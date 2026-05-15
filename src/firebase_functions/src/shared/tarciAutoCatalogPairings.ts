/** Catálogo automático Tarci para Parejas (metadatos; textos en ARB). */

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
  { templateKey: "chat.system.auto.pairings.playful.001.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.002.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.003.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.004.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.005.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.006.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.007.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.008.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.009.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.010.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.011.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.012.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.013.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.014.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.015.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.016.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.017.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.018.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.019.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.playful.020.v1", category: "pairingsPlayful", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.001.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.002.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.003.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.004.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.005.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.006.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.007.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.008.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.009.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.010.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.011.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.challenge.012.v1", category: "pairingsChallenge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.quiet.001.v1", category: "pairingsQuietNudge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.quiet.002.v1", category: "pairingsQuietNudge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.quiet.003.v1", category: "pairingsQuietNudge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.quiet.004.v1", category: "pairingsQuietNudge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.quiet.005.v1", category: "pairingsQuietNudge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.quiet.006.v1", category: "pairingsQuietNudge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.quiet.007.v1", category: "pairingsQuietNudge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.quiet.008.v1", category: "pairingsQuietNudge", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.countdown.014.v1", category: "pairingsCountdown", scope: "pairings", daysBeforeEvent: 14 },
  { templateKey: "chat.system.auto.pairings.countdown.007.v1", category: "pairingsCountdown", scope: "pairings", daysBeforeEvent: 7 },
  { templateKey: "chat.system.auto.pairings.countdown.003.v1", category: "pairingsCountdown", scope: "pairings", daysBeforeEvent: 3 },
  { templateKey: "chat.system.auto.pairings.countdown.001.v1", category: "pairingsCountdown", scope: "pairings", daysBeforeEvent: 1 },
  { templateKey: "chat.system.auto.pairings.countdown.000.v1", category: "pairingsCountdown", scope: "pairings", daysBeforeEvent: 0 },
  { templateKey: "chat.system.auto.pairings.countdown.extra001.v1", category: "pairingsCountdown", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.countdown.extra002.v1", category: "pairingsCountdown", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.countdown.extra003.v1", category: "pairingsCountdown", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.countdown.extra004.v1", category: "pairingsCountdown", scope: "pairings" },
  { templateKey: "chat.system.auto.pairings.countdown.extra005.v1", category: "pairingsCountdown", scope: "pairings" },
];

export const PAIRINGS_COUNTDOWN_TEMPLATE_BY_DAYS = new Map<number, string>(
  TARCI_PAIRINGS_AUTO_CATALOG.filter((e) => e.category === "pairingsCountdown" && e.daysBeforeEvent !== undefined).map((e) => [
    e.daysBeforeEvent!,
    e.templateKey
  ])
);
