enum DrawStatus { idle, drawing, completed, failed }

enum TarciDynamicType { secretSanta, simpleRaffle, teams }

enum ResultVisibility { privatePerParticipant, publicToGroup }

enum RaffleStatus { idle, drawing, completed, failed }

enum TeamStatus { idle, generating, completed, failed }

enum TeamGroupingMode { teamCount, teamSize }

enum TeamsPreset { standard, pairings, duels }

TeamsPreset parseTeamsPreset(String? raw) {
  final s = raw?.trim() ?? '';
  if (s == 'pairings') return TeamsPreset.pairings;
  if (s == 'duels') return TeamsPreset.duels;
  return TeamsPreset.standard;
}

TarciDynamicType parseTarciDynamicType(String? raw) {
  final s = raw?.trim() ?? '';
  if (s == 'simple_raffle') return TarciDynamicType.simpleRaffle;
  if (s == 'teams') return TarciDynamicType.teams;
  return TarciDynamicType.secretSanta;
}

ResultVisibility parseResultVisibility(String? raw, {TarciDynamicType? fallbackDynamic}) {
  final s = raw?.trim() ?? '';
  if (s == 'public_to_group') return ResultVisibility.publicToGroup;
  if (s == 'private_per_participant') return ResultVisibility.privatePerParticipant;
  if (fallbackDynamic == TarciDynamicType.simpleRaffle ||
      fallbackDynamic == TarciDynamicType.teams) {
    return ResultVisibility.publicToGroup;
  }
  return ResultVisibility.privatePerParticipant;
}

TeamStatus parseTeamStatus(String? raw) {
  final k = raw?.trim().toLowerCase() ?? '';
  return TeamStatus.values.firstWhere(
    (e) => e.name == k,
    orElse: () => TeamStatus.idle,
  );
}

TeamGroupingMode parseTeamGroupingMode(String? raw) {
  final s = raw?.trim() ?? '';
  if (s == 'team_size') return TeamGroupingMode.teamSize;
  return TeamGroupingMode.teamCount;
}

RaffleStatus parseRaffleStatus(String? raw) {
  final k = raw?.trim().toLowerCase() ?? '';
  return RaffleStatus.values.firstWhere(
    (e) => e.name == k,
    orElse: () => RaffleStatus.idle,
  );
}

class RaffleManualParticipant {
  final String participantId;
  final String displayName;

  const RaffleManualParticipant({
    required this.participantId,
    required this.displayName,
  });
}

class RaffleWinnerSnapshot {
  final String participantId;
  final String displayName;
  final String sourceType;
  final String? memberUid;

  const RaffleWinnerSnapshot({
    required this.participantId,
    required this.displayName,
    required this.sourceType,
    this.memberUid,
  });
}

class RaffleExecutionSummary {
  final String executionId;
  final int winnerCount;
  final int eligibleParticipantCount;
  final List<RaffleWinnerSnapshot> winnersSnapshot;
  final DateTime? createdAt;

  const RaffleExecutionSummary({
    required this.executionId,
    required this.winnerCount,
    required this.eligibleParticipantCount,
    required this.winnersSnapshot,
    this.createdAt,
  });
}

/// Respuesta mínima tras `executeRaffle` (callable).
class RaffleExecuteResult {
  final String executionId;
  final List<RaffleWinnerSnapshot> winnersSnapshot;

  const RaffleExecuteResult({
    required this.executionId,
    required this.winnersSnapshot,
  });
}

class TeamsManualParticipant {
  final String participantId;
  final String displayName;

  const TeamsManualParticipant({
    required this.participantId,
    required this.displayName,
  });
}

class TeamMemberSnapshot {
  final String participantId;
  final String displayName;
  final String sourceType;
  final String? memberUid;

  const TeamMemberSnapshot({
    required this.participantId,
    required this.displayName,
    required this.sourceType,
    this.memberUid,
  });
}

class TeamSnapshot {
  final int teamIndex;
  final String teamLabel;
  final List<TeamMemberSnapshot> members;

  const TeamSnapshot({
    required this.teamIndex,
    required this.teamLabel,
    required this.members,
  });
}

class TeamsExecutionSummary {
  final String executionId;
  final int eligibleParticipantCount;
  final int teamCount;
  final List<TeamSnapshot> teamsSnapshot;
  final DateTime? createdAt;

  const TeamsExecutionSummary({
    required this.executionId,
    required this.eligibleParticipantCount,
    required this.teamCount,
    required this.teamsSnapshot,
    this.createdAt,
  });
}

class TeamsExecuteResult {
  final String executionId;
  final List<TeamSnapshot> teamsSnapshot;

  const TeamsExecuteResult({
    required this.executionId,
    required this.teamsSnapshot,
  });
}

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
enum GroupParticipantType { appMember, managed, childManaged, raffleManual, teamsManual }
enum GroupParticipantState { active, removed }
enum ManagedParticipantDeliveryMode {
  inApp,
  ownerDelegated,
  verbal,
  printed,
  whatsapp,
  email,
}

class GroupSummary {
  final String groupId;
  final String name;
  final MemberRole role;
  final bool isActiveMember;
  /// Copiado desde `groups/{id}.drawStatus` al listar (no forma parte de `user_groups`).
  final DrawStatus drawStatus;
  final TarciDynamicType dynamicType;
  final RaffleStatus raffleStatus;
  final TeamStatus teamStatus;
  final TeamsPreset teamsPreset;
  /// `groups/{id}.lastDrawCompletedAt` cuando el sorteo ya se ejecutó (opcional).
  final DateTime? lastDrawCompletedAt;
  final DateTime? lastRaffleCompletedAt;
  final DateTime? lastTeamCompletedAt;
  /// `groups/{id}.eventDate` — fecha de entrega o evento (opcional).
  final DateTime? eventDate;

  const GroupSummary({
    required this.groupId,
    required this.name,
    required this.role,
    required this.isActiveMember,
    this.drawStatus = DrawStatus.idle,
    this.dynamicType = TarciDynamicType.secretSanta,
    this.raffleStatus = RaffleStatus.idle,
    this.teamStatus = TeamStatus.idle,
    this.teamsPreset = TeamsPreset.standard,
    this.lastDrawCompletedAt,
    this.lastRaffleCompletedAt,
    this.lastTeamCompletedAt,
    this.eventDate,
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
  final TarciDynamicType dynamicType;
  final ResultVisibility resultVisibility;
  final DrawStatus drawStatus;
  final RaffleStatus raffleStatus;
  final int raffleWinnerCount;
  final bool ownerParticipatesInRaffle;
  final String? lastRaffleExecutionId;
  final RaffleExecutionSummary? lastRaffleExecution;
  final List<RaffleManualParticipant> raffleManualParticipants;
  final TeamStatus teamStatus;
  final TeamsPreset teamsPreset;
  final TeamGroupingMode groupingMode;
  final int? requestedTeamCount;
  final int? requestedTeamSize;
  final bool ownerParticipatesInTeams;
  final String? lastTeamExecutionId;
  final TeamsExecutionSummary? lastTeamExecution;
  final List<TeamsManualParticipant> teamsManualParticipants;
  final int rulesVersionCurrent;
  final DrawSubgroupRule drawSubgroupRule;
  final String? currentExecutionId;
  final String? lastExecutionId;
  final DateTime? lastDrawCompletedAt;
  final DateTime? lastRaffleCompletedAt;
  final DateTime? lastTeamCompletedAt;
  final DateTime? eventDate;
  final List<Subgroup> subgroups;
  final List<GroupMember> members;
  final List<GroupParticipant> managedParticipants;

  const GroupDetail({
    required this.groupId,
    required this.name,
    required this.ownerUid,
    this.dynamicType = TarciDynamicType.secretSanta,
    this.resultVisibility = ResultVisibility.privatePerParticipant,
    required this.drawStatus,
    this.raffleStatus = RaffleStatus.idle,
    this.raffleWinnerCount = 1,
    this.ownerParticipatesInRaffle = true,
    this.lastRaffleExecutionId,
    this.lastRaffleExecution,
    this.raffleManualParticipants = const [],
    this.teamStatus = TeamStatus.idle,
    this.teamsPreset = TeamsPreset.standard,
    this.groupingMode = TeamGroupingMode.teamCount,
    this.requestedTeamCount,
    this.requestedTeamSize,
    this.ownerParticipatesInTeams = true,
    this.lastTeamExecutionId,
    this.lastTeamExecution,
    this.teamsManualParticipants = const [],
    required this.rulesVersionCurrent,
    required this.drawSubgroupRule,
    required this.currentExecutionId,
    required this.lastExecutionId,
    this.lastDrawCompletedAt,
    this.lastRaffleCompletedAt,
    this.lastTeamCompletedAt,
    this.eventDate,
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

/// Valores persistidos en Cloud Functions / Firestore para participantes gestionados.
extension ManagedParticipantDeliveryModeApi on ManagedParticipantDeliveryMode {
  String toFirestoreString() {
    switch (this) {
      case ManagedParticipantDeliveryMode.printed:
        return 'printed';
      case ManagedParticipantDeliveryMode.verbal:
        return 'verbal';
      case ManagedParticipantDeliveryMode.whatsapp:
        return 'whatsapp';
      case ManagedParticipantDeliveryMode.email:
        return 'email';
      case ManagedParticipantDeliveryMode.ownerDelegated:
      case ManagedParticipantDeliveryMode.inApp:
        return 'verbal';
    }
  }
}

