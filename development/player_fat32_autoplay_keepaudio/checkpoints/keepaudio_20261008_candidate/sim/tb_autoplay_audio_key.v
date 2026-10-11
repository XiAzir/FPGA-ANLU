`timescale 1ns/1ps
// Scaled time: 1000 clock cycles represent one nominal second.
module tb_autoplay_audio_key;
reg clk=0, rst=1, key=1;
always #5 clk=~clk;
wire auto_press, tone_press, tone_mode;
integer auto_events=0, tone_events=0;
key_press_debounce #(.CLK_FREQ_HZ(1000),.DEBOUNCE_MS(50)) u_auto
    (.clk(clk),.rst(rst),.button_in(key),.press_pulse(auto_press));
key_press_debounce #(.CLK_FREQ_HZ(1000),.DEBOUNCE_MS(1500)) u_tone_key
    (.clk(clk),.rst(rst),.button_in(key),.press_pulse(tone_press));
player_audio_probe #(.PIXEL_HZ(1000),.SAMPLE_HZ(48)) u_audio
    (.pixel_clk(clk),.sd_clk(clk),.rst(rst),.tone_toggle(tone_press),
     .primed(1'b0),.sample_available(1'b0),.sample_data(16'd0),
     .sample_take(),.underflow(),.audio_valid(),.audio_left(),.audio_right(),
     .acr_valid(),.acr_cts(),.acr_n(),.led(),.tone_mode(tone_mode));
always @(posedge clk) if(!rst) begin
    if(auto_press) auto_events<=auto_events+1;
    if(tone_press) tone_events<=tone_events+1;
end
initial begin
    repeat(8) @(negedge clk); rst=0;
    repeat(10) @(negedge clk);
    // A normal 100ms press triggers autoplay but keeps the WAV source selected.
    key=0; repeat(100) @(negedge clk); key=1;
    repeat(100) @(negedge clk);
    if(auto_events!=1 || tone_events!=0 || tone_mode!==0)
        $fatal(1,"short press changed audio or missed autoplay");
    // Switch tone only after the 1.5s threshold; holding cannot repeat toggles.
    key=0; repeat(1400) @(negedge clk);
    if(tone_events!=0 || tone_mode!==0) $fatal(1,"tone toggled too early");
    repeat(200) @(negedge clk);
    if(auto_events!=2 || tone_events!=1 || tone_mode!==1)
        $fatal(1,"long press did not switch exactly once");
    repeat(2000) @(negedge clk);
    if(tone_events!=1 || tone_mode!==1) $fatal(1,"held key repeated audio toggle");
    key=1; repeat(1600) @(negedge clk);
    // After release/rearm, another short press preserves the selected source.
    key=0; repeat(100) @(negedge clk); key=1;
    repeat(100) @(negedge clk);
    if(auto_events!=3 || tone_events!=1 || tone_mode!==1)
        $fatal(1,"second short press changed audio");
    key=0; repeat(1600) @(negedge clk); key=1;
    repeat(1600) @(negedge clk);
    if(auto_events!=4 || tone_events!=2 || tone_mode!==0)
        $fatal(1,"return to WAV failed");
    $display("PASS autoplay_audio_key: short presses preserve source; long toggles once; release rearm and WAV return");
    $finish;
end
initial begin #200000; $fatal(1,"key regression timeout"); end
endmodule
