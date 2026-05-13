import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import {
  GetManagedAssignmentsRequestSchema,
  GetManagedAssignmentsResponse
} from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";

type ParticipantDoc = {
  participantId?: unknown;
  displayName?: unknown;
  participantType?: unknown;
  linkedUid?: unknown;
  managedByUid?: unknown;
  roleInGroup?: unknown;
  state?: unknown;
  subgroupId?: unknown;
  deliveryMode?: unknown;
};

function parseStringOrNull(raw: unknown): string | null {
  if (typeof raw !== "string") return null;
  const s = raw.trim();
  return s.length > 0 ? s : null;
}

function isManagedType(raw: unknown): raw is "managed" | "child_managed" {
  return raw === "managed" || raw === "child_managed";
}

function isMemberActive(raw: unknown): boolean {
  return raw === "active";
}

export const getManagedAssignments = onCall(
  async (req: CallableRequest<unknown>): Promise<GetManagedAssignmentsResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(GetManagedAssignmentsRequestSchema, req.data);
      const db = getDb();

      const groupRef = db.doc(groupPaths.groupDoc(body.groupId));
      const executionRef = db.doc(groupPaths.executionDoc(body.groupId, body.executionId));
      const callerMemberRef = db.doc(groupPaths.memberDoc(body.groupId, uid));

      const [groupSnap, executionSnap, callerMemberSnap] = await Promise.all([
        groupRef.get(),
        executionRef.get(),
        callerMemberRef.get()
      ]);

      if (!groupSnap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
      }
      if (!executionSnap.exists) {
        throw new AppError({
          code: "NOT_FOUND",
          reasonCode: "EXECUTION_NOT_FOUND",
          message: "Execution not found"
        });
      }

      const groupData = groupSnap.data() as { ownerUid?: unknown; drawStatus?: unknown };
      const ownerUid = parseStringOrNull(groupData.ownerUid);
      if (!ownerUid) {
        throw new AppError({ code: "INTERNAL", message: "Group owner is missing" });
      }
      if (groupData.drawStatus !== "completed") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "DRAW_NOT_COMPLETED",
          message: "Draw is not completed"
        });
      }

      const isOwner = ownerUid === uid;
      const isActiveMember = callerMemberSnap.exists && isMemberActive(callerMemberSnap.data()?.memberState);
      if (!isOwner && !isActiveMember) {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "NOT_ACTIVE_MEMBER",
          message: "Caller is not an active member"
        });
      }

      const participantsSnap = await db.collection(`groups/${body.groupId}/participants`).get();
      const managedByParticipantId = new Map<
        string,
        {
          displayName: string;
          giverType: "managed" | "child_managed";
          deliveryMode: "verbal" | "printed" | "ownerDelegated" | "whatsapp" | "email";
        }
      >();

      for (const doc of participantsSnap.docs) {
        const p = doc.data() as ParticipantDoc;
        if (p.state !== "active") continue;
        if (!isManagedType(p.participantType)) continue;

        const participantId = parseStringOrNull(p.participantId) ?? doc.id;
        const displayName = parseStringOrNull(p.displayName) ?? "Participante";
        const managedByUid = parseStringOrNull(p.managedByUid);
        const resolvedResponsibleUid = managedByUid ?? ownerUid;
        if (resolvedResponsibleUid !== uid) continue;

        const deliveryMode =
          p.deliveryMode === "verbal" ||
          p.deliveryMode === "printed" ||
          p.deliveryMode === "ownerDelegated" ||
          p.deliveryMode === "whatsapp" ||
          p.deliveryMode === "email"
            ? p.deliveryMode
            : "ownerDelegated";

        managedByParticipantId.set(participantId, {
          displayName,
          giverType: p.participantType,
          deliveryMode
        });
      }

      if (managedByParticipantId.size === 0) {
        return { assignments: [] };
      }

      const assignmentsSnap = await db.collection(groupPaths.assignmentsCol(body.groupId, body.executionId)).get();
      const assignments: GetManagedAssignmentsResponse["assignments"] = [];

      for (const doc of assignmentsSnap.docs) {
        const a = doc.data() as Record<string, unknown>;
        const giverType = a.giverType;
        if (!isManagedType(giverType)) continue;

        const giverParticipantId = parseStringOrNull(a.giverParticipantId);
        if (!giverParticipantId) continue;
        const giverMeta = managedByParticipantId.get(giverParticipantId);
        if (!giverMeta) continue;

        const receiverDisplayName =
          parseStringOrNull(a.receiverDisplayNameSnapshot) ??
          parseStringOrNull(a.receiverNicknameSnapshot) ??
          "Participante";
        const receiverTypeRaw = parseStringOrNull(a.receiverType) ?? "app_member";
        const receiverType =
          receiverTypeRaw === "managed" || receiverTypeRaw === "child_managed" ? receiverTypeRaw : "app_member";

        const receiverParticipantId = parseStringOrNull(a.receiverParticipantId);
        if (!receiverParticipantId) continue;

        assignments.push({
          giverParticipantId,
          giverDisplayName: giverMeta.displayName,
          giverType: giverMeta.giverType,
          receiverParticipantId,
          receiverDisplayName,
          receiverType,
          receiverSubgroupName: parseStringOrNull(a.receiverSubgroupNameSnapshot),
          deliveryMode: giverMeta.deliveryMode,
          managedByCurrentUser: true
        });
      }

      assignments.sort((a, b) => a.giverDisplayName.localeCompare(b.giverDisplayName));
      return { assignments };
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

