from __future__ import annotations

import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"


def main() -> None:
    run_dir = HERE / "runs/rgb565_normal_fifo_20261021_attempt02"
    run_dir.mkdir(parents=True, exist_ok=True)
    executable = run_dir / "simv.exe"
    compile_log = run_dir / "compile.log"
    sim_log = run_dir / "sim.log"
    sources = [HERE / "tb_rgb565_normal_fifo.sv", HERE / "rgb565_word_codec.v"]
    compiled = subprocess.run(
        [str(IVERILOG), "-g2012", "-s", "tb_rgb565_normal_fifo", "-o", str(executable),
         *(str(source) for source in sources)],
        text=True, capture_output=True,
    )
    compile_log.write_text(compiled.stdout + compiled.stderr, encoding="utf-8")
    if compiled.returncode:
        raise SystemExit(f"Icarus compile failed ({compiled.returncode}); see {compile_log}")
    simulated = subprocess.run([str(VVP), str(executable)], text=True, capture_output=True, timeout=30)
    sim_log.write_text(simulated.stdout + simulated.stderr, encoding="utf-8")
    print(simulated.stdout, end="")
    if simulated.returncode or "PASS rgb565_normal_fifo" not in simulated.stdout:
        raise SystemExit(f"normal FIFO regression failed ({simulated.returncode}); see {sim_log}")
    result = {
        "status": "PASS",
        "fifo_mode": "normal, non-showahead, read data one rising edge after pop",
        "packets": [128, 86, 64],
        "traffic": "continuous 1-pixel/clk write/read in packet 0; randomized source and read blank cycles in packets 1-2",
        "recovery": "multiple packet clears plus clear of a partial first pixel",
        "underflow": False,
        "compile_log": str(compile_log),
        "sim_log": str(sim_log),
    }
    (run_dir / "result.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
