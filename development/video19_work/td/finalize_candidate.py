from pathlib import Path
import hashlib
import json
import re
import sys

ROOT = Path(__file__).resolve().parent
if len(sys.argv) != 2 or sys.argv[1] not in {"A01", "A02", "A03", "A04", "A05", "A06"}:
    raise SystemExit("usage: python finalize_candidate.py A01|A02|A03|A04|A05|A06")
NAME = sys.argv[1]
RUN = ROOT / f"candidate_td/{NAME}"

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

area = (RUN / "reports/gate.area").read_text(encoding="utf-8", errors="replace")
qor = (RUN / "td_project/gate.qor").read_text(encoding="utf-8", errors="replace")
console = (RUN / "td_console.log").read_text(encoding="utf-8", errors="replace")
manifest = json.loads((RUN / "manifest.json").read_text(encoding="utf-8"))
source_dir = ROOT / f"candidate_src/{NAME}"
source_paths = sorted(source_dir.glob("*.v"))
source_fingerprints = [f"{path.name}:{sha256(path)}" for path in source_paths]
source_bundle = hashlib.sha256("\n".join(source_fingerprints).encode("ascii")).hexdigest()

def metric(pattern: str, source: str):
    match = re.search(pattern, source, re.MULTILINE)
    return int(match.group(1).replace(",", "")) if match else None

def row(instance: str):
    match = re.search(
        rf"^\|\s*{re.escape(instance)}\s*\|[^|]+\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|$",
        area, re.MULTILINE,
    )
    if not match:
        return None
    return dict(zip(("lut", "ripple", "seq", "bram9k", "dsp"), map(int, match.groups())))

warning_lines = [line.strip() for line in console.splitlines() if " WARNING:" in line]
artifacts = [
    RUN / "run_syn.tcl", RUN / "jpeg_core.sdc", RUN / "manifest.json",
    RUN / "td_console.log", RUN / "reports/gate.area",
    RUN / "reports/actualparams.rtl.log", RUN / "reports/actualparams.gate.log",
    RUN / "td_project/gate.qor", RUN / "td_project/jpeg_core.al",
]
if NAME in ("A04", "A05", "A06"):
    artifacts.append(RUN / "reports/actualparams.gate.after.log")
artifacts.extend(source_paths)
receipt = {
    "variant": NAME,
    "status": "SYNTHESIS_COMPLETE" if "SYNTHESIS_COMPLETE" in console else "INCOMPLETE",
    "command": f"python development/video19_work/td/run_candidate.py {NAME}",
    "tool": {"executable": r"C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe",
              "exit_code": 0 if "SYNTHESIS_COMPLETE" in console else None},
    "manifest": manifest,
    "candidate_source_bundle_sha256": source_bundle,
    "resources": {
        "device_lut": metric(r"^#lut\s+(\d+)", area),
        "generic_lut_cells": metric(r"^#Total_luts\s+(\d+)", area),
        "ff_area_report": metric(r"^#reg\s+(\d+)", area),
        "ff_qor_report": metric(r"\|\s+#registers\s+\|\s+(\d+)", qor),
        "bram9k": metric(r"^\s+#bram9k\s+(\d+)", area),
        "dsp": metric(r"^#dsp\s+(\d+)", area),
        "standalone_qor_slices": metric(r"\|\s+#slices\s+\|\s+(\d+)", qor),
        "hierarchy": {
            "jpeg_idct": row("u_jpeg_idct"),
            "idct_x": row("u_idct_x"),
            "idct_y": row("u_idct_y"),
            "jpeg_output": row("u_jpeg_output"),
            "jpeg_dqt": row("u_jpeg_dqt"),
        },
    },
    "synthesis_timing_estimate_only": {
        "period_ns": 20,
        "setup_wns_ps": metric(r"\|\s+Setup WNS\s+\|\s*(-?\d+)", qor),
        "setup_tns_ps": metric(r"\|\s+Setup TNS\s+\|\s*(-?\d+)", qor),
        "violated_setup_endpoints": metric(r"\|\s+Num of violated S-EP\s+\|\s*(\d+)", qor),
        "unconstrained_timing_ports": metric(r"Collect \d+ PI \d+ PO \((\d+) timing unconstrained\)", console),
    },
    "max_dsp_override": {
        "requested": 17 if NAME in ("A04", "A05", "A06") else None,
        "tcl_result": "set" if "MAX_DSP_SET=17" in console else (
            "unsupported" if "MAX_DSP_UNSUPPORTED=" in console else None
        ),
        "actualparams_after_sha256": sha256(RUN / "reports/actualparams.gate.after.log") if NAME in ("A04", "A05", "A06") and (RUN / "reports/actualparams.gate.after.log").exists() else None,
    },
    "warnings": warning_lines,
    "artifacts": [
        {"path": str(path.relative_to(ROOT)).replace("\\", "/"), "sha256": sha256(path)}
        for path in artifacts
    ],
}
(RUN / "result.json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")
print(json.dumps({"variant": NAME, "status": receipt["status"],
                  "resources": receipt["resources"], "warnings": len(warning_lines)}))
