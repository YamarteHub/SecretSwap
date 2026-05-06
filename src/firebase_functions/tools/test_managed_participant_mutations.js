/* eslint-disable no-console */
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
    if (!next || next.startsWith("--")) args[key] = true;
    else {
      args[key] = next;
      i++;
    }
  }
  return args;
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function getHost(envName, fallback) {
  const raw = process.env[envName];
  if (!raw) return fallback;
  if (raw.startsWith("http://") || raw.startsWith("https://")) return raw;
  return `http://${raw}`;
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

function extractCallableResult(json) {
  if (!json) return null;
  if (typeof json.result !== "undefined") return json.result;
  if (typeof json.data !== "undefined") return json.data;
  return null;
}

function extractReasonCode(json) {
  const details = json?.error?.details;
  return details && typeof details === "object" ? details.reasonCode : null;
}

function stablePasswordForUid(uid) {
  return `pw_${crypto.createHash("sha1").update(uid).digest("hex").slice(0, 12)}`;
}

function emailForUid(uid) {
  return `${uid.toLowerCase()}@e2e.local`;
}

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
  const auth = admin.auth();
  try {
    await auth.getUser(uid);
  } catch (e) {
    if (e.code === "auth/user-not-found") {
      await auth.createUser({
        uid,
        email: emailForUid(uid),
        password: stablePasswordForUid(uid),
        emailVerified: true
      });
    } else {
      throw e;
    }
  }
  const customToken = await auth.createCustomToken(uid);
  const signInUrl =
    `${authBaseUrl}/identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${apiKey}`;
  const signIn = await fetchJson(signInUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ token: customToken, returnSecureToken: true })
  });
  if (signIn.ok && signIn.json?.idToken) return signIn.json.idToken;
  throw new Error(`signInWithCustomToken failed: ${signIn.status} ${signIn.text}`);
}

async function invokeCallable({ base, projectId, region, functionName, token, data }) {
  const url = `${base}/${projectId}/${region}/${functionName}`;
  return fetchJson(url, {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
    body: JSON.stringify({ data })
  });
}

function initDb(projectId) {
  if (!process.env.FIRESTORE_EMULATOR_HOST) {
    throw new Error("Define FIRESTORE_EMULATOR_HOST para ejecutar este test.");
  }
  if (admin.apps.length === 0) admin.initializeApp({ projectId });
  return admin.firestore();
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  const projectId = String(args.projectId ?? process.env.GCLOUD_PROJECT ?? "tarciswap-dev");
  const region = String(args.region ?? "us-central1");
  const ownerUid = String(args.ownerUid ?? "E2E_OWNER_MP_MUT");
  const otherUid = String(args.otherUid ?? "E2E_OTHER_MP_MUT");
  const functionsBase = getHost("FUNCTIONS_EMULATOR_URL", "http://127.0.0.1:5001");
  const authBase = getHost("AUTH_EMULATOR_URL", "http://127.0.0.1:9099");
  ensureAuthEmulatorHostFromBaseUrl(authBase);
  const db = initDb(projectId);

  const ownerToken = await ensureIdTokenForUid({ authBaseUrl: authBase, uid: ownerUid });
  const otherToken = await ensureIdTokenForUid({ authBaseUrl: authBase, uid: otherUid });

  const createGroup = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "createGroup",
    token: ownerToken,
    data: { name: `MP MUT ${crypto.randomBytes(2).toString("hex")}`, nickname: "Owner" }
  });
  assert(createGroup.ok && !createGroup.json?.error, `createGroup failed: ${createGroup.text}`);
  const groupId = extractCallableResult(createGroup.json).groupId;

  const subgroupA = `sg_${crypto.randomBytes(2).toString("hex")}`;
  const subgroupB = `sg_${crypto.randomBytes(2).toString("hex")}`;
  const now = admin.firestore.FieldValue.serverTimestamp();
  await db.doc(`groups/${groupId}/subgroups/${subgroupA}`).set({
    subgroupId: subgroupA,
    name: "Casa A",
    createdAt: now,
    updatedAt: now
  });
  await db.doc(`groups/${groupId}/subgroups/${subgroupB}`).set({
    subgroupId: subgroupB,
    name: "Casa B",
    createdAt: now,
    updatedAt: now
  });

  const createManaged = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "createManagedParticipant",
    token: ownerToken,
    data: {
      groupId,
      displayName: "Mami",
      participantType: "managed",
      subgroupId: null,
      deliveryMode: "verbal"
    }
  });
  assert(createManaged.ok && !createManaged.json?.error, `createManagedParticipant failed: ${createManaged.text}`);
  const participantId = extractCallableResult(createManaged.json).participantId;

  const updateFn = "updateManagedParticipant";
  const removeFn = "removeManagedParticipant";

  // update nombre
  let res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: updateFn,
    token: ownerToken,
    data: {
      groupId,
      participantId,
      displayName: "Mami Renombrada",
      participantType: "managed",
      subgroupId: null,
      deliveryMode: "verbal"
    }
  });
  assert(res.ok && !res.json?.error, `update nombre failed: ${res.text}`);

  // update subgrupo + entrega + tipo
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: updateFn,
    token: ownerToken,
    data: {
      groupId,
      participantId,
      displayName: "Mami Renombrada",
      participantType: "child_managed",
      subgroupId: subgroupA,
      deliveryMode: "printed"
    }
  });
  assert(res.ok && !res.json?.error, `update subgroup/type/delivery failed: ${res.text}`);

  const pSnap = await db.doc(`groups/${groupId}/participants/${participantId}`).get();
  const p = pSnap.data();
  assert(p.displayName === "Mami Renombrada", "displayName no persistido");
  assert(p.participantType === "child_managed", "participantType no persistido");
  assert(p.subgroupId === subgroupA, "subgroupId no persistido");
  assert(p.deliveryMode === "printed", "deliveryMode no persistido");

  // reject subgroupId inexistente
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: updateFn,
    token: ownerToken,
    data: {
      groupId,
      participantId,
      displayName: "Mami",
      participantType: "managed",
      subgroupId: "sg_not_found",
      deliveryMode: "verbal"
    }
  });
  assert(!res.ok || res.json?.error, "debía fallar subgroup inexistente");
  assert(extractReasonCode(res.json) === "SUBGROUP_NOT_FOUND", "reasonCode esperado SUBGROUP_NOT_FOUND");

  // reject caller no owner
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: updateFn,
    token: otherToken,
    data: {
      groupId,
      participantId,
      displayName: "Hack",
      participantType: "managed",
      subgroupId: subgroupB,
      deliveryMode: "verbal"
    }
  });
  assert(!res.ok || res.json?.error, "debía fallar no-owner");
  assert(extractReasonCode(res.json) === "NOT_OWNER", "reasonCode esperado NOT_OWNER");

  // reject update con draw completed
  await db.doc(`groups/${groupId}`).update({
    drawStatus: "completed",
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: updateFn,
    token: ownerToken,
    data: {
      groupId,
      participantId,
      displayName: "Blocked",
      participantType: "managed",
      subgroupId: subgroupB,
      deliveryMode: "verbal"
    }
  });
  assert(!res.ok || res.json?.error, "debía fallar draw completed");
  assert(extractReasonCode(res.json) === "DRAW_LOCKED", "reasonCode esperado DRAW_LOCKED");

  // volver a idle y remove
  await db.doc(`groups/${groupId}`).update({
    drawStatus: "idle",
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: removeFn,
    token: ownerToken,
    data: { groupId, participantId }
  });
  assert(res.ok && !res.json?.error, `removeManagedParticipant failed: ${res.text}`);

  const pRemoved = (await db.doc(`groups/${groupId}/participants/${participantId}`).get()).data();
  assert(pRemoved.state === "removed", "state removed no persistido");

  console.log("OK: update/remove managed participant validados.");
}

run().catch((e) => {
  console.error("\nTEST FAILED:");
  console.error(e?.stack || e);
  process.exit(1);
});

