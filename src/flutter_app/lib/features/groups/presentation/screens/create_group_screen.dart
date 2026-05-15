import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../domain/group_models.dart';
import '../providers.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  static const int _totalSteps = 7;

  final _nameCtrl = TextEditingController();
  final _nickCtrl = TextEditingController(text: 'Yo');
  bool _loading = false;
  int _step = 0;
  String _groupType = 'family';
  DrawSubgroupRule _drawRule = DrawSubgroupRule.ignore;
  DateTime? _eventDate;
  bool _ownerParticipatesInSecretSanta = true;

  static const _groupTypeOptions = ['family', 'friends', 'company', 'class', 'other'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nickCtrl.dispose();
    super.dispose();
  }

  bool _isFunctionsEnvironmentError(Object e) {
    if (e is! FirebaseFunctionsException) return false;
    final code = e.code.toLowerCase();
    if (code == 'not-found' || code == 'unavailable' || code == 'internal') {
      return true;
    }
    final msg = (e.message ?? '').toLowerCase();
    return msg.contains('function') ||
        msg.contains('not found') ||
        msg.contains('unavailable');
  }

  bool get _isLastStep => _step == _totalSteps - 1;

  String _groupTypeLabel(BuildContext context, String value) {
    switch (value) {
      case 'family':
        return context.l10n.wizardTypeFamily;
      case 'friends':
        return context.l10n.wizardTypeFriends;
      case 'company':
        return context.l10n.wizardTypeCompany;
      case 'class':
        return context.l10n.wizardTypeClass;
      default:
        return context.l10n.wizardTypeOther;
    }
  }

  IconData _groupTypeIcon(String value) {
    switch (value) {
      case 'family':
        return Icons.family_restroom_outlined;
      case 'friends':
        return Icons.groups_outlined;
      case 'company':
        return Icons.work_outline;
      case 'class':
        return Icons.school_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  ({IconData icon, String title, String help}) _stepMeta(BuildContext context) {
    switch (_step) {
      case 0:
        return (
          icon: Icons.edit_outlined,
          title: context.l10n.wizardStepNameTitle,
          help: context.l10n.wizardNameHelp,
        );
      case 1:
        return (
          icon: Icons.groups_2_outlined,
          title: context.l10n.wizardStepGroupTypeTitle,
          help: context.l10n.wizardGroupTypeHelp,
        );
      case 2:
        return (
          icon: Icons.tune_outlined,
          title: context.l10n.wizardStepRuleTitle,
          help: context.l10n.wizardRuleHelp,
        );
      case 3:
        return (
          icon: Icons.scatter_plot_outlined,
          title: context.l10n.wizardStepSubgroupsTitle,
          help: _drawRule == DrawSubgroupRule.ignore
              ? context.l10n.wizardSubgroupsHelpIgnore
              : context.l10n.wizardSubgroupsHelpEnabled,
        );
      case 4:
        return (
          icon: Icons.event_outlined,
          title: context.l10n.wizardStepEventDateTitle,
          help: context.l10n.wizardStepEventDateHelp,
        );
      case 5:
        return (
          icon: Icons.person_outline,
          title: context.l10n.wizardStepParticipantsTitle,
          help: context.l10n.wizardParticipantsHelp,
        );
      case 6:
        return (
          icon: Icons.fact_check_outlined,
          title: context.l10n.wizardStepReviewTitle,
          help: context.l10n.wizardReviewSummaryHelp,
        );
      default:
        return (
          icon: Icons.bookmark_outline,
          title: '',
          help: '',
        );
    }
  }

  bool _validateCurrentStep() {
    if (_step == 0 && _nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.wizardGroupNameLabel)),
      );
      return false;
    }
    if (_step == 5 && _ownerParticipatesInSecretSanta && _nickCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.wizardNicknameLabel)),
      );
      return false;
    }
    return true;
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;
    if (_step < _totalSteps - 1) setState(() => _step++);
  }

  void _previousStep() {
    if (_step > 0) setState(() => _step--);
  }

  String _ruleTitle(BuildContext context, DrawSubgroupRule r) {
    switch (r) {
      case DrawSubgroupRule.ignore:
        return context.l10n.wizardRuleIgnore;
      case DrawSubgroupRule.preferDifferent:
        return context.l10n.wizardRulePrefer;
      case DrawSubgroupRule.requireDifferent:
        return context.l10n.wizardRuleRequire;
    }
  }

  String _ruleDescription(BuildContext context, DrawSubgroupRule r) {
    switch (r) {
      case DrawSubgroupRule.ignore:
        return context.l10n.wizardRuleIgnoreDesc;
      case DrawSubgroupRule.preferDifferent:
        return context.l10n.wizardRulePreferDesc;
      case DrawSubgroupRule.requireDifferent:
        return context.l10n.wizardRuleRequireDesc;
    }
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final participates = _ownerParticipatesInSecretSanta;
    final nick = participates
        ? _nickCtrl.text.trim()
        : context.l10n.wizardSecretSantaOrganizerOnlyNickFallback;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.wizardGroupNameLabel)),
      );
      return;
    }
    if (participates && nick.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.wizardNicknameLabel)),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final repo = ref.read(groupsRepositoryProvider);
      final created = await repo.createGroup(
        name: name,
        nickname: nick,
        eventDate: _eventDate,
        ownerParticipatesInSecretSanta: participates,
      );
      if (_drawRule != DrawSubgroupRule.ignore) {
        await repo.setDrawSubgroupRule(
          groupId: created.groupId,
          mode: _drawRule,
        );
      }
      if (!mounted) return;
      ref.invalidate(myGroupsProvider);
      final openGroup = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _GroupCreatedDialog(
          groupName: name,
          created: created,
        ),
      );
      if (!mounted) return;
      if (openGroup == true) {
        context.go(
          AppRoutes.groupDetailFor(created.groupId),
          extra: GroupDetailRouteExtra(
            offerPostCreateRequiredSubgroupsSetup:
                _drawRule == DrawSubgroupRule.requireDifferent,
          ),
        );
      } else {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final isDebugFunctionsError =
            kDebugMode && _isFunctionsEnvironmentError(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isDebugFunctionsError
                  ? context.l10n.wizardCreateFunctionsError
                  : userVisibleErrorMessage(e, context.l10n),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = _stepMeta(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.wizardCreateTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: Column(
            children: [
              _StepProgress(step: _step, total: _totalSteps),
              const SizedBox(height: 14),
              Expanded(
                child: SingleChildScrollView(
                  child: SectionCard(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                gradient: AppTheme.brandHeroGradient,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                meta.icon,
                                color: AppTheme.deepPlum,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                meta.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          meta.help,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ..._buildStepContent(context),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: _loading || _step == 0 ? null : _previousStep,
                      child: Text(context.l10n.back),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: FilledButton(
                      onPressed: _loading
                          ? null
                          : _isLastStep
                              ? _submit
                              : _nextStep,
                      child: _loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _isLastStep
                                  ? context.l10n.wizardCreateButton
                                  : context.l10n.next,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStepContent(BuildContext context) {
    final theme = Theme.of(context);
    switch (_step) {
      case 0:
        return [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: context.l10n.wizardGroupNameLabel,
              hintText: context.l10n.wizardGroupNameHint,
              prefixIcon: const Icon(Icons.bookmark_outline),
            ),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
          ),
        ];
      case 1:
        return [
          ..._groupTypeOptions.map(
            (option) => _ChoiceTile(
              icon: _groupTypeIcon(option),
              title: _groupTypeLabel(context, option),
              selected: _groupType == option,
              onTap: () => setState(() => _groupType = option),
            ),
          ),
        ];
      case 2:
        return [
          ...DrawSubgroupRule.values.map(
            (mode) => _ChoiceTile(
              icon: switch (mode) {
                DrawSubgroupRule.ignore => Icons.shuffle_outlined,
                DrawSubgroupRule.preferDifferent => Icons.compare_arrows_outlined,
                DrawSubgroupRule.requireDifferent => Icons.swap_horiz_outlined,
              },
              title: _ruleTitle(context, mode),
              subtitle: _ruleDescription(context, mode),
              selected: _drawRule == mode,
              onTap: () => setState(() => _drawRule = mode),
            ),
          ),
        ];
      case 3:
        return [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.warmIvory,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: AppTheme.mutedGold),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _drawRule == DrawSubgroupRule.ignore
                        ? context.l10n.wizardSubgroupsHelpIgnore
                        : context.l10n.wizardSubgroupsHelpEnabled,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ];
      case 4:
        return [
          Material(
            color: AppTheme.warmIvory,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                final initial = _eventDate ?? DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  locale: Localizations.localeOf(context),
                );
                if (picked != null && context.mounted) {
                  setState(
                    () => _eventDate = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                    ),
                  );
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.event_outlined, color: AppTheme.deepPlum),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.wizardSummaryEventDate,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _eventDate == null
                                ? context.l10n.wizardEventDateNotSet
                                : DateFormat.yMMMMd(
                                    Localizations.localeOf(context)
                                        .toString(),
                                  ).format(_eventDate!),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_eventDate != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _eventDate = null),
                icon: const Icon(Icons.clear, size: 18),
                label: Text(context.l10n.wizardEventDateClear),
              ),
            ),
          ],
        ];
      case 5:
        return [
          Text(
            context.l10n.raffleWizardOwnerParticipatesTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          RadioListTile<bool>(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.raffleWizardOwnerParticipatesYes),
            value: true,
            groupValue: _ownerParticipatesInSecretSanta,
            onChanged: (v) => setState(() => _ownerParticipatesInSecretSanta = v ?? true),
          ),
          RadioListTile<bool>(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.raffleWizardOwnerParticipatesNo),
            value: false,
            groupValue: _ownerParticipatesInSecretSanta,
            onChanged: (v) => setState(() => _ownerParticipatesInSecretSanta = v ?? false),
          ),
          if (!_ownerParticipatesInSecretSanta) ...[
            const SizedBox(height: 6),
            Text(
              context.l10n.wizardSecretSantaOrganizerOnlyHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
          if (_ownerParticipatesInSecretSanta) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _nickCtrl,
              decoration: InputDecoration(
                labelText: context.l10n.wizardNicknameLabel,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ];
      case 6:
        return [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            decoration: BoxDecoration(
              color: AppTheme.warmIvory,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                _summaryRow(
                  icon: Icons.bookmark_outline,
                  label: context.l10n.wizardSummaryName,
                  value: _nameCtrl.text.trim().isEmpty
                      ? '—'
                      : _nameCtrl.text.trim(),
                ),
                _SummaryDivider(theme: theme),
                _summaryRow(
                  icon: _groupTypeIcon(_groupType),
                  label: context.l10n.wizardSummaryGroupType,
                  value: _groupTypeLabel(context, _groupType),
                ),
                _SummaryDivider(theme: theme),
                _summaryRow(
                  icon: Icons.tune_outlined,
                  label: context.l10n.wizardSummaryRule,
                  value: _ruleTitle(context, _drawRule),
                ),
                _SummaryDivider(theme: theme),
                _summaryRow(
                  icon: Icons.how_to_reg_outlined,
                  label: context.l10n.raffleWizardOwnerParticipatesTitle,
                  value: _ownerParticipatesInSecretSanta
                      ? context.l10n.raffleWizardOwnerParticipatesYes
                      : context.l10n.raffleWizardOwnerParticipatesNo,
                ),
                _SummaryDivider(theme: theme),
                _summaryRow(
                  icon: Icons.event_outlined,
                  label: context.l10n.wizardSummaryEventDate,
                  value: _eventDate == null
                      ? context.l10n.wizardEventDateNotSet
                      : DateFormat.yMMMMd(
                          Localizations.localeOf(context).toString(),
                        ).format(_eventDate!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.wizardReviewSaveNotice,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ];
      default:
        return const [];
    }
  }

  Widget _summaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.deepPlum.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.deepPlum),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 42),
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (step + 1) / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.wizardStepOf(step + 1, total),
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected
            ? AppTheme.deepPlum.withValues(alpha: 0.08)
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
                    ? AppTheme.deepPlum.withValues(alpha: 0.45)
                    : theme.colorScheme.outlineVariant,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.deepPlum.withValues(alpha: 0.14)
                          : AppTheme.deepPlum.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppTheme.deepPlum, size: 20),
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
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off_outlined,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
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

class _GroupCreatedDialog extends StatelessWidget {
  const _GroupCreatedDialog({required this.groupName, required this.created});

  final String groupName;
  final CreatedGroup created;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Dialog(
      backgroundColor: AppTheme.softCream,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.brandHeroGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.celebration_outlined,
                      color: AppTheme.deepPlum,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.wizardCreatedTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          groupName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                l10n.wizardInviteCodeLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.secretCardGradient,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.deepPlum.withValues(alpha: 0.22),
                  ),
                  boxShadow: AppTheme.softElevatedShadow,
                ),
                child: SelectableText(
                  created.inviteCode,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    letterSpacing: 4,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.deepPlum,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.wizardInviteCodeDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(l10n.goToGroup),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: created.inviteCode),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.codeCopied)),
                    );
                  }
                },
                icon: const Icon(Icons.copy_outlined),
                label: Text(l10n.copyCode),
              ),
              const SizedBox(height: 6),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
