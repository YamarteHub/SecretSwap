export const collections = {
  groups: () => "groups" as const,
  userGroups: () => "user_groups" as const,
  inviteCodes: () => "invite_codes" as const
};

export const groupPaths = {
  groupDoc: (groupId: string) => `groups/${groupId}`,
  membersCol: (groupId: string) => `groups/${groupId}/members`,
  memberDoc: (groupId: string, uid: string) => `groups/${groupId}/members/${uid}`,
  invitesCurrentDoc: (groupId: string) => `groups/${groupId}/invites/current`,
  rulesCol: (groupId: string) => `groups/${groupId}/rules`,
  ruleDoc: (groupId: string, version: number) => `groups/${groupId}/rules/${version}`,
  executionsCol: (groupId: string) => `groups/${groupId}/executions`,
  executionDoc: (groupId: string, executionId: string) => `groups/${groupId}/executions/${executionId}`,
  assignmentsCol: (groupId: string, executionId: string) =>
    `groups/${groupId}/executions/${executionId}/assignments`,
  assignmentDoc: (groupId: string, executionId: string, giverUid: string) =>
    `groups/${groupId}/executions/${executionId}/assignments/${giverUid}`,
  chatMessagesCol: (groupId: string) => `groups/${groupId}/chatMessages`,
  chatMessageDoc: (groupId: string, messageId: string) => `groups/${groupId}/chatMessages/${messageId}`,
  chatAutomationTarciStateDoc: (groupId: string) => `groups/${groupId}/chatAutomation/tarciState`
};

export const userGroupPaths = {
  userGroupsCol: (uid: string) => `user_groups/${uid}/groups`,
  userGroupDoc: (uid: string, groupId: string) => `user_groups/${uid}/groups/${groupId}`
};

export const inviteCodePaths = {
  inviteCodeDoc: (codeHash: string) => `invite_codes/${codeHash}`
};

