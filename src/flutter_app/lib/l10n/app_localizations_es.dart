// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Tarci Secret';

  @override
  String get retry => 'Reintentar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get create => 'Crear';

  @override
  String get close => 'Cerrar';

  @override
  String get save => 'Guardar';

  @override
  String get goToGroup => 'Ir al grupo';

  @override
  String get copyCode => 'Copiar código';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get joinWithCode => 'Unirme con código';

  @override
  String get joinScreenTitle => 'Unirme con código';

  @override
  String get joinScreenHeroTitle => 'Pega tu código de invitación';

  @override
  String get joinScreenHeroSubtitle =>
      'Tu organizador te lo compartió por mensaje. Cuando lo introduzcas, te uniremos a su grupo.';

  @override
  String get joinScreenCodeLabel => 'Código de invitación';

  @override
  String get joinScreenCodeHint => 'Por ejemplo, AB12CD';

  @override
  String get joinScreenCodeHelper =>
      'Las mayúsculas no importan, lo arreglamos por ti.';

  @override
  String get joinScreenCodeRequired =>
      'Pega o escribe el código que recibiste.';

  @override
  String get joinScreenCodeTooShort =>
      'Ese código parece incompleto. Revísalo y vuelve a intentar.';

  @override
  String get joinScreenNicknameLabel => 'Tu nombre';

  @override
  String get joinScreenNicknameHelper => 'Así te verá el grupo.';

  @override
  String get joinScreenNicknameRequired =>
      'Cuéntanos cómo te llamas para presentarte al grupo.';

  @override
  String get joinScreenNicknameTooShort =>
      'Pon al menos 3 letras para que el grupo te reconozca.';

  @override
  String get joinScreenCta => 'Unirme al grupo';

  @override
  String get joinScreenCtaLoading => 'Uniéndote…';

  @override
  String get joinScreenSuccessSnackbar => '¡Estás dentro!';

  @override
  String get joinSuccessTitle => '¡Ya estás dentro!';

  @override
  String joinSuccessSubtitle(String groupName) {
    return 'Te uniste a $groupName. En un momento podrás ver al resto del grupo.';
  }

  @override
  String get joinSuccessChooseSubgroupTitle => 'Elige tu casa o equipo';

  @override
  String get joinSuccessChooseSubgroupHelp =>
      'El organizador creó casas o equipos. Elige el tuyo para que el sorteo te coloque bien.';

  @override
  String get joinSuccessSubgroupLabel => 'Tu casa o equipo';

  @override
  String get joinSuccessNoSubgroupsTitle => 'Aún no hay casas o equipos';

  @override
  String get joinSuccessNoSubgroupsHelp =>
      'El organizador todavía no las creó. Puedes continuar y esperar; no necesitas hacer nada más por ahora.';

  @override
  String get joinSuccessChooseRequired => 'Elige una opción para continuar.';

  @override
  String get joinSuccessPrimaryCta => 'Ir al grupo';

  @override
  String get joinSuccessSecondaryCta => 'Quedarme aquí';

  @override
  String joinSuccessRaffleSubtitle(String groupName) {
    return 'Te uniste a $groupName. Cuando el organizador realice el sorteo, podrás ver el resultado aquí.';
  }

  @override
  String get joinSuccessRaffleBody =>
      'Mientras tanto puedes revisar quién participa y esperar el momento del sorteo.';

  @override
  String get joinSuccessRafflePrimaryCta => 'Ir al sorteo';

  @override
  String get createSecretFriend => 'Crear amigo secreto';

  @override
  String get mySecretFriend => 'Mi amigo secreto';

  @override
  String get yourSecretFriendIs => 'Tu amigo secreto es…';

  @override
  String get onlyYouCanSeeAssignment => 'Solo tú puedes ver esta asignación.';

  @override
  String get keepSecretUntilExchangeDay =>
      'Guarda el secreto hasta el día del intercambio.';

  @override
  String get managedSecrets => 'Secretos que gestionas';

  @override
  String get guardianOfSecret => 'Guardián del secreto';

  @override
  String get privateResult => 'Resultado privado';

  @override
  String get splashTagline =>
      'Tarci Secret organiza dinámicas privadas de grupo con personas reales.';

  @override
  String get splashLoadingHint => 'Preparando todo para ti…';

  @override
  String get splashBootBrandedHint => 'Preparando tu espacio…';

  @override
  String get productAuthorshipLine => 'Tarci Secret · © 2026 Stalin Yamarte';

  @override
  String get aboutScreenTitle => 'Acerca de Tarci Secret';

  @override
  String get aboutTooltip => 'Acerca de Tarci Secret';

  @override
  String get aboutTagline =>
      'Dinámicas de grupo, sorteos y experiencias sociales con privacidad, emoción y personas reales.';

  @override
  String get aboutCapabilitiesTitle => 'Una app, cinco dinámicas activas';

  @override
  String get aboutSectionPrivacyLead =>
      'Control y transparencia en cada resultado.';

  @override
  String get aboutRetentionLead => 'Los datos no se almacenan indefinidamente.';

  @override
  String get requiredSubgroupsSetupSheetTitle => 'Configura tus subgrupos';

  @override
  String get requiredSubgroupsSetupSheetBody =>
      'La regla elegida necesita subgrupos para funcionar. Crea casas, equipos, clases o categorías y después asigna a cada participante.';

  @override
  String requiredSubgroupsSetupSubgroupFieldLabel(int index) {
    return 'Subgrupo $index';
  }

  @override
  String get requiredSubgroupsSetupAddAnother => 'Añadir otro subgrupo';

  @override
  String get requiredSubgroupsSetupContinue => 'Crear subgrupos y continuar';

  @override
  String get requiredSubgroupsSetupAssignTitle => 'Ubícate en un subgrupo';

  @override
  String get requiredSubgroupsSetupAssignBody =>
      'Para que la regla funcione bien, indica a qué subgrupo perteneces.';

  @override
  String get requiredSubgroupsSetupSaveContinue => 'Guardar y continuar';

  @override
  String get requiredSubgroupsSetupDoLater => 'Lo haré después';

  @override
  String get requiredSubgroupsSetupErrorMinTwo =>
      'Añade al menos dos subgrupos con nombre.';

  @override
  String get requiredSubgroupsSetupErrorDuplicateName =>
      'Hay nombres duplicados. Usa nombres distintos.';

  @override
  String get requiredSubgroupsSetupAssignErrorSelect =>
      'Selecciona un subgrupo para continuar.';

  @override
  String get aboutSectionWhatTitle => 'Qué es Tarci Secret';

  @override
  String get aboutSectionWhatBody =>
      'Tarci Secret es una app social para organizar dinámicas de grupo de forma sencilla, privada y divertida. Permite crear amigos secretos, realizar sorteos, formar equipos, generar parejas y preparar duelos, incluyendo personas con app, sin app o gestionadas por otro participante.\n\nNace alrededor del amigo secreto como experiencia fundacional, pero evoluciona como un espacio para crear encuentros, retos y dinámicas sociales con emoción, claridad y personas reales.';

  @override
  String get aboutSectionHowTitle => 'Cómo funciona';

  @override
  String get aboutStep1Title => 'Crea o únete a un grupo';

  @override
  String get aboutStep1Body =>
      'Empieza una dinámica o entra con un código de invitación.';

  @override
  String get aboutStep2Title => 'Organiza participantes y reglas';

  @override
  String get aboutStep2Body =>
      'Añade personas con app o gestionadas y ajusta el flujo necesario.';

  @override
  String get aboutStep3Title => 'Lanza la dinámica';

  @override
  String get aboutStep3Body =>
      'Ejecuta el sorteo, forma los equipos o completa la experiencia cuando todo esté listo.';

  @override
  String get aboutStep4Title => 'Descubre, conversa y disfruta';

  @override
  String get aboutStep4Body =>
      'Cada dinámica muestra el resultado de forma clara y permite vivir mejor la experiencia del grupo.';

  @override
  String get aboutSectionPrivacyTitle => 'Privacidad por diseño';

  @override
  String get aboutSectionPrivacyBody =>
      'Cada dinámica muestra solo lo que corresponde. Las asignaciones privadas se protegen, los resultados públicos se comparten únicamente con el grupo y Tarci evita exponer información innecesaria.\n\nTarci Secret no necesita pedir correo electrónico ni teléfono para usar el modo rápido. Solo conserva los datos necesarios para que cada dinámica funcione y elimina automáticamente las dinámicas completadas tras un periodo limitado.';

  @override
  String get aboutSectionPrivacyTrust =>
      'La privacidad no es un añadido: es parte del diseño de la experiencia.';

  @override
  String get aboutRetentionTitle => 'Retención limitada';

  @override
  String get aboutRetentionBody =>
      'Las dinámicas completadas se conservan durante 90 días desde su fecha de cierre o evento, para que puedas consultar resultados y compartirlos. Después se eliminan automáticamente del sistema.';

  @override
  String retentionAutoDeleteNotice(String date) {
    return 'Esta dinámica se eliminará automáticamente el $date.';
  }

  @override
  String get retentionAutoDeleteBody =>
      'Conservamos los resultados durante un tiempo limitado para proteger tu privacidad y evitar guardar datos innecesarios.';

  @override
  String get aboutSectionCreatorTitle => 'Creado por Stalin Yamarte';

  @override
  String get aboutSectionCreatorSubtitle =>
      'Especialista en Sistemas y desarrollador de aplicaciones.';

  @override
  String get aboutLinkedInCta => 'Ver perfil en LinkedIn';

  @override
  String get aboutLinkedInError =>
      'No pudimos abrir LinkedIn. Inténtalo desde el navegador.';

  @override
  String get aboutAppInfoTitle => 'Información de la app';

  @override
  String get aboutCopyrightLine => '© 2026 Stalin Yamarte';

  @override
  String get aboutPackageInfoError => 'No pudimos leer la versión de la app.';

  @override
  String aboutBuildLine(String buildNumber) {
    return 'Compilación interna $buildNumber';
  }

  @override
  String get quickModeTitle => 'Modo rápido';

  @override
  String get quickModeDescription =>
      'Puedes empezar sin registrarte. Para conservar tus grupos en varios dispositivos, más adelante podrás crear una cuenta.';

  @override
  String get homeHeaderSubtitle =>
      'Organiza amigos secretos, sorteos, equipos, parejas y duelos con privacidad, emoción y facilidad.';

  @override
  String get homeHeroHeadline => 'Dinámicas sociales para grupos reales';

  @override
  String get homeGroupDrawStatePreparing => 'Preparando';

  @override
  String get homeGroupDrawStateReady => 'Listo para sortear';

  @override
  String get homeGroupDrawStateDrawing => 'Sorteo en curso';

  @override
  String get homeGroupDrawStateCompleted => 'Sorteado';

  @override
  String get homeGroupDrawStateFailed => 'Revisar sorteo';

  @override
  String get wizardCreateTitle => 'Crear amigo secreto';

  @override
  String wizardStepOf(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get wizardStepNameTitle => '¿Cómo se llama este amigo secreto?';

  @override
  String get wizardStepGroupTypeTitle => '¿Qué tipo de grupo es?';

  @override
  String get wizardStepModeTitle => '¿Cómo se organizará?';

  @override
  String get wizardStepRuleTitle => 'Elige la regla del sorteo';

  @override
  String get wizardStepSubgroupsTitle => 'Subgrupos';

  @override
  String get wizardStepParticipantsTitle => 'Participantes';

  @override
  String get wizardStepEventDateTitle => '¿Cuándo es el intercambio?';

  @override
  String get wizardStepEventDateHelp =>
      'Es opcional. Nos servirá para recordar la entrega y mover el grupo al historial cuando pase.';

  @override
  String get wizardSummaryEventDate => 'Fecha del evento';

  @override
  String get wizardEventDateNotSet => 'Sin definir';

  @override
  String get wizardEventDateClear => 'Quitar fecha';

  @override
  String get wizardStepReviewTitle => 'Revisión final';

  @override
  String get wizardGroupNameLabel => 'Nombre del grupo';

  @override
  String get wizardGroupNameHint => 'Navidad familia 2026';

  @override
  String get wizardNicknameLabel => '¿Cómo apareces tú?';

  @override
  String get wizardRuleIgnore => 'Ignorar subgrupos';

  @override
  String get wizardRulePrefer => 'Preferir subgrupo diferente';

  @override
  String get wizardRuleRequire => 'Exigir subgrupo diferente';

  @override
  String get wizardRuleIgnoreDesc => 'Sorteo normal.';

  @override
  String get wizardRulePreferDesc =>
      'Intentar cruzar casas, departamentos o grupos.';

  @override
  String get wizardRuleRequireDesc =>
      'Solo permitir personas de subgrupos distintos.';

  @override
  String get wizardReviewSaveNotice =>
      'Puedes ajustar participantes y subgrupos después.';

  @override
  String get wizardReviewSummaryHelp =>
      'Comprueba que todo esté bien antes de continuar.';

  @override
  String get wizardCreateButton => 'Crear amigo secreto';

  @override
  String get wizardCreatedTitle => 'Amigo secreto creado';

  @override
  String get wizardInviteCodeLabel => 'Código de invitación';

  @override
  String get wizardInviteCodeDescription =>
      'Comparte este código para que otras personas se unan.';

  @override
  String get managedSubtitle =>
      'Estos resultados son de personas que dependen de ti. Entrégaselos en privado.';

  @override
  String get managedEmptyTitle => 'No tienes secretos gestionados';

  @override
  String get managedEmptyMessage =>
      'Cuando gestiones a un niño o a una persona sin app, verás aquí su resultado.';

  @override
  String get managedLoadErrorTitle =>
      'No pudimos cargar tus secretos gestionados';

  @override
  String get managedLoadErrorMessage =>
      'Inténtalo de nuevo en unos minutos. Solo verás los resultados de las personas que gestionas.';

  @override
  String get managedAssignedTo => 'Le toca regalar a…';

  @override
  String get managedDeliverInPrivate => 'Entrega este resultado en privado';

  @override
  String get managedHeroTitle => 'Secretos a tu cargo';

  @override
  String get managedHeroSubtitle =>
      'Tú entregas estos resultados en privado, sin que nadie más se entere.';

  @override
  String get wishlistGroupMyCardTitle => 'Tu lista de deseos';

  @override
  String get wishlistGroupMyCardSubtitle =>
      'Complétala tú; solo la verá quien te toque regalar.';

  @override
  String get wishlistGroupMyCardCtaFill => 'Completar mi lista';

  @override
  String get wishlistGroupMyCardCtaEdit => 'Editar mi lista';

  @override
  String get wishlistGroupMyEmptyHint => 'Aún no has añadido ideas.';

  @override
  String get wishlistGroupMyReadyChip => 'Lista preparada';

  @override
  String get wishlistGroupManagedSectionTitle => 'Listas que gestionas';

  @override
  String get wishlistGroupManagedSectionSubtitle =>
      'Ayuda a rellenarlas; quien les regale las verá en su propia pantalla.';

  @override
  String get wishlistGroupManagedRowCta => 'Editar lista';

  @override
  String get wishlistGroupPostDrawIntro =>
      'Ahora que el sorteo está hecho, unas pistas claras ayudan a acertar con el regalo.';

  @override
  String get wishlistEditorTitle => 'Lista de deseos';

  @override
  String get wishlistViewTitle => 'Ideas para el regalo';

  @override
  String get wishlistEditorIntro =>
      'Escribe con cariño lo que te haría ilusión recibir. Solo lo verá quien te toque regalar (y tú).';

  @override
  String get wishlistViewIntro =>
      'Estas ideas son solo para ayudar con el regalo. Respeta el secreto del sorteo.';

  @override
  String get wishlistFieldWishTitle => 'Me haría ilusión…';

  @override
  String get wishlistFieldWishHint =>
      'Ideas concretas de regalo, tallas o detalles que te gustarían.';

  @override
  String get wishlistFieldLikesTitle => 'Me gusta…';

  @override
  String get wishlistFieldLikesHint =>
      'Hobbies, colores, estilos o cosas que te encantan.';

  @override
  String get wishlistFieldAvoidTitle => 'Mejor evita…';

  @override
  String get wishlistFieldAvoidHint =>
      'Cosas que prefieres no recibir o que ya tienes.';

  @override
  String get wishlistFieldLinksTitle => 'Enlaces de inspiración';

  @override
  String wishlistLinksHelp(int max) {
    return 'Hasta $max enlaces con http o https.';
  }

  @override
  String get wishlistAddLinkCta => 'Añadir enlace';

  @override
  String get wishlistLinkLabelOptional => 'Etiqueta (opcional)';

  @override
  String get wishlistLinkUrlLabel => 'URL';

  @override
  String get wishlistUrlHint => 'https://…';

  @override
  String wishlistLinkRowTitle(int index) {
    return 'Enlace $index';
  }

  @override
  String get wishlistSaveCta => 'Guardar';

  @override
  String get wishlistCancelCta => 'Volver';

  @override
  String get wishlistSaveSuccess => 'Lista guardada.';

  @override
  String get wishlistUrlInvalid =>
      'Revisa las URLs: deben empezar por http:// o https://';

  @override
  String wishlistLinksMax(int max) {
    return 'Como máximo $max enlaces.';
  }

  @override
  String wishlistMyAssignmentReceiverWishlistHeading(String receiverName) {
    return 'Qué le gustaría recibir a $receiverName';
  }

  @override
  String get wishlistMyAssignmentReceiverNameFallback => 'tu destinatario';

  @override
  String get wishlistMyAssignmentSectionSubtitle =>
      'Solo tú ves esto. Sirve para inspirarte al elegir un detalle con cariño.';

  @override
  String get wishlistMyAssignmentViewCta => 'Ver ideas de regalo';

  @override
  String get wishlistManagedViewReceiverCta => 'Ver lista de deseos';

  @override
  String get wishlistManagedViewReceiverHint =>
      'Solo ves las ideas de esta persona para este secreto.';

  @override
  String get wishlistEmptyReceiverTitle => 'Aún no ha dejado ideas de regalo';

  @override
  String get wishlistEmptyReceiverBody =>
      'Quizá las añada más adelante. ¡Un detalle hecho con cariño siempre cuenta!';

  @override
  String get wishlistLinkOpenError => 'No se pudo abrir el enlace.';

  @override
  String get wishlistReadonlySheetTitle => 'Ideas de regalo';

  @override
  String get managedRevealLabel => 'Su amigo secreto es';

  @override
  String get managedDeliveryChipLabel => 'Entrega';

  @override
  String get managedFooterPrivacyNote =>
      'Cada secreto es privado. Solo tú puedes verlo y solo tú lo entregas.';

  @override
  String get myAssignmentNotAvailableTitle =>
      'Aún no puedes ver tu amigo secreto';

  @override
  String get myAssignmentNotAvailableMessage =>
      'Tu asignación todavía no está disponible. Cuando el sorteo se complete, podrás verla aquí.';

  @override
  String get genericLoadErrorMessage =>
      'No pudimos cargar esta información en este momento.';

  @override
  String get backToGroup => 'Volver al grupo';

  @override
  String get groupDetailTitle => 'Detalle del grupo';

  @override
  String get groupRoleLabel => 'Rol';

  @override
  String get groupStatusLabel => 'Estado';

  @override
  String get groupLastExecution => 'Última';

  @override
  String get groupSectionStatus => 'Estado del grupo';

  @override
  String get groupSectionPrimaryAction => 'Acción principal';

  @override
  String get groupSectionDrawRule => 'Regla del sorteo';

  @override
  String get groupSectionSubgroups => 'Subgrupos';

  @override
  String get groupSectionParticipants => 'Participantes';

  @override
  String get groupSectionManagedParticipants => 'Participantes sin app';

  @override
  String get groupSectionInvitations => 'Invitaciones';

  @override
  String get groupSectionAdvanced => 'Configuración avanzada';

  @override
  String get groupStatusPreparing => 'Sigue la preparación';

  @override
  String get groupStatusReadyToDraw => 'Listo para sortear';

  @override
  String get groupStatusCompleted =>
      '¡Vuestros amigos secretos ya están elegidos!';

  @override
  String get groupStatusMissingSubgroups =>
      'Falta colocar a alguien en su grupo';

  @override
  String get groupActionRunDraw => 'Hacer el sorteo ahora';

  @override
  String get groupActionViewMySecretFriend => 'Ver mi amigo secreto';

  @override
  String get groupActionManagedSecrets => 'Secretos que gestionas';

  @override
  String get groupActionCreateSubgroup => 'Crear subgrupo';

  @override
  String get groupActionEmptySubgroup => 'Vaciar subgrupo';

  @override
  String get groupActionDeleteSubgroup => 'Eliminar subgrupo';

  @override
  String get groupActionGenerateNewCode => 'Generar nuevo código';

  @override
  String get groupActionCopyCode => 'Copiar código';

  @override
  String get groupActionRename => 'Renombrar';

  @override
  String get groupActionEdit => 'Editar';

  @override
  String get groupRoleOrganizer => 'Organizador';

  @override
  String get groupRoleParticipant => 'Participante';

  @override
  String get groupTypeAdultNoApp => 'Adulto sin app';

  @override
  String get groupTypeChildManaged => 'Niño gestionado';

  @override
  String get groupNoSubgroupAssigned => 'Sin subgrupo asignado';

  @override
  String get groupGuardianOfSecret => 'Guardián del secreto';

  @override
  String get groupPrivateResult => 'Resultado privado';

  @override
  String get groupWarningMissingSubgroupTitle =>
      'Faltan personas por asignar a un subgrupo.';

  @override
  String get groupWarningMissingSubgroupRule =>
      'Para exigir subgrupo diferente, todos deben tener uno.';

  @override
  String get groupWarningMissingSubgroupCombined =>
      'Faltan personas por asignar a un subgrupo. Para exigir subgrupo diferente, todos deben tener uno.';

  @override
  String get groupDialogDeleteSubgroupTitle => 'Eliminar subgrupo';

  @override
  String groupDialogDeleteSubgroupBody(String name) {
    return '¿Seguro que quieres eliminar \"$name\"? Solo se eliminará si no tiene participantes asignados.';
  }

  @override
  String groupDialogEmptySubgroupTitle(String name) {
    return 'Vaciar \"$name\"';
  }

  @override
  String get groupDialogCancel => 'Cancelar';

  @override
  String get groupDialogDelete => 'Eliminar';

  @override
  String get groupDialogEmpty => 'Vaciar';

  @override
  String get groupDialogMoveAndDelete => 'Mover y eliminar';

  @override
  String get groupDialogMoveToSubgroup => 'Mover a otro subgrupo';

  @override
  String get groupDialogBeforeDeleteMoveTo => 'Antes de eliminar, mover a';

  @override
  String get groupDialogLeaveWithoutSubgroup => 'Dejar sin subgrupo';

  @override
  String get groupDialogNoAlternativeSubgroup =>
      'No hay otro subgrupo disponible. Se dejarán sin subgrupo.';

  @override
  String get groupManagedDialogAddTitle => 'Añadir participante sin app';

  @override
  String get groupManagedDialogEditTitle => 'Editar participante sin app';

  @override
  String get groupManagedDialogNameLabel => 'Nombre';

  @override
  String get groupManagedDialogTypeLabel => 'Tipo';

  @override
  String get groupManagedDialogTypeAdultNoApp => 'Adulto sin app';

  @override
  String get groupManagedDialogTypeChild => 'Niño gestionado';

  @override
  String get groupManagedDialogSubgroupOptionalLabel => 'Subgrupo (opcional)';

  @override
  String get groupManagedDialogNoSubgroup => 'Sin subgrupo';

  @override
  String get groupManagedDialogDeliveryLabel => 'Forma de entrega';

  @override
  String get groupManagedDialogDeliveryVerbal => 'Verbal';

  @override
  String get groupManagedDialogDeliveryEmail => 'Correo';

  @override
  String get groupManagedDialogDeliveryWhatsapp => 'WhatsApp';

  @override
  String get groupManagedDialogDeliveryPrinted => 'Impresa / PDF';

  @override
  String get groupManagedDialogWhoManagesTitle =>
      '¿Quién gestionará su resultado?';

  @override
  String get groupManagedDialogWhoManagesDesc =>
      'Elige quién verá el resultado en la app para poder entregarlo en privado.';

  @override
  String get groupManagedDialogWhoManagesHelp =>
      'Cuando se integre al sorteo, esta persona no verá el resultado en la app. Tú podrás entregárselo de forma verbal o impresa.';

  @override
  String groupManagedDialogManagedBy(String name) {
    return 'Gestionado por: $name';
  }

  @override
  String get groupAssignDialogSelfTitle => 'Tu subgrupo';

  @override
  String get groupAssignDialogTitle => 'Asignar subgrupo';

  @override
  String get groupAssignDialogSelfDesc =>
      'Elige tu casa, departamento, clase o equipo.';

  @override
  String get groupAssignDialogDesc =>
      'Selecciona el subgrupo para este miembro.';

  @override
  String get groupAssignDialogSubgroupLabel => 'Subgrupo';

  @override
  String get groupSnackbarWriteName => 'Escribe un nombre';

  @override
  String get groupSnackbarDrawCompleted => 'Sorteo completado';

  @override
  String get groupSnackbarSubgroupUpdated => 'Subgrupo actualizado';

  @override
  String get groupSnackbarGroupNameUpdated => 'Nombre del grupo actualizado';

  @override
  String get groupSnackbarRuleUpdated => 'Regla de sorteo actualizada';

  @override
  String get groupSnackbarNewCodeGenerated => 'Nuevo código generado';

  @override
  String get groupSnackbarManagedAdded => 'Participante sin app añadido';

  @override
  String get groupSnackbarManagedUpdated => 'Participante sin app actualizado';

  @override
  String get groupSnackbarManagedDeleted => 'Participante sin app eliminado';

  @override
  String get groupDialogEditGroupNameTitle => 'Editar nombre del grupo';

  @override
  String get groupDialogGroupNameLabel => 'Nombre del grupo';

  @override
  String get groupDialogRenameSubgroupTitle => 'Renombrar subgrupo';

  @override
  String get groupDialogSubgroupNameLabel => 'Nombre del subgrupo';

  @override
  String get groupDialogDeleteParticipantTitle => 'Eliminar participante';

  @override
  String groupDialogDeleteParticipantBody(String name) {
    return '¿Seguro que quieres eliminar a \"$name\"?';
  }

  @override
  String groupDialogSubgroupAssignedCount(int count) {
    return 'Hay $count participantes asignados a este subgrupo.';
  }

  @override
  String groupDialogSubgroupAssignedCountDelete(int count) {
    return 'Este subgrupo tiene $count participantes asignados.';
  }

  @override
  String get languageSystem => 'Sistema';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageSelectorTitle => 'Idioma';

  @override
  String get languageSelectorSubtitle => 'Elige cómo quieres ver la app';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageFrench => 'Français';

  @override
  String get functionsErrorAlreadyMember => 'Ya perteneces a este grupo.';

  @override
  String get functionsErrorCodeNotFound =>
      'No encontramos un grupo con ese código.';

  @override
  String get functionsErrorCodeExpired => 'Este código ha expirado.';

  @override
  String get functionsErrorGroupArchived => 'Este grupo ya está cerrado.';

  @override
  String get functionsErrorUserRemoved =>
      'No puedes volver a unirte a este grupo.';

  @override
  String get functionsErrorDrawInProgress =>
      'El sorteo está en curso. Inténtalo más tarde.';

  @override
  String get functionsErrorDrawAlreadyCompleted =>
      'Este sorteo ya se había completado.';

  @override
  String get functionsErrorDrawCompletedInvitesClosed =>
      'Este sorteo ya fue realizado y ya no admite nuevos participantes.';

  @override
  String get functionsErrorSubgroupInUse =>
      'Antes de eliminar este subgrupo, mueve o deja sin subgrupo a sus participantes.';

  @override
  String get functionsErrorSubgroupNotFound =>
      'El subgrupo ya no existe o fue eliminado.';

  @override
  String get functionsErrorNotOwner =>
      'Solo el organizador puede realizar esta acción.';

  @override
  String get functionsErrorGroupDeleteForbidden =>
      'Solo el organizador puede eliminar este grupo.';

  @override
  String get functionsErrorGroupDeleteFailed =>
      'No pudimos eliminar el grupo por completo. Inténtalo otra vez o revisa tu conexión.';

  @override
  String get functionsErrorDrawLocked =>
      'No puedes modificar subgrupos o participantes cuando el sorteo está en curso o completado.';

  @override
  String get functionsErrorGenericAction =>
      'No se pudo completar la acción. Inténtalo de nuevo en un momento.';

  @override
  String get functionsErrorPermissionDeniedDrawRule =>
      'No se pudo cambiar la regla del sorteo. Revisa que el sorteo no esté en curso ni finalizado.';

  @override
  String get functionsErrorUnknown =>
      'Algo salió mal. Inténtalo de nuevo en unos momentos.';

  @override
  String get functionsErrorDebugSession =>
      'No se pudo completar la acción. Revisa si estás usando emuladores o Firebase real, si las Functions están desplegadas y si la sesión está activa.';

  @override
  String get homePrimaryActionsTitle => 'Acciones principales';

  @override
  String get homeChipDraws => 'Sorteos';

  @override
  String get homeChipTeams => 'Equipos';

  @override
  String get homeChipPairings => 'Emparejamientos';

  @override
  String get homeActiveGroupsTitle => 'En curso';

  @override
  String get homeActiveGroupsSubtitle =>
      'Preparación o sorteo pendiente; o sorteo hecho con entrega hoy o futura, o sin fecha de entrega definida.';

  @override
  String get homeActiveGroupsEmpty => 'No tienes grupos en esta sección.';

  @override
  String homeDeliveryDateLine(String date) {
    return 'Entrega: $date';
  }

  @override
  String homeDrawDateLine(String date) {
    return 'Sorteo: $date';
  }

  @override
  String get homeEmptyGroupsTitle => 'Aún no tienes grupos';

  @override
  String get homeEmptyGroupsMessage =>
      'Crea tu primer amigo secreto o únete con un código.';

  @override
  String get homeStatusActive => 'Activo';

  @override
  String get homeStatusInactive => 'Inactivo';

  @override
  String get homeCompletedGroupsTitle => 'Sorteos finalizados';

  @override
  String get homeCompletedGroupsSubtitle =>
      'Sorteo realizado y fecha de entrega ya pasada.';

  @override
  String get homePastGroupsTitle => 'Grupos anteriores';

  @override
  String get homePastGroupsSubtitle =>
      'Ya no participas activamente en estos grupos.';

  @override
  String get homeCompletedArchivedLabel => 'Completado / archivado';

  @override
  String get homeDebugToolsTitle => 'Herramientas de desarrollo';

  @override
  String homeDebugUid(String uid) {
    return 'UID de prueba: $uid';
  }

  @override
  String get homeDebugUserSwitchHint =>
      'Cambiar de usuario de prueba hará que veas otros grupos, porque cada usuario tiene su propia lista.';

  @override
  String get homeDebugResetUser =>
      'Cerrar sesión y crear nuevo usuario de prueba';

  @override
  String get homeEnvironmentEmulator => 'Entorno: Emulador local';

  @override
  String get homeEnvironmentFirebase => 'Entorno: Firebase real dev';

  @override
  String get homePrivacyFooter =>
      'Tu asignación y resultados se mantienen privados por defecto.';

  @override
  String get wizardTypeFamily => 'Familia';

  @override
  String get wizardTypeFriends => 'Amigos';

  @override
  String get wizardTypeCompany => 'Empresa';

  @override
  String get wizardTypeClass => 'Clase';

  @override
  String get wizardTypeOther => 'Otro';

  @override
  String get wizardModeInPerson => 'Presencial';

  @override
  String get wizardModeRemote => 'Remoto';

  @override
  String get wizardModeMixed => 'Mixto';

  @override
  String get wizardCreateFunctionsError =>
      'No se pudo crear el grupo. Revisa si estás usando emuladores o Firebase real y si las Functions están desplegadas.';

  @override
  String get wizardNameHelp => 'Pon un nombre que identifique el grupo.';

  @override
  String get wizardGroupTypeHelp =>
      'Este dato guía la experiencia. Por ahora no se guarda.';

  @override
  String get wizardModeHelp =>
      'Define cómo se organizará el grupo. Por ahora es preparación UX.';

  @override
  String get wizardRuleHelp => 'Esta configuración sí se guarda en el grupo.';

  @override
  String get wizardSubgroupsHelpIgnore =>
      'Con esta regla no necesitas subgrupos ahora.';

  @override
  String get wizardSubgroupsHelpEnabled =>
      'Podrás crear y asignar subgrupos desde el detalle del grupo.';

  @override
  String get wizardParticipantsHelp =>
      'Luego podrás invitar por código y añadir personas sin app.';

  @override
  String get wizardSummaryName => 'Nombre';

  @override
  String get wizardSummaryGroupType => 'Tipo de grupo';

  @override
  String get wizardSummaryMode => 'Modalidad';

  @override
  String get wizardSummaryRule => 'Regla de sorteo';

  @override
  String get groupRoleAdmin => 'Administrador';

  @override
  String get groupRoleMember => 'Miembro';

  @override
  String get groupRuleIgnoreTitle => 'Ignorar subgrupos';

  @override
  String get groupRulePreferTitle => 'Preferir subgrupo diferente';

  @override
  String get groupRuleRequireTitle => 'Exigir subgrupo diferente';

  @override
  String get groupRuleIgnoreDescription =>
      'Sorteo normal. No tiene en cuenta casas, departamentos o clases.';

  @override
  String get groupRulePreferDescription =>
      'Tarci Secret intentará cruzar regalos entre subgrupos diferentes, pero no bloqueará el sorteo si no es posible.';

  @override
  String get groupRuleRequireDescription =>
      'Nadie podrá regalar a alguien de su mismo subgrupo. Puede fallar si el grupo no permite una combinación válida.';

  @override
  String get groupSnackNeedThreeParticipants =>
      'Necesitas al menos 3 participantes efectivos para hacer un sorteo divertido.';

  @override
  String get groupSnackDrawAlreadyRunningOrDone =>
      'No se puede ejecutar un nuevo sorteo mientras está en curso o completado.';

  @override
  String get groupSnackCannotAddAfterDraw =>
      'No puedes añadir participantes después de ejecutar el sorteo.';

  @override
  String get groupDeleteOwnerSectionTitle => 'Opciones del grupo';

  @override
  String get groupDeleteOwnerSectionHint =>
      'Solo el organizador puede cerrar esta dinámica y borrar todos los datos del grupo.';

  @override
  String get groupDeleteEntryCta => 'Eliminar grupo';

  @override
  String get groupDeleteDialogPreTitle => '¿Eliminar este grupo?';

  @override
  String get groupDeleteDialogPreBody =>
      'Se borrarán la configuración, participantes, invitaciones y datos asociados. Esta acción no se puede deshacer.';

  @override
  String get groupDeleteDialogPreConfirm => 'Eliminar grupo';

  @override
  String get groupDeleteDialogPostTitle => '¿Eliminar este amigo secreto?';

  @override
  String get groupDeleteDialogPostBody =>
      'El sorteo ya fue realizado. Si continúas, todos perderán acceso a sus resultados, listas de deseos, conversación del grupo y datos asociados. Esta acción no se puede deshacer.';

  @override
  String get groupDeleteDialogPostConfirm => 'Eliminar definitivamente';

  @override
  String get groupDeleteSuccessSnackbar => 'Grupo eliminado';

  @override
  String get groupDetailMissingMessage =>
      'Este grupo ya no existe o fue eliminado por el organizador.';

  @override
  String get groupTooltipEditGroupName => 'Editar nombre del grupo';

  @override
  String get groupStatusCompletedInfo =>
      'Cada persona ya puede ver a quién le toca regalar.';

  @override
  String get groupStatusReadyInfo =>
      'Al lanzarlo, cada quien verá su asignación en privado.';

  @override
  String get groupStatusPendingInfo =>
      'Revisa participantes o subgrupos pendientes.';

  @override
  String groupEffectiveParticipants(int count) {
    return 'Tienes $count de 3 personas mínimas';
  }

  @override
  String get groupOwnerCanRunHint =>
      'Cuando todo esté listo, el organizador lanza el sorteo.';

  @override
  String get groupPendingSubgroupHint =>
      'Asigna a cada persona a su grupo y ya estamos.';

  @override
  String get groupPendingGeneralHint =>
      'Te falta poco para poder hacer el sorteo.';

  @override
  String groupRuleConfigVersion(int version) {
    return 'Configuración v$version';
  }

  @override
  String get groupRuleLockedHint =>
      'La regla no se puede cambiar mientras el sorteo está en curso o ya se completó.';

  @override
  String get groupSubgroupSectionHelp =>
      'Organiza casas, departamentos, clases o equipos para mejorar el sorteo.';

  @override
  String get groupSubgroupEmptyHelp =>
      'Aún no hay subgrupos. Puedes crear uno para organizar mejor el grupo.';

  @override
  String get groupSubgroupAssignedOne => '1 participante asignado';

  @override
  String groupSubgroupAssignedMany(int count) {
    return '$count participantes asignados';
  }

  @override
  String get groupSubgroupLockedHint =>
      'No puedes modificar subgrupos después de ejecutar el sorteo.';

  @override
  String get groupSubgroupDisabledHint =>
      'Subgrupos desactivados para este sorteo. Puedes habilitarlos cambiando la regla.';

  @override
  String get groupParticipantSubgroupLockedHint =>
      'El subgrupo no se puede cambiar mientras el sorteo está en curso o ya se completó.';

  @override
  String get groupManagedSectionHelp =>
      'Estos participantes no usan la app y su resultado se entrega de forma privada.';

  @override
  String get groupManagedEmptyHelp => 'Aún no hay participantes gestionados.';

  @override
  String get groupManagedGuardianSelf => 'tú';

  @override
  String get groupManagedGuardianOther => 'otro responsable';

  @override
  String get groupManagedPrivateDeliveryHint =>
      'Participan sin app y su resultado se entrega de forma privada.';

  @override
  String get groupInvitationsHelp =>
      'Genera un código y compártelo para que se unan participantes.';

  @override
  String get groupInvitationCodeTapHint => 'Toca el código para copiarlo';

  @override
  String get groupInvitationsClosedHint =>
      'Las invitaciones están cerradas porque el sorteo ya fue ejecutado.';

  @override
  String get groupAdvancedHelp =>
      'Aquí se muestran detalles secundarios del grupo.';

  @override
  String groupAdvancedLastExecution(String id) {
    return 'Última ejecución: $id';
  }

  @override
  String groupAdvancedInternalStatus(String status) {
    return 'Estado interno del sorteo: $status';
  }

  @override
  String get groupCreateSubgroupHint => 'Ej. Casa Stan, Ventas, Clase 3A';

  @override
  String get groupHeaderSubtitle =>
      'Prepara tu sorteo con privacidad y claridad.';

  @override
  String get groupDetailTaglinePostDraw =>
      'Resultados en privado: cada quien ve lo suyo.';

  @override
  String get groupMemberPreDrawSubtitle =>
      'Ya estás dentro. Cuando el organizador lance el sorteo, podrás ver tu asignación en privado.';

  @override
  String get groupMemberYourHouseTitle => 'Tu casa o equipo';

  @override
  String get groupMemberYourHousePickHint =>
      'El organizador definió equipos o casas. Elige el tuyo para ubicarte bien en el sorteo.';

  @override
  String groupMemberYourHouseAssigned(String name) {
    return 'Te hemos ubicado en: $name';
  }

  @override
  String get groupMemberYourHouseChooseCta => 'Elegir mi casa o equipo';

  @override
  String get groupMemberYourHouseChangeCta => 'Cambiar mi casa o equipo';

  @override
  String get groupMemberManagedByYouTitle => 'Personas que gestionas aquí';

  @override
  String get groupMemberManagedByYouSubtitle =>
      'Solo verás a quienes el organizador te asignó como responsable.';

  @override
  String get groupMemberHeroTitlePreDraw => 'Ya estás dentro';

  @override
  String get groupMemberHeroSubtitlePreDraw =>
      'Cuando el organizador lance el sorteo, verás tu asignación en privado.';

  @override
  String get groupMemberHeroTaglinePreDraw =>
      'Tu grupo, tu espacio. Nadie ve el resultado de los demás.';

  @override
  String get groupMemberHeroTaglinePostDraw =>
      'Sorteo listo. Solo tú ves lo que te tocó.';

  @override
  String get groupMemberPostDrawHeroSubtitle =>
      'Abre tu resultado cuando quieras; es privado.';

  @override
  String get groupMemberHeroSubtitleDrawing =>
      'Estamos sorteando. En un momento podrás ver tu resultado.';

  @override
  String get groupBackToDashboard => 'Volver al dashboard';

  @override
  String get groupLoadingDetail => 'Cargando grupo...';

  @override
  String get groupErrorTitle => 'No pudimos abrir este grupo';

  @override
  String get groupErrorNotFound =>
      'Este grupo ya no está disponible o no tienes acceso.';

  @override
  String get groupPreparationTitle => 'Estado del grupo';

  @override
  String groupPreparationQuickSummary(
    int total,
    int withoutApp,
    int subgroups,
  ) {
    return '$total personas en el sorteo · $withoutApp sin app · $subgroups subgrupos';
  }

  @override
  String get groupPostDrawHeroTitle => 'Sorteo realizado';

  @override
  String get groupPostDrawHeroSubtitle =>
      'Ya puedes ver lo que te corresponde, en privado.';

  @override
  String get groupChecklistEnoughPeopleDone => 'Ya tenéis suficientes personas';

  @override
  String get groupChecklistEnoughPeopleMissing =>
      'Necesitas al menos 3 personas';

  @override
  String get groupChecklistAllInSubgroupDone => 'Todos están en su subgrupo';

  @override
  String get groupChecklistMissingSubgroupOne =>
      'Falta colocar a 1 persona en su subgrupo';

  @override
  String groupChecklistMissingSubgroupMany(int count) {
    return 'Faltan $count personas por colocar en su subgrupo';
  }

  @override
  String groupChecklistPendingMembers(int count) {
    return '$count persona(s) salieron o fueron retiradas';
  }

  @override
  String groupPreparationRegistered(int count) {
    return 'Registrados: $count';
  }

  @override
  String groupPreparationManaged(int count) {
    return 'Gestionados: $count';
  }

  @override
  String groupPreparationPending(int count) {
    return 'Pendientes: $count';
  }

  @override
  String groupPreparationMissingSubgroup(int count) {
    return 'Sin subgrupo: $count';
  }

  @override
  String get groupRuleCurrentLabel => 'Regla actual';

  @override
  String get groupRuleChangeCta => 'Cambiar regla';

  @override
  String get groupSectionExpandHint => 'Toca para expandir';

  @override
  String get groupSectionCollapseHint => 'Toca para cerrar';

  @override
  String groupSectionItemsCount(int count) {
    return '$count en total';
  }

  @override
  String get groupManagedDialogGuardianSectionTitle =>
      '¿Quién entregará el resultado?';

  @override
  String get groupManagedDialogGuardianMe => 'Yo';

  @override
  String get groupManagedDialogGuardianMeHint =>
      'Compartiré el resultado en privado';

  @override
  String get groupManagedDialogGuardianOther => 'Otro miembro';

  @override
  String get groupManagedDialogGuardianSpecific => 'Responsable específico';

  @override
  String get groupManagedDialogGuardianComingSoon => 'Próximamente';

  @override
  String get groupManagedDialogDeliverySectionTitle =>
      '¿Cómo se lo harás llegar?';

  @override
  String get groupManagedResponsibleUnavailable => 'Responsable no disponible';

  @override
  String groupManagedDeliversResponsible(String name) {
    return 'Lo gestiona: $name';
  }

  @override
  String get groupManagedDialogPickGuardianTitle => '¿Quién lo entregará?';

  @override
  String get groupManagedDialogGuardianOtherSubtitle =>
      'Este miembro verá el resultado y podrá entregárselo en privado.';

  @override
  String get groupManagedDialogGuardianNoEligibleMembers =>
      'Cuando se una otro miembro con app, podrás asignárselo.';

  @override
  String get groupManagedDialogPickMemberCta => 'Elegir miembro';

  @override
  String get groupManagedDialogSelectOtherFirst =>
      'Elige primero a un miembro del grupo.';

  @override
  String get groupManagedDialogGuardianMustReassign =>
      'Ese miembro ya no está activo en el grupo. Elige a otro responsable o «Yo».';

  @override
  String groupManagedDialogDeliversSummary(String name) {
    return 'Lo entrega: $name';
  }

  @override
  String get groupParticipantsRegisteredTitle => 'Participantes registrados';

  @override
  String get groupParticipantsPendingTitle => 'Participantes pendientes';

  @override
  String get groupParticipantsPendingEmpty =>
      'No hay participantes pendientes.';

  @override
  String get groupPendingStatusLeft => 'Salió del grupo';

  @override
  String get groupPendingStatusRemoved => 'Eliminado del grupo';

  @override
  String myAssignmentSubgroupLabel(String name) {
    return 'Subgrupo: $name';
  }

  @override
  String managedSubgroupLabel(String name) {
    return 'Subgrupo: $name';
  }

  @override
  String get managedYouManageIt => 'Lo gestionas tú';

  @override
  String managedDeliveryRecommendation(String mode) {
    return 'Entrega recomendada: $mode';
  }

  @override
  String get managedTypeManagedParticipant => 'Participante gestionado';

  @override
  String get managedDeliveryOwnerDelegated => 'Gestionada por responsable';

  @override
  String get managedDeliveryModeWhatsapp => 'WhatsApp';

  @override
  String get managedDeliveryModeEmail => 'Correo';

  @override
  String get managedDeliveryModePdf => 'Impresa / PDF';

  @override
  String get managedDeliveryCtaWhatsapp => 'Compartir por WhatsApp';

  @override
  String get managedDeliveryCtaEmail => 'Preparar correo';

  @override
  String get managedDeliveryCtaPdf => 'Generar PDF';

  @override
  String get managedDeliveryVerbalBadge => 'Entrega verbal';

  @override
  String get managedDeliveryPdfGenerating => 'Generando PDF…';

  @override
  String get managedDeliveryWhatsappBrand => '🎁 Tarci Secret';

  @override
  String managedDeliveryWhatsappHello(String name) {
    return 'Hola, $name.';
  }

  @override
  String managedDeliveryWhatsappDrawLine(String groupName) {
    return 'Ya se realizó el amigo secreto de «$groupName».';
  }

  @override
  String get managedDeliveryWhatsappGiftIntro => 'A ti te toca regalar a:';

  @override
  String managedDeliveryWhatsappReceiverLine(String receiverName) {
    return '✨ $receiverName';
  }

  @override
  String managedDeliverySubgroupBelongsTo(String subgroup) {
    return 'Pertenece a: $subgroup';
  }

  @override
  String get managedDeliveryClosingSecret => 'Guarda el secreto 🤫';

  @override
  String managedDeliveryEmailSubject(String groupName) {
    return 'Tu amigo secreto de $groupName ya está listo 🎁';
  }

  @override
  String managedDeliveryEmailGreeting(String name) {
    return 'Hola, $name:';
  }

  @override
  String managedDeliveryEmailLead(String groupName) {
    return 'Te escribimos con el resultado privado del amigo secreto del grupo «$groupName».';
  }

  @override
  String get managedDeliveryEmailGiftLabel => 'A quien te toca regalar es a:';

  @override
  String managedDeliveryEmailReceiverLine(String receiverName) {
    return '$receiverName';
  }

  @override
  String managedDeliveryEmailSubgroupLine(String subgroup) {
    return 'Casa o equipo: $subgroup';
  }

  @override
  String get managedDeliveryEmailClosing =>
      'Por favor, guarda este resultado solo para ti. Nadie más debe verlo.';

  @override
  String get managedDeliveryEmailSignoff => 'Un abrazo,\nTarci Secret';

  @override
  String get managedPdfDocTitle => 'amigo-secreto';

  @override
  String get managedPdfHeadline => 'Tu amigo secreto ya está listo';

  @override
  String get managedPdfForLabel => 'Para';

  @override
  String get managedPdfGroupLabel => 'Grupo';

  @override
  String get managedPdfGiftHeading => 'Te toca regalar a…';

  @override
  String get managedPdfFooterKeepSecret =>
      'Guarda el secreto. Nadie más debe verlo.';

  @override
  String get managedPdfFooterBrand => 'Generado con Tarci Secret';

  @override
  String get managedDeliveryFallbackGroupName => 'tu grupo';

  @override
  String get managedDeliveryErrorMissingData =>
      'No hay datos suficientes para preparar el mensaje.';

  @override
  String get managedDeliveryErrorWhatsapp =>
      'No pudimos abrir WhatsApp. Puedes compartir el texto con otra app.';

  @override
  String get managedDeliveryErrorEmail =>
      'No encontramos una app de correo en este dispositivo.';

  @override
  String get managedDeliveryErrorPdf =>
      'No se pudo generar el PDF. Inténtalo de nuevo.';

  @override
  String get managedDeliveryErrorShare =>
      'No se pudo compartir. Inténtalo otra vez.';

  @override
  String get managedDeliveryErrorGeneric =>
      'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get myAssignmentPrivateBadge => 'Privado · solo para ti';

  @override
  String get myAssignmentRevealLabel => 'Te toca regalar a';

  @override
  String get myAssignmentEmotionalCopy => 'Hazle sentir especial.';

  @override
  String get myAssignmentPrivacyTitle => 'Esto solo lo ves tú';

  @override
  String get myAssignmentPrivacyBody =>
      'Guarda el secreto hasta el día del intercambio. Nadie más en el grupo puede ver a quién te toca.';

  @override
  String get myAssignmentNoSubgroupChip => 'Sin subgrupo';

  @override
  String get groupCompletedHeroSubtitle =>
      'Cada persona ya descubrió a quién le toca regalar.';

  @override
  String get groupCompletedPrivacyNote =>
      'Cada resultado es privado. Solo cada persona ve el suyo.';

  @override
  String get groupCompletedManagedHint =>
      'Tú entregas en privado los resultados de las personas que gestionas.';

  @override
  String get chatGroupSectionTitle => 'Conversación del grupo';

  @override
  String get chatGroupSectionSubtitle =>
      'Bromea, comparte pistas y mantén vivo el ambiente.';

  @override
  String get chatGroupEnterCta => 'Entrar al chat';

  @override
  String chatGroupEventLine(String date) {
    return 'Entrega: $date';
  }

  @override
  String get chatDrawCompletedChip => 'Sorteo realizado';

  @override
  String get chatInputHint => 'Escribe algo para el grupo…';

  @override
  String get chatSendCta => 'Enviar';

  @override
  String get chatTarciLabel => 'Tarci';

  @override
  String get chatEmptyTitle => 'Aún no hay mensajes';

  @override
  String get chatEmptyBody =>
      'Cuando alguien escriba o Tarci avise de algo importante, lo verás aquí.';

  @override
  String get chatLoadError =>
      'No pudimos cargar el chat. Comprueba tu conexión o vuelve a intentarlo.';

  @override
  String get chatSendError =>
      'No se pudo enviar el mensaje. Inténtalo otra vez.';

  @override
  String get chatSystemGroupCreatedV1 =>
      '🎁 El grupo ya está en marcha. Soltad pistas, soltad caña y que ruede el cotilleo sano.';

  @override
  String get chatSystemDrawCompletedV1 =>
      '🤫 Sorteo hecho. A partir de ahora, cada pregunta rara cuenta como evidencia.';

  @override
  String chatSystemUnknownTemplate(String templateKey) {
    return 'Mensaje del sistema ($templateKey)';
  }

  @override
  String get chatSystemAutoPlayful001V1 =>
      'Aquí ya huele a sospechas… y todavía nadie ha confesado nada.';

  @override
  String get chatSystemAutoPlayful002V1 =>
      'Desde que hay sorteo, cada pregunta inocente parece estrategia.';

  @override
  String get chatSystemAutoPlayful003V1 =>
      'Consejo de Tarci: investiga con sutileza, no con interrogatorio.';

  @override
  String get chatSystemAutoPlayful004V1 =>
      'Hay quien ya tiene regalo. Hay quien tiene fe.';

  @override
  String get chatSystemAutoPlayful005V1 =>
      'Si alguien pregunta por tallas, colores y hobbies seguidos, toma nota.';

  @override
  String get chatSystemAutoPlayful006V1 =>
      'Un buen regalo sorprende. Un gran regalo deja historia.';

  @override
  String get chatSystemAutoPlayful007V1 =>
      'Las sonrisas sospechosas cuentan como pista.';

  @override
  String get chatSystemAutoPlayful008V1 =>
      'Se permite despistar. Se recomienda no pasarse.';

  @override
  String get chatSystemAutoPlayful009V1 =>
      'El silencio de algunos empieza a parecer planificación.';

  @override
  String get chatSystemAutoPlayful010V1 =>
      'Si vas a improvisar, al menos improvisa con cariño.';

  @override
  String get chatSystemAutoPlayful011V1 =>
      'Tarci detecta energía de regalo épico… y de pánico elegante.';

  @override
  String get chatSystemAutoPlayful012V1 =>
      'Quien dice “yo ya lo tengo” sin pruebas despierta dudas.';

  @override
  String get chatSystemAutoPlayful013V1 =>
      'Recordatorio amable: el misterio también se disfruta.';

  @override
  String get chatSystemAutoPlayful014V1 =>
      'Cada grupo tiene un detective. ¿Ya sabéis quién es?';

  @override
  String get chatSystemAutoPlayful015V1 =>
      'Un detalle con intención vale más que un regalo sin alma.';

  @override
  String get chatSystemAutoPlayful016V1 =>
      'Este chat está oficialmente en modo sospecha.';

  @override
  String get chatSystemAutoPlayful017V1 =>
      'Si acabas de buscar ideas en secreto, nadie te juzga.';

  @override
  String get chatSystemAutoPlayful018V1 =>
      'Hay miradas en la vida real que ahora significan demasiado.';

  @override
  String get chatSystemAutoPlayful019V1 =>
      'La misión no es gastar más. Es acertar mejor.';

  @override
  String get chatSystemAutoPlayful020V1 =>
      'Disimular bien también es parte del juego.';

  @override
  String get chatSystemAutoPlayful021V1 =>
      'Tarci apuesta a que alguien aquí ya tiene un plan brillante.';

  @override
  String get chatSystemAutoDebate001V1 =>
      'Debate rápido: ¿regalo útil o regalo que haga reír?';

  @override
  String get chatSystemAutoDebate002V1 =>
      '¿Mejor sorpresa total o pista bien aprovechada?';

  @override
  String get chatSystemAutoDebate003V1 => '¿Qué gana: creatividad o precisión?';

  @override
  String get chatSystemAutoDebate004V1 =>
      'Abrimos debate: ¿el envoltorio espectacular importa?';

  @override
  String get chatSystemAutoDebate005V1 =>
      '¿Investigación discreta o lista de deseos al rescate?';

  @override
  String get chatSystemAutoDebate006V1 =>
      'Sin señalar a nadie: ¿quién del grupo improvisa al final?';

  @override
  String get chatSystemAutoDebate007V1 =>
      '¿Regalo pequeño con historia o grande sin historia?';

  @override
  String get chatSystemAutoDebate008V1 =>
      '¿Se vale despistar en el chat o eso ya es juego sucio?';

  @override
  String get chatSystemAutoDebate009V1 =>
      '¿Qué emociona más: acertar o sorprender?';

  @override
  String get chatSystemAutoDebate010V1 =>
      'Si tuvieras que elegir: ¿práctico, divertido o sentimental?';

  @override
  String get chatSystemAutoWishlist001V1 =>
      'Algunas listas siguen vacías. Una pista a tiempo puede salvar un regalo.';

  @override
  String get chatSystemAutoWishlist002V1 =>
      'Tu lista de deseos no quita magia; evita adivinar a ciegas.';

  @override
  String get chatSystemAutoWishlist003V1 =>
      'Si quieres que acierten contigo, deja alguna idea.';

  @override
  String get chatSystemAutoWishlist004V1 =>
      'Hay alguien preparando regalo con muy pocas pistas. Ejem.';

  @override
  String get chatSystemAutoWishlist005V1 =>
      'Completar la lista es ayudar sin revelar demasiado.';

  @override
  String get chatSystemAutoWishlist006V1 =>
      'Un enlace, un gusto, una pista: todo suma.';

  @override
  String get chatSystemAutoWishlist007V1 =>
      'Las mejores sorpresas también agradecen orientación.';

  @override
  String get chatSystemAutoWishlist008V1 =>
      'Si tu lista está vacía, tu amigo secreto está jugando en modo difícil.';

  @override
  String get chatSystemAutoQuiet001V1 =>
      'Mucho silencio por aquí… ¿comprando o escondiendo pruebas?';

  @override
  String get chatSystemAutoQuiet002V1 =>
      'Este grupo está demasiado tranquilo. Alguien que rompa el hielo.';

  @override
  String get chatSystemAutoQuiet003V1 =>
      'Tarci pasa lista: ¿sigue vivo el cachondeo?';

  @override
  String get chatSystemAutoQuiet004V1 =>
      'Pregunta de reactivación: ¿quién se ve más sospechoso hoy?';

  @override
  String get chatSystemAutoQuiet005V1 =>
      'Si nadie escribe, Tarci empieza a inventar teorías.';

  @override
  String get chatSystemAutoQuiet006V1 =>
      'Chat dormido, misterio despierto. Comentad algo.';

  @override
  String get chatSystemAutoCountdown014V1 =>
      'Quedan 14 días. Todavía hay margen, pero la excusa se está acabando.';

  @override
  String get chatSystemAutoCountdown007V1 =>
      'Quedan 7 días. Quien no tenga idea entra en fase de búsqueda seria.';

  @override
  String get chatSystemAutoCountdown003V1 =>
      'Quedan 3 días. Ya no es planificación: es operación rescate.';

  @override
  String get chatSystemAutoCountdown001V1 =>
      'Falta 1 día. Envuelve, respira y finge normalidad.';

  @override
  String get chatSystemAutoCountdown000V1 =>
      'Hoy es el intercambio. Que haya sorpresas, risas y cero confesiones antes de tiempo.';

  @override
  String get dynamicsHomePrimaryCta => 'Crear dinámica';

  @override
  String get dynamicsSelectTitle => 'Elige una dinámica';

  @override
  String get dynamicsSelectSubtitle =>
      'Elige una dinámica: Amigo Secreto, Sorteo, Equipos, Parejas o Duelos.';

  @override
  String get dynamicsCardSecretSantaTitle => 'Amigo secreto';

  @override
  String get dynamicsCardSecretSantaBody =>
      'Asignaciones privadas, listas de deseos y chat de grupo.';

  @override
  String get dynamicsCardRaffleTitle => 'Sorteo';

  @override
  String get dynamicsCardRaffleBody =>
      'Ganadores públicos para todo el grupo. Sin secretos ni entregas gestionadas.';

  @override
  String get dynamicsCardTeamsTitle => 'Equipos';

  @override
  String get dynamicsCardPairingsTitle => 'Parejas';

  @override
  String get dynamicsCardDuelsTitle => 'Duelos';

  @override
  String get dynamicsComingSoonBadge => 'Próximamente';

  @override
  String get homeDynamicTypeSecretSanta => 'Amigo secreto';

  @override
  String get homeDynamicTypeRaffle => 'Sorteo';

  @override
  String get homeRaffleStatePreparing => 'Preparando';

  @override
  String get homeRaffleStateCompleted => 'Sorteo realizado';

  @override
  String get raffleWizardTitle => 'Nuevo sorteo';

  @override
  String get raffleWizardNameLabel => 'Nombre del sorteo';

  @override
  String get raffleWizardWinnersLabel => 'Número de ganadores';

  @override
  String get raffleWizardOwnerParticipatesTitle => '¿Participas tú?';

  @override
  String get raffleWizardOwnerParticipatesYes => 'Sí, entro en el bombo';

  @override
  String get raffleWizardOwnerParticipatesNo => 'No, solo organizo';

  @override
  String get raffleWizardEventOptional => 'Fecha del evento (opcional)';

  @override
  String get raffleWizardReviewTitle => 'Revisión';

  @override
  String raffleWizardReviewWinners(int count) {
    return '$count ganador(es)';
  }

  @override
  String get raffleWizardCreateCta => 'Crear sorteo';

  @override
  String get raffleDetailInviteSection => 'Invitación';

  @override
  String get raffleDetailAppMembersTitle => 'Participantes con app';

  @override
  String get raffleDetailManualTitle => 'Participantes sin app';

  @override
  String get raffleDetailAddManualCta => 'Añadir persona';

  @override
  String get raffleDetailRunRaffleCta => 'Realizar sorteo';

  @override
  String get raffleDetailWinnersTitle => 'Ganadores';

  @override
  String get raffleDetailShareCta => 'Compartir resultado';

  @override
  String get raffleDetailCompletedHint =>
      'Este sorteo ya está cerrado: no se pueden cambiar participantes ni volver a sortear.';

  @override
  String get raffleManualEditTitle => 'Editar participante';

  @override
  String get raffleManualDisplayNameLabel => 'Nombre visible';

  @override
  String raffleShareBody(String raffleName, String winners) {
    return 'Ya tenemos ganadores de «$raffleName»:\n$winners\n\nHecho con Tarci Secret.';
  }

  @override
  String get functionsErrorRaffleResolvedInvitesClosed =>
      'Este sorteo ya se realizó y ya no admite nuevos participantes.';

  @override
  String get functionsErrorRaffleInProgress =>
      'El sorteo está en curso. Inténtalo en unos segundos.';

  @override
  String get functionsErrorRaffleRotateLocked =>
      'No se puede rotar el código cuando el sorteo ya no admite cambios.';

  @override
  String get functionsErrorRaffleAlreadyCompleted =>
      'Este sorteo ya se completó.';

  @override
  String get functionsErrorRaffleTooManyWinners =>
      'Hay más ganadores que participantes elegibles.';

  @override
  String get functionsErrorRaffleInsufficientParticipants =>
      'No hay participantes suficientes para este sorteo.';

  @override
  String get functionsErrorRaffleInvalidDynamic =>
      'Esta acción no está disponible para este tipo de grupo.';

  @override
  String get functionsErrorChatNotAvailableForRaffle =>
      'El chat de grupo no está disponible en sorteos públicos.';

  @override
  String get functionsErrorWishlistNotAvailableForRaffle =>
      'La lista de deseos no está disponible en sorteos.';

  @override
  String get functionsErrorManagedParticipantsNotForRaffle =>
      'Los participantes gestionados de amigo secreto no aplican a sorteos.';

  @override
  String get functionsErrorDrawNotForRaffle =>
      'El sorteo de amigo secreto no está disponible en grupos de tipo sorteo.';

  @override
  String get functionsErrorAssignmentsNotForRaffle =>
      'Las asignaciones secretas no aplican a este grupo.';

  @override
  String raffleDetailEligibleCount(int count) {
    return 'Participantes en el bombo: $count';
  }

  @override
  String get raffleWizardPickEventDate => 'Seleccionar fecha';

  @override
  String get functionsErrorDrawNotSupportedForDynamic =>
      'El sorteo de amigo secreto no está disponible para este tipo de grupo.';

  @override
  String get functionsErrorRaffleEditLocked =>
      'Este sorteo ya no admite cambios en participantes.';

  @override
  String get raffleDetailMinPoolHint =>
      'Necesitas al menos 2 participantes en el bombo para realizar el sorteo.';

  @override
  String get raffleResultHeroTitle => '¡Sorteo realizado!';

  @override
  String get raffleResultHeroSubtitle => 'Ya tenemos el resultado.';

  @override
  String raffleResultSingleWinner(String name) {
    return 'Ganador: $name';
  }

  @override
  String raffleResultMultipleWinners(String names) {
    return 'Ganadores: $names';
  }

  @override
  String get raffleWizardOwnerNicknameLabel => 'Tu nombre en el bombo';

  @override
  String get raffleWizardOwnerNicknameHelper =>
      'Así te verán los demás. Usa un apodo o nombre, no tu rol de organizador.';

  @override
  String get raffleOwnerParticipantFallback => 'Participante';

  @override
  String get raffleMemberDefaultName => 'Participante';

  @override
  String get raffleDetailStatsWinners => 'Número de ganadores';

  @override
  String get raffleDetailInPool => 'En el bombo';

  @override
  String get pushActivationTitle => 'Activa las notificaciones';

  @override
  String get pushActivationBody =>
      'Te avisaremos cuando se realice un sorteo o cuando tu amigo secreto esté listo.';

  @override
  String get pushActivationCta => 'Activar';

  @override
  String get pushActivationSuccessSnackbar => 'Notificaciones activadas.';

  @override
  String get pushActivationDeniedSnackbar =>
      'No pudimos activar las notificaciones. Puedes intentarlo más tarde desde los ajustes del sistema.';

  @override
  String get dynamicsCardTeamsBody =>
      'Reparte participantes en equipos equilibrados. Resultado visible para todos.';

  @override
  String get homeDynamicTypeTeams => 'Equipos';

  @override
  String get homeTeamsStatePreparing => 'Preparando';

  @override
  String get homeTeamsStateGenerating => 'Formando equipos';

  @override
  String get homePairingsStateGenerating => 'Formando parejas';

  @override
  String get homeDuelsStateGenerating => 'Formando duelos';

  @override
  String get homeTeamsStateCompleted => 'Equipos listos';

  @override
  String get teamsWizardTitle => 'Crear equipos';

  @override
  String get teamsWizardCreateCta => 'Crear equipos';

  @override
  String get teamsWizardNameLabel => 'Nombre de la dinámica';

  @override
  String get teamsWizardOwnerNicknameLabel => 'Tu nombre en los equipos';

  @override
  String get teamsWizardOwnerNicknameHelper =>
      'Así te verán los demás en el reparto. Usa un apodo, no tu rol de organizador.';

  @override
  String get teamsWizardEventOptional => 'Fecha del evento (opcional)';

  @override
  String get teamsWizardPickEventDate => 'Elegir fecha';

  @override
  String get teamsWizardOwnerParticipatesTitle => '¿Participas tú?';

  @override
  String get teamsWizardOwnerParticipatesYes => 'Sí, quiero estar en un equipo';

  @override
  String get teamsWizardOwnerParticipatesNo => 'No, solo organizo';

  @override
  String get teamsWizardGroupingTitle => '¿Cómo formar los equipos?';

  @override
  String get teamsWizardGroupingSubtitle =>
      'Elige si prefieres un número fijo de equipos o un tamaño por equipo.';

  @override
  String get teamsWizardModeTeamCount => 'Por número de equipos';

  @override
  String get teamsWizardModeTeamSize => 'Por personas por equipo';

  @override
  String get teamsWizardTeamCountLabel => '¿Cuántos equipos?';

  @override
  String get teamsWizardTeamSizeLabel => '¿Cuántas personas por equipo?';

  @override
  String get teamsWizardReviewTitle => 'Revisión';

  @override
  String teamsWizardReviewTeamCount(int count) {
    return '$count equipos';
  }

  @override
  String teamsWizardReviewTeamSize(int size) {
    return 'Equipos de $size personas';
  }

  @override
  String get teamsOwnerParticipantFallback => 'Participante';

  @override
  String get teamsMemberDefaultName => 'Participante';

  @override
  String get teamsDetailInviteSection => 'Invitación';

  @override
  String get teamsDetailAppMembersTitle => 'Participantes con app';

  @override
  String get teamsDetailManualTitle => 'Participantes sin app';

  @override
  String get teamsDetailAddManualCta => 'Añadir persona';

  @override
  String get teamsDetailFormTeamsCta => 'Formar equipos';

  @override
  String get teamsDetailConfigTitle => 'Configuración';

  @override
  String teamsDetailConfigTeamCount(int count) {
    return '$count equipos';
  }

  @override
  String teamsDetailConfigTeamSize(int size) {
    return 'Equipos de $size personas';
  }

  @override
  String teamsDetailEstimatedTeams(int count) {
    return 'Equipos estimados: $count';
  }

  @override
  String teamsDetailEligibleCount(int count) {
    return 'Participantes en el reparto: $count';
  }

  @override
  String get teamsDetailMinPoolHint =>
      'Necesitas al menos 2 participantes para formar equipos.';

  @override
  String get teamsDetailInvalidConfigHint =>
      'Revisa la configuración de equipos antes de continuar.';

  @override
  String get teamsDetailCompletedHint =>
      'Los equipos ya están formados: no se pueden cambiar participantes ni volver a formar.';

  @override
  String get teamsDetailTeamsListTitle => 'Equipos';

  @override
  String get teamsDetailShareCta => 'Compartir resultado';

  @override
  String get teamsDetailEmailCta => 'Preparar correo';

  @override
  String get teamsDetailPdfCta => 'Generar PDF';

  @override
  String get teamsManualDisplayNameLabel => 'Nombre visible';

  @override
  String get teamsManualEditTitle => 'Editar participante';

  @override
  String get teamsResultHeroTitle => '¡Equipos listos!';

  @override
  String get teamsResultHeroSubtitle =>
      'Ya puedes compartir el reparto con el grupo.';

  @override
  String teamsResultSummary(int teamCount, int participantCount) {
    return '$teamCount equipos · $participantCount participantes';
  }

  @override
  String teamsUnitLabel(int number) {
    return 'Equipo $number';
  }

  @override
  String teamsShareBody(String groupName, String teamsBlock) {
    return '🧩 Equipos generados en «$groupName»\n\n$teamsBlock\n\nHecho con Tarci Secret.';
  }

  @override
  String teamsEmailSubject(String groupName) {
    return 'Equipos generados — $groupName';
  }

  @override
  String teamsEmailBody(String groupName, String teamsBlock) {
    return 'Hola,\n\nYa están listos los equipos de «$groupName»:\n\n$teamsBlock\n\nGenerado con Tarci Secret.';
  }

  @override
  String get teamsEmailError =>
      'No hay una app de correo disponible en este dispositivo.';

  @override
  String get teamsPdfHeadline => 'Equipos generados';

  @override
  String teamsPdfSummary(int teamCount, int participantCount) {
    return '$teamCount equipos · $participantCount participantes';
  }

  @override
  String get teamsPdfFooter => 'Generado con Tarci Secret';

  @override
  String get teamsPdfError => 'No se pudo generar el PDF. Inténtalo de nuevo.';

  @override
  String joinSuccessTeamsSubtitle(String groupName) {
    return 'Te uniste a «$groupName».';
  }

  @override
  String get joinSuccessTeamsBody =>
      'Cuando el organizador forme los equipos, podrás ver el resultado aquí.';

  @override
  String get joinSuccessTeamsPrimaryCta => 'Ir a equipos';

  @override
  String get functionsErrorTeamsResolvedInvitesClosed =>
      'Los equipos ya están formados y este grupo no acepta nuevos participantes.';

  @override
  String get functionsErrorTeamsInProgress =>
      'Se están formando los equipos. Inténtalo en un momento.';

  @override
  String get functionsErrorTeamsRotateLocked =>
      'No se puede cambiar el código después de formar los equipos.';

  @override
  String get functionsErrorTeamsAlreadyCompleted =>
      'Los equipos ya están formados.';

  @override
  String get functionsErrorTeamsInsufficientParticipants =>
      'Se necesitan al menos 2 participantes para formar equipos.';

  @override
  String get functionsErrorTeamsInvalidConfiguration =>
      'La configuración de equipos no es válida.';

  @override
  String get functionsErrorTeamsTooManyParticipants =>
      'Has alcanzado el máximo de participantes permitidos.';

  @override
  String get functionsErrorTeamsInvalidDynamic =>
      'Esta acción no está disponible para este tipo de dinámica.';

  @override
  String get functionsErrorTeamsEditLocked =>
      'No se pueden editar participantes después de formar los equipos.';

  @override
  String get chatSystemAutoTeamsPlayful001V1 =>
      'Equipos listos. Ya podéis empezar a culpar al algoritmo.';

  @override
  String get chatSystemAutoTeamsPlayful002V1 =>
      '¿Qué equipo viene a ganar y cuál viene por la merienda?';

  @override
  String get chatSystemAutoTeamsPlayful003V1 =>
      'Aquí hay talento… y también mucha confianza. Veremos cuál pesa más.';

  @override
  String get chatSystemAutoTeamsPlayful004V1 =>
      'Se aceptan pronósticos, excusas y teorías conspirativas.';

  @override
  String get chatSystemAutoTeamsPlayful005V1 =>
      'Un reparto justo. Las quejas creativas también cuentan como participación.';

  @override
  String get chatSystemAutoTeamsPlayful006V1 =>
      'No importa quién quede contigo. Importa quién termina pidiendo revancha.';

  @override
  String get chatSystemAutoTeamsPlayful007V1 =>
      'Tarci repartió. Ahora os toca demostrar que no era suerte.';

  @override
  String get chatSystemAutoTeamsPlayful008V1 =>
      'Hay equipos que inspiran respeto y otros que inspiran memes.';

  @override
  String get chatSystemAutoTeamsPlayful009V1 =>
      'El azar habló. La dignidad se resuelve el día del encuentro.';

  @override
  String get chatSystemAutoTeamsPlayful010V1 =>
      'Que nadie subestime a un equipo silencioso.';

  @override
  String get chatSystemAutoTeamsPlayful011V1 =>
      'Algunos ya celebran. Otros están calculando cómo cambiar de equipo sin que se note.';

  @override
  String get chatSystemAutoTeamsPlayful012V1 =>
      'Resultado publicado. Empieza oficialmente el salseo.';

  @override
  String get chatSystemAutoTeamsPlayful013V1 =>
      'Hay química de equipo… o al menos eso dice la estadística emocional.';

  @override
  String get chatSystemAutoTeamsPlayful014V1 =>
      'Un buen equipo se construye. Uno legendario se presume antes de jugar.';

  @override
  String get chatSystemAutoTeamsPlayful015V1 =>
      'El grupo ya tiene reparto. Ahora falta la épica.';

  @override
  String get chatSystemAutoTeamsPlayful016V1 =>
      'A partir de aquí, cada mensaje puede convertirse en motivación para el rival.';

  @override
  String get chatSystemAutoTeamsPlayful017V1 =>
      'Equipos formados. El orgullo grupal queda activado.';

  @override
  String get chatSystemAutoTeamsPlayful018V1 =>
      'Ya podéis inventar nombre de guerra, aunque Tarci aún no lo guarde.';

  @override
  String get chatSystemAutoTeamsPlayful019V1 =>
      'Que empiece la parte favorita: opinar sobre si el reparto fue justo.';

  @override
  String get chatSystemAutoTeamsPlayful020V1 =>
      'Tarci no toma partido. Pero sí guarda capturas mentales del pique.';

  @override
  String get chatSystemAutoTeamsChallenge001V1 =>
      'Reto del día: cada equipo debe explicar por qué merece ganar.';

  @override
  String get chatSystemAutoTeamsChallenge002V1 =>
      '¿Quién se atreve a lanzar el primer desafío amistoso?';

  @override
  String get chatSystemAutoTeamsChallenge003V1 =>
      'Equipo que no escriba hoy, empieza perdiendo en carisma.';

  @override
  String get chatSystemAutoTeamsChallenge004V1 =>
      'Propongo una norma no oficial: quien más hable, luego tiene que responder.';

  @override
  String get chatSystemAutoTeamsChallenge005V1 =>
      '¿Hay favorito o todavía fingimos humildad?';

  @override
  String get chatSystemAutoTeamsChallenge006V1 =>
      'Dejad constancia aquí: ¿qué equipo se lleva la gloria?';

  @override
  String get chatSystemAutoTeamsChallenge007V1 =>
      'Un reto suave: haced vuestra predicción antes del encuentro.';

  @override
  String get chatSystemAutoTeamsChallenge008V1 =>
      'Si hay confianza, que haya apuestas simbólicas.';

  @override
  String get chatSystemAutoTeamsChallenge009V1 =>
      '¿Qué equipo trae estrategia y cuál trae puro corazón?';

  @override
  String get chatSystemAutoTeamsChallenge010V1 =>
      'Momento de declarar intenciones. El silencio no puntúa.';

  @override
  String get chatSystemAutoTeamsChallenge011V1 =>
      'Que cada equipo nombre a su portavoz espontáneo. Luego negáis haberlo elegido.';

  @override
  String get chatSystemAutoTeamsChallenge012V1 =>
      '¿Quién rompe el hielo con la primera provocación elegante?';

  @override
  String get chatSystemAutoTeamsQuiet001V1 =>
      'Mucho silencio para unos equipos tan prometedores.';

  @override
  String get chatSystemAutoTeamsQuiet002V1 =>
      'Este chat está más tranquilo que un banquillo antes del pitido inicial.';

  @override
  String get chatSystemAutoTeamsQuiet003V1 =>
      '¿Nadie va a comentar el reparto? Sospechoso.';

  @override
  String get chatSystemAutoTeamsQuiet004V1 =>
      'Tarci detecta calma. A veces eso significa estrategia.';

  @override
  String get chatSystemAutoTeamsQuiet005V1 =>
      'Los equipos están hechos. El chat aún espera su primer buen pique.';

  @override
  String get chatSystemAutoTeamsQuiet006V1 =>
      'Un grupo en silencio no es paz: es tensión dramática.';

  @override
  String get chatSystemAutoTeamsQuiet007V1 =>
      '¿Todo el mundo conforme? Esa unanimidad merece revisión.';

  @override
  String get chatSystemAutoTeamsQuiet008V1 =>
      'Silencio táctico activado. Continuad, que queda elegante.';

  @override
  String get chatSystemAutoTeamsCountdown014V1 =>
      'Faltan 14 días. Tiempo de organizarse… o de improvisar con confianza.';

  @override
  String get chatSystemAutoTeamsCountdown007V1 =>
      'Falta una semana. Las estrategias absurdas ya pueden presentarse oficialmente.';

  @override
  String get chatSystemAutoTeamsCountdown003V1 =>
      'Quedan 3 días. A estas alturas la épica está permitida.';

  @override
  String get chatSystemAutoTeamsCountdown001V1 =>
      'Mañana es el día. Última oportunidad para presumir sin consecuencias.';

  @override
  String get chatSystemAutoTeamsCountdown000V1 =>
      'Hoy toca. Equipos listos, nervios opcionales.';

  @override
  String get chatSystemAutoTeamsCountdownExtra001V1 =>
      'Dos semanas parecen mucho hasta que alguien recuerda que no ha preparado nada.';

  @override
  String get chatSystemAutoTeamsCountdownExtra002V1 =>
      'Siete días. Lo suficiente para entrenar o para perfeccionar una buena excusa.';

  @override
  String get chatSystemAutoTeamsCountdownExtra003V1 =>
      'Tres días. El chat puede pasar de bromas a declaraciones oficiales.';

  @override
  String get chatSystemAutoTeamsCountdownExtra004V1 =>
      'Queda un día. Si había un plan secreto, es buen momento para fingir que existe.';

  @override
  String get chatSystemAutoTeamsCountdownExtra005V1 =>
      'Llegó el momento. Que gane el mejor… o el que mejor lo disimule.';

  @override
  String get teamsChatSectionTitle => 'Conversación del grupo';

  @override
  String get teamsChatSectionSubtitle =>
      'Comentad el reparto, retos y el día del encuentro.';

  @override
  String get teamsChatEnterCta => 'Abrir chat';

  @override
  String get chatTeamsCompletedChip => 'Equipos listos';

  @override
  String get chatSystemTeamsCompletedV1 =>
      'Los equipos ya están listos. Ahora sí: que empiece el pique.';

  @override
  String get teamsMemberWaitingTitle => 'Equipos en preparación';

  @override
  String get teamsMemberWaitingBody =>
      'El organizador está preparando el reparto. Cuando los equipos estén listos podrás verlos aquí y entrar al chat del grupo.';

  @override
  String teamsMemberPoolSummary(int count) {
    return '$count participantes en el grupo';
  }

  @override
  String teamsOrganizerByline(String name) {
    return 'Organizado por $name';
  }

  @override
  String get teamsResultActionsTitle => 'Acciones del resultado';

  @override
  String get teamsRenameDialogTitle => 'Renombrar equipo';

  @override
  String get teamsRenameDialogFieldLabel => 'Nombre del equipo';

  @override
  String get teamsRenameSuccess => 'Nombre del equipo actualizado';

  @override
  String get teamsYouInTeam => 'Tú';

  @override
  String get teamsDetailRosterTitle => 'Participantes del grupo';

  @override
  String get dynamicsCardPairingsBody =>
      'Empareja participantes en parejas de dos. Resultado visible para todos.';

  @override
  String get homeDynamicTypePairings => 'Parejas';

  @override
  String get homePairingsStateCompleted => 'Parejas listas';

  @override
  String get homePairingsStatePreparing => 'Preparando parejas';

  @override
  String get pairingsWizardTitle => 'Crear parejas';

  @override
  String get pairingsWizardCreateCta => 'Crear parejas';

  @override
  String get pairingsWizardNameLabel => 'Nombre de la dinámica';

  @override
  String get pairingsWizardOwnerNicknameLabel => 'Tu nombre en las parejas';

  @override
  String get pairingsWizardOwnerNicknameHelper =>
      'Así te verán los demás en el emparejamiento.';

  @override
  String get pairingsWizardEventOptional => 'Fecha del evento (opcional)';

  @override
  String get pairingsWizardPickEventDate => 'Elegir fecha';

  @override
  String get pairingsWizardOwnerParticipatesTitle => '¿Participas tú?';

  @override
  String get pairingsWizardOwnerParticipatesYes =>
      'Sí, quiero estar en una pareja';

  @override
  String get pairingsWizardOwnerParticipatesNo => 'No, solo organizo';

  @override
  String get pairingsWizardReviewTitle => 'Revisión';

  @override
  String get pairingsWizardReviewSummary => 'Parejas de 2 personas';

  @override
  String pairingsUnitLabel(int index) {
    return 'Pareja $index';
  }

  @override
  String get pairingsResultHeroTitle => '¡Parejas listas!';

  @override
  String get pairingsResultHeroSubtitle =>
      'Cada pareja ya tiene a sus dos integrantes.';

  @override
  String pairingsResultSummary(int count, int eligible) {
    return '$count parejas · $eligible participantes';
  }

  @override
  String get pairingsDetailListTitle => 'Parejas';

  @override
  String get pairingsDetailFormCta => 'Formar parejas';

  @override
  String get pairingsDetailConfigTitle => 'Configuración';

  @override
  String pairingsDetailConfigSummary(int count) {
    return 'Aproximadamente $count parejas';
  }

  @override
  String get pairingsRenameDialogTitle => 'Renombrar pareja';

  @override
  String get pairingsRenameDialogFieldLabel => 'Nombre de la pareja';

  @override
  String get pairingsRenameSuccess => 'Nombre de la pareja actualizado';

  @override
  String pairingsShareBody(String groupName, String blocks) {
    return 'Parejas de «$groupName»:\n\n$blocks';
  }

  @override
  String pairingsEmailSubject(String groupName) {
    return 'Parejas: $groupName';
  }

  @override
  String pairingsEmailBody(String groupName, String blocks) {
    return 'Parejas de «$groupName»:\n\n$blocks';
  }

  @override
  String get pairingsPdfHeadline => 'Parejas';

  @override
  String get pairingsChatSectionTitle => 'Conversación del grupo';

  @override
  String get pairingsChatSectionSubtitle =>
      'Comentad el emparejamiento y el día del encuentro.';

  @override
  String get pairingsChatEnterCta => 'Abrir chat';

  @override
  String get chatPairingsCompletedChip => 'Parejas listas';

  @override
  String get chatSystemPairingsCompletedV1 =>
      'Las parejas ya están listas. ¡A disfrutar del encuentro!';

  @override
  String get pairingsMemberWaitingTitle => 'Parejas en preparación';

  @override
  String get pairingsMemberWaitingBody =>
      'El organizador está preparando el emparejamiento. Cuando las parejas estén listas podrás verlas aquí.';

  @override
  String joinSuccessPairingsSubtitle(String groupName) {
    return 'Te uniste a «$groupName».';
  }

  @override
  String get joinSuccessPairingsBody =>
      'Cuando el organizador forme las parejas, podrás ver el resultado aquí.';

  @override
  String get joinSuccessPairingsPrimaryCta => 'Ir a parejas';

  @override
  String get pairingsDetailEvenHint =>
      'Para formar parejas necesitas un número par de participantes elegibles.';

  @override
  String get chatSystemAutoPairingsPlayful001V1 =>
      'Parejas listos. Ya podéis empezar a culpar al algoritmo.';

  @override
  String get chatSystemAutoPairingsPlayful002V1 =>
      '¿Qué pareja viene a ganar y cuál viene por la merienda?';

  @override
  String get chatSystemAutoPairingsPlayful003V1 =>
      'Aquí hay talento… y también mucha confianza. Veremos cuál pesa más.';

  @override
  String get chatSystemAutoPairingsPlayful004V1 =>
      'Se aceptan pronósticos, excusas y teorías conspirativas.';

  @override
  String get chatSystemAutoPairingsPlayful005V1 =>
      'Un emparejamiento justo. Las quejas creativas también cuentan como participación.';

  @override
  String get chatSystemAutoPairingsPlayful006V1 =>
      'No importa quién quede contigo. Importa quién termina pidiendo revancha.';

  @override
  String get chatSystemAutoPairingsPlayful007V1 =>
      'Tarci repartió. Ahora os toca demostrar que no era suerte.';

  @override
  String get chatSystemAutoPairingsPlayful008V1 =>
      'Hay parejas que inspiran respeto y otros que inspiran memes.';

  @override
  String get chatSystemAutoPairingsPlayful009V1 =>
      'El azar habló. La dignidad se resuelve el día del encuentro.';

  @override
  String get chatSystemAutoPairingsPlayful010V1 =>
      'Que nadie subestime a un pareja silencioso.';

  @override
  String get chatSystemAutoPairingsPlayful011V1 =>
      'Algunos ya celebran. Otros están calculando cómo cambiar de pareja sin que se note.';

  @override
  String get chatSystemAutoPairingsPlayful012V1 =>
      'Resultado publicado. Empieza oficialmente el salseo.';

  @override
  String get chatSystemAutoPairingsPlayful013V1 =>
      'Hay química de pareja… o al menos eso dice la estadística emocional.';

  @override
  String get chatSystemAutoPairingsPlayful014V1 =>
      'Un buen pareja se construye. Uno legendario se presume antes de jugar.';

  @override
  String get chatSystemAutoPairingsPlayful015V1 =>
      'El grupo ya tiene emparejamiento. Ahora falta la épica.';

  @override
  String get chatSystemAutoPairingsPlayful016V1 =>
      'A partir de aquí, cada mensaje puede convertirse en motivación para el rival.';

  @override
  String get chatSystemAutoPairingsPlayful017V1 =>
      'Parejas formados. El orgullo grupal queda activado.';

  @override
  String get chatSystemAutoPairingsPlayful018V1 =>
      'Ya podéis inventar nombre de guerra, aunque Tarci aún no lo guarde.';

  @override
  String get chatSystemAutoPairingsPlayful019V1 =>
      'Que empiece la parte favorita: opinar sobre si el emparejamiento fue justo.';

  @override
  String get chatSystemAutoPairingsPlayful020V1 =>
      'Tarci no toma partido. Pero sí guarda capturas mentales del conversación.';

  @override
  String get chatSystemAutoPairingsChallenge001V1 =>
      'Reto del día: cada pareja debe explicar por qué merece ganar.';

  @override
  String get chatSystemAutoPairingsChallenge002V1 =>
      '¿Quién se atreve a lanzar el primer desafío amistoso?';

  @override
  String get chatSystemAutoPairingsChallenge003V1 =>
      'Pareja que no escriba hoy, empieza perdiendo en carisma.';

  @override
  String get chatSystemAutoPairingsChallenge004V1 =>
      'Propongo una norma no oficial: quien más hable, luego tiene que responder.';

  @override
  String get chatSystemAutoPairingsChallenge005V1 =>
      '¿Hay favorito o todavía fingimos humildad?';

  @override
  String get chatSystemAutoPairingsChallenge006V1 =>
      'Dejad constancia aquí: ¿qué pareja se lleva la gloria?';

  @override
  String get chatSystemAutoPairingsChallenge007V1 =>
      'Un reto suave: haced vuestra predicción antes del encuentro.';

  @override
  String get chatSystemAutoPairingsChallenge008V1 =>
      'Si hay confianza, que haya apuestas simbólicas.';

  @override
  String get chatSystemAutoPairingsChallenge009V1 =>
      '¿Qué pareja trae estrategia y cuál trae puro corazón?';

  @override
  String get chatSystemAutoPairingsChallenge010V1 =>
      'Momento de declarar intenciones. El silencio no puntúa.';

  @override
  String get chatSystemAutoPairingsChallenge011V1 =>
      'Que cada pareja nombre a su portavoz espontáneo. Luego negáis haberlo elegido.';

  @override
  String get chatSystemAutoPairingsChallenge012V1 =>
      '¿Quién rompe el hielo con la primera provocación elegante?';

  @override
  String get chatSystemAutoPairingsQuiet001V1 =>
      'Mucho silencio para unos parejas tan prometedores.';

  @override
  String get chatSystemAutoPairingsQuiet002V1 =>
      'Este chat está más tranquilo que un banquillo antes del pitido inicial.';

  @override
  String get chatSystemAutoPairingsQuiet003V1 =>
      '¿Nadie va a comentar el emparejamiento? Sospechoso.';

  @override
  String get chatSystemAutoPairingsQuiet004V1 =>
      'Tarci detecta calma. A veces eso significa estrategia.';

  @override
  String get chatSystemAutoPairingsQuiet005V1 =>
      'Los parejas están hechos. El chat aún espera su primer buen conversación.';

  @override
  String get chatSystemAutoPairingsQuiet006V1 =>
      'Un grupo en silencio no es paz: es tensión dramática.';

  @override
  String get chatSystemAutoPairingsQuiet007V1 =>
      '¿Todo el mundo conforme? Esa unanimidad merece revisión.';

  @override
  String get chatSystemAutoPairingsQuiet008V1 =>
      'Silencio táctico activado. Continuad, que queda elegante.';

  @override
  String get chatSystemAutoPairingsCountdown014V1 =>
      'Faltan 14 días. Tiempo de organizarse… o de improvisar con confianza.';

  @override
  String get chatSystemAutoPairingsCountdown007V1 =>
      'Falta una semana. Las estrategias absurdas ya pueden presentarse oficialmente.';

  @override
  String get chatSystemAutoPairingsCountdown003V1 =>
      'Quedan 3 días. A estas alturas la épica está permitida.';

  @override
  String get chatSystemAutoPairingsCountdown001V1 =>
      'Mañana es el día. Última oportunidad para presumir sin consecuencias.';

  @override
  String get chatSystemAutoPairingsCountdown000V1 =>
      'Hoy toca. Parejas listos, nervios opcionales.';

  @override
  String get chatSystemAutoPairingsCountdownExtra001V1 =>
      'Dos semanas parecen mucho hasta que alguien recuerda que no ha preparado nada.';

  @override
  String get chatSystemAutoPairingsCountdownExtra002V1 =>
      'Siete días. Lo suficiente para entrenar o para perfeccionar una buena excusa.';

  @override
  String get chatSystemAutoPairingsCountdownExtra003V1 =>
      'Tres días. El chat puede pasar de bromas a declaraciones oficiales.';

  @override
  String get chatSystemAutoPairingsCountdownExtra004V1 =>
      'Queda un día. Si había un plan secreto, es buen momento para fingir que existe.';

  @override
  String get chatSystemAutoPairingsCountdownExtra005V1 =>
      'Llegó el momento. Que gane el mejor… o el que mejor lo disimule.';

  @override
  String get chatSystemAutoDuelsPlayful001V1 =>
      'Duelos listos. Ya podéis empezar a culpar al algoritmo.';

  @override
  String get chatSystemAutoDuelsPlayful002V1 =>
      '¿Qué duelo viene a ganar y cuál viene por la merienda?';

  @override
  String get chatSystemAutoDuelsPlayful003V1 =>
      'Aquí hay talento… y también mucha confianza. Veremos cuál pesa más.';

  @override
  String get chatSystemAutoDuelsPlayful004V1 =>
      'Se aceptan pronósticos, excusas y teorías conspirativas.';

  @override
  String get chatSystemAutoDuelsPlayful005V1 =>
      'Un enfrentamiento justo. Las quejas creativas también cuentan como participación.';

  @override
  String get chatSystemAutoDuelsPlayful006V1 =>
      'No importa contra quién te toque. Importa quién pide la revancha.';

  @override
  String get chatSystemAutoDuelsPlayful007V1 =>
      'Tarci repartió. Ahora os toca demostrar que no era suerte.';

  @override
  String get chatSystemAutoDuelsPlayful008V1 =>
      'Hay duelos que inspiran respeto y otros que inspiran memes.';

  @override
  String get chatSystemAutoDuelsPlayful009V1 =>
      'El azar habló. La dignidad se resuelve el día del encuentro.';

  @override
  String get chatSystemAutoDuelsPlayful010V1 =>
      'Que nadie subestime a un duelo silencioso.';

  @override
  String get chatSystemAutoDuelsPlayful011V1 =>
      'Algunos ya celebran. Otros calculan cómo cambiar de rival sin que se note.';

  @override
  String get chatSystemAutoDuelsPlayful012V1 =>
      'Resultado publicado. Empieza oficialmente el salseo.';

  @override
  String get chatSystemAutoDuelsPlayful013V1 =>
      'Hay química de duelo… o al menos eso dice la estadística emocional.';

  @override
  String get chatSystemAutoDuelsPlayful014V1 =>
      'Un buen duelo se construye. Uno legendario se presume antes de jugar.';

  @override
  String get chatSystemAutoDuelsPlayful015V1 =>
      'El grupo ya tiene enfrentamiento. Ahora falta la épica.';

  @override
  String get chatSystemAutoDuelsPlayful016V1 =>
      'A partir de aquí, cada mensaje puede convertirse en motivación para el rival.';

  @override
  String get chatSystemAutoDuelsPlayful017V1 =>
      'Duelos formados. El orgullo grupal queda activado.';

  @override
  String get chatSystemAutoDuelsPlayful018V1 =>
      'Ya podéis inventar nombre de guerra, aunque Tarci aún no lo guarde.';

  @override
  String get chatSystemAutoDuelsPlayful019V1 =>
      'Que empiece la parte favorita: opinar sobre si el enfrentamiento fue justo.';

  @override
  String get chatSystemAutoDuelsPlayful020V1 =>
      'Tarci no toma partido. Pero sí guarda capturas mentales del pique.';

  @override
  String get chatSystemAutoDuelsChallenge001V1 =>
      'Reto del día: cada duelo debe explicar por qué merece ganar.';

  @override
  String get chatSystemAutoDuelsChallenge002V1 =>
      '¿Quién se atreve a lanzar el primer desafío amistoso?';

  @override
  String get chatSystemAutoDuelsChallenge003V1 =>
      'Duelo que no escriba hoy, empieza perdiendo en carisma.';

  @override
  String get chatSystemAutoDuelsChallenge004V1 =>
      'Propongo una norma no oficial: quien más hable, luego tiene que responder.';

  @override
  String get chatSystemAutoDuelsChallenge005V1 =>
      '¿Hay favorito o todavía fingimos humildad?';

  @override
  String get chatSystemAutoDuelsChallenge006V1 =>
      'Dejad constancia aquí: ¿qué duelo se lleva la gloria?';

  @override
  String get chatSystemAutoDuelsChallenge007V1 =>
      'Un reto suave: haced vuestra predicción antes del encuentro.';

  @override
  String get chatSystemAutoDuelsChallenge008V1 =>
      'Si hay confianza, que haya apuestas simbólicas.';

  @override
  String get chatSystemAutoDuelsChallenge009V1 =>
      '¿Qué duelo trae estrategia y cuál trae puro corazón?';

  @override
  String get chatSystemAutoDuelsChallenge010V1 =>
      'Momento de declarar intenciones. El silencio no puntúa.';

  @override
  String get chatSystemAutoDuelsChallenge011V1 =>
      'Que cada duelo nombre a su portavoz espontáneo. Luego negáis haberlo elegido.';

  @override
  String get chatSystemAutoDuelsChallenge012V1 =>
      '¿Quién rompe el hielo con la primera provocación elegante?';

  @override
  String get chatSystemAutoDuelsQuiet001V1 =>
      'Mucho silencio para unos duelos tan prometedores.';

  @override
  String get chatSystemAutoDuelsQuiet002V1 =>
      'Este chat está más tranquilo que un banquillo antes del pitido inicial.';

  @override
  String get chatSystemAutoDuelsQuiet003V1 =>
      '¿Nadie va a comentar el enfrentamiento? Sospechoso.';

  @override
  String get chatSystemAutoDuelsQuiet004V1 =>
      'Tarci detecta calma. A veces eso significa estrategia.';

  @override
  String get chatSystemAutoDuelsQuiet005V1 =>
      'Los duelos están hechos. El chat aún espera su primer buen pique.';

  @override
  String get chatSystemAutoDuelsQuiet006V1 =>
      'Un grupo en silencio no es paz: es tensión dramática.';

  @override
  String get chatSystemAutoDuelsQuiet007V1 =>
      '¿Todo el mundo conforme? Esa unanimidad merece revisión.';

  @override
  String get chatSystemAutoDuelsQuiet008V1 =>
      'Silencio táctico activado. Continuad, que queda elegante.';

  @override
  String get chatSystemAutoDuelsCountdown014V1 =>
      'Faltan 14 días. Tiempo de organizarse… o de improvisar con confianza.';

  @override
  String get chatSystemAutoDuelsCountdown007V1 =>
      'Falta una semana. Las estrategias absurdas ya pueden presentarse oficialmente.';

  @override
  String get chatSystemAutoDuelsCountdown003V1 =>
      'Quedan 3 días. A estas alturas la épica está permitida.';

  @override
  String get chatSystemAutoDuelsCountdown001V1 =>
      'Mañana es el día. Última oportunidad para presumir sin consecuencias.';

  @override
  String get chatSystemAutoDuelsCountdown000V1 =>
      'Hoy toca. Duelos listos, nervios opcionales.';

  @override
  String get chatSystemAutoDuelsCountdownExtra001V1 =>
      'Dos semanas parecen mucho hasta que alguien recuerda que no ha preparado nada.';

  @override
  String get chatSystemAutoDuelsCountdownExtra002V1 =>
      'Siete días. Lo suficiente para entrenar o para perfeccionar una buena excusa.';

  @override
  String get chatSystemAutoDuelsCountdownExtra003V1 =>
      'Tres días. El chat puede pasar de bromas a declaraciones oficiales.';

  @override
  String get chatSystemAutoDuelsCountdownExtra004V1 =>
      'Queda un día. Si había un plan secreto, es buen momento para fingir que existe.';

  @override
  String get chatSystemAutoDuelsCountdownExtra005V1 =>
      'Llegó el momento. Que gane el mejor… o el que mejor lo disimule.';

  @override
  String get dynamicsCardDuelsBody =>
      'Crea enfrentamientos uno contra uno para retos, juegos y dinámicas con más pique.';

  @override
  String get homeDynamicTypeDuels => 'Duelos';

  @override
  String get homeDuelsStateCompleted => 'Duelos listos';

  @override
  String get homeDuelsStatePreparing => 'Preparando duelos';

  @override
  String get duelsWizardTitle => 'Crear duelos';

  @override
  String get duelsWizardCreateCta => 'Crear duelos';

  @override
  String get duelsWizardNameLabel => 'Nombre de la dinámica';

  @override
  String get duelsWizardOwnerNicknameLabel => 'Tu nombre en los duelos';

  @override
  String get duelsWizardOwnerNicknameHelper =>
      'Así te verán los demás en los enfrentamientos.';

  @override
  String get duelsWizardEventOptional => 'Fecha del evento (opcional)';

  @override
  String get duelsWizardPickEventDate => 'Elegir fecha';

  @override
  String get duelsWizardOwnerParticipatesTitle => '¿Participas tú?';

  @override
  String get duelsWizardOwnerParticipatesYes => 'Sí, quiero estar en un duelo';

  @override
  String get duelsWizardOwnerParticipatesNo => 'No, solo organizo';

  @override
  String get duelsWizardReviewTitle => 'Revisión';

  @override
  String get duelsWizardReviewSummary =>
      'Enfrentamientos 1 vs 1 · número par necesario';

  @override
  String duelsUnitLabel(Object index) {
    return 'Duelo $index';
  }

  @override
  String get duelsVsLabel => 'vs';

  @override
  String get duelsResultHeroTitle => '¡Duelos listos!';

  @override
  String get duelsResultHeroSubtitle => 'Ya sabéis quién se enfrenta a quién.';

  @override
  String duelsResultSummary(Object count, Object eligible) {
    return '$count duelos · $eligible participantes';
  }

  @override
  String get duelsDetailListTitle => 'Duelos';

  @override
  String get duelsDetailFormCta => 'Generar duelos';

  @override
  String get duelsDetailConfigTitle => 'Configuración';

  @override
  String duelsDetailConfigSummary(Object count) {
    return 'Aproximadamente $count duelos';
  }

  @override
  String get duelsRenameDialogTitle => 'Renombrar duelo';

  @override
  String get duelsRenameDialogFieldLabel => 'Nombre del duelo';

  @override
  String get duelsRenameSuccess => 'Nombre del duelo actualizado';

  @override
  String duelsShareBody(Object blocks, Object groupName) {
    return '⚔️ Duelos generados en «$groupName»:\n\n$blocks\n\nHecho con Tarci Secret.';
  }

  @override
  String duelsEmailSubject(Object groupName) {
    return 'Duelos generados — $groupName';
  }

  @override
  String duelsEmailBody(Object blocks, Object groupName) {
    return 'Hola,\n\nYa están listos los duelos de «$groupName»:\n\n$blocks\n\nGenerado con Tarci Secret.';
  }

  @override
  String get duelsPdfHeadline => 'Duelos generados';

  @override
  String get duelsChatSectionTitle => 'Conversación del grupo';

  @override
  String get duelsChatSectionSubtitle =>
      'Lanza retos, bromea y calienta el ambiente antes de los duelos.';

  @override
  String get duelsChatEnterCta => 'Abrir chat';

  @override
  String get chatDuelsCompletedChip => 'Duelos listos';

  @override
  String get chatSystemDuelsCompletedV1 =>
      'Los duelos ya están listos. Ahora sí: que empiece el pique.';

  @override
  String get duelsMemberWaitingTitle => 'Duelos en preparación';

  @override
  String get duelsMemberWaitingBody =>
      'Cuando el organizador genere los duelos, podrás ver quién se enfrenta a quién.';

  @override
  String joinSuccessDuelsSubtitle(Object groupName) {
    return 'Te uniste a «$groupName».';
  }

  @override
  String get joinSuccessDuelsBody =>
      'Cuando el organizador genere los duelos, podrás ver quién se enfrenta a quién.';

  @override
  String get joinSuccessDuelsPrimaryCta => 'Ir a duelos';

  @override
  String get duelsDetailMinPoolHint =>
      'Necesitas al menos 2 participantes para generar duelos.';

  @override
  String get duelsDetailEvenHint =>
      'Necesitas un número par de participantes para generar duelos.';
}
