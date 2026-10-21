#!/usr/bin/env python3
"""Negative controls for the C11318 595 clock/mailbox route-audit gates."""

from __future__ import annotations

import copy

from audit_clock_route import (
    Cell,
    detect_status_mode,
    legacy_mailbox_domain_check,
    mailbox_residual_check,
    segment_status_clock_check,
    status_mode_from_top_text,
    status_register_clock_check,
    status_source_binding_check,
)


EXPECTED = {"pixel": "video_pll_25m_gclk", "system": "sys_pll_50m_gclk"}
STATUS_FFS = [
    Cell("EG_PHY_LSLICE", f"u_status_hex/{reg}[0]", {},
         {"q": f"u_status_hex/{reg}[0]", "clk": EXPECTED["pixel"]})
    for reg in ("state", "slot_count", "frame_value", "shift_word", "digit_index", "half_count")
]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


require(mailbox_residual_check([])[0] == "PASS", "clean netlist must pass mailbox retirement")
require(status_register_clock_check(STATUS_FFS, EXPECTED)[0] == "PASS",
        "all 595 registers on the video clock must pass")
ACTIVE_MODE = detect_status_mode()
require(ACTIVE_MODE in ("video", "legacy"), "selected candidate must classify as one complete status architecture")
require(status_source_binding_check(ACTIVE_MODE)[0] == "PASS",
        "selected status architecture source/top/project/SDC/PLL/IP binding must pass")

video_top = """
wire status_clk = video_clk;
player_status_monitor u_status_monitor (.pixel_clk(video_clk), .sys_clk(status_clk));
status_hex595 #(.CLK_HZ(25000000)) u_status_hex (
  .clk(video_clk), .hex_value(status_hex));
"""
legacy_top = """
wire status_clk = video_clk;
player_status_monitor u_status_monitor (.pixel_clk(video_clk), .sys_clk(status_clk));
player_status_mailbox u_status_mailbox (.source_hex(status_hex), .destination_hex(status_hex_system));
status_hex595 #(.CLK_HZ(50000000)) u_status_hex (
  .clk(sd_card_clk), .hex_value(status_hex_system));
"""
require(status_mode_from_top_text(video_top) == "video", "25 MHz direct wiring selects video-domain audit mode")
require(status_mode_from_top_text(legacy_top) == "legacy", "50 MHz mailbox wiring selects legacy audit mode")
require(status_mode_from_top_text(video_top + " player_status_mailbox u_status_mailbox;") is None,
        "mixed direct/legacy wiring must fail architecture classification")

# Each scanner FF is tested separately so the gate cannot accidentally inspect
# only one representative register while another 595 register uses 50 MHz.
for index, cell in enumerate(STATUS_FFS):
    corrupted = copy.deepcopy(STATUS_FFS)
    corrupted[index].ports["clk"] = EXPECTED["system"]
    status, detail = status_register_clock_check(corrupted, EXPECTED)
    require(status == "FAIL", f"system-clock corruption escaped for {cell.name}: {detail}")

video_pad = Cell("EG_PHY_PAD", "seg7_sclk_pad", {}, {"osclk": EXPECTED["pixel"]})
system_pad = Cell("EG_PHY_PAD", "seg7_sclk_pad", {}, {"osclk": EXPECTED["system"]})
require(segment_status_clock_check("seg7_sclk", video_pad, EXPECTED, "video")[0] == "PASS",
        "video mode segment pad must use video GCLK")
require(segment_status_clock_check("seg7_sclk", system_pad, EXPECTED, "video")[0] == "FAIL",
        "video mode segment pad on system50 must fail")
require(segment_status_clock_check("seg7_sclk", system_pad, EXPECTED, "legacy")[0] == "PASS",
        "legacy mode segment pad must use system GCLK")
require(segment_status_clock_check("seg7_sclk", video_pad, EXPECTED, "legacy")[0] == "FAIL",
        "legacy mode segment pad on video25 must fail")

legacy_source = Cell("EG_PHY_LSLICE", r"u_status_mailbox/held_hex[0]", {},
                     {"q": r"u_status_mailbox/held_hex[0]", "clk": EXPECTED["pixel"]})
legacy_dest = Cell("EG_PHY_LSLICE", r"u_status_mailbox/destination_hex[0]", {},
                   {"q": r"u_status_mailbox/destination_hex[0]", "clk": EXPECTED["system"]})
require(legacy_mailbox_domain_check([legacy_source], EXPECTED, "source/video")[0] == "PASS",
        "legacy source mailbox FFs on video clock must pass")
require(legacy_mailbox_domain_check([legacy_dest], EXPECTED, "destination/system")[0] == "PASS",
        "legacy destination mailbox FFs on system clock must pass")
legacy_source_bad = copy.deepcopy(legacy_source)
legacy_source_bad.ports["clk"] = EXPECTED["system"]
require(legacy_mailbox_domain_check([legacy_source_bad], EXPECTED, "source/video")[0] == "FAIL",
        "legacy source mailbox FF on system clock must fail")
legacy_dest_bad = copy.deepcopy(legacy_dest)
legacy_dest_bad.ports["clk"] = EXPECTED["pixel"]
require(legacy_mailbox_domain_check([legacy_dest_bad], EXPECTED, "destination/system")[0] == "FAIL",
        "legacy destination mailbox FF on video clock must fail")

mailbox_ff = Cell(
    "EG_PHY_LSLICE",
    r"u_status_mailbox/held_hex[0]",
    {},
    {"q": r"u_status_mailbox/held_hex[0]", "clk": EXPECTED["pixel"]},
)
status, detail = mailbox_residual_check(STATUS_FFS + [mailbox_ff])
require(status == "FAIL" and "u_status_mailbox" in detail,
        "mailbox residual FF must fail retirement check")

mailbox_instance = Cell("EG_PHY_PAD", "u_status_mailbox/residual_instance", {}, {"opad": "unused"})
status, detail = mailbox_residual_check([mailbox_instance])
require(status == "FAIL", "mailbox instance without a Q port must fail retirement check")

require(status_register_clock_check([], EXPECTED)[0] == "FAIL",
        "missing scanner FF evidence must fail rather than reduce coverage")

print(f"PASS audit_clock_route controls: active={ACTIVE_MODE}; direct/legacy mode selection; each 595 FF on wrong clock=FAIL; PAD clock mode binding; mailbox retirement/domain negatives; source binding")
