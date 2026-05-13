import * as logger from "firebase-functions/logger";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { getDb } from "../shared/firestore";
import { runTarciAutomationSweep } from "../shared/tarciChatAutomation";

/**
 * Motor diario de mensajes Tarci en chat grupal.
 * Horario: 09:00 UTC (referencia global estable para Cloud Scheduler).
 */
export const publishTarciScheduledChatMessages = onSchedule(
  {
    schedule: "0 9 * * *",
    timeZone: "Etc/UTC",
    memory: "512MiB"
  },
  async () => {
    const db = getDb();
    const out = await runTarciAutomationSweep(db, { maxGroups: 300 });
    logger.info("publishTarciScheduledChatMessages done", {
      processed: out.processed,
      published: out.published
    });
  }
);
