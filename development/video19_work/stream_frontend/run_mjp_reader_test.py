from __future__ import annotations

import json
import subprocess
from pathlib import Path

from pack_video_mjp import DEFAULT_AUDIO, DEFAULT_VIDEO, pack, split_mjpeg


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
IVERILOG = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe"


def write_hex(path: Path, data: bytes) -> None:
    path.write_text("\n".join(f"{byte:02x}" for byte in data) + "\n", encoding="ascii")


def main() -> None:
    run_dir = HERE / "runs/reader_two_frames"
    run_dir.mkdir(parents=True, exist_ok=True)
    output_dir = HERE / "output"
    output_dir.mkdir(parents=True, exist_ok=True)
    video_path = output_dir / "VIDEO.MJP"
    index_path = output_dir / "index.json"
    audio_path = output_dir / "TEST.WAV"
    index = pack(DEFAULT_VIDEO, DEFAULT_AUDIO, video_path, index_path, audio_path)

    source_blob = DEFAULT_VIDEO.read_bytes()
    jpeg_frames = split_mjpeg(source_blob)
    first_two = index["frames"][:2]
    end_sector = first_two[-1]["record_next_sector"]
    card_prefix = video_path.read_bytes()[:end_sector * 512]
    if len(card_prefix) != end_sector * 512:
        raise RuntimeError("two-frame MJP prefix is not sector aligned")
    card_hex = run_dir / "card_prefix.hex"
    jpeg0 = run_dir / "frame0.jpg"
    jpeg1 = run_dir / "frame1.jpg"
    write_hex(card_hex, card_prefix)
    jpeg0.write_bytes(jpeg_frames[0])
    jpeg1.write_bytes(jpeg_frames[1])

    expected_requests = 1 + 1 + first_two[0]["jpeg_sector_count"] + 1 + first_two[1]["jpeg_sector_count"]
    executable = run_dir / "simv.exe"
    compile_cmd = [
        str(IVERILOG), "-g2012", "-s", "tb_mjp_file_reader", "-o", str(executable),
        str(HERE / "tb_mjp_file_reader.sv"), str(HERE / "mjp_file_reader.v"),
    ]
    compiled = subprocess.run(compile_cmd, text=True, capture_output=True)
    (run_dir / "compile.log").write_text(compiled.stdout + compiled.stderr, encoding="utf-8")
    if compiled.returncode:
        raise SystemExit(f"Icarus compile failed ({compiled.returncode}); see {run_dir / 'compile.log'}")

    sim_cmd = [
        str(VVP), str(executable),
        f"+CARD_HEX={card_hex}", f"+CARD_BYTES={len(card_prefix)}",
        f"+JPEG0={jpeg0}", f"+JPEG0_LEN={len(jpeg_frames[0])}",
        f"+JPEG1={jpeg1}", f"+JPEG1_LEN={len(jpeg_frames[1])}",
        f"+SECTOR_REQUESTS={expected_requests}",
    ]
    simulated = subprocess.run(sim_cmd, text=True, capture_output=True, timeout=180)
    sim_output = simulated.stdout + simulated.stderr
    (run_dir / "sim.log").write_text(sim_output, encoding="utf-8")
    print(sim_output, end="")
    if simulated.returncode or "PASS frames=2" not in sim_output:
        raise SystemExit(f"reader simulation failed ({simulated.returncode}); see {run_dir / 'sim.log'}")

    result = {
        "status": "PASS",
        "frames": 2,
        "jpeg_lengths": [len(jpeg_frames[0]), len(jpeg_frames[1])],
        "sector_requests": expected_requests,
        "random_accept": True,
        "video_sha256": index["video_sha256"],
        "audio_sha256": index["audio"]["sha256"],
        "compile_log": str(run_dir / "compile.log"),
        "sim_log": str(run_dir / "sim.log"),
    }
    (run_dir / "result.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
