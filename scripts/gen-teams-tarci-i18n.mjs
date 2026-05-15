/**
 * Genera entradas ARB (5 idiomas) y casos switch Dart para mensajes Tarci Equipos.
 * Ejecutar: node scripts/gen-teams-tarci-i18n.mjs
 */
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, "..");

const messages = {
  playful: [
    { es: "Equipos listos. Ya podéis empezar a culpar al algoritmo.", en: "Teams are set. You can start blaming the algorithm now.", pt: "Equipas prontas. Já podem começar a culpar o algoritmo.", it: "Squadre pronte. Potete iniziare a incolpare l'algoritmo.", fr: "Les équipes sont prêtes. Vous pouvez commencer à blâmer l'algorithme." },
    { es: "¿Qué equipo viene a ganar y cuál viene por la merienda?", en: "Which team is here to win and which one is here for snacks?", pt: "Que equipa vem para ganhar e qual vem pela merenda?", it: "Quale squadra viene per vincere e quale per la merenda?", fr: "Quelle équipe vient pour gagner et laquelle pour le goûter ?" },
    { es: "Aquí hay talento… y también mucha confianza. Veremos cuál pesa más.", en: "There's talent here… and plenty of confidence. We'll see which weighs more.", pt: "Há talento… e muita confiança. Veremos o que pesa mais.", it: "C'è talento… e tanta fiducia. Vedremo cosa pesa di più.", fr: "Il y a du talent… et beaucoup de confiance. On verra ce qui l'emporte." },
    { es: "Se aceptan pronósticos, excusas y teorías conspirativas.", en: "Predictions, excuses, and conspiracy theories are welcome.", pt: "Aceitam-se prognósticos, desculpas e teorias da conspiração.", it: "Si accettano pronostici, scuse e teorie del complotto.", fr: "Pronostics, excuses et théories du complot bienvenus." },
    { es: "Un reparto justo. Las quejas creativas también cuentan como participación.", en: "A fair split. Creative complaints count as participation too.", pt: "Um reparto justo. Reclamações criativas também contam como participação.", it: "Un sorteggio equo. Anche le lamentele creative contano come partecipazione.", fr: "Un tirage équitable. Les plaintes créatives comptent aussi comme participation." },
    { es: "No importa quién quede contigo. Importa quién termina pidiendo revancha.", en: "It doesn't matter who you're with. It matters who asks for a rematch.", pt: "Não importa com quem ficas. Importa quem pede a revanche.", it: "Non importa con chi finisci. Importa chi chiede la rivincita.", fr: "Peu importe avec qui tu es. Importe qui demande la revanche." },
    { es: "Tarci repartió. Ahora os toca demostrar que no era suerte.", en: "Tarci made the draw. Now prove it wasn't luck.", pt: "A Tarci repartiu. Agora provem que não foi sorte.", it: "Tarci ha sorteggiato. Ora dimostrate che non era fortuna.", fr: "Tarci a tiré au sort. Prouvez maintenant que ce n'était pas de la chance." },
    { es: "Hay equipos que inspiran respeto y otros que inspiran memes.", en: "Some teams inspire respect; others inspire memes.", pt: "Há equipas que inspiram respeito e outras que inspiram memes.", it: "Ci sono squadre che ispirano rispetto e altre che ispirano meme.", fr: "Certaines équipes inspirent le respect, d'autres des mèmes." },
    { es: "El azar habló. La dignidad se resuelve el día del encuentro.", en: "Chance has spoken. Dignity gets settled on game day.", pt: "O acaso falou. A dignidade resolve-se no dia do encontro.", it: "Il caso ha parlato. La dignità si risolve il giorno dell'incontro.", fr: "Le hasard a parlé. La dignité se règle le jour J." },
    { es: "Que nadie subestime a un equipo silencioso.", en: "Don't underestimate a quiet team.", pt: "Ninguém subestime uma equipa calada.", it: "Non sottovalutate una squadra silenziosa.", fr: "Ne sous-estimez pas une équipe silencieuse." },
    { es: "Algunos ya celebran. Otros están calculando cómo cambiar de equipo sin que se note.", en: "Some are already celebrating. Others are plotting a discreet team swap.", pt: "Alguns já celebram. Outros calculam como mudar de equipa sem ser notado.", it: "Alcuni festeggiano già. Altri calcolano come cambiare squadra senza farsi notare.", fr: "Certains fêtent déjà. D'autres calculent comment changer d'équipe discrètement." },
    { es: "Resultado publicado. Empieza oficialmente el salseo.", en: "Results are out. The drama officially begins.", pt: "Resultado publicado. Começa oficialmente o drama.", it: "Risultato pubblicato. Il dramma ufficiale inizia ora.", fr: "Résultat publié. Le drama officiel commence." },
    { es: "Hay química de equipo… o al menos eso dice la estadística emocional.", en: "Team chemistry… or so says the emotional stats.", pt: "Há química de equipa… ou pelo menos diz a estatística emocional.", it: "C'è chimica di squadra… o almeno dice la statistica emotiva.", fr: "De la chimie d'équipe… du moins selon les stats émotionnelles." },
    { es: "Un buen equipo se construye. Uno legendario se presume antes de jugar.", en: "Good teams are built. Legendary ones brag before playing.", pt: "Uma boa equipa constrói-se. Uma lendária presume-se antes de jogar.", it: "Una buona squadra si costruisce. Una leggendaria si vanta prima di giocare.", fr: "Une bonne équipe se construit. Une légendaire se vante avant de jouer." },
    { es: "El grupo ya tiene reparto. Ahora falta la épica.", en: "The group has its lineup. Now bring the epic.", pt: "O grupo já tem reparto. Agora falta a épica.", it: "Il gruppo ha il sorteggio. Manca l'epica.", fr: "Le groupe a son tirage. Il manque l'épopée." },
    { es: "A partir de aquí, cada mensaje puede convertirse en motivación para el rival.", en: "From here on, every message can fuel the rivalry.", pt: "Daqui em diante, cada mensagem pode motivar o rival.", it: "Da qui, ogni messaggio può alimentare la rivalità.", fr: "Désormais, chaque message peut motiver le rival." },
    { es: "Equipos formados. El orgullo grupal queda activado.", en: "Teams formed. Group pride is now active.", pt: "Equipas formadas. O orgulho de grupo está ativo.", it: "Squadre formate. L'orgoglio di gruppo è attivo.", fr: "Équipes formées. La fierté collective est activée." },
    { es: "Ya podéis inventar nombre de guerra, aunque Tarci aún no lo guarde.", en: "You can invent war names now—Tarci doesn't store them yet.", pt: "Já podem inventar nome de guerra, embora a Tarci ainda não guarde.", it: "Potete inventarvi un nome da guerra, anche se Tarci non lo salva ancora.", fr: "Inventez un nom de guerre—Tarci ne le garde pas encore." },
    { es: "Que empiece la parte favorita: opinar sobre si el reparto fue justo.", en: "Time for the best part: debating if the split was fair.", pt: "Comece a parte favorita: opinar se o reparto foi justo.", it: "Inizia la parte migliore: discutere se il sorteggio era giusto.", fr: "Place à la meilleure partie : débattre si le tirage était juste." },
    { es: "Tarci no toma partido. Pero sí guarda capturas mentales del pique.", en: "Tarci stays neutral. But mentally screenshots the banter.", pt: "A Tarci não toma partido. Mas guarda capturas mentais do pique.", it: "Tarci non prende partito. Ma tiene screenshot mentali dello sfotto.", fr: "Tarci reste neutre. Mais garde des captures mentales du pique." }
  ],
  challenge: [
    { es: "Reto del día: cada equipo debe explicar por qué merece ganar.", en: "Today's challenge: each team must explain why it deserves to win.", pt: "Desafio do dia: cada equipa deve explicar por que merece ganhar.", it: "Sfida del giorno: ogni squadra spieghi perché merita di vincere.", fr: "Défi du jour : chaque équipe doit expliquer pourquoi elle mérite de gagner." },
    { es: "¿Quién se atreve a lanzar el primer desafío amistoso?", en: "Who dares to throw the first friendly challenge?", pt: "Quem se atreve a lançar o primeiro desafio amigável?", it: "Chi osa lanciare la prima sfida amichevole?", fr: "Qui ose lancer le premier défi amical ?" },
    { es: "Equipo que no escriba hoy, empieza perdiendo en carisma.", en: "A team that doesn't post today starts losing on charisma.", pt: "Equipa que não escrever hoje começa a perder em carisma.", it: "La squadra che non scrive oggi perde a livello di carisma.", fr: "L'équipe qui ne poste pas aujourd'hui perd en charisme." },
    { es: "Propongo una norma no oficial: quien más hable, luego tiene que responder.", en: "Unofficial rule: whoever talks most has to answer back.", pt: "Regra não oficial: quem mais falar depois tem de responder.", it: "Regola non ufficiale: chi parla di più poi deve rispondere.", fr: "Règle officieuse : celui qui parle le plus doit répondre." },
    { es: "¿Hay favorito o todavía fingimos humildad?", en: "Is there a favorite or are we still pretending to be humble?", pt: "Há favorito ou ainda fingimos humildade?", it: "C'è un favorito o fingiamo ancora umiltà?", fr: "Y a-t-il un favori ou fait-on encore semblant d'être humbles ?" },
    { es: "Dejad constancia aquí: ¿qué equipo se lleva la gloria?", en: "Leave your mark: which team takes the glory?", pt: "Deixem constância: que equipa leva a glória?", it: "Lasciate il segno: quale squadra si prende la gloria?", fr: "Laissez une trace : quelle équipe remporte la gloire ?" },
    { es: "Un reto suave: haced vuestra predicción antes del encuentro.", en: "Soft challenge: make your prediction before the meetup.", pt: "Desafio suave: façam a vossa previsão antes do encontro.", it: "Sfida leggera: fate la previsione prima dell'incontro.", fr: "Défi doux : faites votre prédiction avant le jour J." },
    { es: "Si hay confianza, que haya apuestas simbólicas.", en: "If there's confidence, let's have symbolic bets.", pt: "Se há confiança, que haja apostas simbólicas.", it: "Se c'è fiducia, che ci siano scommesse simboliche.", fr: "S'il y a confiance, faisons des paris symboliques." },
    { es: "¿Qué equipo trae estrategia y cuál trae puro corazón?", en: "Which team brings strategy and which brings pure heart?", pt: "Que equipa traz estratégia e qual traz puro coração?", it: "Quale squadra porta strategia e quale solo cuore?", fr: "Quelle équipe apporte la stratégie et laquelle le cœur pur ?" },
    { es: "Momento de declarar intenciones. El silencio no puntúa.", en: "Time to declare intentions. Silence scores zero.", pt: "Momento de declarar intenções. O silêncio não pontua.", it: "Momento di dichiarare le intenzioni. Il silenzio non fa punti.", fr: "Moment de déclarer ses intentions. Le silence ne marque pas." },
    { es: "Que cada equipo nombre a su portavoz espontáneo. Luego negáis haberlo elegido.", en: "Each team picks a spontaneous spokesperson. Then deny you chose them.", pt: "Cada equipa nomeie um porta-voz espontâneo. Depois neguem que o escolheram.", it: "Ogni squadra nomini un portavoce spontaneo. Poi negate di averlo scelto.", fr: "Chaque équipe nomme un porte-parole spontané. Puis niez l'avoir choisi." },
    { es: "¿Quién rompe el hielo con la primera provocación elegante?", en: "Who breaks the ice with the first classy provocation?", pt: "Quem parte o gelo com a primeira provocação elegante?", it: "Chi rompe il ghiaccio con la prima provocazione elegante?", fr: "Qui brise la glace avec la première provocation élégante ?" }
  ],
  quiet: [
    { es: "Mucho silencio para unos equipos tan prometedores.", en: "Very quiet for such promising teams.", pt: "Muito silêncio para equipas tão promissoras.", it: "Molto silenzio per squadre così promettenti.", fr: "Bien silencieux pour des équipes si prometteuses." },
    { es: "Este chat está más tranquilo que un banquillo antes del pitido inicial.", en: "This chat is quieter than the bench before kickoff.", pt: "Este chat está mais calmo que o banco antes do apito inicial.", it: "Questa chat è più tranquilla della panchina prima del fischio.", fr: "Ce chat est plus calme que le banc avant le coup d'envoi." },
    { es: "¿Nadie va a comentar el reparto? Sospechoso.", en: "Nobody going to comment on the lineup? Suspicious.", pt: "Ninguém vai comentar o reparto? Suspeito.", it: "Nessuno commenterà il sorteggio? Sospetto.", fr: "Personne ne commente le tirage ? Suspect." },
    { es: "Tarci detecta calma. A veces eso significa estrategia.", en: "Tarci senses calm. Sometimes that means strategy.", pt: "A Tarci deteta calma. Às vezes isso significa estratégia.", it: "Tarci rileva calma. A volte significa strategia.", fr: "Tarci détecte le calme. Parfois c'est de la stratégie." },
    { es: "Los equipos están hechos. El chat aún espera su primer buen pique.", en: "Teams are set. The chat still waits for its first good banter.", pt: "As equipas estão feitas. O chat ainda espera o primeiro bom pique.", it: "Le squadre ci sono. La chat aspetta ancora il primo bello sfotto.", fr: "Les équipes sont faites. Le chat attend encore son premier bon pique." },
    { es: "Un grupo en silencio no es paz: es tensión dramática.", en: "A silent group isn't peace—it's dramatic tension.", pt: "Um grupo em silêncio não é paz: é tensão dramática.", it: "Un gruppo silenzioso non è pace: è tensione drammatica.", fr: "Un groupe silencieux n'est pas la paix : c'est de la tension." },
    { es: "¿Todo el mundo conforme? Esa unanimidad merece revisión.", en: "Everyone happy? That unanimity deserves a review.", pt: "Todos conformes? Essa unanimidade merece revisão.", it: "Tutti d'accordo? Quell'unanimità merita una revisione.", fr: "Tout le monde d'accord ? Cette unanimité mérite un examen." },
    { es: "Silencio táctico activado. Continuad, que queda elegante.", en: "Tactical silence activated. Carry on—it stays elegant.", pt: "Silêncio tático ativado. Continuem, fica elegante.", it: "Silenzio tattico attivato. Continuate, resta elegante.", fr: "Silence tactique activé. Continuez, ça reste élégant." }
  ],
  countdown: [
    { key: "014", days: 14, es: "Faltan 14 días. Tiempo de organizarse… o de improvisar con confianza.", en: "14 days left. Time to organize… or improvise with confidence.", pt: "Faltam 14 dias. Tempo de organizar… ou improvisar com confiança.", it: "Mancano 14 giorni. Tempo di organizzarsi… o improvvisare con fiducia.", fr: "Plus que 14 jours. Temps de s'organiser… ou d'improviser avec confiance." },
    { key: "007", days: 7, es: "Falta una semana. Las estrategias absurdas ya pueden presentarse oficialmente.", en: "One week to go. Absurd strategies may now apply officially.", pt: "Falta uma semana. Estratégias absurdas já podem apresentar-se oficialmente.", it: "Manca una settimana. Le strategie assurde possono presentarsi ufficialmente.", fr: "Plus qu'une semaine. Les stratégies absurdes peuvent officiellement se présenter." },
    { key: "003", days: 3, es: "Quedan 3 días. A estas alturas la épica está permitida.", en: "3 days left. Epic energy is allowed now.", pt: "Faltam 3 dias. A esta altura a épica é permitida.", it: "Restano 3 giorni. A questo punto l'epica è permessa.", fr: "Plus que 3 jours. L'épopée est autorisée maintenant." },
    { key: "001", days: 1, es: "Mañana es el día. Última oportunidad para presumir sin consecuencias.", en: "Tomorrow's the day. Last chance to brag without consequences.", pt: "Amanhã é o dia. Última oportunidade para presumir sem consequências.", it: "Domani è il giorno. Ultima chance di vantarsi senza conseguenze.", fr: "C'est demain. Dernière chance de se vanter sans conséquences." },
    { key: "000", days: 0, es: "Hoy toca. Equipos listos, nervios opcionales.", en: "Today's the day. Teams ready, nerves optional.", pt: "Hoje é o dia. Equipas prontas, nervos opcionais.", it: "Oggi si gioca. Squadre pronte, nervi opzionali.", fr: "C'est aujourd'hui. Équipes prêtes, nerfs optionnels." },
    { key: "extra001", es: "Dos semanas parecen mucho hasta que alguien recuerda que no ha preparado nada.", en: "Two weeks feels long until someone remembers they prepared nothing.", pt: "Duas semanas parecem muito até alguém lembrar que não preparou nada.", it: "Due settimane sembrano tante finché qualcuno ricorda di non aver preparato nulla.", fr: "Deux semaines paraissent longues jusqu'à ce que quelqu'un se souvienne qu'il n'a rien préparé." },
    { key: "extra002", es: "Siete días. Lo suficiente para entrenar o para perfeccionar una buena excusa.", en: "Seven days. Enough to train or perfect a good excuse.", pt: "Sete dias. Suficiente para treinar ou aperfeiçoar uma boa desculpa.", it: "Sette giorni. Abbastanza per allenarsi o perfezionare una scusa.", fr: "Sept jours. De quoi s'entraîner ou peaufiner une bonne excuse." },
    { key: "extra003", es: "Tres días. El chat puede pasar de bromas a declaraciones oficiales.", en: "Three days. The chat can go from jokes to official statements.", pt: "Três dias. O chat pode passar de brincadeiras a declarações oficiais.", it: "Tre giorni. La chat può passare da battute a dichiarazioni ufficiali.", fr: "Trois jours. Le chat peut passer des blagues aux déclarations officielles." },
    { key: "extra004", es: "Queda un día. Si había un plan secreto, es buen momento para fingir que existe.", en: "One day left. If there was a secret plan, good time to pretend it exists.", pt: "Falta um dia. Se havia um plano secreto, bom momento para fingir que existe.", it: "Resta un giorno. Se c'era un piano segreto, è il momento di fingere che esista.", fr: "Plus qu'un jour. S'il y avait un plan secret, bon moment pour faire semblant." },
    { key: "extra005", es: "Llegó el momento. Que gane el mejor… o el que mejor lo disimule.", en: "It's time. May the best win… or the best at hiding it.", pt: "Chegou o momento. Que ganhe o melhor… ou quem melhor o disfarce.", it: "È il momento. Che vinca il migliore… o chi lo nasconde meglio.", fr: "C'est le moment. Que le meilleur gagne… ou le meilleur camouflé." }
  ]
};

function arbKey(category, num) {
  const cap = category.charAt(0).toUpperCase() + category.slice(1);
  const pad = String(num).padStart(3, "0");
  return `chatSystemAutoTeams${cap}${pad}V1`;
}

function templateKey(category, num, extra) {
  if (category === "countdown" && extra) return `chat.system.auto.teams.countdown.${extra}.v1`;
  const pad = String(num).padStart(3, "0");
  return `chat.system.auto.teams.${category}.${pad}.v1`;
}

function dartGetter(category, num) {
  const cap = category.charAt(0).toUpperCase() + category.slice(1);
  const pad = String(num).padStart(3, "0");
  return `chatSystemAutoTeams${cap}${pad}V1`;
}

const catalogEntries = [];
const dartCases = [];
const arbByLocale = { es: {}, en: {}, pt: {}, it: {}, fr: {} };

for (let i = 0; i < messages.playful.length; i++) {
  const n = i + 1;
  const tk = templateKey("playful", n);
  const ak = arbKey("playful", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "teamsPlayful", scope: "teams" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("playful", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = messages.playful[i][loc];
}
for (let i = 0; i < messages.challenge.length; i++) {
  const n = i + 1;
  const tk = templateKey("challenge", n);
  const ak = arbKey("challenge", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "teamsChallenge", scope: "teams" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("challenge", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = messages.challenge[i][loc];
}
for (let i = 0; i < messages.quiet.length; i++) {
  const n = i + 1;
  const tk = templateKey("quiet", n);
  const ak = arbKey("quiet", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "teamsQuietNudge", scope: "teams" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("quiet", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = messages.quiet[i][loc];
}
messages.countdown.forEach((c, i) => {
  const n = i + 1;
  const tk = c.key.startsWith("extra") ? templateKey("countdown", 0, c.key) : templateKey("countdown", 0, String(c.days).padStart(3, "0"));
  const ak = c.key.startsWith("extra")
    ? `chatSystemAutoTeamsCountdown${c.key.charAt(0).toUpperCase() + c.key.slice(1)}V1`
    : `chatSystemAutoTeamsCountdown${String(c.days).padStart(3, "0")}V1`;
  const daysPart = c.days != null ? `, daysBeforeEvent: ${c.days}` : "";
  catalogEntries.push(`  { templateKey: "${tk}", category: "teamsCountdown", scope: "teams"${daysPart} },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${ak};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = c[loc];
});

const teamsUi = {
  teamsChatSectionTitle: {
    es: "Conversación del grupo",
    en: "Group conversation",
    pt: "Conversa do grupo",
    it: "Conversazione di gruppo",
    fr: "Conversation du groupe"
  },
  teamsChatSectionSubtitle: {
    es: "Comentad el reparto, retos y el día del encuentro.",
    en: "Discuss the lineup, challenges, and game day.",
    pt: "Comentem o reparto, desafios e o dia do encontro.",
    it: "Commentate il sorteggio, le sfide e il giorno dell'incontro.",
    fr: "Commentez le tirage, les défis et le jour J."
  },
  teamsChatEnterCta: {
    es: "Abrir chat",
    en: "Open chat",
    pt: "Abrir chat",
    it: "Apri chat",
    fr: "Ouvrir le chat"
  },
  chatTeamsCompletedChip: {
    es: "Equipos listos",
    en: "Teams ready",
    pt: "Equipas prontas",
    it: "Squadre pronte",
    fr: "Équipes prêtes"
  }
};
for (const [k, v] of Object.entries(teamsUi)) {
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][k] = v[loc];
}

// teamsCompleted system message
const teamsCompleted = {
  es: "Los equipos ya están listos. Ahora sí: que empiece el pique.",
  en: "Teams are ready. Let the friendly banter begin.",
  pt: "As equipas já estão prontas. Agora sim: que comece o pique.",
  it: "Le squadre sono pronte. Ora sì: che inizi lo sfotto.",
  fr: "Les équipes sont prêtes. Maintenant : que le pique commence."
};
for (const loc of ["es", "en", "pt", "it", "fr"]) {
  arbByLocale[loc].chatSystemTeamsCompletedV1 = teamsCompleted[loc];
}

function appendArb(locale, entries) {
  const p = path.join(root, "src/flutter_app/lib/l10n", `app_${locale}.arb`);
  let raw = fs.readFileSync(p, "utf8");
  const insert = Object.entries(entries)
    .map(([k, v]) => `  "${k}": ${JSON.stringify(v)}`)
    .join(",\n");
  raw = raw.replace(/\n}\s*$/, `,\n${insert}\n}\n`);
  fs.writeFileSync(p, raw);
}

for (const loc of ["es", "en", "pt", "it", "fr"]) appendArb(loc, arbByLocale[loc]);

const catalogTs = `/** Catálogo automático Tarci para Equipos (metadatos; textos en ARB). */\n\nexport type TeamsAutoCategory =\n  | "teamsPlayful"\n  | "teamsChallenge"\n  | "teamsQuietNudge"\n  | "teamsCountdown";\n\nexport type TeamsCatalogEntry = {\n  templateKey: string;\n  category: TeamsAutoCategory;\n  scope: "teams";\n  daysBeforeEvent?: number;\n};\n\nexport const TARCI_TEAMS_AUTO_CATALOG: TeamsCatalogEntry[] = [\n${catalogEntries.join("\n")}\n];\n\nexport const TEAMS_COUNTDOWN_TEMPLATE_BY_DAYS = new Map<number, string>(\n  TARCI_TEAMS_AUTO_CATALOG.filter((e) => e.category === "teamsCountdown" && e.daysBeforeEvent !== undefined).map((e) => [\n    e.daysBeforeEvent!,\n    e.templateKey\n  ])\n);\n`;
fs.writeFileSync(path.join(root, "src/firebase_functions/src/shared/tarciAutoCatalogTeams.ts"), catalogTs);

const dartPath = path.join(root, "src/flutter_app/lib/features/chat/presentation/tarci_auto_chat_l10n.dart");
let dart = fs.readFileSync(dartPath, "utf8");
const teamsBlock = `\n    ${dartCases.join("\n")}\n`;
dart = dart.replace(
  /(case 'chat\.system\.auto\.countdown\.000\.v1':[\s\S]*?return l10n\.chatSystemAutoCountdown000V1;)/,
  `$1${teamsBlock}`
);
dart = dart.replace(
  /(case 'chat\.system\.drawCompleted\.v1':)/,
  `    case 'chat.system.teamsCompleted.v1':\n      return l10n.chatSystemTeamsCompletedV1;\n    $1`
);
fs.writeFileSync(dartPath, dart);

console.log("Generated teams i18n + catalog (" + catalogEntries.length + " auto messages)");
