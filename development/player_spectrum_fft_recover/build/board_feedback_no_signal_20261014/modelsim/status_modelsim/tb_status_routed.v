`timescale 1ns/1ps
module tb_status_routed;
  reg clk=0, rst_n=0;
  wire hp,d0,d1,d2,sdclk,mosi,cs,dio,rclk,sclk;
  wire [3:0] led;
  top dut(.clk(clk),.rst_n(rst_n),.key1(1'b1),.key2(1'b1),.sd_miso(1'b1),
    .HDMI_CLK_P(hp),.HDMI_D0_P(d0),.HDMI_D1_P(d1),.HDMI_D2_P(d2),.led(led),
    .sd_dclk(sdclk),.sd_mosi(mosi),.sd_ncs(cs),.seg7_dio(dio),.seg7_rclk(rclk),.seg7_sclk(sclk));
  always #10 clk=~clk;
  wire pclk=dut.\u_status_monitor/sys_clk ;
  wire dstclk=dut.\u_bmp_file_mapper/clk ;
  integer i,page_sel,errors=0,passed=0,walk_bits;
  reg [23:0] acc;
  reg [31:0] expected;
  initial begin
    #200 rst_n=1;
    #2000; force dut.sys_pll_lock=1'b1; force dut.video_pll_lock=1'b1;
    #2000; force dut.rst_cnt=20'd1000000;
    #100; release dut.rst_cnt;
    #2000;
    force dut.\u_status_monitor/self_test = 2'd2;
    force dut.\u_pcm_waveform/u_spectrum/debug_progress = 24'h0;
    force dut.\u_pcm_waveform/u_spectrum/debug_events = 24'h0;
    force dut.\u_pcm_waveform/u_spectrum/debug_accepted = 24'h0;
    for (page_sel=13; page_sel<=15; page_sel=page_sel+1) begin
      force dut.\u_status_monitor/cw_count_data [5] = page_sel[0];
      force dut.\u_status_monitor/cw_count_data[5]_dup_3 = page_sel[0];
      force dut.\u_status_monitor/cw_count_data[5]_dup_4 = page_sel[0];
      force dut.\u_status_monitor/cw_count_data [6] = page_sel[1];
      force dut.\u_status_monitor/cw_count_data [7] = page_sel[2];
      force dut.\u_status_monitor/cw_count_data [8] = page_sel[3];
      repeat (30) @(negedge pclk);
      if (page_sel==14) walk_bits=16;
      else walk_bits=24;
      for (i=0; i<walk_bits; i=i+1) begin
        acc=24'h1 << i;
        if (page_sel==13) begin
          force dut.\u_pcm_waveform/u_spectrum/debug_progress = acc;
          expected={8'hF2,acc};
        end else if (page_sel==14) begin
          force dut.\u_pcm_waveform/u_spectrum/debug_events = acc;
          expected={8'hF3,8'h00,acc[15:0]};
        end else begin
          force dut.\u_pcm_waveform/u_spectrum/debug_accepted = acc;
          expected={8'hF4,acc};
        end
        repeat (30) @(negedge pclk);
        repeat (10) @(negedge dstclk);
        #1;
        if (dut.\u_status_mailbox/destination_hex !== expected) begin
          if (errors<8) $display("FAIL destination page=%0d bit=%0d got=%h expected=%h held=%h",page_sel,i,dut.\u_status_mailbox/destination_hex ,expected,dut.\u_status_mailbox/held_hex );
          errors=errors+1;
        end else passed=passed+1;
      end
      $display("PAGE_DONE page=%0d checked=%0d passed=%0d errors=%0d dest=%h",page_sel,walk_bits,passed,errors,dut.\u_status_mailbox/destination_hex );
    end
    $display("STATUS_WALK_RESULT passed=%0d errors=%0d",passed,errors);
    if (errors==0 && passed==64) $display("PASS routed F2/F3/F4 source-Q to destination_hex: 24+16+24 bits");
    else $display("FAIL routed status walk");
    $finish;
  end
  initial begin #200000; $display("FAIL status timeout"); $finish; end
endmodule