import '../../../l10n/app_localizations.dart';
import '../../groups/domain/group_models.dart';

/// Textos de UI según preset de Equipos: estándar, Parejas o Duelos.
class TeamsUiCopy {
  const TeamsUiCopy(this._l10n, this.preset);

  final AppLocalizations _l10n;
  final TeamsPreset preset;

  bool get isPairings => preset == TeamsPreset.pairings;
  bool get isDuels => preset == TeamsPreset.duels;
  bool get isSizedPair => isPairings || isDuels;

  factory TeamsUiCopy.of(AppLocalizations l10n, TeamsPreset preset) =>
      TeamsUiCopy(l10n, preset);

  String get homeDynamicTypeLabel {
    if (isDuels) return _l10n.homeDynamicTypeDuels;
    if (isPairings) return _l10n.homeDynamicTypePairings;
    return _l10n.homeDynamicTypeTeams;
  }

  String get homeStateCompleted {
    if (isDuels) return _l10n.homeDuelsStateCompleted;
    if (isPairings) return _l10n.homePairingsStateCompleted;
    return _l10n.homeTeamsStateCompleted;
  }

  String get homeStatePreparing {
    if (isDuels) return _l10n.homeDuelsStatePreparing;
    if (isPairings) return _l10n.homePairingsStatePreparing;
    return _l10n.homeTeamsStatePreparing;
  }

  String unitLabel(int index) {
    final n = index + 1;
    if (isDuels) return _l10n.duelsUnitLabel(n);
    if (isPairings) return _l10n.pairingsUnitLabel(n);
    return _l10n.teamsUnitLabel(n);
  }

  String get resultHeroTitle {
    if (isDuels) return _l10n.duelsResultHeroTitle;
    if (isPairings) return _l10n.pairingsResultHeroTitle;
    return _l10n.teamsResultHeroTitle;
  }

  String get resultHeroSubtitle {
    if (isDuels) return _l10n.duelsResultHeroSubtitle;
    if (isPairings) return _l10n.pairingsResultHeroSubtitle;
    return _l10n.teamsResultHeroSubtitle;
  }

  String resultSummary(int count, int eligibleCount) {
    if (isDuels) return _l10n.duelsResultSummary(count, eligibleCount);
    if (isPairings) return _l10n.pairingsResultSummary(count, eligibleCount);
    return _l10n.teamsResultSummary(count, eligibleCount);
  }

  String get detailListTitle {
    if (isDuels) return _l10n.duelsDetailListTitle;
    if (isPairings) return _l10n.pairingsDetailListTitle;
    return _l10n.teamsDetailTeamsListTitle;
  }

  String get detailFormCta {
    if (isDuels) return _l10n.duelsDetailFormCta;
    if (isPairings) return _l10n.pairingsDetailFormCta;
    return _l10n.teamsDetailFormTeamsCta;
  }

  String get detailConfigTitle {
    if (isDuels) return _l10n.duelsDetailConfigTitle;
    if (isPairings) return _l10n.pairingsDetailConfigTitle;
    return _l10n.teamsDetailConfigTitle;
  }

  String detailConfigSummary(int count) {
    if (isDuels) return _l10n.duelsDetailConfigSummary(count);
    if (isPairings) return _l10n.pairingsDetailConfigSummary(count);
    return _l10n.teamsDetailEstimatedTeams(count);
  }

  String get renameDialogTitle {
    if (isDuels) return _l10n.duelsRenameDialogTitle;
    if (isPairings) return _l10n.pairingsRenameDialogTitle;
    return _l10n.teamsRenameDialogTitle;
  }

  String get renameDialogFieldLabel {
    if (isDuels) return _l10n.duelsRenameDialogFieldLabel;
    if (isPairings) return _l10n.pairingsRenameDialogFieldLabel;
    return _l10n.teamsRenameDialogFieldLabel;
  }

  String get renameSuccess {
    if (isDuels) return _l10n.duelsRenameSuccess;
    if (isPairings) return _l10n.pairingsRenameSuccess;
    return _l10n.teamsRenameSuccess;
  }

  String shareBody(String groupName, String blocks) {
    if (isDuels) return _l10n.duelsShareBody(groupName, blocks);
    if (isPairings) return _l10n.pairingsShareBody(groupName, blocks);
    return _l10n.teamsShareBody(groupName, blocks);
  }

  String emailSubject(String groupName) {
    if (isDuels) return _l10n.duelsEmailSubject(groupName);
    if (isPairings) return _l10n.pairingsEmailSubject(groupName);
    return _l10n.teamsEmailSubject(groupName);
  }

  String emailBody(String groupName, String blocks) {
    if (isDuels) return _l10n.duelsEmailBody(groupName, blocks);
    if (isPairings) return _l10n.pairingsEmailBody(groupName, blocks);
    return _l10n.teamsEmailBody(groupName, blocks);
  }

  String get pdfHeadline {
    if (isDuels) return _l10n.duelsPdfHeadline;
    if (isPairings) return _l10n.pairingsPdfHeadline;
    return _l10n.teamsPdfHeadline;
  }

  String get pdfFooter => _l10n.teamsPdfFooter;

  String get chatSectionTitle {
    if (isDuels) return _l10n.duelsChatSectionTitle;
    if (isPairings) return _l10n.pairingsChatSectionTitle;
    return _l10n.teamsChatSectionTitle;
  }

  String get chatSectionSubtitle {
    if (isDuels) return _l10n.duelsChatSectionSubtitle;
    if (isPairings) return _l10n.pairingsChatSectionSubtitle;
    return _l10n.teamsChatSectionSubtitle;
  }

  String get chatEnterCta {
    if (isDuels) return _l10n.duelsChatEnterCta;
    if (isPairings) return _l10n.pairingsChatEnterCta;
    return _l10n.teamsChatEnterCta;
  }

  String get chatCompletedChip {
    if (isDuels) return _l10n.chatDuelsCompletedChip;
    if (isPairings) return _l10n.chatPairingsCompletedChip;
    return _l10n.chatTeamsCompletedChip;
  }

  String get chatSystemCompletedKey {
    if (isDuels) return 'chat.system.duelsCompleted.v1';
    if (isPairings) return 'chat.system.pairingsCompleted.v1';
    return 'chat.system.teamsCompleted.v1';
  }

  String get memberWaitingTitle {
    if (isDuels) return _l10n.duelsMemberWaitingTitle;
    if (isPairings) return _l10n.pairingsMemberWaitingTitle;
    return _l10n.teamsMemberWaitingTitle;
  }

  String get memberWaitingBody {
    if (isDuels) return _l10n.duelsMemberWaitingBody;
    if (isPairings) return _l10n.pairingsMemberWaitingBody;
    return _l10n.teamsMemberWaitingBody;
  }

  String? get detailMinPoolHint {
    if (isDuels) return _l10n.duelsDetailMinPoolHint;
    if (isPairings) return null;
    return _l10n.teamsDetailMinPoolHint;
  }

  String? get detailEvenHint {
    if (isDuels) return _l10n.duelsDetailEvenHint;
    if (isPairings) return _l10n.pairingsDetailEvenHint;
    return null;
  }

  String get vsLabel => _l10n.duelsVsLabel;

  String joinSuccessSubtitle(String name) {
    if (isDuels) return _l10n.joinSuccessDuelsSubtitle(name);
    if (isPairings) return _l10n.joinSuccessPairingsSubtitle(name);
    return _l10n.joinSuccessTeamsSubtitle(name);
  }

  String get joinSuccessBody {
    if (isDuels) return _l10n.joinSuccessDuelsBody;
    if (isPairings) return _l10n.joinSuccessPairingsBody;
    return _l10n.joinSuccessTeamsBody;
  }

  String get joinSuccessPrimaryCta {
    if (isDuels) return _l10n.joinSuccessDuelsPrimaryCta;
    if (isPairings) return _l10n.joinSuccessPairingsPrimaryCta;
    return _l10n.joinSuccessTeamsPrimaryCta;
  }
}
