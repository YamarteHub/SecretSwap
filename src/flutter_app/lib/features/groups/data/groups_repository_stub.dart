import 'dart:async';

import '../domain/group_models.dart';
import '../domain/groups_repository.dart';

class GroupsRepositoryStub implements GroupsRepository {
  @override
  Future<CreatedGroup> createGroup({
    required String name,
    required String nickname,
    DateTime? eventDate,
  }) async {
    throw UnimplementedError('createGroup not wired');
  }

  @override
  Future<void> renameGroup({
    required String groupId,
    required String name,
  }) async {
    throw UnimplementedError('renameGroup not wired');
  }

  @override
  Future<String> joinGroupByCode({
    required String code,
    String? nickname,
  }) async {
    throw UnimplementedError('joinGroupByCode not wired');
  }

  @override
  Future<List<GroupSummary>> listMyGroups() async {
    return const [];
  }

  @override
  Future<GroupDetail> getGroupDetail(String groupId) async {
    throw UnimplementedError('getGroupDetail not wired');
  }

  @override
  Stream<DrawStatus> watchGroupDrawStatus(String groupId) {
    return Stream.value(DrawStatus.idle);
  }

  @override
  Future<Subgroup> createSubgroup({
    required String groupId,
    required String name,
  }) async {
    throw UnimplementedError('createSubgroup not wired');
  }

  @override
  Future<void> renameSubgroup({
    required String groupId,
    required String subgroupId,
    required String name,
  }) async {
    throw UnimplementedError('renameSubgroup not wired');
  }

  @override
  Future<void> deleteSubgroup({
    required String groupId,
    required String subgroupId,
  }) async {
    throw UnimplementedError('deleteSubgroup not wired');
  }

  @override
  Future<void> setMemberSubgroup({
    required String groupId,
    required String memberUid,
    String? subgroupId,
  }) async {
    throw UnimplementedError('setMemberSubgroup not wired');
  }

  @override
  Future<void> setDrawSubgroupRule({
    required String groupId,
    required DrawSubgroupRule mode,
  }) async {
    throw UnimplementedError('setDrawSubgroupRule not wired');
  }

  @override
  Future<String> rotateInviteCode({required String groupId}) async {
    throw UnimplementedError('rotateInviteCode not wired');
  }

  @override
  Future<void> createManagedParticipant({
    required String groupId,
    required String displayName,
    required String participantType,
    String? subgroupId,
    required String deliveryMode,
    String? managedByUid,
  }) async {
    throw UnimplementedError('createManagedParticipant not wired');
  }

  @override
  Future<void> updateManagedParticipant({
    required String groupId,
    required String participantId,
    required String displayName,
    required String participantType,
    String? subgroupId,
    required String deliveryMode,
    String? managedByUid,
    bool syncManagedByUid = false,
  }) async {
    throw UnimplementedError('updateManagedParticipant not wired');
  }

  @override
  Future<void> removeManagedParticipant({
    required String groupId,
    required String participantId,
  }) async {
    throw UnimplementedError('removeManagedParticipant not wired');
  }
}
