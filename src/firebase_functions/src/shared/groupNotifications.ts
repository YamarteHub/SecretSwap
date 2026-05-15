import { createHash } from "crypto";
import * as logger from "firebase-functions/logger";
import { getMessaging } from "firebase-admin/messaging";
import { FieldValue, Firestore } from "firebase-admin/firestore";
import { groupPaths } from "./firestorePaths";
import { userPaths } from "./userPaths";

export type DynamicTypeForPush = "secret_santa" | "simple_raffle" | "teams";
export type TeamsPresetForPush = "standard" | "pairings" | "duels";

type SupportedLocale = "es" | "en" | "pt" | "it" | "fr";

const SUPPORTED: SupportedLocale[] = ["es", "en", "pt", "it", "fr"];

const COPY: Record<
  SupportedLocale,
  {
    secretSantaTitle: string;
    secretSantaBody: (groupName: string) => string;
    raffleTitle: string;
    raffleBody: (groupName: string) => string;
    teamsTitle: string;
    teamsBody: (groupName: string) => string;
    pairingsTitle: string;
    pairingsBody: (groupName: string) => string;
    duelsTitle: string;
    duelsBody: (groupName: string) => string;
  }
> = {
  es: {
    secretSantaTitle: "Tu amigo secreto ya está listo",
    secretSantaBody: (n) => `El sorteo de «${n}» ya se realizó. Entra para descubrir tu resultado.`,
    raffleTitle: "¡El sorteo ya se realizó!",
    raffleBody: (n) => `«${n}» ya tiene resultado. Entra para ver a los ganadores.`,
    teamsTitle: "¡Los equipos ya están listos!",
    teamsBody: (n) => `«${n}» ya tiene reparto. Entra para ver cómo quedaron los equipos.`,
    pairingsTitle: "¡Las parejas ya están listas!",
    pairingsBody: (n) => `«${n}» ya tiene emparejamientos. Entra para ver el resultado.`,
    duelsTitle: "¡Los duelos ya están listos!",
    duelsBody: (n) => `«${n}» ya tiene enfrentamientos. Entra para ver quién va contra quién.`
  },
  en: {
    secretSantaTitle: "Your Secret Santa is ready",
    secretSantaBody: (n) => `The draw for “${n}” is done. Open the app to see your match.`,
    raffleTitle: "The raffle is done!",
    raffleBody: (n) => `“${n}” has a result. Open the app to see the winners.`,
    teamsTitle: "Your teams are ready!",
    teamsBody: (n) => `“${n}” has been arranged. Open Tarci Secret to see the teams.`,
    pairingsTitle: "Your pairings are ready!",
    pairingsBody: (n) => `“${n}” has pairings. Open the app to see the result.`,
    duelsTitle: "Your duels are ready!",
    duelsBody: (n) => `“${n}” has matchups. Open the app to see who faces whom.`
  },
  pt: {
    secretSantaTitle: "O teu amigo secreto está pronto",
    secretSantaBody: (n) => `O sorteio de «${n}» já foi feito. Entra para ver o teu resultado.`,
    raffleTitle: "O sorteio já foi realizado!",
    raffleBody: (n) => `«${n}» já tem resultado. Entra para ver os vencedores.`,
    teamsTitle: "As equipas já estão prontas!",
    teamsBody: (n) => `«${n}» já tem reparto. Entra para ver como ficaram as equipas.`,
    pairingsTitle: "As parejas já estão prontas!",
    pairingsBody: (n) => `«${n}» já tem emparelhamentos. Entra para ver o resultado.`,
    duelsTitle: "Os duelos já estão prontos!",
    duelsBody: (n) => `«${n}» já tem confrontos. Entra para ver quem enfrenta quem.`
  },
  it: {
    secretSantaTitle: "Il tuo amico segreto è pronto",
    secretSantaBody: (n) => `L'estrazione di «${n}» è stata completata. Apri l'app per vedere il risultato.`,
    raffleTitle: "L'estrazione è stata completata!",
    raffleBody: (n) => `«${n}» ha un risultato. Apri l'app per vedere i vincitori.`,
    teamsTitle: "Le squadre sono pronte!",
    teamsBody: (n) => `«${n}» è stato ripartito. Apri Tarci Secret per vedere le squadre.`,
    pairingsTitle: "Le coppie sono pronte!",
    pairingsBody: (n) => `«${n}» ha gli abbinamenti. Apri l'app per vedere il risultato.`,
    duelsTitle: "I duelli sono pronti!",
    duelsBody: (n) => `«${n}» ha gli scontri. Apri l'app per vedere chi affronta chi.`
  },
  fr: {
    secretSantaTitle: "Ton Secret Santa est prêt",
    secretSantaBody: (n) => `Le tirage de « ${n} » est terminé. Ouvre l'app pour découvrir ton résultat.`,
    raffleTitle: "Le tirage est terminé !",
    raffleBody: (n) => `« ${n} » a un résultat. Ouvre l'app pour voir les gagnants.`,
    teamsTitle: "Les équipes sont prêtes !",
    teamsBody: (n) => `« ${n} » a été réparti. Ouvre Tarci Secret pour voir les équipes.`,
    pairingsTitle: "Les paires sont prêtes !",
    pairingsBody: (n) => `« ${n} » a ses paires. Ouvre l'app pour voir le résultat.`,
    duelsTitle: "Les duels sont prêts !",
    duelsBody: (n) => `« ${n} » a ses affrontements. Ouvre l'app pour voir qui affronte qui.`
  }
};

function normalizeLocale(raw: unknown): SupportedLocale {
  const s = typeof raw === "string" ? raw.trim().toLowerCase() : "";
  const code = s.split(/[-_]/)[0] ?? "";
  if ((SUPPORTED as string[]).includes(code)) {
    return code as SupportedLocale;
  }
  return "es";
}

function copyFor(
  locale: SupportedLocale,
  dynamicType: DynamicTypeForPush,
  groupName: string,
  teamsPreset?: TeamsPresetForPush
): { title: string; body: string } {
  const pack = COPY[locale];
  const name = groupName.trim() || "Tarci Secret";
  if (dynamicType === "simple_raffle") {
    return { title: pack.raffleTitle, body: pack.raffleBody(name) };
  }
  if (dynamicType === "teams") {
    if (teamsPreset === "duels") {
      return { title: pack.duelsTitle, body: pack.duelsBody(name) };
    }
    if (teamsPreset === "pairings") {
      return { title: pack.pairingsTitle, body: pack.pairingsBody(name) };
    }
    return { title: pack.teamsTitle, body: pack.teamsBody(name) };
  }
  return { title: pack.secretSantaTitle, body: pack.secretSantaBody(name) };
}

function eventKindFor(dynamicType: DynamicTypeForPush, teamsPreset?: TeamsPresetForPush): string {
  if (dynamicType === "simple_raffle") return "raffle_completed";
  if (dynamicType === "teams" && teamsPreset === "duels") return "duels_completed";
  if (dynamicType === "teams" && teamsPreset === "pairings") return "pairings_completed";
  if (dynamicType === "teams") return "teams_completed";
  return "secret_santa_completed";
}

type TokenTarget = {
  uid: string;
  tokenId: string;
  token: string;
  locale: SupportedLocale;
};

async function loadActiveMemberUids(db: Firestore, groupId: string): Promise<string[]> {
  const snap = await db.collection(groupPaths.membersCol(groupId)).get();
  const uids: string[] = [];
  for (const doc of snap.docs) {
    const d = doc.data() as { memberState?: string; uid?: string };
    if (d.memberState !== "active") continue;
    const uid = typeof d.uid === "string" && d.uid.trim() !== "" ? d.uid.trim() : doc.id;
    uids.push(uid);
  }
  return [...new Set(uids)];
}

async function loadTokenTargets(db: Firestore, uids: string[]): Promise<TokenTarget[]> {
  const out: TokenTarget[] = [];
  for (const uid of uids) {
    const userSnap = await db.doc(userPaths.userDoc(uid)).get();
    const locale = normalizeLocale(userSnap.data()?.preferredLocale);
    const tokensSnap = await db.collection(userPaths.pushTokensCol(uid)).get();
    for (const tdoc of tokensSnap.docs) {
      const t = tdoc.data() as {
        token?: string;
        enabled?: boolean;
      };
      if (t.enabled === false) continue;
      const token = typeof t.token === "string" ? t.token.trim() : "";
      if (!token) continue;
      out.push({ uid, tokenId: tdoc.id, token, locale });
    }
  }
  return out;
}

async function disableInvalidToken(
  db: Firestore,
  uid: string,
  tokenId: string,
  reason: string
): Promise<void> {
  try {
    await db.doc(userPaths.pushTokenDoc(uid, tokenId)).set(
      {
        enabled: false,
        disabledAt: FieldValue.serverTimestamp(),
        disabledReason: reason
      },
      { merge: true }
    );
  } catch (e) {
    logger.warn("groupNotifications: failed to disable token", { uid, tokenId, err: e });
  }
}

/**
 * Envía push a miembros activos con token. No lanza: fallos solo se registran.
 * No llamar en rutas idempotentes que solo re-sincronizan UI.
 */
export async function notifyGroupDynamicCompleted(
  db: Firestore,
  params: {
    groupId: string;
    dynamicType: DynamicTypeForPush;
    teamsPreset?: TeamsPresetForPush;
    groupName: string;
    /** UID que ejecutó draw/raffle/teams; no recibe push (ya está en la app). */
    triggeredByUid?: string;
  }
): Promise<void> {
  try {
    const actorUid =
      typeof params.triggeredByUid === "string" && params.triggeredByUid.trim() !== ""
        ? params.triggeredByUid.trim()
        : null;

    const allActiveUids = await loadActiveMemberUids(db, params.groupId);
    const uids = actorUid != null ? allActiveUids.filter((id) => id !== actorUid) : allActiveUids;

    if (uids.length === 0) {
      logger.info("groupNotifications: no recipients after exclusions", {
        groupId: params.groupId,
        activeMemberCount: allActiveUids.length,
        excludedActorUid: actorUid
      });
      return;
    }

    const targets = await loadTokenTargets(db, uids);
    if (targets.length === 0) {
      logger.info("groupNotifications: no push tokens", {
        groupId: params.groupId,
        memberCount: uids.length
      });
      return;
    }

    const byLocale = new Map<SupportedLocale, TokenTarget[]>();
    for (const t of targets) {
      const list = byLocale.get(t.locale) ?? [];
      list.push(t);
      byLocale.set(t.locale, list);
    }

    const messaging = getMessaging();
    const teamsPreset = params.teamsPreset ?? "standard";
    const eventKind = eventKindFor(params.dynamicType, teamsPreset);

    for (const [locale, list] of byLocale.entries()) {
      const { title, body } = copyFor(locale, params.dynamicType, params.groupName, teamsPreset);
      const tokens = list.map((t) => t.token);
      const response = await messaging.sendEachForMulticast({
        tokens,
        notification: { title, body },
        data: {
          type: "group_dynamic_completed",
          groupId: params.groupId,
          dynamicType: params.dynamicType,
          teamsPreset,
          destination: "group_detail",
          eventKind
        }
      });

      for (let i = 0; i < response.responses.length; i++) {
        const r = response.responses[i];
        if (r?.success) continue;
        const err = r?.error;
        const code = err?.code ?? "";
        const target = list[i]!;
        if (
          code === "messaging/registration-token-not-registered" ||
          code === "messaging/invalid-registration-token" ||
          code === "messaging/invalid-argument"
        ) {
          await disableInvalidToken(db, target.uid, target.tokenId, code);
        } else {
          logger.warn("groupNotifications: send failed", {
            groupId: params.groupId,
            uid: target.uid,
            code,
            message: err?.message
          });
        }
      }
    }

    logger.info("groupNotifications: sent", {
      groupId: params.groupId,
      dynamicType: params.dynamicType,
      tokenCount: targets.length,
      excludedActorUid: actorUid,
      recipientUidCount: uids.length
    });
  } catch (e) {
    logger.warn("groupNotifications: notifyGroupDynamicCompleted failed", {
      groupId: params.groupId,
      dynamicType: params.dynamicType,
      err: e
    });
  }
}

export function pushTokenDocId(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}
