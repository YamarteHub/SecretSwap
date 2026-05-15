import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/firebase/firebase_emulator_config.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../domain/group_models.dart';
import '../../../teams/presentation/teams_ui_copy.dart';
import '../../../notifications/presentation/providers.dart';
import '../../../notifications/presentation/widgets/push_activation_card.dart';
import '../providers.dart';

bool _isEventCalendarDateBeforeToday(DateTime eventDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final e = DateTime(eventDate.year, eventDate.month, eventDate.day);
  return e.isBefore(today);
}

/// Historial: dinámica completada, `eventDate` definida y ya pasada (solo día civil local).
bool _isHistoryFinishedByEventDate(GroupSummary g) {
  final completed = switch (g.dynamicType) {
    TarciDynamicType.simpleRaffle => g.raffleStatus == RaffleStatus.completed,
    TarciDynamicType.teams => g.teamStatus == TeamStatus.completed,
    TarciDynamicType.secretSanta => g.drawStatus == DrawStatus.completed,
  };
  return completed &&
      g.eventDate != null &&
      _isEventCalendarDateBeforeToday(g.eventDate!);
}

bool _isDashboardFlowCompleted(GroupSummary g) {
  return switch (g.dynamicType) {
    TarciDynamicType.simpleRaffle => g.raffleStatus == RaffleStatus.completed,
    TarciDynamicType.teams => g.teamStatus == TeamStatus.completed,
    TarciDynamicType.secretSanta => g.drawStatus == DrawStatus.completed,
  };
}

String? _formatGroupDeliveryDateLine(BuildContext context, GroupSummary g) {
  if (g.eventDate == null) return null;
  final loc = Localizations.localeOf(context).toString();
  final formatted = DateFormat.yMMMMd(loc).format(g.eventDate!);
  return context.l10n.homeDeliveryDateLine(formatted);
}

int _compareActiveDashboardGroups(GroupSummary a, GroupSummary b) {
  final ac = _isDashboardFlowCompleted(a);
  final bc = _isDashboardFlowCompleted(b);
  if (ac != bc) return ac ? 1 : -1;
  if (!ac) return a.name.compareTo(b.name);
  final ae = a.eventDate;
  final be = b.eventDate;
  if (ae != null && be != null) {
    final byEv = ae.compareTo(be);
    if (byEv != 0) return byEv;
  } else if (ae != null) {
    return -1;
  } else if (be != null) {
    return 1;
  }
  return a.name.compareTo(b.name);
}

int _compareHistoryDashboardGroups(GroupSummary a, GroupSummary b) {
  final ae = a.eventDate;
  final be = b.eventDate;
  if (ae != null && be != null) {
    final byEv = be.compareTo(ae);
    if (byEv != 0) return byEv;
  }
  return a.name.compareTo(b.name);
}

String _homeDynamicStatusChipLabel(BuildContext context, GroupSummary g) {
  if (g.dynamicType == TarciDynamicType.simpleRaffle) {
    switch (g.raffleStatus) {
      case RaffleStatus.completed:
        return context.l10n.homeRaffleStateCompleted;
      case RaffleStatus.drawing:
        return context.l10n.homeGroupDrawStateDrawing;
      case RaffleStatus.failed:
        return context.l10n.homeGroupDrawStateFailed;
      case RaffleStatus.idle:
        return context.l10n.homeRaffleStatePreparing;
    }
  }
  if (g.dynamicType == TarciDynamicType.teams) {
    final ui = TeamsUiCopy.of(context.l10n, g.teamsPreset);
    switch (g.teamStatus) {
      case TeamStatus.completed:
        return ui.homeStateCompleted;
      case TeamStatus.generating:
        return context.l10n.homeGroupDrawStateDrawing;
      case TeamStatus.failed:
        return context.l10n.homeGroupDrawStateFailed;
      case TeamStatus.idle:
        return ui.homeStatePreparing;
    }
  }
  return _homeDrawStatusChipLabel(context, g.drawStatus);
}

IconData _homeDynamicStatusChipIcon(GroupSummary g) {
  if (g.dynamicType == TarciDynamicType.simpleRaffle) {
    switch (g.raffleStatus) {
      case RaffleStatus.completed:
        return Icons.check_circle_outline;
      case RaffleStatus.drawing:
        return Icons.hourglass_top_rounded;
      case RaffleStatus.failed:
        return Icons.warning_amber_rounded;
      case RaffleStatus.idle:
        return Icons.tune_rounded;
    }
  }
  if (g.dynamicType == TarciDynamicType.teams) {
    switch (g.teamStatus) {
      case TeamStatus.completed:
        return Icons.check_circle_outline;
      case TeamStatus.generating:
        return Icons.hourglass_top_rounded;
      case TeamStatus.failed:
        return Icons.warning_amber_rounded;
      case TeamStatus.idle:
        return Icons.tune_rounded;
    }
  }
  if (g.drawStatus == DrawStatus.completed) return Icons.check_circle_outline;
  if (g.drawStatus == DrawStatus.drawing) return Icons.hourglass_top_rounded;
  if (g.drawStatus == DrawStatus.failed) return Icons.warning_amber_rounded;
  return Icons.tune_rounded;
}

Color _homeDynamicStatusChipColor(GroupSummary g) {
  if (g.dynamicType == TarciDynamicType.simpleRaffle) {
    switch (g.raffleStatus) {
      case RaffleStatus.completed:
        return AppTheme.sageGreen;
      case RaffleStatus.drawing:
        return AppTheme.mutedGold;
      case RaffleStatus.failed:
        return AppTheme.softTerracotta;
      case RaffleStatus.idle:
        return AppTheme.deepPlumAlt;
    }
  }
  if (g.dynamicType == TarciDynamicType.teams) {
    switch (g.teamStatus) {
      case TeamStatus.completed:
        return AppTheme.sageGreen;
      case TeamStatus.generating:
        return AppTheme.mutedGold;
      case TeamStatus.failed:
        return AppTheme.softTerracotta;
      case TeamStatus.idle:
        return AppTheme.deepPlumAlt;
    }
  }
  if (g.drawStatus == DrawStatus.completed) return AppTheme.sageGreen;
  if (g.drawStatus == DrawStatus.drawing) return AppTheme.mutedGold;
  if (g.drawStatus == DrawStatus.failed) return AppTheme.softTerracotta;
  return AppTheme.deepPlumAlt;
}

String _homeDrawStatusChipLabel(BuildContext context, DrawStatus status) {
  final l10n = context.l10n;
  switch (status) {
    case DrawStatus.idle:
      return l10n.homeGroupDrawStatePreparing;
    case DrawStatus.drawing:
      return l10n.homeGroupDrawStateDrawing;
    case DrawStatus.completed:
      return l10n.homeGroupDrawStateCompleted;
    case DrawStatus.failed:
      return l10n.homeGroupDrawStateFailed;
  }
}

class GroupsHomeScreen extends ConsumerStatefulWidget {
  const GroupsHomeScreen({super.key});

  @override
  ConsumerState<GroupsHomeScreen> createState() => _GroupsHomeScreenState();
}

class _GroupsHomeScreenState extends ConsumerState<GroupsHomeScreen> {
  bool _debugUnlocked = false;

  Future<void> _syncPushLocale(String languageCode) async {
    await ref
        .read(pushNotificationsServiceProvider)
        .syncPreferredLocale(languageCode);
  }

  Future<void> _selectLocale(Locale? locale) async {
    final notifier = ref.read(localeControllerProvider.notifier);
    if (locale == null) {
      await notifier.useSystemLocale();
      final device = WidgetsBinding.instance.platformDispatcher.locale;
      await _syncPushLocale(device.languageCode);
    } else {
      await notifier.setLocale(locale);
      await _syncPushLocale(locale.languageCode);
    }
  }

  String _shortUid(String? uid) {
    if (uid == null || uid.isEmpty) return '—';
    if (uid.length <= 6) return uid;
    return '${uid.substring(0, 6)}...';
  }

  Future<void> _openLanguageSelector(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Consumer(
              builder: (innerContext, innerRef, _) {
                final current = innerRef.watch(localeControllerProvider);
                final l10n = innerContext.l10n;
                final theme = Theme.of(innerContext);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.languageSelectorTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.languageSelectorSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _LangRadio(
                      label: l10n.languageSystem,
                      selected:
                          (current?.languageCode ?? 'system') == 'system',
                      onTap: () => _selectLocale(null),
                    ),
                    _LangRadio(
                      label: 'Español',
                      selected: current?.languageCode == 'es',
                      onTap: () => _selectLocale(const Locale('es')),
                    ),
                    _LangRadio(
                      label: 'English',
                      selected: current?.languageCode == 'en',
                      onTap: () => _selectLocale(const Locale('en')),
                    ),
                    _LangRadio(
                      label: 'Português',
                      selected: current?.languageCode == 'pt',
                      onTap: () => _selectLocale(const Locale('pt')),
                    ),
                    _LangRadio(
                      label: 'Italiano',
                      selected: current?.languageCode == 'it',
                      onTap: () => _selectLocale(const Locale('it')),
                    ),
                    _LangRadio(
                      label: 'Français',
                      selected: current?.languageCode == 'fr',
                      onTap: () => _selectLocale(const Locale('fr')),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _toggleDebugTools(BuildContext context) {
    if (!kDebugMode) return;
    HapticFeedback.selectionClick();
    setState(() => _debugUnlocked = !_debugUnlocked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _debugUnlocked
              ? context.l10n.homeDebugToolsTitle
              : context.l10n.close,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(myGroupsProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final shortUid = _shortUid(uid);
    final environmentLabel = FirebaseEmulatorConfig.shouldUseEmulators
        ? context.l10n.homeEnvironmentEmulator
        : context.l10n.homeEnvironmentFirebase;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: null,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: context.l10n.aboutTooltip,
            onPressed: () => context.push(AppRoutes.about),
            icon: const Icon(Icons.info_outline_rounded),
          ),
          IconButton(
            tooltip: context.l10n.languageSelectorTitle,
            onPressed: () => _openLanguageSelector(context, ref),
            icon: const Icon(Icons.language_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          final activeMembership =
              groups.where((g) => g.isActiveMember).toList();
          final activeBucket = activeMembership
              .where((g) => !_isHistoryFinishedByEventDate(g))
              .toList()
            ..sort(_compareActiveDashboardGroups);
          final historyFinished = activeMembership
              .where(_isHistoryFinishedByEventDate)
              .toList()
            ..sort(_compareHistoryDashboardGroups);
          final pastMembership = groups.where((g) => !g.isActiveMember).toList()
            ..sort((a, b) => a.name.compareTo(b.name));

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myGroupsProvider);
              await ref.read(myGroupsProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                BrandHero(
                  headline: context.l10n.homeHeroHeadline,
                  tagline: context.l10n.homeHeaderSubtitle,
                  onSecretLongPress: () => _toggleDebugTools(context),
                ),
                ref.watch(pushActivationVisibleProvider).when(
                  data: (visible) {
                    if (!visible) return const SizedBox.shrink();
                    return const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: PushActivationCard(),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                Text(
                  context.l10n.homePrimaryActionsTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 10),
                _HomePrimaryActions(
                  onCreate: () async {
                    await context.push(AppRoutes.dynamicsSelect);
                    if (context.mounted) {
                      ref.invalidate(myGroupsProvider);
                    }
                  },
                  onJoin: () async {
                    await context.push(AppRoutes.joinByCode);
                    if (context.mounted) {
                      ref.invalidate(myGroupsProvider);
                    }
                  },
                ),
                const SizedBox(height: 22),
                if (groups.isEmpty)
                  EmptyState(
                    icon: Icons.card_giftcard_outlined,
                    title: context.l10n.homeEmptyGroupsTitle,
                    message: context.l10n.homeEmptyGroupsMessage,
                  )
                else ...[
                  Text(
                    context.l10n.homeActiveGroupsTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.homeActiveGroupsSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (activeBucket.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        context.l10n.homeActiveGroupsEmpty,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                          height: 1.35,
                        ),
                      ),
                    )
                  else
                    ...activeBucket.map(
                      (g) => _GroupCard(
                        summary: g,
                        eventDateLine: _formatGroupDeliveryDateLine(context, g),
                        onTap: () => context.push('/groups/${g.groupId}'),
                      ),
                    ),
                ],
                if (historyFinished.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Text(
                    context.l10n.homeCompletedGroupsTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.homeCompletedGroupsSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...historyFinished.map(
                    (g) => _GroupCard(
                      summary: g,
                      completed: true,
                      eventDateLine: _formatGroupDeliveryDateLine(context, g),
                      onTap: () => context.push('/groups/${g.groupId}'),
                    ),
                  ),
                ],
                if (pastMembership.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  Text(
                    context.l10n.homePastGroupsTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.homePastGroupsSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...pastMembership.map(
                    (g) => _GroupCard(
                      summary: g,
                      completed: true,
                      eventDateLine: _formatGroupDeliveryDateLine(context, g),
                      onTap: () => context.push('/groups/${g.groupId}'),
                    ),
                  ),
                ],
                if (kDebugMode && _debugUnlocked) ...[
                  const SizedBox(height: 24),
                  _DebugToolsCard(
                    shortUid: shortUid,
                    environmentLabel: environmentLabel,
                    onResetUser: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) context.go(AppRoutes.splash);
                    },
                  ),
                ],
                const SizedBox(height: 22),
                Text(
                  context.l10n.homePrivacyFooter,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(userVisibleErrorMessage(e, context.l10n)),
        ),
      ),
    );
  }
}

class _HomePrimaryActions extends StatelessWidget {
  const _HomePrimaryActions({required this.onCreate, required this.onJoin});

  final VoidCallback onCreate;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            textStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          onPressed: onCreate,
          icon: const Icon(Icons.auto_awesome_rounded),
          label: Text(l10n.dynamicsHomePrimaryCta),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
          onPressed: onJoin,
          icon: const Icon(Icons.vpn_key_outlined),
          label: Text(l10n.joinWithCode),
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.summary,
    required this.onTap,
    this.completed = false,
    this.eventDateLine,
  });

  final GroupSummary summary;
  final VoidCallback onTap;
  final bool completed;
  final String? eventDateLine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final groupName = summary.name.isEmpty ? summary.groupId : summary.name;
    final isOwner = summary.role == MemberRole.owner;
    final accent = completed
        ? theme.colorScheme.onSurfaceVariant
        : (isOwner ? AppTheme.mutedGold : AppTheme.deepPlum);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: AppTheme.softCream,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: AppTheme.softCream,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: completed
                    ? theme.colorScheme.outlineVariant
                    : AppTheme.deepPlum.withValues(alpha: 0.10),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 22,
                  spreadRadius: -10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
              child: Row(
                children: [
                  _GroupAvatar(
                    name: groupName,
                    accent: accent,
                    completed: completed,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.1,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            if (!completed) ...[
                              _SoftChip(
                                label: switch (summary.dynamicType) {
                                  TarciDynamicType.simpleRaffle =>
                                    l10n.homeDynamicTypeRaffle,
                                  TarciDynamicType.teams => TeamsUiCopy.of(
                                        l10n,
                                        summary.teamsPreset,
                                      ).homeDynamicTypeLabel,
                                  TarciDynamicType.secretSanta =>
                                    l10n.homeDynamicTypeSecretSanta,
                                },
                                icon: switch (summary.dynamicType) {
                                  TarciDynamicType.simpleRaffle =>
                                    Icons.casino_outlined,
                                  TarciDynamicType.teams =>
                                    summary.teamsPreset == TeamsPreset.pairings
                                        ? Icons.people_alt_outlined
                                        : Icons.groups_outlined,
                                  TarciDynamicType.secretSanta =>
                                    Icons.card_giftcard_outlined,
                                },
                                color: AppTheme.deepPlumAlt,
                              ),
                              _SoftChip(
                                label: _homeDynamicStatusChipLabel(context, summary),
                                icon: _homeDynamicStatusChipIcon(summary),
                                color: _homeDynamicStatusChipColor(summary),
                              ),
                            ],
                            _SoftChip(
                              label: isOwner
                                  ? l10n.groupRoleAdmin
                                  : l10n.groupRoleMember,
                              icon: isOwner
                                  ? Icons.workspace_premium_outlined
                                  : Icons.person_outline,
                              color: isOwner
                                  ? AppTheme.mutedGold
                                  : AppTheme.deepPlumAlt,
                            ),
                            if (completed)
                              _SoftChip(
                                label: l10n.homeCompletedArchivedLabel,
                                icon: Icons.check_circle_outline,
                                color: theme.colorScheme.onSurfaceVariant,
                              )
                            else
                              _SoftChip(
                                label: summary.isActiveMember
                                    ? l10n.homeStatusActive
                                    : l10n.homeStatusInactive,
                                icon: summary.isActiveMember
                                    ? Icons.fiber_manual_record
                                    : Icons.pause_circle_outline,
                                color: summary.isActiveMember
                                    ? AppTheme.sageGreen
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                          ],
                        ),
                        if (eventDateLine != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.event_outlined,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  eventDateLine!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
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

class _GroupAvatar extends StatelessWidget {
  const _GroupAvatar({
    required this.name,
    required this.accent,
    required this.completed,
  });

  final String name;
  final Color accent;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = name.trim().isEmpty
        ? '·'
        : name.trim().characters.first.toUpperCase();
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.brandHeroGradient,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppTheme.softCream,
              shape: BoxShape.circle,
              border: Border.all(
                color: accent.withValues(alpha: completed ? 0.20 : 0.32),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: theme.textTheme.titleMedium?.copyWith(
                color: completed
                    ? theme.colorScheme.onSurfaceVariant
                    : AppTheme.deepPlum,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _LangRadio extends StatelessWidget {
  const _LangRadio({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
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
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DebugToolsCard extends StatelessWidget {
  const _DebugToolsCard({
    required this.shortUid,
    required this.environmentLabel,
    required this.onResetUser,
  });

  final String shortUid;
  final String environmentLabel;
  final VoidCallback onResetUser;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report_outlined,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.homeDebugToolsTitle,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.homeDebugUid(shortUid),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            environmentLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.homeDebugUserSwitchHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onResetUser,
            icon: const Icon(Icons.refresh, size: 20),
            label: Text(l10n.homeDebugResetUser),
          ),
        ],
      ),
    );
  }
}
