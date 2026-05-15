import { randomInt } from "crypto";
import { FieldValue } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import {
  ExecuteTeamsRequestSchema,
  ExecuteTeamsResponse,
  TEAMS_MAX_ELIGIBLE,
  TeamMemberSnapshot,
  TeamSnapshot
} from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";
import { appendGroupChatSystemMessageIfNew } from "../shared/groupChat";
import { notifyGroupDynamicCompleted } from "../shared/groupNotifications";
import { buildRetentionFirestoreUpdate, readEventDate } from "../shared/retention";

type TeamsPresetRun = "standard" | "pairings" | "duels";

function parseTeamsPresetRun(raw?: string): TeamsPresetRun {
  const s = typeof raw === "string" ? raw.trim() : "";
  if (s === "pairings") return "pairings";
  if (s === "duels") return "duels";
  return "standard";
}

function isSizedPairPreset(preset: TeamsPresetRun): boolean {
  return preset === "pairings" || preset === "duels";
}

type Eligible = {
  participantId: string;
  displayName: string;
  sourceType: "app_member" | "teams_manual";
  memberUid?: string;
};

function fisherYatesShuffle<T>(items: T[]): T[] {
  const a = [...items];
  for (let i = a.length - 1; i > 0; i--) {
    const j = randomInt(0, i + 1);
    const t = a[i]!;
    a[i] = a[j]!;
    a[j] = t;
  }
  return a;
}

function parseDynamicType(raw: unknown): string {
  const s = typeof raw === "string" ? raw.trim() : "";
  return s.length > 0 ? s : "secret_santa";
}

function resolveNumTeams(
  poolSize: number,
  groupingMode: string,
  requestedTeamCount: number | undefined,
  requestedTeamSize: number | undefined
): number {
  if (groupingMode === "team_count") {
    return requestedTeamCount ?? 2;
  }
  const k = requestedTeamSize ?? 2;
  return Math.ceil(poolSize / k);
}

function buildTeamsSnapshot(shuffled: Eligible[], numTeams: number): TeamSnapshot[] {
  const buckets: Eligible[][] = Array.from({ length: numTeams }, () => []);
  for (let i = 0; i < shuffled.length; i++) {
    buckets[i % numTeams]!.push(shuffled[i]!);
  }
  return buckets.map((members, teamIndex) => ({
    teamIndex,
    teamLabel: `Team ${teamIndex + 1}`,
    members: members.map(
      (m): TeamMemberSnapshot => ({
        participantId: m.participantId,
        displayName: m.displayName,
        sourceType: m.sourceType,
        ...(m.memberUid ? { memberUid: m.memberUid } : {})
      })
    )
  }));
}

export const executeTeams = onCall(async (req: CallableRequest<unknown>): Promise<ExecuteTeamsResponse> => {
  try {
    const uid = requireAuthUid(req.auth?.uid);
    const body = parseOrThrow(ExecuteTeamsRequestSchema, req.data);
    const db = getDb();
    const groupRef = db.doc(groupPaths.groupDoc(body.groupId));

    const dupSnap = await db
      .collection(groupPaths.teamExecutionsCol(body.groupId))
      .where("idempotencyKey", "==", body.idempotencyKey)
      .limit(1)
      .get();

    if (!dupSnap.empty) {
      const d = dupSnap.docs[0]!.data() as {
        eligibleParticipantCount?: number;
        teamCount?: number;
        teamsSnapshot?: TeamSnapshot[];
      };
      return {
        executionId: dupSnap.docs[0]!.id,
        eligibleParticipantCount:
          typeof d.eligibleParticipantCount === "number" ? d.eligibleParticipantCount : 0,
        teamCount: typeof d.teamCount === "number" ? d.teamCount : 0,
        teamsSnapshot: Array.isArray(d.teamsSnapshot) ? d.teamsSnapshot : []
      };
    }

    const result = await db.runTransaction(async (tx) => {
      const groupSnap = await tx.get(groupRef);
      if (!groupSnap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
      }
      const group = groupSnap.data() as {
        ownerUid?: string;
        lifecycleStatus?: string;
        dynamicType?: string;
        teamStatus?: string;
        teamsPreset?: string;
        groupingMode?: string;
        requestedTeamCount?: number;
        requestedTeamSize?: number;
        ownerParticipatesInTeams?: boolean;
        eventDate?: unknown;
      };
      const teamsPreset = parseTeamsPresetRun(group.teamsPreset);

      if (group.ownerUid !== uid) {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "NOT_OWNER",
          message: "Only owner can form teams"
        });
      }
      if (group.lifecycleStatus === "archived") {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "GROUP_ARCHIVED",
          message: "Group is archived"
        });
      }
      if (parseDynamicType(group.dynamicType) !== "teams") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_INVALID_DYNAMIC",
          message: "Not a teams group"
        });
      }
      if (group.teamStatus === "completed") {
        throw new AppError({
          code: "DRAW_ALREADY_COMPLETED",
          reasonCode: "TEAMS_ALREADY_COMPLETED",
          message: "Teams already formed"
        });
      }
      if (group.teamStatus === "generating") {
        throw new AppError({
          code: "INVITE_ERROR",
          reasonCode: "TEAMS_IN_PROGRESS",
          message: "Teams formation in progress"
        });
      }
      if (group.teamStatus != null && group.teamStatus !== "idle" && group.teamStatus !== "failed") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_INVALID_STATE",
          message: "Teams cannot be formed in this state"
        });
      }

      const groupingMode =
        typeof group.groupingMode === "string" && group.groupingMode.trim() !== ""
          ? group.groupingMode.trim()
          : "team_count";
      const requestedTeamCount =
        typeof group.requestedTeamCount === "number" ? Math.floor(group.requestedTeamCount) : undefined;
      const requestedTeamSize =
        typeof group.requestedTeamSize === "number" ? Math.floor(group.requestedTeamSize) : undefined;

      if (groupingMode === "team_count") {
        if (requestedTeamCount == null || requestedTeamCount < 2) {
          throw new AppError({
            code: "VALIDATION_ERROR",
            reasonCode: "TEAMS_INVALID_CONFIGURATION",
            message: "Invalid team count configuration"
          });
        }
      } else if (requestedTeamSize == null || requestedTeamSize < 2) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_INVALID_CONFIGURATION",
          message: "Invalid team size configuration"
        });
      }

      const membersSnap = await tx.get(db.collection(groupPaths.membersCol(body.groupId)));
      const participantsSnap = await tx.get(db.collection(groupPaths.participantsCol(body.groupId)));

      const ownerUid = typeof group.ownerUid === "string" ? group.ownerUid : "";
      const ownerParticipates = group.ownerParticipatesInTeams !== false;

      const eligible: Eligible[] = [];

      for (const doc of membersSnap.docs) {
        const d = doc.data() as Record<string, unknown>;
        if (d.memberState !== "active") continue;
        const muid =
          typeof d.uid === "string" && d.uid.trim() !== "" ? d.uid.trim() : doc.id;
        if (!ownerParticipates && muid === ownerUid) {
          continue;
        }
        const nickname =
          typeof d.nickname === "string" && d.nickname.trim() !== "" ? d.nickname.trim() : "Miembro";
        eligible.push({
          participantId: muid,
          displayName: nickname,
          sourceType: "app_member",
          memberUid: muid
        });
      }

      for (const doc of participantsSnap.docs) {
        const d = doc.data() as Record<string, unknown>;
        if (d.state !== "active") continue;
        if (d.participantType !== "teams_manual") continue;
        const pid =
          typeof d.participantId === "string" && d.participantId.trim() !== ""
            ? d.participantId.trim()
            : doc.id;
        const displayName =
          typeof d.displayName === "string" && d.displayName.trim() !== ""
            ? d.displayName.trim()
            : "Participante";
        eligible.push({
          participantId: pid,
          displayName,
          sourceType: "teams_manual"
        });
      }

      const dedup = new Map<string, Eligible>();
      for (const e of eligible) {
        dedup.set(e.participantId, e);
      }
      const pool = [...dedup.values()].sort((a, b) => a.participantId.localeCompare(b.participantId));

      if (pool.length < 2) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_INSUFFICIENT_PARTICIPANTS",
          message: "Not enough eligible participants (minimum 2)"
        });
      }
      if (isSizedPairPreset(teamsPreset) && pool.length % 2 !== 0) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode:
            teamsPreset === "duels"
              ? "DUELS_REQUIRES_EVEN_PARTICIPANTS"
              : "PAIRINGS_REQUIRES_EVEN_PARTICIPANTS",
          message: "Requires an even number of eligible participants"
        });
      }
      if (pool.length > TEAMS_MAX_ELIGIBLE) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_TOO_MANY_PARTICIPANTS",
          message: "Too many eligible participants"
        });
      }

      const numTeams = resolveNumTeams(pool.length, groupingMode, requestedTeamCount, requestedTeamSize);

      if (!isSizedPairPreset(teamsPreset) && numTeams < 2) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_INVALID_CONFIGURATION",
          message: "Must form at least 2 teams"
        });
      }
      if (groupingMode === "team_count" && numTeams > pool.length) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_INVALID_CONFIGURATION",
          message: "Team count exceeds eligible participants"
        });
      }
      if (groupingMode === "team_size" && requestedTeamSize != null && requestedTeamSize > pool.length) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_INVALID_CONFIGURATION",
          message: "Team size exceeds eligible participants"
        });
      }

      const shuffled = fisherYatesShuffle(pool);
      const teamsSnapshot = buildTeamsSnapshot(shuffled, numTeams);

      const executionRef = db.collection(groupPaths.teamExecutionsCol(body.groupId)).doc();
      const executionId = executionRef.id;
      const nowTs = FieldValue.serverTimestamp();
      const retentionNow = new Date();

      tx.set(executionRef, {
        executionId,
        idempotencyKey: body.idempotencyKey,
        groupingMode,
        ...(groupingMode === "team_count"
          ? { requestedTeamCount }
          : { requestedTeamSize }),
        eligibleParticipantCount: pool.length,
        teamCount: numTeams,
        teamsSnapshot,
        status: "success",
        createdAt: nowTs,
        createdByUid: uid
      });

      tx.update(groupRef, {
        teamStatus: "completed",
        lastTeamExecutionId: executionId,
        lastTeamCompletedAt: nowTs,
        updatedAt: nowTs,
        ...buildRetentionFirestoreUpdate({
          completedAt: retentionNow,
          eventDate: readEventDate(group.eventDate)
        })
      });

      return {
        executionId,
        eligibleParticipantCount: pool.length,
        teamCount: numTeams,
        teamsSnapshot
      };
    });

    const groupSnapAfter = await groupRef.get();
    const groupName =
      typeof (groupSnapAfter.data() as { name?: string } | undefined)?.name === "string"
        ? ((groupSnapAfter.data() as { name?: string }).name ?? "").trim()
        : "";
    const groupDataAfter = groupSnapAfter.data() as { teamsPreset?: string };
    const teamsPresetAfter = parseTeamsPresetRun(groupDataAfter.teamsPreset);

    await notifyGroupDynamicCompleted(db, {
      groupId: body.groupId,
      dynamicType: "teams",
      teamsPreset: teamsPresetAfter,
      groupName,
      triggeredByUid: uid
    });

    try {
      const chatTemplateKey =
        teamsPresetAfter === "duels"
          ? "chat.system.duelsCompleted.v1"
          : teamsPresetAfter === "pairings"
            ? "chat.system.pairingsCompleted.v1"
            : "chat.system.teamsCompleted.v1";
      const chatDocId =
        teamsPresetAfter === "duels"
          ? `system_duelsCompleted_${result.executionId}`
          : teamsPresetAfter === "pairings"
            ? `system_pairingsCompleted_${result.executionId}`
            : `system_teamsCompleted_${result.executionId}`;
      await appendGroupChatSystemMessageIfNew(db, body.groupId, chatDocId, chatTemplateKey);
    } catch (e) {
      logger.warn("executeTeams: teamsCompleted chat message failed", {
        groupId: body.groupId,
        executionId: result.executionId,
        err: e
      });
    }

    return result;
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
});
