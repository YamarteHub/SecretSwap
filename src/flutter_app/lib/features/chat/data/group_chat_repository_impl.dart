import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../domain/group_chat_message.dart';
import '../domain/group_chat_repository.dart';

class GroupChatRepositoryImpl implements GroupChatRepository {
  GroupChatRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instanceFor(region: 'us-central1');

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  @override
  Stream<List<GroupChatMessage>> watchMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('chatMessages')
        .orderBy('createdAt', descending: false)
        .limit(200)
        .snapshots()
        .map((snap) {
      final out = <GroupChatMessage>[];
      for (final d in snap.docs) {
        final m = GroupChatMessage.fromFirestore(d.id, d.data());
        if (m != null) out.add(m);
      }
      return out;
    });
  }

  @override
  Future<void> sendUserMessage({
    required String groupId,
    required String text,
  }) async {
    final callable = _functions.httpsCallable('sendGroupChatMessage');
    await callable.call(<String, dynamic>{
      'groupId': groupId,
      'text': text,
    });
  }
}
