`timescale 1ns / 1ps

module tb_player_debug_overlay;
    reg pixel_clk = 1'b0;
    always #20 pixel_clk = ~pixel_clk;

    reg rst = 1'b1;
    reg hs_in = 1'b1;
    reg vs_in = 1'b0;
    reg de_in = 1'b0;
    reg [23:0] rgb_in = 24'h123456;
    reg [127:0] debug_rows = {32'h01234567, 32'h89abcdef,
                              32'hfedcba98, 32'h76543210};
    wire hs_out, vs_out, de_out;
    wire [23:0] rgb_out;

    player_debug_overlay dut (
        .pixel_clk(pixel_clk), .rst(rst),
        .hs_in(hs_in), .vs_in(vs_in), .de_in(de_in), .rgb_in(rgb_in),
        .debug_rows(debug_rows), .hs_out(hs_out), .vs_out(vs_out),
        .de_out(de_out), .rgb_out(rgb_out)
    );

    function [34:0] expected_glyph;
        input [3:0] value;
        begin
            case (value)
                4'h0: expected_glyph = 35'b11111_10001_10001_10001_10001_10001_11111;
                4'h1: expected_glyph = 35'b00100_01100_00100_00100_00100_00100_01110;
                4'h2: expected_glyph = 35'b11111_00001_00001_11111_10000_10000_11111;
                4'h3: expected_glyph = 35'b11111_00001_00001_01111_00001_00001_11111;
                4'h4: expected_glyph = 35'b10001_10001_10001_11111_00001_00001_00001;
                4'h5: expected_glyph = 35'b11111_10000_10000_11111_00001_00001_11111;
                4'h6: expected_glyph = 35'b11111_10000_10000_11111_10001_10001_11111;
                4'h7: expected_glyph = 35'b11111_00001_00010_00100_01000_01000_01000;
                4'h8: expected_glyph = 35'b11111_10001_10001_11111_10001_10001_11111;
                4'h9: expected_glyph = 35'b11111_10001_10001_11111_00001_00001_11111;
                4'hA: expected_glyph = 35'b01110_10001_10001_11111_10001_10001_10001;
                4'hB: expected_glyph = 35'b11110_10001_10001_11110_10001_10001_11110;
                4'hC: expected_glyph = 35'b01111_10000_10000_10000_10000_10000_01111;
                4'hD: expected_glyph = 35'b11110_10001_10001_10001_10001_10001_11110;
                4'hE: expected_glyph = 35'b11111_10000_10000_11110_10000_10000_11111;
                4'hF: expected_glyph = 35'b11111_10000_10000_11110_10000_10000_10000;
                default: expected_glyph = 35'd0;
            endcase
        end
    endfunction

    integer errors = 0;
    integer checked_glyph_pixels = 0;
    integer x, y, row, col, gx, gy;
    reg [31:0] expected_row;
    reg [3:0] expected_hex;
    reg [34:0] expected_font;
    reg expected_on;
    reg [23:0] expected_rgb;

    task scan_frame;
        input check_overlay;
        begin
            // Actual 640-pixel active line followed by horizontal blanking.
            // Four visible rows are enough to check the overlay area, then
            // remaining lines exercise coordinate accumulation and pass-through.
            for (y = 0; y < 480; y = y + 1) begin
                for (x = 0; x < 640; x = x + 1) begin
                    @(negedge pixel_clk);
                    de_in = 1'b1;
                    hs_in = (x < 8) ? 1'b0 : 1'b1;
                    vs_in = 1'b0;
                    rgb_in = {x[7:0], y[7:0], (x ^ y) & 8'hff};
                    #1;
                    if (check_overlay && y < 80 && x >= 4 && x < 84) begin
                        row = y / 20;
                        col = (x - 4) / 10;
                        gx = ((x - 4) % 10) / 2;
                        gy = ((y % 20) - 3) / 2;
                        if ((y % 20) >= 3 && (y % 20) < 17) begin
                            case (row)
                                0: expected_row = debug_rows[127:96];
                                1: expected_row = debug_rows[95:64];
                                2: expected_row = debug_rows[63:32];
                                default: expected_row = debug_rows[31:0];
                            endcase
                            expected_hex = (expected_row >> ((7-col)*4)) & 4'hf;
                            expected_font = expected_glyph(expected_hex);
                            expected_on = expected_font[34-(gy*5+gx)];
                            expected_rgb = expected_on ? 24'hffffff : 24'h303030;
                            checked_glyph_pixels = checked_glyph_pixels + 1;
                        end else begin
                            expected_rgb = 24'h303030;
                        end
                    end else begin
                        expected_rgb = rgb_in;
                    end
                    if (rgb_out !== expected_rgb) begin
                        $display("Mismatch frame check=%0d x=%0d y=%0d got=%h exp=%h", check_overlay, x, y, rgb_out, expected_rgb);
                        errors = errors + 1;
                    end
                    if (hs_out !== hs_in || vs_out !== vs_in || de_out !== de_in) begin
                        $display("Sync latency/value mismatch at x=%0d y=%0d", x, y);
                        errors = errors + 1;
                    end
                    @(posedge pixel_clk);
                end
                @(negedge pixel_clk);
                de_in = 1'b0;
                hs_in = 1'b0;
                rgb_in = 24'h654321;
                #1;
                if (rgb_out !== rgb_in || de_out !== de_in || hs_out !== hs_in) begin
                    $display("Blanking passthrough mismatch at y=%0d", y);
                    errors = errors + 1;
                end
                @(posedge pixel_clk);
                // Model the remainder of horizontal blanking.
                repeat (4) @(posedge pixel_clk);
            end
        end
    endtask

    initial begin
        repeat (3) @(posedge pixel_clk);
        @(negedge pixel_clk);
        rst = 1'b0;

        // First frame: assert VS rising edge and verify all overlay pixels.
        @(negedge pixel_clk);
        vs_in = 1'b1;
        @(posedge pixel_clk);
        @(negedge pixel_clk);
        vs_in = 1'b0;
        scan_frame(1'b1);

        // Start a second frame with a different RGB source color. The VS rise
        // must restore the diagnostic overlay to row 0, column 0.
        @(negedge pixel_clk);
        vs_in = 1'b1;
        @(posedge pixel_clk);
        @(negedge pixel_clk);
        vs_in = 1'b0;
        for (row = 0; row < 3; row = row + 1) begin
            for (x = 0; x < 640; x = x + 1) begin
                @(negedge pixel_clk);
                de_in = 1'b1;
                rgb_in = 24'habcdef;
                @(posedge pixel_clk);
            end
            @(negedge pixel_clk);
            de_in = 1'b0;
            @(posedge pixel_clk);
            repeat (4) @(posedge pixel_clk);
        end
        @(negedge pixel_clk);
        de_in = 1'b1;
        rgb_in = 24'habcdef;
        repeat (4) @(posedge pixel_clk);
        @(negedge pixel_clk);
        #1;
        if (rgb_out !== 24'hffffff) begin
            $display("Frame reset failed at first glyph pixel: got=%h exp=ffffff", rgb_out);
            errors = errors + 1;
        end
        if (checked_glyph_pixels != 4*8*10*14) begin
            $display("Unexpected glyph-pixel coverage count: %0d", checked_glyph_pixels);
            errors = errors + 1;
        end

        if (errors == 0) begin
            $display("PASS: debug overlay glyph, sync passthrough, RGB passthrough, and frame reset checks passed");
            $finish;
        end else begin
            $fatal(1, "FAIL: %0d debug overlay checks failed", errors);
        end
    end
endmodule
