// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Tarci Secret';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Seguindo';

  @override
  String get create => 'Criar';

  @override
  String get close => 'Fechar';

  @override
  String get save => 'Manter';

  @override
  String get goToGroup => 'Ir para o grupo';

  @override
  String get copyCode => 'Copiar código';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get joinWithCode => 'Junte-se com código';

  @override
  String get joinScreenTitle => 'Junte-se com código';

  @override
  String get joinScreenHeroTitle => 'Cole seu código de convite';

  @override
  String get joinScreenHeroSubtitle =>
      'Seu organizador compartilhou com você por mensagem. Quando você entrar, nos juntaremos a você no grupo deles.';

  @override
  String get joinScreenCodeLabel => 'código de convite';

  @override
  String get joinScreenCodeHint => 'Por exemplo, AB12CD';

  @override
  String get joinScreenCodeHelper =>
      'A capitalização não importa, nós consertaremos para você.';

  @override
  String get joinScreenCodeRequired =>
      'Cole ou digite o código que você recebeu.';

  @override
  String get joinScreenCodeTooShort =>
      'Esse código parece incompleto. Verifique e tente novamente.';

  @override
  String get joinScreenNicknameLabel => 'seu nome';

  @override
  String get joinScreenNicknameHelper => 'É assim que o grupo verá você.';

  @override
  String get joinScreenNicknameRequired =>
      'Diga-nos o seu nome para se apresentar ao grupo.';

  @override
  String get joinScreenNicknameTooShort =>
      'Digite pelo menos 3 letras para que o grupo reconheça você.';

  @override
  String get joinScreenCta => 'Junte-se ao grupo';

  @override
  String get joinScreenCtaLoading => 'Juntando-se a você…';

  @override
  String get joinScreenSuccessSnackbar => 'Você está dentro!';

  @override
  String get joinSuccessTitle => 'Você já está dentro!';

  @override
  String joinSuccessSubtitle(String groupName) {
    return 'você se juntou$groupName. Em um momento você poderá ver o resto do grupo.';
  }

  @override
  String get joinSuccessChooseSubgroupTitle => 'Escolha sua casa ou equipe';

  @override
  String get joinSuccessChooseSubgroupHelp =>
      'O organizador criou casas ou equipes. Escolha o seu para que o sorteio te posicione bem.';

  @override
  String get joinSuccessSubgroupLabel => 'Sua casa ou equipe';

  @override
  String get joinSuccessNoSubgroupsTitle => 'Ainda não há casas ou equipes';

  @override
  String get joinSuccessNoSubgroupsHelp =>
      'O organizador ainda não os criou. Você pode ir em frente e esperar; Você não precisa fazer mais nada por enquanto.';

  @override
  String get joinSuccessChooseRequired => 'Escolha uma opção para continuar.';

  @override
  String get joinSuccessPrimaryCta => 'Ir para o grupo';

  @override
  String get joinSuccessSecondaryCta => 'fique aqui';

  @override
  String joinSuccessRaffleSubtitle(String groupName) {
    return 'Entraste em $groupName. Quando o organizador fizer o sorteio, poderás ver o resultado aqui.';
  }

  @override
  String get joinSuccessRaffleBody =>
      'Entretanto podes ver quem participa e esperar pelo momento do sorteio.';

  @override
  String get joinSuccessRafflePrimaryCta => 'Ir ao sorteio';

  @override
  String get createSecretFriend => 'Criar amigo secreto';

  @override
  String get comingSoonMoreDynamics =>
      'Em breve: sorteios, times, duelos e pareamentos.';

  @override
  String get mySecretFriend => 'meu amigo secreto';

  @override
  String get yourSecretFriendIs => 'Seu amigo secreto é…';

  @override
  String get onlyYouCanSeeAssignment => 'Somente você pode ver esta tarefa.';

  @override
  String get keepSecretUntilExchangeDay =>
      'Guarde o segredo até o dia da troca.';

  @override
  String get managedSecrets => 'Segredos que você gerencia';

  @override
  String get guardianOfSecret => 'Guardião do segredo';

  @override
  String get privateResult => 'Resultado privado';

  @override
  String get splashTagline =>
      'Tarci Secret organiza dinâmicas de grupo privadas com pessoas reais.';

  @override
  String get splashLoadingHint => 'Preparando tudo para você…';

  @override
  String get splashBootBrandedHint => 'A preparar o teu espaço…';

  @override
  String get productAuthorshipLine => 'Tarci Secret · © 2026 Stalin Yamarte';

  @override
  String get aboutScreenTitle => 'Sobre o Tarci Secret';

  @override
  String get aboutTooltip => 'Sobre o Tarci Secret';

  @override
  String get aboutTagline =>
      'Dinâmicas de grupo, sorteios e experiências sociais com privacidade, emoção e pessoas reais.';

  @override
  String get aboutSectionWhatTitle => 'O que é o Tarci Secret';

  @override
  String get aboutSectionWhatBody =>
      'O Tarci Secret é uma app criada para organizar amigo secreto, sorteios e dinâmicas de grupo de forma simples, privada e divertida. Inclui pessoas reais: crianças, familiares sem telemóvel ou participantes geridos por um adulto.\n\nO Tarci Secret nasce com o amigo secreto como primeira experiência e está pensado para crescer para novas dinâmicas sociais, sorteios, equipas, duelos e emparelhamentos.';

  @override
  String get aboutSectionHowTitle => 'Como funciona';

  @override
  String get aboutStep1Title => 'Cria ou entra num grupo';

  @override
  String get aboutStep1Body =>
      'Começa uma dinâmica ou entra com um código de convite.';

  @override
  String get aboutStep2Title => 'Organiza participantes e regras';

  @override
  String get aboutStep2Body =>
      'Adiciona pessoas com app ou geridas e ajusta o tipo de sorteio.';

  @override
  String get aboutStep3Title => 'Lança a dinâmica ou o sorteio';

  @override
  String get aboutStep3Body =>
      'Quando o grupo estiver pronto, o organizador executa o sorteio em privado.';

  @override
  String get aboutStep4Title => 'Descobre, conversa e diverte-te';

  @override
  String get aboutStep4Body =>
      'Cada pessoa vê o seu resultado em privado e o grupo pode continuar a experiência.';

  @override
  String get aboutSectionPrivacyTitle => 'Privacidade por desenho';

  @override
  String get aboutSectionPrivacyBody =>
      'Cada pessoa vê apenas o que precisa de ver. Num amigo secreto, as atribuições são protegidas para que o resultado continue privado.';

  @override
  String get aboutSectionPrivacyTrust =>
      'A app prioriza a clareza, a confiança e o respeito pela experiência do grupo.';

  @override
  String get aboutSectionCreatorTitle => 'Criado por Stalin Yamarte';

  @override
  String get aboutSectionCreatorSubtitle =>
      'Especialista em Sistemas e desenvolvedor de aplicações.';

  @override
  String get aboutLinkedInCta => 'Ver perfil no LinkedIn';

  @override
  String get aboutLinkedInError =>
      'Não foi possível abrir o LinkedIn. Tenta no navegador.';

  @override
  String get aboutAppInfoTitle => 'Informações da app';

  @override
  String get aboutCopyrightLine => '© 2026 Stalin Yamarte';

  @override
  String get aboutPackageInfoError => 'Não foi possível ler a versão da app.';

  @override
  String aboutBuildLine(String buildNumber) {
    return 'Compilação interna $buildNumber';
  }

  @override
  String get quickModeTitle => 'Modo rápido';

  @override
  String get quickModeDescription =>
      'Você pode começar sem se registrar. Para manter seus grupos em vários dispositivos, você pode criar uma conta posteriormente.';

  @override
  String get homeHeaderSubtitle =>
      'Organize amigos secretos e brindes com quem você quiser. Privado por padrão.';

  @override
  String get homeHeroHeadline => 'Brindes para amigos secretos e grupos';

  @override
  String get homeGroupDrawStatePreparing => 'Preparando';

  @override
  String get homeGroupDrawStateReady => 'Pronto para desenhar';

  @override
  String get homeGroupDrawStateDrawing => 'Sorteio em andamento';

  @override
  String get homeGroupDrawStateCompleted => 'Retirou';

  @override
  String get homeGroupDrawStateFailed => 'Revise o sorteio';

  @override
  String get wizardCreateTitle => 'Criar amigo secreto';

  @override
  String wizardStepOf(int current, int total) {
    return 'Aprovado${current}de$total';
  }

  @override
  String get wizardStepNameTitle => 'Qual é o nome desse amigo secreto?';

  @override
  String get wizardStepGroupTypeTitle => 'Que tipo de grupo é?';

  @override
  String get wizardStepModeTitle => 'Como será organizado?';

  @override
  String get wizardStepRuleTitle => 'Escolha a regra do sorteio';

  @override
  String get wizardStepSubgroupsTitle => 'Subgrupos';

  @override
  String get wizardStepParticipantsTitle => 'Participantes';

  @override
  String get wizardStepEventDateTitle => 'Quando é a troca?';

  @override
  String get wizardStepEventDateHelp =>
      'É opcional. Isso nos ajudará a lembrar a entrega e a levar o grupo à história quando ela acontecer.';

  @override
  String get wizardSummaryEventDate => 'Data do evento';

  @override
  String get wizardEventDateNotSet => 'Indefinido';

  @override
  String get wizardEventDateClear => 'Remover data';

  @override
  String get wizardStepReviewTitle => 'Revisão final';

  @override
  String get wizardGroupNameLabel => 'Nome do grupo';

  @override
  String get wizardGroupNameHint => 'Natal em Família 2026';

  @override
  String get wizardNicknameLabel => 'Como você aparece?';

  @override
  String get wizardRuleIgnore => 'Ignorar subgrupos';

  @override
  String get wizardRulePrefer => 'Prefira subgrupo diferente';

  @override
  String get wizardRuleRequire => 'Exigir subgrupo diferente';

  @override
  String get wizardRuleIgnoreDesc => 'Sorteio normal.';

  @override
  String get wizardRulePreferDesc =>
      'Tente atravessar casas, apartamentos ou grupos.';

  @override
  String get wizardRuleRequireDesc =>
      'Permitir apenas pessoas de subgrupos diferentes.';

  @override
  String get wizardReviewSaveNotice =>
      'Você pode ajustar participantes e subgrupos posteriormente.';

  @override
  String get wizardReviewSummaryHelp =>
      'Verifique se tudo está correto antes de continuar.';

  @override
  String get wizardCreateButton => 'Criar amigo secreto';

  @override
  String get wizardCreatedTitle => 'Amigo secreto criado';

  @override
  String get wizardInviteCodeLabel => 'código de convite';

  @override
  String get wizardInviteCodeDescription =>
      'Compartilhe este código para que outras pessoas possam participar.';

  @override
  String get managedSubtitle =>
      'Esses resultados são de pessoas que dependem de você. Entregue-os a eles em particular.';

  @override
  String get managedEmptyTitle => 'Você não tem segredos gerenciados';

  @override
  String get managedEmptyMessage =>
      'Ao gerenciar uma criança ou pessoa sem um aplicativo, você verá os resultados aqui.';

  @override
  String get managedLoadErrorTitle =>
      'Não foi possível carregar seus segredos gerenciados';

  @override
  String get managedLoadErrorMessage =>
      'Tente novamente em alguns minutos. Você verá apenas os resultados das pessoas que você gerencia.';

  @override
  String get managedAssignedTo => 'É a sua vez de dar...';

  @override
  String get managedDeliverInPrivate =>
      'Entregue este resultado de forma privada';

  @override
  String get managedHeroTitle => 'Segredos à sua disposição';

  @override
  String get managedHeroSubtitle =>
      'Você entrega esses resultados de forma privada, sem que ninguém descubra.';

  @override
  String get wishlistGroupMyCardTitle => 'Sua lista de desejos';

  @override
  String get wishlistGroupMyCardSubtitle =>
      'Você completa; Somente quem for sua vez de dar verá.';

  @override
  String get wishlistGroupMyCardCtaFill => 'Completar minha lista';

  @override
  String get wishlistGroupMyCardCtaEdit => 'Editar minha lista';

  @override
  String get wishlistGroupMyEmptyHint => 'Você ainda não adicionou ideias.';

  @override
  String get wishlistGroupMyReadyChip => 'Lista pronta';

  @override
  String get wishlistGroupManagedSectionTitle => 'Listas que você gerencia';

  @override
  String get wishlistGroupManagedSectionSubtitle =>
      'Ajude a preenchê-los; Quem os der os verá em sua própria tela.';

  @override
  String get wishlistGroupManagedRowCta => 'Editar lista';

  @override
  String get wishlistGroupPostDrawIntro =>
      'Agora que o sorteio terminou, algumas dicas claras ajudam você a acertar o presente.';

  @override
  String get wishlistEditorTitle => 'Lista de desejos';

  @override
  String get wishlistViewTitle => 'Ideias para presentes';

  @override
  String get wishlistEditorIntro =>
      'Escreva com carinho o que você gostaria de receber. Somente quem for sua vez de dar (e você) verá.';

  @override
  String get wishlistViewIntro =>
      'Essas ideias são apenas para ajudar no presente. Respeite o segredo do sorteio.';

  @override
  String get wishlistFieldWishTitle => 'eu ficaria animado...';

  @override
  String get wishlistFieldWishHint =>
      'Idéias, tamanhos ou detalhes específicos para presentes que você gostaria.';

  @override
  String get wishlistFieldLikesTitle => 'Eu gosto disso…';

  @override
  String get wishlistFieldLikesHint =>
      'Hobbies, cores, estilos ou coisas que você ama.';

  @override
  String get wishlistFieldAvoidTitle => 'Melhor evitar…';

  @override
  String get wishlistFieldAvoidHint =>
      'Coisas que você prefere não receber ou que já possui.';

  @override
  String get wishlistFieldLinksTitle => 'Links de inspiração';

  @override
  String wishlistLinksHelp(int max) {
    return 'Até${max}links com http ou https.';
  }

  @override
  String get wishlistAddLinkCta => 'Adicionar link';

  @override
  String get wishlistLinkLabelOptional => 'Etiqueta (opcional)';

  @override
  String get wishlistLinkUrlLabel => 'URL';

  @override
  String get wishlistUrlHint => 'https://…';

  @override
  String wishlistLinkRowTitle(int index) {
    return 'Link$index';
  }

  @override
  String get wishlistSaveCta => 'Manter';

  @override
  String get wishlistCancelCta => 'Retornar';

  @override
  String get wishlistSaveSuccess => 'Lista salva.';

  @override
  String get wishlistUrlInvalid =>
      'Verifique os URLs: eles devem começar com http:// ou https://';

  @override
  String wishlistLinksMax(int max) {
    return 'No máximo${max}links.';
  }

  @override
  String wishlistMyAssignmentReceiverWishlistHeading(String receiverName) {
    return 'O que você gostaria de receber?$receiverName';
  }

  @override
  String get wishlistMyAssignmentReceiverNameFallback => 'seu destinatário';

  @override
  String get wishlistMyAssignmentSectionSubtitle =>
      'Só você vê isso. Serve para inspirar você na hora de escolher um detalhe com amor.';

  @override
  String get wishlistMyAssignmentViewCta => 'Veja ideias de presentes';

  @override
  String get wishlistManagedViewReceiverCta => 'Ver lista de desejos';

  @override
  String get wishlistManagedViewReceiverHint =>
      'Você só vê as ideias dessa pessoa para esse segredo.';

  @override
  String get wishlistEmptyReceiverTitle => 'Ainda não há ideias de presentes';

  @override
  String get wishlistEmptyReceiverBody =>
      'Talvez eu os adicione mais tarde. Um detalhe feito com amor sempre conta!';

  @override
  String get wishlistLinkOpenError => 'O link não pôde ser aberto.';

  @override
  String get wishlistReadonlySheetTitle => 'Ideias para presentes';

  @override
  String get managedRevealLabel => 'Seu amigo secreto é';

  @override
  String get managedDeliveryChipLabel => 'Entrega';

  @override
  String get managedFooterPrivacyNote =>
      'Todo segredo é privado. Só você pode ver e só você entregá-lo.';

  @override
  String get myAssignmentNotAvailableTitle =>
      'Você ainda não consegue ver seu amigo secreto';

  @override
  String get myAssignmentNotAvailableMessage =>
      'Sua tarefa ainda não está disponível. Quando o sorteio estiver concluído, você poderá vê-lo aqui.';

  @override
  String get genericLoadErrorMessage =>
      'Não foi possível carregar essas informações neste momento.';

  @override
  String get backToGroup => 'Voltar ao grupo';

  @override
  String get groupDetailTitle => 'Detalhe do grupo';

  @override
  String get groupRoleLabel => 'Papel';

  @override
  String get groupStatusLabel => 'Estado';

  @override
  String get groupLastExecution => 'Durar';

  @override
  String get groupSectionStatus => 'Status do grupo';

  @override
  String get groupSectionPrimaryAction => 'ação principal';

  @override
  String get groupSectionDrawRule => 'Regra de sorteio';

  @override
  String get groupSectionSubgroups => 'Subgrupos';

  @override
  String get groupSectionParticipants => 'Participantes';

  @override
  String get groupSectionManagedParticipants => 'Participantes sem aplicativo';

  @override
  String get groupSectionInvitations => 'Convites';

  @override
  String get groupSectionAdvanced => 'Configurações avançadas';

  @override
  String get groupStatusPreparing => 'Acompanhe o preparo';

  @override
  String get groupStatusReadyToDraw => 'Pronto para desenhar';

  @override
  String get groupStatusCompleted =>
      'Seus amigos secretos já foram escolhidos!';

  @override
  String get groupStatusMissingSubgroups =>
      'Você precisa colocar alguém em seu grupo';

  @override
  String get groupActionRunDraw => 'Faça o sorteio agora';

  @override
  String get groupActionViewMySecretFriend => 'Veja meu amigo secreto';

  @override
  String get groupActionManagedSecrets => 'Segredos que você gerencia';

  @override
  String get groupActionCreateSubgroup => 'Criar subgrupo';

  @override
  String get groupActionEmptySubgroup => 'Subgrupo vazio';

  @override
  String get groupActionDeleteSubgroup => 'Excluir subgrupo';

  @override
  String get groupActionGenerateNewCode => 'Gerar novo código';

  @override
  String get groupActionCopyCode => 'Copiar código';

  @override
  String get groupActionRename => 'Renomear';

  @override
  String get groupActionEdit => 'Editar';

  @override
  String get groupRoleOrganizer => 'Organizador';

  @override
  String get groupRoleParticipant => 'Participante';

  @override
  String get groupTypeAdultNoApp => 'Adulto sem aplicativo';

  @override
  String get groupTypeChildManaged => 'filho gerenciado';

  @override
  String get groupNoSubgroupAssigned => 'Nenhum subgrupo atribuído';

  @override
  String get groupGuardianOfSecret => 'Guardião do segredo';

  @override
  String get groupPrivateResult => 'Resultado privado';

  @override
  String get groupWarningMissingSubgroupTitle =>
      'Faltam pessoas para atribuir a um subgrupo.';

  @override
  String get groupWarningMissingSubgroupRule =>
      'Para exigir um subgrupo diferente, todos devem ter um.';

  @override
  String get groupWarningMissingSubgroupCombined =>
      'Faltam pessoas para atribuir a um subgrupo. Para exigir um subgrupo diferente, todos devem ter um.';

  @override
  String get groupDialogDeleteSubgroupTitle => 'Excluir subgrupo';

  @override
  String groupDialogDeleteSubgroupBody(String name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Só será excluído se você não tiver participantes atribuídos.';
  }

  @override
  String groupDialogEmptySubgroupTitle(String name) {
    return 'Vazio \"$name\"';
  }

  @override
  String get groupDialogCancel => 'Cancelar';

  @override
  String get groupDialogDelete => 'Eliminar';

  @override
  String get groupDialogEmpty => 'Vazio';

  @override
  String get groupDialogMoveAndDelete => 'Mover e excluir';

  @override
  String get groupDialogMoveToSubgroup => 'Mover para outro subgrupo';

  @override
  String get groupDialogBeforeDeleteMoveTo => 'Antes de excluir, vá para';

  @override
  String get groupDialogLeaveWithoutSubgroup => 'Sair sem subgrupo';

  @override
  String get groupDialogNoAlternativeSubgroup =>
      'Nenhum outro subgrupo disponível. Eles ficarão sem um subgrupo.';

  @override
  String get groupManagedDialogAddTitle =>
      'Adicionar participante sem aplicativo';

  @override
  String get groupManagedDialogEditTitle =>
      'Editar participante sem aplicativo';

  @override
  String get groupManagedDialogNameLabel => 'Nome';

  @override
  String get groupManagedDialogTypeLabel => 'Cara';

  @override
  String get groupManagedDialogTypeAdultNoApp => 'Adulto sem aplicativo';

  @override
  String get groupManagedDialogTypeChild => 'filho gerenciado';

  @override
  String get groupManagedDialogSubgroupOptionalLabel => 'Subgrupo (opcional)';

  @override
  String get groupManagedDialogNoSubgroup => 'Nenhum subgrupo';

  @override
  String get groupManagedDialogDeliveryLabel => 'Método de entrega';

  @override
  String get groupManagedDialogDeliveryVerbal => 'Verbal';

  @override
  String get groupManagedDialogDeliveryEmail => 'Correspondência';

  @override
  String get groupManagedDialogDeliveryWhatsapp => 'WhatsApp';

  @override
  String get groupManagedDialogDeliveryPrinted => 'Impresso/PDF';

  @override
  String get groupManagedDialogWhoManagesTitle =>
      'Quem administrará seu resultado?';

  @override
  String get groupManagedDialogWhoManagesDesc =>
      'Escolha quem verá o resultado no aplicativo para que você possa entregá-lo de forma privada.';

  @override
  String get groupManagedDialogWhoManagesHelp =>
      'Ao participar do sorteio, essa pessoa não verá o resultado no aplicativo. Você pode entregá-lo verbalmente ou por escrito.';

  @override
  String groupManagedDialogManagedBy(String name) {
    return 'Gerenciado por:$name';
  }

  @override
  String get groupAssignDialogSelfTitle => 'Seu subgrupo';

  @override
  String get groupAssignDialogTitle => 'Atribuir subgrupo';

  @override
  String get groupAssignDialogSelfDesc =>
      'Escolha sua casa, apartamento, turma ou equipe.';

  @override
  String get groupAssignDialogDesc => 'Selecione o subgrupo para este membro.';

  @override
  String get groupAssignDialogSubgroupLabel => 'Subgrupo';

  @override
  String get groupSnackbarWriteName => 'Escreva um nome';

  @override
  String get groupSnackbarDrawCompleted => 'Sorteio concluído';

  @override
  String get groupSnackbarSubgroupUpdated => 'Subgrupo atualizado';

  @override
  String get groupSnackbarGroupNameUpdated => 'Nome do grupo atualizado';

  @override
  String get groupSnackbarRuleUpdated => 'Regra de sorteio atualizada';

  @override
  String get groupSnackbarNewCodeGenerated => 'Novo código gerado';

  @override
  String get groupSnackbarManagedAdded =>
      'Participante sem aplicativo adicionado';

  @override
  String get groupSnackbarManagedUpdated => 'Participante sem app atualizado';

  @override
  String get groupSnackbarManagedDeleted => 'Participante sem app eliminado';

  @override
  String get groupDialogEditGroupNameTitle => 'Editar nome do grupo';

  @override
  String get groupDialogGroupNameLabel => 'Nome do grupo';

  @override
  String get groupDialogRenameSubgroupTitle => 'Renomear subgrupo';

  @override
  String get groupDialogSubgroupNameLabel => 'Nome do subgrupo';

  @override
  String get groupDialogDeleteParticipantTitle => 'Excluir participante';

  @override
  String groupDialogDeleteParticipantBody(String name) {
    return 'Tem certeza de que deseja eliminar \"$name\"?';
  }

  @override
  String groupDialogSubgroupAssignedCount(int count) {
    return 'Há${count}participantes atribuídos a este subgrupo.';
  }

  @override
  String groupDialogSubgroupAssignedCountDelete(int count) {
    return 'Este subgrupo tem${count}participantes designados.';
  }

  @override
  String get languageSystem => 'Sistema';

  @override
  String get languageSpanish => 'Espanhol';

  @override
  String get languageEnglish => 'Inglês';

  @override
  String get languageSelectorTitle => 'Linguagem';

  @override
  String get languageSelectorSubtitle =>
      'Escolha como você deseja visualizar o aplicativo';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageItalian => 'italiano';

  @override
  String get languageFrench => 'Francês';

  @override
  String get functionsErrorAlreadyMember => 'Você já pertence a este grupo.';

  @override
  String get functionsErrorCodeNotFound =>
      'Não encontramos um grupo com esse código.';

  @override
  String get functionsErrorCodeExpired => 'Este código expirou.';

  @override
  String get functionsErrorGroupArchived => 'Este grupo está fechado.';

  @override
  String get functionsErrorUserRemoved =>
      'Você não pode ingressar neste grupo novamente.';

  @override
  String get functionsErrorDrawInProgress =>
      'O sorteio está em andamento. Por favor, tente novamente mais tarde.';

  @override
  String get functionsErrorDrawAlreadyCompleted =>
      'Este sorteio já havia sido concluído.';

  @override
  String get functionsErrorDrawCompletedInvitesClosed =>
      'Este sorteio já foi realizado e não aceita mais novos participantes.';

  @override
  String get functionsErrorSubgroupInUse =>
      'Antes de excluir este subgrupo, mova ou deixe seus participantes sem subgrupo.';

  @override
  String get functionsErrorSubgroupNotFound =>
      'O subgrupo não existe mais ou foi excluído.';

  @override
  String get functionsErrorNotOwner =>
      'Somente o organizador pode realizar esta ação.';

  @override
  String get functionsErrorGroupDeleteForbidden =>
      'Somente o organizador pode excluir este grupo.';

  @override
  String get functionsErrorGroupDeleteFailed =>
      'Não conseguimos eliminar o grupo completamente. Tente novamente ou verifique sua conexão.';

  @override
  String get functionsErrorDrawLocked =>
      'Você não pode modificar subgrupos ou participantes enquanto o sorteio estiver em andamento ou concluído.';

  @override
  String get functionsErrorGenericAction =>
      'A ação não pôde ser concluída. Por favor, tente novamente em alguns instantes.';

  @override
  String get functionsErrorPermissionDeniedDrawRule =>
      'A regra do sorteio não pôde ser alterada. Verifique se o sorteio não está em andamento ou concluído.';

  @override
  String get functionsErrorUnknown =>
      'Algo deu errado. Por favor, tente novamente em alguns instantes.';

  @override
  String get functionsErrorDebugSession =>
      'A ação não pôde ser concluída. Verifique se você está usando emuladores ou Firebase real, se as Functions estão implantadas e se a sessão está ativa.';

  @override
  String get homePrimaryActionsTitle => 'Principais ações';

  @override
  String get homeComingSoonDescription =>
      'Em breve: sorteios, times, duelos e pareamentos.';

  @override
  String get homeChipDraws => 'Brindes';

  @override
  String get homeChipTeams => 'Equipes';

  @override
  String get homeChipPairings => 'Emparelhamentos';

  @override
  String get homeActiveGroupsTitle => 'Em andamento';

  @override
  String get homeActiveGroupsSubtitle =>
      'Pendente de preparação ou sorteio; ou sorteio realizado com entrega hoje ou futura, ou sem data de entrega definida.';

  @override
  String get homeActiveGroupsEmpty => 'Você não tem grupos nesta seção.';

  @override
  String homeDeliveryDateLine(String date) {
    return 'Entrega:$date';
  }

  @override
  String homeDrawDateLine(String date) {
    return 'Loteria:$date';
  }

  @override
  String get homeEmptyGroupsTitle => 'Você ainda não tem grupos';

  @override
  String get homeEmptyGroupsMessage =>
      'Crie seu primeiro amigo secreto ou cadastre-se com um código.';

  @override
  String get homeStatusActive => 'Ativo';

  @override
  String get homeStatusInactive => 'Parado';

  @override
  String get homeCompletedGroupsTitle => 'Sorteios finalizados';

  @override
  String get homeCompletedGroupsSubtitle =>
      'Sorteio realizado e data de entrega já passada.';

  @override
  String get homePastGroupsTitle => 'Grupos anteriores';

  @override
  String get homePastGroupsSubtitle =>
      'Você não está mais ativamente envolvido nesses grupos.';

  @override
  String get homeCompletedArchivedLabel => 'Concluído/arquivado';

  @override
  String get homeDebugToolsTitle => 'Ferramentas de desenvolvimento';

  @override
  String homeDebugUid(String uid) {
    return 'UID de teste:$uid';
  }

  @override
  String get homeDebugUserSwitchHint =>
      'A alteração dos usuários de teste fará com que você veja outros grupos, pois cada usuário tem sua própria lista.';

  @override
  String get homeDebugResetUser => 'Sair e criar novo usuário de teste';

  @override
  String get homeEnvironmentEmulator => 'Ambiente: emulador local';

  @override
  String get homeEnvironmentFirebase => 'Ambiente: Firebase real dev';

  @override
  String get homePrivacyFooter =>
      'Sua tarefa e resultados são mantidos privados por padrão.';

  @override
  String get wizardTypeFamily => 'Família';

  @override
  String get wizardTypeFriends => 'Amigos';

  @override
  String get wizardTypeCompany => 'Empresa';

  @override
  String get wizardTypeClass => 'Aula';

  @override
  String get wizardTypeOther => 'Outro';

  @override
  String get wizardModeInPerson => 'Pessoalmente';

  @override
  String get wizardModeRemote => 'Remoto';

  @override
  String get wizardModeMixed => 'Misturado';

  @override
  String get wizardCreateFunctionsError =>
      'Não foi possível criar o grupo. Verifique se você está usando emuladores ou Firebase real e se o Functions está implantado.';

  @override
  String get wizardNameHelp => 'Dê um nome que identifique o grupo.';

  @override
  String get wizardGroupTypeHelp =>
      'Essas informações orientam a experiência. Por enquanto não está salvo.';

  @override
  String get wizardModeHelp =>
      'Defina como o grupo será organizado. Por enquanto é preparação para UX.';

  @override
  String get wizardRuleHelp => 'Esta configuração é salva no grupo.';

  @override
  String get wizardSubgroupsHelpIgnore =>
      'Com esta regra você não precisa de subgrupos agora.';

  @override
  String get wizardSubgroupsHelpEnabled =>
      'Você poderá criar e atribuir subgrupos a partir dos detalhes do grupo.';

  @override
  String get wizardParticipantsHelp =>
      'Depois você pode convidar por código e adicionar pessoas sem aplicativo.';

  @override
  String get wizardSummaryName => 'Nome';

  @override
  String get wizardSummaryGroupType => 'Tipo de grupo';

  @override
  String get wizardSummaryMode => 'Modo';

  @override
  String get wizardSummaryRule => 'Regra de sorteio';

  @override
  String get groupRoleAdmin => 'Administrador';

  @override
  String get groupRoleMember => 'Membro';

  @override
  String get groupRuleIgnoreTitle => 'Ignorar subgrupos';

  @override
  String get groupRulePreferTitle => 'Prefira subgrupo diferente';

  @override
  String get groupRuleRequireTitle => 'Exigir subgrupo diferente';

  @override
  String get groupRuleIgnoreDescription =>
      'Sorteio normal. Não leva em conta casas, apartamentos ou classes.';

  @override
  String get groupRulePreferDescription =>
      'Tarci Secret tentará combinar presentes entre diferentes subgrupos, mas não bloqueará o sorteio se isso não for possível.';

  @override
  String get groupRuleRequireDescription =>
      'Ninguém poderá dar de presente alguém do mesmo subgrupo. Poderá falhar se o grupo não permitir uma adesão válida.';

  @override
  String get groupSnackNeedThreeParticipants =>
      'Você precisa de pelo menos 3 participantes eficazes para ter um sorteio divertido.';

  @override
  String get groupSnackDrawAlreadyRunningOrDone =>
      'Um novo sorteio não pode ser realizado enquanto estiver em andamento ou concluído.';

  @override
  String get groupSnackCannotAddAfterDraw =>
      'Você não pode adicionar participantes após realizar o sorteio.';

  @override
  String get groupDeleteOwnerSectionTitle => 'Opções do grupo';

  @override
  String get groupDeleteOwnerSectionHint =>
      'Só o organizador pode encerrar esta dinâmica e apagar todos os dados do grupo.';

  @override
  String get groupDeleteEntryCta => 'Eliminar grupo';

  @override
  String get groupDeleteDialogPreTitle => 'Eliminar este grupo?';

  @override
  String get groupDeleteDialogPreBody =>
      'Serão apagadas a configuração, participantes, convites e dados associados. Esta ação não pode ser desfeita.';

  @override
  String get groupDeleteDialogPreConfirm => 'Eliminar grupo';

  @override
  String get groupDeleteDialogPostTitle => 'Eliminar este amigo secreto?';

  @override
  String get groupDeleteDialogPostBody =>
      'O sorteio já foi feito. Se continuar, todos perdem acesso aos resultados, listas de desejos, conversa do grupo e dados associados. Esta ação não pode ser desfeita.';

  @override
  String get groupDeleteDialogPostConfirm => 'Eliminar definitivamente';

  @override
  String get groupDeleteSuccessSnackbar => 'Grupo eliminado';

  @override
  String get groupDetailMissingMessage =>
      'Este grupo já não existe ou foi removido pelo organizador.';

  @override
  String get groupTooltipEditGroupName => 'Editar nome do grupo';

  @override
  String get groupStatusCompletedInfo =>
      'Cada pessoa agora pode ver quem é sua vez de dar.';

  @override
  String get groupStatusReadyInfo =>
      'Ao iniciá-lo, todos verão suas tarefas de forma privada.';

  @override
  String get groupStatusPendingInfo =>
      'Revise os participantes ou subgrupos pendentes.';

  @override
  String groupEffectiveParticipants(int count) {
    return 'Ter${count}de 3 pessoas no mínimo';
  }

  @override
  String get groupOwnerCanRunHint =>
      'Quando tudo estiver pronto, o organizador lança o sorteio.';

  @override
  String get groupPendingSubgroupHint =>
      'Atribua cada pessoa ao seu grupo e pronto.';

  @override
  String get groupPendingGeneralHint =>
      'Você está quase lá para poder fazer o sorteio.';

  @override
  String groupRuleConfigVersion(int version) {
    return 'Configuração v$version';
  }

  @override
  String get groupRuleLockedHint =>
      'A regra não pode ser alterada enquanto o sorteio estiver em andamento ou já concluído.';

  @override
  String get groupSubgroupSectionHelp =>
      'Organize casas, apartamentos, turmas ou equipes para melhorar o sorteio.';

  @override
  String get groupSubgroupEmptyHelp =>
      'Ainda não há subgrupos. Você pode criar um para organizar melhor o grupo.';

  @override
  String get groupSubgroupAssignedOne => '1 participante designado';

  @override
  String groupSubgroupAssignedMany(int count) {
    return '${count}participantes designados';
  }

  @override
  String get groupSubgroupLockedHint =>
      'Você não pode modificar subgrupos após executar o sorteio.';

  @override
  String get groupSubgroupDisabledHint =>
      'Subgrupos desativados para este sorteio. Você pode ativá-los alterando a regra.';

  @override
  String get groupParticipantSubgroupLockedHint =>
      'O subgrupo não poderá ser alterado enquanto o sorteio estiver em andamento ou já concluído.';

  @override
  String get groupManagedSectionHelp =>
      'Esses participantes não utilizam o aplicativo e seu resultado é entregue de forma privada.';

  @override
  String get groupManagedEmptyHelp => 'Ainda não há participantes gerenciados.';

  @override
  String get groupManagedGuardianSelf => 'você';

  @override
  String get groupManagedGuardianOther => 'outro responsável';

  @override
  String get groupManagedPrivateDeliveryHint =>
      'Eles participam sem aplicativo e seus resultados são entregues de forma privada.';

  @override
  String get groupInvitationsHelp =>
      'Gere um código e compartilhe-o para que os participantes participem.';

  @override
  String get groupInvitationCodeTapHint => 'Toque no código para copiá-lo';

  @override
  String get groupInvitationsClosedHint =>
      'Os convites estão encerrados porque o sorteio já foi realizado.';

  @override
  String get groupAdvancedHelp =>
      'Os detalhes secundários do grupo são exibidos aqui.';

  @override
  String groupAdvancedLastExecution(String id) {
    return 'Última execução:$id';
  }

  @override
  String groupAdvancedInternalStatus(String status) {
    return 'Situação interna do sorteio:$status';
  }

  @override
  String get groupCreateSubgroupHint => 'Ex. Stan House, Vendas, Classe 3A';

  @override
  String get groupHeaderSubtitle =>
      'Prepare seu sorteio com privacidade e clareza.';

  @override
  String get groupDetailTaglinePostDraw =>
      'Resultados em privado: cada um vê os seus.';

  @override
  String get groupMemberPreDrawSubtitle =>
      'Você já está dentro. Quando o organizador lançar o sorteio, você poderá ver sua alocação de forma privada.';

  @override
  String get groupMemberYourHouseTitle => 'Sua casa ou equipe';

  @override
  String get groupMemberYourHousePickHint =>
      'O organizador definiu equipes ou casas. Escolha o seu para se colocar bem no sorteio.';

  @override
  String groupMemberYourHouseAssigned(String name) {
    return 'Nós localizamos você em:$name';
  }

  @override
  String get groupMemberYourHouseChooseCta => 'Escolha minha casa ou time';

  @override
  String get groupMemberYourHouseChangeCta => 'Mudar minha casa ou equipamento';

  @override
  String get groupMemberManagedByYouTitle => 'Pessoas que você gerencia aqui';

  @override
  String get groupMemberManagedByYouSubtitle =>
      'Você verá apenas aqueles que o organizador atribuiu a você como responsável.';

  @override
  String get groupMemberHeroTitlePreDraw => 'Você já está dentro';

  @override
  String get groupMemberHeroSubtitlePreDraw =>
      'Quando o organizador lançar o sorteio, você verá sua alocação de forma privada.';

  @override
  String get groupMemberHeroTaglinePreDraw =>
      'Seu grupo, seu espaço. Ninguém vê os resultados dos outros.';

  @override
  String get groupMemberHeroTaglinePostDraw =>
      'Sorteio pronto. Só você vê o que você tem.';

  @override
  String get groupMemberPostDrawHeroSubtitle =>
      'Abra seu resultado quando quiser; É privado.';

  @override
  String get groupMemberHeroSubtitleDrawing =>
      'Estamos sorteando. Em um momento você poderá ver seu resultado.';

  @override
  String get groupBackToDashboard => 'Retornar ao painel';

  @override
  String get groupLoadingDetail => 'Carregando grupo...';

  @override
  String get groupErrorTitle => 'Não foi possível abrir este grupo';

  @override
  String get groupErrorNotFound =>
      'Este grupo não está mais disponível ou você não tem acesso.';

  @override
  String get groupPreparationTitle => 'Status do grupo';

  @override
  String groupPreparationQuickSummary(
    int total,
    int withoutApp,
    int subgroups,
  ) {
    return '${total}pessoas no sorteio${withoutApp}sem aplicativo ·${subgroups}subgrupos';
  }

  @override
  String get groupPostDrawHeroTitle => 'Sorteio realizado';

  @override
  String get groupPostDrawHeroSubtitle =>
      'Agora você pode ver o que lhe pertence, em particular.';

  @override
  String get groupChecklistEnoughPeopleDone => 'Você já tem gente suficiente';

  @override
  String get groupChecklistEnoughPeopleMissing =>
      'Você precisa de pelo menos 3 pessoas';

  @override
  String get groupChecklistAllInSubgroupDone => 'Todos estão em seu subgrupo';

  @override
  String get groupChecklistMissingSubgroupOne =>
      'Você precisa colocar 1 pessoa em seu subgrupo';

  @override
  String groupChecklistMissingSubgroupMany(int count) {
    return 'Eles estão faltando${count}pessoas para colocar em seu subgrupo';
  }

  @override
  String groupChecklistPendingMembers(int count) {
    return '${count}pessoa(s) saiu(s) ou foi removida(s)';
  }

  @override
  String groupPreparationRegistered(int count) {
    return 'Registrado:$count';
  }

  @override
  String groupPreparationManaged(int count) {
    return 'Gerenciou:$count';
  }

  @override
  String groupPreparationPending(int count) {
    return 'Brincos:$count';
  }

  @override
  String groupPreparationMissingSubgroup(int count) {
    return 'Sem subgrupo:$count';
  }

  @override
  String get groupRuleCurrentLabel => 'Regra atual';

  @override
  String get groupRuleChangeCta => 'Alterar regra';

  @override
  String get groupSectionExpandHint => 'Toque para expandir';

  @override
  String get groupSectionCollapseHint => 'Toque para fechar';

  @override
  String groupSectionItemsCount(int count) {
    return '${count}no total';
  }

  @override
  String get groupManagedDialogGuardianSectionTitle =>
      'Quem entregará o resultado?';

  @override
  String get groupManagedDialogGuardianMe => 'EU';

  @override
  String get groupManagedDialogGuardianMeHint =>
      'Vou compartilhar o resultado em particular';

  @override
  String get groupManagedDialogGuardianOther => 'outro membro';

  @override
  String get groupManagedDialogGuardianSpecific => 'Responsável específico';

  @override
  String get groupManagedDialogGuardianComingSoon => 'Breve';

  @override
  String get groupManagedDialogDeliverySectionTitle =>
      'Como você vai entregar isso a eles?';

  @override
  String get groupManagedResponsibleUnavailable => 'Gerente não disponível';

  @override
  String groupManagedDeliversResponsible(String name) {
    return 'Gerencia:$name';
  }

  @override
  String get groupManagedDialogPickGuardianTitle => 'Quem irá entregá-lo?';

  @override
  String get groupManagedDialogGuardianOtherSubtitle =>
      'Este membro verá o resultado e poderá entregá-lo a você em particular.';

  @override
  String get groupManagedDialogGuardianNoEligibleMembers =>
      'Quando outro membro com um aplicativo ingressa, você pode atribuí-lo a ele.';

  @override
  String get groupManagedDialogPickMemberCta => 'Escolha membro';

  @override
  String get groupManagedDialogSelectOtherFirst =>
      'Escolha um membro do grupo primeiro.';

  @override
  String get groupManagedDialogGuardianMustReassign =>
      'Esse membro não está mais ativo no grupo. Escolha outro responsável ou “eu”.';

  @override
  String groupManagedDialogDeliversSummary(String name) {
    return 'Ele oferece:$name';
  }

  @override
  String get groupParticipantsRegisteredTitle => 'Participantes registrados';

  @override
  String get groupParticipantsPendingTitle => 'Participantes pendentes';

  @override
  String get groupParticipantsPendingEmpty => 'Não há participantes pendentes.';

  @override
  String get groupPendingStatusLeft => 'saiu do grupo';

  @override
  String get groupPendingStatusRemoved => 'Removido do grupo';

  @override
  String myAssignmentSubgroupLabel(String name) {
    return 'Subgrupo:$name';
  }

  @override
  String managedSubgroupLabel(String name) {
    return 'Subgrupo:$name';
  }

  @override
  String get managedYouManageIt => 'você gerencia isso';

  @override
  String managedDeliveryRecommendation(String mode) {
    return 'Entrega recomendada:$mode';
  }

  @override
  String get managedTypeManagedParticipant => 'Participante Gerenciado';

  @override
  String get managedDeliveryOwnerDelegated => 'Gerenciado pelo responsável';

  @override
  String get managedDeliveryModeWhatsapp => 'WhatsApp';

  @override
  String get managedDeliveryModeEmail => 'Correspondência';

  @override
  String get managedDeliveryModePdf => 'Impresso/PDF';

  @override
  String get managedDeliveryCtaWhatsapp => 'Compartilhe no WhatsApp';

  @override
  String get managedDeliveryCtaEmail => 'Preparar correspondência';

  @override
  String get managedDeliveryCtaPdf => 'Gerar PDF';

  @override
  String get managedDeliveryVerbalBadge => 'entrega verbal';

  @override
  String get managedDeliveryPdfGenerating => 'Gerando PDF…';

  @override
  String get managedDeliveryWhatsappBrand => '🎁 Segredo de Tarci';

  @override
  String managedDeliveryWhatsappHello(String name) {
    return 'Olá,$name.';
  }

  @override
  String managedDeliveryWhatsappDrawLine(String groupName) {
    return 'O amigo secreto de «$groupName».';
  }

  @override
  String get managedDeliveryWhatsappGiftIntro => 'É a sua vez de doar para:';

  @override
  String managedDeliveryWhatsappReceiverLine(String receiverName) {
    return '✨ $receiverName';
  }

  @override
  String managedDeliverySubgroupBelongsTo(String subgroup) {
    return 'Pertence a:$subgroup';
  }

  @override
  String get managedDeliveryClosingSecret => 'Guarde o segredo 🤫';

  @override
  String managedDeliveryEmailSubject(String groupName) {
    return 'Seu amigo secreto${groupName}está pronto 🎁';
  }

  @override
  String managedDeliveryEmailGreeting(String name) {
    return 'Olá,$name:';
  }

  @override
  String managedDeliveryEmailLead(String groupName) {
    return 'Escrevemos para você com o resultado privado do amigo secreto do grupo «$groupName».';
  }

  @override
  String get managedDeliveryEmailGiftLabel => 'Quem você tem que dar é:';

  @override
  String managedDeliveryEmailReceiverLine(String receiverName) {
    return '$receiverName';
  }

  @override
  String managedDeliveryEmailSubgroupLine(String subgroup) {
    return 'Casa ou equipe:$subgroup';
  }

  @override
  String get managedDeliveryEmailClosing =>
      'Por favor, guarde este resultado apenas para você. Ninguém mais deve ver isso.';

  @override
  String get managedDeliveryEmailSignoff => 'um abraço,\nSegredo de Tarci';

  @override
  String get managedPdfDocTitle => 'amigo secreto';

  @override
  String get managedPdfHeadline => 'Seu amigo secreto está pronto';

  @override
  String get managedPdfForLabel => 'Para';

  @override
  String get managedPdfGroupLabel => 'Conjunto';

  @override
  String get managedPdfGiftHeading => 'Você tem que dar para…';

  @override
  String get managedPdfFooterKeepSecret =>
      'Mantenha o segredo. Ninguém mais deve ver isso.';

  @override
  String get managedPdfFooterBrand => 'Gerado com Tarci Secret';

  @override
  String get managedDeliveryFallbackGroupName => 'seu grupo';

  @override
  String get managedDeliveryErrorMissingData =>
      'Não há dados suficientes para preparar a mensagem.';

  @override
  String get managedDeliveryErrorWhatsapp =>
      'Não conseguimos abrir o WhatsApp. Você pode compartilhar o texto com outro aplicativo.';

  @override
  String get managedDeliveryErrorEmail =>
      'Não encontramos um aplicativo de e-mail neste dispositivo.';

  @override
  String get managedDeliveryErrorPdf =>
      'Não foi possível gerar o PDF. Tente novamente.';

  @override
  String get managedDeliveryErrorShare =>
      'Não foi possível compartilhar. Tente novamente.';

  @override
  String get managedDeliveryErrorGeneric => 'Algo deu errado. Tente novamente.';

  @override
  String get myAssignmentPrivateBadge => 'Privado · só para você';

  @override
  String get myAssignmentRevealLabel => 'Você tem que dar para';

  @override
  String get myAssignmentEmotionalCopy => 'Faça-o se sentir especial.';

  @override
  String get myAssignmentPrivacyTitle => 'Só você vê isso';

  @override
  String get myAssignmentPrivacyBody =>
      'Guarde o segredo até o dia da troca. Ninguém mais no grupo pode ver de quem é a vez.';

  @override
  String get myAssignmentNoSubgroupChip => 'Nenhum subgrupo';

  @override
  String get groupCompletedHeroSubtitle =>
      'Cada pessoa já descobriu a quem é a sua vez de dar.';

  @override
  String get groupCompletedPrivacyNote =>
      'Cada resultado é privado. Somente cada pessoa vê a sua.';

  @override
  String get groupCompletedManagedHint =>
      'Você entrega de forma privada os resultados das pessoas que gerencia.';

  @override
  String get chatGroupSectionTitle => 'Conversa do grupo';

  @override
  String get chatGroupSectionSubtitle =>
      'Brinca, partilha pistas e mantém o clima aceso.';

  @override
  String get chatGroupEnterCta => 'Entrar no chat';

  @override
  String chatGroupEventLine(String date) {
    return 'Entrega:$date';
  }

  @override
  String get chatDrawCompletedChip => 'Sorteio realizado';

  @override
  String get chatInputHint => 'Escreve algo para o grupo…';

  @override
  String get chatSendCta => 'Enviar';

  @override
  String get chatTarciLabel => 'Tárci';

  @override
  String get chatEmptyTitle => 'Ainda não há mensagens';

  @override
  String get chatEmptyBody =>
      'Quando alguém escrever ou Tarci relatar algo importante, você verá aqui.';

  @override
  String get chatLoadError =>
      'Não foi possível carregar o chat. Verifique sua conexão ou tente novamente.';

  @override
  String get chatSendError =>
      'A mensagem não pôde ser enviada. Tente novamente.';

  @override
  String get chatSystemGroupCreatedV1 =>
      '🎁 O grupo já está em andamento. Dê dicas, conte tudo e deixe a fofoca saudável rolar.';

  @override
  String get chatSystemDrawCompletedV1 =>
      '🤫 Sorteio realizado. De agora em diante, cada pergunta estranha conta como prova.';

  @override
  String chatSystemUnknownTemplate(String templateKey) {
    return 'Mensagem do sistema ($templateKey)';
  }

  @override
  String get chatSystemAutoPlayful001V1 =>
      'Já há cheiro de suspeitas por aqui… e ninguém confessou nada ainda.';

  @override
  String get chatSystemAutoPlayful002V1 =>
      'Desde que houve sorteio, toda pergunta inocente parece estratégica.';

  @override
  String get chatSystemAutoPlayful003V1 =>
      'Dica da Tarci: investigue com sutileza, não como num interrogatório.';

  @override
  String get chatSystemAutoPlayful004V1 =>
      'Há quem já tenha presente. E há quem tenha fé.';

  @override
  String get chatSystemAutoPlayful005V1 =>
      'Se alguém perguntar por tamanhos, cores e hobbies de uma vez, fique atento.';

  @override
  String get chatSystemAutoPlayful006V1 =>
      'Um bom presente surpreende. Um grande presente vira história.';

  @override
  String get chatSystemAutoPlayful007V1 =>
      'Sorrisos suspeitos contam como pistas.';

  @override
  String get chatSystemAutoPlayful008V1 =>
      'Despistar é permitido. Exagerar, nem tanto.';

  @override
  String get chatSystemAutoPlayful009V1 =>
      'O silêncio de algumas pessoas já parece planejamento.';

  @override
  String get chatSystemAutoPlayful010V1 =>
      'Se for improvisar, pelo menos improvise com carinho.';

  @override
  String get chatSystemAutoPlayful011V1 =>
      'A Tarci percebe energia de presente épico… e de pânico elegante.';

  @override
  String get chatSystemAutoPlayful012V1 =>
      'Quem diz “já resolvi” sem provas levanta suspeitas.';

  @override
  String get chatSystemAutoPlayful013V1 =>
      'Lembrete carinhoso: o mistério também faz parte da graça.';

  @override
  String get chatSystemAutoPlayful014V1 =>
      'Todo grupo tem um detetive. Já sabem quem é?';

  @override
  String get chatSystemAutoPlayful015V1 =>
      'Um detalhe com intenção vale mais do que um presente sem alma.';

  @override
  String get chatSystemAutoPlayful016V1 =>
      'Este chat está oficialmente em modo suspeita.';

  @override
  String get chatSystemAutoPlayful017V1 =>
      'Se você acabou de procurar ideias em segredo, ninguém vai julgar.';

  @override
  String get chatSystemAutoPlayful018V1 =>
      'Alguns olhares na vida real agora significam coisa demais.';

  @override
  String get chatSystemAutoPlayful019V1 =>
      'A missão não é gastar mais. É acertar melhor.';

  @override
  String get chatSystemAutoPlayful020V1 =>
      'Disfarçar bem também faz parte do jogo.';

  @override
  String get chatSystemAutoPlayful021V1 =>
      'A Tarci aposta que alguém aqui já tem um plano brilhante.';

  @override
  String get chatSystemAutoDebate001V1 =>
      'Debate rápido: presente útil ou presente que faça rir?';

  @override
  String get chatSystemAutoDebate002V1 =>
      'Melhor surpresa total ou pista bem aproveitada?';

  @override
  String get chatSystemAutoDebate003V1 =>
      'O que ganha: criatividade ou precisão?';

  @override
  String get chatSystemAutoDebate004V1 =>
      'Debate aberto: uma embalagem caprichada faz diferença?';

  @override
  String get chatSystemAutoDebate005V1 =>
      'Investigação discreta ou lista de desejos para salvar?';

  @override
  String get chatSystemAutoDebate006V1 =>
      'Sem citar nomes: quem deste grupo improvisa no final?';

  @override
  String get chatSystemAutoDebate007V1 =>
      'Presente pequeno com história ou grande sem história?';

  @override
  String get chatSystemAutoDebate008V1 =>
      'Despistar no chat vale ou já é jogo sujo?';

  @override
  String get chatSystemAutoDebate009V1 =>
      'O que emociona mais: acertar ou surpreender?';

  @override
  String get chatSystemAutoDebate010V1 =>
      'Se tivesse de escolher: prático, divertido ou sentimental?';

  @override
  String get chatSystemAutoWishlist001V1 =>
      'Algumas listas de desejos ainda estão vazias. Uma pista na hora certa pode salvar um presente.';

  @override
  String get chatSystemAutoWishlist002V1 =>
      'Sua lista de desejos não tira a magia; evita tentar adivinhar no escuro.';

  @override
  String get chatSystemAutoWishlist003V1 =>
      'Se quiser que acertem com você, deixe algumas ideias.';

  @override
  String get chatSystemAutoWishlist004V1 =>
      'Tem alguém preparando presente com pouquíssimas pistas. Cof cof.';

  @override
  String get chatSystemAutoWishlist005V1 =>
      'Completar a lista ajuda sem revelar demais.';

  @override
  String get chatSystemAutoWishlist006V1 =>
      'Um link, um gosto, uma pista: tudo ajuda.';

  @override
  String get chatSystemAutoWishlist007V1 =>
      'Até as melhores surpresas agradecem um pouco de orientação.';

  @override
  String get chatSystemAutoWishlist008V1 =>
      'Se sua lista está vazia, seu amigo secreto está jogando no modo difícil.';

  @override
  String get chatSystemAutoQuiet001V1 =>
      'Muito silêncio por aqui… comprando ou escondendo provas?';

  @override
  String get chatSystemAutoQuiet002V1 =>
      'Este grupo está quieto demais. Alguém precisa quebrar o gelo.';

  @override
  String get chatSystemAutoQuiet003V1 =>
      'A Tarci está fazendo chamada: a brincadeira continua viva?';

  @override
  String get chatSystemAutoQuiet004V1 =>
      'Pergunta para reanimar: quem parece mais suspeito hoje?';

  @override
  String get chatSystemAutoQuiet005V1 =>
      'Se ninguém escrever, a Tarci vai começar a inventar teorias.';

  @override
  String get chatSystemAutoQuiet006V1 =>
      'Chat dormindo, mistério bem acordado. Digam alguma coisa.';

  @override
  String get chatSystemAutoCountdown014V1 =>
      'Faltam 14 dias. Ainda há tempo, mas as desculpas estão acabando.';

  @override
  String get chatSystemAutoCountdown007V1 =>
      'Faltam 7 dias. Quem ainda não tem ideia entrou oficialmente em busca séria.';

  @override
  String get chatSystemAutoCountdown003V1 =>
      'Faltam 3 dias. Já não é planejamento: é operação resgate.';

  @override
  String get chatSystemAutoCountdown001V1 =>
      'Falta 1 dia. Embrulhe, respire e finja naturalidade.';

  @override
  String get chatSystemAutoCountdown000V1 =>
      'Hoje é o dia da troca. Que haja surpresas, risadas e nenhuma confissão antes da hora.';

  @override
  String get dynamicsHomePrimaryCta => 'Criar dinâmica';

  @override
  String get dynamicsSelectTitle => 'Escolha uma dinâmica';

  @override
  String get dynamicsSelectSubtitle =>
      'Comece com uma experiência pronta hoje. Mais modos chegam em breve.';

  @override
  String get dynamicsCardSecretSantaTitle => 'Amigo secreto';

  @override
  String get dynamicsCardSecretSantaBody =>
      'Atribuições privadas, listas de desejos e chat do grupo.';

  @override
  String get dynamicsCardRaffleTitle => 'Sorteio';

  @override
  String get dynamicsCardRaffleBody =>
      'Vencedores visíveis para todo o grupo. Sem segredos nem entregas geridas.';

  @override
  String get dynamicsCardTeamsTitle => 'Equipas';

  @override
  String get dynamicsCardPairingsTitle => 'Emparelhamentos';

  @override
  String get dynamicsCardDuelsTitle => 'Duelos';

  @override
  String get dynamicsComingSoonBadge => 'Em breve';

  @override
  String get homeDynamicTypeSecretSanta => 'Amigo secreto';

  @override
  String get homeDynamicTypeRaffle => 'Sorteio';

  @override
  String get homeRaffleStatePreparing => 'A preparar';

  @override
  String get homeRaffleStateCompleted => 'Sorteio realizado';

  @override
  String get raffleWizardTitle => 'Novo sorteio';

  @override
  String get raffleWizardNameLabel => 'Nome do sorteio';

  @override
  String get raffleWizardWinnersLabel => 'Número de vencedores';

  @override
  String get raffleWizardOwnerParticipatesTitle => 'Você participa?';

  @override
  String get raffleWizardOwnerParticipatesYes => 'Sim, entro no sorteio';

  @override
  String get raffleWizardOwnerParticipatesNo => 'Não, só organizo';

  @override
  String get raffleWizardEventOptional => 'Data do evento (opcional)';

  @override
  String get raffleWizardReviewTitle => 'Revisão';

  @override
  String raffleWizardReviewWinners(int count) {
    return '$count vencedor(es)';
  }

  @override
  String get raffleWizardCreateCta => 'Criar sorteio';

  @override
  String get raffleDetailInviteSection => 'Convite';

  @override
  String get raffleDetailAppMembersTitle => 'Participantes com app';

  @override
  String get raffleDetailManualTitle => 'Participantes sem app';

  @override
  String get raffleDetailAddManualCta => 'Adicionar pessoa';

  @override
  String get raffleDetailRunRaffleCta => 'Realizar sorteio';

  @override
  String get raffleDetailWinnersTitle => 'Vencedores';

  @override
  String get raffleDetailShareCta => 'Partilhar resultado';

  @override
  String get raffleDetailCompletedHint =>
      'Este sorteio está fechado: não é possível alterar participantes nem sortear de novo.';

  @override
  String get raffleManualEditTitle => 'Editar participante';

  @override
  String get raffleManualDisplayNameLabel => 'Nome visível';

  @override
  String raffleShareBody(String raffleName, String winners) {
    return 'Já temos vencedores de «$raffleName»:\n$winners\n\nFeito com Tarci Secret.';
  }

  @override
  String get functionsErrorRaffleResolvedInvitesClosed =>
      'Este sorteio já foi realizado e não aceita novos participantes.';

  @override
  String get functionsErrorRaffleInProgress =>
      'O sorteio está em curso. Tente novamente dentro de instantes.';

  @override
  String get functionsErrorRaffleRotateLocked =>
      'Não é possível rodar o código quando o sorteio já não aceita alterações.';

  @override
  String get functionsErrorRaffleAlreadyCompleted =>
      'Este sorteio já foi concluído.';

  @override
  String get functionsErrorRaffleTooManyWinners =>
      'Há mais vencedores do que participantes elegíveis.';

  @override
  String get functionsErrorRaffleInsufficientParticipants =>
      'Não há participantes suficientes para este sorteio.';

  @override
  String get functionsErrorRaffleInvalidDynamic =>
      'Esta ação não está disponível para este tipo de grupo.';

  @override
  String get functionsErrorChatNotAvailableForRaffle =>
      'O chat do grupo não está disponível em sorteios públicos.';

  @override
  String get functionsErrorWishlistNotAvailableForRaffle =>
      'As listas de desejos não estão disponíveis em sorteios.';

  @override
  String get functionsErrorManagedParticipantsNotForRaffle =>
      'Participantes geridos de amigo secreto não se aplicam a sorteios.';

  @override
  String get functionsErrorDrawNotForRaffle =>
      'O sorteio de amigo secreto não está disponível em grupos de sorteio.';

  @override
  String get functionsErrorAssignmentsNotForRaffle =>
      'As atribuições secretas não se aplicam a este grupo.';

  @override
  String raffleDetailEligibleCount(int count) {
    return 'Participantes elegíveis: $count';
  }

  @override
  String get raffleWizardPickEventDate => 'Escolher data';

  @override
  String get functionsErrorDrawNotSupportedForDynamic =>
      'O sorteio de amigo secreto não está disponível para este tipo de grupo.';

  @override
  String get functionsErrorRaffleEditLocked =>
      'Este sorteio já não permite alterar participantes.';

  @override
  String get raffleDetailMinPoolHint =>
      'Precisas de pelo menos 2 participantes no bombo para realizar o sorteio.';

  @override
  String get raffleResultHeroTitle => 'Sorteio realizado!';

  @override
  String get raffleResultHeroSubtitle => 'Já temos o resultado.';

  @override
  String raffleResultSingleWinner(String name) {
    return 'Vencedor: $name';
  }

  @override
  String raffleResultMultipleWinners(String names) {
    return 'Vencedores: $names';
  }

  @override
  String get raffleWizardOwnerNicknameLabel => 'O teu nome no bombo';

  @override
  String get raffleWizardOwnerNicknameHelper =>
      'Assim te verão os outros. Usa um apelido, não o papel de organizador.';

  @override
  String get raffleOwnerParticipantFallback => 'Participante';

  @override
  String get raffleMemberDefaultName => 'Participante';

  @override
  String get raffleDetailStatsWinners => 'Número de vencedores';

  @override
  String get raffleDetailInPool => 'No bombo';

  @override
  String get pushActivationTitle => 'Ativa as notificações';

  @override
  String get pushActivationBody =>
      'Avisamos-te quando houver um sorteio ou quando o teu amigo secreto estiver pronto.';

  @override
  String get pushActivationCta => 'Ativar';

  @override
  String get pushActivationSuccessSnackbar => 'Notificações ativadas.';

  @override
  String get pushActivationDeniedSnackbar =>
      'Não foi possível ativar as notificações. Podes tentar mais tarde nas definições do sistema.';
}
