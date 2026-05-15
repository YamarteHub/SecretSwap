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
import '../../../groups/presentation/providers.dart';

/// Wizard propio para crear un grupo de tipo sorteo (`simple_raffle`).
class CreateRaffleWizardScreen extends ConsumerStatefulWidget {
  const CreateRaffleWizardScreen({super.key});

  @override
  ConsumerState<CreateRaffleWizardScreen> createState() => _CreateRaffleWizardScreenState();
}

class _CreateRaffleWizardScreenState extends ConsumerState<CreateRaffleWizardScreen> {
  final _pageController = PageController();
  int _page = 0;

  final _nameCtrl = TextEditingController();
  final _nickCtrl = TextEditingController();
  int _winnerCount = 1;
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
    return l10n.raffleOwnerParticipantFallback;
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
      final created = await repo.createRaffleGroup(
        name: name,
        nickname: _ownerNicknameForCreate(l10n),
        raffleWinnerCount: _winnerCount,
        ownerParticipatesInRaffle: _ownerParticipates,
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.raffleWizardTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: List.generate(4, (i) {
                final on = i <= _page;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: on ? AppTheme.deepPlum : theme.colorScheme.outlineVariant,
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
                _stepWinners(theme, l10n),
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
                      onPressed: _page < 3
                          ? () {
                              if (_page == 0) {
                                if (_nameCtrl.text.trim().isEmpty) {
                                  HapticFeedback.lightImpact();
                                  return;
                                }
                                if (_ownerParticipates &&
                                    _nickCtrl.text.trim().length < 3) {
                                  HapticFeedback.lightImpact();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.joinScreenNicknameTooShort),
                                    ),
                                  );
                                  return;
                                }
                              }
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutCubic,
                              );
                              setState(() => _page++);
                            }
                          : _submit,
                      child: Text(
                        _page < 3 ? l10n.next : l10n.raffleWizardCreateCta,
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
            l10n.raffleWizardNameLabel,
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
            l10n.raffleWizardOwnerNicknameLabel,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nickCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.softCream,
              helperText: l10n.raffleWizardOwnerNicknameHelper,
              helperMaxLines: 3,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.raffleWizardEventOptional,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickEventDate,
            icon: const Icon(Icons.event_outlined),
            label: Text(
              _eventDate == null
                  ? l10n.raffleWizardPickEventDate
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

  Widget _stepWinners(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.raffleWizardWinnersLabel,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: _winnerCount > 1 ? () => setState(() => _winnerCount--) : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              const SizedBox(width: 12),
              Text(
                '$_winnerCount',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: _winnerCount < 50 ? () => setState(() => _winnerCount++) : null,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
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
            l10n.raffleWizardOwnerParticipatesTitle,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          RadioListTile<bool>(
            title: Text(l10n.raffleWizardOwnerParticipatesYes),
            value: true,
            groupValue: _ownerParticipates,
            onChanged: (v) => setState(() => _ownerParticipates = v ?? true),
          ),
          RadioListTile<bool>(
            title: Text(l10n.raffleWizardOwnerParticipatesNo),
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
            l10n.raffleWizardReviewTitle,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(_nameCtrl.text.trim(), style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(l10n.raffleWizardReviewWinners(_winnerCount)),
          if (_eventDate != null) ...[
            const SizedBox(height: 8),
            Text(DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_eventDate!)),
          ],
        ],
      ),
    );
  }
}
