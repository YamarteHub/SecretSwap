import { FieldValue, Timestamp } from "firebase-admin/firestore";

/** Política de retención v1: 90 días desde la fecha efectiva de cierre. */
export const RETENTION_POLICY_VERSION = 1;
export const RETENTION_DAYS = 90;

export type RetentionStatus = "scheduled" | "deleting" | "delete_failed";

export type RetentionTimestamps = {
  retentionPolicyVersion: number;
  retentionBasisAt: Date;
  retentionDeleteAt: Date;
};

/**
 * retentionBasisAt = max(completedAt, eventDate) cuando eventDate > completedAt.
 * retentionDeleteAt = retentionBasisAt + 90 días.
 */
export function computeRetentionTimestamps(params: {
  completedAt: Date;
  eventDate?: Date | null;
}): RetentionTimestamps {
  const completed = params.completedAt;
  const event = params.eventDate;
  let basis = completed;
  if (event && event.getTime() > completed.getTime()) {
    basis = event;
  }
  const deleteAt = new Date(basis.getTime());
  deleteAt.setUTCDate(deleteAt.getUTCDate() + RETENTION_DAYS);
  return {
    retentionPolicyVersion: RETENTION_POLICY_VERSION,
    retentionBasisAt: basis,
    retentionDeleteAt: deleteAt
  };
}

export function readEventDate(raw: unknown): Date | null {
  if (raw instanceof Timestamp) {
    return raw.toDate();
  }
  return null;
}

export function readCompletedAt(raw: unknown): Date | null {
  if (raw instanceof Timestamp) {
    return raw.toDate();
  }
  return null;
}

/** Campos Firestore para escribir al completar una dinámica por primera vez. */
export function buildRetentionFirestoreUpdate(params: {
  completedAt: Date;
  eventDate?: Date | null;
}): Record<string, unknown> {
  const { retentionPolicyVersion, retentionBasisAt, retentionDeleteAt } =
    computeRetentionTimestamps(params);
  return {
    retentionPolicyVersion,
    retentionBasisAt: Timestamp.fromDate(retentionBasisAt),
    retentionDeleteAt: Timestamp.fromDate(retentionDeleteAt),
    retentionScheduledAt: FieldValue.serverTimestamp(),
    retentionStatus: "scheduled" satisfies RetentionStatus,
    retentionLastEvaluatedAt: FieldValue.serverTimestamp()
  };
}

export function isGroupDynamicallyCompleted(data: Record<string, unknown>): boolean {
  const dynamicType =
    typeof data.dynamicType === "string" && data.dynamicType.trim() !== ""
      ? data.dynamicType.trim()
      : "secret_santa";
  if (dynamicType === "simple_raffle") {
    return data.raffleStatus === "completed";
  }
  if (dynamicType === "teams") {
    return data.teamStatus === "completed";
  }
  return data.drawStatus === "completed";
}

/** Resuelve completedAt según tipo de dinámica para backfill tardío. */
export function resolveCompletedAtForGroup(data: Record<string, unknown>): Date | null {
  const dynamicType =
    typeof data.dynamicType === "string" && data.dynamicType.trim() !== ""
      ? data.dynamicType.trim()
      : "secret_santa";
  if (dynamicType === "simple_raffle") {
    return readCompletedAt(data.lastRaffleCompletedAt);
  }
  if (dynamicType === "teams") {
    return readCompletedAt(data.lastTeamCompletedAt);
  }
  return readCompletedAt(data.lastDrawCompletedAt);
}

export function groupNeedsRetentionBackfill(data: Record<string, unknown>): boolean {
  if (!isGroupDynamicallyCompleted(data)) return false;
  if (data.retentionDeleteAt instanceof Timestamp) return false;
  return resolveCompletedAtForGroup(data) != null;
}

export function buildRetentionBackfillUpdate(data: Record<string, unknown>): Record<string, unknown> | null {
  const completedAt = resolveCompletedAtForGroup(data);
  if (!completedAt) return null;
  return buildRetentionFirestoreUpdate({
    completedAt,
    eventDate: readEventDate(data.eventDate)
  });
}
