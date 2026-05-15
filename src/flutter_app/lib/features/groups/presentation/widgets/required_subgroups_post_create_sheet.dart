import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../domain/group_models.dart';
import '../providers.dart';

/// Configuración guiada inmediata tras crear Amigo Secreto con regla
/// [DrawSubgroupRule.requireDifferent] y sin subgrupos (Fase 13.1).
Future<void> showRequiredSubgroupsPostCreateSheet({
  required BuildContext context,
  required String groupId,
  required GroupDetail initialDetail,
  required VoidCallback onReload,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return RequiredSubgroupsPostCreateSheet(
        groupId: groupId,
        initialDetail: initialDetail,
        onReload: onReload,
      );
    },
  );
}

class RequiredSubgroupsPostCreateSheet extends ConsumerStatefulWidget {
  const RequiredSubgroupsPostCreateSheet({
    super.key,
    required this.groupId,
    required this.initialDetail,
    required this.onReload,
  });

  final String groupId;
  final GroupDetail initialDetail;
  final VoidCallback onReload;

  @override
  ConsumerState<RequiredSubgroupsPostCreateSheet> createState() =>
      _RequiredSubgroupsPostCreateSheetState();
}

class _RequiredSubgroupsPostCreateSheetState
    extends ConsumerState<RequiredSubgroupsPostCreateSheet> {
  static const int _minSubgroups = 2;

  final List<TextEditingController> _nameCtrls = [
    TextEditingController(),
    TextEditingController(),
  ];
  int _page = 0;
  bool _busy = false;
  List<Subgroup>? _created;
  String? _selectedSubgroupId;
  String? _validationMessage;

  @override
  void dispose() {
    for (final c in _nameCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _needsOwnerSubgroup {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;
    for (final m in widget.initialDetail.members) {
      if (m.uid == uid && m.memberState == MemberState.active) {
        return true;
      }
    }
    return false;
  }

  List<String> _collectSubgroupNames() {
    return _nameCtrls
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  String? _validateNames(List<String> names) {
    final l10n = context.l10n;
    if (names.length < _minSubgroups) {
      return l10n.requiredSubgroupsSetupErrorMinTwo;
    }
    final lower = <String>{};
    for (final n in names) {
      final k = n.toLowerCase();
      if (lower.contains(k)) {
        return l10n.requiredSubgroupsSetupErrorDuplicateName;
      }
      lower.add(k);
    }
    return null;
  }

  Future<void> _onCreateSubgroups() async {
    final l10n = context.l10n;
    setState(() {
      _validationMessage = null;
    });
    final names = _collectSubgroupNames();
    final err = _validateNames(names);
    if (err != null) {
      setState(() => _validationMessage = err);
      return;
    }
    setState(() => _busy = true);
    try {
      final repo = ref.read(groupsRepositoryProvider);
      final created = <Subgroup>[];
      for (final name in names) {
        final s =
            await repo.createSubgroup(groupId: widget.groupId, name: name);
        created.add(s);
      }
      if (!mounted) return;
      widget.onReload();
      if (!_needsOwnerSubgroup) {
        Navigator.of(context).pop();
        return;
      }
      setState(() {
        _created = created;
        _page = 1;
        _selectedSubgroupId =
            created.isNotEmpty ? created.first.subgroupId : null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleErrorMessage(e, l10n))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _onSaveOwnerSubgroup() async {
    final l10n = context.l10n;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final id = _selectedSubgroupId;
    if (uid == null || id == null || id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.requiredSubgroupsSetupAssignErrorSelect)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(groupsRepositoryProvider).setMemberSubgroup(
            groupId: widget.groupId,
            memberUid: uid,
            subgroupId: id,
          );
      if (!mounted) return;
      widget.onReload();
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleErrorMessage(e, l10n))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _addField() {
    setState(() {
      _nameCtrls.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        decoration: BoxDecoration(
          color: AppTheme.softCream,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: AppTheme.softElevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
                child: _page == 0
                    ? _buildCreatePage(theme, l10n)
                    : _buildAssignPage(theme, l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePage(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppTheme.brandHeroGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.scatter_plot_outlined,
                color: AppTheme.deepPlum.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.requiredSubgroupsSetupSheetTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          l10n.requiredSubgroupsSetupSheetBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
            height: 1.5,
          ),
        ),
        if (_validationMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _validationMessage!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
        const SizedBox(height: 18),
        ...List.generate(_nameCtrls.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              controller: _nameCtrls[i],
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.requiredSubgroupsSetupSubgroupFieldLabel(i + 1),
                filled: true,
                fillColor: AppTheme.warmIvory,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _busy ? null : _addField,
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: Text(l10n.requiredSubgroupsSetupAddAnother),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _busy ? null : _onCreateSubgroups,
          child: _busy
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.requiredSubgroupsSetupContinue),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
            child: Text(l10n.requiredSubgroupsSetupDoLater),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignPage(ThemeData theme, AppLocalizations l10n) {
    final list = _created ?? const <Subgroup>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppTheme.brandHeroGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.person_pin_circle_outlined,
                color: AppTheme.deepPlum.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.requiredSubgroupsSetupAssignTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          l10n.requiredSubgroupsSetupAssignBody,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        SecretCard(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
          child: Column(
            children: [
              for (final s in list)
                RadioListTile<String>(
                  value: s.subgroupId,
                  groupValue: _selectedSubgroupId,
                  onChanged:
                      _busy ? null : (v) => setState(() => _selectedSubgroupId = v),
                  title: Text(
                    s.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _onSaveOwnerSubgroup,
          child: _busy
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.requiredSubgroupsSetupSaveContinue),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
            child: Text(l10n.requiredSubgroupsSetupDoLater),
          ),
        ),
      ],
    );
  }
}
