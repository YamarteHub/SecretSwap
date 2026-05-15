import { FieldValue } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths, inviteCodePaths } from "../shared/firestorePaths";
import { generateInviteCode, hashInviteCode } from "../shared/invites";
import {
  RotateInviteCodeRequestSchema,
  RotateInviteCodeResponse
} from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";

export const rotateInviteCode = onCall(
  async (req: CallableRequest<unknown>): Promise<RotateInviteCodeResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(RotateInviteCodeRequestSchema, req.data);
      const groupId = body.groupId;

      const db = getDb();
      const groupRef = db.doc(groupPaths.groupDoc(groupId));
      const currentInviteRef = db.doc(groupPaths.invitesCurrentDoc(groupId));
      const now = FieldValue.serverTimestamp();

      let inviteCode = "";
      let codeHash = "";

      for (let attempt = 0; attempt < 5; attempt++) {
        inviteCode = generateInviteCode(8);
        codeHash = hashInviteCode(inviteCode);
        const nextInviteCodeRef = db.doc(inviteCodePaths.inviteCodeDoc(codeHash));

        try {
          await db.runTransaction(async (tx) => {
            const groupSnap = await tx.get(groupRef);
            if (!groupSnap.exists) {
              throw new AppError({ code: "NOT_FOUND", message: "Group not found" });
            }

            const group = groupSnap.data() as {
              ownerUid: string;
              lifecycleStatus?: "active" | "archived";
              drawStatus?: string;
              dynamicType?: string;
              raffleStatus?: string;
              teamStatus?: string;
            };

            if (group.ownerUid != uid) {
              throw new AppError({
                code: "FORBIDDEN",
                reasonCode: "NOT_GROUP_OWNER",
                message: "Only owner can rotate invite code"
              });
            }
            if (group.lifecycleStatus == "archived") {
              throw new AppError({
                code: "FORBIDDEN",
                reasonCode: "GROUP_ARCHIVED",
                message: "Group archived"
              });
            }

            const dynamicType =
              typeof group.dynamicType === "string" && group.dynamicType.trim() !== ""
                ? group.dynamicType.trim()
                : "secret_santa";

            if (dynamicType === "teams") {
              if (group.teamStatus === "generating" || group.teamStatus === "completed") {
                throw new AppError({
                  code: "INVITE_ERROR",
                  reasonCode: "TEAMS_ROTATE_LOCKED",
                  message: "Cannot rotate invite code after teams are formed"
                });
              }
            } else if (dynamicType === "simple_raffle") {
              if (group.raffleStatus === "drawing" || group.raffleStatus === "completed") {
                throw new AppError({
                  code: "INVITE_ERROR",
                  reasonCode: "RAFFLE_ROTATE_LOCKED",
                  message: "Cannot rotate invite code after raffle is resolved"
                });
              }
            } else if (group.drawStatus == "drawing" || group.drawStatus == "completed") {
              throw new AppError({
                code: "INVITE_ERROR",
                reasonCode: "DRAW_NOT_IDLE",
                message: "Cannot rotate invite code while draw is drawing/completed"
              });
            }

            const nextCodeSnap = await tx.get(nextInviteCodeRef);
            if (nextCodeSnap.exists) {
              throw new AppError({
                code: "INVITE_ERROR",
                reasonCode: "INVITE_CODE_COLLISION",
                message: "Invite code hash collision"
              });
            }

            const currentInviteSnap = await tx.get(currentInviteRef);
            if (currentInviteSnap.exists) {
              const current = currentInviteSnap.data() as { codeHash?: string | null };
              const oldCodeHash = current.codeHash?.trim();
              if (oldCodeHash != null && oldCodeHash.length > 0) {
                const oldInviteCodeRef = db.doc(inviteCodePaths.inviteCodeDoc(oldCodeHash));
                tx.set(oldInviteCodeRef, { active: false, updatedAt: now }, { merge: true });
              }
            }

            tx.set(
              currentInviteRef,
              {
                codeHash,
                active: true,
                expiresAt: null,
                rotatedAt: now,
                rotatedByUid: uid
              },
              { merge: true }
            );

            tx.create(nextInviteCodeRef, {
              groupId,
              active: true,
              expiresAt: null,
              createdAt: now
            });
          });

          break;
        } catch (e) {
          const err = e as unknown;
          if (attempt === 4) throw err;
          // Retry collisions / concurrent retries.
        }
      }

      return { groupId, inviteCode };
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
