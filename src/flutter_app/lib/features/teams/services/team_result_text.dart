import '../../../l10n/app_localizations.dart';
import '../../groups/domain/group_models.dart';

/// Texto plano para compartir o correo (snapshot de equipos).
class TeamResultText {
  TeamResultText._();

  static String unitLabel(AppLocalizations l10n, int teamIndex) {
    return l10n.teamsUnitLabel(teamIndex + 1);
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
      final label = unitLabel(l10n, team.teamIndex);
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
      final label = unitLabel(l10n, team.teamIndex);
      final lines = team.members.map((m) => '- ${displayNameFor(m)}').join('\n');
      blocks.add('$label\n$lines');
    }
    return l10n.teamsEmailBody(groupName, blocks.join('\n\n'));
  }
}
