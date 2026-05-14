import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths, inviteCodePaths, userGroupPaths } from "../shared/firestorePaths";
import { hashInviteCode, normalizeInviteCode } from "../shared/invites";
import { JoinGroupByCodeRequestSchema, JoinGroupByCodeResponse } from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";

export const joinGroupByCode = onCall(
  async (req: CallableRequest<unknown>): Promise<JoinGroupByCodeResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(JoinGroupByCodeRequestSchema, req.data);

      const normalizedCode = normalizeInviteCode(body.code);
      if (normalizedCode.length < 4 || normalizedCode.length > 64 || !/^[A-Z0-9]+$/.test(normalizedCode)) {
        throw new AppError({
          code: "INVITE_ERROR",
          reasonCode: "INVALID_CODE_FORMAT",
          message: "Invalid invite code format"
        });
      }

      const codeHash = hashInviteCode(normalizedCode);

      const db = getDb();
      const inviteRef = db.doc(inviteCodePaths.inviteCodeDoc(codeHash));
      const now = Timestamp.now();

      const nickname =
        body.nickname?.trim() ||
        (typeof (req.auth?.token as Record<string, unknown> | undefined)?.name === "string"
          ? ((req.auth?.token as Record<string, unknown>).name as string).trim()
          : "") ||
        "Miembro";

      const result = await db.runTransaction(async (tx) => {
        const inviteSnap = await tx.get(inviteRef);
        if (!inviteSnap.exists) {
          throw new AppError({
            code: "INVITE_ERROR",
            reasonCode: "CODE_NOT_FOUND",
            message: "Invite code not found"
          });
        }

        const invite = inviteSnap.data() as {
          groupId: string;
          active: boolean;
          expiresAt?: FirebaseFirestore.Timestamp | null;
        };

        if (!invite.active) {
          throw new AppError({
            code: "INVITE_ERROR",
            reasonCode: "CODE_NOT_FOUND",
            message: "Invite code inactive"
          });
        }
        if (invite.expiresAt && invite.expiresAt.toMillis() <= now.toMillis()) {
          throw new AppError({
            code: "INVITE_ERROR",
            reasonCode: "CODE_EXPIRED",
            message: "Invite code expired"
          });
        }

        const groupRef = db.doc(groupPaths.groupDoc(invite.groupId));
        const groupSnap = await tx.get(groupRef);
        if (!groupSnap.exists) {
          throw new AppError({ code: "NOT_FOUND", message: "Group not found" });
        }

        const group = groupSnap.data() as {
          groupId: string;
          name: string;
          lifecycleStatus?: "active" | "archived";
          drawStatus?: string;
          dynamicType?: string;
          raffleStatus?: string;
        };

        const dynamicType =
          typeof group.dynamicType === "string" && group.dynamicType.trim() !== ""
            ? group.dynamicType.trim()
            : "secret_santa";

        if (group.lifecycleStatus === "archived") {
          throw new AppError({
            code: "FORBIDDEN",
            reasonCode: "GROUP_ARCHIVED",
            message: "Group archived"
          });
        }

        if (dynamicType === "simple_raffle") {
          if (group.raffleStatus === "drawing") {
            throw new AppError({
              code: "INVITE_ERROR",
              reasonCode: "RAFFLE_IN_PROGRESS",
              message: "Raffle in progress"
            });
          }
        } else {
          if (group.drawStatus === "drawing") {
            throw new AppError({
              code: "INVITE_ERROR",
              reasonCode: "DRAW_IN_PROGRESS",
              message: "Draw in progress"
            });
          }
        }

        const memberRef = db.doc(groupPaths.memberDoc(invite.groupId, uid));
        const memberSnap = await tx.get(memberRef);

        if (memberSnap.exists) {
          const member = memberSnap.data() as { memberState?: "active" | "left" | "removed" };
          if (member.memberState === "active") {
            throw new AppError({
              code: "MEMBERSHIP_ERROR",
              reasonCode: "ALREADY_MEMBER",
              message: "User already member"
            });
          }
          if (member.memberState === "removed") {
            throw new AppError({
              code: "MEMBERSHIP_ERROR",
              reasonCode: "USER_REMOVED",
              message: "User removed from group"
            });
          }
        }

        if (dynamicType === "simple_raffle") {
          if (group.raffleStatus === "completed") {
            if (!memberSnap.exists) {
              throw new AppError({
                code: "FORBIDDEN",
                reasonCode: "RAFFLE_RESOLVED_INVITES_CLOSED",
                message: "Raffle completed; this group no longer accepts new participants via invite code"
              });
            }
            const memberAfterChecks = memberSnap.data() as { memberState?: "active" | "left" | "removed" };
            if (memberAfterChecks.memberState !== "active") {
              throw new AppError({
                code: "FORBIDDEN",
                reasonCode: "RAFFLE_RESOLVED_INVITES_CLOSED",
                message: "Raffle completed; this group no longer accepts new participants via invite code"
              });
            }
          }
        } else if (group.drawStatus === "completed") {
          if (!memberSnap.exists) {
            throw new AppError({
              code: "FORBIDDEN",
              reasonCode: "DRAW_COMPLETED_INVITES_CLOSED",
              message: "Draw completed; this group no longer accepts new participants via invite code"
            });
          }
          const memberAfterChecks = memberSnap.data() as { memberState?: "active" | "left" | "removed" };
          if (memberAfterChecks.memberState !== "active") {
            throw new AppError({
              code: "FORBIDDEN",
              reasonCode: "DRAW_COMPLETED_INVITES_CLOSED",
              message: "Draw completed; this group no longer accepts new participants via invite code"
            });
          }
        }

        const nowServer = FieldValue.serverTimestamp();
        if (!memberSnap.exists) {
          tx.create(memberRef, {
            uid,
            role: "member",
            memberState: "active",
            nickname,
            subgroupId: null,
            createdAt: nowServer,
            updatedAt: nowServer
          });
        } else {
          tx.set(
            memberRef,
            {
              role: "member",
              memberState: "active",
              nickname,
              updatedAt: nowServer
            },
            { merge: true }
          );
        }

        const userGroupRef = db.doc(userGroupPaths.userGroupDoc(uid, invite.groupId));
        tx.set(
          userGroupRef,
          {
            groupId: invite.groupId,
            name: group.name,
            role: "member",
            isActiveMember: true,
            updatedAt: nowServer
          },
          { merge: true }
        );

        return { groupId: invite.groupId };
      });

      return result;
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

