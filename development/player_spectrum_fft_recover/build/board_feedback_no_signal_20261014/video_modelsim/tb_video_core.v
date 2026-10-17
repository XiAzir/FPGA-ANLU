`timescale 1ns/1ps
module tb_video_core;
  reg clk=0, rst=1;
  wire hs,vs,de,hs_r,vs_r,de_r; wire user,valid,last; wire [23:0] data,vout; wire ready,locked;
  wire [9:0] ch0,ch1,ch2,chclk;
  integer cycles=0, beats=0, users=0, lasts=0, frames=0, stalls=0, active_run=0, max_active_run=0;
  reg prev_vs=0;
  video_timing_data timing(.video_clk(clk),.rst(rst),.read_req(),.read_req_ack(1'b0),.hs(hs),.vs(vs),.de(de));
  video_delay delay(.video_clk(clk),.rst(rst),.read_en(),.read_data(24'h123456),.hs(hs),.vs(vs),.de(de),.hs_r(hs_r),.vs_r(vs_r),.de_r(de_r),.vout_data(vout));
  video_rgb_to_axis_640x480 converter(.I_clk(clk),.I_rst(rst),.I_vs(vs_r),.I_de(de_r),.I_rgb(vout),.O_video_user(user),.O_video_valid(valid),.O_video_last(last),.O_video_data(data));
  hdmi_1_4b_transmitter_core_wrapper #(.DEVICE("EG"),.HTOTAL(800),.HSA(96),.HFP(16),.HBP(48),.HACTIVE(640),.VTOTAL(525),.VSA(2),.VFP(10),.VBP(33),.VACTIVE(480),.VIDEO_VIC(1),.VIDEO_TPG("Disable"),.VIDEO_FORMAT("RGB"),.AUDIO_SAMPLE_RATE("48K"),.IIC_SCL_DIV(250)) dut(.I_pixel_clk(clk),.I_rst(rst),.I_edid_read_trig(1'b0),.O_edid_read_valid(),.O_edid_read_data(),.I_axis_s_user(user),.I_axis_s_valid(valid),.I_axis_s_last(last),.I_axis_s_data(data),.O_axis_s_ready(ready),.I_audio_valid(1'b0),.I_audio_left_data(24'd0),.I_audio_right_data(24'd0),.I_acr_valid(1'b0),.I_acr_cts(20'd0),.I_acr_n(20'd0),.O_video_locked(locked),.O_ddc_scl(),.IO_ddc_sda(),.O_ch0_tmds_data(ch0),.O_ch1_tmds_data(ch1),.O_ch2_tmds_data(ch2),.O_clk_tmds_data(chclk));
  always #20 clk=~clk;
  always @(posedge clk) begin
    cycles=cycles+1;
    if(!rst) begin
      if(vs && !prev_vs) frames=frames+1;
      if(valid && ready) begin beats=beats+1; if(user)users=users+1; if(last)lasts=lasts+1; end
      if(valid && !ready) stalls=stalls+1;
      if(valid) begin active_run=active_run+1; if(active_run>max_active_run)max_active_run=active_run; end else active_run=0;
      if(cycles%500000==0)$display("PROGRESS cycles=%0d frames=%0d beats=%0d user=%0d last=%0d ready=%b locked=%b de=%b",cycles,frames,beats,users,lasts,ready,locked,de_r);
      if(frames>=4) begin $display("RESULT frames=%0d cycles=%0d beats=%0d users=%0d lasts=%0d ready_stalls=%0d max_active=%0d locked=%b",frames,cycles,beats,users,lasts,stalls,max_active_run,locked); $finish; end
    end
    prev_vs=vs;
  end
  initial begin repeat(20) @(posedge clk); rst=0; $display("RESET_RELEASE cycle=%0d period_ns=40 reset_cycles=20 accelerated_reset_launch=1",cycles); end
  initial begin repeat(2000000) @(posedge clk); $display("TIMEOUT frames=%0d cycles=%0d beats=%0d users=%0d lasts=%0d ready_stalls=%0d max_active=%0d locked=%b",frames,cycles,beats,users,lasts,stalls,max_active_run,locked); $finish; end
endmodule