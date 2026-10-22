`timescale 1ns/1ps
module tb_system;
 defparam dut.u_hdmi_1_4b_transmitter_core_wrapper.u_hdmi_tx_controller_wrapper.u_hdmi_island_data_gen.U_audio_sample_packet_2_channel.u_w96_d1024_fifo.u5.ADDR_WIDTH = 7;

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
 reg [23:0] source_rgb[0:255];
 integer pushes=0,consumed=0,pixels=0,commits=0,valid_frames=0;
 integer read_pixels=0,read_position=0,complete_read_frames=0;
 reg read_frame_eligible=0;
 integer elapsed_ms=0;
 integer max_ms=200;
`ifdef HAS_FFT
 integer fft_trace,fft_frames=0;
 initial begin
  fft_trace=$fopen("fft_trace.csv","w");if(fft_trace==0)$fatal(1,"Cannot open FFT trace");
 end
 // Observe the actual accepted sample writes, not an independently injected PCM.
 always @(posedge dut.video_clk)if(!dut.rst_all && dut.u_pcm_waveform.u_spectrum.sample_write_en && !dut.u_pcm_waveform.u_spectrum.source_change)
  $fdisplay(fft_trace,"S,%0d,%0d,%04h",fft_frames,dut.u_pcm_waveform.u_spectrum.sample_count,dut.u_pcm_waveform.u_spectrum.audio_pcm);
 always @(negedge dut.video_clk)if(!dut.rst_all)begin
  if(dut.u_pcm_waveform.u_spectrum.band_valid)
   $fdisplay(fft_trace,"B,%0d,%0d,%04h",fft_frames,dut.u_pcm_waveform.u_spectrum.band_index,dut.u_pcm_waveform.u_spectrum.band_value);
  if(dut.u_pcm_waveform.u_spectrum.frame_done)begin
   $fdisplay(fft_trace,"D,%0d",fft_frames);fft_frames=fft_frames+1;
  end
 end
`endif
 reg [15:0] wanted_sample;
 reg [23:0] wanted_pixel;
 // The generated 16x16 BMP is bottom-up. Loader emits bottom row first;
 // production WRITE_V_FLIP=1 restores upright pixels at readout.
 function [23:0] pixel_gold;
 input integer index;
 integer x,y;
 begin
  x=index%640;y=index/640;
  if(x<80 || x>=560)pixel_gold=0;
  else pixel_gold=source_rgb[(15-y/30)*16+(x-80)/30];
 end endfunction
 initial begin
  $display("BOUNDARY original archived top startup/media/FIFO/HDMI RTL; PLL simulation initialization adapter; APPLICATION memory model has assumed data-leading-valid contract");
  $readmemh("wave_samples.mem",pcm_gold);
  if($value$plusargs("max_ms=%d",max_ms))begin end
  $readmemh("source_rgb.mem",source_rgb);
  if(^pcm_gold[0]===1'bx || ^pcm_gold[8191]===1'bx || ^source_rgb[0]===1'bx || ^source_rgb[255]===1'bx)
   $fatal(1,"missing golden fixture data");
  repeat(100)@(negedge clk);rst_n=1;
 end
 initial begin
  #1000;$display("TIME_CHECK t_ns=%0.0f ref=%b pixel=%b serial=%b syslock=%b vidlock=%b",$realtime,clk,dut.video_clk,dut.hdmi_5x_clk,dut.sys_pll_lock,dut.video_pll_lock);
  #99000;$display("TIME_CHECK t_ns=%0.0f rst=%b count=%0d",$realtime,dut.rst_all,dut.rst_cnt);
 end

always @(negedge dut.sd_card_clk) if (!dut.rst_all) begin
    if (dut.video_mode_press !== 1'b0 || dut.video_mode !== 1'b0 || dut.video_mode_sd !== 1'b0)
        $fatal(1, "photo regression left default photo mode: press=%b mode=%b sd_mode=%b",
            dut.video_mode_press, dut.video_mode, dut.video_mode_sd);
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
   if(elapsed_ms<=2 || elapsed_ms%10==0)$display("PROGRESS ms=%0d rst=%b card=%b fs=%b imgs=%0d pcm=%0d/%0d pixels=%0d commits=%0d display=%b hdmi=%b card_reads=%0d lba=%0d",elapsed_ms,dut.rst_all,dut.card_init_done,dut.fs_ready,dut.fs_bmp_count,pushes,consumed,pixels,commits,dut.display_valid,dut.hdmi_video_locked,card_reads,last_lba);
   if(elapsed_ms%10==0)$display("MEM_PROGRESS bmp_state=%h req=%b ack=%b ready=%b writes=%0d reads=%0d wr_state=%h rd_state=%h wr_used=%0d rd_used=%0d busy_wr=%b busy_rd=%b init=%b",
    dut.state_code,dut.sd_card_write_req,dut.sd_card_write_req_ack,dut.bmp_write_ready,
    dut.u_frame_buffer.u_sdram.write_count,dut.u_frame_buffer.u_sdram.read_count,
    dut.u_frame_buffer.u_legacy_frame_backend.frame_fifo_write_m0.state,
    dut.u_frame_buffer.u_legacy_frame_backend.frame_fifo_read_m0.state,
    dut.u_frame_buffer.u_legacy_frame_backend.rdusedw,dut.u_frame_buffer.u_legacy_frame_backend.wrusedw,
    dut.u_frame_buffer.u_legacy_frame_backend.O_wr_busy,dut.u_frame_buffer.u_legacy_frame_backend.O_rd_busy,dut.u_frame_buffer.init_done);
   if(commits>=1 && complete_read_frames>=1 && consumed>=4096 && pixels>=307200 && dut.hdmi_video_locked)begin
`ifdef HAS_FFT
    if(fft_frames<3)$fatal(1,"FFT liveness failed frames=%0d",fft_frames);
`endif
    $display("PHOTO_MODE_GUARD_PASS video_mode=0 video_mode_press=0");
    $display("SYSTEM_MEDIA_PASS PCM_push=%0d PCM_consume=%0d BMP_pixels=%0d read_pixels=%0d frames=%0d",pushes,consumed,pixels,read_pixels,complete_read_frames);
    $display("BOUNDARY serial HDMI content still requires separate scoreboard");$finish;
   end
   if(elapsed_ms>=max_ms)begin $display("DIAGNOSTIC_LIMIT_REACHED not a completed media test");$finish;end
  end
  $fatal(1,"SYSTEM timeout; media/commit/HDMI conditions not all satisfied");
 end
endmodule
