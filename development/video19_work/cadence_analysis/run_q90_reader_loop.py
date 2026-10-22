"""Verify all MJP frames, loop wrap, restart, and reader stream contracts."""
from __future__ import annotations

import csv
from datetime import datetime
import hashlib
import json
import shutil
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
Q90_MEDIA = ROOT / "development/video19_work/media_q90_trial/output"
SOURCE_MJP = Q90_MEDIA / "VIDEO.MJP"
SOURCE_WAV = Q90_MEDIA / "TEST.WAV"
SOURCE_INDEX = Q90_MEDIA / "index.json"
MODEL_SOURCE = ROOT / "development/player_video19/src/user_source/hdl_source/mjp_file_reader.v"
MOV_MJPEG = ROOT / "development/video_codec_trial_20261021/media/letterbox640_q90_420.mjpg"
MODELSIM = Path("E:/ModelsimSE/win64")
EXPECTED_CARD_BYTES = 8_521_728


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest().upper()


def split_mjpeg(blob: bytes) -> list[bytes]:
    frames = []
    pos = 0
    while pos < len(blob):
        if blob[pos:pos + 2] != b"\xff\xd8":
            raise ValueError(f"expected SOI at source byte {pos}")
        eoi = blob.find(b"\xff\xd9", pos + 2)
        if eoi < 0:
            raise ValueError(f"missing EOI after source byte {pos}")
        frames.append(blob[pos:eoi + 2])
        pos = eoi + 2
    return frames


def write_hex_bytes(source: Path, destination: Path) -> None:
    with source.open("rb") as input_stream, destination.open("w", encoding="ascii", newline="\n") as output:
        while block := input_stream.read(65536):
            output.writelines(f"{byte:02x}\n" for byte in block)


def run_logged(command: list[str], cwd: Path, log_path: Path, timeout: int) -> dict:
    with log_path.open("w", encoding="utf-8") as log:
        process = subprocess.Popen(command, cwd=cwd, stdout=log, stderr=subprocess.STDOUT)
        try:
            code = process.wait(timeout=timeout)
            timed_out = False
        except subprocess.TimeoutExpired:
            # This PID was created by this runner; leave every unrelated simulator alone.
            process.kill()
            process.wait(timeout=30)
            code = 124
            timed_out = True
    return {"command": command, "exit_code": code, "timed_out": timed_out,
            "log": str(log_path)}


def main() -> None:
    run = HERE / "runs" / ("q90_reader_loop_" + datetime.now().strftime("%Y%m%d_%H%M%S_%f"))
    if run.exists():
        raise SystemExit(f"run directory already exists: {run}")
    refs = run / "jpeg_reference"
    input_dir = run / "input"
    refs.mkdir(parents=True)
    input_dir.mkdir()

    shutil.copy2(SOURCE_MJP, input_dir / "VIDEO.MJP")
    shutil.copy2(SOURCE_WAV, input_dir / "TEST.WAV")
    shutil.copy2(SOURCE_INDEX, input_dir / "index.json")
    index = json.loads((input_dir / "index.json").read_text(encoding="utf-8"))
    video = input_dir / "VIDEO.MJP"
    if len(index["frames"]) != 300 or video.stat().st_size != EXPECTED_CARD_BYTES:
        raise RuntimeError("existing MJP/index geometry changed")
    if sha256(video).lower() != index["video_sha256"].lower():
        raise RuntimeError("copied VIDEO.MJP does not match index SHA256")
    if sha256(input_dir / "TEST.WAV").lower() != index["audio"]["sha256"].lower():
        raise RuntimeError("copied TEST.WAV does not match index SHA256")

    movie_blob = MOV_MJPEG.read_bytes()
    if sha256(MOV_MJPEG).lower() != index["source_mjpg_sha256"].lower():
        raise RuntimeError("MOV-extracted MJPEG reference SHA256 differs from index")
    frames = split_mjpeg(movie_blob)
    if len(frames) != 300:
        raise RuntimeError(f"MOV source contains {len(frames)} JPEGs, expected 300")
    lengths = run / "frame_lengths.hex"
    crcs = run / "frame_crc32.hex"
    manifest = []
    with lengths.open("w", encoding="ascii") as length_out, crcs.open("w", encoding="ascii") as crc_out:
        for ordinal, (jpeg, entry) in enumerate(zip(frames, index["frames"], strict=True)):
            crc = f"{__import__('zlib').crc32(jpeg) & 0xffffffff:08x}"
            if entry["frame_index"] != ordinal or entry["jpeg_length_bytes"] != len(jpeg):
                raise RuntimeError(f"frame geometry mismatch at ordinal {ordinal}")
            if crc.lower() != entry["jpeg_crc32"].lower():
                raise RuntimeError(f"MJP/index CRC differs from MOV-extracted JPEG at {ordinal}")
            reference = refs / f"frame_{ordinal:03d}.jpg"
            reference.write_bytes(jpeg)
            length_out.write(f"{len(jpeg):08x}\n")
            crc_out.write(f"{crc}\n")
            manifest.append({
                "frame_index": ordinal,
                "length_bytes": len(jpeg),
                "crc32": crc,
                "sha256": hashlib.sha256(jpeg).hexdigest().upper(),
                "reference": str(reference),
            })

    card_hex = run / "card.hex"
    write_hex_bytes(video, card_hex)
    reader_copy = run / "mjp_file_reader.v"
    shutil.copy2(MODEL_SOURCE, reader_copy)
    tb = HERE / "tb_q90_mjp_stream_loop.sv"
    tb_copy = run / tb.name
    shutil.copy2(tb, tb_copy)
    (run / "modelsim.ini").write_text(
        "[Library]\nwork = work\nothers = E:/ModelsimSE/modelsim.ini\n", encoding="ascii")
    (run / "run.do").write_text(
        "onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n",
        encoding="ascii")

    receipt = {
        "status": "PREPARED",
        "simulator": "ModelSim SE-64 10.1c",
        "profile": "640x480 15fps JPEG420 Q90, 300 frames; reader only",
        "source_mjp": str(SOURCE_MJP),
        "source_mjp_sha256": sha256(SOURCE_MJP),
        "run_mjp_sha256": sha256(video),
        "source_index_sha256": sha256(SOURCE_INDEX),
        "source_wav_sha256": sha256(SOURCE_WAV),
        "mov_extracted_mjpeg": str(MOV_MJPEG),
        "mov_extracted_mjpeg_sha256": sha256(MOV_MJPEG),
        "reader_source": str(MODEL_SOURCE),
        "reader_source_sha256": sha256(MODEL_SOURCE),
        "reader_run_copy_sha256": sha256(reader_copy),
        "testbench_sha256": sha256(tb_copy),
        "frame_count": 300,
        "expected_runs": "300 sequential Q90 frames, frame 0 after wrap, reset/restart frame 0, then file_error stop",
        "frame_reference_manifest": str(run / "frame_reference_manifest.json"),
        "scope": "live mjp_file_reader; no JPEG core; card_valid gaps and jpeg_accept stalls",
    }
    (run / "frame_reference_manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    (run / "source_receipt.json").write_text(json.dumps(receipt, indent=2) + "\n",
                                               encoding="utf-8")

    vlib = run_logged([str(MODELSIM / "vlib.exe"), "work"], run, run / "vlib.log", 60)
    if vlib["exit_code"]:
        raise SystemExit(f"vlib failed: {vlib}")
    compile_result = run_logged([
        str(MODELSIM / "vlog.exe"), "-modelsimini", "modelsim.ini", "-work", "work",
        "-sv", str(reader_copy), str(tb_copy),
    ], run, run / "compile.log", 180)
    if compile_result["exit_code"]:
        (run / "result.json").write_text(json.dumps({
            "status": "COMPILE_FAILED", "compile": compile_result,
            "inputs": receipt,
        }, indent=2) + "\n", encoding="utf-8")
        raise SystemExit(f"vlog failed: {compile_result}")

    command = [
        str(MODELSIM / "vsim.exe"), "-modelsimini", "modelsim.ini", "-c", "-lic_noqueue",
        "-novopt", "work.tb_mjp_stream_loop",
        f"+CARD_HEX={card_hex.name}", f"+CARD_BYTES={video.stat().st_size}",
        f"+LENGTHS_HEX={lengths.name}", f"+CRCS_HEX={crcs.name}",
        "+FRAME_TRACE=frame_trace.csv", "+REQUEST_TRACE=sector_requests.csv",
        "-do", "run.do", "-l", "run.log",
    ]
    simulation = run_logged(command, run, run / "console.log", 1800)
    console = (run / "console.log").read_text(encoding="utf-8", errors="replace")
    frame_rows = []
    request_rows = []
    if (run / "frame_trace.csv").exists():
        with (run / "frame_trace.csv").open(newline="", encoding="utf-8") as stream:
            frame_rows = list(csv.DictReader(stream))
    if (run / "sector_requests.csv").exists():
        with (run / "sector_requests.csv").open(newline="", encoding="utf-8") as stream:
            request_rows = list(csv.DictReader(stream))

    expected_requests = [0]
    for frame in index["frames"]:
        expected_requests.append(frame["record_sector"])
        expected_requests.extend(range(frame["jpeg_sector"], frame["jpeg_sector"] + frame["jpeg_sector_count"]))
    first = index["frames"][0]
    expected_requests.append(first["record_sector"])
    expected_requests.extend(range(first["jpeg_sector"], first["jpeg_sector"] + first["jpeg_sector_count"]))
    expected_requests.extend([0, first["record_sector"]])
    expected_requests.extend(range(first["jpeg_sector"], first["jpeg_sector"] + first["jpeg_sector_count"]))

    reference_ok = len(frame_rows) == 302
    if reference_ok:
        for position, row in enumerate(frame_rows):
            expected_index = (position % 300) if position < 301 else 0
            expected = index["frames"][expected_index]
            if (int(row["frame_index"]) != expected_index or
                    int(row["length_bytes"]) != expected["jpeg_length_bytes"] or
                    row["crc32"].lower() != expected["jpeg_crc32"].lower()):
                reference_ok = False
                break
    request_ok = [int(row["lba"]) for row in request_rows] == expected_requests
    pass_line = next((line.strip() for line in console.splitlines()
                      if "STREAM_LOOP_PASS" in line), None)
    result = {
        "status": "PASS" if simulation["exit_code"] == 0 and pass_line and reference_ok and request_ok else "FAILED",
        "run_dir": str(run),
        "pass_line": pass_line,
        "source_receipt": receipt,
        "frame_count": len(frame_rows),
        "frame_crc_and_length_match_MOV_extracted_reference": reference_ok,
        "frame_trace_sha256": sha256(run / "frame_trace.csv") if (run / "frame_trace.csv").exists() else None,
        "sector_request_count": len(request_rows),
        "sector_requests_match_index_layout": request_ok,
        "sector_trace_sha256": sha256(run / "sector_requests.csv") if (run / "sector_requests.csv").exists() else None,
        "reference_hashes": {
            "VIDEO.MJP": sha256(video),
            "TEST.WAV": sha256(input_dir / "TEST.WAV"),
            "index.json": sha256(input_dir / "index.json"),
            "MOV_extracted_MJPEG": sha256(MOV_MJPEG),
            "mjp_file_reader.v": sha256(MODEL_SOURCE),
        },
        "compile": compile_result,
        "simulation": simulation,
        "console_tail": console[-5000:],
    }
    (run / "result.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in result.items() if key != "console_tail"},
                     indent=2), flush=True)
    if result["status"] != "PASS":
        raise SystemExit(f"stream-loop verification failed; see {run}")
if __name__ == "__main__":
    main()
