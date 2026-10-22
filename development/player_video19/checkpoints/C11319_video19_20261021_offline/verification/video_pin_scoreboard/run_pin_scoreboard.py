from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
import struct
from datetime import datetime
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = Path(__file__).resolve().parents[3]
DEFAULT_BASE = ROOT / "development/player_video19/build/video_system_20261021_193318"
SYS = ROOT / "development/system_verification_20261016"
PLAYER = ROOT / "development/player_video19"
sys.path.insert(0, str(SYS / "integration"))
from common import BIN, EG4, HDMI, compile_sources, execute, sha


def model_sim_color_compat(path: Path) -> dict:
    """Move the initialized net declaration into a declaration plus continuous assign."""
    original = path.read_text(encoding="utf-8-sig")
    original_sha = sha(path)
    init = re.compile(r"(?m)^\s*wire\s+color_input_fire_w\s*=\s*([^;]+);\s*$")
    matches = list(init.finditer(original))
    if matches:
        if len(matches) != 1:
            raise RuntimeError(f"unexpected color_input_fire_w initialized declaration count in {path}")
        expression = matches[0].group(1).strip()
        text = original[:matches[0].start()] + f"assign color_input_fire_w = {expression};" + original[matches[0].end():]
        module_end = text.find(");", text.find("module jpeg_output"))
        if module_end < 0:
            raise RuntimeError("jpeg_output port-list terminator not found")
        insert_at = module_end + 3
        text = text[:insert_at] + "\nwire color_input_fire_w;\n" + text[insert_at:]
        path.write_text(text, encoding="utf-8")
    final = path.read_text(encoding="utf-8")
    if re.search(r"(?m)^\s*wire\s+color_input_fire_w\s*=", final):
        raise RuntimeError("ModelSim compatibility conversion left an initialized net declaration")
    if len(re.findall(r"(?m)^\s*wire\s+color_input_fire_w;\s*$", final)) != 1:
        raise RuntimeError("ModelSim compatibility requires exactly one early color_input_fire_w net declaration")
    if len(re.findall(r"(?m)^\s*assign\s+color_input_fire_w\s*=", final)) != 1:
        raise RuntimeError("ModelSim compatibility requires exactly one color_input_fire_w continuous assignment")
    return {"path": path.relative_to(path.parents[5]).as_posix(), "source_sha256": original_sha,
            "compat_sha256": sha(path), "changed": original_sha != sha(path),
            "rule": "declare wire at jpeg_output module header; continuous assign after dependent declarations"}


def validate_pcm_reference(wav_path: Path, pcm_mem_path: Path) -> dict:
    blob = wav_path.read_bytes()
    if blob[:4] != b"RIFF" or blob[8:12] != b"WAVE":
        raise RuntimeError(f"PCM reference source is not a RIFF/WAVE file: {wav_path}")
    fmt = None
    data = None
    pos = 12
    while pos + 8 <= len(blob):
        tag = blob[pos:pos + 4]
        size = int.from_bytes(blob[pos + 4:pos + 8], "little")
        start = pos + 8
        end = start + size
        if end > len(blob):
            raise RuntimeError("truncated WAV chunk in PCM reference")
        if tag == b"fmt ":
            fmt = struct.unpack_from("<HHIIHH", blob, start)
        elif tag == b"data":
            data = (start, size)
        pos = end + (size & 1)
    if fmt is None or data is None:
        raise RuntimeError("PCM reference WAV has no fmt/data chunks")
    audio_format, channels, sample_rate, _, block_align, bits = fmt
    data_offset, data_bytes = data
    if (audio_format, channels, sample_rate, block_align, bits) != (1, 1, 48000, 2, 16):
        raise RuntimeError(f"PCM reference WAV format is not PCM16 mono 48 kHz: {fmt}")
    samples = [int(line.strip(), 16) for line in pcm_mem_path.read_text(encoding="ascii").splitlines() if line.strip()]
    raw_mem = b"".join(sample.to_bytes(2, "little") for sample in samples)
    wav_pcm = blob[data_offset:data_offset + data_bytes]
    if len(samples) != 960000 or len(raw_mem) != data_bytes or raw_mem != wav_pcm:
        raise RuntimeError("pcm.mem samples do not match the source WAV data chunk byte-for-byte")
    return {"wav_sha256": sha(wav_path), "wav_path": str(wav_path), "data_offset": data_offset,
            "data_bytes": data_bytes, "sample_count": len(samples),
            "pcm_mem_sha256": sha(pcm_mem_path), "byte_exact": True}


def main() -> None:
    parser = argparse.ArgumentParser(description="Recover HDMI serial pins and compare RGB/PCM to independent references")
    parser.add_argument("--run-name", help="unique directory name under runs/")
    parser.add_argument("--base-run", type=Path, default=DEFAULT_BASE,
                        help="frozen integrated app run, such as the final C04 application candidate")
    parser.add_argument("--reference-run", type=Path, required=True,
                        help="directory produced by prepare_reference.py")
    parser.add_argument("--negative", choices=("none", "rgb", "pcm"), default="none",
                        help="flip one expected-reference bit to prove the comparator rejects it")
    args = parser.parse_args()
    run_name = args.run_name or f"C03_app_20261021_193318_pin_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
    if Path(run_name).name != run_name or run_name in (".", ".."):
        raise SystemExit("--run-name must be a single directory name")
    out = HERE / "runs" / run_name
    base = args.base_run.resolve()
    reference_run = args.reference_run.resolve()
    if not (base / "summary.json").is_file():
        raise RuntimeError(f"missing app-run summary: {base}")
    parent_summary = json.loads((base / "summary.json").read_text(encoding="utf-8"))
    declared_run = parent_summary.get("run_directory")
    if parent_summary.get("status") != "PASS" or (declared_run and Path(declared_run).resolve() != base):
        raise RuntimeError("parent app-model run is not a matching PASS; refusing to bind the scoreboard")
    reference_receipt = json.loads((reference_run / "reference_receipt.json").read_text(encoding="utf-8"))
    if (reference_receipt.get("status") != "PASS" or reference_receipt.get("reference_pixels_per_frame") != 307200 or
            reference_receipt.get("distinct_rgb_pixels_frames_0_1_2", 0) <= 0 or
            reference_receipt.get("distinct_rgb_pixels_frames_1_2_3", 0) <= 0):
        raise RuntimeError("reference receipt is incomplete or invalid")
    reference_crcs = [str(frame.get("crc32", "")).lower() for frame in reference_receipt.get("frames", [])]
    app_crcs = [line.strip().lower().removeprefix("0x") for line in (base / "jpeg_crc.mem").read_text().splitlines() if line.strip()]
    if len(reference_crcs) != 4 or reference_crcs != app_crcs[:4]:
        raise RuntimeError("offline reference JPEG inputs differ from the application run's first four CRCs")
    source_receipt_path = base / "source_receipt.json"
    if not source_receipt_path.is_file():
        raise RuntimeError("parent app-run source receipt is missing")
    wav_entry = next((item for item in parent_summary.get("card_metadata", {}).get("files", [])
                      if item.get("name") == "TEST.WAV"), None)
    if not wav_entry or not Path(wav_entry.get("source_path", "")).is_file():
        raise RuntimeError("parent app-run summary does not identify its TEST.WAV source")
    source_wav = Path(wav_entry["source_path"]).resolve()
    if sha(source_wav).lower() != str(wav_entry.get("sha256", "")).lower():
        raise RuntimeError("TEST.WAV source SHA differs from the parent app-run card manifest")
    if out.exists():
        raise SystemExit(f"Refusing to overwrite existing run: {out}")
    out.mkdir(parents=True)
    source_paths = []
    for line in (base / "plain.f").read_text(encoding="utf-8").splitlines():
        source = Path(line.strip().strip('"').replace("/", "\\")).resolve()
        if base not in source.parents:
            raise RuntimeError(f"base run source escapes source directory: {source}")
        relative = source.relative_to(base)
        destination = out / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
        source_paths.append(destination)

    data_files = ("modelsim.ini", "clock_qualification.json", "jpeg_crc.mem", "lba_map.mem",
                  "packed_mem.mem", "pcm.mem")
    for name in data_files:
        shutil.copy2(base / name, out / name)
    shutil.copy2(source_wav, out / "TEST.WAV")
    shutil.copytree(base / "frozen", out / "frozen", dirs_exist_ok=True)
    compat_receipt = model_sim_color_compat(out / "frozen/src/user_source/hdl_source/jpeg/jpeg_output.v")
    shutil.copy2(reference_run / "pin_rgb_reference.mem", out / "pin_rgb_reference.mem")
    tb = out / "tb_video_system.v"
    tb_text = tb.read_text(encoding="utf-8")
    anchor = " reg [31:0] crc_gold[0:299];"
    if tb_text.count(anchor) != 1:
        raise RuntimeError("video_system TB declaration anchor changed")
    tb_text = tb_text.replace(anchor, anchor + '\n `include "system_pin_scoreboard_video.vh"')
    dut_gold_write = "    rgb_gold[gold_index]=rgb565_expand(dut.sd_card_write_data);"
    if tb_text.count(dut_gold_write) != 1:
        raise RuntimeError("video_system DUT RGB gold write anchor changed")
    tb_text = tb_text.replace(dut_gold_write, "    // rgb_gold is preloaded from independent C03 frozen-core reference.")
    pass_anchor = '    $display("VIDEO_SYSTEM_PASS decoded_pixels='
    if tb_text.count(pass_anchor) != 1:
        raise RuntimeError("video_system PASS anchor changed")
    tb_text = tb_text.replace(pass_anchor, "    check_pin_scoreboard;\n" + pass_anchor)
    tb.write_text(tb_text, encoding="utf-8")
    scoreboard = out / "system_pin_scoreboard_video.vh"
    shutil.copy2(HERE / scoreboard.name, scoreboard)
    pcm_binding = validate_pcm_reference(out / "TEST.WAV", out / "pcm.mem")

    pin_sources = {
        "hdmi_serial_receiver.v": SYS / "hdmi/hdmi_serial_receiver.v",
        "hdmi_video_period_receiver.v": SYS / "hdmi/hdmi_video_period_receiver.v",
        "hdmi_serial_packet_monitor.v": SYS / "hdmi/hdmi_serial_packet_monitor.v",
        "hdmi_packet_monitor.v": PLAYER / "src/user_source/hdl_source/hdmi_packet_monitor.v",
    }
    pin_modules = []
    for name, source in pin_sources.items():
        destination = out / name
        shutil.copy2(source, destination)
        pin_modules.append(destination)
    glbl = out / "eg_phy_glbl.v"
    if glbl not in source_paths:
        raise RuntimeError("run-local eg_phy_glbl.v not in source file set")

    sources = [path for path in source_paths if path.name != "tb_video_system.v"] + pin_modules
    hdl = out / "frozen/src/user_source/hdl_source"
    flags = ["+incdir+" + "+".join(path.as_posix() for path in
                                  (out, hdl, hdl / "include", hdl / "SD", out / "frozen/src/td_project"))]
    (out / "modelsim.ini").write_text(
        "[Library]\nwork = work\neg4 = " + EG4.as_posix() + "\nhdmi = " + HDMI.as_posix() +
        "\nothers = E:/ModelsimSE/modelsim.ini\n", encoding="ascii")
    (out / "run.do").write_text(
        "onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n",
        encoding="ascii")

    copied_files = source_paths + pin_modules + [out / name for name in data_files] + [
        out / "pin_rgb_reference.mem", out / "TEST.WAV"]
    copied_files += [p for p in (out / "frozen").rglob("*") if p.is_file()]
    receipt = {"parent_run": str(base), "parent_status": parent_summary["status"],
               "parent_summary_sha256": sha(base / "summary.json"),
               "parent_source_receipt_sha256": sha(source_receipt_path),
               "parent_tb_sha256": sha(base / "tb_video_system.v"),
               "reference_run": str(reference_run),
               "reference_receipt_sha256": sha(reference_run / "reference_receipt.json"),
               "reference_mem_sha256": sha(out / "pin_rgb_reference.mem"),
               "testbench_sha256": sha(tb), "scoreboard_sha256": sha(scoreboard),
               "excluded_packet_monitor_sha256": sha(out / "hdmi_packet_monitor.v"),
               "serial_pin_sources": {path.name: sha(path) for path in pin_modules},
               "media_inputs": {name: sha(out / name) for name in ("pin_rgb_reference.mem", "pcm.mem", "TEST.WAV",
                                                                        "jpeg_crc.mem", "packed_mem.mem", "lba_map.mem")},
               "negative_control": args.negative,
               "modelsim_compatibility": compat_receipt,
               "pcm_wav_binding": pcm_binding,
               "inputs": [{"path": path.relative_to(out).as_posix(), "sha256": sha(path)} for path in copied_files]}
    (out / "pin_source_receipt.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")

    compile_result = compile_sources(out, sources, flags, tb)
    mapped_sectors = parent_summary.get("card_metadata", {}).get("mapped_sectors")
    if not isinstance(mapped_sectors, int) or mapped_sectors <= 0:
        raise RuntimeError("parent app-run summary has no valid card_metadata.mapped_sectors")
    command = [BIN / "vsim.exe", "-modelsimini", "modelsim.ini", "-c", "-lic_noqueue", "-novopt",
               "-suppress", "3017,3722", "-L", "work", "-L", "eg4", "-L", "hdmi",
               f"-g/tb_video_system/MAPPED_SECTORS={mapped_sectors}", "-g/tb_video_system/IMAGE_BYTES=536870912",
               "-g/tb_video_system/CHECK_FRAMES=4", "work.tb_video_system", "work.glbl"]
    if args.negative == "rgb":
        command.append("+PIN_NEGATIVE_RGB")
    elif args.negative == "pcm":
        command.append("+PIN_NEGATIVE_PCM")
    command += ["-do", "run.do", "-l", "run.log"]
    simulation = execute(command, out, "console.log", 1800)
    log = (out / "console.log").read_text(encoding="utf-8", errors="replace")
    fatal = re.search(r"(?im)^.*(?:\bFATAL\b|\*\*\s+Error\b|\bFAIL(?:ED)?\b)", log)
    expected_negative = {"rgb": "PIN RGB mismatch", "pcm": "PIN PCM mismatch"}.get(args.negative)
    if expected_negative:
        passed = compile_result["exit_code"] == 0 and expected_negative in log and "** Fatal:" in log
        status = "NEGATIVE_CONTROL_PASS" if passed else "NEGATIVE_CONTROL_FAILED"
    else:
        passed = (compile_result["exit_code"] == 0 and simulation["exit_code"] == 0 and
                  "VIDEO_SYSTEM_PASS" in log and "SYSTEM_PIN_CONTENT_PASS" in log and not fatal)
        status = "PASS" if passed else "FAILED"
    result = {"status": status, "compile": compile_result, "simulation": simulation,
              "serial_pin_scoreboard": True,
              "reference_basis": {"rgb": "independent offline C03 frozen-core RGB888 checks every SD write coordinate and quantized framebuffer read; recovered TMDS compares to the matching globally indexed AXIS frame from a two-frame ring, with SOF content-valid/source labels qualifying displayed frames",
                                  "pcm": "pcm.mem validated byte-for-byte against source WAV data offset 78"},
              "assumptions": [f"frozen application run {base.name}", "qualified nominal PLL replay",
                              "application-interface SDRAM model"],
              "unverified": ["physical SDRAM timing", "SDF", "board behavior"],
              "negative_control": args.negative, "run_directory": str(out)}
    (out / "summary.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    if not passed:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
