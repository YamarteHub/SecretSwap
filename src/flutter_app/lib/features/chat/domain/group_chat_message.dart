import 'package:cloud_firestore/cloud_firestore.dart';

enum GroupChatMessageKind { user, system }

class GroupChatMessage {
  const GroupChatMessage({
    required this.id,
    required this.kind,
    required this.createdAt,
    this.senderUid,
    this.senderDisplayName,
    this.text,
    this.templateKey,
    this.templateParams,
  });

  final String id;
  final GroupChatMessageKind kind;
  final DateTime? createdAt;
  final String? senderUid;
  final String? senderDisplayName;
  final String? text;
  final String? templateKey;
  final Map<String, dynamic>? templateParams;

  static GroupChatMessage? fromFirestore(String id, Map<String, dynamic> data) {
    final type = data['type'];
    final createdRaw = data['createdAt'];
    DateTime? createdAt;
    if (createdRaw is Timestamp) {
      createdAt = createdRaw.toDate();
    }

    if (type == 'user') {
      final text = data['text'];
      if (text is! String) return null;
      final senderUid = data['senderUid'];
      final senderDisplayName = data['senderDisplayName'];
      return GroupChatMessage(
        id: id,
        kind: GroupChatMessageKind.user,
        createdAt: createdAt,
        senderUid: senderUid is String ? senderUid : null,
        senderDisplayName: senderDisplayName is String ? senderDisplayName : null,
        text: text,
      );
    }
    if (type == 'system') {
      final templateKey = data['templateKey'];
      if (templateKey is! String || templateKey.isEmpty) return null;
      final paramsRaw = data['templateParams'];
      Map<String, dynamic>? templateParams;
      if (paramsRaw is Map) {
        templateParams = Map<String, dynamic>.from(paramsRaw);
      }
      return GroupChatMessage(
        id: id,
        kind: GroupChatMessageKind.system,
        createdAt: createdAt,
        templateKey: templateKey,
        templateParams: templateParams,
      );
    }
    return null;
  }
}
