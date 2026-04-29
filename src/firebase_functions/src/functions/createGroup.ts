import { FieldValue } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { getDb } from "../shared/firestore";
import { groupPaths, inviteCodePaths, userGroupPaths } from "../shared/firestorePaths";
import { AppError } from "../shared/errors";
import {
  CreateGroupRequestSchema,
  CreateGroupResponse,
  DrawStatusSchema,
  MemberRoleSchema,
  MemberStateSchema
} from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";
import { generateInviteCode, hashInviteCode } from "../shared/invites";

export const createGroup = onCall(async (req: CallableRequest<unknown>): Promise<CreateGroupResponse> => {
  try {
    const uid = requireAuthUid(req.auth?.uid);
    const body = parseOrThrow(CreateGroupRequestSchema, req.data);

    const db = getDb();
    const groupRef = db.collection("groups").doc();
    const groupId = groupRef.id;

    const now = FieldValue.serverTimestamp();
    const rulesVersionCurrent = 1;

    let inviteCode = "";
    let codeHash = "";

    for (let attempt = 0; attempt < 5; attempt++) {
      inviteCode = generateInviteCode(8);
      codeHash = hashInviteCode(inviteCode);
      const inviteCodeRef = db.doc(inviteCodePaths.inviteCodeDoc(codeHash));

      try {
        await db.runTransaction(async (tx) => {
          const existing = await tx.get(inviteCodeRef);
          if (existing.exists) {
            throw new AppError({
              code: "INVITE_ERROR",
              reasonCode: "INVITE_CODE_COLLISION",
              message: "Invite code hash collision"
            });
          }

          tx.create(groupRef, {
            groupId,
            name: body.name,
            ownerUid: uid,
            lifecycleStatus: "active",
            drawStatus: DrawStatusSchema.enum.idle,
            rulesVersionCurrent,
            drawingLock: null,
            createdAt: now,
            updatedAt: now
          });

          tx.create(db.doc(groupPaths.memberDoc(groupId, uid)), {
            uid,
            role: MemberRoleSchema.enum.owner,
            memberState: MemberStateSchema.enum.active,
            nickname: body.nickname,
            subgroupId: null,
            createdAt: now,
            updatedAt: now
          });

          tx.create(db.doc(groupPaths.ruleDoc(groupId, rulesVersionCurrent)), {
            version: rulesVersionCurrent,
            subgroupMode: "ignore",
            exclusions: [],
            createdByUid: uid,
            createdAt: now
          });

          tx.create(db.doc(groupPaths.invitesCurrentDoc(groupId)), {
            codeHash,
            active: true,
            expiresAt: null,
            rotatedAt: now,
            rotatedByUid: uid
          });

          tx.create(inviteCodeRef, {
            groupId,
            active: true,
            expiresAt: null,
            createdAt: now
          });

          tx.create(db.doc(userGroupPaths.userGroupDoc(uid, groupId)), {
            groupId,
            name: body.name,
            role: "owner",
            isActiveMember: true,
            updatedAt: now
          });
        });

        break;
      } catch (e) {
        const err = e as unknown;
        if (attempt === 4) throw err;
        // retry only for collisions or transient transaction retries
      }
    }

    return {
      groupId,
      inviteCode,
      group: {
        groupId,
        name: body.name,
        ownerUid: uid,
        lifecycleStatus: "active",
        drawStatus: DrawStatusSchema.enum.idle,
        rulesVersionCurrent
      }
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

