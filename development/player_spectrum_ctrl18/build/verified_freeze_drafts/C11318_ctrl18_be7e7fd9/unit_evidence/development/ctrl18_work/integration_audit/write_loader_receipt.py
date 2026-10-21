#!/usr/bin/env python3
"""Bind the loader integration simulation PASS to exact sources and tools."""

from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
WORK = ROOT / "development/ctrl18_work/integration_audit"
PARENT = ROOT / "development/player_spectrum_arch17"
CANDIDATE = ROOT / "development/player_spectrum_ctrl18"
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def state_machine_bytes(path: Path) -> bytes:
    source = path.read_bytes()
    endmodule = source.find(b"\nendmodule")
    if endmodule < 0:
        raise AssertionError(f"missing loader endmodule: {path}")
    marker = b"always @(posedge clk or posedge rst) begin"
    starts = []
    pos = 0
    while True:
        found = source.find(marker, pos, endmodule)
        if found < 0:
            break
        starts.append(found)
        pos = found + len(marker)
    if len(starts) < 2:
        raise AssertionError(f"expected both loader sequential blocks: {path}")
    return source[starts[-1] : endmodule + len(b"\nendmodule")]


candidate_loader = CANDIDATE / "src/user_source/hdl_source/tf_bmp_file_player.v"
parent_loader = PARENT / "src/user_source/hdl_source/tf_bmp_file_player.v"
tested_loader = WORK / ".." / "key_events/tf_bmp_file_player_event_candidate.v"
tested_loader = tested_loader.resolve()
candidate_scale = CANDIDATE / "src/user_source/hdl_source/bmp_scale_engine.v"
parent_scale = PARENT / "src/user_source/hdl_source/bmp_scale_engine.v"
tb = WORK / "tb_loader_event.v"
log = WORK / "loader_event_compile.log"
vvp_image = WORK / "tb_loader_event.vvp"

if not log.is_file() or "PASS tb_loader_event checks=35" not in log.read_text(encoding="utf-8", errors="replace"):
    raise AssertionError("loader simulation log has no 35-check PASS")
if sha(candidate_loader) != sha(tested_loader):
    raise AssertionError("C11318 loader source differs from the exact tested loader source")
if sha(candidate_scale) != sha(parent_scale):
    raise AssertionError("C11318 bmp_scale_engine differs from the C11317 dependency compiled in the test")
if state_machine_bytes(candidate_loader) != state_machine_bytes(parent_loader):
    raise AssertionError("loader main state-machine body differs byte-for-byte from C11317")

inputs = [
    candidate_loader,
    parent_loader,
    candidate_scale,
    tb,
    IVERILOG,
    VVP,
    log,
    vvp_image,
]
receipt = {
    "schema": "C11318-loader-event-integration-audit-v1",
    "status": "PASS",
    "created_utc": datetime.now(timezone.utc).isoformat(),
    "test": "tb_loader_event",
    "checks": 35,
    "delivered_sink_pulses_before_reset": {"next": 7, "auto": 3},
    "stale_sink_pulses_after_common_reset": {"next": 0, "auto": 0},
    "coverage": [
        "WAIT_CATALOG event discard without catalog and queue on catalog arrival",
        "IDLE pending consumption into HEADER",
        "PAYLOAD busy next_pending retention and one-bit coalescing",
        "auto event toggles independently while PAYLOAD is active",
        "WAIT_DISPLAY completion coincident with next_press, then deferred IDLE launch",
        "two-phase request synchronization, acknowledgement rearm, and common reset",
    ],
    "scope_note": (
        "The test instantiates the selected C11318 loader and scaler. Testbench-only hierarchical state deposits "
        "select loader states; all next/auto requests traverse the real key_event_mailbox_sink. "
        "It does not run the full media system or Tang Dynasty."
    ),
    "loader_state_machine_body": "byte-identical to C11317",
    "commands": [
        "iverilog.exe -g2012 -Wall -s tb_loader_event -o tb_loader_event.vvp tb_loader_event.v tf_bmp_file_player.v bmp_scale_engine.v",
        "vvp.exe tb_loader_event.vvp",
    ],
    "compiled_inputs_and_evidence": [
        {"path": str(path.relative_to(ROOT)).replace("\\", "/"), "sha256": sha(path), "bytes": path.stat().st_size}
        for path in inputs
    ],
}
output = WORK / "loader_event_receipt.json"
output.write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"PASS loader_event_receipt {output.relative_to(ROOT)} inputs={len(inputs)}")
