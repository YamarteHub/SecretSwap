"""Verificar que las variantes transparentes preservan el logo."""

from pathlib import Path
import numpy as np
from PIL import Image

ASSETS_DIR = Path(__file__).resolve().parent.parent / "src" / "flutter_app" / "assets" / "brand"


def main() -> None:
    for path in sorted(ASSETS_DIR.glob("TarciSecret_*_Transparent.png")):
        with Image.open(path) as img:
            arr = np.asarray(img.convert("RGBA"))
            h, w, _ = arr.shape
            alpha = arr[..., 3]
            cy, cx = h // 2, w // 2
            box = alpha[cy - 50 : cy + 50, cx - 50 : cx + 50]
            print(f"== {path.name} ==")
            print(f"  size after trim: {w}x{h}")
            print(
                f"  global alpha  min={alpha.min()}  max={alpha.max()}  mean={alpha.mean():.1f}"
            )
            print(
                f"  centro 100x100 alpha  min={box.min()}  max={box.max()}  mean={box.mean():.1f}"
            )
            sample_pixels = arr[cy, cx - 5 : cx + 5]
            print(f"  centro pixels (RGBA): {sample_pixels.tolist()}")
            print()


if __name__ == "__main__":
    main()
