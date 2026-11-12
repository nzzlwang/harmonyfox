"""Generate HarmonyFox app icons with PIL.

Usage:
    pip install pillow
    python3 scripts/gen_icon.py
"""
import base64
import io
import os

from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def make_icon(size: int) -> Image.Image:
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # rounded orange square background
    r = size // 6
    d.rounded_rectangle([0, 0, size - 1, size - 1], radius=r, fill=(230, 95, 23, 255))
    # swirl: white ring + orange cut + white dot
    cx, cy = size // 2, size // 2
    rw = int(size * 0.30)
    d.ellipse([cx - rw, cy - rw, cx + rw, cy + rw], fill=(255, 255, 255, 255))
    rw2 = int(size * 0.18)
    d.ellipse([cx - rw2 + int(size * 0.10), cy - rw2 - int(size * 0.06),
               cx + rw2 + int(size * 0.10), cy + rw2 - int(size * 0.06)], fill=(230, 95, 23, 255))
    rw3 = int(size * 0.09)
    d.ellipse([cx - rw3 - int(size * 0.13), cy - rw3 + int(size * 0.11),
               cx + rw3 - int(size * 0.13), cy + rw3 + int(size * 0.11)], fill=(255, 255, 255, 255))
    return img


def main() -> None:
    img = make_icon(512)
    targets = [
        "AppScope/resources/base/media/app_icon.png",
        "entry/src/main/resources/base/media/icon.png",
    ]
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    data = buf.getvalue()
    for rel in targets:
        path = os.path.join(ROOT, rel)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "wb") as f:
            f.write(data)
        print("wrote", rel, len(data), "bytes")
    # keep the base64 mirrors in assets/ in sync
    b64 = base64.b64encode(data).decode()
    for rel in ["assets/app_icon.png.b64", "assets/icon.png.b64"]:
        path = os.path.join(ROOT, rel)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w") as f:
            f.write(b64 + "\n")
        print("wrote", rel)


if __name__ == "__main__":
    main()
