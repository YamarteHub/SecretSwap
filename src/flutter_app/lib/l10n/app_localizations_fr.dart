// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Tarci Secret';

  @override
  String get retry => 'Réessayer';

  @override
  String get back => 'Dos';

  @override
  String get next => 'Suivant';

  @override
  String get create => 'Créer';

  @override
  String get close => 'Fermer';

  @override
  String get save => 'Garder';

  @override
  String get goToGroup => 'Aller au groupe';

  @override
  String get copyCode => 'Copier le code';

  @override
  String get codeCopied => 'Code copié';

  @override
  String get joinWithCode => 'Rejoindre avec le code';

  @override
  String get joinScreenTitle => 'Rejoindre avec le code';

  @override
  String get joinScreenHeroTitle => 'Collez votre code d\'invitation';

  @override
  String get joinScreenHeroSubtitle =>
      'Votre organisateur l\'a partagé avec vous par message. Lorsque vous y entrerez, nous vous rejoindrons dans leur groupe.';

  @override
  String get joinScreenCodeLabel => 'code d\'invitation';

  @override
  String get joinScreenCodeHint => 'Par exemple, AB12CD';

  @override
  String get joinScreenCodeHelper =>
      'La majuscule n\'a pas d\'importance, nous la corrigerons pour vous.';

  @override
  String get joinScreenCodeRequired =>
      'Collez ou tapez le code que vous avez reçu.';

  @override
  String get joinScreenCodeTooShort =>
      'Ce code semble incomplet. Vérifiez-le et réessayez.';

  @override
  String get joinScreenNicknameLabel => 'ton nom';

  @override
  String get joinScreenNicknameHelper =>
      'C\'est ainsi que le groupe vous verra.';

  @override
  String get joinScreenNicknameRequired =>
      'Dites-nous votre nom pour vous présenter au groupe.';

  @override
  String get joinScreenNicknameTooShort =>
      'Entrez au moins 3 lettres pour que le groupe vous reconnaisse.';

  @override
  String get joinScreenCta => 'Rejoignez le groupe';

  @override
  String get joinScreenCtaLoading => 'Je vous rejoins…';

  @override
  String get joinScreenSuccessSnackbar => 'Vous y êtes !';

  @override
  String get joinSuccessTitle => 'Vous y êtes déjà !';

  @override
  String joinSuccessSubtitle(String groupName) {
    return 'tu as rejoint$groupName. Dans un instant, vous pourrez voir le reste du groupe.';
  }

  @override
  String get joinSuccessChooseSubgroupTitle =>
      'Choisissez votre maison ou votre équipe';

  @override
  String get joinSuccessChooseSubgroupHelp =>
      'L\'organisateur a créé des maisons ou des équipes. Choisissez le vôtre pour que le tirage vous place bien.';

  @override
  String get joinSuccessSubgroupLabel => 'Votre maison ou votre équipe';

  @override
  String get joinSuccessNoSubgroupsTitle =>
      'Pas encore de maisons ni d\'équipes';

  @override
  String get joinSuccessNoSubgroupsHelp =>
      'L\'organisateur ne les a pas encore créés. Vous pouvez continuer et attendre ; Vous n’avez rien d’autre à faire pour l’instant.';

  @override
  String get joinSuccessChooseRequired =>
      'Choisissez une option pour continuer.';

  @override
  String get joinSuccessPrimaryCta => 'Aller au groupe';

  @override
  String get joinSuccessSecondaryCta => 'reste ici';

  @override
  String joinSuccessRaffleSubtitle(String groupName) {
    return 'Tu as rejoint $groupName. Quand l’organisateur lancera le tirage, tu pourras voir le résultat ici.';
  }

  @override
  String get joinSuccessRaffleBody =>
      'En attendant, tu peux voir qui participe et attendre le moment du tirage.';

  @override
  String get joinSuccessRafflePrimaryCta => 'Aller au tirage';

  @override
  String get createSecretFriend => 'Créer un ami secret';

  @override
  String get comingSoonMoreDynamics =>
      'Prochainement : tirages au sort, équipes, duels et appariements.';

  @override
  String get mySecretFriend => 'mon ami secret';

  @override
  String get yourSecretFriendIs => 'Votre ami secret est…';

  @override
  String get onlyYouCanSeeAssignment => 'Vous seul pouvez voir cette mission.';

  @override
  String get keepSecretUntilExchangeDay =>
      'Gardez le secret jusqu\'au jour de l\'échange.';

  @override
  String get managedSecrets => 'Les secrets que vous gérez';

  @override
  String get guardianOfSecret => 'Gardien du secret';

  @override
  String get privateResult => 'Résultat privé';

  @override
  String get splashTagline =>
      'Tarci Secret organise des dynamiques de groupes privés avec de vraies personnes.';

  @override
  String get splashLoadingHint => 'Je prépare tout pour vous…';

  @override
  String get splashBootBrandedHint => 'Préparation de votre espace…';

  @override
  String get productAuthorshipLine => 'Tarci Secret · © 2026 Stalin Yamarte';

  @override
  String get aboutScreenTitle => 'À propos de Tarci Secret';

  @override
  String get aboutTooltip => 'À propos de Tarci Secret';

  @override
  String get aboutTagline =>
      'Dynamiques de groupe, tirages au sort et expériences sociales avec confidentialité, émotion et personnes réelles.';

  @override
  String get aboutSectionWhatTitle => 'Qu’est-ce que Tarci Secret';

  @override
  String get aboutSectionWhatBody =>
      'Tarci Secret est une application conçue pour organiser Secret Santa, tirages au sort et dynamiques de groupe de façon simple, privée et ludique. Elle inclut des personnes réelles : enfants, proches sans téléphone ou participants gérés par un adulte.\n\nTarci Secret naît avec le Secret Santa comme première expérience et est pensée pour évoluer vers de nouvelles dynamiques sociales, tirages, équipes, duels et appariements.';

  @override
  String get aboutSectionHowTitle => 'Comment ça marche';

  @override
  String get aboutStep1Title => 'Créer ou rejoindre un groupe';

  @override
  String get aboutStep1Body =>
      'Lancez une dynamique ou entrez avec un code d’invitation.';

  @override
  String get aboutStep2Title => 'Organiser participants et règles';

  @override
  String get aboutStep2Body =>
      'Ajoutez des personnes avec l’app ou gérées et ajustez le type de tirage.';

  @override
  String get aboutStep3Title => 'Lancer la dynamique ou le tirage';

  @override
  String get aboutStep3Body =>
      'Quand le groupe est prêt, l’organisateur exécute le tirage en privé.';

  @override
  String get aboutStep4Title => 'Découvrir, discuter et profiter';

  @override
  String get aboutStep4Body =>
      'Chacun voit son résultat en privé et le groupe peut prolonger l’expérience.';

  @override
  String get aboutSectionPrivacyTitle => 'Confidentialité dès la conception';

  @override
  String get aboutSectionPrivacyBody =>
      'Chacun ne voit que ce dont il a besoin. En Secret Santa, les attributions sont protégées pour que le résultat reste privé.';

  @override
  String get aboutSectionPrivacyTrust =>
      'L’application privilégie la clarté, la confiance et le respect de l’expérience du groupe.';

  @override
  String get aboutSectionCreatorTitle => 'Créé par Stalin Yamarte';

  @override
  String get aboutSectionCreatorSubtitle =>
      'Spécialiste en systèmes et développeur d’applications.';

  @override
  String get aboutLinkedInCta => 'Voir le profil LinkedIn';

  @override
  String get aboutLinkedInError =>
      'Impossible d’ouvrir LinkedIn. Réessayez depuis le navigateur.';

  @override
  String get aboutAppInfoTitle => 'Informations sur l’app';

  @override
  String get aboutCopyrightLine => '© 2026 Stalin Yamarte';

  @override
  String get aboutPackageInfoError => 'Impossible de lire la version de l’app.';

  @override
  String aboutBuildLine(String buildNumber) {
    return 'Compilation interne $buildNumber';
  }

  @override
  String get quickModeTitle => 'Mode rapide';

  @override
  String get quickModeDescription =>
      'Vous pouvez commencer sans vous inscrire. Pour conserver vos groupes sur plusieurs appareils, vous pouvez créer un compte ultérieurement.';

  @override
  String get homeHeaderSubtitle =>
      'Organisez des amis secrets et des cadeaux avec qui vous voulez. Privé par défaut.';

  @override
  String get homeHeroHeadline => 'Cadeaux secrets pour amis et groupes';

  @override
  String get homeGroupDrawStatePreparing => 'Préparation';

  @override
  String get homeGroupDrawStateReady => 'Prêt à dessiner';

  @override
  String get homeGroupDrawStateDrawing => 'Tirage au sort en cours';

  @override
  String get homeGroupDrawStateCompleted => 'Dessiné';

  @override
  String get homeGroupDrawStateFailed => 'Tirage au sort';

  @override
  String get wizardCreateTitle => 'Créer un ami secret';

  @override
  String wizardStepOf(int current, int total) {
    return 'Passé${current}de$total';
  }

  @override
  String get wizardStepNameTitle => 'Quel est le nom de cet ami secret ?';

  @override
  String get wizardStepGroupTypeTitle => 'De quel type de groupe s\'agit-il ?';

  @override
  String get wizardStepModeTitle => 'Comment sera-t-il organisé ?';

  @override
  String get wizardStepRuleTitle => 'Choisissez la règle du tirage au sort';

  @override
  String get wizardStepSubgroupsTitle => 'Sous-groupes';

  @override
  String get wizardStepParticipantsTitle => 'Participants';

  @override
  String get wizardStepEventDateTitle => 'Quand a lieu l\'échange ?';

  @override
  String get wizardStepEventDateHelp =>
      'C\'est facultatif. Cela nous aidera à nous souvenir de la livraison et à déplacer le groupe vers l\'historique lorsque cela se produit.';

  @override
  String get wizardSummaryEventDate => 'Date de l\'événement';

  @override
  String get wizardEventDateNotSet => 'Indéfini';

  @override
  String get wizardEventDateClear => 'Supprimer la date';

  @override
  String get wizardStepReviewTitle => 'Examen final';

  @override
  String get wizardGroupNameLabel => 'Nom du groupe';

  @override
  String get wizardGroupNameHint => 'Noël en famille 2026';

  @override
  String get wizardNicknameLabel => 'Comment apparaissez-vous ?';

  @override
  String get wizardRuleIgnore => 'Ignorer les sous-groupes';

  @override
  String get wizardRulePrefer => 'Préférer un sous-groupe différent';

  @override
  String get wizardRuleRequire => 'Nécessite un sous-groupe différent';

  @override
  String get wizardRuleIgnoreDesc => 'Tirage normal.';

  @override
  String get wizardRulePreferDesc =>
      'Essayez de traverser des maisons, des appartements ou des groupes.';

  @override
  String get wizardRuleRequireDesc =>
      'Autorisez uniquement les personnes de différents sous-groupes.';

  @override
  String get wizardReviewSaveNotice =>
      'Vous pourrez ajuster les participants et les sous-groupes ultérieurement.';

  @override
  String get wizardReviewSummaryHelp =>
      'Vérifiez que tout est correct avant de continuer.';

  @override
  String get wizardCreateButton => 'Créer un ami secret';

  @override
  String get wizardCreatedTitle => 'Ami secret créé';

  @override
  String get wizardInviteCodeLabel => 'code d\'invitation';

  @override
  String get wizardInviteCodeDescription =>
      'Partagez ce code pour que d\'autres personnes puissent le rejoindre.';

  @override
  String get managedSubtitle =>
      'Ces résultats proviennent de personnes qui dépendent de vous. Livrez-les-leur en privé.';

  @override
  String get managedEmptyTitle => 'Vous n\'avez pas de secrets gérés';

  @override
  String get managedEmptyMessage =>
      'Lorsque vous gérez un enfant ou une personne sans application, vous verrez ici leurs résultats.';

  @override
  String get managedLoadErrorTitle =>
      'Nous n\'avons pas pu charger vos secrets gérés';

  @override
  String get managedLoadErrorMessage =>
      'Veuillez réessayer dans quelques minutes. Vous ne verrez que les résultats des personnes que vous dirigez.';

  @override
  String get managedAssignedTo => 'C\'est à votre tour de donner...';

  @override
  String get managedDeliverInPrivate => 'Livrez ce résultat en privé';

  @override
  String get managedHeroTitle => 'Des secrets à votre disposition';

  @override
  String get managedHeroSubtitle =>
      'Vous fournissez ces résultats en privé, sans que personne d’autre ne le sache.';

  @override
  String get wishlistGroupMyCardTitle => 'Votre liste de souhaits';

  @override
  String get wishlistGroupMyCardSubtitle =>
      'Vous le complétez ; Seul celui que vous donnerez à votre tour le verra.';

  @override
  String get wishlistGroupMyCardCtaFill => 'Compléter ma liste';

  @override
  String get wishlistGroupMyCardCtaEdit => 'Modifier ma liste';

  @override
  String get wishlistGroupMyEmptyHint =>
      'Vous n\'avez pas encore ajouté d\'idées.';

  @override
  String get wishlistGroupMyReadyChip => 'Liste prête';

  @override
  String get wishlistGroupManagedSectionTitle => 'Listes que vous gérez';

  @override
  String get wishlistGroupManagedSectionSubtitle =>
      'Aidez-les à les remplir ; Celui qui les donne les verra sur son propre écran.';

  @override
  String get wishlistGroupManagedRowCta => 'Modifier la liste';

  @override
  String get wishlistGroupPostDrawIntro =>
      'Maintenant que le tirage au sort est terminé, quelques indices clairs vous aideront à trouver le bon cadeau.';

  @override
  String get wishlistEditorTitle => 'Liste de souhaits';

  @override
  String get wishlistViewTitle => 'Idées cadeaux';

  @override
  String get wishlistEditorIntro =>
      'Écrivez avec affection ce que vous seriez ravi de recevoir. Seul celui qui sera à votre tour de le donner (et vous) le verra.';

  @override
  String get wishlistViewIntro =>
      'Ces idées sont juste pour aider avec le cadeau. Respectez le secret du tirage au sort.';

  @override
  String get wishlistFieldWishTitle => 'Je serais excité...';

  @override
  String get wishlistFieldWishHint =>
      'Idées cadeaux spécifiques, tailles ou détails que vous souhaiteriez.';

  @override
  String get wishlistFieldLikesTitle => 'J\'aime ça…';

  @override
  String get wishlistFieldLikesHint =>
      'Loisirs, couleurs, styles ou choses que vous aimez.';

  @override
  String get wishlistFieldAvoidTitle => 'Mieux vaut éviter…';

  @override
  String get wishlistFieldAvoidHint =>
      'Des choses que vous préférez ne pas recevoir ou que vous possédez déjà.';

  @override
  String get wishlistFieldLinksTitle => 'Liens d\'inspiration';

  @override
  String wishlistLinksHelp(int max) {
    return 'Jusqu\'à${max}liens avec http ou https.';
  }

  @override
  String get wishlistAddLinkCta => 'Ajouter un lien';

  @override
  String get wishlistLinkLabelOptional => 'Étiquette (facultatif)';

  @override
  String get wishlistLinkUrlLabel => 'URL';

  @override
  String get wishlistUrlHint => 'https://…';

  @override
  String wishlistLinkRowTitle(int index) {
    return 'Lien$index';
  }

  @override
  String get wishlistSaveCta => 'Garder';

  @override
  String get wishlistCancelCta => 'Retour';

  @override
  String get wishlistSaveSuccess => 'Liste enregistrée.';

  @override
  String get wishlistUrlInvalid =>
      'Vérifiez les URL : elles doivent commencer par http:// ou https://';

  @override
  String wishlistLinksMax(int max) {
    return 'Au plus${max}links.';
  }

  @override
  String wishlistMyAssignmentReceiverWishlistHeading(String receiverName) {
    return 'Qu\'aimeriez-vous recevoir ?$receiverName';
  }

  @override
  String get wishlistMyAssignmentReceiverNameFallback => 'votre destinataire';

  @override
  String get wishlistMyAssignmentSectionSubtitle =>
      'Vous seul voyez cela. Il sert à vous inspirer lorsque vous choisissez un détail avec amour.';

  @override
  String get wishlistMyAssignmentViewCta => 'Voir les idées cadeaux';

  @override
  String get wishlistManagedViewReceiverCta => 'Afficher la liste de souhaits';

  @override
  String get wishlistManagedViewReceiverHint =>
      'Vous ne voyez que les idées de cette personne sur ce secret.';

  @override
  String get wishlistEmptyReceiverTitle =>
      'Il n\'y a plus d\'idées cadeaux pour l\'instant';

  @override
  String get wishlistEmptyReceiverBody =>
      'Peut-être que je les ajouterai plus tard. Un détail fait avec amour compte toujours !';

  @override
  String get wishlistLinkOpenError => 'Le lien n\'a pas pu être ouvert.';

  @override
  String get wishlistReadonlySheetTitle => 'Idées cadeaux';

  @override
  String get managedRevealLabel => 'Ton ami secret est';

  @override
  String get managedDeliveryChipLabel => 'Livraison';

  @override
  String get managedFooterPrivacyNote =>
      'Chaque secret est privé. Vous seul pouvez le voir et vous seul pouvez le livrer.';

  @override
  String get myAssignmentNotAvailableTitle =>
      'Tu ne peux toujours pas voir ton ami secret';

  @override
  String get myAssignmentNotAvailableMessage =>
      'Votre mission n\'est pas encore disponible. Une fois le concours terminé, vous pourrez le voir ici.';

  @override
  String get genericLoadErrorMessage =>
      'Nous n\'avons pas pu charger ces informations pour le moment.';

  @override
  String get backToGroup => 'Retour au groupe';

  @override
  String get groupDetailTitle => 'Détail du groupe';

  @override
  String get groupRoleLabel => 'Rôle';

  @override
  String get groupStatusLabel => 'État';

  @override
  String get groupLastExecution => 'Dernier';

  @override
  String get groupSectionStatus => 'Statut du groupe';

  @override
  String get groupSectionPrimaryAction => 'action principale';

  @override
  String get groupSectionDrawRule => 'Règle de dessin';

  @override
  String get groupSectionSubgroups => 'Sous-groupes';

  @override
  String get groupSectionParticipants => 'Participants';

  @override
  String get groupSectionManagedParticipants => 'Participants sans application';

  @override
  String get groupSectionInvitations => 'Invitations';

  @override
  String get groupSectionAdvanced => 'Paramètres avancés';

  @override
  String get groupStatusPreparing => 'Suivez la préparation';

  @override
  String get groupStatusReadyToDraw => 'Prêt à dessiner';

  @override
  String get groupStatusCompleted => 'Vos amis secrets ont déjà été choisis !';

  @override
  String get groupStatusMissingSubgroups =>
      'Vous devez placer quelqu\'un dans votre groupe';

  @override
  String get groupActionRunDraw => 'Faites le tirage maintenant';

  @override
  String get groupActionViewMySecretFriend => 'Voir mon ami secret';

  @override
  String get groupActionManagedSecrets => 'Les secrets que vous gérez';

  @override
  String get groupActionCreateSubgroup => 'Créer un sous-groupe';

  @override
  String get groupActionEmptySubgroup => 'Sous-groupe vide';

  @override
  String get groupActionDeleteSubgroup => 'Supprimer le sous-groupe';

  @override
  String get groupActionGenerateNewCode => 'Générer un nouveau code';

  @override
  String get groupActionCopyCode => 'Copier le code';

  @override
  String get groupActionRename => 'Rebaptiser';

  @override
  String get groupActionEdit => 'Modifier';

  @override
  String get groupRoleOrganizer => 'Organisateur';

  @override
  String get groupRoleParticipant => 'Participant';

  @override
  String get groupTypeAdultNoApp => 'Adulte sans application';

  @override
  String get groupTypeChildManaged => 'enfant géré';

  @override
  String get groupNoSubgroupAssigned => 'Aucun sous-groupe attribué';

  @override
  String get groupGuardianOfSecret => 'Gardien du secret';

  @override
  String get groupPrivateResult => 'Résultat privé';

  @override
  String get groupWarningMissingSubgroupTitle =>
      'Il manque des personnes à affecter à un sous-groupe.';

  @override
  String get groupWarningMissingSubgroupRule =>
      'Pour exiger un sous-groupe différent, tout le monde doit en avoir un.';

  @override
  String get groupWarningMissingSubgroupCombined =>
      'Il manque des personnes à affecter à un sous-groupe. Pour exiger un sous-groupe différent, tout le monde doit en avoir un.';

  @override
  String get groupDialogDeleteSubgroupTitle => 'Supprimer le sous-groupe';

  @override
  String groupDialogDeleteSubgroupBody(String name) {
    return 'Etes-vous sûr de vouloir supprimer \"$name\" ? Ne sera supprimé que si aucun participant n\'est attribué.';
  }

  @override
  String groupDialogEmptySubgroupTitle(String name) {
    return 'Vide \"$name\"';
  }

  @override
  String get groupDialogCancel => 'Annuler';

  @override
  String get groupDialogDelete => 'Éliminer';

  @override
  String get groupDialogEmpty => 'Vide';

  @override
  String get groupDialogMoveAndDelete => 'Déplacer et supprimer';

  @override
  String get groupDialogMoveToSubgroup => 'Passer à un autre sous-groupe';

  @override
  String get groupDialogBeforeDeleteMoveTo => 'Avant de supprimer, passez à';

  @override
  String get groupDialogLeaveWithoutSubgroup => 'Partir sans sous-groupe';

  @override
  String get groupDialogNoAlternativeSubgroup =>
      'Aucun autre sous-groupe disponible. Ils se retrouveront sans sous-groupe.';

  @override
  String get groupManagedDialogAddTitle =>
      'Ajouter un participant sans application';

  @override
  String get groupManagedDialogEditTitle =>
      'Modifier un participant sans application';

  @override
  String get groupManagedDialogNameLabel => 'Nom';

  @override
  String get groupManagedDialogTypeLabel => 'Gars';

  @override
  String get groupManagedDialogTypeAdultNoApp => 'Adulte sans application';

  @override
  String get groupManagedDialogTypeChild => 'enfant géré';

  @override
  String get groupManagedDialogSubgroupOptionalLabel =>
      'Sous-groupe (facultatif)';

  @override
  String get groupManagedDialogNoSubgroup => 'Aucun sous-groupe';

  @override
  String get groupManagedDialogDeliveryLabel => 'Mode de livraison';

  @override
  String get groupManagedDialogDeliveryVerbal => 'Verbal';

  @override
  String get groupManagedDialogDeliveryEmail => 'Mail';

  @override
  String get groupManagedDialogDeliveryWhatsapp => 'WhatsApp';

  @override
  String get groupManagedDialogDeliveryPrinted => 'Imprimé / PDF';

  @override
  String get groupManagedDialogWhoManagesTitle => 'Qui gérera son résultat ?';

  @override
  String get groupManagedDialogWhoManagesDesc =>
      'Choisissez qui verra le résultat dans l\'application afin que vous puissiez le transmettre en privé.';

  @override
  String get groupManagedDialogWhoManagesHelp =>
      'Lorsqu’elle rejoindra le tirage au sort, cette personne ne verra pas le résultat dans l’application. Vous pouvez le remettre verbalement ou sous forme imprimée.';

  @override
  String groupManagedDialogManagedBy(String name) {
    return 'Géré par :$name';
  }

  @override
  String get groupAssignDialogSelfTitle => 'Votre sous-groupe';

  @override
  String get groupAssignDialogTitle => 'Attribuer un sous-groupe';

  @override
  String get groupAssignDialogSelfDesc =>
      'Choisissez votre maison, appartement, classe ou équipe.';

  @override
  String get groupAssignDialogDesc =>
      'Sélectionnez le sous-groupe pour ce membre.';

  @override
  String get groupAssignDialogSubgroupLabel => 'Sous-groupe';

  @override
  String get groupSnackbarWriteName => 'Écrivez un nom';

  @override
  String get groupSnackbarDrawCompleted => 'Concours terminé';

  @override
  String get groupSnackbarSubgroupUpdated => 'Sous-groupe mis à jour';

  @override
  String get groupSnackbarGroupNameUpdated => 'Nom du groupe mis à jour';

  @override
  String get groupSnackbarRuleUpdated => 'Règle de tirage mise à jour';

  @override
  String get groupSnackbarNewCodeGenerated => 'Nouveau code généré';

  @override
  String get groupSnackbarManagedAdded =>
      'Participant sans application ajoutée';

  @override
  String get groupSnackbarManagedUpdated =>
      'Participant sans application mise à jour';

  @override
  String get groupSnackbarManagedDeleted =>
      'Participant sans application éliminé';

  @override
  String get groupDialogEditGroupNameTitle => 'Modifier le nom du groupe';

  @override
  String get groupDialogGroupNameLabel => 'Nom du groupe';

  @override
  String get groupDialogRenameSubgroupTitle => 'Renommer le sous-groupe';

  @override
  String get groupDialogSubgroupNameLabel => 'Nom du sous-groupe';

  @override
  String get groupDialogDeleteParticipantTitle => 'Supprimer un participant';

  @override
  String groupDialogDeleteParticipantBody(String name) {
    return 'Etes-vous sûr de vouloir éliminer \"$name\" ?';
  }

  @override
  String groupDialogSubgroupAssignedCount(int count) {
    return 'Il y a${count}participants affectés à ce sous-groupe.';
  }

  @override
  String groupDialogSubgroupAssignedCountDelete(int count) {
    return 'Ce sous-groupe a${count}participants assignés.';
  }

  @override
  String get languageSystem => 'Système';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageSelectorTitle => 'Langue';

  @override
  String get languageSelectorSubtitle =>
      'Choisissez comment vous souhaitez afficher l\'application';

  @override
  String get languagePortuguese => 'portugais';

  @override
  String get languageItalian => 'italien';

  @override
  String get languageFrench => 'Français';

  @override
  String get functionsErrorAlreadyMember => 'Vous appartenez déjà à ce groupe.';

  @override
  String get functionsErrorCodeNotFound =>
      'Nous n\'avons trouvé aucun groupe avec ce code.';

  @override
  String get functionsErrorCodeExpired => 'Ce code a expiré.';

  @override
  String get functionsErrorGroupArchived => 'Ce groupe est désormais fermé.';

  @override
  String get functionsErrorUserRemoved =>
      'Vous ne pouvez plus rejoindre ce groupe.';

  @override
  String get functionsErrorDrawInProgress =>
      'Le tirage au sort est en cours. Veuillez réessayer plus tard.';

  @override
  String get functionsErrorDrawAlreadyCompleted =>
      'Ce concours était déjà terminé.';

  @override
  String get functionsErrorDrawCompletedInvitesClosed =>
      'Ce tirage au sort a déjà été effectué et n\'accepte plus de nouveaux participants.';

  @override
  String get functionsErrorSubgroupInUse =>
      'Avant de supprimer ce sous-groupe, déplacez ou laissez ses participants sans sous-groupe.';

  @override
  String get functionsErrorSubgroupNotFound =>
      'Le sous-groupe n\'existe plus ou a été supprimé.';

  @override
  String get functionsErrorNotOwner =>
      'Seul l\'organisateur peut effectuer cette action.';

  @override
  String get functionsErrorGroupDeleteForbidden =>
      'Seul l\'organisateur peut supprimer ce groupe.';

  @override
  String get functionsErrorGroupDeleteFailed =>
      'Nous ne pouvions pas éliminer complètement le groupe. Veuillez réessayer ou vérifier votre connexion.';

  @override
  String get functionsErrorDrawLocked =>
      'Vous ne pouvez pas modifier les sous-groupes ou les participants lorsque le tirage est en cours ou terminé.';

  @override
  String get functionsErrorGenericAction =>
      'L\'action n\'a pas pu être complétée. Veuillez réessayer dans un instant.';

  @override
  String get functionsErrorPermissionDeniedDrawRule =>
      'La règle du tirage au sort n\'a pas pu être modifiée. Vérifiez que le tirage n\'est pas en cours ou terminé.';

  @override
  String get functionsErrorUnknown =>
      'Quelque chose s\'est mal passé. Veuillez réessayer dans quelques instants.';

  @override
  String get functionsErrorDebugSession =>
      'L\'action n\'a pas pu être complétée. Vérifiez si vous utilisez des émulateurs ou du vrai Firebase, si les fonctions sont déployées et si la session est active.';

  @override
  String get homePrimaryActionsTitle => 'Principales actions';

  @override
  String get homeComingSoonDescription =>
      'Prochainement : tirages au sort, équipes, duels et appariements.';

  @override
  String get homeChipDraws => 'Cadeaux';

  @override
  String get homeChipTeams => 'Équipes';

  @override
  String get homeChipPairings => 'Accords';

  @override
  String get homeActiveGroupsTitle => 'En cours';

  @override
  String get homeActiveGroupsSubtitle =>
      'En attente de préparation ou de tirage au sort ; ou tirage effectué avec livraison aujourd\'hui ou dans le futur, ou sans date de livraison définie.';

  @override
  String get homeActiveGroupsEmpty =>
      'Vous n\'avez aucun groupe dans cette section.';

  @override
  String homeDeliveryDateLine(String date) {
    return 'Livraison:$date';
  }

  @override
  String homeDrawDateLine(String date) {
    return 'Loterie:$date';
  }

  @override
  String get homeEmptyGroupsTitle => 'Vous n\'avez pas encore de groupes';

  @override
  String get homeEmptyGroupsMessage =>
      'Créez votre premier ami secret ou rejoignez-nous avec un code.';

  @override
  String get homeStatusActive => 'Actif';

  @override
  String get homeStatusInactive => 'Inactif';

  @override
  String get homeCompletedGroupsTitle => 'Tirages finalisés';

  @override
  String get homeCompletedGroupsSubtitle =>
      'Tirage au sort effectué et date de livraison déjà dépassée.';

  @override
  String get homePastGroupsTitle => 'Groupes précédents';

  @override
  String get homePastGroupsSubtitle =>
      'Vous n\'êtes plus activement impliqué dans ces groupes.';

  @override
  String get homeCompletedArchivedLabel => 'Terminé/archivé';

  @override
  String get homeDebugToolsTitle => 'Outils de développement';

  @override
  String homeDebugUid(String uid) {
    return 'UID de test :$uid';
  }

  @override
  String get homeDebugUserSwitchHint =>
      'Changer d\'utilisateur test vous fera voir d\'autres groupes, car chaque utilisateur a sa propre liste.';

  @override
  String get homeDebugResetUser =>
      'Déconnectez-vous et créez un nouvel utilisateur test';

  @override
  String get homeEnvironmentEmulator => 'Environnement : émulateur local';

  @override
  String get homeEnvironmentFirebase =>
      'Environnement : développement réel Firebase';

  @override
  String get homePrivacyFooter =>
      'Votre devoir et vos résultats restent privés par défaut.';

  @override
  String get wizardTypeFamily => 'Famille';

  @override
  String get wizardTypeFriends => 'Amis';

  @override
  String get wizardTypeCompany => 'Entreprise';

  @override
  String get wizardTypeClass => 'Classe';

  @override
  String get wizardTypeOther => 'Autre';

  @override
  String get wizardModeInPerson => 'En personne';

  @override
  String get wizardModeRemote => 'Télécommande';

  @override
  String get wizardModeMixed => 'Mixte';

  @override
  String get wizardCreateFunctionsError =>
      'Le groupe n\'a pas pu être créé. Vérifiez si vous utilisez des émulateurs ou un vrai Firebase et si les fonctions sont déployées.';

  @override
  String get wizardNameHelp => 'Donnez un nom qui identifie le groupe.';

  @override
  String get wizardGroupTypeHelp =>
      'Ces informations guident l’expérience. Pour l\'instant, il n\'est pas sauvegardé.';

  @override
  String get wizardModeHelp =>
      'Définir comment le groupe sera organisé. Pour l\'instant c\'est la préparation UX.';

  @override
  String get wizardRuleHelp =>
      'Cette configuration est enregistrée dans le groupe.';

  @override
  String get wizardSubgroupsHelpIgnore =>
      'Avec cette règle, vous n\'avez plus besoin de sous-groupes.';

  @override
  String get wizardSubgroupsHelpEnabled =>
      'Vous pourrez créer et attribuer des sous-groupes à partir du détail du groupe.';

  @override
  String get wizardParticipantsHelp =>
      'Ensuite, vous pouvez inviter par code et ajouter des personnes sans application.';

  @override
  String get wizardSummaryName => 'Nom';

  @override
  String get wizardSummaryGroupType => 'Type de groupe';

  @override
  String get wizardSummaryMode => 'Mode';

  @override
  String get wizardSummaryRule => 'Règle de dessin';

  @override
  String get groupRoleAdmin => 'Administrateur';

  @override
  String get groupRoleMember => 'Membre';

  @override
  String get groupRuleIgnoreTitle => 'Ignorer les sous-groupes';

  @override
  String get groupRulePreferTitle => 'Préférer un sous-groupe différent';

  @override
  String get groupRuleRequireTitle => 'Nécessite un sous-groupe différent';

  @override
  String get groupRuleIgnoreDescription =>
      'Tirage normal. Il ne prend pas en compte les maisons, les appartements ou les classes.';

  @override
  String get groupRulePreferDescription =>
      'Tarci Secret tentera de faire correspondre les cadeaux entre différents sous-groupes, mais ne bloquera pas le concours si cela n\'est pas possible.';

  @override
  String get groupRuleRequireDescription =>
      'Personne ne pourra offrir en cadeau à quelqu’un du même sous-groupe. Cela peut échouer si le groupe n\'autorise pas une jointure valide.';

  @override
  String get groupSnackNeedThreeParticipants =>
      'Vous avez besoin d\'au moins 3 participants effectifs pour organiser un concours amusant.';

  @override
  String get groupSnackDrawAlreadyRunningOrDone =>
      'Un nouveau tirage ne peut pas être lancé tant qu\'il est en cours ou terminé.';

  @override
  String get groupSnackCannotAddAfterDraw =>
      'Vous ne pouvez pas ajouter de participants après avoir lancé le concours.';

  @override
  String get groupDeleteOwnerSectionTitle => 'Options du groupe';

  @override
  String get groupDeleteOwnerSectionHint =>
      'Seul l’organisateur peut clore cette dynamique et supprimer toutes les données du groupe.';

  @override
  String get groupDeleteEntryCta => 'Supprimer le groupe';

  @override
  String get groupDeleteDialogPreTitle => 'Supprimer ce groupe ?';

  @override
  String get groupDeleteDialogPreBody =>
      'La configuration, les participants, les invitations et les données associées seront supprimés. Cette action est irréversible.';

  @override
  String get groupDeleteDialogPreConfirm => 'Supprimer le groupe';

  @override
  String get groupDeleteDialogPostTitle => 'Supprimer ce Secret Santa ?';

  @override
  String get groupDeleteDialogPostBody =>
      'Le tirage a déjà été effectué. Si vous continuez, tout le monde perdra l’accès aux résultats, aux listes de souhaits, au chat du groupe et aux données associées. Cette action est irréversible.';

  @override
  String get groupDeleteDialogPostConfirm => 'Supprimer définitivement';

  @override
  String get groupDeleteSuccessSnackbar => 'Groupe supprimé';

  @override
  String get groupDetailMissingMessage =>
      'Ce groupe n’existe plus ou a été supprimé par l’organisateur.';

  @override
  String get groupTooltipEditGroupName => 'Modifier le nom du groupe';

  @override
  String get groupStatusCompletedInfo =>
      'Chacun peut désormais voir à qui c’est à son tour de donner.';

  @override
  String get groupStatusReadyInfo =>
      'Lorsque vous le lancerez, chacun verra sa mission en privé.';

  @override
  String get groupStatusPendingInfo =>
      'Examinez les participants ou les sous-groupes en attente.';

  @override
  String groupEffectiveParticipants(int count) {
    return 'Avoir${count}de 3 personnes minimum';
  }

  @override
  String get groupOwnerCanRunHint =>
      'Lorsque tout est prêt, l\'organisateur lance le tirage au sort.';

  @override
  String get groupPendingSubgroupHint =>
      'Affectez chaque personne à son groupe et c\'est tout.';

  @override
  String get groupPendingGeneralHint =>
      'Vous y êtes presque pour pouvoir faire le tirage au sort.';

  @override
  String groupRuleConfigVersion(int version) {
    return 'Configurationv$version';
  }

  @override
  String get groupRuleLockedHint =>
      'La règle ne peut pas être modifiée pendant que le tirage est en cours ou est déjà terminé.';

  @override
  String get groupSubgroupSectionHelp =>
      'Organisez des maisons, des appartements, des classes ou des équipes pour améliorer le tirage au sort.';

  @override
  String get groupSubgroupEmptyHelp =>
      'Il n\'y a pas encore de sous-groupes. Vous pouvez en créer un pour mieux organiser le groupe.';

  @override
  String get groupSubgroupAssignedOne => '1 participant assigné';

  @override
  String groupSubgroupAssignedMany(int count) {
    return '${count}participants assignés';
  }

  @override
  String get groupSubgroupLockedHint =>
      'Vous ne pouvez pas modifier les sous-groupes après avoir exécuté le tirage au sort.';

  @override
  String get groupSubgroupDisabledHint =>
      'Sous-groupes désactivés pour ce concours. Vous pouvez les activer en modifiant la règle.';

  @override
  String get groupParticipantSubgroupLockedHint =>
      'Le sous-groupe ne peut pas être modifié pendant que le tirage au sort est en cours ou est déjà terminé.';

  @override
  String get groupManagedSectionHelp =>
      'Ces participants n\'utilisent pas l\'application et leur résultat est livré en privé.';

  @override
  String get groupManagedEmptyHelp =>
      'Il n’y a pas encore de participants gérés.';

  @override
  String get groupManagedGuardianSelf => 'toi';

  @override
  String get groupManagedGuardianOther => 'un autre responsable';

  @override
  String get groupManagedPrivateDeliveryHint =>
      'Ils participent sans application et leurs résultats sont livrés en privé.';

  @override
  String get groupInvitationsHelp =>
      'Générez un code et partagez-le pour que les participants puissent le rejoindre.';

  @override
  String get groupInvitationCodeTapHint => 'Appuyez sur le code pour le copier';

  @override
  String get groupInvitationsClosedHint =>
      'Les invitations sont closes car le tirage au sort a déjà été effectué.';

  @override
  String get groupAdvancedHelp =>
      'Les détails secondaires du groupe sont affichés ici.';

  @override
  String groupAdvancedLastExecution(String id) {
    return 'Dernière exécution :$id';
  }

  @override
  String groupAdvancedInternalStatus(String status) {
    return 'Statut interne du tirage au sort :$status';
  }

  @override
  String get groupCreateSubgroupHint => 'Ex. Stan House, Ventes, Classe 3A';

  @override
  String get groupHeaderSubtitle =>
      'Préparez votre cadeau avec confidentialité et clarté.';

  @override
  String get groupDetailTaglinePostDraw =>
      'Résultats en privé : chacun voit le sien.';

  @override
  String get groupMemberPreDrawSubtitle =>
      'Vous êtes déjà à l\'intérieur. Lorsque l\'organisateur lancera le concours, vous pourrez consulter votre allocation en privé.';

  @override
  String get groupMemberYourHouseTitle => 'Votre maison ou votre équipe';

  @override
  String get groupMemberYourHousePickHint =>
      'L\'organisateur a défini des équipes ou des maisons. Choisissez le vôtre pour bien vous placer au tirage au sort.';

  @override
  String groupMemberYourHouseAssigned(String name) {
    return 'Nous vous avons localisé à :$name';
  }

  @override
  String get groupMemberYourHouseChooseCta => 'Choisir ma maison ou mon équipe';

  @override
  String get groupMemberYourHouseChangeCta =>
      'Changer de maison ou d\'équipement';

  @override
  String get groupMemberManagedByYouTitle => 'Personnes que vous gérez ici';

  @override
  String get groupMemberManagedByYouSubtitle =>
      'Vous ne verrez que ceux que l\'organisateur vous a désignés comme responsables.';

  @override
  String get groupMemberHeroTitlePreDraw => 'Vous êtes déjà à l\'intérieur';

  @override
  String get groupMemberHeroSubtitlePreDraw =>
      'Lorsque l\'organisateur lancera le concours, vous verrez votre allocation en privé.';

  @override
  String get groupMemberHeroTaglinePreDraw =>
      'Votre groupe, votre espace. Personne ne voit les résultats des autres.';

  @override
  String get groupMemberHeroTaglinePostDraw =>
      'Cadeau prêt. Vous seul voyez ce que vous avez.';

  @override
  String get groupMemberPostDrawHeroSubtitle =>
      'Ouvrez votre résultat quand vous le souhaitez ; C\'est privé.';

  @override
  String get groupMemberHeroSubtitleDrawing =>
      'Nous tirons au sort. Dans un instant, vous pourrez voir votre résultat.';

  @override
  String get groupBackToDashboard => 'Retour au tableau de bord';

  @override
  String get groupLoadingDetail => 'Chargement du groupe...';

  @override
  String get groupErrorTitle => 'Nous n\'avons pas pu ouvrir ce groupe';

  @override
  String get groupErrorNotFound =>
      'Ce groupe n\'est plus disponible ou vous n\'y avez pas accès.';

  @override
  String get groupPreparationTitle => 'Statut du groupe';

  @override
  String groupPreparationQuickSummary(
    int total,
    int withoutApp,
    int subgroups,
  ) {
    return '${total}les gens dans le tirage au sort${withoutApp}sans application ·${subgroups}sous-groupes';
  }

  @override
  String get groupPostDrawHeroTitle => 'Tirage effectué';

  @override
  String get groupPostDrawHeroSubtitle =>
      'Vous pouvez désormais voir ce qui vous appartient, en privé.';

  @override
  String get groupChecklistEnoughPeopleDone => 'Vous avez déjà assez de monde';

  @override
  String get groupChecklistEnoughPeopleMissing =>
      'Vous avez besoin d\'au moins 3 personnes';

  @override
  String get groupChecklistAllInSubgroupDone =>
      'Tout le monde est dans son sous-groupe';

  @override
  String get groupChecklistMissingSubgroupOne =>
      'Vous devez placer 1 personne dans votre sous-groupe';

  @override
  String groupChecklistMissingSubgroupMany(int count) {
    return 'Ils manquent${count}personnes à placer dans leur sous-groupe';
  }

  @override
  String groupChecklistPendingMembers(int count) {
    return '${count}la ou les personne(s) sont parties ou ont été expulsées';
  }

  @override
  String groupPreparationRegistered(int count) {
    return 'Inscrit:$count';
  }

  @override
  String groupPreparationManaged(int count) {
    return 'Géré :$count';
  }

  @override
  String groupPreparationPending(int count) {
    return 'Boucles d\'oreilles :$count';
  }

  @override
  String groupPreparationMissingSubgroup(int count) {
    return 'Sans sous-groupe :$count';
  }

  @override
  String get groupRuleCurrentLabel => 'Règle actuelle';

  @override
  String get groupRuleChangeCta => 'Changer la règle';

  @override
  String get groupSectionExpandHint => 'Appuyez pour développer';

  @override
  String get groupSectionCollapseHint => 'Appuyez pour fermer';

  @override
  String groupSectionItemsCount(int count) {
    return '${count}en tout';
  }

  @override
  String get groupManagedDialogGuardianSectionTitle =>
      'Qui livrera le résultat ?';

  @override
  String get groupManagedDialogGuardianMe => 'je';

  @override
  String get groupManagedDialogGuardianMeHint =>
      'Je partagerai le résultat en privé';

  @override
  String get groupManagedDialogGuardianOther => 'autre membre';

  @override
  String get groupManagedDialogGuardianSpecific => 'Responsable spécifique';

  @override
  String get groupManagedDialogGuardianComingSoon => 'Bientôt';

  @override
  String get groupManagedDialogDeliverySectionTitle =>
      'Comment allez-vous le leur apporter ?';

  @override
  String get groupManagedResponsibleUnavailable =>
      'Gestionnaire non disponible';

  @override
  String groupManagedDeliversResponsible(String name) {
    return 'Le gère :$name';
  }

  @override
  String get groupManagedDialogPickGuardianTitle => 'Qui va le livrer ?';

  @override
  String get groupManagedDialogGuardianOtherSubtitle =>
      'Ce membre verra le résultat et pourra vous le livrer en privé.';

  @override
  String get groupManagedDialogGuardianNoEligibleMembers =>
      'Lorsqu\'un autre membre disposant d\'une application rejoint, vous pouvez la lui attribuer.';

  @override
  String get groupManagedDialogPickMemberCta => 'Choisir un membre';

  @override
  String get groupManagedDialogSelectOtherFirst =>
      'Choisissez d\'abord un membre du groupe.';

  @override
  String get groupManagedDialogGuardianMustReassign =>
      'Ce membre n\'est plus actif dans le groupe. Choisissez un autre responsable ou « moi ».';

  @override
  String groupManagedDialogDeliversSummary(String name) {
    return 'Il délivre :$name';
  }

  @override
  String get groupParticipantsRegisteredTitle => 'Participants inscrits';

  @override
  String get groupParticipantsPendingTitle => 'Participants en attente';

  @override
  String get groupParticipantsPendingEmpty =>
      'Il n’y a aucun participant en attente.';

  @override
  String get groupPendingStatusLeft => 'a quitté le groupe';

  @override
  String get groupPendingStatusRemoved => 'Supprimé du groupe';

  @override
  String myAssignmentSubgroupLabel(String name) {
    return 'Sous-groupe :$name';
  }

  @override
  String managedSubgroupLabel(String name) {
    return 'Sous-groupe :$name';
  }

  @override
  String get managedYouManageIt => 'tu le gères';

  @override
  String managedDeliveryRecommendation(String mode) {
    return 'Livraison recommandée :$mode';
  }

  @override
  String get managedTypeManagedParticipant => 'Participant géré';

  @override
  String get managedDeliveryOwnerDelegated => 'Géré par le responsable';

  @override
  String get managedDeliveryModeWhatsapp => 'WhatsApp';

  @override
  String get managedDeliveryModeEmail => 'Mail';

  @override
  String get managedDeliveryModePdf => 'Imprimé / PDF';

  @override
  String get managedDeliveryCtaWhatsapp => 'Partager sur WhatsApp';

  @override
  String get managedDeliveryCtaEmail => 'Préparer le courrier';

  @override
  String get managedDeliveryCtaPdf => 'Générer un PDF';

  @override
  String get managedDeliveryVerbalBadge => 'livraison verbale';

  @override
  String get managedDeliveryPdfGenerating => 'Génération de PDF…';

  @override
  String get managedDeliveryWhatsappBrand => '🎁 Tarci Secret';

  @override
  String managedDeliveryWhatsappHello(String name) {
    return 'Bonjour,$name.';
  }

  @override
  String managedDeliveryWhatsappDrawLine(String groupName) {
    return 'L\'ami secret de «$groupName».';
  }

  @override
  String get managedDeliveryWhatsappGiftIntro =>
      'C\'est à votre tour de donner à :';

  @override
  String managedDeliveryWhatsappReceiverLine(String receiverName) {
    return '✨ $receiverName';
  }

  @override
  String managedDeliverySubgroupBelongsTo(String subgroup) {
    return 'Il appartient à :$subgroup';
  }

  @override
  String get managedDeliveryClosingSecret => 'Gardez le secret 🤫';

  @override
  String managedDeliveryEmailSubject(String groupName) {
    return 'Ton ami secret${groupName}c\'est prêt 🎁';
  }

  @override
  String managedDeliveryEmailGreeting(String name) {
    return 'Bonjour,$name:';
  }

  @override
  String managedDeliveryEmailLead(String groupName) {
    return 'Nous vous écrivons avec le résultat privé de l\'ami secret du groupe «$groupName».';
  }

  @override
  String get managedDeliveryEmailGiftLabel =>
      'La personne que vous devez donner est :';

  @override
  String managedDeliveryEmailReceiverLine(String receiverName) {
    return '$receiverName';
  }

  @override
  String managedDeliveryEmailSubgroupLine(String subgroup) {
    return 'Maison ou équipe :$subgroup';
  }

  @override
  String get managedDeliveryEmailClosing =>
      'Merci de garder ce résultat rien que pour vous. Personne d\'autre ne doit le voir.';

  @override
  String get managedDeliveryEmailSignoff => 'un câlin,\nTarci Secret';

  @override
  String get managedPdfDocTitle => 'ami secret';

  @override
  String get managedPdfHeadline => 'Votre ami secret est prêt';

  @override
  String get managedPdfForLabel => 'Pour';

  @override
  String get managedPdfGroupLabel => 'Grappe';

  @override
  String get managedPdfGiftHeading => 'Il faut donner à…';

  @override
  String get managedPdfFooterKeepSecret =>
      'Gardez le secret. Personne d\'autre ne doit le voir.';

  @override
  String get managedPdfFooterBrand => 'Généré avec Tarci Secret';

  @override
  String get managedDeliveryFallbackGroupName => 'votre groupe';

  @override
  String get managedDeliveryErrorMissingData =>
      'Il n\'y a pas suffisamment de données pour préparer le message.';

  @override
  String get managedDeliveryErrorWhatsapp =>
      'Nous n\'avons pas pu ouvrir WhatsApp. Vous pouvez partager le texte avec une autre application.';

  @override
  String get managedDeliveryErrorEmail =>
      'Nous ne trouvons pas d\'application de messagerie sur cet appareil.';

  @override
  String get managedDeliveryErrorPdf =>
      'Le PDF n\'a pas pu être généré. Essayer à nouveau.';

  @override
  String get managedDeliveryErrorShare =>
      'Impossible de partager. Essayer à nouveau.';

  @override
  String get managedDeliveryErrorGeneric =>
      'Quelque chose s\'est mal passé. Essayer à nouveau.';

  @override
  String get myAssignmentPrivateBadge => 'Privé · rien que pour vous';

  @override
  String get myAssignmentRevealLabel => 'Il faut donner à';

  @override
  String get myAssignmentEmotionalCopy => 'Faites-lui se sentir spécial.';

  @override
  String get myAssignmentPrivacyTitle => 'Toi seul vois ça';

  @override
  String get myAssignmentPrivacyBody =>
      'Gardez le secret jusqu\'au jour de l\'échange. Personne d’autre dans le groupe ne peut voir à qui revient le tour.';

  @override
  String get myAssignmentNoSubgroupChip => 'Aucun sous-groupe';

  @override
  String get groupCompletedHeroSubtitle =>
      'Chacun a déjà découvert à qui il doit donner.';

  @override
  String get groupCompletedPrivacyNote =>
      'Chaque résultat est privé. Seul chacun voit le sien.';

  @override
  String get groupCompletedManagedHint =>
      'Vous fournissez en privé les résultats des personnes que vous dirigez.';

  @override
  String get chatGroupSectionTitle => 'Conversation du groupe';

  @override
  String get chatGroupSectionSubtitle =>
      'Plaisante, partage des indices et garde l’ambiance vivante.';

  @override
  String get chatGroupEnterCta => 'Ouvrir le chat';

  @override
  String chatGroupEventLine(String date) {
    return 'Livraison:$date';
  }

  @override
  String get chatDrawCompletedChip => 'Tirage effectué';

  @override
  String get chatInputHint => 'Écris un message pour le groupe…';

  @override
  String get chatSendCta => 'Envoyer';

  @override
  String get chatTarciLabel => 'Tarci';

  @override
  String get chatEmptyTitle => 'Il n\'y a pas encore de messages';

  @override
  String get chatEmptyBody =>
      'Lorsque quelqu\'un écrit ou que Tarci rapporte quelque chose d\'important, vous le verrez ici.';

  @override
  String get chatLoadError =>
      'Nous n\'avons pas pu charger le chat. Veuillez vérifier votre connexion ou réessayer.';

  @override
  String get chatSendError =>
      'Le message n\'a pas pu être envoyé. Essayer à nouveau.';

  @override
  String get chatSystemGroupCreatedV1 =>
      '🎁 Le groupe est déjà en route. Laissez tomber les indices, renversez les haricots et laissez les potins sains rouler.';

  @override
  String get chatSystemDrawCompletedV1 =>
      '🤫 Concours terminé. Désormais, toute question bizarre compte comme une preuve.';

  @override
  String chatSystemUnknownTemplate(String templateKey) {
    return 'Message système ($templateKey)';
  }

  @override
  String get chatSystemAutoPlayful001V1 =>
      'L\'ambiance sent déjà le soupçon… et personne n\'a encore rien avoué.';

  @override
  String get chatSystemAutoPlayful002V1 =>
      'Depuis le tirage, chaque question innocente semble calculée.';

  @override
  String get chatSystemAutoPlayful003V1 =>
      'Conseil de Tarci : enquête avec subtilité, pas comme dans un interrogatoire.';

  @override
  String get chatSystemAutoPlayful004V1 =>
      'Certains ont déjà leur cadeau. D\'autres ont la foi.';

  @override
  String get chatSystemAutoPlayful005V1 =>
      'Si quelqu\'un demande tailles, couleurs et loisirs d\'un coup, prends note.';

  @override
  String get chatSystemAutoPlayful006V1 =>
      'Un bon cadeau surprend. Un grand cadeau laisse un souvenir.';

  @override
  String get chatSystemAutoPlayful007V1 =>
      'Les sourires suspects comptent comme des indices.';

  @override
  String get chatSystemAutoPlayful008V1 =>
      'Brouiller les pistes est permis. En faire trop, moins.';

  @override
  String get chatSystemAutoPlayful009V1 =>
      'Le silence de certains commence à ressembler à une stratégie.';

  @override
  String get chatSystemAutoPlayful010V1 =>
      'Si tu improvises, fais-le au moins avec attention.';

  @override
  String get chatSystemAutoPlayful011V1 =>
      'Tarci détecte une énergie de cadeau épique… et de panique élégante.';

  @override
  String get chatSystemAutoPlayful012V1 =>
      'Celui qui dit « c\'est déjà réglé » sans preuve éveille les soupçons.';

  @override
  String get chatSystemAutoPlayful013V1 =>
      'Petit rappel : le mystère fait aussi partie du plaisir.';

  @override
  String get chatSystemAutoPlayful014V1 =>
      'Chaque groupe a son détective. Vous savez déjà qui c\'est ?';

  @override
  String get chatSystemAutoPlayful015V1 =>
      'Une attention sincère vaut plus qu\'un cadeau sans âme.';

  @override
  String get chatSystemAutoPlayful016V1 =>
      'Ce chat est officiellement en mode soupçon.';

  @override
  String get chatSystemAutoPlayful017V1 =>
      'Si tu viens de chercher des idées en secret, personne ne juge.';

  @override
  String get chatSystemAutoPlayful018V1 =>
      'Certains regards dans la vraie vie veulent soudain dire beaucoup trop.';

  @override
  String get chatSystemAutoPlayful019V1 =>
      'Le but n\'est pas de dépenser plus. C\'est de mieux viser.';

  @override
  String get chatSystemAutoPlayful020V1 =>
      'Bien dissimuler fait aussi partie du jeu.';

  @override
  String get chatSystemAutoPlayful021V1 =>
      'Tarci parie que quelqu\'un ici a déjà un plan brillant.';

  @override
  String get chatSystemAutoDebate001V1 =>
      'Débat express : cadeau utile ou cadeau qui fait rire ?';

  @override
  String get chatSystemAutoDebate002V1 =>
      'Mieux vaut une surprise totale ou un indice bien utilisé ?';

  @override
  String get chatSystemAutoDebate003V1 =>
      'Qu\'est-ce qui l\'emporte : créativité ou précision ?';

  @override
  String get chatSystemAutoDebate004V1 =>
      'Débat ouvert : un emballage spectaculaire, ça compte ?';

  @override
  String get chatSystemAutoDebate005V1 =>
      'Enquête discrète ou liste d\'envies à la rescousse ?';

  @override
  String get chatSystemAutoDebate006V1 =>
      'Sans citer personne : qui dans ce groupe improvise à la dernière minute ?';

  @override
  String get chatSystemAutoDebate007V1 =>
      'Petit cadeau avec une histoire ou grand cadeau sans histoire ?';

  @override
  String get chatSystemAutoDebate008V1 =>
      'Brouiller les pistes dans le chat, fair-play ou déjà limite ?';

  @override
  String get chatSystemAutoDebate009V1 =>
      'Qu\'est-ce qui émeut le plus : viser juste ou surprendre ?';

  @override
  String get chatSystemAutoDebate010V1 =>
      'S\'il fallait choisir : pratique, drôle ou sentimental ?';

  @override
  String get chatSystemAutoWishlist001V1 =>
      'Certaines listes d\'envies sont encore vides. Un indice donné à temps peut sauver un cadeau.';

  @override
  String get chatSystemAutoWishlist002V1 =>
      'Ta liste d\'envies n\'enlève rien à la magie ; elle évite de deviner à l\'aveugle.';

  @override
  String get chatSystemAutoWishlist003V1 =>
      'Si tu veux qu\'on vise juste, laisse quelques idées.';

  @override
  String get chatSystemAutoWishlist004V1 =>
      'Quelqu\'un prépare un cadeau avec très peu d\'indices. Hum hum.';

  @override
  String get chatSystemAutoWishlist005V1 =>
      'Compléter sa liste aide sans trop en dévoiler.';

  @override
  String get chatSystemAutoWishlist006V1 =>
      'Un lien, un goût, un indice : tout aide.';

  @override
  String get chatSystemAutoWishlist007V1 =>
      'Même les meilleures surprises apprécient un peu d\'orientation.';

  @override
  String get chatSystemAutoWishlist008V1 =>
      'Si ta liste est vide, ton ami secret joue en mode difficile.';

  @override
  String get chatSystemAutoQuiet001V1 =>
      'C\'est bien silencieux ici… achats en cours ou preuves cachées ?';

  @override
  String get chatSystemAutoQuiet002V1 =>
      'Ce groupe est beaucoup trop calme. Quelqu\'un brise la glace.';

  @override
  String get chatSystemAutoQuiet003V1 =>
      'Tarci fait l\'appel : l\'ambiance est toujours là ?';

  @override
  String get chatSystemAutoQuiet004V1 =>
      'Question pour relancer : qui a l\'air le plus suspect aujourd\'hui ?';

  @override
  String get chatSystemAutoQuiet005V1 =>
      'Si personne n\'écrit, Tarci va commencer à inventer des théories.';

  @override
  String get chatSystemAutoQuiet006V1 =>
      'Chat endormi, mystère bien réveillé. Dites quelque chose.';

  @override
  String get chatSystemAutoCountdown014V1 =>
      'Il reste 14 jours. Il y a encore de la marge, mais les excuses s\'épuisent.';

  @override
  String get chatSystemAutoCountdown007V1 =>
      'Il reste 7 jours. Ceux qui n\'ont pas encore d\'idée passent officiellement en mode recherche sérieuse.';

  @override
  String get chatSystemAutoCountdown003V1 =>
      'Il reste 3 jours. Ce n\'est plus de l\'organisation : c\'est une opération sauvetage.';

  @override
  String get chatSystemAutoCountdown001V1 =>
      'Il reste 1 jour. Emballe, respire et fais comme si de rien n\'était.';

  @override
  String get chatSystemAutoCountdown000V1 =>
      'Aujourd\'hui, c\'est le jour de l\'échange. Place aux surprises, aux rires et à zéro aveu prématuré.';

  @override
  String get dynamicsHomePrimaryCta => 'Créer une dynamique';

  @override
  String get dynamicsSelectTitle => 'Choisissez une dynamique';

  @override
  String get dynamicsSelectSubtitle =>
      'Commencez avec une expérience prête aujourd\'hui. D\'autres modes arrivent bientôt.';

  @override
  String get dynamicsCardSecretSantaTitle => 'Secret Santa';

  @override
  String get dynamicsCardSecretSantaBody =>
      'Tirages privés, listes de souhaits et chat de groupe.';

  @override
  String get dynamicsCardRaffleTitle => 'Tirage au sort';

  @override
  String get dynamicsCardRaffleBody =>
      'Gagnants visibles pour tout le groupe. Pas de secrets ni de remises gérées.';

  @override
  String get dynamicsCardTeamsTitle => 'Équipes';

  @override
  String get dynamicsCardPairingsTitle => 'Appariements';

  @override
  String get dynamicsCardDuelsTitle => 'Duels';

  @override
  String get dynamicsComingSoonBadge => 'Bientôt';

  @override
  String get homeDynamicTypeSecretSanta => 'Secret Santa';

  @override
  String get homeDynamicTypeRaffle => 'Tirage au sort';

  @override
  String get homeRaffleStatePreparing => 'En préparation';

  @override
  String get homeRaffleStateCompleted => 'Tirage effectué';

  @override
  String get raffleWizardTitle => 'Nouveau tirage';

  @override
  String get raffleWizardNameLabel => 'Nom du tirage';

  @override
  String get raffleWizardWinnersLabel => 'Nombre de gagnants';

  @override
  String get raffleWizardOwnerParticipatesTitle => 'Vous participez ?';

  @override
  String get raffleWizardOwnerParticipatesYes => 'Oui, je suis dans le tirage';

  @override
  String get raffleWizardOwnerParticipatesNo => 'Non, j\'organise seulement';

  @override
  String get raffleWizardEventOptional => 'Date de l\'événement (facultatif)';

  @override
  String get raffleWizardReviewTitle => 'Vérification';

  @override
  String raffleWizardReviewWinners(int count) {
    return '$count gagnant(s)';
  }

  @override
  String get raffleWizardCreateCta => 'Créer le tirage';

  @override
  String get raffleDetailInviteSection => 'Invitation';

  @override
  String get raffleDetailAppMembersTitle => 'Participants avec l\'application';

  @override
  String get raffleDetailManualTitle => 'Participants sans application';

  @override
  String get raffleDetailAddManualCta => 'Ajouter une personne';

  @override
  String get raffleDetailRunRaffleCta => 'Lancer le tirage';

  @override
  String get raffleDetailWinnersTitle => 'Gagnants';

  @override
  String get raffleDetailShareCta => 'Partager le résultat';

  @override
  String get raffleDetailCompletedHint =>
      'Ce tirage est clos : vous ne pouvez pas modifier les participants ni relancer le tirage.';

  @override
  String get raffleManualEditTitle => 'Modifier le participant';

  @override
  String get raffleManualDisplayNameLabel => 'Nom affiché';

  @override
  String raffleShareBody(String raffleName, String winners) {
    return 'Nous avons des gagnants pour « $raffleName » :\n$winners\n\nRéalisé avec Tarci Secret.';
  }

  @override
  String get functionsErrorRaffleResolvedInvitesClosed =>
      'Ce tirage a déjà eu lieu et n\'accepte plus de nouveaux participants.';

  @override
  String get functionsErrorRaffleInProgress =>
      'Le tirage est en cours. Réessayez dans quelques secondes.';

  @override
  String get functionsErrorRaffleRotateLocked =>
      'Impossible de faire tourner le code lorsque le tirage n\'accepte plus de modifications.';

  @override
  String get functionsErrorRaffleAlreadyCompleted =>
      'Ce tirage est déjà terminé.';

  @override
  String get functionsErrorRaffleTooManyWinners =>
      'Il y a plus de gagnants que de participants éligibles.';

  @override
  String get functionsErrorRaffleInsufficientParticipants =>
      'Il n\'y a pas assez de participants pour ce tirage.';

  @override
  String get functionsErrorRaffleInvalidDynamic =>
      'Cette action n\'est pas disponible pour ce type de groupe.';

  @override
  String get functionsErrorChatNotAvailableForRaffle =>
      'Le chat de groupe n\'est pas disponible pour les tirages publics.';

  @override
  String get functionsErrorWishlistNotAvailableForRaffle =>
      'Les listes de souhaits ne sont pas disponibles pour les tirages.';

  @override
  String get functionsErrorManagedParticipantsNotForRaffle =>
      'Les participants gérés du Secret Santa ne s\'appliquent pas aux tirages.';

  @override
  String get functionsErrorDrawNotForRaffle =>
      'Le tirage Secret Santa n\'est pas disponible pour les groupes de type tirage au sort.';

  @override
  String get functionsErrorAssignmentsNotForRaffle =>
      'Les attributions secrètes ne s\'appliquent pas à ce groupe.';

  @override
  String raffleDetailEligibleCount(int count) {
    return 'Participants éligibles : $count';
  }

  @override
  String get raffleWizardPickEventDate => 'Choisir la date';

  @override
  String get functionsErrorDrawNotSupportedForDynamic =>
      'Le tirage Secret Santa n\'est pas disponible pour ce type de groupe.';

  @override
  String get functionsErrorRaffleEditLocked =>
      'Ce tirage ne permet plus de modifier les participants.';

  @override
  String get raffleDetailMinPoolHint =>
      'Il faut au moins 2 participants dans le tirage pour lancer le tirage au sort.';

  @override
  String get raffleResultHeroTitle => 'Tirage effectué !';

  @override
  String get raffleResultHeroSubtitle => 'Nous avons le résultat.';

  @override
  String raffleResultSingleWinner(String name) {
    return 'Gagnant : $name';
  }

  @override
  String raffleResultMultipleWinners(String names) {
    return 'Gagnants : $names';
  }

  @override
  String get raffleWizardOwnerNicknameLabel => 'Ton nom dans le tirage';

  @override
  String get raffleWizardOwnerNicknameHelper =>
      'Les autres te verront ainsi. Utilise un surnom, pas ton rôle d’organisateur.';

  @override
  String get raffleOwnerParticipantFallback => 'Participant';

  @override
  String get raffleMemberDefaultName => 'Participant';

  @override
  String get raffleDetailStatsWinners => 'Nombre de gagnants';

  @override
  String get raffleDetailInPool => 'Dans le tirage';
}
