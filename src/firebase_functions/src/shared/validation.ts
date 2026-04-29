import { z } from "zod";
import { AppError } from "./errors";

export function parseOrThrow<T>(schema: z.ZodSchema<T>, input: unknown): T {
  const res = schema.safeParse(input);
  if (!res.success) {
    throw new AppError({
      code: "VALIDATION_ERROR",
      reasonCode: "VALIDATION_ERROR",
      message: "Invalid request",
      details: res.error.format()
    });
  }
  return res.data;
}

