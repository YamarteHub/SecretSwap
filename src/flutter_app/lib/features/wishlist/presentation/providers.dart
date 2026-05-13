import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wishlist_repository_impl.dart';
import '../domain/wishlist_models.dart';
import '../domain/wishlist_repository.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl();
});

final myParticipantIdForWishlistProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, groupId) {
  return ref.read(wishlistRepositoryProvider).resolveMyParticipantId(groupId);
});

class WishlistParticipantKey {
  const WishlistParticipantKey({
    required this.groupId,
    required this.participantId,
  });

  final String groupId;
  final String participantId;

  @override
  bool operator ==(Object other) {
    return other is WishlistParticipantKey &&
        other.groupId == groupId &&
        other.participantId == participantId;
  }

  @override
  int get hashCode => Object.hash(groupId, participantId);
}

final wishlistDataProvider =
    FutureProvider.autoDispose.family<WishlistData, WishlistParticipantKey>(
  (ref, key) {
    return ref.read(wishlistRepositoryProvider).getWishlist(
          groupId: key.groupId,
          participantId: key.participantId,
        );
  },
);
