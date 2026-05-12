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
  String get createSecretFriend => 'Crear amigo secreto';

  @override
  String get comingSoonMoreDynamics =>
      'Próximamente: sorteos, equipos, duelos y emparejamientos.';

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
  String get quickModeTitle => 'Modo rápido';

  @override
  String get quickModeDescription =>
      'Puedes empezar sin registrarte. Para conservar tus grupos en varios dispositivos, más adelante podrás crear una cuenta.';

  @override
  String get homeHeaderSubtitle =>
      'Tarci Secret organiza dinámicas privadas de grupo con personas reales.';

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
  String get groupStatusPreparing => 'Tu grupo ya casi está listo';

  @override
  String get groupStatusReadyToDraw => 'Todo listo para el sorteo';

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
  String get groupManagedDialogDeliveryPrinted => 'Impresa';

  @override
  String get groupManagedDialogWhoManagesTitle =>
      '¿Quién gestionará su resultado?';

  @override
  String get groupManagedDialogWhoManagesDesc =>
      'De momento lo gestionarás tú como organizador.';

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
  String get homePrimaryActionsTitle => 'Acciones principales';

  @override
  String get homeComingSoonDescription =>
      'Próximamente: sorteos, equipos, duelos y emparejamientos.';

  @override
  String get homeChipDraws => 'Sorteos';

  @override
  String get homeChipTeams => 'Equipos';

  @override
  String get homeChipPairings => 'Emparejamientos';

  @override
  String get homeActiveGroupsTitle => 'Grupos activos';

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
  String get homeCompletedGroupsTitle => 'Grupos completados';

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
  String get groupTooltipEditGroupName => 'Editar nombre del grupo';

  @override
  String get groupStatusCompletedInfo =>
      'Cada persona ya puede ver a quién le toca regalar.';

  @override
  String get groupStatusReadyInfo =>
      'Cuando lances el sorteo, cada uno descubrirá su amigo secreto en privado.';

  @override
  String get groupStatusPendingInfo =>
      'Añade un poco más de gente o termina de organizar tus subgrupos.';

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
  String get groupBackToDashboard => 'Volver al dashboard';

  @override
  String get groupLoadingDetail => 'Cargando grupo...';

  @override
  String get groupErrorTitle => 'No pudimos abrir este grupo';

  @override
  String get groupErrorNotFound =>
      'Este grupo ya no está disponible o no tienes acceso.';

  @override
  String get groupPreparationTitle => 'Cómo va tu grupo';

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
  String get groupManagedDialogDeliveryWhatsapp => 'WhatsApp';

  @override
  String get groupManagedDialogDeliveryShowInPerson => 'Mostrar en persona';

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
}
