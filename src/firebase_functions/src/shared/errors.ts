export type ErrorCode =
  | "UNAUTHENTICATED"
  | "FORBIDDEN"
  | "VALIDATION_ERROR"
  | "NOT_FOUND"
  | "DRAW_IN_PROGRESS"
  | "DRAW_ALREADY_COMPLETED"
  | "INVITE_ERROR"
  | "MEMBERSHIP_ERROR"
  | "INTERNAL";

export class AppError extends Error {
  public readonly code: ErrorCode;
  public readonly reasonCode?: string;
  public readonly details?: unknown;

  constructor(params: { code: ErrorCode; reasonCode?: string; message: string; details?: unknown }) {
    super(params.message);
    this.code = params.code;
    this.reasonCode = params.reasonCode;
    this.details = params.details;
  }

  static from(code: ErrorCode, message: string, details?: unknown) {
    return new AppError({ code, message, details });
  }
}

export function assertNever(x: never): never {
  throw new AppError({ code: "INTERNAL", message: "assertNever reached", details: { x } });
}

