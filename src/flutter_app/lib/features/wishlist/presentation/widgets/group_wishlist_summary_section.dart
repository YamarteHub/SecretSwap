import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../../groups/domain/group_models.dart';
import '../providers.dart';
import '../screens/wishlist_edit_screen.dart';

bool _isManagedSecretResponsible(
  GroupDetail d,
  GroupParticipant p,
  String uid,
) {
  final ownerUid = d.ownerUid;
  final r = p.managedByUid;
  if (r != null && r == uid) return true;
  if ((r == null || r == ownerUid) && uid == ownerUid) return true;
  return false;
}

class GroupWishlistSummarySection extends ConsumerWidget {
  const GroupWishlistSummarySection({
    super.key,
    required this.detail,
    required this.groupId,
    required this.currentUid,
  });

  final GroupDetail detail;
  final String groupId;
  final String? currentUid;

  void _openEditor(
    BuildContext context, {
    required String participantId,
    required String displayName,
    bool readOnly = false,
  }) {
    context.push(
      '/groups/$groupId/wishlist/$participantId/edit',
      extra: WishlistRouteExtra(
        subjectDisplayName: displayName,
        readOnly: readOnly,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = currentUid;
    if (uid == null) return const SizedBox.shrink();

    final myPidAsync = ref.watch(myParticipantIdForWishlistProvider(groupId));
    final managed = detail.managedParticipants
        .where((p) => p.state == GroupParticipantState.active)
        .where((p) => _isManagedSecretResponsible(detail, p, uid))
        .toList();

    return myPidAsync.when(
      data: (myPid) {
        if (myPid == null && managed.isEmpty) return const SizedBox.shrink();
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final key = myPid != null
            ? WishlistParticipantKey(groupId: groupId, participantId: myPid)
            : null;
        final wishAsync = key != null
            ? ref.watch(wishlistDataProvider(key))
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (myPid != null) ...[
              SecretCard(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.wishlistGroupMyCardTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.wishlistGroupMyCardSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    wishAsync!.when(
                      data: (w) {
                        final ready = w.hasAnyContent;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!ready)
                              Text(
                                l10n.wishlistGroupMyEmptyHint,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.sageGreen.withValues(
                                    alpha: 0.14,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  l10n.wishlistGroupMyReadyChip,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.deepPlum,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),
                            FilledButton.tonalIcon(
                              onPressed: () => _openEditor(
                                context,
                                participantId: myPid,
                                displayName: l10n.wishlistGroupMyCardTitle,
                                readOnly: false,
                              ),
                              icon: Icon(
                                ready
                                    ? Icons.edit_outlined
                                    : Icons.edit_note_outlined,
                              ),
                              label: Text(
                                ready
                                    ? l10n.wishlistGroupMyCardCtaEdit
                                    : l10n.wishlistGroupMyCardCtaFill,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: LinearProgressIndicator(minHeight: 3),
                      ),
                      error: (_, __) => Text(
                        l10n.genericLoadErrorMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (managed.isNotEmpty) ...[
              SecretCard(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.wishlistGroupManagedSectionTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.wishlistGroupManagedSectionSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...managed.map((p) {
                      final t = p.displayName.trim();
                      final initial = t.isEmpty
                          ? '?'
                          : t.substring(0, 1).toUpperCase();
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.deepPlum.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.deepPlum,
                            ),
                          ),
                        ),
                        title: Text(
                          p.displayName.isNotEmpty
                              ? p.displayName
                              : p.participantId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _openEditor(
                          context,
                          participantId: p.participantId,
                          displayName: p.displayName,
                          readOnly: false,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const SizedBox(
        height: 4,
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
