"""Diagnose alpha transparency of Tarci Secret brand PNGs.

Para cada asset reporta:
- modo (RGB/RGBA),
- si tiene canal alpha,
- min/max alpha,
- estadística por bordes (esquinas + filas/columnas extremas),
- veredicto: transparente real / fondo opaco.
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ASSETS_DIR = Path(__file__).resolve().parent.parent / "src" / "flutter_app" / "assets" / "brand"


def sample_corner(img: Image.Image, x: int, y: int) -> tuple[int, int, int, int]:
    pixel = img.getpixel((x, y))
    if isinstance(pixel, tuple):
        if len(pixel) == 3:
            return (*pixel, 255)
        if len(pixel) == 4:
            return pixel  # type: ignore[return-value]
    return (pixel, pixel, pixel, 255)


def edge_alpha_stats(img: Image.Image) -> tuple[int, int, float]:
    if img.mode != "RGBA":
        return (255, 255, 255.0)
    w, h = img.size
    pixels = img.load()
    alphas: list[int] = []
    for x in range(w):
        alphas.append(pixels[x, 0][3])
        alphas.append(pixels[x, h - 1][3])
    for y in range(h):
        alphas.append(pixels[0, y][3])
        alphas.append(pixels[w - 1, y][3])
    return (min(alphas), max(alphas), sum(alphas) / len(alphas))


def main() -> None:
    if not ASSETS_DIR.is_dir():
        raise SystemExit(f"No existe: {ASSETS_DIR}")

    for path in sorted(ASSETS_DIR.glob("TarciSecret_*.png")):
        with Image.open(path) as img:
            mode = img.mode
            w, h = img.size
            has_alpha = mode in ("RGBA", "LA") or "transparency" in img.info
            alpha_min = alpha_max = 255
            alpha_avg = 255.0
            if mode != "RGBA":
                rgba = img.convert("RGBA")
            else:
                rgba = img
            alpha_min, alpha_max, alpha_avg = edge_alpha_stats(rgba)
            corners = [
                sample_corner(rgba, 0, 0),
                sample_corner(rgba, w - 1, 0),
                sample_corner(rgba, 0, h - 1),
                sample_corner(rgba, w - 1, h - 1),
            ]

            verdict = "TRANSPARENTE" if alpha_max < 250 or (alpha_min == 0 and alpha_avg < 50) else "FONDO OPACO"

            print(f"== {path.name} ({w}x{h}, mode={mode}) ==")
            print(f"  has_alpha_channel={has_alpha}")
            print(f"  edge alpha  min={alpha_min}  max={alpha_max}  avg={alpha_avg:.1f}")
            print(f"  esquinas (RGBA): {corners}")
            print(f"  veredicto: {verdict}")
            print()


if __name__ == "__main__":
    main()
