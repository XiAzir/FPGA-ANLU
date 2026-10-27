`timescale 1ns/1ps

// Parameterized pixel-only 1080-line color bar source.
// For the proposed 1080p15 scan, override:
//   H_TOTAL=2000, H_FRONT=8, H_SYNC=8, H_BACK=64,
//   V_TOTAL=1100, V_FRONT=4, V_SYNC=5, V_BACK=11.
//   pixel_clk=33 MHz. This source contains no HDMI/TMDS serializer.
module video_timing_1080p_custom_colorbar #(
    parameter integer H_ACTIVE = 1920,
    parameter integer H_FRONT  = 88,
    parameter integer H_SYNC   = 44,
    parameter integer H_BACK   = 148,
    parameter integer H_TOTAL  = H_ACTIVE + H_FRONT + H_SYNC + H_BACK,
    parameter integer V_ACTIVE = 1080,
    parameter integer V_FRONT  = 4,
    parameter integer V_SYNC   = 5,
    parameter integer V_BACK   = 36,
    parameter integer V_TOTAL  = V_ACTIVE + V_FRONT + V_SYNC + V_BACK
)(
    input  wire        pixel_clk,
    input  wire        reset,
    output reg         hsync,
    output reg         vsync,
    output reg         de,
    output reg  [23:0] rgb,
    output reg  [11:0] x,
    output reg  [10:0] y
);
    reg [11:0] h_count;
    reg [10:0] v_count;

    always @(posedge pixel_clk) begin
        if (reset) begin
            h_count <= 12'd0;
            v_count <= 11'd0;
            x       <= 12'd0;
            y       <= 11'd0;
        end else if (h_count == H_TOTAL - 1) begin
            h_count <= 12'd0;
            x       <= h_count;
            y       <= v_count;
            if (v_count == V_TOTAL - 1)
                v_count <= 11'd0;
            else
                v_count <= v_count + 1'b1;
        end else begin
            h_count <= h_count + 1'b1;
            x       <= h_count;
            y       <= v_count;
        end
    end

    always @(posedge pixel_clk) begin
        if (reset) begin
            hsync <= 1'b0;
            vsync <= 1'b0;
            de    <= 1'b0;
            rgb   <= 24'h000000;
        end else begin
            hsync <= (h_count >= H_ACTIVE + H_FRONT) &&
                     (h_count <  H_ACTIVE + H_FRONT + H_SYNC);
            vsync <= (v_count >= V_ACTIVE + V_FRONT) &&
                     (v_count <  V_ACTIVE + V_FRONT + V_SYNC);
            de <= (h_count < H_ACTIVE) && (v_count < V_ACTIVE);

            if ((h_count < H_ACTIVE) && (v_count < V_ACTIVE)) begin
                if      (h_count < (H_ACTIVE / 8) * 1) rgb <= 24'hFFFFFF;
                else if (h_count < (H_ACTIVE / 8) * 2) rgb <= 24'hFFFF00;
                else if (h_count < (H_ACTIVE / 8) * 3) rgb <= 24'h00FFFF;
                else if (h_count < (H_ACTIVE / 8) * 4) rgb <= 24'h00FF00;
                else if (h_count < (H_ACTIVE / 8) * 5) rgb <= 24'hFF00FF;
                else if (h_count < (H_ACTIVE / 8) * 6) rgb <= 24'hFF0000;
                else if (h_count < (H_ACTIVE / 8) * 7) rgb <= 24'h0000FF;
                else                                    rgb <= 24'h000000;
            end else begin
                rgb <= 24'h000000;
            end
        end
    end
endmodule


