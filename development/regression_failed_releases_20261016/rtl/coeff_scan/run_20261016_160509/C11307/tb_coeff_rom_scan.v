`timescale 1ns/1ps
module tb_coeff_rom_scan;
    reg clk = 0;
    reg hann_en = 0;
    reg [9:0] hann_addr = 0;
    wire [15:0] hann_q;
    reg twiddle_en = 0;
    reg [8:0] twiddle_addr = 0;
    wire [31:0] twiddle_q;
    reg [15:0] hann_gold [0:1023];
    reg [31:0] twiddle_gold [0:511];
    reg [1023:0] hann_file, twiddle_file;
    integer i;
    integer hann_unknown = 0, hann_mismatch = 0, hann_first = -1;
    integer twiddle_unknown = 0, twiddle_mismatch = 0, twiddle_first = -1;
    reg [15:0] hann_first_got, hann_first_expected;
    reg [31:0] twiddle_first_got, twiddle_first_expected;

    spectrum_coeff_rom dut(
        .clk(clk), .hann_en(hann_en), .hann_addr(hann_addr), .hann_q(hann_q),
        .twiddle_en(twiddle_en), .twiddle_addr(twiddle_addr), .twiddle_q(twiddle_q)
    );
    always #10 clk = ~clk;

    initial begin
        if (!$value$plusargs("HAN=%s", hann_file)) $fatal(1, "missing +HAN");
        if (!$value$plusargs("TWI=%s", twiddle_file)) $fatal(1, "missing +TWI");
        $readmemh(hann_file, hann_gold);
        $readmemh(twiddle_file, twiddle_gold);
        for (i=0; i<1024; i=i+1)
            if ((^hann_gold[i]) === 1'bx) $fatal(1, "Hann golden missing/unknown word %0d", i);
        for (i=0; i<512; i=i+1)
            if ((^twiddle_gold[i]) === 1'bx) $fatal(1, "twiddle golden missing/unknown word %0d", i);

        for (i=0; i<1024; i=i+1) begin
            @(negedge clk); hann_en=1; twiddle_en=0; hann_addr=i;
            @(posedge clk); #1;
            if ((^hann_q) === 1'bx) hann_unknown=hann_unknown+1;
            else if (hann_q !== hann_gold[i]) begin
                hann_mismatch=hann_mismatch+1;
                if (hann_first < 0) begin hann_first=i; hann_first_got=hann_q; hann_first_expected=hann_gold[i]; end
            end
        end
        @(negedge clk); hann_en=0;

        for (i=0; i<512; i=i+1) begin
            @(negedge clk); hann_en=0; twiddle_en=1; twiddle_addr=i;
            @(posedge clk); #1;
            if ((^twiddle_q) === 1'bx) twiddle_unknown=twiddle_unknown+1;
            else if (twiddle_q !== twiddle_gold[i]) begin
                twiddle_mismatch=twiddle_mismatch+1;
                if (twiddle_first < 0) begin twiddle_first=i; twiddle_first_got=twiddle_q; twiddle_first_expected=twiddle_gold[i]; end
            end
        end
        @(negedge clk); twiddle_en=0;

        $display("SCAN Hann words=1024 unknown=%0d mismatches=%0d first_index=%0d first_got=%04h first_expected=%04h",hann_unknown,hann_mismatch,hann_first,hann_first_got,hann_first_expected);
        $display("SCAN Twiddle words=512 unknown=%0d mismatches=%0d first_index=%0d first_got=%08h first_expected=%08h",twiddle_unknown,twiddle_mismatch,twiddle_first,twiddle_first_got,twiddle_first_expected);
        if (hann_unknown==0 && hann_mismatch==0 && twiddle_unknown==0 && twiddle_mismatch==0)
            $display("PASS coeff_rom_scan hann=1024/1024 twiddle=512/512");
        else
            $display("FAIL coeff_rom_scan");
        $finish;
    end
endmodule
