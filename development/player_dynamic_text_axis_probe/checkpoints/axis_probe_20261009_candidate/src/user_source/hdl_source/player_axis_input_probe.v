// Passive AXI-video input observer. It never drives or qualifies the observed stream.
module player_axis_input_probe #(
    parameter integer WIDTH = 640,
    parameter integer HEIGHT = 480,
    parameter integer FRAME_CYCLES = 420000
)(
    input wire clk,
    input wire rst,
    input wire valid,
    input wire user,
    input wire last,
    input wire ready,
    input wire locked,
    output wire [3:0] flags,
    output reg [23:0] dims,
    output reg [23:0] frame_period,
    output reg [23:0] frame_pixels,
    output reg [23:0] bad_counts,
    output reg [23:0] gap_ready,
    output reg [23:0] frame_last_count,
    output reg [23:0] user_frames
);
    reg locked_ever, valid_seen, user_seen;
    reg prev_valid;
    reg in_frame;
    reg [23:0] period_count, pixel_count, line_width, row_count, last_count;
    reg [11:0] bad_line_count, bad_frame_count;
    reg [23:0] blank_count;
    reg [11:0] ready_low_count, bad_user_count, user_frame_count;

    assign flags = {locked, locked_ever, valid_seen, user_seen};

    function [23:0] sat_inc24;
        input [23:0] value;
        begin sat_inc24 = (&value) ? value : value + 24'd1; end
    endfunction

    function [11:0] sat12;
        input [23:0] value;
        begin sat12 = (value > 24'd4095) ? 12'hfff : value[11:0]; end
    endfunction

    function [11:0] sat_inc12;
        input [11:0] value;
        begin sat_inc12 = (&value) ? value : value + 12'd1; end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            locked_ever <= 1'b0; valid_seen <= 1'b0; user_seen <= 1'b0;
            prev_valid <= 1'b0; in_frame <= 1'b0;
            period_count <= 24'd0; pixel_count <= 24'd0; line_width <= 24'd0;
            row_count <= 24'd0; last_count <= 24'd0;
            bad_line_count <= 12'd0; bad_frame_count <= 12'd0;
            blank_count <= 24'd0; ready_low_count <= 12'd0;
            bad_user_count <= 12'd0; user_frame_count <= 12'd0;
            dims <= 24'd0; frame_period <= 24'd0; frame_pixels <= 24'd0;
            bad_counts <= 24'd0; gap_ready <= 24'd0;
            frame_last_count <= 24'd0; user_frames <= 24'd0;
        end else begin
            if (locked) locked_ever <= 1'b1;
            if (valid) valid_seen <= 1'b1;
            if (user) user_seen <= 1'b1;
            prev_valid <= valid;

            if (user && (!valid || prev_valid)) begin
                bad_user_count <= sat_inc12(bad_user_count);
                user_frames[23:12] <= sat_inc12(bad_user_count);
            end

            if (valid && !ready) begin
                ready_low_count <= sat_inc12(ready_low_count);
                gap_ready[11:0] <= sat_inc12(ready_low_count);
            end

            if (valid && user) begin
                if (in_frame) begin
                    frame_period <= sat_inc24(period_count);
                    frame_pixels <= pixel_count;
                    frame_last_count <= last_count;
                    dims[11:0] <= sat12(row_count);
                    if (row_count != HEIGHT || pixel_count != (WIDTH * HEIGHT) ||
                        sat_inc24(period_count) != FRAME_CYCLES)
                        bad_frame_count <= sat_inc12(bad_frame_count);
                    if (row_count != HEIGHT || pixel_count != (WIDTH * HEIGHT) ||
                        sat_inc24(period_count) != FRAME_CYCLES)
                        bad_counts[11:0] <= sat_inc12(bad_frame_count);
                end
                in_frame <= 1'b1;
                period_count <= 24'd0;
                pixel_count <= 24'd1;
                line_width <= 24'd1;
                row_count <= 24'd0;
                last_count <= last ? 24'd1 : 24'd0;
                blank_count <= 24'd0;
                user_frame_count <= sat_inc12(user_frame_count);
                user_frames[11:0] <= sat_inc12(user_frame_count);
            end else begin
                if (in_frame) period_count <= sat_inc24(period_count);
                if (valid) begin
                    if (in_frame) pixel_count <= sat_inc24(pixel_count);
                    line_width <= sat_inc24(line_width);
                    if (last) last_count <= sat_inc24(last_count);
                    blank_count <= 24'd0;
                end else begin
                    if (in_frame) blank_count <= sat_inc24(blank_count);
                    if (prev_valid && in_frame) begin
                        dims[23:12] <= sat12(line_width);
                        if (line_width != WIDTH) begin
                            bad_line_count <= sat_inc12(bad_line_count);
                            bad_counts[23:12] <= sat_inc12(bad_line_count);
                        end
                        row_count <= sat_inc24(row_count);
                        line_width <= 24'd0;
                    end
                end
                if (valid && !prev_valid && in_frame && !(valid && user))
                    gap_ready[23:12] <= sat12(blank_count);
            end
        end
    end
endmodule
