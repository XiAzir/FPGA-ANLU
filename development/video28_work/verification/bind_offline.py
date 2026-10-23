"""Bind C28's observation checks to the exact current source files."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
WORK = ROOT / "development/video28_work"
CAND = ROOT / "development/player_video28_hdmi_observe"
BASE = ROOT / "development/player_video27_command_boundary"


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def read(p):
    return json.loads(p.read_text(encoding="utf-8-sig"))


delta = read(WORK / "verification/passive_delta.json")
assert delta["status"] == "PASS"
for item in delta["inputs"]:
    assert sha(CAND / "src/user_source" / item["path"]) == item["candidate_sha256"]
    assert sha(BASE / "src/user_source" / item["path"]) == item["baseline_sha256"]

parent = read(BASE / "verification/final_binding.json")
for item in parent["offline_tests"]["inputs"]:
    assert sha(BASE / "src/user_source" / item["path"]) == item["candidate_sha256"]
assert sha(ROOT / "download/video27_command_boundary.bit") == parent["bit_sha256"]

photo = read(WORK / "photo_regression/summary.json")
assert len(photo["comparisons"]) == 2
assert all(item["match"] for item in photo["comparisons"])
for key, directory in (("c27", BASE), ("c28", CAND)):
    for field, name in (("tf_sha256", "tf_bmp_file_player.v"), ("scaler_sha256", "bmp_scale_engine.v")):
        assert sha(directory / "src/user_source/hdl_source" / name) == photo["source"][key][field]
for case in photo["cases"]:
    assert case["writes"] == 307200
    if case["width"] == 640:
        assert case["reads"] == 1802 and case["file_size"] == 921654

phy = read(WORK / "monitor_module/phy_probe_summary.json")
assert phy["status"] == "PASS" and len(phy["clock_word_tests"]) == 2
for test in phy["clock_word_tests"]:
    assert test["healthy_case_count"] == 192
    assert test["negative_control_case_count"] == 3
    assert test["receiver_data_errors"] == 0
    assert test["negative_control_data_errors_per_epoch"] == 1
    assert test["clock_delta_min"] == test["clock_delta_max"] == 256
for name in ("player_hdmi_runtime_probe.v", "lane_lvds_10_1.v", "hdmi_phy_warpper.v"):
    assert sha(CAND / "src/user_source/hdl_source" / name) == phy["sha256"][name]
for name in ("tb_phy_probe_matrix.sv", "run_phy_probe_matrix.ps1"):
    assert sha(WORK / "monitor_module" / name) == phy["sha256"][name]

unit = (WORK / "verification/probe_unit_run.log").read_text(encoding="utf-8")
assert "HDMI_PROBE_PASS" in unit and "lines_checked=480" in unit
assert "COLD_RESET_PASS" in unit and "delta=256" in unit
assert "FATAL" not in unit

evidence = [
    WORK / "verification/check_passive_delta.py",
    WORK / "verification/passive_delta.json",
    WORK / "verification/bind_offline.py",
    WORK / "verification/probe_unit_compile.log",
    WORK / "verification/probe_unit_run.log",
    WORK / "monitor_module/tb_player_hdmi_runtime_probe.v",
    WORK / "monitor_module/phy_probe_summary.json",
    WORK / "monitor_module/compile.log",
    WORK / "monitor_module/run_3e0.log",
    WORK / "monitor_module/run_01f.log",
    WORK / "photo_regression/summary.json",
    WORK / "photo_regression/tb_photo_regression.v",
    WORK / "photo_regression/run_photo_regression.ps1",
]
evidence += list((WORK / "photo_regression").glob("C2?-*.log"))
result = dict(
    status="PASS", build_id="00C11328", purpose="Passive HDMI/photo observability",
    parent_c27_preserved=True,
    production_delta=dict(changed=delta["changed"], added=delta["added"],
                          byte_identical=delta["byte_identical_count"],
                          observation_stripped_control_tokens="IDENTICAL"),
    photo=photo, phy=phy,
    probe_unit=dict(status="PASS", compiled_source_sha256=sha(CAND / "src/user_source/hdl_source/player_hdmi_runtime_probe.v"),
                    cases=["480-line SOF accounting", "media/cold reset", "lock loss sticky",
                           "ready/de sticky", "clock data stop/restart", "serial clock stop/restart"]),
    evidence=[dict(path=p.relative_to(ROOT).as_posix(), sha256=sha(p)) for p in evidence],
    outstanding=["C28 board test", "Physical HDMI clock/data/receiver state",
                 "Actual TF photo geometry remains unconfirmed",
                 "No C28 full-system or SDF regression; unchanged media control covered by source delta and focused differential tests"],
)
(CAND / "verification/offline_tests.json").write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
print(json.dumps(dict(status="PASS", healthy_phy_cases=384, negative_phy_cases=6,
                      photo_runs=4, unchanged_user_sources=delta["byte_identical_count"])))
