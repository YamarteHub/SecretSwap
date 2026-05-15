"""Genera el isotipo con padding para el splash nativo Android 12+.

Android recorta `android_12.image` con una máscara circular (~768 px de
diámetro en un lienzo de 1152×1152). Un logo vertical con wordmark se
parte; este asset centra solo el isotipo (Tarci + regalo) con margen.

Fuente: TarciSecret_Icono_Transparent.png
Salida: src/flutter_app/assets/brand/TarciSecret_Icono_Splash_Android12.png
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
BRAND = ROOT / "src" / "flutter_app" / "assets" / "brand"
SRC = BRAND / "TarciSecret_Icono_Transparent.png"
DST = BRAND / "TarciSecret_Icono_Splash_Android12.png"

CANVAS = 1152
SAFE = 640  # < 768 px (diámetro de la zona segura Android 12+)


def main() -> None:
    icon = Image.open(SRC).convert("RGBA")
    icon.thumbnail((SAFE, SAFE), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
    x = (CANVAS - icon.width) // 2
    y = (CANVAS - icon.height) // 2
    canvas.paste(icon, (x, y), icon)
    canvas.save(DST, optimize=True)
    print(f"Wrote {DST} (icon {icon.size} on {CANVAS}x{CANVAS})")


if __name__ == "__main__":
    main()
