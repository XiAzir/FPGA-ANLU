`timescale 1ns/1ps
module player_pcm_waveform #(
    parameter integer CLK_FREQ_HZ = 25000000,
    parameter integer SAMPLES_PER_BIN = 2,
    parameter integer STALE_MS = 100
) (
    input  wire        clk,
    input  wire        rst,
    input  wire        vs,
    input  wire        de,
    input  wire [23:0] rgb_in,
    input  wire        audio_valid,
    input  wire [23:0] audio_pcm,
    input  wire        tone_mode,
    input  wire        freeze_toggle,
    output wire [23:0] rgb_out
);
    localparam integer BINS = 512;
    localparam integer SAMPLE_COUNT_WIDTH = (SAMPLES_PER_BIN > 1) ? $clog2(SAMPLES_PER_BIN) : 1;
    localparam integer BIN_COUNT_WIDTH = $clog2(BINS + 1);
    localparam [63:0] STALE_CYCLES_64 = (64'd1 * CLK_FREQ_HZ * STALE_MS) / 1000;
    localparam integer STALE_COUNT_WIDTH = (STALE_CYCLES_64 > 1) ? $clog2(STALE_CYCLES_64 + 1) : 1;

    // Each bank stores 512 {maximum,minimum} Q2 pairs, each 9 bits. The array is
    // intentionally never reset; front_valid masks its contents until a full
    // capture has been swapped into view.
    (* ram_style = "bram" *) reg [17:0] trace_mem [0:1023];
    reg [17:0] trace_read_data;
    reg display_bank;
    reg capture_bank;
    reg front_valid;
    reg capture_ready;
    reg [BIN_COUNT_WIDTH-1:0] capture_bin;
    reg [SAMPLE_COUNT_WIDTH-1:0] samples_in_bin;
    reg [8:0] bin_min;
    reg [8:0] bin_max;
    reg capture_active;
    reg tone_mode_prev;
    reg frame_tone_mode;
    reg invalidate_pending;
    reg vs_prev;
    reg stale_pending;
    reg have_audio;
    reg [STALE_COUNT_WIDTH-1:0] stale_count;
    reg freeze_requested;
    reg frozen_front;

    reg [9:0] x_pos;
    reg [8:0] y_pos;
    reg de_prev;
    reg arm_first_line;

    wire vs_rise = vs && !vs_prev;
    wire tone_mode_change = tone_mode != tone_mode_prev;
    wire stale_expire = have_audio && !audio_valid && !stale_pending && !frozen_front &&
                        (STALE_CYCLES_64 != 0) &&
                        (stale_count == STALE_CYCLES_64 - 1'b1);
    wire capture_accept = !rst && audio_valid && capture_active && !capture_ready &&
                          !stale_pending && !stale_expire && !tone_mode_change &&
                          !vs_rise && !frozen_front;

    reg signed [15:0] pcm16;
    reg signed [10:0] sample_code_signed;
    reg [8:0] sample_code;
    reg [8:0] next_min;
    reg [8:0] next_max;
    reg [17:0] completed_bin_data;
    always @* begin
        pcm16 = $signed(audio_pcm[23:8]);
        // Arithmetic shift is floor division for negative two's-complement
        // values. One Q2 unit is 64 PCM counts; four units are one pixel.
        // Same 4x display gain and 57 physical rows as the parent.
        sample_code_signed = (pcm16 >>> 6) + 11'sd112;
        if (sample_code_signed < 0)
            sample_code = 9'd0;
        else if (sample_code_signed > 11'sd224)
            sample_code = 9'd224;
        else
            sample_code = sample_code_signed[8:0];

        if (samples_in_bin == 0) begin
            next_min = sample_code;
            next_max = sample_code;
        end else begin
            next_min = (sample_code < bin_min) ? sample_code : bin_min;
            next_max = (sample_code > bin_max) ? sample_code : bin_max;
        end
        completed_bin_data = {next_max, next_min};
    end

    // True dual-bank capture lifecycle. A completed capture waits for VS rise,
    // then the banks swap atomically and the old display bank becomes writable.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            display_bank  <= 1'b0;
            capture_bank  <= 1'b1;
            front_valid   <= 1'b0;
            capture_ready <= 1'b0;
            capture_bin   <= {BIN_COUNT_WIDTH{1'b0}};
            samples_in_bin<= {SAMPLE_COUNT_WIDTH{1'b0}};
            bin_min       <= 9'd0;
            bin_max       <= 9'd0;
            capture_active<= 1'b1;
            tone_mode_prev<= 1'b0;
            frame_tone_mode<= 1'b0;
            invalidate_pending <= 1'b0;
            vs_prev       <= 1'b0;
            stale_pending <= 1'b0;
            have_audio    <= 1'b0;
            stale_count   <= {STALE_COUNT_WIDTH{1'b0}};
            freeze_requested <= 1'b0;
            frozen_front <= 1'b0;
        end else begin
            vs_prev <= vs;
            tone_mode_prev <= tone_mode;
            if (vs_rise)
                frame_tone_mode <= tone_mode;

            // Only the passive display observer is paused. A registered key
            // request commits at VS; a request on that same edge waits for the
            // next VS. Hold the already visible front, not a later audio window.
            if (freeze_toggle)
                freeze_requested <= !freeze_requested;

            if (audio_valid) begin
                have_audio  <= 1'b1;
                stale_count <= {STALE_COUNT_WIDTH{1'b0}};
            end else if (have_audio && !stale_pending && !frozen_front) begin
                if (stale_expire) begin
                    stale_pending <= 1'b1;
                    capture_active <= 1'b0;
                end else begin
                    stale_count <= stale_count + 1'b1;
                end
            end

            if (tone_mode_change) begin
                freeze_requested <= 1'b0;
                frozen_front <= 1'b0;
                capture_ready  <= 1'b0;
                capture_bin    <= {BIN_COUNT_WIDTH{1'b0}};
                samples_in_bin <= {SAMPLE_COUNT_WIDTH{1'b0}};
                bin_min        <= 9'd0;
                bin_max        <= 9'd0;
                capture_active <= 1'b1;
                stale_pending  <= 1'b0;
                stale_count    <= {STALE_COUNT_WIDTH{1'b0}};
                if (vs_rise) begin
                    front_valid <= 1'b0;
                    invalidate_pending <= 1'b0;
                end else begin
                    invalidate_pending <= 1'b1;
                end
            end else if (frozen_front) begin
                // Hold the entire front bank indefinitely, even during silence.
                // Resume discards the partial back bank at VS, then captures
                // a new complete window while retaining the old visible front.
                capture_active <= 1'b0;
                capture_ready <= 1'b0;
                if (vs_rise && !freeze_requested) begin
                    frozen_front <= 1'b0;
                    capture_active <= 1'b1;
                    capture_bank <= ~display_bank;
                    capture_bin <= {BIN_COUNT_WIDTH{1'b0}};
                    samples_in_bin <= {SAMPLE_COUNT_WIDTH{1'b0}};
                    bin_min <= 9'd0;
                    bin_max <= 9'd0;
                    stale_pending <= 1'b0;
                    stale_count <= {STALE_COUNT_WIDTH{1'b0}};
                    have_audio <= audio_valid;
                end
            end else if (vs_rise && freeze_requested && front_valid && !invalidate_pending) begin
                // Stop on the current visible front even if a newer back bank
                // is ready. No read address/bank changes during active video.
                frozen_front <= 1'b1;
                capture_active <= 1'b0;
                capture_ready <= 1'b0;
                stale_pending <= 1'b0;
            end else if ((stale_pending || stale_expire) && vs_rise) begin
                front_valid    <= 1'b0;
                capture_ready  <= 1'b0;
                capture_bin    <= {BIN_COUNT_WIDTH{1'b0}};
                samples_in_bin <= {SAMPLE_COUNT_WIDTH{1'b0}};
                bin_min        <= 9'd0;
                bin_max        <= 9'd0;
                capture_active <= 1'b1;
                capture_bank   <= ~display_bank;
                stale_pending  <= 1'b0;
                stale_count    <= {STALE_COUNT_WIDTH{1'b0}};
                invalidate_pending <= 1'b0;
            end else if (vs_rise) begin
                if (capture_ready) begin
                    display_bank  <= capture_bank;
                    capture_bank  <= display_bank;
                    front_valid   <= 1'b1;
                    capture_ready <= 1'b0;
                    capture_bin   <= {BIN_COUNT_WIDTH{1'b0}};
                    samples_in_bin<= {SAMPLE_COUNT_WIDTH{1'b0}};
                    capture_active<= !freeze_requested;
                    frozen_front <= freeze_requested;
                    invalidate_pending <= 1'b0;
                end else if (invalidate_pending) begin
                    front_valid <= 1'b0;
                    invalidate_pending <= 1'b0;
                end
            end else if (stale_expire) begin
                stale_pending  <= 1'b1;
                capture_active <= 1'b0;
            end else if (capture_accept) begin
                bin_min <= next_min;
                bin_max <= next_max;
                if (samples_in_bin == SAMPLES_PER_BIN - 1) begin
                    samples_in_bin <= {SAMPLE_COUNT_WIDTH{1'b0}};
                    bin_min <= 9'd0;
                    bin_max <= 9'd0;
                    if (capture_bin == BINS - 1) begin
                        capture_bin    <= BINS;
                        capture_ready  <= 1'b1;
                        capture_active <= 1'b0;
                    end else begin
                        capture_bin <= capture_bin + 1'b1;
                    end
                end else begin
                    samples_in_bin <= samples_in_bin + 1'b1;
                end
            end
        end
    end

    // Write only the completed min/max pair. Accepted audio and clear/swap
    // events are mutually gated above, so an edge cannot leak an old source
    // sample into a newly reset window.
    always @(posedge clk) begin
        if (capture_accept && samples_in_bin == SAMPLES_PER_BIN - 1)
            trace_mem[{capture_bank, capture_bin[8:0]}] <= completed_bin_data;
    end

    wire [10:0] next_x_pos = {1'b0, x_pos} + 11'd1;
    wire [8:0] predicted_bin = (next_x_pos <= 11'd64) ? 9'd0 :
                               (next_x_pos >= 11'd576) ? 9'd511 :
                               (next_x_pos - 11'd64);
    always @(posedge clk) begin
        trace_read_data <= trace_mem[{display_bank, predicted_bin}];
    end

    // Pixel coordinates follow the active-video edge convention used by the
    // neighboring OSD modules. Either VS transition arms the first active line.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_pos          <= 10'd0;
            y_pos          <= 9'd0;
            de_prev        <= 1'b0;
            arm_first_line <= 1'b1;
        end else begin
            de_prev <= de;
            if (vs != vs_prev) begin
                x_pos          <= 10'd0;
                y_pos          <= 9'd0;
                arm_first_line <= 1'b1;
            end else if (de) begin
                x_pos <= x_pos + 10'd1;
                if (!de_prev && arm_first_line) begin
                    y_pos          <= 9'd0;
                    arm_first_line <= 1'b0;
                end
            end else begin
                x_pos <= 10'd0;
                if (de_prev && y_pos != 9'd511)
                    y_pos <= y_pos + 9'd1;
            end
        end
    end

    function [4:0] glyph_row;
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
    wire [9:0] title_x = x_pos - 10'd24;
    wire [8:0] title_y = y_pos - 9'd328;
    always @* begin
        title_character_index = title_x[7:4];
        title_character = 8'h20;
        if (frozen_front) begin
            case (title_character_index)
                0:title_character="H"; 1:title_character="O"; 2:title_character="L";
                3:title_character="D"; 4:title_character=8'h20;
                5:title_character=frame_tone_mode ? "T" : "W";
                6:title_character=frame_tone_mode ? "O" : "A";
                7:title_character=frame_tone_mode ? "N" : "V";
                8:title_character=frame_tone_mode ? "E" : 8'h20;
                9:title_character=frame_tone_mode ? 8'h20 : "X";
                10:title_character=frame_tone_mode ? "X" : "4";
                11:title_character=frame_tone_mode ? "4" : 8'h20;
                default:title_character=8'h20;
            endcase
        end else if (frame_tone_mode) begin
            case (title_character_index)
                0:title_character="P"; 1:title_character="C"; 2:title_character="M";
                3: title_character=8'h20;
                4:title_character="T"; 5:title_character="O"; 6:title_character="N";
                7:title_character="E"; 8: title_character=8'h20;
                9:title_character="X"; 10:title_character="4";
                default:title_character=8'h20;
            endcase
        end else begin
            case (title_character_index)
                0:title_character="P"; 1:title_character="C"; 2:title_character="M";
                3:title_character=8'h20;
                4:title_character="W"; 5:title_character="A"; 6:title_character="V";
                7:title_character=8'h20; 8:title_character="X"; 9:title_character="4";
                default:title_character=8'h20;
            endcase
        end
        title_glyph_row_index = title_y[3:1];
        title_glyph_column = title_x[3:1];
        title_glyph_bits = glyph_row(title_character, title_glyph_row_index);
        title_glyph_on = (title_x < 10'd208 && title_y < 9'd16 &&
                          title_glyph_column < 3'd5 && title_glyph_row_index < 3'd7) ?
                         title_glyph_bits[4-title_glyph_column] : 1'b0;
    end

    wire in_panel = x_pos >= 10'd16 && x_pos < 10'd624 &&
                    y_pos >= 9'd320 && y_pos < 9'd424;
    wire panel_edge = (x_pos == 10'd16) || (x_pos == 10'd623) ||
                      (y_pos == 9'd320) || (y_pos == 9'd423);
    wire in_title_box = x_pos >= 10'd24 && x_pos < 10'd232 &&
                        y_pos >= 9'd328 && y_pos < 9'd344;
    wire in_graph = x_pos >= 10'd64 && x_pos < 10'd576 &&
                    y_pos >= 9'd356 && y_pos <= 9'd412;
    wire [8:0] display_max = trace_read_data[17:9];
    wire [8:0] display_min = trace_read_data[8:0];
    wire [9:0] midpoint_sum = {1'b0, display_max} + {1'b0, display_min};
    wire [8:0] display_mid = midpoint_sum[9:1];
    reg [8:0] previous_mid;
    reg previous_valid;

    // At the next pixel edge the synchronous read advances to column N+1,
    // while this register captures column N. Reset the neighbor at each row
    // and keep column zero independent of blanking/clamped RAM reads.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_mid <= 9'd0;
            previous_valid <= 1'b0;
        end else if (!de || !in_graph || vs != vs_prev) begin
            previous_valid <= 1'b0;
        end else begin
            previous_mid <= display_mid;
            previous_valid <= front_valid;
        end
    end
    wire use_previous = previous_valid && x_pos != 10'd64;
    // Draw each connecting segment in its right-hand column exactly once.
    wire [8:0] join_min = use_previous && previous_mid < display_mid ? previous_mid : display_mid;
    wire [8:0] join_max = use_previous && previous_mid > display_mid ? previous_mid : display_mid;
    wire [8:0] line_min = join_min < display_min ? join_min : display_min;
    wire [8:0] line_max = join_max > display_max ? join_max : display_max;
    wire [8:0] row_code = (9'd412 - y_pos) << 2;
    wire [8:0] edge_distance = row_code < line_min ? line_min - row_code :
                              row_code > line_max ? row_code - line_max : 9'd0;
    wire bar_pixel = front_valid && edge_distance < 9'd4;
    wire [23:0] trace_rgb = edge_distance == 0 ? 24'h00ffff :
                           edge_distance == 1 ? 24'h00bfbf :
                           edge_distance == 2 ? 24'h007f7f : 24'h003f3f;

    assign rgb_out = !de ? rgb_in :
                     (!in_panel ? rgb_in :
                      (panel_edge ? 24'h000000 :
                       (in_title_box ? (title_glyph_on ? 24'hffffff : 24'h000000) :
                        (in_graph ? (bar_pixel ? trace_rgb :
                                     ((y_pos == 9'd384) ? 24'h404040 : 24'h000000)) :
                         24'h000000))));
endmodule
