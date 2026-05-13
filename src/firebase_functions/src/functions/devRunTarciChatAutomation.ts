import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";

import { DevRunTarciChatAutomationRequestSchema } from "../shared/dtos";
import { getDb } from "../shared/firestore";
import { processTarciAutomationForGroup, runTarciAutomationSweep } from "../shared/tarciChatAutomation";
import { parseOrThrow } from "../shared/validation";

/**
 * Solo emulador: ejecuta una pasada del motor Tarci (un grupo o barrido limitado).
 */
export const devRunTarciChatAutomation = onCall(async (req: CallableRequest<unknown>) => {
  if (process.env.FUNCTIONS_EMULATOR !== "true") {
    throw new HttpsError("permission-denied", "Solo disponible con Functions Emulator");
  }
  const body = parseOrThrow(DevRunTarciChatAutomationRequestSchema, req.data ?? {});
  const db = getDb();
  if (body.groupId) {
    return processTarciAutomationForGroup(db, body.groupId, { dryRun: body.dryRun === true });
  }
  return runTarciAutomationSweep(db, { maxGroups: body.maxGroups ?? 50 });
});
