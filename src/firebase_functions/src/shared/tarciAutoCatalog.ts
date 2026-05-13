/** Catálogo de mensajes automáticos Tarci (solo metadatos; textos en cliente ARB / docs i18n). */

export type TarciAutoCategory =
  | "playful"
  | "debate"
  | "wishlistReminder"
  | "quietChatNudge"
  | "countdown";

export type TarciCatalogEntry = {
  templateKey: string;
  category: TarciAutoCategory;
  /** Solo countdown: días hasta el evento (día civil en eventTimeZone). */
  daysBeforeEvent?: number;
};

export const TARCI_AUTO_CATALOG: TarciCatalogEntry[] = [
  { templateKey: "chat.system.auto.playful.001.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.002.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.003.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.004.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.005.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.006.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.007.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.008.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.009.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.010.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.011.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.012.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.013.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.014.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.015.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.016.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.017.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.018.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.019.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.020.v1", category: "playful" },
  { templateKey: "chat.system.auto.playful.021.v1", category: "playful" },
  { templateKey: "chat.system.auto.debate.001.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.002.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.003.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.004.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.005.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.006.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.007.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.008.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.009.v1", category: "debate" },
  { templateKey: "chat.system.auto.debate.010.v1", category: "debate" },
  { templateKey: "chat.system.auto.wishlist.001.v1", category: "wishlistReminder" },
  { templateKey: "chat.system.auto.wishlist.002.v1", category: "wishlistReminder" },
  { templateKey: "chat.system.auto.wishlist.003.v1", category: "wishlistReminder" },
  { templateKey: "chat.system.auto.wishlist.004.v1", category: "wishlistReminder" },
  { templateKey: "chat.system.auto.wishlist.005.v1", category: "wishlistReminder" },
  { templateKey: "chat.system.auto.wishlist.006.v1", category: "wishlistReminder" },
  { templateKey: "chat.system.auto.wishlist.007.v1", category: "wishlistReminder" },
  { templateKey: "chat.system.auto.wishlist.008.v1", category: "wishlistReminder" },
  { templateKey: "chat.system.auto.quiet.001.v1", category: "quietChatNudge" },
  { templateKey: "chat.system.auto.quiet.002.v1", category: "quietChatNudge" },
  { templateKey: "chat.system.auto.quiet.003.v1", category: "quietChatNudge" },
  { templateKey: "chat.system.auto.quiet.004.v1", category: "quietChatNudge" },
  { templateKey: "chat.system.auto.quiet.005.v1", category: "quietChatNudge" },
  { templateKey: "chat.system.auto.quiet.006.v1", category: "quietChatNudge" },
  { templateKey: "chat.system.auto.countdown.014.v1", category: "countdown", daysBeforeEvent: 14 },
  { templateKey: "chat.system.auto.countdown.007.v1", category: "countdown", daysBeforeEvent: 7 },
  { templateKey: "chat.system.auto.countdown.003.v1", category: "countdown", daysBeforeEvent: 3 },
  { templateKey: "chat.system.auto.countdown.001.v1", category: "countdown", daysBeforeEvent: 1 },
  { templateKey: "chat.system.auto.countdown.000.v1", category: "countdown", daysBeforeEvent: 0 }
];

export const COUNTDOWN_TEMPLATE_BY_DAYS = new Map<number, string>(
  TARCI_AUTO_CATALOG.filter((e) => e.category === "countdown" && e.daysBeforeEvent !== undefined).map((e) => [
    e.daysBeforeEvent!,
    e.templateKey
  ])
);
