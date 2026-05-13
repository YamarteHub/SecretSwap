import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../domain/draw_models.dart';
import '../../../wishlist/domain/wishlist_models.dart';
import '../../../wishlist/presentation/providers.dart';
import '../../../wishlist/presentation/widgets/wishlist_read_body.dart';
import '../providers.dart';

/// Pantalla "Mi amigo secreto".
///
/// Es la pantalla más emocional del flujo: aquí cada usuario descubre
/// (en privado) a quién le toca regalar. La intención visual es de
/// **revelación premium**, no de ficha técnica:
///
///   - Fondo `warmIvory` con AppBar limpio y `BrandMark.icon` para que se
///     sienta parte de Tarci Secret.
///   - Card protagonista con candado visible arriba ("Privado · solo para
///     ti"), label sobrio "Te toca regalar a", nombre del receptor con la
///     mayor jerarquía tipográfica de la app, y, opcionalmente, un chip
///     pequeño con el subgrupo del receptor.
///   - Copy emocional breve debajo del nombre: "Hazle sentir especial.".
///   - Card secundaria con recordatorio de privacidad consolidado en un
///     único bloque (antes había dos textos repetitivos).
///   - CTA "Volver al grupo" como `FilledButton.tonalIcon` (más elegante
///     que el `OutlinedButton` plano anterior).
///
/// La pantalla debe responder en menos de 3 segundos:
///   1. ¿A quién me toca regalar?
///   2. ¿Esto solo lo veo yo?
class MyAssignmentScreen extends ConsumerStatefulWidget {
  final String groupId;
  final String executionId;

  const MyAssignmentScreen({
    super.key,
    required this.groupId,
    required this.executionId,
  });

  @override
  ConsumerState<MyAssignmentScreen> createState() =>
      _MyAssignmentScreenState();
}

class _MyAssignmentScreenState extends ConsumerState<MyAssignmentScreen> {
  MyAssignment? _assignment;
  WishlistData? _receiverWishlist;
  bool _wishlistLoadFailed = false;
  String? _errorMessage;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    try {
      final draw = ref.read(drawRepositoryProvider);
      final a = await draw.getMyAssignment(
        groupId: widget.groupId,
        executionId: widget.executionId,
      );
      WishlistData? wl;
      var wishlistFailed = false;
      final rid = a.receiverParticipantId?.trim();
      if (rid != null && rid.isNotEmpty) {
        try {
          wl = await ref.read(wishlistRepositoryProvider).getWishlist(
                groupId: widget.groupId,
                participantId: rid,
              );
        } catch (_) {
          wishlistFailed = true;
        }
      }
      if (!mounted) return;
      setState(() {
        _assignment = a;
        _receiverWishlist = wl;
        _wishlistLoadFailed = wishlistFailed;
        _errorMessage = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        final msg = userVisibleErrorMessage(e).toLowerCase();
        if (msg.contains('asignación') || msg.contains('asignacion')) {
          _errorMessage = context.l10n.myAssignmentNotAvailableMessage;
        } else {
          _errorMessage = context.l10n.genericLoadErrorMessage;
        }
        _receiverWishlist = null;
        _wishlistLoadFailed = false;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: AppTheme.warmIvory,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.mySecretFriend),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(
              child: BrandMark(variant: BrandAsset.icon, height: 32),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: _loading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(child: CircularProgressIndicator()),
                )
              : _errorMessage != null
                  ? _buildEmptyOrError(context)
                  : _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildEmptyOrError(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmptyState(
          icon: Icons.lock_outline,
          title: context.l10n.myAssignmentNotAvailableTitle,
          message: _errorMessage!,
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          label: Text(context.l10n.backToGroup),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final a = _assignment;
    if (a == null) return _buildEmptyOrError(context);
    final l10n = context.l10n;
    final subgroup = a.receiverSubgroupName?.trim();
    final hasSubgroup = subgroup != null && subgroup.isNotEmpty;

    final rid = a.receiverParticipantId?.trim();
    final showWishlist = rid != null && rid.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AssignmentRevealCard(
          receiverName: a.receiverNickname,
          subgroupName: hasSubgroup ? subgroup : null,
        ),
        if (showWishlist) ...[
          const SizedBox(height: 18),
          SecretCard(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.mutedGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.card_giftcard_rounded,
                        size: 22,
                        color: AppTheme.deepPlum,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.wishlistMyAssignmentReceiverWishlistHeading(
                              a.receiverNickname.trim().isNotEmpty
                                  ? a.receiverNickname.trim()
                                  : l10n.wishlistMyAssignmentReceiverNameFallback,
                            ),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  color: AppTheme.deepPlum,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.wishlistMyAssignmentSectionSubtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_wishlistLoadFailed)
                  Text(
                    l10n.genericLoadErrorMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          height: 1.4,
                        ),
                  )
                else if (_receiverWishlist != null)
                  WishlistReadBody(
                    data: _receiverWishlist!,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        _PrivacyReminderCard(
          title: l10n.myAssignmentPrivacyTitle,
          body: l10n.myAssignmentPrivacyBody,
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          label: Text(l10n.backToGroup),
        ),
      ],
    );
  }
}

/// Card de revelación: pieza visual protagonista de la pantalla.
///
/// Layout vertical con respiración:
///   - Pequeño badge de candado ("Privado · solo para ti").
///   - Label sobrio "Te toca regalar a".
///   - Nombre del receptor en `headlineLarge` con peso fuerte.
///   - Chip discreto con subgrupo si aplica.
///   - Copy emocional breve al final ("Hazle sentir especial.").
class _AssignmentRevealCard extends StatelessWidget {
  const _AssignmentRevealCard({
    required this.receiverName,
    this.subgroupName,
  });

  final String receiverName;
  final String? subgroupName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de privacidad arriba: refuerza desde el primer pixel.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: AppTheme.deepPlum.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.deepPlum.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_rounded,
                  size: 14,
                  color: AppTheme.deepPlum,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.myAssignmentPrivateBadge,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.deepPlum,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.mutedGold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.redeem_outlined,
                  size: 18,
                  color: AppTheme.mutedGold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.myAssignmentRevealLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.78),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Nombre protagonista. headlineLarge para que sea inequívocamente
          // la pieza más importante de la pantalla.
          Text(
            receiverName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.05,
              color: AppTheme.deepPlum,
            ),
          ),
          if (subgroupName != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppTheme.softCream,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.scatter_plot_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      subgroupName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          Text(
            l10n.myAssignmentEmotionalCopy,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card de privacidad: un único bloque consolidado (antes eran dos textos
/// que decían básicamente lo mismo). Mantiene el icono de candado para
/// reforzar visualmente el mensaje sin repetirlo en palabras.
class _PrivacyReminderCard extends StatelessWidget {
  const _PrivacyReminderCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.deepPlum.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: AppTheme.deepPlum,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
