/* eslint-disable no-console */
/**
 * Test manual mínimo contra emulador para la callable `joinGroupByCode`.
 *
 * Requisitos:
 * - Functions emulator corriendo (default: http://127.0.0.1:5001)
 * - Auth emulator corriendo (default: http://127.0.0.1:9099)
 *
 * Uso:
 *   node tools/test_join_by_code.js --code CODE --uid U_TEST --nickname Nick --expectReasonCode ALREADY_MEMBER
 */

const crypto = require("node:crypto");

function parseArgs(argv) {
  const args = { _: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (!a.startsWith("--")) {
      args._.push(a);
      continue;
    }
    const key = a.slice(2);
    const next = argv[i + 1];
    if (!next || next.startsWith("--")) {
      args[key] = true;
    } else {
      args[key] = next;
      i++;
    }
  }
  return args;
}

function requireString(value, name) {
  if (!value || typeof value !== "string") {
    throw new Error(`Missing --${name}`);
  }
  return value;
}

function getHost(envName, fallback) {
  const raw = process.env[envName];
  if (!raw) return fallback;
  if (raw.startsWith("http://") || raw.startsWith("https://")) return raw;
  return `http://${raw}`;
}

async function fetchJson(url, opts) {
  const res = await fetch(url, opts);
  const text = await res.text();
  let json = null;
  try {
    json = text ? JSON.parse(text) : null;
  } catch {
    json = null;
  }
  return { ok: res.ok, status: res.status, json, text };
}

function stableEmailForUid(uid) {
  return `${uid.toLowerCase()}@test.local`;
}

function stablePasswordForUid(uid) {
  // suficientemente estable para pruebas locales
  return `pw_${crypto.createHash("sha1").update(uid).digest("hex").slice(0, 12)}`;
}

async function ensureIdTokenForUid({ authBaseUrl, uid }) {
  const apiKey = "fake-api-key";
  const email = stableEmailForUid(uid);
  const password = stablePasswordForUid(uid);

  const signUpUrl = `${authBaseUrl}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=${apiKey}`;
  const signInUrl = `${authBaseUrl}/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${apiKey}`;

  // 1) intentamos crear el usuario con localId = uid
  const signUp = await fetchJson(signUpUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      email,
      password,
      returnSecureToken: true,
      localId: uid
    })
  });

  if (signUp.ok && signUp.json?.idToken) {
    return { idToken: signUp.json.idToken, created: true };
  }

  const errMsg = signUp.json?.error?.message;
  if (errMsg && (errMsg.includes("EMAIL_EXISTS") || errMsg.includes("LOCAL_ID_EXISTS"))) {
    const signIn = await fetchJson(signInUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email,
        password,
        returnSecureToken: true
      })
    });

    if (signIn.ok && signIn.json?.idToken) {
      return { idToken: signIn.json.idToken, created: false };
    }
    throw new Error(`Auth signIn failed: ${signIn.status} ${signIn.text}`);
  }

  throw new Error(
    `Auth signUp failed: ${signUp.status} ${signUp.text}\n` +
      "Verifica que el Auth emulator esté corriendo y accesible."
  );
}

function extractCallableResult(json) {
  if (!json) return null;
  if (typeof json.result !== "undefined") return json.result;
  if (typeof json.data !== "undefined") return json.data;
  return null;
}

function extractReasonCodeFromCallableError(json) {
  const reason =
    json?.error?.details?.reasonCode ??
    json?.error?.details?.details?.reasonCode ??
    json?.details?.reasonCode ??
    null;
  return reason;
}

async function run() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(
      "Usage: node tools/test_join_by_code.js --code CODE --uid UID [--nickname Nick] [--expectReasonCode CODE] [--projectId secretswap-dev] [--region us-central1]"
    );
    process.exit(0);
  }

  const code = requireString(args.code, "code");
  const uid = requireString(args.uid, "uid");
  const nickname = typeof args.nickname === "string" ? args.nickname : undefined;
  const expectReasonCode = typeof args.expectReasonCode === "string" ? args.expectReasonCode : undefined;

  const projectId = String(args.projectId ?? process.env.GCLOUD_PROJECT ?? "secretswap-dev");
  const region = String(args.region ?? "us-central1");

  const functionsBaseUrl = getHost("FUNCTIONS_EMULATOR_URL", "http://127.0.0.1:5001");
  const authBaseUrl = getHost("AUTH_EMULATOR_URL", "http://127.0.0.1:9099");

  const { idToken } = await ensureIdTokenForUid({ authBaseUrl, uid });

  const url = `${functionsBaseUrl}/${projectId}/${region}/joinGroupByCode`;
  const requestData = nickname ? { code, nickname } : { code };

  console.log("=== REQUEST ===");
  console.log(JSON.stringify({ url, uid, data: requestData }, null, 2));

  const res = await fetchJson(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${idToken}`
    },
    body: JSON.stringify({ data: requestData })
  });

  console.log("\n=== RESPONSE ===");
  console.log(`HTTP ${res.status}`);
  console.log(res.json ? JSON.stringify(res.json, null, 2) : res.text);

  const isSuccess = res.ok && !res.json?.error;
  const reasonCode = isSuccess ? null : extractReasonCodeFromCallableError(res.json);

  console.log("\n=== RESULT ===");
  if (isSuccess) {
    console.log("SUCCESS");
    const result = extractCallableResult(res.json);
    console.log("callableResult:", JSON.stringify(result, null, 2));
  } else {
    console.log("FAILURE");
    console.log("reasonCode:", reasonCode);
  }

  if (expectReasonCode) {
    if (reasonCode !== expectReasonCode) {
      console.error(
        `\nExpectation failed: expectReasonCode=${expectReasonCode}, got=${reasonCode ?? "(none)"}`
      );
      process.exit(2);
    }
    console.log("\nExpectation OK.");
    process.exit(0);
  }

  // sin expectativa: exit 0 si éxito, 1 si fallo
  process.exit(isSuccess ? 0 : 1);
}

run().catch((e) => {
  console.error(e?.stack || e);
  process.exit(1);
});

