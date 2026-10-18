#!/usr/bin/env python3
"""Render the StreetBite launcher icon sources into assets/icon.

The mark is the bowl-and-steam motif from
`lib/presentation/widgets/streetbite_logo.dart`, redrawn here instead of
screenshotted so it stays pixel-exact and can be regenerated whenever the
brand changes.

It is not a straight copy of the in-app drawing. The app renders the bowl as a
thin stroked arc, which works on a 96dp white tile; on a green launcher square
at 48dp the same arc reads as a smiley face with three exclamation marks for
eyes. Here the bowl is a filled silhouette with an overhanging lip and the
steam waves, so the eye gets a bowl rather than a grin.

    python scripts/make_launcher_icons.py

Three files come out:

    launcher_icon.png             full-bleed, opaque  -> legacy icon
    launcher_icon_foreground.png  transparent, safe zone -> adaptive foreground
    launcher_icon_monochrome.png  white on transparent -> themed icon (Android 13+)
"""

import math
import os

from PIL import Image, ImageDraw

SIZE = 1024
SUPERSAMPLE = 4
CANVAS = SIZE * SUPERSAMPLE

PRIMARY = (0x00, 0xC1, 0x6A)
PRIMARY_DARK = (0x00, 0xA8, 0x5A)
WHITE = (255, 255, 255, 255)

# Adaptive icons are masked, and the mask can crop everything outside the inner
# 66dp of a 108dp canvas. The foreground layer is scaled onto that whole 108dp
# canvas, so its art has to live inside 66/108 = 61% of the image; the legacy
# bitmap is not masked and can carry a wider mark.
LEGACY_SPAN = 0.72
ADAPTIVE_SPAN = 0.56


def _gradient():
    image = Image.new("RGBA", (CANVAS, CANVAS))
    draw = ImageDraw.Draw(image)
    for y in range(CANVAS):
        t = y / (CANVAS - 1)
        color = tuple(
            round(a + (b - a) * t) for a, b in zip(PRIMARY, PRIMARY_DARK)
        ) + (255,)
        draw.line([(0, y), (CANVAS, y)], fill=color)
    return image


def _disc(draw, x, y, radius, color):
    draw.ellipse((x - radius, y - radius, x + radius, y + radius), fill=color)


def _round_stroke(draw, points, thickness, color):
    """Stroke a densely sampled polyline with a disc at every vertex.

    PIL's `arc` and `line` end in square caps, and capping them by hand leaves a
    lollipop where the cap sits half outside the path. Walking the path with
    discs keeps the thickness uniform and the ends genuinely round; callers have
    to sample finely enough that consecutive discs overlap.
    """
    radius = thickness / 2
    for x, y in points:
        _disc(draw, x, y, radius, color)


def _bowl(draw, left, top, side, color):
    """A filled half-ellipse with a lip bar that overhangs it on both sides."""
    rim_y = top + side * 0.58
    cx = left + side * 0.5
    rx = side * 0.40
    ry = side * 0.36

    arc = [
        (cx - rx * math.cos(math.pi * t), rim_y + ry * math.sin(math.pi * t))
        for t in [i / 200 for i in range(201)]
    ]
    draw.polygon(arc, fill=color)
    lip_r = side * 0.085 / 2
    draw.rounded_rectangle(
        (left + side * 0.04, rim_y - lip_r, left + side * 0.96, rim_y + lip_r),
        radius=lip_r,
        fill=color,
    )


def _steam(draw, left, top, side, color):
    """Three waving columns rising from just above the lip."""
    thickness = side * 0.062
    amplitude = side * 0.052
    for x_ratio, height, phase in (
        (0.26, 0.26, 0.0),
        (0.50, 0.36, math.pi),
        (0.74, 0.26, 0.0),
    ):
        cx = left + side * x_ratio
        base = top + side * 0.44
        steps = 160
        _round_stroke(
            draw,
            [
                (
                    cx + amplitude * math.sin(2 * math.pi * (i / steps) + phase),
                    base - side * height * (i / steps),
                )
                for i in range(steps + 1)
            ],
            thickness,
            color,
        )


def _draw_mark(canvas, span, color):
    """Paint the bowl + steam centred on `canvas` within `span` * CANVAS."""
    side = CANVAS * span
    left = (CANVAS - side) / 2
    top = (CANVAS - side) / 2
    draw = ImageDraw.Draw(canvas)
    _steam(draw, left, top, side, color)
    _bowl(draw, left, top, side, color)


def _flatten(*layers):
    """Alpha-composite `layers` top-down and drop to the requested icon size."""
    composite = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
    for layer in layers:
        composite = Image.alpha_composite(composite, layer)
    return composite.resize((SIZE, SIZE), Image.LANCZOS)


def _blank():
    return Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))


def build(out_dir):
    os.makedirs(out_dir, exist_ok=True)

    legacy = _blank()
    _draw_mark(legacy, LEGACY_SPAN, WHITE)
    _flatten(_gradient(), legacy).convert("RGB").save(
        os.path.join(out_dir, "launcher_icon.png")
    )

    foreground = _blank()
    _draw_mark(foreground, ADAPTIVE_SPAN, WHITE)
    _flatten(foreground).save(os.path.join(out_dir, "launcher_icon_foreground.png"))

    # The themed-icon layer is the same art; Android recolors and masks it.
    _flatten(foreground).save(os.path.join(out_dir, "launcher_icon_monochrome.png"))

    return [
        "launcher_icon.png",
        "launcher_icon_foreground.png",
        "launcher_icon_monochrome.png",
    ]


if __name__ == "__main__":
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    target = os.path.join(project_root, "assets", "icon")
    for name in build(target):
        print(f"wrote assets/icon/{name}")
