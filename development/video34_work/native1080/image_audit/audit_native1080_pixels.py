from __future__ import annotations

import gc
import hashlib
import json
import math
import zlib
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont, __version__ as pillow_version

HERE = Path(__file__).resolve().parent
NATIVE_DIR = HERE.parent
ROOT = HERE.parents[3]
MEDIA_DIR = ROOT / "development/video33_work/media1080"
WIDTH, HEIGHT, PAD_HEIGHT = 1920, 1080, 1088
MCU_COLS, MCU_ROWS = 120, 68
MCU_COUNT = MCU_COLS * MCU_ROWS
Y_BYTES = MCU_COUNT * 256
C_BYTES = MCU_COUNT * 64
RAW_BYTES = Y_BYTES + 2 * C_BYTES
FRAME_WORDS = MCU_COUNT * 96

CASES = (
    {"name": "frame000_decode", "fixture": "frame000", "frame_index": 0},
    {"name": "frame108_max_service", "fixture": "frame108_max", "frame_index": 108},
)


def file_sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        while block := stream.read(1024 * 1024):
            h.update(block)
    return h.hexdigest()


def sample_byte(frame: int, plane: int, x: int, y: int) -> int:
    centered = ((x * 7 + y * 11 + frame * 37 + plane * 53) % 511) - 255
    return max(0, min(255, centered + 128))


def expected_encoded_rgb(frame: int) -> np.ndarray:
    out = np.empty((HEIGHT, WIDTH, 3), dtype=np.uint8)
    for y in range(HEIGHT):
        for x in range(WIDTH):
            yy = sample_byte(frame, 0, x, y)
            cb = sample_byte(frame, 1, x // 2, y // 2)
            cr = sample_byte(frame, 2, x // 2, y // 2)
            cbd, crd = cb - 128, cr - 128
            r = yy + ((crd * 5743) >> 12)
            g = yy - ((cbd * 1410) >> 12) - ((crd * 2925) >> 12)
            b = yy + ((cbd * 7258) >> 12)
            out[y, x] = (max(0, min(255, r)), max(0, min(255, g)), max(0, min(255, b)))
    return out


def untile(raw: np.memmap) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    y_plane = np.empty((HEIGHT, WIDTH), dtype=np.uint8)
    cb_plane = np.empty((HEIGHT // 2, WIDTH // 2), dtype=np.uint8)
    cr_plane = np.empty((HEIGHT // 2, WIDTH // 2), dtype=np.uint8)
    cb_base, cr_base = Y_BYTES, Y_BYTES + C_BYTES
    for mcu_y in range(MCU_ROWS):
        visible_y = min(16, HEIGHT - mcu_y * 16)
        visible_cy = min(8, HEIGHT // 2 - mcu_y * 8)
        for mcu_x in range(MCU_COLS):
            mcu = mcu_y * MCU_COLS + mcu_x
            y_tile_base = mcu * 256
            for block in range(4):
                block_y = block // 2
                block_x = block % 2
                tile = np.asarray(raw[y_tile_base + block * 64:y_tile_base + (block + 1) * 64])
                block8 = tile.reshape(8, 8)
                dest_y = mcu_y * 16 + block_y * 8
                dest_x = mcu_x * 16 + block_x * 8
                copy_rows = max(0, min(8, visible_y - block_y * 8))
                if copy_rows:
                    y_plane[dest_y:dest_y + copy_rows, dest_x:dest_x + 8] = block8[:copy_rows]
            c0 = mcu * 64
            cb_tile = np.asarray(raw[cb_base + c0:cb_base + c0 + 64]).reshape(8, 8)
            cr_tile = np.asarray(raw[cr_base + c0:cr_base + c0 + 64]).reshape(8, 8)
            dest_cy, dest_cx = mcu_y * 8, mcu_x * 8
            if visible_cy:
                cb_plane[dest_cy:dest_cy + visible_cy, dest_cx:dest_cx + 8] = cb_tile[:visible_cy]
                cr_plane[dest_cy:dest_cy + visible_cy, dest_cx:dest_cx + 8] = cr_tile[:visible_cy]
    return y_plane, cb_plane, cr_plane


def decode_c34_rgb(y_plane: np.ndarray, cb_plane: np.ndarray, cr_plane: np.ndarray) -> np.ndarray:
    rgb = np.empty((HEIGHT, WIDTH, 3), dtype=np.uint8)
    xs = np.arange(WIDTH, dtype=np.int32)[None, :]
    for y0 in range(0, HEIGHT, 2):
        y8 = y_plane[y0:y0 + 2].astype(np.int32)
        cb_row = cb_plane[y0 // 2:y0 // 2 + 1].repeat(2, axis=1).astype(np.int32) - 128
        cr_row = cr_plane[y0 // 2:y0 // 2 + 1].repeat(2, axis=1).astype(np.int32) - 128
        r = y8 + ((cr_row * 5743) >> 12)
        g = y8 - ((cb_row * 1410) >> 12) - ((cr_row * 2925) >> 12)
        b = y8 + ((cb_row * 7258) >> 12)
        rgb[y0:y0 + 2, :, 0] = np.clip(r, 0, 255).astype(np.uint8)
        rgb[y0:y0 + 2, :, 1] = np.clip(g, 0, 255).astype(np.uint8)
        rgb[y0:y0 + 2, :, 2] = np.clip(b, 0, 255).astype(np.uint8)
    return rgb


def psnr(rmse: float) -> float | None:
    return 999.0 if rmse == 0 else 20.0 * math.log10(255.0 / rmse)


def metric_accumulator(channels: int) -> dict:
    return {"sum_abs": np.zeros(channels, dtype=np.int64),
            "sum_sq": np.zeros(channels, dtype=np.int64),
            "max_abs": np.zeros(channels, dtype=np.int64),
            "max_xy": [None] * channels,
            "count": 0}


def add_error(acc: dict, diff: np.ndarray, x0: int, y0: int) -> None:
    d64 = diff.astype(np.int64)
    absd = np.abs(d64)
    acc["sum_abs"] += absd.sum(axis=(0, 1), dtype=np.int64)
    acc["sum_sq"] += (d64 * d64).sum(axis=(0, 1), dtype=np.int64)
    acc["count"] += diff.shape[0] * diff.shape[1]
    for channel in range(diff.shape[2]):
        current = int(absd[:, :, channel].max())
        if current > acc["max_abs"][channel]:
            pos = np.unravel_index(int(absd[:, :, channel].argmax()), absd[:, :, channel].shape)
            acc["max_abs"][channel] = current
            acc["max_xy"][channel] = [int(x0 + pos[1]), int(y0 + pos[0])]


def finalize_metrics(acc: dict, names: list[str]) -> dict:
    total = acc["count"]
    channels = {}
    for i, name in enumerate(names):
        mae = float(acc["sum_abs"][i]) / total
        rmse = math.sqrt(float(acc["sum_sq"][i]) / total)
        channels[name] = {"mae": mae, "rmse": rmse, "psnr_db": psnr(rmse),
                          "max_abs_error": int(acc["max_abs"][i]),
                          "max_error_xy": acc["max_xy"][i]}
    sum_sq = int(acc["sum_sq"].sum())
    sum_abs = int(acc["sum_abs"].sum())
    aggregate_count = total * len(names)
    mae = float(sum_abs) / aggregate_count
    rmse = math.sqrt(float(sum_sq) / aggregate_count)
    return {"aggregate": {"mae": mae, "rmse": rmse, "psnr_db": psnr(rmse),
                          "max_abs_error": int(acc["max_abs"].max())},
            "channels": channels, "pixels": total}


def image_previews(name: str, native_rgb: np.ndarray, ref_image: Image.Image) -> dict:
    native_path = HERE / f"{name}_c34_rgb.png"
    reference_path = HERE / f"{name}_pillow_rgb.png"
    compare_path = HERE / f"{name}_comparison.png"
    Image.fromarray(native_rgb, mode="RGB").save(native_path, optimize=True)
    ref_image.save(reference_path, optimize=True)
    native_thumb = Image.fromarray(native_rgb, mode="RGB").resize((640, 360), Image.Resampling.LANCZOS)
    ref_thumb = ref_image.resize((640, 360), Image.Resampling.LANCZOS)
    ref_arr = np.asarray(ref_image, dtype=np.int16)
    diff = np.abs(native_rgb.astype(np.int16) - ref_arr).astype(np.uint8)
    # Amplify absolute difference for visual inspection; metrics use unscaled deltas.
    diff = np.minimum(diff.astype(np.uint16) * 3, 255).astype(np.uint8)
    diff_thumb = Image.fromarray(diff, mode="RGB").resize((640, 360), Image.Resampling.LANCZOS)
    board = Image.new("RGB", (1920, 420), "#17191d")
    board.paste(native_thumb, (0, 40))
    board.paste(ref_thumb, (640, 40))
    board.paste(diff_thumb, (1280, 40))
    draw = ImageDraw.Draw(board)
    try:
        font = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", 26)
    except OSError:
        font = ImageFont.load_default()
    draw.text((16, 8), "C34 reconstructed RGB", fill="white", font=font)
    draw.text((656, 8), "Pillow JPEG RGB", fill="white", font=font)
    draw.text((1296, 8), "Absolute RGB difference x3", fill="white", font=font)
    board.save(compare_path, optimize=True)
    return {"c34_rgb": native_path.name, "pillow_rgb": reference_path.name,
            "comparison": compare_path.name}


def analyze(case: dict, source_index: dict, encoder_frames: dict) -> dict:
    name = case["name"]
    summary_path = NATIVE_DIR / f"{name}_summary.json"
    summary = json.loads(summary_path.read_text(encoding="utf-8"))
    jpeg_path = NATIVE_DIR / f"{case['fixture']}.jpg"
    raw_path = NATIVE_DIR / summary["yuv420_tiled_le32_raw"]
    expected_frame = encoder_frames[case["frame_index"]]
    jpeg_sha = file_sha256(jpeg_path)
    if jpeg_sha != summary["jpeg_sha256"] or jpeg_sha != expected_frame["jpeg_sha256"]:
        raise ValueError(f"{name}: JPEG fixture hash does not match the Q65 source frame")
    if raw_path.stat().st_size != RAW_BYTES or RAW_BYTES != summary["raw_bytes"]:
        raise ValueError(f"{name}: raw size mismatch {raw_path.stat().st_size}")
    raw = np.memmap(raw_path, dtype=np.uint8, mode="r", shape=(RAW_BYTES,))
    crc = zlib.crc32(memoryview(raw)) & 0xFFFFFFFF
    if f"{crc:08x}" != summary["raw_crc32"]:
        raise ValueError(f"{name}: raw CRC does not match VVP summary")

    y_plane, cb_plane, cr_plane = untile(raw)
    del raw
    native_rgb = decode_c34_rgb(y_plane, cb_plane, cr_plane)
    del cb_plane, cr_plane

    ref_image = Image.open(jpeg_path).convert("RGB")
    if ref_image.size != (WIDTH, HEIGHT):
        raise ValueError(f"{name}: Pillow decoded size is {ref_image.size}")
    ref_rgb = np.asarray(ref_image, dtype=np.uint8)
    if ref_rgb.shape != native_rgb.shape:
        raise ValueError(f"{name}: RGB reference shape mismatch")

    acc = metric_accumulator(3)
    y_acc = metric_accumulator(1)
    edge_abs_sum, edge_count = 0, 0
    interior_abs_sum, interior_count = 0, 0
    tile_row_sum = np.zeros(MCU_ROWS, dtype=np.int64)
    tile_row_count = np.zeros(MCU_ROWS, dtype=np.int64)
    tile_col_sum = np.zeros(MCU_COLS, dtype=np.int64)
    tile_col_count = np.zeros(MCU_COLS, dtype=np.int64)
    error_pixel_counts = {str(threshold): 0 for threshold in (5, 10, 20, 40, 60)}
    xcoords = np.arange(WIDTH, dtype=np.int32)
    x_edge = ((xcoords % 16 == 0) | (xcoords % 16 == 15))[None, :]

    for y0 in range(0, HEIGHT, 2):
        native_chunk = native_rgb[y0:y0 + 2]
        ref_chunk = ref_rgb[y0:y0 + 2].astype(np.int16)
        diff = native_chunk.astype(np.int16) - ref_chunk
        absd = np.abs(diff).astype(np.int64)
        add_error(acc, diff, 0, y0)
        pixel_max_error = absd.max(axis=2)
        for threshold in error_pixel_counts:
            error_pixel_counts[threshold] += int((pixel_max_error >= int(threshold)).sum())
        ref32 = ref_chunk.astype(np.int32)
        ref_luma = ((77 * ref32[:, :, 0] + 150 * ref32[:, :, 1] +
                     29 * ref32[:, :, 2] + 128) >> 8).astype(np.int16)
        # Compare decoded Y against the standard integer luma estimated from Pillow RGB.
        native_luma = y_plane[y0:y0 + 2].astype(np.int16)
        yd = (native_luma - ref_luma)[:, :, None]
        add_error(y_acc, yd, 0, y0)

        y_edge = ((np.arange(y0, y0 + 2) % 16 == 0) |
                  (np.arange(y0, y0 + 2) % 16 == 15))[:, None]
        tile_edge = x_edge | y_edge
        edge_abs_sum += int(absd[tile_edge].sum())
        edge_count += int(tile_edge.sum()) * 3
        interior_abs_sum += int(absd[~tile_edge].sum())
        interior_count += int((~tile_edge).sum()) * 3
        for row in range(2):
            tile_y = min((y0 + row) // 16, MCU_ROWS - 1)
            tile_row_sum[tile_y] += int(absd[row].sum())
            tile_row_count[tile_y] += absd[row].size
        for col in range(MCU_COLS):
            x1, x2 = col * 16, min((col + 1) * 16, WIDTH)
            tile_col_sum[col] += int(absd[:, x1:x2].sum())
            tile_col_count[col] += absd[:, x1:x2].size

    rgb_metrics = finalize_metrics(acc, ["R", "G", "B"])
    y_metrics = finalize_metrics(y_acc, ["Y_vs_Pillow_RGB_luma"])
    tile_rows = [float(tile_row_sum[i]) / int(tile_row_count[i]) for i in range(MCU_ROWS)]
    tile_cols = [float(tile_col_sum[i]) / int(tile_col_count[i]) for i in range(MCU_COLS)]
    means_native = native_rgb.astype(np.float64).mean(axis=(0, 1))
    means_ref = ref_rgb.astype(np.float64).mean(axis=(0, 1))
    previews = image_previews(name, native_rgb, ref_image)
    result = {
        "fixture": case["fixture"], "source_frame_index": case["frame_index"],
        "source_jpeg_sha256": jpeg_sha, "raw_yuv_file": raw_path.name,
        "raw_bytes": RAW_BYTES, "raw_crc32": f"{crc:08x}",
        "geometry": {"visible": [WIDTH, HEIGHT], "storage": [WIDTH, PAD_HEIGHT],
                     "mcu_columns": MCU_COLS, "mcu_rows": MCU_ROWS,
                     "plane_bytes": {"Y": Y_BYTES, "Cb": C_BYTES, "Cr": C_BYTES}},
        "reconstruction": {
            "layout": "MCU-tiled Y plane (four row-major 8x8 blocks TL/TR/BL/BR) then Cb and Cr planes (one row-major 8x8 block per MCU); little-endian bytes from VVP raw output",
            "visible_crop": "1080 luma rows and 540 chroma rows; remaining 8/4 padded rows excluded",
            "chroma_upsampling": "nearest-neighbor 2x2 reuse, matching scan-cache x>>1/y>>1 addressing",
            "rgb_coefficients": {"Cr_to_R": "5743/4096", "Cb_to_G": "1410/4096",
                                 "Cr_to_G": "2925/4096", "Cb_to_B": "7258/4096"},
            "rounding": "signed arithmetic floor shift by 12, as in yuv420_to_rgb888.v",
            "storage_clipping": "raw Y/Cb/Cr are already clipped to 8-bit after centered_sample+128 by the native block buffer; no second clipping is applied before RGB",
        },
        "reference": {"decoder": "Pillow/libjpeg", "pillow_version": pillow_version,
                      "operation": "JPEG decode then convert to RGB using Pillow defaults"},
        "metrics": {"rgb_vs_pillow_rgb": rgb_metrics,
                    "stored_y_vs_pillow_rgb_luma": y_metrics,
                    "mean_rgb_c34": [float(x) for x in means_native],
                    "mean_rgb_pillow": [float(x) for x in means_ref],
                    "mean_rgb_bias_c34_minus_pillow": [float(a-b) for a,b in zip(means_native,means_ref)],
                    "pixels_with_max_channel_error_at_least": error_pixel_counts,
                    "tile_error": {"mean_abs_rgb_error_by_16x16_mcu_row": tile_rows,
                                   "mean_abs_rgb_error_by_16x16_mcu_column": tile_cols,
                                   "mcu_boundary_mae": float(edge_abs_sum) / edge_count,
                                   "mcu_interior_mae": float(interior_abs_sum) / interior_count}},
        "previews": previews,
        "interpretation": "No tolerance threshold is applied. Differences include the native IDCT rounding, stored 8-bit clipping, nearest-neighbor chroma reuse, and Pillow/libjpeg's own JPEG IDCT/chroma reconstruction behavior.",
    }
    del ref_rgb, native_rgb, ref_image, y_plane
    gc.collect()
    return result


def main() -> None:
    native_summary = json.loads((NATIVE_DIR / "fixtures.json").read_text(encoding="utf-8"))
    media_index = json.loads((MEDIA_DIR / "media_index.json").read_text(encoding="utf-8"))
    q65_frames = {item["frame_index"]: item for item in
                  json.loads((MEDIA_DIR / "manifest.json").read_text(encoding="utf-8"))["quality_statistics"]["65"]["frames_manifest"]}
    results = []
    for case in CASES:
        fixture = native_summary["selected"][case["fixture"]]
        if fixture["frame_index"] != case["frame_index"]:
            raise ValueError(f"fixture frame index mismatch: {case}")
        result = analyze(case, media_index, q65_frames)
        results.append(result)
    final = {
        "status": "PIXEL_EXTERNAL_REFERENCE_AUDIT_COMPLETE",
        "scope": "offline pixel comparison only; no VVP run, JPEG encoding, RTL edit, or threshold gating",
        "reference_limit": "Pillow/libjpeg is an independent software reference; its IDCT rounding and 4:2:0 upsampling can differ from C34",
        "memory_plan": "memory-mapped raw input, visible-size Y/Cb/Cr arrays, two luma rows per RGB conversion iteration, one frame processed and released at a time",
        "frames": results,
    }
    resource_path = HERE / "resource_usage.json"
    if resource_path.is_file():
        final["resource_usage"] = json.loads(resource_path.read_text(encoding="utf-8"))
    (HERE / "native1080_pixel_audit.json").write_text(json.dumps(final, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"status": final["status"],
                      "frames": [{"fixture": r["fixture"], "rgb": r["metrics"]["rgb_vs_pillow_rgb"],
                                  "luma": r["metrics"]["stored_y_vs_pillow_rgb_luma"],
                                  "tile_error": r["metrics"]["tile_error"], "previews": r["previews"]}
                                 for r in results],
                      "output": str(HERE / "native1080_pixel_audit.json")}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
