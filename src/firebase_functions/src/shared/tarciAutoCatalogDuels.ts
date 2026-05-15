/** Catálogo automático Tarci para Duelos (metadatos; textos en ARB). */

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
  { templateKey: "chat.system.auto.duels.playful.001.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.002.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.003.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.004.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.005.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.006.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.007.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.008.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.009.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.010.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.011.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.012.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.013.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.014.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.015.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.016.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.017.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.018.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.019.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.playful.020.v1", category: "duelsPlayful", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.001.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.002.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.003.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.004.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.005.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.006.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.007.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.008.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.009.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.010.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.011.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.challenge.012.v1", category: "duelsChallenge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.quiet.001.v1", category: "duelsQuietNudge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.quiet.002.v1", category: "duelsQuietNudge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.quiet.003.v1", category: "duelsQuietNudge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.quiet.004.v1", category: "duelsQuietNudge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.quiet.005.v1", category: "duelsQuietNudge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.quiet.006.v1", category: "duelsQuietNudge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.quiet.007.v1", category: "duelsQuietNudge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.quiet.008.v1", category: "duelsQuietNudge", scope: "duels" },
  { templateKey: "chat.system.auto.duels.countdown.014.v1", category: "duelsCountdown", scope: "duels", daysBeforeEvent: 14 },
  { templateKey: "chat.system.auto.duels.countdown.007.v1", category: "duelsCountdown", scope: "duels", daysBeforeEvent: 7 },
  { templateKey: "chat.system.auto.duels.countdown.003.v1", category: "duelsCountdown", scope: "duels", daysBeforeEvent: 3 },
  { templateKey: "chat.system.auto.duels.countdown.001.v1", category: "duelsCountdown", scope: "duels", daysBeforeEvent: 1 },
  { templateKey: "chat.system.auto.duels.countdown.000.v1", category: "duelsCountdown", scope: "duels", daysBeforeEvent: 0 },
  { templateKey: "chat.system.auto.duels.countdown.extra001.v1", category: "duelsCountdown", scope: "duels" },
  { templateKey: "chat.system.auto.duels.countdown.extra002.v1", category: "duelsCountdown", scope: "duels" },
  { templateKey: "chat.system.auto.duels.countdown.extra003.v1", category: "duelsCountdown", scope: "duels" },
  { templateKey: "chat.system.auto.duels.countdown.extra004.v1", category: "duelsCountdown", scope: "duels" },
  { templateKey: "chat.system.auto.duels.countdown.extra005.v1", category: "duelsCountdown", scope: "duels" },
];

export const DUELS_COUNTDOWN_TEMPLATE_BY_DAYS = new Map<number, string>(
  TARCI_DUELS_AUTO_CATALOG.filter((e) => e.category === "duelsCountdown" && e.daysBeforeEvent !== undefined).map((e) => [
    e.daysBeforeEvent!,
    e.templateKey
  ])
);
