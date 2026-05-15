import { FieldValue } from "firebase-admin/firestore";
import type { DocumentSnapshot } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import {
  CreateTeamsManualParticipantRequestSchema,
  CreateTeamsManualParticipantResponse,
  RemoveTeamsManualParticipantRequestSchema,
  RemoveTeamsManualParticipantResponse,
  TEAMS_MAX_ELIGIBLE,
  UpdateTeamsManualParticipantRequestSchema,
  UpdateTeamsManualParticipantResponse
} from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";

function parseDynamicType(raw: unknown): string {
  const s = typeof raw === "string" ? raw.trim() : "";
  return s.length > 0 ? s : "secret_santa";
}

function teamsAllowsEdits(teamStatus: unknown): boolean {
  return teamStatus == null || teamStatus === "idle" || teamStatus === "failed";
}

async function countTeamsEligible(db: ReturnType<typeof getDb>, groupId: string, group: {
  ownerUid?: string;
  ownerParticipatesInTeams?: boolean;
}): Promise<number> {
  const ownerUid = typeof group.ownerUid === "string" ? group.ownerUid : "";
  const ownerParticipates = group.ownerParticipatesInTeams !== false;

  const membersSnap = await db.collection(groupPaths.membersCol(groupId)).get();
  const participantsSnap = await db.collection(groupPaths.participantsCol(groupId)).get();

  const ids = new Set<string>();

  for (const doc of membersSnap.docs) {
    const d = doc.data() as Record<string, unknown>;
    if (d.memberState !== "active") continue;
    const muid =
      typeof d.uid === "string" && d.uid.trim() !== "" ? d.uid.trim() : doc.id;
    if (!ownerParticipates && muid === ownerUid) continue;
    ids.add(muid);
  }

  for (const doc of participantsSnap.docs) {
    const d = doc.data() as Record<string, unknown>;
    if (d.state !== "active") continue;
    if (d.participantType !== "teams_manual") continue;
    const pid =
      typeof d.participantId === "string" && d.participantId.trim() !== ""
        ? d.participantId.trim()
        : doc.id;
    ids.add(pid);
  }

  return ids.size;
}

async function requireTeamsOwnerEditableGroup(groupId: string, uid: string): Promise<DocumentSnapshot> {
  const db = getDb();
  const groupRef = db.doc(groupPaths.groupDoc(groupId));
  const groupSnap = await groupRef.get();
  if (!groupSnap.exists) {
    throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
  }
  const group = groupSnap.data() as {
    ownerUid?: string;
    dynamicType?: string;
    teamStatus?: string;
  };
  if (group.ownerUid !== uid) {
    throw new AppError({ code: "FORBIDDEN", reasonCode: "NOT_OWNER", message: "Only owner can edit teams" });
  }
  if (parseDynamicType(group.dynamicType) !== "teams") {
    throw new AppError({
      code: "VALIDATION_ERROR",
      reasonCode: "TEAMS_INVALID_DYNAMIC",
      message: "Not a teams group"
    });
  }
  if (!teamsAllowsEdits(group.teamStatus)) {
    throw new AppError({
      code: "VALIDATION_ERROR",
      reasonCode: "TEAMS_MANUAL_PARTICIPANTS_LOCKED",
      message: "Cannot edit teams participants after formation"
    });
  }
  return groupSnap;
}

export const createTeamsManualParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<CreateTeamsManualParticipantResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(CreateTeamsManualParticipantRequestSchema, req.data);
      const displayName = body.displayName.trim();
      if (displayName.length === 0 || displayName.length > 80) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_DISPLAY_NAME",
          message: "Invalid displayName"
        });
      }

      const groupSnap = await requireTeamsOwnerEditableGroup(body.groupId, uid);
      const group = groupSnap.data() as {
        ownerUid?: string;
        ownerParticipatesInTeams?: boolean;
      };

      const db = getDb();
      const eligibleCount = await countTeamsEligible(db, body.groupId, group);
      if (eligibleCount >= TEAMS_MAX_ELIGIBLE) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_TOO_MANY_PARTICIPANTS",
          message: "Maximum participants reached"
        });
      }

      const participantRef = db.collection(groupPaths.participantsCol(body.groupId)).doc();
      const participantId = participantRef.id;
      const now = FieldValue.serverTimestamp();

      await participantRef.set({
        participantId,
        displayName,
        participantType: "teams_manual",
        state: "active",
        linkedUid: null,
        managedByUid: null,
        roleInGroup: "member",
        deliveryMode: "verbal",
        canReceiveDirectResult: false,
        subgroupId: null,
        source: "teams_manual_v1",
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

export const updateTeamsManualParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<UpdateTeamsManualParticipantResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(UpdateTeamsManualParticipantRequestSchema, req.data);
      const displayName = body.displayName.trim();
      if (displayName.length === 0 || displayName.length > 80) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_DISPLAY_NAME",
          message: "Invalid displayName"
        });
      }

      await requireTeamsOwnerEditableGroup(body.groupId, uid);

      const db = getDb();
      const ref = db.doc(`${groupPaths.participantsCol(body.groupId)}/${body.participantId}`);
      const snap = await ref.get();
      if (!snap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "PARTICIPANT_NOT_FOUND", message: "Participant not found" });
      }
      const d = snap.data() as { participantType?: string; state?: string };
      if (d.participantType !== "teams_manual") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_PARTICIPANT_TYPE",
          message: "Not a teams manual participant"
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

export const removeTeamsManualParticipant = onCall(
  async (req: CallableRequest<unknown>): Promise<RemoveTeamsManualParticipantResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(RemoveTeamsManualParticipantRequestSchema, req.data);

      await requireTeamsOwnerEditableGroup(body.groupId, uid);

      const db = getDb();
      const ref = db.doc(`${groupPaths.participantsCol(body.groupId)}/${body.participantId}`);
      const snap = await ref.get();
      if (!snap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "PARTICIPANT_NOT_FOUND", message: "Participant not found" });
      }
      const d = snap.data() as { participantType?: string };
      if (d.participantType !== "teams_manual") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_PARTICIPANT_TYPE",
          message: "Not a teams manual participant"
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
