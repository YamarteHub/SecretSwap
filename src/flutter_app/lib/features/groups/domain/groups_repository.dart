import 'group_models.dart';

abstract interface class GroupsRepository {
  Future<List<GroupSummary>> listMyGroups();

  Future<CreatedGroup> createGroup({
    required String name,
    required String nickname,
    /// Día civil local del evento/entrega; opcional (`groups.eventDate` en Firestore).
    DateTime? eventDate,
  });

  Future<void> renameGroup({required String groupId, required String name});

  Future<String> joinGroupByCode({required String code, String? nickname});

  Future<GroupDetail> getGroupDetail(String groupId);

  /// Emite el estado de sorteo de `groups/{groupId}` (misma lectura que en `getGroupDetail`).
  Stream<DrawStatus> watchGroupDrawStatus(String groupId);

  /// Estado del sorteo público (`raffleStatus`) para grupos `simple_raffle`.
  Stream<RaffleStatus> watchGroupRaffleStatus(String groupId);

  /// Estado de formación de equipos (`teamStatus`) para grupos `teams`.
  Stream<TeamStatus> watchGroupTeamStatus(String groupId);

  /// Firma estable de miembros + participantes; cambia al unirse alguien o editar el bombo.
  Stream<int> watchGroupRosterSignature(String groupId);

  Future<CreatedGroup> createRaffleGroup({
    required String name,
    required String nickname,
    required int raffleWinnerCount,
    required bool ownerParticipatesInRaffle,
    DateTime? eventDate,
  });

  Future<RaffleExecuteResult> executeRaffle({
    required String groupId,
    required String idempotencyKey,
  });

  Future<String> createRaffleManualParticipant({
    required String groupId,
    required String displayName,
  });

  Future<void> updateRaffleManualParticipant({
    required String groupId,
    required String participantId,
    required String displayName,
  });

  Future<void> removeRaffleManualParticipant({
    required String groupId,
    required String participantId,
  });

  Future<CreatedGroup> createTeamsGroup({
    required String name,
    required String nickname,
    required TeamGroupingMode groupingMode,
    int? requestedTeamCount,
    int? requestedTeamSize,
    required bool ownerParticipatesInTeams,
    TeamsPreset teamsPreset = TeamsPreset.standard,
    DateTime? eventDate,
  });

  Future<TeamsExecuteResult> executeTeams({
    required String groupId,
    required String idempotencyKey,
  });

  Future<String> createTeamsManualParticipant({
    required String groupId,
    required String displayName,
  });

  Future<void> updateTeamsManualParticipant({
    required String groupId,
    required String participantId,
    required String displayName,
  });

  Future<void> removeTeamsManualParticipant({
    required String groupId,
    required String participantId,
  });

  Future<void> updateTeamLabel({
    required String groupId,
    required int teamIndex,
    required String teamLabel,
  });

  /// Crea un subgrupo (Firestore: `groups/{groupId}/subgroups/{id}`).
  Future<Subgroup> createSubgroup({
    required String groupId,
    required String name,
  });

  Future<void> renameSubgroup({
    required String groupId,
    required String subgroupId,
    required String name,
  });

  Future<void> deleteSubgroup({
    required String groupId,
    required String subgroupId,
  });

  /// Asigna o quita subgrupo del miembro (`subgroupId` null = sin subgrupo).
  Future<void> setMemberSubgroup({
    required String groupId,
    required String memberUid,
    String? subgroupId,
  });

  /// Crea `rules/{N+1}` inmutable y actualiza `rulesVersionCurrent` (solo owner + reglas Firestore).
  Future<void> setDrawSubgroupRule({
    required String groupId,
    required DrawSubgroupRule mode,
  });

  /// Genera un nuevo código de invitación y devuelve el código en claro.
  Future<String> rotateInviteCode({required String groupId});

  Future<void> createManagedParticipant({
    required String groupId,
    required String displayName,
    required String participantType,
    String? subgroupId,
    required String deliveryMode,
    /// Miembro activo responsable (por defecto: quien crea, el owner).
    String? managedByUid,
  });

  Future<void> updateManagedParticipant({
    required String groupId,
    required String participantId,
    required String displayName,
    required String participantType,
    String? subgroupId,
    required String deliveryMode,
    String? managedByUid,
    /// Si es `true`, se envía `managedByUid` al callable (`null` = organizador).
    bool syncManagedByUid = false,
  });

  Future<void> removeManagedParticipant({
    required String groupId,
    required String participantId,
  });

  /// Elimina el grupo y datos asociados (solo backend; debe ser el owner).
  Future<void> deleteGroup(String groupId);
}
