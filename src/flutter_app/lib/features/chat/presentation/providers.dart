import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/group_chat_repository_impl.dart';
import '../domain/group_chat_message.dart';
import '../domain/group_chat_repository.dart';

final groupChatRepositoryProvider = Provider<GroupChatRepository>((ref) {
  return GroupChatRepositoryImpl();
});

final groupChatMessagesProvider =
    StreamProvider.autoDispose.family<List<GroupChatMessage>, String>((ref, groupId) {
  return ref.read(groupChatRepositoryProvider).watchMessages(groupId);
});
