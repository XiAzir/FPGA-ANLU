`timescale 1ns/1ps

module tb_player_dynamic_text_timer;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg vs = 1'b0;
    reg de = 1'b0;
    reg [23:0] rgb_in = 24'h123456;
    wire [23:0] rgb_out;

    player_dynamic_text #(.CLK_FREQ_HZ(2)) dut (
        .clk(clk), .rst(rst), .vs(vs), .de(de), .rgb_in(rgb_in), .rgb_out(rgb_out)
    );
    always #5 clk = ~clk;

    task automatic check_time(input integer mt, input integer mo, input integer st, input integer so, input [255:0] label_text);
        begin
            if ({dut.minute_tens,dut.minute_ones,dut.second_tens,dut.second_ones} !== {mt[3:0],mo[3:0],st[3:0],so[3:0]}) begin
                $display("FAIL %0s expected=%0d%0d:%0d%0d actual=%0d%0d:%0d%0d tick=%0d", label_text,
                    mt,mo,st,so,dut.minute_tens,dut.minute_ones,dut.second_tens,dut.second_ones,dut.second_tick);
                $fatal(1, "BCD timer mismatch");
            end
        end
    endtask

    integer i;
    initial begin
        repeat(3) @(posedge clk);
        @(negedge clk); rst=0;
        repeat(118) @(posedge clk);
        #1; check_time(0,0,5,9,"00:59 before minute carry");
        repeat(2) @(posedge clk);
        #1; check_time(0,1,0,0,"01:00 after minute carry");

        // From 01:00, 11800 clocks are exactly 5900 seconds, yielding 99:20.
        repeat(11800) @(posedge clk);
        #1; check_time(99/10,99%10,2,0,"99:20 long-run BCD");
        repeat(78) @(posedge clk);
        #1; check_time(99/10,99%10,5,9,"99:59 before full wrap");
        repeat(2) @(posedge clk);
        #1; check_time(0,0,0,0,"00:00 after 99:59 wrap");

        // A second asynchronous reset must clear divider, live digits, display
        // snapshot, raster state and scroll phase immediately.
        repeat(14) @(posedge clk);
        @(negedge clk); rst=1;
        #1;
        check_time(0,0,0,0,"second reset");
        if (dut.second_tick !== 0 || dut.scroll_phase !== 0 || dut.display_minute_tens !== 0 ||
            dut.display_minute_ones !== 0 || dut.display_second_tens !== 0 || dut.display_second_ones !== 0)
            $fatal(1, "reset did not clear timer/display/scroll state");
        repeat(3) @(posedge clk);
        @(negedge clk); rst=0;
        repeat(2) @(posedge clk);
        #1; check_time(0,0,0,1,"timer resumes after second reset");
        $display("PASS timer parameter=2 Hz; checked 00:59->01:00, 99:20, 99:59->00:00, second reset and restart; 12000-cycle wrap path");
        $finish;
    end
endmodule
