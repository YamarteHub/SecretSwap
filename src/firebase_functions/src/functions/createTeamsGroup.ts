import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { getDb } from "../shared/firestore";
import { groupPaths, inviteCodePaths, userGroupPaths } from "../shared/firestorePaths";
import { AppError } from "../shared/errors";
import {
  CreateTeamsGroupRequestSchema,
  CreateTeamsGroupResponse,
  DrawStatusSchema,
  MemberRoleSchema,
  MemberStateSchema,
  RaffleStatusSchema,
  TeamStatusSchema
} from "../shared/dtos";
import { parseOrThrow } from "../shared/validation";
import { generateInviteCode, hashInviteCode } from "../shared/invites";

function optionalEventTimestamp(epochMs: number | undefined): Timestamp | undefined {
  if (epochMs === undefined) return undefined;
  const d = new Date(epochMs);
  if (Number.isNaN(d.getTime())) return undefined;
  return Timestamp.fromMillis(epochMs);
}

export const createTeamsGroup = onCall(
  async (req: CallableRequest<unknown>): Promise<CreateTeamsGroupResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(CreateTeamsGroupRequestSchema, req.data);
      const teamsPreset = body.teamsPreset ?? "standard";
      const groupingMode = teamsPreset === "pairings" ? "team_size" : body.groupingMode;
      const requestedTeamCount =
        teamsPreset === "pairings" ? undefined : body.requestedTeamCount;
      const requestedTeamSize = teamsPreset === "pairings" ? 2 : body.requestedTeamSize;
      const eventDateTs = optionalEventTimestamp(body.eventDateEpochMs);

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
              dynamicType: "teams",
              resultVisibility: "public_to_group",
              teamStatus: TeamStatusSchema.enum.idle,
              teamsPreset,
              groupingMode,
              ...(groupingMode === "team_count"
                ? { requestedTeamCount }
                : { requestedTeamSize }),
              ownerParticipatesInTeams: body.ownerParticipatesInTeams,
              lastTeamExecutionId: null,
              drawStatus: DrawStatusSchema.enum.idle,
              raffleStatus: RaffleStatusSchema.enum.idle,
              rulesVersionCurrent,
              drawingLock: null,
              createdAt: now,
              updatedAt: now,
              ...(eventDateTs
                ? {
                    eventDate: eventDateTs,
                    eventDateDayKey: body.eventDateDayKey,
                    ...(body.eventTimeZone ? { eventTimeZone: body.eventTimeZone } : {})
                  }
                : {})
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
          dynamicType: "teams",
          resultVisibility: "public_to_group",
          teamStatus: TeamStatusSchema.enum.idle,
          groupingMode: body.groupingMode,
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
  }
);
