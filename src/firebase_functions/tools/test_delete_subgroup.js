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
  const ownerUid = String(args.ownerUid ?? "E2E_OWNER_DELETE_SG");
  const otherUid = String(args.otherUid ?? "E2E_OTHER_DELETE_SG");
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
    data: { name: `Delete SG ${crypto.randomBytes(2).toString("hex")}`, nickname: "Owner" }
  });
  assert(createGroup.ok && !createGroup.json?.error, `createGroup failed: ${createGroup.text}`);
  const out = extractCallableResult(createGroup.json);
  const groupId = out.groupId;
  const inviteCode = out.inviteCode;

  const join = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "joinGroupByCode",
    token: otherToken,
    data: { code: inviteCode, nickname: "Other" }
  });
  assert(join.ok && !join.json?.error, `joinGroupByCode failed: ${join.text}`);

  const now = admin.firestore.FieldValue.serverTimestamp();
  const subgroupEmpty = `sg_empty_${crypto.randomBytes(2).toString("hex")}`;
  const subgroupMember = `sg_member_${crypto.randomBytes(2).toString("hex")}`;
  const subgroupManaged = `sg_managed_${crypto.randomBytes(2).toString("hex")}`;
  const subgroupCompleted = `sg_completed_${crypto.randomBytes(2).toString("hex")}`;
  for (const sg of [subgroupEmpty, subgroupMember, subgroupManaged, subgroupCompleted]) {
    await db.doc(`groups/${groupId}/subgroups/${sg}`).set({
      subgroupId: sg,
      name: sg,
      createdAt: now,
      updatedAt: now
    });
  }

  // member activo asignado
  await db.doc(`groups/${groupId}/members/${otherUid}`).update({
    subgroupId: subgroupMember
  });

  // participant activo asignado
  await db.doc(`groups/${groupId}/participants/p_managed_delete_test`).set({
    participantId: "p_managed_delete_test",
    displayName: "Roy",
    participantType: "managed",
    linkedUid: null,
    managedByUid: ownerUid,
    roleInGroup: "member",
    state: "active",
    subgroupId: subgroupManaged,
    deliveryMode: "verbal",
    canReceiveDirectResult: false,
    source: "test_seed",
    createdAt: now,
    updatedAt: now
  });

  // 1) owner elimina subgrupo vacío
  let res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "deleteSubgroup",
    token: ownerToken,
    data: { groupId, subgroupId: subgroupEmpty }
  });
  assert(res.ok && !res.json?.error, `delete empty subgroup failed: ${res.text}`);
  const emptyExists = await db.doc(`groups/${groupId}/subgroups/${subgroupEmpty}`).get();
  assert(!emptyExists.exists, "subgrupo vacío no fue eliminado");

  // 2) owner no elimina con member activo
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "deleteSubgroup",
    token: ownerToken,
    data: { groupId, subgroupId: subgroupMember }
  });
  assert(!res.ok || res.json?.error, "debía fallar subgroup con member activo");
  assert(extractReasonCode(res.json) === "SUBGROUP_IN_USE", "reasonCode esperado SUBGROUP_IN_USE (member)");

  // 3) owner no elimina con managed activo
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "deleteSubgroup",
    token: ownerToken,
    data: { groupId, subgroupId: subgroupManaged }
  });
  assert(!res.ok || res.json?.error, "debía fallar subgroup con managed activo");
  assert(extractReasonCode(res.json) === "SUBGROUP_IN_USE", "reasonCode esperado SUBGROUP_IN_USE (managed)");

  // 4) no owner no puede eliminar
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "deleteSubgroup",
    token: otherToken,
    data: { groupId, subgroupId: subgroupCompleted }
  });
  assert(!res.ok || res.json?.error, "debía fallar no-owner");
  assert(extractReasonCode(res.json) === "NOT_OWNER", "reasonCode esperado NOT_OWNER");

  // 5) no se puede eliminar en completed
  await db.doc(`groups/${groupId}`).update({
    drawStatus: "completed",
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "deleteSubgroup",
    token: ownerToken,
    data: { groupId, subgroupId: subgroupCompleted }
  });
  assert(!res.ok || res.json?.error, "debía fallar draw completed");
  assert(extractReasonCode(res.json) === "DRAW_LOCKED", "reasonCode esperado DRAW_LOCKED");

  // volver a idle para caso inexistente
  await db.doc(`groups/${groupId}`).update({
    drawStatus: "idle",
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });

  // 6) subgroup inexistente
  res = await invokeCallable({
    base: functionsBase,
    projectId,
    region,
    functionName: "deleteSubgroup",
    token: ownerToken,
    data: { groupId, subgroupId: "sg_not_exists" }
  });
  assert(!res.ok || res.json?.error, "debía fallar subgroup inexistente");
  assert(extractReasonCode(res.json) === "SUBGROUP_NOT_FOUND", "reasonCode esperado SUBGROUP_NOT_FOUND");

  console.log("OK: deleteSubgroup validado.");
}

run().catch((e) => {
  console.error("\nTEST FAILED:");
  console.error(e?.stack || e);
  process.exit(1);
});

