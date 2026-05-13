import { FieldValue } from "firebase-admin/firestore";
import type { Firestore, QueryDocumentSnapshot } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import {
  computeMatching,
  DrawParticipant,
  SubgroupModeNorm
} from "../shared/drawMatching";
import {
  ExecuteDrawRequestSchema,
  ExecuteDrawResponse,
  ExecuteDrawSummary,
  ExecutionStatusSchema
} from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { acquireDrawingLock, clearDrawingLock } from "../shared/lock";
import { parseOrThrow } from "../shared/validation";

function assignmentsCollection(db: Firestore, groupId: string, executionId: string) {
  return db.collection("groups").doc(groupId).collection("executions").doc(executionId).collection("assignments");
}

function summarySubgroupLabel(mode: SubgroupModeNorm): string {
  return mode;
}

function normalizeSubgroupMode(raw: unknown): SubgroupModeNorm {
  const s = typeof raw === "string" ? raw.trim() : "";
  if (s === "ignore") return "ignore";
  if (s === "different" || s === "requireDifferent") return "different";
  if (s === "preferDifferent") return "preferDifferent";
  throw new AppError({
    code: "VALIDATION_ERROR",
    reasonCode: "INVALID_SUBGROUP_MODE",
    message: "Invalid rules.subgroupMode"
  });
}

type ParticipantType = "app_member" | "managed" | "child_managed";
type DeliveryMode = "inApp" | "ownerDelegated" | "verbal" | "printed" | "whatsapp" | "email";
type RoleInGroup = "owner" | "member";
type DrawParticipantSource = "member_projection" | "participants_doc";

type UnifiedDrawParticipant = DrawParticipant & {
  linkedUid: string | null;
  participantType: ParticipantType;
  deliveryMode: DeliveryMode;
  canReceiveDirectResult: boolean;
  roleInGroup: RoleInGroup;
  source: DrawParticipantSource;
};

function validateSubgroupPreconditions(mode: SubgroupModeNorm, participants: DrawParticipant[]) {
  if (mode !== "different") return;
  for (const p of participants) {
    if (p.subgroupId == null || p.subgroupId.trim() === "") {
      throw new AppError({
        code: "VALIDATION_ERROR",
        reasonCode: "SUBGROUP_REQUIRED",
        message: "All active members must have subgroupId for this rules mode"
      });
    }
  }
}

function parseSubgroupId(raw: unknown): string | null {
  if (typeof raw === "string" && raw.trim() !== "") return raw.trim();
  if (raw != null) {
    const s = String(raw).trim();
    if (s !== "") return s;
  }
  return null;
}

function parseRoleInGroup(raw: unknown): RoleInGroup {
  return raw === "owner" ? "owner" : "member";
}

function parseParticipantType(raw: unknown): ParticipantType | null {
  const s = typeof raw === "string" ? raw.trim() : "";
  if (s === "app_member" || s === "managed" || s === "child_managed") return s;
  return null;
}

function parseDeliveryMode(raw: unknown, fallback: DeliveryMode): DeliveryMode {
  const s = typeof raw === "string" ? raw.trim() : "";
  if (
    s === "inApp" ||
    s === "ownerDelegated" ||
    s === "verbal" ||
    s === "printed" ||
    s === "whatsapp" ||
    s === "email"
  )
    return s;
  return fallback;
}

async function loadDrawParticipants(groupId: string, db: Firestore): Promise<UnifiedDrawParticipant[]> {
  const [membersSnap, participantsSnap] = await Promise.all([
    db.collection("groups").doc(groupId).collection("members").get(),
    db.collection("groups").doc(groupId).collection("participants").get()
  ]);

  const membersByUid = new Map<string, UnifiedDrawParticipant>();
  for (const doc of membersSnap.docs) {
    const d = doc.data() as Record<string, unknown>;
    if (d.memberState !== "active") continue;
    const uid = typeof d.uid === "string" && d.uid.trim() !== "" ? d.uid.trim() : doc.id;
    const displayName =
      typeof d.nickname === "string" && d.nickname.trim() !== "" ? d.nickname.trim() : "Miembro";
    membersByUid.set(uid, {
      participantId: uid,
      displayName,
      linkedUid: uid,
      subgroupId: parseSubgroupId(d.subgroupId),
      participantType: "app_member",
      deliveryMode: "inApp",
      canReceiveDirectResult: true,
      roleInGroup: parseRoleInGroup(d.role),
      source: "member_projection"
    });
  }

  const participantDocs: UnifiedDrawParticipant[] = [];
  for (const doc of participantsSnap.docs) {
    const d = doc.data() as Record<string, unknown>;
    if (d.state !== "active") continue;
    const participantType = parseParticipantType(d.participantType);
    if (!participantType) continue;
    const participantId =
      typeof d.participantId === "string" && d.participantId.trim() !== ""
        ? d.participantId.trim()
        : doc.id;
    const linkedUid =
      typeof d.linkedUid === "string" && d.linkedUid.trim() !== "" ? d.linkedUid.trim() : null;
    const displayName =
      typeof d.displayName === "string" && d.displayName.trim() !== ""
        ? d.displayName.trim()
        : "Participante";
    participantDocs.push({
      participantId,
      displayName,
      linkedUid,
      subgroupId: parseSubgroupId(d.subgroupId),
      participantType,
      deliveryMode: parseDeliveryMode(d.deliveryMode, linkedUid ? "inApp" : "ownerDelegated"),
      canReceiveDirectResult: d.canReceiveDirectResult === true,
      roleInGroup: parseRoleInGroup(d.roleInGroup),
      source: "participants_doc"
    });
  }

  const finalByParticipantId = new Map<string, UnifiedDrawParticipant>();
  for (const member of membersByUid.values()) {
    finalByParticipantId.set(member.participantId, member);
  }
  for (const participant of participantDocs) {
    if (participant.linkedUid != null) {
      membersByUid.delete(participant.linkedUid);
      finalByParticipantId.delete(participant.linkedUid);
    }
    finalByParticipantId.set(participant.participantId, participant);
  }
  return [...finalByParticipantId.values()].sort((a, b) => a.participantId.localeCompare(b.participantId));
}

function buildResolvedExclusionSet(raw: unknown, participants: UnifiedDrawParticipant[]): Set<string> {
  const set = new Set<string>();
  if (!Array.isArray(raw)) return set;

  const participantById = new Map(participants.map((p) => [p.participantId, p]));
  const participantIdByUid = new Map<string, string>();
  for (const p of participants) {
    if (p.linkedUid != null && p.linkedUid !== "") {
      participantIdByUid.set(p.linkedUid, p.participantId);
    }
  }

  for (const item of raw) {
    if (!item || typeof item !== "object") continue;
    const o = item as Record<string, unknown>;
    const giverRaw = o.giverParticipantId ?? o.giverId ?? o.giverUid ?? o.giver;
    const receiverRaw = o.receiverParticipantId ?? o.receiverId ?? o.receiverUid ?? o.receiver;
    const giverKey = typeof giverRaw === "string" ? giverRaw.trim() : "";
    const receiverKey = typeof receiverRaw === "string" ? receiverRaw.trim() : "";
    if (giverKey === "" || receiverKey === "") continue;

    const giverParticipantId =
      participantById.has(giverKey) ? giverKey : participantIdByUid.get(giverKey);
    const receiverParticipantId =
      participantById.has(receiverKey) ? receiverKey : participantIdByUid.get(receiverKey);

    if (!giverParticipantId || !receiverParticipantId) {
      console.warn(
        `[executeDraw] exclusion not mappable to participant ids: giver="${giverKey}" receiver="${receiverKey}"`
      );
      continue;
    }
    set.add(`${giverParticipantId}|${receiverParticipantId}`);
  }
  return set;
}

async function loadSubgroupNamesById(groupId: string, db: Firestore): Promise<Map<string, string>> {
  const snap = await db.collection("groups").doc(groupId).collection("subgroups").get();
  const out = new Map<string, string>();
  for (const doc of snap.docs) {
    const d = doc.data() as { subgroupId?: unknown; name?: unknown };
    const subgroupId =
      typeof d.subgroupId === "string" && d.subgroupId.trim() !== ""
        ? d.subgroupId.trim()
        : doc.id;
    const name =
      typeof d.name === "string" && d.name.trim() !== ""
        ? d.name.trim()
        : "";
    if (name.length > 0) {
      out.set(subgroupId, name);
    }
  }
  return out;
}

function isAlreadyExistsError(e: unknown): boolean {
  return typeof e === "object" && e !== null && (e as { code?: number }).code === 6;
}

function internalMatchFromAssignments(
  participantById: Map<string, UnifiedDrawParticipant>,
  assignmentDocs: QueryDocumentSnapshot[]
): number {
  let c = 0;
  for (const d of assignmentDocs) {
    const data = d.data();
    const giverIdRaw = data.giverParticipantId ?? d.id;
    const giverId = typeof giverIdRaw === "string" ? giverIdRaw : String(giverIdRaw);
    const giver = participantById.get(giverId);
    const gSub = giver?.subgroupId ?? null;
    const rSub =
      data.receiverSubgroupIdSnapshot === undefined || data.receiverSubgroupIdSnapshot === null
        ? null
        : String(data.receiverSubgroupIdSnapshot);
    if (gSub != null && rSub !== "" && rSub != null && gSub === rSub) c++;
  }
  return c;
}

/** Si la ejecución ya terminó en éxito pero el grupo quedó en `drawing`, libera el lock (recuperación). */
async function ensureGroupNotStuckInDrawing(db: Firestore, groupId: string, executionId: string): Promise<void> {
  const groupRef = db.doc(groupPaths.groupDoc(groupId));
  const gs = await groupRef.get();
  const g = gs.data() as {
    drawStatus?: string;
    drawingLock?: { executionId?: string } | null;
  } | undefined;
  if (g?.drawStatus === "drawing" && g?.drawingLock?.executionId === executionId) {
    await clearDrawingLock({
      groupId,
      nextDrawStatus: "completed",
      currentExecutionId: executionId,
      lastExecutionId: executionId
    });
  }
}

function buildSuccessExecuteDrawResponse(
  executionId: string,
  rulesVersion: number,
  raw: Record<string, unknown>
): ExecuteDrawResponse {
  const summary = raw.summary as ExecuteDrawSummary | undefined;
  if (!summary) {
    throw new AppError({ code: "INTERNAL", message: "Execution success without summary" });
  }
  return {
    executionId,
    status: ExecutionStatusSchema.enum.success,
    rulesVersion,
    summary,
    finishedAt: raw.finishedAt ?? raw.completedAt
  };
}

export const executeDraw = onCall(async (req: CallableRequest<unknown>): Promise<ExecuteDrawResponse> => {
  const uid = requireAuthUid(req.auth?.uid);
  const body = parseOrThrow(ExecuteDrawRequestSchema, req.data);
  const db = getDb();
  const groupRef = db.doc(groupPaths.groupDoc(body.groupId));

  let lockHeldForExecution: { executionId: string } | null = null;

  try {
    const groupSnap = await groupRef.get();
    if (!groupSnap.exists) {
      throw new AppError({ code: "NOT_FOUND", message: "Group not found" });
    }
    const group = groupSnap.data() as {
      ownerUid: string;
      lifecycleStatus?: string;
      rulesVersionCurrent: number;
      drawStatus?: string;
    };
    if (group.ownerUid !== uid) {
      throw new AppError({ code: "FORBIDDEN", message: "Only owner can execute draw in MVP" });
    }
    if (group.drawStatus === "completed") {
      throw new AppError({
        code: "DRAW_ALREADY_COMPLETED",
        reasonCode: "DRAW_ALREADY_COMPLETED",
        message: "Draw already completed for this group"
      });
    }
    if (group.lifecycleStatus === "archived") {
      throw new AppError({
        code: "FORBIDDEN",
        reasonCode: "GROUP_ARCHIVED",
        message: "Group is archived"
      });
    }

    const participants = await loadDrawParticipants(body.groupId, db);
    const subgroupNamesById = await loadSubgroupNamesById(body.groupId, db);
    const n = participants.length;
    if (n < 2) {
      throw new AppError({
        code: "VALIDATION_ERROR",
        reasonCode: "INSUFFICIENT_ACTIVE_MEMBERS",
        message: "At least two active participants are required"
      });
    }

    const rulesRef = db.doc(groupPaths.ruleDoc(body.groupId, group.rulesVersionCurrent));
    const rulesSnap = await rulesRef.get();
    if (!rulesSnap.exists) {
      throw new AppError({
        code: "NOT_FOUND",
        reasonCode: "RULES_NOT_FOUND",
        message: "Rules version not found for group"
      });
    }
    const rulesData = rulesSnap.data() as Record<string, unknown>;
    const subgroupMode = normalizeSubgroupMode(rulesData.subgroupMode);
    const exclusions = buildResolvedExclusionSet(rulesData.exclusions, participants);
    validateSubgroupPreconditions(subgroupMode, participants);

    const participantById = new Map(participants.map((p) => [p.participantId, p]));

    const dupSnap = await db
      .collection("groups")
      .doc(body.groupId)
      .collection("executions")
      .where("idempotencyKey", "==", body.idempotencyKey)
      .limit(1)
      .get();

    if (!dupSnap.empty) {
      const edoc = dupSnap.docs[0]!;
      const eid = edoc.id;
      const d = edoc.data() as { status: string; rulesVersion: number };
      const col = assignmentsCollection(db, body.groupId, eid);
      const ac = await col.get();

      if (d.status === "success") {
        if (ac.size !== n) {
          throw new AppError({
            code: "INTERNAL",
            reasonCode: "ASSIGNMENTS_INCOMPLETE",
            message: "Execution marked success but assignments are missing"
          });
        }
        await ensureGroupNotStuckInDrawing(db, body.groupId, eid);
        return buildSuccessExecuteDrawResponse(eid, d.rulesVersion, edoc.data() as Record<string, unknown>);
      }
      if (d.status === "failed") {
        const raw = edoc.data() as Record<string, unknown>;
        const failure = raw.failure as { reasonCode?: string; message?: string } | undefined;
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: failure?.reasonCode ?? String(raw.errorCode ?? "DRAW_FAILED"),
          message: failure?.message ?? "Draw failed"
        });
      }
      if (d.status === "running" && group.drawStatus !== "drawing") {
        throw new AppError({
          code: "INTERNAL",
          reasonCode: "ORPHAN_EXECUTION",
          message: "Execution is running but group is not in drawing state; requires manual cleanup"
        });
      }
    }

    const lockRes = await acquireDrawingLock({
      groupId: body.groupId,
      requestedByUid: uid,
      idempotencyKey: body.idempotencyKey
    });

    if (!dupSnap.empty) {
      const priorId = dupSnap.docs[0]!.id;
      if (priorId !== lockRes.executionId) {
        throw new AppError({
          code: "INTERNAL",
          reasonCode: "EXECUTION_ID_MISMATCH",
          message: "Idempotency execution does not match active lock"
        });
      }
    }

    const executionId = lockRes.executionId;
    const rulesVersion = lockRes.rulesVersion;

    const executionRef = db.doc(groupPaths.executionDoc(body.groupId, executionId));
    const assignCol = assignmentsCollection(db, body.groupId, executionId);

    lockHeldForExecution = { executionId };

    let exSnap = await executionRef.get();
    if (!exSnap.exists) {
      const now = FieldValue.serverTimestamp();
      try {
        await executionRef.create({
          executionId,
          groupId: body.groupId,
          rulesVersion,
          idempotencyKey: body.idempotencyKey,
          status: ExecutionStatusSchema.enum.running,
          memberCount: 0,
          requestedByUid: uid,
          createdAt: now,
          startedAt: now,
          completedAt: null,
          finishedAt: null,
          errorCode: null,
          failure: null,
          summary: null
        });
      } catch (e: unknown) {
        if (!isAlreadyExistsError(e)) throw e;
      }
      exSnap = await executionRef.get();
    }

    if (!exSnap.exists) {
      throw new AppError({ code: "INTERNAL", message: "Execution document missing after lock" });
    }

    const exData = exSnap.data() as { status: string; rulesVersion: number };
    let assignSnap = await assignCol.get();
    const assignCount = assignSnap.size;

    if (exData.status === "success") {
      if (assignCount !== n) {
        throw new AppError({
          code: "INTERNAL",
          reasonCode: "ASSIGNMENTS_INCOMPLETE",
          message: "Execution marked success but assignments are missing"
        });
      }
      await ensureGroupNotStuckInDrawing(db, body.groupId, executionId);
      lockHeldForExecution = null;
      return buildSuccessExecuteDrawResponse(executionId, exData.rulesVersion, exSnap.data() as Record<string, unknown>);
    }

    if (exData.status === "failed") {
      const raw = exSnap.data() as Record<string, unknown>;
      const failure = raw.failure as { reasonCode?: string; message?: string } | undefined;
      const gs = await groupRef.get();
      const g = gs.data() as {
        drawStatus?: string;
        drawingLock?: { executionId?: string } | null;
      } | undefined;
      if (g?.drawStatus === "drawing" && g?.drawingLock?.executionId === executionId) {
        await clearDrawingLock({
          groupId: body.groupId,
          nextDrawStatus: "failed",
          lastExecutionId: executionId
        });
      }
      lockHeldForExecution = null;
      throw new AppError({
        code: "VALIDATION_ERROR",
        reasonCode: failure?.reasonCode ?? String(raw.errorCode ?? "DRAW_FAILED"),
        message: failure?.message ?? "Draw failed"
      });
    }

    if (assignCount > 0 && assignCount < n) {
      throw new AppError({
        code: "INTERNAL",
        reasonCode: "PARTIAL_ASSIGNMENTS",
        message: "Execution has partial assignments; cannot complete automatically"
      });
    }

    if (assignCount === n) {
      const nowTs = FieldValue.serverTimestamp();
      const summary: ExecuteDrawSummary = {
        participantCount: n,
        subgroupMode: summarySubgroupLabel(subgroupMode),
        internalMatchCount: internalMatchFromAssignments(participantById, assignSnap.docs)
      };
      await db.runTransaction(async (tx) => {
        const [gSnap, eSnap] = await Promise.all([tx.get(groupRef), tx.get(executionRef)]);
        const lock = gSnap.data()?.drawingLock as { executionId?: string; idempotencyKey?: string } | undefined;
        if (!lock || lock.executionId !== executionId || lock.idempotencyKey !== body.idempotencyKey) {
          throw new AppError({ code: "DRAW_IN_PROGRESS", message: "Draw lock lost" });
        }
        const ed = eSnap.data() as { status?: string } | undefined;
        if (ed?.status === "success") {
          return;
        }
        if (ed?.status !== "running") {
          throw new AppError({ code: "INTERNAL", message: "Unexpected execution state in repair transaction" });
        }
        tx.update(executionRef, {
          status: ExecutionStatusSchema.enum.success,
          memberCount: n,
          completedAt: nowTs,
          finishedAt: nowTs,
          errorCode: null,
          failure: null,
          summary
        });
        tx.update(groupRef, {
          drawStatus: "completed",
          drawingLock: null,
          currentExecutionId: executionId,
          lastExecutionId: executionId,
          updatedAt: FieldValue.serverTimestamp()
        });
      });

      lockHeldForExecution = null;
      const finalSnap = await executionRef.get();
      const fd = finalSnap.data() as Record<string, unknown>;
      if ((fd.status as string) !== "success") {
        throw new AppError({ code: "INTERNAL", message: "Repair transaction did not complete execution" });
      }
      return buildSuccessExecuteDrawResponse(executionId, rulesVersion, fd);
    }

    const seedInput = `${body.idempotencyKey}:${body.groupId}:${executionId}`;
    const matching = computeMatching(participants, subgroupMode, exclusions, seedInput, 300);
    if (!matching) {
      const now = FieldValue.serverTimestamp();
      const failSummary: ExecuteDrawSummary = {
        participantCount: n,
        subgroupMode: summarySubgroupLabel(subgroupMode),
        internalMatchCount: 0
      };
      await executionRef.update({
        status: ExecutionStatusSchema.enum.failed,
        memberCount: n,
        completedAt: now,
        finishedAt: now,
        errorCode: "NO_PERFECT_MATCHING",
        failure: {
          reasonCode: "NO_PERFECT_MATCHING",
          message: "No valid assignment found for the given constraints"
        },
        summary: failSummary
      });
      await clearDrawingLock({
        groupId: body.groupId,
        nextDrawStatus: "failed",
        lastExecutionId: executionId
      });
      lockHeldForExecution = null;
      throw new AppError({
        code: "VALIDATION_ERROR",
        reasonCode: "NO_PERFECT_MATCHING",
        message: "No valid assignment found for the given constraints"
      });
    }

    const { receiversByGiverParticipantId, internalMatchCount } = matching;
    const summary: ExecuteDrawSummary = {
      participantCount: n,
      subgroupMode: summarySubgroupLabel(subgroupMode),
      internalMatchCount
    };

    const nowTs = FieldValue.serverTimestamp();

    await db.runTransaction(async (tx) => {
      const [gSnap, eSnap] = await Promise.all([tx.get(groupRef), tx.get(executionRef)]);
      const lock = gSnap.data()?.drawingLock as { executionId?: string; idempotencyKey?: string } | undefined;
      if (!lock || lock.executionId !== executionId || lock.idempotencyKey !== body.idempotencyKey) {
        throw new AppError({ code: "DRAW_IN_PROGRESS", message: "Draw lock lost" });
      }
      const ed = eSnap.data() as { status?: string } | undefined;
      if (ed?.status === "success") {
        return;
      }
      if (ed?.status !== "running") {
        throw new AppError({ code: "INTERNAL", message: "Unexpected execution state in transaction" });
      }

      const assignmentDocIdByParticipantId = new Map<string, string>();
      const seenDocIds = new Set<string>();
      for (const p of participants) {
        const docId = p.linkedUid && p.linkedUid.trim() !== "" ? p.linkedUid.trim() : p.participantId;
        if (seenDocIds.has(docId)) {
          throw new AppError({
            code: "INTERNAL",
            reasonCode: "ASSIGNMENT_DOC_ID_COLLISION",
            message: `Duplicate assignment docId detected: ${docId}`
          });
        }
        seenDocIds.add(docId);
        assignmentDocIdByParticipantId.set(p.participantId, docId);
      }
      await Promise.all(
        participants.map((p) => tx.get(assignCol.doc(assignmentDocIdByParticipantId.get(p.participantId)!)))
      );

      for (const p of participants) {
        const recv = receiversByGiverParticipantId.get(p.participantId);
        if (!recv) {
          throw new AppError({ code: "INTERNAL", message: "Matching map incomplete" });
        }
        const recvFull = participantById.get(recv.participantId);
        if (!recvFull) {
          throw new AppError({ code: "INTERNAL", message: "Receiver participant not found in source map" });
        }
        const docId = assignmentDocIdByParticipantId.get(p.participantId)!;
        const aRef = assignCol.doc(docId);
        tx.set(aRef, {
          giverParticipantId: p.participantId,
          giverUid: p.linkedUid,
          giverDisplayNameSnapshot: p.displayName,
          giverType: p.participantType,
          receiverParticipantId: recvFull.participantId,
          receiverUid: recvFull.linkedUid,
          receiverDisplayNameSnapshot: recvFull.displayName,
          receiverType: recvFull.participantType,
          receiverNicknameSnapshot: recvFull.displayName,
          receiverSubgroupIdSnapshot: recvFull.subgroupId,
          receiverSubgroupNameSnapshot:
            recvFull.subgroupId == null ? null : subgroupNamesById.get(recvFull.subgroupId) ?? null,
          deliveryMode: recvFull.deliveryMode,
          canReceiverSeeDirectly: recvFull.canReceiveDirectResult,
          rulesVersion,
          executionId,
          createdAt: nowTs
        });
      }

      tx.update(executionRef, {
        status: ExecutionStatusSchema.enum.success,
        memberCount: n,
        completedAt: nowTs,
        finishedAt: nowTs,
        errorCode: null,
        failure: null,
        summary
      });
      tx.update(groupRef, {
        drawStatus: "completed",
        drawingLock: null,
        currentExecutionId: executionId,
        lastExecutionId: executionId,
        lastDrawCompletedAt: nowTs,
        updatedAt: FieldValue.serverTimestamp()
      });
    });

    lockHeldForExecution = null;
    const outSnap = await executionRef.get();
    const outData = outSnap.data() as Record<string, unknown>;
    if ((outData.status as string) !== "success") {
      throw new AppError({ code: "INTERNAL", message: "Draw did not complete" });
    }
    assignSnap = await assignCol.get();
    if (assignSnap.size !== n) {
      throw new AppError({ code: "INTERNAL", message: "Assignments not written" });
    }
    return buildSuccessExecuteDrawResponse(executionId, rulesVersion, outData);
  } catch (e) {
    if (lockHeldForExecution) {
      try {
        const er = db.doc(groupPaths.executionDoc(body.groupId, lockHeldForExecution.executionId));
        const es = await er.get();
        const st = (es.data() as { status?: string } | undefined)?.status;
        if (es.exists && st === "running") {
          const now = FieldValue.serverTimestamp();
          await er.update({
            status: ExecutionStatusSchema.enum.failed,
            memberCount: es.data()?.memberCount ?? 0,
            completedAt: now,
            finishedAt: now,
            errorCode: "INTERNAL",
            failure: { reasonCode: "INTERNAL", message: "Draw aborted due to internal error" }
          });
        }
        await clearDrawingLock({
          groupId: body.groupId,
          nextDrawStatus: "failed",
          lastExecutionId: lockHeldForExecution.executionId
        });
      } catch {
        // ignore secondary failures
      }
    }

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
