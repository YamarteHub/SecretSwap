import 'group_chat_message.dart';

abstract interface class GroupChatRepository {
  Stream<List<GroupChatMessage>> watchMessages(String groupId);

  Future<void> sendUserMessage({
    required String groupId,
    required String text,
  });
}
