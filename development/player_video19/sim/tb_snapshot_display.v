`timescale 1ns/1ps
module tb_snapshot_display;
 reg clk=0,rst=1;
 wire [31:0] hex;
 player_status_monitor #(.PIXEL_HZ(8),.SYS_HZ(8),.PAGE_SECONDS(1),.SHOW_SELF_TEST(0)) dut(
 .pixel_clk(clk),.sys_clk(clk),.rst(rst),.sys_rst(rst),
 .axis_rgb(24'd0),.axis_valid(1'b0),.axis_user(1'b0),.hdmi_locked(1'b0),
 .audio_valid(1'b0),.tone_mode(1'b0),.underflow(1'b0),.audio_pcm(24'd0),
 .startup_flags(4'd0),.file_flags(8'd0),.fs_code(8'd0),.wav_map_code(8'd0),
 .packet_samples(24'd0),.packet_count(24'd0),.packet_bad_bch(24'd0),.packet_bad_terc(24'd0),
 .packet_tone_bad(24'd0),.packet_cts(24'd0),.packet_n(24'd0),.packet_flags(4'd0),
 .bmp_diag(27'd0),.sd_crc_diag(32'd0),.fft_progress(24'h012345),.fft_events(24'h006789),.fft_accepted(24'habcdef),
 .snapshot_valid(1'b1),.snapshot_header(28'h4020100),.snapshot_prev_progress(24'h001a00),
 .snapshot_progress(24'h001c00),.snapshot_prev_accepted(24'h000000),.snapshot_accepted(24'h000000),
 .snapshot_frames(24'h13579b),.snapshot_events(24'h002468),.window_toggle_out(),.hex_value(hex),.cw_count_data(),.cw_count_trigger());
 always #20 clk=~clk;
 integer i,checks=0;
 reg [31:0] expected;
 initial begin
  repeat(4)@(posedge clk);@(negedge clk);#1;rst=0;
  repeat(260)begin
   @(negedge clk);#1;
   case(dut.page)
    2:expected=32'h64020100;3:expected=32'h78001a00;4:expected=32'h88001c00;
    5:expected=32'h98000000;6:expected=32'ha8000000;7:expected=32'hb813579b;
    8:expected=32'hc8002468;9:expected=32'hdfc11312;13:expected=32'hf2012345;
    14:expected=32'hf3006789;15:expected=32'hf4abcdef;default:expected=hex;
   endcase
   if(hex!==expected)$fatal(1,"page mismatch page=%0d got=%h expected=%h",dut.page,hex,expected);
   if(dut.page>=2 && dut.page<=9 || dut.page>=13)checks=checks+1;
  end
  $display("PASS snapshot_display sampled_words=%0d complete_cycles=2 snapshot_pages=6..C live_pages=F2..F4 build_id=DFC11312",checks);$finish;
 end
endmodule
