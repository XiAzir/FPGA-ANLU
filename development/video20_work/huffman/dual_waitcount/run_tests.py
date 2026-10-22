from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
TESTS = ROOT / "tests"
TESTS.mkdir(exist_ok=True)
CASES = [
    ("stream", "tb_fat32_dual_file_sector.v", "tb_fat32_dual_file_sector"),
    ("timeout", "tb_fat32_dual_timeout.v", "tb_fat32_dual_timeout"),
    ("disable_drain", "tb_fat32_dual_disable_drain.v", "tb_fat32_dual_disable_drain"),
    ("peer_timeout_race", "tb_cidle_peer_timeout_race.v", "tb_cidle_peer_timeout_race"),
    ("natural_timeout", "tb_cidle_timeout_natural.v", "tb_cidle_timeout_natural"),
]

def run(case_name, tb_path, top, source, variant, iv, vvp):
    outdir = TESTS / f"{case_name}_{variant}"
    outdir.mkdir(exist_ok=True)
    image = outdir / "sim.vvp"
    log = outdir / "sim.log"
    comp = subprocess.run([iv, "-g2012", "-s", top, "-o", str(image), str(tb_path), str(source)], capture_output=True, text=True)
    if comp.returncode:
        log.write_text(comp.stdout + comp.stderr, encoding="utf-8")
        raise RuntimeError(f"compile failed: {case_name}/{variant}; see {log}")
    sim = subprocess.run([vvp, str(image)], capture_output=True, text=True)
    output = sim.stdout + sim.stderr
    log.write_text(output, encoding="utf-8")
    if sim.returncode:
        raise RuntimeError(f"simulation failed: {case_name}/{variant}; see {log}\n{output[-800:]}")
    return output

def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: run_tests.py <iverilog.exe> <vvp.exe>")
    iv, vvp = sys.argv[1:]
    outputs = {}
    for case_name, filename, top in CASES:
        tb = ROOT / filename
        for variant in ("baseline", "candidate"):
            outputs[(case_name, variant)] = run(case_name, tb, top, ROOT / variant / "fat32_dual_file_sector.v", variant, iv, vvp)
        if outputs[(case_name, "baseline")] != outputs[(case_name, "candidate")]:
            raise RuntimeError(f"simulation output differs: {case_name}")

    template = (ROOT / "tb_fat32_dual_file_sector.v").read_text(encoding="utf-8")
    needle = "fat32_dual_file_sector #(.WAIT_LIMIT(2000),.AUDIO_BURST_MAX(2)) dut("
    if template.count(needle) != 1:
        raise RuntimeError("main stream TB parameterization needle is not unique")
    mode_results = []
    for stable in (0, 1):
        for wav_static in (0, 1):
            tb = TESTS / f"stream_mode_{stable}{wav_static}.v"
            source = template.replace(needle, f"fat32_dual_file_sector #(.WAIT_LIMIT(2000),.AUDIO_BURST_MAX(2),.REQUEST_STABLE({stable}),.WAV_STATIC_FILE({wav_static})) dut(")
            tb.write_text(source, encoding="utf-8")
            ref = run(f"stream_mode_{stable}{wav_static}", tb, "tb_fat32_dual_file_sector", ROOT / "baseline/fat32_dual_file_sector.v", "baseline", iv, vvp)
            cand = run(f"stream_mode_{stable}{wav_static}", tb, "tb_fat32_dual_file_sector", ROOT / "candidate/fat32_dual_file_sector.v", "candidate", iv, vvp)
            if ref != cand:
                raise RuntimeError(f"parameter-mode simulation output differs: stable={stable}, wav_static={wav_static}")
            mode_results.append({"REQUEST_STABLE": stable, "WAV_STATIC_FILE": wav_static, "pass_message": "PASS shared mapper, 2-sector WAV burst cap, independent walk contexts" in cand})

    width_results = []
    for limit, expected in ((0, 32), (1, 1), (2, 1), (50000000, 26), (4294967295, 32)):
        for variant, want in (("baseline", 32), ("candidate", expected)):
            image = TESTS / f"width_{limit}_{variant}.vvp"
            comp = subprocess.run([iv, "-g2012", "-s", "tb_waitcount_width", f"-Ptb_waitcount_width.LIMIT={limit}", "-o", str(image), str(ROOT / "tb_waitcount_width.v"), str(ROOT / variant / "fat32_dual_file_sector.v")], capture_output=True, text=True)
            if comp.returncode:
                raise RuntimeError(f"wait width compile failed: limit={limit}/{variant}\n{comp.stdout}{comp.stderr}")
            sim = subprocess.run([vvp, str(image)], capture_output=True, text=True)
            output = sim.stdout + sim.stderr
            (TESTS / f"width_{limit}_{variant}.log").write_text(output, encoding="utf-8")
            match = re.search(r"WAIT_COUNT_BITS=(\d+)", output)
            if sim.returncode or not match or int(match.group(1)) != want:
                raise RuntimeError(f"wait width mismatch: limit={limit} variant={variant} expected={want}; output={output}")
        width_results.append({"WAIT_LIMIT": limit, "baseline_bits": 32, "candidate_bits": expected})

    manifest = {
        "cases": [{"name": name, "sha256": hashlib.sha256(outputs[(name, "baseline")].encode()).hexdigest(), "baseline_candidate_identical": outputs[(name, "baseline")] == outputs[(name, "candidate")]} for name, _, _ in CASES],
        "parameter_modes": mode_results,
        "wait_limit_widths": width_results,
    }
    (TESTS / "result.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest, indent=2))

if __name__ == "__main__":
    main()
