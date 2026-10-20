#!/usr/bin/env python3
"""Create copyright-free raw BMP scaler fixtures and independent host gold streams."""
from __future__ import annotations

import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parent
MEDIA = ROOT / "test_media"
OW, OH = 640, 480

# 5x7 glyphs are intentionally tiny and deterministic; labels are rendered into
# the original source pixels, never into a scaled copy.
FONT = {
    "0": ("01110", "10001", "10011", "10101", "11001", "10001", "01110"),
    "1": ("00100", "01100", "00100", "00100", "00100", "00100", "01110"),
    "2": ("01110", "10001", "00001", "00010", "00100", "01000", "11111"),
    "3": ("11110", "00001", "00001", "01110", "00001", "00001", "11110"),
    "4": ("00010", "00110", "01010", "10010", "11111", "00010", "00010"),
    "5": ("11111", "10000", "10000", "11110", "00001", "00001", "11110"),
    "6": ("01110", "10000", "10000", "11110", "10001", "10001", "01110"),
    "7": ("11111", "00001", "00010", "00100", "01000", "01000", "01000"),
    "8": ("01110", "10001", "10001", "01110", "10001", "10001", "01110"),
    "9": ("01110", "10001", "10001", "01111", "00001", "00001", "01110"),
    "A": ("01110", "10001", "10001", "11111", "10001", "10001", "10001"),
    "B": ("11110", "10001", "10001", "11110", "10001", "10001", "11110"),
    "C": ("01111", "10000", "10000", "10000", "10000", "10000", "01111"),
    "D": ("11110", "10001", "10001", "10001", "10001", "10001", "11110"),
    "E": ("11111", "10000", "10000", "11110", "10000", "10000", "11111"),
    "F": ("11111", "10000", "10000", "11110", "10000", "10000", "10000"),
    "G": ("01111", "10000", "10000", "10111", "10001", "10001", "01111"),
    "H": ("10001", "10001", "10001", "11111", "10001", "10001", "10001"),
    "I": ("01110", "00100", "00100", "00100", "00100", "00100", "01110"),
    "J": ("00111", "00010", "00010", "00010", "10010", "10010", "01100"),
    "K": ("10001", "10010", "10100", "11000", "10100", "10010", "10001"),
    "L": ("10000", "10000", "10000", "10000", "10000", "10000", "11111"),
    "M": ("10001", "11011", "10101", "10101", "10001", "10001", "10001"),
    "N": ("10001", "11001", "10101", "10011", "10001", "10001", "10001"),
    "O": ("01110", "10001", "10001", "10001", "10001", "10001", "01110"),
    "P": ("11110", "10001", "10001", "11110", "10000", "10000", "10000"),
    "R": ("11110", "10001", "10001", "11110", "10100", "10010", "10001"),
    "S": ("01111", "10000", "10000", "01110", "00001", "00001", "11110"),
    "T": ("11111", "00100", "00100", "00100", "00100", "00100", "00100"),
    "U": ("10001", "10001", "10001", "10001", "10001", "10001", "01110"),
    "X": ("10001", "10001", "01010", "00100", "01010", "10001", "10001"),
}

ASSETS = [
    {"name": "bmp_320x240_bottomup.bmp", "w": 320, "h": 240, "top_down": False, "label": "TEST 320X240 A", "seed": 1, "desc": "320x240 bottom-up 放大到640x480"},
    {"name": "bmp_800x600_bottomup.bmp", "w": 800, "h": 600, "top_down": False, "label": "TEST 800X600 B", "seed": 2, "desc": "800x600 bottom-up 非整数缩小"},
    {"name": "bmp_191x321_topdown.bmp", "w": 191, "h": 321, "top_down": True, "label": "TEST 191X321 C", "seed": 3, "desc": "191x321 top-down 奇数宽且每行padding3字节"},
    {"name": "bmp_512x128_bottomup.bmp", "w": 512, "h": 128, "top_down": False, "label": "TEST 512X128 D", "seed": 4, "desc": "512x128 bottom-up 居中黑边"},
    {"name": "scaler_native_640x480.bmp", "w": 640, "h": 480, "top_down": False, "label": "NATIVE 640X480 E", "seed": 5, "desc": "独立原生分辨率回归素材，仅用于native独立TB"},
    {"name": "scaler_odd_vertical_800x599.bmp", "w": 800, "h": 599, "top_down": False, "label": "ODD VERTICAL F", "seed": 6, "desc": "独立奇数垂直留边回归素材：dh479，上黑边0行、下黑边1行"},
]


def rgb_at(x: int, y: int, w: int, h: int, seed: int) -> tuple[int, int, int]:
    """Pattern has large color cells, a diagonal, axes, border and corner markers."""
    palette = ((232, 36, 40), (32, 190, 70), (36, 84, 230), (245, 205, 32),
               (195, 48, 190), (26, 205, 210), (240, 116, 28), (228, 228, 228))
    cell_x, cell_y = max(1, w // 8), max(1, h // 6)
    base = palette[((x // cell_x) + 3 * (y // cell_y) + seed) % len(palette)]
    if abs((x * max(1, h - 1)) - (y * max(1, w - 1))) < max(w, h) * 2:
        base = (18, 18, 24)
    if x == w // 2 or y == h // 2:
        base = (255, 255, 255)
    if x < 5 or y < 5 or x >= w - 5 or y >= h - 5:
        base = (12, 12, 12)
    # Four differently colored corner patches make orientation obvious.
    corner = max(8, min(w, h) // 12)
    if x < corner and y < corner:
        base = (255, 48, 48)
    elif x >= w - corner and y < corner:
        base = (48, 255, 48)
    elif x < corner and y >= h - corner:
        base = (48, 80, 255)
    elif x >= w - corner and y >= h - corner:
        base = (255, 220, 32)
    return base


def glyph_pixel(label: str, x: int, y: int) -> bool:
    start_x, start_y = 8, 10
    for index, char in enumerate(label):
        glyph = FONT.get(char)
        if not glyph:
            continue
        gx = x - (start_x + index * 6)
        gy = y - start_y
        if 0 <= gx < 5 and 0 <= gy < 7 and glyph[gy][gx] == "1":
            return True
    return False


def make_source(a: dict) -> bytes:
    w, h = a["w"], a["h"]
    stride = (w * 3 + 3) & ~3
    pixels = bytearray()
    # BMP storage order: bottom-up rows for positive height, top-down for negative.
    for physical_y in range(h):
        logical_y = physical_y if a["top_down"] else h - 1 - physical_y
        row = bytearray()
        for x in range(w):
            r, g, b = rgb_at(x, logical_y, w, h, a["seed"])
            if glyph_pixel(a["label"], x, logical_y):
                r, g, b = (255, 255, 255)
            row.extend((b, g, r))
        row.extend(bytes(stride - len(row)))
        pixels.extend(row)
    offset = 54
    file_size = offset + len(pixels)
    height_field = -h if a["top_down"] else h
    header = b"BM" + struct.pack("<IHHI", file_size, 0, 0, offset)
    dib = struct.pack("<IiiHHIIiiII", 40, w, height_field, 1, 24, 0,
                      len(pixels), 2835, 2835, 0, 0)
    return header + dib + pixels


def read_bmp(path: Path) -> dict:
    raw = path.read_bytes()
    if len(raw) < 54 or raw[:2] != b"BM":
        raise ValueError(f"bad BMP header: {path}")
    file_size, offset = struct.unpack_from("<IxxxxI", raw, 2)
    dib, w, signed_h, planes, bpp, compression, image_size = struct.unpack_from("<IiiHHII", raw, 14)
    h = abs(signed_h)
    stride = (w * 3 + 3) & ~3
    if dib < 40 or planes != 1 or bpp != 24 or compression != 0 or not w or not h:
        raise ValueError(f"unsupported BMP: {path}")
    if offset + stride * h > len(raw) or file_size > len(raw):
        raise ValueError(f"truncated BMP: {path}")
    return {"raw": raw, "w": w, "h": h, "top_down": signed_h < 0,
            "stride": stride, "offset": offset, "size": len(raw), "declared": file_size,
            "image_size": image_size}


def source_pixel(bmp: dict, x: int, y_top: int) -> tuple[int, int, int]:
    physical_y = y_top if bmp["top_down"] else bmp["h"] - 1 - y_top
    at = bmp["offset"] + physical_y * bmp["stride"] + x * 3
    b, g, r = bmp["raw"][at:at + 3]
    return r, g, b


def expected_bottomup(bmp: dict) -> tuple[bytes, dict]:
    w, h = bmp["w"], bmp["h"]
    # Independent positive-coordinate floor geometry from scaler_spec.md.
    if w * OH >= h * OW:
        dw, dh = OW, max(1, h * OW // w)
    else:
        dh, dw = OH, max(1, w * OH // h)
    offx, offy = (OW - dw) // 2, (OH - dh) // 2
    out = bytearray()
    for j in range(OH):
        y_display = OH - 1 - j  # expected stream is bottom-up target raster
        if y_display < offy or y_display >= offy + dh:
            out.extend(bytes(OW * 3))
            continue
        y_local_bottom = j - (OH - (offy + dh))
        src_y_bottom = ((y_local_bottom + 1) * h - 1) // dh
        src_y_top = h - 1 - src_y_bottom
        for x_display in range(OW):
            if x_display < offx or x_display >= offx + dw:
                out.extend((0, 0, 0))
                continue
            src_x = (x_display - offx) * w // dw
            out.extend(source_pixel(bmp, src_x, src_y_top))
    return bytes(out), {"dw": dw, "dh": dh, "offx": offx, "offy": offy}


def save_ppm(path: Path, rgb: bytes) -> None:
    row_bytes = OW * 3
    top_down = b"".join(rgb[row:row + row_bytes] for row in range((OH - 1) * row_bytes, -1, -row_bytes))
    path.write_bytes(f"P6\n{OW} {OH}\n255\n".encode("ascii") + top_down)


def main() -> None:
    MEDIA.mkdir(parents=True, exist_ok=True)
    manifest = {"purpose": "host-only independently generated gold; do not copy preview/gold to TF",
                "output": [OW, OH], "assets": []}
    for a in ASSETS:
        path = MEDIA / a["name"]
        path.write_bytes(make_source(a))
        bmp = read_bmp(path)
        gold, geom = expected_bottomup(bmp)
        stem = path.stem
        source_mem = MEDIA / f"{stem}_source_bytes.mem"
        with source_mem.open("w", encoding="ascii", newline="\n") as f:
            for value in bmp["raw"]:
                f.write(f"{value:02X}\n")
        mem = MEDIA / f"{stem}_expected_bottomup_rgb24.mem"
        with mem.open("w", encoding="ascii", newline="\n") as f:
            for at in range(0, len(gold), 3):
                r, g, b = gold[at:at + 3]
                f.write(f"{r:02X}{g:02X}{b:02X}\n")
        preview = MEDIA / f"{stem}_preview_gold.ppm"
        save_ppm(preview, gold)
        entry = {"bmp": path.name, "source_width": bmp["w"], "source_height": bmp["h"],
                 "height_sign": "negative/top-down" if bmp["top_down"] else "positive/bottom-up",
                 "stride": bmp["stride"], "file_size": bmp["size"], "pixel_offset": bmp["offset"],
                 "row_padding_bytes": bmp["stride"] - bmp["w"] * 3, "geometry": geom,
                 "source_bytes_mem": source_mem.name, "expected_mem": mem.name, "preview_ppm": preview.name,
                 "role": a["desc"], "sha256": __import__("hashlib").sha256(path.read_bytes()).hexdigest()}
        manifest["assets"].append(entry)
    try:
        from PIL import Image
        for entry in manifest["assets"]:
            ppm = MEDIA / entry["preview_ppm"]
            png = ppm.with_suffix(".png")
            Image.open(ppm).save(png)
            entry["preview_png"] = png.name
    except ImportError:
        pass
    # Error fixtures for the real loader integration TB. The truncated file
    # retains its original catalog/header size to emulate a mid-read transport
    # failure after the 54-byte header was already accepted.
    base = bytearray((MEDIA / ASSETS[0]["name"]).read_bytes())
    zero_dim = bytearray(base)
    struct.pack_into("<i", zero_dim, 18, 0)
    (MEDIA / "bad_zero_width.bmp").write_bytes(zero_dim)
    oversize = bytearray(base)
    struct.pack_into("<i", oversize, 18, 1025)
    (MEDIA / "bad_unsupported_width.bmp").write_bytes(oversize)
    trunc_len = 54 + 17000
    (MEDIA / "bad_truncated_payload.bmp").write_bytes(base[:trunc_len])
    for raw, name in ((zero_dim, "bad_zero_width"), (oversize, "bad_unsupported_width"),
                      (base[:trunc_len], "bad_truncated_payload")):
        with (MEDIA / f"{name}_source_bytes.mem").open("w", encoding="ascii", newline="\n") as f:
            for value in raw:
                f.write(f"{value:02X}\n")
    manifest["error_fixtures"] = [
        {"file": "bad_zero_width.bmp", "case": "invalid zero dimension in BMP header"},
        {"file": "bad_unsupported_width.bmp", "case": "width exceeds supported maximum 1024"},
        {"file": "short_sector", "case": "sector transport ends after 511 bytes"},
        {"file": "bad_truncated_payload.bmp", "case": "transport error after valid header during payload"},
    ]
    (MEDIA / "media_manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"SCALER_MEDIA PASS sources={len(ASSETS)} production=4 output={OW}x{OH}")


if __name__ == "__main__":
    main()
