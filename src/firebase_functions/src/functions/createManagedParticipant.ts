import { FieldValue } from "firebase-admin/firestore";
import type { Firestore } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import {
  CreateManagedParticipantRequestSchema,
  CreateManagedParticipantResponse
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

export const createManagedParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<CreateManagedParticipantResponse> => {
    try {
      if (!req.auth?.uid) {
        throw new AppError({
          code: "UNAUTHENTICATED",
          reasonCode: "UNAUTHENTICATED",
          message: "Authentication required"
        });
      }
      const uid = requireAuthUid(req.auth.uid);
      const body = parseOrThrow(CreateManagedParticipantRequestSchema, req.data);
      const displayName = body.displayName.trim();

      if (displayName.length === 0 || displayName.length > 80) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_DISPLAY_NAME",
          message: "Invalid displayName"
        });
      }

      if (body.participantType !== "managed" && body.participantType !== "child_managed") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_PARTICIPANT_TYPE",
          message: "Invalid participantType"
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
          message: "Only owner can create managed participants"
        });
      }
      if (!drawAllowsParticipantsEdit(group.drawStatus)) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "DRAW_LOCKED",
          message: "Cannot modify participants while draw is drawing/completed"
        });
      }

      const subgroupId = body.subgroupId?.trim() ? body.subgroupId.trim() : null;
      if (subgroupId != null) {
        const subgroupRef = db.doc(`groups/${body.groupId}/subgroups/${subgroupId}`);
        const subgroupSnap = await subgroupRef.get();
        if (!subgroupSnap.exists) {
          throw new AppError({
            code: "NOT_FOUND",
            reasonCode: "SUBGROUP_NOT_FOUND",
            message: "Subgroup not found"
          });
        }
      }

      const participantRef = db.collection(`groups/${body.groupId}/participants`).doc();
      const participantId = participantRef.id;
      const now = FieldValue.serverTimestamp();

      const guardianUid = body.managedByUid?.trim() ? body.managedByUid.trim() : uid;
      if (guardianUid !== uid) {
        await requireActiveMemberUid(db, body.groupId, guardianUid);
      }

      await participantRef.set({
        participantId,
        displayName,
        participantType: body.participantType,
        linkedUid: null,
        managedByUid: guardianUid,
        roleInGroup: "member",
        state: "active",
        subgroupId,
        deliveryMode: body.deliveryMode,
        canReceiveDirectResult: false,
        source: "managed_created",
        createdAt: now,
        updatedAt: now
      });

      return {
        participantId,
        displayName,
        participantType: body.participantType,
        subgroupId,
        deliveryMode: body.deliveryMode
      };
    } catch (e) {
      const err = e as unknown;
      if (err instanceof AppError) {
        throw new HttpsError("failed-precondition", err.message, {
          code: err.code,
          reasonCode: err.reasonCode,
          details: err.details
        });
      }
      throw new HttpsError("internal", "Internal error");
    }
  }
);
