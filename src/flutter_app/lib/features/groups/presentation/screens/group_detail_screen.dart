import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../draw/presentation/providers.dart';
import '../../domain/group_models.dart';
import '../providers.dart';

String? _subgroupDisplayName(GroupDetail detail, String? subgroupId) {
  if (subgroupId == null || subgroupId.isEmpty) return null;
  for (final s in detail.subgroups) {
    if (s.subgroupId == subgroupId) return s.name;
  }
  return subgroupId;
}

/// Miembros con app activos elegibles como responsable (excluye al organizador).
List<GroupMember> _eligibleDelegatedGuardians(GroupDetail d) {
  return d.members
      .where(
        (m) =>
            m.memberState == MemberState.active && m.uid != d.ownerUid,
      )
      .toList()
    ..sort(
      (a, b) => a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase()),
    );
}

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

String _managedResponsibleNickname(
  GroupDetail d,
  GroupParticipant p,
  AppLocalizations l10n,
) {
  final effectiveUid = p.managedByUid ?? d.ownerUid;
  for (final m in d.members) {
    if (m.uid == effectiveUid) return m.nickname;
  }
  return l10n.groupManagedResponsibleUnavailable;
}

const _drawRuleOrder = [
  DrawSubgroupRule.ignore,
  DrawSubgroupRule.preferDifferent,
  DrawSubgroupRule.requireDifferent,
];

String _drawRuleOptionTitle(BuildContext context, DrawSubgroupRule r) {
  switch (r) {
    case DrawSubgroupRule.ignore:
      return context.l10n.groupRuleIgnoreTitle;
    case DrawSubgroupRule.preferDifferent:
      return context.l10n.groupRulePreferTitle;
    case DrawSubgroupRule.requireDifferent:
      return context.l10n.groupRuleRequireTitle;
  }
}

String _drawRuleOptionDescription(BuildContext context, DrawSubgroupRule r) {
  switch (r) {
    case DrawSubgroupRule.ignore:
      return context.l10n.groupRuleIgnoreDescription;
    case DrawSubgroupRule.preferDifferent:
      return context.l10n.groupRulePreferDescription;
    case DrawSubgroupRule.requireDifferent:
      return context.l10n.groupRuleRequireDescription;
  }
}

class _UnifiedPreparationCounts {
  final int effectiveTotal;
  final int withApp;
  final int withoutApp;
  final int childManaged;
  final int withoutSubgroup;

  const _UnifiedPreparationCounts({
    required this.effectiveTotal,
    required this.withApp,
    required this.withoutApp,
    required this.childManaged,
    required this.withoutSubgroup,
  });
}

_UnifiedPreparationCounts _buildUnifiedPreparationCounts(GroupDetail d) {
  final membersByUid = <String, GroupMember>{};
  for (final m in d.members) {
    if (m.memberState != MemberState.active) continue;
    membersByUid[m.uid] = m;
  }

  final activeParticipants = d.managedParticipants
      .where((p) => p.state == GroupParticipantState.active)
      .toList();
  final linkedUids = activeParticipants
      .map((p) => p.linkedUid)
      .whereType<String>()
      .where((uid) => uid.trim().isNotEmpty)
      .toSet();

  int withApp = 0;
  int withoutApp = 0;
  int childManaged = 0;
  int withoutSubgroup = 0;

  for (final m in membersByUid.values) {
    if (linkedUids.contains(m.uid)) continue;
    withApp++;
    if (m.subgroupId == null || m.subgroupId!.trim().isEmpty) {
      withoutSubgroup++;
    }
  }

  for (final p in activeParticipants) {
    if (p.participantType == GroupParticipantType.appMember) {
      withApp++;
    } else if (p.participantType == GroupParticipantType.childManaged) {
      childManaged++;
      withoutApp++;
    } else {
      withoutApp++;
    }
    if (p.subgroupId == null || p.subgroupId!.trim().isEmpty) {
      withoutSubgroup++;
    }
  }

  return _UnifiedPreparationCounts(
    effectiveTotal: withApp + withoutApp,
    withApp: withApp,
    withoutApp: withoutApp,
    childManaged: childManaged,
    withoutSubgroup: withoutSubgroup,
  );
}

List<String> _effectiveParticipantsWithoutSubgroupNames(GroupDetail d) {
  final membersByUid = <String, GroupMember>{};
  for (final m in d.members) {
    if (m.memberState != MemberState.active) continue;
    membersByUid[m.uid] = m;
  }

  final activeParticipants = d.managedParticipants
      .where((p) => p.state == GroupParticipantState.active)
      .toList();
  final linkedUids = activeParticipants
      .map((p) => p.linkedUid)
      .whereType<String>()
      .where((uid) => uid.trim().isNotEmpty)
      .toSet();

  final names = <String>[];
  for (final m in membersByUid.values) {
    if (linkedUids.contains(m.uid)) continue;
    if (m.subgroupId != null && m.subgroupId!.trim().isNotEmpty) continue;
    final nick = m.nickname.trim();
    names.add(nick.isNotEmpty ? nick : m.uid);
  }
  for (final p in activeParticipants) {
    if (p.subgroupId != null && p.subgroupId!.trim().isNotEmpty) continue;
    names.add(
      p.displayName.trim().isNotEmpty ? p.displayName : p.participantId,
    );
  }
  return names;
}

String _shortNamesList(List<String> names, {int maxVisible = 4}) {
  if (names.isEmpty) return '';
  if (names.length <= maxVisible) return names.join(', ');
  final visible = names.take(maxVisible).join(', ');
  final remaining = names.length - maxVisible;
  return '$visible +$remaining';
}

class GroupDetailScreen extends ConsumerWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.groupsHome);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final l10n = context.l10n;
    // Defensa: si el groupId llega vacío por una ruta corrupta no debemos
    // dejar al usuario ante un body vacío. Mostramos un estado de error
    // explícito con acción de volver al dashboard.
    if (groupId.trim().isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.warmIvory,
        appBar: _buildAppBar(context, l10n),
        body: _DetailErrorState(
          message: l10n.groupErrorNotFound,
          onRetry: null,
          onBack: () => _goBack(context),
        ),
      );
    }

    final detailAsync = ref.watch(groupDetailProvider(groupId));

    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: _buildAppBar(context, l10n),
      body: detailAsync.when(
        data: (detail) => _GroupDetailBody(
          detail: detail,
          currentUid: uid,
          groupId: groupId,
          onAfterDraw: () {
            ref.invalidate(groupDetailProvider(groupId));
          },
          onReload: () => ref.invalidate(groupDetailProvider(groupId)),
        ),
        loading: () => const _DetailLoadingState(),
        error: (e, _) => _DetailErrorState(
          message: userVisibleActionErrorMessage(e),
          onRetry: () => ref.invalidate(groupDetailProvider(groupId)),
          onBack: () => _goBack(context),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      leading: IconButton(
        tooltip: l10n.groupBackToDashboard,
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => _goBack(context),
      ),
      title: const BrandMark(variant: BrandAsset.icon, height: 32),
      centerTitle: true,
    );
  }
}

class _DetailLoadingState extends StatelessWidget {
  const _DetailLoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 2.6),
            ),
            const SizedBox(height: 14),
            Text(
              context.l10n.groupLoadingDetail,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailErrorState extends StatelessWidget {
  const _DetailErrorState({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  final String message;
  final VoidCallback? onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.softTerracotta.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 36,
                  color: AppTheme.softTerracotta,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.groupErrorTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              if (onRetry != null) ...[
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.retry),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: Text(l10n.groupBackToDashboard),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupDetailBody extends ConsumerStatefulWidget {
  final GroupDetail detail;
  final String? currentUid;
  final String groupId;
  final VoidCallback onAfterDraw;
  final VoidCallback onReload;

  const _GroupDetailBody({
    required this.detail,
    required this.currentUid,
    required this.groupId,
    required this.onAfterDraw,
    required this.onReload,
  });

  @override
  ConsumerState<_GroupDetailBody> createState() => _GroupDetailBodyState();
}

/// Secciones del detalle que se comportan como acordeón con expansión única.
/// Solo una puede estar expandida a la vez para evitar scroll infinito y
/// sobrecarga visual cuando hay muchos subgrupos o participantes.
enum _DetailSection { subgroups, registered, managed, invitations }

class _GroupDetailBodyState extends ConsumerState<_GroupDetailBody> {
  bool _drawing = false;
  bool _savingRule = false;
  bool _rotatingInviteCode = false;
  String? _lastInviteCode;
  // Sección actualmente expandida. `null` = todas colapsadas.
  // El usuario abre y cierra manualmente; no expandimos por defecto para
  // que la pantalla quede limpia y los headers se vean como un índice.
  _DetailSection? _expandedSection;

  void _toggleSection(_DetailSection section) {
    setState(() {
      _expandedSection = _expandedSection == section ? null : section;
    });
  }

  bool _userManagesManagedSecrets(GroupDetail d, String? uid) {
    if (uid == null) return false;
    return d.managedParticipants
        .any((p) => _isManagedSecretResponsible(d, p, uid));
  }

  GroupMember? _selfMember(GroupDetail d) {
    final uid = widget.currentUid;
    if (uid == null) return null;
    for (final m in d.members) {
      if (m.uid == uid && m.memberState == MemberState.active) return m;
    }
    return null;
  }

  List<GroupParticipant> _managedAssignedToMe(GroupDetail d) {
    final uid = widget.currentUid;
    if (uid == null) return const [];
    return d.managedParticipants
        .where((p) => _isManagedSecretResponsible(d, p, uid))
        .toList();
  }

  bool _memberShouldSeeSubgroupPicker(GroupDetail d) {
    if (d.drawSubgroupRule == DrawSubgroupRule.ignore) return false;
    return d.subgroups.isNotEmpty;
  }

  bool get _isOwner =>
      widget.currentUid != null && widget.currentUid == widget.detail.ownerUid;

  bool _drawAllowsSubgroupChange(DrawStatus status) {
    return status == DrawStatus.idle || status == DrawStatus.failed;
  }

  bool _canAssignSubgroup(GroupMember m) {
    if (!_drawAllowsSubgroupChange(widget.detail.drawStatus)) return false;
    if (_isOwner) return true;
    if (widget.currentUid != m.uid) return false;
    return m.memberState == MemberState.active;
  }

  bool get _canManageManagedParticipants {
    return _isOwner && _drawAllowsSubgroupChange(widget.detail.drawStatus);
  }

  Future<void> _showRulePickerSheet(GroupDetail d, bool canEditRule) async {
    if (!_isOwner) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheetContext.l10n.groupSectionDrawRule,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ..._drawRuleOrder.map(
                  (mode) => _RuleSheetTile(
                    title: _drawRuleOptionTitle(sheetContext, mode),
                    description: _drawRuleOptionDescription(sheetContext, mode),
                    selected: d.drawSubgroupRule == mode,
                    onTap: canEditRule
                        ? () async {
                            Navigator.pop(sheetContext);
                            await _applyDrawSubgroupRule(mode);
                          }
                        : null,
                  ),
                ),
                if (!canEditRule)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      sheetContext.l10n.groupRuleLockedHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _runDraw() async {
    final unifiedCounts = _buildUnifiedPreparationCounts(widget.detail);
    if (unifiedCounts.effectiveTotal < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.groupSnackNeedThreeParticipants)),
      );
      return;
    }
    if (!_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.groupSnackDrawAlreadyRunningOrDone),
        ),
      );
      return;
    }
    if (widget.detail.drawSubgroupRule == DrawSubgroupRule.requireDifferent &&
        unifiedCounts.withoutSubgroup > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.groupWarningMissingSubgroupRule),
        ),
      );
      return;
    }
    final idempotencyKey =
        'app-${DateTime.now().microsecondsSinceEpoch}-${widget.groupId}';
    setState(() => _drawing = true);
    try {
      final draw = ref.read(drawRepositoryProvider);
      await draw.executeDraw(
        groupId: widget.groupId,
        idempotencyKey: idempotencyKey,
      );
      if (!mounted) return;
      widget.onAfterDraw();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.groupSnackbarDrawCompleted)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _drawing = false);
    }
  }

  void _openAssignment(String executionId) {
    context.push(
      AppRoutes.myAssignment
          .replaceFirst(':groupId', widget.groupId)
          .replaceFirst(':executionId', executionId),
    );
  }

  void _openManagedAssignments(String executionId) {
    context.push(
      AppRoutes.managedAssignments
          .replaceFirst(':groupId', widget.groupId)
          .replaceFirst(':executionId', executionId),
    );
  }

  void _reloadDetail() {
    ref.invalidate(groupDetailProvider(widget.groupId));
  }

  Future<void> _showCreateSubgroupDialog() async {
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => const _CreateSubgroupDialog(),
    );
    if (!mounted || name == null) return;
    try {
      await ref
          .read(groupsRepositoryProvider)
          .createSubgroup(groupId: widget.groupId, name: name);
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupActionCreateSubgroup)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _showAssignSubgroupDialog(GroupMember member) async {
    final result = await showDialog<_SubgroupAssignResult>(
      context: context,
      builder: (ctx) => _AssignSubgroupDialog(
        member: member,
        subgroups: widget.detail.subgroups,
        isSelf: widget.currentUid == member.uid,
      ),
    );
    if (!mounted || result == null || !result.didSave) return;
    try {
      await ref
          .read(groupsRepositoryProvider)
          .setMemberSubgroup(
            groupId: widget.groupId,
            memberUid: member.uid,
            subgroupId: result.subgroupId,
          );
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupSnackbarSubgroupUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _applyDrawSubgroupRule(DrawSubgroupRule mode) async {
    if (mode == widget.detail.drawSubgroupRule) return;
    if (!_isOwner) return;
    if (!_drawAllowsSubgroupChange(widget.detail.drawStatus)) return;

    final unifiedCounts = _buildUnifiedPreparationCounts(widget.detail);
    if (mode == DrawSubgroupRule.requireDifferent &&
        unifiedCounts.withoutSubgroup > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.groupWarningMissingSubgroupRule)),
      );
    }

    setState(() => _savingRule = true);
    try {
      await ref
          .read(groupsRepositoryProvider)
          .setDrawSubgroupRule(groupId: widget.groupId, mode: mode);
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupSnackbarRuleUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _savingRule = false);
    }
  }

  Future<void> _rotateInviteCode() async {
    if (!_isOwner || _rotatingInviteCode) return;
    setState(() => _rotatingInviteCode = true);
    try {
      final code = await ref
          .read(groupsRepositoryProvider)
          .rotateInviteCode(groupId: widget.groupId);
      if (!mounted) return;
      setState(() => _lastInviteCode = code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.groupSnackbarNewCodeGenerated)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleErrorMessage(e))),
        );
      }
    } finally {
      if (mounted) setState(() => _rotatingInviteCode = false);
    }
  }

  Future<void> _copyInviteCode() async {
    final code = _lastInviteCode;
    if (code == null || code.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.codeCopied)),
    );
  }

  Future<void> _showCreateManagedParticipantDialog() async {
    if (!_isOwner) return;
    if (!_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.groupSnackCannotAddAfterDraw)),
      );
      return;
    }

    final result = await showDialog<_ManagedParticipantDraft>(
      context: context,
      builder: (ctx) => _CreateManagedParticipantDialog(
        subgroups: widget.detail.subgroups,
        ownerUid: widget.detail.ownerUid,
        eligibleDelegatedMembers:
            _eligibleDelegatedGuardians(widget.detail),
      ),
    );
    if (!mounted || result == null) return;

    try {
      await ref
          .read(groupsRepositoryProvider)
          .createManagedParticipant(
            groupId: widget.groupId,
            displayName: result.displayName,
            participantType: result.participantType,
            subgroupId: result.subgroupId,
            deliveryMode: result.deliveryMode,
            managedByUid: result.managedByUid,
          );
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupSnackbarManagedAdded)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _showRenameGroupDialog() async {
    if (!_isOwner || !_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      return;
    }
    final ctrl = TextEditingController(text: widget.detail.name);
    final nextName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.groupDialogEditGroupNameTitle),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: context.l10n.groupDialogGroupNameLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.groupDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    if (!mounted || nextName == null || nextName.trim().isEmpty) return;
    try {
      await ref
          .read(groupsRepositoryProvider)
          .renameGroup(groupId: widget.groupId, name: nextName.trim());
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupSnackbarGroupNameUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _showRenameSubgroupDialog(Subgroup subgroup) async {
    if (!_isOwner || !_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      return;
    }
    final ctrl = TextEditingController(text: subgroup.name);
    final nextName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.groupDialogRenameSubgroupTitle),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: context.l10n.groupDialogSubgroupNameLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.groupDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    if (!mounted || nextName == null || nextName.trim().isEmpty) return;
    try {
      await ref
          .read(groupsRepositoryProvider)
          .renameSubgroup(
            groupId: widget.groupId,
            subgroupId: subgroup.subgroupId,
            name: nextName.trim(),
          );
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupSnackbarSubgroupUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _deleteSubgroup(Subgroup subgroup) async {
    if (!_isOwner || !_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.groupDialogDeleteSubgroupTitle),
        content: Text(context.l10n.groupDialogDeleteSubgroupBody(subgroup.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.groupDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.groupDialogDelete),
          ),
        ],
      ),
    );
    if (!mounted || ok != true) return;
    try {
      await ref
          .read(groupsRepositoryProvider)
          .deleteSubgroup(
            groupId: widget.groupId,
            subgroupId: subgroup.subgroupId,
          );
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupActionDeleteSubgroup)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    }
  }

  int _subgroupAssignedCount(GroupDetail d, String subgroupId) {
    final members = d.members.where((m) => m.subgroupId == subgroupId).length;
    final managed = d.managedParticipants
        .where(
          (p) =>
              p.state == GroupParticipantState.active &&
              p.subgroupId == subgroupId,
        )
        .length;
    return members + managed;
  }

  Future<void> _reassignSubgroupParticipants({
    required String fromSubgroupId,
    String? toSubgroupId,
  }) async {
    final repo = ref.read(groupsRepositoryProvider);
    final members = widget.detail.members
        .where((m) => m.subgroupId == fromSubgroupId)
        .toList();
    final managed = widget.detail.managedParticipants
        .where(
          (p) =>
              p.state == GroupParticipantState.active &&
              p.subgroupId == fromSubgroupId,
        )
        .toList();

    for (final m in members) {
      await repo.setMemberSubgroup(
        groupId: widget.groupId,
        memberUid: m.uid,
        subgroupId: toSubgroupId,
      );
    }
    for (final p in managed) {
      await repo.updateManagedParticipant(
        groupId: widget.groupId,
        participantId: p.participantId,
        displayName: p.displayName,
        participantType: p.participantType == GroupParticipantType.childManaged
            ? 'child_managed'
            : 'managed',
        subgroupId: toSubgroupId,
        deliveryMode: p.deliveryMode.toFirestoreString(),
      );
    }
  }

  Future<void> _emptySubgroup(Subgroup subgroup) async {
    if (!_isOwner || !_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      return;
    }
    final assigned = _subgroupAssignedCount(widget.detail, subgroup.subgroupId);
    if (assigned == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.groupActionEmptySubgroup)),
      );
      return;
    }
    String? targetSubgroupId;
    final alternatives = widget.detail.subgroups
        .where((s) => s.subgroupId != subgroup.subgroupId)
        .toList();
    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => AlertDialog(
          title: Text(context.l10n.groupDialogEmptySubgroupTitle(subgroup.name)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.groupDialogSubgroupAssignedCount(assigned)),
              const SizedBox(height: 8),
              if (alternatives.isNotEmpty)
                DropdownButtonFormField<String?>(
                  value: targetSubgroupId,
                  decoration: InputDecoration(
                    labelText: context.l10n.groupDialogMoveToSubgroup,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(context.l10n.groupDialogLeaveWithoutSubgroup),
                    ),
                    ...alternatives.map(
                      (s) => DropdownMenuItem<String?>(
                        value: s.subgroupId,
                        child: Text(s.name),
                      ),
                    ),
                  ],
                  onChanged: (v) => setLocalState(() => targetSubgroupId = v),
                ),
              if (alternatives.isEmpty)
                Text(
                  context.l10n.groupDialogNoAlternativeSubgroup,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text(context.l10n.groupDialogCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, 'confirm'),
              child: Text(context.l10n.groupDialogEmpty),
            ),
          ],
        ),
      ),
    );
    if (!mounted || action != 'confirm') return;
    try {
      await _reassignSubgroupParticipants(
        fromSubgroupId: subgroup.subgroupId,
        toSubgroupId: targetSubgroupId,
      );
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupActionEmptySubgroup)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _resolveAndDeleteSubgroup(Subgroup subgroup) async {
    if (!_isOwner || !_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      return;
    }
    final assigned = _subgroupAssignedCount(widget.detail, subgroup.subgroupId);
    if (assigned == 0) {
      await _deleteSubgroup(subgroup);
      return;
    }

    String? targetSubgroupId;
    final alternatives = widget.detail.subgroups
        .where((s) => s.subgroupId != subgroup.subgroupId)
        .toList();
    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => AlertDialog(
          title: Text(context.l10n.groupDialogDeleteSubgroupTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.groupDialogSubgroupAssignedCountDelete(assigned),
              ),
              const SizedBox(height: 8),
              if (alternatives.isNotEmpty)
                DropdownButtonFormField<String?>(
                  value: targetSubgroupId,
                  decoration: InputDecoration(
                    labelText: context.l10n.groupDialogBeforeDeleteMoveTo,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(context.l10n.groupDialogLeaveWithoutSubgroup),
                    ),
                    ...alternatives.map(
                      (s) => DropdownMenuItem<String?>(
                        value: s.subgroupId,
                        child: Text(s.name),
                      ),
                    ),
                  ],
                  onChanged: (v) => setLocalState(() => targetSubgroupId = v),
                ),
              if (alternatives.isEmpty)
                Text(
                  context.l10n.groupDialogNoAlternativeSubgroup,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text(context.l10n.groupDialogCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, 'confirm'),
              child: Text(context.l10n.groupDialogMoveAndDelete),
            ),
          ],
        ),
      ),
    );
    if (!mounted || action != 'confirm') return;
    try {
      await _reassignSubgroupParticipants(
        fromSubgroupId: subgroup.subgroupId,
        toSubgroupId: targetSubgroupId,
      );
      await ref
          .read(groupsRepositoryProvider)
          .deleteSubgroup(
            groupId: widget.groupId,
            subgroupId: subgroup.subgroupId,
          );
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupActionDeleteSubgroup)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _showEditManagedParticipantDialog(
    GroupParticipant participant,
  ) async {
    if (!_isOwner || !_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      return;
    }
    final result = await showDialog<_ManagedParticipantDraft>(
      context: context,
      builder: (ctx) => _CreateManagedParticipantDialog(
        subgroups: widget.detail.subgroups,
        ownerUid: widget.detail.ownerUid,
        eligibleDelegatedMembers:
            _eligibleDelegatedGuardians(widget.detail),
        initial: participant,
      ),
    );
    if (!mounted || result == null) return;
    try {
      await ref
          .read(groupsRepositoryProvider)
          .updateManagedParticipant(
            groupId: widget.groupId,
            participantId: participant.participantId,
            displayName: result.displayName,
            participantType: result.participantType,
            subgroupId: result.subgroupId,
            deliveryMode: result.deliveryMode,
            managedByUid: result.managedByUid,
            syncManagedByUid: true,
          );
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupSnackbarManagedUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    }
  }

  Future<void> _removeManagedParticipant(GroupParticipant participant) async {
    if (!_isOwner || !_drawAllowsSubgroupChange(widget.detail.drawStatus)) {
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.groupDialogDeleteParticipantTitle),
        content: Text(
          context.l10n.groupDialogDeleteParticipantBody(participant.displayName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.groupDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.groupDialogDelete),
          ),
        ],
      ),
    );
    if (!mounted || ok != true) return;
    try {
      await ref
          .read(groupsRepositoryProvider)
          .removeManagedParticipant(
            groupId: widget.groupId,
            participantId: participant.participantId,
          );
      _reloadDetail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.groupSnackbarManagedDeleted)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final execId = d.currentExecutionId ?? d.lastExecutionId;
    final canEditRule = _drawAllowsSubgroupChange(d.drawStatus) && !_savingRule;
    final unifiedCounts = _buildUnifiedPreparationCounts(d);
    final subgroupsCount = d.subgroups.length;
    final hasSubgroups = subgroupsCount > 0;
    final shouldShowSubgroupsSection =
        hasSubgroups || d.drawSubgroupRule != DrawSubgroupRule.ignore;
    final missingSubgroupCount = unifiedCounts.withoutSubgroup;
    final missingSubgroupNames = _effectiveParticipantsWithoutSubgroupNames(d);
    final isCompleted = d.drawStatus == DrawStatus.completed;
    final drawReadyByParticipants = unifiedCounts.effectiveTotal >= 3;
    final drawReadyByStatus = _drawAllowsSubgroupChange(d.drawStatus);
    final drawReadyByRule = !(d.drawSubgroupRule ==
            DrawSubgroupRule.requireDifferent &&
        missingSubgroupCount > 0);
    final visualStatus = !drawReadyByParticipants
        ? l10n.groupStatusPreparing
        : !drawReadyByRule
            ? l10n.groupStatusMissingSubgroups
            : l10n.groupStatusReadyToDraw;
    final memberPreDraw = !_isOwner && !isCompleted;
    final memberPostDraw = !_isOwner && isCompleted;
    final heroTitle = isCompleted
        ? l10n.groupPostDrawHeroTitle
        : memberPreDraw
            ? (d.drawStatus == DrawStatus.drawing
                ? l10n.homeGroupDrawStateDrawing
                : l10n.groupMemberHeroTitlePreDraw)
            : visualStatus;
    final heroSubtitle = isCompleted
        ? (memberPostDraw
            ? l10n.groupMemberPostDrawHeroSubtitle
            : l10n.groupPostDrawHeroSubtitle)
        : memberPreDraw
            ? (d.drawStatus == DrawStatus.drawing
                ? l10n.groupMemberHeroSubtitleDrawing
                : l10n.groupMemberHeroSubtitlePreDraw)
            : (drawReadyByParticipants && drawReadyByRule
                ? l10n.groupStatusReadyInfo
                : l10n.groupStatusPendingInfo);
    final heroTagline = isCompleted
        ? (memberPostDraw
            ? l10n.groupMemberHeroTaglinePostDraw
            : l10n.groupDetailTaglinePostDraw)
        : memberPreDraw
            ? l10n.groupMemberHeroTaglinePreDraw
            : l10n.groupHeaderSubtitle;
    final canRunDraw = _isOwner &&
        !_drawing &&
        drawReadyByParticipants &&
        drawReadyByStatus &&
        drawReadyByRule;
    final activeMembers = d.members
        .where((m) => m.memberState == MemberState.active)
        .toList();
    final pendingMembers = d.members
        .where((m) => m.memberState != MemberState.active)
        .toList();
    // El hero ya no muestra el chip "Rol · Administrador" porque robaba
    // aire y no aporta valor emocional. El rol sigue disponible para
    // condicionar acciones a través de `_isOwner`.

    return RefreshIndicator(
      onRefresh: () async {
        widget.onReload();
        await ref.read(groupDetailProvider(widget.groupId).future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
        _GroupDetailHero(
          groupName: d.name,
          tagline: heroTagline,
          onEditName: _isOwner && _drawAllowsSubgroupChange(d.drawStatus)
              ? _showRenameGroupDialog
              : null,
        ),
        const SizedBox(height: 18),
        _StatusHeroCard(
          title: heroTitle,
          subtitle: heroSubtitle,
          isCompleted: isCompleted,
          isReady: drawReadyByParticipants &&
              drawReadyByRule &&
              drawReadyByStatus,
          calmWaiting: memberPreDraw,
          primary: !isCompleted && _isOwner
              ? _PrimaryAction(
                  label: l10n.groupActionRunDraw,
                  icon: Icons.shuffle_rounded,
                  loading: _drawing,
                  onPressed: canRunDraw ? _runDraw : null,
                )
              : (isCompleted && execId != null)
                  ? _PrimaryAction(
                      label: l10n.groupActionViewMySecretFriend,
                      icon: Icons.lock_outline,
                      onPressed: () => _openAssignment(execId),
                    )
                  : null,
          secondary: isCompleted &&
                  execId != null &&
                  _userManagesManagedSecrets(d, widget.currentUid)
              ? _PrimaryAction(
                  label: l10n.groupActionManagedSecrets,
                  icon: Icons.shield_moon_outlined,
                  onPressed: () => _openManagedAssignments(execId),
                )
              : null,
          ownerHint: null,
          pendingHint: !isCompleted && _isOwner && !canRunDraw
              ? (d.drawSubgroupRule == DrawSubgroupRule.requireDifferent &&
                      missingSubgroupCount > 0
                  ? l10n.groupPendingSubgroupHint
                  : l10n.groupPendingGeneralHint)
              : null,
          warning: !isCompleted &&
                  _isOwner &&
                  d.drawSubgroupRule == DrawSubgroupRule.requireDifferent &&
                  missingSubgroupCount > 0
              ? l10n.groupWarningMissingSubgroupCombined
              : null,
        ),
        if (!isCompleted && _isOwner) ...[
          const SizedBox(height: 16),
          _PreparationChecklist(
            totalEffective: unifiedCounts.effectiveTotal,
            pending: pendingMembers.length,
            missingSubgroup: missingSubgroupCount,
            missingNames: missingSubgroupNames,
            subgroupRuleActive:
                d.drawSubgroupRule != DrawSubgroupRule.ignore,
            subgroupsCount: subgroupsCount,
            withoutAppCount: unifiedCounts.withoutApp,
          ),
        ],
        if (!isCompleted && _isOwner) ...[
          const SizedBox(height: 16),
          _RuleSummaryCard(
            ruleTitle: _drawRuleOptionTitle(context, d.drawSubgroupRule),
            ruleDescription: _drawRuleOptionDescription(context, d.drawSubgroupRule),
            configVersion: l10n.groupRuleConfigVersion(d.rulesVersionCurrent),
            canEdit: _isOwner,
            onEdit: () => _showRulePickerSheet(d, canEditRule),
            saving: _savingRule,
          ),
        ],
        // ─── Secciones colapsables (single-expanded) ──────────────────────
        // Cada sección comparte header con conteo y se abre/cierra al tocar
        // su header. Solo una puede estar abierta a la vez (controlado por
        // `_expandedSection`). Esto evita scroll infinito cuando hay muchos
        // subgrupos, miembros, gestionados o invitaciones acumuladas.
        if (_isOwner && shouldShowSubgroupsSection) ...[
          const SizedBox(height: 16),
          _CollapsibleSection(
            icon: Icons.scatter_plot_outlined,
            title: l10n.groupSectionSubgroups,
            subtitle: l10n.groupSubgroupSectionHelp,
            count: subgroupsCount,
            expanded: _expandedSection == _DetailSection.subgroups,
            onToggle: () => _toggleSection(_DetailSection.subgroups),
            trailingAction: (_isOwner && !isCompleted)
                ? FilledButton.tonalIcon(
                    onPressed: _showCreateSubgroupDialog,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.groupActionCreateSubgroup),
                  )
                : null,
            child: _SubgroupsBody(
              detail: d,
              isOwner: _isOwner,
              isCompleted: isCompleted,
              onRename: _showRenameSubgroupDialog,
              onEmpty: _emptySubgroup,
              onDelete: _resolveAndDeleteSubgroup,
              assignedCount: _subgroupAssignedCount,
            ),
          ),
        ] else if (_isOwner) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l10n.groupSubgroupDisabledHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
        if (!_isOwner && !isCompleted && _memberShouldSeeSubgroupPicker(d)) ...[
          const SizedBox(height: 16),
          _MemberSubgroupChoiceCard(
            detail: d,
            selfMember: _selfMember(d),
            onTapAssign: () {
              final m = _selfMember(d);
              if (m != null) _showAssignSubgroupDialog(m);
            },
          ),
        ],
        if (_isOwner) ...[
        const SizedBox(height: 12),
        _CollapsibleSection(
          icon: Icons.people_alt_outlined,
          title: l10n.groupParticipantsRegisteredTitle,
          count: activeMembers.length,
          expanded: _expandedSection == _DetailSection.registered,
          onToggle: () => _toggleSection(_DetailSection.registered),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_drawAllowsSubgroupChange(d.drawStatus))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.groupParticipantSubgroupLockedHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (activeMembers.isEmpty)
                Text(
                  l10n.homeEmptyGroupsMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                ...activeMembers.map((m) {
                  final nick = m.nickname.isEmpty ? m.uid : m.nickname;
                  final subName = _subgroupDisplayName(d, m.subgroupId);
                  final canAssign = _canAssignSubgroup(m);
                  return PersonTile(
                    name: nick,
                    roleLabel: m.role == MemberRole.owner
                        ? l10n.groupRoleOrganizer
                        : l10n.groupRoleParticipant,
                    subgroupName: subName,
                    subgroupPrefix: l10n.groupSectionSubgroups,
                    noSubgroupLabel: l10n.groupNoSubgroupAssigned,
                    canEdit: canAssign,
                    onTap: canAssign
                        ? () => _showAssignSubgroupDialog(m)
                        : null,
                  );
                }),
              if (pendingMembers.isNotEmpty) ...[
                const SizedBox(height: 12),
                Divider(color: theme.colorScheme.outlineVariant, height: 1),
                const SizedBox(height: 10),
                Text(
                  l10n.groupParticipantsPendingTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                ...pendingMembers.map(
                  (m) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${m.nickname.isEmpty ? m.uid : m.nickname} · '
                            '${m.memberState == MemberState.left ? l10n.groupPendingStatusLeft : l10n.groupPendingStatusRemoved}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        ],
        const SizedBox(height: 12),
        if (!_isOwner && !isCompleted && _managedAssignedToMe(d).isNotEmpty) ...[
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeading(
                  icon: Icons.shield_moon_outlined,
                  title: l10n.groupMemberManagedByYouTitle,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.groupMemberManagedByYouSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                ..._managedAssignedToMe(d).map((p) {
                  final subgroupName = _subgroupDisplayName(d, p.subgroupId);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.displayName,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                subgroupName ?? l10n.groupNoSubgroupAssigned,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
        if (_isOwner) ...[
        const SizedBox(height: 12),
        _CollapsibleSection(
          icon: Icons.shield_moon_outlined,
          title: l10n.groupSectionManagedParticipants,
          subtitle: l10n.groupManagedSectionHelp,
          count: widget.detail.managedParticipants.length,
          expanded: _expandedSection == _DetailSection.managed,
          onToggle: () => _toggleSection(_DetailSection.managed),
          tone: AppTheme.deepPlumAlt,
          trailingAction: _isOwner && _canManageManagedParticipants
              ? FilledButton.tonalIcon(
                  onPressed: _showCreateManagedParticipantDialog,
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                  label: Text(l10n.groupManagedDialogAddTitle),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.detail.managedParticipants.isEmpty)
                Text(
                  l10n.groupManagedEmptyHelp,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                ...widget.detail.managedParticipants.map((p) {
                  final subgroupName = _subgroupDisplayName(
                    widget.detail,
                    p.subgroupId,
                  );
                  final respName =
                      _managedResponsibleNickname(widget.detail, p, l10n);
                  return GuardianTile(
                    name: p.displayName,
                    personTypeLabel:
                        p.participantType == GroupParticipantType.childManaged
                            ? l10n.groupTypeChildManaged
                            : l10n.groupTypeAdultNoApp,
                    subgroupName: subgroupName,
                    responsibilityLine:
                        l10n.groupManagedDeliversResponsible(respName),
                    subgroupPrefix: l10n.groupSectionSubgroups,
                    noSubgroupLabel: l10n.groupNoSubgroupAssigned,
                    privateResultLabel: l10n.groupPrivateResult,
                    trailing: _isOwner && _canManageManagedParticipants
                        ? PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditManagedParticipantDialog(p);
                              } else if (value == 'remove') {
                                _removeManagedParticipant(p);
                              }
                            },
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(l10n.groupActionEdit),
                              ),
                              PopupMenuItem(
                                value: 'remove',
                                child: Text(l10n.groupDialogDelete),
                              ),
                            ],
                          )
                        : null,
                  );
                }),
              if (widget.detail.managedParticipants.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.groupManagedPrivateDeliveryHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              if (_isOwner && !_canManageManagedParticipants) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.groupSnackCannotAddAfterDraw,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        ],
        if (!isCompleted && _isOwner) ...[
          const SizedBox(height: 12),
          _CollapsibleSection(
            icon: Icons.mail_outline,
            title: l10n.groupSectionInvitations,
            subtitle: l10n.groupInvitationsHelp,
            count: _lastInviteCode != null ? 1 : 0,
            expanded: _expandedSection == _DetailSection.invitations,
            onToggle: () => _toggleSection(_DetailSection.invitations),
            child: _InvitationsBody(
              isLoading: _rotatingInviteCode,
              inviteCode: _lastInviteCode,
              onGenerate: _rotateInviteCode,
              onCopy: _copyInviteCode,
            ),
          ),
        ],
        if (isCompleted && _isOwner) ...[
          const SizedBox(height: 16),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeading(
                  icon: Icons.mail_outline,
                  title: l10n.groupSectionInvitations,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.groupInvitationsClosedHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
        ],
      ),
    );
  }
}

/// Bloque simple para miembros: elegir o ver su casa/subgrupo sin panel de administración.
class _MemberSubgroupChoiceCard extends StatelessWidget {
  const _MemberSubgroupChoiceCard({
    required this.detail,
    required this.selfMember,
    required this.onTapAssign,
  });

  final GroupDetail detail;
  final GroupMember? selfMember;
  final VoidCallback onTapAssign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final m = selfMember;
    if (m == null) return const SizedBox.shrink();
    final subName = _subgroupDisplayName(detail, m.subgroupId);
    final hasSubgroup = m.subgroupId != null && m.subgroupId!.trim().isNotEmpty;
    final canTap = m.memberState == MemberState.active &&
        (detail.drawStatus == DrawStatus.idle ||
            detail.drawStatus == DrawStatus.failed);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            icon: Icons.cottage_outlined,
            title: l10n.groupMemberYourHouseTitle,
          ),
          const SizedBox(height: 8),
          Text(
            hasSubgroup
                ? l10n.groupMemberYourHouseAssigned(subName ?? '')
                : l10n.groupMemberYourHousePickHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
              height: 1.35,
            ),
          ),
          if (canTap) ...[
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: onTapAssign,
              icon: Icon(hasSubgroup ? Icons.edit_outlined : Icons.touch_app_outlined),
              label: Text(
                hasSubgroup
                    ? l10n.groupMemberYourHouseChangeCta
                    : l10n.groupMemberYourHouseChooseCta,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Hero del detalle: nombre del grupo + tagline cálido. Sin chip de rol;
/// el organizador ya conoce su rol y la información técnica añadía ruido.
class _GroupDetailHero extends StatelessWidget {
  const _GroupDetailHero({
    required this.groupName,
    required this.tagline,
    this.onEditName,
  });

  final String groupName;
  final String tagline;
  final VoidCallback? onEditName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 16, 20),
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
              Expanded(
                child: Text(
                  groupName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
              if (onEditName != null)
                IconButton(
                  tooltip: context.l10n.groupTooltipEditGroupName,
                  onPressed: onEditName,
                  icon: const Icon(Icons.edit_outlined),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            tagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusHeroCard extends StatelessWidget {
  const _StatusHeroCard({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isReady,
    this.calmWaiting = false,
    this.primary,
    this.secondary,
    this.ownerHint,
    this.pendingHint,
    this.warning,
  });

  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isReady;
  /// Miembro pre-sorteo: tono neutro (sin “alerta” terracota de preparación admin).
  final bool calmWaiting;
  final _PrimaryAction? primary;
  final _PrimaryAction? secondary;
  final String? ownerHint;
  final String? pendingHint;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final tone = isCompleted
        ? AppTheme.sageGreen
        : calmWaiting
            ? AppTheme.deepPlumAlt
            : isReady
                ? AppTheme.mutedGold
                : AppTheme.softTerracotta;
    final icon = isCompleted
        ? Icons.verified_outlined
        : calmWaiting
            ? Icons.hourglass_top_rounded
            : isReady
                ? Icons.check_circle_outline
                : Icons.pending_actions_outlined;
    return SecretCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: isCompleted
                      ? Border.all(
                          color: AppTheme.mutedGold.withValues(alpha: 0.45),
                          width: 1.2,
                        )
                      : null,
                ),
                child: Icon(
                  icon,
                  color: tone,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: (isCompleted
                          ? theme.textTheme.headlineSmall
                          : theme.textTheme.titleLarge)
                      ?.copyWith(
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
              height: 1.4,
            ),
          ),
          if (primary != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              style: isCompleted
                  ? FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      textStyle: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : null,
              onPressed: primary!.loading ? null : primary!.onPressed,
              icon: primary!.loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(primary!.icon),
              label: Text(primary!.label),
            ),
          ],
          if (secondary != null) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: isCompleted
                  ? OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      side: BorderSide(
                        color: AppTheme.deepPlum.withValues(alpha: 0.35),
                        width: 1.4,
                      ),
                    )
                  : null,
              onPressed: secondary!.onPressed,
              icon: Icon(secondary!.icon),
              label: Text(secondary!.label),
            ),
          ],
          // Hint de privacidad sobrio cuando el grupo está completado.
          // Se muestra justo bajo los CTAs y refuerza la idea de que
          // los resultados son individuales y privados, sin aspaviento.
          if (isCompleted) ...[
            const SizedBox(height: 14),
            _CompletedPrivacyHint(
              text: secondary != null
                  ? l10n.groupCompletedManagedHint
                  : l10n.groupCompletedPrivacyNote,
            ),
          ],
          if (ownerHint != null) ...[
            const SizedBox(height: 10),
            Text(
              ownerHint!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (pendingHint != null) ...[
            const SizedBox(height: 10),
            Text(
              pendingHint!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (warning != null) ...[
            const SizedBox(height: 10),
            WarningBox(message: warning!),
          ],
        ],
      ),
    );
  }
}

/// Hint de privacidad para el estado "grupo completado". Pequeño, en
/// itálicas, con icono de candado a la izquierda. No compite con los
/// CTAs principales pero deja claro que cada resultado es privado.
class _CompletedPrivacyHint extends StatelessWidget {
  const _CompletedPrivacyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
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
    );
  }
}

class _PrimaryAction {
  const _PrimaryAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool loading;
}

/// Checklist humano del grupo. Antes era un panel KPI con cifras frías
/// (`Registrados: X`, `Gestionados: X`, etc.); ahora muestra 2 items
/// principales con copy emocional: hay suficientes personas y todas tienen
/// subgrupo (si la regla lo requiere). Solo aparece el aviso de pendientes
/// cuando alguien salió/fue retirado.
class _PreparationChecklist extends StatelessWidget {
  const _PreparationChecklist({
    required this.totalEffective,
    required this.pending,
    required this.missingSubgroup,
    required this.missingNames,
    required this.subgroupRuleActive,
    required this.subgroupsCount,
    required this.withoutAppCount,
  });

  final int totalEffective;
  final int pending;
  final int missingSubgroup;
  final List<String> missingNames;
  final bool subgroupRuleActive;
  final int subgroupsCount;
  final int withoutAppCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final hasEnoughPeople = totalEffective >= 3;
    final allHaveSubgroup = missingSubgroup == 0;

    return SectionCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            icon: Icons.checklist_outlined,
            title: l10n.groupPreparationTitle,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.groupPreparationQuickSummary(
              totalEffective,
              withoutAppCount,
              subgroupsCount,
            ),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          _ChecklistItem(
            done: hasEnoughPeople,
            label: hasEnoughPeople
                ? l10n.groupChecklistEnoughPeopleDone
                : l10n.groupEffectiveParticipants(totalEffective),
            sublabel: hasEnoughPeople
                ? null
                : l10n.groupChecklistEnoughPeopleMissing,
          ),
          if (subgroupRuleActive) ...[
            const SizedBox(height: 4),
            _ChecklistItem(
              done: allHaveSubgroup,
              label: allHaveSubgroup
                  ? l10n.groupChecklistAllInSubgroupDone
                  : (missingSubgroup == 1
                      ? l10n.groupChecklistMissingSubgroupOne
                      : l10n.groupChecklistMissingSubgroupMany(
                          missingSubgroup,
                        )),
              sublabel:
                  !allHaveSubgroup && missingNames.isNotEmpty
                      ? _shortNamesList(missingNames)
                      : null,
              tone: allHaveSubgroup
                  ? AppTheme.sageGreen
                  : AppTheme.softTerracotta,
            ),
          ],
          if (pending > 0) ...[
            const SizedBox(height: 4),
            _ChecklistItem(
              done: false,
              label: l10n.groupChecklistPendingMembers(pending),
              tone: AppTheme.softTerracotta,
              isWarning: true,
            ),
          ],
          // Defensa: si no hay regla de subgrupo activa ni gente pendiente,
          // mantenemos al menos el primer item visible para que el card
          // tenga sentido.
          if (!subgroupRuleActive && pending == 0 && hasEnoughPeople)
            const SizedBox.shrink(),
          // hint silencioso: mantenemos referencia al theme para uso futuro
          // sin meter texto técnico.
          if (theme.brightness == Brightness.dark) const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.done,
    required this.label,
    this.sublabel,
    this.tone,
    this.isWarning = false,
  });

  final bool done;
  final String label;
  final String? sublabel;
  final Color? tone;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = tone ??
        (done ? AppTheme.sageGreen : AppTheme.softTerracotta);
    final IconData icon = isWarning
        ? Icons.error_outline_rounded
        : (done ? Icons.check_rounded : Icons.priority_high_rounded);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                if (sublabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sublabel!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleSummaryCard extends StatelessWidget {
  const _RuleSummaryCard({
    required this.ruleTitle,
    required this.ruleDescription,
    required this.configVersion,
    required this.canEdit,
    required this.onEdit,
    required this.saving,
  });

  final String ruleTitle;
  final String ruleDescription;
  final String configVersion;
  final bool canEdit;
  final VoidCallback onEdit;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Expanded fija el ancho disponible para el heading: dentro
              // recibe constraints tight, así que el Flexible interior
              // funciona correctamente y el título hace ellipsis si es
              // muy largo. Esto evita la cadena de RenderFlex unconstrained
              // que vimos antes.
              Expanded(
                child: _SectionHeading(
                  icon: Icons.tune_outlined,
                  title: l10n.groupSectionDrawRule,
                ),
              ),
              const SizedBox(width: 8),
              if (canEdit && !saving)
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(l10n.groupRuleChangeCta),
                ),
              if (saving)
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            configVersion,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            ruleTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ruleDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Body de la sección "Subgrupos" sin `SectionCard` ni heading; pensado
/// para ir dentro de un `_CollapsibleSection`.
class _SubgroupsBody extends StatelessWidget {
  const _SubgroupsBody({
    required this.detail,
    required this.isOwner,
    required this.isCompleted,
    required this.onRename,
    required this.onEmpty,
    required this.onDelete,
    required this.assignedCount,
  });

  final GroupDetail detail;
  final bool isOwner;
  final bool isCompleted;
  final void Function(Subgroup) onRename;
  final void Function(Subgroup) onEmpty;
  final void Function(Subgroup) onDelete;
  final int Function(GroupDetail, String) assignedCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (detail.subgroups.isEmpty)
          Text(
            l10n.groupSubgroupEmptyHelp,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ...detail.subgroups.map((s) {
            final assigned = assignedCount(detail, s.subgroupId);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
              decoration: BoxDecoration(
                color: AppTheme.warmIvory,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.deepPlum.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.group_work_outlined,
                      size: 18,
                      color: AppTheme.deepPlum,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          assigned == 1
                              ? l10n.groupSubgroupAssignedOne
                              : l10n.groupSubgroupAssignedMany(assigned),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isOwner && !isCompleted)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'rename') onRename(s);
                        if (value == 'empty') onEmpty(s);
                        if (value == 'delete') onDelete(s);
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'rename',
                          child: Text(l10n.groupActionRename),
                        ),
                        PopupMenuItem(
                          value: 'empty',
                          child: Text(l10n.groupActionEmptySubgroup),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(l10n.groupActionDeleteSubgroup),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }),
        if (isOwner && isCompleted) ...[
          const SizedBox(height: 8),
          Text(
            l10n.groupSubgroupLockedHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

/// Body de la sección "Invitaciones" sin `SectionCard` ni heading; pensado
/// para ir dentro de un `_CollapsibleSection`.
///
/// Comportamiento del código de invitación:
///   - Se muestra como un bloque grande, tappable.
///   - Al tocarlo se copia automáticamente al portapapeles (sin botón
///     "Copiar código" dedicado, eliminado por ruido visual).
///   - Feedback visual: snackbar elegante "Código copiado".
class _InvitationsBody extends StatelessWidget {
  const _InvitationsBody({
    required this.isLoading,
    required this.inviteCode,
    required this.onGenerate,
    required this.onCopy,
  });

  final bool isLoading;
  final String? inviteCode;
  final VoidCallback onGenerate;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.tonalIcon(
          onPressed: isLoading ? null : onGenerate,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded),
          label: Text(l10n.groupActionGenerateNewCode),
        ),
        if (inviteCode != null) ...[
          const SizedBox(height: 14),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: AppTheme.secretCardGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.deepPlum.withValues(alpha: 0.20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          inviteCode!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                            color: AppTheme.deepPlum,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: AppTheme.deepPlum.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.groupInvitationCodeTapHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

/// Encabezado de sección reutilizable: icono + título.
///
/// IMPORTANTE: este widget se utiliza tanto como hijo directo de `Column`
/// dentro de un `SectionCard` (caso normal) como dentro de un `Row` que
/// también contiene un `Spacer()` y acciones (caso `_RuleSummaryCard`).
///
/// En ese segundo caso, Flutter pasa a los hijos no-flex constraints
/// **loose** (no tight) en el eje principal porque el Spacer ocupa el
/// espacio sobrante. Si este `Row` interior usara `MainAxisSize.max` +
/// `Expanded(Text)`, `RenderFlex` se quedaría sin tamaño y propagaría
/// `BoxConstraints(unconstrained)` + `RenderBox was not laid out`,
/// rompiendo el render de todo el slivers/listview que lo contiene.
///
/// Solución defensiva:
///   - `mainAxisSize: MainAxisSize.min` → el Row se ajusta al contenido y
///     no exige conocer el ancho disponible para tamañarse.
///   - `Flexible(... maxLines: 2, overflow: ellipsis)` en lugar de
///     `Expanded` → permite que el texto se elipse cuando hay restricción
///     de ancho pero no exige tight constraints.
///
/// Con ello el componente es seguro en cualquier parent (Column directo,
/// Row con Spacer, otro Flex anidado).
class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppTheme.deepPlum),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

/// Sección colapsable con header tappable, badge de conteo y body animado.
///
/// Comportamiento:
///   - Expansión única gestionada por el padre vía `expanded` + `onToggle`.
///   - El header siempre es interactivo aunque no haya items.
///   - Animación suave (AnimatedCrossFade + AnimatedRotation del chevron).
///   - Apariencia premium: `SectionCard` exterior + tap target generoso.
///
/// El padre decide qué sección está abierta para garantizar que solo una
/// puede estar expandida a la vez (single-expanded), evitando scroll
/// infinito cuando hay 10-15 subgrupos o muchos participantes.
class _CollapsibleSection extends StatelessWidget {
  const _CollapsibleSection({
    required this.icon,
    required this.title,
    required this.count,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.subtitle,
    this.trailingAction,
    this.tone,
  });

  final IconData icon;
  final String title;
  final int count;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final String? subtitle;
  final Widget? trailingAction;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = tone ?? AppTheme.deepPlum;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 18, color: accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (count > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$count',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      child,
                      if (trailingAction != null) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: trailingAction,
                        ),
                      ],
                    ],
                  ),
                ),
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 220),
                sizeCurve: Curves.easeOutCubic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleSheetTile extends StatelessWidget {
  const _RuleSheetTile({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected
            ? AppTheme.deepPlum.withValues(alpha: 0.07)
            : AppTheme.warmIvory,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? AppTheme.deepPlum.withValues(alpha: 0.40)
                    : theme.colorScheme.outlineVariant,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off_outlined,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubgroupAssignResult {
  const _SubgroupAssignResult({required this.didSave, this.subgroupId});

  final bool didSave;
  final String? subgroupId;
}

class _ManagedParticipantDraft {
  const _ManagedParticipantDraft({
    required this.displayName,
    required this.participantType,
    required this.subgroupId,
    required this.deliveryMode,
    this.managedByUid,
  });

  final String displayName;
  final String participantType;
  final String? subgroupId;
  final String deliveryMode;
  /// `null` = responsable el organizador (contrato backend / Firestore).
  final String? managedByUid;
}

class _CreateSubgroupDialog extends StatefulWidget {
  const _CreateSubgroupDialog();

  @override
  State<_CreateSubgroupDialog> createState() => _CreateSubgroupDialogState();
}

class _CreateSubgroupDialogState extends State<_CreateSubgroupDialog> {
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    // Popup de creación con menos sensación de formulario:
    // el input vive dentro de un contenedor cálido, con bordes suaves y
    // tipografía relajada. Mantenemos un único campo (el del backend) para
    // no añadir más fricción.
    return PremiumDialog(
      icon: Icons.scatter_plot_outlined,
      title: l10n.groupActionCreateSubgroup,
      subtitle: l10n.groupSubgroupSectionHelp,
      content: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: AppTheme.warmIvory,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: TextField(
          controller: _nameCtrl,
          decoration: InputDecoration(
            labelText: l10n.groupManagedDialogNameLabel,
            hintText: l10n.groupCreateSubgroupHint,
            prefixIcon: const Icon(Icons.bookmark_outline),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
          ),
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
        ),
      ),
      primaryLabel: l10n.create,
      onPrimary: () {
        final name = _nameCtrl.text.trim();
        if (name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.groupSnackbarWriteName)),
          );
          return;
        }
        Navigator.pop(context, name);
      },
      secondaryLabel: l10n.groupDialogCancel,
      onSecondary: () => Navigator.pop(context),
    );
  }
}

class _AssignSubgroupDialog extends StatefulWidget {
  const _AssignSubgroupDialog({
    required this.member,
    required this.subgroups,
    required this.isSelf,
  });

  final GroupMember member;
  final List<Subgroup> subgroups;
  final bool isSelf;

  @override
  State<_AssignSubgroupDialog> createState() => _AssignSubgroupDialogState();
}

class _AssignSubgroupDialogState extends State<_AssignSubgroupDialog> {
  late String? _selected;

  @override
  void initState() {
    super.initState();
    var initial = widget.member.subgroupId;
    if (initial != null &&
        !widget.subgroups.any((s) => s.subgroupId == initial)) {
      initial = null;
    }
    _selected = initial;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final nick = widget.member.nickname.isEmpty
        ? widget.member.uid
        : widget.member.nickname;
    return PremiumDialog(
      icon: Icons.scatter_plot_outlined,
      title: widget.isSelf
          ? l10n.groupAssignDialogSelfTitle
          : l10n.groupAssignDialogTitle,
      subtitle: widget.isSelf
          ? l10n.groupAssignDialogSelfDesc
          : l10n.groupAssignDialogDesc,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(nick, style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            value: _selected,
            decoration: InputDecoration(
              labelText: l10n.groupAssignDialogSubgroupLabel,
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(l10n.groupManagedDialogNoSubgroup),
              ),
              ...widget.subgroups.map(
                (s) => DropdownMenuItem<String?>(
                  value: s.subgroupId,
                  child: Text(s.name),
                ),
              ),
            ],
            onChanged: (v) => setState(() => _selected = v),
          ),
        ],
      ),
      primaryLabel: l10n.save,
      onPrimary: () => Navigator.pop(
        context,
        _SubgroupAssignResult(didSave: true, subgroupId: _selected),
      ),
      secondaryLabel: l10n.groupDialogCancel,
      onSecondary: () => Navigator.pop(
        context,
        const _SubgroupAssignResult(didSave: false),
      ),
    );
  }
}

class _CreateManagedParticipantDialog extends StatefulWidget {
  const _CreateManagedParticipantDialog({
    required this.subgroups,
    required this.ownerUid,
    required this.eligibleDelegatedMembers,
    this.initial,
  });

  final List<Subgroup> subgroups;
  final String ownerUid;
  final List<GroupMember> eligibleDelegatedMembers;
  final GroupParticipant? initial;

  @override
  State<_CreateManagedParticipantDialog> createState() =>
      _CreateManagedParticipantDialogState();
}

/// Crear/editar participante sin app (tipo, subgrupo, responsable de entrega, modo entrega).
class _CreateManagedParticipantDialogState
    extends State<_CreateManagedParticipantDialog> {
  final _nameCtrl = TextEditingController();
  String _participantType = 'managed';
  static const _deliveryVerbal = 'verbal';
  static const _deliveryPrinted = 'printed';
  static const _deliveryWhatsapp = 'whatsapp';
  static const _deliveryEmail = 'email';
  String _deliveryMode = _deliveryVerbal;
  static const _guardianSelf = 'self';
  static const _guardianOther = 'other';
  static const _guardianSpecific = 'specific';
  String _guardian = _guardianSelf;
  String? _subgroupId;
  String? _otherGuardianUid;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial == null) return;
    _nameCtrl.text = initial.displayName;
    _participantType =
        initial.participantType == GroupParticipantType.childManaged
            ? 'child_managed'
            : 'managed';
    _deliveryMode = switch (initial.deliveryMode) {
      ManagedParticipantDeliveryMode.printed => _deliveryPrinted,
      ManagedParticipantDeliveryMode.verbal => _deliveryVerbal,
      ManagedParticipantDeliveryMode.whatsapp => _deliveryWhatsapp,
      ManagedParticipantDeliveryMode.email => _deliveryEmail,
      ManagedParticipantDeliveryMode.ownerDelegated ||
      ManagedParticipantDeliveryMode.inApp =>
        _deliveryVerbal,
    };
    _subgroupId = initial.subgroupId;
    final m = initial.managedByUid;
    final owner = widget.ownerUid;
    if (m == null || m == owner) {
      _guardian = _guardianSelf;
      _otherGuardianUid = null;
    } else {
      _guardian = _guardianOther;
      _otherGuardianUid = m;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _persistableDeliveryMode() {
    return switch (_deliveryMode) {
      _deliveryPrinted => _deliveryPrinted,
      _deliveryVerbal => _deliveryVerbal,
      _deliveryWhatsapp => _deliveryWhatsapp,
      _deliveryEmail => _deliveryEmail,
      _ => _deliveryVerbal,
    };
  }

  String? _subgroupNameForMember(GroupMember m) {
    final id = m.subgroupId;
    if (id == null || id.isEmpty) return null;
    for (final s in widget.subgroups) {
      if (s.subgroupId == id) return s.name;
    }
    return null;
  }

  String? _nicknameForDelegatedUid(String uid) {
    for (final m in widget.eligibleDelegatedMembers) {
      if (m.uid == uid) return m.nickname;
    }
    return null;
  }

  Future<void> _openDelegatedGuardianPicker(BuildContext context) async {
    final l10n = context.l10n;
    final members = widget.eligibleDelegatedMembers;
    final picked = await showModalBottomSheet<GroupMember>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) {
        final theme = Theme.of(sheetCtx);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Text(
                    l10n.groupManagedDialogPickGuardianTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                for (final m in members)
                  ListTile(
                    title: Text(m.nickname),
                    subtitle: _subgroupNameForMember(m) != null
                        ? Text(_subgroupNameForMember(m)!)
                        : null,
                    onTap: () => Navigator.pop(sheetCtx, m),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted || picked == null) return;
    setState(() {
      _guardian = _guardianOther;
      _otherGuardianUid = picked.uid;
    });
  }

  void _onGuardianChoice(String v, BuildContext context) {
    if (v == _guardianSelf) {
      setState(() {
        _guardian = _guardianSelf;
        _otherGuardianUid = null;
      });
      return;
    }
    if (v == _guardianOther) {
      if (widget.eligibleDelegatedMembers.isEmpty) return;
      setState(() => _guardian = _guardianOther);
      unawaited(_openDelegatedGuardianPicker(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final canDelegate =
        widget.eligibleDelegatedMembers.isNotEmpty;
    return PremiumDialog(
      icon: Icons.shield_moon_outlined,
      title: widget.initial == null
          ? l10n.groupManagedDialogAddTitle
          : l10n.groupManagedDialogEditTitle,
      subtitle: l10n.groupManagedDialogWhoManagesDesc,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: l10n.groupManagedDialogNameLabel,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: widget.initial == null,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: _participantType,
            decoration: InputDecoration(
              labelText: l10n.groupManagedDialogTypeLabel,
            ),
            items: [
              DropdownMenuItem(
                value: 'managed',
                child: Text(l10n.groupManagedDialogTypeAdultNoApp),
              ),
              DropdownMenuItem(
                value: 'child_managed',
                child: Text(l10n.groupManagedDialogTypeChild),
              ),
            ],
            onChanged: (v) => setState(() => _participantType = v ?? 'managed'),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String?>(
            value: _subgroupId,
            decoration: InputDecoration(
              labelText: l10n.groupManagedDialogSubgroupOptionalLabel,
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(l10n.groupManagedDialogNoSubgroup),
              ),
              ...widget.subgroups.map(
                (s) => DropdownMenuItem<String?>(
                  value: s.subgroupId,
                  child: Text(s.name),
                ),
              ),
            ],
            onChanged: (v) => setState(() => _subgroupId = v),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.groupManagedDialogGuardianSectionTitle,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _ChoiceRow(
            options: [
              _ChoiceOption(
                value: _guardianSelf,
                icon: Icons.person_outline,
                label: l10n.groupManagedDialogGuardianMe,
                hint: l10n.groupManagedDialogGuardianMeHint,
                enabled: true,
              ),
              _ChoiceOption(
                value: _guardianOther,
                icon: Icons.group_outlined,
                label: l10n.groupManagedDialogGuardianOther,
                hint: canDelegate
                    ? null
                    : l10n.groupManagedDialogGuardianNoEligibleMembers,
                enabled: canDelegate,
              ),
              _ChoiceOption(
                value: _guardianSpecific,
                icon: Icons.shield_outlined,
                label: l10n.groupManagedDialogGuardianSpecific,
                hint: l10n.groupManagedDialogGuardianComingSoon,
                enabled: false,
              ),
            ],
            selected: _guardian,
            onChanged: (v) => _onGuardianChoice(v, context),
          ),
          if (_guardian == _guardianOther) ...[
            const SizedBox(height: 10),
            Text(
              l10n.groupManagedDialogGuardianOtherSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 8),
            if (_otherGuardianUid != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _openDelegatedGuardianPicker(context),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(
                    l10n.groupManagedDialogDeliversSummary(
                      _nicknameForDelegatedUid(_otherGuardianUid!) ??
                          l10n.groupManagedResponsibleUnavailable,
                    ),
                  ),
                ),
              )
            else
              FilledButton.tonal(
                onPressed: canDelegate
                    ? () => _openDelegatedGuardianPicker(context)
                    : null,
                child: Text(l10n.groupManagedDialogPickMemberCta),
              ),
          ],
          const SizedBox(height: 18),
          Text(
            l10n.groupManagedDialogDeliverySectionTitle,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _ChoiceRow(
            options: [
              _ChoiceOption(
                value: _deliveryWhatsapp,
                icon: Icons.chat_bubble_outline,
                label: l10n.groupManagedDialogDeliveryWhatsapp,
                enabled: true,
              ),
              _ChoiceOption(
                value: _deliveryEmail,
                icon: Icons.mail_outline,
                label: l10n.groupManagedDialogDeliveryEmail,
                enabled: true,
              ),
              _ChoiceOption(
                value: _deliveryVerbal,
                icon: Icons.record_voice_over_outlined,
                label: l10n.groupManagedDialogDeliveryVerbal,
                enabled: true,
              ),
              _ChoiceOption(
                value: _deliveryPrinted,
                icon: Icons.picture_as_pdf_outlined,
                label: l10n.groupManagedDialogDeliveryPrinted,
                enabled: true,
              ),
            ],
            selected: _deliveryMode,
            onChanged: (v) => setState(() => _deliveryMode = v),
          ),
        ],
      ),
      primaryLabel: l10n.save,
      onPrimary: () {
        final displayName = _nameCtrl.text.trim();
        if (displayName.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.groupSnackbarWriteName)),
          );
          return;
        }
        if (_guardian == _guardianOther) {
          final uid = _otherGuardianUid?.trim();
          if (uid == null || uid.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.groupManagedDialogSelectOtherFirst)),
            );
            return;
          }
          final allowed =
              widget.eligibleDelegatedMembers.any((m) => m.uid == uid);
          if (!allowed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.groupManagedDialogGuardianMustReassign),
              ),
            );
            return;
          }
        }
        final managedByUid = _guardian == _guardianSelf
            ? null
            : _otherGuardianUid!.trim();
        Navigator.pop(
          context,
          _ManagedParticipantDraft(
            displayName: displayName,
            participantType: _participantType,
            subgroupId: _subgroupId,
            deliveryMode: _persistableDeliveryMode(),
            managedByUid: managedByUid,
          ),
        );
      },
      secondaryLabel: l10n.groupDialogCancel,
      onSecondary: () => Navigator.pop(context),
    );
  }
}

/// Opción visual para `_ChoiceRow` (chips de selección con icono + label).
class _ChoiceOption {
  const _ChoiceOption({
    required this.value,
    required this.icon,
    required this.label,
    this.hint,
    this.enabled = true,
  });

  final String value;
  final IconData icon;
  final String label;
  final String? hint;
  final bool enabled;
}

/// Fila de chips de selección. Cuando una opción no está habilitada, se
/// muestra atenuada con un pequeño badge ("Próximamente"). Tap mostrará
/// un snackbar amable indicando que la opción aún no está disponible.
///
/// Diseño pensado para sustituir el típico `DropdownButtonFormField` por
/// un patrón visual más cálido y social, sin sensación de formulario CRUD.
class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<_ChoiceOption> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = opt.value == selected;
        return _ChoiceChip(
          option: opt,
          selected: isSelected,
          onTap: () {
            if (opt.enabled) {
              onChanged(opt.value);
            } else if (opt.hint != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(opt.hint!)),
              );
            }
          },
        );
      }).toList(),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _ChoiceOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppTheme.deepPlum;
    final disabled = !option.enabled;
    final bg = selected
        ? accent.withValues(alpha: 0.10)
        : (disabled ? AppTheme.warmIvory : AppTheme.softCream);
    final borderColor = selected
        ? accent.withValues(alpha: 0.45)
        : theme.colorScheme.outlineVariant;
    final fgColor = disabled
        ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
        : (selected ? accent : theme.colorScheme.onSurface);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(option.icon, size: 18, color: fgColor),
                    const SizedBox(width: 8),
                    Text(
                      option.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: fgColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (option.hint != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    option.hint!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
