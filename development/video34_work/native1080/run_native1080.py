#!/usr/bin/env python3
"""Build and optionally run one 1080p native JPEG + YUV block-buffer frame."""
import argparse
import hashlib
import json
import math
import re
import subprocess
import time
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
MEDIA = ROOT / "development/video33_work/media1080"
JPEG_DIR = ROOT / "development/player_video34_1080p15/src/user_source/hdl_source/jpeg"
BUFFER = ROOT / "development/player_video34_1080p15/src/user_source/hdl_source/idct_yuv420_block_buffer.v"
IV = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe"
VVP = IV.with_name("vvp.exe")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fixture", choices=("frame000", "frame108_max"), default="frame000")
    ap.add_argument("--mode", choices=("decode", "service"), default="decode",
                    help="decode uses one input word per accepted cycle; service models 1.22 MB/s at 100 MHz")
    ap.add_argument("--run", action="store_true", help="run VVP after compiling; otherwise prepare/compile only")
    ap.add_argument("--word-stall-period", type=int, default=13,
                    help="word_ready stalls one cycle per period; 1 means no output stalls")
    ap.add_argument("--stop-cycles", type=int, default=None,
                    help="override the deterministic testbench cycle limit")
    ap.add_argument("--diagnostics", action="store_true",
                    help="emit one compact pipeline/queue snapshot per 100,000 cycles")
    args = ap.parse_args()

    if args.word_stall_period < 1:
        ap.error("--word-stall-period must be >= 1")
    frame = HERE / f"{args.fixture}.jpg"
    frame_hex = HERE / f"{args.fixture}.hex"
    if not frame.exists() or not frame_hex.exists():
        raise SystemExit("Run prepare_native1080.py first")
    blob = frame.read_bytes()
    info = json.loads((HERE / "fixtures.json").read_text(encoding="utf-8"))["selected"][args.fixture]
    if hashlib.sha256(blob).hexdigest() != info["jpeg_sha256"]:
        raise SystemExit("fixture SHA256 changed")
    data_words = (len(blob)+3)//4
    source_words = data_words+1  # Separate empty strb=0000, last=1 tail word.
    gap = 328 if args.mode == "service" else 1
    blocks = 120*68*6
    samples = blocks*64
    y_words = 120*68*64
    c_words = 120*68*16
    output_words = y_words+2*c_words
    decode_cycles_est = math.ceil(blocks*82.87)
    input_cycles_est = source_words*gap
    output_cycles_est = math.ceil(output_words*args.word_stall_period/(args.word_stall_period-1)) if args.word_stall_period>1 else output_words
    estimated_cycles = max(decode_cycles_est,input_cycles_est,output_cycles_est)+50000
    raw = HERE / f"{args.fixture}_{args.mode}_yuv420_tiled_le32.raw"
    image = HERE / f"{args.fixture}_{args.mode}.vvp"
    log = HERE / f"{args.fixture}_{args.mode}.log"
    report = HERE / f"{args.fixture}_{args.mode}_summary.json"
    sources = sorted(JPEG_DIR.glob("*.v"))
    cmd = [str(IV),"-g2012","-s","tb_native1080",
           f"-Ptb_native1080.JPEG_BYTES={len(blob)}",
           f"-Ptb_native1080.WORD_GAP={gap}",
           f"-Ptb_native1080.WORD_STALL_PERIOD={args.word_stall_period}",
           "-o",str(image),str(HERE/"tb_native1080.v"),str(BUFFER),*[str(p) for p in sources]]
    vvp_cmd=[str(VVP),str(image),f"+FRAME_HEX={frame_hex}",f"+RAW_OUT={raw}"]
    if args.stop_cycles is not None:
        vvp_cmd.append(f"+STOP_CYCLES={args.stop_cycles}")
    if args.diagnostics:
        vvp_cmd.append("+DIAGNOSTICS=1")
    print(json.dumps({"fixture":args.fixture,"frame_index":info["frame_index"],
        "jpeg_bytes":len(blob),"jpeg_sha256":info["jpeg_sha256"],"data_words":data_words,
        "source_words_with_empty_last_tail":source_words,"word_gap_cycles":gap,
        "input_rate_assumption_bytes_s":(1_220_000 if args.mode=="service" else None),
        "word_stall_period":args.word_stall_period,"expected_blocks":blocks,
        "expected_real_samples":samples,"expected_words":output_words,
        "estimated_cycles":estimated_cycles,"estimated_ms_at_100mhz":estimated_cycles/100000,
        "iverilog_command":cmd,"vvp_command":vvp_cmd},indent=2))
    subprocess.run(cmd,cwd=ROOT,check=True)
    if not args.run:
        print("Compile succeeded. VVP remains unstarted; rerun with --run after authorization.")
        return
    started = time.perf_counter()
    with log.open("w",encoding="utf-8") as f:
        run=subprocess.run(vvp_cmd,cwd=ROOT,stdout=f,stderr=subprocess.STDOUT,text=True)
    wall_seconds = time.perf_counter() - started
    transcript = log.read_text(encoding="utf-8")
    print(transcript)
    if run.returncode:
        raise SystemExit(f"VVP failed with exit {run.returncode}; see {log}")
    if not raw.exists() or raw.stat().st_size != output_words*4:
        raise SystemExit(f"raw output size mismatch: expected {output_words*4}")
    payload=raw.read_bytes()
    observed_cycles = int(re.search(r"NATIVE1080_PASS .*?cycles=(\d+)",transcript).group(1))
    result={"status":"PASS","fixture":args.fixture,"frame_index":info["frame_index"],"mode":args.mode,
        "jpeg_bytes":len(blob),"jpeg_sha256":info["jpeg_sha256"],"data_words":data_words,
        "source_words_with_empty_last_tail":source_words,"word_gap_cycles":gap,
        "yuv420_tiled_le32_raw":raw.name,"raw_bytes":len(payload),
        "raw_crc32":f"{zlib.crc32(payload)&0xffffffff:08x}","sim_log":log.name,
        "expected_blocks":blocks,"expected_real_samples":samples,"expected_words":output_words,
        "observed_cycles":observed_cycles,"observed_ms_at_100mhz":observed_cycles/100000,
        "vvp_wall_seconds":round(wall_seconds,3),
        "source_sha256":{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest()
                         for p in [HERE/"tb_native1080.v",BUFFER,*sources]},
        "estimated_cycles":estimated_cycles,"estimated_ms_at_100mhz":estimated_cycles/100000}
    report.write_text(json.dumps(result,indent=2),encoding="utf-8")
    print(json.dumps(result,indent=2))

if __name__ == "__main__":
    main()
