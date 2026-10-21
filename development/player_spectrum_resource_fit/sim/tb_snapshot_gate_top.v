`timescale 1ns/1ps
module tb_snapshot_gate_top;
 reg clk=0,rst_n=0,stim_valid=0;
 wire hp,d0,d1,d2,sdclk,mosi,cs,dio,rclk,sclk;
 wire [3:0] led;
 top dut(.clk(clk),.rst_n(rst_n),.key1(1'b1),.key2(1'b1),.sd_miso(1'b1),
 .HDMI_CLK_P(hp),.HDMI_D0_P(d0),.HDMI_D1_P(d1),.HDMI_D2_P(d2),.led(led),
 .sd_dclk(sdclk),.sd_mosi(mosi),.sd_ncs(cs),.seg7_dio(dio),.seg7_rclk(rclk),.seg7_sclk(sclk));
 always #10 clk=~clk;
 wire pclk=dut.\u_status_monitor/sys_clk ;
 wire [27:0] header=dut.\u_fault_snapshot/snapshot_header ;
 wire [23:0] pp=dut.\u_fault_snapshot/snapshot_prev_progress ;
 wire [23:0] cp=dut.\u_fault_snapshot/snapshot_progress ;
 wire [23:0] pa=dut.\u_fault_snapshot/snapshot_prev_accepted ;
 wire [23:0] ca=dut.\u_fault_snapshot/snapshot_accepted ;
 wire captured=dut.\u_status_monitor/snapshot_valid ;
 integer i,page_sel;
 reg [31:0] expected_word;
 initial begin
  #200 rst_n=1;
  #2000;force dut.sys_pll_lock=1'b1;force dut.video_pll_lock=1'b1;
  #2000;force dut.rst_cnt=20'd1000000;
  #100;release dut.rst_cnt;
  #2000;force dut.\u_audio_probe/tone_mode =1'b1;
  force dut.\u_audio_probe/audio_valid =stim_valid;
  repeat(20)@(negedge pclk);
  $display("BOUNDARY testbench fault injection on diagnostic accepted bus only; PLL ready/fast startup selected tone; no SDF/no card; original gate or routed full top");
  force dut.\u_fault_snapshot/accepted =24'd0;
  for(i=0;i<8;i=i+1)begin @(negedge pclk);stim_valid=1;end
  @(negedge pclk);stim_valid=0;
  repeat(8)@(negedge pclk);
  $display("SNAPSHOT captured=%b header=%h prev_progress=%h curr_progress=%h prev_accepted=%h curr_accepted=%h",captured,header,pp,cp,pa,ca);
  // The optimized alias leaves constant header bits undriven. Check the
  // retained reason bits here, then verify the real display words below.
  if(captured!==1'b1 || header[26:24]!==3'd4 || header[23]!==1'b1 || pp[18:9]!==0 || cp[18:9]!==1 || pa!==0 || ca!==0)
   begin $display("FAIL full_top_snapshot atomic gate evidence");$finish;end
  repeat(30)@(negedge pclk);
  if(cp[18:9]!==1 || ca!==0)begin $display("FAIL frozen snapshot changed");$finish;end
  force dut.\u_status_monitor/self_test =2'd2;
  for(page_sel=2;page_sel<=8;page_sel=page_sel+1)begin
   `include "page_force.vh"
   repeat(40)@(negedge pclk);
   case(page_sel)
    2:expected_word=32'h64a10100;3:expected_word=32'h78000000;4:expected_word=32'h88000200;
    5:expected_word=32'h98000000;6:expected_word=32'ha8000000;7:expected_word=32'hb8000000;8:expected_word=32'hc8000001;
   endcase
   $display("DISPLAY_WORD page=%0d got=%h expected=%h",page_sel,dut.\u_status_mailbox/destination_hex ,expected_word);
   if(dut.\u_status_mailbox/destination_hex !==expected_word)begin $display("FAIL full_top_snapshot display transport");$finish;end
  end
  $display("PASS full_top_snapshot actual_primitive_capture=1 frozen_previous_current=1 healthy_reset_source_mask=1 observation_fault_injected=1 display_mailbox_words=7");$finish;
 end
 initial begin #100000;$display("FAIL full_top_snapshot timeout");$finish;end
endmodule
