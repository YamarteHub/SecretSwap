import { FieldValue } from "firebase-admin/firestore";
import type { DocumentSnapshot } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import {
  CreateRaffleManualParticipantRequestSchema,
  CreateRaffleManualParticipantResponse,
  RemoveRaffleManualParticipantRequestSchema,
  RemoveRaffleManualParticipantResponse,
  UpdateRaffleManualParticipantRequestSchema,
  UpdateRaffleManualParticipantResponse
} from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";

function parseDynamicType(raw: unknown): string {
  const s = typeof raw === "string" ? raw.trim() : "";
  return s.length > 0 ? s : "secret_santa";
}

function raffleAllowsEdits(raffleStatus: unknown): boolean {
  return raffleStatus == null || raffleStatus === "idle" || raffleStatus === "failed";
}

async function requireRaffleOwnerEditableGroup(groupId: string, uid: string): Promise<DocumentSnapshot> {
  const db = getDb();
  const groupRef = db.doc(groupPaths.groupDoc(groupId));
  const groupSnap = await groupRef.get();
  if (!groupSnap.exists) {
    throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
  }
  const group = groupSnap.data() as {
    ownerUid?: string;
    dynamicType?: string;
    raffleStatus?: string;
  };
  if (group.ownerUid !== uid) {
    throw new AppError({ code: "FORBIDDEN", reasonCode: "NOT_OWNER", message: "Only owner can edit raffle" });
  }
  if (parseDynamicType(group.dynamicType) !== "simple_raffle") {
    throw new AppError({
      code: "VALIDATION_ERROR",
      reasonCode: "RAFFLE_INVALID_DYNAMIC",
      message: "Not a raffle group"
    });
  }
  if (!raffleAllowsEdits(group.raffleStatus)) {
    throw new AppError({
      code: "VALIDATION_ERROR",
      reasonCode: "RAFFLE_EDIT_LOCKED",
      message: "Cannot edit raffle participants after completion"
    });
  }
  return groupSnap;
}

export const createRaffleManualParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<CreateRaffleManualParticipantResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(CreateRaffleManualParticipantRequestSchema, req.data);
      const displayName = body.displayName.trim();
      if (displayName.length === 0 || displayName.length > 80) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_DISPLAY_NAME",
          message: "Invalid displayName"
        });
      }

      await requireRaffleOwnerEditableGroup(body.groupId, uid);

      const db = getDb();
      const participantRef = db.collection(groupPaths.participantsCol(body.groupId)).doc();
      const participantId = participantRef.id;
      const now = FieldValue.serverTimestamp();

      await participantRef.set({
        participantId,
        displayName,
        participantType: "raffle_manual",
        state: "active",
        linkedUid: null,
        managedByUid: null,
        roleInGroup: "member",
        deliveryMode: "verbal",
        canReceiveDirectResult: false,
        subgroupId: null,
        source: "raffle_manual_v1",
        createdAt: now,
        updatedAt: now
      });

      return { participantId };
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

export const updateRaffleManualParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<UpdateRaffleManualParticipantResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(UpdateRaffleManualParticipantRequestSchema, req.data);
      const displayName = body.displayName.trim();
      if (displayName.length === 0 || displayName.length > 80) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_DISPLAY_NAME",
          message: "Invalid displayName"
        });
      }

      await requireRaffleOwnerEditableGroup(body.groupId, uid);

      const db = getDb();
      const ref = db.doc(`${groupPaths.participantsCol(body.groupId)}/${body.participantId}`);
      const snap = await ref.get();
      if (!snap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "PARTICIPANT_NOT_FOUND", message: "Participant not found" });
      }
      const d = snap.data() as { participantType?: string; state?: string };
      if (d.participantType !== "raffle_manual") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_PARTICIPANT_TYPE",
          message: "Not a raffle manual participant"
        });
      }
      if (d.state === "removed") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "PARTICIPANT_REMOVED",
          message: "Participant removed"
        });
      }

      await ref.update({
        displayName,
        updatedAt: FieldValue.serverTimestamp()
      });

      return { participantId: body.participantId };
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

export const removeRaffleManualParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<RemoveRaffleManualParticipantResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(RemoveRaffleManualParticipantRequestSchema, req.data);

      await requireRaffleOwnerEditableGroup(body.groupId, uid);

      const db = getDb();
      const ref = db.doc(`${groupPaths.participantsCol(body.groupId)}/${body.participantId}`);
      const snap = await ref.get();
      if (!snap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "PARTICIPANT_NOT_FOUND", message: "Participant not found" });
      }
      const d = snap.data() as { participantType?: string };
      if (d.participantType !== "raffle_manual") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_PARTICIPANT_TYPE",
          message: "Not a raffle manual participant"
        });
      }

      await ref.update({
        state: "removed",
        updatedAt: FieldValue.serverTimestamp()
      });

      return { participantId: body.participantId, state: "removed" };
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
