/* eslint-disable no-console */
/**
 * E2E mínimo (emulador): createGroup -> joinGroupByCode -> verificar Firestore consistente.
 *
 * Requiere:
 * - FIRESTORE_EMULATOR_HOST (ej: 127.0.0.1:8080)
 * - Auth emulator (default: http://127.0.0.1:9099)
 * - Functions emulator (default: http://127.0.0.1:5001)
 *
 * Ejemplo:
 *   set FIRESTORE_EMULATOR_HOST=127.0.0.1:8080
 *   cd src/firebase_functions
 *   node tools/e2e_create_and_join.js --ownerUid U_OWNER --memberUid U_MEMBER --projectId secretswap-dev
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

function stableEmailForUid(uid) {
  return `${uid.toLowerCase()}@test.local`;
}

function stablePasswordForUid(uid) {
  return `pw_${crypto.createHash("sha1").update(uid).digest("hex").slice(0, 12)}`;
}

async function ensureIdTokenForUid({ authBaseUrl, uid }) {
  const apiKey = "fake-api-key";
  const email = stableEmailForUid(uid);
  const password = stablePasswordForUid(uid);

  const signUpUrl = `${authBaseUrl}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=${apiKey}`;
  const signInUrl = `${authBaseUrl}/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${apiKey}`;

  const signUp = await fetchJson(signUpUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password, returnSecureToken: true, localId: uid })
  });

  if (signUp.ok && signUp.json?.idToken) {
    return signUp.json.idToken;
  }

  const msg = signUp.json?.error?.message;
  if (msg && (msg.includes("EMAIL_EXISTS") || msg.includes("LOCAL_ID_EXISTS"))) {
    const signIn = await fetchJson(signInUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password, returnSecureToken: true })
    });
    if (signIn.ok && signIn.json?.idToken) return signIn.json.idToken;
    throw new Error(`Auth signIn failed: ${signIn.status} ${signIn.text}`);
  }

  throw new Error(`Auth signUp failed: ${signUp.status} ${signUp.text}`);
}

function extractCallableResult(json) {
  if (!json) return null;
  if (typeof json.result !== "undefined") return json.result;
  if (typeof json.data !== "undefined") return json.data;
  return null;
}

function normalizeInviteCode(code) {
  return String(code ?? "").trim().toUpperCase();
}

function hashInviteCode(code) {
  const normalized = normalizeInviteCode(code);
  return crypto.createHash("sha256").update(normalized, "utf8").digest("hex");
}

function initFirestore(projectId) {
  const emulatorHost = process.env.FIRESTORE_EMULATOR_HOST;
  if (!emulatorHost) {
    throw new Error("FIRESTORE_EMULATOR_HOST no está definido (ej: 127.0.0.1:8080).");
  }
  admin.initializeApp({ projectId });
  return admin.firestore();
}

function assertDocExists(snap, path) {
  if (!snap.exists) throw new Error(`Missing document: ${path}`);
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(
      "Usage: node tools/e2e_create_and_join.js --ownerUid U_OWNER --memberUid U_MEMBER [--ownerNickname N1] [--memberNickname N2] [--groupName NAME] [--projectId secretswap-dev] [--region us-central1]"
    );
    process.exit(0);
  }

  const projectId = String(args.projectId ?? process.env.GCLOUD_PROJECT ?? "secretswap-dev");
  const region = String(args.region ?? "us-central1");

  const ownerUid = requireString(args.ownerUid, "ownerUid");
  const memberUid = requireString(args.memberUid, "memberUid");
  const ownerNickname = String(args.ownerNickname ?? "Owner");
  const memberNickname = String(args.memberNickname ?? "Member");
  const groupName = String(args.groupName ?? `E2E Group ${crypto.randomBytes(3).toString("hex")}`);

  const functionsBaseUrl = getHost("FUNCTIONS_EMULATOR_URL", "http://127.0.0.1:5001");
  const authBaseUrl = getHost("AUTH_EMULATOR_URL", "http://127.0.0.1:9099");

  const db = initFirestore(projectId);

  const ownerToken = await ensureIdTokenForUid({ authBaseUrl, uid: ownerUid });
  const memberToken = await ensureIdTokenForUid({ authBaseUrl, uid: memberUid });

  const createGroupUrl = `${functionsBaseUrl}/${projectId}/${region}/createGroup`;
  const joinUrl = `${functionsBaseUrl}/${projectId}/${region}/joinGroupByCode`;

  console.log("=== CALL createGroup ===");
  const createReq = { name: groupName, nickname: ownerNickname };
  console.log("request:", JSON.stringify(createReq, null, 2));
  const createRes = await fetchJson(createGroupUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${ownerToken}` },
    body: JSON.stringify({ data: createReq })
  });
  console.log(`HTTP ${createRes.status}`);
  console.log(createRes.json ? JSON.stringify(createRes.json, null, 2) : createRes.text);
  if (!createRes.ok || createRes.json?.error) throw new Error("createGroup failed");

  const created = extractCallableResult(createRes.json);
  const groupId = created?.groupId;
  const inviteCode = created?.inviteCode;
  if (!groupId || !inviteCode) throw new Error("createGroup response missing groupId/inviteCode");

  console.log("\n=== CALL joinGroupByCode ===");
  const joinReq = { code: inviteCode, nickname: memberNickname };
  console.log("request:", JSON.stringify({ uid: memberUid, ...joinReq }, null, 2));
  const joinRes = await fetchJson(joinUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${memberToken}` },
    body: JSON.stringify({ data: joinReq })
  });
  console.log(`HTTP ${joinRes.status}`);
  console.log(joinRes.json ? JSON.stringify(joinRes.json, null, 2) : joinRes.text);
  if (!joinRes.ok || joinRes.json?.error) throw new Error("joinGroupByCode failed");

  const joined = extractCallableResult(joinRes.json);
  if (joined?.groupId !== groupId) {
    throw new Error(`joinGroupByCode groupId mismatch: expected=${groupId} got=${joined?.groupId}`);
  }

  console.log("\n=== VERIFY FIRESTORE DOCS ===");
  const codeHash = hashInviteCode(inviteCode);

  const paths = {
    group: `groups/${groupId}`,
    ownerMember: `groups/${groupId}/members/${ownerUid}`,
    newMember: `groups/${groupId}/members/${memberUid}`,
    invitesCurrent: `groups/${groupId}/invites/current`,
    inviteCodes: `invite_codes/${codeHash}`,
    ownerUserGroup: `user_groups/${ownerUid}/groups/${groupId}`,
    memberUserGroup: `user_groups/${memberUid}/groups/${groupId}`
  };

  const [groupSnap, ownerSnap, memberSnap, invitesSnap, inviteCodeSnap, ownerUGSnap, memberUGSnap] =
    await Promise.all([
      db.doc(paths.group).get(),
      db.doc(paths.ownerMember).get(),
      db.doc(paths.newMember).get(),
      db.doc(paths.invitesCurrent).get(),
      db.doc(paths.inviteCodes).get(),
      db.doc(paths.ownerUserGroup).get(),
      db.doc(paths.memberUserGroup).get()
    ]);

  assertDocExists(groupSnap, paths.group);
  assertDocExists(ownerSnap, paths.ownerMember);
  assertDocExists(memberSnap, paths.newMember);
  assertDocExists(invitesSnap, paths.invitesCurrent);
  assertDocExists(inviteCodeSnap, paths.inviteCodes);
  assertDocExists(ownerUGSnap, paths.ownerUserGroup);
  assertDocExists(memberUGSnap, paths.memberUserGroup);

  const group = groupSnap.data();
  if (group.lifecycleStatus !== "active") throw new Error("Group lifecycleStatus not active");
  if (group.drawStatus !== "idle") throw new Error("Group drawStatus not idle");
  if (group.ownerUid !== ownerUid) throw new Error("Group ownerUid mismatch");

  const ownerMember = ownerSnap.data();
  if (ownerMember.role !== "owner") throw new Error("Owner member role mismatch");
  if (ownerMember.memberState !== "active") throw new Error("Owner memberState not active");

  const newMember = memberSnap.data();
  if (newMember.role !== "member") throw new Error("New member role mismatch");
  if (newMember.memberState !== "active") throw new Error("New memberState not active");

  const invites = invitesSnap.data();
  if (invites.codeHash !== codeHash) throw new Error("invites/current codeHash mismatch");
  if (invites.active !== true) throw new Error("invites/current active != true");

  const inviteIndex = inviteCodeSnap.data();
  if (inviteIndex.groupId !== groupId) throw new Error("invite_codes groupId mismatch");
  if (inviteIndex.active !== true) throw new Error("invite_codes active != true");

  const ownerUG = ownerUGSnap.data();
  if (ownerUG.role !== "owner") throw new Error("owner user_groups role mismatch");
  if (ownerUG.isActiveMember !== true) throw new Error("owner user_groups isActiveMember != true");

  const memberUG = memberUGSnap.data();
  if (memberUG.role !== "member") throw new Error("member user_groups role mismatch");
  if (memberUG.isActiveMember !== true) throw new Error("member user_groups isActiveMember != true");

  console.log("OK: todos los documentos existen y son consistentes.");
  console.log("\nResumen:");
  console.log(`- groupId=${groupId}`);
  console.log(`- inviteCode=${inviteCode} (solo salida, no persistido)`);
  console.log(`- ownerUid=${ownerUid}, memberUid=${memberUid}`);
}

run().catch((e) => {
  console.error("\nE2E FAILED:");
  console.error(e?.stack || e);
  process.exit(1);
});

