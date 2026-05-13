import { Timestamp } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { GetWishlistRequestSchema, GetWishlistResponse } from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";
import {
  buildParticipantsMapForWishlist,
  canViewWishlist,
  resolveTargetParticipant
} from "../shared/wishlistAccess";

function parseStringOrNull(raw: unknown): string | null {
  if (typeof raw !== "string") return null;
  const s = raw.trim();
  return s.length > 0 ? s : null;
}

function normalizeLinks(raw: unknown): GetWishlistResponse["links"] {
  if (!Array.isArray(raw)) return [];
  const out: GetWishlistResponse["links"] = [];
  for (const item of raw.slice(0, 3)) {
    if (typeof item !== "object" || item === null) continue;
    const o = item as Record<string, unknown>;
    const url = parseStringOrNull(o.url);
    if (!url) continue;
    const label = o.label === null ? null : parseStringOrNull(o.label);
    out.push({ label, url });
  }
  return out;
}

export const getWishlist = onCall(async (req: CallableRequest<unknown>): Promise<GetWishlistResponse> => {
  try {
    const uid = requireAuthUid(req.auth?.uid);
    const body = parseOrThrow(GetWishlistRequestSchema, req.data);
    const db = getDb();

    const groupRef = db.doc(groupPaths.groupDoc(body.groupId));
    const callerMemberRef = db.doc(groupPaths.memberDoc(body.groupId, uid));
    const [groupSnap, callerMemberSnap] = await Promise.all([groupRef.get(), callerMemberRef.get()]);

    if (!groupSnap.exists) {
      throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
    }
    const groupData = groupSnap.data() as { ownerUid?: unknown; drawStatus?: unknown; lastExecutionId?: unknown };
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

    const lastEx = parseStringOrNull(groupData.lastExecutionId);
    let assignmentRows: Record<string, unknown>[] = [];
    if (lastEx) {
      const asg = await db.collection(groupPaths.assignmentsCol(body.groupId, lastEx)).get();
      assignmentRows = asg.docs.map((d) => d.data() as Record<string, unknown>);
    }

    const drawStatus = typeof groupData.drawStatus === "string" ? groupData.drawStatus : undefined;
    if (!canViewWishlist(uid, target.participantId, ownerUid, drawStatus, participantsById, assignmentRows)) {
      throw new AppError({
        code: "FORBIDDEN",
        reasonCode: "WISHLIST_FORBIDDEN",
        message: "Not allowed to view this wishlist"
      });
    }

    const wishRef = db.doc(`groups/${body.groupId}/wishlists/${target.participantId}`);
    const wishSnap = await wishRef.get();
    if (!wishSnap.exists) {
      return {
        groupId: body.groupId,
        participantId: target.participantId,
        wishText: null,
        likesText: null,
        avoidText: null,
        links: [],
        updatedAtMillis: null
      };
    }
    const w = wishSnap.data() as Record<string, unknown>;
    const updatedAt = w.updatedAt;
    let updatedAtMillis: number | null = null;
    if (updatedAt instanceof Timestamp) {
      updatedAtMillis = updatedAt.toMillis();
    }

    return {
      groupId: body.groupId,
      participantId: target.participantId,
      wishText: parseStringOrNull(w.wishText),
      likesText: parseStringOrNull(w.likesText),
      avoidText: parseStringOrNull(w.avoidText),
      links: normalizeLinks(w.links),
      updatedAtMillis
    };
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
