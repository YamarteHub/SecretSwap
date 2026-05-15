import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../draw/services/managed_delivery_launcher.dart';
import '../../../chat/presentation/screens/group_chat_screen.dart';
import '../../../groups/domain/group_models.dart';
import '../../../groups/presentation/providers.dart';
import '../../../groups/presentation/widgets/retention_auto_delete_notice.dart';
import '../../services/team_result_pdf.dart';
import '../../services/team_result_text.dart';
import '../teams_ui_copy.dart';

bool _isActiveTeamsMember(GroupDetail d, String? uid) {
  if (uid == null || uid.isEmpty) return false;
  for (final m in d.members) {
    if (m.uid == uid && m.memberState == MemberState.active) return true;
  }
  return false;
}

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
  int? _renamingTeamIndex;

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
    if (widget.detail.teamsPreset == TeamsPreset.pairings ||
        widget.detail.teamsPreset == TeamsPreset.duels) {
      return _eligibleCount % 2 == 0;
    }
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
    if (widget.detail.teamsPreset == TeamsPreset.pairings ||
        widget.detail.teamsPreset == TeamsPreset.duels) {
      return _eligibleCount ~/ 2;
    }
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

  String? _ownerDisplayName(AppLocalizations l10n) {
    for (final m in widget.detail.members) {
      if (m.uid == widget.detail.ownerUid) {
        return _memberDisplayName(m, l10n);
      }
    }
    return null;
  }

  bool _isCurrentUserInTeam(TeamSnapshot team) {
    final uid = widget.currentUid;
    if (uid == null || uid.isEmpty) return false;
    return team.members.any((m) => m.memberUid == uid);
  }

  Future<void> _renameTeam(TeamSnapshot team, AppLocalizations l10n) async {
    final ui = TeamsUiCopy.of(l10n, widget.detail.teamsPreset);
    final preset = widget.detail.teamsPreset;
    final current = TeamResultText.teamDisplayName(l10n, team, preset: preset);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => _TeamsRenameDialog(
        initialName: current,
        title: ui.renameDialogTitle,
        fieldLabel: ui.renameDialogFieldLabel,
        cancelLabel: l10n.groupDialogCancel,
        saveLabel: l10n.save,
      ),
    );
    if (!mounted || newName == null || newName.isEmpty || newName == current) return;

    setState(() => _renamingTeamIndex = team.teamIndex);
    try {
      await ref.read(groupsRepositoryProvider).updateTeamLabel(
            groupId: widget.groupId,
            teamIndex: team.teamIndex,
            teamLabel: newName,
          );
      if (!mounted) return;
      widget.onReload();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ui.renameSuccess)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e, l10n))),
        );
      }
    } finally {
      if (mounted) setState(() => _renamingTeamIndex = null);
    }
  }

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
      final ui = TeamsUiCopy.of(context.l10n, widget.detail.teamsPreset);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ui.homeStateCompleted)),
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
    final preset = widget.detail.teamsPreset;
    final text = TeamResultText.buildShareBody(
      l10n: l10n,
      groupName: _groupDisplayName,
      teams: _teams,
      displayNameFor: (m) => _memberSnapshotDisplayName(m, l10n),
      preset: preset,
    );
    await Share.share(text);
  }

  Future<void> _openEmail(AppLocalizations l10n) async {
    if (_teams.isEmpty) return;
    final preset = widget.detail.teamsPreset;
    final subject = TeamResultText.buildEmailSubject(l10n, _groupDisplayName, preset: preset);
    final body = TeamResultText.buildEmailBody(
      l10n: l10n,
      groupName: _groupDisplayName,
      teams: _teams,
      displayNameFor: (m) => _memberSnapshotDisplayName(m, l10n),
      preset: preset,
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
    final ui = TeamsUiCopy.of(l10n, widget.detail.teamsPreset);
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
        headline: ui.pdfHeadline,
        groupName: _groupDisplayName,
        eventDateLine: eventLine,
        teamCount: teamCount,
        participantCount: participantCount,
        teams: _teams,
        displayNameFor: (m) => _memberSnapshotDisplayName(m, l10n),
        footerBrand: ui.pdfFooter,
        teamsPreset: widget.detail.teamsPreset,
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
    final ui = TeamsUiCopy.of(l10n, widget.detail.teamsPreset);
    final preset = widget.detail.teamsPreset;
    final theme = Theme.of(context);
    final appMembers = widget.detail.members
        .where((m) => m.memberState == MemberState.active)
        .toList()
      ..sort((a, b) => a.nickname.compareTo(b.nickname));

    final preparingChipBg = AppTheme.mutedGold.withValues(alpha: 0.22);
    final preparingChipFg = AppTheme.deepPlumAlt;
    final completedChipBg = AppTheme.sageGreen.withValues(alpha: 0.22);
    final completedChipFg = AppTheme.sageGreen;

    final configLine = widget.detail.teamsPreset == TeamsPreset.duels
        ? l10n.duelsWizardReviewSummary
        : widget.detail.teamsPreset == TeamsPreset.pairings
            ? l10n.pairingsWizardReviewSummary
            : widget.detail.groupingMode == TeamGroupingMode.teamCount
            ? l10n.teamsDetailConfigTeamCount(widget.detail.requestedTeamCount ?? 2)
            : l10n.teamsDetailConfigTeamSize(widget.detail.requestedTeamSize ?? 2);
    final ownerName = _ownerDisplayName(l10n);

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
                label: ui.homeDynamicTypeLabel,
                background: AppTheme.deepPlum.withValues(alpha: 0.10),
                foreground: AppTheme.deepPlum,
                icon: switch (widget.detail.teamsPreset) {
                  TeamsPreset.duels => Icons.sports_martial_arts_outlined,
                  TeamsPreset.pairings => Icons.people_alt_outlined,
                  TeamsPreset.standard => Icons.groups_outlined,
                },
              ),
              _statusChip(
                label: _teamsComplete ? ui.homeStateCompleted : ui.homeStatePreparing,
                background: _teamsComplete ? completedChipBg : preparingChipBg,
                foreground: _teamsComplete ? completedChipFg : preparingChipFg,
                icon: _teamsComplete
                    ? Icons.check_circle_outline
                    : Icons.hourglass_empty_rounded,
              ),
            ],
          ),
          if (!_isOwner && ownerName != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.teamsOrganizerByline(ownerName),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (_teamsComplete && _teams.isNotEmpty) ...[
            const SizedBox(height: 20),
            _TeamsResultHero(
              title: ui.resultHeroTitle,
              subtitle: ui.resultHeroSubtitle,
              summary: ui.resultSummary(_teams.length, _eligibleCount),
            ),
            RetentionAutoDeleteNoticeSlot(
              retentionDeleteAt: widget.detail.retentionDeleteAt,
            ),
            if (_isActiveTeamsMember(widget.detail, widget.currentUid)) ...[
              const SizedBox(height: 16),
              _TeamsGroupChatAccessCard(
                groupId: widget.groupId,
                groupName: _groupDisplayName,
                eventDate: widget.detail.eventDate,
                teamsPreset: widget.detail.teamsPreset,
              ),
            ],
            const SizedBox(height: 22),
            Text(
              ui.detailListTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            ..._teams.map(
              (team) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: widget.detail.teamsPreset == TeamsPreset.duels
                    ? _DuelsVsMatchCard(
                        team: team,
                        displayName: TeamResultText.teamDisplayName(l10n, team, preset: preset),
                        leftName: team.members.isNotEmpty
                            ? _memberSnapshotDisplayName(team.members.first, l10n)
                            : '—',
                        rightName: team.members.length > 1
                            ? _memberSnapshotDisplayName(team.members[1], l10n)
                            : '—',
                        youOnLeft: team.members.isNotEmpty &&
                            team.members.first.memberUid == widget.currentUid,
                        youOnRight: team.members.length > 1 &&
                            team.members[1].memberUid == widget.currentUid,
                        vsLabel: ui.vsLabel,
                        youLabel: l10n.teamsYouInTeam,
                        canRename: _isOwner,
                        isRenaming: _renamingTeamIndex == team.teamIndex,
                        onRename: () => _renameTeam(team, l10n),
                      )
                    : _TeamsResultTeamCard(
                        team: team,
                        displayName: TeamResultText.teamDisplayName(l10n, team, preset: preset),
                        memberNameFor: (m) => _memberSnapshotDisplayName(m, l10n),
                        youInTeam: _isCurrentUserInTeam(team),
                        youLabel: l10n.teamsYouInTeam,
                        canRename: _isOwner,
                        isRenaming: _renamingTeamIndex == team.teamIndex,
                        onRename: () => _renameTeam(team, l10n),
                      ),
              ),
            ),
            if (_isOwner) ...[
              const SizedBox(height: 8),
              if (_teamsComplete)
                Text(
                  l10n.teamsDetailCompletedHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                l10n.teamsDetailRosterTitle,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _TeamsRosterSection(
                appMembers: appMembers,
                manualParticipants: widget.detail.teamsManualParticipants,
                memberDisplayName: (m) => _memberDisplayName(m, l10n),
                ownerUid: widget.detail.ownerUid,
                adminLabel: l10n.groupRoleAdmin,
                memberLabel: l10n.groupRoleMember,
                appMembersTitle: l10n.teamsDetailAppMembersTitle,
                manualTitle: l10n.teamsDetailManualTitle,
              ),
              const SizedBox(height: 22),
              Text(
                l10n.teamsResultActionsTitle,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              SecretCard(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => _shareResult(l10n),
                      icon: const Icon(Icons.ios_share_rounded),
                      label: Text(l10n.teamsDetailShareCta),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _openEmail(l10n),
                      icon: const Icon(Icons.mail_outline_rounded),
                      label: Text(l10n.teamsDetailEmailCta),
                    ),
                    const SizedBox(height: 8),
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
                ),
              ),
            ],
          ] else if (!_isOwner && !_teamsComplete) ...[
            const SizedBox(height: 20),
            _TeamsMemberWaitingCard(
              title: ui.memberWaitingTitle,
              body: ui.memberWaitingBody,
              poolSummary: l10n.teamsMemberPoolSummary(_eligibleCount),
              appMembers: appMembers,
              memberDisplayName: (m) => _memberDisplayName(m, l10n),
            ),
          ] else if (_isOwner && !_teamsComplete) ...[
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
            const SizedBox(height: 20),
            _TeamsRosterSection(
              appMembers: appMembers,
              manualParticipants: widget.detail.teamsManualParticipants,
              memberDisplayName: (m) => _memberDisplayName(m, l10n),
              ownerUid: widget.detail.ownerUid,
              adminLabel: l10n.groupRoleAdmin,
              memberLabel: l10n.groupRoleMember,
              appMembersTitle: l10n.teamsDetailAppMembersTitle,
              manualTitle: l10n.teamsDetailManualTitle,
              onAddManual: _addManual,
              addManualLabel: l10n.teamsDetailAddManualCta,
              onEditManual: _editManual,
              onRemoveManual: _removeManual,
            ),
            const SizedBox(height: 14),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ui.detailConfigTitle,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(configLine, style: theme.textTheme.bodyMedium),
                  if (_estimatedTeamCount != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      ui.detailConfigSummary(_estimatedTeamCount!),
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
              label: Text(ui.detailFormCta),
            ),
            if (!_hasMinPool || !_configValid) ...[
              const SizedBox(height: 10),
              Text(
                !_hasMinPool
                    ? (ui.detailMinPoolHint ?? l10n.teamsDetailMinPoolHint)
                    : ui.detailEvenHint != null
                        ? ui.detailEvenHint!
                        : l10n.teamsDetailInvalidConfigHint,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
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

/// Diálogo de renombrado: el [TextEditingController] vive en el State del diálogo
/// y se dispone tras desmontar el [TextField], evitando `_dependents.isEmpty`.
class _TeamsRenameDialog extends StatefulWidget {
  const _TeamsRenameDialog({
    required this.initialName,
    required this.title,
    required this.fieldLabel,
    required this.cancelLabel,
    required this.saveLabel,
  });

  final String initialName;
  final String title;
  final String fieldLabel;
  final String cancelLabel;
  final String saveLabel;

  @override
  State<_TeamsRenameDialog> createState() => _TeamsRenameDialogState();
}

class _TeamsRenameDialogState extends State<_TeamsRenameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        maxLength: 40,
        autofocus: true,
        decoration: InputDecoration(labelText: widget.fieldLabel),
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.saveLabel),
        ),
      ],
    );
  }
}

class _TeamsResultHero extends StatelessWidget {
  const _TeamsResultHero({
    required this.title,
    required this.subtitle,
    required this.summary,
  });

  final String title;
  final String subtitle;
  final String summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppTheme.sageGreen.withValues(alpha: 0.28),
              AppTheme.mutedGold.withValues(alpha: 0.18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.deepPlum.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  color: AppTheme.deepPlum,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.deepPlum,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        summary,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.deepPlum,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DuelsVsMatchCard extends StatelessWidget {
  const _DuelsVsMatchCard({
    required this.team,
    required this.displayName,
    required this.leftName,
    required this.rightName,
    required this.youOnLeft,
    required this.youOnRight,
    required this.vsLabel,
    required this.youLabel,
    required this.canRename,
    required this.isRenaming,
    required this.onRename,
  });

  final TeamSnapshot team;
  final String displayName;
  final String leftName;
  final String rightName;
  final bool youOnLeft;
  final bool youOnRight;
  final String vsLabel;
  final String youLabel;
  final bool canRename;
  final bool isRenaming;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.deepPlum,
                  ),
                ),
              ),
              if (canRename)
                IconButton(
                  onPressed: isRenaming ? null : onRename,
                  icon: isRenaming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          Icons.edit_outlined,
                          color: AppTheme.deepPlum.withValues(alpha: 0.75),
                        ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _DuelCompetitorName(
                  name: leftName,
                  highlight: youOnLeft,
                  youLabel: youLabel,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.softTerracotta.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.softTerracotta.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    vsLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppTheme.deepPlum,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _DuelCompetitorName(
                  name: rightName,
                  highlight: youOnRight,
                  youLabel: youLabel,
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DuelCompetitorName extends StatelessWidget {
  const _DuelCompetitorName({
    required this.name,
    required this.highlight,
    required this.youLabel,
    this.alignEnd = false,
  });

  final String name;
  final bool highlight;
  final String youLabel;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          name,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        if (highlight) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.sageGreen.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              youLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.deepPlum,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TeamsResultTeamCard extends StatelessWidget {
  const _TeamsResultTeamCard({
    required this.team,
    required this.displayName,
    required this.memberNameFor,
    required this.youInTeam,
    required this.youLabel,
    required this.canRename,
    required this.isRenaming,
    required this.onRename,
  });

  final TeamSnapshot team;
  final String displayName;
  final String Function(TeamMemberSnapshot member) memberNameFor;
  final bool youInTeam;
  final String youLabel;
  final bool canRename;
  final bool isRenaming;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: youInTeam ? AppTheme.sageGreen : AppTheme.deepPlum.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.deepPlum,
                      ),
                    ),
                    if (youInTeam) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.sageGreen.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          youLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.deepPlum,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (canRename)
                IconButton(
                  tooltip: displayName,
                  onPressed: isRenaming ? null : onRename,
                  icon: isRenaming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          Icons.edit_outlined,
                          color: AppTheme.deepPlum.withValues(alpha: 0.75),
                        ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...team.members.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.deepPlum.withValues(alpha: 0.08),
                    child: Icon(
                      Icons.person_outline,
                      size: 18,
                      color: AppTheme.deepPlum.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      memberNameFor(m),
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
    );
  }
}

class _TeamsRosterSection extends StatelessWidget {
  const _TeamsRosterSection({
    required this.appMembers,
    required this.manualParticipants,
    required this.memberDisplayName,
    required this.ownerUid,
    required this.adminLabel,
    required this.memberLabel,
    required this.appMembersTitle,
    required this.manualTitle,
    this.onAddManual,
    this.addManualLabel,
    this.onEditManual,
    this.onRemoveManual,
  });

  final List<GroupMember> appMembers;
  final List<TeamsManualParticipant> manualParticipants;
  final String Function(GroupMember m) memberDisplayName;
  final String ownerUid;
  final String adminLabel;
  final String memberLabel;
  final String appMembersTitle;
  final String manualTitle;
  final VoidCallback? onAddManual;
  final String? addManualLabel;
  final void Function(TeamsManualParticipant p)? onEditManual;
  final void Function(TeamsManualParticipant p)? onRemoveManual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editable = onAddManual != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                appMembersTitle,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              ...appMembers.map(
                (m) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.deepPlum.withValues(alpha: 0.10),
                    child: Icon(
                      m.uid == ownerUid
                          ? Icons.star_outline_rounded
                          : Icons.person_outline,
                      color: AppTheme.deepPlum,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    memberDisplayName(m),
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    m.uid == ownerUid ? adminLabel : memberLabel,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (manualParticipants.isNotEmpty || editable) ...[
          const SizedBox(height: 12),
          SectionCard(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        manualTitle,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (editable && addManualLabel != null)
                      TextButton.icon(
                        onPressed: onAddManual,
                        icon: const Icon(Icons.person_add_alt_1_outlined),
                        label: Text(addManualLabel!),
                      ),
                  ],
                ),
                ...manualParticipants.map(
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
                    trailing: editable && onEditManual != null && onRemoveManual != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => onEditManual!(p),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => onRemoveManual!(p),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TeamsMemberWaitingCard extends StatelessWidget {
  const _TeamsMemberWaitingCard({
    required this.title,
    required this.body,
    required this.poolSummary,
    required this.appMembers,
    required this.memberDisplayName,
  });

  final String title;
  final String body;
  final String poolSummary;
  final List<GroupMember> appMembers;
  final String Function(GroupMember m) memberDisplayName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.mutedGold.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.hourglass_top_rounded,
                  color: AppTheme.deepPlum.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            poolSummary,
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (appMembers.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: appMembers.take(8).map((m) {
                final name = memberDisplayName(m);
                final initial =
                    name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: AppTheme.deepPlum.withValues(alpha: 0.12),
                    child: Text(
                      initial,
                      style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  label: Text(memberDisplayName(m)),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _TeamsGroupChatAccessCard extends StatelessWidget {
  const _TeamsGroupChatAccessCard({
    required this.groupId,
    required this.groupName,
    this.eventDate,
    this.teamsPreset = TeamsPreset.standard,
  });

  final String groupId;
  final String groupName;
  final DateTime? eventDate;
  final TeamsPreset teamsPreset;

  @override
  Widget build(BuildContext context) {
    final ui = TeamsUiCopy.of(context.l10n, teamsPreset);
    final theme = Theme.of(context);
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.mutedGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.forum_rounded,
                  color: AppTheme.deepPlum.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ui.chatSectionTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ui.chatSectionSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton.tonalIcon(
            onPressed: () {
              context.push(
                AppRoutes.groupChatFor(groupId),
                extra: GroupChatRouteExtra(
                  groupName: groupName,
                  eventDate: eventDate,
                  teamsCompleted: true,
                  teamsPreset: teamsPreset,
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: Text(ui.chatEnterCta),
          ),
        ],
      ),
    );
  }
}
