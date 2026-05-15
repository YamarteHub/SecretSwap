import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../groups/domain/group_models.dart';
import '../../../groups/presentation/providers.dart';
import '../../../groups/presentation/widgets/retention_auto_delete_notice.dart';

/// Detalle de grupo tipo sorteo público (`simple_raffle`). No mezcla UI de Amigo Secreto.
class RaffleGroupDetailScreen extends ConsumerStatefulWidget {
  const RaffleGroupDetailScreen({
    super.key,
    required this.detail,
    required this.groupId,
    this.currentUid,
    this.initialInviteCode,
    required this.onReload,
    required this.onGroupDeletedSuccess,
  });

  final GroupDetail detail;
  final String groupId;
  final String? currentUid;
  final String? initialInviteCode;
  final VoidCallback onReload;
  final VoidCallback onGroupDeletedSuccess;

  @override
  ConsumerState<RaffleGroupDetailScreen> createState() => _RaffleGroupDetailScreenState();
}

class _RaffleGroupDetailScreenState extends ConsumerState<RaffleGroupDetailScreen> {
  String? _inviteCode;
  bool _rotating = false;
  bool _executeInFlight = false;
  bool _deleteInFlight = false;

  @override
  void initState() {
    super.initState();
    _inviteCode = widget.initialInviteCode;
  }

  bool get _isOwner =>
      widget.currentUid != null && widget.currentUid == widget.detail.ownerUid;

  bool get _raffleComplete => widget.detail.raffleStatus == RaffleStatus.completed;

  bool get _canRotate =>
      _isOwner &&
      !_raffleComplete &&
      (widget.detail.raffleStatus == RaffleStatus.idle ||
          widget.detail.raffleStatus == RaffleStatus.failed);

  int get _eligibleCount {
    var n = widget.detail.members
        .where((m) => m.memberState == MemberState.active)
        .length;
    if (!widget.detail.ownerParticipatesInRaffle) {
      final ownerActive = widget.detail.members.any(
        (m) =>
            m.uid == widget.detail.ownerUid &&
            m.memberState == MemberState.active,
      );
      if (ownerActive) n -= 1;
    }
    n += widget.detail.raffleManualParticipants.length;
    return n;
  }

  bool get _hasMinPool => _eligibleCount >= 2;

  bool get _canExecute =>
      _isOwner &&
      !_raffleComplete &&
      _hasMinPool &&
      _eligibleCount >= widget.detail.raffleWinnerCount &&
      widget.detail.raffleWinnerCount >= 1;

  bool _isAdministrativeParticipantLabel(String value, AppLocalizations l10n) {
    final v = value.trim().toLowerCase();
    final blocked = <String>{
      l10n.groupRoleOrganizer.toLowerCase(),
      l10n.groupRoleAdmin.toLowerCase(),
      'organizador',
      'organizer',
      'admin',
      'administrator',
      'administrador',
      'miembro',
      'member',
    };
    return blocked.contains(v);
  }

  String _memberBomboDisplayName(GroupMember m, AppLocalizations l10n) {
    final nick = m.nickname.trim();
    if (nick.isEmpty || _isAdministrativeParticipantLabel(nick, l10n)) {
      return l10n.raffleMemberDefaultName;
    }
    return nick;
  }

  String _winnerDisplayName(RaffleWinnerSnapshot w, AppLocalizations l10n) {
    final uid = w.memberUid;
    if (uid != null && uid.isNotEmpty) {
      for (final m in widget.detail.members) {
        if (m.uid == uid) {
          return _memberBomboDisplayName(m, l10n);
        }
      }
    }
    final snap = w.displayName.trim();
    if (snap.isEmpty || _isAdministrativeParticipantLabel(snap, l10n)) {
      return l10n.raffleMemberDefaultName;
    }
    return snap;
  }

  String _winnersSummaryLine(AppLocalizations l10n) {
    final names = _winners.map((w) => _winnerDisplayName(w, l10n)).toList();
    if (names.isEmpty) return '';
    if (names.length == 1) {
      return l10n.raffleResultSingleWinner(names.first);
    }
    return l10n.raffleResultMultipleWinners(names.join(', '));
  }

  Widget _statusChip({
    required String label,
    required Color background,
    required Color foreground,
    IconData? icon,
  }) {
    return Chip(
      avatar: icon != null
          ? Icon(icon, size: 16, color: foreground)
          : null,
      label: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
      backgroundColor: background,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  List<RaffleWinnerSnapshot> get _winners =>
      widget.detail.lastRaffleExecution?.winnersSnapshot ?? const [];

  Future<void> _rotateInvite() async {
    if (!_canRotate || _rotating) return;
    setState(() => _rotating = true);
    try {
      final code = await ref
          .read(groupsRepositoryProvider)
          .rotateInviteCode(groupId: widget.groupId);
      if (!mounted) return;
      setState(() => _inviteCode = code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.groupSnackbarNewCodeGenerated)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleErrorMessage(e, context.l10n))),
        );
      }
    } finally {
      if (mounted) setState(() => _rotating = false);
    }
  }

  Future<void> _executeRaffle() async {
    if (!_canExecute || _executeInFlight) return;
    final idempotencyKey =
        'raffle-${DateTime.now().microsecondsSinceEpoch}-${widget.groupId}';
    setState(() => _executeInFlight = true);
    try {
      await ref.read(groupsRepositoryProvider).executeRaffle(
            groupId: widget.groupId,
            idempotencyKey: idempotencyKey,
          );
      if (!mounted) return;
      widget.onReload();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.homeRaffleStateCompleted)),
      );
    } catch (e) {
      if (!mounted) return;
      if (executeRaffleErrorIsAlreadyCompleted(e)) {
        widget.onReload();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userVisibleActionErrorMessage(e, context.l10n))),
      );
    } finally {
      if (mounted) setState(() => _executeInFlight = false);
    }
  }

  Future<void> _shareWinners(AppLocalizations l10n) async {
    if (_winners.isEmpty) return;
    final bullets =
        _winners.map((w) => '• ${_winnerDisplayName(w, l10n)}').join('\n');
    final text = l10n.raffleShareBody(
      widget.detail.name.isEmpty ? widget.groupId : widget.detail.name,
      bullets,
    );
    await Share.share(text);
  }

  Future<void> _addManual() async {
    if (!_isOwner || _raffleComplete) return;
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.raffleDetailAddManualCta),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: ctx.l10n.raffleManualDisplayNameLabel),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l10n.close)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(ctx.l10n.create)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final name = ctrl.text.trim();
    if (name.isEmpty) return;
    try {
      await ref.read(groupsRepositoryProvider).createRaffleManualParticipant(
            groupId: widget.groupId,
            displayName: name,
          );
      widget.onReload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e, context.l10n))),
        );
      }
    }
  }

  Future<void> _editManual(RaffleManualParticipant p) async {
    if (!_isOwner || _raffleComplete) return;
    final ctrl = TextEditingController(text: p.displayName);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.raffleManualEditTitle),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: ctx.l10n.raffleManualDisplayNameLabel),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l10n.close)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(ctx.l10n.save)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final name = ctrl.text.trim();
    if (name.isEmpty) return;
    try {
      await ref.read(groupsRepositoryProvider).updateRaffleManualParticipant(
            groupId: widget.groupId,
            participantId: p.participantId,
            displayName: name,
          );
      widget.onReload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e, context.l10n))),
        );
      }
    }
  }

  Future<void> _removeManual(RaffleManualParticipant p) async {
    if (!_isOwner || _raffleComplete) return;
    try {
      await ref.read(groupsRepositoryProvider).removeRaffleManualParticipant(
            groupId: widget.groupId,
            participantId: p.participantId,
          );
      widget.onReload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e, context.l10n))),
        );
      }
    }
  }

  Future<void> _deleteGroup() async {
    if (!_isOwner || _deleteInFlight) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.groupDeleteDialogPreTitle),
        content: Text(ctx.l10n.groupDeleteDialogPreBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l10n.close)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.groupDeleteDialogPreConfirm),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => _deleteInFlight = true);
    try {
      await ref.read(groupsRepositoryProvider).deleteGroup(widget.groupId);
      if (!mounted) return;
      widget.onGroupDeletedSuccess();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e, context.l10n))),
        );
      }
    } finally {
      if (mounted) setState(() => _deleteInFlight = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(groupRosterSignatureStreamProvider(widget.groupId), (previous, next) {
      next.whenData((signature) {
        final prevSignature = previous?.asData?.value;
        if (prevSignature == null || prevSignature == signature) return;
        widget.onReload();
      });
    });

    final l10n = context.l10n;
    final theme = Theme.of(context);
    final appMembers = widget.detail.members
        .where((m) => m.memberState == MemberState.active)
        .toList()
      ..sort((a, b) => a.nickname.compareTo(b.nickname));

    final preparingChipBg = AppTheme.mutedGold.withValues(alpha: 0.22);
    final preparingChipFg = AppTheme.deepPlumAlt;
    final completedChipBg = AppTheme.sageGreen.withValues(alpha: 0.22);
    final completedChipFg = AppTheme.sageGreen;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.detail.name,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statusChip(
                label: l10n.homeDynamicTypeRaffle,
                background: AppTheme.deepPlum.withValues(alpha: 0.10),
                foreground: AppTheme.deepPlum,
                icon: Icons.casino_outlined,
              ),
              _statusChip(
                label: _raffleComplete
                    ? l10n.homeRaffleStateCompleted
                    : l10n.homeRaffleStatePreparing,
                background: _raffleComplete ? completedChipBg : preparingChipBg,
                foreground: _raffleComplete ? completedChipFg : preparingChipFg,
                icon: _raffleComplete
                    ? Icons.emoji_events_outlined
                    : Icons.hourglass_empty_rounded,
              ),
            ],
          ),
          if (_raffleComplete && _winners.isNotEmpty) ...[
            const SizedBox(height: 20),
            SecretCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.mutedGold.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: AppTheme.deepPlum,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.raffleResultHeroTitle,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppTheme.deepPlum,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.raffleResultHeroSubtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _winnersSummaryLine(l10n),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RetentionAutoDeleteNoticeSlot(
              retentionDeleteAt: widget.detail.retentionDeleteAt,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.raffleDetailCompletedHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          if (!_raffleComplete) ...[
            const SizedBox(height: 20),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.raffleDetailInviteSection,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  if (_inviteCode != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.warmIvory,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: SelectableText(
                        _inviteCode!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          letterSpacing: 3,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.deepPlum,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 0,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: _inviteCode!));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.codeCopied)),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy_rounded),
                          label: Text(l10n.copyCode),
                        ),
                        if (_canRotate)
                          TextButton.icon(
                            onPressed: _rotating ? null : _rotateInvite,
                            icon: _rotating
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.refresh_rounded),
                            label: Text(l10n.groupActionGenerateNewCode),
                          ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      l10n.groupInvitationsHelp,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                    ),
                    if (_canRotate) ...[
                      const SizedBox(height: 10),
                      FilledButton.tonalIcon(
                        onPressed: _rotating ? null : _rotateInvite,
                        icon: const Icon(Icons.vpn_key_outlined),
                        label: Text(l10n.groupActionGenerateNewCode),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SectionCard(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.raffleDetailAppMembersTitle,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                ...appMembers.map(
                  (m) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.deepPlum.withValues(alpha: 0.10),
                      child: Icon(
                        m.uid == widget.detail.ownerUid
                            ? Icons.star_outline_rounded
                            : Icons.person_outline,
                        color: AppTheme.deepPlum,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      _memberBomboDisplayName(m, l10n),
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      m.uid == widget.detail.ownerUid
                          ? l10n.groupRoleAdmin
                          : l10n.groupRoleMember,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.raffleDetailManualTitle,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (_isOwner && !_raffleComplete)
                      TextButton.icon(
                        onPressed: _addManual,
                        icon: const Icon(Icons.person_add_alt_1_outlined),
                        label: Text(l10n.raffleDetailAddManualCta),
                      ),
                  ],
                ),
                ...widget.detail.raffleManualParticipants.map(
                  (p) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.mutedGold.withValues(alpha: 0.22),
                      child: const Icon(
                        Icons.emoji_people_outlined,
                        color: AppTheme.deepPlum,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      p.displayName,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    trailing: _isOwner && !_raffleComplete
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _editManual(p),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _removeManual(p),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.raffleDetailStatsWinners,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.detail.raffleWinnerCount}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 44, color: theme.colorScheme.outlineVariant),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.raffleDetailInPool,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_eligibleCount',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: _hasMinPool ? AppTheme.sageGreen : AppTheme.softTerracotta,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isOwner && !_raffleComplete) ...[
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: (_canExecute && !_executeInFlight) ? _executeRaffle : null,
              icon: _executeInFlight
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.casino_rounded),
              label: Text(l10n.raffleDetailRunRaffleCta),
            ),
            if (!_hasMinPool) ...[
              const SizedBox(height: 10),
              Text(
                l10n.raffleDetailMinPoolHint,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ],
          if (_raffleComplete && _winners.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(
              l10n.raffleDetailWinnersTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            SectionCard(
              highlighted: true,
              child: Column(
                children: _winners.map(
                  (w) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.mutedGold.withValues(alpha: 0.24),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: AppTheme.deepPlum,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _winnerDisplayName(w, l10n),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => _shareWinners(l10n),
              icon: const Icon(Icons.ios_share_rounded),
              label: Text(l10n.raffleDetailShareCta),
            ),
          ],
          if (_isOwner) ...[
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: _deleteInFlight ? null : _deleteGroup,
              icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
              label: Text(
                l10n.groupDeleteEntryCta,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
