from __future__ import annotations

import argparse
import hashlib
import json
import math
import struct
import subprocess
from pathlib import Path



HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
CORE = ROOT / "development/video19_work/vendor/core_jpeg/src_v"
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"
RECORD = struct.Struct("<HHBBB")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as src:
        for block in iter(lambda: src.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("jpeg", type=Path, nargs="+")
    ap.add_argument("--mode", type=int, choices=[0, 1, 2, 3], default=0,
                    help="0=no backpressure, 1=input gaps, 2=random output backpressure, 3=both")
    ap.add_argument("--gap", type=int, default=0)
    ap.add_argument("--seed", type=int, default=0x13579BDF)
    ap.add_argument("--name", default=None)
    ap.add_argument("--abort-bytes", type=int, default=0)
    ap.add_argument("--core-dir", type=Path, default=CORE,
                    help="directory containing the complete jpeg_core Verilog source set")
    ap.add_argument("--width", type=int, default=640)
    ap.add_argument("--height", type=int, default=480)
    args = ap.parse_args()
    jpeg_paths = [p.resolve() for p in args.jpeg]
    core_dir = args.core_dir.resolve()
    sources = sorted(core_dir.glob("*.v"))
    if not sources:
        raise SystemExit(f"no Verilog sources found in {core_dir}")
    run_name = args.name or (jpeg_paths[0].stem + ("_" + jpeg_paths[1].stem if len(jpeg_paths) > 1 else ""))
    out_dir = HERE / "runs" / run_name
    out_dir.mkdir(parents=True, exist_ok=True)
    input_path = jpeg_paths[0]
    pause_after = 0
    if len(jpeg_paths) > 1:
        input_path = out_dir / "input_concatenated.mjpg"
        input_path.write_bytes(b"".join(p.read_bytes() for p in jpeg_paths))
        pause_after = input_path.stat().st_size - jpeg_paths[-1].stat().st_size
    exe = out_dir / "simv"
    pixels = out_dir / "pixels_xy_rgb.bin"
    log = out_dir / "sim.log"
    compile_cmd = [str(IVERILOG), "-g2012", "-s", "tb_jpeg_core", "-o", str(exe),
                   str(HERE / "tb_jpeg_core.sv"), *(str(p) for p in sources)]
    manifest = {
        "core_dir": str(core_dir),
        "core_sources": [{"path": str(p), "sha256": sha256(p)} for p in sources],
        "testbench": {"path": str(HERE / "tb_jpeg_core.sv"), "sha256": sha256(HERE / "tb_jpeg_core.sv")},
        "fixtures": [{"path": str(p), "bytes": p.stat().st_size, "sha256": sha256(p)} for p in jpeg_paths],
        "mode": args.mode, "gap": args.gap, "seed": args.seed,
        "abort_bytes": args.abort_bytes, "iverilog": str(IVERILOG), "vvp": str(VVP),
    }
    (out_dir / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    comp = subprocess.run(compile_cmd, text=True, capture_output=True)
    (out_dir / "compile.log").write_text(comp.stdout + comp.stderr, encoding="utf-8")
    if comp.returncode:
        raise SystemExit(f"Icarus compile failed ({comp.returncode}); see {out_dir / 'compile.log'}")
    sim_cmd = [str(VVP), str(exe), f"+JPEG={input_path}", f"+OUT={pixels}", f"+LOG={log}",
               f"+MODE={args.mode}", f"+GAP={args.gap}", f"+SEED={args.seed}",
               f"+FRAMES={len(jpeg_paths)}", f"+ABORT_BYTES={args.abort_bytes}",
               f"+PAUSE_AFTER_BYTES={pause_after}", f"+WIDTH={args.width}", f"+HEIGHT={args.height}"]
    sim = subprocess.Popen(sim_cmd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    try:
        sim_output, _ = sim.communicate(timeout=240)
    except subprocess.TimeoutExpired:
        sim.kill()
        sim_output, _ = sim.communicate()
        (out_dir / "console.log").write_text(sim_output + "\nTIMEOUT: vvp terminated at 240 seconds.\n", encoding="utf-8")
        raise SystemExit(f"simulation timeout after 240 seconds; see {out_dir / 'console.log'}")
    (out_dir / "console.log").write_text(sim_output, encoding="utf-8")
    print(sim_output, end="")
    if sim.returncode:
        raise SystemExit(f"simulation failed ({sim.returncode}); see {out_dir / 'console.log'}")
    result = {"fixtures": [str(p) for p in jpeg_paths], "dimensions": [args.width, args.height],
              "frames": len(jpeg_paths), "records": pixels.stat().st_size // 7,
              "pixel_record_sha256": sha256(pixels), "analysis": "exact baseline/candidate comparison is performed separately"}
    (out_dir / "analysis.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
