#!/usr/bin/env python3
"""Build and differentially simulate the 64x14 ping-pong waveform proposal."""
from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "development/player_spectrum_trace/src/user_source/hdl_source/player_pcm_waveform.v"
TB = Path(__file__).with_name("tb_waveform_proposal.v")
WORK = Path(__file__).resolve().parent
PROPOSAL = WORK / "player_pcm_waveform_proposal.v"
BIN = ROOT / "bringup/tf_wav_hdmi/tools/iverilog/app/bin"


def replace_once(source: str, old: str, new: str, label: str) -> str:
    count = source.count(old)
    if count != 1:
        raise ValueError(f"转换锚点 {label!r} 命中 {count} 次，预期恰好一次")
    return source.replace(old, new, 1)


def make_proposal(source: str) -> str:
    text = source
    text = replace_once(text,
        """    reg [6:0] display_height[0:23],peak_height[0:23];
    reg [6:0] back_height[0:23],back_peak[0:23];""",
        """    // One synchronous 64x14 BRAM: two banks of 24 {height, peak} words.
    (* ram_style=\"bram\" *) reg [13:0] wave_mem[0:63];
    reg [13:0] wave_q;
    reg front_bank,front_valid;
    reg [23:0] front_nonzero_mask,back_nonzero_mask;""",
        "waveform banks")
    text = replace_once(text,
        """    wire update_busy=(update_state!=U_IDLE);
    reg [6:0] next_height,next_peak;""",
        """    wire update_busy=(update_state!=U_IDLE);
    wire source_vsync_clear=vs_rise && source_waiting;
    wire commit_now=!rst && !source_waiting && (update_state==U_COMMIT);
    reg [6:0] next_height,next_peak;""",
        "commit priority wires")
    text = replace_once(text,
        """        if(state_write_en) state_mem[update_index]<=state_write_data;
        if(!rst && !source_waiting && band_valid && band_index<BANDS)""",
        """        if(state_write_en) state_mem[update_index]<=state_write_data;
        if(!rst && !source_waiting && update_state==U_CALC) begin
            wave_mem[{~front_bank,update_index}]<={next_height,next_peak};
        end
        if(!rst && !source_waiting && band_valid && band_index<BANDS)""",
        "back bank writes")
    text = replace_once(text,
        """    integer i;
    always @(posedge clk or posedge rst) begin""",
        """    always @(posedge clk or posedge rst) begin""",
        "unused array loop variable")
    text = replace_once(text,
        """            capture_bank<=1;ready_bank<=0;snapshot_bank<=0;ready_valid<=0;snapshot_valid<=0;
            for(i=0;i<BANDS;i=i+1) begin
                display_height[i]<=0;peak_height[i]<=0;back_height[i]<=0;back_peak[i]<=0;
            end""",
        """            capture_bank<=1;ready_bank<=0;snapshot_bank<=0;ready_valid<=0;snapshot_valid<=0;
            front_bank<=0;front_valid<=0;front_nonzero_mask<=0;back_nonzero_mask<=0;""",
        "reset metadata")
    text = replace_once(text,
        """                capture_bank<=1;ready_bank<=0;snapshot_bank<=0;ready_valid<=0;snapshot_valid<=0;
                for(i=0;i<BANDS;i=i+1) begin
                    display_height[i]<=0;peak_height[i]<=0;back_height[i]<=0;back_peak[i]<=0;
                end""",
        """                capture_bank<=1;ready_bank<=0;snapshot_bank<=0;ready_valid<=0;snapshot_valid<=0;
                front_bank<=0;front_valid<=0;front_nonzero_mask<=0;back_nonzero_mask<=0;""",
        "source VS clear")
    text = replace_once(text,
        """                U_CALC: begin
                    back_height[update_index]<=next_height;back_peak[update_index]<=next_peak;
                    if(update_index==23) update_state<=U_COMMIT;""",
        """                U_CALC: begin
                    back_nonzero_mask[update_index]<= (next_height!=0);
                    if(update_index==23) update_state<=U_COMMIT;""",
        "serial calculate")
    text = replace_once(text,
        """                U_COMMIT: begin
                    for(i=0;i<BANDS;i=i+1) begin
                        display_height[i]<=back_height[i];peak_height[i]<=back_peak[i];
                    end
                    frame_tone_mode<=snapshot_tone;frozen_front<=0;
                    update_done<=1;update_state<=U_IDLE;
                end""",
        """                U_COMMIT: begin
                    front_bank<=~front_bank;front_valid<=1'b1;
                    front_nonzero_mask<=back_nonzero_mask;
                    frame_tone_mode<=snapshot_tone;frozen_front<=0;
                    update_done<=1;update_state<=U_IDLE;
                end""",
        "atomic bank commit")
    text = replace_once(text,
        """    wire [23:0] diag_front_nonzero;
    genvar diag_j;
    generate for(diag_j=0;diag_j<24;diag_j=diag_j+1) begin: g_diag_front
        assign diag_front_nonzero[diag_j]=|display_height[diag_j];
    end endgenerate""",
        """    wire diag_front_nonzero=front_valid && (|front_nonzero_mask);""",
        "diagnostic mask")
    text = replace_once(text,
        """    always @(posedge clk or posedge rst) begin
        if(rst) begin x_pos<=0;y_pos<=0;de_prev<=0;arm_first_line<=1;end
        else begin
            de_prev<=de;""",
        """    always @(posedge clk or posedge rst) begin
        if(rst) begin x_pos<=0;y_pos<=0;de_prev<=0;arm_first_line<=1;end
        else begin
            de_prev<=de;""",
        "pixel counter anchor")
    text = replace_once(text,
        """    end
    function [34:0] glyph;""",
        """    end
    // Read the bank and column that will be visible after this edge. This
    // mirrors x_pos priority and selects the incoming front bank on U_COMMIT.
    reg [9:0] render_x_next;
    reg [4:0] render_col_next;
    wire render_bank_next=commit_now ? ~front_bank : front_bank;
    always @* begin
        if(rst || vs!=vs_prev || !de) render_x_next=0;
        else render_x_next=x_pos+1'b1;
        if(render_x_next>=128 && render_x_next<512)
            render_col_next=(render_x_next-128)>>4;
        else render_col_next=0;
    end
    always @(posedge clk) wave_q<=wave_mem[{render_bank_next,render_col_next}];
    function [34:0] glyph;""",
        "synchronous lookahead read")
    text = replace_once(text,
        """        height_at_x=display_height[column_index];peak_at_x=peak_height[column_index];""",
        """        height_at_x=front_valid?wave_q[13:7]:7'd0;
        peak_at_x=front_valid?wave_q[6:0]:7'd0;""",
        "render from BRAM output")
    return text


def locate_tool(explicit: str | None, name: str) -> str:
    if explicit:
        return explicit
    bundled = BIN / (name + (".exe" if sys.platform == "win32" else ""))
    if bundled.is_file():
        return str(bundled)
    found = shutil.which(name)
    if found:
        return found
    raise FileNotFoundError(f"找不到 {name}，请使用 --{name} 指定")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--source", type=Path, default=SOURCE)
    ap.add_argument("--testbench", type=Path, default=TB)
    ap.add_argument("--iverilog")
    ap.add_argument("--vvp")
    args = ap.parse_args()
    if not args.source.is_file() or not args.testbench.is_file():
        raise FileNotFoundError("找不到 overlay 原版或差分 testbench")

    original = args.source.read_text(encoding="utf-8")
    candidate = make_proposal(original)
    candidate = replace_once(candidate, "module player_pcm_waveform #(", "module player_pcm_waveform_proposal #(", "candidate module rename")
    reference = replace_once(original, "module player_pcm_waveform #(", "module player_pcm_waveform_reference #(", "reference module rename")
    PROPOSAL.write_text(candidate, encoding="utf-8")
    ref_copy = WORK / ".player_pcm_waveform_reference.generated.v"
    image = WORK / ".waveform_proposal.generated.vvp"
    iv = locate_tool(args.iverilog, "iverilog")
    vvp = locate_tool(args.vvp, "vvp")
    try:
        ref_copy.write_text(reference, encoding="utf-8")
        compile_cmd = [iv, "-g2012", "-s", "tb_waveform_proposal", "-o", str(image),
                       str(args.testbench.resolve()), str(ref_copy), str(PROPOSAL)]
        print("PROPOSAL:", PROPOSAL, flush=True)
        print("Compile:", subprocess.list2cmdline(compile_cmd), flush=True)
        subprocess.run(compile_cmd, check=True)
        run_cmd = [vvp, str(image)]
        print("Run:", subprocess.list2cmdline(run_cmd), flush=True)
        subprocess.run(run_cmd, check=True)
    finally:
        for generated in (image, ref_copy):
            try:
                generated.unlink(missing_ok=True)
            except OSError:
                pass
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, subprocess.CalledProcessError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
