`timescale 1ns/100fs
module tb_capture_pll;
 reg refclk=0;
 wire slock,vlock,s0,s1,s2,pclk,serclk;
 integer f;
 sys_pll spll(.refclk(refclk),.reset(1'b0),.extlock(slock),.clk0_out(s0),.clk1_out(s1),.clk2_out(s2));
 video_pll vpll(.refclk(refclk),.reset(1'b0),.extlock(vlock),.clk0_out(pclk),.clk1_out(serclk));
 always #10 refclk=~refclk;
 initial begin
  f=$fopen("pll_trace.csv","w");
  if(f==0)$fatal(1,"cannot open trace");
  $timeformat(-9,4," ns",12);
  #10000;
  $fclose(f);
  $display("CAPTURE_DONE t=%0.4f ns slock=%b vlock=%b clocks=%b%b%b%b%b",$realtime,slock,vlock,s0,s1,s2,pclk,serclk);
  $finish;
 end
 always @(s0) if($realtime<=10000)$fdisplay(f,"%0.4f,sys0,%b",$realtime,s0);
 always @(s1) if($realtime<=10000)$fdisplay(f,"%0.4f,sys1,%b",$realtime,s1);
 always @(s2) if($realtime<=10000)$fdisplay(f,"%0.4f,sys2,%b",$realtime,s2);
 always @(pclk) if($realtime<=10000)$fdisplay(f,"%0.4f,pclk,%b",$realtime,pclk);
 always @(serclk) if($realtime<=10000)$fdisplay(f,"%0.4f,serclk,%b",$realtime,serclk);
 always @(slock) if($realtime<=10000)$fdisplay(f,"%0.4f,slock,%b",$realtime,slock);
 always @(vlock) if($realtime<=10000)$fdisplay(f,"%0.4f,vlock,%b",$realtime,vlock);
 initial begin #20000;$display("CAPTURE_TIMEOUT");$fatal(1);end
endmodule
