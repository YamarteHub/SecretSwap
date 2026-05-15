import type { Firestore, Query } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { CallableRequest, HttpsError, onCall } from "firebase-functions/v2/https";

import { requireAuthUid } from "../shared/auth";
import { getDb } from "../shared/firestore";
import { collections, groupPaths, userGroupPaths } from "../shared/firestorePaths";
import { DeleteGroupRequestSchema, DeleteGroupResponse } from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";

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
  const coll = db.collection(collectionPath);
  await deleteQueryInChunks(db, coll);
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
 * Borrado explícito de subcolecciones conocidas del proyecto + índices externos.
 * (Sin `recursiveDelete`: depende del runtime Admin; aquí el árbol está acotado por el código real.)
 */
async function deleteGroupFirestoreTree(db: Firestore, groupId: string): Promise<void> {
  await deleteExecutionsTree(db, groupId);
  await deleteRaffleExecutionsTree(db, groupId);
  await deleteTeamExecutionsTree(db, groupId);
  await deleteCollectionByPath(db, groupPaths.membersCol(groupId));
  await deleteCollectionByPath(db, `groups/${groupId}/participants`);
  await deleteCollectionByPath(db, `groups/${groupId}/subgroups`);
  await deleteCollectionByPath(db, groupPaths.rulesCol(groupId));
  await deleteCollectionByPath(db, groupPaths.chatMessagesCol(groupId));
  await deleteCollectionByPath(db, `groups/${groupId}/wishlists`);
  await deleteCollectionByPath(db, `groups/${groupId}/invites`);
  await deleteCollectionByPath(db, `groups/${groupId}/chatAutomation`);
  await db.doc(groupPaths.groupDoc(groupId)).delete();
}

export const deleteGroup = onCall(async (req: CallableRequest<unknown>): Promise<DeleteGroupResponse> => {
  try {
    const uid = requireAuthUid(req.auth?.uid);
    const body = parseOrThrow(DeleteGroupRequestSchema, req.data);
    const { groupId } = body;
    const db = getDb();
    const groupRef = db.doc(groupPaths.groupDoc(groupId));
    const groupSnap = await groupRef.get();

    if (!groupSnap.exists) {
      /** Idempotente: segundo intento o grupo ya borrado no es error para el cliente. */
      return { ok: true, groupId, alreadyDeleted: true };
    }

    const group = groupSnap.data() as { ownerUid?: string };
    if (group.ownerUid !== uid) {
      throw new HttpsError("permission-denied", "Forbidden", {
        code: "FORBIDDEN",
        reasonCode: "GROUP_DELETE_FORBIDDEN"
      });
    }

    const membersSnap = await db.collection(groupPaths.membersCol(groupId)).get();
    const memberUids = membersSnap.docs.map((d) => d.id);

    const inviteCodesSnap = await db
      .collection(collections.inviteCodes())
      .where("groupId", "==", groupId)
      .get();

    try {
      for (let i = 0; i < inviteCodesSnap.docs.length; i += BATCH_MAX) {
        const slice = inviteCodesSnap.docs.slice(i, i + BATCH_MAX);
        const b = db.batch();
        for (const d of slice) {
          b.delete(d.ref);
        }
        await b.commit();
      }

      await deleteGroupFirestoreTree(db, groupId);

      for (const memberUid of memberUids) {
        const ugRef = db.doc(userGroupPaths.userGroupDoc(memberUid, groupId));
        const ugSnap = await ugRef.get();
        if (ugSnap.exists) {
          await ugRef.delete();
        }
      }
    } catch (e) {
      logger.error("deleteGroup: data cleanup failed", { groupId, err: e });
      throw new HttpsError("internal", "Group delete failed", {
        code: "INTERNAL",
        reasonCode: "GROUP_DELETE_FAILED"
      });
    }

    return { ok: true, groupId, alreadyDeleted: false };
  } catch (e) {
    const err = e as unknown;
    if (err instanceof HttpsError) {
      throw err;
    }
    logger.error("deleteGroup: unexpected", { err: e });
    throw new HttpsError("internal", "Internal error", {
      code: "INTERNAL",
      reasonCode: "GROUP_DELETE_FAILED"
    });
  }
});
