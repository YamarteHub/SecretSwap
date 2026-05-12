import { FieldValue } from "firebase-admin/firestore";
import type { Firestore } from "firebase-admin/firestore";
import { CallableRequest, HttpsError, onCall } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import {
  UpdateManagedParticipantRequestSchema,
  UpdateManagedParticipantResponse
} from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";

async function requireActiveMemberUid(
  db: Firestore,
  groupId: string,
  memberUid: string
): Promise<void> {
  const snap = await db.doc(groupPaths.memberDoc(groupId, memberUid)).get();
  if (!snap.exists) {
    throw new AppError({
      code: "NOT_FOUND",
      reasonCode: "MEMBER_NOT_FOUND",
      message: "Guardian must be a member of this group"
    });
  }
  const st = (snap.data() as { memberState?: string } | undefined)?.memberState ?? "active";
  if (st !== "active") {
    throw new AppError({
      code: "VALIDATION_ERROR",
      reasonCode: "MEMBER_NOT_ACTIVE",
      message: "Guardian must be an active member"
    });
  }
}

function drawAllowsParticipantsEdit(drawStatus: unknown): boolean {
  return drawStatus == null || drawStatus === "idle" || drawStatus === "failed";
}

export const updateManagedParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<UpdateManagedParticipantResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(UpdateManagedParticipantRequestSchema, req.data);
      const displayName = body.displayName.trim();
      if (displayName.length === 0 || displayName.length > 80) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_DISPLAY_NAME",
          message: "Invalid displayName"
        });
      }

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
          message: "Only owner can update managed participants"
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
        state?: string;
      };
      if (participant.state !== "active") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "PARTICIPANT_NOT_ACTIVE",
          message: "Participant is not active"
        });
      }
      if (participant.participantType !== "managed" && participant.participantType !== "child_managed") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "PARTICIPANT_TYPE_NOT_EDITABLE",
          message: "Only managed participants can be updated"
        });
      }

      const subgroupId = body.subgroupId?.trim() ? body.subgroupId.trim() : null;
      if (subgroupId) {
        const subgroupSnap = await db.doc(`groups/${body.groupId}/subgroups/${subgroupId}`).get();
        if (!subgroupSnap.exists) {
          throw new AppError({
            code: "NOT_FOUND",
            reasonCode: "SUBGROUP_NOT_FOUND",
            message: "Subgroup not found"
          });
        }
      }

      const updatePayload: Record<string, unknown> = {
        displayName,
        participantType: body.participantType,
        deliveryMode: body.deliveryMode,
        ...(subgroupId == null ? { subgroupId: FieldValue.delete() } : { subgroupId }),
        updatedAt: FieldValue.serverTimestamp()
      };

      if (body.managedByUid !== undefined) {
        const ownerUid = group.ownerUid ?? "";
        if (body.managedByUid === null) {
          updatePayload.managedByUid = ownerUid;
        } else {
          const g = body.managedByUid.trim();
          if (g.length > 0) {
            await requireActiveMemberUid(db, body.groupId, g);
            updatePayload.managedByUid = g;
          }
        }
      }

      await participantRef.update(updatePayload);

      return {
        participantId: body.participantId,
        displayName,
        participantType: body.participantType,
        subgroupId,
        deliveryMode: body.deliveryMode
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

