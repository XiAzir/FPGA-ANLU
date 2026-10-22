`timescale 1ns/1ps

module tb_color_mul_width;
    integer sample;
    integer expected_cr;
    integer expected_cb;
    integer checked_cr = 0;
    integer checked_cb = 0;
    reg signed [16:0] value;
    wire signed [30:0] cr_product_31 = value * 14'sd5743;
    wire signed [30:0] cb_product_31 = value * 14'sd7258;
    wire signed [31:0] cr_product_32 = {cr_product_31[30], cr_product_31};
    wire signed [31:0] cb_product_32 = {cb_product_31[30], cb_product_31};

    initial begin
        for (sample = -65536; sample <= 65535; sample = sample + 1) begin
            value = sample;
            #1;
            expected_cr = sample * 5743;
            expected_cb = sample * 7258;
            if (cr_product_32 !== expected_cr)
                $fatal(1, "cr mismatch input=%0d got=%0d expected=%0d", sample, cr_product_32, expected_cr);
            if (cb_product_32 !== expected_cb)
                $fatal(1, "cb mismatch input=%0d got=%0d expected=%0d", sample, cb_product_32, expected_cb);
            checked_cr = checked_cr + 1;
            checked_cb = checked_cb + 1;
        end
        $display("COLOR_MUL_WIDTH_EXHAUSTIVE_PASS cr=%0d cb=%0d range=-65536..65535", checked_cr, checked_cb);
        $finish;
    end
endmodule
