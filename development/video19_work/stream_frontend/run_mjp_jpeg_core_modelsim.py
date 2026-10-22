from __future__ import annotations

import hashlib
import json
import re
import shutil
import struct
import subprocess
from datetime import datetime
from pathlib import Path

from pack_video_mjp import DEFAULT_AUDIO, DEFAULT_VIDEO, pack, split_mjpeg
from run_mjp_jpeg_core_test import frame1_software_metrics


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
CORE_DIR = ROOT / "development/video19_work/vendor/core_jpeg/src_v"
BASELINE_FRAME0 = ROOT / "development/video19_work/jpeg_unit/runs/frame_000_nobp/pixels_xy_rgb.bin"
MODELSIM_BIN = Path("E:/ModelsimSE/win64")
PIXEL_RECORD = struct.Struct("<HHBBB")
FRAME_PIXELS = 640 * 480


def run_command(command: list[str], cwd: Path, log_path: Path, timeout: int) -> dict:
    with log_path.open("w", encoding="utf-8") as log:
        process = subprocess.Popen(command, cwd=cwd, stdout=log, stderr=subprocess.STDOUT)
        try:
            code = process.wait(timeout=timeout)
            timed_out = False
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()
            code = 124
            timed_out = True
    return {"command": command, "exit_code": code, "timed_out": timed_out, "log": str(log_path)}


def main() -> None:
    run_name = "reader_jpeg_core_modelsim_" + datetime.now().strftime("%Y%m%d_%H%M%S")
    run_dir = HERE / "runs" / run_name
    run_dir.mkdir(parents=True)
    media_dir = HERE / "output"
    video_path = media_dir / "VIDEO.MJP"
    index_path = media_dir / "index.json"
    audio_path = media_dir / "TEST.WAV"
    index = pack(DEFAULT_VIDEO, DEFAULT_AUDIO, video_path, index_path, audio_path)
    jpeg_frames = split_mjpeg(DEFAULT_VIDEO.read_bytes())
    frame_entries = index["frames"][:2]
    sector_count = frame_entries[-1]["record_next_sector"]
    card_prefix = video_path.read_bytes()[:sector_count * 512]
    if len(card_prefix) != sector_count * 512:
        raise RuntimeError("MJP prefix is not sector aligned")
    card_hex = run_dir / "mjp_sector_prefix.hex"
    card_hex.write_text("\n".join(f"{byte:02x}" for byte in card_prefix) + "\n", encoding="ascii")
    pixels = run_dir / "pixels_xy_rgb.bin"
    summary = run_dir / "frame_summary.txt"
    exe = run_dir / "simv.exe"
    local_sources = []
    input_compat = {}
    for source in sorted(CORE_DIR.glob("*.v")):
        local = run_dir / "core" / source.name
        local.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, local)
        if source.name == "jpeg_input.v":
            original = local.read_text(encoding="utf-8-sig")
            patched, count = re.subn(
                r"(wire\s+token_\w+_w\s*=\s*)(.*?)(;)",
                r"\1inport_valid_i && \2\3", original,
            )
            if count != 12:
                raise RuntimeError(f"expected 12 JPEG marker tokens in jpeg_input.v, found {count}")
            local.write_text(patched, encoding="utf-8")
            input_compat = {
                "source": str(source),
                "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                "run_local_sha256": hashlib.sha256(local.read_bytes()).hexdigest(),
                "changes": count,
                "change": "Qualify every token_soi/sof0/dqt/dht/eoi/sos/pad/sof2/dri/rst/app/com with inport_valid_i",
            }
        if source.name == "jpeg_dht.v":
            text = local.read_text(encoding="utf-8-sig")
            declarations = []
            for name in ("idx_q", "total_entries_q"):
                pattern = r"^\s*reg\s+\[11:0\]\s+" + name + r"\s*;[^\n]*\n"
                match = re.search(pattern, text, re.M)
                if not match:
                    raise RuntimeError(f"jpeg_dht compatibility declaration not found: {name}")
                declarations.append(match.group().strip())
                text = text[:match.start()] + text[match.end():]
            anchor = text.index("    // DHT tables can be combined")
            text = text[:anchor] + "\n".join(declarations) + "\n" + text[anchor:]
            local.write_text(text, encoding="utf-8")
        local_sources.append(local)
    reader_copy = run_dir / "mjp_file_reader.v"
    tb_copy = run_dir / "tb_mjp_jpeg_core.sv"
    shutil.copy2(HERE / "mjp_file_reader.v", reader_copy)
    shutil.copy2(HERE / "tb_mjp_jpeg_core.sv", tb_copy)
    source_list = local_sources + [reader_copy, tb_copy]
    (run_dir / "sources.f").write_text("\n".join('"' + p.as_posix() + '"' for p in source_list) + "\n")
    (run_dir / "modelsim.ini").write_text(
        "[Library]\nwork = work\nothers = E:/ModelsimSE/modelsim.ini\n", encoding="ascii"
    )
    (run_dir / "run.do").write_text(
        "onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n",
        encoding="ascii",
    )

    vlib = run_command([str(MODELSIM_BIN / "vlib.exe"), "work"], run_dir,
                       run_dir / "vlib.log", 30)
    if vlib["exit_code"]:
        raise SystemExit(f"ModelSim vlib failed; see {vlib['log']}")
    compile_result = run_command(
        [str(MODELSIM_BIN / "vlog.exe"), "-modelsimini", "modelsim.ini", "-work", "work",
         "-sv", "-f", "sources.f"],
        run_dir, run_dir / "compile.log", 120,
    )
    if compile_result["exit_code"]:
        raise SystemExit(f"ModelSim compile failed; see {compile_result['log']}")

    expected_requests = 1 + 1 + sum(
        entry["jpeg_sector_count"] for entry in frame_entries
    ) + 1
    command = [
        str(MODELSIM_BIN / "vsim.exe"), "-modelsimini", "modelsim.ini", "-c", "-lic_noqueue",
        "-novopt", "work.tb_mjp_jpeg_core",
        f"+CARD_HEX={card_hex.name}", f"+CARD_BYTES={len(card_prefix)}",
        "+CARD_PERIOD=36", f"+SECTOR_REQUESTS={expected_requests}",
        f"+FRAME0_BYTES={frame_entries[0]['jpeg_length_bytes']}",
        f"+FRAME1_BYTES={frame_entries[1]['jpeg_length_bytes']}",
        f"+FRAME0_CRC={frame_entries[0]['jpeg_crc32']}",
        f"+FRAME1_CRC={frame_entries[1]['jpeg_crc32']}",
        f"+OUT={pixels.name}", f"+SUMMARY={summary.name}",
        "-do", "run.do", "-l", "run.log",
    ]
    simulation = run_command(command, run_dir, run_dir / "console.log", 2400)
    console = (run_dir / "console.log").read_text(encoding="utf-8", errors="replace")
    passed = simulation["exit_code"] == 0 and "PASS frames=2" in console
    if not passed:
        (run_dir / "result.json").write_text(json.dumps({
            "status": "FAILED", "compile": compile_result, "simulation": simulation,
            "console_tail": console[-5000:],
        }, indent=2) + "\n", encoding="utf-8")
        raise SystemExit(f"ModelSim joint simulation failed; see {run_dir}")

    actual = pixels.read_bytes()
    frame_record_bytes = FRAME_PIXELS * PIXEL_RECORD.size
    if len(actual) != frame_record_bytes * 2:
        raise RuntimeError(f"pixel stream has {len(actual)} bytes, expected {frame_record_bytes*2}")
    baseline = BASELINE_FRAME0.read_bytes()
    frame0 = actual[:frame_record_bytes]
    if frame0 != baseline:
        mismatch = next((i for i, (a, b) in enumerate(zip(frame0, baseline)) if a != b), -1)
        raise RuntimeError(f"frame0 differs from jpeg_unit baseline at byte {mismatch}")
    metrics = frame1_software_metrics(actual[frame_record_bytes:], jpeg_frames[1], run_dir)
    result = {
        "status": "PASS",
        "simulator": "ModelSim SE-64 10.1c",
        "frames": 2,
        "card_period_sysclk": 36,
        "card_period_ns": 720,
        "sector_requests": expected_requests,
        "sector_bytes": len(card_prefix),
        "frame0_bit_exact": True,
        "frame1": metrics,
        "jpeg_input_compatibility": input_compat,
        "frame_summaries": summary.read_text(encoding="utf-8").splitlines(),
        "mjp_sha256": index["video_sha256"],
        "audio_sha256": index["audio"]["sha256"],
        "pixel_output_sha256": hashlib.sha256(actual).hexdigest(),
        "compile": compile_result,
        "simulation": simulation,
    }
    (run_dir / "result.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
