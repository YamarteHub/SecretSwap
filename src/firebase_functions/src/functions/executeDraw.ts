import { FieldValue } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { acquireDrawingLock, clearDrawingLock } from "../shared/lock";
import { parseOrThrow } from "../shared/validation";
import { ExecuteDrawRequestSchema, ExecuteDrawResponse, ExecutionStatusSchema } from "../shared/dtos";

export const executeDraw = onCall(async (req: CallableRequest<unknown>): Promise<ExecuteDrawResponse> => {
  const uid = requireAuthUid(req.auth?.uid);
  const body = parseOrThrow(ExecuteDrawRequestSchema, req.data);

  const db = getDb();
  const groupRef = db.doc(groupPaths.groupDoc(body.groupId));

  try {
    const groupSnap = await groupRef.get();
    if (!groupSnap.exists) {
      throw new AppError({ code: "NOT_FOUND", message: "Group not found" });
    }
    const group = groupSnap.data() as { ownerUid: string };
    if (group.ownerUid !== uid) {
      throw new AppError({ code: "FORBIDDEN", message: "Only owner can execute draw in MVP" });
    }

    const lockRes = await acquireDrawingLock({
      groupId: body.groupId,
      requestedByUid: uid,
      idempotencyKey: body.idempotencyKey
    });

    if (lockRes.kind === "idempotent_retry") {
      const existingExec = await db.doc(groupPaths.executionDoc(body.groupId, lockRes.executionId)).get();
      if (existingExec.exists) {
        const data = existingExec.data() as { status: string; createdAt: unknown };
        return {
          executionId: lockRes.executionId,
          status: ExecutionStatusSchema.parse(data.status),
          rulesVersion: lockRes.rulesVersion,
          createdAt: data.createdAt
        };
      }
      // Si el lock existe pero la ejecución aún no fue creada, devolvemos "running" como estado.
      return {
        executionId: lockRes.executionId,
        status: ExecutionStatusSchema.enum.running,
        rulesVersion: lockRes.rulesVersion,
        createdAt: FieldValue.serverTimestamp()
      };
    }

    const executionRef = db.doc(groupPaths.executionDoc(body.groupId, lockRes.executionId));
    const now = FieldValue.serverTimestamp();

    await executionRef.create({
      executionId: lockRes.executionId,
      groupId: body.groupId,
      rulesVersion: lockRes.rulesVersion,
      idempotencyKey: body.idempotencyKey,
      status: ExecutionStatusSchema.enum.running,
      memberCount: 0,
      createdAt: now,
      completedAt: null,
      errorCode: null
    });

    // TODO: implementar algoritmo de asignación y escrituras de assignments/{giverUid}.
    // En este esqueleto solo fijamos el contrato, el lock y la persistencia mínima.

    await executionRef.update({
      status: ExecutionStatusSchema.enum.success,
      completedAt: now
    });
    await clearDrawingLock({ groupId: body.groupId, nextDrawStatus: "completed" });

    const createdSnap = await executionRef.get();
    const created = createdSnap.data() as { createdAt: unknown };
    return {
      executionId: lockRes.executionId,
      status: ExecutionStatusSchema.enum.success,
      rulesVersion: lockRes.rulesVersion,
      createdAt: created.createdAt
    };
  } catch (e) {
    try {
      await clearDrawingLock({ groupId: body.groupId, nextDrawStatus: "failed" });
    } catch {
      // ignore lock cleanup failure here; handled in logs in real impl
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

