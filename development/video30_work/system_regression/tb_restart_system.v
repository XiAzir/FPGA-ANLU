`timescale 1ns/1ps
// Offline C30 system regression. Stimulus enters the retained mode/restart
// classifier outputs; the SPI card, FAT/JPEG/WAV readers and HDMI media path
// remain the candidate RTL. No production CRC or observer wires are sampled.
module tb_video_system #(parameter MAPPED_SECTORS=22486, IMAGE_BYTES=536870912);
reg clk=0,rst_n=0,key1=1,key2=1;
always #10 clk=~clk;
wire [3:0] led;
wire seg_d,seg_s,seg_r,hclk,h0,h1,h2,ncs,sck,mosi,miso;
top dut(.clk(clk),.rst_n(rst_n),.key1(key1),.key2(key2),.led(led),
 .seg7_dio(seg_d),.seg7_sclk(seg_s),.seg7_rclk(seg_r),
 .HDMI_CLK_P(hclk),.HDMI_D0_P(h0),.HDMI_D1_P(h1),.HDMI_D2_P(h2),
 .sd_ncs(ncs),.sd_dclk(sck),.sd_mosi(mosi),.sd_miso(miso));
wire [31:0] commands,reads,last_lba;
wire [31:0] cmd0_count;
wire card_error;
sd_spi_card_model #(.IMAGE_BYTES(IMAGE_BYTES),.MAPPED_SECTORS(MAPPED_SECTORS)) card(
 .cs_n(ncs),.sck(sck),.mosi(mosi),.miso(miso),.command_count(commands),
 .read_count(reads),.last_lba(last_lba),.cmd0_count(cmd0_count),.protocol_error(card_error));
reg [15:0] pcm_gold[0:959999];
reg [307199:0] rgb_coords_seen=0;
integer pcm_in_session=0,pcm_total=0,session_count=0,transitions=0,ms=0;
integer rgb_pixels_session=0,video_frames_session=0;
integer gate_valid_samples=0,gate_blank_samples=0;
integer rgb_x,rgb_y,rgb_index;
reg [31:0] jpeg_crc_gold[0:299];
reg [31:0] jpeg_crc=32'hffffffff;
integer jpeg_frame=0,jpeg_bytes=0,jpeg_lane;
reg [31:0] rgb_crc=32'hffffffff;
integer expected_cmd0=1;
function [31:0] crc_byte;
 input [31:0] previous;
 input [7:0] value;
 reg [31:0] v;
 integer bit_number;
 begin
  v=previous^value;
  for(bit_number=0;bit_number<8;bit_number=bit_number+1)
   if(v[0])v=(v>>1)^32'hedb88320;else v=v>>1;
  crc_byte=v;
 end
endfunction
always @(posedge dut.rst_all) begin
 pcm_in_session=0;rgb_pixels_session=0;video_frames_session=0;
 rgb_coords_seen=0;rgb_crc=32'hffffffff;
 jpeg_crc=32'hffffffff;jpeg_frame=0;jpeg_bytes=0;session_count=session_count+1;
end
always @(posedge dut.sd_card_clk) begin
 if(card_error)$fatal(1,"external SPI card model protocol error");
end
always @(negedge dut.video_clk) if(!dut.rst_all && dut.audio_valid) begin
 if(dut.audio_left_data!=={pcm_gold[pcm_in_session%960000],8'd0} ||
    dut.audio_right_data!=={pcm_gold[pcm_in_session%960000],8'd0})
  $fatal(1,"PCM mismatch session=%0d sample=%0d got=%h/%h expected=%h",
         session_count,pcm_in_session,dut.audio_left_data,dut.audio_right_data,
         {pcm_gold[pcm_in_session%960000],8'd0});
 if(dut.audio_underflow)$fatal(1,"audio underflow");
 pcm_in_session=pcm_in_session+1;pcm_total=pcm_total+1;
end
// Assert the retained source-valid RGB gate on both sides of its validity signal.
always @(negedge dut.video_clk) if(!dut.rst_all) begin
 if(dut.vout_data_base !== (dut.osd_frame_valid ? dut.vout_data_raw : 24'd0))
  $fatal(1,"source-valid RGB gate mismatch valid=%b raw=%h gated=%h",
         dut.osd_frame_valid,dut.vout_data_raw,dut.vout_data_base);
 if(dut.osd_frame_valid)gate_valid_samples=gate_valid_samples+1;
 else gate_blank_samples=gate_blank_samples+1;
end
// Hash bytes accepted by the real JPEG decoder against the fixture media index.
always @(negedge dut.sd_card_clk) if(!dut.rst_all && dut.video_mode_sd) begin
 if(dut.video_reader_next) begin jpeg_crc=32'hffffffff;jpeg_bytes=0;end
 if(dut.video_jpeg_valid && dut.video_jpeg_accept) begin
  for(jpeg_lane=0;jpeg_lane<4;jpeg_lane=jpeg_lane+1) if(dut.video_jpeg_strb[jpeg_lane]) begin
   jpeg_crc=crc_byte(jpeg_crc,dut.video_jpeg_data[jpeg_lane*8+:8]);
   jpeg_bytes=jpeg_bytes+1;
  end
  if(dut.video_jpeg_last) begin
   if((jpeg_crc^32'hffffffff)!==jpeg_crc_gold[jpeg_frame])
    $fatal(1,"JPEG source CRC mismatch session=%0d frame=%0d bytes=%0d got=%08x expected=%08x",
           session_count,jpeg_frame,jpeg_bytes,jpeg_crc^32'hffffffff,jpeg_crc_gold[jpeg_frame]);
   $display("VIDEO_JPEG_FRAME session=%0d frame=%0d bytes=%0d crc32=%08x",
            session_count,jpeg_frame,jpeg_bytes,jpeg_crc^32'hffffffff);
   jpeg_frame=jpeg_frame+1;
  end
 end
end
// Count actual decoded RGB writes, check full-frame coordinate coverage and
// emit a stable per-frame signature for optional C29/C30 trace comparison.
always @(negedge dut.sd_card_clk) if(!dut.rst_all && dut.video_mode_sd && dut.sd_card_write_en) begin
 rgb_x=dut.video_pixel_x;rgb_y=dut.video_pixel_y;
 if((^dut.video_pixel_x)===1'bx || (^dut.video_pixel_y)===1'bx ||
    rgb_x<0 || rgb_x>=640 || rgb_y<0 || rgb_y>=480)
  $fatal(1,"decoded RGB coordinate out of range x=%0d y=%0d",rgb_x,rgb_y);
 rgb_index=rgb_y*640+rgb_x;
 if(rgb_coords_seen[rgb_index])
  $fatal(1,"decoded RGB coordinate repeated session=%0d index=%0d",session_count,rgb_index);
 if((^dut.sd_card_write_data)===1'bx)
  $fatal(1,"decoded RGB contains X session=%0d index=%0d",session_count,rgb_index);
 rgb_coords_seen[rgb_index]=1'b1;
 rgb_crc=crc_byte(rgb_crc,dut.sd_card_write_data[23:16]);
 rgb_crc=crc_byte(rgb_crc,dut.sd_card_write_data[15:8]);
 rgb_crc=crc_byte(rgb_crc,dut.sd_card_write_data[7:0]);
 rgb_pixels_session=rgb_pixels_session+1;
end
always @(posedge dut.frame_write_finish) if(!dut.rst_all && dut.video_mode_sd) begin
 if(rgb_pixels_session!=307200 || (&rgb_coords_seen)!==1'b1)
  $fatal(1,"incomplete RGB frame session=%0d pixels=%0d",session_count,rgb_pixels_session);
 $display("VIDEO_RGB_FRAME session=%0d frame=%0d pixels=%0d crc32=%08x t=%0t",
          session_count,video_frames_session,rgb_pixels_session,rgb_crc^32'hffffffff,$time);
 video_frames_session=video_frames_session+1;
 rgb_pixels_session=0;rgb_coords_seen=0;rgb_crc=32'hffffffff;
end
task check_session;
 input wanted;
 begin
  wait(!dut.rst_all);
  wait(dut.fs_ready && dut.display_valid && pcm_in_session>=256);
  if(wanted)wait(video_frames_session>=1);
  if(dut.video_mode!==wanted || dut.video_mode_sd!==wanted || cmd0_count!=expected_cmd0)
   $fatal(1,"mode/reinitialization mismatch mode=%b expected=%b CMD0=%0d expected=%0d",
          dut.video_mode_sd,wanted,cmd0_count,expected_cmd0);
  if(wanted && video_frames_session<1)$fatal(1,"video session lacked completed RGB frame");
  $display("RESTART_SESSION_PASS transition=%0d video=%0d frames=%0d pixels=%0d PCM=%0d total=%0d reads=%0d commands=%0d CMD0=%0d",
           transitions,wanted,video_frames_session,rgb_pixels_session,pcm_in_session,
           pcm_total,reads,commands,cmd0_count);
 end
endtask
task media_event;
 input mode_change;
 input wanted;
 input integer byte_position;
 begin
  // Exercise data and CRC boundaries in the live SPI read transaction.
  wait(dut.u_shared_card.sd_card_cmd_m0.state==7 &&
       dut.u_shared_card.sd_card_cmd_m0.byte_cnt==byte_position);
  if(mode_change) begin
   @(negedge dut.video_clk);force dut.video_mode_press=1'b1;
   @(negedge dut.video_clk);release dut.video_mode_press;
  end else begin
   @(negedge dut.sd_card_clk);force dut.video_next_press=1'b1;
   @(negedge dut.sd_card_clk);release dut.video_next_press;
  end
  wait(dut.media_reset_active);
  expected_cmd0=expected_cmd0+1;
  transitions=transitions+1;
  check_session(wanted);
 end
endtask
initial begin
 $readmemh("pcm.mem",pcm_gold);
 $readmemh("jpeg_crc.mem",jpeg_crc_gold);
 repeat(100)@(negedge clk);rst_n=1;
 wait(dut.fs_ready);
 check_session(0);
 media_event(1,1,37);
 media_event(0,1,0);
 media_event(0,1,511);
 media_event(1,0,512);
 media_event(1,1,37);
 media_event(1,0,513);
 if(transitions!=6 || cmd0_count!=7 || pcm_total<1792 ||
    gate_valid_samples==0 || gate_blank_samples==0)
  $fatal(1,"incomplete restart test transitions=%0d CMD0=%0d PCM=%0d gate=%0d/%0d",
         transitions,cmd0_count,pcm_total,gate_valid_samples,gate_blank_samples);
 $display("VIDEO_SYSTEM_PASS restart_roundtrip transitions=%0d PCM=%0d CMD0=%0d reads=%0d commands=%0d gate=%0d/%0d",
          transitions,pcm_total,cmd0_count,reads,commands,gate_valid_samples,gate_blank_samples);
 $finish;
end
initial begin
 for(ms=0;ms<5000;ms=ms+1)begin
  #1000000;
  if(ms%25==0)$display("RESTART_PROGRESS ms=%0d video=%b PCM=%0d frames=%0d CMD0=%0d",
                       ms,dut.video_mode,pcm_in_session,video_frames_session,cmd0_count);
 end
 $fatal(1,"restart system timeout");
end
endmodule


