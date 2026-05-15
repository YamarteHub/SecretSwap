import { onCall, CallableRequest, HttpsError } from "firebase-functions/v2/https";
import { requireAuthUid } from "../shared/auth";
import { UpdateTeamLabelRequestSchema, UpdateTeamLabelResponse } from "../shared/dtos";
import { AppError } from "../shared/errors";
import { getDb } from "../shared/firestore";
import { groupPaths } from "../shared/firestorePaths";
import { parseOrThrow } from "../shared/validation";

const MAX_LABEL_LEN = 40;

export const updateTeamLabel = onCall(
  async (req: CallableRequest<unknown>): Promise<UpdateTeamLabelResponse> => {
    try {
      const uid = requireAuthUid(req.auth?.uid);
      const body = parseOrThrow(UpdateTeamLabelRequestSchema, req.data);
      const label = body.teamLabel.trim();
      if (label.length === 0) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAM_LABEL_EMPTY",
          message: "Team label is empty"
        });
      }
      if (label.length > MAX_LABEL_LEN) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAM_LABEL_TOO_LONG",
          message: `Team label exceeds ${MAX_LABEL_LEN} characters`
        });
      }

      const db = getDb();
      const groupRef = db.doc(groupPaths.groupDoc(body.groupId));
      const groupSnap = await groupRef.get();
      if (!groupSnap.exists) {
        throw new AppError({ code: "NOT_FOUND", reasonCode: "GROUP_NOT_FOUND", message: "Group not found" });
      }
      const group = groupSnap.data() as {
        ownerUid?: string;
        dynamicType?: string;
        teamStatus?: string;
        lastTeamExecutionId?: string;
      };
      if (group.ownerUid !== uid) {
        throw new AppError({ code: "FORBIDDEN", reasonCode: "NOT_OWNER", message: "Only owner can rename teams" });
      }
      const dyn = typeof group.dynamicType === "string" ? group.dynamicType.trim() : "secret_santa";
      if (dyn !== "teams") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "NOT_TEAMS_GROUP",
          message: "Group is not a teams dynamic"
        });
      }
      if (group.teamStatus !== "completed") {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "TEAMS_NOT_COMPLETED",
          message: "Teams must be formed before renaming"
        });
      }
      const executionId =
        typeof group.lastTeamExecutionId === "string" ? group.lastTeamExecutionId.trim() : "";
      if (executionId.length === 0) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "NO_TEAM_EXECUTION",
          message: "No team execution found"
        });
      }

      const executionRef = db.doc(groupPaths.teamExecutionDoc(body.groupId, executionId));
      const executionSnap = await executionRef.get();
      if (!executionSnap.exists) {
        throw new AppError({
          code: "NOT_FOUND",
          reasonCode: "TEAM_EXECUTION_NOT_FOUND",
          message: "Team execution not found"
        });
      }
      const raw = executionSnap.data() as { teamsSnapshot?: unknown };
      if (!Array.isArray(raw.teamsSnapshot)) {
        throw new AppError({
          code: "VALIDATION_ERROR",
          reasonCode: "INVALID_SNAPSHOT",
          message: "Invalid teams snapshot"
        });
      }

      const teamsSnapshot = raw.teamsSnapshot.map((item) => {
        if (typeof item !== "object" || item === null) return item;
        return { ...(item as Record<string, unknown>) };
      }) as Array<Record<string, unknown>>;

      let found = false;
      for (const team of teamsSnapshot) {
        const idx = typeof team.teamIndex === "number" ? team.teamIndex : -1;
        if (idx === body.teamIndex) {
          team.teamLabel = label;
          found = true;
          break;
        }
      }
      if (!found) {
        throw new AppError({
          code: "NOT_FOUND",
          reasonCode: "TEAM_INDEX_NOT_FOUND",
          message: "Team index not found in snapshot"
        });
      }

      await executionRef.update({ teamsSnapshot });

      return { teamIndex: body.teamIndex, teamLabel: label };
    } catch (e) {
      const err = e as unknown;
      if (err instanceof AppError) {
        throw new HttpsError("failed-precondition", err.message, {
          code: err.code,
          reasonCode: err.reasonCode,
          details: err.details
        });
      }
      throw new HttpsError("internal", "Internal error");
    }
  }
);
