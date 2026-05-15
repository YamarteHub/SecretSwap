import '../../../l10n/app_localizations.dart';
import '../../groups/domain/group_models.dart';

/// Texto plano para compartir o correo (snapshot de equipos).
class TeamResultText {
  TeamResultText._();

  static String unitLabel(AppLocalizations l10n, int teamIndex) {
    return l10n.teamsUnitLabel(teamIndex + 1);
  }

  /// `true` si el label guardado es el fallback automático (p. ej. "Team 1").
  static bool isDefaultTeamLabel(String teamLabel, int teamIndex) {
    final t = teamLabel.trim();
    if (t.isEmpty) return true;
    final n = teamIndex + 1;
    if (t == 'Team $n') return true;
    final patterns = [
      RegExp(r'^Team\s+$n$', caseSensitive: false),
      RegExp(r'^Equipo\s+$n$', caseSensitive: false),
      RegExp(r'^Equipa\s+$n$', caseSensitive: false),
      RegExp(r'^Squadra\s+$n$', caseSensitive: false),
      RegExp(r'^Équipe\s+$n$', caseSensitive: false),
    ];
    return patterns.any((p) => p.hasMatch(t));
  }

  static String teamDisplayName(AppLocalizations l10n, TeamSnapshot team) {
    final custom = team.teamLabel.trim();
    if (custom.isNotEmpty && !isDefaultTeamLabel(custom, team.teamIndex)) {
      return custom;
    }
    return unitLabel(l10n, team.teamIndex);
  }

  static String memberLine(String name) => '• $name';

  static String buildShareBody({
    required AppLocalizations l10n,
    required String groupName,
    required List<TeamSnapshot> teams,
    required String Function(TeamMemberSnapshot member) displayNameFor,
  }) {
    final blocks = <String>[];
    for (final team in teams) {
      final label = teamDisplayName(l10n, team);
      final lines = team.members.map((m) => memberLine(displayNameFor(m))).join('\n');
      blocks.add('$label\n$lines');
    }
    return l10n.teamsShareBody(groupName, blocks.join('\n\n'));
  }

  static String buildEmailSubject(AppLocalizations l10n, String groupName) {
    return l10n.teamsEmailSubject(groupName);
  }

  static String buildEmailBody({
    required AppLocalizations l10n,
    required String groupName,
    required List<TeamSnapshot> teams,
    required String Function(TeamMemberSnapshot member) displayNameFor,
  }) {
    final blocks = <String>[];
    for (final team in teams) {
      final label = teamDisplayName(l10n, team);
      final lines = team.members.map((m) => '- ${displayNameFor(m)}').join('\n');
      blocks.add('$label\n$lines');
    }
    return l10n.teamsEmailBody(groupName, blocks.join('\n\n'));
  }
}
