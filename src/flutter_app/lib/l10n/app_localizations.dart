import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

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
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
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

  /// No description provided for @joinSuccessRaffleSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Te uniste a {groupName}. Cuando el organizador realice el sorteo, podrás ver el resultado aquí.'**
  String joinSuccessRaffleSubtitle(String groupName);

  /// No description provided for @joinSuccessRaffleBody.
  ///
  /// In es, this message translates to:
  /// **'Mientras tanto puedes revisar quién participa y esperar el momento del sorteo.'**
  String get joinSuccessRaffleBody;

  /// No description provided for @joinSuccessRafflePrimaryCta.
  ///
  /// In es, this message translates to:
  /// **'Ir al sorteo'**
  String get joinSuccessRafflePrimaryCta;

  /// No description provided for @createSecretFriend.
  ///
  /// In es, this message translates to:
  /// **'Crear amigo secreto'**
  String get createSecretFriend;

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

  /// No description provided for @splashLoadingHint.
  ///
  /// In es, this message translates to:
  /// **'Preparando todo para ti…'**
  String get splashLoadingHint;

  /// No description provided for @splashBootBrandedHint.
  ///
  /// In es, this message translates to:
  /// **'Preparando tu espacio…'**
  String get splashBootBrandedHint;

  /// No description provided for @productAuthorshipLine.
  ///
  /// In es, this message translates to:
  /// **'Tarci Secret · © 2026 Stalin Yamarte'**
  String get productAuthorshipLine;

  /// No description provided for @aboutScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Acerca de Tarci Secret'**
  String get aboutScreenTitle;

  /// No description provided for @aboutTooltip.
  ///
  /// In es, this message translates to:
  /// **'Acerca de Tarci Secret'**
  String get aboutTooltip;

  /// No description provided for @aboutTagline.
  ///
  /// In es, this message translates to:
  /// **'Dinámicas de grupo, sorteos y experiencias sociales con privacidad, emoción y personas reales.'**
  String get aboutTagline;

  /// No description provided for @aboutCapabilitiesTitle.
  ///
  /// In es, this message translates to:
  /// **'Una app, cinco dinámicas activas'**
  String get aboutCapabilitiesTitle;

  /// No description provided for @aboutSectionPrivacyLead.
  ///
  /// In es, this message translates to:
  /// **'Control y transparencia en cada resultado.'**
  String get aboutSectionPrivacyLead;

  /// No description provided for @aboutRetentionLead.
  ///
  /// In es, this message translates to:
  /// **'Los datos no se almacenan indefinidamente.'**
  String get aboutRetentionLead;

  /// No description provided for @requiredSubgroupsSetupSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'Configura tus subgrupos'**
  String get requiredSubgroupsSetupSheetTitle;

  /// No description provided for @requiredSubgroupsSetupSheetBody.
  ///
  /// In es, this message translates to:
  /// **'La regla elegida necesita subgrupos para funcionar. Crea casas, equipos, clases o categorías y después asigna a cada participante.'**
  String get requiredSubgroupsSetupSheetBody;

  /// No description provided for @requiredSubgroupsSetupSubgroupFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Subgrupo {index}'**
  String requiredSubgroupsSetupSubgroupFieldLabel(int index);

  /// No description provided for @requiredSubgroupsSetupAddAnother.
  ///
  /// In es, this message translates to:
  /// **'Añadir otro subgrupo'**
  String get requiredSubgroupsSetupAddAnother;

  /// No description provided for @requiredSubgroupsSetupContinue.
  ///
  /// In es, this message translates to:
  /// **'Crear subgrupos y continuar'**
  String get requiredSubgroupsSetupContinue;

  /// No description provided for @requiredSubgroupsSetupAssignTitle.
  ///
  /// In es, this message translates to:
  /// **'Ubícate en un subgrupo'**
  String get requiredSubgroupsSetupAssignTitle;

  /// No description provided for @requiredSubgroupsSetupAssignBody.
  ///
  /// In es, this message translates to:
  /// **'Para que la regla funcione bien, indica a qué subgrupo perteneces.'**
  String get requiredSubgroupsSetupAssignBody;

  /// No description provided for @requiredSubgroupsSetupSaveContinue.
  ///
  /// In es, this message translates to:
  /// **'Guardar y continuar'**
  String get requiredSubgroupsSetupSaveContinue;

  /// No description provided for @requiredSubgroupsSetupDoLater.
  ///
  /// In es, this message translates to:
  /// **'Lo haré después'**
  String get requiredSubgroupsSetupDoLater;

  /// No description provided for @requiredSubgroupsSetupErrorMinTwo.
  ///
  /// In es, this message translates to:
  /// **'Añade al menos dos subgrupos con nombre.'**
  String get requiredSubgroupsSetupErrorMinTwo;

  /// No description provided for @requiredSubgroupsSetupErrorDuplicateName.
  ///
  /// In es, this message translates to:
  /// **'Hay nombres duplicados. Usa nombres distintos.'**
  String get requiredSubgroupsSetupErrorDuplicateName;

  /// No description provided for @requiredSubgroupsSetupAssignErrorSelect.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un subgrupo para continuar.'**
  String get requiredSubgroupsSetupAssignErrorSelect;

  /// No description provided for @aboutSectionWhatTitle.
  ///
  /// In es, this message translates to:
  /// **'Qué es Tarci Secret'**
  String get aboutSectionWhatTitle;

  /// No description provided for @aboutSectionWhatBody.
  ///
  /// In es, this message translates to:
  /// **'Tarci Secret es una app social para organizar dinámicas de grupo de forma sencilla, privada y divertida. Permite crear amigos secretos, realizar sorteos, formar equipos, generar parejas y preparar duelos, incluyendo personas con app, sin app o gestionadas por otro participante.\n\nNace alrededor del amigo secreto como experiencia fundacional, pero evoluciona como un espacio para crear encuentros, retos y dinámicas sociales con emoción, claridad y personas reales.'**
  String get aboutSectionWhatBody;

  /// No description provided for @aboutSectionHowTitle.
  ///
  /// In es, this message translates to:
  /// **'Cómo funciona'**
  String get aboutSectionHowTitle;

  /// No description provided for @aboutStep1Title.
  ///
  /// In es, this message translates to:
  /// **'Crea o únete a un grupo'**
  String get aboutStep1Title;

  /// No description provided for @aboutStep1Body.
  ///
  /// In es, this message translates to:
  /// **'Empieza una dinámica o entra con un código de invitación.'**
  String get aboutStep1Body;

  /// No description provided for @aboutStep2Title.
  ///
  /// In es, this message translates to:
  /// **'Organiza participantes y reglas'**
  String get aboutStep2Title;

  /// No description provided for @aboutStep2Body.
  ///
  /// In es, this message translates to:
  /// **'Añade personas con app o gestionadas y ajusta el flujo necesario.'**
  String get aboutStep2Body;

  /// No description provided for @aboutStep3Title.
  ///
  /// In es, this message translates to:
  /// **'Lanza la dinámica'**
  String get aboutStep3Title;

  /// No description provided for @aboutStep3Body.
  ///
  /// In es, this message translates to:
  /// **'Ejecuta el sorteo, forma los equipos o completa la experiencia cuando todo esté listo.'**
  String get aboutStep3Body;

  /// No description provided for @aboutStep4Title.
  ///
  /// In es, this message translates to:
  /// **'Descubre, conversa y disfruta'**
  String get aboutStep4Title;

  /// No description provided for @aboutStep4Body.
  ///
  /// In es, this message translates to:
  /// **'Cada dinámica muestra el resultado de forma clara y permite vivir mejor la experiencia del grupo.'**
  String get aboutStep4Body;

  /// No description provided for @aboutSectionPrivacyTitle.
  ///
  /// In es, this message translates to:
  /// **'Privacidad por diseño'**
  String get aboutSectionPrivacyTitle;

  /// No description provided for @aboutSectionPrivacyBody.
  ///
  /// In es, this message translates to:
  /// **'Cada dinámica muestra solo lo que corresponde. Las asignaciones privadas se protegen, los resultados públicos se comparten únicamente con el grupo y Tarci evita exponer información innecesaria.\n\nTarci Secret no necesita pedir correo electrónico ni teléfono para usar el modo rápido. Solo conserva los datos necesarios para que cada dinámica funcione y elimina automáticamente las dinámicas completadas tras un periodo limitado.'**
  String get aboutSectionPrivacyBody;

  /// No description provided for @aboutSectionPrivacyTrust.
  ///
  /// In es, this message translates to:
  /// **'La privacidad no es un añadido: es parte del diseño de la experiencia.'**
  String get aboutSectionPrivacyTrust;

  /// No description provided for @aboutRetentionTitle.
  ///
  /// In es, this message translates to:
  /// **'Retención limitada'**
  String get aboutRetentionTitle;

  /// No description provided for @aboutRetentionBody.
  ///
  /// In es, this message translates to:
  /// **'Las dinámicas completadas se conservan durante 90 días desde su fecha de cierre o evento, para que puedas consultar resultados y compartirlos. Después se eliminan automáticamente del sistema.'**
  String get aboutRetentionBody;

  /// No description provided for @retentionAutoDeleteNotice.
  ///
  /// In es, this message translates to:
  /// **'Esta dinámica se eliminará automáticamente el {date}.'**
  String retentionAutoDeleteNotice(String date);

  /// No description provided for @retentionAutoDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'Conservamos los resultados durante un tiempo limitado para proteger tu privacidad y evitar guardar datos innecesarios.'**
  String get retentionAutoDeleteBody;

  /// No description provided for @aboutSectionCreatorTitle.
  ///
  /// In es, this message translates to:
  /// **'Creado por Stalin Yamarte'**
  String get aboutSectionCreatorTitle;

  /// No description provided for @aboutSectionCreatorSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Especialista en Sistemas y desarrollador de aplicaciones.'**
  String get aboutSectionCreatorSubtitle;

  /// No description provided for @aboutLinkedInCta.
  ///
  /// In es, this message translates to:
  /// **'Ver perfil en LinkedIn'**
  String get aboutLinkedInCta;

  /// No description provided for @aboutLinkedInError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos abrir LinkedIn. Inténtalo desde el navegador.'**
  String get aboutLinkedInError;

  /// No description provided for @aboutAppInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Información de la app'**
  String get aboutAppInfoTitle;

  /// No description provided for @aboutCopyrightLine.
  ///
  /// In es, this message translates to:
  /// **'© 2026 Stalin Yamarte'**
  String get aboutCopyrightLine;

  /// No description provided for @aboutPackageInfoError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos leer la versión de la app.'**
  String get aboutPackageInfoError;

  /// No description provided for @aboutBuildLine.
  ///
  /// In es, this message translates to:
  /// **'Compilación interna {buildNumber}'**
  String aboutBuildLine(String buildNumber);

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
  /// **'Organiza amigos secretos, sorteos, equipos, parejas y duelos con privacidad, emoción y facilidad.'**
  String get homeHeaderSubtitle;

  /// No description provided for @homeHeroHeadline.
  ///
  /// In es, this message translates to:
  /// **'Dinámicas sociales para grupos reales'**
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

  /// No description provided for @wizardStepEventDateTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo es el intercambio?'**
  String get wizardStepEventDateTitle;

  /// No description provided for @wizardStepEventDateHelp.
  ///
  /// In es, this message translates to:
  /// **'Es opcional. Nos servirá para recordar la entrega y mover el grupo al historial cuando pase.'**
  String get wizardStepEventDateHelp;

  /// No description provided for @wizardSummaryEventDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha del evento'**
  String get wizardSummaryEventDate;

  /// No description provided for @wizardEventDateNotSet.
  ///
  /// In es, this message translates to:
  /// **'Sin definir'**
  String get wizardEventDateNotSet;

  /// No description provided for @wizardEventDateClear.
  ///
  /// In es, this message translates to:
  /// **'Quitar fecha'**
  String get wizardEventDateClear;

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

  /// No description provided for @wizardSecretSantaOrganizerOnlyNickFallback.
  ///
  /// In es, this message translates to:
  /// **'Organizador'**
  String get wizardSecretSantaOrganizerOnlyNickFallback;

  /// No description provided for @wizardSecretSantaOrganizerOnlyHint.
  ///
  /// In es, this message translates to:
  /// **'Gestionarás el grupo y no entrarás en el sorteo. Seguirás con permisos de organizador.'**
  String get wizardSecretSantaOrganizerOnlyHint;

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

  /// No description provided for @wishlistGroupMyCardTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu lista de deseos'**
  String get wishlistGroupMyCardTitle;

  /// No description provided for @wishlistGroupMyCardSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Complétala tú; solo la verá quien te toque regalar.'**
  String get wishlistGroupMyCardSubtitle;

  /// No description provided for @wishlistGroupMyCardCtaFill.
  ///
  /// In es, this message translates to:
  /// **'Completar mi lista'**
  String get wishlistGroupMyCardCtaFill;

  /// No description provided for @wishlistGroupMyCardCtaEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar mi lista'**
  String get wishlistGroupMyCardCtaEdit;

  /// No description provided for @wishlistGroupMyEmptyHint.
  ///
  /// In es, this message translates to:
  /// **'Aún no has añadido ideas.'**
  String get wishlistGroupMyEmptyHint;

  /// No description provided for @wishlistGroupMyReadyChip.
  ///
  /// In es, this message translates to:
  /// **'Lista preparada'**
  String get wishlistGroupMyReadyChip;

  /// No description provided for @wishlistGroupManagedSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Listas que gestionas'**
  String get wishlistGroupManagedSectionTitle;

  /// No description provided for @wishlistGroupManagedSectionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ayuda a rellenarlas; quien les regale las verá en su propia pantalla.'**
  String get wishlistGroupManagedSectionSubtitle;

  /// No description provided for @wishlistGroupManagedRowCta.
  ///
  /// In es, this message translates to:
  /// **'Editar lista'**
  String get wishlistGroupManagedRowCta;

  /// No description provided for @wishlistGroupPostDrawIntro.
  ///
  /// In es, this message translates to:
  /// **'Ahora que el sorteo está hecho, unas pistas claras ayudan a acertar con el regalo.'**
  String get wishlistGroupPostDrawIntro;

  /// No description provided for @wishlistEditorTitle.
  ///
  /// In es, this message translates to:
  /// **'Lista de deseos'**
  String get wishlistEditorTitle;

  /// No description provided for @wishlistViewTitle.
  ///
  /// In es, this message translates to:
  /// **'Ideas para el regalo'**
  String get wishlistViewTitle;

  /// No description provided for @wishlistEditorIntro.
  ///
  /// In es, this message translates to:
  /// **'Escribe con cariño lo que te haría ilusión recibir. Solo lo verá quien te toque regalar (y tú).'**
  String get wishlistEditorIntro;

  /// No description provided for @wishlistViewIntro.
  ///
  /// In es, this message translates to:
  /// **'Estas ideas son solo para ayudar con el regalo. Respeta el secreto del sorteo.'**
  String get wishlistViewIntro;

  /// No description provided for @wishlistFieldWishTitle.
  ///
  /// In es, this message translates to:
  /// **'Me haría ilusión…'**
  String get wishlistFieldWishTitle;

  /// No description provided for @wishlistFieldWishHint.
  ///
  /// In es, this message translates to:
  /// **'Ideas concretas de regalo, tallas o detalles que te gustarían.'**
  String get wishlistFieldWishHint;

  /// No description provided for @wishlistFieldLikesTitle.
  ///
  /// In es, this message translates to:
  /// **'Me gusta…'**
  String get wishlistFieldLikesTitle;

  /// No description provided for @wishlistFieldLikesHint.
  ///
  /// In es, this message translates to:
  /// **'Hobbies, colores, estilos o cosas que te encantan.'**
  String get wishlistFieldLikesHint;

  /// No description provided for @wishlistFieldAvoidTitle.
  ///
  /// In es, this message translates to:
  /// **'Mejor evita…'**
  String get wishlistFieldAvoidTitle;

  /// No description provided for @wishlistFieldAvoidHint.
  ///
  /// In es, this message translates to:
  /// **'Cosas que prefieres no recibir o que ya tienes.'**
  String get wishlistFieldAvoidHint;

  /// No description provided for @wishlistFieldLinksTitle.
  ///
  /// In es, this message translates to:
  /// **'Enlaces de inspiración'**
  String get wishlistFieldLinksTitle;

  /// No description provided for @wishlistLinksHelp.
  ///
  /// In es, this message translates to:
  /// **'Hasta {max} enlaces con http o https.'**
  String wishlistLinksHelp(int max);

  /// No description provided for @wishlistAddLinkCta.
  ///
  /// In es, this message translates to:
  /// **'Añadir enlace'**
  String get wishlistAddLinkCta;

  /// No description provided for @wishlistLinkLabelOptional.
  ///
  /// In es, this message translates to:
  /// **'Etiqueta (opcional)'**
  String get wishlistLinkLabelOptional;

  /// No description provided for @wishlistLinkUrlLabel.
  ///
  /// In es, this message translates to:
  /// **'URL'**
  String get wishlistLinkUrlLabel;

  /// No description provided for @wishlistUrlHint.
  ///
  /// In es, this message translates to:
  /// **'https://…'**
  String get wishlistUrlHint;

  /// No description provided for @wishlistLinkRowTitle.
  ///
  /// In es, this message translates to:
  /// **'Enlace {index}'**
  String wishlistLinkRowTitle(int index);

  /// No description provided for @wishlistSaveCta.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get wishlistSaveCta;

  /// No description provided for @wishlistCancelCta.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get wishlistCancelCta;

  /// No description provided for @wishlistSaveSuccess.
  ///
  /// In es, this message translates to:
  /// **'Lista guardada.'**
  String get wishlistSaveSuccess;

  /// No description provided for @wishlistUrlInvalid.
  ///
  /// In es, this message translates to:
  /// **'Revisa las URLs: deben empezar por http:// o https://'**
  String get wishlistUrlInvalid;

  /// No description provided for @wishlistLinksMax.
  ///
  /// In es, this message translates to:
  /// **'Como máximo {max} enlaces.'**
  String wishlistLinksMax(int max);

  /// No description provided for @wishlistMyAssignmentReceiverWishlistHeading.
  ///
  /// In es, this message translates to:
  /// **'Qué le gustaría recibir a {receiverName}'**
  String wishlistMyAssignmentReceiverWishlistHeading(String receiverName);

  /// No description provided for @wishlistMyAssignmentReceiverNameFallback.
  ///
  /// In es, this message translates to:
  /// **'tu destinatario'**
  String get wishlistMyAssignmentReceiverNameFallback;

  /// No description provided for @wishlistMyAssignmentSectionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Solo tú ves esto. Sirve para inspirarte al elegir un detalle con cariño.'**
  String get wishlistMyAssignmentSectionSubtitle;

  /// No description provided for @wishlistMyAssignmentViewCta.
  ///
  /// In es, this message translates to:
  /// **'Ver ideas de regalo'**
  String get wishlistMyAssignmentViewCta;

  /// No description provided for @wishlistManagedViewReceiverCta.
  ///
  /// In es, this message translates to:
  /// **'Ver lista de deseos'**
  String get wishlistManagedViewReceiverCta;

  /// No description provided for @wishlistManagedViewReceiverHint.
  ///
  /// In es, this message translates to:
  /// **'Solo ves las ideas de esta persona para este secreto.'**
  String get wishlistManagedViewReceiverHint;

  /// No description provided for @wishlistEmptyReceiverTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no ha dejado ideas de regalo'**
  String get wishlistEmptyReceiverTitle;

  /// No description provided for @wishlistEmptyReceiverBody.
  ///
  /// In es, this message translates to:
  /// **'Quizá las añada más adelante. ¡Un detalle hecho con cariño siempre cuenta!'**
  String get wishlistEmptyReceiverBody;

  /// No description provided for @wishlistLinkOpenError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir el enlace.'**
  String get wishlistLinkOpenError;

  /// No description provided for @wishlistReadonlySheetTitle.
  ///
  /// In es, this message translates to:
  /// **'Ideas de regalo'**
  String get wishlistReadonlySheetTitle;

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

  /// No description provided for @groupManagedDialogDeliveryEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get groupManagedDialogDeliveryEmail;

  /// No description provided for @groupManagedDialogDeliveryWhatsapp.
  ///
  /// In es, this message translates to:
  /// **'WhatsApp'**
  String get groupManagedDialogDeliveryWhatsapp;

  /// No description provided for @groupManagedDialogDeliveryPrinted.
  ///
  /// In es, this message translates to:
  /// **'Impresa / PDF'**
  String get groupManagedDialogDeliveryPrinted;

  /// No description provided for @groupManagedDialogWhoManagesTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Quién gestionará su resultado?'**
  String get groupManagedDialogWhoManagesTitle;

  /// No description provided for @groupManagedDialogWhoManagesDesc.
  ///
  /// In es, this message translates to:
  /// **'Elige quién verá el resultado en la app para poder entregarlo en privado.'**
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

  /// No description provided for @languagePortuguese.
  ///
  /// In es, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageItalian.
  ///
  /// In es, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @languageFrench.
  ///
  /// In es, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @functionsErrorAlreadyMember.
  ///
  /// In es, this message translates to:
  /// **'Ya perteneces a este grupo.'**
  String get functionsErrorAlreadyMember;

  /// No description provided for @functionsErrorCodeNotFound.
  ///
  /// In es, this message translates to:
  /// **'No encontramos un grupo con ese código.'**
  String get functionsErrorCodeNotFound;

  /// No description provided for @functionsErrorCodeExpired.
  ///
  /// In es, this message translates to:
  /// **'Este código ha expirado.'**
  String get functionsErrorCodeExpired;

  /// No description provided for @functionsErrorGroupArchived.
  ///
  /// In es, this message translates to:
  /// **'Este grupo ya está cerrado.'**
  String get functionsErrorGroupArchived;

  /// No description provided for @functionsErrorUserRemoved.
  ///
  /// In es, this message translates to:
  /// **'No puedes volver a unirte a este grupo.'**
  String get functionsErrorUserRemoved;

  /// No description provided for @functionsErrorDrawInProgress.
  ///
  /// In es, this message translates to:
  /// **'El sorteo está en curso. Inténtalo más tarde.'**
  String get functionsErrorDrawInProgress;

  /// No description provided for @functionsErrorDrawAlreadyCompleted.
  ///
  /// In es, this message translates to:
  /// **'Este sorteo ya se había completado.'**
  String get functionsErrorDrawAlreadyCompleted;

  /// No description provided for @functionsErrorDrawCompletedInvitesClosed.
  ///
  /// In es, this message translates to:
  /// **'Este sorteo ya fue realizado y ya no admite nuevos participantes.'**
  String get functionsErrorDrawCompletedInvitesClosed;

  /// No description provided for @functionsErrorSubgroupInUse.
  ///
  /// In es, this message translates to:
  /// **'Antes de eliminar este subgrupo, mueve o deja sin subgrupo a sus participantes.'**
  String get functionsErrorSubgroupInUse;

  /// No description provided for @functionsErrorSubgroupNotFound.
  ///
  /// In es, this message translates to:
  /// **'El subgrupo ya no existe o fue eliminado.'**
  String get functionsErrorSubgroupNotFound;

  /// No description provided for @functionsErrorNotOwner.
  ///
  /// In es, this message translates to:
  /// **'Solo el organizador puede realizar esta acción.'**
  String get functionsErrorNotOwner;

  /// No description provided for @functionsErrorGroupDeleteForbidden.
  ///
  /// In es, this message translates to:
  /// **'Solo el organizador puede eliminar este grupo.'**
  String get functionsErrorGroupDeleteForbidden;

  /// No description provided for @functionsErrorGroupDeleteFailed.
  ///
  /// In es, this message translates to:
  /// **'No pudimos eliminar el grupo por completo. Inténtalo otra vez o revisa tu conexión.'**
  String get functionsErrorGroupDeleteFailed;

  /// No description provided for @functionsErrorDrawLocked.
  ///
  /// In es, this message translates to:
  /// **'No puedes modificar subgrupos o participantes cuando el sorteo está en curso o completado.'**
  String get functionsErrorDrawLocked;

  /// No description provided for @functionsErrorGenericAction.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar la acción. Inténtalo de nuevo en un momento.'**
  String get functionsErrorGenericAction;

  /// No description provided for @functionsErrorPermissionDeniedDrawRule.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cambiar la regla del sorteo. Revisa que el sorteo no esté en curso ni finalizado.'**
  String get functionsErrorPermissionDeniedDrawRule;

  /// No description provided for @functionsErrorUnknown.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Inténtalo de nuevo en unos momentos.'**
  String get functionsErrorUnknown;

  /// No description provided for @functionsErrorDebugSession.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar la acción. Revisa si estás usando emuladores o Firebase real, si las Functions están desplegadas y si la sesión está activa.'**
  String get functionsErrorDebugSession;

  /// No description provided for @homePrimaryActionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Acciones principales'**
  String get homePrimaryActionsTitle;

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
  /// **'En curso'**
  String get homeActiveGroupsTitle;

  /// No description provided for @homeActiveGroupsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Preparación o sorteo pendiente; o sorteo hecho con entrega hoy o futura, o sin fecha de entrega definida.'**
  String get homeActiveGroupsSubtitle;

  /// No description provided for @homeActiveGroupsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tienes grupos en esta sección.'**
  String get homeActiveGroupsEmpty;

  /// No description provided for @homeDeliveryDateLine.
  ///
  /// In es, this message translates to:
  /// **'Entrega: {date}'**
  String homeDeliveryDateLine(String date);

  /// No description provided for @homeDrawDateLine.
  ///
  /// In es, this message translates to:
  /// **'Sorteo: {date}'**
  String homeDrawDateLine(String date);

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
  /// **'Sorteos finalizados'**
  String get homeCompletedGroupsTitle;

  /// No description provided for @homeCompletedGroupsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Sorteo realizado y fecha de entrega ya pasada.'**
  String get homeCompletedGroupsSubtitle;

  /// No description provided for @homePastGroupsTitle.
  ///
  /// In es, this message translates to:
  /// **'Grupos anteriores'**
  String get homePastGroupsTitle;

  /// No description provided for @homePastGroupsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ya no participas activamente en estos grupos.'**
  String get homePastGroupsSubtitle;

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

  /// No description provided for @groupDeleteOwnerSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Opciones del grupo'**
  String get groupDeleteOwnerSectionTitle;

  /// No description provided for @groupDeleteOwnerSectionHint.
  ///
  /// In es, this message translates to:
  /// **'Solo el organizador puede cerrar esta dinámica y borrar todos los datos del grupo.'**
  String get groupDeleteOwnerSectionHint;

  /// No description provided for @groupDeleteEntryCta.
  ///
  /// In es, this message translates to:
  /// **'Eliminar grupo'**
  String get groupDeleteEntryCta;

  /// No description provided for @groupDeleteDialogPreTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar este grupo?'**
  String get groupDeleteDialogPreTitle;

  /// No description provided for @groupDeleteDialogPreBody.
  ///
  /// In es, this message translates to:
  /// **'Se borrarán la configuración, participantes, invitaciones y datos asociados. Esta acción no se puede deshacer.'**
  String get groupDeleteDialogPreBody;

  /// No description provided for @groupDeleteDialogPreConfirm.
  ///
  /// In es, this message translates to:
  /// **'Eliminar grupo'**
  String get groupDeleteDialogPreConfirm;

  /// No description provided for @groupDeleteDialogPostTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar este amigo secreto?'**
  String get groupDeleteDialogPostTitle;

  /// No description provided for @groupDeleteDialogPostBody.
  ///
  /// In es, this message translates to:
  /// **'El sorteo ya fue realizado. Si continúas, todos perderán acceso a sus resultados, listas de deseos, conversación del grupo y datos asociados. Esta acción no se puede deshacer.'**
  String get groupDeleteDialogPostBody;

  /// No description provided for @groupDeleteDialogPostConfirm.
  ///
  /// In es, this message translates to:
  /// **'Eliminar definitivamente'**
  String get groupDeleteDialogPostConfirm;

  /// No description provided for @groupDeleteSuccessSnackbar.
  ///
  /// In es, this message translates to:
  /// **'Grupo eliminado'**
  String get groupDeleteSuccessSnackbar;

  /// No description provided for @groupDetailMissingMessage.
  ///
  /// In es, this message translates to:
  /// **'Este grupo ya no existe o fue eliminado por el organizador.'**
  String get groupDetailMissingMessage;

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

  /// No description provided for @groupManagedDialogDeliverySectionTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo se lo harás llegar?'**
  String get groupManagedDialogDeliverySectionTitle;

  /// No description provided for @groupManagedResponsibleUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Responsable no disponible'**
  String get groupManagedResponsibleUnavailable;

  /// No description provided for @groupManagedDeliversResponsible.
  ///
  /// In es, this message translates to:
  /// **'Lo gestiona: {name}'**
  String groupManagedDeliversResponsible(String name);

  /// No description provided for @groupManagedDialogPickGuardianTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Quién lo entregará?'**
  String get groupManagedDialogPickGuardianTitle;

  /// No description provided for @groupManagedDialogGuardianOtherSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Este miembro verá el resultado y podrá entregárselo en privado.'**
  String get groupManagedDialogGuardianOtherSubtitle;

  /// No description provided for @groupManagedDialogGuardianNoEligibleMembers.
  ///
  /// In es, this message translates to:
  /// **'Cuando se una otro miembro con app, podrás asignárselo.'**
  String get groupManagedDialogGuardianNoEligibleMembers;

  /// No description provided for @groupManagedDialogPickMemberCta.
  ///
  /// In es, this message translates to:
  /// **'Elegir miembro'**
  String get groupManagedDialogPickMemberCta;

  /// No description provided for @groupManagedDialogSelectOtherFirst.
  ///
  /// In es, this message translates to:
  /// **'Elige primero a un miembro del grupo.'**
  String get groupManagedDialogSelectOtherFirst;

  /// No description provided for @groupManagedDialogGuardianMustReassign.
  ///
  /// In es, this message translates to:
  /// **'Ese miembro ya no está activo en el grupo. Elige a otro responsable o «Yo».'**
  String get groupManagedDialogGuardianMustReassign;

  /// No description provided for @groupManagedDialogDeliversSummary.
  ///
  /// In es, this message translates to:
  /// **'Lo entrega: {name}'**
  String groupManagedDialogDeliversSummary(String name);

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

  /// No description provided for @managedDeliveryModeWhatsapp.
  ///
  /// In es, this message translates to:
  /// **'WhatsApp'**
  String get managedDeliveryModeWhatsapp;

  /// No description provided for @managedDeliveryModeEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get managedDeliveryModeEmail;

  /// No description provided for @managedDeliveryModePdf.
  ///
  /// In es, this message translates to:
  /// **'Impresa / PDF'**
  String get managedDeliveryModePdf;

  /// No description provided for @managedDeliveryCtaWhatsapp.
  ///
  /// In es, this message translates to:
  /// **'Compartir por WhatsApp'**
  String get managedDeliveryCtaWhatsapp;

  /// No description provided for @managedDeliveryCtaEmail.
  ///
  /// In es, this message translates to:
  /// **'Preparar correo'**
  String get managedDeliveryCtaEmail;

  /// No description provided for @managedDeliveryCtaPdf.
  ///
  /// In es, this message translates to:
  /// **'Generar PDF'**
  String get managedDeliveryCtaPdf;

  /// No description provided for @managedDeliveryVerbalBadge.
  ///
  /// In es, this message translates to:
  /// **'Entrega verbal'**
  String get managedDeliveryVerbalBadge;

  /// No description provided for @managedDeliveryPdfGenerating.
  ///
  /// In es, this message translates to:
  /// **'Generando PDF…'**
  String get managedDeliveryPdfGenerating;

  /// No description provided for @managedDeliveryWhatsappBrand.
  ///
  /// In es, this message translates to:
  /// **'🎁 Tarci Secret'**
  String get managedDeliveryWhatsappBrand;

  /// No description provided for @managedDeliveryWhatsappHello.
  ///
  /// In es, this message translates to:
  /// **'Hola, {name}.'**
  String managedDeliveryWhatsappHello(String name);

  /// No description provided for @managedDeliveryWhatsappDrawLine.
  ///
  /// In es, this message translates to:
  /// **'Ya se realizó el amigo secreto de «{groupName}».'**
  String managedDeliveryWhatsappDrawLine(String groupName);

  /// No description provided for @managedDeliveryWhatsappGiftIntro.
  ///
  /// In es, this message translates to:
  /// **'A ti te toca regalar a:'**
  String get managedDeliveryWhatsappGiftIntro;

  /// No description provided for @managedDeliveryWhatsappReceiverLine.
  ///
  /// In es, this message translates to:
  /// **'✨ {receiverName}'**
  String managedDeliveryWhatsappReceiverLine(String receiverName);

  /// No description provided for @managedDeliverySubgroupBelongsTo.
  ///
  /// In es, this message translates to:
  /// **'Pertenece a: {subgroup}'**
  String managedDeliverySubgroupBelongsTo(String subgroup);

  /// No description provided for @managedDeliveryClosingSecret.
  ///
  /// In es, this message translates to:
  /// **'Guarda el secreto 🤫'**
  String get managedDeliveryClosingSecret;

  /// No description provided for @managedDeliveryEmailSubject.
  ///
  /// In es, this message translates to:
  /// **'Tu amigo secreto de {groupName} ya está listo 🎁'**
  String managedDeliveryEmailSubject(String groupName);

  /// No description provided for @managedDeliveryEmailGreeting.
  ///
  /// In es, this message translates to:
  /// **'Hola, {name}:'**
  String managedDeliveryEmailGreeting(String name);

  /// No description provided for @managedDeliveryEmailLead.
  ///
  /// In es, this message translates to:
  /// **'Te escribimos con el resultado privado del amigo secreto del grupo «{groupName}».'**
  String managedDeliveryEmailLead(String groupName);

  /// No description provided for @managedDeliveryEmailGiftLabel.
  ///
  /// In es, this message translates to:
  /// **'A quien te toca regalar es a:'**
  String get managedDeliveryEmailGiftLabel;

  /// No description provided for @managedDeliveryEmailReceiverLine.
  ///
  /// In es, this message translates to:
  /// **'{receiverName}'**
  String managedDeliveryEmailReceiverLine(String receiverName);

  /// No description provided for @managedDeliveryEmailSubgroupLine.
  ///
  /// In es, this message translates to:
  /// **'Casa o equipo: {subgroup}'**
  String managedDeliveryEmailSubgroupLine(String subgroup);

  /// No description provided for @managedDeliveryEmailClosing.
  ///
  /// In es, this message translates to:
  /// **'Por favor, guarda este resultado solo para ti. Nadie más debe verlo.'**
  String get managedDeliveryEmailClosing;

  /// No description provided for @managedDeliveryEmailSignoff.
  ///
  /// In es, this message translates to:
  /// **'Un abrazo,\nTarci Secret'**
  String get managedDeliveryEmailSignoff;

  /// No description provided for @managedPdfDocTitle.
  ///
  /// In es, this message translates to:
  /// **'amigo-secreto'**
  String get managedPdfDocTitle;

  /// No description provided for @managedPdfHeadline.
  ///
  /// In es, this message translates to:
  /// **'Tu amigo secreto ya está listo'**
  String get managedPdfHeadline;

  /// No description provided for @managedPdfForLabel.
  ///
  /// In es, this message translates to:
  /// **'Para'**
  String get managedPdfForLabel;

  /// No description provided for @managedPdfGroupLabel.
  ///
  /// In es, this message translates to:
  /// **'Grupo'**
  String get managedPdfGroupLabel;

  /// No description provided for @managedPdfGiftHeading.
  ///
  /// In es, this message translates to:
  /// **'Te toca regalar a…'**
  String get managedPdfGiftHeading;

  /// No description provided for @managedPdfFooterKeepSecret.
  ///
  /// In es, this message translates to:
  /// **'Guarda el secreto. Nadie más debe verlo.'**
  String get managedPdfFooterKeepSecret;

  /// No description provided for @managedPdfFooterBrand.
  ///
  /// In es, this message translates to:
  /// **'Generado con Tarci Secret'**
  String get managedPdfFooterBrand;

  /// No description provided for @managedDeliveryFallbackGroupName.
  ///
  /// In es, this message translates to:
  /// **'tu grupo'**
  String get managedDeliveryFallbackGroupName;

  /// No description provided for @managedDeliveryErrorMissingData.
  ///
  /// In es, this message translates to:
  /// **'No hay datos suficientes para preparar el mensaje.'**
  String get managedDeliveryErrorMissingData;

  /// No description provided for @managedDeliveryErrorWhatsapp.
  ///
  /// In es, this message translates to:
  /// **'No pudimos abrir WhatsApp. Puedes compartir el texto con otra app.'**
  String get managedDeliveryErrorWhatsapp;

  /// No description provided for @managedDeliveryErrorEmail.
  ///
  /// In es, this message translates to:
  /// **'No encontramos una app de correo en este dispositivo.'**
  String get managedDeliveryErrorEmail;

  /// No description provided for @managedDeliveryErrorPdf.
  ///
  /// In es, this message translates to:
  /// **'No se pudo generar el PDF. Inténtalo de nuevo.'**
  String get managedDeliveryErrorPdf;

  /// No description provided for @managedDeliveryErrorShare.
  ///
  /// In es, this message translates to:
  /// **'No se pudo compartir. Inténtalo otra vez.'**
  String get managedDeliveryErrorShare;

  /// No description provided for @managedDeliveryErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Inténtalo de nuevo.'**
  String get managedDeliveryErrorGeneric;

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

  /// No description provided for @chatGroupSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Conversación del grupo'**
  String get chatGroupSectionTitle;

  /// No description provided for @chatGroupSectionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Bromea, comparte pistas y mantén vivo el ambiente.'**
  String get chatGroupSectionSubtitle;

  /// No description provided for @chatGroupEnterCta.
  ///
  /// In es, this message translates to:
  /// **'Entrar al chat'**
  String get chatGroupEnterCta;

  /// No description provided for @chatGroupEventLine.
  ///
  /// In es, this message translates to:
  /// **'Entrega: {date}'**
  String chatGroupEventLine(String date);

  /// No description provided for @chatDrawCompletedChip.
  ///
  /// In es, this message translates to:
  /// **'Sorteo realizado'**
  String get chatDrawCompletedChip;

  /// No description provided for @chatInputHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe algo para el grupo…'**
  String get chatInputHint;

  /// No description provided for @chatSendCta.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get chatSendCta;

  /// No description provided for @chatTarciLabel.
  ///
  /// In es, this message translates to:
  /// **'Tarci'**
  String get chatTarciLabel;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay mensajes'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptyBody.
  ///
  /// In es, this message translates to:
  /// **'Cuando alguien escriba o Tarci avise de algo importante, lo verás aquí.'**
  String get chatEmptyBody;

  /// No description provided for @chatLoadError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar el chat. Comprueba tu conexión o vuelve a intentarlo.'**
  String get chatLoadError;

  /// No description provided for @chatSendError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar el mensaje. Inténtalo otra vez.'**
  String get chatSendError;

  /// No description provided for @chatSystemGroupCreatedV1.
  ///
  /// In es, this message translates to:
  /// **'🎁 El grupo ya está en marcha. Soltad pistas, soltad caña y que ruede el cotilleo sano.'**
  String get chatSystemGroupCreatedV1;

  /// No description provided for @chatSystemDrawCompletedV1.
  ///
  /// In es, this message translates to:
  /// **'🤫 Sorteo hecho. A partir de ahora, cada pregunta rara cuenta como evidencia.'**
  String get chatSystemDrawCompletedV1;

  /// No description provided for @chatSystemUnknownTemplate.
  ///
  /// In es, this message translates to:
  /// **'Mensaje del sistema ({templateKey})'**
  String chatSystemUnknownTemplate(String templateKey);

  /// No description provided for @chatSystemAutoPlayful001V1.
  ///
  /// In es, this message translates to:
  /// **'Aquí ya huele a sospechas… y todavía nadie ha confesado nada.'**
  String get chatSystemAutoPlayful001V1;

  /// No description provided for @chatSystemAutoPlayful002V1.
  ///
  /// In es, this message translates to:
  /// **'Desde que hay sorteo, cada pregunta inocente parece estrategia.'**
  String get chatSystemAutoPlayful002V1;

  /// No description provided for @chatSystemAutoPlayful003V1.
  ///
  /// In es, this message translates to:
  /// **'Consejo de Tarci: investiga con sutileza, no con interrogatorio.'**
  String get chatSystemAutoPlayful003V1;

  /// No description provided for @chatSystemAutoPlayful004V1.
  ///
  /// In es, this message translates to:
  /// **'Hay quien ya tiene regalo. Hay quien tiene fe.'**
  String get chatSystemAutoPlayful004V1;

  /// No description provided for @chatSystemAutoPlayful005V1.
  ///
  /// In es, this message translates to:
  /// **'Si alguien pregunta por tallas, colores y hobbies seguidos, toma nota.'**
  String get chatSystemAutoPlayful005V1;

  /// No description provided for @chatSystemAutoPlayful006V1.
  ///
  /// In es, this message translates to:
  /// **'Un buen regalo sorprende. Un gran regalo deja historia.'**
  String get chatSystemAutoPlayful006V1;

  /// No description provided for @chatSystemAutoPlayful007V1.
  ///
  /// In es, this message translates to:
  /// **'Las sonrisas sospechosas cuentan como pista.'**
  String get chatSystemAutoPlayful007V1;

  /// No description provided for @chatSystemAutoPlayful008V1.
  ///
  /// In es, this message translates to:
  /// **'Se permite despistar. Se recomienda no pasarse.'**
  String get chatSystemAutoPlayful008V1;

  /// No description provided for @chatSystemAutoPlayful009V1.
  ///
  /// In es, this message translates to:
  /// **'El silencio de algunos empieza a parecer planificación.'**
  String get chatSystemAutoPlayful009V1;

  /// No description provided for @chatSystemAutoPlayful010V1.
  ///
  /// In es, this message translates to:
  /// **'Si vas a improvisar, al menos improvisa con cariño.'**
  String get chatSystemAutoPlayful010V1;

  /// No description provided for @chatSystemAutoPlayful011V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci detecta energía de regalo épico… y de pánico elegante.'**
  String get chatSystemAutoPlayful011V1;

  /// No description provided for @chatSystemAutoPlayful012V1.
  ///
  /// In es, this message translates to:
  /// **'Quien dice “yo ya lo tengo” sin pruebas despierta dudas.'**
  String get chatSystemAutoPlayful012V1;

  /// No description provided for @chatSystemAutoPlayful013V1.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio amable: el misterio también se disfruta.'**
  String get chatSystemAutoPlayful013V1;

  /// No description provided for @chatSystemAutoPlayful014V1.
  ///
  /// In es, this message translates to:
  /// **'Cada grupo tiene un detective. ¿Ya sabéis quién es?'**
  String get chatSystemAutoPlayful014V1;

  /// No description provided for @chatSystemAutoPlayful015V1.
  ///
  /// In es, this message translates to:
  /// **'Un detalle con intención vale más que un regalo sin alma.'**
  String get chatSystemAutoPlayful015V1;

  /// No description provided for @chatSystemAutoPlayful016V1.
  ///
  /// In es, this message translates to:
  /// **'Este chat está oficialmente en modo sospecha.'**
  String get chatSystemAutoPlayful016V1;

  /// No description provided for @chatSystemAutoPlayful017V1.
  ///
  /// In es, this message translates to:
  /// **'Si acabas de buscar ideas en secreto, nadie te juzga.'**
  String get chatSystemAutoPlayful017V1;

  /// No description provided for @chatSystemAutoPlayful018V1.
  ///
  /// In es, this message translates to:
  /// **'Hay miradas en la vida real que ahora significan demasiado.'**
  String get chatSystemAutoPlayful018V1;

  /// No description provided for @chatSystemAutoPlayful019V1.
  ///
  /// In es, this message translates to:
  /// **'La misión no es gastar más. Es acertar mejor.'**
  String get chatSystemAutoPlayful019V1;

  /// No description provided for @chatSystemAutoPlayful020V1.
  ///
  /// In es, this message translates to:
  /// **'Disimular bien también es parte del juego.'**
  String get chatSystemAutoPlayful020V1;

  /// No description provided for @chatSystemAutoPlayful021V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci apuesta a que alguien aquí ya tiene un plan brillante.'**
  String get chatSystemAutoPlayful021V1;

  /// No description provided for @chatSystemAutoDebate001V1.
  ///
  /// In es, this message translates to:
  /// **'Debate rápido: ¿regalo útil o regalo que haga reír?'**
  String get chatSystemAutoDebate001V1;

  /// No description provided for @chatSystemAutoDebate002V1.
  ///
  /// In es, this message translates to:
  /// **'¿Mejor sorpresa total o pista bien aprovechada?'**
  String get chatSystemAutoDebate002V1;

  /// No description provided for @chatSystemAutoDebate003V1.
  ///
  /// In es, this message translates to:
  /// **'¿Qué gana: creatividad o precisión?'**
  String get chatSystemAutoDebate003V1;

  /// No description provided for @chatSystemAutoDebate004V1.
  ///
  /// In es, this message translates to:
  /// **'Abrimos debate: ¿el envoltorio espectacular importa?'**
  String get chatSystemAutoDebate004V1;

  /// No description provided for @chatSystemAutoDebate005V1.
  ///
  /// In es, this message translates to:
  /// **'¿Investigación discreta o lista de deseos al rescate?'**
  String get chatSystemAutoDebate005V1;

  /// No description provided for @chatSystemAutoDebate006V1.
  ///
  /// In es, this message translates to:
  /// **'Sin señalar a nadie: ¿quién del grupo improvisa al final?'**
  String get chatSystemAutoDebate006V1;

  /// No description provided for @chatSystemAutoDebate007V1.
  ///
  /// In es, this message translates to:
  /// **'¿Regalo pequeño con historia o grande sin historia?'**
  String get chatSystemAutoDebate007V1;

  /// No description provided for @chatSystemAutoDebate008V1.
  ///
  /// In es, this message translates to:
  /// **'¿Se vale despistar en el chat o eso ya es juego sucio?'**
  String get chatSystemAutoDebate008V1;

  /// No description provided for @chatSystemAutoDebate009V1.
  ///
  /// In es, this message translates to:
  /// **'¿Qué emociona más: acertar o sorprender?'**
  String get chatSystemAutoDebate009V1;

  /// No description provided for @chatSystemAutoDebate010V1.
  ///
  /// In es, this message translates to:
  /// **'Si tuvieras que elegir: ¿práctico, divertido o sentimental?'**
  String get chatSystemAutoDebate010V1;

  /// No description provided for @chatSystemAutoWishlist001V1.
  ///
  /// In es, this message translates to:
  /// **'Algunas listas siguen vacías. Una pista a tiempo puede salvar un regalo.'**
  String get chatSystemAutoWishlist001V1;

  /// No description provided for @chatSystemAutoWishlist002V1.
  ///
  /// In es, this message translates to:
  /// **'Tu lista de deseos no quita magia; evita adivinar a ciegas.'**
  String get chatSystemAutoWishlist002V1;

  /// No description provided for @chatSystemAutoWishlist003V1.
  ///
  /// In es, this message translates to:
  /// **'Si quieres que acierten contigo, deja alguna idea.'**
  String get chatSystemAutoWishlist003V1;

  /// No description provided for @chatSystemAutoWishlist004V1.
  ///
  /// In es, this message translates to:
  /// **'Hay alguien preparando regalo con muy pocas pistas. Ejem.'**
  String get chatSystemAutoWishlist004V1;

  /// No description provided for @chatSystemAutoWishlist005V1.
  ///
  /// In es, this message translates to:
  /// **'Completar la lista es ayudar sin revelar demasiado.'**
  String get chatSystemAutoWishlist005V1;

  /// No description provided for @chatSystemAutoWishlist006V1.
  ///
  /// In es, this message translates to:
  /// **'Un enlace, un gusto, una pista: todo suma.'**
  String get chatSystemAutoWishlist006V1;

  /// No description provided for @chatSystemAutoWishlist007V1.
  ///
  /// In es, this message translates to:
  /// **'Las mejores sorpresas también agradecen orientación.'**
  String get chatSystemAutoWishlist007V1;

  /// No description provided for @chatSystemAutoWishlist008V1.
  ///
  /// In es, this message translates to:
  /// **'Si tu lista está vacía, tu amigo secreto está jugando en modo difícil.'**
  String get chatSystemAutoWishlist008V1;

  /// No description provided for @chatSystemAutoQuiet001V1.
  ///
  /// In es, this message translates to:
  /// **'Mucho silencio por aquí… ¿comprando o escondiendo pruebas?'**
  String get chatSystemAutoQuiet001V1;

  /// No description provided for @chatSystemAutoQuiet002V1.
  ///
  /// In es, this message translates to:
  /// **'Este grupo está demasiado tranquilo. Alguien que rompa el hielo.'**
  String get chatSystemAutoQuiet002V1;

  /// No description provided for @chatSystemAutoQuiet003V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci pasa lista: ¿sigue vivo el cachondeo?'**
  String get chatSystemAutoQuiet003V1;

  /// No description provided for @chatSystemAutoQuiet004V1.
  ///
  /// In es, this message translates to:
  /// **'Pregunta de reactivación: ¿quién se ve más sospechoso hoy?'**
  String get chatSystemAutoQuiet004V1;

  /// No description provided for @chatSystemAutoQuiet005V1.
  ///
  /// In es, this message translates to:
  /// **'Si nadie escribe, Tarci empieza a inventar teorías.'**
  String get chatSystemAutoQuiet005V1;

  /// No description provided for @chatSystemAutoQuiet006V1.
  ///
  /// In es, this message translates to:
  /// **'Chat dormido, misterio despierto. Comentad algo.'**
  String get chatSystemAutoQuiet006V1;

  /// No description provided for @chatSystemAutoCountdown014V1.
  ///
  /// In es, this message translates to:
  /// **'Quedan 14 días. Todavía hay margen, pero la excusa se está acabando.'**
  String get chatSystemAutoCountdown014V1;

  /// No description provided for @chatSystemAutoCountdown007V1.
  ///
  /// In es, this message translates to:
  /// **'Quedan 7 días. Quien no tenga idea entra en fase de búsqueda seria.'**
  String get chatSystemAutoCountdown007V1;

  /// No description provided for @chatSystemAutoCountdown003V1.
  ///
  /// In es, this message translates to:
  /// **'Quedan 3 días. Ya no es planificación: es operación rescate.'**
  String get chatSystemAutoCountdown003V1;

  /// No description provided for @chatSystemAutoCountdown001V1.
  ///
  /// In es, this message translates to:
  /// **'Falta 1 día. Envuelve, respira y finge normalidad.'**
  String get chatSystemAutoCountdown001V1;

  /// No description provided for @chatSystemAutoCountdown000V1.
  ///
  /// In es, this message translates to:
  /// **'Hoy es el intercambio. Que haya sorpresas, risas y cero confesiones antes de tiempo.'**
  String get chatSystemAutoCountdown000V1;

  /// No description provided for @dynamicsHomePrimaryCta.
  ///
  /// In es, this message translates to:
  /// **'Crear dinámica'**
  String get dynamicsHomePrimaryCta;

  /// No description provided for @dynamicsSelectTitle.
  ///
  /// In es, this message translates to:
  /// **'Elige una dinámica'**
  String get dynamicsSelectTitle;

  /// No description provided for @dynamicsSelectSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Elige una dinámica: Amigo Secreto, Sorteo, Equipos, Parejas o Duelos.'**
  String get dynamicsSelectSubtitle;

  /// No description provided for @dynamicsCardSecretSantaTitle.
  ///
  /// In es, this message translates to:
  /// **'Amigo secreto'**
  String get dynamicsCardSecretSantaTitle;

  /// No description provided for @dynamicsCardSecretSantaBody.
  ///
  /// In es, this message translates to:
  /// **'Asignaciones privadas, listas de deseos y chat de grupo.'**
  String get dynamicsCardSecretSantaBody;

  /// No description provided for @dynamicsCardRaffleTitle.
  ///
  /// In es, this message translates to:
  /// **'Sorteo'**
  String get dynamicsCardRaffleTitle;

  /// No description provided for @dynamicsCardRaffleBody.
  ///
  /// In es, this message translates to:
  /// **'Ganadores públicos para todo el grupo. Sin secretos ni entregas gestionadas.'**
  String get dynamicsCardRaffleBody;

  /// No description provided for @dynamicsCardTeamsTitle.
  ///
  /// In es, this message translates to:
  /// **'Equipos'**
  String get dynamicsCardTeamsTitle;

  /// No description provided for @dynamicsCardPairingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Parejas'**
  String get dynamicsCardPairingsTitle;

  /// No description provided for @dynamicsCardDuelsTitle.
  ///
  /// In es, this message translates to:
  /// **'Duelos'**
  String get dynamicsCardDuelsTitle;

  /// No description provided for @dynamicsComingSoonBadge.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get dynamicsComingSoonBadge;

  /// No description provided for @homeDynamicTypeSecretSanta.
  ///
  /// In es, this message translates to:
  /// **'Amigo secreto'**
  String get homeDynamicTypeSecretSanta;

  /// No description provided for @homeDynamicTypeRaffle.
  ///
  /// In es, this message translates to:
  /// **'Sorteo'**
  String get homeDynamicTypeRaffle;

  /// No description provided for @homeRaffleStatePreparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando'**
  String get homeRaffleStatePreparing;

  /// No description provided for @homeRaffleStateCompleted.
  ///
  /// In es, this message translates to:
  /// **'Sorteo realizado'**
  String get homeRaffleStateCompleted;

  /// No description provided for @raffleWizardTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo sorteo'**
  String get raffleWizardTitle;

  /// No description provided for @raffleWizardNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del sorteo'**
  String get raffleWizardNameLabel;

  /// No description provided for @raffleWizardWinnersLabel.
  ///
  /// In es, this message translates to:
  /// **'Número de ganadores'**
  String get raffleWizardWinnersLabel;

  /// No description provided for @raffleWizardOwnerParticipatesTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Participas tú?'**
  String get raffleWizardOwnerParticipatesTitle;

  /// No description provided for @raffleWizardOwnerParticipatesYes.
  ///
  /// In es, this message translates to:
  /// **'Sí, entro en el bombo'**
  String get raffleWizardOwnerParticipatesYes;

  /// No description provided for @raffleWizardOwnerParticipatesNo.
  ///
  /// In es, this message translates to:
  /// **'No, solo organizo'**
  String get raffleWizardOwnerParticipatesNo;

  /// No description provided for @raffleWizardEventOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha del evento (opcional)'**
  String get raffleWizardEventOptional;

  /// No description provided for @raffleWizardReviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Revisión'**
  String get raffleWizardReviewTitle;

  /// No description provided for @raffleWizardReviewWinners.
  ///
  /// In es, this message translates to:
  /// **'{count} ganador(es)'**
  String raffleWizardReviewWinners(int count);

  /// No description provided for @raffleWizardCreateCta.
  ///
  /// In es, this message translates to:
  /// **'Crear sorteo'**
  String get raffleWizardCreateCta;

  /// No description provided for @raffleDetailInviteSection.
  ///
  /// In es, this message translates to:
  /// **'Invitación'**
  String get raffleDetailInviteSection;

  /// No description provided for @raffleDetailAppMembersTitle.
  ///
  /// In es, this message translates to:
  /// **'Participantes con app'**
  String get raffleDetailAppMembersTitle;

  /// No description provided for @raffleDetailManualTitle.
  ///
  /// In es, this message translates to:
  /// **'Participantes sin app'**
  String get raffleDetailManualTitle;

  /// No description provided for @raffleDetailAddManualCta.
  ///
  /// In es, this message translates to:
  /// **'Añadir persona'**
  String get raffleDetailAddManualCta;

  /// No description provided for @raffleDetailRunRaffleCta.
  ///
  /// In es, this message translates to:
  /// **'Realizar sorteo'**
  String get raffleDetailRunRaffleCta;

  /// No description provided for @raffleDetailWinnersTitle.
  ///
  /// In es, this message translates to:
  /// **'Ganadores'**
  String get raffleDetailWinnersTitle;

  /// No description provided for @raffleDetailShareCta.
  ///
  /// In es, this message translates to:
  /// **'Compartir resultado'**
  String get raffleDetailShareCta;

  /// No description provided for @raffleDetailCompletedHint.
  ///
  /// In es, this message translates to:
  /// **'Este sorteo ya está cerrado: no se pueden cambiar participantes ni volver a sortear.'**
  String get raffleDetailCompletedHint;

  /// No description provided for @raffleManualEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar participante'**
  String get raffleManualEditTitle;

  /// No description provided for @raffleManualDisplayNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre visible'**
  String get raffleManualDisplayNameLabel;

  /// No description provided for @raffleShareBody.
  ///
  /// In es, this message translates to:
  /// **'Ya tenemos ganadores de «{raffleName}»:\n{winners}\n\nHecho con Tarci Secret.'**
  String raffleShareBody(String raffleName, String winners);

  /// No description provided for @functionsErrorRaffleResolvedInvitesClosed.
  ///
  /// In es, this message translates to:
  /// **'Este sorteo ya se realizó y ya no admite nuevos participantes.'**
  String get functionsErrorRaffleResolvedInvitesClosed;

  /// No description provided for @functionsErrorRaffleInProgress.
  ///
  /// In es, this message translates to:
  /// **'El sorteo está en curso. Inténtalo en unos segundos.'**
  String get functionsErrorRaffleInProgress;

  /// No description provided for @functionsErrorRaffleRotateLocked.
  ///
  /// In es, this message translates to:
  /// **'No se puede rotar el código cuando el sorteo ya no admite cambios.'**
  String get functionsErrorRaffleRotateLocked;

  /// No description provided for @functionsErrorRaffleAlreadyCompleted.
  ///
  /// In es, this message translates to:
  /// **'Este sorteo ya se completó.'**
  String get functionsErrorRaffleAlreadyCompleted;

  /// No description provided for @functionsErrorRaffleTooManyWinners.
  ///
  /// In es, this message translates to:
  /// **'Hay más ganadores que participantes elegibles.'**
  String get functionsErrorRaffleTooManyWinners;

  /// No description provided for @functionsErrorRaffleInsufficientParticipants.
  ///
  /// In es, this message translates to:
  /// **'No hay participantes suficientes para este sorteo.'**
  String get functionsErrorRaffleInsufficientParticipants;

  /// No description provided for @functionsErrorRaffleInvalidDynamic.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no está disponible para este tipo de grupo.'**
  String get functionsErrorRaffleInvalidDynamic;

  /// No description provided for @functionsErrorChatNotAvailableForRaffle.
  ///
  /// In es, this message translates to:
  /// **'El chat de grupo no está disponible en sorteos públicos.'**
  String get functionsErrorChatNotAvailableForRaffle;

  /// No description provided for @functionsErrorWishlistNotAvailableForRaffle.
  ///
  /// In es, this message translates to:
  /// **'La lista de deseos no está disponible en sorteos.'**
  String get functionsErrorWishlistNotAvailableForRaffle;

  /// No description provided for @functionsErrorManagedParticipantsNotForRaffle.
  ///
  /// In es, this message translates to:
  /// **'Los participantes gestionados de amigo secreto no aplican a sorteos.'**
  String get functionsErrorManagedParticipantsNotForRaffle;

  /// No description provided for @functionsErrorDrawNotForRaffle.
  ///
  /// In es, this message translates to:
  /// **'El sorteo de amigo secreto no está disponible en grupos de tipo sorteo.'**
  String get functionsErrorDrawNotForRaffle;

  /// No description provided for @functionsErrorAssignmentsNotForRaffle.
  ///
  /// In es, this message translates to:
  /// **'Las asignaciones secretas no aplican a este grupo.'**
  String get functionsErrorAssignmentsNotForRaffle;

  /// No description provided for @raffleDetailEligibleCount.
  ///
  /// In es, this message translates to:
  /// **'Participantes en el bombo: {count}'**
  String raffleDetailEligibleCount(int count);

  /// No description provided for @raffleWizardPickEventDate.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get raffleWizardPickEventDate;

  /// No description provided for @functionsErrorDrawNotSupportedForDynamic.
  ///
  /// In es, this message translates to:
  /// **'El sorteo de amigo secreto no está disponible para este tipo de grupo.'**
  String get functionsErrorDrawNotSupportedForDynamic;

  /// No description provided for @functionsErrorRaffleEditLocked.
  ///
  /// In es, this message translates to:
  /// **'Este sorteo ya no admite cambios en participantes.'**
  String get functionsErrorRaffleEditLocked;

  /// No description provided for @raffleDetailMinPoolHint.
  ///
  /// In es, this message translates to:
  /// **'Necesitas al menos 2 participantes en el bombo para realizar el sorteo.'**
  String get raffleDetailMinPoolHint;

  /// No description provided for @raffleResultHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Sorteo realizado!'**
  String get raffleResultHeroTitle;

  /// No description provided for @raffleResultHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ya tenemos el resultado.'**
  String get raffleResultHeroSubtitle;

  /// No description provided for @raffleResultSingleWinner.
  ///
  /// In es, this message translates to:
  /// **'Ganador: {name}'**
  String raffleResultSingleWinner(String name);

  /// No description provided for @raffleResultMultipleWinners.
  ///
  /// In es, this message translates to:
  /// **'Ganadores: {names}'**
  String raffleResultMultipleWinners(String names);

  /// No description provided for @raffleWizardOwnerNicknameLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre en el bombo'**
  String get raffleWizardOwnerNicknameLabel;

  /// No description provided for @raffleWizardOwnerNicknameHelper.
  ///
  /// In es, this message translates to:
  /// **'Así te verán los demás. Usa un apodo o nombre, no tu rol de organizador.'**
  String get raffleWizardOwnerNicknameHelper;

  /// No description provided for @raffleOwnerParticipantFallback.
  ///
  /// In es, this message translates to:
  /// **'Participante'**
  String get raffleOwnerParticipantFallback;

  /// No description provided for @raffleMemberDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Participante'**
  String get raffleMemberDefaultName;

  /// No description provided for @raffleDetailStatsWinners.
  ///
  /// In es, this message translates to:
  /// **'Número de ganadores'**
  String get raffleDetailStatsWinners;

  /// No description provided for @raffleDetailInPool.
  ///
  /// In es, this message translates to:
  /// **'En el bombo'**
  String get raffleDetailInPool;

  /// No description provided for @pushActivationTitle.
  ///
  /// In es, this message translates to:
  /// **'Activa las notificaciones'**
  String get pushActivationTitle;

  /// No description provided for @pushActivationBody.
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos cuando se realice un sorteo o cuando tu amigo secreto esté listo.'**
  String get pushActivationBody;

  /// No description provided for @pushActivationCta.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get pushActivationCta;

  /// No description provided for @pushActivationSuccessSnackbar.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones activadas.'**
  String get pushActivationSuccessSnackbar;

  /// No description provided for @pushActivationDeniedSnackbar.
  ///
  /// In es, this message translates to:
  /// **'No pudimos activar las notificaciones. Puedes intentarlo más tarde desde los ajustes del sistema.'**
  String get pushActivationDeniedSnackbar;

  /// No description provided for @dynamicsCardTeamsBody.
  ///
  /// In es, this message translates to:
  /// **'Reparte participantes en equipos equilibrados. Resultado visible para todos.'**
  String get dynamicsCardTeamsBody;

  /// No description provided for @homeDynamicTypeTeams.
  ///
  /// In es, this message translates to:
  /// **'Equipos'**
  String get homeDynamicTypeTeams;

  /// No description provided for @homeTeamsStatePreparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando'**
  String get homeTeamsStatePreparing;

  /// No description provided for @homeTeamsStateGenerating.
  ///
  /// In es, this message translates to:
  /// **'Formando equipos'**
  String get homeTeamsStateGenerating;

  /// No description provided for @homePairingsStateGenerating.
  ///
  /// In es, this message translates to:
  /// **'Formando parejas'**
  String get homePairingsStateGenerating;

  /// No description provided for @homeDuelsStateGenerating.
  ///
  /// In es, this message translates to:
  /// **'Formando duelos'**
  String get homeDuelsStateGenerating;

  /// No description provided for @homeTeamsStateCompleted.
  ///
  /// In es, this message translates to:
  /// **'Equipos listos'**
  String get homeTeamsStateCompleted;

  /// No description provided for @teamsWizardTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear equipos'**
  String get teamsWizardTitle;

  /// No description provided for @teamsWizardCreateCta.
  ///
  /// In es, this message translates to:
  /// **'Crear equipos'**
  String get teamsWizardCreateCta;

  /// No description provided for @teamsWizardNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la dinámica'**
  String get teamsWizardNameLabel;

  /// No description provided for @teamsWizardOwnerNicknameLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre en los equipos'**
  String get teamsWizardOwnerNicknameLabel;

  /// No description provided for @teamsWizardOwnerNicknameHelper.
  ///
  /// In es, this message translates to:
  /// **'Así te verán los demás en el reparto. Usa un apodo, no tu rol de organizador.'**
  String get teamsWizardOwnerNicknameHelper;

  /// No description provided for @teamsWizardEventOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha del evento (opcional)'**
  String get teamsWizardEventOptional;

  /// No description provided for @teamsWizardPickEventDate.
  ///
  /// In es, this message translates to:
  /// **'Elegir fecha'**
  String get teamsWizardPickEventDate;

  /// No description provided for @teamsWizardOwnerParticipatesTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Participas tú?'**
  String get teamsWizardOwnerParticipatesTitle;

  /// No description provided for @teamsWizardOwnerParticipatesYes.
  ///
  /// In es, this message translates to:
  /// **'Sí, quiero estar en un equipo'**
  String get teamsWizardOwnerParticipatesYes;

  /// No description provided for @teamsWizardOwnerParticipatesNo.
  ///
  /// In es, this message translates to:
  /// **'No, solo organizo'**
  String get teamsWizardOwnerParticipatesNo;

  /// No description provided for @teamsWizardGroupingTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo formar los equipos?'**
  String get teamsWizardGroupingTitle;

  /// No description provided for @teamsWizardGroupingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Elige si prefieres un número fijo de equipos o un tamaño por equipo.'**
  String get teamsWizardGroupingSubtitle;

  /// No description provided for @teamsWizardModeTeamCount.
  ///
  /// In es, this message translates to:
  /// **'Por número de equipos'**
  String get teamsWizardModeTeamCount;

  /// No description provided for @teamsWizardModeTeamSize.
  ///
  /// In es, this message translates to:
  /// **'Por personas por equipo'**
  String get teamsWizardModeTeamSize;

  /// No description provided for @teamsWizardTeamCountLabel.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántos equipos?'**
  String get teamsWizardTeamCountLabel;

  /// No description provided for @teamsWizardTeamSizeLabel.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántas personas por equipo?'**
  String get teamsWizardTeamSizeLabel;

  /// No description provided for @teamsWizardReviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Revisión'**
  String get teamsWizardReviewTitle;

  /// No description provided for @teamsWizardReviewTeamCount.
  ///
  /// In es, this message translates to:
  /// **'{count} equipos'**
  String teamsWizardReviewTeamCount(int count);

  /// No description provided for @teamsWizardReviewTeamSize.
  ///
  /// In es, this message translates to:
  /// **'Equipos de {size} personas'**
  String teamsWizardReviewTeamSize(int size);

  /// No description provided for @teamsOwnerParticipantFallback.
  ///
  /// In es, this message translates to:
  /// **'Participante'**
  String get teamsOwnerParticipantFallback;

  /// No description provided for @teamsMemberDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Participante'**
  String get teamsMemberDefaultName;

  /// No description provided for @teamsDetailInviteSection.
  ///
  /// In es, this message translates to:
  /// **'Invitación'**
  String get teamsDetailInviteSection;

  /// No description provided for @teamsDetailAppMembersTitle.
  ///
  /// In es, this message translates to:
  /// **'Participantes con app'**
  String get teamsDetailAppMembersTitle;

  /// No description provided for @teamsDetailManualTitle.
  ///
  /// In es, this message translates to:
  /// **'Participantes sin app'**
  String get teamsDetailManualTitle;

  /// No description provided for @teamsDetailAddManualCta.
  ///
  /// In es, this message translates to:
  /// **'Añadir persona'**
  String get teamsDetailAddManualCta;

  /// No description provided for @teamsDetailFormTeamsCta.
  ///
  /// In es, this message translates to:
  /// **'Formar equipos'**
  String get teamsDetailFormTeamsCta;

  /// No description provided for @teamsDetailConfigTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get teamsDetailConfigTitle;

  /// No description provided for @teamsDetailConfigTeamCount.
  ///
  /// In es, this message translates to:
  /// **'{count} equipos'**
  String teamsDetailConfigTeamCount(int count);

  /// No description provided for @teamsDetailConfigTeamSize.
  ///
  /// In es, this message translates to:
  /// **'Equipos de {size} personas'**
  String teamsDetailConfigTeamSize(int size);

  /// No description provided for @teamsDetailEstimatedTeams.
  ///
  /// In es, this message translates to:
  /// **'Equipos estimados: {count}'**
  String teamsDetailEstimatedTeams(int count);

  /// No description provided for @teamsDetailEligibleCount.
  ///
  /// In es, this message translates to:
  /// **'Participantes en el reparto: {count}'**
  String teamsDetailEligibleCount(int count);

  /// No description provided for @teamsDetailMinPoolHint.
  ///
  /// In es, this message translates to:
  /// **'Necesitas al menos 2 participantes para formar equipos.'**
  String get teamsDetailMinPoolHint;

  /// No description provided for @teamsDetailInvalidConfigHint.
  ///
  /// In es, this message translates to:
  /// **'Revisa la configuración de equipos antes de continuar.'**
  String get teamsDetailInvalidConfigHint;

  /// No description provided for @teamsDetailCompletedHint.
  ///
  /// In es, this message translates to:
  /// **'Los equipos ya están formados: no se pueden cambiar participantes ni volver a formar.'**
  String get teamsDetailCompletedHint;

  /// No description provided for @teamsDetailTeamsListTitle.
  ///
  /// In es, this message translates to:
  /// **'Equipos'**
  String get teamsDetailTeamsListTitle;

  /// No description provided for @teamsDetailShareCta.
  ///
  /// In es, this message translates to:
  /// **'Compartir resultado'**
  String get teamsDetailShareCta;

  /// No description provided for @teamsDetailEmailCta.
  ///
  /// In es, this message translates to:
  /// **'Preparar correo'**
  String get teamsDetailEmailCta;

  /// No description provided for @teamsDetailPdfCta.
  ///
  /// In es, this message translates to:
  /// **'Generar PDF'**
  String get teamsDetailPdfCta;

  /// No description provided for @teamsManualDisplayNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre visible'**
  String get teamsManualDisplayNameLabel;

  /// No description provided for @teamsManualEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar participante'**
  String get teamsManualEditTitle;

  /// No description provided for @teamsResultHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Equipos listos!'**
  String get teamsResultHeroTitle;

  /// No description provided for @teamsResultHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ya puedes compartir el reparto con el grupo.'**
  String get teamsResultHeroSubtitle;

  /// No description provided for @teamsResultSummary.
  ///
  /// In es, this message translates to:
  /// **'{teamCount} equipos · {participantCount} participantes'**
  String teamsResultSummary(int teamCount, int participantCount);

  /// No description provided for @teamsUnitLabel.
  ///
  /// In es, this message translates to:
  /// **'Equipo {number}'**
  String teamsUnitLabel(int number);

  /// No description provided for @teamsShareBody.
  ///
  /// In es, this message translates to:
  /// **'🧩 Equipos generados en «{groupName}»\n\n{teamsBlock}\n\nHecho con Tarci Secret.'**
  String teamsShareBody(String groupName, String teamsBlock);

  /// No description provided for @teamsEmailSubject.
  ///
  /// In es, this message translates to:
  /// **'Equipos generados — {groupName}'**
  String teamsEmailSubject(String groupName);

  /// No description provided for @teamsEmailBody.
  ///
  /// In es, this message translates to:
  /// **'Hola,\n\nYa están listos los equipos de «{groupName}»:\n\n{teamsBlock}\n\nGenerado con Tarci Secret.'**
  String teamsEmailBody(String groupName, String teamsBlock);

  /// No description provided for @teamsEmailError.
  ///
  /// In es, this message translates to:
  /// **'No hay una app de correo disponible en este dispositivo.'**
  String get teamsEmailError;

  /// No description provided for @teamsPdfHeadline.
  ///
  /// In es, this message translates to:
  /// **'Equipos generados'**
  String get teamsPdfHeadline;

  /// No description provided for @teamsPdfSummary.
  ///
  /// In es, this message translates to:
  /// **'{teamCount} equipos · {participantCount} participantes'**
  String teamsPdfSummary(int teamCount, int participantCount);

  /// No description provided for @teamsPdfFooter.
  ///
  /// In es, this message translates to:
  /// **'Generado con Tarci Secret'**
  String get teamsPdfFooter;

  /// No description provided for @teamsPdfError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo generar el PDF. Inténtalo de nuevo.'**
  String get teamsPdfError;

  /// No description provided for @joinSuccessTeamsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Te uniste a «{groupName}».'**
  String joinSuccessTeamsSubtitle(String groupName);

  /// No description provided for @joinSuccessTeamsBody.
  ///
  /// In es, this message translates to:
  /// **'Cuando el organizador forme los equipos, podrás ver el resultado aquí.'**
  String get joinSuccessTeamsBody;

  /// No description provided for @joinSuccessTeamsPrimaryCta.
  ///
  /// In es, this message translates to:
  /// **'Ir a equipos'**
  String get joinSuccessTeamsPrimaryCta;

  /// No description provided for @functionsErrorTeamsResolvedInvitesClosed.
  ///
  /// In es, this message translates to:
  /// **'Los equipos ya están formados y este grupo no acepta nuevos participantes.'**
  String get functionsErrorTeamsResolvedInvitesClosed;

  /// No description provided for @functionsErrorTeamsInProgress.
  ///
  /// In es, this message translates to:
  /// **'Se están formando los equipos. Inténtalo en un momento.'**
  String get functionsErrorTeamsInProgress;

  /// No description provided for @functionsErrorTeamsRotateLocked.
  ///
  /// In es, this message translates to:
  /// **'No se puede cambiar el código después de formar los equipos.'**
  String get functionsErrorTeamsRotateLocked;

  /// No description provided for @functionsErrorTeamsAlreadyCompleted.
  ///
  /// In es, this message translates to:
  /// **'Los equipos ya están formados.'**
  String get functionsErrorTeamsAlreadyCompleted;

  /// No description provided for @functionsErrorTeamsInsufficientParticipants.
  ///
  /// In es, this message translates to:
  /// **'Se necesitan al menos 2 participantes para formar equipos.'**
  String get functionsErrorTeamsInsufficientParticipants;

  /// No description provided for @functionsErrorTeamsInvalidConfiguration.
  ///
  /// In es, this message translates to:
  /// **'La configuración de equipos no es válida.'**
  String get functionsErrorTeamsInvalidConfiguration;

  /// No description provided for @functionsErrorTeamsTooManyParticipants.
  ///
  /// In es, this message translates to:
  /// **'Has alcanzado el máximo de participantes permitidos.'**
  String get functionsErrorTeamsTooManyParticipants;

  /// No description provided for @functionsErrorTeamsInvalidDynamic.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no está disponible para este tipo de dinámica.'**
  String get functionsErrorTeamsInvalidDynamic;

  /// No description provided for @functionsErrorTeamsEditLocked.
  ///
  /// In es, this message translates to:
  /// **'No se pueden editar participantes después de formar los equipos.'**
  String get functionsErrorTeamsEditLocked;

  /// No description provided for @chatSystemAutoTeamsPlayful001V1.
  ///
  /// In es, this message translates to:
  /// **'Equipos listos. Ya podéis empezar a culpar al algoritmo.'**
  String get chatSystemAutoTeamsPlayful001V1;

  /// No description provided for @chatSystemAutoTeamsPlayful002V1.
  ///
  /// In es, this message translates to:
  /// **'¿Qué equipo viene a ganar y cuál viene por la merienda?'**
  String get chatSystemAutoTeamsPlayful002V1;

  /// No description provided for @chatSystemAutoTeamsPlayful003V1.
  ///
  /// In es, this message translates to:
  /// **'Aquí hay talento… y también mucha confianza. Veremos cuál pesa más.'**
  String get chatSystemAutoTeamsPlayful003V1;

  /// No description provided for @chatSystemAutoTeamsPlayful004V1.
  ///
  /// In es, this message translates to:
  /// **'Se aceptan pronósticos, excusas y teorías conspirativas.'**
  String get chatSystemAutoTeamsPlayful004V1;

  /// No description provided for @chatSystemAutoTeamsPlayful005V1.
  ///
  /// In es, this message translates to:
  /// **'Un reparto justo. Las quejas creativas también cuentan como participación.'**
  String get chatSystemAutoTeamsPlayful005V1;

  /// No description provided for @chatSystemAutoTeamsPlayful006V1.
  ///
  /// In es, this message translates to:
  /// **'No importa quién quede contigo. Importa quién termina pidiendo revancha.'**
  String get chatSystemAutoTeamsPlayful006V1;

  /// No description provided for @chatSystemAutoTeamsPlayful007V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci repartió. Ahora os toca demostrar que no era suerte.'**
  String get chatSystemAutoTeamsPlayful007V1;

  /// No description provided for @chatSystemAutoTeamsPlayful008V1.
  ///
  /// In es, this message translates to:
  /// **'Hay equipos que inspiran respeto y otros que inspiran memes.'**
  String get chatSystemAutoTeamsPlayful008V1;

  /// No description provided for @chatSystemAutoTeamsPlayful009V1.
  ///
  /// In es, this message translates to:
  /// **'El azar habló. La dignidad se resuelve el día del encuentro.'**
  String get chatSystemAutoTeamsPlayful009V1;

  /// No description provided for @chatSystemAutoTeamsPlayful010V1.
  ///
  /// In es, this message translates to:
  /// **'Que nadie subestime a un equipo silencioso.'**
  String get chatSystemAutoTeamsPlayful010V1;

  /// No description provided for @chatSystemAutoTeamsPlayful011V1.
  ///
  /// In es, this message translates to:
  /// **'Algunos ya celebran. Otros están calculando cómo cambiar de equipo sin que se note.'**
  String get chatSystemAutoTeamsPlayful011V1;

  /// No description provided for @chatSystemAutoTeamsPlayful012V1.
  ///
  /// In es, this message translates to:
  /// **'Resultado publicado. Empieza oficialmente el salseo.'**
  String get chatSystemAutoTeamsPlayful012V1;

  /// No description provided for @chatSystemAutoTeamsPlayful013V1.
  ///
  /// In es, this message translates to:
  /// **'Hay química de equipo… o al menos eso dice la estadística emocional.'**
  String get chatSystemAutoTeamsPlayful013V1;

  /// No description provided for @chatSystemAutoTeamsPlayful014V1.
  ///
  /// In es, this message translates to:
  /// **'Un buen equipo se construye. Uno legendario se presume antes de jugar.'**
  String get chatSystemAutoTeamsPlayful014V1;

  /// No description provided for @chatSystemAutoTeamsPlayful015V1.
  ///
  /// In es, this message translates to:
  /// **'El grupo ya tiene reparto. Ahora falta la épica.'**
  String get chatSystemAutoTeamsPlayful015V1;

  /// No description provided for @chatSystemAutoTeamsPlayful016V1.
  ///
  /// In es, this message translates to:
  /// **'A partir de aquí, cada mensaje puede convertirse en motivación para el rival.'**
  String get chatSystemAutoTeamsPlayful016V1;

  /// No description provided for @chatSystemAutoTeamsPlayful017V1.
  ///
  /// In es, this message translates to:
  /// **'Equipos formados. El orgullo grupal queda activado.'**
  String get chatSystemAutoTeamsPlayful017V1;

  /// No description provided for @chatSystemAutoTeamsPlayful018V1.
  ///
  /// In es, this message translates to:
  /// **'Ya podéis inventar nombre de guerra, aunque Tarci aún no lo guarde.'**
  String get chatSystemAutoTeamsPlayful018V1;

  /// No description provided for @chatSystemAutoTeamsPlayful019V1.
  ///
  /// In es, this message translates to:
  /// **'Que empiece la parte favorita: opinar sobre si el reparto fue justo.'**
  String get chatSystemAutoTeamsPlayful019V1;

  /// No description provided for @chatSystemAutoTeamsPlayful020V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci no toma partido. Pero sí guarda capturas mentales del pique.'**
  String get chatSystemAutoTeamsPlayful020V1;

  /// No description provided for @chatSystemAutoTeamsChallenge001V1.
  ///
  /// In es, this message translates to:
  /// **'Reto del día: cada equipo debe explicar por qué merece ganar.'**
  String get chatSystemAutoTeamsChallenge001V1;

  /// No description provided for @chatSystemAutoTeamsChallenge002V1.
  ///
  /// In es, this message translates to:
  /// **'¿Quién se atreve a lanzar el primer desafío amistoso?'**
  String get chatSystemAutoTeamsChallenge002V1;

  /// No description provided for @chatSystemAutoTeamsChallenge003V1.
  ///
  /// In es, this message translates to:
  /// **'Equipo que no escriba hoy, empieza perdiendo en carisma.'**
  String get chatSystemAutoTeamsChallenge003V1;

  /// No description provided for @chatSystemAutoTeamsChallenge004V1.
  ///
  /// In es, this message translates to:
  /// **'Propongo una norma no oficial: quien más hable, luego tiene que responder.'**
  String get chatSystemAutoTeamsChallenge004V1;

  /// No description provided for @chatSystemAutoTeamsChallenge005V1.
  ///
  /// In es, this message translates to:
  /// **'¿Hay favorito o todavía fingimos humildad?'**
  String get chatSystemAutoTeamsChallenge005V1;

  /// No description provided for @chatSystemAutoTeamsChallenge006V1.
  ///
  /// In es, this message translates to:
  /// **'Dejad constancia aquí: ¿qué equipo se lleva la gloria?'**
  String get chatSystemAutoTeamsChallenge006V1;

  /// No description provided for @chatSystemAutoTeamsChallenge007V1.
  ///
  /// In es, this message translates to:
  /// **'Un reto suave: haced vuestra predicción antes del encuentro.'**
  String get chatSystemAutoTeamsChallenge007V1;

  /// No description provided for @chatSystemAutoTeamsChallenge008V1.
  ///
  /// In es, this message translates to:
  /// **'Si hay confianza, que haya apuestas simbólicas.'**
  String get chatSystemAutoTeamsChallenge008V1;

  /// No description provided for @chatSystemAutoTeamsChallenge009V1.
  ///
  /// In es, this message translates to:
  /// **'¿Qué equipo trae estrategia y cuál trae puro corazón?'**
  String get chatSystemAutoTeamsChallenge009V1;

  /// No description provided for @chatSystemAutoTeamsChallenge010V1.
  ///
  /// In es, this message translates to:
  /// **'Momento de declarar intenciones. El silencio no puntúa.'**
  String get chatSystemAutoTeamsChallenge010V1;

  /// No description provided for @chatSystemAutoTeamsChallenge011V1.
  ///
  /// In es, this message translates to:
  /// **'Que cada equipo nombre a su portavoz espontáneo. Luego negáis haberlo elegido.'**
  String get chatSystemAutoTeamsChallenge011V1;

  /// No description provided for @chatSystemAutoTeamsChallenge012V1.
  ///
  /// In es, this message translates to:
  /// **'¿Quién rompe el hielo con la primera provocación elegante?'**
  String get chatSystemAutoTeamsChallenge012V1;

  /// No description provided for @chatSystemAutoTeamsQuiet001V1.
  ///
  /// In es, this message translates to:
  /// **'Mucho silencio para unos equipos tan prometedores.'**
  String get chatSystemAutoTeamsQuiet001V1;

  /// No description provided for @chatSystemAutoTeamsQuiet002V1.
  ///
  /// In es, this message translates to:
  /// **'Este chat está más tranquilo que un banquillo antes del pitido inicial.'**
  String get chatSystemAutoTeamsQuiet002V1;

  /// No description provided for @chatSystemAutoTeamsQuiet003V1.
  ///
  /// In es, this message translates to:
  /// **'¿Nadie va a comentar el reparto? Sospechoso.'**
  String get chatSystemAutoTeamsQuiet003V1;

  /// No description provided for @chatSystemAutoTeamsQuiet004V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci detecta calma. A veces eso significa estrategia.'**
  String get chatSystemAutoTeamsQuiet004V1;

  /// No description provided for @chatSystemAutoTeamsQuiet005V1.
  ///
  /// In es, this message translates to:
  /// **'Los equipos están hechos. El chat aún espera su primer buen pique.'**
  String get chatSystemAutoTeamsQuiet005V1;

  /// No description provided for @chatSystemAutoTeamsQuiet006V1.
  ///
  /// In es, this message translates to:
  /// **'Un grupo en silencio no es paz: es tensión dramática.'**
  String get chatSystemAutoTeamsQuiet006V1;

  /// No description provided for @chatSystemAutoTeamsQuiet007V1.
  ///
  /// In es, this message translates to:
  /// **'¿Todo el mundo conforme? Esa unanimidad merece revisión.'**
  String get chatSystemAutoTeamsQuiet007V1;

  /// No description provided for @chatSystemAutoTeamsQuiet008V1.
  ///
  /// In es, this message translates to:
  /// **'Silencio táctico activado. Continuad, que queda elegante.'**
  String get chatSystemAutoTeamsQuiet008V1;

  /// No description provided for @chatSystemAutoTeamsCountdown014V1.
  ///
  /// In es, this message translates to:
  /// **'Faltan 14 días. Tiempo de organizarse… o de improvisar con confianza.'**
  String get chatSystemAutoTeamsCountdown014V1;

  /// No description provided for @chatSystemAutoTeamsCountdown007V1.
  ///
  /// In es, this message translates to:
  /// **'Falta una semana. Las estrategias absurdas ya pueden presentarse oficialmente.'**
  String get chatSystemAutoTeamsCountdown007V1;

  /// No description provided for @chatSystemAutoTeamsCountdown003V1.
  ///
  /// In es, this message translates to:
  /// **'Quedan 3 días. A estas alturas la épica está permitida.'**
  String get chatSystemAutoTeamsCountdown003V1;

  /// No description provided for @chatSystemAutoTeamsCountdown001V1.
  ///
  /// In es, this message translates to:
  /// **'Mañana es el día. Última oportunidad para presumir sin consecuencias.'**
  String get chatSystemAutoTeamsCountdown001V1;

  /// No description provided for @chatSystemAutoTeamsCountdown000V1.
  ///
  /// In es, this message translates to:
  /// **'Hoy toca. Equipos listos, nervios opcionales.'**
  String get chatSystemAutoTeamsCountdown000V1;

  /// No description provided for @chatSystemAutoTeamsCountdownExtra001V1.
  ///
  /// In es, this message translates to:
  /// **'Dos semanas parecen mucho hasta que alguien recuerda que no ha preparado nada.'**
  String get chatSystemAutoTeamsCountdownExtra001V1;

  /// No description provided for @chatSystemAutoTeamsCountdownExtra002V1.
  ///
  /// In es, this message translates to:
  /// **'Siete días. Lo suficiente para entrenar o para perfeccionar una buena excusa.'**
  String get chatSystemAutoTeamsCountdownExtra002V1;

  /// No description provided for @chatSystemAutoTeamsCountdownExtra003V1.
  ///
  /// In es, this message translates to:
  /// **'Tres días. El chat puede pasar de bromas a declaraciones oficiales.'**
  String get chatSystemAutoTeamsCountdownExtra003V1;

  /// No description provided for @chatSystemAutoTeamsCountdownExtra004V1.
  ///
  /// In es, this message translates to:
  /// **'Queda un día. Si había un plan secreto, es buen momento para fingir que existe.'**
  String get chatSystemAutoTeamsCountdownExtra004V1;

  /// No description provided for @chatSystemAutoTeamsCountdownExtra005V1.
  ///
  /// In es, this message translates to:
  /// **'Llegó el momento. Que gane el mejor… o el que mejor lo disimule.'**
  String get chatSystemAutoTeamsCountdownExtra005V1;

  /// No description provided for @teamsChatSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Conversación del grupo'**
  String get teamsChatSectionTitle;

  /// No description provided for @teamsChatSectionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Comentad el reparto, retos y el día del encuentro.'**
  String get teamsChatSectionSubtitle;

  /// No description provided for @teamsChatEnterCta.
  ///
  /// In es, this message translates to:
  /// **'Abrir chat'**
  String get teamsChatEnterCta;

  /// No description provided for @chatTeamsCompletedChip.
  ///
  /// In es, this message translates to:
  /// **'Equipos listos'**
  String get chatTeamsCompletedChip;

  /// No description provided for @chatSystemTeamsCompletedV1.
  ///
  /// In es, this message translates to:
  /// **'Los equipos ya están listos. Ahora sí: que empiece el pique.'**
  String get chatSystemTeamsCompletedV1;

  /// No description provided for @teamsMemberWaitingTitle.
  ///
  /// In es, this message translates to:
  /// **'Equipos en preparación'**
  String get teamsMemberWaitingTitle;

  /// No description provided for @teamsMemberWaitingBody.
  ///
  /// In es, this message translates to:
  /// **'El organizador está preparando el reparto. Cuando los equipos estén listos podrás verlos aquí y entrar al chat del grupo.'**
  String get teamsMemberWaitingBody;

  /// No description provided for @teamsMemberPoolSummary.
  ///
  /// In es, this message translates to:
  /// **'{count} participantes en el grupo'**
  String teamsMemberPoolSummary(int count);

  /// No description provided for @teamsOrganizerByline.
  ///
  /// In es, this message translates to:
  /// **'Organizado por {name}'**
  String teamsOrganizerByline(String name);

  /// No description provided for @teamsResultActionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Acciones del resultado'**
  String get teamsResultActionsTitle;

  /// No description provided for @teamsRenameDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Renombrar equipo'**
  String get teamsRenameDialogTitle;

  /// No description provided for @teamsRenameDialogFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del equipo'**
  String get teamsRenameDialogFieldLabel;

  /// No description provided for @teamsRenameSuccess.
  ///
  /// In es, this message translates to:
  /// **'Nombre del equipo actualizado'**
  String get teamsRenameSuccess;

  /// No description provided for @teamsYouInTeam.
  ///
  /// In es, this message translates to:
  /// **'Tú'**
  String get teamsYouInTeam;

  /// No description provided for @teamsDetailRosterTitle.
  ///
  /// In es, this message translates to:
  /// **'Participantes del grupo'**
  String get teamsDetailRosterTitle;

  /// No description provided for @dynamicsCardPairingsBody.
  ///
  /// In es, this message translates to:
  /// **'Empareja participantes en parejas de dos. Resultado visible para todos.'**
  String get dynamicsCardPairingsBody;

  /// No description provided for @homeDynamicTypePairings.
  ///
  /// In es, this message translates to:
  /// **'Parejas'**
  String get homeDynamicTypePairings;

  /// No description provided for @homePairingsStateCompleted.
  ///
  /// In es, this message translates to:
  /// **'Parejas listas'**
  String get homePairingsStateCompleted;

  /// No description provided for @homePairingsStatePreparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando parejas'**
  String get homePairingsStatePreparing;

  /// No description provided for @pairingsWizardTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear parejas'**
  String get pairingsWizardTitle;

  /// No description provided for @pairingsWizardCreateCta.
  ///
  /// In es, this message translates to:
  /// **'Crear parejas'**
  String get pairingsWizardCreateCta;

  /// No description provided for @pairingsWizardNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la dinámica'**
  String get pairingsWizardNameLabel;

  /// No description provided for @pairingsWizardOwnerNicknameLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre en las parejas'**
  String get pairingsWizardOwnerNicknameLabel;

  /// No description provided for @pairingsWizardOwnerNicknameHelper.
  ///
  /// In es, this message translates to:
  /// **'Así te verán los demás en el emparejamiento.'**
  String get pairingsWizardOwnerNicknameHelper;

  /// No description provided for @pairingsWizardEventOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha del evento (opcional)'**
  String get pairingsWizardEventOptional;

  /// No description provided for @pairingsWizardPickEventDate.
  ///
  /// In es, this message translates to:
  /// **'Elegir fecha'**
  String get pairingsWizardPickEventDate;

  /// No description provided for @pairingsWizardOwnerParticipatesTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Participas tú?'**
  String get pairingsWizardOwnerParticipatesTitle;

  /// No description provided for @pairingsWizardOwnerParticipatesYes.
  ///
  /// In es, this message translates to:
  /// **'Sí, quiero estar en una pareja'**
  String get pairingsWizardOwnerParticipatesYes;

  /// No description provided for @pairingsWizardOwnerParticipatesNo.
  ///
  /// In es, this message translates to:
  /// **'No, solo organizo'**
  String get pairingsWizardOwnerParticipatesNo;

  /// No description provided for @pairingsWizardReviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Revisión'**
  String get pairingsWizardReviewTitle;

  /// No description provided for @pairingsWizardReviewSummary.
  ///
  /// In es, this message translates to:
  /// **'Parejas de 2 personas'**
  String get pairingsWizardReviewSummary;

  /// No description provided for @pairingsUnitLabel.
  ///
  /// In es, this message translates to:
  /// **'Pareja {index}'**
  String pairingsUnitLabel(int index);

  /// No description provided for @pairingsResultHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Parejas listas!'**
  String get pairingsResultHeroTitle;

  /// No description provided for @pairingsResultHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cada pareja ya tiene a sus dos integrantes.'**
  String get pairingsResultHeroSubtitle;

  /// No description provided for @pairingsResultSummary.
  ///
  /// In es, this message translates to:
  /// **'{count} parejas · {eligible} participantes'**
  String pairingsResultSummary(int count, int eligible);

  /// No description provided for @pairingsDetailListTitle.
  ///
  /// In es, this message translates to:
  /// **'Parejas'**
  String get pairingsDetailListTitle;

  /// No description provided for @pairingsDetailFormCta.
  ///
  /// In es, this message translates to:
  /// **'Formar parejas'**
  String get pairingsDetailFormCta;

  /// No description provided for @pairingsDetailConfigTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get pairingsDetailConfigTitle;

  /// No description provided for @pairingsDetailConfigSummary.
  ///
  /// In es, this message translates to:
  /// **'Aproximadamente {count} parejas'**
  String pairingsDetailConfigSummary(int count);

  /// No description provided for @pairingsRenameDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Renombrar pareja'**
  String get pairingsRenameDialogTitle;

  /// No description provided for @pairingsRenameDialogFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la pareja'**
  String get pairingsRenameDialogFieldLabel;

  /// No description provided for @pairingsRenameSuccess.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la pareja actualizado'**
  String get pairingsRenameSuccess;

  /// No description provided for @pairingsShareBody.
  ///
  /// In es, this message translates to:
  /// **'Parejas de «{groupName}»:\n\n{blocks}'**
  String pairingsShareBody(String groupName, String blocks);

  /// No description provided for @pairingsEmailSubject.
  ///
  /// In es, this message translates to:
  /// **'Parejas: {groupName}'**
  String pairingsEmailSubject(String groupName);

  /// No description provided for @pairingsEmailBody.
  ///
  /// In es, this message translates to:
  /// **'Parejas de «{groupName}»:\n\n{blocks}'**
  String pairingsEmailBody(String groupName, String blocks);

  /// No description provided for @pairingsPdfHeadline.
  ///
  /// In es, this message translates to:
  /// **'Parejas'**
  String get pairingsPdfHeadline;

  /// No description provided for @pairingsChatSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Conversación del grupo'**
  String get pairingsChatSectionTitle;

  /// No description provided for @pairingsChatSectionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Comentad el emparejamiento y el día del encuentro.'**
  String get pairingsChatSectionSubtitle;

  /// No description provided for @pairingsChatEnterCta.
  ///
  /// In es, this message translates to:
  /// **'Abrir chat'**
  String get pairingsChatEnterCta;

  /// No description provided for @chatPairingsCompletedChip.
  ///
  /// In es, this message translates to:
  /// **'Parejas listas'**
  String get chatPairingsCompletedChip;

  /// No description provided for @chatSystemPairingsCompletedV1.
  ///
  /// In es, this message translates to:
  /// **'Las parejas ya están listas. ¡A disfrutar del encuentro!'**
  String get chatSystemPairingsCompletedV1;

  /// No description provided for @pairingsMemberWaitingTitle.
  ///
  /// In es, this message translates to:
  /// **'Parejas en preparación'**
  String get pairingsMemberWaitingTitle;

  /// No description provided for @pairingsMemberWaitingBody.
  ///
  /// In es, this message translates to:
  /// **'El organizador está preparando el emparejamiento. Cuando las parejas estén listas podrás verlas aquí.'**
  String get pairingsMemberWaitingBody;

  /// No description provided for @joinSuccessPairingsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Te uniste a «{groupName}».'**
  String joinSuccessPairingsSubtitle(String groupName);

  /// No description provided for @joinSuccessPairingsBody.
  ///
  /// In es, this message translates to:
  /// **'Cuando el organizador forme las parejas, podrás ver el resultado aquí.'**
  String get joinSuccessPairingsBody;

  /// No description provided for @joinSuccessPairingsPrimaryCta.
  ///
  /// In es, this message translates to:
  /// **'Ir a parejas'**
  String get joinSuccessPairingsPrimaryCta;

  /// No description provided for @pairingsDetailEvenHint.
  ///
  /// In es, this message translates to:
  /// **'Para formar parejas necesitas un número par de participantes elegibles.'**
  String get pairingsDetailEvenHint;

  /// No description provided for @chatSystemAutoPairingsPlayful001V1.
  ///
  /// In es, this message translates to:
  /// **'Parejas listos. Ya podéis empezar a culpar al algoritmo.'**
  String get chatSystemAutoPairingsPlayful001V1;

  /// No description provided for @chatSystemAutoPairingsPlayful002V1.
  ///
  /// In es, this message translates to:
  /// **'¿Qué pareja viene a ganar y cuál viene por la merienda?'**
  String get chatSystemAutoPairingsPlayful002V1;

  /// No description provided for @chatSystemAutoPairingsPlayful003V1.
  ///
  /// In es, this message translates to:
  /// **'Aquí hay talento… y también mucha confianza. Veremos cuál pesa más.'**
  String get chatSystemAutoPairingsPlayful003V1;

  /// No description provided for @chatSystemAutoPairingsPlayful004V1.
  ///
  /// In es, this message translates to:
  /// **'Se aceptan pronósticos, excusas y teorías conspirativas.'**
  String get chatSystemAutoPairingsPlayful004V1;

  /// No description provided for @chatSystemAutoPairingsPlayful005V1.
  ///
  /// In es, this message translates to:
  /// **'Un emparejamiento justo. Las quejas creativas también cuentan como participación.'**
  String get chatSystemAutoPairingsPlayful005V1;

  /// No description provided for @chatSystemAutoPairingsPlayful006V1.
  ///
  /// In es, this message translates to:
  /// **'No importa quién quede contigo. Importa quién termina pidiendo revancha.'**
  String get chatSystemAutoPairingsPlayful006V1;

  /// No description provided for @chatSystemAutoPairingsPlayful007V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci repartió. Ahora os toca demostrar que no era suerte.'**
  String get chatSystemAutoPairingsPlayful007V1;

  /// No description provided for @chatSystemAutoPairingsPlayful008V1.
  ///
  /// In es, this message translates to:
  /// **'Hay parejas que inspiran respeto y otros que inspiran memes.'**
  String get chatSystemAutoPairingsPlayful008V1;

  /// No description provided for @chatSystemAutoPairingsPlayful009V1.
  ///
  /// In es, this message translates to:
  /// **'El azar habló. La dignidad se resuelve el día del encuentro.'**
  String get chatSystemAutoPairingsPlayful009V1;

  /// No description provided for @chatSystemAutoPairingsPlayful010V1.
  ///
  /// In es, this message translates to:
  /// **'Que nadie subestime a un pareja silencioso.'**
  String get chatSystemAutoPairingsPlayful010V1;

  /// No description provided for @chatSystemAutoPairingsPlayful011V1.
  ///
  /// In es, this message translates to:
  /// **'Algunos ya celebran. Otros están calculando cómo cambiar de pareja sin que se note.'**
  String get chatSystemAutoPairingsPlayful011V1;

  /// No description provided for @chatSystemAutoPairingsPlayful012V1.
  ///
  /// In es, this message translates to:
  /// **'Resultado publicado. Empieza oficialmente el salseo.'**
  String get chatSystemAutoPairingsPlayful012V1;

  /// No description provided for @chatSystemAutoPairingsPlayful013V1.
  ///
  /// In es, this message translates to:
  /// **'Hay química de pareja… o al menos eso dice la estadística emocional.'**
  String get chatSystemAutoPairingsPlayful013V1;

  /// No description provided for @chatSystemAutoPairingsPlayful014V1.
  ///
  /// In es, this message translates to:
  /// **'Un buen pareja se construye. Uno legendario se presume antes de jugar.'**
  String get chatSystemAutoPairingsPlayful014V1;

  /// No description provided for @chatSystemAutoPairingsPlayful015V1.
  ///
  /// In es, this message translates to:
  /// **'El grupo ya tiene emparejamiento. Ahora falta la épica.'**
  String get chatSystemAutoPairingsPlayful015V1;

  /// No description provided for @chatSystemAutoPairingsPlayful016V1.
  ///
  /// In es, this message translates to:
  /// **'A partir de aquí, cada mensaje puede convertirse en motivación para el rival.'**
  String get chatSystemAutoPairingsPlayful016V1;

  /// No description provided for @chatSystemAutoPairingsPlayful017V1.
  ///
  /// In es, this message translates to:
  /// **'Parejas formados. El orgullo grupal queda activado.'**
  String get chatSystemAutoPairingsPlayful017V1;

  /// No description provided for @chatSystemAutoPairingsPlayful018V1.
  ///
  /// In es, this message translates to:
  /// **'Ya podéis inventar nombre de guerra, aunque Tarci aún no lo guarde.'**
  String get chatSystemAutoPairingsPlayful018V1;

  /// No description provided for @chatSystemAutoPairingsPlayful019V1.
  ///
  /// In es, this message translates to:
  /// **'Que empiece la parte favorita: opinar sobre si el emparejamiento fue justo.'**
  String get chatSystemAutoPairingsPlayful019V1;

  /// No description provided for @chatSystemAutoPairingsPlayful020V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci no toma partido. Pero sí guarda capturas mentales del conversación.'**
  String get chatSystemAutoPairingsPlayful020V1;

  /// No description provided for @chatSystemAutoPairingsChallenge001V1.
  ///
  /// In es, this message translates to:
  /// **'Reto del día: cada pareja debe explicar por qué merece ganar.'**
  String get chatSystemAutoPairingsChallenge001V1;

  /// No description provided for @chatSystemAutoPairingsChallenge002V1.
  ///
  /// In es, this message translates to:
  /// **'¿Quién se atreve a lanzar el primer desafío amistoso?'**
  String get chatSystemAutoPairingsChallenge002V1;

  /// No description provided for @chatSystemAutoPairingsChallenge003V1.
  ///
  /// In es, this message translates to:
  /// **'Pareja que no escriba hoy, empieza perdiendo en carisma.'**
  String get chatSystemAutoPairingsChallenge003V1;

  /// No description provided for @chatSystemAutoPairingsChallenge004V1.
  ///
  /// In es, this message translates to:
  /// **'Propongo una norma no oficial: quien más hable, luego tiene que responder.'**
  String get chatSystemAutoPairingsChallenge004V1;

  /// No description provided for @chatSystemAutoPairingsChallenge005V1.
  ///
  /// In es, this message translates to:
  /// **'¿Hay favorito o todavía fingimos humildad?'**
  String get chatSystemAutoPairingsChallenge005V1;

  /// No description provided for @chatSystemAutoPairingsChallenge006V1.
  ///
  /// In es, this message translates to:
  /// **'Dejad constancia aquí: ¿qué pareja se lleva la gloria?'**
  String get chatSystemAutoPairingsChallenge006V1;

  /// No description provided for @chatSystemAutoPairingsChallenge007V1.
  ///
  /// In es, this message translates to:
  /// **'Un reto suave: haced vuestra predicción antes del encuentro.'**
  String get chatSystemAutoPairingsChallenge007V1;

  /// No description provided for @chatSystemAutoPairingsChallenge008V1.
  ///
  /// In es, this message translates to:
  /// **'Si hay confianza, que haya apuestas simbólicas.'**
  String get chatSystemAutoPairingsChallenge008V1;

  /// No description provided for @chatSystemAutoPairingsChallenge009V1.
  ///
  /// In es, this message translates to:
  /// **'¿Qué pareja trae estrategia y cuál trae puro corazón?'**
  String get chatSystemAutoPairingsChallenge009V1;

  /// No description provided for @chatSystemAutoPairingsChallenge010V1.
  ///
  /// In es, this message translates to:
  /// **'Momento de declarar intenciones. El silencio no puntúa.'**
  String get chatSystemAutoPairingsChallenge010V1;

  /// No description provided for @chatSystemAutoPairingsChallenge011V1.
  ///
  /// In es, this message translates to:
  /// **'Que cada pareja nombre a su portavoz espontáneo. Luego negáis haberlo elegido.'**
  String get chatSystemAutoPairingsChallenge011V1;

  /// No description provided for @chatSystemAutoPairingsChallenge012V1.
  ///
  /// In es, this message translates to:
  /// **'¿Quién rompe el hielo con la primera provocación elegante?'**
  String get chatSystemAutoPairingsChallenge012V1;

  /// No description provided for @chatSystemAutoPairingsQuiet001V1.
  ///
  /// In es, this message translates to:
  /// **'Mucho silencio para unos parejas tan prometedores.'**
  String get chatSystemAutoPairingsQuiet001V1;

  /// No description provided for @chatSystemAutoPairingsQuiet002V1.
  ///
  /// In es, this message translates to:
  /// **'Este chat está más tranquilo que un banquillo antes del pitido inicial.'**
  String get chatSystemAutoPairingsQuiet002V1;

  /// No description provided for @chatSystemAutoPairingsQuiet003V1.
  ///
  /// In es, this message translates to:
  /// **'¿Nadie va a comentar el emparejamiento? Sospechoso.'**
  String get chatSystemAutoPairingsQuiet003V1;

  /// No description provided for @chatSystemAutoPairingsQuiet004V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci detecta calma. A veces eso significa estrategia.'**
  String get chatSystemAutoPairingsQuiet004V1;

  /// No description provided for @chatSystemAutoPairingsQuiet005V1.
  ///
  /// In es, this message translates to:
  /// **'Los parejas están hechos. El chat aún espera su primer buen conversación.'**
  String get chatSystemAutoPairingsQuiet005V1;

  /// No description provided for @chatSystemAutoPairingsQuiet006V1.
  ///
  /// In es, this message translates to:
  /// **'Un grupo en silencio no es paz: es tensión dramática.'**
  String get chatSystemAutoPairingsQuiet006V1;

  /// No description provided for @chatSystemAutoPairingsQuiet007V1.
  ///
  /// In es, this message translates to:
  /// **'¿Todo el mundo conforme? Esa unanimidad merece revisión.'**
  String get chatSystemAutoPairingsQuiet007V1;

  /// No description provided for @chatSystemAutoPairingsQuiet008V1.
  ///
  /// In es, this message translates to:
  /// **'Silencio táctico activado. Continuad, que queda elegante.'**
  String get chatSystemAutoPairingsQuiet008V1;

  /// No description provided for @chatSystemAutoPairingsCountdown014V1.
  ///
  /// In es, this message translates to:
  /// **'Faltan 14 días. Tiempo de organizarse… o de improvisar con confianza.'**
  String get chatSystemAutoPairingsCountdown014V1;

  /// No description provided for @chatSystemAutoPairingsCountdown007V1.
  ///
  /// In es, this message translates to:
  /// **'Falta una semana. Las estrategias absurdas ya pueden presentarse oficialmente.'**
  String get chatSystemAutoPairingsCountdown007V1;

  /// No description provided for @chatSystemAutoPairingsCountdown003V1.
  ///
  /// In es, this message translates to:
  /// **'Quedan 3 días. A estas alturas la épica está permitida.'**
  String get chatSystemAutoPairingsCountdown003V1;

  /// No description provided for @chatSystemAutoPairingsCountdown001V1.
  ///
  /// In es, this message translates to:
  /// **'Mañana es el día. Última oportunidad para presumir sin consecuencias.'**
  String get chatSystemAutoPairingsCountdown001V1;

  /// No description provided for @chatSystemAutoPairingsCountdown000V1.
  ///
  /// In es, this message translates to:
  /// **'Hoy toca. Parejas listos, nervios opcionales.'**
  String get chatSystemAutoPairingsCountdown000V1;

  /// No description provided for @chatSystemAutoPairingsCountdownExtra001V1.
  ///
  /// In es, this message translates to:
  /// **'Dos semanas parecen mucho hasta que alguien recuerda que no ha preparado nada.'**
  String get chatSystemAutoPairingsCountdownExtra001V1;

  /// No description provided for @chatSystemAutoPairingsCountdownExtra002V1.
  ///
  /// In es, this message translates to:
  /// **'Siete días. Lo suficiente para entrenar o para perfeccionar una buena excusa.'**
  String get chatSystemAutoPairingsCountdownExtra002V1;

  /// No description provided for @chatSystemAutoPairingsCountdownExtra003V1.
  ///
  /// In es, this message translates to:
  /// **'Tres días. El chat puede pasar de bromas a declaraciones oficiales.'**
  String get chatSystemAutoPairingsCountdownExtra003V1;

  /// No description provided for @chatSystemAutoPairingsCountdownExtra004V1.
  ///
  /// In es, this message translates to:
  /// **'Queda un día. Si había un plan secreto, es buen momento para fingir que existe.'**
  String get chatSystemAutoPairingsCountdownExtra004V1;

  /// No description provided for @chatSystemAutoPairingsCountdownExtra005V1.
  ///
  /// In es, this message translates to:
  /// **'Llegó el momento. Que gane el mejor… o el que mejor lo disimule.'**
  String get chatSystemAutoPairingsCountdownExtra005V1;

  /// No description provided for @chatSystemAutoDuelsPlayful001V1.
  ///
  /// In es, this message translates to:
  /// **'Duelos listos. Ya podéis empezar a culpar al algoritmo.'**
  String get chatSystemAutoDuelsPlayful001V1;

  /// No description provided for @chatSystemAutoDuelsPlayful002V1.
  ///
  /// In es, this message translates to:
  /// **'¿Qué duelo viene a ganar y cuál viene por la merienda?'**
  String get chatSystemAutoDuelsPlayful002V1;

  /// No description provided for @chatSystemAutoDuelsPlayful003V1.
  ///
  /// In es, this message translates to:
  /// **'Aquí hay talento… y también mucha confianza. Veremos cuál pesa más.'**
  String get chatSystemAutoDuelsPlayful003V1;

  /// No description provided for @chatSystemAutoDuelsPlayful004V1.
  ///
  /// In es, this message translates to:
  /// **'Se aceptan pronósticos, excusas y teorías conspirativas.'**
  String get chatSystemAutoDuelsPlayful004V1;

  /// No description provided for @chatSystemAutoDuelsPlayful005V1.
  ///
  /// In es, this message translates to:
  /// **'Un enfrentamiento justo. Las quejas creativas también cuentan como participación.'**
  String get chatSystemAutoDuelsPlayful005V1;

  /// No description provided for @chatSystemAutoDuelsPlayful006V1.
  ///
  /// In es, this message translates to:
  /// **'No importa contra quién te toque. Importa quién pide la revancha.'**
  String get chatSystemAutoDuelsPlayful006V1;

  /// No description provided for @chatSystemAutoDuelsPlayful007V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci repartió. Ahora os toca demostrar que no era suerte.'**
  String get chatSystemAutoDuelsPlayful007V1;

  /// No description provided for @chatSystemAutoDuelsPlayful008V1.
  ///
  /// In es, this message translates to:
  /// **'Hay duelos que inspiran respeto y otros que inspiran memes.'**
  String get chatSystemAutoDuelsPlayful008V1;

  /// No description provided for @chatSystemAutoDuelsPlayful009V1.
  ///
  /// In es, this message translates to:
  /// **'El azar habló. La dignidad se resuelve el día del encuentro.'**
  String get chatSystemAutoDuelsPlayful009V1;

  /// No description provided for @chatSystemAutoDuelsPlayful010V1.
  ///
  /// In es, this message translates to:
  /// **'Que nadie subestime a un duelo silencioso.'**
  String get chatSystemAutoDuelsPlayful010V1;

  /// No description provided for @chatSystemAutoDuelsPlayful011V1.
  ///
  /// In es, this message translates to:
  /// **'Algunos ya celebran. Otros calculan cómo cambiar de rival sin que se note.'**
  String get chatSystemAutoDuelsPlayful011V1;

  /// No description provided for @chatSystemAutoDuelsPlayful012V1.
  ///
  /// In es, this message translates to:
  /// **'Resultado publicado. Empieza oficialmente el salseo.'**
  String get chatSystemAutoDuelsPlayful012V1;

  /// No description provided for @chatSystemAutoDuelsPlayful013V1.
  ///
  /// In es, this message translates to:
  /// **'Hay química de duelo… o al menos eso dice la estadística emocional.'**
  String get chatSystemAutoDuelsPlayful013V1;

  /// No description provided for @chatSystemAutoDuelsPlayful014V1.
  ///
  /// In es, this message translates to:
  /// **'Un buen duelo se construye. Uno legendario se presume antes de jugar.'**
  String get chatSystemAutoDuelsPlayful014V1;

  /// No description provided for @chatSystemAutoDuelsPlayful015V1.
  ///
  /// In es, this message translates to:
  /// **'El grupo ya tiene enfrentamiento. Ahora falta la épica.'**
  String get chatSystemAutoDuelsPlayful015V1;

  /// No description provided for @chatSystemAutoDuelsPlayful016V1.
  ///
  /// In es, this message translates to:
  /// **'A partir de aquí, cada mensaje puede convertirse en motivación para el rival.'**
  String get chatSystemAutoDuelsPlayful016V1;

  /// No description provided for @chatSystemAutoDuelsPlayful017V1.
  ///
  /// In es, this message translates to:
  /// **'Duelos formados. El orgullo grupal queda activado.'**
  String get chatSystemAutoDuelsPlayful017V1;

  /// No description provided for @chatSystemAutoDuelsPlayful018V1.
  ///
  /// In es, this message translates to:
  /// **'Ya podéis inventar nombre de guerra, aunque Tarci aún no lo guarde.'**
  String get chatSystemAutoDuelsPlayful018V1;

  /// No description provided for @chatSystemAutoDuelsPlayful019V1.
  ///
  /// In es, this message translates to:
  /// **'Que empiece la parte favorita: opinar sobre si el enfrentamiento fue justo.'**
  String get chatSystemAutoDuelsPlayful019V1;

  /// No description provided for @chatSystemAutoDuelsPlayful020V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci no toma partido. Pero sí guarda capturas mentales del pique.'**
  String get chatSystemAutoDuelsPlayful020V1;

  /// No description provided for @chatSystemAutoDuelsChallenge001V1.
  ///
  /// In es, this message translates to:
  /// **'Reto del día: cada duelo debe explicar por qué merece ganar.'**
  String get chatSystemAutoDuelsChallenge001V1;

  /// No description provided for @chatSystemAutoDuelsChallenge002V1.
  ///
  /// In es, this message translates to:
  /// **'¿Quién se atreve a lanzar el primer desafío amistoso?'**
  String get chatSystemAutoDuelsChallenge002V1;

  /// No description provided for @chatSystemAutoDuelsChallenge003V1.
  ///
  /// In es, this message translates to:
  /// **'Duelo que no escriba hoy, empieza perdiendo en carisma.'**
  String get chatSystemAutoDuelsChallenge003V1;

  /// No description provided for @chatSystemAutoDuelsChallenge004V1.
  ///
  /// In es, this message translates to:
  /// **'Propongo una norma no oficial: quien más hable, luego tiene que responder.'**
  String get chatSystemAutoDuelsChallenge004V1;

  /// No description provided for @chatSystemAutoDuelsChallenge005V1.
  ///
  /// In es, this message translates to:
  /// **'¿Hay favorito o todavía fingimos humildad?'**
  String get chatSystemAutoDuelsChallenge005V1;

  /// No description provided for @chatSystemAutoDuelsChallenge006V1.
  ///
  /// In es, this message translates to:
  /// **'Dejad constancia aquí: ¿qué duelo se lleva la gloria?'**
  String get chatSystemAutoDuelsChallenge006V1;

  /// No description provided for @chatSystemAutoDuelsChallenge007V1.
  ///
  /// In es, this message translates to:
  /// **'Un reto suave: haced vuestra predicción antes del encuentro.'**
  String get chatSystemAutoDuelsChallenge007V1;

  /// No description provided for @chatSystemAutoDuelsChallenge008V1.
  ///
  /// In es, this message translates to:
  /// **'Si hay confianza, que haya apuestas simbólicas.'**
  String get chatSystemAutoDuelsChallenge008V1;

  /// No description provided for @chatSystemAutoDuelsChallenge009V1.
  ///
  /// In es, this message translates to:
  /// **'¿Qué duelo trae estrategia y cuál trae puro corazón?'**
  String get chatSystemAutoDuelsChallenge009V1;

  /// No description provided for @chatSystemAutoDuelsChallenge010V1.
  ///
  /// In es, this message translates to:
  /// **'Momento de declarar intenciones. El silencio no puntúa.'**
  String get chatSystemAutoDuelsChallenge010V1;

  /// No description provided for @chatSystemAutoDuelsChallenge011V1.
  ///
  /// In es, this message translates to:
  /// **'Que cada duelo nombre a su portavoz espontáneo. Luego negáis haberlo elegido.'**
  String get chatSystemAutoDuelsChallenge011V1;

  /// No description provided for @chatSystemAutoDuelsChallenge012V1.
  ///
  /// In es, this message translates to:
  /// **'¿Quién rompe el hielo con la primera provocación elegante?'**
  String get chatSystemAutoDuelsChallenge012V1;

  /// No description provided for @chatSystemAutoDuelsQuiet001V1.
  ///
  /// In es, this message translates to:
  /// **'Mucho silencio para unos duelos tan prometedores.'**
  String get chatSystemAutoDuelsQuiet001V1;

  /// No description provided for @chatSystemAutoDuelsQuiet002V1.
  ///
  /// In es, this message translates to:
  /// **'Este chat está más tranquilo que un banquillo antes del pitido inicial.'**
  String get chatSystemAutoDuelsQuiet002V1;

  /// No description provided for @chatSystemAutoDuelsQuiet003V1.
  ///
  /// In es, this message translates to:
  /// **'¿Nadie va a comentar el enfrentamiento? Sospechoso.'**
  String get chatSystemAutoDuelsQuiet003V1;

  /// No description provided for @chatSystemAutoDuelsQuiet004V1.
  ///
  /// In es, this message translates to:
  /// **'Tarci detecta calma. A veces eso significa estrategia.'**
  String get chatSystemAutoDuelsQuiet004V1;

  /// No description provided for @chatSystemAutoDuelsQuiet005V1.
  ///
  /// In es, this message translates to:
  /// **'Los duelos están hechos. El chat aún espera su primer buen pique.'**
  String get chatSystemAutoDuelsQuiet005V1;

  /// No description provided for @chatSystemAutoDuelsQuiet006V1.
  ///
  /// In es, this message translates to:
  /// **'Un grupo en silencio no es paz: es tensión dramática.'**
  String get chatSystemAutoDuelsQuiet006V1;

  /// No description provided for @chatSystemAutoDuelsQuiet007V1.
  ///
  /// In es, this message translates to:
  /// **'¿Todo el mundo conforme? Esa unanimidad merece revisión.'**
  String get chatSystemAutoDuelsQuiet007V1;

  /// No description provided for @chatSystemAutoDuelsQuiet008V1.
  ///
  /// In es, this message translates to:
  /// **'Silencio táctico activado. Continuad, que queda elegante.'**
  String get chatSystemAutoDuelsQuiet008V1;

  /// No description provided for @chatSystemAutoDuelsCountdown014V1.
  ///
  /// In es, this message translates to:
  /// **'Faltan 14 días. Tiempo de organizarse… o de improvisar con confianza.'**
  String get chatSystemAutoDuelsCountdown014V1;

  /// No description provided for @chatSystemAutoDuelsCountdown007V1.
  ///
  /// In es, this message translates to:
  /// **'Falta una semana. Las estrategias absurdas ya pueden presentarse oficialmente.'**
  String get chatSystemAutoDuelsCountdown007V1;

  /// No description provided for @chatSystemAutoDuelsCountdown003V1.
  ///
  /// In es, this message translates to:
  /// **'Quedan 3 días. A estas alturas la épica está permitida.'**
  String get chatSystemAutoDuelsCountdown003V1;

  /// No description provided for @chatSystemAutoDuelsCountdown001V1.
  ///
  /// In es, this message translates to:
  /// **'Mañana es el día. Última oportunidad para presumir sin consecuencias.'**
  String get chatSystemAutoDuelsCountdown001V1;

  /// No description provided for @chatSystemAutoDuelsCountdown000V1.
  ///
  /// In es, this message translates to:
  /// **'Hoy toca. Duelos listos, nervios opcionales.'**
  String get chatSystemAutoDuelsCountdown000V1;

  /// No description provided for @chatSystemAutoDuelsCountdownExtra001V1.
  ///
  /// In es, this message translates to:
  /// **'Dos semanas parecen mucho hasta que alguien recuerda que no ha preparado nada.'**
  String get chatSystemAutoDuelsCountdownExtra001V1;

  /// No description provided for @chatSystemAutoDuelsCountdownExtra002V1.
  ///
  /// In es, this message translates to:
  /// **'Siete días. Lo suficiente para entrenar o para perfeccionar una buena excusa.'**
  String get chatSystemAutoDuelsCountdownExtra002V1;

  /// No description provided for @chatSystemAutoDuelsCountdownExtra003V1.
  ///
  /// In es, this message translates to:
  /// **'Tres días. El chat puede pasar de bromas a declaraciones oficiales.'**
  String get chatSystemAutoDuelsCountdownExtra003V1;

  /// No description provided for @chatSystemAutoDuelsCountdownExtra004V1.
  ///
  /// In es, this message translates to:
  /// **'Queda un día. Si había un plan secreto, es buen momento para fingir que existe.'**
  String get chatSystemAutoDuelsCountdownExtra004V1;

  /// No description provided for @chatSystemAutoDuelsCountdownExtra005V1.
  ///
  /// In es, this message translates to:
  /// **'Llegó el momento. Que gane el mejor… o el que mejor lo disimule.'**
  String get chatSystemAutoDuelsCountdownExtra005V1;

  /// No description provided for @dynamicsCardDuelsBody.
  ///
  /// In es, this message translates to:
  /// **'Crea enfrentamientos uno contra uno para retos, juegos y dinámicas con más pique.'**
  String get dynamicsCardDuelsBody;

  /// No description provided for @homeDynamicTypeDuels.
  ///
  /// In es, this message translates to:
  /// **'Duelos'**
  String get homeDynamicTypeDuels;

  /// No description provided for @homeDuelsStateCompleted.
  ///
  /// In es, this message translates to:
  /// **'Duelos listos'**
  String get homeDuelsStateCompleted;

  /// No description provided for @homeDuelsStatePreparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando duelos'**
  String get homeDuelsStatePreparing;

  /// No description provided for @duelsWizardTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear duelos'**
  String get duelsWizardTitle;

  /// No description provided for @duelsWizardCreateCta.
  ///
  /// In es, this message translates to:
  /// **'Crear duelos'**
  String get duelsWizardCreateCta;

  /// No description provided for @duelsWizardNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la dinámica'**
  String get duelsWizardNameLabel;

  /// No description provided for @duelsWizardOwnerNicknameLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu nombre en los duelos'**
  String get duelsWizardOwnerNicknameLabel;

  /// No description provided for @duelsWizardOwnerNicknameHelper.
  ///
  /// In es, this message translates to:
  /// **'Así te verán los demás en los enfrentamientos.'**
  String get duelsWizardOwnerNicknameHelper;

  /// No description provided for @duelsWizardEventOptional.
  ///
  /// In es, this message translates to:
  /// **'Fecha del evento (opcional)'**
  String get duelsWizardEventOptional;

  /// No description provided for @duelsWizardPickEventDate.
  ///
  /// In es, this message translates to:
  /// **'Elegir fecha'**
  String get duelsWizardPickEventDate;

  /// No description provided for @duelsWizardOwnerParticipatesTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Participas tú?'**
  String get duelsWizardOwnerParticipatesTitle;

  /// No description provided for @duelsWizardOwnerParticipatesYes.
  ///
  /// In es, this message translates to:
  /// **'Sí, quiero estar en un duelo'**
  String get duelsWizardOwnerParticipatesYes;

  /// No description provided for @duelsWizardOwnerParticipatesNo.
  ///
  /// In es, this message translates to:
  /// **'No, solo organizo'**
  String get duelsWizardOwnerParticipatesNo;

  /// No description provided for @duelsWizardReviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Revisión'**
  String get duelsWizardReviewTitle;

  /// No description provided for @duelsWizardReviewSummary.
  ///
  /// In es, this message translates to:
  /// **'Enfrentamientos 1 vs 1 · número par necesario'**
  String get duelsWizardReviewSummary;

  /// No description provided for @duelsUnitLabel.
  ///
  /// In es, this message translates to:
  /// **'Duelo {index}'**
  String duelsUnitLabel(Object index);

  /// No description provided for @duelsVsLabel.
  ///
  /// In es, this message translates to:
  /// **'vs'**
  String get duelsVsLabel;

  /// No description provided for @duelsResultHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Duelos listos!'**
  String get duelsResultHeroTitle;

  /// No description provided for @duelsResultHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ya sabéis quién se enfrenta a quién.'**
  String get duelsResultHeroSubtitle;

  /// No description provided for @duelsResultSummary.
  ///
  /// In es, this message translates to:
  /// **'{count} duelos · {eligible} participantes'**
  String duelsResultSummary(Object count, Object eligible);

  /// No description provided for @duelsDetailListTitle.
  ///
  /// In es, this message translates to:
  /// **'Duelos'**
  String get duelsDetailListTitle;

  /// No description provided for @duelsDetailFormCta.
  ///
  /// In es, this message translates to:
  /// **'Generar duelos'**
  String get duelsDetailFormCta;

  /// No description provided for @duelsDetailConfigTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get duelsDetailConfigTitle;

  /// No description provided for @duelsDetailConfigSummary.
  ///
  /// In es, this message translates to:
  /// **'Aproximadamente {count} duelos'**
  String duelsDetailConfigSummary(Object count);

  /// No description provided for @duelsRenameDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Renombrar duelo'**
  String get duelsRenameDialogTitle;

  /// No description provided for @duelsRenameDialogFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del duelo'**
  String get duelsRenameDialogFieldLabel;

  /// No description provided for @duelsRenameSuccess.
  ///
  /// In es, this message translates to:
  /// **'Nombre del duelo actualizado'**
  String get duelsRenameSuccess;

  /// No description provided for @duelsShareBody.
  ///
  /// In es, this message translates to:
  /// **'⚔️ Duelos generados en «{groupName}»:\n\n{blocks}\n\nHecho con Tarci Secret.'**
  String duelsShareBody(Object blocks, Object groupName);

  /// No description provided for @duelsEmailSubject.
  ///
  /// In es, this message translates to:
  /// **'Duelos generados — {groupName}'**
  String duelsEmailSubject(Object groupName);

  /// No description provided for @duelsEmailBody.
  ///
  /// In es, this message translates to:
  /// **'Hola,\n\nYa están listos los duelos de «{groupName}»:\n\n{blocks}\n\nGenerado con Tarci Secret.'**
  String duelsEmailBody(Object blocks, Object groupName);

  /// No description provided for @duelsPdfHeadline.
  ///
  /// In es, this message translates to:
  /// **'Duelos generados'**
  String get duelsPdfHeadline;

  /// No description provided for @duelsChatSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Conversación del grupo'**
  String get duelsChatSectionTitle;

  /// No description provided for @duelsChatSectionSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Lanza retos, bromea y calienta el ambiente antes de los duelos.'**
  String get duelsChatSectionSubtitle;

  /// No description provided for @duelsChatEnterCta.
  ///
  /// In es, this message translates to:
  /// **'Abrir chat'**
  String get duelsChatEnterCta;

  /// No description provided for @chatDuelsCompletedChip.
  ///
  /// In es, this message translates to:
  /// **'Duelos listos'**
  String get chatDuelsCompletedChip;

  /// No description provided for @chatSystemDuelsCompletedV1.
  ///
  /// In es, this message translates to:
  /// **'Los duelos ya están listos. Ahora sí: que empiece el pique.'**
  String get chatSystemDuelsCompletedV1;

  /// No description provided for @duelsMemberWaitingTitle.
  ///
  /// In es, this message translates to:
  /// **'Duelos en preparación'**
  String get duelsMemberWaitingTitle;

  /// No description provided for @duelsMemberWaitingBody.
  ///
  /// In es, this message translates to:
  /// **'Cuando el organizador genere los duelos, podrás ver quién se enfrenta a quién.'**
  String get duelsMemberWaitingBody;

  /// No description provided for @joinSuccessDuelsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Te uniste a «{groupName}».'**
  String joinSuccessDuelsSubtitle(Object groupName);

  /// No description provided for @joinSuccessDuelsBody.
  ///
  /// In es, this message translates to:
  /// **'Cuando el organizador genere los duelos, podrás ver quién se enfrenta a quién.'**
  String get joinSuccessDuelsBody;

  /// No description provided for @joinSuccessDuelsPrimaryCta.
  ///
  /// In es, this message translates to:
  /// **'Ir a duelos'**
  String get joinSuccessDuelsPrimaryCta;

  /// No description provided for @duelsDetailMinPoolHint.
  ///
  /// In es, this message translates to:
  /// **'Necesitas al menos 2 participantes para generar duelos.'**
  String get duelsDetailMinPoolHint;

  /// No description provided for @duelsDetailEvenHint.
  ///
  /// In es, this message translates to:
  /// **'Necesitas un número par de participantes para generar duelos.'**
  String get duelsDetailEvenHint;
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
      <String>['en', 'es', 'fr', 'it', 'pt'].contains(locale.languageCode);

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
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
