import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../draw/services/managed_delivery_launcher.dart';
import '../../../groups/domain/group_models.dart';
import '../../../groups/presentation/providers.dart';
import '../../services/team_result_pdf.dart';
import '../../services/team_result_text.dart';

class TeamsGroupDetailScreen extends ConsumerStatefulWidget {
  const TeamsGroupDetailScreen({
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
  ConsumerState<TeamsGroupDetailScreen> createState() => _TeamsGroupDetailScreenState();
}

class _TeamsGroupDetailScreenState extends ConsumerState<TeamsGroupDetailScreen> {
  String? _inviteCode;
  bool _rotating = false;
  bool _executeInFlight = false;
  bool _deleteInFlight = false;
  bool _pdfBusy = false;

  @override
  void initState() {
    super.initState();
    _inviteCode = widget.initialInviteCode;
  }

  bool get _isOwner =>
      widget.currentUid != null && widget.currentUid == widget.detail.ownerUid;

  bool get _teamsComplete => widget.detail.teamStatus == TeamStatus.completed;

  bool get _canRotate =>
      _isOwner &&
      !_teamsComplete &&
      (widget.detail.teamStatus == TeamStatus.idle ||
          widget.detail.teamStatus == TeamStatus.failed);

  int get _eligibleCount {
    var n = widget.detail.members
        .where((m) => m.memberState == MemberState.active)
        .length;
    if (!widget.detail.ownerParticipatesInTeams) {
      final ownerActive = widget.detail.members.any(
        (m) =>
            m.uid == widget.detail.ownerUid &&
            m.memberState == MemberState.active,
      );
      if (ownerActive) n -= 1;
    }
    n += widget.detail.teamsManualParticipants.length;
    return n;
  }

  bool get _hasMinPool => _eligibleCount >= 2;

  bool get _configValid {
    if (_eligibleCount < 2) return false;
    if (widget.detail.groupingMode == TeamGroupingMode.teamCount) {
      final n = widget.detail.requestedTeamCount ?? 2;
      return n >= 2 && n <= _eligibleCount;
    }
    final k = widget.detail.requestedTeamSize ?? 2;
    if (k < 2 || k > _eligibleCount) return false;
    final numTeams = (_eligibleCount / k).ceil();
    return numTeams >= 2;
  }

  bool get _canExecute => _isOwner && !_teamsComplete && _hasMinPool && _configValid;

  int? get _estimatedTeamCount {
    if (!_hasMinPool) return null;
    if (widget.detail.groupingMode == TeamGroupingMode.teamCount) {
      return widget.detail.requestedTeamCount;
    }
    final k = widget.detail.requestedTeamSize ?? 2;
    return (_eligibleCount / k).ceil();
  }

  List<TeamSnapshot> get _teams =>
      widget.detail.lastTeamExecution?.teamsSnapshot ?? const [];

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

  String _memberDisplayName(GroupMember m, AppLocalizations l10n) {
    final nick = m.nickname.trim();
    if (nick.isEmpty || _isAdministrativeParticipantLabel(nick, l10n)) {
      return l10n.teamsMemberDefaultName;
    }
    return nick;
  }

  String _memberSnapshotDisplayName(TeamMemberSnapshot m, AppLocalizations l10n) {
    final uid = m.memberUid;
    if (uid != null && uid.isNotEmpty) {
      for (final mem in widget.detail.members) {
        if (mem.uid == uid) {
          return _memberDisplayName(mem, l10n);
        }
      }
    }
    final snap = m.displayName.trim();
    if (snap.isEmpty || _isAdministrativeParticipantLabel(snap, l10n)) {
      return l10n.teamsMemberDefaultName;
    }
    return snap;
  }

  String get _groupDisplayName =>
      widget.detail.name.isEmpty ? widget.groupId : widget.detail.name;

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

  Future<void> _executeTeams() async {
    if (!_canExecute || _executeInFlight) return;
    final idempotencyKey =
        'teams-${DateTime.now().microsecondsSinceEpoch}-${widget.groupId}';
    setState(() => _executeInFlight = true);
    try {
      await ref.read(groupsRepositoryProvider).executeTeams(
            groupId: widget.groupId,
            idempotencyKey: idempotencyKey,
          );
      if (!mounted) return;
      widget.onReload();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.homeTeamsStateCompleted)),
      );
    } catch (e) {
      if (!mounted) return;
      if (executeTeamsErrorIsAlreadyCompleted(e)) {
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

  Future<void> _shareResult(AppLocalizations l10n) async {
    if (_teams.isEmpty) return;
    final text = TeamResultText.buildShareBody(
      l10n: l10n,
      groupName: _groupDisplayName,
      teams: _teams,
      displayNameFor: (m) => _memberSnapshotDisplayName(m, l10n),
    );
    await Share.share(text);
  }

  Future<void> _openEmail(AppLocalizations l10n) async {
    if (_teams.isEmpty) return;
    final subject = TeamResultText.buildEmailSubject(l10n, _groupDisplayName);
    final body = TeamResultText.buildEmailBody(
      l10n: l10n,
      groupName: _groupDisplayName,
      teams: _teams,
      displayNameFor: (m) => _memberSnapshotDisplayName(m, l10n),
    );
    final ok = await ManagedDeliveryLauncher.openEmailComposer(
      subject: subject,
      body: body,
    );
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teamsEmailError)),
      );
    }
  }

  Future<void> _generatePdf(AppLocalizations l10n) async {
    if (_teams.isEmpty || _pdfBusy) return;
    setState(() => _pdfBusy = true);
    try {
      String? eventLine;
      if (widget.detail.eventDate != null) {
        final loc = Localizations.localeOf(context).toString();
        eventLine = DateFormat.yMMMd(loc).format(widget.detail.eventDate!);
      }
      final participantCount =
          widget.detail.lastTeamExecution?.eligibleParticipantCount ?? _eligibleCount;
      final teamCount = widget.detail.lastTeamExecution?.teamCount ?? _teams.length;
      final bytes = await TeamResultPdf.buildDocument(
        l10n: l10n,
        headline: l10n.teamsPdfHeadline,
        groupName: _groupDisplayName,
        eventDateLine: eventLine,
        teamCount: teamCount,
        participantCount: participantCount,
        teams: _teams,
        displayNameFor: (m) => _memberSnapshotDisplayName(m, l10n),
        footerBrand: l10n.teamsPdfFooter,
      );
      if (!mounted) return;
      await TeamResultPdf.previewAndShare(
        bytes: bytes,
        documentName: _groupDisplayName.replaceAll(RegExp(r'[^\w\s-]'), '_'),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.teamsPdfError)),
        );
      }
    } finally {
      if (mounted) setState(() => _pdfBusy = false);
    }
  }

  Future<void> _addManual() async {
    if (!_isOwner || _teamsComplete) return;
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.teamsDetailAddManualCta),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: ctx.l10n.teamsManualDisplayNameLabel),
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
      await ref.read(groupsRepositoryProvider).createTeamsManualParticipant(
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

  Future<void> _editManual(TeamsManualParticipant p) async {
    if (!_isOwner || _teamsComplete) return;
    final ctrl = TextEditingController(text: p.displayName);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.teamsManualEditTitle),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: ctx.l10n.teamsManualDisplayNameLabel),
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
      await ref.read(groupsRepositoryProvider).updateTeamsManualParticipant(
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

  Future<void> _removeManual(TeamsManualParticipant p) async {
    if (!_isOwner || _teamsComplete) return;
    try {
      await ref.read(groupsRepositoryProvider).removeTeamsManualParticipant(
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

  Widget _statusChip({
    required String label,
    required Color background,
    required Color foreground,
    IconData? icon,
  }) {
    return Chip(
      avatar: icon != null ? Icon(icon, size: 16, color: foreground) : null,
      label: Text(
        label,
        style: TextStyle(color: foreground, fontWeight: FontWeight.w700, fontSize: 12),
      ),
      backgroundColor: background,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
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

    final configLine = widget.detail.groupingMode == TeamGroupingMode.teamCount
        ? l10n.teamsDetailConfigTeamCount(widget.detail.requestedTeamCount ?? 2)
        : l10n.teamsDetailConfigTeamSize(widget.detail.requestedTeamSize ?? 2);

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
                label: l10n.homeDynamicTypeTeams,
                background: AppTheme.deepPlum.withValues(alpha: 0.10),
                foreground: AppTheme.deepPlum,
                icon: Icons.groups_outlined,
              ),
              _statusChip(
                label: _teamsComplete
                    ? l10n.homeTeamsStateCompleted
                    : l10n.homeTeamsStatePreparing,
                background: _teamsComplete ? completedChipBg : preparingChipBg,
                foreground: _teamsComplete ? completedChipFg : preparingChipFg,
                icon: _teamsComplete
                    ? Icons.check_circle_outline
                    : Icons.hourglass_empty_rounded,
              ),
            ],
          ),
          if (_teamsComplete && _teams.isNotEmpty) ...[
            const SizedBox(height: 20),
            SecretCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.sageGreen.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
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
                          l10n.teamsResultHeroTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.deepPlum,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.teamsResultHeroSubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.teamsResultSummary(_teams.length, _eligibleCount),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.teamsDetailCompletedHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          if (!_teamsComplete) ...[
            const SizedBox(height: 20),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.teamsDetailInviteSection,
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
                  ] else if (_canRotate) ...[
                    FilledButton.tonalIcon(
                      onPressed: _rotating ? null : _rotateInvite,
                      icon: const Icon(Icons.vpn_key_outlined),
                      label: Text(l10n.groupActionGenerateNewCode),
                    ),
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
                  l10n.teamsDetailAppMembersTitle,
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
                      _memberDisplayName(m, l10n),
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
                        l10n.teamsDetailManualTitle,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (_isOwner && !_teamsComplete)
                      TextButton.icon(
                        onPressed: _addManual,
                        icon: const Icon(Icons.person_add_alt_1_outlined),
                        label: Text(l10n.teamsDetailAddManualCta),
                      ),
                  ],
                ),
                ...widget.detail.teamsManualParticipants.map(
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
                    trailing: _isOwner && !_teamsComplete
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
          if (!_teamsComplete) ...[
            const SizedBox(height: 14),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.teamsDetailConfigTitle,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(configLine, style: theme.textTheme.bodyMedium),
                  if (_estimatedTeamCount != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.teamsDetailEstimatedTeams(_estimatedTeamCount!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    l10n.teamsDetailEligibleCount(_eligibleCount),
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
          if (_isOwner && !_teamsComplete) ...[
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: (_canExecute && !_executeInFlight) ? _executeTeams : null,
              icon: _executeInFlight
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.groups_rounded),
              label: Text(l10n.teamsDetailFormTeamsCta),
            ),
            if (!_hasMinPool || !_configValid) ...[
              const SizedBox(height: 10),
              Text(
                !_hasMinPool ? l10n.teamsDetailMinPoolHint : l10n.teamsDetailInvalidConfigHint,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ],
          if (_teamsComplete && _teams.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(
              l10n.teamsDetailTeamsListTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            ..._teams.map((team) {
              final label = TeamResultText.unitLabel(l10n, team.teamIndex);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.deepPlum,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...team.members.map(
                        (m) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _memberSnapshotDisplayName(m, l10n),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => _shareResult(l10n),
              icon: const Icon(Icons.ios_share_rounded),
              label: Text(l10n.teamsDetailShareCta),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _openEmail(l10n),
              icon: const Icon(Icons.mail_outline_rounded),
              label: Text(l10n.teamsDetailEmailCta),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _pdfBusy ? null : () => _generatePdf(l10n),
              icon: _pdfBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf_outlined),
              label: Text(l10n.teamsDetailPdfCta),
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
