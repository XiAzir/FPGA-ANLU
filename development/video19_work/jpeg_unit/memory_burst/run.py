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
GLOBAL_DEF = ROOT / "development/player_video19/src/user_source/hdl_source/include/global_def.v"
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
    parser.add_argument("--burst-words", type=int, default=128)
    parser.add_argument("--gap-cycles", type=int, default=50)
    parser.add_argument("--data-lag", type=int, choices=[0, 1], default=0,
                        help="drive App_wr_din from the previous stream word")
    args = parser.parse_args()
    if not 1 <= args.burst_words <= 128:
        raise SystemExit("--burst-words must be 1..128")
    if args.gap_cycles < 0:
        raise SystemExit("--gap-cycles must be nonnegative")
    if not os.environ.get("MGLS_LICENSE_FILE"):
        raise SystemExit("MGLS_LICENSE_FILE is required")
    target_words = 512 if args.format == "rgb565" else 768
    info = json.loads(GATE_INFO.read_text(encoding="utf-8"))
    gate_source = Path(info["directory"]) / "build/controller_gate.v"
    if sha(gate_source) != info["gate_sha256"].upper():
        raise SystemExit("Controller gate SHA mismatch")
    out = HERE / "runs" / ("jpeg_" + args.format + "_gate_" + datetime.now().strftime("%Y%m%d_%H%M%S"))
    out.mkdir(parents=True)
    sources = [gate_source, REFERENCE, WRAPPER, GLBL, GLOBAL_DEF, HERE / "tb_jpeg420_controller_jump.v"]
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
        "burst_words": args.burst_words,
        "gap_cycles": args.gap_cycles,
        "data_lag": args.data_lag,
        "linear_read_words": 8192,
        "mapping": ("RGB565, four horizontal MCUs, 128 words per MCU, four words per 8-pixel block row"
                    if args.format == "rgb565" else
                    "jpeg420_word_address.v formula; first four horizontal MCUs; 192 words per MCU, six words per 8-pixel block row"),
        "global_def": {"path": str(GLOBAL_DEF), "sha256": sha(GLOBAL_DEF),
                       "data_width": 32, "app_address_width": 21, "row_width": 11, "bank_width": 2},
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
    sim_command += [f"+BURST_WORDS={args.burst_words}", f"+GAP_CYCLES={args.gap_cycles}",
                    f"+DATA_LAG={args.data_lag}"]
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
    active_rows: dict[int, int] = {}
    physical_banks: set[int] = set()
    physical_rows: set[tuple[int, int]] = set()
    physical_locations: set[tuple[int, int, int]] = set()
    physical_events = []
    physical_write_map = []
    physical_write_map_mismatches = []
    app_address_by_data = {
        f"{want:08x}": address
        for address, written, want in expected if written
    }
    if commands_path.exists():
        command_map = {"011": "ACT", "101": "READ", "100": "WRITE", "010": "PRECHARGE", "001": "REFRESH"}
        with commands_path.open(newline="") as stream:
            for row in csv.reader(stream):
                command = command_map.get(row[1] + row[2] + row[3])
                if command:
                    command_counts[command] += 1
                    bank = int(row[4], 2)
                    pin_addr = int(row[5], 16)
                    physical_banks.add(bank)
                    if command == "ACT":
                        active_rows[bank] = pin_addr & 0x7FF
                        physical_rows.add((bank, active_rows[bank]))
                    elif command in ("READ", "WRITE"):
                        physical_locations.add((bank, active_rows.get(bank, -1), pin_addr & 0xFF))
                        expected_app_address = app_address_by_data.get(row[6].lower()) if command == "WRITE" else None
                        if command == "WRITE" and expected_app_address is not None:
                            app_addr = expected_app_address
                            mapped_bank = (app_addr >> 2) & 0x3
                            mapped_row = (app_addr >> 10) & 0x7FF
                            mapped_column = (((app_addr >> 4) & 0x3F) << 2) | (app_addr & 0x3)
                            mapping = {
                                "app_address_from_dq": app_addr,
                                "pin_bank": bank, "expected_bank": mapped_bank,
                                "pin_row": active_rows.get(bank), "expected_row": mapped_row,
                                "pin_column": pin_addr & 0xFF, "expected_column": mapped_column,
                            }
                            physical_write_map.append(mapping)
                            if (bank, active_rows.get(bank), pin_addr & 0xFF) != (
                                mapped_bank, mapped_row, mapped_column
                            ):
                                physical_write_map_mismatches.append(mapping)
                        if command == "WRITE" or len(physical_events) < 16:
                            physical_events.append({
                                "time_ns": float(row[0]), "command": command, "bank": bank,
                                "row": active_rows.get(bank), "column": pin_addr & 0xFF,
                                "auto_precharge": bool(pin_addr & 0x400),
                                "dq_at_command": row[6],
                                "expected_app_address_from_dq": expected_app_address,
                                "app_wr_en_at_command": row[7],
                                "app_wr_addr_at_command": row[8],
                                "app_wr_data_at_command": row[9],
                            })
                    elif command == "PRECHARGE":
                        if pin_addr & 0x400:
                            active_rows.clear()
                        else:
                            active_rows.pop(bank, None)
    burst_starts = []
    busy_high_cycles_between_bursts = []
    write_trace_path = out / "app_write_trace.csv"
    if write_trace_path.exists():
        with write_trace_path.open(newline="") as stream:
            write_rows = list(csv.reader(stream))
        burst_starts = [int(row[0]) for index, row in enumerate(write_rows)
                        if row[1] == "1" and (index == 0 or write_rows[index - 1][1] != "1")]
        for start, end in zip(burst_starts, burst_starts[1:]):
            busy_high_cycles_between_bursts.append(sum(
                1 for row in write_rows if start < int(row[0]) < end and row[1] == "0" and row[4] == "1"
            ))
    burst_periods = [b - a for a, b in zip(burst_starts, burst_starts[1:])]
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
        "write_burst_cadence": {
            "burst_words": args.burst_words,
            "burst_count": len(burst_starts),
            "start_to_start_cycles_min": min(burst_periods, default=None),
            "start_to_start_cycles_max": max(burst_periods, default=None),
            "app_enable_low_cycles_min": min((period - args.burst_words for period in burst_periods), default=None),
            "app_enable_low_cycles_max": max((period - args.burst_words for period in burst_periods), default=None),
            "busy_high_cycles_between_bursts_min": min(busy_high_cycles_between_bursts, default=None),
            "busy_high_cycles_between_bursts_max": max(busy_high_cycles_between_bursts, default=None),
            "word_rate_mwords_per_second_at_50mhz": (
                50.0 * args.burst_words / min(burst_periods) if burst_periods else None
            ),
        },
        "physical_pin_decode": {
            "basis": "gate SDRAM pin commands; bank and row from ACT, column from READ/WRITE A[7:0], A10 is auto-precharge",
            "app_address_mapping_verified_from_all_write_dq": {
                "bank": "AppAddr[3:2]",
                "row": "AppAddr[20:10]",
                "column": "{AppAddr[9:4], AppAddr[1:0]}",
                "write_command_count": len(physical_write_map),
                "mapping_mismatch_count": len(physical_write_map_mismatches),
                "write_samples": physical_write_map[:32],
            },
            "bank_mask": sum(1 << bank for bank in physical_banks),
            "banks_seen": sorted(physical_banks),
            "active_bank_row_pairs": len(physical_rows),
            "row_min": min((row for _, row in physical_rows), default=None),
            "row_max": max((row for _, row in physical_rows), default=None),
            "unique_command_locations": len(physical_locations),
            "first_read_write_and_all_write_commands": physical_events,
        },
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
