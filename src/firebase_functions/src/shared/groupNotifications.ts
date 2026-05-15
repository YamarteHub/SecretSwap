import { createHash } from "crypto";
import * as logger from "firebase-functions/logger";
import { getMessaging } from "firebase-admin/messaging";
import { FieldValue, Firestore } from "firebase-admin/firestore";
import { groupPaths } from "./firestorePaths";
import { userPaths } from "./userPaths";

export type DynamicTypeForPush = "secret_santa" | "simple_raffle";

type SupportedLocale = "es" | "en" | "pt" | "it" | "fr";

const SUPPORTED: SupportedLocale[] = ["es", "en", "pt", "it", "fr"];

const COPY: Record<
  SupportedLocale,
  {
    secretSantaTitle: string;
    secretSantaBody: (groupName: string) => string;
    raffleTitle: string;
    raffleBody: (groupName: string) => string;
  }
> = {
  es: {
    secretSantaTitle: "Tu amigo secreto ya está listo",
    secretSantaBody: (n) => `El sorteo de «${n}» ya se realizó. Entra para descubrir tu resultado.`,
    raffleTitle: "¡El sorteo ya se realizó!",
    raffleBody: (n) => `«${n}» ya tiene resultado. Entra para ver a los ganadores.`
  },
  en: {
    secretSantaTitle: "Your Secret Santa is ready",
    secretSantaBody: (n) => `The draw for “${n}” is done. Open the app to see your match.`,
    raffleTitle: "The raffle is done!",
    raffleBody: (n) => `“${n}” has a result. Open the app to see the winners.`
  },
  pt: {
    secretSantaTitle: "O teu amigo secreto está pronto",
    secretSantaBody: (n) => `O sorteio de «${n}» já foi feito. Entra para ver o teu resultado.`,
    raffleTitle: "O sorteio já foi realizado!",
    raffleBody: (n) => `«${n}» já tem resultado. Entra para ver os vencedores.`
  },
  it: {
    secretSantaTitle: "Il tuo amico segreto è pronto",
    secretSantaBody: (n) => `L'estrazione di «${n}» è stata completata. Apri l'app per vedere il risultato.`,
    raffleTitle: "L'estrazione è stata completata!",
    raffleBody: (n) => `«${n}» ha un risultato. Apri l'app per vedere i vincitori.`
  },
  fr: {
    secretSantaTitle: "Ton Secret Santa est prêt",
    secretSantaBody: (n) => `Le tirage de « ${n} » est terminé. Ouvre l'app pour découvrir ton résultat.`,
    raffleTitle: "Le tirage est terminé !",
    raffleBody: (n) => `« ${n} » a un résultat. Ouvre l'app pour voir les gagnants.`
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
  groupName: string
): { title: string; body: string } {
  const pack = COPY[locale];
  const name = groupName.trim() || "Tarci Secret";
  if (dynamicType === "simple_raffle") {
    return { title: pack.raffleTitle, body: pack.raffleBody(name) };
  }
  return { title: pack.secretSantaTitle, body: pack.secretSantaBody(name) };
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
    groupName: string;
  }
): Promise<void> {
  try {
    const uids = await loadActiveMemberUids(db, params.groupId);
    if (uids.length === 0) {
      logger.info("groupNotifications: no active members", { groupId: params.groupId });
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
    const eventKind =
      params.dynamicType === "simple_raffle" ? "raffle_completed" : "secret_santa_completed";

    for (const [locale, list] of byLocale.entries()) {
      const { title, body } = copyFor(locale, params.dynamicType, params.groupName);
      const tokens = list.map((t) => t.token);
      const response = await messaging.sendEachForMulticast({
        tokens,
        notification: { title, body },
        data: {
          type: "group_dynamic_completed",
          groupId: params.groupId,
          dynamicType: params.dynamicType,
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
      tokenCount: targets.length
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
