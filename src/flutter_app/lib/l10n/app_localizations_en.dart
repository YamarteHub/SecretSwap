// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tarci Secret';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get create => 'Create';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get goToGroup => 'Go to group';

  @override
  String get copyCode => 'Copy code';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get joinWithCode => 'Join with code';

  @override
  String get joinScreenTitle => 'Join with code';

  @override
  String get joinScreenHeroTitle => 'Paste your invitation code';

  @override
  String get joinScreenHeroSubtitle =>
      'Your organizer shared it with you. Enter it and we\'ll add you to their group.';

  @override
  String get joinScreenCodeLabel => 'Invitation code';

  @override
  String get joinScreenCodeHint => 'For example, AB12CD';

  @override
  String get joinScreenCodeHelper => 'Lowercase is fine, we\'ll handle it.';

  @override
  String get joinScreenCodeRequired => 'Paste or type the code you received.';

  @override
  String get joinScreenCodeTooShort =>
      'That code looks incomplete. Please check and try again.';

  @override
  String get joinScreenNicknameLabel => 'Your name';

  @override
  String get joinScreenNicknameHelper => 'This is how the group will see you.';

  @override
  String get joinScreenNicknameRequired =>
      'Tell us your name so we can introduce you.';

  @override
  String get joinScreenNicknameTooShort =>
      'Use at least 3 letters so the group recognizes you.';

  @override
  String get joinScreenCta => 'Join the group';

  @override
  String get joinScreenCtaLoading => 'Joining…';

  @override
  String get joinScreenSuccessSnackbar => 'You\'re in!';

  @override
  String get joinSuccessTitle => 'You\'re in!';

  @override
  String joinSuccessSubtitle(String groupName) {
    return 'You joined $groupName. In a moment you\'ll see the rest of the group.';
  }

  @override
  String get joinSuccessChooseSubgroupTitle => 'Pick your house or team';

  @override
  String get joinSuccessChooseSubgroupHelp =>
      'The organizer created houses or teams. Pick yours so the draw places you correctly.';

  @override
  String get joinSuccessSubgroupLabel => 'Your house or team';

  @override
  String get joinSuccessNoSubgroupsTitle => 'No houses or teams yet';

  @override
  String get joinSuccessNoSubgroupsHelp =>
      'The organizer hasn\'t created them yet. You can continue and wait; there\'s nothing else for you to do right now.';

  @override
  String get joinSuccessChooseRequired => 'Pick an option to continue.';

  @override
  String get joinSuccessPrimaryCta => 'Go to group';

  @override
  String get joinSuccessSecondaryCta => 'Stay here';

  @override
  String get createSecretFriend => 'Create Secret Santa';

  @override
  String get comingSoonMoreDynamics =>
      'Coming soon: draws, teams, duels and pairings.';

  @override
  String get mySecretFriend => 'My secret friend';

  @override
  String get yourSecretFriendIs => 'Your secret friend is…';

  @override
  String get onlyYouCanSeeAssignment => 'Only you can see this assignment.';

  @override
  String get keepSecretUntilExchangeDay =>
      'Keep the secret until exchange day.';

  @override
  String get managedSecrets => 'Secrets you manage';

  @override
  String get guardianOfSecret => 'Guardian of the secret';

  @override
  String get privateResult => 'Private result';

  @override
  String get splashTagline =>
      'Tarci Secret hosts private group dynamics with real people.';

  @override
  String get splashLoadingHint => 'Getting things ready for you…';

  @override
  String get quickModeTitle => 'Quick mode';

  @override
  String get quickModeDescription =>
      'You can start without registering. To keep your groups across devices, you will be able to create an account later.';

  @override
  String get homeHeaderSubtitle =>
      'Organize Secret Santa and private draws with anyone. Private by default.';

  @override
  String get homeHeroHeadline => 'Secret Santa and group draws';

  @override
  String get homeGroupDrawStatePreparing => 'Getting ready';

  @override
  String get homeGroupDrawStateReady => 'Ready to draw';

  @override
  String get homeGroupDrawStateDrawing => 'Draw in progress';

  @override
  String get homeGroupDrawStateCompleted => 'Draw done';

  @override
  String get homeGroupDrawStateFailed => 'Draw needs attention';

  @override
  String get wizardCreateTitle => 'Create Secret Santa';

  @override
  String wizardStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get wizardStepNameTitle => 'What is this Secret Santa called?';

  @override
  String get wizardStepGroupTypeTitle => 'What type of group is it?';

  @override
  String get wizardStepModeTitle => 'How will it be organized?';

  @override
  String get wizardStepRuleTitle => 'Choose draw rule';

  @override
  String get wizardStepSubgroupsTitle => 'Subgroups';

  @override
  String get wizardStepParticipantsTitle => 'Participants';

  @override
  String get wizardStepEventDateTitle => 'When is the exchange?';

  @override
  String get wizardStepEventDateHelp =>
      'Optional. We use it to remind you about the exchange and move the group to your history once that day has passed.';

  @override
  String get wizardSummaryEventDate => 'Event date';

  @override
  String get wizardEventDateNotSet => 'Not set';

  @override
  String get wizardEventDateClear => 'Clear date';

  @override
  String get wizardStepReviewTitle => 'Final review';

  @override
  String get wizardGroupNameLabel => 'Group name';

  @override
  String get wizardGroupNameHint => 'Family Christmas 2026';

  @override
  String get wizardNicknameLabel => 'How do you appear?';

  @override
  String get wizardRuleIgnore => 'Ignore subgroups';

  @override
  String get wizardRulePrefer => 'Prefer different subgroup';

  @override
  String get wizardRuleRequire => 'Require different subgroup';

  @override
  String get wizardRuleIgnoreDesc => 'Normal draw.';

  @override
  String get wizardRulePreferDesc =>
      'Try to mix houses, departments or groups.';

  @override
  String get wizardRuleRequireDesc =>
      'Only allow people from different subgroups.';

  @override
  String get wizardReviewSaveNotice =>
      'You can adjust participants and subgroups later.';

  @override
  String get wizardReviewSummaryHelp =>
      'Check that everything looks right before continuing.';

  @override
  String get wizardCreateButton => 'Create Secret Santa';

  @override
  String get wizardCreatedTitle => 'Secret Santa created';

  @override
  String get wizardInviteCodeLabel => 'Invite code';

  @override
  String get wizardInviteCodeDescription =>
      'Share this code so others can join.';

  @override
  String get managedSubtitle =>
      'These results belong to people who depend on you. Deliver them privately.';

  @override
  String get managedEmptyTitle => 'You have no managed secrets';

  @override
  String get managedEmptyMessage =>
      'When you manage a child or a person without app, their result will appear here.';

  @override
  String get managedLoadErrorTitle => 'We couldn\'t load your managed secrets';

  @override
  String get managedLoadErrorMessage =>
      'Try again in a few minutes. You will only see results for people you manage.';

  @override
  String get managedAssignedTo => 'They should give to…';

  @override
  String get managedDeliverInPrivate => 'Deliver this result privately';

  @override
  String get managedHeroTitle => 'Secrets in your care';

  @override
  String get managedHeroSubtitle =>
      'You deliver these results privately, without anyone else finding out.';

  @override
  String get wishlistGroupMyCardTitle => 'Your wish list';

  @override
  String get wishlistGroupMyCardSubtitle =>
      'Fill it in yourself; only the person who drew you will see it.';

  @override
  String get wishlistGroupMyCardCtaFill => 'Fill in my list';

  @override
  String get wishlistGroupMyCardCtaEdit => 'Edit my list';

  @override
  String get wishlistGroupMyEmptyHint => 'You have not added ideas yet.';

  @override
  String get wishlistGroupMyReadyChip => 'List ready';

  @override
  String get wishlistGroupManagedSectionTitle => 'Lists you manage';

  @override
  String get wishlistGroupManagedSectionSubtitle =>
      'You can help fill them in; their gift givers will see them on their own screens.';

  @override
  String get wishlistGroupManagedRowCta => 'Edit list';

  @override
  String get wishlistGroupPostDrawIntro =>
      'Now that the draw is done, a few clear hints make it easier to pick the right gift.';

  @override
  String get wishlistEditorTitle => 'Wish list';

  @override
  String get wishlistViewTitle => 'Gift ideas';

  @override
  String get wishlistEditorIntro =>
      'Write lovingly what you would like to receive. Only your Secret Santa (and you) will see it.';

  @override
  String get wishlistViewIntro =>
      'These ideas are only to help with the gift. Keep the draw secret.';

  @override
  String get wishlistFieldWishTitle => 'I would love…';

  @override
  String get wishlistFieldWishHint =>
      'Concrete gift ideas, sizes, or details you would like.';

  @override
  String get wishlistFieldLikesTitle => 'I like…';

  @override
  String get wishlistFieldLikesHint =>
      'Hobbies, colors, styles, or things you love.';

  @override
  String get wishlistFieldAvoidTitle => 'Please avoid…';

  @override
  String get wishlistFieldAvoidHint =>
      'Things you prefer not to receive or already have.';

  @override
  String get wishlistFieldLinksTitle => 'Inspiration links';

  @override
  String wishlistLinksHelp(int max) {
    return 'Up to $max links using http or https.';
  }

  @override
  String get wishlistAddLinkCta => 'Add link';

  @override
  String get wishlistLinkLabelOptional => 'Label (optional)';

  @override
  String get wishlistLinkUrlLabel => 'URL';

  @override
  String get wishlistUrlHint => 'https://…';

  @override
  String wishlistLinkRowTitle(int index) {
    return 'Link $index';
  }

  @override
  String get wishlistSaveCta => 'Save';

  @override
  String get wishlistCancelCta => 'Go back';

  @override
  String get wishlistSaveSuccess => 'List saved.';

  @override
  String get wishlistUrlInvalid =>
      'Check the URLs: they must start with http:// or https://';

  @override
  String wishlistLinksMax(int max) {
    return 'At most $max links.';
  }

  @override
  String wishlistMyAssignmentReceiverWishlistHeading(String receiverName) {
    return 'What $receiverName would love to receive';
  }

  @override
  String get wishlistMyAssignmentReceiverNameFallback => 'your recipient';

  @override
  String get wishlistMyAssignmentSectionSubtitle =>
      'Only you see this. Use it as inspiration for a thoughtful gift.';

  @override
  String get wishlistMyAssignmentViewCta => 'View gift ideas';

  @override
  String get wishlistManagedViewReceiverCta => 'View wish list';

  @override
  String get wishlistManagedViewReceiverHint =>
      'You only see this person\'s ideas for this secret.';

  @override
  String get wishlistEmptyReceiverTitle => 'No gift ideas yet';

  @override
  String get wishlistEmptyReceiverBody =>
      'They might add them later. A thoughtful little gift always counts!';

  @override
  String get wishlistLinkOpenError => 'Could not open the link.';

  @override
  String get wishlistReadonlySheetTitle => 'Gift ideas';

  @override
  String get managedRevealLabel => 'Their secret friend is';

  @override
  String get managedDeliveryChipLabel => 'Delivery';

  @override
  String get managedFooterPrivacyNote =>
      'Every secret is private. Only you see it, and only you deliver it.';

  @override
  String get myAssignmentNotAvailableTitle =>
      'You can\'t see your secret friend yet';

  @override
  String get myAssignmentNotAvailableMessage =>
      'Your assignment is not available yet. When the draw is completed, you will see it here.';

  @override
  String get genericLoadErrorMessage =>
      'We couldn\'t load this information right now.';

  @override
  String get backToGroup => 'Back to group';

  @override
  String get groupDetailTitle => 'Group detail';

  @override
  String get groupRoleLabel => 'Role';

  @override
  String get groupStatusLabel => 'Status';

  @override
  String get groupLastExecution => 'Last';

  @override
  String get groupSectionStatus => 'Group status';

  @override
  String get groupSectionPrimaryAction => 'Primary action';

  @override
  String get groupSectionDrawRule => 'Draw rule';

  @override
  String get groupSectionSubgroups => 'Subgroups';

  @override
  String get groupSectionParticipants => 'Participants';

  @override
  String get groupSectionManagedParticipants => 'Participants without app';

  @override
  String get groupSectionInvitations => 'Invitations';

  @override
  String get groupSectionAdvanced => 'Advanced settings';

  @override
  String get groupStatusPreparing => 'Still getting ready';

  @override
  String get groupStatusReadyToDraw => 'Ready to draw';

  @override
  String get groupStatusCompleted => 'Your secret friends are picked!';

  @override
  String get groupStatusMissingSubgroups => 'Someone still needs a subgroup';

  @override
  String get groupActionRunDraw => 'Run the draw now';

  @override
  String get groupActionViewMySecretFriend => 'View my secret friend';

  @override
  String get groupActionManagedSecrets => 'Secrets you manage';

  @override
  String get groupActionCreateSubgroup => 'Create subgroup';

  @override
  String get groupActionEmptySubgroup => 'Empty subgroup';

  @override
  String get groupActionDeleteSubgroup => 'Delete subgroup';

  @override
  String get groupActionGenerateNewCode => 'Generate new code';

  @override
  String get groupActionCopyCode => 'Copy code';

  @override
  String get groupActionRename => 'Rename';

  @override
  String get groupActionEdit => 'Edit';

  @override
  String get groupRoleOrganizer => 'Organizer';

  @override
  String get groupRoleParticipant => 'Participant';

  @override
  String get groupTypeAdultNoApp => 'Adult without app';

  @override
  String get groupTypeChildManaged => 'Managed child';

  @override
  String get groupNoSubgroupAssigned => 'No subgroup assigned';

  @override
  String get groupGuardianOfSecret => 'Guardian of the secret';

  @override
  String get groupPrivateResult => 'Private result';

  @override
  String get groupWarningMissingSubgroupTitle =>
      'Some people still need a subgroup.';

  @override
  String get groupWarningMissingSubgroupRule =>
      'To require different subgroup, everyone must have one.';

  @override
  String get groupWarningMissingSubgroupCombined =>
      'Some people still need a subgroup. To require different subgroup, everyone must have one.';

  @override
  String get groupDialogDeleteSubgroupTitle => 'Delete subgroup';

  @override
  String groupDialogDeleteSubgroupBody(String name) {
    return 'Are you sure you want to delete \"$name\"? It will only be deleted if it has no assigned participants.';
  }

  @override
  String groupDialogEmptySubgroupTitle(String name) {
    return 'Empty \"$name\"';
  }

  @override
  String get groupDialogCancel => 'Cancel';

  @override
  String get groupDialogDelete => 'Delete';

  @override
  String get groupDialogEmpty => 'Empty';

  @override
  String get groupDialogMoveAndDelete => 'Move and delete';

  @override
  String get groupDialogMoveToSubgroup => 'Move to another subgroup';

  @override
  String get groupDialogBeforeDeleteMoveTo => 'Before deleting, move to';

  @override
  String get groupDialogLeaveWithoutSubgroup => 'Leave without subgroup';

  @override
  String get groupDialogNoAlternativeSubgroup =>
      'No other subgroup is available. They will remain without subgroup.';

  @override
  String get groupManagedDialogAddTitle => 'Add participant without app';

  @override
  String get groupManagedDialogEditTitle => 'Edit participant without app';

  @override
  String get groupManagedDialogNameLabel => 'Name';

  @override
  String get groupManagedDialogTypeLabel => 'Type';

  @override
  String get groupManagedDialogTypeAdultNoApp => 'Adult without app';

  @override
  String get groupManagedDialogTypeChild => 'Managed child';

  @override
  String get groupManagedDialogSubgroupOptionalLabel => 'Subgroup (optional)';

  @override
  String get groupManagedDialogNoSubgroup => 'No subgroup';

  @override
  String get groupManagedDialogDeliveryLabel => 'Delivery method';

  @override
  String get groupManagedDialogDeliveryVerbal => 'Verbal';

  @override
  String get groupManagedDialogDeliveryEmail => 'Email';

  @override
  String get groupManagedDialogDeliveryWhatsapp => 'WhatsApp';

  @override
  String get groupManagedDialogDeliveryPrinted => 'Printed / PDF';

  @override
  String get groupManagedDialogWhoManagesTitle =>
      'Who will manage this result?';

  @override
  String get groupManagedDialogWhoManagesDesc =>
      'Choose who will see the result in the app so they can deliver it privately.';

  @override
  String get groupManagedDialogWhoManagesHelp =>
      'When added to the draw, this person won\'t see the result in the app. You can deliver it verbally or printed.';

  @override
  String groupManagedDialogManagedBy(String name) {
    return 'Managed by: $name';
  }

  @override
  String get groupAssignDialogSelfTitle => 'Your subgroup';

  @override
  String get groupAssignDialogTitle => 'Assign subgroup';

  @override
  String get groupAssignDialogSelfDesc =>
      'Choose your house, department, class or team.';

  @override
  String get groupAssignDialogDesc => 'Select the subgroup for this member.';

  @override
  String get groupAssignDialogSubgroupLabel => 'Subgroup';

  @override
  String get groupSnackbarWriteName => 'Write a name';

  @override
  String get groupSnackbarDrawCompleted => 'Draw completed';

  @override
  String get groupSnackbarSubgroupUpdated => 'Subgroup updated';

  @override
  String get groupSnackbarGroupNameUpdated => 'Group name updated';

  @override
  String get groupSnackbarRuleUpdated => 'Draw rule updated';

  @override
  String get groupSnackbarNewCodeGenerated => 'New code generated';

  @override
  String get groupSnackbarManagedAdded => 'Participant without app added';

  @override
  String get groupSnackbarManagedUpdated => 'Participant without app updated';

  @override
  String get groupSnackbarManagedDeleted => 'Participant without app deleted';

  @override
  String get groupDialogEditGroupNameTitle => 'Edit group name';

  @override
  String get groupDialogGroupNameLabel => 'Group name';

  @override
  String get groupDialogRenameSubgroupTitle => 'Rename subgroup';

  @override
  String get groupDialogSubgroupNameLabel => 'Subgroup name';

  @override
  String get groupDialogDeleteParticipantTitle => 'Delete participant';

  @override
  String groupDialogDeleteParticipantBody(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String groupDialogSubgroupAssignedCount(int count) {
    return 'There are $count participants assigned to this subgroup.';
  }

  @override
  String groupDialogSubgroupAssignedCountDelete(int count) {
    return 'This subgroup has $count assigned participants.';
  }

  @override
  String get languageSystem => 'System';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSelectorTitle => 'Language';

  @override
  String get languageSelectorSubtitle => 'Choose how you want to see the app';

  @override
  String get homePrimaryActionsTitle => 'Primary actions';

  @override
  String get homeComingSoonDescription =>
      'Coming soon: draws, teams, duels and pairings.';

  @override
  String get homeChipDraws => 'Draws';

  @override
  String get homeChipTeams => 'Teams';

  @override
  String get homeChipPairings => 'Pairings';

  @override
  String get homeActiveGroupsTitle => 'In progress';

  @override
  String get homeActiveGroupsSubtitle =>
      'Setup or draw still pending; or draw done with delivery today or in the future, or no delivery date set yet.';

  @override
  String get homeActiveGroupsEmpty => 'You have no groups in this section.';

  @override
  String homeDeliveryDateLine(String date) {
    return 'Delivery: $date';
  }

  @override
  String homeDrawDateLine(String date) {
    return 'Draw: $date';
  }

  @override
  String get homeEmptyGroupsTitle => 'You don\'t have groups yet';

  @override
  String get homeEmptyGroupsMessage =>
      'Create your first secret friend or join with a code.';

  @override
  String get homeStatusActive => 'Active';

  @override
  String get homeStatusInactive => 'Inactive';

  @override
  String get homeCompletedGroupsTitle => 'Finished draws';

  @override
  String get homeCompletedGroupsSubtitle =>
      'Draw completed and the delivery date has passed.';

  @override
  String get homePastGroupsTitle => 'Past groups';

  @override
  String get homePastGroupsSubtitle =>
      'You are no longer an active member of these groups.';

  @override
  String get homeCompletedArchivedLabel => 'Completed / archived';

  @override
  String get homeDebugToolsTitle => 'Development tools';

  @override
  String homeDebugUid(String uid) {
    return 'Test UID: $uid';
  }

  @override
  String get homeDebugUserSwitchHint =>
      'Switching test user will show different groups because each user has their own list.';

  @override
  String get homeDebugResetUser => 'Sign out and create a new test user';

  @override
  String get homeEnvironmentEmulator => 'Environment: Local emulator';

  @override
  String get homeEnvironmentFirebase => 'Environment: Real Firebase dev';

  @override
  String get homePrivacyFooter =>
      'Your assignment and results remain private by default.';

  @override
  String get wizardTypeFamily => 'Family';

  @override
  String get wizardTypeFriends => 'Friends';

  @override
  String get wizardTypeCompany => 'Company';

  @override
  String get wizardTypeClass => 'Class';

  @override
  String get wizardTypeOther => 'Other';

  @override
  String get wizardModeInPerson => 'In person';

  @override
  String get wizardModeRemote => 'Remote';

  @override
  String get wizardModeMixed => 'Mixed';

  @override
  String get wizardCreateFunctionsError =>
      'Couldn\'t create the group. Check whether you are using emulators or real Firebase and whether Functions are deployed.';

  @override
  String get wizardNameHelp => 'Add a name that identifies the group.';

  @override
  String get wizardGroupTypeHelp =>
      'This guides the experience. It is not saved yet.';

  @override
  String get wizardModeHelp =>
      'Define how the group will be organized. For now, this is UX preparation.';

  @override
  String get wizardRuleHelp => 'This setting is saved in the group.';

  @override
  String get wizardSubgroupsHelpIgnore =>
      'With this rule you don\'t need subgroups now.';

  @override
  String get wizardSubgroupsHelpEnabled =>
      'You can create and assign subgroups from group detail.';

  @override
  String get wizardParticipantsHelp =>
      'Later you can invite by code and add people without app.';

  @override
  String get wizardSummaryName => 'Name';

  @override
  String get wizardSummaryGroupType => 'Group type';

  @override
  String get wizardSummaryMode => 'Mode';

  @override
  String get wizardSummaryRule => 'Draw rule';

  @override
  String get groupRoleAdmin => 'Admin';

  @override
  String get groupRoleMember => 'Member';

  @override
  String get groupRuleIgnoreTitle => 'Ignore subgroups';

  @override
  String get groupRulePreferTitle => 'Prefer different subgroup';

  @override
  String get groupRuleRequireTitle => 'Require different subgroup';

  @override
  String get groupRuleIgnoreDescription =>
      'Normal draw. It does not consider houses, departments, or classes.';

  @override
  String get groupRulePreferDescription =>
      'Tarci Secret will try to cross gifts between different subgroups, but won\'t block the draw if not possible.';

  @override
  String get groupRuleRequireDescription =>
      'Nobody can give to someone from the same subgroup. It may fail if the group cannot produce a valid combination.';

  @override
  String get groupSnackNeedThreeParticipants =>
      'You need at least 3 effective participants for a fun draw.';

  @override
  String get groupSnackDrawAlreadyRunningOrDone =>
      'You can\'t run a new draw while one is in progress or completed.';

  @override
  String get groupSnackCannotAddAfterDraw =>
      'You can\'t add participants after running the draw.';

  @override
  String get groupDeleteOwnerSectionTitle => 'Group options';

  @override
  String get groupDeleteOwnerSectionHint =>
      'Only the organizer can end this group dynamic and delete all of its data.';

  @override
  String get groupDeleteEntryCta => 'Delete group';

  @override
  String get groupDeleteDialogPreTitle => 'Delete this group?';

  @override
  String get groupDeleteDialogPreBody =>
      'This will remove the setup, participants, invitations, and related data. This action cannot be undone.';

  @override
  String get groupDeleteDialogPreConfirm => 'Delete group';

  @override
  String get groupDeleteDialogPostTitle => 'Delete this Secret Santa?';

  @override
  String get groupDeleteDialogPostBody =>
      'The draw has already been run. If you continue, everyone will lose access to their results, wishlists, group chat, and related data. This action cannot be undone.';

  @override
  String get groupDeleteDialogPostConfirm => 'Delete permanently';

  @override
  String get groupDeleteSuccessSnackbar => 'Group deleted';

  @override
  String get groupDetailMissingMessage =>
      'This group no longer exists or was removed by the organizer.';

  @override
  String get groupTooltipEditGroupName => 'Edit group name';

  @override
  String get groupStatusCompletedInfo =>
      'Each person can now see who they\'re gifting to, in private.';

  @override
  String get groupStatusReadyInfo =>
      'When you launch it, each person sees their assignment privately.';

  @override
  String get groupStatusPendingInfo =>
      'Check pending participants or subgroups.';

  @override
  String groupEffectiveParticipants(int count) {
    return 'You have $count of 3 minimum people';
  }

  @override
  String get groupOwnerCanRunHint =>
      'Once everything is ready, the organizer launches the draw.';

  @override
  String get groupPendingSubgroupHint =>
      'Place each person in their subgroup and you\'re done.';

  @override
  String get groupPendingGeneralHint =>
      'You\'re nearly there. Just a bit more setup.';

  @override
  String groupRuleConfigVersion(int version) {
    return 'Config v$version';
  }

  @override
  String get groupRuleLockedHint =>
      'The rule can\'t be changed while the draw is in progress or completed.';

  @override
  String get groupSubgroupSectionHelp =>
      'Organize houses, departments, classes or teams to improve the draw.';

  @override
  String get groupSubgroupEmptyHelp =>
      'There are no subgroups yet. You can create one to organize the group better.';

  @override
  String get groupSubgroupAssignedOne => '1 assigned participant';

  @override
  String groupSubgroupAssignedMany(int count) {
    return '$count assigned participants';
  }

  @override
  String get groupSubgroupLockedHint =>
      'You can\'t modify subgroups after running the draw.';

  @override
  String get groupSubgroupDisabledHint =>
      'Subgroups are disabled for this draw. You can enable them by changing the rule.';

  @override
  String get groupParticipantSubgroupLockedHint =>
      'Subgroup can\'t be changed while draw is in progress or completed.';

  @override
  String get groupManagedSectionHelp =>
      'These participants don\'t use the app and their result is delivered privately.';

  @override
  String get groupManagedEmptyHelp => 'There are no managed participants yet.';

  @override
  String get groupManagedGuardianSelf => 'you';

  @override
  String get groupManagedGuardianOther => 'another manager';

  @override
  String get groupManagedPrivateDeliveryHint =>
      'They participate without app and their result is delivered privately.';

  @override
  String get groupInvitationsHelp =>
      'Generate a code and share it so participants can join.';

  @override
  String get groupInvitationCodeTapHint => 'Tap the code to copy it';

  @override
  String get groupInvitationsClosedHint =>
      'Invitations are closed because the draw was already run.';

  @override
  String get groupAdvancedHelp => 'Secondary group details are shown here.';

  @override
  String groupAdvancedLastExecution(String id) {
    return 'Last execution: $id';
  }

  @override
  String groupAdvancedInternalStatus(String status) {
    return 'Internal draw status: $status';
  }

  @override
  String get groupCreateSubgroupHint => 'e.g. Stan House, Sales, Class 3A';

  @override
  String get groupHeaderSubtitle =>
      'Prepare your draw with privacy and clarity.';

  @override
  String get groupDetailTaglinePostDraw =>
      'Private results: everyone sees only their own.';

  @override
  String get groupMemberPreDrawSubtitle =>
      'You\'re in. When the organizer runs the draw, you\'ll see your assignment privately.';

  @override
  String get groupMemberYourHouseTitle => 'Your house or team';

  @override
  String get groupMemberYourHousePickHint =>
      'The organizer set up teams or houses. Pick yours so the draw can place you correctly.';

  @override
  String groupMemberYourHouseAssigned(String name) {
    return 'You\'re placed in: $name';
  }

  @override
  String get groupMemberYourHouseChooseCta => 'Choose my house or team';

  @override
  String get groupMemberYourHouseChangeCta => 'Change my house or team';

  @override
  String get groupMemberManagedByYouTitle => 'People you manage here';

  @override
  String get groupMemberManagedByYouSubtitle =>
      'You\'ll only see people the organizer assigned to you as their responsible adult.';

  @override
  String get groupMemberHeroTitlePreDraw => 'You\'re in';

  @override
  String get groupMemberHeroSubtitlePreDraw =>
      'When the organizer runs the draw, you\'ll see your assignment privately.';

  @override
  String get groupMemberHeroTaglinePreDraw =>
      'Your group, your space. No one else sees your result.';

  @override
  String get groupMemberHeroTaglinePostDraw =>
      'Draw done. Only you see what you got.';

  @override
  String get groupMemberPostDrawHeroSubtitle =>
      'Open your result whenever you like — it\'s private.';

  @override
  String get groupMemberHeroSubtitleDrawing =>
      'We\'re drawing now. You\'ll see your result shortly.';

  @override
  String get groupBackToDashboard => 'Back to dashboard';

  @override
  String get groupLoadingDetail => 'Loading group...';

  @override
  String get groupErrorTitle => 'We couldn\'t open this group';

  @override
  String get groupErrorNotFound =>
      'This group is no longer available or you don\'t have access.';

  @override
  String get groupPreparationTitle => 'Group status';

  @override
  String groupPreparationQuickSummary(
    int total,
    int withoutApp,
    int subgroups,
  ) {
    return '$total people in the draw · $withoutApp without app · $subgroups subgroups';
  }

  @override
  String get groupPostDrawHeroTitle => 'Draw completed';

  @override
  String get groupPostDrawHeroSubtitle =>
      'You can now see what applies to you, in private.';

  @override
  String get groupChecklistEnoughPeopleDone => 'You have enough people';

  @override
  String get groupChecklistEnoughPeopleMissing => 'You need at least 3 people';

  @override
  String get groupChecklistAllInSubgroupDone => 'Everyone is in a subgroup';

  @override
  String get groupChecklistMissingSubgroupOne =>
      '1 person still needs a subgroup';

  @override
  String groupChecklistMissingSubgroupMany(int count) {
    return '$count people still need a subgroup';
  }

  @override
  String groupChecklistPendingMembers(int count) {
    return '$count person(s) left or were removed';
  }

  @override
  String groupPreparationRegistered(int count) {
    return 'Registered: $count';
  }

  @override
  String groupPreparationManaged(int count) {
    return 'Managed: $count';
  }

  @override
  String groupPreparationPending(int count) {
    return 'Pending: $count';
  }

  @override
  String groupPreparationMissingSubgroup(int count) {
    return 'No subgroup: $count';
  }

  @override
  String get groupRuleCurrentLabel => 'Current rule';

  @override
  String get groupRuleChangeCta => 'Change rule';

  @override
  String get groupSectionExpandHint => 'Tap to expand';

  @override
  String get groupSectionCollapseHint => 'Tap to collapse';

  @override
  String groupSectionItemsCount(int count) {
    return '$count total';
  }

  @override
  String get groupManagedDialogGuardianSectionTitle =>
      'Who will deliver the result?';

  @override
  String get groupManagedDialogGuardianMe => 'Me';

  @override
  String get groupManagedDialogGuardianMeHint =>
      'I\'ll share it privately with them';

  @override
  String get groupManagedDialogGuardianOther => 'Another member';

  @override
  String get groupManagedDialogGuardianSpecific => 'Specific person';

  @override
  String get groupManagedDialogGuardianComingSoon => 'Coming soon';

  @override
  String get groupManagedDialogDeliverySectionTitle => 'How will you share it?';

  @override
  String get groupManagedResponsibleUnavailable => 'Responsible not available';

  @override
  String groupManagedDeliversResponsible(String name) {
    return 'Managed by: $name';
  }

  @override
  String get groupManagedDialogPickGuardianTitle => 'Who will deliver it?';

  @override
  String get groupManagedDialogGuardianOtherSubtitle =>
      'This member will see the result and can pass it on in private.';

  @override
  String get groupManagedDialogGuardianNoEligibleMembers =>
      'When another member joins with the app, you can assign them.';

  @override
  String get groupManagedDialogPickMemberCta => 'Choose member';

  @override
  String get groupManagedDialogSelectOtherFirst =>
      'Choose a group member first.';

  @override
  String get groupManagedDialogGuardianMustReassign =>
      'That member is no longer active in the group. Pick another responsible person or \"Me\".';

  @override
  String groupManagedDialogDeliversSummary(String name) {
    return 'Delivers: $name';
  }

  @override
  String get groupParticipantsRegisteredTitle => 'Registered participants';

  @override
  String get groupParticipantsPendingTitle => 'Pending participants';

  @override
  String get groupParticipantsPendingEmpty =>
      'There are no pending participants.';

  @override
  String get groupPendingStatusLeft => 'Left the group';

  @override
  String get groupPendingStatusRemoved => 'Removed from group';

  @override
  String myAssignmentSubgroupLabel(String name) {
    return 'Subgroup: $name';
  }

  @override
  String managedSubgroupLabel(String name) {
    return 'Subgroup: $name';
  }

  @override
  String get managedYouManageIt => 'Managed by you';

  @override
  String managedDeliveryRecommendation(String mode) {
    return 'Recommended delivery: $mode';
  }

  @override
  String get managedTypeManagedParticipant => 'Managed participant';

  @override
  String get managedDeliveryOwnerDelegated => 'Handled by manager';

  @override
  String get managedDeliveryModeWhatsapp => 'WhatsApp';

  @override
  String get managedDeliveryModeEmail => 'Email';

  @override
  String get managedDeliveryModePdf => 'Printed / PDF';

  @override
  String get managedDeliveryCtaWhatsapp => 'Share via WhatsApp';

  @override
  String get managedDeliveryCtaEmail => 'Prepare email';

  @override
  String get managedDeliveryCtaPdf => 'Create PDF';

  @override
  String get managedDeliveryVerbalBadge => 'Verbal delivery';

  @override
  String get managedDeliveryPdfGenerating => 'Creating PDF…';

  @override
  String get managedDeliveryWhatsappBrand => '🎁 Tarci Secret';

  @override
  String managedDeliveryWhatsappHello(String name) {
    return 'Hi, $name.';
  }

  @override
  String managedDeliveryWhatsappDrawLine(String groupName) {
    return 'The Secret Santa draw for \"$groupName\" is ready.';
  }

  @override
  String get managedDeliveryWhatsappGiftIntro => 'You\'re giving a gift to:';

  @override
  String managedDeliveryWhatsappReceiverLine(String receiverName) {
    return '✨ $receiverName';
  }

  @override
  String managedDeliverySubgroupBelongsTo(String subgroup) {
    return 'Group / house / team: $subgroup';
  }

  @override
  String get managedDeliveryClosingSecret => 'Keep it secret 🤫';

  @override
  String managedDeliveryEmailSubject(String groupName) {
    return 'Your Secret Santa result for $groupName is ready 🎁';
  }

  @override
  String managedDeliveryEmailGreeting(String name) {
    return 'Hi $name,';
  }

  @override
  String managedDeliveryEmailLead(String groupName) {
    return 'Here is the private Secret Santa result for the group \"$groupName\".';
  }

  @override
  String get managedDeliveryEmailGiftLabel => 'You are giving a gift to:';

  @override
  String managedDeliveryEmailReceiverLine(String receiverName) {
    return '$receiverName';
  }

  @override
  String managedDeliveryEmailSubgroupLine(String subgroup) {
    return 'House or team: $subgroup';
  }

  @override
  String get managedDeliveryEmailClosing =>
      'Please keep this result private. No one else should see it.';

  @override
  String get managedDeliveryEmailSignoff => 'Warm wishes,\nTarci Secret';

  @override
  String get managedPdfDocTitle => 'secret-santa';

  @override
  String get managedPdfHeadline => 'Your Secret Santa result is ready';

  @override
  String get managedPdfForLabel => 'For';

  @override
  String get managedPdfGroupLabel => 'Group';

  @override
  String get managedPdfGiftHeading => 'You\'re giving a gift to…';

  @override
  String get managedPdfFooterKeepSecret =>
      'Keep the secret. No one else should see this.';

  @override
  String get managedPdfFooterBrand => 'Made with Tarci Secret';

  @override
  String get managedDeliveryFallbackGroupName => 'your group';

  @override
  String get managedDeliveryErrorMissingData =>
      'Not enough data to prepare the message.';

  @override
  String get managedDeliveryErrorWhatsapp =>
      'We couldn\'t open WhatsApp. You can share the text with another app.';

  @override
  String get managedDeliveryErrorEmail =>
      'No email app is available on this device.';

  @override
  String get managedDeliveryErrorPdf =>
      'The PDF could not be generated. Please try again.';

  @override
  String get managedDeliveryErrorShare => 'Sharing failed. Please try again.';

  @override
  String get managedDeliveryErrorGeneric =>
      'Something went wrong. Please try again.';

  @override
  String get myAssignmentPrivateBadge => 'Private · just for you';

  @override
  String get myAssignmentRevealLabel => 'You\'re gifting to';

  @override
  String get myAssignmentEmotionalCopy => 'Make them feel special.';

  @override
  String get myAssignmentPrivacyTitle => 'Only you can see this';

  @override
  String get myAssignmentPrivacyBody =>
      'Keep the secret until exchange day. No one else in the group can see who you got.';

  @override
  String get myAssignmentNoSubgroupChip => 'No subgroup';

  @override
  String get groupCompletedHeroSubtitle =>
      'Everyone has found out who they\'re gifting to.';

  @override
  String get groupCompletedPrivacyNote =>
      'Each result is private. Only that person sees their own.';

  @override
  String get groupCompletedManagedHint =>
      'You privately deliver the results of the people you manage.';

  @override
  String get chatGroupSectionTitle => 'Group conversation';

  @override
  String get chatGroupSectionSubtitle =>
      'Joke around, share clues, and keep the vibe alive.';

  @override
  String get chatGroupEnterCta => 'Open chat';

  @override
  String chatGroupEventLine(String date) {
    return 'Exchange: $date';
  }

  @override
  String get chatDrawCompletedChip => 'Draw completed';

  @override
  String get chatInputHint => 'Say something to the group…';

  @override
  String get chatSendCta => 'Send';

  @override
  String get chatTarciLabel => 'Tarci';

  @override
  String get chatEmptyTitle => 'No messages yet';

  @override
  String get chatEmptyBody =>
      'When someone writes or Tarci shares an update, it will show up here.';

  @override
  String get chatLoadError =>
      'We couldn\'t load the chat. Check your connection and try again.';

  @override
  String get chatSendError =>
      'We couldn\'t send your message. Please try again.';

  @override
  String get chatSystemGroupCreatedV1 =>
      '🎁 The group is live. Drop hints, stir the pot, and let the playful chaos begin.';

  @override
  String get chatSystemDrawCompletedV1 =>
      '🤫 The draw is done. From here on, every weird question is evidence.';

  @override
  String chatSystemUnknownTemplate(String templateKey) {
    return 'System message ($templateKey)';
  }

  @override
  String get chatSystemAutoPlayful001V1 =>
      'Suspicion is already in the air… and nobody has confessed a thing.';

  @override
  String get chatSystemAutoPlayful002V1 =>
      'Now that the draw is done, every innocent question sounds strategic.';

  @override
  String get chatSystemAutoPlayful003V1 =>
      'Tarci tip: investigate with subtlety, not like an interrogation.';

  @override
  String get chatSystemAutoPlayful004V1 =>
      'Some already have a gift. Others have faith.';

  @override
  String get chatSystemAutoPlayful005V1 =>
      'If someone asks about sizes, colors and hobbies all at once, take note.';

  @override
  String get chatSystemAutoPlayful006V1 =>
      'A good gift surprises. A great gift becomes a story.';

  @override
  String get chatSystemAutoPlayful007V1 => 'Suspicious smiles count as clues.';

  @override
  String get chatSystemAutoPlayful008V1 =>
      'Misdirection is allowed. Overdoing it is not recommended.';

  @override
  String get chatSystemAutoPlayful009V1 =>
      'Some people\'s silence is starting to look like a plan.';

  @override
  String get chatSystemAutoPlayful010V1 =>
      'If you are going to improvise, at least improvise with care.';

  @override
  String get chatSystemAutoPlayful011V1 =>
      'Tarci detects energy for epic gifts… and elegant panic.';

  @override
  String get chatSystemAutoPlayful012V1 =>
      'Anyone saying “I already have it” without proof raises suspicion.';

  @override
  String get chatSystemAutoPlayful013V1 =>
      'Friendly reminder: the mystery is part of the fun.';

  @override
  String get chatSystemAutoPlayful014V1 =>
      'Every group has a detective. Do you already know who it is?';

  @override
  String get chatSystemAutoPlayful015V1 =>
      'A thoughtful detail is worth more than a gift without soul.';

  @override
  String get chatSystemAutoPlayful016V1 =>
      'This chat is officially in suspicion mode.';

  @override
  String get chatSystemAutoPlayful017V1 =>
      'If you just searched for gift ideas in secret, nobody is judging.';

  @override
  String get chatSystemAutoPlayful018V1 =>
      'Some real-life glances suddenly mean far too much.';

  @override
  String get chatSystemAutoPlayful019V1 =>
      'The mission is not to spend more. It is to get it right.';

  @override
  String get chatSystemAutoPlayful020V1 =>
      'Hiding it well is also part of the game.';

  @override
  String get chatSystemAutoPlayful021V1 =>
      'Tarci bets someone here already has a brilliant plan.';

  @override
  String get chatSystemAutoDebate001V1 =>
      'Quick debate: a useful gift or a gift that makes people laugh?';

  @override
  String get chatSystemAutoDebate002V1 =>
      'Better a total surprise or a well-used hint?';

  @override
  String get chatSystemAutoDebate003V1 => 'What wins: creativity or precision?';

  @override
  String get chatSystemAutoDebate004V1 =>
      'Open debate: does spectacular wrapping matter?';

  @override
  String get chatSystemAutoDebate005V1 =>
      'Discreet research or wish list to the rescue?';

  @override
  String get chatSystemAutoDebate006V1 =>
      'Without naming names: who in this group improvises at the last minute?';

  @override
  String get chatSystemAutoDebate007V1 =>
      'A small gift with a story or a big gift without one?';

  @override
  String get chatSystemAutoDebate008V1 =>
      'Is misdirection in the chat fair play or already dirty tactics?';

  @override
  String get chatSystemAutoDebate009V1 =>
      'What feels better: getting it right or surprising someone?';

  @override
  String get chatSystemAutoDebate010V1 =>
      'If you had to choose: practical, fun or sentimental?';

  @override
  String get chatSystemAutoWishlist001V1 =>
      'Some wish lists are still empty. A timely hint can save a gift.';

  @override
  String get chatSystemAutoWishlist002V1 =>
      'Your wish list does not remove the magic; it avoids guessing blindly.';

  @override
  String get chatSystemAutoWishlist003V1 =>
      'If you want them to get it right, leave a few ideas.';

  @override
  String get chatSystemAutoWishlist004V1 =>
      'Someone is preparing a gift with very few clues. Ahem.';

  @override
  String get chatSystemAutoWishlist005V1 =>
      'Filling in your list helps without revealing too much.';

  @override
  String get chatSystemAutoWishlist006V1 =>
      'A link, a preference, a clue: it all helps.';

  @override
  String get chatSystemAutoWishlist007V1 =>
      'Even the best surprises appreciate a little guidance.';

  @override
  String get chatSystemAutoWishlist008V1 =>
      'If your list is empty, your Secret Santa is playing on hard mode.';

  @override
  String get chatSystemAutoQuiet001V1 =>
      'It is very quiet here… shopping or hiding evidence?';

  @override
  String get chatSystemAutoQuiet002V1 =>
      'This group is far too quiet. Someone break the ice.';

  @override
  String get chatSystemAutoQuiet003V1 =>
      'Tarci is taking attendance: is the playful chaos still alive?';

  @override
  String get chatSystemAutoQuiet004V1 =>
      'Reactivation question: who looks most suspicious today?';

  @override
  String get chatSystemAutoQuiet005V1 =>
      'If nobody writes, Tarci will start making up theories.';

  @override
  String get chatSystemAutoQuiet006V1 =>
      'Sleeping chat, wide-awake mystery. Say something.';

  @override
  String get chatSystemAutoCountdown014V1 =>
      '14 days left. There is still time, but excuses are running out.';

  @override
  String get chatSystemAutoCountdown007V1 =>
      '7 days left. Anyone without an idea has officially entered serious search mode.';

  @override
  String get chatSystemAutoCountdown003V1 =>
      '3 days left. This is no longer planning; it is a rescue operation.';

  @override
  String get chatSystemAutoCountdown001V1 =>
      '1 day left. Wrap it, breathe, and act natural.';

  @override
  String get chatSystemAutoCountdown000V1 =>
      'Today is the exchange. May there be surprises, laughs, and zero early confessions.';
}
