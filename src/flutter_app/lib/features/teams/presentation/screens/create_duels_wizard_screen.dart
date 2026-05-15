import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../groups/domain/group_models.dart';
import '../../../groups/presentation/providers.dart';

/// Wizard de creación de Duelos (`teamsPreset: duels`, enfrentamientos 1 vs 1).
class CreateDuelsWizardScreen extends ConsumerStatefulWidget {
  const CreateDuelsWizardScreen({super.key});

  @override
  ConsumerState<CreateDuelsWizardScreen> createState() => _CreateDuelsWizardScreenState();
}

class _CreateDuelsWizardScreenState extends ConsumerState<CreateDuelsWizardScreen> {
  final _pageController = PageController();
  int _page = 0;

  final _nameCtrl = TextEditingController();
  final _nickCtrl = TextEditingController();
  bool _ownerParticipates = true;
  DateTime? _eventDate;

  @override
  void initState() {
    super.initState();
    final u = FirebaseAuth.instance.currentUser;
    final d = u?.displayName?.trim();
    if (d != null && d.isNotEmpty) {
      _nickCtrl.text = d;
    } else {
      final e = u?.email?.trim();
      if (e != null && e.isNotEmpty) {
        _nickCtrl.text = e.split('@').first;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _nickCtrl.dispose();
    super.dispose();
  }

  String _ownerNicknameForCreate(AppLocalizations l10n) {
    final nick = _nickCtrl.text.trim();
    if (nick.isNotEmpty) return nick;
    return l10n.teamsOwnerParticipantFallback;
  }

  Future<void> _pickEventDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _eventDate = picked);
    }
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    if (_ownerParticipates && _nickCtrl.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.joinScreenNicknameTooShort)),
      );
      return;
    }
    final repo = ref.read(groupsRepositoryProvider);
    try {
      final created = await repo.createTeamsGroup(
        name: name,
        nickname: _ownerNicknameForCreate(l10n),
        groupingMode: TeamGroupingMode.teamSize,
        requestedTeamSize: 2,
        ownerParticipatesInTeams: _ownerParticipates,
        teamsPreset: TeamsPreset.duels,
        eventDate: _eventDate,
      );
      if (!mounted) return;
      ref.invalidate(myGroupsProvider);
      context.go(
        AppRoutes.groupDetailFor(created.groupId),
        extra: GroupDetailRouteExtra(inviteCode: created.inviteCode),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userVisibleActionErrorMessage(e, context.l10n))),
      );
    }
  }

  bool _validateStep(int page) {
    final l10n = context.l10n;
    if (page == 0) {
      if (_nameCtrl.text.trim().isEmpty) return false;
      if (_ownerParticipates && _nickCtrl.text.trim().length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.joinScreenNicknameTooShort)),
        );
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    const totalSteps = 3;
    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.duelsWizardTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: List.generate(totalSteps, (i) {
                final on = i <= _page;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: on ? AppTheme.softTerracotta : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _stepName(context, theme, l10n),
                _stepOwnerParticipation(theme, l10n),
                _stepReview(context, theme, l10n),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: _page > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutCubic,
                              );
                              setState(() => _page--);
                            }
                          : null,
                      child: Text(l10n.back),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: FilledButton(
                      onPressed: _page < totalSteps - 1
                          ? () {
                              if (!_validateStep(_page)) {
                                HapticFeedback.lightImpact();
                                return;
                              }
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutCubic,
                              );
                              setState(() => _page++);
                            }
                          : _submit,
                      child: Text(
                        _page < totalSteps - 1 ? l10n.next : l10n.duelsWizardCreateCta,
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

  Widget _stepName(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.duelsWizardNameLabel,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.softCream,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.duelsWizardOwnerNicknameLabel,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nickCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.softCream,
              helperText: l10n.duelsWizardOwnerNicknameHelper,
              helperMaxLines: 3,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.duelsWizardEventOptional,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickEventDate,
            icon: const Icon(Icons.event_outlined),
            label: Text(
              _eventDate == null
                  ? l10n.duelsWizardPickEventDate
                  : DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_eventDate!),
            ),
          ),
          if (_eventDate != null)
            TextButton(
              onPressed: () => setState(() => _eventDate = null),
              child: Text(l10n.close),
            ),
        ],
      ),
    );
  }

  Widget _stepOwnerParticipation(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.duelsWizardOwnerParticipatesTitle,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          RadioListTile<bool>(
            title: Text(l10n.duelsWizardOwnerParticipatesYes),
            value: true,
            groupValue: _ownerParticipates,
            onChanged: (v) => setState(() => _ownerParticipates = v ?? true),
          ),
          RadioListTile<bool>(
            title: Text(l10n.duelsWizardOwnerParticipatesNo),
            value: false,
            groupValue: _ownerParticipates,
            onChanged: (v) => setState(() => _ownerParticipates = v ?? false),
          ),
        ],
      ),
    );
  }

  Widget _stepReview(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.duelsWizardReviewTitle,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(_nameCtrl.text.trim(), style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(l10n.duelsWizardReviewSummary),
          if (_eventDate != null) ...[
            const SizedBox(height: 8),
            Text(DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_eventDate!)),
          ],
        ],
      ),
    );
  }
}
