from __future__ import annotations

import csv
import hashlib
import argparse
import json
import os
import shutil
import subprocess
from datetime import datetime
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
MEMORY = ROOT / "development/system_verification_20261016/memory"
GATE_INFO = MEMORY / "controller_gate_latest.json"
REFERENCE = Path(
    "E:/QQ CACHE/Download/安路资料/赛题1_工作资料/05_补充参考工程/"
    "APUG011_SDRAM参考工程/source_code/model/IS42s32200.v"
)
WRAPPER = MEMORY / "sdram_issi_reference_wrapper.v"
GLBL = Path("C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v")
MODELSIM = Path("E:/ModelsimSE/win64")
EG4 = ROOT / "development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work"
DATA_OFFSET = -1


def sha(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as src:
        for block in iter(lambda: src.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest().upper()


def execute(command: list[Path | str], cwd: Path, log_name: str, timeout: int = 240) -> dict:
    command_text = [str(part) for part in command]
    with (cwd / log_name).open("w", encoding="utf-8") as log:
        proc = subprocess.Popen(command_text, cwd=cwd, stdout=log, stderr=subprocess.STDOUT)
        try:
            code = proc.wait(timeout=timeout)
            timed_out = False
        except subprocess.TimeoutExpired:
            timed_out = True
            proc.kill()
            proc.wait(timeout=20)
            code = 124
            log.write("\nTIMEOUT: process terminated by runner.\n")
    return {"command": command_text, "exit_code": code, "timed_out": timed_out, "log": str(cwd / log_name)}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--format", choices=["rgb888", "rgb565"], default="rgb888")
    args = parser.parse_args()
    if not os.environ.get("MGLS_LICENSE_FILE"):
        raise SystemExit("MGLS_LICENSE_FILE is required")
    target_words = 512 if args.format == "rgb565" else 768
    info = json.loads(GATE_INFO.read_text(encoding="utf-8"))
    gate_source = Path(info["directory"]) / "build/controller_gate.v"
    if sha(gate_source) != info["gate_sha256"].upper():
        raise SystemExit("Controller gate SHA mismatch")
    out = HERE / "runs" / ("jpeg_" + args.format + "_gate_" + datetime.now().strftime("%Y%m%d_%H%M%S"))
    out.mkdir(parents=True)
    sources = [gate_source, REFERENCE, WRAPPER, GLBL, HERE / "tb_jpeg420_controller_jump.v"]
    copies = []
    for source in sources:
        if not source.exists():
            raise SystemExit(f"missing source: {source}")
        target = out / source.name
        shutil.copy2(source, target)
        copies.append(target)
    manifest = {
        "scope": "Unmodified synthesized production SDRAM controller gate + APUG011 IS42s32200 pin-level model; no SDF",
        "controller_gate_directory": info["directory"],
        "controller_gate_expected_sha256": info["gate_sha256"].upper(),
        "controller_gate_actual_sha256_before": sha(gate_source),
        "read_data_offset_cycles": DATA_OFFSET,
        "format": args.format,
        "write_words": target_words,
        "linear_read_words": 8192,
        "mapping": ("RGB565, four horizontal MCUs, 128 words per MCU, four words per 8-pixel block row"
                    if args.format == "rgb565" else
                    "jpeg420_word_address.v formula; first four horizontal MCUs; 192 words per MCU, six words per 8-pixel block row"),
        "inputs": [{"source": str(src), "copy": str(dst), "sha256": sha(src)} for src, dst in zip(sources, copies)],
    }
    (out / "source_receipt.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    (out / "modelsim.ini").write_text(
        "[Library]\nwork = work\neg4 = " + EG4.as_posix() + "\nothers = E:/ModelsimSE/modelsim.ini\n",
        encoding="utf-8",
    )
    vlib = execute([MODELSIM / "vlib.exe", "work"], out, "vlib.log")
    if vlib["exit_code"]:
        raise SystemExit(f"vlib failed: {out / 'vlib.log'}")
    compile_result = execute(
        [MODELSIM / "vlog.exe", "-modelsimini", "modelsim.ini", "-work", "work", *copies],
        out, "compile.log",
    )
    if compile_result["exit_code"]:
        raise SystemExit(f"compile failed: {out / 'compile.log'}")
    (out / "run.do").write_text("onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n", encoding="utf-8")
    sim_command = [MODELSIM / "vsim.exe", "-modelsimini", "modelsim.ini", "-c", "-novopt", "-suppress", "3017,3722",
         "-L", "work", "-L", "eg4", "work.tb_controller_gate", "work.glbl"]
    if args.format == "rgb565":
        sim_command.append("+RGB565")
    sim_command += ["-do", "run.do", "-l", "run.log"]
    sim = execute(
        sim_command,
        out, "console.log", timeout=240,
    )
    trace = out / "controller_memory.csv"
    expected_path = out / "expected.csv"
    rows = {}
    if trace.exists():
        with trace.open(newline="") as stream:
            for row in csv.reader(stream):
                rows[int(row[0])] = row
    expected = []
    with expected_path.open(newline="") as stream:
        expected = [(int(row[0]), row[1] == "1", int(row[2], 16)) for row in csv.reader(stream)]
    errors = []
    checked = 0
    checked_written = 0
    for cycle, row in sorted(rows.items()):
        if row[3] != "1":
            continue
        source_row = rows.get(cycle + DATA_OFFSET)
        expected_addr, written, want = expected[checked] if checked < len(expected) else (None, False, None)
        if written:
            try:
                got = int(source_row[4], 16) if source_row else None
            except ValueError:
                got = None
            checked_written += 1
            if got != want:
                errors.append({"read_index": checked, "address": expected_addr,
                               "got": None if got is None else f"{got:08x}",
                               "expected": None if want is None else f"{want:08x}"})
        checked += 1
    log_text = (out / "console.log").read_text(errors="replace") if (out / "console.log").exists() else ""
    complete = "JPEG420_CONTROLLER_TRACE_COMPLETE" in log_text
    model_errors = sum(1 for line in log_text.splitlines() if "ERROR:" in line)
    command_counts = {"ACT": 0, "READ": 0, "WRITE": 0, "PRECHARGE": 0, "REFRESH": 0}
    commands_path = out / "sdram_commands.csv"
    if commands_path.exists():
        command_map = {"011": "ACT", "101": "READ", "100": "WRITE", "010": "PRECHARGE", "001": "REFRESH"}
        with commands_path.open(newline="") as stream:
            for row in csv.reader(stream):
                command = command_map.get(row[1] + row[2] + row[3])
                if command:
                    command_counts[command] += 1
    gate_after = sha(gate_source)
    ok = sim["exit_code"] == 0 and not sim["timed_out"] and complete and model_errors == 0 and checked == 8192 and checked_written == target_words and not errors and gate_after == info["gate_sha256"].upper()
    summary = {
        "status": "PASS_SCOPE_PIN_MODEL" if ok else "NOT_QUALIFIED",
        "simulation": sim,
        "checked_words": checked,
        "checked_written_addresses": checked_written,
        "expected_words": len(expected),
        "expected_written_addresses": target_words,
        "mismatch_count": len(errors),
        "first_mismatches": errors[:16],
        "vendor_model_timing_errors": model_errors,
        "sdram_command_counts": command_counts,
        "controller_gate_sha256_after": gate_after,
        "limitations": [
            "APUG011 pin-level reference model is not a SiP electrical timing guarantee",
            "No SDF or routed full-top timing simulation",
        ],
    }
    (out / "summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps({"directory": str(out), **summary}, indent=2), flush=True)
    raise SystemExit(0 if ok else 2)


if __name__ == "__main__":
    main()
