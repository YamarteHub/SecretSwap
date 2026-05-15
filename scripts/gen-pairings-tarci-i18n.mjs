/**
 * Genera ARB (5 idiomas), catálogo TS y casos Dart para mensajes Tarci Parejas.
 * Ejecutar: node scripts/gen-pairings-tarci-i18n.mjs
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
    .replace(/\bTeams\b/g, "Pairs")
    .replace(/\bteams\b/g, "pairs")
    .replace(/\bTeam\b/g, "Pair")
    .replace(/\bteam\b/g, "pair")
    .replace(/\bEquipos\b/g, "Parejas")
    .replace(/\bequipos\b/g, "parejas")
    .replace(/\bEquipo\b/g, "Pareja")
    .replace(/\bequipo\b/g, "pareja")
    .replace(/\bEquipas\b/g, "Parejas")
    .replace(/\bequipas\b/g, "parejas")
    .replace(/\bEquipa\b/g, "Pareja")
    .replace(/\bSquadre\b/g, "Coppie")
    .replace(/\bsquadre\b/g, "coppie")
    .replace(/\bSquadra\b/g, "Coppia")
    .replace(/\bÉquipes\b/g, "Paires")
    .replace(/\béquipes\b/g, "paires")
    .replace(/\bÉquipe\b/g, "Paire")
    .replace(/\béquipe\b/g, "paire")
    .replace(/\bEmparelhamentos\b/g, "Parejas")
    .replace(/\bAbbinamenti\b/g, "Coppie")
    .replace(/\bAppariements\b/g, "Paires")
    .replace(/\breparto\b/g, "emparejamiento")
    .replace(/\blineup\b/g, "pairings")
    .replace(/\brivalry\b/g, "chemistry")
    .replace(/\brivalità\b/g, "chimica")
    .replace(/\brivalité\b/g, "alchimie")
    .replace(/\bpique\b/g, "conversación")
    .replace(/\bbanter\b/g, "chat")
    .replace(/\brematch\b/g, "revancha");
}

function adaptMsg(m) {
  const out = {};
  for (const loc of ["es", "en", "pt", "it", "fr"]) out[loc] = adaptText(m[loc]);
  if (m.days != null) out.days = m.days;
  if (m.key) out.key = m.key;
  return out;
}

const pairingsMessages = {
  playful: messages.playful.map(adaptMsg),
  challenge: messages.challenge.map(adaptMsg),
  quiet: messages.quiet.map(adaptMsg),
  countdown: messages.countdown.map(adaptMsg)
};

function arbKey(category, num) {
  const cap = category.charAt(0).toUpperCase() + category.slice(1);
  const pad = String(num).padStart(3, "0");
  return `chatSystemAutoPairings${cap}${pad}V1`;
}

function templateKey(category, num, extra) {
  if (category === "countdown" && extra) return `chat.system.auto.pairings.countdown.${extra}.v1`;
  const pad = String(num).padStart(3, "0");
  return `chat.system.auto.pairings.${category}.${pad}.v1`;
}

function dartGetter(category, num) {
  const cap = category.charAt(0).toUpperCase() + category.slice(1);
  const pad = String(num).padStart(3, "0");
  return `chatSystemAutoPairings${cap}${pad}V1`;
}

const catalogEntries = [];
const dartCases = [];
const arbByLocale = { es: {}, en: {}, pt: {}, it: {}, fr: {} };

for (let i = 0; i < pairingsMessages.playful.length; i++) {
  const n = i + 1;
  const tk = templateKey("playful", n);
  const ak = arbKey("playful", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "pairingsPlayful", scope: "pairings" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("playful", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = pairingsMessages.playful[i][loc];
}
for (let i = 0; i < pairingsMessages.challenge.length; i++) {
  const n = i + 1;
  const tk = templateKey("challenge", n);
  const ak = arbKey("challenge", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "pairingsChallenge", scope: "pairings" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("challenge", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = pairingsMessages.challenge[i][loc];
}
for (let i = 0; i < pairingsMessages.quiet.length; i++) {
  const n = i + 1;
  const tk = templateKey("quiet", n);
  const ak = arbKey("quiet", n);
  catalogEntries.push(`  { templateKey: "${tk}", category: "pairingsQuietNudge", scope: "pairings" },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${dartGetter("quiet", n)};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = pairingsMessages.quiet[i][loc];
}
pairingsMessages.countdown.forEach((c, i) => {
  const tk = c.key.startsWith("extra") ? templateKey("countdown", 0, c.key) : templateKey("countdown", 0, String(c.days).padStart(3, "0"));
  const ak = c.key.startsWith("extra")
    ? `chatSystemAutoPairingsCountdown${c.key.charAt(0).toUpperCase() + c.key.slice(1)}V1`
    : `chatSystemAutoPairingsCountdown${String(c.days).padStart(3, "0")}V1`;
  const daysPart = c.days != null ? `, daysBeforeEvent: ${c.days}` : "";
  catalogEntries.push(`  { templateKey: "${tk}", category: "pairingsCountdown", scope: "pairings"${daysPart} },`);
  dartCases.push(`    case '${tk}':\n      return l10n.${ak};`);
  for (const loc of ["es", "en", "pt", "it", "fr"]) arbByLocale[loc][ak] = c[loc];
});

for (const loc of ["es", "en", "pt", "it", "fr"]) {
  arbByLocale[loc].chatSystemPairingsCompletedV1 = {
    es: "Las parejas ya están listas. ¡A disfrutar del encuentro!",
    en: "The pairings are ready. Enjoy the meetup!",
    pt: "As parejas já estão prontas. Aproveitem o encontro!",
    it: "Le coppie sono pronte. Buon incontro!",
    fr: "Les paires sont prêtes. Bonne rencontre !"
  }[loc];
}

function appendArb(locale, entries) {
  const p = path.join(root, "src/flutter_app/lib/l10n", `app_${locale}.arb`);
  let raw = fs.readFileSync(p, "utf8");
  const keys = Object.keys(entries);
  const filtered = {};
  for (const k of keys) {
    if (raw.includes(`"${k}"`)) continue;
    filtered[k] = entries[k];
  }
  if (Object.keys(filtered).length === 0) return;
  const insert = Object.entries(filtered)
    .map(([k, v]) => `  "${k}": ${JSON.stringify(v)}`)
    .join(",\n");
  raw = raw.replace(/\n}\s*$/, `,\n${insert}\n}\n`);
  fs.writeFileSync(p, raw);
}

for (const loc of ["es", "en", "pt", "it", "fr"]) appendArb(loc, arbByLocale[loc]);

const catalogTs = `/** Catálogo automático Tarci para Parejas (metadatos; textos en ARB). */

export type PairingsAutoCategory =
  | "pairingsPlayful"
  | "pairingsChallenge"
  | "pairingsQuietNudge"
  | "pairingsCountdown";

export type PairingsCatalogEntry = {
  templateKey: string;
  category: PairingsAutoCategory;
  scope: "pairings";
  daysBeforeEvent?: number;
};

export const TARCI_PAIRINGS_AUTO_CATALOG: PairingsCatalogEntry[] = [
${catalogEntries.join("\n")}
];

export const PAIRINGS_COUNTDOWN_TEMPLATE_BY_DAYS = new Map<number, string>(
  TARCI_PAIRINGS_AUTO_CATALOG.filter((e) => e.category === "pairingsCountdown" && e.daysBeforeEvent !== undefined).map((e) => [
    e.daysBeforeEvent!,
    e.templateKey
  ])
);
`;
fs.writeFileSync(path.join(root, "src/firebase_functions/src/shared/tarciAutoCatalogPairings.ts"), catalogTs);

const dartPath = path.join(root, "src/flutter_app/lib/features/chat/presentation/tarci_auto_chat_l10n.dart");
let dart = fs.readFileSync(dartPath, "utf8");
const block = `${dartCases.join("\n")}\n`;
if (!dart.includes("chat.system.auto.pairings.playful.001.v1")) {
  dart = dart.replace(/\n    default:\n      return null;/, `\n${block}    default:\n      return null;`);
}
fs.writeFileSync(dartPath, dart);

console.log("Generated pairings i18n + catalog (" + catalogEntries.length + " auto messages)");
