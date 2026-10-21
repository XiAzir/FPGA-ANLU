"""Summarize combined and combined-OR TD reports."""

from __future__ import annotations

import csv
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent / "or_ablation"


def num(pattern: str, text: str) -> int:
    match = re.search(pattern, text)
    if not match:
        raise ValueError(f"missing report field {pattern}")
    return int(match.group(1))


def main() -> None:
    manifest = json.loads((ROOT / "input_manifest.json").read_text(encoding="utf-8"))
    status = {x["variant"]: x for x in json.loads((ROOT / "synthesis_status.json").read_text(encoding="utf-8"))}
    rows = []
    for variant in ("combined", "combined_or"):
        folder = ROOT / variant
        area_path = folder / "reports" / "gate.area"
        console_path = folder / "console.log"
        area = area_path.read_text(encoding="utf-8", errors="replace")
        console = console_path.read_text(encoding="utf-8", errors="replace")
        info = manifest["variants"][variant]
        if info["hdl_sha256"].upper() != status[variant]["hdl_sha256"].upper():
            raise ValueError(f"HDL hash mismatch for {variant}")
        if "SYNTHESIS_COMPLETE" not in console:
            raise ValueError(f"incomplete synthesis for {variant}")
        rows.append(
            {
                "variant": variant,
                "hdl_sha256": info["hdl_sha256"],
                "sdc_sha256": info["sdc_sha256"],
                "lut": num(r"#Total_luts\s+(\d+)", area),
                "ff": num(r"#reg\s+(\d+)\s+out of", area),
                "carry_chain_packs": num(r"Pack (\d+) carry chain into lslice", console),
                "dsp": num(r"#dsp\s+(\d+)\s+out of", area),
                "console_log": str(console_path.resolve()),
                "gate_area_report": str(area_path.resolve()),
                "gate_qor_report": str((folder / "td_project" / "gate.qor").resolve()),
                "edge_diff_log": str(
                    (ROOT.parent.parent / "build" / "mapper_aligned" / "tb_mapper_aligned_edges_run.log").resolve()
                ),
                "long_diff_log": str(
                    (ROOT.parent.parent / "build" / "mapper_aligned" / "tb_mapper_aligned_long_run.log").resolve()
                ),
            }
        )
    baseline = rows[0]
    for row in rows:
        row["delta_vs_combined"] = {
            key: row[key] - baseline[key]
            for key in ("lut", "ff", "carry_chain_packs", "dsp")
        }
    result = {
        "tool": "Tang Dynasty 6.2.1_SP1_6.2.178.840",
        "device": manifest["device"],
        "clock_constraint_ns": manifest["clock_constraint_ns"],
        "scope": "standalone fat32_file_sector; optimize_rtl + optimize_gate -packarea",
        "place_route_or_bitstream": False,
        "source_path": manifest["source_path"],
        "source_sha256": manifest["source_sha256"],
        "variants": rows,
    }
    (ROOT / "or_ablation_summary.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    with (ROOT / "or_ablation_summary.csv").open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=("variant", "lut", "ff", "carry_chain_packs", "dsp", "hdl_sha256"))
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row[key] for key in writer.fieldnames})
    print(f"Wrote {ROOT / 'or_ablation_summary.json'} and .csv")


if __name__ == "__main__":
    main()
