"""Generar variantes transparentes de los PNG de marca.

Los PNG originales tienen fondo crema/blanco opaco. Este script:

1. Estima el color de fondo a partir de las esquinas.
2. Calcula la "distancia" perceptual de cada pixel al color de fondo.
3. Aplica un color-key con feathering:
   - cerca del color de fondo  -> alpha = 0  (transparente)
   - medio                     -> alpha proporcional (suaviza bordes)
   - lejos del color de fondo  -> alpha = 255 (opaco)
4. Si el pixel se considera fondo, además lo "neutraliza" a un gris medio
   para que cualquier residuo en composiciones modernas no introduzca
   tinte crema/blanco.
5. Recorta espacios totalmente transparentes (trim) para que el logo
   quede sin marco vacío y se integre en cards/heroes.

No es retoque de diseño: es color-key automático sobre fondos uniformes.
Los archivos transparentes finales se guardan junto a los originales con
sufijo `_Transparent.png`.
"""

from __future__ import annotations

from pathlib import Path

import numpy as np
from PIL import Image

ASSETS_DIR = Path(__file__).resolve().parent.parent / "src" / "flutter_app" / "assets" / "brand"

# Distancia (en RGB 0-255) a partir de la cual el pixel se considera totalmente
# parte del logo (alpha=255). Por debajo de NEAR se considera fondo (alpha=0).
NEAR = 10.0
FAR = 60.0


def estimate_background(rgb: np.ndarray) -> np.ndarray:
    h, w, _ = rgb.shape
    # Promediar 4 muestras 16x16 en cada esquina.
    samples = [
        rgb[:16, :16].reshape(-1, 3),
        rgb[:16, w - 16 :].reshape(-1, 3),
        rgb[h - 16 :, :16].reshape(-1, 3),
        rgb[h - 16 :, w - 16 :].reshape(-1, 3),
    ]
    return np.median(np.concatenate(samples), axis=0).astype(np.float32)


def make_transparent(src_path: Path, dst_path: Path) -> tuple[int, int, int]:
    with Image.open(src_path) as img:
        rgb = np.asarray(img.convert("RGB"), dtype=np.float32)

    bg = estimate_background(rgb)
    distance = np.sqrt(np.sum((rgb - bg) ** 2, axis=-1))

    # Alpha por feathering lineal entre NEAR y FAR.
    alpha = np.clip((distance - NEAR) / (FAR - NEAR), 0.0, 1.0)
    alpha8 = (alpha * 255).astype(np.uint8)

    rgb8 = rgb.astype(np.uint8)
    rgba = np.dstack([rgb8, alpha8])

    out = Image.fromarray(rgba, mode="RGBA")

    # Trim: recortar bordes completamente transparentes para que el logo no
    # tenga padding extra que rompa la integración visual.
    bbox = out.getbbox()
    if bbox is not None:
        out = out.crop(bbox)

    out.save(dst_path, optimize=True)

    transparent_pixels = int(np.sum(alpha8 == 0))
    semi_pixels = int(np.sum((alpha8 > 0) & (alpha8 < 255)))
    opaque_pixels = int(np.sum(alpha8 == 255))
    return transparent_pixels, semi_pixels, opaque_pixels


def main() -> None:
    targets = [
        ("TarciSecret_Vertical.png", "TarciSecret_Vertical_Transparent.png"),
        ("TarciSecret_Horizontal.png", "TarciSecret_Horizontal_Transparent.png"),
        ("TarciSecret_Icono.png", "TarciSecret_Icono_Transparent.png"),
        ("TarciSecret_Principal.png", "TarciSecret_Principal_Transparent.png"),
    ]
    for src_name, dst_name in targets:
        src = ASSETS_DIR / src_name
        dst = ASSETS_DIR / dst_name
        if not src.exists():
            print(f"!! falta source: {src}")
            continue
        t, s, o = make_transparent(src, dst)
        size_kb = dst.stat().st_size / 1024
        print(
            f"OK  {src_name} -> {dst_name}  "
            f"transparent={t}  semi={s}  opaque={o}  "
            f"size={size_kb:.0f} KB"
        )


if __name__ == "__main__":
    main()
