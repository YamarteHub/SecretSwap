import crypto from "node:crypto";

export function normalizeInviteCode(code: string): string {
  return code.trim().toUpperCase();
}

export function hashInviteCode(code: string): string {
  const normalized = normalizeInviteCode(code);
  return crypto.createHash("sha256").update(normalized, "utf8").digest("hex");
}

const INVITE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // sin I,O,1,0

export function generateInviteCode(length = 8): string {
  const bytes = crypto.randomBytes(length);
  let out = "";
  for (let i = 0; i < length; i++) {
    out += INVITE_ALPHABET[bytes[i] % INVITE_ALPHABET.length];
  }
  return out;
}

