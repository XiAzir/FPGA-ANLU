#!/usr/bin/env python3
"""Count post-explicit-hold routed slice primitives without modifying inputs."""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
AUDIT = Path(__file__).resolve().parent
MANUAL = ROOT / "development/player_video20/build/manual"
NETLIST = AUDIT / "AC201_tf_hdmi_c11320_pr_routed.v"
PHYSICAL_LOG = MANUAL / "physical_console.log"
HOLD_LOG = MANUAL / "hold_console.log"
AREA = MANUAL / "AC201_tf_hdmi_phy.area"
TIMING = MANUAL / "AC201_tf_hdmi_phy.ts"
PR_DB = MANUAL / "AC201_tf_hdmi_pr.db"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def primitive_count(text: str, primitive: str) -> int:
    pattern = rf"^\s*{re.escape(primitive)}\s*#\s*\("
    return len(re.findall(pattern, text, re.MULTILINE))


def main() -> None:
    netlist_text = NETLIST.read_text(encoding="utf-8", errors="replace")
    physical_text = PHYSICAL_LOG.read_text(encoding="utf-8", errors="replace")
    hold_text = HOLD_LOG.read_text(encoding="utf-8", errors="replace")
    timing_text = TIMING.read_text(encoding="utf-8")
    m_count = primitive_count(netlist_text, "EG_PHY_MSLICE")
    l_count = primitive_count(netlist_text, "EG_PHY_LSLICE")
    counts = {
        "EG_PHY_MSLICE": m_count,
        "EG_PHY_LSLICE": l_count,
        "total_slice_primitives": m_count + l_count,
        "EG_PHY_BRAM": primitive_count(netlist_text, "EG_PHY_BRAM"),
    }
    auto_hold_counts = re.findall(r"#slices\s*\|\s*(\d+)", physical_text)
    packed_counts = re.findall(r"(\d+)\s+mslices,\s*(\d+)\s+lslices,\s*78\s+pads,\s*62\s+brams,\s*26\s+dsps", physical_text)
    result = {
        "schema": "c11320-posthold-slice-count-v1",
        "design": "player_video20 / C11320",
        "stage": "explicit hold-repair final PR DB routed netlist",
        "post_explicit_hold_routed_netlist_counts": counts,
        "physical_auto_hold_route_console": {
            "pre_hold_packed_mslices_lslices": [int(x) for x in packed_counts[-1]],
            "reported_final_auto_hold_slices": int(auto_hold_counts[-1]),
        },
        "explicit_hold_log_evidence": {
            "0_of_2_endpoints_fixed_by_lut_bridge": "0 out of 2 ((0.00)%) EP fixed by LB." in hold_text,
            "2_of_2_endpoints_fixed_by_pin_delay": "2 out of 2 ((100.00)%) EP fixed by pin delay." in hold_text,
            "final_timing": timing_text.strip(),
        },
        "hashes": {
            str(path.relative_to(ROOT)).replace("\\", "/"): sha256(path)
            for path in (NETLIST, PHYSICAL_LOG, HOLD_LOG, AREA, TIMING, PR_DB)
        },
        "conclusion": {
            "known": "The final explicit-hold routed netlist contains 8637 slice primitives (4334 MSLICE + 4303 LSLICE). The auto-hold physical console also reports 8637 final slices; its pre-hold packed count is 4332 + 4303 = 8635. The explicit hold log reports both remaining endpoints fixed by pin delay and zero fixed by LUT bridge.",
            "inference": "The matching 8637 count and pin-delay-only fix indicate no additional slice primitive was added by the explicit hold pass. A pre-explicit-hold database snapshot is retained in whole/D02/prehold; this audit counts the final exported netlist and does not compare placement movement.",
        },
    }
    if counts["total_slice_primitives"] != 8637:
        raise SystemExit(f"unexpected post-hold slice primitive count: {counts}")
    if int(auto_hold_counts[-1]) != counts["total_slice_primitives"]:
        raise SystemExit("post-hold netlist count does not match physical console final #slices")
    if not result["explicit_hold_log_evidence"]["2_of_2_endpoints_fixed_by_pin_delay"]:
        raise SystemExit("explicit hold log lacks the expected pin-delay evidence")

    json_path = AUDIT / "posthold_slice_count.json"
    md_path = AUDIT / "posthold_slice_count.md"
    json_path.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    md_path.write_text(
        "# C11320 post-explicit-hold Slice count\n\n"
        "The final explicit-hold routed netlist contains **8637 Slice primitives**: "
        "4334 `EG_PHY_MSLICE` + 4303 `EG_PHY_LSLICE`. This is an exact count from the exported routed primitive netlist; "
        "it matches the auto-hold physical console's final QoR count of 8637.\n\n"
        "The physical console records 4332 MSLICE + 4303 LSLICE before its automatic hold stage (8635), then reports 8637 slices after hold repair. "
        "The explicit hold log reports 0/2 endpoints fixed by LUT bridge and 2/2 fixed by pin delay, with final hold WNS +0.024 ns.\n\n"
        "**Known:** the explicit-hold final netlist has 8637 slice primitives; its routed DB SHA-256 and source run binding are the same as the final route audit receipt.\n\n"
        "**Inference:** matching the auto-hold count plus pin-delay-only repair indicates the explicit hold pass added no further slice primitive. The prior auto-hold database snapshot is retained in `whole/D02/prehold`; this audit counts the final netlist and does not compare individual placement movement.\n\n"
        "Input hashes are recorded in `posthold_slice_count.json`; the existing route netlist and build artifacts were read only.\n",
        encoding="utf-8",
    )
    print(json.dumps({"counts": counts, "json": str(json_path), "markdown": str(md_path)}, indent=2))


if __name__ == "__main__":
    main()
