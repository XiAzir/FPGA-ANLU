`timescale 1ns/1ps
module tb_key_debounce_equiv;
    reg clk=0,rst=1,key=1;
    wire ref_p1,opt_p1,ref_p3,opt_p3;
    integer cycles=0;
    always #5 clk=~clk;
    key_press_debounce_reference #(.CLK_FREQ_HZ(1000),.DEBOUNCE_MS(1)) r1
        (.clk(clk),.rst(rst),.button_in(key),.press_pulse(ref_p1));
    key_press_debounce #(.CLK_FREQ_HZ(1000),.DEBOUNCE_MS(1)) o1
        (.clk(clk),.rst(rst),.button_in(key),.press_pulse(opt_p1));
    key_press_debounce_reference #(.CLK_FREQ_HZ(1000),.DEBOUNCE_MS(3)) r3
        (.clk(clk),.rst(rst),.button_in(key),.press_pulse(ref_p3));
    key_press_debounce #(.CLK_FREQ_HZ(1000),.DEBOUNCE_MS(3)) o3
        (.clk(clk),.rst(rst),.button_in(key),.press_pulse(opt_p3));
    always @(posedge clk) begin
        cycles<=cycles+1;
        #1;
        if (ref_p1 !== opt_p1 || r1.button_sync0 !== o1.button_sync0 ||
            r1.button_sync1 !== o1.button_sync1 || r1.button_stable !== o1.button_stable || r1.cnt != o1.cnt ||
            ref_p3 !== opt_p3 || r3.button_sync0 !== o3.button_sync0 ||
            r3.button_sync1 !== o3.button_sync1 || r3.button_stable !== o3.button_stable || r3.cnt != o3.cnt)
            begin
                $display("r1 pulse=%b sync=%b%b stable=%b cnt=%h opt=%b sync=%b%b stable=%b cnt=%h",
                    ref_p1,r1.button_sync0,r1.button_sync1,r1.button_stable,r1.cnt,
                    opt_p1,o1.button_sync0,o1.button_sync1,o1.button_stable,o1.cnt);
                $display("r3 pulse=%b sync=%b%b stable=%b cnt=%h opt=%b sync=%b%b stable=%b cnt=%h",
                    ref_p3,r3.button_sync0,r3.button_sync1,r3.button_stable,r3.cnt,
                    opt_p3,o3.button_sync0,o3.button_sync1,o3.button_stable,o3.cnt);
                $fatal(1,"key timer divergence at cycle %0d",cycles);
            end
    end
    initial begin
        repeat(4) @(negedge clk); rst=0;
        repeat(4) @(negedge clk);
        key=0; repeat(2) @(negedge clk); key=1;
        repeat(4) @(negedge clk);
        key=0; repeat(12) @(negedge clk);
        key=1; repeat(8) @(negedge clk);
        key=0; repeat(8) @(negedge clk);
        if (cycles<35) $fatal(1,"key sequence too short");
        $display("PASS key debounce cycle-equivalence cycles=%0d",cycles);
        $finish;
    end
    initial begin #10000; $fatal(1,"key timer equivalence timeout"); end
endmodule
