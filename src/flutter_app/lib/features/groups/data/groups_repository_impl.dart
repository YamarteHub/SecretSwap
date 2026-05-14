import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';

import '../domain/group_exceptions.dart';
import '../domain/group_models.dart';
import '../domain/groups_repository.dart';

Map<String, dynamic> _asStringKeyMap(dynamic raw) {
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v));
  }
  throw ArgumentError('Respuesta inesperada del backend');
}

DateTime? _readFirestoreOptionalDate(Map<String, dynamic> data, String key) {
  final raw = data[key];
  if (raw is Timestamp) return raw.toDate();
  return null;
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
    DateTime? eventDate,
  }) async {
    final callable = _functions.httpsCallable('createGroup');
    final payload = <String, dynamic>{
      'name': name,
      'nickname': nickname,
    };
    if (eventDate != null) {
      final day = DateTime(
        eventDate.year,
        eventDate.month,
        eventDate.day,
      );
      payload['eventDateEpochMs'] = day.millisecondsSinceEpoch;
      payload['eventDateDayKey'] = DateFormat('yyyy-MM-dd').format(day);
      try {
        final tz = await FlutterTimezone.getLocalTimezone();
        if (tz.isNotEmpty) {
          payload['eventTimeZone'] = tz;
        }
      } catch (_) {
        // Sin zona IANA el backend omite countdown exacto; el resto del motor sigue activo.
      }
    }
    final result = await callable.call(payload);
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
    final drawFromUserRow = <String, DrawStatus>{};
    final rows = snap.docs.map((d) {
      final m = d.data();
      final gid = (m['groupId'] as String? ?? d.id).trim();
      final rawUser = m['drawStatus'];
      if (rawUser is String && rawUser.trim().isNotEmpty) {
        drawFromUserRow[gid] = _parseDrawStatus(rawUser);
      }
      return GroupSummary(
        groupId: gid,
        name: m['name'] as String? ?? '',
        role: _parseRole(m['role'] as String? ?? 'member'),
        isActiveMember: m['isActiveMember'] as bool? ?? false,
      );
    }).toList();
    final ids = rows.map((g) => g.groupId).toSet().toList();
    final drawById = <String, DrawStatus>{};
    final lastDrawAtById = <String, DateTime?>{};
    final eventDateById = <String, DateTime?>{};
    if (ids.isNotEmpty) {
      final groupSnaps = await Future.wait(
        ids.map((id) => _firestore.doc('groups/$id').get()),
      );
      for (var i = 0; i < ids.length; i++) {
        final doc = groupSnaps[i];
        if (!doc.exists) continue;
        final gid = ids[i];
        final data = doc.data()!;
        drawById[gid] = _drawStatusFromGroupMap(data);
        lastDrawAtById[gid] =
            _readFirestoreOptionalDate(data, 'lastDrawCompletedAt');
        eventDateById[gid] = _readFirestoreOptionalDate(data, 'eventDate');
      }
    }
    return rows
        .map(
          (g) => GroupSummary(
            groupId: g.groupId,
            name: g.name,
            role: g.role,
            isActiveMember: g.isActiveMember,
            drawStatus: drawById[g.groupId] ??
                drawFromUserRow[g.groupId] ??
                DrawStatus.idle,
            lastDrawCompletedAt: lastDrawAtById[g.groupId],
            eventDate: eventDateById[g.groupId],
          ),
        )
        .toList();
  }

  @override
  Stream<DrawStatus> watchGroupDrawStatus(String groupId) {
    return _firestore.doc('groups/$groupId').snapshots().map((snap) {
      if (!snap.exists) return DrawStatus.idle;
      final g = snap.data();
      if (g == null) return DrawStatus.idle;
      return _drawStatusFromGroupMap(g);
    });
  }

  @override
  Future<GroupDetail> getGroupDetail(String groupId) async {
    final gRef = _firestore.doc('groups/$groupId');
    final gSnap = await gRef.get();
    if (!gSnap.exists) {
      throw GroupDocumentMissingException();
    }
    final g = gSnap.data()!;
    final rulesVersion = (g['rulesVersionCurrent'] as num?)?.toInt() ?? 1;
    final ownerUid = (g['ownerUid'] as String?) ?? '';
    final isDetailOwner = _uid == ownerUid;

    final participantsFuture = isDetailOwner
        ? _firestore.collection('groups/$groupId/participants').get()
        : _firestore
            .collection('groups/$groupId/participants')
            .where('managedByUid', isEqualTo: _uid)
            .get();

    final results = await Future.wait([
      _firestore.doc('groups/$groupId/rules/$rulesVersion').get(),
      _firestore.collection('groups/$groupId/members').get(),
      _firestore.collection('groups/$groupId/subgroups').get(),
      participantsFuture,
    ]);
    final ruleSnap = results[0] as DocumentSnapshot<Map<String, dynamic>>;
    final membersSnap = results[1] as QuerySnapshot<Map<String, dynamic>>;
    final subgroupsSnap = results[2] as QuerySnapshot<Map<String, dynamic>>;
    final participantsSnap = results[3] as QuerySnapshot<Map<String, dynamic>>;

    final rawMode = ruleSnap.exists
        ? (ruleSnap.data()?['subgroupMode'] as String?)
        : null;
    final drawSubgroupRule = parseDrawSubgroupRule(rawMode);

    final members = membersSnap.docs.map((doc) {
      final m = doc.data();
      return GroupMember(
        uid: m['uid'] as String? ?? doc.id,
        role: _parseRole(m['role'] as String? ?? 'member'),
        memberState: _parseMemberState(m['memberState'] as String? ?? 'active'),
        nickname: m['nickname'] as String? ?? '',
        subgroupId: m['subgroupId'] as String?,
      );
    }).toList()
      ..sort((a, b) => a.nickname.compareTo(b.nickname));

    final subgroups = subgroupsSnap.docs.map((doc) {
      final s = doc.data();
      return Subgroup(
        subgroupId: s['subgroupId'] as String? ?? doc.id,
        name: s['name'] as String? ?? '',
        color: s['color'] as String?,
        createdAt: (s['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (s['updatedAt'] as Timestamp?)?.toDate(),
      );
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

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
      drawStatus: _drawStatusFromGroupMap(g),
      rulesVersionCurrent: rulesVersion,
      drawSubgroupRule: drawSubgroupRule,
      currentExecutionId: g['currentExecutionId'] as String?,
      lastExecutionId: g['lastExecutionId'] as String?,
      lastDrawCompletedAt:
          _readFirestoreOptionalDate(g, 'lastDrawCompletedAt'),
      eventDate: _readFirestoreOptionalDate(g, 'eventDate'),
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
      throw GroupDocumentMissingException();
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
    String? managedByUid,
  }) async {
    final callable = _functions.httpsCallable('createManagedParticipant');
    final payload = <String, dynamic>{
      'groupId': groupId,
      'displayName': displayName.trim(),
      'participantType': participantType,
      'subgroupId': (subgroupId == null || subgroupId.trim().isEmpty)
          ? null
          : subgroupId.trim(),
      'deliveryMode': deliveryMode,
    };
    if (managedByUid != null && managedByUid.trim().isNotEmpty) {
      payload['managedByUid'] = managedByUid.trim();
    }
    await callable.call(payload);
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
    final callable = _functions.httpsCallable('updateManagedParticipant');
    final payload = <String, dynamic>{
      'groupId': groupId,
      'participantId': participantId,
      'displayName': displayName.trim(),
      'participantType': participantType,
      'subgroupId': (subgroupId == null || subgroupId.trim().isEmpty)
          ? null
          : subgroupId.trim(),
      'deliveryMode': deliveryMode,
    };
    if (syncManagedByUid) {
      payload['managedByUid'] = managedByUid == null || managedByUid.trim().isEmpty
          ? null
          : managedByUid.trim();
    }
    await callable.call(payload);
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

  @override
  Future<void> deleteGroup(String groupId) async {
    final callable = _functions.httpsCallable('deleteGroup');
    await callable.call(<String, dynamic>{'groupId': groupId});
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

  /// Combina `drawStatus` explícito con señales del documento (`drawingLock`,
  /// `lastExecutionId`) para no mostrar "idle" en UI cuando el sorteo ya cerró
  /// pero el campo quedó desincronizado o en transición.
  DrawStatus _drawStatusFromGroupMap(Map<String, dynamic> g) {
    final parsed = _parseDrawStatus(_readDrawStatusRaw(g['drawStatus']));
    if (parsed == DrawStatus.completed ||
        parsed == DrawStatus.drawing ||
        parsed == DrawStatus.failed) {
      return parsed;
    }
    final lock = g['drawingLock'];
    if (lock is Map) {
      final ex = lock['executionId'];
      if (ex is String && ex.trim().isNotEmpty) {
        return DrawStatus.drawing;
      }
    }
    final last = g['lastExecutionId'];
    if (last is String && last.trim().isNotEmpty) {
      return DrawStatus.completed;
    }
    return DrawStatus.idle;
  }

  DrawStatus _parseDrawStatus(String s) {
    final k = s.trim().toLowerCase();
    if (k == 'complete' ||
        k == 'closed' ||
        k == 'done' ||
        k == 'finished' ||
        k == 'archived' ||
        k == 'success') {
      return DrawStatus.completed;
    }
    return DrawStatus.values.firstWhere(
      (e) => e.name == k,
      orElse: () => DrawStatus.idle,
    );
  }

  String _readDrawStatusRaw(dynamic raw) {
    if (raw == null) return 'idle';
    final s = raw.toString().trim();
    return s.isEmpty ? 'idle' : s;
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
    if (s == 'whatsapp') return ManagedParticipantDeliveryMode.whatsapp;
    if (s == 'email') return ManagedParticipantDeliveryMode.email;
    return ManagedParticipantDeliveryMode.ownerDelegated;
  }
}
