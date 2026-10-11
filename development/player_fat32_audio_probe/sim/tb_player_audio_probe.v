`timescale 1ns/1ps
module tb_player_audio_probe;
    reg pixel_clk=0, sd_clk=0;
    always #20 pixel_clk=~pixel_clk;
    always #10 sd_clk=~sd_clk;
    reg rst=1, toggle=0, primed=0, available=0, varying=1;
    reg [15:0] data=16'h1234;
    wire take, underflow, valid, acr_valid, mode;
    wire [23:0] left_pcm,right_pcm;
    wire [19:0] cts,n;
    wire [3:0] led;
    integer samples=0, takes=0, cycles=0, last_cycle=0;
    reg [15:0] expected=16'h1234;
    player_audio_probe #(.PIXEL_HZ(100000),.SAMPLE_HZ(480)) dut (
        .pixel_clk(pixel_clk),.sd_clk(sd_clk),.rst(rst),.tone_toggle(toggle),
        .primed(primed),.sample_available(available),.sample_data(data),
        .sample_take(take),.underflow(underflow),.audio_valid(valid),
        .audio_left(left_pcm),.audio_right(right_pcm),
        .acr_valid(acr_valid),.acr_cts(cts),.acr_n(n),.led(led),.tone_mode(mode)
    );
    always @(posedge sd_clk) begin
        if (rst) begin data<=16'h1234; takes=0; end
        else if(take) begin
            if(!available) $fatal(1,"take without available");
            if(varying) data<=data+16'd1;
            takes=takes+1;
        end
    end
    always @(negedge pixel_clk) begin
        if (rst) begin samples=0; cycles=0; last_cycle=0; expected=16'h1234; end
        else begin
            cycles=cycles+1;
            if(valid && !mode) begin
                if(left_pcm!=={expected,8'h00} || right_pcm!=={expected,8'h00})
                    $fatal(1,"WAV sample order/packing mismatch got=%h expected=%h",left_pcm,{expected,8'h00});
                if(samples!=0 && cycles-last_cycle!=208 && cycles-last_cycle!=209)
                    $fatal(1,"WAV sample cadence mismatch");
                if(varying) expected=expected+16'd1;
                samples=samples+1; last_cycle=cycles;
            end
            if(acr_valid && n!=6144) $fatal(1,"ACR N mismatch");
        end
    end
    task switch_source;
        begin
            @(negedge pixel_clk); toggle=1;
            @(negedge pixel_clk); toggle=0;
        end
    endtask
    initial begin
        repeat(6) @(negedge pixel_clk); rst=0; primed=1;
        // Reproduce the exact blind spot in the previous readiness indication.
        repeat(1000) @(negedge pixel_clk);
        if(takes!=0 || samples!=0 || underflow || led!=4'hf)
            $fatal(1,"primed-only startup should not claim playback or underflow");
        switch_source();
        repeat(25000) @(negedge pixel_clk);
        if(!mode || led[2:0]!=0 || takes!=0 || underflow)
            $fatal(1,"internal tone must work without WAV first acknowledgement");
        $display("PASS tone bypass: valid/nonzero/ACR with no WAV samples");
        switch_source();
        repeat(500) @(negedge pixel_clk);
        if(mode || samples!=0 || led!=4'hf)
            $fatal(1,"return to stalled WAV should preserve separate observations");
        @(negedge pixel_clk); rst=1;
        repeat(6) @(negedge pixel_clk); rst=0; primed=1; available=1;
        repeat(25000) @(negedge pixel_clk);
        if(mode || led!=0 || underflow || samples<100 || takes<samples)
            $fatal(1,"WAV live path did not complete all observations");
        $display("PASS WAV chain: %0d ordered stereo samples, %0d takes, correct fractional cadence/ACR",samples,takes);
        @(negedge pixel_clk); rst=1; varying=0;
        repeat(6) @(negedge pixel_clk); rst=0;
        repeat(25000) @(negedge pixel_clk);
        if(led!=4'b0010 || underflow || samples<100)
            $fatal(1,"nonzero constant PCM must not claim varied output");
        $display("PASS nonzero DC: FIFO/take/ACR seen but varied-output flag stays off");
        $display("PASS tb_player_audio_probe"); $finish;
    end
    initial begin #10000000; $fatal(1,"timeout"); end
endmodule
