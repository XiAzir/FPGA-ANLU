from __future__ import annotations

import hashlib
import json
import math
import shutil
import subprocess
import struct
from pathlib import Path

from pack_video_mjp import DEFAULT_AUDIO, DEFAULT_VIDEO, pack, split_mjpeg


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
CORE_DIR = ROOT / "development/video19_work/vendor/core_jpeg/src_v"
BASELINE_FRAME0 = ROOT / "development/video19_work/jpeg_unit/runs/frame_000_nobp/pixels_xy_rgb.bin"
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
PIXEL_RECORD = struct.Struct("<HHBBB")
FRAME_PIXELS = 640 * 480


def write_hex(path: Path, data: bytes) -> None:
    path.write_text("\n".join(f"{byte:02x}" for byte in data) + "\n", encoding="ascii")


def frame1_software_metrics(frame_records: bytes, jpeg: bytes, run_dir: Path) -> dict:
    ffmpeg = shutil.which("ffmpeg")
    if not ffmpeg:
        return {"software_rgb_metrics": "unavailable: ffmpeg not found"}
    jpeg_path = run_dir / "frame1.jpg"
    reference_path = run_dir / "frame1_software_rgb.bin"
    jpeg_path.write_bytes(jpeg)
    decoded = subprocess.run([
        ffmpeg, "-hide_banner", "-loglevel", "error", "-y", "-i", str(jpeg_path),
        "-f", "rawvideo", "-pix_fmt", "rgb24", str(reference_path),
    ], text=True, capture_output=True)
    if decoded.returncode:
        raise RuntimeError(f"software JPEG decode failed: {decoded.stderr}")
    expected = reference_path.read_bytes()
    if len(expected) != FRAME_PIXELS * 3:
        raise RuntimeError(f"software RGB reference has {len(expected)} bytes")
    actual = bytearray(FRAME_PIXELS * 3)
    seen = bytearray(FRAME_PIXELS)
    count = 0
    for x, y, r, g, b in PIXEL_RECORD.iter_unpack(frame_records):
        if x >= 640 or y >= 480:
            raise RuntimeError(f"frame1 coordinate out of bounds: ({x},{y})")
        pixel = y * 640 + x
        if seen[pixel]:
            raise RuntimeError(f"frame1 duplicate coordinate: ({x},{y})")
        seen[pixel] = 1
        actual[pixel * 3:pixel * 3 + 3] = bytes((r, g, b))
        count += 1
    if count != FRAME_PIXELS or any(value == 0 for value in seen):
        raise RuntimeError(f"frame1 coordinate coverage {count}/{FRAME_PIXELS}")
    squared_error = sum((a - b) * (a - b) for a, b in zip(actual, expected))
    mse = squared_error / (FRAME_PIXELS * 3)
    psnr = 999.0 if mse == 0 else 10.0 * math.log10(255.0 * 255.0 / mse)
    return {"software_rgb_mse": mse, "software_rgb_psnr_db": psnr,
            "software_decoder": "FFmpeg", "coordinate_coverage": count}


def main() -> None:
    run_dir = HERE / "runs/reader_jpeg_core_diag_20261021"
    output_dir = HERE / "output"
    run_dir.mkdir(parents=True, exist_ok=True)
    output_dir.mkdir(parents=True, exist_ok=True)
    video_path = output_dir / "VIDEO.MJP"
    index_path = output_dir / "index.json"
    audio_path = output_dir / "TEST.WAV"
    index = pack(DEFAULT_VIDEO, DEFAULT_AUDIO, video_path, index_path, audio_path)
    jpeg_frames = split_mjpeg(DEFAULT_VIDEO.read_bytes())
    frame_entries = index["frames"][:2]
    sector_count = frame_entries[-1]["record_next_sector"]
    card_prefix = video_path.read_bytes()[:sector_count * 512]
    if len(card_prefix) != sector_count * 512:
        raise RuntimeError("MJP prefix is not sector aligned")
    card_hex = run_dir / "mjp_sector_prefix.hex"
    output_pixels = run_dir / "pixels_xy_rgb.bin"
    summary_file = run_dir / "frame_summary.txt"
    write_hex(card_hex, card_prefix)

    expected_requests = 1 + 1 + frame_entries[0]["jpeg_sector_count"] + 1 + frame_entries[1]["jpeg_sector_count"]
    executable = run_dir / "simv.exe"
    sources = sorted(CORE_DIR.glob("*.v"))
    compile_cmd = [
        str(IVERILOG), "-g2012", "-s", "tb_mjp_jpeg_core", "-o", str(executable),
        str(HERE / "tb_mjp_jpeg_core.sv"), str(HERE / "mjp_file_reader.v"),
        *(str(source) for source in sources),
    ]
    compiled = subprocess.run(compile_cmd, text=True, capture_output=True)
    (run_dir / "compile.log").write_text(compiled.stdout + compiled.stderr, encoding="utf-8")
    if compiled.returncode:
        raise SystemExit(f"Icarus compile failed ({compiled.returncode}); see {run_dir / 'compile.log'}")

    sim_cmd = [
        str(VVP), str(executable),
        f"+CARD_HEX={card_hex}", f"+CARD_BYTES={len(card_prefix)}",
        f"+CARD_PERIOD=36", f"+SECTOR_REQUESTS={expected_requests}",
        f"+OUT={output_pixels}", f"+SUMMARY={summary_file}",
    ]
    log_path = run_dir / "sim.log"
    with log_path.open("w", encoding="utf-8") as log:
        process = subprocess.Popen(sim_cmd, stdout=log, stderr=subprocess.STDOUT, text=True)
        try:
            return_code = process.wait(timeout=120)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()
            raise SystemExit(f"integrated simulation exceeded 120 seconds; inspect {log_path}")
    sim_output = log_path.read_text(encoding="utf-8")
    print(sim_output, end="")
    if return_code or "PASS frames=2" not in sim_output:
        raise SystemExit(f"integrated simulation failed ({return_code}); see {log_path}")

    actual = output_pixels.read_bytes()
    frame_record_bytes = FRAME_PIXELS * PIXEL_RECORD.size
    if len(actual) != frame_record_bytes * 2:
        raise RuntimeError(f"pixel stream has {len(actual)} bytes, expected {frame_record_bytes*2}")
    baseline = BASELINE_FRAME0.read_bytes()
    frame0 = actual[:frame_record_bytes]
    if frame0 != baseline:
        mismatch = next((i for i, (a, b) in enumerate(zip(frame0, baseline)) if a != b), -1)
        raise RuntimeError(f"frame0 differs from jpeg_unit baseline at byte {mismatch}")

    metrics = frame1_software_metrics(actual[frame_record_bytes:], jpeg_frames[1], run_dir)
    frame_summaries = summary_file.read_text(encoding="utf-8").splitlines()
    result = {
        "status": "PASS",
        "frames": 2,
        "card_period_sysclk": 36,
        "card_period_ns": 720,
        "sector_requests": expected_requests,
        "sector_bytes": len(card_prefix),
        "frame0_reference": str(BASELINE_FRAME0),
        "frame0_bit_exact": True,
        "frame1": metrics,
        "frame_summaries": frame_summaries,
        "mjp_sha256": index["video_sha256"],
        "audio_sha256": index["audio"]["sha256"],
        "pixel_output_sha256": hashlib.sha256(actual).hexdigest(),
        "compile_log": str(run_dir / "compile.log"),
        "sim_log": str(run_dir / "sim.log"),
    }
    (run_dir / "result.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
