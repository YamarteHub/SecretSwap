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

export const ExecuteDrawResponseSchema = z.object({
  executionId: z.string().min(1),
  status: ExecutionStatusSchema,
  rulesVersion: z.number().int().positive(),
  createdAt: z.any()
});
export type ExecuteDrawResponse = z.infer<typeof ExecuteDrawResponseSchema>;

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

