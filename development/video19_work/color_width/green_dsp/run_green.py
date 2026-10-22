from __future__ import annotations

import hashlib
import json
import re
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = Path(__file__).resolve().parents[4]
PARENT = HERE.parent / "parent/src_v"
CANDIDATE = HERE / "src_v"
TB_ARITH = HERE / "arithmetic/tb_green_mul_width.v"
TB_CORE = ROOT / "development/video19_work/jpeg_unit/tb_jpeg_core.sv"
FIXTURE = ROOT / "development/video_codec_trial_20261021/decoder_fixture/frame_000.jpg"
REFERENCE = ROOT / "development/video19_work/combined_area/C01/frame000/pixels.bin"
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(command: list[str], cwd: Path, log: Path, timeout: int = 600) -> dict:
    result = subprocess.run(command, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            timeout=timeout, check=False)
    log.write_bytes(result.stdout)
    return {"command": command, "exit_code": result.returncode, "log": str(log)}


def arithmetic() -> dict:
    out = HERE / "arithmetic/run"
    out.mkdir(parents=True, exist_ok=True)
    exe = out / "simv"
    compile_result = run([str(IVERILOG), "-g2012", "-s", "tb_green_mul_width", "-o", str(exe), str(TB_ARITH)],
                         out, out / "compile.log")
    if compile_result["exit_code"]:
        raise RuntimeError("green arithmetic TB compile failed")
    execution = run([str(VVP), str(exe)], out, out / "run.log")
    text = (out / "run.log").read_text(encoding="utf-8", errors="replace")
    passed = execution["exit_code"] == 0 and "GREEN_MUL_WIDTH_EXHAUSTIVE_PASS 2925=131072 1410=131072" in text
    return {"status": "PASS" if passed else "FAILED", "checks": 262144,
            "compile": compile_result, "run": execution, "log_text": text.strip()}


def pixels(label: str, sources: Path) -> dict:
    out = HERE / "runs" / label
    out.mkdir(parents=True, exist_ok=True)
    exe = out / "simv"
    files = sorted(sources.glob("*.v"))
    compile_result = run([str(IVERILOG), "-g2012", "-s", "tb_jpeg_core", "-o", str(exe),
                          str(TB_CORE), *map(str, files)], out, out / "compile.log")
    if compile_result["exit_code"]:
        raise RuntimeError(f"{label} core compile failed")
    pixels_path = out / "pixels.bin"
    sim_log = out / "sim.log"
    execution = run([str(VVP), str(exe), f"+JPEG={FIXTURE}", f"+OUT={pixels_path}", f"+LOG={sim_log}",
                     "+MODE=2", "+GAP=0", "+SEED=1003", "+FRAMES=1", "+ABORT_BYTES=0",
                     "+PAUSE_AFTER_BYTES=0", "+WIDTH=640", "+HEIGHT=480"], out, out / "console.log")
    detail = sim_log.read_text(encoding="utf-8", errors="replace") if sim_log.exists() else ""
    match = re.search(r"RESULT .*pixels=(\d+) .*stalls=(\d+) hold_errors=(\d+) duplicate_coords=(\d+) bad_coords=(\d+)", detail)
    return {"compile": compile_result, "run": execution,
            "sha256": sha(pixels_path) if pixels_path.exists() else None,
            "bytes": pixels_path.stat().st_size if pixels_path.exists() else 0,
            "metrics": dict(zip(("pixels", "stalls", "hold_errors", "duplicate_coords", "bad_coords"),
                                map(int, match.groups()))) if match else None,
            "console": str(out / "console.log")}


def main() -> None:
    parent_hashes = {p.name: sha(p) for p in sorted(PARENT.glob("*.v"))}
    candidate_hashes = {p.name: sha(p) for p in sorted(CANDIDATE.glob("*.v"))}
    changed = [name for name in parent_hashes if parent_hashes[name] != candidate_hashes.get(name)]
    if changed != ["jpeg_output.v"]:
        raise RuntimeError(f"unexpected green candidate source delta: {changed}")
    math_result = arithmetic()
    parent = pixels("parent_frame000_random_bp", PARENT)
    candidate = pixels("candidate_frame000_random_bp", CANDIDATE)
    reference_hash = sha(REFERENCE)
    exact = (parent["run"]["exit_code"] == candidate["run"]["exit_code"] == 0 and
             parent["sha256"] == candidate["sha256"] == reference_hash and
             parent["bytes"] == candidate["bytes"] == 307200 * 7 and
             parent["metrics"] and candidate["metrics"] and
             all(row["metrics"]["pixels"] == 307200 and row["metrics"]["stalls"] > 0 and
                 row["metrics"]["hold_errors"] == row["metrics"]["duplicate_coords"] ==
                 row["metrics"]["bad_coords"] == 0 for row in (parent, candidate)))
    summary = {"status": "PASS" if math_result["status"] == "PASS" and exact else "FAILED",
               "parent_sources_sha256": parent_hashes, "candidate_sources_sha256": candidate_hashes,
               "changed_sources": changed, "arithmetic": math_result,
               "pixels": {"status": "PASS" if exact else "FAILED", "parent": parent,
                          "candidate": candidate, "C02_current_exact_reference_sha256": reference_hash}}
    (HERE / "verification_summary.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(summary, indent=2))
    if summary["status"] != "PASS":
        raise SystemExit(2)


if __name__ == "__main__":
    main()
