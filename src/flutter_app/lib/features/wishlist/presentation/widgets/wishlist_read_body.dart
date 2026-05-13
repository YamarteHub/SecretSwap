import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/wishlist_models.dart';

/// Lectura cálida de una wishlist (reutilizable en sheet, pantalla o bloque).
class WishlistReadBody extends StatelessWidget {
  const WishlistReadBody({
    super.key,
    required this.data,
    this.padding = const EdgeInsets.fromLTRB(4, 0, 4, 8),
  });

  final WishlistData data;
  final EdgeInsets padding;

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.wishlistLinkOpenError)),
      );
      return;
    }
    try {
      if (await canLaunchUrl(uri)) {
        final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!ok && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.wishlistLinkOpenError)),
          );
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.wishlistLinkOpenError)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.wishlistLinkOpenError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    if (!data.hasAnyContent) {
      return Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.wishlistEmptyReceiverTitle,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.wishlistEmptyReceiverBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    Widget block(String title, String? body) {
      if (body == null || body.trim().isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.deepPlum,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body.trim(),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          block(l10n.wishlistFieldWishTitle, data.wishText),
          block(l10n.wishlistFieldLikesTitle, data.likesText),
          block(l10n.wishlistFieldAvoidTitle, data.avoidText),
          if (data.links.isNotEmpty) ...[
            Text(
              l10n.wishlistFieldLinksTitle,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.deepPlum,
              ),
            ),
            const SizedBox(height: 8),
            ...data.links.map(
              (l) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _openUrl(context, l.url),
                    icon: const Icon(Icons.link_rounded, size: 18),
                    label: Text(
                      (l.label != null && l.label!.trim().isNotEmpty)
                          ? l.label!.trim()
                          : l.url,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
