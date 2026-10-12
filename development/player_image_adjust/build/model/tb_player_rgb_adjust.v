`timescale 1ns/1ps
module tb_player_rgb_adjust;
    reg [23:0] rgb_in;
    reg [3:0] brightness_index;
    reg [2:0] contrast_index;
    wire [23:0] rgb_out;
    integer p;
    integer b;
    integer c;
    integer er, eg, eb;
    integer checks;

    player_rgb_adjust dut (
        .rgb_in(rgb_in),
        .brightness_index(brightness_index),
        .contrast_index(contrast_index),
        .rgb_out(rgb_out)
    );

    function integer floor_ratio;
        input integer numerator;
        input integer denominator;
        begin
            if (numerator >= 0) floor_ratio = numerator / denominator;
            else floor_ratio = -(((-numerator) + denominator - 1) / denominator);
        end
    endfunction

    function integer golden_channel;
        input integer pixel;
        input integer bi;
        input integer ci;
        integer gain_num;
        integer gain_den;
        integer centered;
        integer value;
        begin
            if (bi > 8) bi = 4;
            if (ci > 4) ci = 2;
            case (ci)
                0: begin gain_num = 1; gain_den = 2; end
                1: begin gain_num = 3; gain_den = 4; end
                2: begin gain_num = 1; gain_den = 1; end
                3: begin gain_num = 5; gain_den = 4; end
                default: begin gain_num = 3; gain_den = 2; end
            endcase
            centered = pixel - 128;
            value = floor_ratio(centered * gain_num, gain_den) + 128 + 16 * (bi - 4);
            if (value < 0) golden_channel = 0;
            else if (value > 255) golden_channel = 255;
            else golden_channel = value;
        end
    endfunction

    task check_rgb;
        input [23:0] value;
        input integer bi;
        input integer ci;
        begin
            rgb_in = value;
            brightness_index = bi[3:0];
            contrast_index = ci[2:0];
            #1;
            er = golden_channel(value[23:16], bi, ci);
            eg = golden_channel(value[15:8], bi, ci);
            eb = golden_channel(value[7:0], bi, ci);
            if (rgb_out !== {er[7:0], eg[7:0], eb[7:0]}) begin
                $display("RGB mismatch in=%h B=%0d C=%0d got=%h expected=%02x%02x%02x", value, bi, ci, rgb_out, er, eg, eb);
                $fatal(1);
            end
            checks = checks + 1;
        end
    endtask

    initial begin
        checks = 0;
        for (c = 0; c <= 4; c = c + 1) begin
            for (b = 0; b <= 8; b = b + 1) begin
                for (p = 0; p <= 255; p = p + 1) begin
                    // Each pass exhausts every possible byte in all three lanes.
                    check_rgb({p[7:0], p[7:0], p[7:0]}, b, c);
                end
            end
        end
        // Check independent, non-equal channel values and invalid-index fallbacks.
        check_rgb(24'h00_80_ff, 4, 2);
        check_rgb(24'h13_a7_5c, 9, 2);
        check_rgb(24'hf0_22_81, 4, 7);
        check_rgb(24'h7f_80_81, 15, 7);
        if (checks != (256 * 9 * 5 + 4)) $fatal(1, "unexpected check count %0d", checks);
        $display("PASS tb_player_rgb_adjust: %0d vectors", checks);
        $finish;
    end
endmodule
