import { DocumentSnapshot, Firestore, QueryDocumentSnapshot } from "firebase-admin/firestore";

export type ParticipantLite = {
  participantId: string;
  participantType: string;
  linkedUid: string | null;
  managedByUid: string | null;
  state: string;
};

export function parseParticipantDoc(doc: DocumentSnapshot): ParticipantLite | null {
  if (!doc.exists) return null;
  const d = doc.data() as Record<string, unknown>;
  const state = typeof d.state === "string" ? d.state : "";
  if (state !== "active") return null;
  const participantType = typeof d.participantType === "string" ? d.participantType : "managed";
  const linkedUid = typeof d.linkedUid === "string" && d.linkedUid.trim() !== "" ? d.linkedUid.trim() : null;
  const managedByUid =
    typeof d.managedByUid === "string" && d.managedByUid.trim() !== "" ? d.managedByUid.trim() : null;
  const participantId =
    typeof d.participantId === "string" && d.participantId.trim() !== "" ? d.participantId.trim() : doc.id;
  return { participantId, participantType, linkedUid, managedByUid, state };
}

export function participantsMapFromSnap(docs: QueryDocumentSnapshot[]): Map<string, ParticipantLite> {
  const m = new Map<string, ParticipantLite>();
  for (const doc of docs) {
    const p = parseParticipantDoc(doc);
    if (p) m.set(p.participantId, p);
  }
  return m;
}

export async function buildParticipantsMapForWishlist(db: Firestore, groupId: string): Promise<Map<string, ParticipantLite>> {
  const snap = await db.collection(`groups/${groupId}/participants`).get();
  const m = participantsMapFromSnap(snap.docs);
  const members = await db.collection(`groups/${groupId}/members`).get();
  for (const doc of members.docs) {
    const uidM = doc.id;
    const st = doc.data()?.memberState;
    if (st !== "active") continue;
    if ([...m.values()].some((p) => p.linkedUid === uidM)) continue;
    if (m.has(uidM)) continue;
    m.set(uidM, {
      participantId: uidM,
      participantType: "app_member",
      linkedUid: uidM,
      managedByUid: null,
      state: "active"
    });
  }
  return m;
}

export async function resolveTargetParticipant(
  db: Firestore,
  groupId: string,
  targetParticipantId: string,
  participantsById: Map<string, ParticipantLite>
): Promise<ParticipantLite | null> {
  if (participantsById.has(targetParticipantId)) {
    return participantsById.get(targetParticipantId)!;
  }
  const direct = await db.doc(`groups/${groupId}/participants/${targetParticipantId}`).get();
  const parsed = parseParticipantDoc(direct);
  if (parsed) {
    participantsById.set(parsed.participantId, parsed);
    return parsed;
  }
  const memberSnap = await db.doc(`groups/${groupId}/members/${targetParticipantId}`).get();
  if (!memberSnap.exists || memberSnap.data()?.memberState !== "active") return null;
  const stub: ParticipantLite = {
    participantId: targetParticipantId,
    participantType: "app_member",
    linkedUid: targetParticipantId,
    managedByUid: null,
    state: "active"
  };
  participantsById.set(stub.participantId, stub);
  return stub;
}

export function effectiveGuardianUid(p: ParticipantLite, ownerUid: string): string {
  if (p.participantType === "managed" || p.participantType === "child_managed") {
    return p.managedByUid ?? ownerUid;
  }
  return ownerUid;
}

export function canEditWishlist(uid: string, target: ParticipantLite, ownerUid: string): boolean {
  if (target.state !== "active") return false;
  if (target.linkedUid && target.linkedUid === uid) return true;
  if (target.participantType === "managed" || target.participantType === "child_managed") {
    return effectiveGuardianUid(target, ownerUid) === uid;
  }
  return false;
}

export function canViewWishlist(
  uid: string,
  receiverPid: string,
  ownerUid: string,
  drawStatus: string | undefined,
  participantsById: Map<string, ParticipantLite>,
  assignmentRows: Record<string, unknown>[]
): boolean {
  const target = participantsById.get(receiverPid);
  if (!target) return false;
  if (canEditWishlist(uid, target, ownerUid)) return true;
  if (drawStatus !== "completed") return false;

  for (const a of assignmentRows) {
    const recvPid = typeof a.receiverParticipantId === "string" ? a.receiverParticipantId : null;
    if (recvPid !== receiverPid) continue;
    const giverUid = typeof a.giverUid === "string" && a.giverUid.trim() !== "" ? a.giverUid.trim() : null;
    if (giverUid && giverUid === uid) return true;
    const giverPid = typeof a.giverParticipantId === "string" ? a.giverParticipantId : null;
    if (!giverPid) continue;
    const giver = participantsById.get(giverPid);
    if (!giver) continue;
    if (giver.participantType === "managed" || giver.participantType === "child_managed") {
      if (effectiveGuardianUid(giver, ownerUid) === uid) return true;
    }
  }
  return false;
}
