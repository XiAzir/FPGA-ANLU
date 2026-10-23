"""Check the exact C27 -> C28 source delta after removing observation-only code."""
import difflib
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
BASE = ROOT / "development/player_video27_command_boundary/src/user_source"
CAND = ROOT / "development/player_video28_hdmi_observe/src/user_source"
OUT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tokens(text):
    text = re.sub(r"/\*.*?\*/|//[^\n]*", "", text, flags=re.S)
    return re.sub(r"\s+", "", text)


def control_text(name, text, candidate):
    if name == "top_tf_hdmi_audio.v":
        # This existing block only drives status-page inputs and samples buses.
        text, count = re.subn(
            r"// Passive board diagnostics\..*?(?=player_compact_status_pages)",
            "/* observation block */\n", text, flags=re.S,
        )
        assert count == 1
        if candidate:
            text = text.replace("wire [23:0] photo_progress;", "")
            text = text.replace("wire [31:0] hdmi_probe_page_e,hdmi_probe_page_f;", "")
            text = text.replace("wire hdmi_clock_bit_probe;", "")
            text = text.replace(
                ".O_tmds_clk_p       (HDMI_CLK_P),\n    .O_clock_bit_probe  (hdmi_clock_bit_probe)",
                ".O_tmds_clk_p       (HDMI_CLK_P)",
            )
            text = text.replace(
                ".failure_detail(photo_failure_detail),.debug_progress(photo_progress)",
                ".failure_detail(photo_failure_detail)",
            )
            text = text.replace(
                ".diag14(hdmi_probe_page_e),.diag15(hdmi_probe_page_f)",
                ".diag14(diag_sd_sync1),.diag15(diag_sd_sync1)",
            )
            text, count = re.subn(
                r"player_hdmi_runtime_probe u_hdmi_runtime_probe \(.*?\n\);",
                "", text, flags=re.S,
            )
            assert count == 1
    elif candidate and name == "tf_bmp_file_player.v":
        text = text.replace(
            "output wire [23:0] failure_detail,\n    output wire [23:0] debug_progress",
            "output wire [23:0] failure_detail",
        )
        text = text.replace(
            ".failure_code(scale_failure_code),\n    .debug_progress(debug_progress)",
            ".failure_code(scale_failure_code)",
        )
    elif candidate and name == "bmp_scale_engine.v":
        text = text.replace(
            "output reg [7:0] failure_code,\n    output wire [23:0] debug_progress",
            "output reg [7:0] failure_code",
        )
        for line in (
            "wire [9:0] debug_out_x=out_x;",
            "wire [8:0] debug_out_y=out_y;",
            "assign debug_progress={state,debug_out_y,debug_out_x};",
        ):
            text = text.replace(line, "")
    elif candidate and name == "player_compact_status_pages.v":
        text = text.replace("00C11328", "00C11327")
    elif candidate and name == "lane_lvds_10_1.v":
        text = text.replace("output wire     O_serial_out,\n    output wire     O_serial_bit_probe",
                            "output wire     O_serial_out")
        text = text.replace("assign O_serial_bit_probe=S_oddr_data[1];", "")
    elif candidate and name == "hdmi_phy_warpper.v":
        text = text.replace("output wire     O_tmds_clk_p,\n    output wire     O_clock_bit_probe",
                            "output wire     O_tmds_clk_p")
        text = text.replace(".O_serial_out ( O_tmds_clk_p    ),\n        .O_serial_bit_probe (O_clock_bit_probe)",
                            ".O_serial_out ( O_tmds_clk_p    )")
    return tokens(text)


allowed = {
    "top_tf_hdmi_audio.v", "tf_bmp_file_player.v",
    "bmp_scale_engine.v", "player_compact_status_pages.v",
    "lane_lvds_10_1.v", "hdmi_phy_warpper.v",
}
entries = []
changed = []
for path in sorted(p for p in BASE.rglob("*") if p.is_file()):
    rel = path.relative_to(BASE)
    candidate = CAND / rel
    assert candidate.is_file(), rel
    same = sha(path) == sha(candidate)
    if not same:
        assert path.name in allowed, rel
        a, b = path.read_text(encoding="utf-8"), candidate.read_text(encoding="utf-8")
        assert control_text(path.name, a, False) == control_text(path.name, b, True), rel
        changed.append(str(rel).replace("\\", "/"))
        (OUT / f"{path.name}.diff").write_text(
            "".join(difflib.unified_diff(a.splitlines(True), b.splitlines(True),
                                      fromfile=f"C27/{rel}", tofile=f"C28/{rel}")),
            encoding="utf-8",
        )
    entries.append(dict(path=str(rel).replace("\\", "/"),
                        baseline_sha256=sha(path), candidate_sha256=sha(candidate),
                        byte_identical=same))
added = [p.relative_to(CAND).as_posix() for p in CAND.rglob("*")
         if p.is_file() and not (BASE / p.relative_to(CAND)).exists()]
assert added == ["hdl_source/player_hdmi_runtime_probe.v"], added
assert len(changed) == 6, changed
receipt = dict(
    status="PASS", check="media/control tokens identical after explicit observation stripping",
    changed=changed, added=added,
    byte_identical_count=sum(e["byte_identical"] for e in entries), inputs=entries,
    limits=["Observation logic itself is verified by separate probe tests",
            "Token equivalence covers the declared production media/control scope",
            "Physical mapping and board output remain separate validation stages"],
)
(OUT / "passive_delta.json").write_text(json.dumps(receipt, indent=2), encoding="utf-8")
print(json.dumps({k: receipt[k] for k in ("status", "changed", "added", "byte_identical_count")}))
