class MyAssignment {
  final String giverUid;
  final String executionId;
  final int rulesVersion;
  final String receiverUid;
  final String? receiverParticipantId;
  final String receiverNickname;
  final String? receiverSubgroupId;
  final String? receiverSubgroupName;

  const MyAssignment({
    required this.giverUid,
    required this.executionId,
    required this.rulesVersion,
    required this.receiverUid,
    this.receiverParticipantId,
    required this.receiverNickname,
    required this.receiverSubgroupId,
    required this.receiverSubgroupName,
  });
}

class ManagedAssignment {
  final String giverParticipantId;
  final String giverDisplayName;
  final String giverType;
  final String receiverParticipantId;
  final String receiverDisplayName;
  final String receiverType;
  final String? receiverSubgroupName;
  final String deliveryMode;
  final bool managedByCurrentUser;

  const ManagedAssignment({
    required this.giverParticipantId,
    required this.giverDisplayName,
    required this.giverType,
    required this.receiverParticipantId,
    required this.receiverDisplayName,
    required this.receiverType,
    required this.receiverSubgroupName,
    required this.deliveryMode,
    required this.managedByCurrentUser,
  });
}

