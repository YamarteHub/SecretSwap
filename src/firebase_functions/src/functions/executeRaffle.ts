import { randomInt } from "crypto";
import { FieldValue } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import {
  ExecuteRaffleRequestSchema,
  ExecuteRaffleResponse,
  RaffleWinnerSnapshot
} from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";
import { notifyGroupDynamicCompleted } from "../shared/groupNotifications";
import { retentionPatchIfFirstRaffleCompletion } from "../shared/retention";

type Eligible = {
  participantId: string;
  displayName: string;
  sourceType: "app_member" | "raffle_manual";
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

export const executeRaffle = onCall(async (req: CallableRequest<unknown>): Promise<ExecuteRaffleResponse> => {
  try {
    const uid = requireAuthUid(req.auth?.uid);
    const body = parseOrThrow(ExecuteRaffleRequestSchema, req.data);
    const db = getDb();
    const groupRef = db.doc(groupPaths.groupDoc(body.groupId));

    const dupSnap = await db
      .collection(groupPaths.raffleExecutionsCol(body.groupId))
      .where("idempotencyKey", "==", body.idempotencyKey)
      .limit(1)
      .get();

    if (!dupSnap.empty) {
      const d = dupSnap.docs[0]!.data() as {
        winnerCount?: number;
        eligibleParticipantCount?: number;
        winnerParticipantIds?: string[];
        winnersSnapshot?: RaffleWinnerSnapshot[];
      };
      return {
        executionId: dupSnap.docs[0]!.id,
        winnerCount: typeof d.winnerCount === "number" ? d.winnerCount : 0,
        eligibleParticipantCount:
          typeof d.eligibleParticipantCount === "number" ? d.eligibleParticipantCount : 0,
        winnerParticipantIds: Array.isArray(d.winnerParticipantIds) ? d.winnerParticipantIds : [],
        winnersSnapshot: Array.isArray(d.winnersSnapshot) ? d.winnersSnapshot : []
      };
    }

    const retentionNow = new Date();
    const result = await db.runTransaction(async (tx) => {
      const groupSnap = await tx.get(groupRef);
      if (!groupSnap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
      }
      const group = groupSnap.data() as {
        ownerUid?: string;
        lifecycleStatus?: string;
        dynamicType?: string;
        raffleStatus?: string;
        raffleWinnerCount?: number;
        ownerParticipatesInRaffle?: boolean;
        name?: string;
        eventDate?: unknown;
      };

      if (group.ownerUid !== uid) {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "NOT_OWNER",
          message: "Only owner can execute raffle"
        });
      }
      if (group.lifecycleStatus === "archived") {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "GROUP_ARCHIVED",
          message: "Group is archived"
        });
      }
      if (parseDynamicType(group.dynamicType) !== "simple_raffle") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "RAFFLE_INVALID_DYNAMIC",
          message: "Not a raffle group"
        });
      }
      if (group.raffleStatus === "completed") {
        throw new AppError({
          code: "DRAW_ALREADY_COMPLETED",
          reasonCode: "RAFFLE_ALREADY_COMPLETED",
          message: "Raffle already completed"
        });
      }
      if (group.raffleStatus === "drawing") {
        throw new AppError({
          code: "INVITE_ERROR",
          reasonCode: "RAFFLE_IN_PROGRESS",
          message: "Raffle in progress"
        });
      }
      if (group.raffleStatus != null && group.raffleStatus !== "idle" && group.raffleStatus !== "failed") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "RAFFLE_INVALID_STATE",
          message: "Raffle cannot be executed in this state"
        });
      }

      const winnerCount =
        typeof group.raffleWinnerCount === "number" && group.raffleWinnerCount >= 1
          ? Math.floor(group.raffleWinnerCount)
          : 1;

      const membersSnap = await tx.get(db.collection(groupPaths.membersCol(body.groupId)));
      const participantsSnap = await tx.get(db.collection(groupPaths.participantsCol(body.groupId)));

      const ownerUid = typeof group.ownerUid === "string" ? group.ownerUid : "";
      const ownerParticipates = group.ownerParticipatesInRaffle !== false;

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
        if (d.participantType !== "raffle_manual") continue;
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
          sourceType: "raffle_manual"
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
          reasonCode: "RAFFLE_INSUFFICIENT_PARTICIPANTS",
          message: "Not enough eligible participants (minimum 2)"
        });
      }
      if (winnerCount > pool.length) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "RAFFLE_TOO_MANY_WINNERS",
          message: "Winner count exceeds eligible participants"
        });
      }

      const shuffled = fisherYatesShuffle(pool);
      const winners = shuffled.slice(0, winnerCount);
      const winnersSnapshot: RaffleWinnerSnapshot[] = winners.map((w) => ({
        participantId: w.participantId,
        displayName: w.displayName,
        sourceType: w.sourceType,
        ...(w.memberUid ? { memberUid: w.memberUid } : {})
      }));

      const executionRef = db.collection(groupPaths.raffleExecutionsCol(body.groupId)).doc();
      const executionId = executionRef.id;
      const nowTs = FieldValue.serverTimestamp();

      tx.set(executionRef, {
        executionId,
        idempotencyKey: body.idempotencyKey,
        winnerCount,
        eligibleParticipantCount: pool.length,
        winnerParticipantIds: winners.map((w) => w.participantId),
        winnersSnapshot,
        status: "success",
        createdAt: nowTs,
        createdByUid: uid
      });

      tx.update(groupRef, {
        raffleStatus: "completed",
        lastRaffleExecutionId: executionId,
        lastRaffleCompletedAt: nowTs,
        updatedAt: nowTs,
        ...retentionPatchIfFirstRaffleCompletion(group, retentionNow)
      });

      return {
        executionId,
        winnerCount,
        eligibleParticipantCount: pool.length,
        winnerParticipantIds: winners.map((w) => w.participantId),
        winnersSnapshot
      };
    });

    const groupSnapAfter = await groupRef.get();
    const groupName =
      typeof (groupSnapAfter.data() as { name?: string } | undefined)?.name === "string"
        ? ((groupSnapAfter.data() as { name?: string }).name ?? "").trim()
        : "";
    await notifyGroupDynamicCompleted(db, {
      groupId: body.groupId,
      dynamicType: "simple_raffle",
      groupName,
      triggeredByUid: uid
    });

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
