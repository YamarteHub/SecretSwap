class WishlistLink {
  const WishlistLink({this.label, required this.url});

  final String? label;
  final String url;
}

class WishlistData {
  const WishlistData({
    this.wishText,
    this.likesText,
    this.avoidText,
    this.links = const [],
    this.updatedAtMillis,
  });

  final String? wishText;
  final String? likesText;
  final String? avoidText;
  final List<WishlistLink> links;
  final int? updatedAtMillis;

  bool get hasAnyContent {
    for (final s in [wishText, likesText, avoidText]) {
      if (s != null && s.trim().isNotEmpty) return true;
    }
    return links.any((l) => l.url.trim().isNotEmpty);
  }
}

class WishlistWritePayload {
  const WishlistWritePayload({
    required this.wishText,
    required this.likesText,
    required this.avoidText,
    required this.links,
  });

  final String? wishText;
  final String? likesText;
  final String? avoidText;
  final List<WishlistLink> links;
}
