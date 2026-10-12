`timescale 1ns / 1ps

// Four rows of hexadecimal diagnostics in the upper-left of a 640x480 image.
// This is a combinational RGB overlay: sync and RGB retain the input pixel
// latency. Each 5x7 glyph is doubled in both dimensions inside a 10x20 cell.
module player_debug_overlay (
    input  wire        pixel_clk,
    input  wire        rst,
    input  wire        hs_in,
    input  wire        vs_in,
    input  wire        de_in,
    input  wire [23:0] rgb_in,
    input  wire [127:0] debug_rows,
    output wire        hs_out,
    output wire        vs_out,
    output wire        de_out,
    output wire [23:0] rgb_out
);

    reg [10:0] x_pos;
    reg [10:0] y_pos;
    reg de_prev;
    reg vs_prev;

    always @(posedge pixel_clk) begin
        if (rst) begin
            x_pos  <= 11'd0;
            y_pos  <= 11'd0;
            de_prev <= 1'b0;
            vs_prev <= 1'b0;
        end else begin
            de_prev <= de_in;
            vs_prev <= vs_in;

            if (vs_in && !vs_prev) begin
                x_pos <= 11'd0;
                y_pos <= 11'd0;
            end else if (de_in) begin
                x_pos <= x_pos + 11'd1;
            end else if (de_prev) begin
                x_pos <= 11'd0;
                y_pos <= y_pos + 11'd1;
            end
        end
    end

    function [34:0] hex_glyph;
        input [3:0] value;
        begin
            case (value)
                4'h0: hex_glyph = 35'b11111_10001_10001_10001_10001_10001_11111;
                4'h1: hex_glyph = 35'b00100_01100_00100_00100_00100_00100_01110;
                4'h2: hex_glyph = 35'b11111_00001_00001_11111_10000_10000_11111;
                4'h3: hex_glyph = 35'b11111_00001_00001_01111_00001_00001_11111;
                4'h4: hex_glyph = 35'b10001_10001_10001_11111_00001_00001_00001;
                4'h5: hex_glyph = 35'b11111_10000_10000_11111_00001_00001_11111;
                4'h6: hex_glyph = 35'b11111_10000_10000_11111_10001_10001_11111;
                4'h7: hex_glyph = 35'b11111_00001_00010_00100_01000_01000_01000;
                4'h8: hex_glyph = 35'b11111_10001_10001_11111_10001_10001_11111;
                4'h9: hex_glyph = 35'b11111_10001_10001_11111_00001_00001_11111;
                4'hA: hex_glyph = 35'b01110_10001_10001_11111_10001_10001_10001;
                4'hB: hex_glyph = 35'b11110_10001_10001_11110_10001_10001_11110;
                4'hC: hex_glyph = 35'b01111_10000_10000_10000_10000_10000_01111;
                4'hD: hex_glyph = 35'b11110_10001_10001_10001_10001_10001_11110;
                4'hE: hex_glyph = 35'b11111_10000_10000_11110_10000_10000_11111;
                4'hF: hex_glyph = 35'b11111_10000_10000_11110_10000_10000_10000;
                default: hex_glyph = 35'd0;
            endcase
        end
    endfunction

    wire in_overlay = (x_pos >= 11'd4) && (x_pos < 11'd84) &&
                      (y_pos < 11'd80);
    wire [2:0] char_column = (x_pos - 11'd4) / 11'd10;
    wire [1:0] text_row = y_pos / 11'd20;
    wire [3:0] row_pixel_x = ((x_pos - 11'd4) % 11'd10) >> 1;
    wire [2:0] row_pixel_y = (y_pos % 11'd20 - 11'd3) >> 1;

    reg [31:0] selected_row;
    reg [3:0] selected_hex;
    reg [34:0] selected_glyph;
    reg glyph_on;

    always @* begin
        case (text_row)
            2'd0: selected_row = debug_rows[127:96];
            2'd1: selected_row = debug_rows[95:64];
            2'd2: selected_row = debug_rows[63:32];
            default: selected_row = debug_rows[31:0];
        endcase
        selected_hex = (selected_row >> ((3'd7 - char_column) * 4)) & 4'hf;
        selected_glyph = hex_glyph(selected_hex);
        glyph_on = 1'b0;
        if (in_overlay && (y_pos % 11'd20 >= 11'd3) &&
            (y_pos % 11'd20 < 11'd17)) begin
            glyph_on = selected_glyph[34 - (row_pixel_y * 5 + row_pixel_x)];
        end
    end

    assign hs_out = hs_in;
    assign vs_out = vs_in;
    assign de_out = de_in;
    assign rgb_out = in_overlay ? (glyph_on ? 24'hffffff : 24'h303030) : rgb_in;

endmodule
