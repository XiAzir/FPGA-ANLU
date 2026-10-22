from pathlib import Path
import json
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
PYTHON = sys.executable
RUNNER = HERE / "run.py"
COMPARATOR = HERE / "compare_exact.py"
ROOT = HERE.parents[3]
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
FIX = HERE / "fixtures"
SCENARIOS = [
    {"name":"q90_frame_000", "inputs":[FIX/"q90_frame_000.jpg"], "mode":0},
    {"name":"q90_frame_299", "inputs":[FIX/"q90_frame_299.jpg"], "mode":0},
    {"name":"q90_frame_000_299_serial", "inputs":[FIX/"q90_frame_000.jpg",FIX/"q90_frame_299.jpg"], "mode":0},
    {"name":"q90_frame_108_gap_bp", "inputs":[FIX/"q90_frame_108.jpg"], "mode":3,"gap":5,"seed":20261021},
    {"name":"q90_frame_108_abort_bp", "inputs":[FIX/"q90_frame_108.jpg"], "mode":2,"seed":20261022,"abort_bytes":20000},
]

def run(scenario, variant):
    label = scenario["name"]
    run_name = f"{variant}_{label}"
    cmd = [PYTHON, str(RUNNER), *(str(p) for p in scenario["inputs"]),
           "--core-dir", str(HERE / f"{variant}_src"), "--name", run_name,
           "--mode", str(scenario["mode"]), "--seed", str(scenario.get("seed", 72021))]
    if "gap" in scenario:
        cmd += ["--gap", str(scenario["gap"])]
    if "abort_bytes" in scenario:
        cmd += ["--abort-bytes", str(scenario["abort_bytes"])]
    out = subprocess.run(cmd, cwd=HERE, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=300)
    (HERE / "runs" / run_name / "matrix_console.log").write_text(out.stdout, encoding="utf-8")
    if out.returncode:
        raise RuntimeError(f"{run_name} failed; see runs/{run_name}/matrix_console.log\n{out.stdout[-1200:]}")
    return HERE / "runs" / run_name

def main():
    results=[]
    for scenario in SCENARIOS:
        start=time.time()
        print(f"START {scenario['name']}",flush=True)
        base=run(scenario,"baseline")
        candidate=run(scenario,"candidate")
        args=[PYTHON,str(COMPARATOR),str(base/"pixels_xy_rgb.bin"),str(candidate/"pixels_xy_rgb.bin")]
        pin=None
        if scenario["name"].startswith("q90_frame_108"):
            pin=HERE/"fixtures"/"pin_rgb_reference.mem"
            args += [str(pin),"1"]
        comparison=subprocess.run(args,cwd=HERE,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        (HERE/"runs"/scenario["name"]).mkdir(exist_ok=True)
        (HERE/"runs"/scenario["name"]/"comparison.json").write_text(comparison.stdout,encoding="utf-8")
        if comparison.returncode:
            raise RuntimeError(f"exact comparison failed: {scenario['name']}\n{comparison.stdout}")
        base_result=json.loads((base/"analysis.json").read_text(encoding="utf-8"))
        cand_result=json.loads((candidate/"analysis.json").read_text(encoding="utf-8"))
        row={"scenario":scenario["name"],"inputs":[str(p) for p in scenario["inputs"]],
             "mode":scenario["mode"],"gap":scenario.get("gap",0),"abort_bytes":scenario.get("abort_bytes",0),
             "baseline_cycles":int((base/"sim.log").read_text().split("cycles=")[1].split()[0]),
             "candidate_cycles":int((candidate/"sim.log").read_text().split("cycles=")[1].split()[0]),
             "baseline_pixel_record_sha256":base_result["pixel_record_sha256"],
             "candidate_pixel_record_sha256":cand_result["pixel_record_sha256"],
             "exact_comparison":True,"elapsed_seconds":round(time.time()-start,2),
             "baseline_run":str(base.relative_to(HERE)),"candidate_run":str(candidate.relative_to(HERE))}
        results.append(row)
        (HERE/"matrix_results.json").write_text(json.dumps(results,indent=2)+"\n",encoding="utf-8")
        print(json.dumps(row),flush=True)
    print("SHARED_IDCT_PIXEL_MATRIX_PASS",flush=True)

if __name__=="__main__":
    main()
