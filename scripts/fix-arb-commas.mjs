import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, "..");

for (const loc of ["it", "pt", "fr", "en", "es"]) {
  const p = path.join(root, "src/flutter_app/lib/l10n", `app_${loc}.arb`);
  let raw = fs.readFileSync(p, "utf8");
  raw = raw.replace(/^\s*,\s*\r?\n/gm, "");
  raw = raw.replace(/\."\s+"(chatSystem)/g, '.",\n  "$1');
  raw = raw.replace(/\."\s+"(pairings|duels|home)/g, '.",\n  "$1');
  fs.writeFileSync(p, raw);
  console.log("fixed", loc);
}
