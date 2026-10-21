"""Parse the completed TD standalone resource reports into JSON and CSV."""

from __future__ import annotations

import csv
import json
import re
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parent
RUNS = ROOT / "runs"
VARIANTS = ("reference", "algorithm_only", "address_only", "index_only", "combined")


def capture(pattern: str, text: str, label: str) -> int:
    match = re.search(pattern, text)
    if not match:
        raise ValueError(f"missing {label} in TD report")
    return int(match.group(1))


def main() -> None:
    manifest = json.loads((RUNS / "input_manifest.json").read_text(encoding="utf-8"))
    statuses = {item["variant"]: item for item in json.loads((RUNS / "synthesis_status.json").read_text(encoding="utf-8"))}
    entries = []
    for name in VARIANTS:
        folder = RUNS / name
        area_path = folder / "reports" / "gate.area"
        console_path = folder / "console.log"
        area = area_path.read_text(encoding="utf-8", errors="replace")
        console = console_path.read_text(encoding="utf-8", errors="replace")
        hdl_hash = manifest["variants"][name]["hdl_sha256"]
        if hdl_hash.upper() != statuses[name]["hdl_sha256"].upper():
            raise ValueError(f"HDL hash mismatch for {name}")
        if "SYNTHESIS_COMPLETE" not in console or not statuses[name]["area_report"]:
            raise ValueError(f"incomplete TD synthesis for {name}")
        entries.append(
            {
                "variant": name,
                "hdl_sha256": hdl_hash,
                "lut": capture(r"#Total_luts\s+(\d+)", area, "#Total_luts"),
                "ff": capture(r"#reg\s+(\d+)\s+out of", area, "#reg"),
                "carry_chain_packs": capture(r"Pack (\d+) carry chain into lslice", console, "carry chain pack count"),
                "dsp": capture(r"#dsp\s+(\d+)\s+out of", area, "#dsp"),
                "console_log": str(console_path.resolve()),
                "gate_area_report": str(area_path.resolve()),
                "gate_qor_report": str((folder / "td_project" / "gate.qor").resolve()),
                "return_code": statuses[name]["exit_code"],
            }
        )
    reference = entries[0]
    for item in entries:
        item["delta_vs_reference"] = {
            field: item[field] - reference[field]
            for field in ("lut", "ff", "carry_chain_packs", "dsp")
        }
        item["lut_plus_ff_delta"] = item["delta_vs_reference"]["lut"] + item["delta_vs_reference"]["ff"]
    result = {
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "tool": "Tang Dynasty 6.2.1_SP1_6.2.178.840",
        "device": manifest["device"],
        "clock_constraint_ns": manifest["clock_constraint_ns"],
        "scope": "standalone fat32_file_sector; optimize_rtl + optimize_gate -packarea",
        "place_route_or_bitstream": False,
        "source_path": manifest["source_path"],
        "source_sha256": manifest["source_sha256"],
        "variants": entries,
        "resource_note": "The top-level module exposes 262 IOs against the EG4S20BG256 package capacity of 188; these runs measure standalone mapped logic and do not include place-and-route feasibility.",
    }
    (RUNS / "synthesis_summary.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    with (RUNS / "synthesis_summary.csv").open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(
            stream,
            fieldnames=("variant", "lut", "ff", "carry_chain_packs", "dsp", "lut_plus_ff_delta", "hdl_sha256"),
        )
        writer.writeheader()
        writer.writerows(
            {key: item[key] for key in writer.fieldnames}
            for item in entries
        )
    print(f"Wrote {RUNS / 'synthesis_summary.json'} and synthesis_summary.csv")


if __name__ == "__main__":
    main()
