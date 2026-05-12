import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Tarci Secret'**
  String get appName;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @create.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get create;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @goToGroup.
  ///
  /// In es, this message translates to:
  /// **'Ir al grupo'**
  String get goToGroup;

  /// No description provided for @copyCode.
  ///
  /// In es, this message translates to:
  /// **'Copiar código'**
  String get copyCode;

  /// No description provided for @codeCopied.
  ///
  /// In es, this message translates to:
  /// **'Código copiado'**
  String get codeCopied;

  /// No description provided for @joinWithCode.
  ///
  /// In es, this message translates to:
  /// **'Unirme con código'**
  String get joinWithCode;

  /// No description provided for @joinScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Unirme con código'**
  String get joinScreenTitle;

  /// No description provided for @joinScreenHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'Pega tu código de invitación'**
  String get joinScreenHeroTitle;

  /// No description provided for @joinScreenHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu organizador te lo compartió por mensaje. Cuando lo introduzcas, te uniremos a su grupo.'**
  String get joinScreenHeroSubtitle;

  /// No description provided for @joinScreenCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación'**
  String get joinScreenCodeLabel;

  /// No description provided for @joinScreenCodeHint.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo, AB12CD'**
  String get joinScreenCodeHint;

  /// No description provided for @joinScreenCodeHelper.
  ///
  /// In es, this message translates to:
  /// **'Las mayúsculas no importan, lo arreglamos por ti.'**
  String get joinScreenCodeHelper;

  /// No description provided for @joinScreenCodeRequired.
  ///
  /// In es, this message translates to:
  /// **'Pega o escribe el código que recibiste.'**
  String get joinScreenCodeRequired;

  /// No description provided for @joinScreenCodeTooShort.
  ///
  /// In es, this message translates to:
  /// **'Ese código parece incompleto. Revísalo y vuelve a intentar.'**
  String get joinScreenCodeTooShort;

  /// No description provided for @joinScreenNicknameLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre'**
  String get joinScreenNicknameLabel;

  /// No description provided for @joinScreenNicknameHelper.
  ///
  /// In es, this message translates to:
  /// **'Así te verá el grupo.'**
  String get joinScreenNicknameHelper;

  /// No description provided for @joinScreenNicknameRequired.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos cómo te llamas para presentarte al grupo.'**
  String get joinScreenNicknameRequired;

  /// No description provided for @joinScreenNicknameTooShort.
  ///
  /// In es, this message translates to:
  /// **'Pon al menos 3 letras para que el grupo te reconozca.'**
  String get joinScreenNicknameTooShort;

  /// No description provided for @joinScreenCta.
  ///
  /// In es, this message translates to:
  /// **'Unirme al grupo'**
  String get joinScreenCta;

  /// No description provided for @joinScreenCtaLoading.
  ///
  /// In es, this message translates to:
  /// **'Uniéndote…'**
  String get joinScreenCtaLoading;

  /// No description provided for @joinScreenSuccessSnackbar.
  ///
  /// In es, this message translates to:
  /// **'¡Estás dentro!'**
  String get joinScreenSuccessSnackbar;

  /// No description provided for @joinSuccessTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Ya estás dentro!'**
  String get joinSuccessTitle;

  /// No description provided for @joinSuccessSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Te uniste a {groupName}. En un momento podrás ver al resto del grupo.'**
  String joinSuccessSubtitle(String groupName);

  /// No description provided for @joinSuccessChooseSubgroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Elige tu casa o equipo'**
  String get joinSuccessChooseSubgroupTitle;

  /// No description provided for @joinSuccessChooseSubgroupHelp.
  ///
  /// In es, this message translates to:
  /// **'El organizador creó casas o equipos. Elige el tuyo para que el sorteo te coloque bien.'**
  String get joinSuccessChooseSubgroupHelp;

  /// No description provided for @joinSuccessSubgroupLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu casa o equipo'**
  String get joinSuccessSubgroupLabel;

  /// No description provided for @joinSuccessNoSubgroupsTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay casas o equipos'**
  String get joinSuccessNoSubgroupsTitle;

  /// No description provided for @joinSuccessNoSubgroupsHelp.
  ///
  /// In es, this message translates to:
  /// **'El organizador todavía no las creó. Puedes continuar y esperar; no necesitas hacer nada más por ahora.'**
  String get joinSuccessNoSubgroupsHelp;

  /// No description provided for @joinSuccessChooseRequired.
  ///
  /// In es, this message translates to:
  /// **'Elige una opción para continuar.'**
  String get joinSuccessChooseRequired;

  /// No description provided for @joinSuccessPrimaryCta.
  ///
  /// In es, this message translates to:
  /// **'Ir al grupo'**
  String get joinSuccessPrimaryCta;

  /// No description provided for @joinSuccessSecondaryCta.
  ///
  /// In es, this message translates to:
  /// **'Quedarme aquí'**
  String get joinSuccessSecondaryCta;

  /// No description provided for @createSecretFriend.
  ///
  /// In es, this message translates to:
  /// **'Crear amigo secreto'**
  String get createSecretFriend;

  /// No description provided for @comingSoonMoreDynamics.
  ///
  /// In es, this message translates to:
  /// **'Próximamente: sorteos, equipos, duelos y emparejamientos.'**
  String get comingSoonMoreDynamics;

  /// No description provided for @mySecretFriend.
  ///
  /// In es, this message translates to:
  /// **'Mi amigo secreto'**
  String get mySecretFriend;

  /// No description provided for @yourSecretFriendIs.
  ///
  /// In es, this message translates to:
  /// **'Tu amigo secreto es…'**
  String get yourSecretFriendIs;

  /// No description provided for @onlyYouCanSeeAssignment.
  ///
  /// In es, this message translates to:
  /// **'Solo tú puedes ver esta asignación.'**
  String get onlyYouCanSeeAssignment;

  /// No description provided for @keepSecretUntilExchangeDay.
  ///
  /// In es, this message translates to:
  /// **'Guarda el secreto hasta el día del intercambio.'**
  String get keepSecretUntilExchangeDay;

  /// No description provided for @managedSecrets.
  ///
  /// In es, this message translates to:
  /// **'Secretos que gestionas'**
  String get managedSecrets;

  /// No description provided for @guardianOfSecret.
  ///
  /// In es, this message translates to:
  /// **'Guardián del secreto'**
  String get guardianOfSecret;

  /// No description provided for @privateResult.
  ///
  /// In es, this message translates to:
  /// **'Resultado privado'**
  String get privateResult;

  /// No description provided for @splashTagline.
  ///
  /// In es, this message translates to:
  /// **'Tarci Secret organiza dinámicas privadas de grupo con personas reales.'**
  String get splashTagline;

  /// No description provided for @quickModeTitle.
  ///
  /// In es, this message translates to:
  /// **'Modo rápido'**
  String get quickModeTitle;

  /// No description provided for @quickModeDescription.
  ///
  /// In es, this message translates to:
  /// **'Puedes empezar sin registrarte. Para conservar tus grupos en varios dispositivos, más adelante podrás crear una cuenta.'**
  String get quickModeDescription;

  /// No description provided for @homeHeaderSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Organiza amigo secreto y sorteos con quien quieras. Privado por defecto.'**
  String get homeHeaderSubtitle;

  /// No description provided for @homeHeroHeadline.
  ///
  /// In es, this message translates to:
  /// **'Amigo secreto y sorteos de grupo'**
  String get homeHeroHeadline;

  /// No description provided for @homeGroupDrawStatePreparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando'**
  String get homeGroupDrawStatePreparing;

  /// No description provided for @homeGroupDrawStateReady.
  ///
  /// In es, this message translates to:
  /// **'Listo para sortear'**
  String get homeGroupDrawStateReady;

  /// No description provided for @homeGroupDrawStateDrawing.
  ///
  /// In es, this message translates to:
  /// **'Sorteo en curso'**
  String get homeGroupDrawStateDrawing;

  /// No description provided for @homeGroupDrawStateCompleted.
  ///
  /// In es, this message translates to:
  /// **'Sorteado'**
  String get homeGroupDrawStateCompleted;

  /// No description provided for @homeGroupDrawStateFailed.
  ///
  /// In es, this message translates to:
  /// **'Revisar sorteo'**
  String get homeGroupDrawStateFailed;

  /// No description provided for @wizardCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear amigo secreto'**
  String get wizardCreateTitle;

  /// No description provided for @wizardStepOf.
  ///
  /// In es, this message translates to:
  /// **'Paso {current} de {total}'**
  String wizardStepOf(int current, int total);

  /// No description provided for @wizardStepNameTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo se llama este amigo secreto?'**
  String get wizardStepNameTitle;

  /// No description provided for @wizardStepGroupTypeTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué tipo de grupo es?'**
  String get wizardStepGroupTypeTitle;

  /// No description provided for @wizardStepModeTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo se organizará?'**
  String get wizardStepModeTitle;

  /// No description provided for @wizardStepRuleTitle.
  ///
  /// In es, this message translates to:
  /// **'Elige la regla del sorteo'**
  String get wizardStepRuleTitle;

  /// No description provided for @wizardStepSubgroupsTitle.
  ///
  /// In es, this message translates to:
  /// **'Subgrupos'**
  String get wizardStepSubgroupsTitle;

  /// No description provided for @wizardStepParticipantsTitle.
  ///
  /// In es, this message translates to:
  /// **'Participantes'**
  String get wizardStepParticipantsTitle;

  /// No description provided for @wizardStepReviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Revisión final'**
  String get wizardStepReviewTitle;

  /// No description provided for @wizardGroupNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del grupo'**
  String get wizardGroupNameLabel;

  /// No description provided for @wizardGroupNameHint.
  ///
  /// In es, this message translates to:
  /// **'Navidad familia 2026'**
  String get wizardGroupNameHint;

  /// No description provided for @wizardNicknameLabel.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo apareces tú?'**
  String get wizardNicknameLabel;

  /// No description provided for @wizardRuleIgnore.
  ///
  /// In es, this message translates to:
  /// **'Ignorar subgrupos'**
  String get wizardRuleIgnore;

  /// No description provided for @wizardRulePrefer.
  ///
  /// In es, this message translates to:
  /// **'Preferir subgrupo diferente'**
  String get wizardRulePrefer;

  /// No description provided for @wizardRuleRequire.
  ///
  /// In es, this message translates to:
  /// **'Exigir subgrupo diferente'**
  String get wizardRuleRequire;

  /// No description provided for @wizardRuleIgnoreDesc.
  ///
  /// In es, this message translates to:
  /// **'Sorteo normal.'**
  String get wizardRuleIgnoreDesc;

  /// No description provided for @wizardRulePreferDesc.
  ///
  /// In es, this message translates to:
  /// **'Intentar cruzar casas, departamentos o grupos.'**
  String get wizardRulePreferDesc;

  /// No description provided for @wizardRuleRequireDesc.
  ///
  /// In es, this message translates to:
  /// **'Solo permitir personas de subgrupos distintos.'**
  String get wizardRuleRequireDesc;

  /// No description provided for @wizardReviewSaveNotice.
  ///
  /// In es, this message translates to:
  /// **'Puedes ajustar participantes y subgrupos después.'**
  String get wizardReviewSaveNotice;

  /// No description provided for @wizardReviewSummaryHelp.
  ///
  /// In es, this message translates to:
  /// **'Comprueba que todo esté bien antes de continuar.'**
  String get wizardReviewSummaryHelp;

  /// No description provided for @wizardCreateButton.
  ///
  /// In es, this message translates to:
  /// **'Crear amigo secreto'**
  String get wizardCreateButton;

  /// No description provided for @wizardCreatedTitle.
  ///
  /// In es, this message translates to:
  /// **'Amigo secreto creado'**
  String get wizardCreatedTitle;

  /// No description provided for @wizardInviteCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación'**
  String get wizardInviteCodeLabel;

  /// No description provided for @wizardInviteCodeDescription.
  ///
  /// In es, this message translates to:
  /// **'Comparte este código para que otras personas se unan.'**
  String get wizardInviteCodeDescription;

  /// No description provided for @managedSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Estos resultados son de personas que dependen de ti. Entrégaselos en privado.'**
  String get managedSubtitle;

  /// No description provided for @managedEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'No tienes secretos gestionados'**
  String get managedEmptyTitle;

  /// No description provided for @managedEmptyMessage.
  ///
  /// In es, this message translates to:
  /// **'Cuando gestiones a un niño o a una persona sin app, verás aquí su resultado.'**
  String get managedEmptyMessage;

  /// No description provided for @managedLoadErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus secretos gestionados'**
  String get managedLoadErrorTitle;

  /// No description provided for @managedLoadErrorMessage.
  ///
  /// In es, this message translates to:
  /// **'Inténtalo de nuevo en unos minutos. Solo verás los resultados de las personas que gestionas.'**
  String get managedLoadErrorMessage;

  /// No description provided for @managedAssignedTo.
  ///
  /// In es, this message translates to:
  /// **'Le toca regalar a…'**
  String get managedAssignedTo;

  /// No description provided for @managedDeliverInPrivate.
  ///
  /// In es, this message translates to:
  /// **'Entrega este resultado en privado'**
  String get managedDeliverInPrivate;

  /// No description provided for @managedHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'Secretos a tu cargo'**
  String get managedHeroTitle;

  /// No description provided for @managedHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tú entregas estos resultados en privado, sin que nadie más se entere.'**
  String get managedHeroSubtitle;

  /// No description provided for @managedRevealLabel.
  ///
  /// In es, this message translates to:
  /// **'Su amigo secreto es'**
  String get managedRevealLabel;

  /// No description provided for @managedDeliveryChipLabel.
  ///
  /// In es, this message translates to:
  /// **'Entrega'**
  String get managedDeliveryChipLabel;

  /// No description provided for @managedFooterPrivacyNote.
  ///
  /// In es, this message translates to:
  /// **'Cada secreto es privado. Solo tú puedes verlo y solo tú lo entregas.'**
  String get managedFooterPrivacyNote;

  /// No description provided for @myAssignmentNotAvailableTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no puedes ver tu amigo secreto'**
  String get myAssignmentNotAvailableTitle;

  /// No description provided for @myAssignmentNotAvailableMessage.
  ///
  /// In es, this message translates to:
  /// **'Tu asignación todavía no está disponible. Cuando el sorteo se complete, podrás verla aquí.'**
  String get myAssignmentNotAvailableMessage;

  /// No description provided for @genericLoadErrorMessage.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar esta información en este momento.'**
  String get genericLoadErrorMessage;

  /// No description provided for @backToGroup.
  ///
  /// In es, this message translates to:
  /// **'Volver al grupo'**
  String get backToGroup;

  /// No description provided for @groupDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle del grupo'**
  String get groupDetailTitle;

  /// No description provided for @groupRoleLabel.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get groupRoleLabel;

  /// No description provided for @groupStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get groupStatusLabel;

  /// No description provided for @groupLastExecution.
  ///
  /// In es, this message translates to:
  /// **'Última'**
  String get groupLastExecution;

  /// No description provided for @groupSectionStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado del grupo'**
  String get groupSectionStatus;

  /// No description provided for @groupSectionPrimaryAction.
  ///
  /// In es, this message translates to:
  /// **'Acción principal'**
  String get groupSectionPrimaryAction;

  /// No description provided for @groupSectionDrawRule.
  ///
  /// In es, this message translates to:
  /// **'Regla del sorteo'**
  String get groupSectionDrawRule;

  /// No description provided for @groupSectionSubgroups.
  ///
  /// In es, this message translates to:
  /// **'Subgrupos'**
  String get groupSectionSubgroups;

  /// No description provided for @groupSectionParticipants.
  ///
  /// In es, this message translates to:
  /// **'Participantes'**
  String get groupSectionParticipants;

  /// No description provided for @groupSectionManagedParticipants.
  ///
  /// In es, this message translates to:
  /// **'Participantes sin app'**
  String get groupSectionManagedParticipants;

  /// No description provided for @groupSectionInvitations.
  ///
  /// In es, this message translates to:
  /// **'Invitaciones'**
  String get groupSectionInvitations;

  /// No description provided for @groupSectionAdvanced.
  ///
  /// In es, this message translates to:
  /// **'Configuración avanzada'**
  String get groupSectionAdvanced;

  /// No description provided for @groupStatusPreparing.
  ///
  /// In es, this message translates to:
  /// **'Sigue la preparación'**
  String get groupStatusPreparing;

  /// No description provided for @groupStatusReadyToDraw.
  ///
  /// In es, this message translates to:
  /// **'Listo para sortear'**
  String get groupStatusReadyToDraw;

  /// No description provided for @groupStatusCompleted.
  ///
  /// In es, this message translates to:
  /// **'¡Vuestros amigos secretos ya están elegidos!'**
  String get groupStatusCompleted;

  /// No description provided for @groupStatusMissingSubgroups.
  ///
  /// In es, this message translates to:
  /// **'Falta colocar a alguien en su grupo'**
  String get groupStatusMissingSubgroups;

  /// No description provided for @groupActionRunDraw.
  ///
  /// In es, this message translates to:
  /// **'Hacer el sorteo ahora'**
  String get groupActionRunDraw;

  /// No description provided for @groupActionViewMySecretFriend.
  ///
  /// In es, this message translates to:
  /// **'Ver mi amigo secreto'**
  String get groupActionViewMySecretFriend;

  /// No description provided for @groupActionManagedSecrets.
  ///
  /// In es, this message translates to:
  /// **'Secretos que gestionas'**
  String get groupActionManagedSecrets;

  /// No description provided for @groupActionCreateSubgroup.
  ///
  /// In es, this message translates to:
  /// **'Crear subgrupo'**
  String get groupActionCreateSubgroup;

  /// No description provided for @groupActionEmptySubgroup.
  ///
  /// In es, this message translates to:
  /// **'Vaciar subgrupo'**
  String get groupActionEmptySubgroup;

  /// No description provided for @groupActionDeleteSubgroup.
  ///
  /// In es, this message translates to:
  /// **'Eliminar subgrupo'**
  String get groupActionDeleteSubgroup;

  /// No description provided for @groupActionGenerateNewCode.
  ///
  /// In es, this message translates to:
  /// **'Generar nuevo código'**
  String get groupActionGenerateNewCode;

  /// No description provided for @groupActionCopyCode.
  ///
  /// In es, this message translates to:
  /// **'Copiar código'**
  String get groupActionCopyCode;

  /// No description provided for @groupActionRename.
  ///
  /// In es, this message translates to:
  /// **'Renombrar'**
  String get groupActionRename;

  /// No description provided for @groupActionEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get groupActionEdit;

  /// No description provided for @groupRoleOrganizer.
  ///
  /// In es, this message translates to:
  /// **'Organizador'**
  String get groupRoleOrganizer;

  /// No description provided for @groupRoleParticipant.
  ///
  /// In es, this message translates to:
  /// **'Participante'**
  String get groupRoleParticipant;

  /// No description provided for @groupTypeAdultNoApp.
  ///
  /// In es, this message translates to:
  /// **'Adulto sin app'**
  String get groupTypeAdultNoApp;

  /// No description provided for @groupTypeChildManaged.
  ///
  /// In es, this message translates to:
  /// **'Niño gestionado'**
  String get groupTypeChildManaged;

  /// No description provided for @groupNoSubgroupAssigned.
  ///
  /// In es, this message translates to:
  /// **'Sin subgrupo asignado'**
  String get groupNoSubgroupAssigned;

  /// No description provided for @groupGuardianOfSecret.
  ///
  /// In es, this message translates to:
  /// **'Guardián del secreto'**
  String get groupGuardianOfSecret;

  /// No description provided for @groupPrivateResult.
  ///
  /// In es, this message translates to:
  /// **'Resultado privado'**
  String get groupPrivateResult;

  /// No description provided for @groupWarningMissingSubgroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Faltan personas por asignar a un subgrupo.'**
  String get groupWarningMissingSubgroupTitle;

  /// No description provided for @groupWarningMissingSubgroupRule.
  ///
  /// In es, this message translates to:
  /// **'Para exigir subgrupo diferente, todos deben tener uno.'**
  String get groupWarningMissingSubgroupRule;

  /// No description provided for @groupWarningMissingSubgroupCombined.
  ///
  /// In es, this message translates to:
  /// **'Faltan personas por asignar a un subgrupo. Para exigir subgrupo diferente, todos deben tener uno.'**
  String get groupWarningMissingSubgroupCombined;

  /// No description provided for @groupDialogDeleteSubgroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar subgrupo'**
  String get groupDialogDeleteSubgroupTitle;

  /// No description provided for @groupDialogDeleteSubgroupBody.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar \"{name}\"? Solo se eliminará si no tiene participantes asignados.'**
  String groupDialogDeleteSubgroupBody(String name);

  /// No description provided for @groupDialogEmptySubgroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Vaciar \"{name}\"'**
  String groupDialogEmptySubgroupTitle(String name);

  /// No description provided for @groupDialogCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get groupDialogCancel;

  /// No description provided for @groupDialogDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get groupDialogDelete;

  /// No description provided for @groupDialogEmpty.
  ///
  /// In es, this message translates to:
  /// **'Vaciar'**
  String get groupDialogEmpty;

  /// No description provided for @groupDialogMoveAndDelete.
  ///
  /// In es, this message translates to:
  /// **'Mover y eliminar'**
  String get groupDialogMoveAndDelete;

  /// No description provided for @groupDialogMoveToSubgroup.
  ///
  /// In es, this message translates to:
  /// **'Mover a otro subgrupo'**
  String get groupDialogMoveToSubgroup;

  /// No description provided for @groupDialogBeforeDeleteMoveTo.
  ///
  /// In es, this message translates to:
  /// **'Antes de eliminar, mover a'**
  String get groupDialogBeforeDeleteMoveTo;

  /// No description provided for @groupDialogLeaveWithoutSubgroup.
  ///
  /// In es, this message translates to:
  /// **'Dejar sin subgrupo'**
  String get groupDialogLeaveWithoutSubgroup;

  /// No description provided for @groupDialogNoAlternativeSubgroup.
  ///
  /// In es, this message translates to:
  /// **'No hay otro subgrupo disponible. Se dejarán sin subgrupo.'**
  String get groupDialogNoAlternativeSubgroup;

  /// No description provided for @groupManagedDialogAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Añadir participante sin app'**
  String get groupManagedDialogAddTitle;

  /// No description provided for @groupManagedDialogEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar participante sin app'**
  String get groupManagedDialogEditTitle;

  /// No description provided for @groupManagedDialogNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get groupManagedDialogNameLabel;

  /// No description provided for @groupManagedDialogTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get groupManagedDialogTypeLabel;

  /// No description provided for @groupManagedDialogTypeAdultNoApp.
  ///
  /// In es, this message translates to:
  /// **'Adulto sin app'**
  String get groupManagedDialogTypeAdultNoApp;

  /// No description provided for @groupManagedDialogTypeChild.
  ///
  /// In es, this message translates to:
  /// **'Niño gestionado'**
  String get groupManagedDialogTypeChild;

  /// No description provided for @groupManagedDialogSubgroupOptionalLabel.
  ///
  /// In es, this message translates to:
  /// **'Subgrupo (opcional)'**
  String get groupManagedDialogSubgroupOptionalLabel;

  /// No description provided for @groupManagedDialogNoSubgroup.
  ///
  /// In es, this message translates to:
  /// **'Sin subgrupo'**
  String get groupManagedDialogNoSubgroup;

  /// No description provided for @groupManagedDialogDeliveryLabel.
  ///
  /// In es, this message translates to:
  /// **'Forma de entrega'**
  String get groupManagedDialogDeliveryLabel;

  /// No description provided for @groupManagedDialogDeliveryVerbal.
  ///
  /// In es, this message translates to:
  /// **'Verbal'**
  String get groupManagedDialogDeliveryVerbal;

  /// No description provided for @groupManagedDialogDeliveryPrinted.
  ///
  /// In es, this message translates to:
  /// **'Impresa'**
  String get groupManagedDialogDeliveryPrinted;

  /// No description provided for @groupManagedDialogWhoManagesTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Quién gestionará su resultado?'**
  String get groupManagedDialogWhoManagesTitle;

  /// No description provided for @groupManagedDialogWhoManagesDesc.
  ///
  /// In es, this message translates to:
  /// **'De momento lo gestionarás tú como organizador.'**
  String get groupManagedDialogWhoManagesDesc;

  /// No description provided for @groupManagedDialogWhoManagesHelp.
  ///
  /// In es, this message translates to:
  /// **'Cuando se integre al sorteo, esta persona no verá el resultado en la app. Tú podrás entregárselo de forma verbal o impresa.'**
  String get groupManagedDialogWhoManagesHelp;

  /// No description provided for @groupManagedDialogManagedBy.
  ///
  /// In es, this message translates to:
  /// **'Gestionado por: {name}'**
  String groupManagedDialogManagedBy(String name);

  /// No description provided for @groupAssignDialogSelfTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu subgrupo'**
  String get groupAssignDialogSelfTitle;

  /// No description provided for @groupAssignDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Asignar subgrupo'**
  String get groupAssignDialogTitle;

  /// No description provided for @groupAssignDialogSelfDesc.
  ///
  /// In es, this message translates to:
  /// **'Elige tu casa, departamento, clase o equipo.'**
  String get groupAssignDialogSelfDesc;

  /// No description provided for @groupAssignDialogDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el subgrupo para este miembro.'**
  String get groupAssignDialogDesc;

  /// No description provided for @groupAssignDialogSubgroupLabel.
  ///
  /// In es, this message translates to:
  /// **'Subgrupo'**
  String get groupAssignDialogSubgroupLabel;

  /// No description provided for @groupSnackbarWriteName.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre'**
  String get groupSnackbarWriteName;

  /// No description provided for @groupSnackbarDrawCompleted.
  ///
  /// In es, this message translates to:
  /// **'Sorteo completado'**
  String get groupSnackbarDrawCompleted;

  /// No description provided for @groupSnackbarSubgroupUpdated.
  ///
  /// In es, this message translates to:
  /// **'Subgrupo actualizado'**
  String get groupSnackbarSubgroupUpdated;

  /// No description provided for @groupSnackbarGroupNameUpdated.
  ///
  /// In es, this message translates to:
  /// **'Nombre del grupo actualizado'**
  String get groupSnackbarGroupNameUpdated;

  /// No description provided for @groupSnackbarRuleUpdated.
  ///
  /// In es, this message translates to:
  /// **'Regla de sorteo actualizada'**
  String get groupSnackbarRuleUpdated;

  /// No description provided for @groupSnackbarNewCodeGenerated.
  ///
  /// In es, this message translates to:
  /// **'Nuevo código generado'**
  String get groupSnackbarNewCodeGenerated;

  /// No description provided for @groupSnackbarManagedAdded.
  ///
  /// In es, this message translates to:
  /// **'Participante sin app añadido'**
  String get groupSnackbarManagedAdded;

  /// No description provided for @groupSnackbarManagedUpdated.
  ///
  /// In es, this message translates to:
  /// **'Participante sin app actualizado'**
  String get groupSnackbarManagedUpdated;

  /// No description provided for @groupSnackbarManagedDeleted.
  ///
  /// In es, this message translates to:
  /// **'Participante sin app eliminado'**
  String get groupSnackbarManagedDeleted;

  /// No description provided for @groupDialogEditGroupNameTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar nombre del grupo'**
  String get groupDialogEditGroupNameTitle;

  /// No description provided for @groupDialogGroupNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del grupo'**
  String get groupDialogGroupNameLabel;

  /// No description provided for @groupDialogRenameSubgroupTitle.
  ///
  /// In es, this message translates to:
  /// **'Renombrar subgrupo'**
  String get groupDialogRenameSubgroupTitle;

  /// No description provided for @groupDialogSubgroupNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del subgrupo'**
  String get groupDialogSubgroupNameLabel;

  /// No description provided for @groupDialogDeleteParticipantTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar participante'**
  String get groupDialogDeleteParticipantTitle;

  /// No description provided for @groupDialogDeleteParticipantBody.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar a \"{name}\"?'**
  String groupDialogDeleteParticipantBody(String name);

  /// No description provided for @groupDialogSubgroupAssignedCount.
  ///
  /// In es, this message translates to:
  /// **'Hay {count} participantes asignados a este subgrupo.'**
  String groupDialogSubgroupAssignedCount(int count);

  /// No description provided for @groupDialogSubgroupAssignedCountDelete.
  ///
  /// In es, this message translates to:
  /// **'Este subgrupo tiene {count} participantes asignados.'**
  String groupDialogSubgroupAssignedCountDelete(int count);

  /// No description provided for @languageSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get languageSystem;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get languageEnglish;

  /// No description provided for @languageSelectorTitle.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageSelectorTitle;

  /// No description provided for @languageSelectorSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Elige cómo quieres ver la app'**
  String get languageSelectorSubtitle;

  /// No description provided for @homePrimaryActionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Acciones principales'**
  String get homePrimaryActionsTitle;

  /// No description provided for @homeComingSoonDescription.
  ///
  /// In es, this message translates to:
  /// **'Próximamente: sorteos, equipos, duelos y emparejamientos.'**
  String get homeComingSoonDescription;

  /// No description provided for @homeChipDraws.
  ///
  /// In es, this message translates to:
  /// **'Sorteos'**
  String get homeChipDraws;

  /// No description provided for @homeChipTeams.
  ///
  /// In es, this message translates to:
  /// **'Equipos'**
  String get homeChipTeams;

  /// No description provided for @homeChipPairings.
  ///
  /// In es, this message translates to:
  /// **'Emparejamientos'**
  String get homeChipPairings;

  /// No description provided for @homeActiveGroupsTitle.
  ///
  /// In es, this message translates to:
  /// **'Grupos activos'**
  String get homeActiveGroupsTitle;

  /// No description provided for @homeActiveGroupsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Estado del sorteo según lo último guardado en el grupo.'**
  String get homeActiveGroupsSubtitle;

  /// No description provided for @homeEmptyGroupsTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes grupos'**
  String get homeEmptyGroupsTitle;

  /// No description provided for @homeEmptyGroupsMessage.
  ///
  /// In es, this message translates to:
  /// **'Crea tu primer amigo secreto o únete con un código.'**
  String get homeEmptyGroupsMessage;

  /// No description provided for @homeStatusActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get homeStatusActive;

  /// No description provided for @homeStatusInactive.
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get homeStatusInactive;

  /// No description provided for @homeCompletedGroupsTitle.
  ///
  /// In es, this message translates to:
  /// **'Grupos completados'**
  String get homeCompletedGroupsTitle;

  /// No description provided for @homeCompletedArchivedLabel.
  ///
  /// In es, this message translates to:
  /// **'Completado / archivado'**
  String get homeCompletedArchivedLabel;

  /// No description provided for @homeDebugToolsTitle.
  ///
  /// In es, this message translates to:
  /// **'Herramientas de desarrollo'**
  String get homeDebugToolsTitle;

  /// No description provided for @homeDebugUid.
  ///
  /// In es, this message translates to:
  /// **'UID de prueba: {uid}'**
  String homeDebugUid(String uid);

  /// No description provided for @homeDebugUserSwitchHint.
  ///
  /// In es, this message translates to:
  /// **'Cambiar de usuario de prueba hará que veas otros grupos, porque cada usuario tiene su propia lista.'**
  String get homeDebugUserSwitchHint;

  /// No description provided for @homeDebugResetUser.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión y crear nuevo usuario de prueba'**
  String get homeDebugResetUser;

  /// No description provided for @homeEnvironmentEmulator.
  ///
  /// In es, this message translates to:
  /// **'Entorno: Emulador local'**
  String get homeEnvironmentEmulator;

  /// No description provided for @homeEnvironmentFirebase.
  ///
  /// In es, this message translates to:
  /// **'Entorno: Firebase real dev'**
  String get homeEnvironmentFirebase;

  /// No description provided for @homePrivacyFooter.
  ///
  /// In es, this message translates to:
  /// **'Tu asignación y resultados se mantienen privados por defecto.'**
  String get homePrivacyFooter;

  /// No description provided for @wizardTypeFamily.
  ///
  /// In es, this message translates to:
  /// **'Familia'**
  String get wizardTypeFamily;

  /// No description provided for @wizardTypeFriends.
  ///
  /// In es, this message translates to:
  /// **'Amigos'**
  String get wizardTypeFriends;

  /// No description provided for @wizardTypeCompany.
  ///
  /// In es, this message translates to:
  /// **'Empresa'**
  String get wizardTypeCompany;

  /// No description provided for @wizardTypeClass.
  ///
  /// In es, this message translates to:
  /// **'Clase'**
  String get wizardTypeClass;

  /// No description provided for @wizardTypeOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get wizardTypeOther;

  /// No description provided for @wizardModeInPerson.
  ///
  /// In es, this message translates to:
  /// **'Presencial'**
  String get wizardModeInPerson;

  /// No description provided for @wizardModeRemote.
  ///
  /// In es, this message translates to:
  /// **'Remoto'**
  String get wizardModeRemote;

  /// No description provided for @wizardModeMixed.
  ///
  /// In es, this message translates to:
  /// **'Mixto'**
  String get wizardModeMixed;

  /// No description provided for @wizardCreateFunctionsError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear el grupo. Revisa si estás usando emuladores o Firebase real y si las Functions están desplegadas.'**
  String get wizardCreateFunctionsError;

  /// No description provided for @wizardNameHelp.
  ///
  /// In es, this message translates to:
  /// **'Pon un nombre que identifique el grupo.'**
  String get wizardNameHelp;

  /// No description provided for @wizardGroupTypeHelp.
  ///
  /// In es, this message translates to:
  /// **'Este dato guía la experiencia. Por ahora no se guarda.'**
  String get wizardGroupTypeHelp;

  /// No description provided for @wizardModeHelp.
  ///
  /// In es, this message translates to:
  /// **'Define cómo se organizará el grupo. Por ahora es preparación UX.'**
  String get wizardModeHelp;

  /// No description provided for @wizardRuleHelp.
  ///
  /// In es, this message translates to:
  /// **'Esta configuración sí se guarda en el grupo.'**
  String get wizardRuleHelp;

  /// No description provided for @wizardSubgroupsHelpIgnore.
  ///
  /// In es, this message translates to:
  /// **'Con esta regla no necesitas subgrupos ahora.'**
  String get wizardSubgroupsHelpIgnore;

  /// No description provided for @wizardSubgroupsHelpEnabled.
  ///
  /// In es, this message translates to:
  /// **'Podrás crear y asignar subgrupos desde el detalle del grupo.'**
  String get wizardSubgroupsHelpEnabled;

  /// No description provided for @wizardParticipantsHelp.
  ///
  /// In es, this message translates to:
  /// **'Luego podrás invitar por código y añadir personas sin app.'**
  String get wizardParticipantsHelp;

  /// No description provided for @wizardSummaryName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get wizardSummaryName;

  /// No description provided for @wizardSummaryGroupType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de grupo'**
  String get wizardSummaryGroupType;

  /// No description provided for @wizardSummaryMode.
  ///
  /// In es, this message translates to:
  /// **'Modalidad'**
  String get wizardSummaryMode;

  /// No description provided for @wizardSummaryRule.
  ///
  /// In es, this message translates to:
  /// **'Regla de sorteo'**
  String get wizardSummaryRule;

  /// No description provided for @groupRoleAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get groupRoleAdmin;

  /// No description provided for @groupRoleMember.
  ///
  /// In es, this message translates to:
  /// **'Miembro'**
  String get groupRoleMember;

  /// No description provided for @groupRuleIgnoreTitle.
  ///
  /// In es, this message translates to:
  /// **'Ignorar subgrupos'**
  String get groupRuleIgnoreTitle;

  /// No description provided for @groupRulePreferTitle.
  ///
  /// In es, this message translates to:
  /// **'Preferir subgrupo diferente'**
  String get groupRulePreferTitle;

  /// No description provided for @groupRuleRequireTitle.
  ///
  /// In es, this message translates to:
  /// **'Exigir subgrupo diferente'**
  String get groupRuleRequireTitle;

  /// No description provided for @groupRuleIgnoreDescription.
  ///
  /// In es, this message translates to:
  /// **'Sorteo normal. No tiene en cuenta casas, departamentos o clases.'**
  String get groupRuleIgnoreDescription;

  /// No description provided for @groupRulePreferDescription.
  ///
  /// In es, this message translates to:
  /// **'Tarci Secret intentará cruzar regalos entre subgrupos diferentes, pero no bloqueará el sorteo si no es posible.'**
  String get groupRulePreferDescription;

  /// No description provided for @groupRuleRequireDescription.
  ///
  /// In es, this message translates to:
  /// **'Nadie podrá regalar a alguien de su mismo subgrupo. Puede fallar si el grupo no permite una combinación válida.'**
  String get groupRuleRequireDescription;

  /// No description provided for @groupSnackNeedThreeParticipants.
  ///
  /// In es, this message translates to:
  /// **'Necesitas al menos 3 participantes efectivos para hacer un sorteo divertido.'**
  String get groupSnackNeedThreeParticipants;

  /// No description provided for @groupSnackDrawAlreadyRunningOrDone.
  ///
  /// In es, this message translates to:
  /// **'No se puede ejecutar un nuevo sorteo mientras está en curso o completado.'**
  String get groupSnackDrawAlreadyRunningOrDone;

  /// No description provided for @groupSnackCannotAddAfterDraw.
  ///
  /// In es, this message translates to:
  /// **'No puedes añadir participantes después de ejecutar el sorteo.'**
  String get groupSnackCannotAddAfterDraw;

  /// No description provided for @groupTooltipEditGroupName.
  ///
  /// In es, this message translates to:
  /// **'Editar nombre del grupo'**
  String get groupTooltipEditGroupName;

  /// No description provided for @groupStatusCompletedInfo.
  ///
  /// In es, this message translates to:
  /// **'Cada persona ya puede ver a quién le toca regalar.'**
  String get groupStatusCompletedInfo;

  /// No description provided for @groupStatusReadyInfo.
  ///
  /// In es, this message translates to:
  /// **'Al lanzarlo, cada quien verá su asignación en privado.'**
  String get groupStatusReadyInfo;

  /// No description provided for @groupStatusPendingInfo.
  ///
  /// In es, this message translates to:
  /// **'Revisa participantes o subgrupos pendientes.'**
  String get groupStatusPendingInfo;

  /// No description provided for @groupEffectiveParticipants.
  ///
  /// In es, this message translates to:
  /// **'Tienes {count} de 3 personas mínimas'**
  String groupEffectiveParticipants(int count);

  /// No description provided for @groupOwnerCanRunHint.
  ///
  /// In es, this message translates to:
  /// **'Cuando todo esté listo, el organizador lanza el sorteo.'**
  String get groupOwnerCanRunHint;

  /// No description provided for @groupPendingSubgroupHint.
  ///
  /// In es, this message translates to:
  /// **'Asigna a cada persona a su grupo y ya estamos.'**
  String get groupPendingSubgroupHint;

  /// No description provided for @groupPendingGeneralHint.
  ///
  /// In es, this message translates to:
  /// **'Te falta poco para poder hacer el sorteo.'**
  String get groupPendingGeneralHint;

  /// No description provided for @groupRuleConfigVersion.
  ///
  /// In es, this message translates to:
  /// **'Configuración v{version}'**
  String groupRuleConfigVersion(int version);

  /// No description provided for @groupRuleLockedHint.
  ///
  /// In es, this message translates to:
  /// **'La regla no se puede cambiar mientras el sorteo está en curso o ya se completó.'**
  String get groupRuleLockedHint;

  /// No description provided for @groupSubgroupSectionHelp.
  ///
  /// In es, this message translates to:
  /// **'Organiza casas, departamentos, clases o equipos para mejorar el sorteo.'**
  String get groupSubgroupSectionHelp;

  /// No description provided for @groupSubgroupEmptyHelp.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay subgrupos. Puedes crear uno para organizar mejor el grupo.'**
  String get groupSubgroupEmptyHelp;

  /// No description provided for @groupSubgroupAssignedOne.
  ///
  /// In es, this message translates to:
  /// **'1 participante asignado'**
  String get groupSubgroupAssignedOne;

  /// No description provided for @groupSubgroupAssignedMany.
  ///
  /// In es, this message translates to:
  /// **'{count} participantes asignados'**
  String groupSubgroupAssignedMany(int count);

  /// No description provided for @groupSubgroupLockedHint.
  ///
  /// In es, this message translates to:
  /// **'No puedes modificar subgrupos después de ejecutar el sorteo.'**
  String get groupSubgroupLockedHint;

  /// No description provided for @groupSubgroupDisabledHint.
  ///
  /// In es, this message translates to:
  /// **'Subgrupos desactivados para este sorteo. Puedes habilitarlos cambiando la regla.'**
  String get groupSubgroupDisabledHint;

  /// No description provided for @groupParticipantSubgroupLockedHint.
  ///
  /// In es, this message translates to:
  /// **'El subgrupo no se puede cambiar mientras el sorteo está en curso o ya se completó.'**
  String get groupParticipantSubgroupLockedHint;

  /// No description provided for @groupManagedSectionHelp.
  ///
  /// In es, this message translates to:
  /// **'Estos participantes no usan la app y su resultado se entrega de forma privada.'**
  String get groupManagedSectionHelp;

  /// No description provided for @groupManagedEmptyHelp.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay participantes gestionados.'**
  String get groupManagedEmptyHelp;

  /// No description provided for @groupManagedGuardianSelf.
  ///
  /// In es, this message translates to:
  /// **'tú'**
  String get groupManagedGuardianSelf;

  /// No description provided for @groupManagedGuardianOther.
  ///
  /// In es, this message translates to:
  /// **'otro responsable'**
  String get groupManagedGuardianOther;

  /// No description provided for @groupManagedPrivateDeliveryHint.
  ///
  /// In es, this message translates to:
  /// **'Participan sin app y su resultado se entrega de forma privada.'**
  String get groupManagedPrivateDeliveryHint;

  /// No description provided for @groupInvitationsHelp.
  ///
  /// In es, this message translates to:
  /// **'Genera un código y compártelo para que se unan participantes.'**
  String get groupInvitationsHelp;

  /// No description provided for @groupInvitationCodeTapHint.
  ///
  /// In es, this message translates to:
  /// **'Toca el código para copiarlo'**
  String get groupInvitationCodeTapHint;

  /// No description provided for @groupInvitationsClosedHint.
  ///
  /// In es, this message translates to:
  /// **'Las invitaciones están cerradas porque el sorteo ya fue ejecutado.'**
  String get groupInvitationsClosedHint;

  /// No description provided for @groupAdvancedHelp.
  ///
  /// In es, this message translates to:
  /// **'Aquí se muestran detalles secundarios del grupo.'**
  String get groupAdvancedHelp;

  /// No description provided for @groupAdvancedLastExecution.
  ///
  /// In es, this message translates to:
  /// **'Última ejecución: {id}'**
  String groupAdvancedLastExecution(String id);

  /// No description provided for @groupAdvancedInternalStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado interno del sorteo: {status}'**
  String groupAdvancedInternalStatus(String status);

  /// No description provided for @groupCreateSubgroupHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Casa Stan, Ventas, Clase 3A'**
  String get groupCreateSubgroupHint;

  /// No description provided for @groupHeaderSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Prepara tu sorteo con privacidad y claridad.'**
  String get groupHeaderSubtitle;

  /// No description provided for @groupDetailTaglinePostDraw.
  ///
  /// In es, this message translates to:
  /// **'Resultados en privado: cada quien ve lo suyo.'**
  String get groupDetailTaglinePostDraw;

  /// No description provided for @groupMemberPreDrawSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ya estás dentro. Cuando el organizador lance el sorteo, podrás ver tu asignación en privado.'**
  String get groupMemberPreDrawSubtitle;

  /// No description provided for @groupMemberYourHouseTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu casa o equipo'**
  String get groupMemberYourHouseTitle;

  /// No description provided for @groupMemberYourHousePickHint.
  ///
  /// In es, this message translates to:
  /// **'El organizador definió equipos o casas. Elige el tuyo para ubicarte bien en el sorteo.'**
  String get groupMemberYourHousePickHint;

  /// No description provided for @groupMemberYourHouseAssigned.
  ///
  /// In es, this message translates to:
  /// **'Te hemos ubicado en: {name}'**
  String groupMemberYourHouseAssigned(String name);

  /// No description provided for @groupMemberYourHouseChooseCta.
  ///
  /// In es, this message translates to:
  /// **'Elegir mi casa o equipo'**
  String get groupMemberYourHouseChooseCta;

  /// No description provided for @groupMemberYourHouseChangeCta.
  ///
  /// In es, this message translates to:
  /// **'Cambiar mi casa o equipo'**
  String get groupMemberYourHouseChangeCta;

  /// No description provided for @groupMemberManagedByYouTitle.
  ///
  /// In es, this message translates to:
  /// **'Personas que gestionas aquí'**
  String get groupMemberManagedByYouTitle;

  /// No description provided for @groupMemberManagedByYouSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Solo verás a quienes el organizador te asignó como responsable.'**
  String get groupMemberManagedByYouSubtitle;

  /// No description provided for @groupMemberHeroTitlePreDraw.
  ///
  /// In es, this message translates to:
  /// **'Ya estás dentro'**
  String get groupMemberHeroTitlePreDraw;

  /// No description provided for @groupMemberHeroSubtitlePreDraw.
  ///
  /// In es, this message translates to:
  /// **'Cuando el organizador lance el sorteo, verás tu asignación en privado.'**
  String get groupMemberHeroSubtitlePreDraw;

  /// No description provided for @groupMemberHeroTaglinePreDraw.
  ///
  /// In es, this message translates to:
  /// **'Tu grupo, tu espacio. Nadie ve el resultado de los demás.'**
  String get groupMemberHeroTaglinePreDraw;

  /// No description provided for @groupMemberHeroTaglinePostDraw.
  ///
  /// In es, this message translates to:
  /// **'Sorteo listo. Solo tú ves lo que te tocó.'**
  String get groupMemberHeroTaglinePostDraw;

  /// No description provided for @groupMemberPostDrawHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Abre tu resultado cuando quieras; es privado.'**
  String get groupMemberPostDrawHeroSubtitle;

  /// No description provided for @groupMemberHeroSubtitleDrawing.
  ///
  /// In es, this message translates to:
  /// **'Estamos sorteando. En un momento podrás ver tu resultado.'**
  String get groupMemberHeroSubtitleDrawing;

  /// No description provided for @groupBackToDashboard.
  ///
  /// In es, this message translates to:
  /// **'Volver al dashboard'**
  String get groupBackToDashboard;

  /// No description provided for @groupLoadingDetail.
  ///
  /// In es, this message translates to:
  /// **'Cargando grupo...'**
  String get groupLoadingDetail;

  /// No description provided for @groupErrorTitle.
  ///
  /// In es, this message translates to:
  /// **'No pudimos abrir este grupo'**
  String get groupErrorTitle;

  /// No description provided for @groupErrorNotFound.
  ///
  /// In es, this message translates to:
  /// **'Este grupo ya no está disponible o no tienes acceso.'**
  String get groupErrorNotFound;

  /// No description provided for @groupPreparationTitle.
  ///
  /// In es, this message translates to:
  /// **'Estado del grupo'**
  String get groupPreparationTitle;

  /// No description provided for @groupPreparationQuickSummary.
  ///
  /// In es, this message translates to:
  /// **'{total} personas en el sorteo · {withoutApp} sin app · {subgroups} subgrupos'**
  String groupPreparationQuickSummary(int total, int withoutApp, int subgroups);

  /// No description provided for @groupPostDrawHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'Sorteo realizado'**
  String get groupPostDrawHeroTitle;

  /// No description provided for @groupPostDrawHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ya puedes ver lo que te corresponde, en privado.'**
  String get groupPostDrawHeroSubtitle;

  /// No description provided for @groupChecklistEnoughPeopleDone.
  ///
  /// In es, this message translates to:
  /// **'Ya tenéis suficientes personas'**
  String get groupChecklistEnoughPeopleDone;

  /// No description provided for @groupChecklistEnoughPeopleMissing.
  ///
  /// In es, this message translates to:
  /// **'Necesitas al menos 3 personas'**
  String get groupChecklistEnoughPeopleMissing;

  /// No description provided for @groupChecklistAllInSubgroupDone.
  ///
  /// In es, this message translates to:
  /// **'Todos están en su subgrupo'**
  String get groupChecklistAllInSubgroupDone;

  /// No description provided for @groupChecklistMissingSubgroupOne.
  ///
  /// In es, this message translates to:
  /// **'Falta colocar a 1 persona en su subgrupo'**
  String get groupChecklistMissingSubgroupOne;

  /// No description provided for @groupChecklistMissingSubgroupMany.
  ///
  /// In es, this message translates to:
  /// **'Faltan {count} personas por colocar en su subgrupo'**
  String groupChecklistMissingSubgroupMany(int count);

  /// No description provided for @groupChecklistPendingMembers.
  ///
  /// In es, this message translates to:
  /// **'{count} persona(s) salieron o fueron retiradas'**
  String groupChecklistPendingMembers(int count);

  /// No description provided for @groupPreparationRegistered.
  ///
  /// In es, this message translates to:
  /// **'Registrados: {count}'**
  String groupPreparationRegistered(int count);

  /// No description provided for @groupPreparationManaged.
  ///
  /// In es, this message translates to:
  /// **'Gestionados: {count}'**
  String groupPreparationManaged(int count);

  /// No description provided for @groupPreparationPending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes: {count}'**
  String groupPreparationPending(int count);

  /// No description provided for @groupPreparationMissingSubgroup.
  ///
  /// In es, this message translates to:
  /// **'Sin subgrupo: {count}'**
  String groupPreparationMissingSubgroup(int count);

  /// No description provided for @groupRuleCurrentLabel.
  ///
  /// In es, this message translates to:
  /// **'Regla actual'**
  String get groupRuleCurrentLabel;

  /// No description provided for @groupRuleChangeCta.
  ///
  /// In es, this message translates to:
  /// **'Cambiar regla'**
  String get groupRuleChangeCta;

  /// No description provided for @groupSectionExpandHint.
  ///
  /// In es, this message translates to:
  /// **'Toca para expandir'**
  String get groupSectionExpandHint;

  /// No description provided for @groupSectionCollapseHint.
  ///
  /// In es, this message translates to:
  /// **'Toca para cerrar'**
  String get groupSectionCollapseHint;

  /// No description provided for @groupSectionItemsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} en total'**
  String groupSectionItemsCount(int count);

  /// No description provided for @groupManagedDialogGuardianSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Quién entregará el resultado?'**
  String get groupManagedDialogGuardianSectionTitle;

  /// No description provided for @groupManagedDialogGuardianMe.
  ///
  /// In es, this message translates to:
  /// **'Yo'**
  String get groupManagedDialogGuardianMe;

  /// No description provided for @groupManagedDialogGuardianMeHint.
  ///
  /// In es, this message translates to:
  /// **'Compartiré el resultado en privado'**
  String get groupManagedDialogGuardianMeHint;

  /// No description provided for @groupManagedDialogGuardianOther.
  ///
  /// In es, this message translates to:
  /// **'Otro miembro'**
  String get groupManagedDialogGuardianOther;

  /// No description provided for @groupManagedDialogGuardianSpecific.
  ///
  /// In es, this message translates to:
  /// **'Responsable específico'**
  String get groupManagedDialogGuardianSpecific;

  /// No description provided for @groupManagedDialogGuardianComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get groupManagedDialogGuardianComingSoon;

  /// No description provided for @groupManagedDialogDeliverySectionTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo se lo harás llegar?'**
  String get groupManagedDialogDeliverySectionTitle;

  /// No description provided for @groupManagedDialogDeliveryWhatsapp.
  ///
  /// In es, this message translates to:
  /// **'WhatsApp'**
  String get groupManagedDialogDeliveryWhatsapp;

  /// No description provided for @groupManagedDialogDeliveryShowInPerson.
  ///
  /// In es, this message translates to:
  /// **'Mostrar en persona'**
  String get groupManagedDialogDeliveryShowInPerson;

  /// No description provided for @groupParticipantsRegisteredTitle.
  ///
  /// In es, this message translates to:
  /// **'Participantes registrados'**
  String get groupParticipantsRegisteredTitle;

  /// No description provided for @groupParticipantsPendingTitle.
  ///
  /// In es, this message translates to:
  /// **'Participantes pendientes'**
  String get groupParticipantsPendingTitle;

  /// No description provided for @groupParticipantsPendingEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay participantes pendientes.'**
  String get groupParticipantsPendingEmpty;

  /// No description provided for @groupPendingStatusLeft.
  ///
  /// In es, this message translates to:
  /// **'Salió del grupo'**
  String get groupPendingStatusLeft;

  /// No description provided for @groupPendingStatusRemoved.
  ///
  /// In es, this message translates to:
  /// **'Eliminado del grupo'**
  String get groupPendingStatusRemoved;

  /// No description provided for @myAssignmentSubgroupLabel.
  ///
  /// In es, this message translates to:
  /// **'Subgrupo: {name}'**
  String myAssignmentSubgroupLabel(String name);

  /// No description provided for @managedSubgroupLabel.
  ///
  /// In es, this message translates to:
  /// **'Subgrupo: {name}'**
  String managedSubgroupLabel(String name);

  /// No description provided for @managedYouManageIt.
  ///
  /// In es, this message translates to:
  /// **'Lo gestionas tú'**
  String get managedYouManageIt;

  /// No description provided for @managedDeliveryRecommendation.
  ///
  /// In es, this message translates to:
  /// **'Entrega recomendada: {mode}'**
  String managedDeliveryRecommendation(String mode);

  /// No description provided for @managedTypeManagedParticipant.
  ///
  /// In es, this message translates to:
  /// **'Participante gestionado'**
  String get managedTypeManagedParticipant;

  /// No description provided for @managedDeliveryOwnerDelegated.
  ///
  /// In es, this message translates to:
  /// **'Gestionada por responsable'**
  String get managedDeliveryOwnerDelegated;

  /// No description provided for @myAssignmentPrivateBadge.
  ///
  /// In es, this message translates to:
  /// **'Privado · solo para ti'**
  String get myAssignmentPrivateBadge;

  /// No description provided for @myAssignmentRevealLabel.
  ///
  /// In es, this message translates to:
  /// **'Te toca regalar a'**
  String get myAssignmentRevealLabel;

  /// No description provided for @myAssignmentEmotionalCopy.
  ///
  /// In es, this message translates to:
  /// **'Hazle sentir especial.'**
  String get myAssignmentEmotionalCopy;

  /// No description provided for @myAssignmentPrivacyTitle.
  ///
  /// In es, this message translates to:
  /// **'Esto solo lo ves tú'**
  String get myAssignmentPrivacyTitle;

  /// No description provided for @myAssignmentPrivacyBody.
  ///
  /// In es, this message translates to:
  /// **'Guarda el secreto hasta el día del intercambio. Nadie más en el grupo puede ver a quién te toca.'**
  String get myAssignmentPrivacyBody;

  /// No description provided for @myAssignmentNoSubgroupChip.
  ///
  /// In es, this message translates to:
  /// **'Sin subgrupo'**
  String get myAssignmentNoSubgroupChip;

  /// No description provided for @groupCompletedHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cada persona ya descubrió a quién le toca regalar.'**
  String get groupCompletedHeroSubtitle;

  /// No description provided for @groupCompletedPrivacyNote.
  ///
  /// In es, this message translates to:
  /// **'Cada resultado es privado. Solo cada persona ve el suyo.'**
  String get groupCompletedPrivacyNote;

  /// No description provided for @groupCompletedManagedHint.
  ///
  /// In es, this message translates to:
  /// **'Tú entregas en privado los resultados de las personas que gestionas.'**
  String get groupCompletedManagedHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
