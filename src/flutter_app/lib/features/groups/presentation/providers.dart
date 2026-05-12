import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/groups_repository_impl.dart';
import '../domain/group_models.dart';
import '../domain/groups_repository.dart';

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  return GroupsRepositoryImpl();
});

final myGroupsProvider = FutureProvider.autoDispose<List<GroupSummary>>((ref) async {
  return ref.watch(groupsRepositoryProvider).listMyGroups();
});

final groupDetailProvider = FutureProvider.autoDispose.family<GroupDetail, String>((ref, groupId) async {
  return ref.watch(groupsRepositoryProvider).getGroupDetail(groupId);
});
