"""Collect immutable hashes and pass markers for the timer ablation tests."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
REF = HERE / "reference"
OPT = HERE / "timer_candidate"
MAIN = ROOT / "development/player_spectrum_resource_fit/src/user_source/hdl_source"
RUN = HERE / "run_20261020_210553_268"
TARGETS = {
    "tf_bmp_file_player.v",
    "fat32_file_sector.v",
    "SD/sd_card_bmp.v",
    "player_audio_probe.v",
}
TESTS = [
    "bmp_failure_detail_21",
    "tb_mapper_edges",
    "tb_mapper_long_equiv",
    "mapper_public",
    "key_debounce_audio_control",
    "audio_probe",
    "key_debounce_small_cycle_diff",
    "audio_blink_small_cycle_diff",
]


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    differences = []
    relative_files = sorted(path.relative_to(REF) for path in REF.rglob("*") if path.is_file())
    for relative in relative_files:
        before, after = REF / relative, OPT / relative
        before_hash, after_hash = sha(before), sha(after)
        if before_hash != after_hash:
            differences.append({
                "file": relative.as_posix(),
                "reference_sha256": before_hash,
                "timer_candidate_sha256": after_hash,
                "main_candidate_sha256": sha(MAIN / relative),
            })
    assert {row["file"] for row in differences} == TARGETS, differences

    tests = []
    for name in TESTS:
        rows = []
        for variant in ("reference", "timer_candidate"):
            log = RUN / f"{name}.{variant}.log"
            lines = log.read_text(encoding="utf-8", errors="replace").splitlines()
            assert lines, f"empty output for {name}/{variant}"
            rows.append({"path": str(log.resolve()), "sha256": sha(log), "lines": lines})
        assert rows[0]["lines"] == rows[1]["lines"], name
        tests.append({
            "name": name,
            "status": "PASS",
            "outputs_identical": True,
            "reference_log": rows[0]["path"],
            "candidate_log": rows[1]["path"],
        })

    proposal = ROOT / "development/resource_opt_work/timer_proposal.py"
    proof = HERE / "timer_range_proof.json"
    report = {
        "status": "PASS",
        "candidate_main_modified_by_this_agent": False,
        "td_run": False,
        "source_diff_files": differences,
        "source_diff_exactly_targeted_files": True,
        "proposal_script": str(proposal.resolve()),
        "proposal_sha256": sha(proposal),
        "proof_report": str(proof.resolve()),
        "proof_report_sha256": sha(proof),
        "estimated_default_ff_bit_reduction": 52,
        "td_area_measured": False,
        "public_tests": tests,
        "cycle_diff_tests": [
            "key debounce: 42 cycles, CLK_FREQ_HZ=1000, DEBOUNCE_MS=1 and 3",
            "audio blink: 25 cycles, PIXEL_HZ=8, five blink transitions",
        ],
        "parameter_elaboration": "PASS; zero/max/negative fallback and default-width examples are in tb_timer_param_elab.v and param_elab.compile.log",
        "final_run_directory": str(RUN.resolve()),
    }
    out = HERE / "timer_public_tb_results.json"
    out.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "status": report["status"],
        "changed": [row["file"] for row in differences],
        "tests": [row["name"] for row in tests],
        "estimated_ff_bits": 52,
        "result_file": str(out.resolve()),
    }, indent=2))


if __name__ == "__main__":
    main()
