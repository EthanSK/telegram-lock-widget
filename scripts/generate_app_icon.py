#!/usr/bin/env python3
"""Generate the 1024x1024 AppIcon PNG using only the Python standard library.

The icon is a vertical blue gradient with a single white paper-plane triangle.
We deliberately avoid using or referencing Telegram's official artwork.
"""
from __future__ import annotations

import struct
import zlib
from pathlib import Path

W = H = 1024
TOP_RGB = (38, 152, 219)
BOT_RGB = (24, 119, 184)
WHITE = (255, 255, 255)

# Triangle anchors, tuned to feel like a paper plane in flight
CENTER = (W / 2.0, H / 2.0)
SIZE = 380.0
TIP = (CENTER[0] + SIZE * 0.95, CENTER[1] - SIZE * 0.05)
TOP_LEFT = (CENTER[0] - SIZE * 0.70, CENTER[1] - SIZE * 0.60)
BOT_LEFT = (CENTER[0] - SIZE * 0.55, CENTER[1] + SIZE * 0.55)
TRIANGLE = (TIP, TOP_LEFT, BOT_LEFT)


def png_chunk(typ: bytes, data: bytes) -> bytes:
    return (
        struct.pack(">I", len(data))
        + typ
        + data
        + struct.pack(">I", zlib.crc32(typ + data) & 0xFFFFFFFF)
    )


def encode_png(width: int, height: int, rows: list[bytes]) -> bytes:
    sig = b"\x89PNG\r\n\x1a\n"
    ihdr = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)  # 8-bit RGBA
    raw = b"".join(b"\x00" + row for row in rows)  # filter byte 0 per scanline
    idat = zlib.compress(raw, 9)
    return sig + png_chunk(b"IHDR", ihdr) + png_chunk(b"IDAT", idat) + png_chunk(b"IEND", b"")


def triangle_scanlines(verts: tuple) -> dict[int, tuple[int, int]]:
    """For each y-row, return (xmin, xmax) inclusive of the triangle interior."""
    ys = [v[1] for v in verts]
    miny = max(0, int(min(ys)))
    maxy = min(H - 1, int(max(ys)))
    edges = []
    for i in range(3):
        a = verts[i]
        b = verts[(i + 1) % 3]
        if a[1] != b[1]:
            edges.append((a, b))
    rows: dict[int, tuple[int, int]] = {}
    for y in range(miny, maxy + 1):
        xs = []
        for a, b in edges:
            ay, by = a[1], b[1]
            if (ay <= y < by) or (by <= y < ay):
                t = (y - ay) / (by - ay)
                xs.append(a[0] + t * (b[0] - a[0]))
        if len(xs) >= 2:
            xs.sort()
            x0 = max(0, int(xs[0]))
            x1 = min(W - 1, int(xs[-1]))
            if x1 >= x0:
                rows[y] = (x0, x1)
    return rows


def main() -> None:
    tri_rows = triangle_scanlines(TRIANGLE)
    fg = bytes(WHITE) + b"\xff"
    rows: list[bytes] = []
    for y in range(H):
        t = y / (H - 1)
        r = int(TOP_RGB[0] * (1 - t) + BOT_RGB[0] * t)
        g = int(TOP_RGB[1] * (1 - t) + BOT_RGB[1] * t)
        b = int(TOP_RGB[2] * (1 - t) + BOT_RGB[2] * t)
        bg = bytes((r, g, b, 0xFF))
        if y in tri_rows:
            x0, x1 = tri_rows[y]
            row = bg * x0 + fg * (x1 - x0 + 1) + bg * (W - x1 - 1)
        else:
            row = bg * W
        rows.append(row)

    out_path = (
        Path(__file__).resolve().parent.parent
        / "TelegramLockWidget"
        / "Assets.xcassets"
        / "AppIcon.appiconset"
        / "AppIcon-1024.png"
    )
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_bytes(encode_png(W, H, rows))
    print(f"Wrote {out_path} ({out_path.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
