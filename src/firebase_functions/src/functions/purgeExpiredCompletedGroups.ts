import { FieldValue, QueryDocumentSnapshot, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { purgeGroupFully } from "../shared/deleteGroupTree";
import { getDb } from "../shared/firestore";
import { collections } from "../shared/firestorePaths";
import {
  buildRetentionBackfillUpdate,
  groupNeedsRetentionBackfill
} from "../shared/retention";

const MAX_PURGE_PER_RUN = 50;
const MAX_BACKFILL_PER_RUN = 40;

/**
 * Backfill tardío: grupos completados sin retentionDeleteAt (pre-fase 12 o migración).
 */
async function backfillRetentionFields(): Promise<number> {
  const db = getDb();
  const seen = new Set<string>();
  const candidates: QueryDocumentSnapshot[] = [];

  const statusQueries = [
    db.collection(collections.groups()).where("drawStatus", "==", "completed").limit(30),
    db.collection(collections.groups()).where("raffleStatus", "==", "completed").limit(30),
    db.collection(collections.groups()).where("teamStatus", "==", "completed").limit(30)
  ];

  for (const q of statusQueries) {
    const snap = await q.get();
    for (const doc of snap.docs) {
      if (seen.has(doc.id)) continue;
      const data = doc.data();
      if (!groupNeedsRetentionBackfill(data)) continue;
      seen.add(doc.id);
      candidates.push(doc);
      if (candidates.length >= MAX_BACKFILL_PER_RUN) break;
    }
    if (candidates.length >= MAX_BACKFILL_PER_RUN) break;
  }

  let written = 0;
  for (const doc of candidates) {
    const update = buildRetentionBackfillUpdate(doc.data());
    if (!update) continue;
    await doc.ref.update({
      ...update,
      retentionLastEvaluatedAt: FieldValue.serverTimestamp()
    });
    written++;
    logger.info("retention backfill written", { groupId: doc.id });
  }
  return written;
}

async function purgeExpiredGroups(): Promise<{ purged: number; failed: number }> {
  const db = getDb();
  const now = Timestamp.now();
  const snap = await db
    .collection(collections.groups())
    .where("retentionDeleteAt", "<=", now)
    .limit(MAX_PURGE_PER_RUN)
    .get();

  let purged = 0;
  let failed = 0;

  for (const doc of snap.docs) {
    const groupId = doc.id;
    try {
      await doc.ref.update({
        retentionStatus: "deleting",
        retentionLastEvaluatedAt: FieldValue.serverTimestamp()
      });
    } catch (e) {
      logger.warn("purge: could not mark deleting", { groupId, err: e });
    }

    const result = await purgeGroupFully(db, groupId);
    if (result.ok) {
      purged++;
      logger.info("purge: group deleted", { groupId });
    } else {
      failed++;
      try {
        await doc.ref.update({
          retentionStatus: "delete_failed",
          retentionDeleteFailedAt: FieldValue.serverTimestamp(),
          retentionDeleteFailureCount: FieldValue.increment(1),
          retentionLastEvaluatedAt: FieldValue.serverTimestamp()
        });
      } catch (markErr) {
        logger.error("purge: could not mark delete_failed", { groupId, err: markErr });
      }
      logger.error("purge: delete failed", { groupId, reason: result.reason });
    }
  }

  return { purged, failed };
}

/**
 * Purga diaria de dinámicas completadas cuyo plazo de retención ha vencido.
 * Horario: 04:00 UTC.
 *
 * En emulador el scheduler no corre solo: invocar manualmente la función exportada
 * o usar el trigger de Cloud Scheduler en staging.
 */
export const purgeExpiredCompletedGroups = onSchedule(
  {
    schedule: "30 4 * * *",
    timeZone: "Etc/UTC",
    memory: "512MiB",
    timeoutSeconds: 540
  },
  async () => {
    const backfilled = await backfillRetentionFields();
    const { purged, failed } = await purgeExpiredGroups();
    logger.info("purgeExpiredCompletedGroups done", { backfilled, purged, failed });
  }
);
