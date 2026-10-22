from __future__ import annotations

import argparse
import hashlib
import json
import math
import struct
import subprocess
from pathlib import Path

from PIL import Image


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
CORE = ROOT / "development/video19_work/vendor/core_jpeg/src_v"
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
RECORD = struct.Struct("<HHBBB")


def psnr(mse: float) -> float:
    return 999.0 if mse == 0 else 10.0 * math.log10(255.0 * 255.0 / mse)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as src:
        for block in iter(lambda: src.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def analyze(jpeg_paths: list[Path], pixels_path: Path) -> dict:
    blob = pixels_path.read_bytes()
    if len(blob) % RECORD.size:
        raise ValueError(f"pixel record file has {len(blob)} bytes, not divisible by {RECORD.size}")
    rec_count = len(blob) // RECORD.size
    images = [Image.open(p).convert("RGB") for p in jpeg_paths]
    if len({image.size for image in images}) != 1:
        raise ValueError(f"all inputs must have identical dimensions, got {[image.size for image in images]}")
    width, height = images[0].size
    if width % 16 or height % 16:
        raise ValueError(f"JPEG420 test dimensions must be multiples of 16, got {width}x{height}")
    frame_records = width * height
    if rec_count != frame_records * len(images):
        raise ValueError(f"expected {frame_records*len(images)} output records, got {rec_count}")
    frame_results = []
    total_sq = 0
    total_abs = 0
    total_values = 0
    total_exact_pixels = 0
    total_coords = 0
    total_max = 0
    block_offsets = [(0, 0), (8, 0), (0, 8), (8, 8)]
    for frame_index, image in enumerate(images):
        w, h = image.size
        reference = image.tobytes()
        decoded = bytearray(w * h * 3)
        seen = bytearray(w * h)
        sum_sq = [0, 0, 0]
        sum_abs = 0
        max_abs = 0
        channel_max = [0, 0, 0]
        exact_pixels = 0
        start = frame_index * frame_records * RECORD.size
        end = start + frame_records * RECORD.size
        frame_blob = blob[start:end]
        for x, y, r, g, b in RECORD.iter_unpack(frame_blob):
            if x >= w or y >= h:
                raise ValueError(f"frame {frame_index}: out-of-range coordinate ({x},{y})")
            address = y * w + x
            if seen[address]:
                raise ValueError(f"frame {frame_index}: duplicate coordinate ({x},{y})")
            seen[address] = 1
            decoded[address * 3:address * 3 + 3] = bytes((r, g, b))
        unique = sum(seen)
        if unique != frame_records:
            raise ValueError(f"frame {frame_index}: coordinate coverage {unique}/{frame_records}")
        first_block_starts = []
        block_start_mismatches = 0
        block_count = (w // 8) * (h // 8)
        mcu_columns = w // 16
        for block_index in range(block_count):
            x, y, _, _, _ = RECORD.unpack_from(frame_blob, block_index * 64 * RECORD.size)
            mcu_index, block_in_mcu = divmod(block_index, 4)
            offset_x, offset_y = block_offsets[block_in_mcu]
            expected_x = (mcu_index % mcu_columns) * 16 + offset_x
            expected_y = (mcu_index // mcu_columns) * 16 + offset_y
            if block_index < 8:
                first_block_starts.append([x, y])
            if (x, y) != (expected_x, expected_y):
                block_start_mismatches += 1
        for i, (got, want) in enumerate(zip(decoded, reference)):
            channel = i % 3
            delta = abs(got - want)
            sum_sq[channel] += delta * delta
            sum_abs += delta
            max_abs = max(max_abs, delta)
            channel_max[channel] = max(channel_max[channel], delta)
        for i in range(0, len(decoded), 3):
            if decoded[i:i+3] == reference[i:i+3]:
                exact_pixels += 1
        mse_by_channel = [v / frame_records for v in sum_sq]
        mse = sum(sum_sq) / (frame_records * 3)
        frame_results.append({
            "fixture": str(jpeg_paths[frame_index]), "records": frame_records,
            "unique_coordinates": unique, "coordinate_coverage": f"{unique}/{frame_records}",
            "rgb_mse": mse, "rgb_psnr_db": psnr(mse), "max_abs_error": max_abs,
            "mean_abs_error": sum_abs / (frame_records * 3),
            "per_channel_max_abs_error": channel_max,
            "per_channel_mse": mse_by_channel,
            "exact_pixel_fraction": exact_pixels / frame_records,
            "first_8_block_starts_xy": first_block_starts,
            "mcu_tl_tr_bl_br_order": block_start_mismatches == 0,
            "mcu_block_start_mismatches": block_start_mismatches,
        })
        total_sq += sum(sum_sq)
        total_abs += sum_abs
        total_values += frame_records * 3
        total_exact_pixels += exact_pixels
        total_coords += unique
        total_max = max(total_max, max_abs)
    total_mse = total_sq / total_values
    return {
        "fixtures": [str(p) for p in jpeg_paths], "dimensions": [width, height],
        "records": rec_count, "frames": len(images),
        "unique_coordinates_per_frame": total_coords,
        "coordinate_coverage_per_frame": f"{total_coords}/{frame_records*len(images)}",
        "rgb_mse": total_mse, "rgb_psnr_db": psnr(total_mse),
        "max_abs_error": total_max, "mean_abs_error": total_abs / total_values,
        "exact_pixel_fraction": total_exact_pixels / (frame_records * len(images)),
        "per_frame": frame_results,
        "reference": "Pillow JPEG decode RGB888, compared at output coordinate; Pillow default chroma upsampling is fancy.",
    }


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("jpeg", type=Path, nargs="+")
    ap.add_argument("--mode", type=int, choices=[0, 1, 2, 3], default=0,
                    help="0=no backpressure, 1=input gaps, 2=random output backpressure, 3=both")
    ap.add_argument("--gap", type=int, default=0)
    ap.add_argument("--seed", type=int, default=0x13579BDF)
    ap.add_argument("--name", default=None)
    ap.add_argument("--abort-bytes", type=int, default=0)
    ap.add_argument("--core-dir", type=Path, default=CORE,
                    help="directory containing the complete jpeg_core Verilog source set")
    ap.add_argument("--width", type=int, default=640)
    ap.add_argument("--height", type=int, default=480)
    args = ap.parse_args()
    jpeg_paths = [p.resolve() for p in args.jpeg]
    core_dir = args.core_dir.resolve()
    sources = sorted(core_dir.glob("*.v"))
    if not sources:
        raise SystemExit(f"no Verilog sources found in {core_dir}")
    run_name = args.name or (jpeg_paths[0].stem + ("_" + jpeg_paths[1].stem if len(jpeg_paths) > 1 else ""))
    out_dir = HERE / "runs" / run_name
    out_dir.mkdir(parents=True, exist_ok=True)
    input_path = jpeg_paths[0]
    pause_after = 0
    if len(jpeg_paths) > 1:
        input_path = out_dir / "input_concatenated.mjpg"
        input_path.write_bytes(b"".join(p.read_bytes() for p in jpeg_paths))
        pause_after = input_path.stat().st_size - jpeg_paths[-1].stat().st_size
    exe = out_dir / "simv"
    pixels = out_dir / "pixels_xy_rgb.bin"
    log = out_dir / "sim.log"
    compile_cmd = [str(IVERILOG), "-g2012", "-s", "tb_jpeg_core", "-o", str(exe),
                   str(HERE / "tb_jpeg_core.sv"), *(str(p) for p in sources)]
    manifest = {
        "core_dir": str(core_dir),
        "core_sources": [{"path": str(p), "sha256": sha256(p)} for p in sources],
        "testbench": {"path": str(HERE / "tb_jpeg_core.sv"), "sha256": sha256(HERE / "tb_jpeg_core.sv")},
        "fixtures": [{"path": str(p), "bytes": p.stat().st_size, "sha256": sha256(p)} for p in jpeg_paths],
        "mode": args.mode, "gap": args.gap, "seed": args.seed,
        "abort_bytes": args.abort_bytes, "iverilog": str(IVERILOG), "vvp": str(VVP),
    }
    (out_dir / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    comp = subprocess.run(compile_cmd, text=True, capture_output=True)
    (out_dir / "compile.log").write_text(comp.stdout + comp.stderr, encoding="utf-8")
    if comp.returncode:
        raise SystemExit(f"Icarus compile failed ({comp.returncode}); see {out_dir / 'compile.log'}")
    sim_cmd = [str(VVP), str(exe), f"+JPEG={input_path}", f"+OUT={pixels}", f"+LOG={log}",
               f"+MODE={args.mode}", f"+GAP={args.gap}", f"+SEED={args.seed}",
               f"+FRAMES={len(jpeg_paths)}", f"+ABORT_BYTES={args.abort_bytes}",
               f"+PAUSE_AFTER_BYTES={pause_after}", f"+WIDTH={args.width}", f"+HEIGHT={args.height}"]
    sim = subprocess.Popen(sim_cmd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    try:
        sim_output, _ = sim.communicate(timeout=240)
    except subprocess.TimeoutExpired:
        sim.kill()
        sim_output, _ = sim.communicate()
        (out_dir / "console.log").write_text(sim_output + "\nTIMEOUT: vvp terminated at 240 seconds.\n", encoding="utf-8")
        raise SystemExit(f"simulation timeout after 240 seconds; see {out_dir / 'console.log'}")
    (out_dir / "console.log").write_text(sim_output, encoding="utf-8")
    print(sim_output, end="")
    if sim.returncode:
        raise SystemExit(f"simulation failed ({sim.returncode}); see {out_dir / 'console.log'}")
    result = analyze(jpeg_paths, pixels)
    (out_dir / "analysis.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
