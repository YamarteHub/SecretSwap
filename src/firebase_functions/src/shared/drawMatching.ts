import { createHash } from "node:crypto";

export type DrawParticipant = {
  participantId: string;
  displayName: string;
  subgroupId: string | null;
};

export type SubgroupModeNorm = "ignore" | "different" | "preferDifferent";

export function buildExclusionSet(raw: unknown): Set<string> {
  const set = new Set<string>();
  if (!Array.isArray(raw)) return set;
  for (const item of raw) {
    if (!item || typeof item !== "object") continue;
    const o = item as Record<string, unknown>;
    const g = o.giverUid ?? o.giver;
    const r = o.receiverUid ?? o.receiver;
    if (typeof g === "string" && typeof r === "string") {
      set.add(`${g}|${r}`);
    }
  }
  return set;
}

function createSeededRng(seedInput: string) {
  const h = createHash("sha256").update(seedInput).digest();
  let seed = h.readUInt32BE(0);
  return function rng() {
    seed |= 0;
    seed = (seed + 0x6d2b79f5) | 0;
    let t = Math.imul(seed ^ (seed >>> 15), seed | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function shuffle<T>(items: T[], rng: () => number): T[] {
  const a = [...items];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(rng() * (i + 1));
    const tmp = a[i]!;
    a[i] = a[j]!;
    a[j] = tmp;
  }
  return a;
}

function violatesSubgroupDifferent(g: DrawParticipant, r: DrawParticipant): boolean {
  if (g.subgroupId == null || r.subgroupId == null) return true;
  return g.subgroupId === r.subgroupId;
}

function violatesSubgroupPreferStrict(g: DrawParticipant, r: DrawParticipant): boolean {
  if (g.subgroupId != null && r.subgroupId != null && g.subgroupId === r.subgroupId) return true;
  return false;
}

function isValidAssignment(
  givers: DrawParticipant[],
  receivers: DrawParticipant[],
  exclusions: Set<string>,
  phase: "strictSub" | "anySub",
  mode: SubgroupModeNorm
): boolean {
  const n = givers.length;
  for (let i = 0; i < n; i++) {
    const g = givers[i]!;
    const r = receivers[i]!;
    if (g.participantId === r.participantId) return false;
    if (exclusions.has(`${g.participantId}|${r.participantId}`)) return false;
    if (phase === "strictSub") {
      if (mode === "different") {
        if (violatesSubgroupDifferent(g, r)) return false;
      } else if (mode === "preferDifferent") {
        if (violatesSubgroupPreferStrict(g, r)) return false;
      }
    }
  }
  return true;
}

export function computeInternalMatchCount(
  givers: DrawParticipant[],
  receiversByGiverParticipantId: Map<string, DrawParticipant>
): number {
  let c = 0;
  for (const g of givers) {
    const r = receiversByGiverParticipantId.get(g.participantId);
    if (!r) continue;
    if (g.subgroupId != null && r.subgroupId != null && g.subgroupId === r.subgroupId) {
      c++;
    }
  }
  return c;
}

/**
 * Sorteo 1:1 con PRNG determinista por `seedInput` para que reintentos con la misma
 * idempotencia reproduzcan el mismo resultado si la ejecución no llegó a confirmarse.
 */
export function computeMatching(
  participants: DrawParticipant[],
  mode: SubgroupModeNorm,
  exclusions: Set<string>,
  seedInput: string,
  maxAttemptsPerPhase = 300
): { receiversByGiverParticipantId: Map<string, DrawParticipant>; internalMatchCount: number } | null {
  const n = participants.length;
  if (n < 2) return null;

  const givers = [...participants].sort((a, b) => a.participantId.localeCompare(b.participantId));

  const phases: Array<"strictSub" | "anySub"> =
    mode === "ignore"
      ? ["anySub"]
      : mode === "different"
        ? ["strictSub"]
        : ["strictSub", "anySub"];

  for (const phase of phases) {
    for (let attempt = 0; attempt < maxAttemptsPerPhase; attempt++) {
      const rng = createSeededRng(`${seedInput}:${phase}:${attempt}`);
      const receivers = shuffle(givers, rng);
      if (isValidAssignment(givers, receivers, exclusions, phase, mode)) {
        const receiversByGiverParticipantId = new Map<string, DrawParticipant>();
        for (let i = 0; i < n; i++) {
          receiversByGiverParticipantId.set(givers[i]!.participantId, receivers[i]!);
        }
        const internalMatchCount = computeInternalMatchCount(givers, receiversByGiverParticipantId);
        return { receiversByGiverParticipantId, internalMatchCount };
      }
    }
  }
  return null;
}
