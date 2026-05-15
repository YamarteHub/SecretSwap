import type { Firestore, Query } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

import { collections, groupPaths, userGroupPaths } from "./firestorePaths";

const BATCH_MAX = 400;

async function deleteQueryInChunks(db: Firestore, query: Query): Promise<void> {
  const snap = await query.limit(BATCH_MAX).get();
  if (snap.empty) return;
  const batch = db.batch();
  for (const d of snap.docs) {
    batch.delete(d.ref);
  }
  await batch.commit();
  await deleteQueryInChunks(db, query);
}

async function deleteCollectionByPath(db: Firestore, collectionPath: string): Promise<void> {
  await deleteQueryInChunks(db, db.collection(collectionPath));
}

async function deleteExecutionsTree(db: Firestore, groupId: string): Promise<void> {
  const execSnap = await db.collection(groupPaths.executionsCol(groupId)).get();
  for (const exec of execSnap.docs) {
    await deleteCollectionByPath(
      db,
      `${groupPaths.executionsCol(groupId)}/${exec.id}/assignments`
    );
    await exec.ref.delete();
  }
}

async function deleteRaffleExecutionsTree(db: Firestore, groupId: string): Promise<void> {
  const col = db.collection(groupPaths.raffleExecutionsCol(groupId));
  const snap = await col.get();
  for (const d of snap.docs) {
    await d.ref.delete();
  }
}

async function deleteTeamExecutionsTree(db: Firestore, groupId: string): Promise<void> {
  const col = db.collection(groupPaths.teamExecutionsCol(groupId));
  const snap = await col.get();
  for (const d of snap.docs) {
    await d.ref.delete();
  }
}

/**
 * Borra subcolecciones conocidas y el documento raíz del grupo.
 * No elimina invite_codes ni user_groups (ver {@link purgeGroupFully}).
 */
export async function deleteGroupFirestoreTree(db: Firestore, groupId: string): Promise<void> {
  await deleteExecutionsTree(db, groupId);
  await deleteRaffleExecutionsTree(db, groupId);
  await deleteTeamExecutionsTree(db, groupId);
  await deleteCollectionByPath(db, groupPaths.membersCol(groupId));
  await deleteCollectionByPath(db, groupPaths.participantsCol(groupId));
  await deleteCollectionByPath(db, `groups/${groupId}/subgroups`);
  await deleteCollectionByPath(db, groupPaths.rulesCol(groupId));
  await deleteCollectionByPath(db, groupPaths.chatMessagesCol(groupId));
  await deleteCollectionByPath(db, `groups/${groupId}/wishlists`);
  await deleteCollectionByPath(db, `groups/${groupId}/invites`);
  await deleteCollectionByPath(db, `groups/${groupId}/chatAutomation`);
  await db.doc(groupPaths.groupDoc(groupId)).delete();
}

async function deleteInviteCodesForGroup(db: Firestore, groupId: string): Promise<void> {
  const inviteCodesSnap = await db
    .collection(collections.inviteCodes())
    .where("groupId", "==", groupId)
    .get();
  for (let i = 0; i < inviteCodesSnap.docs.length; i += BATCH_MAX) {
    const slice = inviteCodesSnap.docs.slice(i, i + BATCH_MAX);
    const b = db.batch();
    for (const d of slice) {
      b.delete(d.ref);
    }
    await b.commit();
  }
}

async function deleteUserGroupIndexes(
  db: Firestore,
  groupId: string,
  memberUids: string[]
): Promise<void> {
  for (const memberUid of memberUids) {
    const ugRef = db.doc(userGroupPaths.userGroupDoc(memberUid, groupId));
    const ugSnap = await ugRef.get();
    if (ugSnap.exists) {
      await ugRef.delete();
    }
  }
}

export type PurgeGroupResult = { ok: true } | { ok: false; reason: string };

/**
 * Borrado completo de un grupo: árbol Firestore, invite_codes y user_groups.
 * Usado por deleteGroup (owner) y purgeExpiredCompletedGroups (scheduler).
 */
export async function purgeGroupFully(db: Firestore, groupId: string): Promise<PurgeGroupResult> {
  const groupRef = db.doc(groupPaths.groupDoc(groupId));
  const groupSnap = await groupRef.get();
  if (!groupSnap.exists) {
    return { ok: true };
  }

  const membersSnap = await db.collection(groupPaths.membersCol(groupId)).get();
  const memberUids = membersSnap.docs.map((d) => d.id);

  try {
    await deleteInviteCodesForGroup(db, groupId);
    await deleteGroupFirestoreTree(db, groupId);
    await deleteUserGroupIndexes(db, groupId, memberUids);
    return { ok: true };
  } catch (e) {
    logger.error("purgeGroupFully failed", { groupId, err: e });
    return { ok: false, reason: e instanceof Error ? e.message : String(e) };
  }
}
