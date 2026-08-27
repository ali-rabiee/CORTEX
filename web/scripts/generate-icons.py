"""Generate CORTEX app icons (PWA + Apple touch) from code, so they stay reproducible.

Run:  python3 scripts/generate-icons.py
Writes PNGs into public/icons/.
"""

from __future__ import annotations

import os

from PIL import Image, ImageDraw

OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "public", "icons")

BG_TOP = (23, 27, 46)
BG_BOTTOM = (13, 17, 23)
NODE = (157, 151, 255)
NODE_CORE = (108, 99, 255)
EDGE = (108, 99, 255, 120)

# A three-layer network motif, in normalized coordinates.
LAYERS = [
    [(0.16, 0.30), (0.16, 0.70)],
    [(0.50, 0.13), (0.50, 0.50), (0.50, 0.87)],
    [(0.84, 0.30), (0.84, 0.70)],
]


def _gradient(size: int) -> Image.Image:
    img = Image.new("RGB", (1, size))
    px = img.load()
    for y in range(size):
        t = y / max(size - 1, 1)
        px[0, y] = tuple(
            round(BG_TOP[i] + (BG_BOTTOM[i] - BG_TOP[i]) * t) for i in range(3)
        )
    return img.resize((size, size))


def _rounded_mask(size: int, radius_ratio: float) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, size - 1, size - 1), radius=round(size * radius_ratio), fill=255
    )
    return mask


def render(size: int, *, radius_ratio: float, content_scale: float) -> Image.Image:
    # Supersample 4x, then downscale — gives us clean antialiased strokes.
    s = size * 4
    img = _gradient(s).convert("RGBA")
    overlay = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    box = s * content_scale
    origin = (s - box) / 2

    def pt(p: tuple[float, float]) -> tuple[float, float]:
        return (origin + p[0] * box, origin + p[1] * box)

    edge_w = max(round(s * 0.012), 1)
    for a, b in zip(LAYERS, LAYERS[1:]):
        for src in a:
            for dst in b:
                draw.line([pt(src), pt(dst)], fill=EDGE, width=edge_w)

    for layer in LAYERS:
        for p in layer:
            cx, cy = pt(p)
            r = s * 0.052
            draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=NODE)
            r2 = r * 0.45
            draw.ellipse((cx - r2, cy - r2, cx + r2, cy + r2), fill=NODE_CORE)

    img = Image.alpha_composite(img, overlay)
    img = img.resize((size, size), Image.LANCZOS)

    if radius_ratio > 0:
        img.putalpha(_rounded_mask(size, radius_ratio))
    return img


def main() -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    targets = [
        # (filename, size, radius_ratio, content_scale)
        ("icon-192.png", 192, 0.22, 0.62),
        ("icon-512.png", 512, 0.22, 0.62),
        # Maskable icons are cropped to a circle by Android — keep art in the
        # inner 60% safe zone and let the background bleed to the edges.
        ("maskable-192.png", 192, 0.0, 0.46),
        ("maskable-512.png", 512, 0.0, 0.46),
        # iOS applies its own mask, so ship it square.
        ("apple-touch-icon.png", 180, 0.0, 0.62),
        ("favicon-32.png", 32, 0.18, 0.66),
    ]
    for name, size, radius, scale in targets:
        img = render(size, radius_ratio=radius, content_scale=scale)
        if name == "apple-touch-icon.png":
            img = img.convert("RGB")  # iOS dislikes alpha here
        img.save(os.path.join(OUT_DIR, name))
        print(f"wrote {name} ({size}x{size})")


if __name__ == "__main__":
    main()
