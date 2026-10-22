from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import struct
import subprocess
import zlib
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
MJP = ROOT / "development/video19_work/stream_frontend/output/VIDEO.MJP"
INDEX = ROOT / "development/video19_work/stream_frontend/output/index.json"
JPEG_TB = ROOT / "development/video19_work/jpeg_unit/tb_jpeg_core.sv"
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
PIXEL_RECORD = struct.Struct("<HHBBB")
FRAME_PIXELS = 640 * 480
FRAME_BYTES = FRAME_PIXELS * PIXEL_RECORD.size


def sha(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as src:
        for block in iter(lambda: src.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description="Build four frame RGB reference using standalone frozen JPEG RTL")
    parser.add_argument("core_run", type=Path, help="C03 integrated app run containing baseline frozen JPEG RTL")
    parser.add_argument("run_name", help="run directory name under video_pin_scoreboard/runs/")
    parser.add_argument("--input-run", type=Path,
                        help="app run whose jpeg_crc.mem binds the selected stream; defaults to core_run")
    parser.add_argument("--start-frame", type=int, default=0,
                        help="first JPEG index in VIDEO.MJP; reference four sequential frames")
    parser.add_argument("--mjp", type=Path, default=MJP, help="MJP byte stream to decode")
    parser.add_argument("--index", type=Path, default=INDEX, help="matching MJP frame index JSON")
    args = parser.parse_args()
    if Path(args.run_name).name != args.run_name or args.run_name in (".", ".."):
        raise SystemExit("run_name must be one directory name")
    core_base = args.core_run.resolve()
    input_base = (args.input_run or args.core_run).resolve()
    out = HERE / "runs" / args.run_name
    if out.exists():
        raise SystemExit(f"Refusing to overwrite reference run: {out}")
    core_source = core_base / "frozen/src/user_source/hdl_source/jpeg"
    sources = sorted(core_source.glob("*.v"))
    if not sources:
        raise RuntimeError(f"frozen JPEG RTL not found under {core_source}")
    mjp_path = args.mjp.resolve()
    index_path = args.index.resolve()
    index = json.loads(index_path.read_text(encoding="utf-8"))
    if args.start_frame < 0 or index.get("frame_count", 0) < args.start_frame + 4:
        raise RuntimeError("reference MJP does not contain the requested four-frame interval")
    crc_entries = [line.strip().lower() for line in (input_base / "jpeg_crc.mem").read_text().splitlines() if line.strip()]
    input_blob = mjp_path.read_bytes()
    out.mkdir(parents=True)
    jpeg_paths = []
    selected_entries = index["frames"][args.start_frame:args.start_frame + 4]
    for i, entry in enumerate(selected_entries):
        start = entry["jpeg_offset_bytes"]
        jpeg = input_blob[start:start + entry["jpeg_length_bytes"]]
        crc = f"{zlib.crc32(jpeg):08x}"
        if len(jpeg) != entry["jpeg_length_bytes"] or crc != entry["jpeg_crc32"]:
            raise RuntimeError(f"MJP frame {i} length/CRC differs from index")
        if i >= len(crc_entries) or crc != crc_entries[i].removeprefix("0x"):
            raise RuntimeError(f"MJP frame {args.start_frame + i} CRC differs from integrated app input manifest entry {i}")
        path = out / f"input_frame_{i}.jpg"
        path.write_bytes(jpeg)
        jpeg_paths.append(path)
    core_run = out / "standalone_core"
    core_run.mkdir()
    for path in jpeg_paths:
        shutil.copy2(path, core_run / path.name)
    for source in sources:
        shutil.copy2(source, core_run / source.name)
    tb_copy = core_run / "tb_jpeg_core.sv"
    shutil.copy2(JPEG_TB, tb_copy)
    compile_log = core_run / "compile.log"
    exe = core_run / "simv.exe"
    compile_cmd = [str(IVERILOG), "-g2012", "-s", "tb_jpeg_core", "-o", str(exe),
                   str(tb_copy), *(str(p) for p in sorted(core_run.glob("*.v")))]
    compiled = subprocess.run(compile_cmd, cwd=core_run, capture_output=True, text=True)
    compile_log.write_text(compiled.stdout + compiled.stderr, encoding="utf-8")
    if compiled.returncode:
        raise RuntimeError(f"standalone core compile failed; see {compile_log}")
    frame_record_blobs = []
    for i, path in enumerate(jpeg_paths):
        pixel_records = core_run / f"frame{i}_pixels_xy_rgb.bin"
        sim_log = core_run / f"frame{i}.log"
        console_log = core_run / f"frame{i}_console.log"
        sim_cmd = [str(VVP), str(exe), f"+JPEG={path.name}", f"+OUT={pixel_records.name}", f"+LOG={sim_log.name}",
                   "+MODE=0", "+GAP=0", "+SEED=20261021", "+FRAMES=1", "+WIDTH=640", "+HEIGHT=480"]
        with console_log.open("w", encoding="utf-8") as log:
            simulation = subprocess.run(sim_cmd, cwd=core_run, stdout=log, stderr=subprocess.STDOUT, timeout=240)
        if simulation.returncode:
            raise RuntimeError(f"standalone frame {i} decode failed; see {console_log}")
        records = pixel_records.read_bytes()
        if len(records) != FRAME_BYTES:
            raise RuntimeError(f"standalone frame {i} record size {len(records)} != {FRAME_BYTES}")
        frame_record_blobs.append(records)

    mem = out / "pin_rgb_reference.mem"
    ordered_frames = []
    with mem.open("w", encoding="ascii", newline="\n") as stream:
        for frame in range(4):
            frame_blob = frame_record_blobs[frame]
            pixels = bytearray(FRAME_PIXELS * 3)
            seen = bytearray(FRAME_PIXELS)
            for x, y, r, g, b in PIXEL_RECORD.iter_unpack(frame_blob):
                if x >= 640 or y >= 480:
                    raise RuntimeError(f"frame {frame}: coordinate out of range ({x},{y})")
                address = y * 640 + x
                if seen[address]:
                    raise RuntimeError(f"frame {frame}: duplicate coordinate ({x},{y})")
                seen[address] = 1
                pixels[address * 3:address * 3 + 3] = bytes((r, g, b))
            if not all(seen):
                raise RuntimeError(f"frame {frame}: incomplete coordinate map {sum(seen)}/{FRAME_PIXELS}")
            ordered_frames.append(pixels)
            for pos in range(0, len(pixels), 3):
                stream.write(f"{pixels[pos]:02x}{pixels[pos + 1]:02x}{pixels[pos + 2]:02x}\n")

    distinct_triplets_012 = sum(
        ordered_frames[0][p:p + 3] != ordered_frames[1][p:p + 3] and
        ordered_frames[0][p:p + 3] != ordered_frames[2][p:p + 3] and
        ordered_frames[1][p:p + 3] != ordered_frames[2][p:p + 3]
        for p in range(0, FRAME_PIXELS * 3, 3)
    )
    distinct_triplets_123 = sum(
        ordered_frames[1][p:p + 3] != ordered_frames[2][p:p + 3] and
        ordered_frames[1][p:p + 3] != ordered_frames[3][p:p + 3] and
        ordered_frames[2][p:p + 3] != ordered_frames[3][p:p + 3]
        for p in range(0, FRAME_PIXELS * 3, 3)
    )
    if distinct_triplets_012 == 0 or distinct_triplets_123 == 0:
        raise RuntimeError("offline reference does not contain three pairwise-distinct frames in both 0..2 and 1..3 windows")

    input_summary = []
    for i, path in enumerate(jpeg_paths):
        input_summary.append({"frame": args.start_frame + i, "app_crc_index": i,
                              "bytes": path.stat().st_size, "sha256": sha(path),
                              "crc32": index["frames"][args.start_frame + i]["jpeg_crc32"]})
    receipt = {"status": "PASS", "method": "standalone frozen integrated JPEG RTL, coordinate sorted RGB888",
               "core_run": str(core_base), "input_run": str(input_base), "start_frame": args.start_frame,
               "core_source_hashes": [{"path": p.name, "sha256": sha(p)} for p in sources],
               "tb_source": {"path": str(JPEG_TB), "sha256": sha(JPEG_TB)},
               "mjp_source": {"path": str(mjp_path), "sha256": sha(mjp_path),
                              "index_path": str(index_path), "index_sha256": sha(index_path)},
               "frames": input_summary,
               "records_sha256": [{"frame": i, "sha256": sha(core_run / f"frame{i}_pixels_xy_rgb.bin")} for i in range(4)],
               "reference_mem_sha256": sha(mem), "reference_pixels_per_frame": FRAME_PIXELS,
               "distinct_rgb_pixels_frames_0_1_2": distinct_triplets_012,
               "distinct_rgb_pixels_frames_1_2_3": distinct_triplets_123}
    (out / "reference_receipt.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(receipt, indent=2))


if __name__ == "__main__":
    main()
