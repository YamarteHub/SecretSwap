import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../domain/group_models.dart';
import '../domain/groups_repository.dart';

Map<String, dynamic> _asStringKeyMap(dynamic raw) {
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v));
  }
  throw ArgumentError('Respuesta inesperada del backend');
}

class GroupsRepositoryImpl implements GroupsRepository {
  GroupsRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _functions =
           functions ?? FirebaseFunctions.instanceFor(region: 'us-central1'),
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
  Future<CreatedGroup> createGroup({
    required String name,
    required String nickname,
  }) async {
    final callable = _functions.httpsCallable('createGroup');
    final result = await callable.call(<String, dynamic>{
      'name': name,
      'nickname': nickname,
    });
    final data = _asStringKeyMap(result.data);
    final groupId = data['groupId'] as String?;
    final inviteCode = data['inviteCode'] as String?;
    if (groupId == null || inviteCode == null) {
      throw StateError('createGroup: faltan groupId o inviteCode');
    }
    return CreatedGroup(groupId: groupId, inviteCode: inviteCode);
  }

  @override
  Future<void> renameGroup({
    required String groupId,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('El nombre del grupo no puede estar vacío');
    }
    await _firestore.doc('groups/$groupId').update({
      'name': trimmed,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _firestore.doc('user_groups/$_uid/groups/$groupId').update({
      'name': trimmed,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<String> joinGroupByCode({
    required String code,
    String? nickname,
  }) async {
    final callable = _functions.httpsCallable('joinGroupByCode');
    final payload = <String, dynamic>{'code': code.trim()};
    if (nickname != null && nickname.trim().isNotEmpty) {
      payload['nickname'] = nickname.trim();
    }
    final result = await callable.call(payload);
    final data = _asStringKeyMap(result.data);
    final groupId = data['groupId'] as String?;
    if (groupId == null) throw StateError('joinGroupByCode: falta groupId');
    return groupId;
  }

  @override
  Future<List<GroupSummary>> listMyGroups() async {
    final snap = await _firestore
        .collection('user_groups')
        .doc(_uid)
        .collection('groups')
        .get();
    return snap.docs.map((d) {
      final m = d.data();
      return GroupSummary(
        groupId: m['groupId'] as String? ?? d.id,
        name: m['name'] as String? ?? '',
        role: _parseRole(m['role'] as String? ?? 'member'),
        isActiveMember: m['isActiveMember'] as bool? ?? false,
      );
    }).toList();
  }

  @override
  Future<GroupDetail> getGroupDetail(String groupId) async {
    final gRef = _firestore.doc('groups/$groupId');
    final gSnap = await gRef.get();
    if (!gSnap.exists) {
      throw StateError('Grupo no encontrado');
    }
    final g = gSnap.data()!;
    final rulesVersion = (g['rulesVersionCurrent'] as num?)?.toInt() ?? 1;
    final ruleSnap = await _firestore
        .doc('groups/$groupId/rules/$rulesVersion')
        .get();
    final rawMode = ruleSnap.data()?['subgroupMode'] as String?;
    final drawSubgroupRule = parseDrawSubgroupRule(rawMode);

    final membersSnap = await _firestore
        .collection('groups/$groupId/members')
        .get();
    final members = membersSnap.docs.map((doc) {
      final m = doc.data();
      return GroupMember(
        uid: m['uid'] as String? ?? doc.id,
        role: _parseRole(m['role'] as String? ?? 'member'),
        memberState: _parseMemberState(m['memberState'] as String? ?? 'active'),
        nickname: m['nickname'] as String? ?? '',
        subgroupId: m['subgroupId'] as String?,
      );
    }).toList()..sort((a, b) => a.nickname.compareTo(b.nickname));

    final subgroupsSnap = await _firestore
        .collection('groups/$groupId/subgroups')
        .get();
    final subgroups = subgroupsSnap.docs.map((doc) {
      final s = doc.data();
      return Subgroup(
        subgroupId: s['subgroupId'] as String? ?? doc.id,
        name: s['name'] as String? ?? '',
        color: s['color'] as String?,
        createdAt: (s['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (s['updatedAt'] as Timestamp?)?.toDate(),
      );
    }).toList()..sort((a, b) => a.name.compareTo(b.name));

    final participantsSnap = await _firestore
        .collection('groups/$groupId/participants')
        .get();
    final managedParticipants =
        participantsSnap.docs
            .map((doc) {
              final p = doc.data();
              return GroupParticipant(
                participantId: p['participantId'] as String? ?? doc.id,
                displayName: p['displayName'] as String? ?? '',
                participantType: _parseParticipantType(
                  p['participantType'] as String? ?? 'managed',
                ),
                linkedUid: p['linkedUid'] as String?,
                managedByUid: p['managedByUid'] as String?,
                roleInGroup: _parseRole(
                  p['roleInGroup'] as String? ?? 'member',
                ),
                state: _parseParticipantState(
                  p['state'] as String? ?? 'active',
                ),
                subgroupId: p['subgroupId'] as String?,
                deliveryMode: _parseDeliveryMode(
                  p['deliveryMode'] as String? ?? 'ownerDelegated',
                ),
                canReceiveDirectResult:
                    p['canReceiveDirectResult'] as bool? ?? false,
                source: p['source'] as String? ?? 'managed_created',
              );
            })
            .where((p) => p.state == GroupParticipantState.active)
            .toList()
          ..sort((a, b) => a.displayName.compareTo(b.displayName));

    return GroupDetail(
      groupId: g['groupId'] as String? ?? groupId,
      name: g['name'] as String? ?? '',
      ownerUid: g['ownerUid'] as String? ?? '',
      drawStatus: _parseDrawStatus(g['drawStatus'] as String? ?? 'idle'),
      rulesVersionCurrent: rulesVersion,
      drawSubgroupRule: drawSubgroupRule,
      currentExecutionId: g['currentExecutionId'] as String?,
      lastExecutionId: g['lastExecutionId'] as String?,
      subgroups: subgroups,
      members: members,
      managedParticipants: managedParticipants,
    );
  }

  @override
  Future<Subgroup> createSubgroup({
    required String groupId,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('El nombre del subgrupo no puede estar vacío');
    }
    final col = _firestore.collection('groups/$groupId/subgroups');
    final doc = col.doc();
    final id = doc.id;
    final now = FieldValue.serverTimestamp();
    await doc.set({
      'subgroupId': id,
      'name': trimmed,
      'color': null,
      'createdAt': now,
      'updatedAt': now,
    });
    return Subgroup(
      subgroupId: id,
      name: trimmed,
      color: null,
      createdAt: null,
      updatedAt: null,
    );
  }

  @override
  Future<void> renameSubgroup({
    required String groupId,
    required String subgroupId,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('El nombre del subgrupo no puede estar vacío');
    }
    await _firestore.doc('groups/$groupId/subgroups/$subgroupId').update({
      'name': trimmed,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteSubgroup({
    required String groupId,
    required String subgroupId,
  }) async {
    final callable = _functions.httpsCallable('deleteSubgroup');
    await callable.call(<String, dynamic>{
      'groupId': groupId,
      'subgroupId': subgroupId,
    });
  }

  @override
  Future<void> setMemberSubgroup({
    required String groupId,
    required String memberUid,
    String? subgroupId,
  }) async {
    final ref = _firestore.doc('groups/$groupId/members/$memberUid');
    if (subgroupId == null || subgroupId.isEmpty) {
      await ref.update({'subgroupId': FieldValue.delete()});
    } else {
      await ref.update({'subgroupId': subgroupId});
    }
  }

  @override
  Future<void> setDrawSubgroupRule({
    required String groupId,
    required DrawSubgroupRule mode,
  }) async {
    final gRef = _firestore.doc('groups/$groupId');
    final gSnap = await gRef.get();
    if (!gSnap.exists) {
      throw StateError('Grupo no encontrado');
    }
    final g = gSnap.data()!;
    final drawStatus = g['drawStatus'] as String? ?? 'idle';
    if (drawStatus != 'idle' && drawStatus != 'failed') {
      throw StateError(
        'No se puede cambiar la regla mientras el sorteo no está en reposo.',
      );
    }
    final current = (g['rulesVersionCurrent'] as num?)?.toInt() ?? 1;
    final next = current + 1;
    final subgroupMode = mode.storageSubgroupMode;
    final rulePath = 'groups/$groupId/rules/$next';
    final rulePayload = <String, dynamic>{
      'version': next,
      'subgroupMode': subgroupMode,
      'exclusions': <dynamic>[],
      'createdByUid': _uid,
      'createdAt': FieldValue.serverTimestamp(),
    };
    final groupUpdatePayload = <String, dynamic>{
      'rulesVersionCurrent': next,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    debugPrint('[setDrawSubgroupRule] groupId=$groupId');
    debugPrint('[setDrawSubgroupRule] currentRulesVersionCurrent=$current');
    debugPrint('[setDrawSubgroupRule] nextVersion=$next');
    debugPrint('[setDrawSubgroupRule] subgroupMode=$subgroupMode');
    debugPrint('[setDrawSubgroupRule] rulesDocPath=$rulePath');
    debugPrint('[setDrawSubgroupRule] rulesDocPayload=$rulePayload');
    debugPrint('[setDrawSubgroupRule] groupUpdatePayload=$groupUpdatePayload');

    final batch = _firestore.batch();
    final ruleRef = _firestore.doc('groups/$groupId/rules/$next');
    batch.set(ruleRef, rulePayload);
    batch.update(gRef, groupUpdatePayload);
    await batch.commit();
  }

  @override
  Future<String> rotateInviteCode({required String groupId}) async {
    final callable = _functions.httpsCallable('rotateInviteCode');
    final result = await callable.call(<String, dynamic>{'groupId': groupId});
    final data = _asStringKeyMap(result.data);
    final returnedGroupId = data['groupId'] as String?;
    final inviteCode = data['inviteCode'] as String?;
    if (returnedGroupId == null || inviteCode == null) {
      throw StateError('rotateInviteCode: faltan groupId o inviteCode');
    }
    if (returnedGroupId != groupId) {
      throw StateError('rotateInviteCode: groupId inesperado en respuesta');
    }
    return inviteCode;
  }

  @override
  Future<void> createManagedParticipant({
    required String groupId,
    required String displayName,
    required String participantType,
    String? subgroupId,
    required String deliveryMode,
  }) async {
    final callable = _functions.httpsCallable('createManagedParticipant');
    await callable.call(<String, dynamic>{
      'groupId': groupId,
      'displayName': displayName.trim(),
      'participantType': participantType,
      'subgroupId': (subgroupId == null || subgroupId.trim().isEmpty)
          ? null
          : subgroupId.trim(),
      'deliveryMode': deliveryMode,
    });
  }

  @override
  Future<void> updateManagedParticipant({
    required String groupId,
    required String participantId,
    required String displayName,
    required String participantType,
    String? subgroupId,
    required String deliveryMode,
  }) async {
    final callable = _functions.httpsCallable('updateManagedParticipant');
    await callable.call(<String, dynamic>{
      'groupId': groupId,
      'participantId': participantId,
      'displayName': displayName.trim(),
      'participantType': participantType,
      'subgroupId': (subgroupId == null || subgroupId.trim().isEmpty)
          ? null
          : subgroupId.trim(),
      'deliveryMode': deliveryMode,
    });
  }

  @override
  Future<void> removeManagedParticipant({
    required String groupId,
    required String participantId,
  }) async {
    final callable = _functions.httpsCallable('removeManagedParticipant');
    await callable.call(<String, dynamic>{
      'groupId': groupId,
      'participantId': participantId,
    });
  }

  MemberRole _parseRole(String s) {
    return MemberRole.values.firstWhere(
      (e) => e.name == s,
      orElse: () => MemberRole.member,
    );
  }

  MemberState _parseMemberState(String s) {
    return MemberState.values.firstWhere(
      (e) => e.name == s,
      orElse: () => MemberState.active,
    );
  }

  DrawStatus _parseDrawStatus(String s) {
    return DrawStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => DrawStatus.idle,
    );
  }

  GroupParticipantType _parseParticipantType(String s) {
    if (s == 'child_managed') return GroupParticipantType.childManaged;
    if (s == 'app_member') return GroupParticipantType.appMember;
    return GroupParticipantType.managed;
  }

  GroupParticipantState _parseParticipantState(String s) {
    if (s == 'removed') return GroupParticipantState.removed;
    return GroupParticipantState.active;
  }

  ManagedParticipantDeliveryMode _parseDeliveryMode(String s) {
    if (s == 'inApp') return ManagedParticipantDeliveryMode.inApp;
    if (s == 'verbal') return ManagedParticipantDeliveryMode.verbal;
    if (s == 'printed') return ManagedParticipantDeliveryMode.printed;
    return ManagedParticipantDeliveryMode.ownerDelegated;
  }
}
