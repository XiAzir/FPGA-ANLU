module arithmetic_equiv_tb;
    reg signed [31:0] a;
    wire signed [31:0] ref2896 = a * 32'sd2896;
    wire signed [31:0] add2896 = (a <<< 11) + (a <<< 9) + (a <<< 8) + (a <<< 6) + (a <<< 4);
    wire signed [31:0] ref181_div = (a * 32'sd181) / 32'sd256;
    wire signed [31:0] add181_div = (((a <<< 7) + (a <<< 5) + (a <<< 4) + (a <<< 2) + a) / 32'sd256);
    wire signed [31:0] ref5743 = a * 32'sd5743;
    wire signed [31:0] add5743 = (a <<< 12) + (a <<< 10) + (a <<< 9) + (a <<< 6) + (a <<< 5) + (a <<< 3) + (a <<< 2) + (a <<< 1) + a;
    wire signed [31:0] ref2925 = a * 32'sd2925;
    wire signed [31:0] add2925 = (a <<< 11) + (a <<< 9) + (a <<< 8) + (a <<< 6) + (a <<< 5) + (a <<< 3) + (a <<< 2) + a;
    wire signed [31:0] ref1410 = a * 32'sd1410;
    wire signed [31:0] add1410 = (a <<< 10) + (a <<< 8) + (a <<< 7) + (a <<< 1);
    wire signed [31:0] ref7258 = a * 32'sd7258;
    wire signed [31:0] add7258 = (a <<< 12) + (a <<< 11) + (a <<< 10) + (a <<< 6) + (a <<< 4) + (a <<< 3) + (a <<< 1);

    integer i;
    reg [31:0] seed;
    task check_value;
        input signed [31:0] value;
        begin
            a = value;
            #1;
            if (ref2896 !== add2896 || ref181_div !== add181_div || ref5743 !== add5743 ||
                ref2925 !== add2925 || ref1410 !== add1410 ||
                ref7258 !== add7258) begin
                $display("MISMATCH a=%h", a);
                $fatal(1);
            end
        end
    endtask

    initial begin
        check_value(32'h00000000);
        check_value(32'h00000001);
        check_value(-32'sd1);
        check_value(32'h7fffffff);
        check_value(32'h80000000);
        check_value(32'h55555555);
        check_value(32'haaaaaaaa);
        check_value(32'h40000001);
        check_value(32'hc0000001);
        seed = 32'h19a27c53;
        for (i = 0; i < 100000; i = i + 1) begin
            seed = seed * 32'd1664525 + 32'd1013904223;
            check_value(seed);
        end
        $display("ARITHMETIC_EQUIV_PASS vectors=100009 width=32 signed wraparound");
        $finish;
    end
endmodule
