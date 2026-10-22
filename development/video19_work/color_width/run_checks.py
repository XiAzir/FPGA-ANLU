from __future__ import annotations

import hashlib
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
PARENT = HERE / "parent/src_v"
CANDIDATE = HERE / "candidate/src_v"
ARITHMETIC = HERE / "arithmetic"
TB = ROOT / "development/video19_work/jpeg_unit/tb_jpeg_core.sv"
FIXTURE = ROOT / "development/video_codec_trial_20261021/decoder_fixture/frame_000.jpg"
BASELINE_PIXELS = ROOT / "development/video19_work/combined_area/C01/frame000/pixels.bin"
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def execute(command: list[str], cwd: Path, log_path: Path, timeout: int = 600) -> dict:
    result = subprocess.run(command, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            timeout=timeout, check=False)
    log_path.write_bytes(result.stdout)
    return {"command": command, "exit_code": result.returncode, "log": str(log_path)}


def run_arithmetic() -> dict:
    out = HERE / "arithmetic/run"
    out.mkdir(parents=True, exist_ok=True)
    exe = out / "simv"
    compile_result = execute([str(IVERILOG), "-g2012", "-s", "tb_color_mul_width", "-o", str(exe),
                              str(ARITHMETIC / "tb_color_mul_width.v")], out, out / "compile.log")
    if compile_result["exit_code"]:
        raise RuntimeError("arithmetic TB compile failed")
    run = execute([str(VVP), str(exe)], out, out / "run.log")
    log = (out / "run.log").read_text(encoding="utf-8", errors="replace")
    passed = run["exit_code"] == 0 and "COLOR_MUL_WIDTH_EXHAUSTIVE_PASS cr=131072 cb=131072" in log
    return {"status": "PASS" if passed else "FAILED", "compile": compile_result,
            "run": run, "checks": 262144, "log_text": log.strip()}


def run_pixels(name: str, source_dir: Path) -> dict:
    out = HERE / "runs" / name
    out.mkdir(parents=True, exist_ok=True)
    exe = out / "simv"
    sources = sorted(source_dir.glob("*.v"))
    compile_result = execute([str(IVERILOG), "-g2012", "-s", "tb_jpeg_core", "-o", str(exe),
                              str(TB), *map(str, sources)], out, out / "compile.log")
    if compile_result["exit_code"]:
        raise RuntimeError(f"{name} core compile failed")
    pixels = out / "pixels.bin"
    sim_log = out / "sim.log"
    run = execute([str(VVP), str(exe), f"+JPEG={FIXTURE}", f"+OUT={pixels}", f"+LOG={sim_log}",
                   "+MODE=2", "+GAP=0", "+SEED=1003", "+FRAMES=1", "+ABORT_BYTES=0",
                   "+PAUSE_AFTER_BYTES=0", "+WIDTH=640", "+HEIGHT=480"],
                  out, out / "console.log")
    detail = sim_log.read_text(encoding="utf-8", errors="replace") if sim_log.exists() else ""
    match = re.search(r"RESULT .*pixels=(\d+) .*stalls=(\d+) hold_errors=(\d+) duplicate_coords=(\d+) bad_coords=(\d+)", detail)
    return {"compile": compile_result, "run": run, "pixels_sha256": sha(pixels) if pixels.exists() else None,
            "bytes": pixels.stat().st_size if pixels.exists() else 0,
            "metrics": dict(zip(("pixels", "stalls", "hold_errors", "duplicate_coords", "bad_coords"),
                                map(int, match.groups()))) if match else None,
            "sim_log": str(out / "console.log")}


def main() -> None:
    files = sorted(PARENT.glob("*.v"))
    parent_sha = {path.name: sha(path) for path in files}
    candidate_sha = {path.name: sha(path) for path in sorted(CANDIDATE.glob("*.v"))}
    changed = [name for name in parent_sha if parent_sha[name] != candidate_sha.get(name)]
    if changed != ["jpeg_output.v"]:
        raise RuntimeError(f"unexpected candidate source delta: {changed}")

    arithmetic = run_arithmetic()
    parent = run_pixels("parent_frame000_random_bp", PARENT)
    candidate = run_pixels("candidate_frame000_random_bp", CANDIDATE)
    baseline_hash = sha(BASELINE_PIXELS)
    pixel_pass = (parent["run"]["exit_code"] == 0 and candidate["run"]["exit_code"] == 0 and
                  parent["pixels_sha256"] == candidate["pixels_sha256"] == baseline_hash and
                  parent["bytes"] == candidate["bytes"] == 307200 * 7 and
                  parent["metrics"] and candidate["metrics"] and
                  all(run["metrics"]["pixels"] == 307200 and run["metrics"]["stalls"] > 0 and
                      run["metrics"]["hold_errors"] == 0 and run["metrics"]["duplicate_coords"] == 0 and
                      run["metrics"]["bad_coords"] == 0 for run in (parent, candidate)))
    summary = {"status": "PASS" if arithmetic["status"] == "PASS" and pixel_pass else "FAILED",
               "parent": str(PARENT), "candidate": str(CANDIDATE), "parent_sources_sha256": parent_sha,
               "candidate_sources_sha256": candidate_sha, "changed_sources": changed,
               "arithmetic": arithmetic, "pixels": {"status": "PASS" if pixel_pass else "FAILED",
                   "parent": parent, "candidate": candidate, "C01_reference_sha256": baseline_hash,
                   "C02_parent_sha256": parent["pixels_sha256"]}}
    (HERE / "verification_summary.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(summary, indent=2))
    if summary["status"] != "PASS":
        raise SystemExit(2)


if __name__ == "__main__":
    main()
