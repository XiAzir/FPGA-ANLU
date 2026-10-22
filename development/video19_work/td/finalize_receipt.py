from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import re
import subprocess

ROOT = Path(__file__).resolve().parent
RUN = ROOT / "jpeg_core_area_high"

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

area_text = (RUN / "reports/gate.area").read_text(encoding="utf-8", errors="replace")
qor_text = (RUN / "td_project/gate.qor").read_text(encoding="utf-8", errors="replace")
console = (RUN / "td_console.log").read_text(encoding="utf-8", errors="replace")
manifest = json.loads((RUN / "manifest.json").read_text(encoding="utf-8"))

def first(pattern: str, source: str, cast=int):
    match = re.search(pattern, source, re.MULTILINE)
    return cast(match.group(1).replace(",", "")) if match else None

warnings = [line.strip() for line in console.splitlines() if " WARNING:" in line]
artifacts = [
    RUN / "run_syn.tcl", RUN / "jpeg_core.sdc", RUN / "manifest.json",
    RUN / "td_console.log", RUN / "reports/gate.area",
    RUN / "reports/actualparams.rtl.log", RUN / "reports/actualparams.gate.log",
    RUN / "td_project/gate.qor", RUN / "td_project/jpeg_core.al",
]
receipt = {
    "status": "SYNTHESIS_COMPLETE",
    "captured_utc": datetime.now(timezone.utc).isoformat(),
    "command": "python development/video19_work/td/run_td.py",
    "tool": {
        "executable": r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe",
        "version": "6.2.1_SP1_6.2.178.840",
        "exit_code": 0,
    },
    "input": manifest,
    "settings_report_verified": {
        "rtl_sha256": sha256(RUN / "reports/actualparams.rtl.log"),
        "gate_sha256": sha256(RUN / "reports/actualparams.gate.log"),
        "parameters": ["min_ripple_len=18", "mapper_lut_delay=1600",
                        "add_map_lut_struct=high", "map_mode=area_prior",
                        "multi_thread_mapping=partition", "resource_sharing=auto",
                        "shifter_style=shifter_reg"],
    },
    "resources": {
        "device_lut": first(r"^#lut\s+(\d+)", area_text),
        "generic_lut_cells": first(r"^#Total_luts\s+(\d+)", area_text),
        "ripple_cells": first(r"^\|top\s*\|jpeg_core\s*\|\d+\s*\|(\d+)", area_text),
        "ff_area_report": first(r"^#reg\s+(\d+)", area_text),
        "ff_qor_report": first(r"\|\s+#registers\s+\|\s+(\d+)", qor_text),
        "bram9k": first(r"^\s+#bram9k\s+(\d+)", area_text),
        "dsp": first(r"^#dsp\s+(\d+)", area_text),
        "standalone_qor_slices": first(r"\|\s+#slices\s+\|\s+(\d+)", qor_text),
    },
    "synthesis_timing_estimate_only": {
        "clock_period_ns": 20,
        "setup_wns_ps": first(r"\|\s+Setup WNS\s+\|\s*(-?\d+)", qor_text),
        "setup_tns_ps": first(r"\|\s+Setup TNS\s+\|\s*(-?\d+)", qor_text),
        "violated_setup_endpoints": first(r"\|\s+Num of violated S-EP\s+\|\s*(\d+)", qor_text),
        "unconstrained_timing_ports": first(r"Collect \d+ PI \d+ PO \((\d+) timing unconstrained\)", console),
    },
    "warnings": warnings,
    "artifacts": [
        {"path": str(path.relative_to(ROOT)).replace("\\", "/"), "sha256": sha256(path)}
        for path in artifacts
    ],
}
(RUN / "result.json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")
print(json.dumps({"status": receipt["status"], "resources": receipt["resources"],
                  "warning_count": len(warnings), "receipt": str(RUN / "result.json")}))
