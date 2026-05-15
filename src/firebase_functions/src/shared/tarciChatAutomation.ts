import { FieldValue, Timestamp } from "firebase-admin/firestore";
import type { DocumentSnapshot, Firestore } from "firebase-admin/firestore";
import { DateTime } from "luxon";
import * as logger from "firebase-functions/logger";

import { buildParticipantsMapForWishlist } from "./wishlistAccess";
import { groupPaths } from "./firestorePaths";
import { COUNTDOWN_TEMPLATE_BY_DAYS, TARCI_AUTO_CATALOG, type TarciCatalogEntry } from "./tarciAutoCatalog";
import {
  DUELS_COUNTDOWN_TEMPLATE_BY_DAYS,
  TARCI_DUELS_AUTO_CATALOG,
  type DuelsCatalogEntry
} from "./tarciAutoCatalogDuels";
import {
  PAIRINGS_COUNTDOWN_TEMPLATE_BY_DAYS,
  TARCI_PAIRINGS_AUTO_CATALOG,
  type PairingsCatalogEntry
} from "./tarciAutoCatalogPairings";
import {
  TEAMS_COUNTDOWN_TEMPLATE_BY_DAYS,
  TARCI_TEAMS_AUTO_CATALOG,
  type TeamsCatalogEntry
} from "./tarciAutoCatalogTeams";

const MS_PER_DAY = 86400000;
const NO_EVENT_ENGAGEMENT_DAYS = 21;
const WISHLIST_REMINDER_COOLDOWN_MS = 7 * MS_PER_DAY;
const QUIET_NUDGE_COOLDOWN_MS = 5 * MS_PER_DAY;
const HUMAN_IDLE_MS = 72 * 3600000;

export type TarciAutomationProcessResult = {
  groupId: string;
  outcome: "skipped" | "published" | "dryRun";
  reason?: string;
  templateKey?: string;
};

type GroupAutoFields = {
  dynamicType?: string;
  drawStatus?: string;
  teamStatus?: string;
  teamsPreset?: string;
  lifecycleStatus?: string;
  eventDate?: Timestamp;
  eventDateDayKey?: string;
  eventTimeZone?: string;
  lastDrawCompletedAt?: Timestamp;
  lastTeamCompletedAt?: Timestamp;
};

type TarciStateFields = {
  sentTemplateKeys: string[];
  sentCountdownMilestones: string[];
  lastAutoMessageAt?: Timestamp | null;
  nextAutoMessageAt?: Timestamp | null;
  lastWishlistReminderAt?: Timestamp | null;
  lastQuietNudgeAt?: Timestamp | null;
  lastHumanMessageAt?: Timestamp | null;
};

function utcDayKey(d: Date): string {
  return d.toISOString().slice(0, 10);
}

function sameUtcCalendarDay(ts: Timestamp | null | undefined, d: Date): boolean {
  if (!ts) return false;
  return utcDayKey(ts.toDate()) === utcDayKey(d);
}

function readGroupAuto(doc: DocumentSnapshot): GroupAutoFields {
  const x = doc.data() as Record<string, unknown>;
  return {
    dynamicType: typeof x.dynamicType === "string" ? x.dynamicType : undefined,
    drawStatus: typeof x.drawStatus === "string" ? x.drawStatus : undefined,
    teamStatus: typeof x.teamStatus === "string" ? x.teamStatus : undefined,
    teamsPreset: typeof x.teamsPreset === "string" ? x.teamsPreset : undefined,
    lifecycleStatus: typeof x.lifecycleStatus === "string" ? x.lifecycleStatus : undefined,
    eventDate: x.eventDate instanceof Timestamp ? x.eventDate : undefined,
    eventDateDayKey: typeof x.eventDateDayKey === "string" ? x.eventDateDayKey : undefined,
    eventTimeZone: typeof x.eventTimeZone === "string" ? x.eventTimeZone : undefined,
    lastDrawCompletedAt: x.lastDrawCompletedAt instanceof Timestamp ? x.lastDrawCompletedAt : undefined,
    lastTeamCompletedAt: x.lastTeamCompletedAt instanceof Timestamp ? x.lastTeamCompletedAt : undefined
  };
}

function isTeamsGroup(g: GroupAutoFields): boolean {
  return g.dynamicType === "teams";
}

function isPairingsGroup(g: GroupAutoFields): boolean {
  return isTeamsGroup(g) && g.teamsPreset === "pairings";
}

function isDuelsGroup(g: GroupAutoFields): boolean {
  return isTeamsGroup(g) && g.teamsPreset === "duels";
}

type TeamsLikeCatalogEntry = TeamsCatalogEntry | PairingsCatalogEntry | DuelsCatalogEntry;

function teamsPresetForAutomation(g: GroupAutoFields): "standard" | "pairings" | "duels" {
  if (g.teamsPreset === "pairings") return "pairings";
  if (g.teamsPreset === "duels") return "duels";
  return "standard";
}

function normalizeTarciState(raw: Record<string, unknown> | undefined): TarciStateFields {
  const sk = raw?.sentTemplateKeys;
  const scm = raw?.sentCountdownMilestones;
  return {
    sentTemplateKeys: Array.isArray(sk) ? sk.map((s) => String(s)) : [],
    sentCountdownMilestones: Array.isArray(scm) ? scm.map((s) => String(s)) : [],
    lastAutoMessageAt: raw?.lastAutoMessageAt instanceof Timestamp ? raw.lastAutoMessageAt : null,
    nextAutoMessageAt: raw?.nextAutoMessageAt instanceof Timestamp ? raw.nextAutoMessageAt : null,
    lastWishlistReminderAt:
      raw?.lastWishlistReminderAt instanceof Timestamp ? raw.lastWishlistReminderAt : null,
    lastQuietNudgeAt: raw?.lastQuietNudgeAt instanceof Timestamp ? raw.lastQuietNudgeAt : null,
    lastHumanMessageAt: raw?.lastHumanMessageAt instanceof Timestamp ? raw.lastHumanMessageAt : null
  };
}

/** Días enteros hasta el día del evento (incluye 0 el día del evento). null si datos inválidos. */
export function daysUntilEventDay(eventDayKey: string, timeZone: string, now: Date): number | null {
  try {
    const eventStart = DateTime.fromISO(eventDayKey, { zone: timeZone }).startOf("day");
    if (!eventStart.isValid) return null;
    const todayStart = DateTime.fromJSDate(now, { zone: timeZone }).startOf("day");
    return Math.round(eventStart.diff(todayStart, "days").days);
  } catch {
    return null;
  }
}

function engagementWindowOpenSecretSanta(g: GroupAutoFields, now: Date): boolean {
  if (g.drawStatus !== "completed") return false;
  if (g.lifecycleStatus !== "active") return false;
  const dk = g.eventDateDayKey;
  const tz = g.eventTimeZone;
  if (dk && tz) {
    const days = daysUntilEventDay(dk, tz, now);
    if (days === null) return false;
    return days >= 0;
  }
  if (dk && !tz) {
    const last = g.lastDrawCompletedAt;
    if (!last) return false;
    return now.getTime() <= last.toMillis() + NO_EVENT_ENGAGEMENT_DAYS * MS_PER_DAY;
  }
  if (g.eventDate && !dk) {
    const ed = g.eventDate.toDate();
    const end = Date.UTC(ed.getUTCFullYear(), ed.getUTCMonth(), ed.getUTCDate(), 23, 59, 59, 999);
    return now.getTime() <= end;
  }
  const last = g.lastDrawCompletedAt;
  if (!last) return false;
  return now.getTime() <= last.toMillis() + NO_EVENT_ENGAGEMENT_DAYS * MS_PER_DAY;
}

function engagementWindowOpenTeams(g: GroupAutoFields, now: Date): boolean {
  if (g.teamStatus !== "completed") return false;
  if (g.lifecycleStatus !== "active") return false;
  const dk = g.eventDateDayKey;
  const tz = g.eventTimeZone;
  if (dk && tz) {
    const days = daysUntilEventDay(dk, tz, now);
    if (days === null) return false;
    return days >= 0;
  }
  if (dk && !tz) {
    const last = g.lastTeamCompletedAt;
    if (!last) return false;
    return now.getTime() <= last.toMillis() + NO_EVENT_ENGAGEMENT_DAYS * MS_PER_DAY;
  }
  if (g.eventDate && !dk) {
    const ed = g.eventDate.toDate();
    const end = Date.UTC(ed.getUTCFullYear(), ed.getUTCMonth(), ed.getUTCDate(), 23, 59, 59, 999);
    return now.getTime() <= end;
  }
  const last = g.lastTeamCompletedAt;
  if (!last) return false;
  return now.getTime() <= last.toMillis() + NO_EVENT_ENGAGEMENT_DAYS * MS_PER_DAY;
}

function engagementWindowOpen(g: GroupAutoFields, now: Date): boolean {
  if (isTeamsGroup(g)) return engagementWindowOpenTeams(g, now);
  return engagementWindowOpenSecretSanta(g, now);
}

function parseNonEmptyString(v: unknown): string | null {
  if (typeof v !== "string") return null;
  const s = v.trim();
  return s.length > 0 ? s : null;
}

function isWishlistDocEmpty(data: Record<string, unknown> | undefined): boolean {
  if (!data) return true;
  const w = parseNonEmptyString(data.wishText);
  const l = parseNonEmptyString(data.likesText);
  const a = parseNonEmptyString(data.avoidText);
  const links = Array.isArray(data.links) ? data.links : [];
  const hasLink = links.some((item) => {
    if (typeof item !== "object" || item === null) return false;
    const o = item as Record<string, unknown>;
    const url = parseNonEmptyString(o.url);
    return url != null;
  });
  return w == null && l == null && a == null && !hasLink;
}

export async function hasAnyEmptyWishlist(db: Firestore, groupId: string): Promise<boolean> {
  const participants = await buildParticipantsMapForWishlist(db, groupId);
  const checks: Promise<boolean>[] = [];
  for (const p of participants.values()) {
    if (p.state !== "active") continue;
    const pid = p.participantId;
    const ref = db.doc(`groups/${groupId}/wishlists/${pid}`);
    checks.push(
      ref.get().then((snap) => {
        if (!snap.exists) return true;
        return isWishlistDocEmpty(snap.data() as Record<string, unknown>);
      })
    );
  }
  if (checks.length === 0) return false;
  const results = await Promise.all(checks);
  return results.some(Boolean);
}

function pickRandomUnused<T extends { templateKey: string }>(
  candidates: T[],
  sent: Set<string>
): T | null {
  const avail = candidates.filter((c) => !sent.has(c.templateKey));
  if (avail.length === 0) return null;
  return avail[Math.floor(Math.random() * avail.length)]!;
}

function randomCadenceMs(): number {
  const days = 2 + Math.floor(Math.random() * 3);
  return days * MS_PER_DAY;
}

function olderThan(ts: Timestamp | null | undefined, ms: number, now: Date): boolean {
  if (!ts) return true;
  return now.getTime() - ts.toMillis() >= ms;
}

function nextAutoEligible(state: TarciStateFields, now: Date): boolean {
  const n = state.nextAutoMessageAt;
  if (!n) return true;
  return n.toMillis() <= now.getTime();
}

export type AutomationDecision = {
  templateKey: string;
  milestoneKey?: string;
  bumpWishlistAt: boolean;
  bumpQuietAt: boolean;
  setNextCadence: boolean;
};

function decideTarciAutomationMessageSecretSanta(input: {
  group: GroupAutoFields;
  state: TarciStateFields;
  now: Date;
  hasEmptyWishlist: boolean;
}): AutomationDecision | null {
  const { group, state, now, hasEmptyWishlist } = input;
  const sent = new Set(state.sentTemplateKeys);
  const milestones = new Set(state.sentCountdownMilestones);

  const dk = group.eventDateDayKey;
  const tz = group.eventTimeZone;
  if (dk && tz) {
    const days = daysUntilEventDay(dk, tz, now);
    if (days !== null) {
      const milestonesToCheck = [14, 7, 3, 1, 0] as const;
      if (milestonesToCheck.includes(days as (typeof milestonesToCheck)[number])) {
        const key = COUNTDOWN_TEMPLATE_BY_DAYS.get(days);
        if (key && !milestones.has(String(days)) && !sent.has(key)) {
          return {
            templateKey: key,
            milestoneKey: String(days),
            bumpWishlistAt: false,
            bumpQuietAt: false,
            setNextCadence: false
          };
        }
      }
    }
  }

  if (
    hasEmptyWishlist &&
    olderThan(state.lastWishlistReminderAt, WISHLIST_REMINDER_COOLDOWN_MS, now)
  ) {
    const cands = TARCI_AUTO_CATALOG.filter((c) => c.category === "wishlistReminder");
    const pick = pickRandomUnused(cands, sent);
    if (pick) {
      return {
        templateKey: pick.templateKey,
        bumpWishlistAt: true,
        bumpQuietAt: false,
        setNextCadence: true
      };
    }
  }

  const lastHum = state.lastHumanMessageAt;
  if (
    lastHum != null &&
    now.getTime() - lastHum.toMillis() >= HUMAN_IDLE_MS &&
    olderThan(state.lastQuietNudgeAt, QUIET_NUDGE_COOLDOWN_MS, now)
  ) {
    const cands = TARCI_AUTO_CATALOG.filter((c) => c.category === "quietChatNudge");
    const pick = pickRandomUnused(cands, sent);
    if (pick) {
      return {
        templateKey: pick.templateKey,
        bumpWishlistAt: false,
        bumpQuietAt: true,
        setNextCadence: true
      };
    }
  }

  if (nextAutoEligible(state, now)) {
    const cands = TARCI_AUTO_CATALOG.filter((c) => c.category === "playful" || c.category === "debate");
    const pick = pickRandomUnused(cands, sent);
    if (pick) {
      return {
        templateKey: pick.templateKey,
        bumpWishlistAt: false,
        bumpQuietAt: false,
        setNextCadence: true
      };
    }
  }

  return null;
}

function decideTarciAutomationMessageTeams(input: {
  group: GroupAutoFields;
  state: TarciStateFields;
  now: Date;
}): AutomationDecision | null {
  const { group, state, now } = input;
  const preset = teamsPresetForAutomation(group);
  const catalog: TeamsLikeCatalogEntry[] =
    preset === "duels"
      ? TARCI_DUELS_AUTO_CATALOG
      : preset === "pairings"
        ? TARCI_PAIRINGS_AUTO_CATALOG
        : TARCI_TEAMS_AUTO_CATALOG;
  const countdownByDays =
    preset === "duels"
      ? DUELS_COUNTDOWN_TEMPLATE_BY_DAYS
      : preset === "pairings"
        ? PAIRINGS_COUNTDOWN_TEMPLATE_BY_DAYS
        : TEAMS_COUNTDOWN_TEMPLATE_BY_DAYS;
  const playfulCat =
    preset === "duels" ? "duelsPlayful" : preset === "pairings" ? "pairingsPlayful" : "teamsPlayful";
  const challengeCat =
    preset === "duels" ? "duelsChallenge" : preset === "pairings" ? "pairingsChallenge" : "teamsChallenge";
  const quietCat =
    preset === "duels" ? "duelsQuietNudge" : preset === "pairings" ? "pairingsQuietNudge" : "teamsQuietNudge";
  const countdownCat =
    preset === "duels" ? "duelsCountdown" : preset === "pairings" ? "pairingsCountdown" : "teamsCountdown";

  const sent = new Set(state.sentTemplateKeys);
  const milestones = new Set(state.sentCountdownMilestones);

  const dk = group.eventDateDayKey;
  const tz = group.eventTimeZone;
  if (dk && tz) {
    const days = daysUntilEventDay(dk, tz, now);
    if (days !== null) {
      const milestonesToCheck = [14, 7, 3, 1, 0] as const;
      if (milestonesToCheck.includes(days as (typeof milestonesToCheck)[number])) {
        const key = countdownByDays.get(days);
        if (key && !milestones.has(String(days)) && !sent.has(key)) {
          return {
            templateKey: key,
            milestoneKey: String(days),
            bumpWishlistAt: false,
            bumpQuietAt: false,
            setNextCadence: false
          };
        }
      }
    }
  }

  const lastHum = state.lastHumanMessageAt;
  if (
    lastHum != null &&
    now.getTime() - lastHum.toMillis() >= HUMAN_IDLE_MS &&
    olderThan(state.lastQuietNudgeAt, QUIET_NUDGE_COOLDOWN_MS, now)
  ) {
    const cands = catalog.filter((c) => c.category === quietCat);
    const pick = pickRandomUnused(cands, sent);
    if (pick) {
      return {
        templateKey: pick.templateKey,
        bumpWishlistAt: false,
        bumpQuietAt: true,
        setNextCadence: true
      };
    }
  }

  if (nextAutoEligible(state, now)) {
    const cands = catalog.filter(
      (c) =>
        c.category === playfulCat ||
        c.category === challengeCat ||
        (c.category === countdownCat && c.daysBeforeEvent === undefined)
    );
    const pick = pickRandomUnused(cands, sent);
    if (pick) {
      return {
        templateKey: pick.templateKey,
        bumpWishlistAt: false,
        bumpQuietAt: false,
        setNextCadence: true
      };
    }
  }

  return null;
}

export function decideTarciAutomationMessage(input: {
  group: GroupAutoFields;
  state: TarciStateFields;
  now: Date;
  hasEmptyWishlist: boolean;
}): AutomationDecision | null {
  const { group, state, now, hasEmptyWishlist } = input;

  if (!engagementWindowOpen(group, now)) {
    return null;
  }
  if (sameUtcCalendarDay(state.lastAutoMessageAt, now)) {
    return null;
  }

  if (isTeamsGroup(group)) {
    return decideTarciAutomationMessageTeams({ group, state, now });
  }
  return decideTarciAutomationMessageSecretSanta({ group, state, now, hasEmptyWishlist });
}

function autoMessageDocId(templateKey: string): string {
  return `tarci_auto_${templateKey.replace(/\./g, "_")}`;
}

export async function processTarciAutomationForGroup(
  db: Firestore,
  groupId: string,
  options?: { now?: Date; dryRun?: boolean }
): Promise<TarciAutomationProcessResult> {
  const now = options?.now ?? new Date();
  const dryRun = options?.dryRun ?? false;

  const groupRef = db.doc(groupPaths.groupDoc(groupId));
  const stateRef = db.doc(groupPaths.chatAutomationTarciStateDoc(groupId));

  const groupSnap = await groupRef.get();
  if (!groupSnap.exists) {
    return { groupId, outcome: "skipped", reason: "group_missing" };
  }
  const group = readGroupAuto(groupSnap);

  if (!engagementWindowOpen(group, now)) {
    return { groupId, outcome: "skipped", reason: "not_eligible" };
  }

  const stateSnap = await stateRef.get();
  const state = normalizeTarciState(stateSnap.data() as Record<string, unknown> | undefined);

  if (sameUtcCalendarDay(state.lastAutoMessageAt, now)) {
    return { groupId, outcome: "skipped", reason: "daily_cap" };
  }

  const dyn = group.dynamicType ?? "secret_santa";
  if (dyn === "simple_raffle") {
    return { groupId, outcome: "skipped", reason: "not_eligible" };
  }

  const hasEmptyWishlist =
    isTeamsGroup(group) ? false : await hasAnyEmptyWishlist(db, groupId);
  const decision = decideTarciAutomationMessage({ group, state, now, hasEmptyWishlist });
  if (!decision) {
    return { groupId, outcome: "skipped", reason: "no_candidate" };
  }

  if (dryRun) {
    return { groupId, outcome: "dryRun", templateKey: decision.templateKey };
  }

  const messageDocId = autoMessageDocId(decision.templateKey);
  const messageRef = db.doc(groupPaths.chatMessageDoc(groupId, messageDocId));

  try {
    await db.runTransaction(async (tx) => {
      const [g2, s2, m2] = await Promise.all([tx.get(groupRef), tx.get(stateRef), tx.get(messageRef)]);
      if (!g2.exists) return;
      const g2d = readGroupAuto(g2);
      if (!engagementWindowOpen(g2d, now)) return;

      const s2n = normalizeTarciState(s2.data() as Record<string, unknown> | undefined);
      if (sameUtcCalendarDay(s2n.lastAutoMessageAt, now)) return;
      if (m2.exists) return;
      if (s2n.sentTemplateKeys.includes(decision.templateKey)) return;
      if (decision.milestoneKey && s2n.sentCountdownMilestones.includes(decision.milestoneKey)) return;

      tx.create(messageRef, {
        type: "system",
        templateKey: decision.templateKey,
        createdAt: FieldValue.serverTimestamp()
      });

      const nextCadence = Timestamp.fromMillis(now.getTime() + randomCadenceMs());
      const patch: Record<string, unknown> = {
        sentTemplateKeys: FieldValue.arrayUnion(decision.templateKey),
        lastAutoMessageAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp()
      };
      if (decision.milestoneKey) {
        patch.sentCountdownMilestones = FieldValue.arrayUnion(decision.milestoneKey);
      }
      if (decision.bumpWishlistAt) {
        patch.lastWishlistReminderAt = FieldValue.serverTimestamp();
      }
      if (decision.bumpQuietAt) {
        patch.lastQuietNudgeAt = FieldValue.serverTimestamp();
      }
      if (decision.setNextCadence) {
        patch.nextAutoMessageAt = nextCadence;
      }
      tx.set(stateRef, patch, { merge: true });
    });
  } catch (e) {
    logger.warn("processTarciAutomationForGroup transaction failed", { groupId, err: e });
    return { groupId, outcome: "skipped", reason: "transaction_failed" };
  }

  const verify = await messageRef.get();
  if (!verify.exists) {
    return { groupId, outcome: "skipped", reason: "race_or_validation" };
  }

  return { groupId, outcome: "published", templateKey: decision.templateKey };
}

export async function runTarciAutomationSweep(db: Firestore, opts?: { now?: Date; maxGroups?: number }): Promise<{
  processed: number;
  published: number;
  results: TarciAutomationProcessResult[];
}> {
  const now = opts?.now ?? new Date();
  const max = opts?.maxGroups ?? 200;
  const half = Math.max(1, Math.floor(max / 2));
  const [ssSnap, teamsSnap] = await Promise.all([
    db
      .collection("groups")
      .where("drawStatus", "==", "completed")
      .where("lifecycleStatus", "==", "active")
      .limit(half)
      .get(),
    db
      .collection("groups")
      .where("dynamicType", "==", "teams")
      .where("teamStatus", "==", "completed")
      .where("lifecycleStatus", "==", "active")
      .limit(half)
      .get()
  ]);

  const results: TarciAutomationProcessResult[] = [];
  let published = 0;
  const seen = new Set<string>();

  for (const doc of ssSnap.docs) {
    if (seen.has(doc.id)) continue;
    seen.add(doc.id);
    const g = readGroupAuto(doc);
    if (g.dynamicType === "teams" || g.dynamicType === "simple_raffle") continue;
    const r = await processTarciAutomationForGroup(db, doc.id, { now });
    results.push(r);
    if (r.outcome === "published") published += 1;
  }
  for (const doc of teamsSnap.docs) {
    if (seen.has(doc.id)) continue;
    seen.add(doc.id);
    const r = await processTarciAutomationForGroup(db, doc.id, { now });
    results.push(r);
    if (r.outcome === "published") published += 1;
  }
  return { processed: results.length, published, results };
}
