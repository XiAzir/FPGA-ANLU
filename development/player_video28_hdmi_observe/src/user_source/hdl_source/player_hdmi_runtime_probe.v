`timescale 1ns/1ps
module player_hdmi_runtime_probe (
    input  wire        pixel_clk,
    input  wire        serial_clk,
    input  wire        cold_rst,
    input  wire        media_rst,
    input  wire        locked,
    input  wire        axis_ready,
    input  wire        axis_valid,
    input  wire        axis_user,
    input  wire        hs,
    input  wire        vs,
    input  wire        de,
    input  wire        serial_clock_out,
    input  wire [9:0]  tmds_clock_word,
    output wire [31:0] page_e,
    output wire [31:0] page_f
);
    // E page sticky fields and frame-line accounting live in pixel_clk domain.
    reg previous_locked;
    reg lock_seen;
    reg lock_lost;
    reg ready_wait_seen;
    reg de_seen;
    reg [7:0] sof_count;
    reg [9:0] line_count;
    reg [9:0] last_frame_lines;
    reg axis_valid_d;
    reg sof_d;
    wire sof_now = axis_user && axis_valid;
    wire sof_event = sof_now && !sof_d;
    wire axis_valid_rise = axis_valid && !axis_valid_d;

    assign page_e = {
        4'hE, locked, lock_seen, lock_lost, axis_ready,
        sof_count, last_frame_lines,
        axis_user, axis_valid, hs, vs, ready_wait_seen, de_seen
    };

    always @(posedge pixel_clk or posedge cold_rst) begin
        if (cold_rst) begin
            previous_locked <= 1'b0;
            lock_seen <= 1'b0;
            lock_lost <= 1'b0;
            ready_wait_seen <= 1'b0;
            de_seen <= 1'b0;
            sof_count <= 8'd0;
            line_count <= 10'd0;
            last_frame_lines <= 10'd0;
            axis_valid_d <= 1'b0;
            sof_d <= 1'b0;
        end else begin
            if (media_rst) begin
                // Track the reset-time lock level to avoid a reset-induced loss event.
                previous_locked <= locked;
                axis_valid_d <= 1'b0;
                sof_d <= 1'b0;
                line_count <= 10'd0;
                last_frame_lines <= 10'd0;
            end else begin
                previous_locked <= locked;
                axis_valid_d <= axis_valid;
                sof_d <= sof_now;

                if (locked)
                    lock_seen <= 1'b1;
                if (previous_locked && !locked)
                    lock_lost <= 1'b1;
                if (axis_valid && !axis_ready)
                    ready_wait_seen <= 1'b1;
                if (de)
                    de_seen <= 1'b1;

                if (sof_event) begin
                    sof_count <= sof_count + 1'b1;
                    last_frame_lines <= line_count;
                    // SOF is the first active line and counts as line one.
                    line_count <= 10'd1;
                end else if (axis_valid_rise) begin
                    line_count <= line_count + 1'b1;
                end
            end
        end
    end

    // Count sampled transitions of the clock lane's positive-edge ODDR input
    // in serial_clk. Dedicated ODDR Q stays pad-only. Export only Gray code
    // across the asynchronous boundary.
    reg serial_clock_d;
    reg [9:0] edge_count_bin;
    reg [9:0] edge_count_gray;
    wire serial_edge = serial_clock_out ^ serial_clock_d;
    wire [9:0] edge_count_next = edge_count_bin + serial_edge;

    always @(posedge serial_clk or posedge cold_rst) begin
        if (cold_rst) begin
            serial_clock_d <= 1'b0;
            edge_count_bin <= 10'd0;
            edge_count_gray <= 10'd0;
        end else begin
            serial_clock_d <= serial_clock_out;
            edge_count_bin <= edge_count_next;
            edge_count_gray <= (edge_count_next >> 1) ^ edge_count_next;
        end
    end

    (* async_reg = "true" *) reg [9:0] edge_gray_sync1;
    (* async_reg = "true" *) reg [9:0] edge_gray_sync2;
    reg [9:0] edge_count_snapshot;
    reg [9:0] clock_edge_delta;
    reg [6:0] window_timer;
    wire [9:0] edge_count_pixel = gray_to_binary(edge_gray_sync2);

    function [9:0] gray_to_binary;
        input [9:0] gray;
        integer k;
        begin
            gray_to_binary[9] = gray[9];
            for (k=8;k>=0;k=k-1)
                gray_to_binary[k] = gray_to_binary[k+1] ^ gray[k];
        end
    endfunction

    always @(posedge pixel_clk or posedge cold_rst) begin
        if (cold_rst) begin
            edge_gray_sync1 <= 10'd0;
            edge_gray_sync2 <= 10'd0;
            edge_count_snapshot <= 10'd0;
            clock_edge_delta <= 10'd0;
            window_timer <= 7'd0;
        end else begin
            edge_gray_sync1 <= edge_count_gray;
            edge_gray_sync2 <= edge_gray_sync1;
            if (window_timer == 7'd127) begin
                window_timer <= 7'd0;
                clock_edge_delta <= edge_count_pixel - edge_count_snapshot;
                edge_count_snapshot <= edge_count_pixel;
            end else window_timer <= window_timer + 1'b1;
        end
    end

    // The page is formed wholly in pixel_clk. The Gray counter CDC settles
    // well before each 128-pixel window; tmds_clock_word is a live pixel-domain
    // sample from the caller. A one-pixel display transition can be mixed.
    assign page_f = {4'hF, tmds_clock_word, clock_edge_delta, 8'd0};
endmodule
