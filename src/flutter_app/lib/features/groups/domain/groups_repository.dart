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
