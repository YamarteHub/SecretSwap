import { FieldValue } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { SendGroupChatMessageRequestSchema, SendGroupChatMessageResponse } from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";

const MAX_LEN = 500;

export const sendGroupChatMessage = onCall(
  async (req: CallableRequest<unknown>): Promise<SendGroupChatMessageResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(SendGroupChatMessageRequestSchema, req.data);
      const text = body.text.trim();
      if (text.length === 0) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "CHAT_TEXT_EMPTY",
          message: "Message text is empty"
        });
      }
      if (text.length > MAX_LEN) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "CHAT_TEXT_TOO_LONG",
          message: `Message exceeds ${MAX_LEN} characters`
        });
      }

      const db = getDb();
      const memberRef = db.doc(groupPaths.memberDoc(body.groupId, uid));
      const groupRef = db.doc(groupPaths.groupDoc(body.groupId));
      const [memberSnap, groupSnap] = await Promise.all([memberRef.get(), groupRef.get()]);

      if (!groupSnap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
      }
      const gDyn = groupSnap.data() as { dynamicType?: string };
      const dyn =
        typeof gDyn.dynamicType === "string" && gDyn.dynamicType.trim() !== ""
          ? gDyn.dynamicType.trim()
          : "secret_santa";
      if (dyn === "simple_raffle") {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "CHAT_NOT_AVAILABLE_FOR_RAFFLE",
          message: "Group chat is disabled for raffle groups"
        });
      }
      if (!memberSnap.exists) {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "NOT_GROUP_MEMBER",
          message: "Caller is not a member of this group"
        });
      }
      const ms = memberSnap.data() as { memberState?: string; nickname?: unknown } | undefined;
      if (ms?.memberState !== "active") {
        throw new AppError({
          code: "FORBIDDEN",
          reasonCode: "NOT_ACTIVE_MEMBER",
          message: "Only active members can post to group chat"
        });
      }
      const nickRaw = ms.nickname;
      const nickname =
        typeof nickRaw === "string" && nickRaw.trim().length > 0 ? nickRaw.trim() : "Tarci";

      const col = groupRef.collection("chatMessages");
      const msgRef = col.doc();
      const stateRef = db.doc(groupPaths.chatAutomationTarciStateDoc(body.groupId));
      const batch = db.batch();
      batch.set(msgRef, {
        type: "user",
        senderUid: uid,
        senderDisplayName: nickname,
        text,
        createdAt: FieldValue.serverTimestamp()
      });
      batch.set(
        stateRef,
        {
          lastHumanMessageAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp()
        },
        { merge: true }
      );
      await batch.commit();

      return { ok: true as const, messageId: msgRef.id };
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
  }
);
