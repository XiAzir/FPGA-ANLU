`timescale 1ns/1ps
module tb_system;
 reg clk=0,rst_n=0,key1=1,key2=1;
 always #10 clk=~clk;
 wire [3:0] led;
 wire seg_d,seg_s,seg_r,hclk,h0,h1,h2,ncs,sck,mosi,miso;
 assign miso=1'b1;
 top dut(.clk(clk),.rst_n(rst_n),.key1(key1),.key2(key2),.led(led),
 .seg7_dio(seg_d),.seg7_sclk(seg_s),.seg7_rclk(seg_r),
 .HDMI_CLK_P(hclk),.HDMI_D0_P(h0),.HDMI_D1_P(h1),.HDMI_D2_P(h2),
 .sd_ncs(ncs),.sd_dclk(sck),.sd_mosi(mosi),.sd_miso(miso));
 defparam dut.u_adjust_control.CLK_FREQ_HZ=1000,
          dut.u_adjust_control.DEBOUNCE_MS=2,
          dut.u_adjust_control.HOLD_MS=30,
          dut.u_adjust_control.PULSE_MS=2,
          dut.u_adjust_control.LEGACY_GAP_MS=2;
 integer mode_pulses=0,next_events=0,auto_events=0,reset_events=0;
 integer reset_width=0,last_reset_width=0;
 reg media_reset_d=0;
 always @(posedge dut.video_clk) begin
  if(dut.video_mode_press) mode_pulses=mode_pulses+1;
  if(dut.media_reset_active && !media_reset_d) begin reset_events=reset_events+1;reset_width=1;end
  else if(dut.media_reset_active) reset_width=reset_width+1;
  if(!dut.media_reset_active && media_reset_d) last_reset_width=reset_width;
  media_reset_d<=dut.media_reset_active;
 end
 always @(posedge dut.sd_card_clk) begin
  if(dut.video_next_press) next_events=next_events+1;
  if(dut.video_auto_press) auto_events=auto_events+1;
 end
 task wait_mode;
  input expected;
  integer i;
  begin
   i=0;
   while(dut.video_mode!==expected && i<300) begin @(negedge dut.video_clk);i=i+1;end
   if(dut.video_mode!==expected) $fatal(1,"mode timeout wanted=%b got=%b",expected,dut.video_mode);
  end
 endtask
 task press_chord_long;
  input expected_before;
  begin
   key1=0;key2=0;repeat(70) @(negedge dut.video_clk);
   if(dut.video_mode!==expected_before) $fatal(1,"mode changed before chord release");
   key1=1;key2=1;
  end
 endtask
 task press_key1_short;
  begin key1=0;repeat(12) @(negedge dut.video_clk);key1=1;end
 endtask
 task press_key2_short;
  begin key2=0;repeat(12) @(negedge dut.video_clk);key2=1;end
 endtask
 task wait_count;
  input integer which;
  input integer wanted;
  integer i;
  begin
   i=0;
   while(((which==0 ? mode_pulses : which==1 ? next_events : which==2 ? auto_events : reset_events)<wanted) && i<500) begin
    @(negedge dut.video_clk);i=i+1;
   end
   if((which==0 ? mode_pulses : which==1 ? next_events : which==2 ? auto_events : reset_events)<wanted)
    $fatal(1,"event timeout which=%0d wanted=%0d",which,wanted);
  end
 endtask
 initial begin
  #500000000;$fatal(1,"VIDEO_CONTROL_WATCHDOG");
 end
 initial begin
  repeat(100) @(negedge clk);rst_n=1;
  wait(dut.rst_all_reg===1'b0);
  repeat(5) @(negedge dut.video_clk);
  if(dut.video_mode!==0 || dut.video_mode_sd!==0) $fatal(1,"startup mode was not photo");

  press_chord_long(0);
  wait_count(0,1);wait_mode(1);
  wait(dut.video_mode_sd===1'b1);
  wait_count(3,1);repeat(4) @(negedge dut.video_clk);
  if(last_reset_width<31 || last_reset_width>33) $fatal(1,"mode media reset width=%0d",last_reset_width);

  press_key1_short();wait_count(1,1);wait_count(3,2);
  if(dut.video_mode!==1 || dut.video_mode_sd!==1) $fatal(1,"video next changed mode");
  press_key2_short();wait_count(2,1);
  if(dut.video_paused!==1) $fatal(1,"video pause action missing");
  press_key2_short();wait_count(2,2);
  if(dut.video_paused!==0) $fatal(1,"video resume action missing");

  press_chord_long(1);wait_count(0,2);wait_mode(0);
  wait(dut.video_mode_sd===1'b0);wait_count(3,3);
  repeat(4) @(negedge dut.video_clk);
  if(last_reset_width<31 || last_reset_width>33) $fatal(1,"return media reset width=%0d",last_reset_width);
  if(mode_pulses!=2 || next_events!=1 || auto_events!=2 || reset_events!=3)
   $fatal(1,"event counts mode=%0d next=%0d auto=%0d reset=%0d",mode_pulses,next_events,auto_events,reset_events);
  $display("VIDEO_CONTROL_PASS mode_pulses=%0d next=%0d auto=%0d resets=%0d last_reset_width=%0d mode=%b sd_mode=%b paused=%b",
   mode_pulses,next_events,auto_events,reset_events,last_reset_width,dut.video_mode,dut.video_mode_sd,dut.video_paused);
  $finish;
 end
endmodule
