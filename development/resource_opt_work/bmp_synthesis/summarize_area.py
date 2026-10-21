"""Extract pack-area resource fields from completed BMP standalone runs."""
from __future__ import annotations

import json
import re
from pathlib import Path
import sys


def parse_area(path: Path) -> dict[str, int]:
    text = path.read_text(encoding="utf-8", errors="replace")

    def number(pattern: str) -> int:
        match = re.search(pattern, text, re.I)
        if not match:
            raise ValueError(f"resource field missing in {path}: {pattern}")
        return int(match.group(1))

    row = re.search(
        r"\|\s*top\s*\|[^|]+\|\s*(\d+)\s*\|\s*(\d+)\s*\|"
        r"\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|",
        text,
        re.I,
    )
    return {
        "generic_luts": number(r"#Total_luts\s+(\d+)"),
        "device_lut": number(r"#lut\s+(\d+)\s+out of"),
        "device_reg": number(r"#reg\s+(\d+)\s+out of"),
        "ripple_carry": int(row.group(2)) if row else number(r"#carry\s+(\d+)"),
        "hierarchy_seq_including_pad_registers": int(row.group(3)) if row else -1,
        "hierarchy_luts": int(row.group(1)) if row else -1,
        "bram": int(row.group(4)) if row else number(r"#bram\s+(\d+)\s+out of"),
        "dsp": int(row.group(5)) if row else number(r"#dsp\s+(\d+)\s+out of"),
    }


def main() -> None:
    root = Path(sys.argv[1]).resolve()
    status_path = root / "synthesis_status.json"
    raw_status = json.loads(status_path.read_text(encoding="utf-8-sig"))
    variants = raw_status["variants"] if isinstance(raw_status, dict) else raw_status
    manifest = json.loads((root / "input_manifest.json").read_text(encoding="utf-8-sig"))
    for item in variants:
        area = root / item["variant"] / "reports/gate.area"
        item["resources"] = parse_area(area)
        item["gate_area_sha256"] = __import__("hashlib").sha256(area.read_bytes()).hexdigest()
    reference = next(item["resources"] for item in variants if item["variant"] == "reference")
    metric_names = ("generic_luts", "device_lut", "device_reg", "ripple_carry",
                    "hierarchy_luts", "hierarchy_seq_including_pad_registers",
                    "bram", "dsp")
    baselines = {"width32": "reference", "width19": "reference",
                 "loader_diag_direct": "loader_reference"}
    resources_by_variant = {item["variant"]: item["resources"] for item in variants}
    status = {
        "status": "PASS",
        "device": manifest["device"],
        "clock_constraint_ns": manifest["clock_constraint_ns"],
        "source_sha256": manifest["top_source_sha256"],
        "proposal_sha256": manifest["proposal_sha256"],
        "variants": variants,
        "resource_summary": {
            "reference": reference,
            "by_variant": resources_by_variant,
            "baseline_by_variant": baselines,
            "delta_vs_baseline": {
                variant: {key: resources_by_variant[variant][key]-resources_by_variant[base][key]
                          for key in metric_names}
                for variant, base in baselines.items()
            },
        },
    }
    status_path.write_text(json.dumps(status, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(status["resource_summary"], indent=2))


if __name__ == "__main__":
    main()
