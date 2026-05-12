import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/draw_models.dart';
import '../domain/draw_repository.dart';

Map<String, dynamic> _asStringKeyMap(dynamic raw) {
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v));
  }
  throw ArgumentError('Respuesta inesperada del backend');
}

class DrawRepositoryImpl implements DrawRepository {
  DrawRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instanceFor(region: 'us-central1'),
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw StateError('No hay sesión');
    return u.uid;
  }

  @override
  Future<String> executeDraw({
    required String groupId,
    required String idempotencyKey,
  }) async {
    final callable = _functions.httpsCallable('executeDraw');
    final result = await callable.call(<String, dynamic>{
      'groupId': groupId,
      'idempotencyKey': idempotencyKey,
    });
    final data = _asStringKeyMap(result.data);
    final executionId = data['executionId'] as String?;
    if (executionId == null) throw StateError('executeDraw: falta executionId');
    return executionId;
  }

  @override
  Future<MyAssignment> getMyAssignment({
    required String groupId,
    required String executionId,
  }) async {
    final doc = await _firestore
        .doc('groups/$groupId/executions/$executionId/assignments/$_uid')
        .get();
    if (!doc.exists) {
      throw StateError('No hay asignación para este usuario');
    }
    final m = doc.data()!;
    return MyAssignment(
      giverUid: m['giverUid'] as String? ?? _uid,
      executionId: m['executionId'] as String? ?? executionId,
      rulesVersion: (m['rulesVersion'] as num?)?.toInt() ?? 1,
      receiverUid: m['receiverUid'] as String? ?? '',
      receiverNickname: m['receiverNicknameSnapshot'] as String? ?? '',
      receiverSubgroupId: m['receiverSubgroupIdSnapshot'] as String?,
      receiverSubgroupName: m['receiverSubgroupNameSnapshot'] as String?,
    );
  }

  @override
  Future<List<ManagedAssignment>> getManagedAssignments({
    required String groupId,
    required String executionId,
  }) async {
    final callable = _functions.httpsCallable('getManagedAssignments');
    final result = await callable.call(<String, dynamic>{
      'groupId': groupId,
      'executionId': executionId,
    });
    final data = _asStringKeyMap(result.data);
    final rawAssignments = data['assignments'];
    if (rawAssignments is! List) {
      throw StateError('getManagedAssignments: respuesta inválida');
    }
    return rawAssignments.map((raw) {
      final m = _asStringKeyMap(raw);
      return ManagedAssignment(
        giverParticipantId: m['giverParticipantId'] as String? ?? '',
        giverDisplayName: m['giverDisplayName'] as String? ?? 'Participante',
        giverType: m['giverType'] as String? ?? 'managed',
        receiverDisplayName: m['receiverDisplayName'] as String? ?? 'Participante',
        receiverType: m['receiverType'] as String? ?? 'app_member',
        receiverSubgroupName: m['receiverSubgroupName'] as String?,
        deliveryMode: m['deliveryMode'] as String? ?? 'ownerDelegated',
        managedByCurrentUser: m['managedByCurrentUser'] == true,
      );
    }).toList();
  }
}
