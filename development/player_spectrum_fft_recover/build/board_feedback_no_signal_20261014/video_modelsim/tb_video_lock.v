`timescale 1ns/1ps
module tb;
  reg clk=0, rst_n=0, core_rst=1, drive_valid=0, drive_user=0, drive_last=0;
  reg [23:0] drive_data=24'h123456;
  wire HDMI_CLK_P, HDMI_D0_P, HDMI_D1_P, HDMI_D2_P;
  wire [3:0] led; wire sd_dclk, sd_mosi, sd_ncs, seg7_dio, seg7_rclk, seg7_sclk;
  integer frame, v, h, sent;
  top dut(.clk(clk), .key1(1'b1), .key2(1'b1), .rst_n(rst_n), .sd_miso(1'b1), .HDMI_CLK_P(HDMI_CLK_P), .HDMI_D0_P(HDMI_D0_P), .HDMI_D1_P(HDMI_D1_P), .HDMI_D2_P(HDMI_D2_P), .led(led), .sd_dclk(sd_dclk), .sd_mosi(sd_mosi), .sd_ncs(sd_ncs), .seg7_dio(seg7_dio), .seg7_rclk(seg7_rclk), .seg7_sclk(seg7_sclk));
  always #20 clk=~clk;
  wire ready_w; wire locked_w; wire [13:0] col_w; wire [13:0] line_w; wire pause_w; wire sof_w; wire sol_w; wire de_prev_w;
  assign ready_w=dut.axis_s_ready; assign locked_w=dut.hdmi_video_locked;
  assign col_w=dut.\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_col_cnt ; assign line_w=dut.\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_line_cnt ; assign pause_w=dut.\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/O_video_source_pause ; assign sof_w=dut.\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/I_video_source_sof ; assign sol_w=dut.\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/I_video_source_sol ; assign de_prev_w=dut.\u_adjust_osd/de_prev ;
  initial begin
    force dut.\u_status_monitor/sys_clk  = clk; force dut.\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst  = core_rst; force dut.\u_adjust_osd/de_prev  = drive_valid;
    force dut.axis_s_valid=drive_valid; force dut.axis_s_user=drive_user; force dut.axis_s_last=drive_last; force dut.axis_s_data=drive_data; force dut.axis_s_ready=1'b1;
    #1000; core_rst=0; rst_n=1; repeat (1000) @(posedge clk);
    $display("START ready=%b lock=%b col=%0d line=%0d pause=%b sof=%b sol=%b de_prev=%b",ready_w,locked_w,col_w,line_w,pause_w,sof_w,sol_w,de_prev_w); sent=0;
    for (frame=0; frame<2; frame=frame+1) begin
      for (v=0; v<525; v=v+1) begin
        if (v<45) begin drive_valid=0; drive_user=0; drive_last=0; repeat (800) @(posedge clk); end
        else begin
          drive_valid=0; drive_user=0; drive_last=0; repeat (160) @(posedge clk);
          for (h=0; h<640; h=h+1) begin
            @(negedge clk); drive_valid=1; drive_user=(frame==0 && v==45 && h==0); drive_last=(h==639);
            @(posedge clk); sent=sent+1; #1;
          end
          @(negedge clk); drive_valid=0; drive_user=0; drive_last=0; repeat (160) @(posedge clk);
          if ((v%60)==45) $display("ROW frame=%0d v=%0d sent=%0d lock=%b col=%0d line=%0d pause=%b sof=%b sol=%b",frame,v,sent,locked_w,col_w,line_w,pause_w,sof_w,sol_w);
        end
      end
      $display("FRAME_END frame=%0d sent=%0d lock=%b col=%0d line=%0d pause=%b sof=%b sol=%b",frame,sent,locked_w,col_w,line_w,pause_w,sof_w,sol_w);
    end
    $display("FINAL sent=%0d lock=%b col=%0d line=%0d pause=%b sof=%b sol=%b de_prev=%b",sent,locked_w,col_w,line_w,pause_w,sof_w,sol_w,de_prev_w); $finish;
  end
endmodule
