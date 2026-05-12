enum DrawStatus { idle, drawing, completed, failed }

/// Regla de subgrupos para el sorteo (almacenada en `rules/{version}.subgroupMode`).
enum DrawSubgroupRule {
  ignore,
  preferDifferent,
  requireDifferent,
}

extension DrawSubgroupRuleStorage on DrawSubgroupRule {
  String get storageSubgroupMode {
    switch (this) {
      case DrawSubgroupRule.ignore:
        return 'ignore';
      case DrawSubgroupRule.preferDifferent:
        return 'preferDifferent';
      case DrawSubgroupRule.requireDifferent:
        return 'requireDifferent';
    }
  }
}

DrawSubgroupRule parseDrawSubgroupRule(String? raw) {
  final s = raw?.trim() ?? '';
  if (s == 'preferDifferent') return DrawSubgroupRule.preferDifferent;
  if (s == 'requireDifferent' || s == 'different') return DrawSubgroupRule.requireDifferent;
  return DrawSubgroupRule.ignore;
}

enum MemberRole { owner, member }
enum MemberState { active, left, removed }
enum GroupParticipantType { appMember, managed, childManaged }
enum GroupParticipantState { active, removed }
enum ManagedParticipantDeliveryMode { inApp, ownerDelegated, verbal, printed }

class GroupSummary {
  final String groupId;
  final String name;
  final MemberRole role;
  final bool isActiveMember;

  const GroupSummary({
    required this.groupId,
    required this.name,
    required this.role,
    required this.isActiveMember,
  });
}

class GroupMember {
  final String uid;
  final MemberRole role;
  final MemberState memberState;
  final String nickname;
  final String? subgroupId;

  const GroupMember({
    required this.uid,
    required this.role,
    required this.memberState,
    required this.nickname,
    required this.subgroupId,
  });
}

class CreatedGroup {
  final String groupId;
  final String inviteCode;

  const CreatedGroup({
    required this.groupId,
    required this.inviteCode,
  });
}

class Subgroup {
  final String subgroupId;
  final String name;
  final String? color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Subgroup({
    required this.subgroupId,
    required this.name,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });
}

class GroupDetail {
  final String groupId;
  final String name;
  final String ownerUid;
  final DrawStatus drawStatus;
  final int rulesVersionCurrent;
  final DrawSubgroupRule drawSubgroupRule;
  final String? currentExecutionId;
  final String? lastExecutionId;
  final List<Subgroup> subgroups;
  final List<GroupMember> members;
  final List<GroupParticipant> managedParticipants;

  const GroupDetail({
    required this.groupId,
    required this.name,
    required this.ownerUid,
    required this.drawStatus,
    required this.rulesVersionCurrent,
    required this.drawSubgroupRule,
    required this.currentExecutionId,
    required this.lastExecutionId,
    required this.subgroups,
    required this.members,
    required this.managedParticipants,
  });
}

class GroupParticipant {
  final String participantId;
  final String displayName;
  final GroupParticipantType participantType;
  final String? linkedUid;
  final String? managedByUid;
  final MemberRole roleInGroup;
  final GroupParticipantState state;
  final String? subgroupId;
  final ManagedParticipantDeliveryMode deliveryMode;
  final bool canReceiveDirectResult;
  final String source;

  const GroupParticipant({
    required this.participantId,
    required this.displayName,
    required this.participantType,
    required this.linkedUid,
    required this.managedByUid,
    required this.roleInGroup,
    required this.state,
    required this.subgroupId,
    required this.deliveryMode,
    required this.canReceiveDirectResult,
    required this.source,
  });
}

