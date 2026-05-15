/** Catálogo automático Tarci para Equipos (metadatos; textos en ARB). */

export type TeamsAutoCategory =
  | "teamsPlayful"
  | "teamsChallenge"
  | "teamsQuietNudge"
  | "teamsCountdown";

export type TeamsCatalogEntry = {
  templateKey: string;
  category: TeamsAutoCategory;
  scope: "teams";
  daysBeforeEvent?: number;
};

export const TARCI_TEAMS_AUTO_CATALOG: TeamsCatalogEntry[] = [
  { templateKey: "chat.system.auto.teams.playful.001.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.002.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.003.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.004.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.005.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.006.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.007.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.008.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.009.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.010.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.011.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.012.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.013.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.014.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.015.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.016.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.017.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.018.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.019.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.playful.020.v1", category: "teamsPlayful", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.001.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.002.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.003.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.004.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.005.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.006.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.007.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.008.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.009.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.010.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.011.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.challenge.012.v1", category: "teamsChallenge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.quiet.001.v1", category: "teamsQuietNudge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.quiet.002.v1", category: "teamsQuietNudge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.quiet.003.v1", category: "teamsQuietNudge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.quiet.004.v1", category: "teamsQuietNudge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.quiet.005.v1", category: "teamsQuietNudge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.quiet.006.v1", category: "teamsQuietNudge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.quiet.007.v1", category: "teamsQuietNudge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.quiet.008.v1", category: "teamsQuietNudge", scope: "teams" },
  { templateKey: "chat.system.auto.teams.countdown.014.v1", category: "teamsCountdown", scope: "teams", daysBeforeEvent: 14 },
  { templateKey: "chat.system.auto.teams.countdown.007.v1", category: "teamsCountdown", scope: "teams", daysBeforeEvent: 7 },
  { templateKey: "chat.system.auto.teams.countdown.003.v1", category: "teamsCountdown", scope: "teams", daysBeforeEvent: 3 },
  { templateKey: "chat.system.auto.teams.countdown.001.v1", category: "teamsCountdown", scope: "teams", daysBeforeEvent: 1 },
  { templateKey: "chat.system.auto.teams.countdown.000.v1", category: "teamsCountdown", scope: "teams", daysBeforeEvent: 0 },
  { templateKey: "chat.system.auto.teams.countdown.extra001.v1", category: "teamsCountdown", scope: "teams" },
  { templateKey: "chat.system.auto.teams.countdown.extra002.v1", category: "teamsCountdown", scope: "teams" },
  { templateKey: "chat.system.auto.teams.countdown.extra003.v1", category: "teamsCountdown", scope: "teams" },
  { templateKey: "chat.system.auto.teams.countdown.extra004.v1", category: "teamsCountdown", scope: "teams" },
  { templateKey: "chat.system.auto.teams.countdown.extra005.v1", category: "teamsCountdown", scope: "teams" },
];

export const TEAMS_COUNTDOWN_TEMPLATE_BY_DAYS = new Map<number, string>(
  TARCI_TEAMS_AUTO_CATALOG.filter((e) => e.category === "teamsCountdown" && e.daysBeforeEvent !== undefined).map((e) => [
    e.daysBeforeEvent!,
    e.templateKey
  ])
);
