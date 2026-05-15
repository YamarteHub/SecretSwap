import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../groups/domain/group_models.dart';
import '../../../groups/presentation/providers.dart';

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

  bool get _canExecute =>
      _isOwner &&
      !_raffleComplete &&
      _eligibleCount >= widget.detail.raffleWinnerCount &&
      widget.detail.raffleWinnerCount >= 1;

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
    final bullets = _winners.map((w) => '• ${w.displayName}').join('\n');
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.detail.name,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(l10n.homeDynamicTypeRaffle),
                visualDensity: VisualDensity.compact,
              ),
              Chip(
                label: Text(
                  _raffleComplete
                      ? l10n.homeRaffleStateCompleted
                      : l10n.homeRaffleStatePreparing,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (_raffleComplete) ...[
            const SizedBox(height: 16),
            Text(
              l10n.raffleDetailCompletedHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (!_raffleComplete) ...[
            const SizedBox(height: 22),
            Text(
              l10n.raffleDetailInviteSection,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            if (_inviteCode != null) ...[
              SelectableText(
                _inviteCode!,
                style: theme.textTheme.titleMedium?.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
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
                style: theme.textTheme.bodySmall,
              ),
              if (_canRotate)
                FilledButton.tonalIcon(
                  onPressed: _rotating ? null : _rotateInvite,
                  icon: const Icon(Icons.vpn_key_outlined),
                  label: Text(l10n.groupActionGenerateNewCode),
                ),
            ],
          ],
          const SizedBox(height: 20),
          Text(
            l10n.raffleDetailAppMembersTitle,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          ...appMembers.map(
            (m) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person_outline),
              title: Text(m.nickname),
              subtitle: Text(m.uid == widget.detail.ownerUid ? l10n.groupRoleAdmin : l10n.groupRoleMember),
            ),
          ),
          const SizedBox(height: 16),
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
              leading: const Icon(Icons.emoji_people_outlined),
              title: Text(p.displayName),
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
          const SizedBox(height: 12),
          Text(
            '${l10n.raffleWizardWinnersLabel}: ${widget.detail.raffleWinnerCount}',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            l10n.raffleDetailEligibleCount(_eligibleCount),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (_isOwner && !_raffleComplete) ...[
            const SizedBox(height: 20),
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
          ],
          if (_raffleComplete && _winners.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.raffleDetailWinnersTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            ..._winners.map(
              (w) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: AppTheme.softCream,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    title: Text(
                      w.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
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
