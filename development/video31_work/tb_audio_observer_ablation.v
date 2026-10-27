`timescale 1ns/1ps
module tb_audio_observer_ablation;
 reg pc=0,sc=0,rst=1,toggle=0,primed=0,available=1,play=1;
 reg [15:0] data=16'h1234;
 wire take0,take1,uf0,uf1,ue0,ue1,av0,av1,cv0,cv1,mode0,mode1;
 wire [23:0] l0,l1,r0,r1;
 wire [19:0] c0,c1,n0,n1;
 wire [3:0] leds;
 integer cycles=0,samples=0,acrs=0,negative=0;
 always #20 pc=~pc;
 always #10 sc=~sc;
 player_audio_output #(.PLAY_GATE(1)) a0(
 .pixel_clk(pc),.sd_clk(sc),.rst(rst),.tone_toggle(toggle),.primed(primed),
 .sample_available(available),.play_enable(play),.sample_data(data),
 .sample_take(take0),.underflow(uf0),.underflow_event(ue0),
 .audio_valid(av0),.audio_left(l0),.audio_right(r0),
 .acr_valid(cv0),.acr_cts(c0),.acr_n(n0),.tone_mode(mode0));
 player_audio_probe #(.PLAY_GATE(1)) a1(
 .pixel_clk(pc),.sd_clk(sc),.rst(rst),.tone_toggle(toggle),.primed(primed),
 .sample_available(available),.play_enable(play),.sample_data(data),
 .sample_take(take1),.underflow(uf1),.underflow_event(ue1),
 .audio_valid(av1),.audio_left(l1),.audio_right(r1),
 .acr_valid(cv1),.acr_cts(c1),.acr_n(n1),.tone_mode(mode1),.led(leds));
 always @(negedge sc) begin
   if(take0) data <= {data[14:0],data[15]^data[13]^data[12]^data[10]};
   if(take0 !== take1) $fatal(1,"sample_take mismatch");
 end
 always @(negedge pc) begin
   cycles=cycles+1;
   if(cycles>4) begin
    if({uf0,ue0,av0,l0,r0,cv0,c0,n0,mode0} !== {uf1,ue1,av1,l1,r1,cv1,c1,n1,mode1})
      $fatal(1,"audio observer ablation mismatch cycle %0d",cycles);
    if(av0) begin
      samples=samples+1;
      // Deliberate one-bit corruption must be detected by the same comparison.
      if(l0 !== (l1 ^ 24'h000100)) negative=negative+1;
    end
    if(cv0) begin
      acrs=acrs+1;
      if(n0!==20'd6144 || c0==0) $fatal(1,"invalid ACR");
    end
   end
   toggle=0;
   case(cycles)
    5: rst=0;
    20: primed=1;
    40000,100000,170000,230000: toggle=1;
    120000: play=0;
    125000: play=1;
    140000: available=0;
    142000: available=1;
    260000: rst=1;
    260010: rst=0;
    300000: begin
      if(samples<400 || acrs<5 || negative!=samples) $fatal(1,"insufficient coverage");
      $display("PASS AUDIO_OBSERVER_ABLATION cycles=%0d samples=%0d acr=%0d corruption_detected=%0d",cycles,samples,acrs,negative);
      $finish;
    end
   endcase
 end
endmodule
