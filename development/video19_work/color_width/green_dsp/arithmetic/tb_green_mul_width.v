`timescale 1ns/1ps

module tb_green_mul_width;
    integer sample;
    integer expected_2925;
    integer expected_1410;
    integer checked_2925 = 0;
    integer checked_1410 = 0;
    reg signed [16:0] value;
    wire signed [29:0] product_2925_30 = value * 13'sd2925;
    wire signed [28:0] product_1410_29 = value * 12'sd1410;
    wire signed [31:0] product_2925_32 = {{2{product_2925_30[29]}}, product_2925_30};
    wire signed [31:0] product_1410_32 = {{3{product_1410_29[28]}}, product_1410_29};

    initial begin
        for (sample = -65536; sample <= 65535; sample = sample + 1) begin
            value = sample;
            #1;
            expected_2925 = sample * 2925;
            expected_1410 = sample * 1410;
            if (product_2925_32 !== expected_2925)
                $fatal(1, "2925 mismatch input=%0d got=%0d expected=%0d", sample, product_2925_32, expected_2925);
            if (product_1410_32 !== expected_1410)
                $fatal(1, "1410 mismatch input=%0d got=%0d expected=%0d", sample, product_1410_32, expected_1410);
            checked_2925 = checked_2925 + 1;
            checked_1410 = checked_1410 + 1;
        end
        $display("GREEN_MUL_WIDTH_EXHAUSTIVE_PASS 2925=%0d 1410=%0d range=-65536..65535", checked_2925, checked_1410);
        $finish;
    end
endmodule
