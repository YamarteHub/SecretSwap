/* eslint-disable no-console */
/**
 * E2E local (emulador): valida executeDraw con fuente unificada members + participants.
 *
 * Casos:
 * 1) regresión solo members
 * 2) mixto app + managed + child_managed
 * 3) requireDifferent válido
 * 4) requireDifferent imposible
 * 5) preferDifferent (no bloquea)
 * 6) compatibilidad doc assignment por uid para app user
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

function isEmulatorFunctionNotFoundResponse(res) {
  if (res.status === 404) return true;
  const text = res.text || "";
  if (text.includes("does not exist") && text.includes("valid functions are")) return true;
  const e = res.json?.error;
  if (!e) return false;
  const st = String(e.status ?? "").toUpperCase();
  return st === "NOT_FOUND" || st === "NOT FOUND";
}

async function invokeCallableEmulator({ origin, projectId, region, functionName, token, data }) {
  const base = origin.replace(/\/+$/, "");
  const candidates = [
    `${base}/${projectId}/${region}/${functionName}`,
    `${base}/${projectId}/${region}-${functionName}`
  ];
  let last = null;
  for (let i = 0; i < candidates.length; i++) {
    const url = candidates[i];
    const res = await fetchJson(url, {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ data })
    });
    last = res;
    if (!isEmulatorFunctionNotFoundResponse(res)) return res;
  }
  return last;
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
  if (res.ok && res.json?.idToken) return res.json.idToken;
  throw new Error(`signInWithCustomToken failed: ${res.status} ${res.text}`);
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
  const msg = String(json?.error?.message ?? "");
  if (msg.includes("NO_PERFECT_MATCHING")) return "NO_PERFECT_MATCHING";
  return null;
}

function assert(cond, msg) {
  if (!cond) throw new Error(msg);
}

function assertNonEmptyString(value, label) {
  assert(typeof value === "string" && value.trim() !== "", `Test setup invalid: ${label} missing`);
  return value.trim();
}

function initFirestore(projectId) {
  if (!process.env.FIRESTORE_EMULATOR_HOST) {
    throw new Error("Define FIRESTORE_EMULATOR_HOST para ejecutar en emulador.");
  }
  if (admin.apps.length === 0) {
    admin.initializeApp({ projectId });
  }
  return admin.firestore();
}

async function callCreateGroup(ctx, token, name, nickname) {
  const res = await invokeCallableEmulator({
    ...ctx,
    functionName: "createGroup",
    token,
    data: { name, nickname }
  });
  if (!res.ok || res.json?.error) {
    throw new Error(`createGroup failed: ${res.text}`);
  }
  return extractCallableResult(res.json);
}

async function callJoin(ctx, token, code, nickname) {
  const res = await invokeCallableEmulator({
    ...ctx,
    functionName: "joinGroupByCode",
    token,
    data: { code, nickname }
  });
  if (!res.ok || res.json?.error) {
    throw new Error(`joinGroupByCode failed: ${res.text}`);
  }
  return extractCallableResult(res.json);
}

async function callExecuteDraw(ctx, token, groupId, idempotencyKey) {
  return invokeCallableEmulator({
    ...ctx,
    functionName: "executeDraw",
    token,
    data: { groupId, idempotencyKey }
  });
}

async function setMemberSubgroup(db, groupId, uid, subgroupId) {
  await db.doc(`groups/${groupId}/members/${uid}`).set(
    {
      subgroupId,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    },
    { merge: true }
  );
}

async function upsertParticipant(db, groupId, participantId, data) {
  await db.doc(`groups/${groupId}/participants/${participantId}`).set(
    {
      participantId,
      state: "active",
      source: "test_seed",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      ...data
    },
    { merge: true }
  );
}

async function setRuleSubgroupMode(db, groupId, mode) {
  await db.doc(`groups/${groupId}/rules/1`).set(
    {
      subgroupMode: mode,
      exclusions: []
    },
    { merge: true }
  );
}

async function assertAssignmentsCount(db, groupId, executionId, expected) {
  const snap = await db.collection(`groups/${groupId}/executions/${executionId}/assignments`).get();
  assert(snap.size === expected, `assignments esperados=${expected}, recibidos=${snap.size}`);
  return snap;
}

async function caseLegacyOnlyMembers(ctx, db, ownerToken, member1Token, member2Token, ownerUid, member1Uid, member2Uid) {
  assertNonEmptyString(ownerUid, "ownerUid");
  assertNonEmptyString(member1Uid, "appUid1");
  assertNonEmptyString(member2Uid, "appUid2");
  const created = await callCreateGroup(ctx, ownerToken, `C21 legacy ${crypto.randomBytes(3).toString("hex")}`, "Owner");
  assertNonEmptyString(created?.groupId, "groupId");
  assertNonEmptyString(created?.inviteCode, "inviteCode");
  await callJoin(ctx, member1Token, created.inviteCode, "M1");
  await callJoin(ctx, member2Token, created.inviteCode, "M2");
  const res = await callExecuteDraw(ctx, ownerToken, created.groupId, `legacy-${crypto.randomUUID()}`);
  assert(res.ok && !res.json?.error, `legacy executeDraw failed: ${res.text}`);
  const out = extractCallableResult(res.json);
  await assertAssignmentsCount(db, created.groupId, out.executionId, 3);
  for (const uid of [ownerUid, member1Uid, member2Uid]) {
    const doc = await db.doc(`groups/${created.groupId}/executions/${out.executionId}/assignments/${uid}`).get();
    assert(doc.exists, `legacy assignment por uid faltante: ${uid}`);
  }
  console.log("OK 1/6 regresión solo members");
}

async function caseMixedAndUidCompatibility(ctx, db, ownerToken, appUserToken, ownerUid, appUserUid) {
  assertNonEmptyString(ownerUid, "ownerUid");
  assertNonEmptyString(appUserUid, "appUid1");
  const created = await callCreateGroup(ctx, ownerToken, `C21 mixto ${crypto.randomBytes(3).toString("hex")}`, "Owner");
  assertNonEmptyString(created?.groupId, "groupId");
  assertNonEmptyString(created?.inviteCode, "inviteCode");
  await callJoin(ctx, appUserToken, created.inviteCode, "YoApp");
  assertNonEmptyString("p_mami", "participantId p_mami");
  assertNonEmptyString("p_roy", "participantId p_roy");
  await upsertParticipant(db, created.groupId, "p_mami", {
    displayName: "Mami",
    participantType: "managed",
    linkedUid: null,
    managedByUid: ownerUid,
    roleInGroup: "member",
    subgroupId: null,
    deliveryMode: "verbal",
    canReceiveDirectResult: false
  });
  await upsertParticipant(db, created.groupId, "p_roy", {
    displayName: "Roy",
    participantType: "child_managed",
    linkedUid: null,
    managedByUid: ownerUid,
    roleInGroup: "member",
    subgroupId: null,
    deliveryMode: "printed",
    canReceiveDirectResult: false
  });
  const res = await callExecuteDraw(ctx, ownerToken, created.groupId, `mixed-${crypto.randomUUID()}`);
  assert(res.ok && !res.json?.error, `mixed executeDraw failed: ${res.text}`);
  const out = extractCallableResult(res.json);
  const snap = await assertAssignmentsCount(db, created.groupId, out.executionId, 4);
  const appDoc = await db
    .doc(`groups/${created.groupId}/executions/${out.executionId}/assignments/${appUserUid}`)
    .get();
  assert(appDoc.exists, `assignment por uid faltante para app user: ${appUserUid}`);
  const managedDoc = snap.docs.find((d) => d.id === "p_mami");
  assert(Boolean(managedDoc), "assignment por participantId faltante para managed");
  console.log("OK 2/6 mixto app+managed+child y 6/6 compatibilidad uid app");
}

async function caseRequireDifferentValid(ctx, db, ownerToken, appUserToken, ownerUid, appUserUid) {
  assertNonEmptyString(ownerUid, "ownerUid");
  assertNonEmptyString(appUserUid, "appUid1");
  const created = await callCreateGroup(ctx, ownerToken, `C21 reqdiff ok ${crypto.randomBytes(3).toString("hex")}`, "Owner");
  assertNonEmptyString(created?.groupId, "groupId");
  assertNonEmptyString(created?.inviteCode, "inviteCode");
  await callJoin(ctx, appUserToken, created.inviteCode, "AppA");
  const subgroupOwner = "sg_a";
  const subgroupAppUser = "sg_b";
  const subgroupChild = "sg_c";
  assertNonEmptyString(subgroupOwner, "subgroupId owner");
  assertNonEmptyString(subgroupAppUser, "subgroupId appUid1");
  assertNonEmptyString(subgroupChild, "subgroupId child");
  await setRuleSubgroupMode(db, created.groupId, "requireDifferent");
  await setMemberSubgroup(db, created.groupId, ownerUid, subgroupOwner);
  await setMemberSubgroup(db, created.groupId, appUserUid, subgroupAppUser);
  assertNonEmptyString("p_child_req_ok", "participantId p_child_req_ok");
  await upsertParticipant(db, created.groupId, "p_child_req_ok", {
    displayName: "Child",
    participantType: "child_managed",
    linkedUid: null,
    managedByUid: ownerUid,
    roleInGroup: "member",
    subgroupId: subgroupChild,
    deliveryMode: "ownerDelegated",
    canReceiveDirectResult: false
  });
  const res = await callExecuteDraw(ctx, ownerToken, created.groupId, `req-ok-${crypto.randomUUID()}`);
  assert(res.ok && !res.json?.error, `requireDifferent válido falló: ${res.text}`);
  console.log("OK 3/6 requireDifferent válido");
}

async function caseRequireDifferentImpossible(ctx, db, ownerToken, appUserToken, ownerUid, appUserUid) {
  assertNonEmptyString(ownerUid, "ownerUid");
  assertNonEmptyString(appUserUid, "appUid1");
  const created = await callCreateGroup(ctx, ownerToken, `C21 reqdiff bad ${crypto.randomBytes(3).toString("hex")}`, "Owner");
  assertNonEmptyString(created?.groupId, "groupId");
  assertNonEmptyString(created?.inviteCode, "inviteCode");
  await callJoin(ctx, appUserToken, created.inviteCode, "AppB");
  const subgroupShared = "same_house";
  assertNonEmptyString(subgroupShared, "subgroupId shared");
  await setRuleSubgroupMode(db, created.groupId, "requireDifferent");
  await setMemberSubgroup(db, created.groupId, ownerUid, subgroupShared);
  await setMemberSubgroup(db, created.groupId, appUserUid, subgroupShared);
  const res = await callExecuteDraw(ctx, ownerToken, created.groupId, `req-bad-${crypto.randomUUID()}`);
  assert(!res.ok || res.json?.error, "requireDifferent imposible debió fallar");
  const reasonCode = extractReasonCode(res.json);
  assert(reasonCode === "NO_PERFECT_MATCHING", `reasonCode esperado NO_PERFECT_MATCHING, recibido=${reasonCode}`);
  console.log("OK 4/6 requireDifferent imposible");
}

async function casePreferDifferent(ctx, db, ownerToken, appUserToken, ownerUid, appUserUid) {
  assertNonEmptyString(ownerUid, "ownerUid");
  assertNonEmptyString(appUserUid, "appUid2");
  const created = await callCreateGroup(ctx, ownerToken, `C21 prefer ${crypto.randomBytes(3).toString("hex")}`, "Owner");
  assertNonEmptyString(created?.groupId, "groupId");
  assertNonEmptyString(created?.inviteCode, "inviteCode");
  await callJoin(ctx, appUserToken, created.inviteCode, "AppC");
  const subgroupShared = "same_house";
  assertNonEmptyString(subgroupShared, "subgroupId shared");
  await setRuleSubgroupMode(db, created.groupId, "preferDifferent");
  await setMemberSubgroup(db, created.groupId, ownerUid, subgroupShared);
  await setMemberSubgroup(db, created.groupId, appUserUid, subgroupShared);
  assertNonEmptyString("p_prefer_1", "participantId p_prefer_1");
  await upsertParticipant(db, created.groupId, "p_prefer_1", {
    displayName: "Prefer1",
    participantType: "managed",
    linkedUid: null,
    managedByUid: ownerUid,
    roleInGroup: "member",
    subgroupId: "same_house",
    deliveryMode: "verbal",
    canReceiveDirectResult: false
  });
  const res = await callExecuteDraw(ctx, ownerToken, created.groupId, `prefer-${crypto.randomUUID()}`);
  assert(res.ok && !res.json?.error, `preferDifferent no debe bloquear: ${res.text}`);
  console.log("OK 5/6 preferDifferent");
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  const projectId = String(args.projectId ?? process.env.GCLOUD_PROJECT ?? "tarciswap-dev");
  const region = String(args.region ?? "us-central1");

  const ownerUid = assertNonEmptyString(String(args.ownerUid ?? "E2E_OWNER_C21"), "ownerUid");
  const appUid1 = assertNonEmptyString(String(args.appUid1 ?? "E2E_APP1_C21"), "appUid1");
  const appUid2 = assertNonEmptyString(String(args.appUid2 ?? "E2E_APP2_C21"), "appUid2");

  const authBaseUrl = getHost("AUTH_EMULATOR_URL", "http://127.0.0.1:9099");
  const origin = getFunctionsEmulatorOrigin();
  ensureAuthEmulatorHostFromBaseUrl(authBaseUrl);

  const db = initFirestore(projectId);
  const ctx = { origin, projectId, region };

  const ownerToken = await ensureIdTokenForUid({ authBaseUrl, uid: ownerUid });
  const appToken1 = await ensureIdTokenForUid({ authBaseUrl, uid: appUid1 });
  const appToken2 = await ensureIdTokenForUid({ authBaseUrl, uid: appUid2 });

  await caseLegacyOnlyMembers(ctx, db, ownerToken, appToken1, appToken2, ownerUid, appUid1, appUid2);
  await caseMixedAndUidCompatibility(ctx, db, ownerToken, appToken1, ownerUid, appUid1);
  await caseRequireDifferentValid(ctx, db, ownerToken, appToken1, ownerUid, appUid1);
  await caseRequireDifferentImpossible(ctx, db, ownerToken, appToken1, ownerUid, appUid1);
  await casePreferDifferent(ctx, db, ownerToken, appToken2, ownerUid, appUid2);

  console.log("\nOK: test_execute_draw_unified completado.");
}

run().catch((e) => {
  console.error("\nTEST FAILED:");
  console.error(e?.stack || e);
  process.exit(1);
});

