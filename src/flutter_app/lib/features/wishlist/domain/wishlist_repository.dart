import 'wishlist_models.dart';

abstract interface class WishlistRepository {
  /// Resuelve el `participantId` del usuario actual en el grupo (app member).
  Future<String?> resolveMyParticipantId(String groupId);

  Future<WishlistData> getWishlist({
    required String groupId,
    required String participantId,
  });

  Future<void> setWishlist({
    required String groupId,
    required String participantId,
    required WishlistWritePayload payload,
  });
}
