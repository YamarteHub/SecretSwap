/* eslint-disable no-console */
/**
 * Seed de datos para probar joinGroupByCode.
 *
 * - Solo crea/actualiza documentos (sin queries).
 * - No guarda el código en claro: calcula codeHash (sha256(normalize(code))).
 * - Por seguridad, si NO detecta emulador, aborta salvo --allowProd.
 *
 * Uso (emulador):
 *   set FIRESTORE_EMULATOR_HOST=127.0.0.1:8080
 *   node tools/seed_join_by_code.js --scenario all --uid U_TEST --ownerUid U_OWNER
 *
 * Uso (1 caso):
 *   node tools/seed_join_by_code.js --scenario group_archived --uid U_TEST --ownerUid U_OWNER
 */

const crypto = require("node:crypto");
const admin = require("firebase-admin");

function normalizeInviteCode(code) {
  return String(code ?? "").trim().toUpperCase();
}

function hashInviteCode(code) {
  const normalized = normalizeInviteCode(code);
  return crypto.createHash("sha256").update(normalized, "utf8").digest("hex");
}

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

function nowMillis() {
  return Date.now();
}

function toTimestampOrNull(expiresInSeconds) {
  if (expiresInSeconds == null) return null;
  const s = Number(expiresInSeconds);
  if (!Number.isFinite(s)) return null;
  return admin.firestore.Timestamp.fromMillis(nowMillis() + s * 1000);
}

function initAdmin(projectId) {
  const emulatorHost = process.env.FIRESTORE_EMULATOR_HOST;
  const isEmulator = !!emulatorHost;

  if (isEmulator) {
    admin.initializeApp({ projectId });
  } else {
    admin.initializeApp();
  }

  return { db: admin.firestore(), isEmulator };
}

async function upsertInviteBundle(db, params) {
  const {
    groupId,
    groupName,
    ownerUid,
    lifecycleStatus,
    drawStatus,
    code,
    inviteActive,
    inviteExpiresAt,
    rotatedByUid
  } = params;

  const normalizedCode = normalizeInviteCode(code);
  const codeHash = hashInviteCode(normalizedCode);

  const groupRef = db.doc(`groups/${groupId}`);
  const inviteCurrentRef = db.doc(`groups/${groupId}/invites/current`);
  const inviteCodeRef = db.doc(`invite_codes/${codeHash}`);

  const serverNow = admin.firestore.FieldValue.serverTimestamp();

  await db.runTransaction(async (tx) => {
    tx.set(
      groupRef,
      {
        groupId,
        name: groupName,
        ownerUid,
        lifecycleStatus,
        rulesVersionCurrent: 1,
        drawStatus,
        drawingLock: null,
        updatedAt: serverNow,
        createdAt: serverNow
      },
      { merge: true }
    );

    tx.set(
      inviteCurrentRef,
      {
        codeHash,
        active: inviteActive,
        expiresAt: inviteExpiresAt,
        rotatedAt: serverNow,
        rotatedByUid
      },
      { merge: true }
    );

    tx.set(
      inviteCodeRef,
      {
        groupId,
        active: inviteActive,
        expiresAt: inviteExpiresAt,
        createdAt: serverNow
      },
      { merge: true }
    );
  });

  return { normalizedCode, codeHash };
}

async function upsertMember(db, params) {
  const { groupId, uid, memberState, nickname, role } = params;
  const memberRef = db.doc(`groups/${groupId}/members/${uid}`);
  const serverNow = admin.firestore.FieldValue.serverTimestamp();

  await memberRef.set(
    {
      uid,
      role,
      memberState,
      nickname,
      subgroupId: null,
      updatedAt: serverNow,
      createdAt: serverNow
    },
    { merge: true }
  );
}

async function upsertUserGroup(db, params) {
  const { uid, groupId, groupName, role, isActiveMember } = params;
  const ref = db.doc(`user_groups/${uid}/groups/${groupId}`);
  const serverNow = admin.firestore.FieldValue.serverTimestamp();
  await ref.set(
    {
      groupId,
      name: groupName,
      role,
      isActiveMember,
      updatedAt: serverNow
    },
    { merge: true }
  );
}

function scenarioConfig(scenario) {
  switch (scenario) {
    case "ok_rejoin_left":
      return {
        expected: "OK (debe permitir rejoin; memberState left -> active)",
        memberState: "left",
        lifecycleStatus: "active",
        drawStatus: "idle",
        inviteActive: true,
        expiresInSeconds: 3600
      };
    case "already_member":
      return {
        expected: "ALREADY_MEMBER",
        memberState: "active",
        lifecycleStatus: "active",
        drawStatus: "idle",
        inviteActive: true,
        expiresInSeconds: 3600
      };
    case "user_removed":
      return {
        expected: "USER_REMOVED",
        memberState: "removed",
        lifecycleStatus: "active",
        drawStatus: "idle",
        inviteActive: true,
        expiresInSeconds: 3600
      };
    case "group_archived":
      return {
        expected: "GROUP_ARCHIVED",
        memberState: "left",
        lifecycleStatus: "archived",
        drawStatus: "idle",
        inviteActive: true,
        expiresInSeconds: 3600
      };
    case "draw_in_progress":
      return {
        expected: "DRAW_IN_PROGRESS",
        memberState: "left",
        lifecycleStatus: "active",
        drawStatus: "drawing",
        inviteActive: true,
        expiresInSeconds: 3600
      };
    case "code_expired":
      return {
        expected: "CODE_EXPIRED",
        memberState: "left",
        lifecycleStatus: "active",
        drawStatus: "idle",
        inviteActive: true,
        expiresInSeconds: -60
      };
    default:
      throw new Error(
        `Unknown scenario "${scenario}". Use one of: all, ok_rejoin_left, already_member, user_removed, group_archived, draw_in_progress, code_expired`
      );
  }
}

function makeGroupId(prefix) {
  return `${prefix}_${crypto.randomBytes(4).toString("hex")}`;
}

function makeCode(prefix) {
  const suffix = crypto.randomBytes(3).toString("hex").toUpperCase();
  return `${prefix}${suffix}`; // alfanumérico y uppercase
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log("Usage: node tools/seed_join_by_code.js --scenario all --uid U_TEST --ownerUid U_OWNER [--projectId secretswap-dev] [--allowProd]");
    process.exit(0);
  }

  const scenario = String(args.scenario ?? "all");
  const uid = requireString(args.uid, "uid");
  const ownerUid = requireString(args.ownerUid, "ownerUid");
  const projectId = String(args.projectId ?? process.env.GCLOUD_PROJECT ?? "secretswap-dev");
  const allowProd = !!args.allowProd;

  const { db, isEmulator } = initAdmin(projectId);
  if (!isEmulator && !allowProd) {
    throw new Error(
      "FIRESTORE_EMULATOR_HOST no está definido. Para evitar writes accidentales, este script aborta.\n" +
        "Si realmente quieres escribir en un proyecto real, re-ejecuta con --allowProd y credenciales configuradas."
    );
  }

  const scenarios =
    scenario === "all"
      ? ["ok_rejoin_left", "already_member", "user_removed", "group_archived", "draw_in_progress", "code_expired"]
      : [scenario];

  const results = [];
  for (const sc of scenarios) {
    const cfg = scenarioConfig(sc);
    const groupId = makeGroupId(sc);
    const code = makeCode(sc.replaceAll("_", "").slice(0, 6).toUpperCase());
    const groupName = `Test ${sc}`;
    const inviteExpiresAt = toTimestampOrNull(cfg.expiresInSeconds);

    const { normalizedCode, codeHash } = await upsertInviteBundle(db, {
      groupId,
      groupName,
      ownerUid,
      lifecycleStatus: cfg.lifecycleStatus,
      drawStatus: cfg.drawStatus,
      code,
      inviteActive: cfg.inviteActive,
      inviteExpiresAt,
      rotatedByUid: ownerUid
    });

    await upsertMember(db, {
      groupId,
      uid,
      memberState: cfg.memberState,
      nickname: "SeedUser",
      role: "member"
    });

    await upsertUserGroup(db, {
      uid,
      groupId,
      groupName,
      role: "member",
      isActiveMember: cfg.memberState === "active"
    });

    results.push({
      scenario: sc,
      expected: cfg.expected,
      groupId,
      code: normalizedCode,
      codeHash
    });
  }

  console.log("\nSeed listo. Usa estos datos para llamar joinGroupByCode:");
  for (const r of results) {
    console.log(`- ${r.scenario}: expected=${r.expected}`);
    console.log(`  uid=${uid}`);
    console.log(`  groupId=${r.groupId}`);
    console.log(`  code=${r.code}`);
    console.log(`  codeHash=${r.codeHash}\n`);
  }

  console.log(
    "Nota: INVALID_CODE_FORMAT se prueba enviando un code con caracteres inválidos (ej: \"ab cd\" o \"ABCD-123\")."
  );
}

run().catch((e) => {
  console.error(e?.stack || e);
  process.exit(1);
});

