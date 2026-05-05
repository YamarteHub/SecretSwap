/* eslint-disable no-console */
/**
 * E2E local: valida callable createManagedParticipant contra Emulator Suite.
 *
 * Requiere:
 * - FIRESTORE_EMULATOR_HOST (obligatorio, aborta si falta)
 * - AUTH_EMULATOR_URL (default: http://127.0.0.1:9099)
 * - FUNCTIONS_EMULATOR_URL (default: http://127.0.0.1:5001)
 * - GCLOUD_PROJECT o --projectId
 *
 * Uso:
 *   npm run test:create-managed-participant -- --ownerUid E2E_OWNER_MANAGED --projectId tarciswap-dev
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
  if (!value || typeof value !== "string" || value.trim() === "") {
    throw new Error(`Missing --${name}`);
  }
  return value.trim();
}

function getArgWithPositionalFallback(args, key, positionalIndex) {
  const byFlag = args[key];
  if (typeof byFlag === "string" && byFlag.trim() !== "") return byFlag.trim();
  const byPositional = args._[positionalIndex];
  if (typeof byPositional === "string" && byPositional.trim() !== "") return byPositional.trim();
  return undefined;
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
  const email = stableEmailForUid(uid);
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
  const signInWithCustomTokenUrl =
    `${authBaseUrl}/identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${apiKey}`;
  const signIn = await fetchJson(signInWithCustomTokenUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ token: customToken, returnSecureToken: true })
  });
  if (signIn.ok && signIn.json?.idToken) return signIn.json.idToken;
  throw new Error(`signInWithCustomToken failed: ${signIn.status} ${signIn.text}`);
}

function extractCallableResult(json) {
  if (!json) return null;
  if (typeof json.result !== "undefined") return json.result;
  if (typeof json.data !== "undefined") return json.data;
  return null;
}

function assertDocExists(snap, path) {
  if (!snap.exists) throw new Error(`Missing document: ${path}`);
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function initFirestore(projectId) {
  if (!process.env.FIRESTORE_EMULATOR_HOST) {
    throw new Error(
      "Este script solo puede ejecutarse contra Firestore Emulator. Define FIRESTORE_EMULATOR_HOST."
    );
  }
  admin.initializeApp({ projectId });
  return admin.firestore();
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(
      "Usage: npm run test:create-managed-participant -- --ownerUid E2E_OWNER_MANAGED [--projectId tarciswap-dev]"
    );
    process.exit(0);
  }

  const ownerUid = requireString(getArgWithPositionalFallback(args, "ownerUid", 0), "ownerUid");
  const projectId = String(
    getArgWithPositionalFallback(args, "projectId", 1) ?? process.env.GCLOUD_PROJECT ?? "tarciswap-dev"
  );
  const authBaseUrl = getHost("AUTH_EMULATOR_URL", "http://127.0.0.1:9099");
  const functionsBaseUrl = getHost("FUNCTIONS_EMULATOR_URL", "http://127.0.0.1:5001");
  const region = String(args.region ?? "us-central1");

  ensureAuthEmulatorHostFromBaseUrl(authBaseUrl);
  const db = initFirestore(projectId);
  const ownerToken = await ensureIdTokenForUid({ authBaseUrl, uid: ownerUid });

  const createGroupUrl = `${functionsBaseUrl}/${projectId}/${region}/createGroup`;
  const createManagedUrl = `${functionsBaseUrl}/${projectId}/${region}/createManagedParticipant`;

  console.log("=== CALL createGroup ===");
  const groupReq = {
    name: `Managed E2E ${crypto.randomBytes(3).toString("hex")}`,
    nickname: "Owner"
  };
  const createGroupRes = await fetchJson(createGroupUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${ownerToken}` },
    body: JSON.stringify({ data: groupReq })
  });
  console.log(`HTTP ${createGroupRes.status}`);
  if (!createGroupRes.ok || createGroupRes.json?.error) {
    throw new Error(`createGroup failed: ${createGroupRes.text}`);
  }
  const created = extractCallableResult(createGroupRes.json);
  const groupId = created?.groupId;
  assert(typeof groupId === "string" && groupId.length > 0, "createGroup response missing groupId");

  const subgroupId = `sg_${crypto.randomBytes(3).toString("hex")}`;
  const subgroupName = `Casa QA ${crypto.randomBytes(2).toString("hex")}`;
  const subgroupRef = db.doc(`groups/${groupId}/subgroups/${subgroupId}`);
  await subgroupRef.set({
    subgroupId,
    name: subgroupName,
    color: null,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });
  console.log(`Subgrupo creado para prueba: ${subgroupId} (${subgroupName})`);

  console.log("\n=== CALL createManagedParticipant (OK) ===");
  const managedReq = {
    groupId,
    displayName: "Roy",
    participantType: "child_managed",
    subgroupId,
    deliveryMode: "ownerDelegated"
  };
  const managedRes = await fetchJson(createManagedUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${ownerToken}` },
    body: JSON.stringify({ data: managedReq })
  });
  console.log(`HTTP ${managedRes.status}`);
  if (!managedRes.ok || managedRes.json?.error) {
    throw new Error(`createManagedParticipant failed: ${managedRes.text}`);
  }

  const managedOut = extractCallableResult(managedRes.json);
  const participantId = managedOut?.participantId;
  assert(typeof participantId === "string" && participantId.length > 0, "Missing participantId in response");
  assert(managedOut.displayName === "Roy", "Output displayName mismatch");
  assert(managedOut.participantType === "child_managed", "Output participantType mismatch");
  assert(managedOut.subgroupId === subgroupId, "Output subgroupId mismatch");
  assert(managedOut.deliveryMode === "ownerDelegated", "Output deliveryMode mismatch");

  const participantPath = `groups/${groupId}/participants/${participantId}`;
  const participantSnap = await db.doc(participantPath).get();
  assertDocExists(participantSnap, participantPath);
  const p = participantSnap.data();

  assert(p.displayName === "Roy", "Firestore displayName mismatch");
  assert(p.participantType === "child_managed", "Firestore participantType mismatch");
  assert(p.linkedUid === null, "Firestore linkedUid should be null");
  assert(p.managedByUid === ownerUid, "Firestore managedByUid mismatch");
  assert(p.state === "active", "Firestore state mismatch");
  assert(p.deliveryMode === "ownerDelegated", "Firestore deliveryMode mismatch");
  assert(p.canReceiveDirectResult === false, "Firestore canReceiveDirectResult mismatch");
  assert(p.source === "managed_created", "Firestore source mismatch");

  console.log("Participante creado y validado en Firestore.");

  console.log("\n=== CALL createManagedParticipant (NEGATIVE: SUBGROUP_NOT_FOUND) ===");
  const badReq = {
    groupId,
    displayName: "Roy Bad",
    participantType: "managed",
    subgroupId: "sg_not_exists",
    deliveryMode: "verbal"
  };
  const badRes = await fetchJson(createManagedUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${ownerToken}` },
    body: JSON.stringify({ data: badReq })
  });
  console.log(`HTTP ${badRes.status}`);
  const errDetails = badRes.json?.error?.details;
  const reasonCode = errDetails?.reasonCode;
  if (badRes.ok || !badRes.json?.error) {
    throw new Error("Expected failure for subgroup not found, but request succeeded.");
  }
  assert(reasonCode === "SUBGROUP_NOT_FOUND", `Expected SUBGROUP_NOT_FOUND, got: ${reasonCode ?? "undefined"}`);

  console.log("\nOK: createManagedParticipant validado.");
  console.log(`groupId=${groupId}`);
  console.log(`participantId=${participantId}`);
}

run().catch((e) => {
  console.error("\nTEST FAILED:");
  console.error(e?.stack || e);
  process.exit(1);
});

