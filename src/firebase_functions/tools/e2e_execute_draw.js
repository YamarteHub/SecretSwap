/* eslint-disable no-console */
/**
 * E2E (emulador): createGroup -> joinGroupByCode (×3) -> executeDraw -> verificar Firestore -> idempotencia
 * + escenario imposible (requireDifferent con 2 miembros mismo subgrupo).
 *
 * Requiere:
 * - FIRESTORE_EMULATOR_HOST (ej: 127.0.0.1:8080)
 * - Auth emulator (default: http://127.0.0.1:9099). Opcional: FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099
 * - Functions emulator: FUNCTIONS_EMULATOR_URL = solo origen http://127.0.0.1:5001 (sin path /projectId)
 * - `npm run build` (Functions compiladas a lib/)
 *
 * Tokens: el emulador rechaza `localId` en REST signUp; se usa Admin SDK (createUser con uid)
 * + signInWithCustomToken para obtener idToken con el mismo uid que --ownerUid / --memberUidN.
 *
 * Ejemplo (PowerShell):
 *   $env:FIRESTORE_EMULATOR_HOST="127.0.0.1:8080"
 *   cd src/firebase_functions
 *   npm run test:e2e:execute-draw -- --ownerUid E2E_OWNER --memberUid1 E2E_M1 --memberUid2 E2E_M2 --memberUid3 E2E_M3 --projectId secretswap-dev
 */

const crypto = require("node:crypto");
const admin = require("firebase-admin");

function parseArgs(argv) {
  const args = { _: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (!a.startsWith("--")) {
      args._.push(a);
      continue;
    }
    const key = a.slice(2);
    const next = argv[i + 1];
    if (!next || next.startsWith("--")) {
      args[key] = true;
    } else {
      args[key] = next;
      i++;
    }
  }
  return args;
}

function requireString(value, name) {
  if (!value || typeof value !== "string") {
    throw new Error(`Missing --${name}`);
  }
  return value;
}

function getHost(envName, fallback) {
  const raw = process.env[envName];
  if (!raw) return fallback;
  if (raw.startsWith("http://") || raw.startsWith("https://")) return raw;
  return `http://${raw}`;
}

/**
 * Origen del emulador de Functions: solo protocolo + host + puerto (sin /projectId ni rutas).
 * Si FUNCTIONS_EMULATOR_URL incluye path extra, se ignora para evitar URLs del tipo
 * .../secretswap-dev/secretswap-dev/us-central1/createGroup (404 o nombre mal resuelto).
 */
function getFunctionsEmulatorOrigin() {
  const raw = getHost("FUNCTIONS_EMULATOR_URL", "http://127.0.0.1:5001");
  try {
    const u = new URL(raw);
    const port = u.port || (u.protocol === "https:" ? "443" : "80");
    return `${u.protocol}//${u.hostname}:${port}`;
  } catch {
    return String(raw).replace(/\/+$/, "");
  }
}

function isEmulatorFunctionNotFoundResponse(res) {
  if (res.status === 404) return true;
  const text = res.text || "";
  if (text.includes("does not exist") && text.includes("valid functions are")) return true;
  const e = res.json?.error;
  if (!e) return false;
  const st = String(e.status ?? "").toUpperCase();
  if (st === "NOT_FOUND" || st === "NOT FOUND") return true;
  const msg = String(e.message ?? "");
  if (msg.includes("NOT_FOUND") || msg.includes("not-found")) return true;
  if (msg.includes("does not exist") && msg.includes("valid functions are")) return true;
  return false;
}

/**
 * Callables en el emulador (v1 y v2): el trigger v2 a veces se resuelve como `/{region}-{functionName}`.
 * Probamos en orden:
 *   1) /{projectId}/{region}/{functionName}  (documentación clásica)
 *   2) /{projectId}/{region}-{functionName}   (id de trigger Gen 2)
 */
async function invokeCallableEmulator({ origin, projectId, region, functionName, token, data }) {
  const base = origin.replace(/\/+$/, "");
  const candidates = [
    `${base}/${projectId}/${region}/${functionName}`,
    `${base}/${projectId}/${region}-${functionName}`
  ];

  let last = null;
  for (let i = 0; i < candidates.length; i++) {
    const url = candidates[i];
    console.log(`[callable:${functionName}] POST ${url}`);
    const res = await fetchJson(url, {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ data })
    });
    last = res;
    if (!isEmulatorFunctionNotFoundResponse(res)) {
      return res;
    }
    if (i < candidates.length - 1) {
      console.warn(
        `[callable:${functionName}] ruta no reconocida por el emulador (HTTP ${res.status}), probando alternativa...`
      );
    }
  }

  console.error(`[callable:${functionName}] Todos los intentos fallaron. Última respuesta completa:`);
  console.error(last?.text ?? "(sin cuerpo)");
  return last;
}

async function fetchJson(url, opts) {
  const res = await fetch(url, opts);
  const text = await res.text();
  let json = null;
  try {
    json = text ? JSON.parse(text) : null;
  } catch {
    json = null;
  }
  return { ok: res.ok, status: res.status, json, text };
}

/** Email estable por UID (solo E2E / emulador). */
function e2eEmailForUid(uid) {
  return `${uid.toLowerCase()}@e2e.local`;
}

/** Password derivada del UID (evita colisiones si reutilizas el mismo emulador). */
function stablePasswordForUid(uid) {
  return `pw_${crypto.createHash("sha1").update(uid).digest("hex").slice(0, 12)}`;
}

/**
 * El REST `accounts:signUp` del emulador no acepta `localId` → UNEXPECTED_PARAMETER : User ID.
 * Garantiza `request.auth.uid === uid` con Admin SDK + custom token.
 */
function ensureAuthEmulatorHostFromBaseUrl(authBaseUrl) {
  if (process.env.FIREBASE_AUTH_EMULATOR_HOST) return;
  try {
    const u = new URL(authBaseUrl);
    const port = u.port || (u.protocol === "https:" ? "443" : "80");
    process.env.FIREBASE_AUTH_EMULATOR_HOST = `${u.hostname}:${port}`;
  } catch {
    process.env.FIREBASE_AUTH_EMULATOR_HOST = "127.0.0.1:9099";
  }
}

async function ensureIdTokenForUid({ authBaseUrl, uid }) {
  const apiKey = "fake-api-key";
  const email = e2eEmailForUid(uid);
  const password = stablePasswordForUid(uid);

  const auth = admin.auth();
  try {
    await auth.getUser(uid);
  } catch (e) {
    if (e.code === "auth/user-not-found") {
      await auth.createUser({
        uid,
        email,
        password,
        emailVerified: true
      });
    } else {
      throw e;
    }
  }

  const customToken = await auth.createCustomToken(uid);
  const url = `${authBaseUrl}/identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${apiKey}`;
  const res = await fetchJson(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ token: customToken, returnSecureToken: true })
  });

  if (res.ok && res.json?.idToken) {
    return res.json.idToken;
  }
  throw new Error(`signInWithCustomToken failed: ${res.status} ${res.text}`);
}

function extractCallableResult(json) {
  if (!json) return null;
  if (typeof json.result !== "undefined") return json.result;
  if (typeof json.data !== "undefined") return json.data;
  return null;
}

function extractCallableErrorDetails(json) {
  const err = json?.error;
  if (!err) return null;
  let details = err.details;
  if (typeof details === "string") {
    try {
      details = JSON.parse(details);
    } catch {
      return { raw: details, message: err.message };
    }
  }
  if (details && typeof details === "object") {
    if (details.reasonCode) return details;
    if (details.details && details.details.reasonCode) return details.details;
  }
  return { message: err.message, details };
}

function initFirebase(projectId) {
  const emulatorHost = process.env.FIRESTORE_EMULATOR_HOST;
  if (!emulatorHost) {
    throw new Error("FIRESTORE_EMULATOR_HOST no está definido (ej: 127.0.0.1:8080).");
  }
  if (admin.apps.length === 0) {
    admin.initializeApp({ projectId });
  }
  return admin.firestore();
}

async function callCreateGroup(origin, projectId, region, token, body) {
  return invokeCallableEmulator({
    origin,
    projectId,
    region,
    functionName: "createGroup",
    token,
    data: body
  });
}

async function callJoin(origin, projectId, region, token, body) {
  return invokeCallableEmulator({
    origin,
    projectId,
    region,
    functionName: "joinGroupByCode",
    token,
    data: body
  });
}

async function callExecuteDraw(origin, projectId, region, token, body) {
  return invokeCallableEmulator({
    origin,
    projectId,
    region,
    functionName: "executeDraw",
    token,
    data: body
  });
}

function assert(cond, msg) {
  if (!cond) throw new Error(msg);
}

async function verifyHappyPathDraw(db, groupId, executionId, nMembers) {
  const groupRef = db.doc(`groups/${groupId}`);
  const groupSnap = await groupRef.get();
  assert(groupSnap.exists, `missing group ${groupId}`);
  const g = groupSnap.data();

  assert(g.drawStatus === "completed", `drawStatus expected completed, got ${g.drawStatus}`);
  assert(g.currentExecutionId === executionId, `currentExecutionId mismatch: ${g.currentExecutionId} vs ${executionId}`);
  assert(g.lastExecutionId === executionId, `lastExecutionId mismatch`);
  assert(g.drawingLock == null, `drawingLock should be null/undefined, got ${JSON.stringify(g.drawingLock)}`);

  const execSnap = await db.doc(`groups/${groupId}/executions/${executionId}`).get();
  assert(execSnap.exists, `missing execution ${executionId}`);
  const ex = execSnap.data();
  assert(ex.status === "success", `execution.status expected success, got ${ex.status}`);

  const assignCol = db.collection(`groups/${groupId}/executions/${executionId}/assignments`);
  const assignSnap = await assignCol.get();
  assert(assignSnap.size === nMembers, `assignments count expected ${nMembers}, got ${assignSnap.size}`);

  const giverIds = [];
  const receiverIds = [];
  for (const d of assignSnap.docs) {
    const row = d.data();
    giverIds.push(row.giverUid);
    receiverIds.push(row.receiverUid);
    assert(row.giverUid !== row.receiverUid, `self-assignment for ${row.giverUid}`);
  }

  assert(new Set(giverIds).size === nMembers, "each giverUid must appear once");
  assert(new Set(receiverIds).size === nMembers, "each receiverUid must appear once");

  const execAll = await db.collection(`groups/${groupId}/executions`).get();
  assert(execAll.size === 1, `expected 1 execution doc for happy path, got ${execAll.size}`);
}

async function verifyImpossibleDraw(db, groupId, executionId) {
  const g = (await db.doc(`groups/${groupId}`).get()).data();
  assert(g.drawStatus === "failed", `drawStatus expected failed, got ${g.drawStatus}`);
  assert(g.drawingLock == null, "drawingLock should be cleared after failed draw");

  const ex = (await db.doc(`groups/${groupId}/executions/${executionId}`).get()).data();
  assert(ex.status === "failed", `execution.status expected failed, got ${ex.status}`);
  const reason = ex.failure?.reasonCode ?? ex.errorCode;
  assert(
    reason === "NO_PERFECT_MATCHING",
    `expected NO_PERFECT_MATCHING, got ${reason}`
  );

  const assignSnap = await db
    .collection(`groups/${groupId}/executions/${executionId}/assignments`)
    .get();
  assert(assignSnap.size === 0, `impossible draw should have 0 assignments, got ${assignSnap.size}`);
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(
      "Usage: node tools/e2e_execute_draw.js \\\n" +
        "  --ownerUid E2E_OWNER --memberUid1 E2E_M1 --memberUid2 E2E_M2 --memberUid3 E2E_M3 \\\n" +
        "  [--projectId secretswap-dev] [--region us-central1] [--skipImpossible]\n" +
        "\n" +
        "FUNCTIONS_EMULATOR_URL: solo origen, ej. http://127.0.0.1:5001 (sin /projectId).\n" +
        "Debe coincidir el --projectId con el proyecto del emulador (p. ej. .firebaserc default).\n" +
        "\n" +
        "Nota: el escenario imposible muta `rules/1` y miembros vía Admin SDK (solo emulador / prueba)."
    );
    process.exit(0);
  }

  const projectId = String(args.projectId ?? process.env.GCLOUD_PROJECT ?? "secretswap-dev");
  const region = String(args.region ?? "us-central1");
  const skipImpossible = Boolean(args.skipImpossible);

  const ownerUid = requireString(args.ownerUid, "ownerUid");
  const memberUid1 = requireString(args.memberUid1, "memberUid1");
  const memberUid2 = requireString(args.memberUid2, "memberUid2");
  const memberUid3 = requireString(args.memberUid3, "memberUid3");

  const functionsOrigin = getFunctionsEmulatorOrigin();
  const authBaseUrl = getHost("AUTH_EMULATOR_URL", "http://127.0.0.1:9099");

  console.log(
    `Emulador Functions: origin=${functionsOrigin} projectId=${projectId} region=${region} (exportados: createGroup, joinGroupByCode, executeDraw)`
  );

  ensureAuthEmulatorHostFromBaseUrl(authBaseUrl);
  const db = initFirebase(projectId);

  const ownerToken = await ensureIdTokenForUid({ authBaseUrl, uid: ownerUid });
  const t1 = await ensureIdTokenForUid({ authBaseUrl, uid: memberUid1 });
  const t2 = await ensureIdTokenForUid({ authBaseUrl, uid: memberUid2 });
  const t3 = await ensureIdTokenForUid({ authBaseUrl, uid: memberUid3 });

  const groupName = `E2E Draw ${crypto.randomBytes(3).toString("hex")}`;
  const idempotencyKey = `e2e-happy-${crypto.randomUUID()}`;

  console.log("=== PART 1: createGroup ===");
  const createRes = await callCreateGroup(functionsOrigin, projectId, region, ownerToken, {
    name: groupName,
    nickname: "OwnerNick"
  });
  console.log(`HTTP ${createRes.status}`);
  if (!createRes.ok || createRes.json?.error) {
    console.error(createRes.text);
    throw new Error("createGroup failed");
  }
  const created = extractCallableResult(createRes.json);
  const groupId = created?.groupId;
  const inviteCode = created?.inviteCode;
  assert(groupId && inviteCode, "missing groupId/inviteCode");

  console.log("=== PART 2: joinGroupByCode ×3 ===");
  const members = [
    { uid: memberUid1, token: t1, nick: "M1" },
    { uid: memberUid2, token: t2, nick: "M2" },
    { uid: memberUid3, token: t3, nick: "M3" }
  ];
  for (const m of members) {
    const jr = await callJoin(functionsOrigin, projectId, region, m.token, {
      code: inviteCode,
      nickname: m.nick
    });
    if (!jr.ok || jr.json?.error) {
      console.error(jr.text);
      throw new Error(`joinGroupByCode failed for ${m.uid}`);
    }
    const j = extractCallableResult(jr.json);
    assert(j?.groupId === groupId, "join groupId mismatch");
  }

  const nTotal = 4;

  console.log("=== PART 3: executeDraw ===");
  const drawRes = await callExecuteDraw(functionsOrigin, projectId, region, ownerToken, {
    groupId,
    idempotencyKey
  });
  console.log(`HTTP ${drawRes.status}`);
  if (!drawRes.ok || drawRes.json?.error) {
    console.error(drawRes.text);
    throw new Error("executeDraw failed");
  }
  const drawOut = extractCallableResult(drawRes.json);
  const executionId = drawOut?.executionId;
  assert(executionId, "missing executionId");
  assert(drawOut?.status === "success", `expected status success, got ${drawOut?.status}`);
  assert(drawOut?.summary?.participantCount === nTotal, "summary.participantCount mismatch");

  console.log("=== PART 4: verify Firestore (happy) ===");
  await verifyHappyPathDraw(db, groupId, executionId, nTotal);

  console.log("=== PART 5: idempotencia executeDraw ===");
  const draw2 = await callExecuteDraw(functionsOrigin, projectId, region, ownerToken, {
    groupId,
    idempotencyKey
  });
  if (!draw2.ok || draw2.json?.error) {
    console.error(draw2.text);
    throw new Error("second executeDraw should succeed (idempotent)");
  }
  const out2 = extractCallableResult(draw2.json);
  assert(out2?.executionId === executionId, "idempotent retry must return same executionId");
  const execAllAfter = await db.collection(`groups/${groupId}/executions`).get();
  assert(execAllAfter.size === 1, "idempotent retry must not create second execution");
  const assignAfter = await db
    .collection(`groups/${groupId}/executions/${executionId}/assignments`)
    .get();
  assert(assignAfter.size === nTotal, "idempotent retry must not duplicate assignments");

  console.log("OK: flujo feliz + idempotencia.");

  if (skipImpossible) {
    console.log("(skipImpossible) Escenario imposible omitido.");
    return;
  }

  console.log("\n=== PART 6: escenario imposible (requireDifferent + mismo subgrupo) ===");
  const impGroupName = `E2E Impossible ${crypto.randomBytes(3).toString("hex")}`;
  const impKey = `e2e-imp-${crypto.randomUUID()}`;

  const cr2 = await callCreateGroup(functionsOrigin, projectId, region, ownerToken, {
    name: impGroupName,
    nickname: "ImpOwner"
  });
  if (!cr2.ok || cr2.json?.error) {
    console.error(cr2.text);
    throw new Error("createGroup (impossible scenario) failed");
  }
  const c2 = extractCallableResult(cr2.json);
  const g2 = c2?.groupId;
  const code2 = c2?.inviteCode;
  assert(g2 && code2, "missing second group");

  const jrImp = await callJoin(functionsOrigin, projectId, region, t1, {
    code: code2,
    nickname: "ImpMember"
  });
  if (!jrImp.ok || jrImp.json?.error) {
    console.error(jrImp.text);
    throw new Error("join (impossible scenario) failed");
  }

  const rulesRef = db.doc(`groups/${g2}/rules/1`);
  const ownerMemRef = db.doc(`groups/${g2}/members/${ownerUid}`);
  const memRef = db.doc(`groups/${g2}/members/${memberUid1}`);
  const now = admin.firestore.FieldValue.serverTimestamp();
  await db.runTransaction(async (tx) => {
    const [rSnap, oSnap, mSnap] = await Promise.all([
      tx.get(rulesRef),
      tx.get(ownerMemRef),
      tx.get(memRef)
    ]);
    assert(rSnap.exists, "rules/1 missing");
    assert(oSnap.exists, "owner member missing");
    assert(mSnap.exists, "joined member missing");
    tx.update(rulesRef, { subgroupMode: "requireDifferent" });
    tx.update(ownerMemRef, { subgroupId: "same-house", updatedAt: now });
    tx.update(memRef, { subgroupId: "same-house", updatedAt: now });
  });

  console.log("Llamando executeDraw (debe fallar con NO_PERFECT_MATCHING)...");
  const badDraw = await callExecuteDraw(functionsOrigin, projectId, region, ownerToken, {
    groupId: g2,
    idempotencyKey: impKey
  });

  if (badDraw.ok && !badDraw.json?.error) {
    throw new Error("executeDraw should fail for impossible matching (expected error payload)");
  }
  const details = extractCallableErrorDetails(badDraw.json);
  const reasonCode =
    details?.reasonCode ??
    details?.reason_code ??
    (typeof badDraw.json?.error?.message === "string" &&
    badDraw.json.error.message.includes("NO_PERFECT_MATCHING")
      ? "NO_PERFECT_MATCHING"
      : null);
  assert(
    reasonCode === "NO_PERFECT_MATCHING",
    `expected reasonCode NO_PERFECT_MATCHING, got details=${JSON.stringify(details)} body=${badDraw.text?.slice(0, 500)}`
  );

  const execsImp = await db.collection(`groups/${g2}/executions`).get();
  assert(execsImp.size === 1, "impossible scenario should create exactly one execution doc");
  const impExecId = execsImp.docs[0].id;

  await verifyImpossibleDraw(db, g2, impExecId);
  console.log("OK: escenario imposible verificado.");
}

run().catch((e) => {
  console.error("\nE2E FAILED:");
  console.error(e?.stack || e);
  process.exit(1);
});
