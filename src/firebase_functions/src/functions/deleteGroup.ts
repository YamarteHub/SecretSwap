import * as logger from "firebase-functions/logger";
import { CallableRequest, HttpsError, onCall } from "firebase-functions/v2/https";

import { requireAuthUid } from "../shared/auth";
import { purgeGroupFully } from "../shared/deleteGroupTree";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { DeleteGroupRequestSchema, DeleteGroupResponse } from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";

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

    const result = await purgeGroupFully(db, groupId);
    if (!result.ok) {
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
