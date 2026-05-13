import { FieldValue } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { SetWishlistRequestSchema, SetWishlistResponse } from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";
import {
  buildParticipantsMapForWishlist,
  canEditWishlist,
  resolveTargetParticipant
} from "../shared/wishlistAccess";

function parseStringOrNull(raw: unknown): string | null {
  if (typeof raw !== "string") return null;
  const s = raw.trim();
  return s.length > 0 ? s : null;
}

export const setWishlist = onCall(async (req: CallableRequest<unknown>): Promise<SetWishlistResponse> => {
  try {
    const uid = requireAuthUid(req.auth?.uid);
    const body = parseOrThrow(SetWishlistRequestSchema, req.data);
    const db = getDb();

    const groupRef = db.doc(groupPaths.groupDoc(body.groupId));
    const callerMemberRef = db.doc(groupPaths.memberDoc(body.groupId, uid));
    const [groupSnap, callerMemberSnap] = await Promise.all([groupRef.get(), callerMemberRef.get()]);

    if (!groupSnap.exists) {
      throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
    }
    const groupData = groupSnap.data() as { ownerUid?: unknown };
    const ownerUid = parseStringOrNull(groupData.ownerUid);
    if (!ownerUid) {
      throw new AppError({ code: "INTERNAL", message: "Group owner is missing" });
    }
    const isActiveMember = callerMemberSnap.exists && callerMemberSnap.data()?.memberState === "active";
    if (!isActiveMember) {
      throw new AppError({
        code: "FORBIDDEN",
        reasonCode: "NOT_ACTIVE_MEMBER",
        message: "Caller is not an active member"
      });
    }

    const participantsById = await buildParticipantsMapForWishlist(db, body.groupId);
    const target = await resolveTargetParticipant(db, body.groupId, body.participantId, participantsById);
    if (!target) {
      throw new AppError({ code: "NOT_FOUND", reasonCode: "PARTICIPANT_NOT_FOUND", message: "Participant not found" });
    }
    if (!canEditWishlist(uid, target, ownerUid)) {
      throw new AppError({
        code: "FORBIDDEN",
        reasonCode: "WISHLIST_EDIT_FORBIDDEN",
        message: "Not allowed to edit this wishlist"
      });
    }

    const linksOut = body.links.map((l) => ({
      label: l.label === undefined ? null : l.label === null ? null : parseStringOrNull(l.label),
      url: l.url.trim()
    }));

    const wishRef = db.doc(`groups/${body.groupId}/wishlists/${target.participantId}`);
    await wishRef.set(
      {
        groupId: body.groupId,
        participantId: target.participantId,
        wishText: body.wishText === null ? null : parseStringOrNull(body.wishText),
        likesText: body.likesText === null ? null : parseStringOrNull(body.likesText),
        avoidText: body.avoidText === null ? null : parseStringOrNull(body.avoidText),
        links: linksOut,
        updatedAt: FieldValue.serverTimestamp(),
        updatedByUid: uid
      },
      { merge: true }
    );

    return { ok: true };
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
});
