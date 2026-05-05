/* eslint-disable no-console */
/**
 * Seed local de participantes fake para QA (solo Firestore Emulator).
 *
 * Uso:
 *   set FIRESTORE_EMULATOR_HOST=127.0.0.1:8080
 *   set GCLOUD_PROJECT=tarciswap-dev
 *   npm run seed:participants -- --groupId <GROUP_ID> --allow-seed --members "Enrique:Casa Quillo,Adrian:Casa Adrian"
 *
 * También admite miembros sin subgrupo:
 *   npm run seed:participants -- --groupId <GROUP_ID> --allow-seed --members "Enrique,Adrian"
 */

const admin = require("firebase-admin");

function parseArgs(argv) {
  const args = { _: [] };
  for (let i = 0; i < argv.length; i++) {
    const current = argv[i];
    if (!current.startsWith("--")) {
      args._.push(current);
      continue;
    }
    const key = current.slice(2);
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

function fail(message) {
  throw new Error(message);
}

function requireNonEmptyString(value, fieldName) {
  if (!value || typeof value !== "string" || value.trim() === "") {
    fail(`Falta --${fieldName}.`);
  }
  return value.trim();
}

function slugifyName(input) {
  const base = String(input)
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
  return base || "member";
}

function fakeUidFromNickname(nickname) {
  return `fake_${slugifyName(nickname)}`;
}

function parseMembers(raw) {
  const input = String(raw ?? "").trim();
  if (!input) {
    fail("Falta --members. Ejemplo: --members \"Enrique:Casa Quillo,Adrian\"");
  }

  const parts = input
    .split(",")
    .map((p) => p.trim())
    .filter(Boolean);

  if (parts.length === 0) {
    fail("No se detectaron miembros en --members.");
  }

  const seenUid = new Set();
  const out = [];
  for (const part of parts) {
    const sepIndex = part.indexOf(":");
    const nickname = (sepIndex >= 0 ? part.slice(0, sepIndex) : part).trim();
    const subgroupName = (sepIndex >= 0 ? part.slice(sepIndex + 1) : "").trim();

    if (!nickname) {
      fail(`Miembro inválido en --members: "${part}"`);
    }

    const uid = fakeUidFromNickname(nickname);
    if (seenUid.has(uid)) {
      fail(`Nombre duplicado (uid determinista repetido): "${nickname}" => "${uid}"`);
    }
    seenUid.add(uid);

    out.push({
      nickname,
      uid,
      subgroupName: subgroupName || null
    });
  }
  return out;
}

function initFirestore(projectId) {
  const emulatorHost = process.env.FIRESTORE_EMULATOR_HOST;
  if (!emulatorHost) {
    fail("Este script solo puede ejecutarse contra Firestore Emulator.");
  }
  admin.initializeApp({ projectId });
  return admin.firestore();
}

async function loadGroupOrFail(db, groupId) {
  const groupRef = db.doc(`groups/${groupId}`);
  const groupSnap = await groupRef.get();
  if (!groupSnap.exists) {
    fail(`Grupo no encontrado: ${groupId}`);
  }
  const group = groupSnap.data() || {};
  return {
    groupRef,
    groupName: typeof group.name === "string" && group.name.trim() !== "" ? group.name.trim() : groupId
  };
}

async function loadSubgroupsByName(db, groupId) {
  const snap = await db.collection(`groups/${groupId}/subgroups`).get();
  const map = new Map();
  for (const doc of snap.docs) {
    const d = doc.data() || {};
    const name = typeof d.name === "string" ? d.name.trim() : "";
    if (!name) continue;
    map.set(name.toLowerCase(), {
      subgroupId: typeof d.subgroupId === "string" && d.subgroupId.trim() !== "" ? d.subgroupId.trim() : doc.id,
      name
    });
  }
  return map;
}

async function upsertMemberAndProjection({ db, groupId, groupName, member, subgroupId }) {
  const memberRef = db.doc(`groups/${groupId}/members/${member.uid}`);
  const userGroupRef = db.doc(`user_groups/${member.uid}/groups/${groupId}`);
  const now = admin.firestore.FieldValue.serverTimestamp();

  const memberSnap = await memberRef.get();
  const createdAt = memberSnap.exists ? memberSnap.data()?.createdAt ?? now : now;

  await memberRef.set(
    {
      uid: member.uid,
      nickname: member.nickname,
      role: "member",
      memberState: "active",
      subgroupId: subgroupId ?? null,
      createdAt,
      updatedAt: now
    },
    { merge: true }
  );

  await userGroupRef.set(
    {
      groupId,
      name: groupName,
      role: "member",
      isActiveMember: true,
      updatedAt: now
    },
    { merge: true }
  );
}

async function activeMembersCount(db, groupId) {
  const snap = await db.collection(`groups/${groupId}/members`).where("memberState", "==", "active").get();
  return snap.size;
}

async function run() {
  const args = parseArgs(process.argv.slice(2));

  if (!args["allow-seed"]) {
    fail("Debes confirmar --allow-seed.\nEste script solo puede ejecutarse contra Firestore Emulator.");
  }

  if (!process.env.FIRESTORE_EMULATOR_HOST) {
    fail("Este script solo puede ejecutarse contra Firestore Emulator.");
  }

  const groupId = requireNonEmptyString(args.groupId, "groupId");
  const members = parseMembers(args.members);
  const projectId = String(args.projectId ?? process.env.GCLOUD_PROJECT ?? "tarciswap-dev");

  const db = initFirestore(projectId);
  const { groupName } = await loadGroupOrFail(db, groupId);
  const subgroupsByName = await loadSubgroupsByName(db, groupId);

  console.log(`[seed:participants] Grupo encontrado: ${groupId} (${groupName})`);
  console.log(`[seed:participants] Proyecto: ${projectId}`);
  console.log(`[seed:participants] FIRESTORE_EMULATOR_HOST=${process.env.FIRESTORE_EMULATOR_HOST}`);

  for (const member of members) {
    let subgroupId = null;
    if (member.subgroupName) {
      const found = subgroupsByName.get(member.subgroupName.toLowerCase());
      if (!found) {
        fail(`Subgrupo no encontrado: ${member.subgroupName}`);
      }
      subgroupId = found.subgroupId;
    }

    await upsertMemberAndProjection({
      db,
      groupId,
      groupName,
      member,
      subgroupId
    });

    const subgroupLabel = member.subgroupName ? ` (subgrupo: ${member.subgroupName})` : "";
    console.log(`- miembro creado/actualizado: ${member.nickname} [${member.uid}]${subgroupLabel}`);
  }

  const totalActive = await activeMembersCount(db, groupId);
  console.log(`[seed:participants] Total miembros activos en el grupo: ${totalActive}`);
  console.log(
    "[seed:participants] Ahora puedes volver a la app como owner y ejecutar sorteo si hay al menos 3 activos."
  );
}

run().catch((e) => {
  console.error(e?.message || e);
  process.exit(1);
});

