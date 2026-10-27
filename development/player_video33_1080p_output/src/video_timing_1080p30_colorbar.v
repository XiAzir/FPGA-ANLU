`timescale 1ns/1ps

// Pixel-domain 1920x1080 @ 30 Hz color-bar source.
// This module generates RGB/DE/HS/VS only. It does not implement TMDS
// serialization or claim compatibility with the AC201 HDMI output pins.
module video_timing_1080p30_colorbar (
    input  wire        pixel_clk,  // target: 74.25 MHz
    input  wire        reset,
    output reg         hsync,
    output reg         vsync,
    output reg         de,
    output reg  [23:0] rgb,
    output reg  [11:0] x,
    output reg  [10:0] y
);
    localparam integer H_ACTIVE = 1920;
    localparam integer H_FRONT  = 88;
    localparam integer H_SYNC   = 44;
    localparam integer H_BACK   = 148;
    localparam integer H_TOTAL  = H_ACTIVE + H_FRONT + H_SYNC + H_BACK; // 2200

    localparam integer V_ACTIVE = 1080;
    localparam integer V_FRONT  = 4;
    localparam integer V_SYNC   = 5;
    localparam integer V_BACK   = 36;
    localparam integer V_TOTAL  = V_ACTIVE + V_FRONT + V_SYNC + V_BACK; // 1125

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
            // 1080p timing uses positive sync polarity.
            hsync <= (h_count >= H_ACTIVE + H_FRONT) &&
                     (h_count <  H_ACTIVE + H_FRONT + H_SYNC);
            vsync <= (v_count >= V_ACTIVE + V_FRONT) &&
                     (v_count <  V_ACTIVE + V_FRONT + V_SYNC);
            de <= (h_count < H_ACTIVE) && (v_count < V_ACTIVE);

            if ((h_count < H_ACTIVE) && (v_count < V_ACTIVE)) begin
                // Eight equal-width vertical bars: white, yellow, cyan,
                // green, magenta, red, blue, black.
                if      (h_count < 12'd240)  rgb <= 24'hFFFFFF;
                else if (h_count < 12'd480)  rgb <= 24'hFFFF00;
                else if (h_count < 12'd720)  rgb <= 24'h00FFFF;
                else if (h_count < 12'd960)  rgb <= 24'h00FF00;
                else if (h_count < 12'd1200) rgb <= 24'hFF00FF;
                else if (h_count < 12'd1440) rgb <= 24'hFF0000;
                else if (h_count < 12'd1680) rgb <= 24'h0000FF;
                else                         rgb <= 24'h000000;
            end else begin
                rgb <= 24'h000000;
            end
        end
    end
endmodule

