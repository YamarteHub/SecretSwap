import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../groups/domain/group_models.dart';
import '../../../groups/presentation/providers.dart';
import '../../domain/draw_models.dart';
import '../../services/managed_assignment_pdf.dart';
import '../../services/managed_delivery_launcher.dart';
import '../../services/managed_delivery_text.dart';
import '../providers.dart';
import '../../../wishlist/domain/wishlist_models.dart';
import '../../../wishlist/presentation/providers.dart';
import '../../../wishlist/presentation/widgets/wishlist_read_body.dart';

Future<void> _showManagedReceiverWishlistSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required String groupId,
  required ManagedAssignment assignment,
}) async {
  final pid = assignment.receiverParticipantId.trim();
  if (pid.isEmpty) return;
  final repo = ref.read(wishlistRepositoryProvider);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            4,
            20,
            MediaQuery.paddingOf(ctx).bottom + 16,
          ),
          child: FutureBuilder<WishlistData>(
            future: repo.getWishlist(
              groupId: groupId,
              participantId: pid,
            ),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    l10n.genericLoadErrorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      assignment.receiverDisplayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.deepPlum,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.wishlistReadonlySheetTitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    WishlistReadBody(
                      data: snap.data!,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

/// Pantalla "Secretos que gestionas".
class ManagedAssignmentsScreen extends ConsumerWidget {
  final String groupId;
  final String executionId;

  const ManagedAssignmentsScreen({
    super.key,
    required this.groupId,
    required this.executionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final groupAsync = ref.watch(groupDetailProvider(groupId));
    final assignmentsAsync =
        ref.watch(_managedAssignmentsProvider((groupId, executionId)));
    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: AppTheme.warmIvory,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.managedSecrets),
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
        child: _ManagedAssignmentsBody(
          l10n: l10n,
          groupId: groupId,
          groupAsync: groupAsync,
          assignmentsAsync: assignmentsAsync,
        ),
      ),
    );
  }
}

class _ManagedAssignmentsBody extends StatelessWidget {
  const _ManagedAssignmentsBody({
    required this.l10n,
    required this.groupId,
    required this.groupAsync,
    required this.assignmentsAsync,
  });

  final AppLocalizations l10n;
  final String groupId;
  final AsyncValue<GroupDetail> groupAsync;
  final AsyncValue<List<ManagedAssignment>> assignmentsAsync;

  @override
  Widget build(BuildContext context) {
    if (assignmentsAsync.isLoading || groupAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (assignmentsAsync.hasError) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: EmptyState(
          icon: Icons.lock_person_outlined,
          title: l10n.managedLoadErrorTitle,
          message: l10n.managedLoadErrorMessage,
        ),
      );
    }
    final items = assignmentsAsync.requireValue;
    final rawName = groupAsync.value?.name.trim() ?? '';
    final groupDisplayName =
        rawName.isEmpty ? l10n.managedDeliveryFallbackGroupName : rawName;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        _ManagedHero(
          title: l10n.managedHeroTitle,
          subtitle: l10n.managedHeroSubtitle,
        ),
        const SizedBox(height: 18),
        if (items.isEmpty)
          EmptyState(
            icon: Icons.inbox_outlined,
            title: l10n.managedEmptyTitle,
            message: l10n.managedEmptyMessage,
          )
        else ...[
          ...items.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GuardianAssignmentCard(
                groupId: groupId,
                assignment: a,
                groupDisplayName: groupDisplayName,
              ),
            ),
          ),
          const SizedBox(height: 6),
          _PrivacyFooterNote(text: l10n.managedFooterPrivacyNote),
        ],
      ],
    );
  }
}

class _ManagedHero extends StatelessWidget {
  const _ManagedHero({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        gradient: AppTheme.brandHeroGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.deepPlum.withValues(alpha: 0.10),
        ),
        boxShadow: AppTheme.softElevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.deepPlum.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield_moon_outlined,
                  color: AppTheme.deepPlum,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.78),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardianAssignmentCard extends ConsumerWidget {
  const _GuardianAssignmentCard({
    required this.groupId,
    required this.assignment,
    required this.groupDisplayName,
  });

  final String groupId;
  final ManagedAssignment assignment;
  final String groupDisplayName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final subName = assignment.receiverSubgroupName?.trim();
    final hasSubgroup = subName != null && subName.isNotEmpty;
    final receiverPid = assignment.receiverParticipantId.trim();
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _InitialAvatar(name: assignment.giverDisplayName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.giverDisplayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _TypeBadge(label: _giverTypeLabel(context, assignment.giverType)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            color: theme.colorScheme.outlineVariant,
            height: 1,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppTheme.mutedGold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.redeem_outlined,
                  size: 16,
                  color: AppTheme.mutedGold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.managedRevealLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.78),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            assignment.receiverDisplayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: AppTheme.deepPlum,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (hasSubgroup)
                _ChipPill(
                  icon: Icons.scatter_plot_outlined,
                  label: subName,
                ),
              _ChipPill(
                icon: _deliveryIcon(assignment.deliveryMode),
                label:
                    '${l10n.managedDeliveryChipLabel} · ${_deliveryModeLabel(context, assignment.deliveryMode)}',
                tone: AppTheme.deepPlum,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (receiverPid.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _showManagedReceiverWishlistSheet(
                  context: context,
                  ref: ref,
                  l10n: l10n,
                  groupId: groupId,
                  assignment: assignment,
                ),
                icon: const Icon(Icons.auto_awesome_outlined, size: 20),
                label: Text(l10n.wishlistManagedViewReceiverCta),
              ),
            ),
            const SizedBox(height: 4),
          ],
          _ManagedDeliveryActions(
            assignment: assignment,
            groupDisplayName: groupDisplayName,
          ),
        ],
      ),
    );
  }
}

class _ManagedDeliveryActions extends StatefulWidget {
  const _ManagedDeliveryActions({
    required this.assignment,
    required this.groupDisplayName,
  });

  final ManagedAssignment assignment;
  final String groupDisplayName;

  @override
  State<_ManagedDeliveryActions> createState() =>
      _ManagedDeliveryActionsState();
}

class _ManagedDeliveryActionsState extends State<_ManagedDeliveryActions> {
  bool _pdfBusy = false;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _validateNames() {
    final l10n = context.l10n;
    final g = widget.assignment.giverDisplayName.trim();
    final r = widget.assignment.receiverDisplayName.trim();
    if (g.isEmpty || r.isEmpty) {
      _snack(l10n.managedDeliveryErrorMissingData);
      return false;
    }
    return true;
  }

  Future<void> _whatsapp() async {
    final l10n = context.l10n;
    if (!_validateNames()) return;
    try {
      final text = ManagedDeliveryText.whatsappBody(
        l10n,
        managedName: widget.assignment.giverDisplayName.trim(),
        groupName: widget.groupDisplayName.trim(),
        receiverName: widget.assignment.receiverDisplayName.trim(),
        receiverSubgroupName: widget.assignment.receiverSubgroupName,
      );
      await ManagedDeliveryLauncher.shareWhatsAppOrFallback(text);
    } catch (_) {
      _snack(l10n.managedDeliveryErrorWhatsapp);
    }
  }

  Future<void> _email() async {
    final l10n = context.l10n;
    if (!_validateNames()) return;
    try {
      final subject = ManagedDeliveryText.emailSubject(
        l10n,
        widget.groupDisplayName.trim(),
      );
      final body = ManagedDeliveryText.emailBody(
        l10n,
        managedName: widget.assignment.giverDisplayName.trim(),
        groupName: widget.groupDisplayName.trim(),
        receiverName: widget.assignment.receiverDisplayName.trim(),
        receiverSubgroupName: widget.assignment.receiverSubgroupName,
      );
      final ok = await ManagedDeliveryLauncher.openEmailComposer(
        subject: subject,
        body: body,
      );
      if (!ok && mounted) {
        _snack(l10n.managedDeliveryErrorEmail);
      }
    } catch (_) {
      _snack(l10n.managedDeliveryErrorEmail);
    }
  }

  Future<void> _pdf() async {
    final l10n = context.l10n;
    if (!_validateNames()) return;
    setState(() => _pdfBusy = true);
    try {
      final sub = widget.assignment.receiverSubgroupName?.trim();
      final subgroupLine = (sub != null && sub.isNotEmpty)
          ? l10n.managedDeliverySubgroupBelongsTo(sub)
          : null;
      final bytes = await ManagedAssignmentPdf.buildDocument(
        headline: l10n.managedPdfHeadline,
        forLabel: l10n.managedPdfForLabel,
        managedName: widget.assignment.giverDisplayName.trim(),
        groupLabel: l10n.managedPdfGroupLabel,
        groupName: widget.groupDisplayName.trim(),
        giftHeading: l10n.managedPdfGiftHeading,
        receiverName: widget.assignment.receiverDisplayName.trim(),
        receiverSubgroupLine: subgroupLine,
        footerSecret: l10n.managedPdfFooterKeepSecret,
        footerBrand: l10n.managedPdfFooterBrand,
      );
      if (!mounted) return;
      await ManagedAssignmentPdf.previewAndShare(
        bytes: bytes,
        documentName: l10n.managedPdfDocTitle,
      );
    } catch (_) {
      if (mounted) _snack(l10n.managedDeliveryErrorPdf);
    } finally {
      if (mounted) setState(() => _pdfBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mode = widget.assignment.deliveryMode;

    if (mode == 'verbal') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.softCream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.deepPlum.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.record_voice_over_outlined,
              size: 20,
              color: AppTheme.deepPlum.withValues(alpha: 0.85),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.managedDeliveryVerbalBadge,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    if (mode == 'whatsapp') {
      return FilledButton.icon(
        onPressed: _whatsapp,
        icon: const Icon(Icons.chat_bubble_outline),
        label: Text(l10n.managedDeliveryCtaWhatsapp),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.deepPlum,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      );
    }

    if (mode == 'email') {
      return FilledButton.icon(
        onPressed: _email,
        icon: const Icon(Icons.mail_outline),
        label: Text(l10n.managedDeliveryCtaEmail),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.deepPlumAlt,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      );
    }

    if (mode == 'printed') {
      return FilledButton.tonalIcon(
        onPressed: _pdfBusy ? null : _pdf,
        icon: _pdfBusy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.picture_as_pdf_outlined),
        label: Text(
          _pdfBusy
              ? l10n.managedDeliveryPdfGenerating
              : l10n.managedDeliveryCtaPdf,
        ),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      );
    }

    // ownerDelegated u otros: recordatorio suave sin CTA de canales
    return Text(
      l10n.managedDeliveryOwnerDelegated,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = _firstInitial(name);
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: AppTheme.brandHeroGradient,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.deepPlum.withValues(alpha: 0.18),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppTheme.deepPlum,
        ),
      ),
    );
  }

  static String _firstInitial(String s) {
    final t = s.trim();
    if (t.isEmpty) return '·';
    final ch = t.runes.first;
    return String.fromCharCode(ch).toUpperCase();
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.warmIvory,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ChipPill extends StatelessWidget {
  const _ChipPill({
    required this.icon,
    required this.label,
    this.tone,
  });

  final IconData icon;
  final String label;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = tone ?? theme.colorScheme.onSurfaceVariant;
    final bg = tone != null
        ? tone!.withValues(alpha: 0.10)
        : AppTheme.softCream;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tone != null
              ? tone!.withValues(alpha: 0.30)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyFooterNote extends StatelessWidget {
  const _PrivacyFooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _giverTypeLabel(BuildContext context, String raw) {
  switch (raw) {
    case 'child_managed':
      return context.l10n.groupTypeChildManaged;
    case 'managed':
      return context.l10n.groupTypeAdultNoApp;
    default:
      return context.l10n.managedTypeManagedParticipant;
  }
}

String _deliveryModeLabel(BuildContext context, String raw) {
  switch (raw) {
    case 'verbal':
      return context.l10n.groupManagedDialogDeliveryVerbal;
    case 'printed':
      return context.l10n.managedDeliveryModePdf;
    case 'whatsapp':
      return context.l10n.managedDeliveryModeWhatsapp;
    case 'email':
      return context.l10n.managedDeliveryModeEmail;
    case 'ownerDelegated':
      return context.l10n.managedDeliveryOwnerDelegated;
    default:
      return raw;
  }
}

IconData _deliveryIcon(String raw) {
  switch (raw) {
    case 'printed':
      return Icons.picture_as_pdf_outlined;
    case 'whatsapp':
      return Icons.chat_bubble_outline;
    case 'email':
      return Icons.mail_outline;
    case 'ownerDelegated':
      return Icons.shield_outlined;
    case 'verbal':
    default:
      return Icons.record_voice_over_outlined;
  }
}

final _managedAssignmentsProvider =
    FutureProvider.family.autoDispose((ref, (String, String) key) async {
  final (groupId, executionId) = key;
  return ref.read(drawRepositoryProvider).getManagedAssignments(
        groupId: groupId,
        executionId: executionId,
      );
});
