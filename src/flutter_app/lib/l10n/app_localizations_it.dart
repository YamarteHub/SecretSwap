// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Tarci Secret';

  @override
  String get retry => 'Riprova';

  @override
  String get back => 'Indietro';

  @override
  String get next => 'Seguente';

  @override
  String get create => 'Creare';

  @override
  String get close => 'Vicino';

  @override
  String get save => 'Mantenere';

  @override
  String get goToGroup => 'Vai al gruppo';

  @override
  String get copyCode => 'Copia il codice';

  @override
  String get codeCopied => 'Codice copiato';

  @override
  String get joinWithCode => 'Partecipa con il codice';

  @override
  String get joinScreenTitle => 'Partecipa con il codice';

  @override
  String get joinScreenHeroTitle => 'Incolla il tuo codice di invito';

  @override
  String get joinScreenHeroSubtitle =>
      'Il tuo organizzatore lo ha condiviso con te tramite messaggio. Quando lo inserisci, ti uniremo al loro gruppo.';

  @override
  String get joinScreenCodeLabel => 'codice di invito';

  @override
  String get joinScreenCodeHint => 'Ad esempio, AB12CD';

  @override
  String get joinScreenCodeHelper =>
      'Le maiuscole non hanno importanza, le aggiusteremo per te.';

  @override
  String get joinScreenCodeRequired =>
      'Incolla o digita il codice che hai ricevuto.';

  @override
  String get joinScreenCodeTooShort =>
      'Quel codice sembra incompleto. Controllalo e riprova.';

  @override
  String get joinScreenNicknameLabel => 'il tuo nome';

  @override
  String get joinScreenNicknameHelper => 'Ecco come ti vedrà il gruppo.';

  @override
  String get joinScreenNicknameRequired =>
      'Dicci il tuo nome per presentarti al gruppo.';

  @override
  String get joinScreenNicknameTooShort =>
      'Inserisci almeno 3 lettere in modo che il gruppo ti riconosca.';

  @override
  String get joinScreenCta => 'Unisciti al gruppo';

  @override
  String get joinScreenCtaLoading => 'Mi unisco a te...';

  @override
  String get joinScreenSuccessSnackbar => 'Ci sei!';

  @override
  String get joinSuccessTitle => 'Sei già dentro!';

  @override
  String joinSuccessSubtitle(String groupName) {
    return 'ti sei iscritto$groupName. Tra un attimo potrai vedere il resto del gruppo.';
  }

  @override
  String get joinSuccessChooseSubgroupTitle => 'Scegli la tua casa o squadra';

  @override
  String get joinSuccessChooseSubgroupHelp =>
      'L\'organizzatore ha creato case o squadre. Scegli il tuo in modo che il sorteggio ti posizioni bene.';

  @override
  String get joinSuccessSubgroupLabel => 'La tua casa o la tua squadra';

  @override
  String get joinSuccessNoSubgroupsTitle => 'Ancora nessuna casa o squadra';

  @override
  String get joinSuccessNoSubgroupsHelp =>
      'L\'organizzatore non li ha ancora creati. Puoi andare avanti e aspettare; Non devi fare nient\'altro per ora.';

  @override
  String get joinSuccessChooseRequired => 'Scegli un\'opzione per continuare.';

  @override
  String get joinSuccessPrimaryCta => 'Vai al gruppo';

  @override
  String get joinSuccessSecondaryCta => 'rimani qui';

  @override
  String joinSuccessRaffleSubtitle(String groupName) {
    return 'Sei entrato in $groupName. Quando l’organizzatore farà l’estrazione, potrai vedere il risultato qui.';
  }

  @override
  String get joinSuccessRaffleBody =>
      'Nel frattempo puoi vedere chi partecipa e attendere il momento dell’estrazione.';

  @override
  String get joinSuccessRafflePrimaryCta => 'Vai al sorteggio';

  @override
  String get createSecretFriend => 'Crea un amico segreto';

  @override
  String get mySecretFriend => 'il mio amico segreto';

  @override
  String get yourSecretFriendIs => 'Il tuo amico segreto è...';

  @override
  String get onlyYouCanSeeAssignment => 'Solo tu puoi vedere questo compito.';

  @override
  String get keepSecretUntilExchangeDay =>
      'Mantieni il segreto fino al giorno dello scambio.';

  @override
  String get managedSecrets => 'Segreti che gestisci';

  @override
  String get guardianOfSecret => 'Custode del segreto';

  @override
  String get privateResult => 'Risultato privato';

  @override
  String get splashTagline =>
      'Tarci Secret organizza dinamiche di gruppo private con persone reali.';

  @override
  String get splashLoadingHint => 'Preparando tutto per te...';

  @override
  String get splashBootBrandedHint => 'Prepariamo il tuo spazio…';

  @override
  String get productAuthorshipLine => 'Tarci Secret · © 2026 Stalin Yamarte';

  @override
  String get aboutScreenTitle => 'Informazioni su Tarci Secret';

  @override
  String get aboutTooltip => 'Informazioni su Tarci Secret';

  @override
  String get aboutTagline =>
      'Dinamiche di gruppo, estrazioni ed esperienze sociali con privacy, emozione e persone reali.';

  @override
  String get aboutSectionWhatTitle => 'Cos’è Tarci Secret';

  @override
  String get aboutSectionWhatBody =>
      'Tarci Secret è un’app social per organizzare dinamiche di gruppo in modo semplice, privato e divertente. Permette di creare amico segreto, fare estrazioni, formare squadre e includere persone con app, senza app o gestite da un altro partecipante.\n\nNasce intorno all’amico segreto come esperienza fondativa, ma evolve come spazio per creare incontri, sfide e dinamiche sociali con emozione, chiarezza e persone reali.';

  @override
  String get aboutSectionHowTitle => 'Come funziona';

  @override
  String get aboutStep1Title => 'Crea o unisciti a un gruppo';

  @override
  String get aboutStep1Body =>
      'Avvia una dinamica o entra con un codice d’invito.';

  @override
  String get aboutStep2Title => 'Organizza partecipanti e regole';

  @override
  String get aboutStep2Body =>
      'Aggiungi persone con app o gestite e regola il flusso necessario.';

  @override
  String get aboutStep3Title => 'Avvia la dinamica';

  @override
  String get aboutStep3Body =>
      'Esegui l’estrazione, forma le squadre o completa l’esperienza quando tutto è pronto.';

  @override
  String get aboutStep4Title => 'Scopri, chatta e divertiti';

  @override
  String get aboutStep4Body =>
      'Ogni dinamica mostra il risultato in modo chiaro e permette di vivere meglio l’esperienza del gruppo.';

  @override
  String get aboutSectionPrivacyTitle => 'Privacy by design';

  @override
  String get aboutSectionPrivacyBody =>
      'Ogni dinamica mostra solo ciò che corrisponde. Le assegnazioni private restano protette, i risultati pubblici si condividono solo con il gruppo e Tarci evita di esporre informazioni non necessarie.';

  @override
  String get aboutSectionPrivacyTrust =>
      'La privacy non è un extra: fa parte del design dell’esperienza.';

  @override
  String get aboutSectionCreatorTitle => 'Creato da Stalin Yamarte';

  @override
  String get aboutSectionCreatorSubtitle =>
      'Specialista in sistemi e sviluppatore di applicazioni.';

  @override
  String get aboutLinkedInCta => 'Vedi il profilo LinkedIn';

  @override
  String get aboutLinkedInError =>
      'Non siamo riusciti ad aprire LinkedIn. Riprova dal browser.';

  @override
  String get aboutAppInfoTitle => 'Informazioni sull\'app';

  @override
  String get aboutCopyrightLine => '© 2026 Stalin Yamarte';

  @override
  String get aboutPackageInfoError =>
      'Impossibile leggere la versione dell\'app.';

  @override
  String aboutBuildLine(String buildNumber) {
    return 'Build interno $buildNumber';
  }

  @override
  String get quickModeTitle => 'Modalità veloce';

  @override
  String get quickModeDescription =>
      'Puoi iniziare senza registrarti. Per mantenere i tuoi gruppi su più dispositivi, puoi creare un account in un secondo momento.';

  @override
  String get homeHeaderSubtitle =>
      'Organizza amico segreto, estrazioni e squadre con privacy, emozione e semplicità.';

  @override
  String get homeHeroHeadline => 'Dinamiche sociali per gruppi reali';

  @override
  String get homeGroupDrawStatePreparing => 'Preparazione';

  @override
  String get homeGroupDrawStateReady => 'Pronto per disegnare';

  @override
  String get homeGroupDrawStateDrawing => 'Lotteria in corso';

  @override
  String get homeGroupDrawStateCompleted => 'Disegnato';

  @override
  String get homeGroupDrawStateFailed => 'Rivedi il sorteggio';

  @override
  String get wizardCreateTitle => 'Crea un amico segreto';

  @override
  String wizardStepOf(int current, int total) {
    return 'Superato${current}Di$total';
  }

  @override
  String get wizardStepNameTitle => 'Come si chiama questo amico segreto?';

  @override
  String get wizardStepGroupTypeTitle => 'Che tipo di gruppo è?';

  @override
  String get wizardStepModeTitle => 'Come sarà organizzato?';

  @override
  String get wizardStepRuleTitle => 'Scegli la regola del pareggio';

  @override
  String get wizardStepSubgroupsTitle => 'Sottogruppi';

  @override
  String get wizardStepParticipantsTitle => 'Partecipanti';

  @override
  String get wizardStepEventDateTitle => 'Quando avviene lo scambio?';

  @override
  String get wizardStepEventDateHelp =>
      'È facoltativo. Ci aiuterà a ricordare la consegna e a spostare il gruppo nella cronologia quando avviene.';

  @override
  String get wizardSummaryEventDate => 'Data dell\'evento';

  @override
  String get wizardEventDateNotSet => 'Indefinito';

  @override
  String get wizardEventDateClear => 'Rimuovi la data';

  @override
  String get wizardStepReviewTitle => 'Revisione finale';

  @override
  String get wizardGroupNameLabel => 'Nome del gruppo';

  @override
  String get wizardGroupNameHint => 'Natale in famiglia 2026';

  @override
  String get wizardNicknameLabel => 'Come appari?';

  @override
  String get wizardRuleIgnore => 'Ignora i sottogruppi';

  @override
  String get wizardRulePrefer => 'Preferisci sottogruppi diversi';

  @override
  String get wizardRuleRequire => 'Richiedono sottogruppi diversi';

  @override
  String get wizardRuleIgnoreDesc => 'Pareggio normale.';

  @override
  String get wizardRulePreferDesc =>
      'Prova ad attraversare case, appartamenti o gruppi.';

  @override
  String get wizardRuleRequireDesc =>
      'Consenti solo persone appartenenti a sottogruppi diversi.';

  @override
  String get wizardReviewSaveNotice =>
      'Puoi modificare i partecipanti e i sottogruppi in un secondo momento.';

  @override
  String get wizardReviewSummaryHelp =>
      'Controlla che tutto sia corretto prima di continuare.';

  @override
  String get wizardCreateButton => 'Crea un amico segreto';

  @override
  String get wizardCreatedTitle => 'Amico segreto creato';

  @override
  String get wizardInviteCodeLabel => 'codice di invito';

  @override
  String get wizardInviteCodeDescription =>
      'Condividi questo codice in modo che altre persone possano partecipare.';

  @override
  String get managedSubtitle =>
      'Questi risultati provengono da persone che dipendono da te. Consegnaglieli in privato.';

  @override
  String get managedEmptyTitle => 'Non hai gestito i segreti';

  @override
  String get managedEmptyMessage =>
      'Quando gestisci un bambino o una persona senza un\'app, vedrai i suoi risultati qui.';

  @override
  String get managedLoadErrorTitle =>
      'Non è stato possibile caricare i tuoi segreti gestiti';

  @override
  String get managedLoadErrorMessage =>
      'Riprova tra qualche minuto. Vedrai solo i risultati delle persone che gestisci.';

  @override
  String get managedAssignedTo => 'È il tuo turno di dare...';

  @override
  String get managedDeliverInPrivate => 'Consegna questo risultato in privato';

  @override
  String get managedHeroTitle => 'Segreti a tua disposizione';

  @override
  String get managedHeroSubtitle =>
      'Fornisci questi risultati in privato, senza che nessun altro lo scopra.';

  @override
  String get wishlistGroupMyCardTitle => 'La tua lista dei desideri';

  @override
  String get wishlistGroupMyCardSubtitle =>
      'Lo completi; Solo chi toccherà a te donarlo lo vedrà.';

  @override
  String get wishlistGroupMyCardCtaFill => 'Completa la mia lista';

  @override
  String get wishlistGroupMyCardCtaEdit => 'Modifica la mia lista';

  @override
  String get wishlistGroupMyEmptyHint => 'Non hai ancora aggiunto idee.';

  @override
  String get wishlistGroupMyReadyChip => 'Lista pronta';

  @override
  String get wishlistGroupManagedSectionTitle => 'Elenchi che gestisci';

  @override
  String get wishlistGroupManagedSectionSubtitle =>
      'Aiutaci a compilarli; Chi li regala li vedrà sul proprio schermo.';

  @override
  String get wishlistGroupManagedRowCta => 'Modifica elenco';

  @override
  String get wishlistGroupPostDrawIntro =>
      'Ora che la lotteria è terminata, alcuni indizi chiari ti aiuteranno a ottenere il regalo giusto.';

  @override
  String get wishlistEditorTitle => 'Lista dei desideri';

  @override
  String get wishlistViewTitle => 'Idee regalo';

  @override
  String get wishlistEditorIntro =>
      'Scrivi con affetto ciò che saresti entusiasta di ricevere. Solo chi toccherà a te donare (e a te) lo vedrà.';

  @override
  String get wishlistViewIntro =>
      'Queste idee servono solo per aiutare con il regalo. Rispetta il segreto del sorteggio.';

  @override
  String get wishlistFieldWishTitle => 'sarei emozionato...';

  @override
  String get wishlistFieldWishHint =>
      'Idee regalo specifiche, dimensioni o dettagli che desideri.';

  @override
  String get wishlistFieldLikesTitle => 'Mi piace…';

  @override
  String get wishlistFieldLikesHint => 'Hobby, colori, stili o cose che ami.';

  @override
  String get wishlistFieldAvoidTitle => 'Meglio evitare...';

  @override
  String get wishlistFieldAvoidHint =>
      'Cose che preferisci non ricevere o che già hai.';

  @override
  String get wishlistFieldLinksTitle => 'Collegamenti di ispirazione';

  @override
  String wishlistLinksHelp(int max) {
    return 'Fino a${max}collegamenti con http o https.';
  }

  @override
  String get wishlistAddLinkCta => 'Aggiungi collegamento';

  @override
  String get wishlistLinkLabelOptional => 'Etichetta (facoltativa)';

  @override
  String get wishlistLinkUrlLabel => 'URL';

  @override
  String get wishlistUrlHint => 'https://…';

  @override
  String wishlistLinkRowTitle(int index) {
    return 'Collegamento$index';
  }

  @override
  String get wishlistSaveCta => 'Mantenere';

  @override
  String get wishlistCancelCta => 'Ritorno';

  @override
  String get wishlistSaveSuccess => 'Elenco salvato.';

  @override
  String get wishlistUrlInvalid =>
      'Controlla gli URL: devono iniziare con http:// o https://';

  @override
  String wishlistLinksMax(int max) {
    return 'Al massimo${max}collegamenti.';
  }

  @override
  String wishlistMyAssignmentReceiverWishlistHeading(String receiverName) {
    return 'Cosa vorresti ricevere?$receiverName';
  }

  @override
  String get wishlistMyAssignmentReceiverNameFallback => 'il tuo destinatario';

  @override
  String get wishlistMyAssignmentSectionSubtitle =>
      'Solo tu lo vedi. Serve ad ispirarti quando scegli un dettaglio con amore.';

  @override
  String get wishlistMyAssignmentViewCta => 'Vedi le idee regalo';

  @override
  String get wishlistManagedViewReceiverCta =>
      'Visualizza la lista dei desideri';

  @override
  String get wishlistManagedViewReceiverHint =>
      'Vedi solo le idee di questa persona per questo segreto.';

  @override
  String get wishlistEmptyReceiverTitle => 'Nessuna idea regalo rimasta ancora';

  @override
  String get wishlistEmptyReceiverBody =>
      'Forse li aggiungerò più tardi. Un dettaglio fatto con amore conta sempre!';

  @override
  String get wishlistLinkOpenError => 'Impossibile aprire il collegamento.';

  @override
  String get wishlistReadonlySheetTitle => 'Idee regalo';

  @override
  String get managedRevealLabel => 'Il tuo amico segreto lo è';

  @override
  String get managedDeliveryChipLabel => 'Consegna';

  @override
  String get managedFooterPrivacyNote =>
      'Ogni segreto è privato. Solo tu puoi vederlo e solo tu lo consegni.';

  @override
  String get myAssignmentNotAvailableTitle =>
      'Non riesci ancora a vedere il tuo amico segreto';

  @override
  String get myAssignmentNotAvailableMessage =>
      'Il tuo compito non è ancora disponibile. Una volta completato il giveaway, potrai vederlo qui.';

  @override
  String get genericLoadErrorMessage =>
      'Non è stato possibile caricare queste informazioni in questo momento.';

  @override
  String get backToGroup => 'Ritorno al gruppo';

  @override
  String get groupDetailTitle => 'Particolare del gruppo';

  @override
  String get groupRoleLabel => 'Ruolo';

  @override
  String get groupStatusLabel => 'Stato';

  @override
  String get groupLastExecution => 'Scorso';

  @override
  String get groupSectionStatus => 'Stato del gruppo';

  @override
  String get groupSectionPrimaryAction => 'azione principale';

  @override
  String get groupSectionDrawRule => 'Disegna la regola';

  @override
  String get groupSectionSubgroups => 'Sottogruppi';

  @override
  String get groupSectionParticipants => 'Partecipanti';

  @override
  String get groupSectionManagedParticipants => 'Partecipanti senza app';

  @override
  String get groupSectionInvitations => 'Inviti';

  @override
  String get groupSectionAdvanced => 'Impostazioni avanzate';

  @override
  String get groupStatusPreparing => 'Segui la preparazione';

  @override
  String get groupStatusReadyToDraw => 'Pronto per disegnare';

  @override
  String get groupStatusCompleted =>
      'I tuoi amici segreti sono già stati scelti!';

  @override
  String get groupStatusMissingSubgroups =>
      'Devi inserire qualcuno nel tuo gruppo';

  @override
  String get groupActionRunDraw => 'Fai il sorteggio adesso';

  @override
  String get groupActionViewMySecretFriend => 'Vedi il mio amico segreto';

  @override
  String get groupActionManagedSecrets => 'Segreti che gestisci';

  @override
  String get groupActionCreateSubgroup => 'Crea sottogruppo';

  @override
  String get groupActionEmptySubgroup => 'Sottogruppo vuoto';

  @override
  String get groupActionDeleteSubgroup => 'Elimina sottogruppo';

  @override
  String get groupActionGenerateNewCode => 'Genera nuovo codice';

  @override
  String get groupActionCopyCode => 'Copia il codice';

  @override
  String get groupActionRename => 'Rinominare';

  @override
  String get groupActionEdit => 'Modificare';

  @override
  String get groupRoleOrganizer => 'Organizzatore';

  @override
  String get groupRoleParticipant => 'Partecipante';

  @override
  String get groupTypeAdultNoApp => 'Adulto senza app';

  @override
  String get groupTypeChildManaged => 'bambino gestito';

  @override
  String get groupNoSubgroupAssigned => 'Nessun sottogruppo assegnato';

  @override
  String get groupGuardianOfSecret => 'Custode del segreto';

  @override
  String get groupPrivateResult => 'Risultato privato';

  @override
  String get groupWarningMissingSubgroupTitle =>
      'Mancano persone da assegnare a un sottogruppo.';

  @override
  String get groupWarningMissingSubgroupRule =>
      'Per richiedere un sottogruppo diverso, tutti devono averne uno.';

  @override
  String get groupWarningMissingSubgroupCombined =>
      'Mancano persone da assegnare a un sottogruppo. Per richiedere un sottogruppo diverso, tutti devono averne uno.';

  @override
  String get groupDialogDeleteSubgroupTitle => 'Elimina sottogruppo';

  @override
  String groupDialogDeleteSubgroupBody(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"? Verrà eliminato solo se non sono stati assegnati partecipanti.';
  }

  @override
  String groupDialogEmptySubgroupTitle(String name) {
    return 'Vuoto \"$name\"';
  }

  @override
  String get groupDialogCancel => 'Cancellare';

  @override
  String get groupDialogDelete => 'Eliminare';

  @override
  String get groupDialogEmpty => 'Vuoto';

  @override
  String get groupDialogMoveAndDelete => 'Sposta ed elimina';

  @override
  String get groupDialogMoveToSubgroup => 'Passare a un altro sottogruppo';

  @override
  String get groupDialogBeforeDeleteMoveTo => 'Prima di eliminare, spostati in';

  @override
  String get groupDialogLeaveWithoutSubgroup => 'Lasciare senza sottogruppo';

  @override
  String get groupDialogNoAlternativeSubgroup =>
      'Nessun altro sottogruppo disponibile. Rimarranno senza un sottogruppo.';

  @override
  String get groupManagedDialogAddTitle => 'Aggiungi partecipante senza app';

  @override
  String get groupManagedDialogEditTitle => 'Modifica partecipante senza app';

  @override
  String get groupManagedDialogNameLabel => 'Nome';

  @override
  String get groupManagedDialogTypeLabel => 'Tipo';

  @override
  String get groupManagedDialogTypeAdultNoApp => 'Adulto senza app';

  @override
  String get groupManagedDialogTypeChild => 'bambino gestito';

  @override
  String get groupManagedDialogSubgroupOptionalLabel =>
      'Sottogruppo (facoltativo)';

  @override
  String get groupManagedDialogNoSubgroup => 'Nessun sottogruppo';

  @override
  String get groupManagedDialogDeliveryLabel => 'Metodo di consegna';

  @override
  String get groupManagedDialogDeliveryVerbal => 'Verbale';

  @override
  String get groupManagedDialogDeliveryEmail => 'Posta';

  @override
  String get groupManagedDialogDeliveryWhatsapp => 'Whatsapp';

  @override
  String get groupManagedDialogDeliveryPrinted => 'Stampato/PDF';

  @override
  String get groupManagedDialogWhoManagesTitle =>
      'Chi ne gestirà il risultato?';

  @override
  String get groupManagedDialogWhoManagesDesc =>
      'Scegli chi vedrà il risultato nell\'app in modo da poterlo consegnare in privato.';

  @override
  String get groupManagedDialogWhoManagesHelp =>
      'Quando si unisce all\'estrazione, questa persona non vedrà il risultato nell\'app. Puoi consegnarlo verbalmente o in formato cartaceo.';

  @override
  String groupManagedDialogManagedBy(String name) {
    return 'Gestito da:$name';
  }

  @override
  String get groupAssignDialogSelfTitle => 'Il tuo sottogruppo';

  @override
  String get groupAssignDialogTitle => 'Assegna sottogruppo';

  @override
  String get groupAssignDialogSelfDesc =>
      'Scegli la tua casa, appartamento, classe o squadra.';

  @override
  String get groupAssignDialogDesc =>
      'Seleziona il sottogruppo per questo membro.';

  @override
  String get groupAssignDialogSubgroupLabel => 'Sottogruppo';

  @override
  String get groupSnackbarWriteName => 'Scrivi un nome';

  @override
  String get groupSnackbarDrawCompleted => 'Omaggio completato';

  @override
  String get groupSnackbarSubgroupUpdated => 'Sottogruppo aggiornato';

  @override
  String get groupSnackbarGroupNameUpdated => 'Nome del gruppo aggiornato';

  @override
  String get groupSnackbarRuleUpdated => 'Regola di sorteggio aggiornata';

  @override
  String get groupSnackbarNewCodeGenerated => 'Nuovo codice generato';

  @override
  String get groupSnackbarManagedAdded => 'Partecipante senza app aggiunta';

  @override
  String get groupSnackbarManagedUpdated => 'Partecipante senza app aggiornata';

  @override
  String get groupSnackbarManagedDeleted => 'Partecipante senza app eliminato';

  @override
  String get groupDialogEditGroupNameTitle => 'Modifica il nome del gruppo';

  @override
  String get groupDialogGroupNameLabel => 'Nome del gruppo';

  @override
  String get groupDialogRenameSubgroupTitle => 'Rinominare il sottogruppo';

  @override
  String get groupDialogSubgroupNameLabel => 'Nome del sottogruppo';

  @override
  String get groupDialogDeleteParticipantTitle => 'Elimina partecipante';

  @override
  String groupDialogDeleteParticipantBody(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"?';
  }

  @override
  String groupDialogSubgroupAssignedCount(int count) {
    return 'C\'è${count}partecipanti assegnati a questo sottogruppo.';
  }

  @override
  String groupDialogSubgroupAssignedCountDelete(int count) {
    return 'Questo sottogruppo ha${count}partecipanti assegnati.';
  }

  @override
  String get languageSystem => 'Sistema';

  @override
  String get languageSpanish => 'spagnolo';

  @override
  String get languageEnglish => 'Inglese';

  @override
  String get languageSelectorTitle => 'Lingua';

  @override
  String get languageSelectorSubtitle =>
      'Scegli come desideri visualizzare l\'app';

  @override
  String get languagePortuguese => 'portoghese';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageFrench => 'francese';

  @override
  String get functionsErrorAlreadyMember => 'Appartieni già a questo gruppo.';

  @override
  String get functionsErrorCodeNotFound =>
      'Non abbiamo trovato un gruppo con quel codice.';

  @override
  String get functionsErrorCodeExpired => 'Questo codice è scaduto.';

  @override
  String get functionsErrorGroupArchived => 'Questo gruppo è ora chiuso.';

  @override
  String get functionsErrorUserRemoved =>
      'Non puoi unirti nuovamente a questo gruppo.';

  @override
  String get functionsErrorDrawInProgress =>
      'Il sorteggio è in corso. Per favore riprova più tardi.';

  @override
  String get functionsErrorDrawAlreadyCompleted =>
      'Questo giveaway era già stato completato.';

  @override
  String get functionsErrorDrawCompletedInvitesClosed =>
      'Questo sorteggio è già stato effettuato e non accetta più nuovi partecipanti.';

  @override
  String get functionsErrorSubgroupInUse =>
      'Prima di eliminare questo sottogruppo, sposta o lascia i suoi partecipanti senza un sottogruppo.';

  @override
  String get functionsErrorSubgroupNotFound =>
      'Il sottogruppo non esiste più o è stato eliminato.';

  @override
  String get functionsErrorNotOwner =>
      'Solo l\'organizzatore può eseguire questa azione.';

  @override
  String get functionsErrorGroupDeleteForbidden =>
      'Solo l\'organizzatore può eliminare questo gruppo.';

  @override
  String get functionsErrorGroupDeleteFailed =>
      'Non siamo riusciti a eliminare completamente il gruppo. Riprova o controlla la connessione.';

  @override
  String get functionsErrorDrawLocked =>
      'Non è possibile modificare sottogruppi o partecipanti mentre l\'estrazione è in corso o completata.';

  @override
  String get functionsErrorGenericAction =>
      'Impossibile completare l\'azione. Per favore riprova tra poco.';

  @override
  String get functionsErrorPermissionDeniedDrawRule =>
      'La regola del pareggio non può essere modificata. Controlla che l\'estrazione non sia in corso o completata.';

  @override
  String get functionsErrorUnknown =>
      'Qualcosa è andato storto. Per favore riprova tra qualche istante.';

  @override
  String get functionsErrorDebugSession =>
      'Impossibile completare l\'azione. Controlla se stai utilizzando emulatori o Firebase reale, se le funzioni sono implementate e se la sessione è attiva.';

  @override
  String get homePrimaryActionsTitle => 'Azioni principali';

  @override
  String get homeChipDraws => 'Omaggi';

  @override
  String get homeChipTeams => 'Squadre';

  @override
  String get homeChipPairings => 'Abbinamenti';

  @override
  String get homeActiveGroupsTitle => 'In corso';

  @override
  String get homeActiveGroupsSubtitle =>
      'In attesa di preparazione o sorteggio; ovvero sorteggio effettuato con consegna odierna o futura, oppure senza data di consegna definita.';

  @override
  String get homeActiveGroupsEmpty => 'Non hai gruppi in questa sezione.';

  @override
  String homeDeliveryDateLine(String date) {
    return 'Consegna:$date';
  }

  @override
  String homeDrawDateLine(String date) {
    return 'Lotteria:$date';
  }

  @override
  String get homeEmptyGroupsTitle => 'Non hai ancora gruppi';

  @override
  String get homeEmptyGroupsMessage =>
      'Crea il tuo primo amico segreto o iscriviti con un codice.';

  @override
  String get homeStatusActive => 'Risorsa';

  @override
  String get homeStatusInactive => 'Oziare';

  @override
  String get homeCompletedGroupsTitle => 'Sorteggi definitivi';

  @override
  String get homeCompletedGroupsSubtitle =>
      'Sorteggio effettuato e data di consegna già trascorsa.';

  @override
  String get homePastGroupsTitle => 'Gruppi precedenti';

  @override
  String get homePastGroupsSubtitle =>
      'Non sei più attivamente coinvolto in questi gruppi.';

  @override
  String get homeCompletedArchivedLabel => 'Completato/archiviato';

  @override
  String get homeDebugToolsTitle => 'Strumenti di sviluppo';

  @override
  String homeDebugUid(String uid) {
    return 'UID di prova:$uid';
  }

  @override
  String get homeDebugUserSwitchHint =>
      'La modifica degli utenti di prova ti farà vedere altri gruppi, perché ogni utente ha il proprio elenco.';

  @override
  String get homeDebugResetUser => 'Esci e crea un nuovo utente di prova';

  @override
  String get homeEnvironmentEmulator => 'Ambiente: emulatore locale';

  @override
  String get homeEnvironmentFirebase => 'Ambiente: sviluppo reale di Firebase';

  @override
  String get homePrivacyFooter =>
      'Il tuo compito e i risultati vengono mantenuti privati ​​per impostazione predefinita.';

  @override
  String get wizardTypeFamily => 'Famiglia';

  @override
  String get wizardTypeFriends => 'Amici';

  @override
  String get wizardTypeCompany => 'Azienda';

  @override
  String get wizardTypeClass => 'Classe';

  @override
  String get wizardTypeOther => 'Altro';

  @override
  String get wizardModeInPerson => 'Di persona';

  @override
  String get wizardModeRemote => 'Remoto';

  @override
  String get wizardModeMixed => 'Misto';

  @override
  String get wizardCreateFunctionsError =>
      'Impossibile creare il gruppo. Controlla se stai utilizzando emulatori o Firebase reale e se le funzioni sono distribuite.';

  @override
  String get wizardNameHelp => 'Dare un nome che identifichi il gruppo.';

  @override
  String get wizardGroupTypeHelp =>
      'Queste informazioni guidano l\'esperienza. Per ora non è salvato.';

  @override
  String get wizardModeHelp =>
      'Definire come sarà organizzato il gruppo. Per ora è la preparazione UX.';

  @override
  String get wizardRuleHelp =>
      'Questa configurazione viene salvata nel gruppo.';

  @override
  String get wizardSubgroupsHelpIgnore =>
      'Con questa regola non hai più bisogno dei sottogruppi.';

  @override
  String get wizardSubgroupsHelpEnabled =>
      'Potrai creare e assegnare sottogruppi dai dettagli del gruppo.';

  @override
  String get wizardParticipantsHelp =>
      'Quindi puoi invitare tramite codice e aggiungere persone senza un\'app.';

  @override
  String get wizardSummaryName => 'Nome';

  @override
  String get wizardSummaryGroupType => 'Tipo di gruppo';

  @override
  String get wizardSummaryMode => 'Modalità';

  @override
  String get wizardSummaryRule => 'Disegna la regola';

  @override
  String get groupRoleAdmin => 'Amministratore';

  @override
  String get groupRoleMember => 'Membro';

  @override
  String get groupRuleIgnoreTitle => 'Ignora i sottogruppi';

  @override
  String get groupRulePreferTitle => 'Preferisci sottogruppi diversi';

  @override
  String get groupRuleRequireTitle => 'Richiedono sottogruppi diversi';

  @override
  String get groupRuleIgnoreDescription =>
      'Pareggio normale. Non tiene conto delle case, degli appartamenti o delle classi.';

  @override
  String get groupRulePreferDescription =>
      'Tarci Secret tenterà di abbinare i regali tra diversi sottogruppi, ma non bloccherà l\'omaggio se ciò non è possibile.';

  @override
  String get groupRuleRequireDescription =>
      'Nessuno potrà regalare qualcuno dello stesso sottogruppo. Potrebbe non riuscire se il gruppo non consente un\'unione valida.';

  @override
  String get groupSnackNeedThreeParticipants =>
      'Sono necessari almeno 3 partecipanti effettivi per organizzare un omaggio divertente.';

  @override
  String get groupSnackDrawAlreadyRunningOrDone =>
      'Non è possibile eseguire una nuova estrazione mentre è in corso o completata.';

  @override
  String get groupSnackCannotAddAfterDraw =>
      'Non è possibile aggiungere partecipanti dopo aver eseguito il giveaway.';

  @override
  String get groupDeleteOwnerSectionTitle => 'Opzioni del gruppo';

  @override
  String get groupDeleteOwnerSectionHint =>
      'Solo l’organizzatore può chiudere questa dinamica ed eliminare tutti i dati del gruppo.';

  @override
  String get groupDeleteEntryCta => 'Elimina gruppo';

  @override
  String get groupDeleteDialogPreTitle => 'Eliminare questo gruppo?';

  @override
  String get groupDeleteDialogPreBody =>
      'Verranno eliminati configurazione, partecipanti, inviti e dati collegati. L’azione non può essere annullata.';

  @override
  String get groupDeleteDialogPreConfirm => 'Elimina gruppo';

  @override
  String get groupDeleteDialogPostTitle => 'Eliminare questo amico segreto?';

  @override
  String get groupDeleteDialogPostBody =>
      'L’estrazione è già stata eseguita. Se continui, tutti perderanno l’accesso ai risultati, alle wishlist, alla chat di gruppo e ai dati collegati. L’azione non può essere annullata.';

  @override
  String get groupDeleteDialogPostConfirm => 'Elimina definitivamente';

  @override
  String get groupDeleteSuccessSnackbar => 'Gruppo eliminato';

  @override
  String get groupDetailMissingMessage =>
      'Questo gruppo non esiste più o è stato rimosso dall’organizzatore.';

  @override
  String get groupTooltipEditGroupName => 'Modifica il nome del gruppo';

  @override
  String get groupStatusCompletedInfo =>
      'Ogni persona ora può vedere chi è il suo turno di donare.';

  @override
  String get groupStatusReadyInfo =>
      'Quando lo avvii, tutti vedranno il proprio compito in privato.';

  @override
  String get groupStatusPendingInfo =>
      'Rivedi i partecipanti o i sottogruppi in sospeso.';

  @override
  String groupEffectiveParticipants(int count) {
    return 'Avere${count}minimo 3 persone';
  }

  @override
  String get groupOwnerCanRunHint =>
      'Quando tutto è pronto, l\'organizzatore lancia il sorteggio.';

  @override
  String get groupPendingSubgroupHint =>
      'Assegna ogni persona al proprio gruppo e il gioco è fatto.';

  @override
  String get groupPendingGeneralHint =>
      'Sei quasi arrivato per poter fare il sorteggio.';

  @override
  String groupRuleConfigVersion(int version) {
    return 'Configurazione v$version';
  }

  @override
  String get groupRuleLockedHint =>
      'La regola non può essere modificata mentre l\'estrazione è in corso o è già stata completata.';

  @override
  String get groupSubgroupSectionHelp =>
      'Organizza case, appartamenti, classi o squadre per migliorare il sorteggio.';

  @override
  String get groupSubgroupEmptyHelp =>
      'Non ci sono ancora sottogruppi. Puoi crearne uno per organizzare meglio il gruppo.';

  @override
  String get groupSubgroupAssignedOne => '1 partecipante assegnato';

  @override
  String groupSubgroupAssignedMany(int count) {
    return '${count}partecipanti assegnati';
  }

  @override
  String get groupSubgroupLockedHint =>
      'Non è possibile modificare i sottogruppi dopo aver eseguito l\'estrazione.';

  @override
  String get groupSubgroupDisabledHint =>
      'Sottogruppi disabilitati per questo giveaway. Puoi abilitarli modificando la regola.';

  @override
  String get groupParticipantSubgroupLockedHint =>
      'Il sottogruppo non può essere modificato mentre il sorteggio è in corso o è già stato completato.';

  @override
  String get groupManagedSectionHelp =>
      'Questi partecipanti non utilizzano l\'app e il loro risultato viene consegnato in privato.';

  @override
  String get groupManagedEmptyHelp =>
      'Non ci sono ancora partecipanti gestiti.';

  @override
  String get groupManagedGuardianSelf => 'Voi';

  @override
  String get groupManagedGuardianOther => 'un altro responsabile';

  @override
  String get groupManagedPrivateDeliveryHint =>
      'Partecipano senza app e i loro risultati vengono consegnati privatamente.';

  @override
  String get groupInvitationsHelp =>
      'Genera un codice e condividilo affinché i partecipanti possano partecipare.';

  @override
  String get groupInvitationCodeTapHint => 'Tocca il codice per copiarlo';

  @override
  String get groupInvitationsClosedHint =>
      'Gli inviti sono chiusi perché il sorteggio è già stato effettuato.';

  @override
  String get groupAdvancedHelp =>
      'I dettagli secondari del gruppo vengono visualizzati qui.';

  @override
  String groupAdvancedLastExecution(String id) {
    return 'Ultima corsa:$id';
  }

  @override
  String groupAdvancedInternalStatus(String status) {
    return 'Stato interno del sorteggio:$status';
  }

  @override
  String get groupCreateSubgroupHint => 'Ex. Stan House, Vendite, Classe 3A';

  @override
  String get groupHeaderSubtitle =>
      'Prepara il tuo giveaway con riservatezza e chiarezza.';

  @override
  String get groupDetailTaglinePostDraw =>
      'Risultati in privato: ognuno vede il proprio.';

  @override
  String get groupMemberPreDrawSubtitle =>
      'Sei già dentro. Quando l\'organizzatore lancerà il giveaway, potrai visualizzare la tua allocazione in privato.';

  @override
  String get groupMemberYourHouseTitle => 'La tua casa o la tua squadra';

  @override
  String get groupMemberYourHousePickHint =>
      'L\'organizzatore ha definito squadre o case. Scegli il tuo per posizionarti bene nel sorteggio.';

  @override
  String groupMemberYourHouseAssigned(String name) {
    return 'Ti abbiamo localizzato in:$name';
  }

  @override
  String get groupMemberYourHouseChooseCta =>
      'Scegli la mia casa o la mia squadra';

  @override
  String get groupMemberYourHouseChangeCta =>
      'Cambia la mia casa o la mia attrezzatura';

  @override
  String get groupMemberManagedByYouTitle => 'Persone che gestisci qui';

  @override
  String get groupMemberManagedByYouSubtitle =>
      'Vedrai solo coloro che l\'organizzatore ti ha assegnato come responsabile.';

  @override
  String get groupMemberHeroTitlePreDraw => 'Sei già dentro';

  @override
  String get groupMemberHeroSubtitlePreDraw =>
      'Quando l\'organizzatore lancerà il giveaway, vedrai la tua assegnazione in privato.';

  @override
  String get groupMemberHeroTaglinePreDraw =>
      'Il tuo gruppo, il tuo spazio. Nessuno vede i risultati degli altri.';

  @override
  String get groupMemberHeroTaglinePostDraw =>
      'Omaggio pronto. Solo tu vedi quello che hai.';

  @override
  String get groupMemberPostDrawHeroSubtitle =>
      'Apri il tuo risultato quando vuoi; È privato.';

  @override
  String get groupMemberHeroSubtitleDrawing =>
      'Stiamo sorteggiando. In un attimo potrai vedere il tuo risultato.';

  @override
  String get groupBackToDashboard => 'Ritorna alla dashboard';

  @override
  String get groupLoadingDetail => 'Caricamento gruppo...';

  @override
  String get groupErrorTitle => 'Impossibile aprire questo gruppo';

  @override
  String get groupErrorNotFound =>
      'Questo gruppo non è più disponibile o non hai accesso.';

  @override
  String get groupPreparationTitle => 'Stato del gruppo';

  @override
  String groupPreparationQuickSummary(
    int total,
    int withoutApp,
    int subgroups,
  ) {
    return '${total}persone nel sorteggio${withoutApp}senza app ·${subgroups}sottogruppi';
  }

  @override
  String get groupPostDrawHeroTitle => 'Sorteggio effettuato';

  @override
  String get groupPostDrawHeroSubtitle =>
      'Ora puoi vedere ciò che ti appartiene, in privato.';

  @override
  String get groupChecklistEnoughPeopleDone => 'Hai già abbastanza persone';

  @override
  String get groupChecklistEnoughPeopleMissing =>
      'Sono necessarie almeno 3 persone';

  @override
  String get groupChecklistAllInSubgroupDone =>
      'Ognuno è nel proprio sottogruppo';

  @override
  String get groupChecklistMissingSubgroupOne =>
      'Devi inserire 1 persona nel tuo sottogruppo';

  @override
  String groupChecklistMissingSubgroupMany(int count) {
    return 'Mancano${count}persone da inserire nel proprio sottogruppo';
  }

  @override
  String groupChecklistPendingMembers(int count) {
    return '${count}persone se ne sono andate o sono state rimosse';
  }

  @override
  String groupPreparationRegistered(int count) {
    return 'Registrato:$count';
  }

  @override
  String groupPreparationManaged(int count) {
    return 'Gestito:$count';
  }

  @override
  String groupPreparationPending(int count) {
    return 'Orecchini:$count';
  }

  @override
  String groupPreparationMissingSubgroup(int count) {
    return 'Senza sottogruppo:$count';
  }

  @override
  String get groupRuleCurrentLabel => 'Regola attuale';

  @override
  String get groupRuleChangeCta => 'Cambia regola';

  @override
  String get groupSectionExpandHint => 'Tocca per espandere';

  @override
  String get groupSectionCollapseHint => 'Tocca per chiudere';

  @override
  String groupSectionItemsCount(int count) {
    return '${count}in totale';
  }

  @override
  String get groupManagedDialogGuardianSectionTitle =>
      'Chi consegnerà il risultato?';

  @override
  String get groupManagedDialogGuardianMe => 'IO';

  @override
  String get groupManagedDialogGuardianMeHint =>
      'Condividerò il risultato in privato';

  @override
  String get groupManagedDialogGuardianOther => 'altro membro';

  @override
  String get groupManagedDialogGuardianSpecific => 'Responsabile specifico';

  @override
  String get groupManagedDialogGuardianComingSoon => 'Presto';

  @override
  String get groupManagedDialogDeliverySectionTitle =>
      'Come farai a darglielo?';

  @override
  String get groupManagedResponsibleUnavailable => 'Gestore non disponibile';

  @override
  String groupManagedDeliversResponsible(String name) {
    return 'Lo gestisce:$name';
  }

  @override
  String get groupManagedDialogPickGuardianTitle => 'Chi lo consegnerà?';

  @override
  String get groupManagedDialogGuardianOtherSubtitle =>
      'Questo membro vedrà il risultato e potrà consegnartelo in privato.';

  @override
  String get groupManagedDialogGuardianNoEligibleMembers =>
      'Quando un altro membro con un\'app si unisce, puoi assegnargliela.';

  @override
  String get groupManagedDialogPickMemberCta => 'Scegli membro';

  @override
  String get groupManagedDialogSelectOtherFirst =>
      'Scegli prima un membro del gruppo.';

  @override
  String get groupManagedDialogGuardianMustReassign =>
      'Quel membro non è più attivo nel gruppo. Scegli un\'altra persona responsabile o \"Io\".';

  @override
  String groupManagedDialogDeliversSummary(String name) {
    return 'Fornisce:$name';
  }

  @override
  String get groupParticipantsRegisteredTitle => 'Partecipanti registrati';

  @override
  String get groupParticipantsPendingTitle => 'Partecipanti in sospeso';

  @override
  String get groupParticipantsPendingEmpty =>
      'Non ci sono partecipanti in sospeso.';

  @override
  String get groupPendingStatusLeft => 'lasciato il gruppo';

  @override
  String get groupPendingStatusRemoved => 'Rimosso dal gruppo';

  @override
  String myAssignmentSubgroupLabel(String name) {
    return 'Sottogruppo:$name';
  }

  @override
  String managedSubgroupLabel(String name) {
    return 'Sottogruppo:$name';
  }

  @override
  String get managedYouManageIt => 'lo gestisci tu';

  @override
  String managedDeliveryRecommendation(String mode) {
    return 'Consegna consigliata:$mode';
  }

  @override
  String get managedTypeManagedParticipant => 'Partecipante gestito';

  @override
  String get managedDeliveryOwnerDelegated => 'Gestito dal responsabile';

  @override
  String get managedDeliveryModeWhatsapp => 'Whatsapp';

  @override
  String get managedDeliveryModeEmail => 'Posta';

  @override
  String get managedDeliveryModePdf => 'Stampato/PDF';

  @override
  String get managedDeliveryCtaWhatsapp => 'Condividi su WhatsApp';

  @override
  String get managedDeliveryCtaEmail => 'Preparare la posta';

  @override
  String get managedDeliveryCtaPdf => 'Genera PDF';

  @override
  String get managedDeliveryVerbalBadge => 'consegna verbale';

  @override
  String get managedDeliveryPdfGenerating => 'Generazione PDF…';

  @override
  String get managedDeliveryWhatsappBrand => '🎁Tarci Segreto';

  @override
  String managedDeliveryWhatsappHello(String name) {
    return 'Ciao,$name.';
  }

  @override
  String managedDeliveryWhatsappDrawLine(String groupName) {
    return 'L\'amico segreto di «$groupName».';
  }

  @override
  String get managedDeliveryWhatsappGiftIntro => 'Tocca a te donare a:';

  @override
  String managedDeliveryWhatsappReceiverLine(String receiverName) {
    return '✨ $receiverName';
  }

  @override
  String managedDeliverySubgroupBelongsTo(String subgroup) {
    return 'Appartiene a:$subgroup';
  }

  @override
  String get managedDeliveryClosingSecret => 'Mantieni il segreto 🤫';

  @override
  String managedDeliveryEmailSubject(String groupName) {
    return 'Il tuo amico segreto$groupNameè pronto 🎁';
  }

  @override
  String managedDeliveryEmailGreeting(String name) {
    return 'Ciao,$name:';
  }

  @override
  String managedDeliveryEmailLead(String groupName) {
    return 'Vi scriviamo con il risultato privato dell\'amico segreto del gruppo «$groupName».';
  }

  @override
  String get managedDeliveryEmailGiftLabel => 'Chi devi dare è:';

  @override
  String managedDeliveryEmailReceiverLine(String receiverName) {
    return '$receiverName';
  }

  @override
  String managedDeliveryEmailSubgroupLine(String subgroup) {
    return 'Casa o squadra:$subgroup';
  }

  @override
  String get managedDeliveryEmailClosing =>
      'Tieni questo risultato solo per te. Nessun altro deve vederlo.';

  @override
  String get managedDeliveryEmailSignoff => 'un abbraccio,\nTarci Segreto';

  @override
  String get managedPdfDocTitle => 'amico-segreto';

  @override
  String get managedPdfHeadline => 'Il tuo amico segreto è pronto';

  @override
  String get managedPdfForLabel => 'Per';

  @override
  String get managedPdfGroupLabel => 'Grappolo';

  @override
  String get managedPdfGiftHeading => 'Devi dare a...';

  @override
  String get managedPdfFooterKeepSecret =>
      'Mantieni il segreto. Nessun altro deve vederlo.';

  @override
  String get managedPdfFooterBrand => 'Generato con Tarci Secret';

  @override
  String get managedDeliveryFallbackGroupName => 'il tuo gruppo';

  @override
  String get managedDeliveryErrorMissingData =>
      'Non ci sono dati sufficienti per preparare il messaggio.';

  @override
  String get managedDeliveryErrorWhatsapp =>
      'Non è stato possibile aprire WhatsApp. Puoi condividere il testo con un\'altra app.';

  @override
  String get managedDeliveryErrorEmail =>
      'Non troviamo un\'app di posta elettronica su questo dispositivo.';

  @override
  String get managedDeliveryErrorPdf => 'Impossibile generare il PDF. Riprova.';

  @override
  String get managedDeliveryErrorShare => 'Impossibile condividere. Riprova.';

  @override
  String get managedDeliveryErrorGeneric =>
      'Qualcosa è andato storto. Riprova.';

  @override
  String get myAssignmentPrivateBadge => 'Privato · solo per te';

  @override
  String get myAssignmentRevealLabel => 'Devi dare a';

  @override
  String get myAssignmentEmotionalCopy => 'Fallo sentire speciale.';

  @override
  String get myAssignmentPrivacyTitle => 'Solo tu lo vedi';

  @override
  String get myAssignmentPrivacyBody =>
      'Mantieni il segreto fino al giorno dello scambio. Nessun altro nel gruppo può vedere di chi è il turno.';

  @override
  String get myAssignmentNoSubgroupChip => 'Nessun sottogruppo';

  @override
  String get groupCompletedHeroSubtitle =>
      'Ognuno ha già scoperto chi è il suo turno di donare.';

  @override
  String get groupCompletedPrivacyNote =>
      'Ogni risultato è privato. Solo ogni persona vede il proprio.';

  @override
  String get groupCompletedManagedHint =>
      'Fornisci privatamente i risultati delle persone che gestisci.';

  @override
  String get chatGroupSectionTitle => 'Conversazione di gruppo';

  @override
  String get chatGroupSectionSubtitle =>
      'Scherza, lascia indizi e tieni viva l’atmosfera.';

  @override
  String get chatGroupEnterCta => 'Apri la chat';

  @override
  String chatGroupEventLine(String date) {
    return 'Consegna:$date';
  }

  @override
  String get chatDrawCompletedChip => 'Sorteggio effettuato';

  @override
  String get chatInputHint => 'Scrivi qualcosa per il gruppo…';

  @override
  String get chatSendCta => 'Invia';

  @override
  String get chatTarciLabel => 'Tarci';

  @override
  String get chatEmptyTitle => 'Non ci sono ancora messaggi';

  @override
  String get chatEmptyBody =>
      'Quando qualcuno scrive o Tarci segnala qualcosa di importante, lo vedrai qui.';

  @override
  String get chatLoadError =>
      'Non è stato possibile caricare la chat. Controlla la connessione o riprova.';

  @override
  String get chatSendError => 'Impossibile inviare il messaggio. Riprova.';

  @override
  String get chatSystemGroupCreatedV1 =>
      '🎁 Il gruppo è già in corso. Lascia cadere suggerimenti, vuota il sacco e lascia che i pettegolezzi sani rotolino.';

  @override
  String get chatSystemDrawCompletedV1 =>
      '🤫 Giveaway fatto. D\'ora in poi, ogni domanda strana conta come prova.';

  @override
  String chatSystemUnknownTemplate(String templateKey) {
    return 'Messaggio di sistema ($templateKey)';
  }

  @override
  String get chatSystemAutoPlayful001V1 =>
      'Qui c\'è già aria di sospetti… e nessuno ha ancora confessato nulla.';

  @override
  String get chatSystemAutoPlayful002V1 =>
      'Da quando c\'è stato il sorteggio, ogni domanda innocente sembra strategica.';

  @override
  String get chatSystemAutoPlayful003V1 =>
      'Consiglio di Tarci: indaga con discrezione, non come in un interrogatorio.';

  @override
  String get chatSystemAutoPlayful004V1 =>
      'C\'è chi ha già il regalo. E chi ha fede.';

  @override
  String get chatSystemAutoPlayful005V1 =>
      'Se qualcuno chiede taglie, colori e hobby tutti insieme, prendi nota.';

  @override
  String get chatSystemAutoPlayful006V1 =>
      'Un buon regalo sorprende. Un grande regalo lascia il segno.';

  @override
  String get chatSystemAutoPlayful007V1 =>
      'I sorrisi sospetti contano come indizi.';

  @override
  String get chatSystemAutoPlayful008V1 =>
      'Depistare è concesso. Esagerare è sconsigliato.';

  @override
  String get chatSystemAutoPlayful009V1 =>
      'Il silenzio di qualcuno comincia a sembrare una strategia.';

  @override
  String get chatSystemAutoPlayful010V1 =>
      'Se improvvisi, fallo almeno con affetto.';

  @override
  String get chatSystemAutoPlayful011V1 =>
      'Tarci percepisce energia da regalo epico… e da panico elegante.';

  @override
  String get chatSystemAutoPlayful012V1 =>
      'Chi dice “ce l\'ho già” senza prove suscita sospetti.';

  @override
  String get chatSystemAutoPlayful013V1 =>
      'Promemoria gentile: anche il mistero fa parte del divertimento.';

  @override
  String get chatSystemAutoPlayful014V1 =>
      'Ogni gruppo ha un detective. Avete già capito chi è?';

  @override
  String get chatSystemAutoPlayful015V1 =>
      'Un pensiero fatto con intenzione vale più di un regalo senza anima.';

  @override
  String get chatSystemAutoPlayful016V1 =>
      'Questa chat è ufficialmente in modalità sospetto.';

  @override
  String get chatSystemAutoPlayful017V1 =>
      'Se hai appena cercato idee regalo di nascosto, nessuno ti giudica.';

  @override
  String get chatSystemAutoPlayful018V1 =>
      'Certi sguardi nella vita reale ora significano fin troppo.';

  @override
  String get chatSystemAutoPlayful019V1 =>
      'La missione non è spendere di più. È azzeccarci meglio.';

  @override
  String get chatSystemAutoPlayful020V1 =>
      'Saper dissimulare fa parte del gioco.';

  @override
  String get chatSystemAutoPlayful021V1 =>
      'Tarci scommette che qualcuno qui ha già un piano geniale.';

  @override
  String get chatSystemAutoDebate001V1 =>
      'Dibattito rapido: regalo utile o regalo che fa ridere?';

  @override
  String get chatSystemAutoDebate002V1 =>
      'Meglio una sorpresa totale o un indizio sfruttato bene?';

  @override
  String get chatSystemAutoDebate003V1 =>
      'Cosa vince: creatività o precisione?';

  @override
  String get chatSystemAutoDebate004V1 =>
      'Dibattito aperto: una confezione spettacolare conta?';

  @override
  String get chatSystemAutoDebate005V1 =>
      'Indagine discreta o lista dei desideri in soccorso?';

  @override
  String get chatSystemAutoDebate006V1 =>
      'Senza fare nomi: chi in questo gruppo improvvisa all\'ultimo?';

  @override
  String get chatSystemAutoDebate007V1 =>
      'Meglio un piccolo regalo con una storia o uno grande senza?';

  @override
  String get chatSystemAutoDebate008V1 =>
      'Depistare in chat è lecito o è già gioco sporco?';

  @override
  String get chatSystemAutoDebate009V1 =>
      'Cosa emoziona di più: azzeccare o sorprendere?';

  @override
  String get chatSystemAutoDebate010V1 =>
      'Se dovessi scegliere: pratico, divertente o sentimentale?';

  @override
  String get chatSystemAutoWishlist001V1 =>
      'Alcune liste dei desideri sono ancora vuote. Un indizio al momento giusto può salvare un regalo.';

  @override
  String get chatSystemAutoWishlist002V1 =>
      'La tua lista dei desideri non toglie magia; evita di andare alla cieca.';

  @override
  String get chatSystemAutoWishlist003V1 =>
      'Se vuoi che ci azzecchino, lascia qualche idea.';

  @override
  String get chatSystemAutoWishlist004V1 =>
      'Qualcuno sta preparando un regalo con pochissimi indizi. Ehm.';

  @override
  String get chatSystemAutoWishlist005V1 =>
      'Completare la lista aiuta senza svelare troppo.';

  @override
  String get chatSystemAutoWishlist006V1 =>
      'Un link, un gusto, un indizio: tutto aiuta.';

  @override
  String get chatSystemAutoWishlist007V1 =>
      'Anche le migliori sorprese apprezzano un po\' di orientamento.';

  @override
  String get chatSystemAutoWishlist008V1 =>
      'Se la tua lista è vuota, il tuo amico segreto sta giocando in modalità difficile.';

  @override
  String get chatSystemAutoQuiet001V1 =>
      'Qui c\'è molto silenzio… state comprando o nascondendo le prove?';

  @override
  String get chatSystemAutoQuiet002V1 =>
      'Questo gruppo è fin troppo tranquillo. Qualcuno rompa il ghiaccio.';

  @override
  String get chatSystemAutoQuiet003V1 =>
      'Tarci fa l\'appello: il divertimento è ancora vivo?';

  @override
  String get chatSystemAutoQuiet004V1 =>
      'Domanda per riattivare il gruppo: chi sembra più sospetto oggi?';

  @override
  String get chatSystemAutoQuiet005V1 =>
      'Se nessuno scrive, Tarci inizierà a inventare teorie.';

  @override
  String get chatSystemAutoQuiet006V1 =>
      'Chat addormentata, mistero sveglissimo. Scrivete qualcosa.';

  @override
  String get chatSystemAutoCountdown014V1 =>
      'Mancano 14 giorni. C\'è ancora margine, ma le scuse stanno finendo.';

  @override
  String get chatSystemAutoCountdown007V1 =>
      'Mancano 7 giorni. Chi non ha ancora un\'idea entra ufficialmente in fase ricerca seria.';

  @override
  String get chatSystemAutoCountdown003V1 =>
      'Mancano 3 giorni. Non è più pianificazione: è operazione salvataggio.';

  @override
  String get chatSystemAutoCountdown001V1 =>
      'Manca 1 giorno. Incarta, respira e fai finta di niente.';

  @override
  String get chatSystemAutoCountdown000V1 =>
      'Oggi è il giorno dello scambio. Che ci siano sorprese, risate e zero confessioni in anticipo.';

  @override
  String get dynamicsHomePrimaryCta => 'Crea una dinamica';

  @override
  String get dynamicsSelectTitle => 'Scegli una dinamica';

  @override
  String get dynamicsSelectSubtitle =>
      'Inizia con un\'esperienza pronta oggi. Arriveranno presto altre modalità.';

  @override
  String get dynamicsCardSecretSantaTitle => 'Amico segreto';

  @override
  String get dynamicsCardSecretSantaBody =>
      'Assegnazioni private, liste dei desideri e chat di gruppo.';

  @override
  String get dynamicsCardRaffleTitle => 'Sorteggio';

  @override
  String get dynamicsCardRaffleBody =>
      'Vincitori visibili a tutto il gruppo. Niente segreti né consegne gestite.';

  @override
  String get dynamicsCardTeamsTitle => 'Squadre';

  @override
  String get dynamicsCardPairingsTitle => 'Abbinamenti';

  @override
  String get dynamicsCardDuelsTitle => 'Duelli';

  @override
  String get dynamicsComingSoonBadge => 'Prossimamente';

  @override
  String get homeDynamicTypeSecretSanta => 'Amico segreto';

  @override
  String get homeDynamicTypeRaffle => 'Sorteggio';

  @override
  String get homeRaffleStatePreparing => 'In preparazione';

  @override
  String get homeRaffleStateCompleted => 'Sorteggio completato';

  @override
  String get raffleWizardTitle => 'Nuovo sorteggio';

  @override
  String get raffleWizardNameLabel => 'Nome del sorteggio';

  @override
  String get raffleWizardWinnersLabel => 'Numero di vincitori';

  @override
  String get raffleWizardOwnerParticipatesTitle => 'Partecipi anche tu?';

  @override
  String get raffleWizardOwnerParticipatesYes => 'Sì, entro nell\'estrazione';

  @override
  String get raffleWizardOwnerParticipatesNo => 'No, organizzo soltanto';

  @override
  String get raffleWizardEventOptional => 'Data dell\'evento (opzionale)';

  @override
  String get raffleWizardReviewTitle => 'Revisione';

  @override
  String raffleWizardReviewWinners(int count) {
    return '$count vincitori';
  }

  @override
  String get raffleWizardCreateCta => 'Crea sorteggio';

  @override
  String get raffleDetailInviteSection => 'Invito';

  @override
  String get raffleDetailAppMembersTitle => 'Partecipanti con app';

  @override
  String get raffleDetailManualTitle => 'Partecipanti senza app';

  @override
  String get raffleDetailAddManualCta => 'Aggiungi persona';

  @override
  String get raffleDetailRunRaffleCta => 'Esegui sorteggio';

  @override
  String get raffleDetailWinnersTitle => 'Vincitori';

  @override
  String get raffleDetailShareCta => 'Condividi risultato';

  @override
  String get raffleDetailCompletedHint =>
      'Questo sorteggio è chiuso: non puoi modificare i partecipanti né ripetere l\'estrazione.';

  @override
  String get raffleManualEditTitle => 'Modifica partecipante';

  @override
  String get raffleManualDisplayNameLabel => 'Nome visibile';

  @override
  String raffleShareBody(String raffleName, String winners) {
    return 'Abbiamo i vincitori di «$raffleName»:\n$winners\n\nRealizzato con Tarci Secret.';
  }

  @override
  String get functionsErrorRaffleResolvedInvitesClosed =>
      'Questo sorteggio è già stato effettuato e non accetta nuovi partecipanti.';

  @override
  String get functionsErrorRaffleInProgress =>
      'Il sorteggio è in corso. Riprova tra qualche secondo.';

  @override
  String get functionsErrorRaffleRotateLocked =>
      'Non puoi ruotare il codice quando il sorteggio non accetta più modifiche.';

  @override
  String get functionsErrorRaffleAlreadyCompleted =>
      'Questo sorteggio è già stato completato.';

  @override
  String get functionsErrorRaffleTooManyWinners =>
      'Ci sono più vincitori dei partecipanti eleggibili.';

  @override
  String get functionsErrorRaffleInsufficientParticipants =>
      'Non ci sono abbastanza partecipanti per questo sorteggio.';

  @override
  String get functionsErrorRaffleInvalidDynamic =>
      'Questa azione non è disponibile per questo tipo di gruppo.';

  @override
  String get functionsErrorChatNotAvailableForRaffle =>
      'La chat di gruppo non è disponibile per i sorteggi pubblici.';

  @override
  String get functionsErrorWishlistNotAvailableForRaffle =>
      'Le liste dei desideri non sono disponibili nei sorteggi.';

  @override
  String get functionsErrorManagedParticipantsNotForRaffle =>
      'I partecipanti gestiti dell\'amico segreto non si applicano ai sorteggi.';

  @override
  String get functionsErrorDrawNotForRaffle =>
      'Il sorteggio dell\'amico segreto non è disponibile per i gruppi sorteggio.';

  @override
  String get functionsErrorAssignmentsNotForRaffle =>
      'Le assegnazioni segrete non si applicano a questo gruppo.';

  @override
  String raffleDetailEligibleCount(int count) {
    return 'Partecipanti eleggibili: $count';
  }

  @override
  String get raffleWizardPickEventDate => 'Scegli data';

  @override
  String get functionsErrorDrawNotSupportedForDynamic =>
      'Il sorteggio dell\'amico segreto non è disponibile per questo tipo di gruppo.';

  @override
  String get functionsErrorRaffleEditLocked =>
      'Questo sorteggio non consente più modifiche ai partecipanti.';

  @override
  String get raffleDetailMinPoolHint =>
      'Servono almeno 2 partecipanti nel bombo per eseguire l’estrazione.';

  @override
  String get raffleResultHeroTitle => 'Estrazione completata!';

  @override
  String get raffleResultHeroSubtitle => 'Abbiamo il risultato.';

  @override
  String raffleResultSingleWinner(String name) {
    return 'Vincitore: $name';
  }

  @override
  String raffleResultMultipleWinners(String names) {
    return 'Vincitori: $names';
  }

  @override
  String get raffleWizardOwnerNicknameLabel => 'Il tuo nome nel bombo';

  @override
  String get raffleWizardOwnerNicknameHelper =>
      'Gli altri ti vedranno così. Usa un soprannome, non il ruolo di organizzatore.';

  @override
  String get raffleOwnerParticipantFallback => 'Partecipante';

  @override
  String get raffleMemberDefaultName => 'Partecipante';

  @override
  String get raffleDetailStatsWinners => 'Numero di vincitori';

  @override
  String get raffleDetailInPool => 'Nel bombo';

  @override
  String get pushActivationTitle => 'Attiva le notifiche';

  @override
  String get pushActivationBody =>
      'Ti avviseremo quando si svolge un’estrazione o quando il tuo amico segreto è pronto.';

  @override
  String get pushActivationCta => 'Attiva';

  @override
  String get pushActivationSuccessSnackbar => 'Notifiche attivate.';

  @override
  String get pushActivationDeniedSnackbar =>
      'Non è stato possibile attivare le notifiche. Puoi riprovare più tardi dalle impostazioni di sistema.';

  @override
  String get dynamicsCardTeamsBody =>
      'Dividi i partecipanti in squadre equilibrate. Risultato visibile a tutti.';

  @override
  String get homeDynamicTypeTeams => 'Squadre';

  @override
  String get homeTeamsStatePreparing => 'In preparazione';

  @override
  String get homeTeamsStateCompleted => 'Squadre pronte';

  @override
  String get teamsWizardTitle => 'Crea squadre';

  @override
  String get teamsWizardCreateCta => 'Crea squadre';

  @override
  String get teamsWizardNameLabel => 'Nome dell’attività';

  @override
  String get teamsWizardOwnerNicknameLabel => 'Il tuo nome nelle squadre';

  @override
  String get teamsWizardOwnerNicknameHelper =>
      'Così ti vedranno gli altri. Usa un soprannome, non il ruolo di organizzatore.';

  @override
  String get teamsWizardEventOptional => 'Data dell’evento (opzionale)';

  @override
  String get teamsWizardPickEventDate => 'Scegli data';

  @override
  String get teamsWizardOwnerParticipatesTitle => 'Partecipi anche tu?';

  @override
  String get teamsWizardOwnerParticipatesYes =>
      'Sì, voglio essere in una squadra';

  @override
  String get teamsWizardOwnerParticipatesNo => 'No, organizzo solo';

  @override
  String get teamsWizardGroupingTitle => 'Come formare le squadre?';

  @override
  String get teamsWizardGroupingSubtitle =>
      'Scegli un numero fisso di squadre o una dimensione per squadra.';

  @override
  String get teamsWizardModeTeamCount => 'Per numero di squadre';

  @override
  String get teamsWizardModeTeamSize => 'Per persone per squadra';

  @override
  String get teamsWizardTeamCountLabel => 'Quante squadre?';

  @override
  String get teamsWizardTeamSizeLabel => 'Quante persone per squadra?';

  @override
  String get teamsWizardReviewTitle => 'Riepilogo';

  @override
  String teamsWizardReviewTeamCount(int count) {
    return '$count squadre';
  }

  @override
  String teamsWizardReviewTeamSize(int size) {
    return 'Squadre da $size persone';
  }

  @override
  String get teamsOwnerParticipantFallback => 'Partecipante';

  @override
  String get teamsMemberDefaultName => 'Partecipante';

  @override
  String get teamsDetailInviteSection => 'Invito';

  @override
  String get teamsDetailAppMembersTitle => 'Partecipanti con app';

  @override
  String get teamsDetailManualTitle => 'Partecipanti senza app';

  @override
  String get teamsDetailAddManualCta => 'Aggiungi persona';

  @override
  String get teamsDetailFormTeamsCta => 'Forma squadre';

  @override
  String get teamsDetailConfigTitle => 'Configurazione';

  @override
  String teamsDetailConfigTeamCount(int count) {
    return '$count squadre';
  }

  @override
  String teamsDetailConfigTeamSize(int size) {
    return 'Squadre da $size persone';
  }

  @override
  String teamsDetailEstimatedTeams(int count) {
    return 'Squadre stimate: $count';
  }

  @override
  String teamsDetailEligibleCount(int count) {
    return 'Partecipanti nel sorteggio: $count';
  }

  @override
  String get teamsDetailMinPoolHint =>
      'Servono almeno 2 partecipanti per formare le squadre.';

  @override
  String get teamsDetailInvalidConfigHint =>
      'Controlla la configurazione delle squadre prima di continuare.';

  @override
  String get teamsDetailCompletedHint =>
      'Le squadre sono già formate: non puoi modificare i partecipanti né rifare il sorteggio.';

  @override
  String get teamsDetailTeamsListTitle => 'Squadre';

  @override
  String get teamsDetailShareCta => 'Condividi risultato';

  @override
  String get teamsDetailEmailCta => 'Prepara email';

  @override
  String get teamsDetailPdfCta => 'Genera PDF';

  @override
  String get teamsManualDisplayNameLabel => 'Nome visibile';

  @override
  String get teamsManualEditTitle => 'Modifica partecipante';

  @override
  String get teamsResultHeroTitle => 'Squadre pronte!';

  @override
  String get teamsResultHeroSubtitle =>
      'Puoi condividere il risultato con il gruppo.';

  @override
  String teamsResultSummary(int teamCount, int participantCount) {
    return '$teamCount squadre · $participantCount partecipanti';
  }

  @override
  String teamsUnitLabel(int number) {
    return 'Squadra $number';
  }

  @override
  String teamsShareBody(String groupName, String teamsBlock) {
    return '🧩 Squadre generate per «$groupName»\n\n$teamsBlock\n\nCreato con Tarci Secret.';
  }

  @override
  String teamsEmailSubject(String groupName) {
    return 'Squadre generate — $groupName';
  }

  @override
  String teamsEmailBody(String groupName, String teamsBlock) {
    return 'Ciao,\n\nLe squadre di «$groupName» sono pronte:\n\n$teamsBlock\n\nGenerato con Tarci Secret.';
  }

  @override
  String get teamsEmailError =>
      'Nessuna app email disponibile su questo dispositivo.';

  @override
  String get teamsPdfHeadline => 'Squadre generate';

  @override
  String teamsPdfSummary(int teamCount, int participantCount) {
    return '$teamCount squadre · $participantCount partecipanti';
  }

  @override
  String get teamsPdfFooter => 'Generato con Tarci Secret';

  @override
  String get teamsPdfError => 'Impossibile generare il PDF. Riprova.';

  @override
  String joinSuccessTeamsSubtitle(String groupName) {
    return 'Sei entrato in «$groupName».';
  }

  @override
  String get joinSuccessTeamsBody =>
      'Quando l’organizzatore formerà le squadre, vedrai il risultato qui.';

  @override
  String get joinSuccessTeamsPrimaryCta => 'Vai alle squadre';

  @override
  String get functionsErrorTeamsResolvedInvitesClosed =>
      'Le squadre sono già formate e questo gruppo non accetta nuovi partecipanti.';

  @override
  String get functionsErrorTeamsInProgress =>
      'Le squadre sono in formazione. Riprova tra poco.';

  @override
  String get functionsErrorTeamsRotateLocked =>
      'Non puoi cambiare il codice dopo aver formato le squadre.';

  @override
  String get functionsErrorTeamsAlreadyCompleted =>
      'Le squadre sono già formate.';

  @override
  String get functionsErrorTeamsInsufficientParticipants =>
      'Servono almeno 2 partecipanti per formare le squadre.';

  @override
  String get functionsErrorTeamsInvalidConfiguration =>
      'Configurazione squadre non valida.';

  @override
  String get functionsErrorTeamsTooManyParticipants =>
      'Hai raggiunto il numero massimo di partecipanti.';

  @override
  String get functionsErrorTeamsInvalidDynamic =>
      'Questa azione non è disponibile per questo tipo di attività.';

  @override
  String get functionsErrorTeamsEditLocked =>
      'Non puoi modificare i partecipanti dopo aver formato le squadre.';

  @override
  String get chatSystemAutoTeamsPlayful001V1 =>
      'Squadre pronte. Potete iniziare a incolpare l\'algoritmo.';

  @override
  String get chatSystemAutoTeamsPlayful002V1 =>
      'Quale squadra viene per vincere e quale per la merenda?';

  @override
  String get chatSystemAutoTeamsPlayful003V1 =>
      'C\'è talento… e tanta fiducia. Vedremo cosa pesa di più.';

  @override
  String get chatSystemAutoTeamsPlayful004V1 =>
      'Si accettano pronostici, scuse e teorie del complotto.';

  @override
  String get chatSystemAutoTeamsPlayful005V1 =>
      'Un sorteggio equo. Anche le lamentele creative contano come partecipazione.';

  @override
  String get chatSystemAutoTeamsPlayful006V1 =>
      'Non importa con chi finisci. Importa chi chiede la rivincita.';

  @override
  String get chatSystemAutoTeamsPlayful007V1 =>
      'Tarci ha sorteggiato. Ora dimostrate che non era fortuna.';

  @override
  String get chatSystemAutoTeamsPlayful008V1 =>
      'Ci sono squadre che ispirano rispetto e altre che ispirano meme.';

  @override
  String get chatSystemAutoTeamsPlayful009V1 =>
      'Il caso ha parlato. La dignità si risolve il giorno dell\'incontro.';

  @override
  String get chatSystemAutoTeamsPlayful010V1 =>
      'Non sottovalutate una squadra silenziosa.';

  @override
  String get chatSystemAutoTeamsPlayful011V1 =>
      'Alcuni festeggiano già. Altri calcolano come cambiare squadra senza farsi notare.';

  @override
  String get chatSystemAutoTeamsPlayful012V1 =>
      'Risultato pubblicato. Il dramma ufficiale inizia ora.';

  @override
  String get chatSystemAutoTeamsPlayful013V1 =>
      'C\'è chimica di squadra… o almeno dice la statistica emotiva.';

  @override
  String get chatSystemAutoTeamsPlayful014V1 =>
      'Una buona squadra si costruisce. Una leggendaria si vanta prima di giocare.';

  @override
  String get chatSystemAutoTeamsPlayful015V1 =>
      'Il gruppo ha il sorteggio. Manca l\'epica.';

  @override
  String get chatSystemAutoTeamsPlayful016V1 =>
      'Da qui, ogni messaggio può alimentare la rivalità.';

  @override
  String get chatSystemAutoTeamsPlayful017V1 =>
      'Squadre formate. L\'orgoglio di gruppo è attivo.';

  @override
  String get chatSystemAutoTeamsPlayful018V1 =>
      'Potete inventarvi un nome da guerra, anche se Tarci non lo salva ancora.';

  @override
  String get chatSystemAutoTeamsPlayful019V1 =>
      'Inizia la parte migliore: discutere se il sorteggio era giusto.';

  @override
  String get chatSystemAutoTeamsPlayful020V1 =>
      'Tarci non prende partito. Ma tiene screenshot mentali dello sfotto.';

  @override
  String get chatSystemAutoTeamsChallenge001V1 =>
      'Sfida del giorno: ogni squadra spieghi perché merita di vincere.';

  @override
  String get chatSystemAutoTeamsChallenge002V1 =>
      'Chi osa lanciare la prima sfida amichevole?';

  @override
  String get chatSystemAutoTeamsChallenge003V1 =>
      'La squadra che non scrive oggi perde a livello di carisma.';

  @override
  String get chatSystemAutoTeamsChallenge004V1 =>
      'Regola non ufficiale: chi parla di più poi deve rispondere.';

  @override
  String get chatSystemAutoTeamsChallenge005V1 =>
      'C\'è un favorito o fingiamo ancora umiltà?';

  @override
  String get chatSystemAutoTeamsChallenge006V1 =>
      'Lasciate il segno: quale squadra si prende la gloria?';

  @override
  String get chatSystemAutoTeamsChallenge007V1 =>
      'Sfida leggera: fate la previsione prima dell\'incontro.';

  @override
  String get chatSystemAutoTeamsChallenge008V1 =>
      'Se c\'è fiducia, che ci siano scommesse simboliche.';

  @override
  String get chatSystemAutoTeamsChallenge009V1 =>
      'Quale squadra porta strategia e quale solo cuore?';

  @override
  String get chatSystemAutoTeamsChallenge010V1 =>
      'Momento di dichiarare le intenzioni. Il silenzio non fa punti.';

  @override
  String get chatSystemAutoTeamsChallenge011V1 =>
      'Ogni squadra nomini un portavoce spontaneo. Poi negate di averlo scelto.';

  @override
  String get chatSystemAutoTeamsChallenge012V1 =>
      'Chi rompe il ghiaccio con la prima provocazione elegante?';

  @override
  String get chatSystemAutoTeamsQuiet001V1 =>
      'Molto silenzio per squadre così promettenti.';

  @override
  String get chatSystemAutoTeamsQuiet002V1 =>
      'Questa chat è più tranquilla della panchina prima del fischio.';

  @override
  String get chatSystemAutoTeamsQuiet003V1 =>
      'Nessuno commenterà il sorteggio? Sospetto.';

  @override
  String get chatSystemAutoTeamsQuiet004V1 =>
      'Tarci rileva calma. A volte significa strategia.';

  @override
  String get chatSystemAutoTeamsQuiet005V1 =>
      'Le squadre ci sono. La chat aspetta ancora il primo bello sfotto.';

  @override
  String get chatSystemAutoTeamsQuiet006V1 =>
      'Un gruppo silenzioso non è pace: è tensione drammatica.';

  @override
  String get chatSystemAutoTeamsQuiet007V1 =>
      'Tutti d\'accordo? Quell\'unanimità merita una revisione.';

  @override
  String get chatSystemAutoTeamsQuiet008V1 =>
      'Silenzio tattico attivato. Continuate, resta elegante.';

  @override
  String get chatSystemAutoTeamsCountdown014V1 =>
      'Mancano 14 giorni. Tempo di organizzarsi… o improvvisare con fiducia.';

  @override
  String get chatSystemAutoTeamsCountdown007V1 =>
      'Manca una settimana. Le strategie assurde possono presentarsi ufficialmente.';

  @override
  String get chatSystemAutoTeamsCountdown003V1 =>
      'Restano 3 giorni. A questo punto l\'epica è permessa.';

  @override
  String get chatSystemAutoTeamsCountdown001V1 =>
      'Domani è il giorno. Ultima chance di vantarsi senza conseguenze.';

  @override
  String get chatSystemAutoTeamsCountdown000V1 =>
      'Oggi si gioca. Squadre pronte, nervi opzionali.';

  @override
  String get chatSystemAutoTeamsCountdownExtra001V1 =>
      'Due settimane sembrano tante finché qualcuno ricorda di non aver preparato nulla.';

  @override
  String get chatSystemAutoTeamsCountdownExtra002V1 =>
      'Sette giorni. Abbastanza per allenarsi o perfezionare una scusa.';

  @override
  String get chatSystemAutoTeamsCountdownExtra003V1 =>
      'Tre giorni. La chat può passare da battute a dichiarazioni ufficiali.';

  @override
  String get chatSystemAutoTeamsCountdownExtra004V1 =>
      'Resta un giorno. Se c\'era un piano segreto, è il momento di fingere che esista.';

  @override
  String get chatSystemAutoTeamsCountdownExtra005V1 =>
      'È il momento. Che vinca il migliore… o chi lo nasconde meglio.';

  @override
  String get teamsChatSectionTitle => 'Conversazione di gruppo';

  @override
  String get teamsChatSectionSubtitle =>
      'Commentate il sorteggio, le sfide e il giorno dell\'incontro.';

  @override
  String get teamsChatEnterCta => 'Apri chat';

  @override
  String get chatTeamsCompletedChip => 'Squadre pronte';

  @override
  String get chatSystemTeamsCompletedV1 =>
      'Le squadre sono pronte. Ora sì: che inizi lo sfotto.';

  @override
  String get teamsMemberWaitingTitle => 'Squadre in preparazione';

  @override
  String get teamsMemberWaitingBody =>
      'L\'organizzatore sta preparando il sorteggio. Quando le squadre saranno pronte potrai vederle qui ed entrare nella chat di gruppo.';

  @override
  String teamsMemberPoolSummary(int count) {
    return '$count partecipanti nel gruppo';
  }

  @override
  String teamsOrganizerByline(String name) {
    return 'Organizzato da $name';
  }

  @override
  String get teamsResultActionsTitle => 'Azioni sul risultato';

  @override
  String get teamsRenameDialogTitle => 'Rinomina squadra';

  @override
  String get teamsRenameDialogFieldLabel => 'Nome della squadra';

  @override
  String get teamsRenameSuccess => 'Nome della squadra aggiornato';

  @override
  String get teamsYouInTeam => 'Tu';

  @override
  String get teamsDetailRosterTitle => 'Partecipanti del gruppo';
}
