import '../../../l10n/app_localizations.dart';
import '../../groups/domain/group_models.dart';
import '../presentation/teams_ui_copy.dart';

/// Texto plano para compartir o correo (snapshot de equipos).
class TeamResultText {
  TeamResultText._();

  static String unitLabel(
    AppLocalizations l10n,
    int teamIndex, {
    TeamsPreset preset = TeamsPreset.standard,
  }) {
    return TeamsUiCopy.of(l10n, preset).unitLabel(teamIndex);
  }

  /// `true` si el label guardado es el fallback automático (p. ej. "Team 1").
  static bool isDefaultTeamLabel(
    String teamLabel,
    int teamIndex, {
    TeamsPreset preset = TeamsPreset.standard,
  }) {
    final t = teamLabel.trim();
    if (t.isEmpty) return true;
    final n = teamIndex + 1;
    if (t == 'Team $n') return true;
    final patterns = preset == TeamsPreset.duels
        ? [
            RegExp(r'^Duel\s+$n$', caseSensitive: false),
            RegExp(r'^Duelo\s+$n$', caseSensitive: false),
            RegExp(r'^Duelo\s+$n$', caseSensitive: false),
            RegExp(r'^Duello\s+$n$', caseSensitive: false),
            RegExp(r'^Duel\s+$n$', caseSensitive: false),
          ]
        : preset == TeamsPreset.pairings
        ? [
            RegExp(r'^Pair\s+$n$', caseSensitive: false),
            RegExp(r'^Pareja\s+$n$', caseSensitive: false),
            RegExp(r'^Coppia\s+$n$', caseSensitive: false),
            RegExp(r'^Paire\s+$n$', caseSensitive: false),
          ]
        : [
            RegExp(r'^Team\s+$n$', caseSensitive: false),
            RegExp(r'^Equipo\s+$n$', caseSensitive: false),
            RegExp(r'^Equipa\s+$n$', caseSensitive: false),
            RegExp(r'^Squadra\s+$n$', caseSensitive: false),
            RegExp(r'^Équipe\s+$n$', caseSensitive: false),
          ];
    return patterns.any((p) => p.hasMatch(t));
  }

  static String teamDisplayName(
    AppLocalizations l10n,
    TeamSnapshot team, {
    TeamsPreset preset = TeamsPreset.standard,
  }) {
    final custom = team.teamLabel.trim();
    if (custom.isNotEmpty && !isDefaultTeamLabel(custom, team.teamIndex, preset: preset)) {
      return custom;
    }
    return unitLabel(l10n, team.teamIndex, preset: preset);
  }

  static String memberLine(String name) => '• $name';

  static String _duelsMatchLine(
    AppLocalizations l10n,
    TeamSnapshot team,
    String Function(TeamMemberSnapshot member) displayNameFor, {
    required TeamsPreset preset,
  }) {
    final label = teamDisplayName(l10n, team, preset: preset);
    final names = team.members.map(displayNameFor).toList();
    final left = names.isNotEmpty ? names[0] : '—';
    final right = names.length > 1 ? names[1] : '—';
    return '$label\n$left ${l10n.duelsVsLabel} $right';
  }

  static String buildShareBody({
    required AppLocalizations l10n,
    required String groupName,
    required List<TeamSnapshot> teams,
    required String Function(TeamMemberSnapshot member) displayNameFor,
    TeamsPreset preset = TeamsPreset.standard,
  }) {
    final ui = TeamsUiCopy.of(l10n, preset);
    if (preset == TeamsPreset.duels) {
      final blocks = teams
          .map((t) => _duelsMatchLine(l10n, t, displayNameFor, preset: preset))
          .join('\n\n');
      return ui.shareBody(groupName, blocks);
    }
    final blocks = <String>[];
    for (final team in teams) {
      final label = teamDisplayName(l10n, team, preset: preset);
      final lines = team.members.map((m) => memberLine(displayNameFor(m))).join('\n');
      blocks.add('$label\n$lines');
    }
    return ui.shareBody(groupName, blocks.join('\n\n'));
  }

  static String buildEmailSubject(
    AppLocalizations l10n,
    String groupName, {
    TeamsPreset preset = TeamsPreset.standard,
  }) {
    return TeamsUiCopy.of(l10n, preset).emailSubject(groupName);
  }

  static String buildEmailBody({
    required AppLocalizations l10n,
    required String groupName,
    required List<TeamSnapshot> teams,
    required String Function(TeamMemberSnapshot member) displayNameFor,
    TeamsPreset preset = TeamsPreset.standard,
  }) {
    final ui = TeamsUiCopy.of(l10n, preset);
    if (preset == TeamsPreset.duels) {
      final blocks = teams
          .map((t) => _duelsMatchLine(l10n, t, displayNameFor, preset: preset))
          .join('\n\n');
      return ui.emailBody(groupName, blocks);
    }
    final blocks = <String>[];
    for (final team in teams) {
      final label = teamDisplayName(l10n, team, preset: preset);
      final lines = team.members.map((m) => '- ${displayNameFor(m)}').join('\n');
      blocks.add('$label\n$lines');
    }
    return ui.emailBody(groupName, blocks.join('\n\n'));
  }
}
