import { CallableRequest, HttpsError, onCall } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";
import { DeleteSubgroupRequestSchema, DeleteSubgroupResponse } from "../shared/dtos";

function drawAllowsSubgroupEdit(drawStatus: unknown): boolean {
  return drawStatus == null || drawStatus === "idle" || drawStatus === "failed";
}

export const deleteSubgroup = onCall(
  async (req: CallableRequest<unknown>): Promise<DeleteSubgroupResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(DeleteSubgroupRequestSchema, req.data);
      const db = getDb();

      const groupRef = db.doc(groupPaths.groupDoc(body.groupId));
      const groupSnap = await groupRef.get();
      if (!groupSnap.exists) {
        throw new AppError({
          code: "NOT_FOUND",
          reasonCode: "GROUP_NOT_FOUND",
          message: "Group not found"
        });
      }
      const group = groupSnap.data() as { ownerUid?: string; drawStatus?: string };
      if (group.ownerUid !== uid) {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "NOT_OWNER",
          message: "Only owner can delete subgroups"
        });
      }
      if (!drawAllowsSubgroupEdit(group.drawStatus)) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "DRAW_LOCKED",
          message: "Cannot modify subgroups while draw is drawing/completed"
        });
      }

      const subgroupRef = db.doc(`groups/${body.groupId}/subgroups/${body.subgroupId}`);
      const subgroupSnap = await subgroupRef.get();
      if (!subgroupSnap.exists) {
        throw new AppError({
          code: "NOT_FOUND",
          reasonCode: "SUBGROUP_NOT_FOUND",
          message: "Subgroup not found"
        });
      }

      const memberInUse = await db
        .collection(`groups/${body.groupId}/members`)
        .where("memberState", "==", "active")
        .where("subgroupId", "==", body.subgroupId)
        .limit(1)
        .get();
      if (memberInUse.docs.length > 0) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "SUBGROUP_IN_USE",
          message: "Antes de eliminar este subgrupo, mueve o deja sin subgrupo a sus participantes."
        });
      }

      const participantInUse = await db
        .collection(`groups/${body.groupId}/participants`)
        .where("state", "==", "active")
        .where("subgroupId", "==", body.subgroupId)
        .limit(1)
        .get();
      if (participantInUse.docs.length > 0) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "SUBGROUP_IN_USE",
          message: "Antes de eliminar este subgrupo, mueve o deja sin subgrupo a sus participantes."
        });
      }

      await subgroupRef.delete();
      return {
        subgroupId: body.subgroupId,
        deleted: true
      };
    } catch (e) {
      if (e instanceof AppError) {
        throw new HttpsError("failed-precondition", e.message, {
          code: e.code,
          reasonCode: e.reasonCode,
          details: e.details
        });
      }
      throw new HttpsError("internal", "Internal error");
    }
  }
);

