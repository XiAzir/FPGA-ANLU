`timescale 1ns/1ps
module tb_audio_blink_equiv;
    reg clk=0,rst=1;
    wire [3:0] ref_led,opt_led;
    wire ref_mode,opt_mode;
    integer cycles=0, toggles=0;
    reg last_blink=0;
    always #5 clk=~clk;
    player_audio_probe_reference #(.PIXEL_HZ(8),.SAMPLE_HZ(1)) r
        (.pixel_clk(clk),.sd_clk(clk),.rst(rst),.tone_toggle(1'b0),
         .primed(1'b0),.sample_available(1'b0),.sample_data(16'd0),
         .led(ref_led),.tone_mode(ref_mode));
    player_audio_probe #(.PIXEL_HZ(8),.SAMPLE_HZ(1)) o
        (.pixel_clk(clk),.sd_clk(clk),.rst(rst),.tone_toggle(1'b0),
         .primed(1'b0),.sample_available(1'b0),.sample_data(16'd0),
         .led(opt_led),.tone_mode(opt_mode));
    always @(posedge clk) begin
        cycles<=cycles+1;
        #1;
        if (ref_led !== opt_led || ref_mode !== opt_mode || r.blink !== o.blink ||
            r.blink_count != o.blink_count)
            $fatal(1,"audio blink timer divergence at cycle %0d",cycles);
        if (o.blink!=last_blink) toggles<=toggles+1;
        last_blink<=o.blink;
    end
    initial begin
        repeat(4) @(negedge clk); rst=0;
        repeat(21) @(negedge clk);
        if(toggles<4) $fatal(1,"small half-period blink did not toggle repeatedly");
        $display("PASS audio blink cycle-equivalence cycles=%0d toggles=%0d",cycles,toggles);
        $finish;
    end
    initial begin #10000; $fatal(1,"audio blink equivalence timeout"); end
endmodule
