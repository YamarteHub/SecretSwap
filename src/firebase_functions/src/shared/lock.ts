import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { getDb } from "./firestore";
import { groupPaths } from "./firestorePaths";
import { AppError } from "./errors";

export type DrawingLock = {
  executionId: string;
  idempotencyKey: string;
  rulesVersion: number;
  lockedByUid: string;
  lockedAt: FirebaseFirestore.Timestamp;
  expiresAt?: FirebaseFirestore.Timestamp | null;
};

export type GroupDoc = {
  ownerUid: string;
  name: string;
  lifecycleStatus?: "active" | "archived";
  rulesVersionCurrent: number;
  drawStatus: "idle" | "drawing" | "completed" | "failed";
  drawingLock?: DrawingLock | null;
};

export type AcquireLockResult =
  | { kind: "acquired"; executionId: string; rulesVersion: number }
  | { kind: "idempotent_retry"; executionId: string; rulesVersion: number };

export async function acquireDrawingLock(params: {
  groupId: string;
  requestedByUid: string;
  idempotencyKey: string;
  now?: FirebaseFirestore.Timestamp;
  ttlSeconds?: number;
}): Promise<AcquireLockResult> {
  const db = getDb();
  const groupRef = db.doc(groupPaths.groupDoc(params.groupId));
  const now = params.now ?? Timestamp.now();
  const ttlSeconds = params.ttlSeconds ?? 120;
  const expiresAt = Timestamp.fromMillis(now.toMillis() + ttlSeconds * 1000);

  return await db.runTransaction(async (tx) => {
    const snap = await tx.get(groupRef);
    if (!snap.exists) {
      throw new AppError({ code: "NOT_FOUND", message: "Group not found" });
    }

    const group = snap.data() as GroupDoc;
    const existingLock = group.drawingLock ?? null;

    if (group.drawStatus === "drawing" && existingLock) {
      if (existingLock.idempotencyKey === params.idempotencyKey) {
        if (existingLock.lockedByUid !== params.requestedByUid) {
          throw new AppError({
            code: "DRAW_IN_PROGRESS",
            reasonCode: "DRAW_LOCK_HELD_BY_OTHER",
            message: "Draw already in progress"
          });
        }
        return {
          kind: "idempotent_retry",
          executionId: existingLock.executionId,
          rulesVersion: existingLock.rulesVersion
        };
      }

      const isExpired =
        !!existingLock.expiresAt && existingLock.expiresAt.toMillis() <= now.toMillis();
      if (!isExpired) {
        throw new AppError({ code: "DRAW_IN_PROGRESS", message: "Draw already in progress" });
      }
    }

    const executionId = db.collection(groupPaths.executionsCol(params.groupId)).doc().id;
    const rulesVersion = group.rulesVersionCurrent;

    const newLock: DrawingLock = {
      executionId,
      idempotencyKey: params.idempotencyKey,
      rulesVersion,
      lockedByUid: params.requestedByUid,
      lockedAt: now,
      expiresAt
    };

    tx.update(groupRef, {
      drawStatus: "drawing",
      drawingLock: newLock,
      updatedAt: FieldValue.serverTimestamp()
    });

    return { kind: "acquired", executionId, rulesVersion };
  });
}

export async function clearDrawingLock(params: {
  groupId: string;
  nextDrawStatus: "completed" | "failed" | "idle";
  currentExecutionId?: string;
  lastExecutionId?: string;
}): Promise<void> {
  const db = getDb();
  const groupRef = db.doc(groupPaths.groupDoc(params.groupId));
  const patch: Record<string, unknown> = {
    drawStatus: params.nextDrawStatus,
    drawingLock: null,
    updatedAt: FieldValue.serverTimestamp()
  };
  if (params.lastExecutionId !== undefined) {
    patch.lastExecutionId = params.lastExecutionId;
  }
  if (params.currentExecutionId !== undefined) {
    patch.currentExecutionId = params.currentExecutionId;
  }
  await groupRef.update(patch);
}

