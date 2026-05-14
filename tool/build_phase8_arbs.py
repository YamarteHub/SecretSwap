#!/usr/bin/env python3
"""
Genera app_pt.arb, app_it.arb y app_fr.arb a partir de app_es.arb:
- Copia metadatos @* y orden de claves del template ES.
- Aplica overrides de docs/*.json (locale_pt/it/fr) y mensajes Tarci del JSON de chat.
- Traduce el resto ES→(pt|it|fr) con GoogleTranslator, preservando {placeholders}.
"""
from __future__ import annotations

import json
import re
import time
from collections import OrderedDict
from pathlib import Path

try:
    from deep_translator import GoogleTranslator
except ImportError as e:
    raise SystemExit("Instala dependencias: pip install deep-translator") from e

ROOT = Path(__file__).resolve().parents[1]
FLUTTER = ROOT / "src" / "flutter_app"
L10N = FLUTTER / "lib" / "l10n"
DOCS = ROOT / "docs"

# Líneas de marca / legales: mantener igual que ES en todos los locales.
BRAND_KEYS = frozenset(
    {
        "appName",
        "productAuthorshipLine",
        "aboutCopyrightLine",
    }
)

DOC_FILES = [
    "tarci_phase_6c_chat_refresh_i18n.json",
    "tarci_phase_7a_delete_group_i18n.json",
    "tarci_phase_7b_about_author_i18n.json",
]


def template_key_to_arb_key(template_key: str) -> str:
    parts = template_key.split(".")
    s = parts[0]
    for p in parts[1:]:
        if p in ("v1", "v2"):
            s += p.upper()
        elif p.isdigit():
            s += p
        elif p:
            s += p[0].upper() + p[1:]
    return s


def load_doc_overrides() -> tuple[dict[str, str], dict[str, str], dict[str, str]]:
    pt: dict[str, str] = {}
    it: dict[str, str] = {}
    fr: dict[str, str] = {}
    for name in DOC_FILES:
        path = DOCS / name
        if not path.exists():
            continue
        data = json.loads(path.read_text(encoding="utf-8"))
        for loc, bucket in (
            ("locale_pt", pt),
            ("locale_it", it),
            ("locale_fr", fr),
        ):
            if loc in data and isinstance(data[loc], dict):
                bucket.update(data[loc])
    chat_path = DOCS / "tarci_chat_auto_messages_i18n.json"
    if chat_path.exists():
        rows = json.loads(chat_path.read_text(encoding="utf-8"))
        for row in rows:
            ak = template_key_to_arb_key(row["templateKey"])
            pt[ak] = row["pt"]
            it[ak] = row["it"]
            fr[ak] = row["fr"]
    return pt, it, fr


def load_arb(path: Path) -> OrderedDict:
    return json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=OrderedDict)


def translate_safe(translator: GoogleTranslator, text: str) -> str:
    if not text.strip():
        return text
    if "{" in text:
        parts = re.split(r"(\{[^}]+\})", text)
        out: list[str] = []
        for chunk in parts:
            if chunk.startswith("{") and chunk.endswith("}"):
                out.append(chunk)
            elif chunk:
                try:
                    t = translator.translate(chunk)
                    out.append(t if t else chunk)
                except Exception:
                    out.append(chunk)
                time.sleep(0.04)
        return "".join(out)
    try:
        t = translator.translate(text)
        return t if t else text
    except Exception:
        return text


def build_for_target(
    target: str,
    overrides: dict[str, str],
    es: OrderedDict,
    en: OrderedDict,
) -> OrderedDict:
    translator = GoogleTranslator(source="es", target=target)
    out: OrderedDict[str, object] = OrderedDict()
    out["@@locale"] = target
    for key, val in es.items():
        if key == "@@locale":
            continue
        if key.startswith("@"):
            out[key] = val
            continue
        if not isinstance(val, str):
            out[key] = val
            continue
        if key in overrides and overrides[key].strip():
            out[key] = overrides[key]
            continue
        if key in BRAND_KEYS:
            out[key] = val
            continue
        translated = translate_safe(translator, val)
        out[key] = translated
        time.sleep(0.03)
    return out


def main() -> None:
    es = load_arb(L10N / "app_es.arb")
    en = load_arb(L10N / "app_en.arb")
    pt_o, it_o, fr_o = load_doc_overrides()
    for code, ovs in (("pt", pt_o), ("it", it_o), ("fr", fr_o)):
        arb = build_for_target(code, ovs, es, en)
        out_path = L10N / f"app_{code}.arb"
        out_path.write_text(
            json.dumps(arb, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print("Wrote", out_path, "keys", len(arb))


if __name__ == "__main__":
    main()
