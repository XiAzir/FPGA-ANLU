#!/usr/bin/env python3
"""Ablate waveform nonzero masks to scalar flags and run cycle-level differential simulation."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
WORK = Path(__file__).resolve().parent
SOURCE = ROOT / "development/player_spectrum_trace/src/user_source/hdl_source/player_pcm_waveform.v"
BASE_SCRIPT = WORK / "waveform_proposal.py"
BASE_TB = WORK / "tb_waveform_proposal.v"
PROPOSAL = WORK / "player_pcm_waveform_flags_proposal.v"
GENERATED_TB = WORK / ".tb_waveform_flags.generated.v"
REF_COPY = WORK / ".player_pcm_waveform_reference_flags.generated.v"
IMAGE = WORK / ".waveform_flags_proposal.generated.vvp"
BIN = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin"


def replace_once(source: str, old: str, new: str, label: str) -> str:
    count = source.count(old)
    if count != 1:
        raise ValueError(f"转换锚点 {label!r} 命中 {count} 次，预期恰好一次")
    return source.replace(old, new, 1)


def load_base_builder():
    spec = importlib.util.spec_from_file_location("waveform_base_builder", BASE_SCRIPT)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"无法载入基础proposal生成器：{BASE_SCRIPT}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def build_flags_proposal(original: str) -> str:
    base = load_base_builder().make_proposal(original)
    base = replace_once(base, "module player_pcm_waveform #(", "module player_pcm_waveform_proposal #(", "base module name")
    text = replace_once(base, "reg [23:0] front_nonzero_mask,back_nonzero_mask;",
                        "reg front_nonzero,back_nonzero;", "scalar flags declaration")
    clear = "front_nonzero_mask<=0;back_nonzero_mask<=0;"
    if text.count(clear) != 2:
        raise ValueError(f"reset/source-clear锚点命中 {text.count(clear)} 次，预期恰好两次")
    text = text.replace(clear, "front_nonzero<=0;back_nonzero<=0;")
    text = replace_once(text, "back_nonzero_mask[update_index]<= (next_height!=0);",
                        "if(update_index==0) back_nonzero<=(next_height!=0);\n                    else back_nonzero<=back_nonzero || (next_height!=0);",
                        "U_CALC scalar accumulate")
    text = replace_once(text, "front_nonzero_mask<=back_nonzero_mask;", "front_nonzero<=back_nonzero;", "U_COMMIT scalar capture")
    text = replace_once(text, "wire diag_front_nonzero=front_valid && (|front_nonzero_mask);",
                        "wire diag_front_nonzero=front_valid && front_nonzero;", "diagnostic scalar flag")
    return replace_once(text, "module player_pcm_waveform_proposal #(", "module player_pcm_waveform_flags_proposal #(", "flags module name")


def apply(file: str | Path) -> Path:
    """Create the ablation in resource_opt_work, leaving the input untouched."""
    input_path = Path(file)
    original = input_path.read_text(encoding="utf-8")
    candidate = build_flags_proposal(original)
    PROPOSAL.write_text(candidate, encoding="utf-8")
    return PROPOSAL


def build_diff_tb(tb: str) -> str:
    text = replace_once(tb, "player_pcm_waveform_proposal #(", "player_pcm_waveform_flags_proposal #(", "DUT module")
    front_check = "          if (prop_dut.front_nonzero_mask[k] !== (ref_dut.display_height[k]!=0))\n            $fatal(1,\"front nonzero mask mismatch cycle=%0d band=%0d\",cycles,k);\n"
    text = replace_once(text, front_check, "", "old front mask assertion")
    text = replace_once(text, "prop_dut.front_nonzero_mask[k]!==0", "prop_dut.front_nonzero!==0", "invalid front scalar assertion")
    back_check = "      if (prop_dut.back_nonzero_mask[k] !== (ref_dut.back_height[k]!=0))\n        $fatal(1,\"back nonzero mask mismatch cycle=%0d band=%0d\",cycles,k);\n"
    text = replace_once(text, back_check,
                        "      if (prop_dut.back_nonzero !== ref_back_prefix_nonzero(calc_index))\n        $fatal(1,\"back nonzero flag mismatch cycle=%0d index=%0d\",cycles,calc_index);\n",
                        "back prefix reduction assertion")
    text = replace_once(text, "      end\n    end\n    if (was_calc) begin",
                        "      end\n      if (prop_dut.front_nonzero !== ref_front_nonzero())\n        $fatal(1,\"front nonzero flag mismatch cycle=%0d\",cycles);\n    end\n    if (was_calc) begin",
                        "front reduction assertion")
    functions = ("  function ref_front_nonzero;\n"
                 "    integer n;\n"
                 "    begin\n"
                 "      ref_front_nonzero=0;\n"
                 "      for(n=0;n<24;n=n+1) if(ref_dut.display_height[n]!=0) ref_front_nonzero=1;\n"
                 "    end\n"
                 "  endfunction\n"
                 "  function ref_back_prefix_nonzero(input integer last_index);\n"
                 "    integer n;\n"
                 "    begin\n"
                 "      ref_back_prefix_nonzero=0;\n"
                 "      for(n=0;n<24;n=n+1) if(n<=last_index && ref_dut.back_height[n]!=0) ref_back_prefix_nonzero=1;\n"
                 "    end\n"
                 "  endfunction\n\n")
    return replace_once(text, "  always @(posedge clk) begin\n", functions + "  always @(posedge clk) begin\n", "reference reduce functions")


def locate_tool(explicit: str | None, name: str) -> str:
    if explicit:
        return explicit
    candidate = BIN / (name + (".exe" if sys.platform == "win32" else ""))
    if candidate.is_file():
        return str(candidate)
    found = shutil.which(name)
    if found:
        return found
    raise FileNotFoundError(f"找不到 {name}，请显式指定可执行文件")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--source", type=Path, default=SOURCE)
    ap.add_argument("--candidate", type=Path, help="用此实际候选源码参加差分；只读该文件并复制重命名，不重新生成候选逻辑")
    ap.add_argument("--testbench", type=Path, default=BASE_TB)
    ap.add_argument("--iverilog")
    ap.add_argument("--vvp")
    args = ap.parse_args()
    input_paths = [args.source, args.testbench, BASE_SCRIPT]
    if args.candidate is not None:
        input_paths.append(args.candidate)
    for path in input_paths:
        if not path.is_file():
            raise FileNotFoundError(f"缺少输入文件：{path}")
    original = args.source.read_text(encoding="utf-8")
    if args.candidate is None:
        apply(args.source)
        candidate_label = str(PROPOSAL)
        candidate_sha_input = sha256(args.source)
    else:
        candidate_input = args.candidate.read_text(encoding="utf-8")
        renamed_candidate = replace_once(candidate_input, "module player_pcm_waveform #(",
                                          "module player_pcm_waveform_flags_proposal #(", "actual candidate module name")
        PROPOSAL.write_text(renamed_candidate, encoding="utf-8")
        candidate_label = str(args.candidate.resolve())
        candidate_sha_input = sha256(args.candidate)
    reference = replace_once(original, "module player_pcm_waveform #(", "module player_pcm_waveform_reference #(", "reference module name")
    diff_tb = build_diff_tb(args.testbench.read_text(encoding="utf-8"))
    GENERATED_TB.write_text(diff_tb, encoding="utf-8")
    iv, vvp = locate_tool(args.iverilog, "iverilog"), locate_tool(args.vvp, "vvp")
    try:
        REF_COPY.write_text(reference, encoding="utf-8")
        compile_cmd = [iv, "-g2012", "-s", "tb_waveform_proposal", "-o", str(IMAGE),
                       str(GENERATED_TB), str(REF_COPY), str(PROPOSAL)]
        print("Candidate input:", candidate_label, flush=True)
        print("Differential module copy:", PROPOSAL, flush=True)
        print("Compile:", subprocess.list2cmdline(compile_cmd), flush=True)
        subprocess.run(compile_cmd, check=True)
        run_cmd = [vvp, str(IMAGE)]
        print("Run:", subprocess.list2cmdline(run_cmd), flush=True)
        subprocess.run(run_cmd, check=True)
        print("A/B theoretical nonzero flag FF: base=48, ablation=2, delta=-46 (95.8% fewer flag FF). TD not run.", flush=True)
        print("SHA256 reference={} candidate_input={} base_tb={} script={} renamed_copy={} generated_tb={}".format(
            sha256(args.source), candidate_sha_input, sha256(args.testbench), sha256(Path(__file__)), sha256(PROPOSAL), sha256(GENERATED_TB)), flush=True)
    finally:
        for generated in (IMAGE, GENERATED_TB, REF_COPY):
            try:
                generated.unlink(missing_ok=True)
            except OSError:
                pass
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
