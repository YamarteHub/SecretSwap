import '../../../l10n/app_localizations.dart';
import '../../groups/domain/group_models.dart';

/// Textos de UI según modalidad Equipos estándar o Parejas (`teamsPreset`).
class TeamsUiCopy {
  const TeamsUiCopy(this._l10n, this.preset);

  final AppLocalizations _l10n;
  final TeamsPreset preset;

  bool get isPairings => preset == TeamsPreset.pairings;

  factory TeamsUiCopy.of(AppLocalizations l10n, TeamsPreset preset) =>
      TeamsUiCopy(l10n, preset);

  String get homeDynamicTypeLabel =>
      isPairings ? _l10n.homeDynamicTypePairings : _l10n.homeDynamicTypeTeams;

  String get homeStateCompleted =>
      isPairings ? _l10n.homePairingsStateCompleted : _l10n.homeTeamsStateCompleted;

  String get homeStatePreparing =>
      isPairings ? _l10n.homePairingsStatePreparing : _l10n.homeTeamsStatePreparing;

  String unitLabel(int index) =>
      isPairings ? _l10n.pairingsUnitLabel(index + 1) : _l10n.teamsUnitLabel(index + 1);

  String get resultHeroTitle =>
      isPairings ? _l10n.pairingsResultHeroTitle : _l10n.teamsResultHeroTitle;

  String get resultHeroSubtitle =>
      isPairings ? _l10n.pairingsResultHeroSubtitle : _l10n.teamsResultHeroSubtitle;

  String resultSummary(int pairCount, int eligibleCount) => isPairings
      ? _l10n.pairingsResultSummary(pairCount, eligibleCount)
      : _l10n.teamsResultSummary(pairCount, eligibleCount);

  String get detailListTitle =>
      isPairings ? _l10n.pairingsDetailListTitle : _l10n.teamsDetailTeamsListTitle;

  String get detailFormCta =>
      isPairings ? _l10n.pairingsDetailFormCta : _l10n.teamsDetailFormTeamsCta;

  String get detailConfigTitle =>
      isPairings ? _l10n.pairingsDetailConfigTitle : _l10n.teamsDetailConfigTitle;

  String detailConfigSummary(int count) => isPairings
      ? _l10n.pairingsDetailConfigSummary(count)
      : _l10n.teamsDetailEstimatedTeams(count);

  String get renameDialogTitle =>
      isPairings ? _l10n.pairingsRenameDialogTitle : _l10n.teamsRenameDialogTitle;

  String get renameDialogFieldLabel =>
      isPairings ? _l10n.pairingsRenameDialogFieldLabel : _l10n.teamsRenameDialogFieldLabel;

  String get renameSuccess =>
      isPairings ? _l10n.pairingsRenameSuccess : _l10n.teamsRenameSuccess;

  String shareBody(String groupName, String blocks) =>
      isPairings ? _l10n.pairingsShareBody(groupName, blocks) : _l10n.teamsShareBody(groupName, blocks);

  String emailSubject(String groupName) => isPairings
      ? _l10n.pairingsEmailSubject(groupName)
      : _l10n.teamsEmailSubject(groupName);

  String emailBody(String groupName, String blocks) => isPairings
      ? _l10n.pairingsEmailBody(groupName, blocks)
      : _l10n.teamsEmailBody(groupName, blocks);

  String get pdfHeadline =>
      isPairings ? _l10n.pairingsPdfHeadline : _l10n.teamsPdfHeadline;

  String get pdfFooter => _l10n.teamsPdfFooter;

  String get chatSectionTitle =>
      isPairings ? _l10n.pairingsChatSectionTitle : _l10n.teamsChatSectionTitle;

  String get chatSectionSubtitle =>
      isPairings ? _l10n.pairingsChatSectionSubtitle : _l10n.teamsChatSectionSubtitle;

  String get chatEnterCta =>
      isPairings ? _l10n.pairingsChatEnterCta : _l10n.teamsChatEnterCta;

  String get chatCompletedChip =>
      isPairings ? _l10n.chatPairingsCompletedChip : _l10n.chatTeamsCompletedChip;

  String get chatSystemCompletedKey => isPairings
      ? 'chat.system.pairingsCompleted.v1'
      : 'chat.system.teamsCompleted.v1';

  String get memberWaitingTitle =>
      isPairings ? _l10n.pairingsMemberWaitingTitle : _l10n.teamsMemberWaitingTitle;

  String get memberWaitingBody =>
      isPairings ? _l10n.pairingsMemberWaitingBody : _l10n.teamsMemberWaitingBody;

  String joinSuccessSubtitle(String name) => isPairings
      ? _l10n.joinSuccessPairingsSubtitle(name)
      : _l10n.joinSuccessTeamsSubtitle(name);

  String get joinSuccessBody =>
      isPairings ? _l10n.joinSuccessPairingsBody : _l10n.joinSuccessTeamsBody;

  String get joinSuccessPrimaryCta =>
      isPairings ? _l10n.joinSuccessPairingsPrimaryCta : _l10n.joinSuccessTeamsPrimaryCta;
}
