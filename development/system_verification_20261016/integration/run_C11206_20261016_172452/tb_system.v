`timescale 1ns/1ps
module tb_system;
 reg clk=0,rst_n=0,key1=1,key2=1;
 always #10 clk=~clk;
 wire [3:0] led;
 wire seg_d,seg_s,seg_r,hclk,h0,h1,h2,ncs,sck,mosi,miso;
 top dut(.clk(clk),.rst_n(rst_n),.key1(key1),.key2(key2),.led(led),
 .seg7_dio(seg_d),.seg7_sclk(seg_s),.seg7_rclk(seg_r),
 .HDMI_CLK_P(hclk),.HDMI_D0_P(h0),.HDMI_D1_P(h1),.HDMI_D2_P(h2),
 .sd_ncs(ncs),.sd_dclk(sck),.sd_mosi(mosi),.sd_miso(miso));
 wire [31:0] card_commands,card_reads,last_lba;
 wire card_error;
 sd_spi_card_model #(.IMAGE_BYTES(67108864)) card(
 .cs_n(ncs),.sck(sck),.mosi(mosi),.miso(miso),
 .command_count(card_commands),.read_count(card_reads),.last_lba(last_lba),.protocol_error(card_error));
 reg [7:0] pcm_gold[0:8191];
 integer pushes=0,consumed=0,pixels=0,commits=0,valid_frames=0;
 integer read_pixels=0,read_position=0,complete_read_frames=0;
 reg read_frame_eligible=0;
 integer elapsed_ms=0;
 reg [15:0] wanted_sample;
 reg [23:0] wanted_pixel;
 // The generated 16x16 BMP is bottom-up. Loader emits bottom row first;
 // production WRITE_V_FLIP=1 restores upright pixels at readout.
 function [23:0] pixel_gold;
 input integer index;
 integer x,y,c;
 begin
  x=index%640;y=index/640;
  if(x<80 || x>=560)pixel_gold=0;
  else begin
   c=(((x-80)/30)/4+2*((15-y/30)/4))%8;
   case(c)
    0:pixel_gold={8'd220,8'd35,8'd35};1:pixel_gold={8'd30,8'd190,8'd65};
    2:pixel_gold={8'd35,8'd80,8'd225};3:pixel_gold={8'd240,8'd205,8'd35};
    4:pixel_gold={8'd190,8'd45,8'd200};5:pixel_gold={8'd25,8'd190,8'd200};
    6:pixel_gold={8'd245,8'd120,8'd25};7:pixel_gold={8'd235,8'd235,8'd235};
   endcase
  end
 end endfunction
 initial begin
  $display("BOUNDARY original archived top startup/media/FIFO/HDMI RTL; PLL simulation initialization adapter; APPLICATION memory model has assumed data-leading-valid contract");
  $readmemh("wave_samples.mem",pcm_gold);
  repeat(100)@(negedge clk);rst_n=1;
 end
 always @(negedge dut.sd_card_clk)if(!dut.rst_all)begin
  if(card_error || dut.fs_error || dut.bmp_error || dut.bmp_map_error || dut.wav_error || dut.wav_map_error)
   $fatal(1,"SYSTEM media error card=%b fs=%b bmp=%b bmap=%b wav=%b wmap=%b state=%h",card_error,dut.fs_error,dut.bmp_error,dut.bmp_map_error,dut.wav_error,dut.wav_map_error,dut.state_code);
  if(dut.pcm_push)begin
   wanted_sample={pcm_gold[(pushes%4096)*2+1],pcm_gold[(pushes%4096)*2]};
   if(dut.pcm_push_data!==wanted_sample)$fatal(1,"PCM push mismatch n=%0d got=%h want=%h",pushes,dut.pcm_push_data,wanted_sample);
   pushes=pushes+1;
  end
  if(dut.sd_card_write_en)begin
   wanted_pixel=pixel_gold(pixels%307200);
   if(dut.sd_card_write_data!==wanted_pixel)$fatal(1,"BMP loader mismatch n=%0d got=%h want=%h",pixels,dut.sd_card_write_data,wanted_pixel);
   pixels=pixels+1;
  end
 end
 always @(negedge dut.video_clk)if(!dut.rst_all && dut.audio_valid)begin
  wanted_sample={pcm_gold[(consumed%4096)*2+1],pcm_gold[(consumed%4096)*2]};
  if(dut.audio_left_data!=={wanted_sample,8'b0} || dut.audio_right_data!=={wanted_sample,8'b0})
   $fatal(1,"PCM consume mismatch n=%0d L=%h R=%h want=%h",consumed,dut.audio_left_data,dut.audio_right_data,wanted_sample);
  consumed=consumed+1;
 end
 always @(posedge dut.frame_write_finish)begin commits=commits+1;$display("FRAME_COMMIT t_ns=%0.0f pixels=%0d",$realtime,pixels);end
 always @(posedge dut.vs)begin
  if(read_frame_eligible && read_position!=307200)$fatal(1,"frame pixel count=%0d",read_position);
  if(read_frame_eligible)complete_read_frames=complete_read_frames+1;
  read_position=0;read_frame_eligible=dut.osd_frame_valid;
  if(dut.osd_frame_valid)valid_frames=valid_frames+1;
 end
 always @(negedge dut.video_clk)if(!dut.rst_all && dut.de && read_frame_eligible)begin
  // Compare the real unpacked framebuffer pixels before OSD/color adjustment.
  if(dut.vout_data_raw!==pixel_gold((479-read_position/640)*640+read_position%640))
   $fatal(1,"framebuffer mismatch pixel=%0d got=%h want=%h",read_position,dut.vout_data_raw,pixel_gold((479-read_position/640)*640+read_position%640));
  read_position=read_position+1;read_pixels=read_pixels+1;
 end
 initial begin
  repeat(200)begin
   #1000000;elapsed_ms=elapsed_ms+1;
   if(elapsed_ms%10==0)$display("PROGRESS ms=%0d rst=%b card=%b fs=%b imgs=%0d pcm=%0d/%0d pixels=%0d commits=%0d display=%b hdmi=%b card_reads=%0d lba=%0d",elapsed_ms,dut.rst_all,dut.card_init_done,dut.fs_ready,dut.fs_bmp_count,pushes,consumed,pixels,commits,dut.display_valid,dut.hdmi_video_locked,card_reads,last_lba);
   if(commits>=1 && complete_read_frames>=1 && consumed>=4096 && pixels>=307200 && dut.hdmi_video_locked)begin
    $display("SYSTEM_MEDIA_PASS PCM_push=%0d PCM_consume=%0d BMP_pixels=%0d read_pixels=%0d frames=%0d",pushes,consumed,pixels,read_pixels,complete_read_frames);
    $display("BOUNDARY serial HDMI content still requires separate scoreboard");$finish;
   end
  end
  $fatal(1,"SYSTEM timeout; media/commit/HDMI conditions not all satisfied");
 end
endmodule
