import { AppError } from "./errors";

export function requireAuthUid(authUid: string | undefined | null): string {
  if (!authUid) {
    throw new AppError({ code: "UNAUTHENTICATED", message: "Authentication required" });
  }
  return authUid;
}

