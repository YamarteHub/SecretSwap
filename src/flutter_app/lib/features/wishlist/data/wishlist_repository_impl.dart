import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/wishlist_models.dart';
import '../domain/wishlist_repository.dart';

Map<String, dynamic> _asStringKeyMap(dynamic raw) {
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v));
  }
  throw ArgumentError('Respuesta inesperada del backend');
}

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
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
  Future<String?> resolveMyParticipantId(String groupId) async {
    final snap = await _firestore
        .collection('groups/$groupId/participants')
        .where('linkedUid', isEqualTo: _uid)
        .limit(1)
        .get();
    if (snap.docs.isNotEmpty) {
      final m = snap.docs.first.data();
      final pid = m['participantId'] as String?;
      return (pid != null && pid.trim().isNotEmpty) ? pid.trim() : snap.docs.first.id;
    }
    final member = await _firestore.doc('groups/$groupId/members/$_uid').get();
    if (member.exists) {
      final st = member.data()?['memberState'] as String? ?? '';
      if (st == 'active') return _uid;
    }
    return null;
  }

  @override
  Future<WishlistData> getWishlist({
    required String groupId,
    required String participantId,
  }) async {
    final callable = _functions.httpsCallable('getWishlist');
    final result = await callable.call(<String, dynamic>{
      'groupId': groupId,
      'participantId': participantId,
    });
    final data = _asStringKeyMap(result.data);
    final linksRaw = data['links'];
    final links = <WishlistLink>[];
    if (linksRaw is List) {
      for (final item in linksRaw) {
        if (item is! Map) continue;
        final m = item.map((k, v) => MapEntry(k.toString(), v));
        final url = m['url'] as String? ?? '';
        if (url.trim().isEmpty) continue;
        final labelRaw = m['label'] as String?;
        links.add(
          WishlistLink(
            label: labelRaw == null || labelRaw.trim().isEmpty ? null : labelRaw.trim(),
            url: url.trim(),
          ),
        );
      }
    }
    return WishlistData(
      wishText: data['wishText'] as String?,
      likesText: data['likesText'] as String?,
      avoidText: data['avoidText'] as String?,
      links: links,
      updatedAtMillis: (data['updatedAtMillis'] as num?)?.toInt(),
    );
  }

  @override
  Future<void> setWishlist({
    required String groupId,
    required String participantId,
    required WishlistWritePayload payload,
  }) async {
    final callable = _functions.httpsCallable('setWishlist');
    await callable.call(<String, dynamic>{
      'groupId': groupId,
      'participantId': participantId,
      'wishText': _nullableTrim(payload.wishText),
      'likesText': _nullableTrim(payload.likesText),
      'avoidText': _nullableTrim(payload.avoidText),
      'links': payload.links
          .map(
            (l) => <String, dynamic>{
              'label': l.label == null || l.label!.trim().isEmpty ? null : l.label!.trim(),
              'url': l.url.trim(),
            },
          )
          .toList(),
    });
  }

  String? _nullableTrim(String? s) {
    if (s == null) return null;
    final t = s.trim();
    return t.isEmpty ? null : t;
  }
}
