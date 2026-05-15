import { FieldValue } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { pushTokenDocId } from "../shared/groupNotifications";
import { userPaths } from "../shared/userPaths";
import { RegisterPushTokenRequestSchema } from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";

export const registerPushToken = onCall(async (req: CallableRequest<unknown>): Promise<{ ok: true }> => {
  try {
    const uid = requireAuthUid(req.auth?.uid);
    const body = parseOrThrow(RegisterPushTokenRequestSchema, req.data);
    const token = body.token.trim();
    if (token.length < 20) {
      throw new AppError({
        code: "VALIDATION_ERROR",
        reasonCode: "INVALID_PUSH_TOKEN",
        message: "Invalid FCM token"
      });
    }

    const db = getDb();
    const now = FieldValue.serverTimestamp();
    const tokenId = pushTokenDocId(token);
    const platform = body.platform ?? "unknown";

    const userRef = db.doc(userPaths.userDoc(uid));
    const tokenRef = db.doc(userPaths.pushTokenDoc(uid, tokenId));

    await db.runTransaction(async (tx) => {
      const existing = await tx.get(tokenRef);
      const userSnap = await tx.get(userRef);

      if (!userSnap.exists) {
        tx.set(userRef, {
          uid,
          preferredLocale: body.preferredLocale ?? "es",
          createdAt: now,
          updatedAt: now
        });
      } else if (body.preferredLocale) {
        tx.set(
          userRef,
          {
            preferredLocale: body.preferredLocale,
            updatedAt: now
          },
          { merge: true }
        );
      } else {
        tx.set(userRef, { updatedAt: now }, { merge: true });
      }

      if (!existing.exists) {
        tx.set(tokenRef, {
          token,
          platform,
          enabled: true,
          createdAt: now,
          updatedAt: now,
          lastSeenAt: now
        });
      } else {
        tx.set(
          tokenRef,
          {
            token,
            platform,
            enabled: true,
            updatedAt: now,
            lastSeenAt: now,
            disabledAt: null,
            disabledReason: null
          },
          { merge: true }
        );
      }
    });

    return { ok: true };
  } catch (e) {
    const err = e as unknown;
    if (err instanceof AppError) {
      throw new HttpsError("failed-precondition", err.message, {
        code: err.code,
        reasonCode: err.reasonCode
      });
    }
    throw new HttpsError("internal", "Internal error");
  }
});
