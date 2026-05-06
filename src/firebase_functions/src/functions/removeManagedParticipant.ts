import { FieldValue } from "firebase-admin/firestore";
import { CallableRequest, HttpsError, onCall } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { RemoveManagedParticipantRequestSchema, RemoveManagedParticipantResponse } from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";

function drawAllowsParticipantsEdit(drawStatus: unknown): boolean {
  return drawStatus == null || drawStatus === "idle" || drawStatus === "failed";
}

export const removeManagedParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<RemoveManagedParticipantResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(RemoveManagedParticipantRequestSchema, req.data);

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
          message: "Only owner can remove managed participants"
        });
      }
      if (!drawAllowsParticipantsEdit(group.drawStatus)) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "DRAW_LOCKED",
          message: "Cannot modify participants while draw is drawing/completed"
        });
      }

      const participantRef = db.doc(`groups/${body.groupId}/participants/${body.participantId}`);
      const participantSnap = await participantRef.get();
      if (!participantSnap.exists) {
        throw new AppError({
          code: "NOT_FOUND",
          reasonCode: "PARTICIPANT_NOT_FOUND",
          message: "Participant not found"
        });
      }
      const participant = participantSnap.data() as {
        participantType?: string;
      };
      if (participant.participantType !== "managed" && participant.participantType !== "child_managed") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "PARTICIPANT_TYPE_NOT_REMOVABLE",
          message: "Only managed participants can be removed"
        });
      }

      await participantRef.update({
        state: "removed",
        updatedAt: FieldValue.serverTimestamp()
      });

      return {
        participantId: body.participantId,
        state: "removed"
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

