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

export const CreateGroupRequestSchema = z.object({
  name: z.string().min(1),
  nickname: z.string().min(1)
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

export const GetManagedAssignmentsRequestSchema = z.object({
  groupId: z.string().min(1),
  executionId: z.string().min(1)
});
export type GetManagedAssignmentsRequest = z.infer<typeof GetManagedAssignmentsRequestSchema>;

export const ManagedAssignmentItemSchema = z.object({
  giverParticipantId: z.string().min(1),
  giverDisplayName: z.string().min(1),
  giverType: ManagedParticipantTypeSchema,
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

