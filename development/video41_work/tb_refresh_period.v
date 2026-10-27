`timescale 1ns/1ps
`include "global_def.v"
module tb_refresh_period;
    parameter integer EXPECT_PERIOD = 781;
    parameter integer EXPECT_REQUESTS = 1;
    parameter integer NATURAL_INIT = 0;
    parameter integer PULSES_TARGET = 4097;
    reg clk = 0;
    reg rst = 1;
    reg ack = 0;
    wire init_done, req;
    wire ref_vld;
    wire [1:0] ba;
    wire [11:0] addr;
    wire ras_n, cas_n, we_n;
    reg [3:0] ack_pipe = 0;
    integer cycles = 0;
    integer active_cycles = 0;
    integer last_pulse = -1;
    integer first_pulse = -1;
    integer pulses = 0;
    integer done_seen = 0;
    integer gap;
    reg previous_req = 0;
    sdr_init_ref dut(.Sdr_clk(clk),.Rst(rst),.Sdr_init_req(1'b0),
        .Sdr_init_mode(4'd2),.Sdr_init_done(init_done),.App_ref_req(1'b0),
        .Sdr_ref_req(req),.Sdr_ref_ack(ack),.Sdr_rw_vld(1'b0),
        .Sdr_init_ref_vld(ref_vld),.Sdr_init_ref_ras(ras_n),
        .Sdr_init_ref_cas(cas_n),.Sdr_init_ref_we(we_n),
        .Sdr_init_ref_ba(ba),.Sdr_init_ref_addr(addr));
    always #10 clk = ~clk;
    always @(negedge clk) begin
        ack_pipe <= {ack_pipe[2:0],req};
        ack <= ack_pipe[3];
    end
    initial begin
        $display("MACRO period_ns=%0d terminal=%0d",`SDR_CLK_PERIOD,`SELF_REFRESH_INTERVAL);
        repeat(3) @(negedge clk);
        rst = 0;
        if(!NATURAL_INIT) force dut.init_done = 1'b1;
        while(pulses < PULSES_TARGET && cycles < 3500000) begin
            @(posedge clk); #1;
            cycles = cycles+1;
            if(init_done === 1'b1) begin
                done_seen = 1;
                active_cycles = active_cycles+1;
                if(req === 1'b1) begin
                    if(previous_req) $fatal(1,"request wider than one cycle");
                    if(!EXPECT_REQUESTS) $fatal(1,"unexpected baseline request");
                    if(last_pulse >= 0) begin
                        gap = active_cycles-last_pulse;
                        if(gap != EXPECT_PERIOD) $fatal(1,"request gap %0d expected %0d",gap,EXPECT_PERIOD);
                    end else first_pulse = active_cycles;
                    last_pulse = active_cycles;
                    pulses = pulses+1;
                end
                if(EXPECT_REQUESTS && first_pulse < 0 && active_cycles > EXPECT_PERIOD)
                    $fatal(1,"no periodic refresh by required interval");
                if(!EXPECT_REQUESTS && active_cycles == 5000) begin
                    $display("BASELINE_ZERO_REQUEST_REPRODUCED active_cycles=%0d",active_cycles);
                    $finish;
                end
            end else if(req === 1'b1) $fatal(1,"request before initialization");
            previous_req = req;
        end
        if(!done_seen || pulses != PULSES_TARGET) $fatal(1,"initialization/refresh incomplete");
        if((last_pulse-first_pulse)*20 > 64000000) $fatal(1,"4096 intervals exceed 64ms");
        $display("REFRESH_SPEC_PASS natural_init=%0d pulses=%0d gap=%0d window_ns=%0d",
            NATURAL_INIT,pulses,EXPECT_PERIOD,(last_pulse-first_pulse)*20);
        $finish;
    end
endmodule
