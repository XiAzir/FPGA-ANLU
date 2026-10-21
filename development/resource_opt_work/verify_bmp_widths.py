"""Exhaustively verify scaler math and per-cycle RTL equivalence in isolation.

Writes all generated RTL, Icarus images, and logs below this script's
verification_runs directory. The active project sources are read only.
"""
from __future__ import annotations

from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[2]
RESOURCE = Path(__file__).resolve().parent
ACTIVE_HDL = ROOT / "development/player_spectrum_trace/src/user_source/hdl_source"
PROPOSAL_PATH = RESOURCE / "bmp_proposal.py"
TB_EQUIV = RESOURCE / "tb_bmp_width_equiv.v"
TB_PARAMS = RESOURCE / "tb_bmp_param_widths.v"
FRAME_CASES = ((640, 480), (32, 24), (1, 1))
SRC_MAX_W, SRC_MAX_H = 1024, 768


def _load_proposal():
    namespace: dict[str, object] = {}
    source = PROPOSAL_PATH.read_text(encoding="utf-8-sig")
    exec(compile(source, str(PROPOSAL_PATH), "exec"), namespace)
    return namespace["apply"]


def _iverilog_tools() -> tuple[Path, Path]:
    env_dir = os.environ.get("ANLU_IVERILOG_BIN")
    if env_dir:
        directory = Path(env_dir)
        return directory / "iverilog.exe", directory / "vvp.exe"
    iverilog = shutil.which("iverilog")
    vvp = shutil.which("vvp")
    if iverilog and vvp:
        return Path(iverilog), Path(vvp)
    fallback = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin"
    return fallback / "iverilog.exe", fallback / "vvp.exe"


def _divider(numerator: int, denominator: int, dividend_width: int,
             quotient_width: int) -> tuple[int, int]:
    """Model the default 32-cycle Verilog recurrence bit for bit."""
    shifted_numerator = numerator
    num_mask = (1 << dividend_width) - 1
    quotient_mask = (1 << quotient_width) - 1
    quotient = 0
    remainder = 0
    for div_bit in range(31, -1, -1):
        input_bit = 0
        if div_bit < dividend_width:
            input_bit = (shifted_numerator >> (dividend_width - 1)) & 1
            shifted_numerator = (shifted_numerator << 1) & num_mask
        trial = (remainder << 1) | input_bit
        subtract = trial >= denominator
        remainder = trial - denominator if subtract else trial
        quotient = ((quotient << 1) | int(subtract)) & quotient_mask
    return quotient, remainder


def _make_19_cycle_tb(frame_w: int = 32, frame_h: int = 24,
                     target_only: bool = False) -> str:
    text = TB_EQUIV.read_text(encoding="utf-8-sig")
    name = "tb_bmp_width_equiv19_target" if target_only else "tb_bmp_width_equiv19"
    text = text.replace("module tb_bmp_width_equiv;", f"module {name};", 1)
    text = text.replace("bmp_scale_engine_opt #(", "bmp_scale_engine_opt19 #(", 1)
    text = text.replace(".FRAME_WIDTH(32),.FRAME_HEIGHT(24)",
                        f".FRAME_WIDTH({frame_w}),.FRAME_HEIGHT({frame_h})")
    text = text.replace("pixel_count!=32*24", f"pixel_count!={frame_w}*{frame_h}")
    text = text.replace("reg clk=0, rst=1, start=0;",
                        "reg clk=0, rst=1, start_ref=0, start_opt=0, compare_enable=0;", 1)
    text = text.replace(".clk(clk),.rst(rst),.start(start),.source_width(source_width),",
                        ".clk(clk),.rst(rst),.start(start_ref),.source_width(source_width),", 1)
    text = text.replace(".clk(clk),.rst(rst),.start(start),.source_width(source_width),",
                        ".clk(clk),.rst(rst),.start(start_opt),.source_width(source_width),", 1)
    text = text.replace("if (!rst) begin", "if (!rst && compare_enable) begin", 1)
    text = text.replace("rst=1; start=0; card_valid=0; card_end=0;",
                        "rst=1; start_ref=0; start_opt=0; compare_enable=0; card_valid=0; card_end=0;", 1)
    text = text.replace("""    task run_valid;
""", """    task start_pair;
        input integer optimized_delay;
        begin
            compare_enable=0;
            if (optimized_delay>0) begin
                start_ref=1; start_opt=0;
                @(negedge clk); start_ref=0;
                repeat(optimized_delay-1) @(negedge clk);
                start_opt=1;
                @(negedge clk); start_opt=0;
                @(negedge clk); compare_enable=1;
            end else begin
                start_ref=1; start_opt=1;
                @(negedge clk); start_ref=0; start_opt=0; compare_enable=1;
            end
        end
    endtask

    task run_valid;
""", 1)
    text = text.replace("""            fault_kind=0; start=1;
            @(negedge clk); start=0;
""", """            fault_kind=0; start_pair(13);
""", 1)
    text = text.replace("""            fault_kind=fault; start=1;
            @(negedge clk); start=0;
""", """            fault_kind=fault;
            if (fault==0 || fault==4) start_pair(0);
            else start_pair(13);
""", 1)
    delay = 32 - max(SRC_MAX_H * frame_w, SRC_MAX_W * frame_h).bit_length()
    text = text.replace("start_pair(13)", f"start_pair({delay})")
    if target_only:
        start = text.index("    initial begin\n        run_valid(1,1,0);")
        end = text.index("    initial begin\n        #500000000;", start)
        text = text[:start] + f"""    initial begin
        run_valid(1,1,0);
        $display(\"BMP_EQUIV19_TARGET PASS frame={frame_w}x{frame_h} pixel_count=%0d\",pixel_count);
        $finish;
    end

""" + text[end:]
    else:
        text = text.replace("BMP_EQUIV PASS valid=7 errors=6 frame=32x24 pixels=%0d",
                            f"BMP_EQUIV19 PASS valid=7 errors=6 frame={frame_w}x{frame_h} pixels=%0d")
    return text


def exhaustive_arithmetic() -> dict[str, object]:
    total = 0
    per_frame: list[dict[str, object]] = []
    for frame_w, frame_h in FRAME_CASES:
        max_num = max(SRC_MAX_H * frame_w, SRC_MAX_W * frame_h)
        dividend_w = max_num.bit_length()
        denom_w = max(SRC_MAX_W, SRC_MAX_H).bit_length()
        quotient_w = max(frame_w, frame_h).bit_length()
        x_phase_w = (frame_w + SRC_MAX_W - 1).bit_length()
        y_phase_w = (frame_h + SRC_MAX_H - 1).bit_length()
        x_edge_w, y_edge_w = frame_w.bit_length(), frame_h.bit_length()
        frame_total = 0
        max_seen = {"numerator": 0, "denominator": 0, "remainder": 0,
                    "quotient": 0, "x_phase_bound": 0, "y_phase_bound": 0,
                    "stride": 0, "image_bytes": 0}

        for width in range(1, SRC_MAX_W + 1):
            stride = ((width * 3 + 3) >> 2) << 2
            for height in range(1, SRC_MAX_H + 1):
                if width * frame_h >= height * frame_w:
                    numerator = height * frame_w
                    denominator = width
                    quotient_golden = numerator // denominator
                    dw, dh = frame_w, max(1, quotient_golden)
                    offx, offy = 0, (frame_h - dh + 1) >> 1
                else:
                    numerator = width * frame_h
                    denominator = height
                    quotient_golden = numerator // denominator
                    dw, dh = max(1, quotient_golden), frame_h
                    offx, offy = (frame_w - dw) >> 1, 0

                quotient, remainder = _divider(
                    numerator, denominator, dividend_w, quotient_w)
                if quotient != quotient_golden or remainder != numerator % denominator:
                    raise AssertionError(
                        f"divider mismatch frame={frame_w}x{frame_h} source={width}x{height} "
                        f"{numerator}/{denominator}: {quotient},{remainder} != "
                        f"{quotient_golden},{numerator % denominator}")

                stride_bytes = stride * height
                x_phase_bound = dw - 1 + width
                y_phase_bound = dh - 1 + height
                src_x_last = ((dw - 1) * width) // dw
                src_y_last = (dh * height - 1) // dh
                if not (1 <= dw <= frame_w and 1 <= dh <= frame_h):
                    raise AssertionError("scaled geometry exceeded output frame")
                if offx + dw > frame_w or offy + dh > frame_h:
                    raise AssertionError("centering offset exceeded output frame")
                if x_phase_bound >= (1 << x_phase_w) or y_phase_bound >= (1 << y_phase_w):
                    raise AssertionError("phase localparam is too narrow")
                if offx + dw >= (1 << x_edge_w) or offy + dh >= (1 << y_edge_w):
                    raise AssertionError("edge localparam is too narrow")
                if src_x_last >= width or src_y_last >= height:
                    raise AssertionError("nearest-neighbour source index escaped dimensions")
                if numerator >= (1 << dividend_w) or denominator >= (1 << denom_w):
                    raise AssertionError("divider operand localparam is too narrow")
                if stride >= (1 << 12) or stride_bytes >= (1 << 22):
                    raise AssertionError("BMP stride/image byte localparam is too narrow")

                max_seen["numerator"] = max(max_seen["numerator"], numerator)
                max_seen["denominator"] = max(max_seen["denominator"], denominator)
                max_seen["remainder"] = max(max_seen["remainder"], remainder)
                max_seen["quotient"] = max(max_seen["quotient"], quotient)
                max_seen["x_phase_bound"] = max(max_seen["x_phase_bound"], x_phase_bound)
                max_seen["y_phase_bound"] = max(max_seen["y_phase_bound"], y_phase_bound)
                max_seen["stride"] = max(max_seen["stride"], stride)
                max_seen["image_bytes"] = max(max_seen["image_bytes"], stride_bytes)
                frame_total += 1

        total += frame_total
        per_frame.append({
            "frame": f"{frame_w}x{frame_h}",
            "source_pairs": frame_total,
            "divider_widths": {"dividend": dividend_w, "denominator": denom_w,
                               "quotient": quotient_w},
            "phase_widths": {"x": x_phase_w, "y": y_phase_w},
            "coordinate_widths": {"x": max(1, (frame_w-1).bit_length()),
                                   "y": max(1, (frame_h-1).bit_length()),
                                   "x_edge": x_edge_w, "y_edge": y_edge_w},
            "maxima": max_seen,
        })
        print(f"ARITH PASS frame={frame_w}x{frame_h} pairs={frame_total} "
              f"dividend_w={dividend_w} q_w={quotient_w}")
    return {"status": "PASS", "source_dimensions": [SRC_MAX_W, SRC_MAX_H],
            "total_frame_dimension_pairs": total, "frames": per_frame}


def _compile_run(iverilog: Path, vvp: Path, work: Path, top: str,
                 sources: tuple[Path, ...]) -> str:
    image = work / f"{top}.vvp"
    compile_log = work / f"{top}_compile.log"
    run_log = work / f"{top}_run.log"
    with compile_log.open("w", encoding="utf-8", newline="\n") as log:
        result = subprocess.run(
            [str(iverilog), "-g2012", "-Wall", "-s", top, "-o", str(image),
             *(str(source) for source in sources)],
            cwd=work, text=True, stdout=log, stderr=subprocess.STDOUT, check=False)
    if result.returncode:
        raise RuntimeError(f"Icarus compile failed: {compile_log}")
    with run_log.open("w", encoding="utf-8", newline="\n") as log:
        result = subprocess.run([str(vvp), str(image)], cwd=work, text=True,
                                stdout=log, stderr=subprocess.STDOUT, check=False,
                                timeout=180)
    output = run_log.read_text(encoding="utf-8", errors="replace")
    if result.returncode or "PASS" not in output or "FAIL" in output:
        raise RuntimeError(f"simulation failed: {run_log}\n{output[-3000:]}")
    return output


def run_rtl(work: Path) -> dict[str, object]:
    iverilog, vvp = _iverilog_tools()
    original = (ACTIVE_HDL / "bmp_scale_engine.v").read_text(encoding="utf-8-sig")
    loader = (ACTIVE_HDL / "tf_bmp_file_player.v").read_text(encoding="utf-8-sig")
    ref_dir, opt_dir = work / "ref", work / "opt"
    ref_dir.mkdir(); opt_dir.mkdir()
    (ref_dir / "bmp_scale_engine.v").write_text(original, encoding="utf-8", newline="\n")
    (ref_dir / "tf_bmp_file_player.v").write_text(loader, encoding="utf-8", newline="\n")
    (opt_dir / "bmp_scale_engine.v").write_text(original, encoding="utf-8", newline="\n")
    (opt_dir / "tf_bmp_file_player.v").write_text(loader, encoding="utf-8", newline="\n")

    apply = _load_proposal()
    apply(opt_dir, widths=True, diagnostic_direct=False, divider_cycles=32)
    ref_text = (ref_dir / "bmp_scale_engine.v").read_text(encoding="utf-8")
    opt_text = (opt_dir / "bmp_scale_engine.v").read_text(encoding="utf-8")
    (work / "bmp_scale_engine_ref.v").write_text(
        ref_text.replace("module bmp_scale_engine #(", "module bmp_scale_engine_ref #(", 1),
        encoding="utf-8", newline="\n")
    (work / "bmp_scale_engine_opt.v").write_text(
        opt_text.replace("module bmp_scale_engine #(", "module bmp_scale_engine_opt #(", 1),
        encoding="utf-8", newline="\n")

    equiv_tb = _compile_run(iverilog, vvp, work, "tb_bmp_width_equiv", (
        work / "bmp_scale_engine_ref.v", work / "bmp_scale_engine_opt.v", TB_EQUIV))
    opt19_dir = work / "opt19"
    opt19_dir.mkdir()
    (opt19_dir / "bmp_scale_engine.v").write_text(original, encoding="utf-8", newline="\n")
    (opt19_dir / "tf_bmp_file_player.v").write_text(loader, encoding="utf-8", newline="\n")
    apply(opt19_dir, widths=True, diagnostic_direct=False, divider_cycles=19)
    opt19_text = (opt19_dir / "bmp_scale_engine.v").read_text(encoding="utf-8")
    opt19_path = work / "bmp_scale_engine_opt19.v"
    opt19_path.write_text(
        opt19_text.replace("module bmp_scale_engine #(", "module bmp_scale_engine_opt19 #(", 1),
        encoding="utf-8", newline="\n")
    equiv19_tb_path = work / "tb_bmp_width_equiv19.v"
    equiv19_tb_path.write_text(_make_19_cycle_tb(), encoding="utf-8", newline="\n")
    equiv19_tb = _compile_run(iverilog, vvp, work, "tb_bmp_width_equiv19", (
        work / "bmp_scale_engine_ref.v", opt19_path, equiv19_tb_path))
    target19_tb_path = work / "tb_bmp_width_equiv19_target.v"
    target19_tb_path.write_text(_make_19_cycle_tb(640, 480, True), encoding="utf-8", newline="\n")
    target19_tb = _compile_run(iverilog, vvp, work, "tb_bmp_width_equiv19_target", (
        work / "bmp_scale_engine_ref.v", opt19_path, target19_tb_path))
    params_tb = _compile_run(iverilog, vvp, work, "tb_bmp_param_widths", (
        work / "bmp_scale_engine_opt.v", TB_PARAMS))
    print(equiv_tb.strip())
    print(equiv19_tb.strip())
    print(target19_tb.strip())
    print(params_tb.strip())
    return {"equivalence_32_cycle": "PASS", "equivalence_19_cycle_with_parameter_cycle_alignment": "PASS",
            "equivalence_19_cycle_target_640x480_with_13_cycle_start_alignment": "PASS",
            "parameter_elaboration": "PASS",
            "equivalence_log": "tb_bmp_width_equiv_run.log",
            "equivalence_19_log": "tb_bmp_width_equiv19_run.log",
            "equivalence_19_target_log": "tb_bmp_width_equiv19_target_run.log",
            "parameter_log": "tb_bmp_param_widths_run.log"}


def main() -> int:
    tag = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    work = RESOURCE / "verification_runs" / f"run_{tag}"
    work.mkdir(parents=True)
    arithmetic = exhaustive_arithmetic()
    rtl = run_rtl(work)
    report = {"status": "PASS", "run_dir": str(work),
              "arithmetic": arithmetic, "rtl": rtl}
    report_path = work / "verification_report.json"
    report_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"BMP_WIDTH_VERIFICATION PASS pairs={arithmetic['total_frame_dimension_pairs']} "
          f"run_dir={work}")
    print(f"report={report_path}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"BMP width verification failed: {exc}", file=sys.stderr)
        raise
