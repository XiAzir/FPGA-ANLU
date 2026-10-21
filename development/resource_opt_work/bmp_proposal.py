"""Parameter-safe BMP scaler width and divider patch.

This module only writes the HDL directory explicitly passed to apply(). The
default divider retains the original 32 S_DIV cycles: leading zero numerator
bits are skipped before the active dividend bits. A 19-cycle variant is
available for A/B comparison. The diagnostic pipeline is opt-in to bypass.

For 640x480 with accepted sources capped at 1024x768: stride<=3072 (12 bits),
stride*height<=2,359,296 (22 bits), and each fit-ratio numerator is at most
max(768*640,1024*480)=491,520 (19 bits). The selected quotient is <=640 (10
bits); denominator<=1024 and remainder<denominator (11 bits), while the trial
remainder needs 12 bits. Coordinates fit their frame dimensions (10/9 bits),
right/bottom edges fit frame dimension inclusive (10/9 bits), and phase maxima
are 639+1024=1663 and 479+768=1247 (11 bits). Source column/row indices fit
0..1023 and 0..767 (10 bits); sector_count reaches 512 (10 bits), and sector
tags hold the 23-bit byte address [31:9]. Width localparams use actual module
parameters intersected with the existing hard caps, so 32x24 and 8x6 test
instances keep valid widths too.
"""
from __future__ import annotations

from pathlib import Path
import argparse
import re


def _replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise ValueError(f"{label}: expected one match, found {count}")
    return text.replace(old, new, 1)


def _patch_engine(text: str, divider_cycles: int = 32) -> str:
    if divider_cycles not in (19, 32):
        raise ValueError("divider_cycles must be 19 or 32")
    old_states = """localparam [5:0] S_IDLE=0, S_DIV=1, S_DIV_FIN=2, S_SETUP=3,
 S_Y_BEGIN=4, S_Y_NORM=5, S_ROW_CHECK=6, S_BYTE=7, S_SECTOR=8,
 S_SECTOR_GAP=9, S_MEM_WAIT=10, S_BYTE_GOT=11, S_ROW_DONE=12,
 S_X_BEGIN=13, S_X_MAP=14, S_ROW_READ=15, S_ROW_READ_WAIT=16,
 S_EMIT=17, S_ADV_X=18, S_ADV_Y=19, S_TERMINAL=20, S_X_NORM=21;
"""
    new_states = old_states.replace("[5:0]", "[4:0]", 1) + """localparam integer SOURCE_WIDTH_CAP = MAX_SOURCE_WIDTH < 1024 ? MAX_SOURCE_WIDTH : 1024;
localparam integer SOURCE_HEIGHT_CAP = MAX_SOURCE_HEIGHT < 768 ? MAX_SOURCE_HEIGHT : 768;
localparam integer MAX_NUMERATOR =
    (SOURCE_HEIGHT_CAP*FRAME_WIDTH > SOURCE_WIDTH_CAP*FRAME_HEIGHT) ?
     SOURCE_HEIGHT_CAP*FRAME_WIDTH : SOURCE_WIDTH_CAP*FRAME_HEIGHT;
localparam integer MAX_DENOMINATOR =
    (SOURCE_WIDTH_CAP > SOURCE_HEIGHT_CAP) ? SOURCE_WIDTH_CAP : SOURCE_HEIGHT_CAP;
localparam integer MAX_QUOTIENT = (FRAME_WIDTH > FRAME_HEIGHT) ? FRAME_WIDTH : FRAME_HEIGHT;
localparam integer DIVIDEND_W = $clog2(MAX_NUMERATOR+1);
localparam integer DENOM_W = $clog2(MAX_DENOMINATOR+1);
localparam integer QUOTIENT_W = $clog2(MAX_QUOTIENT+1);
localparam integer X_W = FRAME_WIDTH > 1 ? $clog2(FRAME_WIDTH) : 1;
localparam integer Y_W = FRAME_HEIGHT > 1 ? $clog2(FRAME_HEIGHT) : 1;
localparam integer X_EDGE_W = $clog2(FRAME_WIDTH+1);
localparam integer Y_EDGE_W = $clog2(FRAME_HEIGHT+1);
localparam integer X_PHASE_W = $clog2(FRAME_WIDTH+SOURCE_WIDTH_CAP);
localparam integer Y_PHASE_W = $clog2(FRAME_HEIGHT+SOURCE_HEIGHT_CAP);
localparam integer INTERVAL_W = PIXEL_INTERVAL > 1 ? $clog2(PIXEL_INTERVAL) : 1;
"""
    text = _replace_once(text, old_states, new_states, "state/localparam block")

    old_regs = """reg [5:0] state;
reg [10:0] src_w;
reg [9:0] src_h;
reg [11:0] stride;
reg [31:0] dw, dh, offx, offy;
reg [31:0] numerator, denominator, quotient, remainder;
reg [5:0] div_bit;
"""
    new_regs = """reg [4:0] state;
reg [10:0] src_w;
reg [9:0] src_h;
reg [11:0] stride;
reg [X_EDGE_W-1:0] dw, offx;
reg [Y_EDGE_W-1:0] dh, offy;
reg [DIVIDEND_W-1:0] numerator;
reg [DENOM_W-1:0] denominator, remainder;
reg [QUOTIENT_W-1:0] quotient;
reg [5:0] div_bit;
"""
    text = _replace_once(text, old_regs, new_regs, "scaler registers")
    text = _replace_once(text, "reg [31:0] sector_count;", "reg [9:0] sector_count;", "sector byte counter")
    text = _replace_once(text, "reg [31:0] sector_tag;", "reg [22:0] sector_tag;", "sector tag")
    text = _replace_once(
        text,
        "reg [31:0] out_x, out_y, x_phase, y_phase;\n"
        "reg [10:0] x_src;\n"
        "reg [31:0] interval_count;",
        "reg [X_W-1:0] out_x;\n"
        "reg [Y_W-1:0] out_y;\n"
        "reg [X_PHASE_W-1:0] x_phase;\n"
        "reg [Y_PHASE_W-1:0] y_phase;\n"
        "reg [9:0] x_src;\n"
        "reg [INTERVAL_W-1:0] interval_count;",
        "coordinate/phase/interval registers",
    )
    text = _replace_once(text, "reg [10:0] src_col;", "reg [9:0] src_col;", "source column")
    text = _replace_once(text, "reg [31:0] wanted_byte_addr;\n", "", "unused wanted byte address")
    text = _replace_once(text, "reg [7:0] byte_value, blue_value, green_value;", "reg [7:0] blue_value, green_value;", "unused byte value")

    old_wires = """wire [32:0] div_shifted_rem = {1'b0,remainder[30:0],numerator[div_bit]};
wire div_subtract = div_shifted_rem >= {1'b0,denominator};
wire [32:0] div_next_rem = div_subtract ?
    div_shifted_rem - {1'b0,denominator} : div_shifted_rem;
wire [31:0] div_next_quot = div_subtract ?
    (quotient | (32'b1 << div_bit)) : quotient;
wire [31:0] output_right = offx + dw;
wire [31:0] output_bottom = offy + dh;
"""
    new_wires = """wire div_numerator_bit = (div_bit < DIVIDEND_W) ? numerator[DIVIDEND_W-1] : 1'b0;
wire [DENOM_W:0] div_shifted_rem = ({1'b0,remainder} << 1) |
    {{DENOM_W{1'b0}},div_numerator_bit};
wire div_subtract = div_shifted_rem >= {1'b0,denominator};
wire [DENOM_W:0] div_next_rem = div_subtract ?
    div_shifted_rem - {1'b0,denominator} : div_shifted_rem;
wire [QUOTIENT_W-1:0] div_next_quot = (quotient << 1) |
    {{(QUOTIENT_W-1){1'b0}},div_subtract};
wire [X_EDGE_W-1:0] output_right = offx + dw;
wire [Y_EDGE_W-1:0] output_bottom = offy + dh;
"""
    text = _replace_once(text, old_wires, new_wires, "divider/edge wires")
    if divider_cycles == 32:
        div_step = """S_DIV: begin
            remainder<=div_next_rem[DENOM_W-1:0]; quotient<=div_next_quot;
            if (div_bit < DIVIDEND_W)
                numerator<=numerator<<1;
            if (div_bit==0) state<=S_DIV_FIN;
            else div_bit<=div_bit-1'b1;
        end"""
    else:
        text = _replace_once(text, "(div_bit < DIVIDEND_W) ? numerator[DIVIDEND_W-1] : 1'b0", "numerator[DIVIDEND_W-1]", "19-cycle divider input")
        div_step = """S_DIV: begin
            remainder<=div_next_rem[DENOM_W-1:0]; quotient<=div_next_quot;
            numerator<=numerator<<1;
            if (div_bit==0) state<=S_DIV_FIN;
            else div_bit<=div_bit-1'b1;
        end"""
        text = text.replace("div_bit<=31;", "div_bit<=DIVIDEND_W-1;")
    old_step = """S_DIV: begin
            remainder<=div_next_rem[31:0]; quotient<=div_next_quot;
            if (div_bit==0) state<=S_DIV_FIN;
            else div_bit<=div_bit-1'b1;
        end"""
    text = _replace_once(text, old_step, div_step, "divider step")
    text = text.replace("wanted_byte_addr<=0;", "")
    text = text.replace("wanted_byte_addr<=byte_address_wide[31:0];\n            ", "")
    text = text.replace("byte_value<=0; ", "")
    text = text.replace("byte_value<=sector_q;\n            ", "")
    text = _replace_once(text, "sector_tag<=card_addr; sector_tag_valid<=1;", "sector_tag<=card_addr[22:0]; sector_tag_valid<=1;", "sector tag capture")
    return text


def _patch_loader(text: str) -> str:
    text = _replace_once(
        text,
        "reg [11:0] diagnostic_stride;\n"
        "reg [21:0] diagnostic_image_bytes;\n"
        "reg [32:0] diagnostic_pixel_end;\n"
        "reg [15:0] diagnostic_header_mask;\n",
        "",
        "diagnostic pipeline registers",
    )
    text = text.replace("diagnostic_pixel_end", "pixel_end")
    text = re.sub(
        r"// The header fields end by byte 33; CHECK follows the complete 512-byte\n"
        r"// sector\..*?\nend\n(?=assign card_read=)",
        """// CHECK follows the complete 512-byte header sector, so the parsed
// fields and validation wires are stable when failure detail is captured.
always @(posedge clk or posedge rst) begin
    if(rst) failure_shadow<=0;
    else if(!error) begin
        case(state)
            HEADER: if(card_end) failure_shadow<={8'h01,6'd0,sector_bytes};
            CHECK: failure_shadow<={8'h02,header_failure_mask};
            PAYLOAD: if(scale_active && scale_error)
                failure_shadow<={8'h03,8'd0,scale_failure_code};
            WAIT_CATALOG,IDLE,WRITE_WAIT,GAP,COMMIT,HALT,WAIT_DISPLAY: begin end
            default: failure_shadow<={8'h06,12'd0,state};
        endcase
        if((file_error && state!=WAIT_CATALOG) ||
           (state!=WAIT_DISPLAY && watchdog>=WAIT_LIMIT))
            failure_shadow<=file_error ? {8'h04,12'd0,state} : {8'h05,12'd0,state};
    end
end
""",
        text,
        count=1,
        flags=re.S,
    )
    return text


def apply(hdl_path: str | Path, *, widths: bool = True,
          diagnostic_direct: bool = False, divider_cycles: int = 32) -> tuple[Path, Path]:
    """Patch an isolated candidate HDL directory; diagnostics are opt-in."""
    hdl = Path(hdl_path).resolve()
    engine_path = hdl / "bmp_scale_engine.v"
    loader_path = hdl / "tf_bmp_file_player.v"
    if widths:
        engine = engine_path.read_text(encoding="utf-8-sig")
        engine_path.write_text(_patch_engine(engine, divider_cycles), encoding="utf-8", newline="\n")
    if diagnostic_direct:
        loader = loader_path.read_text(encoding="utf-8-sig")
        loader_path.write_text(_patch_loader(loader), encoding="utf-8", newline="\n")
    return engine_path, loader_path


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hdl_path", help="isolated candidate hdl_source directory")
    parser.add_argument("--widths", dest="widths", action="store_true", default=True,
                        help="apply safe scaler widths and remove unused registers (default)")
    parser.add_argument("--no-widths", dest="widths", action="store_false",
                        help="leave the scaler unchanged; combine with diagnostic-direct for an isolated test")
    parser.add_argument("--diagnostic-direct", action="store_true", help="remove passive diagnostic registers")
    parser.add_argument("--divider-cycles", choices=(19, 32), type=int, default=32,
                        help="divider iteration count; 32 preserves the current S_DIV duration")
    args = parser.parse_args()
    for path in apply(args.hdl_path, widths=args.widths,
                      diagnostic_direct=args.diagnostic_direct,
                      divider_cycles=args.divider_cycles):
        print(path)
