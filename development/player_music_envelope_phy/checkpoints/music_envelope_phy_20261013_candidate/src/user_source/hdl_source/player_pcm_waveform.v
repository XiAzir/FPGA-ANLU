`timescale 1ns/1ps
module player_pcm_waveform #(
    parameter integer CLK_FREQ_HZ = 25000000,
    parameter integer AVG_LOG2 = 8,
    parameter integer STALE_MS = 100,
    // Retained for source compatibility with the C11301 parent.
    parameter integer SAMPLES_PER_BIN = 2
) (
    input wire clk, input wire rst, input wire vs, input wire de,
    input wire [23:0] rgb_in, input wire audio_valid,
    input wire [23:0] audio_pcm, input wire tone_mode,
    input wire freeze_toggle, output wire [23:0] rgb_out
);
    localparam integer HIST_N=128, TRACE_N=512;
    localparam integer AVG_COUNT_W=(AVG_LOG2>0)?AVG_LOG2:1;
    localparam [63:0] STALE_CYCLES_64=(64'd1*CLK_FREQ_HZ*STALE_MS)/1000;
    localparam integer STALE_W=(STALE_CYCLES_64>1)?$clog2(STALE_CYCLES_64+1):1;

    reg vs_prev;
    wire vs_rise=vs && !vs_prev;
    reg tone_mode_prev;
    reg frame_tone_mode;
    reg source_pending;
    wire source_change=(tone_mode != tone_mode_prev);
    wire source_waiting=source_change || source_pending;
    wire source_boundary=vs_rise && source_waiting;
    reg freeze_requested, frozen_front;
    reg [19:0] env_q4;
    reg [23:0] abs_sum;
    reg [AVG_COUNT_W-1:0] avg_count;
    reg have_audio, stale_active;
    reg [STALE_W-1:0] stale_count;
    reg [15:0] pcm_abs;
    wire [15:0] pcm16=audio_pcm[23:8];
    always @* begin
        if (pcm16[15]) pcm_abs=(~pcm16)+16'd1;
        else pcm_abs=pcm16;
    end
    wire [24:0] abs_sum_next={1'b0,abs_sum}+{9'd0,pcm_abs};
    wire avg_last=(avg_count == {AVG_COUNT_W{1'b1}});
    wire [15:0] mean_abs=abs_sum_next[AVG_LOG2 +: 16];
    reg [19:0] env_target;
    reg [19:0] env_delta, env_step, env_updated;
    always @* begin
        env_target={mean_abs,4'b0000};
        if(env_target>=env_q4) begin
            env_delta=env_target-env_q4;
            env_step=(env_delta+20'd15)>>4;
            env_updated=env_q4+env_step;
            if(env_updated>env_target) env_updated=env_target;
        end else begin
            env_delta=env_q4-env_target;
            env_step=(env_delta+20'd63)>>6;
            env_updated=env_q4-env_step;
            if(env_updated<env_target) env_updated=env_target;
        end
        if(env_updated>20'd524288) env_updated=20'd524288;
    end
    wire [19:0] stale_step=(env_q4+20'd15)>>4;
    wire stale_expire=have_audio && !stale_active && (STALE_CYCLES_64!=0) &&
                      (stale_count==STALE_CYCLES_64-1'b1);
    wire [19:0] env_for_history=(stale_active || stale_expire) ?
                                ((env_q4>stale_step)?env_q4-stale_step:20'd0) : env_q4;
    wire [19:0] history_height_q4=(env_for_history<=20'd65536)?(env_for_history>>7):
                                  (20'd512+((env_for_history-20'd65536)>>9));
    wire [15:0] history_height=(history_height_q4>20'd832)?16'd832:history_height_q4[15:0];

    (* ram_style="block" *) reg [15:0] hist_mem [0:127];
    reg [6:0] hist_write_ptr;
    reg [7:0] hist_count;
    reg [6:0] snap_base;
    reg [7:0] snap_count;
    reg [15:0] hist_read_data;
    reg [6:0] hist_read_addr;
    reg hist_read_zero;
    reg [15:0] p0,p1,p2,p3,p3_next;
    reg [6:0] segment_index;
    reg [2:0] preload_count;
    reg [1:0] pixel_in_segment;
    reg [9:0] trace_write_index;
    reg display_bank,capture_bank,front_valid,capture_ready;
    (* ram_style="block" *) reg [15:0] trace_mem [0:1023];
    reg [15:0] trace_read_data;
    reg [2:0] build_state;
    localparam [2:0] B_IDLE=0,B_PRELOAD=1,B_PIXELS=2;

    function [6:0] logical_to_physical;
        input integer logical_index;
        input [6:0] base;
        input [7:0] count_value;
        integer pad, phys;
        begin
            pad=128-count_value;
            phys=(base+logical_index-pad)&127;
            logical_to_physical=phys[6:0];
        end
    endfunction
    integer hist_logical;
    always @* begin
        hist_logical=0;
        hist_read_zero=1'b0;
        if(build_state==B_PRELOAD) begin
            case(preload_count)
                0: hist_logical=(segment_index==0)?0:segment_index-1;
                1: hist_logical=segment_index;
                2: hist_logical=(segment_index==127)?127:segment_index+1;
                default: hist_logical=(segment_index>=126)?127:segment_index+2;
            endcase
            // Clamp endpoints first, then still mask left-padded startup slots.
            if(hist_logical < 128-snap_count) hist_read_zero=1'b1;
            hist_read_addr=logical_to_physical(hist_logical,snap_base,snap_count);
        end else if(build_state==B_PIXELS && pixel_in_segment==0 && segment_index<127) begin
            hist_logical=(segment_index>=124)?127:segment_index+3;
            if(hist_logical < 128-snap_count) hist_read_zero=1'b1;
            hist_read_addr=logical_to_physical(hist_logical,snap_base,snap_count);
        end else begin
            hist_read_addr=7'd0;
            hist_read_zero=1'b1;
        end
    end
    always @(posedge clk) begin
        hist_read_data <= hist_read_zero ? 16'd0 : hist_mem[hist_read_addr];
    end

    // Signed constant shifts preserve the exact Catmull-Rom numerator while
    // preventing TD from mapping these small coefficients to extra DSPs.
    wire signed [21:0] c0=$signed({6'b0,p0});
    wire signed [21:0] c1=$signed({6'b0,p1});
    wire signed [21:0] c2=$signed({6'b0,p2});
    wire signed [21:0] c3=$signed({6'b0,p3});
    wire signed [21:0] c0x9=(c0<<<3)+c0;
    wire signed [21:0] c0x3=(c0<<<1)+c0;
    wire signed [21:0] c1x111=(c1<<<7)-(c1<<<4)-c1;
    wire signed [21:0] c1x29=(c1<<<5)-(c1<<<1)-c1;
    wire signed [21:0] c1x72=(c1<<<6)+(c1<<<3);
    wire signed [21:0] c2x111=(c2<<<7)-(c2<<<4)-c2;
    wire signed [21:0] c2x29=(c2<<<5)-(c2<<<1)-c2;
    wire signed [21:0] c2x72=(c2<<<6)+(c2<<<3);
    wire signed [21:0] c3x9=(c3<<<3)+c3;
    wire signed [21:0] c3x3=(c3<<<1)+c3;
    reg signed [21:0] interp_num;
    reg signed [21:0] interp_value;
    reg [15:0] interp_height;
    reg [15:0] interp_lo,interp_hi;
    always @* begin
        case(pixel_in_segment)
            0: interp_num=c1<<<7;
            1: interp_num=-c0x9+c1x111+c2x29-c3x3;
            2: interp_num=-(c0<<<3)+c1x72+c2x72-(c3<<<3);
            default: interp_num=-c0x3+c1x29+c2x111-c3x9;
        endcase
        interp_value=interp_num >>> 7;
        interp_lo=(p1<p2)?p1:p2;
        interp_hi=(p1>p2)?p1:p2;
        if(interp_value<0) interp_height=interp_lo;
        else if(interp_value<$signed({1'b0,interp_lo})) interp_height=interp_lo;
        else if(interp_value>$signed({1'b0,interp_hi})) interp_height=interp_hi;
        else interp_height=interp_value[15:0];
        if(interp_height>16'd832) interp_height=16'd832;
    end
    wire [9:0] trace_write_addr={segment_index,2'b00}+{8'd0,pixel_in_segment};
    always @(posedge clk) begin
        if(build_state==B_PIXELS && !source_waiting && !rst)
            trace_mem[{capture_bank,trace_write_addr[8:0]}] <= interp_height;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            vs_prev<=0; tone_mode_prev<=0; freeze_requested<=0;
            env_q4<=0; abs_sum<=0; avg_count<=0; have_audio<=0;
            stale_active<=0; stale_count<=0;
        end else begin
            vs_prev<=vs;
            tone_mode_prev<=tone_mode;
            if(freeze_toggle) freeze_requested<=!freeze_requested;
            if(source_change) begin
                env_q4<=0; abs_sum<=0; avg_count<=0; have_audio<=0;
            stale_active<=0; stale_count<=0; freeze_requested<=0;
            end else if(audio_valid) begin
                have_audio<=1; stale_active<=0; stale_count<=0;
                if(avg_last) begin
                    abs_sum<=0; avg_count<=0; env_q4<=env_updated;
                end else begin
                    abs_sum<=abs_sum_next[23:0]; avg_count<=avg_count+1'b1;
                end
            end else if(have_audio && !stale_active) begin
                if(stale_expire) begin
                    stale_active<=1; stale_count<=0; abs_sum<=0; avg_count<=0;
                end else stale_count<=stale_count+1'b1;
            end
            if(vs_rise && (stale_active || stale_expire) && !source_change)
                env_q4<=env_for_history;
            // A pending source change also wins over a new HOLD request on
            // its committing VS edge; do not carry that request to next frame.
            if(source_boundary) freeze_requested<=0;
        end
    end

    // Capture newest envelope once per VS; snapshot is taken after this write.
    wire history_push=vs_rise && !source_waiting && !freeze_requested && !rst;
    always @(posedge clk) begin
        if(history_push) hist_mem[hist_write_ptr] <= history_height;
    end
    wire [7:0] count_after=(hist_count<128)?hist_count+1'b1:8'd128;
    wire [6:0] base_after=(hist_count==128)?hist_write_ptr+1'b1:7'd0;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            hist_write_ptr<=0; hist_count<=0;
            display_bank<=0; capture_bank<=1; front_valid<=0; capture_ready<=0;
            build_state<=B_IDLE; segment_index<=0; preload_count<=0; pixel_in_segment<=0;
            snap_base<=0; snap_count<=0; p0<=0;p1<=0;p2<=0;p3<=0;p3_next<=0;
            frozen_front<=0; frame_tone_mode<=0; source_pending<=0;
        end else if(source_boundary) begin
            hist_write_ptr<=0; hist_count<=0;
            front_valid<=0; capture_ready<=0; build_state<=B_IDLE;
            frozen_front<=0; frame_tone_mode<=tone_mode; source_pending<=0;
        end else if(source_waiting) begin
            // Abort only the unpublished back table. Keep visible state and
            // title intact until the next VS commits the source change.
            source_pending<=1;
            capture_ready<=0; build_state<=B_IDLE;
        end else begin
            if(history_push) begin
                hist_write_ptr<=hist_write_ptr+1'b1;
                if(hist_count<128) hist_count<=hist_count+1'b1;
            end
            if(build_state==B_PRELOAD) begin
                case(preload_count)
                    1:p0<=hist_read_data;
                    2:p1<=hist_read_data;
                    3:p2<=hist_read_data;
                    4:p3<=hist_read_data;
                    default: begin end
                endcase
                if(preload_count<4) preload_count<=preload_count+1'b1;
                else begin build_state<=B_PIXELS; pixel_in_segment<=0; end
            end else if(build_state==B_PIXELS) begin
                if(pixel_in_segment==1) p3_next<=hist_read_data;
                if(pixel_in_segment==3) begin
                    if(segment_index==127) begin
                        build_state<=B_IDLE; capture_ready<=1;
                    end else begin
                        p0<=p1; p1<=p2; p2<=p3; p3<=p3_next;
                        segment_index<=segment_index+1'b1; pixel_in_segment<=0;
                    end
                end else pixel_in_segment<=pixel_in_segment+1'b1;
            end
            if(vs_rise) begin
                frame_tone_mode<=tone_mode;
                if(freeze_requested) begin
                    frozen_front<=1; build_state<=B_IDLE; capture_ready<=0;
                end else if(capture_ready) begin
                    display_bank<=capture_bank; capture_bank<=display_bank;
                    front_valid<=1; capture_ready<=0;
                end
                if(!freeze_requested && frozen_front) begin
                    frozen_front<=0;
                    snap_base<=base_after; snap_count<=count_after;
                    segment_index<=0; preload_count<=0; build_state<=B_PRELOAD; capture_ready<=0;
                end else if(!freeze_requested && !frozen_front) begin
                    snap_base<=base_after; snap_count<=count_after;
                    segment_index<=0; preload_count<=0; build_state<=B_PRELOAD; capture_ready<=0;
                end
            end
        end
    end

    reg [9:0] x_pos;
    reg [8:0] y_pos;
    reg de_prev,arm_first_line;
    wire [10:0] next_x_pos={1'b0,x_pos}+11'd1;
    wire [8:0] predicted_bin=(next_x_pos<=11'd64)?9'd0:
                              (next_x_pos>=11'd576)?9'd511:(next_x_pos-11'd64);
    always @(posedge clk) trace_read_data<=trace_mem[{display_bank,predicted_bin}];
    always @(posedge clk or posedge rst) begin
        if(rst) begin x_pos<=0;y_pos<=0;de_prev<=0;arm_first_line<=1; end
        else begin
            de_prev<=de;
            if(vs!=vs_prev) begin x_pos<=0;y_pos<=0;arm_first_line<=1; end
            else if(de) begin
                x_pos<=x_pos+1'b1;
                if(!de_prev && arm_first_line) begin y_pos<=0;arm_first_line<=0;end
            end else begin
                x_pos<=0;
                if(de_prev && y_pos!=511) y_pos<=y_pos+1'b1;
            end
        end
    end    function [4:0] glyph_row;
        input [7:0] character;
        input [2:0] row;
        begin
            glyph_row = 5'b00000;
            case (character)
                "H": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b11111; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "L": case (row)
                    0:glyph_row=5'b10000; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b10000; 4:glyph_row=5'b10000; 5:glyph_row=5'b10000;
                    6:glyph_row=5'b11111; default:glyph_row=5'b00000;
                endcase
                "D": case (row)
                    0:glyph_row=5'b11110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b10001; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b11110; default:glyph_row=5'b00000;
                endcase
                "P": case (row)
                    0:glyph_row=5'b11110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b11110; 4:glyph_row=5'b10000; 5:glyph_row=5'b10000;
                    6:glyph_row=5'b10000; default:glyph_row=5'b00000;
                endcase
                "C": case (row)
                    0:glyph_row=5'b01111; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b10000; 4:glyph_row=5'b10000; 5:glyph_row=5'b10000;
                    6:glyph_row=5'b01111; default:glyph_row=5'b00000;
                endcase
                "M": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b11011; 2:glyph_row=5'b10101;
                    3:glyph_row=5'b10101; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "T": case (row)
                    0:glyph_row=5'b11111; 1:glyph_row=5'b00100; 2:glyph_row=5'b00100;
                    3:glyph_row=5'b00100; 4:glyph_row=5'b00100; 5:glyph_row=5'b00100;
                    6:glyph_row=5'b00100; default:glyph_row=5'b00000;
                endcase
                "O": case (row)
                    0:glyph_row=5'b01110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b10001; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b01110; default:glyph_row=5'b00000;
                endcase
                "N": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b11001; 2:glyph_row=5'b10101;
                    3:glyph_row=5'b10011; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "E": case (row)
                    0:glyph_row=5'b11111; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b11110; 4:glyph_row=5'b10000; 5:glyph_row=5'b10000;
                    6:glyph_row=5'b11111; default:glyph_row=5'b00000;
                endcase
                "W": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b10101; 4:glyph_row=5'b10101; 5:glyph_row=5'b10101;
                    6:glyph_row=5'b01010; default:glyph_row=5'b00000;
                endcase
                "A": case (row)
                    0:glyph_row=5'b01110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b11111; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "V": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b10001; 4:glyph_row=5'b10001; 5:glyph_row=5'b01010;
                    6:glyph_row=5'b00100; default:glyph_row=5'b00000;
                endcase
                "X": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b10001; 2:glyph_row=5'b01010;
                    3:glyph_row=5'b00100; 4:glyph_row=5'b01010; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "4": case (row)
                    0:glyph_row=5'b10010; 1:glyph_row=5'b10010; 2:glyph_row=5'b10010;
                    3:glyph_row=5'b11111; 4:glyph_row=5'b00010; 5:glyph_row=5'b00010;
                    6:glyph_row=5'b00010; default:glyph_row=5'b00000;
                endcase
                default: glyph_row = 5'b00000;
            endcase
        end
    endfunction
    reg [7:0] title_character;
    reg [3:0] title_character_index;
    reg [2:0] title_glyph_row_index;
    reg [2:0] title_glyph_column;
    reg [4:0] title_glyph_bits;
    reg title_glyph_on;
    wire [9:0] title_x=x_pos-10'd24;
    wire [8:0] title_y=y_pos-9'd328;
    always @* begin
        title_character_index=title_x[7:4]; title_character=8'h20;
        if(frozen_front) begin
            case(title_character_index)
                0:title_character="H"; 1:title_character="O"; 2:title_character="L"; 3:title_character="D";
                4:title_character=8'h20; 5:title_character=frame_tone_mode?"T":"W";
                6:title_character=frame_tone_mode?"O":"A"; 7:title_character=frame_tone_mode?"N":"V";
                8:title_character=frame_tone_mode?"E":8'h20; default:title_character=8'h20;
            endcase
        end else begin
            case(title_character_index)
                0:title_character="E"; 1:title_character="N"; 2:title_character="V"; 3:title_character=8'h20;
                4:title_character=frame_tone_mode?"T":"W"; 5:title_character=frame_tone_mode?"O":"A";
                6:title_character=frame_tone_mode?"N":"V"; 7:title_character=frame_tone_mode?"E":8'h20;
                default:title_character=8'h20;
            endcase
        end
        title_glyph_row_index=title_y[3:1]; title_glyph_column=title_x[3:1];
        title_glyph_bits=glyph_row(title_character,title_glyph_row_index);
        title_glyph_on=(title_x<10'd208 && title_y<9'd16 && title_glyph_column<5 && title_glyph_row_index<7)?
                       title_glyph_bits[4-title_glyph_column]:1'b0;
    end
    reg [23:0] color_main,color_glow;
    function [23:0] main_color;
        input [4:0] a;
        begin case(a)
            0:main_color=24'h070b12;
            1:main_color=24'h0b181e;
            2:main_color=24'h0f252a;
            3:main_color=24'h133236;
            4:main_color=24'h173f42;
            5:main_color=24'h1b4c4e;
            6:main_color=24'h1f595a;
            7:main_color=24'h236666;
            8:main_color=24'h277372;
            9:main_color=24'h2b807e;
            10:main_color=24'h2f8d8a;
            11:main_color=24'h339a96;
            12:main_color=24'h37a7a2;
            13:main_color=24'h3bb4ae;
            14:main_color=24'h3fc1ba;
            15:main_color=24'h43cec6;
            16:main_color=24'h48dcd2;
            default:main_color=24'h070b12;
        endcase end
    endfunction
    function [23:0] glow_color;
        input [4:0] a;
        begin case(a)
            0:glow_color=24'h070b12;
            1:glow_color=24'h070b12;
            2:glow_color=24'h070c13;
            3:glow_color=24'h070d14;
            4:glow_color=24'h080e15;
            5:glow_color=24'h080f15;
            6:glow_color=24'h080f16;
            7:glow_color=24'h081017;
            8:glow_color=24'h091118;
            9:glow_color=24'h091218;
            10:glow_color=24'h091319;
            11:glow_color=24'h09131a;
            12:glow_color=24'h0a141b;
            13:glow_color=24'h0a151b;
            14:glow_color=24'h0a161c;
            15:glow_color=24'h0a171d;
            16:glow_color=24'h0b181e;
            default:glow_color=24'h070b12;
        endcase end
    endfunction
    wire in_panel=x_pos>=16 && x_pos<624 && y_pos>=320 && y_pos<424;
    wire panel_edge=(x_pos==16)||(x_pos==623)||(y_pos==320)||(y_pos==423);
    wire in_title_box=x_pos>=24 && x_pos<232 && y_pos>=328 && y_pos<344;
    wire in_graph=x_pos>=64 && x_pos<576 && y_pos>=356 && y_pos<=412;
    wire [15:0] trace_height=front_valid?trace_read_data:16'd0;
    wire [15:0] curve_height=trace_height;
    wire signed [13:0] row_q4=($signed(14'sd408)-$signed({5'd0,y_pos})) <<< 4;
    wire signed [14:0] distance_signed=$signed({row_q4[13],row_q4})-$signed({1'b0,curve_height});
    wire [14:0] edge_distance=distance_signed[14]?-distance_signed:distance_signed;
    wire [4:0] alpha_main=(edge_distance<16)?16-edge_distance:0;
    wire [4:0] alpha_glow=(edge_distance>=16 && edge_distance<32)?32-edge_distance:0;
    wire curve_pixel=(front_valid && edge_distance<32);
    wire [23:0] draw_rgb=curve_pixel?(edge_distance<16?main_color(alpha_main):glow_color(alpha_glow)):
                         ((y_pos==408)?24'h17212c:24'h070b12);
    assign rgb_out=!de?rgb_in:(!in_panel?rgb_in:(panel_edge?24'h000000:
                    (in_title_box?(title_glyph_on?24'hffffff:24'h000000):
                     (in_graph?draw_rgb:24'h070b12))));
endmodule
