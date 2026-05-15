/**
 * Genera ARB (5 idiomas), catálogo TS y casos Dart para mensajes Tarci Duelos.
 * Ejecutar: node scripts/gen-duels-tarci-i18n.mjs
 */
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, "..");

const teamsPath = path.join(root, "scripts/gen-teams-tarci-i18n.mjs");
const teamsSrc = fs.readFileSync(teamsPath, "utf8");
const start = teamsSrc.indexOf("const messages = ");
const endMarker = teamsSrc.indexOf("\n};", start);
if (start < 0 || endMarker < 0) throw new Error("messages block not found");
const objLiteral = teamsSrc.slice(start + "const messages = ".length, endMarker + 2);
const messages = Function(`"use strict"; return (${objLiteral});`)();

function adaptText(text) {
  return text
    .replace(/\bTeams\b/g, "Duels")
    .replace(/\bteams\b/g, "duels")
    .replace(/\bTeam\b/g, "Duel")
    .replace(/\bteam\b/g, "duel")
    .replace(/\bEquipos\b/g, "Duelos")
    .replace(/\bequipos\b/g, "duelos")
    .replace(/\bEquipo\b/g, "Duelo")
    .replace(/\bequipo\b/g, "duelo")
    .replace(/\bEquipas\b/g, "Duelos")
    .replace(/\bequipas\b/g, "duelos")
    .replace(/\bEquipa\b/g, "Duelo")
    .replace(/\bSquadre\b/g, "Duelli")
    .replace(/\bsquadre\b/g, "duelli")
    .replace(/\bSquadra\b/g, "Duello")
    .replace(/\bÉquipes\b/g, "Duels")
    .replace(/\béquipes\b/g, "duels")
    .replace(/\bÉquipe\b/g, "Duel")
    .replace(/\bEmparelhamentos\b/g, "Duelos")
    .replace(/\bAbbinamenti\b/g, "Duelli")
    .replace(/\bAppariements\b/g, "Duels")
    .replace(/\breparto\b/g, "enfrentamiento")
    .replace(/\blineup\b/g, "matchups")
    .replace(/\brivalry\b/g, "rivalry")
    .replace(/\bbanter\b/g, "banter");
}

function adaptMsg(m) {
  const out = {};
  for (const loc of ["es", "en", "pt", "it", "fr"]) out[loc] = adaptText(m[loc]);
  if (m.days != null) out.days = m.days;
  if (m.key) out.key = m.key;
  return out;
}

const duelsMessages = {
  playful: messages.playful.map(adaptMsg),
  challenge: messages.challenge.map(adaptMsg),
  quiet: messages.quiet.map(adaptMsg),
  countdown: messages.countdown.map(adaptMsg)
};

function arbKey(category, num) {
  const cap = category.charAt(0).toUpperCase() + category.slice(1);
  const pad = String(num).padStart(3, "0");
  return `chatSystemAutoDuels${cap}${pad}V1`;
}

function templateKey(category, num, extra) {
  if (category === "countdown" && extra) return `chat.system.auto.duels.countdown.${extra}.v1`;
  const pad = String(num).padStart(3, "0");
  return `chat.system.auto.duels.${category}.${pad}.v1`;
}

function dartGetter(category, num) {
  const cap = category.charAt(0).toUpperCase() + category.slice(1);
  const pad = String(num).padStart(3, "0");
  return `chatSystemAutoDuels${cap}${pad}V1`;
}

const catalogEntries = [];
const dartCases = [];
const arbByLocale = { es: {}, en: {}, pt: {}, it: {}, fr: {} };

for (let i = 0; i < duelsMessages.playful.length; i++) {
  const n = i + 1;
  const tk = templateKey("playful", n);
  const ak = arbKey("playful", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "duelsPlayful", scope: "duels" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("playful", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = duelsMessages.playful[i][loc];
}
for (let i = 0; i < duelsMessages.challenge.length; i++) {
  const n = i + 1;
  const tk = templateKey("challenge", n);
  const ak = arbKey("challenge", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "duelsChallenge", scope: "duels" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("challenge", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = duelsMessages.challenge[i][loc];
}
for (let i = 0; i < duelsMessages.quiet.length; i++) {
  const n = i + 1;
  const tk = templateKey("quiet", n);
  const ak = arbKey("quiet", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "duelsQuietNudge", scope: "duels" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("quiet", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = duelsMessages.quiet[i][loc];
}
duelsMessages.countdown.forEach((c) => {
  const tk = c.key.startsWith("extra") ? templateKey("countdown", 0, c.key) : templateKey("countdown", 0, String(c.days).padStart(3, "0"));
  const ak = c.key.startsWith("extra")
    ? `chatSystemAutoDuelsCountdown${c.key.charAt(0).toUpperCase() + c.key.slice(1)}V1`
    : `chatSystemAutoDuelsCountdown${String(c.days).padStart(3, "0")}V1`;
  const daysPart = c.days != null ? `, daysBeforeEvent: ${c.days}` : "";
  catalogEntries.push(`  { templateKey: "${tk}", category: "duelsCountdown", scope: "duels"${daysPart} },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${ak};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = c[loc];
});

const duelsUi = {
  dynamicsCardDuelsBody: {
    es: "Crea enfrentamientos uno contra uno para retos, juegos y dinámicas con más pique.",
    en: "Create one-on-one matchups for challenges, games, and dynamics with extra spark.",
    pt: "Cria confrontos um contra um para desafios, jogos e dinâmicas com mais pique.",
    it: "Crea scontri uno contro uno per sfide, giochi e dinamiche con più grinta.",
    fr: "Crée des affrontements un contre un pour défis, jeux et dynamiques plus piquantes."
  },
  homeDynamicTypeDuels: { es: "Duelos", en: "Duels", pt: "Duelos", it: "Duelli", fr: "Duels" },
  homeDuelsStateCompleted: { es: "Duelos listos", en: "Duels ready", pt: "Duelos prontos", it: "Duelli pronti", fr: "Duels prêts" },
  homeDuelsStatePreparing: { es: "Preparando duelos", en: "Preparing duels", pt: "A preparar duelos", it: "Preparazione duelli", fr: "Préparation des duels" },
  duelsWizardTitle: { es: "Crear duelos", en: "Create duels", pt: "Criar duelos", it: "Crea duelli", fr: "Créer des duels" },
  duelsWizardCreateCta: { es: "Crear duelos", en: "Create duels", pt: "Criar duelos", it: "Crea duelli", fr: "Créer des duels" },
  duelsWizardNameLabel: { es: "Nombre de la dinámica", en: "Dynamic name", pt: "Nome da dinâmica", it: "Nome della dinamica", fr: "Nom de la dynamique" },
  duelsWizardOwnerNicknameLabel: { es: "Tu nombre en los duelos", en: "Your name in the duels", pt: "O teu nome nos duelos", it: "Il tuo nome nei duelli", fr: "Ton nom dans les duels" },
  duelsWizardOwnerNicknameHelper: { es: "Así te verán los demás en los enfrentamientos.", en: "How others will see you in the matchups.", pt: "Como os outros te verão nos confrontos.", it: "Come ti vedranno gli altri negli scontri.", fr: "Comment les autres te verront dans les affrontements." },
  duelsWizardEventOptional: { es: "Fecha del evento (opcional)", en: "Event date (optional)", pt: "Data do evento (opcional)", it: "Data evento (opzionale)", fr: "Date de l'événement (optionnel)" },
  duelsWizardPickEventDate: { es: "Elegir fecha", en: "Pick date", pt: "Escolher data", it: "Scegli data", fr: "Choisir une date" },
  duelsWizardOwnerParticipatesTitle: { es: "¿Participas tú?", en: "Are you participating?", pt: "Participas?", it: "Partecipi?", fr: "Tu participes ?" },
  duelsWizardOwnerParticipatesYes: { es: "Sí, quiero estar en un duelo", en: "Yes, I want to be in a duel", pt: "Sim, quero estar num duelo", it: "Sì, voglio essere in un duello", fr: "Oui, je veux être dans un duel" },
  duelsWizardOwnerParticipatesNo: { es: "No, solo organizo", en: "No, I only organize", pt: "Não, só organizo", it: "No, organizzo solo", fr: "Non, j'organise seulement" },
  duelsWizardReviewTitle: { es: "Revisión", en: "Review", pt: "Revisão", it: "Revisione", fr: "Vérification" },
  duelsWizardReviewSummary: { es: "Enfrentamientos 1 vs 1 · número par necesario", en: "1 vs 1 matchups · even count required", pt: "Confrontos 1 vs 1 · número par necessário", it: "Scontri 1 vs 1 · numero pari necessario", fr: "Affrontements 1 vs 1 · nombre pair requis" },
  duelsUnitLabel: { es: "Duelo {index}", en: "Duel {index}", pt: "Duelo {index}", it: "Duello {index}", fr: "Duel {index}" },
  duelsVsLabel: { es: "vs", en: "vs", pt: "vs", it: "vs", fr: "vs" },
  duelsResultHeroTitle: { es: "¡Duelos listos!", en: "Duels are ready!", pt: "Duelos prontos!", it: "Duelli pronti!", fr: "Les duels sont prêts !" },
  duelsResultHeroSubtitle: { es: "Ya sabéis quién se enfrenta a quién.", en: "You know who faces whom.", pt: "Já sabem quem enfrenta quem.", it: "Sapete chi affronta chi.", fr: "Vous savez qui affronte qui." },
  duelsResultSummary: { es: "{count} duelos · {eligible} participantes", en: "{count} duels · {eligible} participants", pt: "{count} duelos · {eligible} participantes", it: "{count} duelli · {eligible} partecipanti", fr: "{count} duels · {eligible} participants" },
  duelsDetailListTitle: { es: "Duelos", en: "Duels", pt: "Duelos", it: "Duelli", fr: "Duels" },
  duelsDetailFormCta: { es: "Generar duelos", en: "Generate duels", pt: "Gerar duelos", it: "Genera duelli", fr: "Générer les duels" },
  duelsDetailConfigTitle: { es: "Configuración", en: "Configuration", pt: "Configuração", it: "Configurazione", fr: "Configuration" },
  duelsDetailConfigSummary: { es: "Aproximadamente {count} duelos", en: "About {count} duels", pt: "Cerca de {count} duelos", it: "Circa {count} duelli", fr: "Environ {count} duels" },
  duelsRenameDialogTitle: { es: "Renombrar duelo", en: "Rename duel", pt: "Renomear duelo", it: "Rinomina duello", fr: "Renommer le duel" },
  duelsRenameDialogFieldLabel: { es: "Nombre del duelo", en: "Duel name", pt: "Nome do duelo", it: "Nome del duello", fr: "Nom du duel" },
  duelsRenameSuccess: { es: "Nombre del duelo actualizado", en: "Duel name updated", pt: "Nome do duelo atualizado", it: "Nome del duello aggiornato", fr: "Nom du duel mis à jour" },
  duelsShareBody: { es: "⚔️ Duelos generados en «{groupName}»:\n\n{blocks}\n\nHecho con Tarci Secret.", en: "⚔️ Duels generated for «{groupName}»:\n\n{blocks}\n\nMade with Tarci Secret.", pt: "⚔️ Duelos gerados em «{groupName}»:\n\n{blocks}\n\nFeito com Tarci Secret.", it: "⚔️ Duelli generati per «{groupName}»:\n\n{blocks}\n\nCreato con Tarci Secret.", fr: "⚔️ Duels générés pour « {groupName} » :\n\n{blocks}\n\nFait avec Tarci Secret." },
  duelsEmailSubject: { es: "Duelos generados — {groupName}", en: "Duels generated — {groupName}", pt: "Duelos gerados — {groupName}", it: "Duelli generati — {groupName}", fr: "Duels générés — {groupName}" },
  duelsEmailBody: { es: "Hola,\n\nYa están listos los duelos de «{groupName}»:\n\n{blocks}\n\nGenerado con Tarci Secret.", en: "Hi,\n\nThe duels for «{groupName}» are ready:\n\n{blocks}\n\nGenerated with Tarci Secret.", pt: "Olá,\n\nOs duelos de «{groupName}» estão prontos:\n\n{blocks}\n\nGerado com Tarci Secret.", it: "Ciao,\n\nI duelli di «{groupName}» sono pronti:\n\n{blocks}\n\nGenerato con Tarci Secret.", fr: "Bonjour,\n\nLes duels de « {groupName} » sont prêts :\n\n{blocks}\n\nGénéré avec Tarci Secret." },
  duelsPdfHeadline: { es: "Duelos generados", en: "Duels generated", pt: "Duelos gerados", it: "Duelli generati", fr: "Duels générés" },
  duelsChatSectionTitle: { es: "Conversación del grupo", en: "Group conversation", pt: "Conversa do grupo", it: "Conversazione di gruppo", fr: "Conversation du groupe" },
  duelsChatSectionSubtitle: { es: "Lanza retos, bromea y calienta el ambiente antes de los duelos.", en: "Drop challenges, joke around, and heat things up before the duels.", pt: "Lança desafios, brinca e aquece o ambiente antes dos duelos.", it: "Lancia sfide, scherza e scalda l'ambiente prima dei duelli.", fr: "Lance des défis, plaisante et chauffe l'ambiance avant les duels." },
  duelsChatEnterCta: { es: "Abrir chat", en: "Open chat", pt: "Abrir chat", it: "Apri chat", fr: "Ouvrir le chat" },
  chatDuelsCompletedChip: { es: "Duelos listos", en: "Duels ready", pt: "Duelos prontos", it: "Duelli pronti", fr: "Duels prêts" },
  chatSystemDuelsCompletedV1: { es: "Los duelos ya están listos. Ahora sí: que empiece el pique.", en: "The duels are ready. Let the friendly rivalry begin.", pt: "Os duelos já estão prontos. Agora sim: que comece o pique.", it: "I duelli sono pronti. Ora sì: che inizi il pique.", fr: "Les duels sont prêts. Maintenant : que le pique commence." },
  duelsMemberWaitingTitle: { es: "Duelos en preparación", en: "Duels in progress", pt: "Duelos em preparação", it: "Duelli in preparazione", fr: "Duels en préparation" },
  duelsMemberWaitingBody: { es: "Cuando el organizador genere los duelos, podrás ver quién se enfrenta a quién.", en: "When the organizer generates the duels, you'll see who faces whom.", pt: "Quando o organizador gerar os duelos, verás quem enfrenta quem.", it: "Quando l'organizzatore formerà i duelli, vedrai chi affronta chi.", fr: "Quand l'organisateur formera les duels, tu verras qui affronte qui." },
  joinSuccessDuelsSubtitle: { es: "Te uniste a «{groupName}».", en: "You joined «{groupName}».", pt: "Entraste em «{groupName}».", it: "Sei entrato in «{groupName}».", fr: "Tu as rejoint « {groupName} »." },
  joinSuccessDuelsBody: { es: "Cuando el organizador genere los duelos, podrás ver quién se enfrenta a quién.", en: "When the organizer generates the duels, you'll see who faces whom.", pt: "Quando o organizador gerar os duelos, verás quem enfrenta quem.", it: "Quando l'organizzatore formerà i duelli, vedrai chi affronta chi.", fr: "Quand l'organisateur formera les duels, tu verras qui affronte qui." },
  joinSuccessDuelsPrimaryCta: { es: "Ir a duelos", en: "Go to duels", pt: "Ir aos duelos", it: "Vai ai duelli", fr: "Aller aux duels" },
  duelsDetailMinPoolHint: { es: "Necesitas al menos 2 participantes para generar duelos.", en: "You need at least 2 participants to generate duels.", pt: "Precisas de pelo menos 2 participantes para gerar duelos.", it: "Servono almeno 2 partecipanti per generare i duelli.", fr: "Il faut au moins 2 participants pour générer des duels." },
  duelsDetailEvenHint: { es: "Necesitas un número par de participantes para generar duelos.", en: "You need an even number of participants to generate duels.", pt: "Precisas de um número par de participantes para gerar duelos.", it: "Serve un numero pari di partecipanti per generare i duelli.", fr: "Il faut un nombre pair de participants pour générer des duels." }
};
for (const [k, v] of Object.entries(duelsUi)) {
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][k] = v[loc];
}

function appendArb(locale, entries) {
  const p = path.join(root, "src/flutter_app/lib/l10n", `app_${locale}.arb`);
  let raw = fs.readFileSync(p, "utf8");
  const filtered = {};
  for (const [k, v] of Object.entries(entries)) {
    if (raw.includes(`"${k}"`)) continue;
    filtered[k] = v;
  }
  if (Object.keys(filtered).length === 0) return;
  const insert = Object.entries(filtered)
    .map(([k, v]) => `  "${k}": ${JSON.stringify(v)}`)
    .join(",\n");
  raw = raw.replace(/\n}\s*$/, `,\n${insert}\n}\n`);
  fs.writeFileSync(p, raw);
}

for (const loc of ["es", "en", "pt", "it", "fr"]) appendArb(loc, arbByLocale[loc]);

const catalogTs = `/** Catálogo automático Tarci para Duelos (metadatos; textos en ARB). */

export type DuelsAutoCategory =
  | "duelsPlayful"
  | "duelsChallenge"
  | "duelsQuietNudge"
  | "duelsCountdown";

export type DuelsCatalogEntry = {
  templateKey: string;
  category: DuelsAutoCategory;
  scope: "duels";
  daysBeforeEvent?: number;
};

export const TARCI_DUELS_AUTO_CATALOG: DuelsCatalogEntry[] = [
${catalogEntries.join("\n")}
];

export const DUELS_COUNTDOWN_TEMPLATE_BY_DAYS = new Map<number, string>(
  TARCI_DUELS_AUTO_CATALOG.filter((e) => e.category === "duelsCountdown" && e.daysBeforeEvent !== undefined).map((e) => [
    e.daysBeforeEvent!,
    e.templateKey
  ])
);
`;
fs.writeFileSync(path.join(root, "src/firebase_functions/src/shared/tarciAutoCatalogDuels.ts"), catalogTs);

const dartPath = path.join(root, "src/flutter_app/lib/features/chat/presentation/tarci_auto_chat_l10n.dart");
let dart = fs.readFileSync(dartPath, "utf8");
const block = `${dartCases.join("\n")}\n`;
if (!dart.includes("chat.system.auto.duels.playful.001.v1")) {
  dart = dart.replace(/\n    default:\n      return null;/, `\n${block}    default:\n      return null;`);
}
if (!dart.includes("chat.system.duelsCompleted.v1")) {
  dart = dart.replace(
    /(case 'chat\.system\.pairingsCompleted\.v1':[\s\S]*?return l10n\.chatSystemPairingsCompletedV1;)/,
    `$1\n    case 'chat.system.duelsCompleted.v1':\n      return l10n.chatSystemDuelsCompletedV1;`
  );
}
fs.writeFileSync(dartPath, dart);

console.log("Generated duels i18n + catalog (" + catalogEntries.length + " auto messages)");
