import { z } from "zod";

export const DrawStatusSchema = z.enum(["idle", "drawing", "completed", "failed"]);
export type DrawStatus = z.infer<typeof DrawStatusSchema>;

export const ExecutionStatusSchema = z.enum(["running", "success", "failed"]);
export type ExecutionStatus = z.infer<typeof ExecutionStatusSchema>;

export const MemberRoleSchema = z.enum(["owner", "member"]);
export type MemberRole = z.infer<typeof MemberRoleSchema>;

export const MemberStateSchema = z.enum(["active", "left", "removed"]);
export type MemberState = z.infer<typeof MemberStateSchema>;

export const ExecuteDrawRequestSchema = z.object({
  groupId: z.string().min(1),
  idempotencyKey: z.string().min(1)
});
export type ExecuteDrawRequest = z.infer<typeof ExecuteDrawRequestSchema>;

export const ExecuteDrawSummarySchema = z.object({
  participantCount: z.number().int().nonnegative(),
  subgroupMode: z.string(),
  internalMatchCount: z.number().int().nonnegative()
});

export const ExecuteDrawResponseSchema = z.object({
  executionId: z.string().min(1),
  status: ExecutionStatusSchema,
  rulesVersion: z.number().int().positive(),
  summary: ExecuteDrawSummarySchema,
  finishedAt: z.any().optional()
});
export type ExecuteDrawResponse = z.infer<typeof ExecuteDrawResponseSchema>;
export type ExecuteDrawSummary = z.infer<typeof ExecuteDrawSummarySchema>;

export const CreateGroupRequestSchema = z
  .object({
    name: z.string().min(1),
    nickname: z.string().min(1),
    /** Día del evento/entrega (medianoche local del cliente), epoch ms. Opcional. */
    eventDateEpochMs: z.number().int().finite().positive().optional(),
    /** Día civil elegido por el usuario (YYYY-MM-DD en su calendario local). Obligatorio si hay eventDateEpochMs. */
    eventDateDayKey: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
    /** Zona IANA del dispositivo (p. ej. Europe/Madrid). Recomendada con fecha para countdown fiable. */
    eventTimeZone: z.string().min(1).max(80).optional()
  })
  .superRefine((d, ctx) => {
    if (d.eventDateEpochMs !== undefined && !d.eventDateDayKey) {
      ctx.addIssue({
        code: "custom",
        path: ["eventDateDayKey"],
        message: "eventDateDayKey is required when eventDateEpochMs is set"
      });
    }
    if (d.eventDateDayKey !== undefined && d.eventDateEpochMs === undefined) {
      ctx.addIssue({
        code: "custom",
        path: ["eventDateEpochMs"],
        message: "eventDateEpochMs is required when eventDateDayKey is set"
      });
    }
  });
export type CreateGroupRequest = z.infer<typeof CreateGroupRequestSchema>;

export const CreateGroupResponseSchema = z.object({
  groupId: z.string().min(1),
  inviteCode: z.string().min(8).max(8),
  group: z.object({
    groupId: z.string().min(1),
    name: z.string().min(1),
    ownerUid: z.string().min(1),
    lifecycleStatus: z.enum(["active", "archived"]),
    drawStatus: DrawStatusSchema,
    rulesVersionCurrent: z.number().int().positive()
  })
});
export type CreateGroupResponse = z.infer<typeof CreateGroupResponseSchema>;

export const JoinGroupByCodeRequestSchema = z.object({
  code: z.string().min(1),
  nickname: z.string().min(1).optional()
});
export type JoinGroupByCodeRequest = z.infer<typeof JoinGroupByCodeRequestSchema>;

export const JoinGroupByCodeResponseSchema = z.object({
  groupId: z.string().min(1)
});
export type JoinGroupByCodeResponse = z.infer<typeof JoinGroupByCodeResponseSchema>;

export const RotateInviteCodeRequestSchema = z.object({
  groupId: z.string().min(1)
});
export type RotateInviteCodeRequest = z.infer<typeof RotateInviteCodeRequestSchema>;

export const RotateInviteCodeResponseSchema = z.object({
  groupId: z.string().min(1),
  inviteCode: z.string().min(8).max(8)
});
export type RotateInviteCodeResponse = z.infer<typeof RotateInviteCodeResponseSchema>;

export const ManagedParticipantTypeSchema = z.enum(["managed", "child_managed"]);
export type ManagedParticipantType = z.infer<typeof ManagedParticipantTypeSchema>;

export const ManagedParticipantDeliveryModeSchema = z.enum([
  "verbal",
  "printed",
  "ownerDelegated",
  "whatsapp",
  "email"
]);
export type ManagedParticipantDeliveryMode = z.infer<typeof ManagedParticipantDeliveryModeSchema>;

export const CreateManagedParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  displayName: z.string().min(1),
  participantType: ManagedParticipantTypeSchema,
  subgroupId: z.string().min(1).nullable().optional(),
  deliveryMode: ManagedParticipantDeliveryModeSchema,
  /** Miembro activo del grupo que recibirá/entregará el resultado. Por defecto: quien crea (owner). */
  managedByUid: z.string().min(1).optional()
});
export type CreateManagedParticipantRequest = z.infer<typeof CreateManagedParticipantRequestSchema>;

export const CreateManagedParticipantResponseSchema = z.object({
  participantId: z.string().min(1),
  displayName: z.string().min(1),
  participantType: ManagedParticipantTypeSchema,
  subgroupId: z.string().min(1).nullable(),
  deliveryMode: ManagedParticipantDeliveryModeSchema
});
export type CreateManagedParticipantResponse = z.infer<typeof CreateManagedParticipantResponseSchema>;

export const UpdateManagedParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1),
  displayName: z.string().min(1),
  participantType: ManagedParticipantTypeSchema,
  subgroupId: z.string().min(1).nullable().optional(),
  deliveryMode: ManagedParticipantDeliveryModeSchema,
  managedByUid: z.string().min(1).nullable().optional()
});
export type UpdateManagedParticipantRequest = z.infer<typeof UpdateManagedParticipantRequestSchema>;

export const UpdateManagedParticipantResponseSchema = z.object({
  participantId: z.string().min(1),
  displayName: z.string().min(1),
  participantType: ManagedParticipantTypeSchema,
  subgroupId: z.string().min(1).nullable(),
  deliveryMode: ManagedParticipantDeliveryModeSchema
});
export type UpdateManagedParticipantResponse = z.infer<typeof UpdateManagedParticipantResponseSchema>;

export const RemoveManagedParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1)
});
export type RemoveManagedParticipantRequest = z.infer<typeof RemoveManagedParticipantRequestSchema>;

export const RemoveManagedParticipantResponseSchema = z.object({
  participantId: z.string().min(1),
  state: z.literal("removed")
});
export type RemoveManagedParticipantResponse = z.infer<typeof RemoveManagedParticipantResponseSchema>;

export const DeleteSubgroupRequestSchema = z.object({
  groupId: z.string().min(1),
  subgroupId: z.string().min(1)
});
export type DeleteSubgroupRequest = z.infer<typeof DeleteSubgroupRequestSchema>;

export const DeleteSubgroupResponseSchema = z.object({
  subgroupId: z.string().min(1),
  deleted: z.literal(true)
});
export type DeleteSubgroupResponse = z.infer<typeof DeleteSubgroupResponseSchema>;

export const DeleteGroupRequestSchema = z.object({
  groupId: z.string().min(1)
});
export type DeleteGroupRequest = z.infer<typeof DeleteGroupRequestSchema>;

export const DeleteGroupResponseSchema = z.object({
  ok: z.literal(true),
  groupId: z.string().min(1),
  alreadyDeleted: z.boolean()
});
export type DeleteGroupResponse = z.infer<typeof DeleteGroupResponseSchema>;

export const GetManagedAssignmentsRequestSchema = z.object({
  groupId: z.string().min(1),
  executionId: z.string().min(1)
});
export type GetManagedAssignmentsRequest = z.infer<typeof GetManagedAssignmentsRequestSchema>;

export const ManagedAssignmentItemSchema = z.object({
  giverParticipantId: z.string().min(1),
  giverDisplayName: z.string().min(1),
  giverType: ManagedParticipantTypeSchema,
  receiverParticipantId: z.string().min(1),
  receiverDisplayName: z.string().min(1),
  receiverType: z.enum(["app_member", "managed", "child_managed"]),
  receiverSubgroupName: z.string().nullable(),
  deliveryMode: ManagedParticipantDeliveryModeSchema,
  managedByCurrentUser: z.boolean()
});
export type ManagedAssignmentItem = z.infer<typeof ManagedAssignmentItemSchema>;

export const GetManagedAssignmentsResponseSchema = z.object({
  assignments: z.array(ManagedAssignmentItemSchema)
});
export type GetManagedAssignmentsResponse = z.infer<typeof GetManagedAssignmentsResponseSchema>;

const WishlistLinkInputSchema = z.object({
  label: z.union([z.string().max(80), z.null()]).optional(),
  url: z
    .string()
    .min(1)
    .max(2048)
    .regex(/^https?:\/\//i, "URL must start with http:// or https://")
});

export const GetWishlistRequestSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1)
});
export type GetWishlistRequest = z.infer<typeof GetWishlistRequestSchema>;

export const WishlistLinkDtoSchema = z.object({
  label: z.string().nullable().optional(),
  url: z.string().min(1).max(2048)
});
export type WishlistLinkDto = z.infer<typeof WishlistLinkDtoSchema>;

export const GetWishlistResponseSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1),
  wishText: z.string().nullable(),
  likesText: z.string().nullable(),
  avoidText: z.string().nullable(),
  links: z.array(WishlistLinkDtoSchema),
  updatedAtMillis: z.number().nullable().optional()
});
export type GetWishlistResponse = z.infer<typeof GetWishlistResponseSchema>;

export const SetWishlistRequestSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1),
  wishText: z.union([z.string().max(500), z.null()]),
  likesText: z.union([z.string().max(500), z.null()]),
  avoidText: z.union([z.string().max(500), z.null()]),
  links: z.array(WishlistLinkInputSchema).max(3)
});
export type SetWishlistRequest = z.infer<typeof SetWishlistRequestSchema>;

export const SetWishlistResponseSchema = z.object({
  ok: z.literal(true)
});
export type SetWishlistResponse = z.infer<typeof SetWishlistResponseSchema>;

export const SendGroupChatMessageRequestSchema = z.object({
  groupId: z.string().min(1),
  text: z.string().min(1).max(500)
});
export type SendGroupChatMessageRequest = z.infer<typeof SendGroupChatMessageRequestSchema>;

export const SendGroupChatMessageResponseSchema = z.object({
  ok: z.literal(true),
  messageId: z.string().min(1)
});
export type SendGroupChatMessageResponse = z.infer<typeof SendGroupChatMessageResponseSchema>;

export const DevRunTarciChatAutomationRequestSchema = z.object({
  groupId: z.string().min(1).optional(),
  dryRun: z.boolean().optional(),
  maxGroups: z.number().int().positive().max(500).optional()
});
export type DevRunTarciChatAutomationRequest = z.infer<typeof DevRunTarciChatAutomationRequestSchema>;

export const TarciDynamicTypeSchema = z.enum(["secret_santa", "simple_raffle", "teams"]);
export type TarciDynamicType = z.infer<typeof TarciDynamicTypeSchema>;

export const ResultVisibilitySchema = z.enum(["private_per_participant", "public_to_group"]);
export type ResultVisibility = z.infer<typeof ResultVisibilitySchema>;

export const RaffleStatusSchema = z.enum(["idle", "drawing", "completed", "failed"]);
export type RaffleStatus = z.infer<typeof RaffleStatusSchema>;

export const CreateRaffleGroupRequestSchema = z
  .object({
    name: z.string().min(1),
    nickname: z.string().min(1),
    raffleWinnerCount: z.number().int().min(1).max(500),
    ownerParticipatesInRaffle: z.boolean(),
    eventDateEpochMs: z.number().int().finite().positive().optional(),
    eventDateDayKey: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
    eventTimeZone: z.string().min(1).max(80).optional()
  })
  .superRefine((d, ctx) => {
    if (d.eventDateEpochMs !== undefined && !d.eventDateDayKey) {
      ctx.addIssue({
        code: "custom",
        path: ["eventDateDayKey"],
        message: "eventDateDayKey is required when eventDateEpochMs is set"
      });
    }
    if (d.eventDateDayKey !== undefined && d.eventDateEpochMs === undefined) {
      ctx.addIssue({
        code: "custom",
        path: ["eventDateEpochMs"],
        message: "eventDateEpochMs is required when eventDateDayKey is set"
      });
    }
  });
export type CreateRaffleGroupRequest = z.infer<typeof CreateRaffleGroupRequestSchema>;

export const CreateRaffleGroupResponseSchema = z.object({
  groupId: z.string().min(1),
  inviteCode: z.string().min(8).max(8),
  group: z.object({
    groupId: z.string().min(1),
    name: z.string().min(1),
    ownerUid: z.string().min(1),
    lifecycleStatus: z.enum(["active", "archived"]),
    dynamicType: TarciDynamicTypeSchema,
    resultVisibility: ResultVisibilitySchema,
    raffleStatus: RaffleStatusSchema,
    raffleWinnerCount: z.number().int().positive(),
    rulesVersionCurrent: z.number().int().positive()
  })
});
export type CreateRaffleGroupResponse = z.infer<typeof CreateRaffleGroupResponseSchema>;

export const ExecuteRaffleRequestSchema = z.object({
  groupId: z.string().min(1),
  idempotencyKey: z.string().min(1)
});
export type ExecuteRaffleRequest = z.infer<typeof ExecuteRaffleRequestSchema>;

export const RaffleWinnerSnapshotSchema = z.object({
  participantId: z.string().min(1),
  displayName: z.string().min(1),
  sourceType: z.enum(["app_member", "raffle_manual"]),
  memberUid: z.string().min(1).optional()
});
export type RaffleWinnerSnapshot = z.infer<typeof RaffleWinnerSnapshotSchema>;

export const ExecuteRaffleResponseSchema = z.object({
  executionId: z.string().min(1),
  winnerCount: z.number().int().positive(),
  eligibleParticipantCount: z.number().int().nonnegative(),
  winnerParticipantIds: z.array(z.string().min(1)),
  winnersSnapshot: z.array(RaffleWinnerSnapshotSchema)
});
export type ExecuteRaffleResponse = z.infer<typeof ExecuteRaffleResponseSchema>;

export const CreateRaffleManualParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  displayName: z.string().min(1).max(80)
});
export type CreateRaffleManualParticipantRequest = z.infer<typeof CreateRaffleManualParticipantRequestSchema>;

export const CreateRaffleManualParticipantResponseSchema = z.object({
  participantId: z.string().min(1)
});
export type CreateRaffleManualParticipantResponse = z.infer<
  typeof CreateRaffleManualParticipantResponseSchema
>;

export const UpdateRaffleManualParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1),
  displayName: z.string().min(1).max(80)
});
export type UpdateRaffleManualParticipantRequest = z.infer<typeof UpdateRaffleManualParticipantRequestSchema>;

export const UpdateRaffleManualParticipantResponseSchema = z.object({
  participantId: z.string().min(1)
});
export type UpdateRaffleManualParticipantResponse = z.infer<
  typeof UpdateRaffleManualParticipantResponseSchema
>;

export const RemoveRaffleManualParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1)
});
export type RemoveRaffleManualParticipantRequest = z.infer<typeof RemoveRaffleManualParticipantRequestSchema>;

export const RemoveRaffleManualParticipantResponseSchema = z.object({
  participantId: z.string().min(1),
  state: z.literal("removed")
});
export type RemoveRaffleManualParticipantResponse = z.infer<
  typeof RemoveRaffleManualParticipantResponseSchema
>;

export const TeamStatusSchema = z.enum(["idle", "generating", "completed", "failed"]);
export type TeamStatus = z.infer<typeof TeamStatusSchema>;

export const TeamGroupingModeSchema = z.enum(["team_count", "team_size"]);
export type TeamGroupingMode = z.infer<typeof TeamGroupingModeSchema>;

export const TeamsPresetSchema = z.enum(["standard", "pairings", "duels"]);
export type TeamsPreset = z.infer<typeof TeamsPresetSchema>;

export const TEAMS_MAX_ELIGIBLE = 100;

export const CreateTeamsGroupRequestSchema = z
  .object({
    name: z.string().min(1),
    nickname: z.string().min(1),
    teamsPreset: TeamsPresetSchema.optional(),
    groupingMode: TeamGroupingModeSchema,
    requestedTeamCount: z.number().int().min(2).max(TEAMS_MAX_ELIGIBLE).optional(),
    requestedTeamSize: z.number().int().min(2).max(TEAMS_MAX_ELIGIBLE).optional(),
    ownerParticipatesInTeams: z.boolean(),
    eventDateEpochMs: z.number().int().finite().positive().optional(),
    eventDateDayKey: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
    eventTimeZone: z.string().min(1).max(80).optional()
  })
  .superRefine((d, ctx) => {
    const preset = d.teamsPreset ?? "standard";
    if (preset === "pairings" || preset === "duels") {
      if (d.groupingMode !== "team_size" || d.requestedTeamSize !== 2) {
        ctx.addIssue({
          code: "custom",
          path: ["teamsPreset"],
          message: `${preset} preset requires team_size mode with size 2`
        });
      }
    }
    if (d.eventDateEpochMs !== undefined && !d.eventDateDayKey) {
      ctx.addIssue({
        code: "custom",
        path: ["eventDateDayKey"],
        message: "eventDateDayKey is required when eventDateEpochMs is set"
      });
    }
    if (d.eventDateDayKey !== undefined && d.eventDateEpochMs === undefined) {
      ctx.addIssue({
        code: "custom",
        path: ["eventDateEpochMs"],
        message: "eventDateEpochMs is required when eventDateDayKey is set"
      });
    }
    if (d.groupingMode === "team_count") {
      if (d.requestedTeamCount == null) {
        ctx.addIssue({
          code: "custom",
          path: ["requestedTeamCount"],
          message: "requestedTeamCount required for team_count mode"
        });
      }
    } else if (d.groupingMode === "team_size") {
      if (d.requestedTeamSize == null) {
        ctx.addIssue({
          code: "custom",
          path: ["requestedTeamSize"],
          message: "requestedTeamSize required for team_size mode"
        });
      }
    }
  });
export type CreateTeamsGroupRequest = z.infer<typeof CreateTeamsGroupRequestSchema>;

export const CreateTeamsGroupResponseSchema = z.object({
  groupId: z.string().min(1),
  inviteCode: z.string().min(8).max(8),
  group: z.object({
    groupId: z.string().min(1),
    name: z.string().min(1),
    ownerUid: z.string().min(1),
    lifecycleStatus: z.enum(["active", "archived"]),
    dynamicType: z.literal("teams"),
    resultVisibility: ResultVisibilitySchema,
    teamStatus: TeamStatusSchema,
    groupingMode: TeamGroupingModeSchema,
    rulesVersionCurrent: z.number().int().positive()
  })
});
export type CreateTeamsGroupResponse = z.infer<typeof CreateTeamsGroupResponseSchema>;

export const ExecuteTeamsRequestSchema = z.object({
  groupId: z.string().min(1),
  idempotencyKey: z.string().min(1)
});
export type ExecuteTeamsRequest = z.infer<typeof ExecuteTeamsRequestSchema>;

export const TeamMemberSnapshotSchema = z.object({
  participantId: z.string().min(1),
  displayName: z.string().min(1),
  sourceType: z.enum(["app_member", "teams_manual"]),
  memberUid: z.string().min(1).optional()
});
export type TeamMemberSnapshot = z.infer<typeof TeamMemberSnapshotSchema>;

export const TeamSnapshotSchema = z.object({
  teamIndex: z.number().int().nonnegative(),
  teamLabel: z.string().min(1),
  members: z.array(TeamMemberSnapshotSchema)
});
export type TeamSnapshot = z.infer<typeof TeamSnapshotSchema>;

export const ExecuteTeamsResponseSchema = z.object({
  executionId: z.string().min(1),
  eligibleParticipantCount: z.number().int().nonnegative(),
  teamCount: z.number().int().positive(),
  teamsSnapshot: z.array(TeamSnapshotSchema)
});
export type ExecuteTeamsResponse = z.infer<typeof ExecuteTeamsResponseSchema>;

export const CreateTeamsManualParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  displayName: z.string().min(1).max(80)
});
export type CreateTeamsManualParticipantRequest = z.infer<
  typeof CreateTeamsManualParticipantRequestSchema
>;

export const CreateTeamsManualParticipantResponseSchema = z.object({
  participantId: z.string().min(1)
});
export type CreateTeamsManualParticipantResponse = z.infer<
  typeof CreateTeamsManualParticipantResponseSchema
>;

export const UpdateTeamsManualParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1),
  displayName: z.string().min(1).max(80)
});
export type UpdateTeamsManualParticipantRequest = z.infer<
  typeof UpdateTeamsManualParticipantRequestSchema
>;

export const UpdateTeamsManualParticipantResponseSchema = z.object({
  participantId: z.string().min(1)
});
export type UpdateTeamsManualParticipantResponse = z.infer<
  typeof UpdateTeamsManualParticipantResponseSchema
>;

export const RemoveTeamsManualParticipantRequestSchema = z.object({
  groupId: z.string().min(1),
  participantId: z.string().min(1)
});
export type RemoveTeamsManualParticipantRequest = z.infer<
  typeof RemoveTeamsManualParticipantRequestSchema
>;

export const RemoveTeamsManualParticipantResponseSchema = z.object({
  participantId: z.string().min(1),
  state: z.literal("removed")
});
export type RemoveTeamsManualParticipantResponse = z.infer<
  typeof RemoveTeamsManualParticipantResponseSchema
>;

export const UpdateTeamLabelRequestSchema = z.object({
  groupId: z.string().min(1),
  teamIndex: z.number().int().min(0),
  teamLabel: z.string().min(1).max(40)
});
export type UpdateTeamLabelRequest = z.infer<typeof UpdateTeamLabelRequestSchema>;

export const UpdateTeamLabelResponseSchema = z.object({
  teamIndex: z.number().int().min(0),
  teamLabel: z.string().min(1)
});
export type UpdateTeamLabelResponse = z.infer<typeof UpdateTeamLabelResponseSchema>;

export const PushPlatformSchema = z.enum(["android", "ios", "web", "unknown"]);
export type PushPlatform = z.infer<typeof PushPlatformSchema>;

export const PreferredLocaleSchema = z.enum(["es", "en", "pt", "it", "fr"]);

export const RegisterPushTokenRequestSchema = z.object({
  token: z.string().min(20).max(4096),
  platform: PushPlatformSchema.optional(),
  preferredLocale: PreferredLocaleSchema.optional()
});
export type RegisterPushTokenRequest = z.infer<typeof RegisterPushTokenRequestSchema>;

export const RegisterPushTokenResponseSchema = z.object({
  ok: z.literal(true)
});
export type RegisterPushTokenResponse = z.infer<typeof RegisterPushTokenResponseSchema>;
