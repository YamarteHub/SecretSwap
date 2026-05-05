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

function assert(cond, msg) {
  if (!cond) throw new Error(msg);
}

function getHost(envName, fallback) {
  const raw = process.env[envName];
  if (!raw) return fallback;
  if (raw.startsWith("http://") || raw.startsWith("https://")) return raw;
  return `http://${raw}`;
}

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

function isNotFoundFn(res) {
  if (res.status === 404) return true;
  const t = res.text || "";
  return t.includes("does not exist") && t.includes("valid functions are");
}

async function invokeCallable({ origin, projectId, region, functionName, token, data }) {
  const base = origin.replace(/\/+$/, "");
  const urls = [
    `${base}/${projectId}/${region}/${functionName}`,
    `${base}/${projectId}/${region}-${functionName}`
  ];
  let last = null;
  for (const url of urls) {
    const res = await fetchJson(url, {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ data })
    });
    last = res;
    if (!isNotFoundFn(res)) return res;
  }
  return last;
}

function extractCallableResult(json) {
  if (!json) return null;
  if (typeof json.result !== "undefined") return json.result;
  if (typeof json.data !== "undefined") return json.data;
  return null;
}

function extractReasonCode(json) {
  const details = json?.error?.details;
  if (details && typeof details === "object" && details.reasonCode) return details.reasonCode;
  return null;
}

function stablePasswordForUid(uid) {
  return `pw_${crypto.createHash("sha1").update(uid).digest("hex").slice(0, 12)}`;
}

function e2eEmailForUid(uid) {
  return `${uid.toLowerCase()}@e2e.local`;
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
        email: e2eEmailForUid(uid),
        password: stablePasswordForUid(uid),
        emailVerified: true
      });
    } else throw e;
  }
  const customToken = await auth.createCustomToken(uid);
  const url = `${authBaseUrl}/identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${apiKey}`;
  const res = await fetchJson(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ token: customToken, returnSecureToken: true })
  });
  if (res.ok && res.json?.idToken) return res.json.idToken;
  throw new Error(`signInWithCustomToken failed: ${res.status} ${res.text}`);
}

function initDb(projectId) {
  if (!process.env.FIRESTORE_EMULATOR_HOST) {
    throw new Error("Define FIRESTORE_EMULATOR_HOST");
  }
  if (admin.apps.length === 0) admin.initializeApp({ projectId });
  return admin.firestore();
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  const projectId = String(args.projectId ?? process.env.GCLOUD_PROJECT ?? "tarciswap-dev");
  const region = String(args.region ?? "us-central1");
  const ownerUid = String(args.ownerUid ?? "E2E_OWNER_D21");
  const appUid1 = String(args.appUid1 ?? "E2E_APP1_D21");
  const appUid2 = String(args.appUid2 ?? "E2E_APP2_D21");

  const origin = getFunctionsEmulatorOrigin();
  const authBaseUrl = getHost("AUTH_EMULATOR_URL", "http://127.0.0.1:9099");
  ensureAuthEmulatorHostFromBaseUrl(authBaseUrl);
  const db = initDb(projectId);

  const ownerToken = await ensureIdTokenForUid({ authBaseUrl, uid: ownerUid });
  const app1Token = await ensureIdTokenForUid({ authBaseUrl, uid: appUid1 });
  const app2Token = await ensureIdTokenForUid({ authBaseUrl, uid: appUid2 });

  const create = await invokeCallable({
    origin,
    projectId,
    region,
    functionName: "createGroup",
    token: ownerToken,
    data: { name: `GMA ${crypto.randomBytes(3).toString("hex")}`, nickname: "Owner" }
  });
  assert(create.ok && !create.json?.error, `createGroup failed: ${create.text}`);
  const created = extractCallableResult(create.json);
  const groupId = created.groupId;
  const inviteCode = created.inviteCode;

  for (const [token, nick] of [
    [app1Token, "App1"],
    [app2Token, "App2"]
  ]) {
    const join = await invokeCallable({
      origin,
      projectId,
      region,
      functionName: "joinGroupByCode",
      token,
      data: { code: inviteCode, nickname: nick }
    });
    assert(join.ok && !join.json?.error, `join failed: ${join.text}`);
  }

  const now = admin.firestore.FieldValue.serverTimestamp();
  await db.doc(`groups/${groupId}/participants/p_roy`).set({
    participantId: "p_roy",
    displayName: "Roy",
    participantType: "child_managed",
    linkedUid: null,
    managedByUid: ownerUid,
    roleInGroup: "member",
    state: "active",
    subgroupId: null,
    deliveryMode: "verbal",
    canReceiveDirectResult: false,
    source: "test_seed",
    createdAt: now,
    updatedAt: now
  });
  await db.doc(`groups/${groupId}/participants/p_mami`).set({
    participantId: "p_mami",
    displayName: "Mami",
    participantType: "managed",
    linkedUid: null,
    managedByUid: null,
    roleInGroup: "member",
    state: "active",
    subgroupId: null,
    deliveryMode: "printed",
    canReceiveDirectResult: false,
    source: "test_seed",
    createdAt: now,
    updatedAt: now
  });
  await db.doc(`groups/${groupId}/participants/p_luis`).set({
    participantId: "p_luis",
    displayName: "Luis",
    participantType: "managed",
    linkedUid: null,
    managedByUid: appUid2,
    roleInGroup: "member",
    state: "active",
    subgroupId: null,
    deliveryMode: "verbal",
    canReceiveDirectResult: false,
    source: "test_seed",
    createdAt: now,
    updatedAt: now
  });

  const draw = await invokeCallable({
    origin,
    projectId,
    region,
    functionName: "executeDraw",
    token: ownerToken,
    data: { groupId, idempotencyKey: `draw-${crypto.randomUUID()}` }
  });
  assert(draw.ok && !draw.json?.error, `executeDraw failed: ${draw.text}`);
  const executionId = extractCallableResult(draw.json)?.executionId;
  assert(executionId, "executionId missing");

  // 1 + 2 + 4: owner ve roy/mami, no app_member y fallback owner funciona
  const ownerManaged = await invokeCallable({
    origin,
    projectId,
    region,
    functionName: "getManagedAssignments",
    token: ownerToken,
    data: { groupId, executionId }
  });
  assert(ownerManaged.ok && !ownerManaged.json?.error, `owner getManaged failed: ${ownerManaged.text}`);
  const ownerAssignments = extractCallableResult(ownerManaged.json)?.assignments ?? [];
  const ownerGivers = new Set(ownerAssignments.map((a) => a.giverParticipantId));
  assert(ownerGivers.has("p_roy"), "owner debe ver Roy (managedByUid)");
  assert(ownerGivers.has("p_mami"), "owner debe ver Mami (fallback owner)");
  assert(!ownerGivers.has(ownerUid) && !ownerGivers.has(appUid1), "owner no debe ver app_members");
  assert(!ownerGivers.has("p_luis"), "owner no debe ver gestionados de otro responsable");

  // 3: otro usuario no ve gestionadas por owner (solo las suyas)
  const app2Managed = await invokeCallable({
    origin,
    projectId,
    region,
    functionName: "getManagedAssignments",
    token: app2Token,
    data: { groupId, executionId }
  });
  assert(app2Managed.ok && !app2Managed.json?.error, `app2 getManaged failed: ${app2Managed.text}`);
  const app2Assignments = extractCallableResult(app2Managed.json)?.assignments ?? [];
  const app2Givers = new Set(app2Assignments.map((a) => a.giverParticipantId));
  assert(!app2Givers.has("p_roy") && !app2Givers.has("p_mami"), "otro usuario no debe ver gestionadas por owner");

  // 5: grupo no completed => falla
  const create2 = await invokeCallable({
    origin,
    projectId,
    region,
    functionName: "createGroup",
    token: ownerToken,
    data: { name: `GMA2 ${crypto.randomBytes(3).toString("hex")}`, nickname: "Owner2" }
  });
  assert(create2.ok && !create2.json?.error, "createGroup 2 failed");
  const g2 = extractCallableResult(create2.json)?.groupId;
  const badState = await invokeCallable({
    origin,
    projectId,
    region,
    functionName: "getManagedAssignments",
    token: ownerToken,
    data: { groupId: g2, executionId: "any" }
  });
  assert(!badState.ok || badState.json?.error, "debe fallar si draw no completed");
  assert(extractReasonCode(badState.json) === "EXECUTION_NOT_FOUND" || extractReasonCode(badState.json) === "DRAW_NOT_COMPLETED",
    "reasonCode esperado EXECUTION_NOT_FOUND o DRAW_NOT_COMPLETED");

  // 6: execution inexistente => falla claro
  const badExec = await invokeCallable({
    origin,
    projectId,
    region,
    functionName: "getManagedAssignments",
    token: ownerToken,
    data: { groupId, executionId: "exec_not_exists" }
  });
  assert(!badExec.ok || badExec.json?.error, "debe fallar por execution inexistente");
  assert(extractReasonCode(badExec.json) === "EXECUTION_NOT_FOUND", "reasonCode esperado EXECUTION_NOT_FOUND");

  console.log("OK: getManagedAssignments validado.");
}

run().catch((e) => {
  console.error("\nTEST FAILED:");
  console.error(e?.stack || e);
  process.exit(1);
});

