"""Decode base64 icon sources into HarmonyOS resource directories.

Run once after cloning (CI and DevEco users):
    python3 scripts/prepare_assets.py
"""
import base64
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

PAIRS = [
    ("assets/app_icon.png.b64", "AppScope/resources/base/media/app_icon.png"),
    ("assets/icon.png.b64", "entry/src/main/resources/base/media/icon.png"),
]


def main() -> None:
    for src, dst in PAIRS:
        s = os.path.join(ROOT, src)
        d = os.path.join(ROOT, dst)
        if os.path.exists(d):
            print("skip (exists):", dst)
            continue
        os.makedirs(os.path.dirname(d), exist_ok=True)
        with open(s, "rb") as f:
            data = base64.b64decode(f.read())
        with open(d, "wb") as f:
            f.write(data)
        print("decoded:", dst, len(data), "bytes")


if __name__ == "__main__":
    main()
