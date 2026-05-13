/**
 * Genera tarci_auto_es.arb, tarci_auto_en.arb y docs/tarci_chat_auto_messages_i18n.json
 * desde el catálogo oficial Fase 6B.
 * Ejecutar: node tools/build_tarci_auto_arb.mjs
 */
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, "..");

const entries = [
  ["chat.system.auto.playful.001.v1", "playful", "Aquí ya huele a sospechas… y todavía nadie ha confesado nada.", "Suspicion is already in the air… and nobody has confessed a thing.", "Qui c'è già aria di sospetti… e nessuno ha ancora confessato nulla.", "Já há cheiro de suspeitas por aqui… e ninguém confessou nada ainda.", "L'ambiance sent déjà le soupçon… et personne n'a encore rien avoué."],
  ["chat.system.auto.playful.002.v1", "playful", "Desde que hay sorteo, cada pregunta inocente parece estrategia.", "Now that the draw is done, every innocent question sounds strategic.", "Da quando c'è stato il sorteggio, ogni domanda innocente sembra strategica.", "Desde que houve sorteio, toda pergunta inocente parece estratégica.", "Depuis le tirage, chaque question innocente semble calculée."],
  ["chat.system.auto.playful.003.v1", "playful", "Consejo de Tarci: investiga con sutileza, no con interrogatorio.", "Tarci tip: investigate with subtlety, not like an interrogation.", "Consiglio di Tarci: indaga con discrezione, non come in un interrogatorio.", "Dica da Tarci: investigue com sutileza, não como num interrogatório.", "Conseil de Tarci : enquête avec subtilité, pas comme dans un interrogatoire."],
  ["chat.system.auto.playful.004.v1", "playful", "Hay quien ya tiene regalo. Hay quien tiene fe.", "Some already have a gift. Others have faith.", "C'è chi ha già il regalo. E chi ha fede.", "Há quem já tenha presente. E há quem tenha fé.", "Certains ont déjà leur cadeau. D'autres ont la foi."],
  ["chat.system.auto.playful.005.v1", "playful", "Si alguien pregunta por tallas, colores y hobbies seguidos, toma nota.", "If someone asks about sizes, colors and hobbies all at once, take note.", "Se qualcuno chiede taglie, colori e hobby tutti insieme, prendi nota.", "Se alguém perguntar por tamanhos, cores e hobbies de uma vez, fique atento.", "Si quelqu'un demande tailles, couleurs et loisirs d'un coup, prends note."],
  ["chat.system.auto.playful.006.v1", "playful", "Un buen regalo sorprende. Un gran regalo deja historia.", "A good gift surprises. A great gift becomes a story.", "Un buon regalo sorprende. Un grande regalo lascia il segno.", "Um bom presente surpreende. Um grande presente vira história.", "Un bon cadeau surprend. Un grand cadeau laisse un souvenir."],
  ["chat.system.auto.playful.007.v1", "playful", "Las sonrisas sospechosas cuentan como pista.", "Suspicious smiles count as clues.", "I sorrisi sospetti contano come indizi.", "Sorrisos suspeitos contam como pistas.", "Les sourires suspects comptent comme des indices."],
  ["chat.system.auto.playful.008.v1", "playful", "Se permite despistar. Se recomienda no pasarse.", "Misdirection is allowed. Overdoing it is not recommended.", "Depistare è concesso. Esagerare è sconsigliato.", "Despistar é permitido. Exagerar, nem tanto.", "Brouiller les pistes est permis. En faire trop, moins."],
  ["chat.system.auto.playful.009.v1", "playful", "El silencio de algunos empieza a parecer planificación.", "Some people's silence is starting to look like a plan.", "Il silenzio di qualcuno comincia a sembrare una strategia.", "O silêncio de algumas pessoas já parece planejamento.", "Le silence de certains commence à ressembler à une stratégie."],
  ["chat.system.auto.playful.010.v1", "playful", "Si vas a improvisar, al menos improvisa con cariño.", "If you are going to improvise, at least improvise with care.", "Se improvvisi, fallo almeno con affetto.", "Se for improvisar, pelo menos improvise com carinho.", "Si tu improvises, fais-le au moins avec attention."],
  ["chat.system.auto.playful.011.v1", "playful", "Tarci detecta energía de regalo épico… y de pánico elegante.", "Tarci detects energy for epic gifts… and elegant panic.", "Tarci percepisce energia da regalo epico… e da panico elegante.", "A Tarci percebe energia de presente épico… e de pânico elegante.", "Tarci détecte une énergie de cadeau épique… et de panique élégante."],
  ["chat.system.auto.playful.012.v1", "playful", "Quien dice “yo ya lo tengo” sin pruebas despierta dudas.", "Anyone saying “I already have it” without proof raises suspicion.", "Chi dice “ce l'ho già” senza prove suscita sospetti.", "Quem diz “já resolvi” sem provas levanta suspeitas.", "Celui qui dit « c'est déjà réglé » sans preuve éveille les soupçons."],
  ["chat.system.auto.playful.013.v1", "playful", "Recordatorio amable: el misterio también se disfruta.", "Friendly reminder: the mystery is part of the fun.", "Promemoria gentile: anche il mistero fa parte del divertimento.", "Lembrete carinhoso: o mistério também faz parte da graça.", "Petit rappel : le mystère fait aussi partie du plaisir."],
  ["chat.system.auto.playful.014.v1", "playful", "Cada grupo tiene un detective. ¿Ya sabéis quién es?", "Every group has a detective. Do you already know who it is?", "Ogni gruppo ha un detective. Avete già capito chi è?", "Todo grupo tem um detetive. Já sabem quem é?", "Chaque groupe a son détective. Vous savez déjà qui c'est ?"],
  ["chat.system.auto.playful.015.v1", "playful", "Un detalle con intención vale más que un regalo sin alma.", "A thoughtful detail is worth more than a gift without soul.", "Un pensiero fatto con intenzione vale più di un regalo senza anima.", "Um detalhe com intenção vale mais do que um presente sem alma.", "Une attention sincère vaut plus qu'un cadeau sans âme."],
  ["chat.system.auto.playful.016.v1", "playful", "Este chat está oficialmente en modo sospecha.", "This chat is officially in suspicion mode.", "Questa chat è ufficialmente in modalità sospetto.", "Este chat está oficialmente em modo suspeita.", "Ce chat est officiellement en mode soupçon."],
  ["chat.system.auto.playful.017.v1", "playful", "Si acabas de buscar ideas en secreto, nadie te juzga.", "If you just searched for gift ideas in secret, nobody is judging.", "Se hai appena cercato idee regalo di nascosto, nessuno ti giudica.", "Se você acabou de procurar ideias em segredo, ninguém vai julgar.", "Si tu viens de chercher des idées en secret, personne ne juge."],
  ["chat.system.auto.playful.018.v1", "playful", "Hay miradas en la vida real que ahora significan demasiado.", "Some real-life glances suddenly mean far too much.", "Certi sguardi nella vita reale ora significano fin troppo.", "Alguns olhares na vida real agora significam coisa demais.", "Certains regards dans la vraie vie veulent soudain dire beaucoup trop."],
  ["chat.system.auto.playful.019.v1", "playful", "La misión no es gastar más. Es acertar mejor.", "The mission is not to spend more. It is to get it right.", "La missione non è spendere di più. È azzeccarci meglio.", "A missão não é gastar mais. É acertar melhor.", "Le but n'est pas de dépenser plus. C'est de mieux viser."],
  ["chat.system.auto.playful.020.v1", "playful", "Disimular bien también es parte del juego.", "Hiding it well is also part of the game.", "Saper dissimulare fa parte del gioco.", "Disfarçar bem também faz parte do jogo.", "Bien dissimuler fait aussi partie du jeu."],
  ["chat.system.auto.playful.021.v1", "playful", "Tarci apuesta a que alguien aquí ya tiene un plan brillante.", "Tarci bets someone here already has a brilliant plan.", "Tarci scommette che qualcuno qui ha già un piano geniale.", "A Tarci aposta que alguém aqui já tem um plano brilhante.", "Tarci parie que quelqu'un ici a déjà un plan brillant."],
  ["chat.system.auto.debate.001.v1", "debate", "Debate rápido: ¿regalo útil o regalo que haga reír?", "Quick debate: a useful gift or a gift that makes people laugh?", "Dibattito rapido: regalo utile o regalo che fa ridere?", "Debate rápido: presente útil ou presente que faça rir?", "Débat express : cadeau utile ou cadeau qui fait rire ?"],
  ["chat.system.auto.debate.002.v1", "debate", "¿Mejor sorpresa total o pista bien aprovechada?", "Better a total surprise or a well-used hint?", "Meglio una sorpresa totale o un indizio sfruttato bene?", "Melhor surpresa total ou pista bem aproveitada?", "Mieux vaut une surprise totale ou un indice bien utilisé ?"],
  ["chat.system.auto.debate.003.v1", "debate", "¿Qué gana: creatividad o precisión?", "What wins: creativity or precision?", "Cosa vince: creatività o precisione?", "O que ganha: criatividade ou precisão?", "Qu'est-ce qui l'emporte : créativité ou précision ?"],
  ["chat.system.auto.debate.004.v1", "debate", "Abrimos debate: ¿el envoltorio espectacular importa?", "Open debate: does spectacular wrapping matter?", "Dibattito aperto: una confezione spettacolare conta?", "Debate aberto: uma embalagem caprichada faz diferença?", "Débat ouvert : un emballage spectaculaire, ça compte ?"],
  ["chat.system.auto.debate.005.v1", "debate", "¿Investigación discreta o lista de deseos al rescate?", "Discreet research or wish list to the rescue?", "Indagine discreta o lista dei desideri in soccorso?", "Investigação discreta ou lista de desejos para salvar?", "Enquête discrète ou liste d'envies à la rescousse ?"],
  ["chat.system.auto.debate.006.v1", "debate", "Sin señalar a nadie: ¿quién del grupo improvisa al final?", "Without naming names: who in this group improvises at the last minute?", "Senza fare nomi: chi in questo gruppo improvvisa all'ultimo?", "Sem citar nomes: quem deste grupo improvisa no final?", "Sans citer personne : qui dans ce groupe improvise à la dernière minute ?"],
  ["chat.system.auto.debate.007.v1", "debate", "¿Regalo pequeño con historia o grande sin historia?", "A small gift with a story or a big gift without one?", "Meglio un piccolo regalo con una storia o uno grande senza?", "Presente pequeno com história ou grande sem história?", "Petit cadeau avec une histoire ou grand cadeau sans histoire ?"],
  ["chat.system.auto.debate.008.v1", "debate", "¿Se vale despistar en el chat o eso ya es juego sucio?", "Is misdirection in the chat fair play or already dirty tactics?", "Depistare in chat è lecito o è già gioco sporco?", "Despistar no chat vale ou já é jogo sujo?", "Brouiller les pistes dans le chat, fair-play ou déjà limite ?"],
  ["chat.system.auto.debate.009.v1", "debate", "¿Qué emociona más: acertar o sorprender?", "What feels better: getting it right or surprising someone?", "Cosa emoziona di più: azzeccare o sorprendere?", "O que emociona mais: acertar ou surpreender?", "Qu'est-ce qui émeut le plus : viser juste ou surprendre ?"],
  ["chat.system.auto.debate.010.v1", "debate", "Si tuvieras que elegir: ¿práctico, divertido o sentimental?", "If you had to choose: practical, fun or sentimental?", "Se dovessi scegliere: pratico, divertente o sentimentale?", "Se tivesse de escolher: prático, divertido ou sentimental?", "S'il fallait choisir : pratique, drôle ou sentimental ?"],
  ["chat.system.auto.wishlist.001.v1", "wishlistReminder", "Algunas listas siguen vacías. Una pista a tiempo puede salvar un regalo.", "Some wish lists are still empty. A timely hint can save a gift.", "Alcune liste dei desideri sono ancora vuote. Un indizio al momento giusto può salvare un regalo.", "Algumas listas de desejos ainda estão vazias. Uma pista na hora certa pode salvar um presente.", "Certaines listes d'envies sont encore vides. Un indice donné à temps peut sauver un cadeau."],
  ["chat.system.auto.wishlist.002.v1", "wishlistReminder", "Tu lista de deseos no quita magia; evita adivinar a ciegas.", "Your wish list does not remove the magic; it avoids guessing blindly.", "La tua lista dei desideri non toglie magia; evita di andare alla cieca.", "Sua lista de desejos não tira a magia; evita tentar adivinhar no escuro.", "Ta liste d'envies n'enlève rien à la magie ; elle évite de deviner à l'aveugle."],
  ["chat.system.auto.wishlist.003.v1", "wishlistReminder", "Si quieres que acierten contigo, deja alguna idea.", "If you want them to get it right, leave a few ideas.", "Se vuoi che ci azzecchino, lascia qualche idea.", "Se quiser que acertem com você, deixe algumas ideias.", "Si tu veux qu'on vise juste, laisse quelques idées."],
  ["chat.system.auto.wishlist.004.v1", "wishlistReminder", "Hay alguien preparando regalo con muy pocas pistas. Ejem.", "Someone is preparing a gift with very few clues. Ahem.", "Qualcuno sta preparando un regalo con pochissimi indizi. Ehm.", "Tem alguém preparando presente com pouquíssimas pistas. Cof cof.", "Quelqu'un prépare un cadeau avec très peu d'indices. Hum hum."],
  ["chat.system.auto.wishlist.005.v1", "wishlistReminder", "Completar la lista es ayudar sin revelar demasiado.", "Filling in your list helps without revealing too much.", "Completare la lista aiuta senza svelare troppo.", "Completar a lista ajuda sem revelar demais.", "Compléter sa liste aide sans trop en dévoiler."],
  ["chat.system.auto.wishlist.006.v1", "wishlistReminder", "Un enlace, un gusto, una pista: todo suma.", "A link, a preference, a clue: it all helps.", "Un link, un gusto, un indizio: tutto aiuta.", "Um link, um gosto, uma pista: tudo ajuda.", "Un lien, un goût, un indice : tout aide."],
  ["chat.system.auto.wishlist.007.v1", "wishlistReminder", "Las mejores sorpresas también agradecen orientación.", "Even the best surprises appreciate a little guidance.", "Anche le migliori sorprese apprezzano un po' di orientamento.", "Até as melhores surpresas agradecem um pouco de orientação.", "Même les meilleures surprises apprécient un peu d'orientation."],
  ["chat.system.auto.wishlist.008.v1", "wishlistReminder", "Si tu lista está vacía, tu amigo secreto está jugando en modo difícil.", "If your list is empty, your Secret Santa is playing on hard mode.", "Se la tua lista è vuota, il tuo amico segreto sta giocando in modalità difficile.", "Se sua lista está vazia, seu amigo secreto está jogando no modo difícil.", "Si ta liste est vide, ton ami secret joue en mode difficile."],
  ["chat.system.auto.quiet.001.v1", "quietChatNudge", "Mucho silencio por aquí… ¿comprando o escondiendo pruebas?", "It is very quiet here… shopping or hiding evidence?", "Qui c'è molto silenzio… state comprando o nascondendo le prove?", "Muito silêncio por aqui… comprando ou escondendo provas?", "C'est bien silencieux ici… achats en cours ou preuves cachées ?"],
  ["chat.system.auto.quiet.002.v1", "quietChatNudge", "Este grupo está demasiado tranquilo. Alguien que rompa el hielo.", "This group is far too quiet. Someone break the ice.", "Questo gruppo è fin troppo tranquillo. Qualcuno rompa il ghiaccio.", "Este grupo está quieto demais. Alguém precisa quebrar o gelo.", "Ce groupe est beaucoup trop calme. Quelqu'un brise la glace."],
  ["chat.system.auto.quiet.003.v1", "quietChatNudge", "Tarci pasa lista: ¿sigue vivo el cachondeo?", "Tarci is taking attendance: is the playful chaos still alive?", "Tarci fa l'appello: il divertimento è ancora vivo?", "A Tarci está fazendo chamada: a brincadeira continua viva?", "Tarci fait l'appel : l'ambiance est toujours là ?"],
  ["chat.system.auto.quiet.004.v1", "quietChatNudge", "Pregunta de reactivación: ¿quién se ve más sospechoso hoy?", "Reactivation question: who looks most suspicious today?", "Domanda per riattivare il gruppo: chi sembra più sospetto oggi?", "Pergunta para reanimar: quem parece mais suspeito hoje?", "Question pour relancer : qui a l'air le plus suspect aujourd'hui ?"],
  ["chat.system.auto.quiet.005.v1", "quietChatNudge", "Si nadie escribe, Tarci empieza a inventar teorías.", "If nobody writes, Tarci will start making up theories.", "Se nessuno scrive, Tarci inizierà a inventare teorie.", "Se ninguém escrever, a Tarci vai começar a inventar teorias.", "Si personne n'écrit, Tarci va commencer à inventer des théories."],
  ["chat.system.auto.quiet.006.v1", "quietChatNudge", "Chat dormido, misterio despierto. Comentad algo.", "Sleeping chat, wide-awake mystery. Say something.", "Chat addormentata, mistero sveglissimo. Scrivete qualcosa.", "Chat dormindo, mistério bem acordado. Digam alguma coisa.", "Chat endormi, mystère bien réveillé. Dites quelque chose."],
  ["chat.system.auto.countdown.014.v1", "countdown", "Quedan 14 días. Todavía hay margen, pero la excusa se está acabando.", "14 days left. There is still time, but excuses are running out.", "Mancano 14 giorni. C'è ancora margine, ma le scuse stanno finendo.", "Faltam 14 dias. Ainda há tempo, mas as desculpas estão acabando.", "Il reste 14 jours. Il y a encore de la marge, mais les excuses s'épuisent."],
  ["chat.system.auto.countdown.007.v1", "countdown", "Quedan 7 días. Quien no tenga idea entra en fase de búsqueda seria.", "7 days left. Anyone without an idea has officially entered serious search mode.", "Mancano 7 giorni. Chi non ha ancora un'idea entra ufficialmente in fase ricerca seria.", "Faltam 7 dias. Quem ainda não tem ideia entrou oficialmente em busca séria.", "Il reste 7 jours. Ceux qui n'ont pas encore d'idée passent officiellement en mode recherche sérieuse."],
  ["chat.system.auto.countdown.003.v1", "countdown", "Quedan 3 días. Ya no es planificación: es operación rescate.", "3 days left. This is no longer planning; it is a rescue operation.", "Mancano 3 giorni. Non è più pianificazione: è operazione salvataggio.", "Faltam 3 dias. Já não é planejamento: é operação resgate.", "Il reste 3 jours. Ce n'est plus de l'organisation : c'est une opération sauvetage."],
  ["chat.system.auto.countdown.001.v1", "countdown", "Falta 1 día. Envuelve, respira y finge normalidad.", "1 day left. Wrap it, breathe, and act natural.", "Manca 1 giorno. Incarta, respira e fai finta di niente.", "Falta 1 dia. Embrulhe, respire e finja naturalidade.", "Il reste 1 jour. Emballe, respire et fais comme si de rien n'était."],
  ["chat.system.auto.countdown.000.v1", "countdown", "Hoy es el intercambio. Que haya sorpresas, risas y cero confesiones antes de tiempo.", "Today is the exchange. May there be surprises, laughs, and zero early confessions.", "Oggi è il giorno dello scambio. Che ci siano sorprese, risate e zero confessioni in anticipo.", "Hoje é o dia da troca. Que haja surpresas, risadas e nenhuma confissão antes da hora.", "Aujourd'hui, c'est le jour de l'échange. Place aux surprises, aux rires et à zéro aveu prématuré."]
];

function templateKeyToArbKeyFixed(templateKey) {
  const parts = templateKey.split(".");
  const cat = parts[3];
  const num = parts[4];
  const ver = parts[5];
  const V = ver === "v1" ? "V1" : ver;
  const catCap = cat.charAt(0).toUpperCase() + cat.slice(1);
  return `chatSystemAuto${catCap}${num}${V}`;
}

function mergeIntoMainArb(mainPath, langIdx) {
  const main = JSON.parse(fs.readFileSync(mainPath, "utf8"));
  for (const row of entries) {
    const k = templateKeyToArbKeyFixed(row[0]);
    main[k] = row[2 + langIdx];
  }
  fs.writeFileSync(mainPath, JSON.stringify(main, null, 2) + "\n", "utf8");
}

const appEs = path.join(root, "src/flutter_app/lib/l10n/app_es.arb");
const appEn = path.join(root, "src/flutter_app/lib/l10n/app_en.arb");
mergeIntoMainArb(appEs, 0);
mergeIntoMainArb(appEn, 1);

const docJson = entries.map((row) => ({
  templateKey: row[0],
  category: row[1],
  es: row[2],
  en: row[3],
  it: row[4],
  pt: row[5],
  fr: row[6]
}));
const docPath = path.join(root, "docs/tarci_chat_auto_messages_i18n.json");
fs.mkdirSync(path.dirname(docPath), { recursive: true });
fs.writeFileSync(docPath, JSON.stringify(docJson, null, 2), "utf8");

console.log("Merged Tarci auto strings into", appEs, appEn, docPath);

const dartPath = path.join(root, "src/flutter_app/lib/features/chat/presentation/tarci_auto_chat_l10n.dart");
const dartCases = entries
  .map((row) => {
    const tk = row[0];
    const arbKey = templateKeyToArbKeyFixed(tk);
    return `    case '${tk}':\n      return l10n.${arbKey};`;
  })
  .join("\n");

const dartOut = `import '../../../l10n/app_localizations.dart';

/// Mensajes automáticos Tarci (Fase 6B). Claves en app_es.arb / app_en.arb (prefijo chatSystemAuto*).
String? localizedTarciAutoMessage(AppLocalizations l10n, String templateKey) {
  switch (templateKey) {
${dartCases}
    default:
      return null;
  }
}
`;
fs.writeFileSync(dartPath, dartOut, "utf8");
console.log("Wrote", dartPath);
