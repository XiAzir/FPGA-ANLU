from __future__ import annotations

import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"


def main() -> None:
    run_dir = HERE / "runs/rgb565_stream_20261021_attempt03"
    run_dir.mkdir(parents=True, exist_ok=True)
    executable = run_dir / "simv.exe"
    compile_log = run_dir / "compile.log"
    sim_log = run_dir / "sim.log"
    tests = [
        ("tb_video_rgb565_stream", [HERE / "tb_video_rgb565_stream.sv",
                                     HERE / "video_rgb565_packer.v",
                                     HERE / "video_rgb565_unpacker.v"]),
        ("tb_video_rgb565_unpacker_rate", [HERE / "tb_video_rgb565_unpacker_rate.sv",
                                            HERE / "video_rgb565_unpacker.v"]),
    ]
    compile_entries = []
    sim_outputs = []
    for top, sources in tests:
        compiled = subprocess.run(
            [str(IVERILOG), "-g2012", "-s", top, "-o", str(executable),
             *(str(source) for source in sources)],
            text=True, capture_output=True,
        )
        compile_entries.append(f"[{top}]\n{compiled.stdout}{compiled.stderr}")
        compile_log.write_text("\n".join(compile_entries), encoding="utf-8")
        if compiled.returncode:
            raise SystemExit(f"Icarus compile failed for {top} ({compiled.returncode}); see {compile_log}")
        simulated = subprocess.run([str(VVP), str(executable)], text=True, capture_output=True, timeout=30)
        sim_outputs.append(f"[{top}]\n{simulated.stdout}{simulated.stderr}")
        sim_log.write_text("\n".join(sim_outputs), encoding="utf-8")
        print(simulated.stdout, end="")
        pass_token = "PASS rgb565_stream" if top == "tb_video_rgb565_stream" else "PASS rgb565_unpacker_rate"
        if simulated.returncode or pass_token not in simulated.stdout:
            raise SystemExit(f"RGB565 stream regression failed for {top} ({simulated.returncode}); see {sim_log}")
    result = {
        "status": "PASS",
        "pixels": 1024,
        "quantization": "RGB565 high-bit truncation with bit replication on expansion",
        "word_order": "pixel0 in word_data[15:0], pixel1 in word_data[31:16]",
        "coverage": "random source gaps and randomized output backpressure",
        "rate_test": "unpacker emits 512 pixels from 256 consecutive words with no output bubbles",
        "compile_log": str(compile_log),
        "sim_log": str(sim_log),
    }
    (run_dir / "result.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
