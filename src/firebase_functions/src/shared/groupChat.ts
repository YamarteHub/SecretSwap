import { FieldValue } from "firebase-admin/firestore";
import type { Firestore } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

import { groupPaths } from "./firestorePaths";

function isAlreadyExistsError(e: unknown): boolean {
  return typeof e === "object" && e !== null && (e as { code?: number }).code === 6;
}

/**
 * Crea un mensaje de sistema idempotente (mismo docId = sin duplicar en reintentos).
 */
export async function appendGroupChatSystemMessageIfNew(
  db: Firestore,
  groupId: string,
  messageDocId: string,
  templateKey: string,
  templateParams?: Record<string, unknown>
): Promise<void> {
  const ref = db.doc(groupPaths.chatMessageDoc(groupId, messageDocId));
  try {
    await ref.create({
      type: "system",
      templateKey,
      ...(templateParams && Object.keys(templateParams).length > 0 ? { templateParams } : {}),
      createdAt: FieldValue.serverTimestamp()
    });
  } catch (e: unknown) {
    if (isAlreadyExistsError(e)) return;
    logger.warn("appendGroupChatSystemMessageIfNew failed", { groupId, messageDocId, err: e });
    throw e;
  }
}
