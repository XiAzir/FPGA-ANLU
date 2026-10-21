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
 reg [23:0] source_rgb[0:255];
 integer pushes=0,consumed=0,pixels=0,commits=0,valid_frames=0;
 integer read_pixels=0,read_position=0,complete_read_frames=0;
 reg read_frame_eligible=0;
 // Passive whole-system HDMI pins versus the exact accepted core inputs.
 // The existing TB independently verifies file->PCM and file->framebuffer.
 reg [23:0] pin_rgb_gold[0:614399];
 reg [47:0] pin_audio_gold[0:16383];
 integer pin_rgb_sent=0,pin_rgb_checked=0,pin_audio_sent=0,pin_audio_checked=0;
 integer pin_rgb_index=0;
 wire pin_word_valid,pin_locked;
 wire [9:0] pin_ch0,pin_ch1,pin_ch2,pin_chclk;
 wire [31:0] pin_malformed,pin_line,pin_column,pin_rows,pin_period_errors;
 wire pin_pixel_valid;
 wire [23:0] pin_rgb;
 hdmi_serial_receiver #(.CLOCK_WORD(10'b0000011111)) pin_receiver(
  .serial_clk(dut.hdmi_5x_clk),.pixel_clk(dut.video_clk),.rst(dut.rst_all),
  .tmds_clk(hclk),.tmds_d0(h0),.tmds_d1(h1),.tmds_d2(h2),
  .symbol_valid(pin_word_valid),.ch0(pin_ch0),.ch1(pin_ch1),.ch2(pin_ch2),.chclk(pin_chclk),
  .alignment_locked(pin_locked),.malformed_words(pin_malformed));
 hdmi_video_period_receiver pin_video(
  .word_clk(pin_word_valid),.rst(dut.rst_all),.ch0(pin_ch0),.ch1(pin_ch1),.ch2(pin_ch2),
  .pixel_valid(pin_pixel_valid),.rgb(pin_rgb),.pixel_line(pin_line),.pixel_column(pin_column),
  .rows_completed(pin_rows),.protocol_errors(pin_period_errors));
 hdmi_serial_packet_monitor #(.CLOCK_WORD(10'b0000011111)) pin_packets(
  .serial_clk(dut.hdmi_5x_clk),.pixel_clk(dut.video_clk),.rst(dut.rst_all),
  .tmds_clk(hclk),.tmds_d0(h0),.tmds_d1(h1),.tmds_d2(h2),.tone_mode(1'b0));
 always @(posedge dut.video_clk)if(!dut.rst_all)begin
  if(dut.axis_s_valid)begin
   if(!dut.axis_s_ready)$fatal(1,"PIN scoreboard core input dropped pixel");
   if(dut.axis_s_user && pin_rgb_sent%307200!=0)$fatal(1,"PIN scoreboard unexpected input SOF");
   if(^dut.axis_s_data===1'bx)$fatal(1,"PIN scoreboard unknown input RGB");
   pin_rgb_gold[pin_rgb_sent%614400]=dut.axis_s_data;pin_rgb_sent=pin_rgb_sent+1;
  end
  if(dut.audio_valid)begin
   if(pin_audio_sent>=16384)$fatal(1,"PIN audio golden queue overflow");
   pin_audio_gold[pin_audio_sent]={dut.audio_right_data,dut.audio_left_data};
   pin_audio_sent=pin_audio_sent+1;
  end
 end
 always @(posedge pin_word_valid)begin
  #0.003;
  // Skip only the first complete cold-start video frame, as in qualified unit.
  if(!dut.rst_all && pin_pixel_valid && pin_line>=480)begin
   pin_rgb_index=pin_line*640+pin_column;
   if(pin_rgb_index>=pin_rgb_sent || pin_rgb_sent-pin_rgb_index>614400)$fatal(1,"PIN RGB golden queue coverage gap");
   if(pin_rgb_index!=307200+pin_rgb_checked)$fatal(1,"PIN RGB order/count gap");
   if(pin_rgb!==pin_rgb_gold[pin_rgb_index%614400])
    $fatal(1,"PIN RGB mismatch index=%0d got=%h want=%h",pin_rgb_index,pin_rgb,pin_rgb_gold[pin_rgb_index%614400]);
   pin_rgb_checked=pin_rgb_checked+1;
  end
 end
 always @(posedge pin_packets.monitor_clk)if(!dut.rst_all && pin_packets.packet_monitor.audio_good)begin
  if(pin_packets.packet_monitor.sp!==4'b0001)$fatal(1,"PIN PCM checker requires one pair per packet");
  if(pin_audio_checked>=pin_audio_sent)$fatal(1,"PIN PCM output without accepted input");
  if(pin_packets.packet_monitor.body0_complete[47:0]!==pin_audio_gold[pin_audio_checked])
   $fatal(1,"PIN PCM mismatch index=%0d got=%h want=%h",pin_audio_checked,pin_packets.packet_monitor.body0_complete[47:0],pin_audio_gold[pin_audio_checked]);
  pin_audio_checked=pin_audio_checked+1;
 end
 task check_pin_scoreboard;
 begin
  $display("SYSTEM_PIN_RESULT rgb_sent=%0d rgb_checked=%0d rows=%0d pcm_sent=%0d pcm_checked=%0d",pin_rgb_sent,pin_rgb_checked,pin_rows,pin_audio_sent,pin_audio_checked);
  if(!pin_locked || pin_malformed!=0 || pin_period_errors!=0 || pin_rgb_checked<307200 || pin_audio_checked<4096 || pin_audio_sent-pin_audio_checked>4)
   $fatal(1,"PIN output coverage/liveness/alignment incomplete");
  if(pin_packets.packet_monitor.win_bad_bch!=0 || pin_packets.packet_monitor.win_bad_terc!=0)
   $fatal(1,"PIN packet BCH/TERC corruption");
  $display("SYSTEM_PIN_CONTENT_PASS exact accepted RGB/ordered stereo over serial pins; first cold video frame excluded");
 end
 endtask

 integer elapsed_ms=0;
 integer max_ms=200;
`ifdef HAS_FFT
 integer fft_trace,fft_frames=0,spectrum_visible_pixels=0;
 // Observe actual renderer color in the plot area, not only FFT completion.
 function spectrum_bar_color;
 input [23:0] rgb;
 begin case(rgb)
  24'h24525c,24'h2b626b,24'h33747c,24'h3c868c,24'h46979c,
  24'h50a8ac,24'h5ab8bb,24'h63c6c8,24'h6dd2d4,24'h78dddf:spectrum_bar_color=1;
  default:spectrum_bar_color=0;
 endcase end endfunction
 always @(negedge dut.video_clk)if(!dut.rst_all && dut.de &&
  dut.u_pcm_waveform.x_pos>=128 && dut.u_pcm_waveform.x_pos<512 &&
  dut.u_pcm_waveform.y_pos>=330 && dut.u_pcm_waveform.y_pos<414 &&
  spectrum_bar_color(dut.u_pcm_waveform.rgb_out))spectrum_visible_pixels=spectrum_visible_pixels+1;
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
    if(spectrum_visible_pixels==0)$fatal(1,"FFT completes but no spectrum bar pixels rendered");
    $display("SPECTRUM_RENDER_RESULT visible_bar_pixels=%0d",spectrum_visible_pixels);
`endif
    check_pin_scoreboard; check_mapper_contracts; check_spi_performance; check_bmp_header_contract; check_fifo_hold_contract;
    $display("SYSTEM_MEDIA_PASS PCM_push=%0d PCM_consume=%0d BMP_pixels=%0d read_pixels=%0d frames=%0d",pushes,consumed,pixels,read_pixels,complete_read_frames);
    $display("BOUNDARY serial HDMI scoreboard included; physical IO and full SDF remain unverified");$finish;
   end
   if(elapsed_ms>=max_ms)begin $display("DIAGNOSTIC_LIMIT_REACHED not a completed media test");$finish;end
  end
  $fatal(1,"SYSTEM timeout; media/commit/HDMI conditions not all satisfied");
 end
// Passive verification only: request stability is established by the real callers.
reg bmp_req_active=0,wav_req_active=0,wav_desc_active=0;
reg [95:0] bmp_request,wav_request;
reg [63:0] wav_descriptor;
integer bmp_request_checks=0,wav_request_checks=0;
always @(posedge dut.sd_card_clk) begin
 if(dut.rst_all) begin
  bmp_req_active=0;wav_req_active=0;wav_desc_active=0;
 end else begin
  if(!dut.u_bmp_file_mapper.enable) bmp_req_active=0;
  else begin
   if(dut.fs_cluster_shift>7 || dut.fs_cluster_count==0 ||
      dut.fs_cluster_count>32'h0ffffff5 || dut.fs_fat_lba==32'hffffffff ||
      dut.fs_data_lba==32'hffffffff) $fatal(1,"BMP catalog geometry contract");
   if(bmp_req_active && bmp_request!=={dut.bmp_file_cluster,dut.bmp_file_size,dut.bmp_card_addr})
      $fatal(1,"BMP request stability contract");
   if(dut.bmp_card_end) bmp_req_active=0;
   if(dut.u_bmp_file_mapper.state==0 && dut.u_bmp_file_mapper.armed &&
      dut.bmp_card_read && !dut.bmp_map_error) begin
    bmp_req_active=1;bmp_request={dut.bmp_file_cluster,dut.bmp_file_size,dut.bmp_card_addr};
    bmp_request_checks=bmp_request_checks+1;
   end
  end
  if(!dut.u_wav_file_mapper.enable) begin wav_req_active=0;wav_desc_active=0;end
  else begin
   if(dut.fs_cluster_shift>7 || dut.fs_cluster_count==0 ||
      dut.fs_cluster_count>32'h0ffffff5 || dut.fs_fat_lba==32'hffffffff ||
      dut.fs_data_lba==32'hffffffff) $fatal(1,"WAV catalog geometry contract");
   if(wav_desc_active && wav_descriptor!=={dut.fs_wav_cluster,dut.fs_wav_size})
      $fatal(1,"WAV static descriptor contract");
   wav_desc_active=1;wav_descriptor={dut.fs_wav_cluster,dut.fs_wav_size};
   if(wav_req_active && wav_request!=={dut.fs_wav_cluster,dut.fs_wav_size,dut.wav_card_addr})
      $fatal(1,"WAV request stability contract");
   if(dut.wav_card_end) wav_req_active=0;
   if(dut.u_wav_file_mapper.state==0 && dut.u_wav_file_mapper.armed &&
      dut.wav_card_read && !dut.wav_map_error) begin
    wav_req_active=1;wav_request={dut.fs_wav_cluster,dut.fs_wav_size,dut.wav_card_addr};
    wav_request_checks=wav_request_checks+1;
   end
  end
 end
end
task check_mapper_contracts;
begin
 if(bmp_request_checks<2 || wav_request_checks<2) $fatal(1,"Insufficient mapper request coverage");
 $display("MAPPER_CONTRACT_PASS BMP_requests=%0d WAV_requests=%0d",bmp_request_checks,wav_request_checks);
end
endtask

// Passive measurement of the actual controller/arbiter/caller chain, in ns.
time perf_init=0,perf_fs=0,perf_primed=0,perf_first_pixel=0,perf_commit=0;
time perf_card_start=0,perf_card_max=0,perf_card_total=0;
time perf_bmp_start=0,perf_bmp_max=0,perf_bmp_total=0;
time perf_wav_start=0,perf_wav_max=0,perf_wav_total=0;
time perf_last_sclk=0,perf_min_sclk=0;
time perf_data_first=0,perf_data_last=0;
integer perf_card_count=0,perf_card_bytes=0,perf_sector_bytes=0;
integer perf_bmp_count=0,perf_wav_count=0,perf_underruns=0,perf_fifo_min=8192;
integer perf_log,perf_json;
reg perf_card_pending=0,perf_bmp_pending=0,perf_wav_pending=0;
initial perf_log=$fopen("spi_service.csv","w");
always @(posedge dut.sd_dclk) if(!dut.rst_all && !dut.sd_ncs &&
 dut.u_shared_card.sd_card_sec_read_write_m0.state==6) begin
 if(perf_last_sclk!=0) begin
  if(perf_min_sclk==0 || $time-perf_last_sclk<perf_min_sclk) perf_min_sclk=$time-perf_last_sclk;
  if($time-perf_last_sclk<80) $fatal(1,"SPI clock too fast/glitch");
 end
 perf_last_sclk=$time;
end
always @(posedge dut.frame_write_finish) if(perf_commit==0) perf_commit=$time;
always @(negedge dut.sd_card_clk) if(!dut.rst_all) begin
 if(dut.card_init_done && perf_init==0) perf_init=$time;
 if(dut.fs_ready && perf_fs==0) perf_fs=$time;
 if(dut.wav_primed && perf_primed==0) perf_primed=$time;
 if(dut.sd_card_write_en && perf_first_pixel==0) perf_first_pixel=$time;
 if(dut.audio_underflow) $fatal(1,"SPI performance audio underflow flag");
 if(dut.wav_primed) begin
  if(dut.u_wav_player.fifo_count<perf_fifo_min) perf_fifo_min=dut.u_wav_player.fifo_count;
  if(dut.wav_sample_take && !dut.wav_sample_available) perf_underruns=perf_underruns+1;
 end
 if(!perf_card_pending && dut.shared_card_read) begin
  perf_card_pending=1;perf_card_start=$time;perf_sector_bytes=0;
 end
 if(dut.shared_card_valid) begin
  perf_card_bytes=perf_card_bytes+1;perf_sector_bytes=perf_sector_bytes+1;
  if(perf_data_first==0)perf_data_first=$time;perf_data_last=$time;
 end
 if(perf_card_pending && dut.shared_card_end) begin
  if(perf_sector_bytes!=512) $fatal(1,"SPI sector byte count=%0d",perf_sector_bytes);
  perf_card_count=perf_card_count+1;
  perf_card_total=perf_card_total+($time-perf_card_start);
  if($time-perf_card_start>perf_card_max)perf_card_max=$time-perf_card_start;
  $fdisplay(perf_log,"CARD,%0d,%0d,%0d,%0d",dut.shared_card_addr,perf_card_start,$time,perf_sector_bytes);
  perf_card_pending=0;
 end
 if(!perf_bmp_pending && dut.bmp_phy_read)begin perf_bmp_pending=1;perf_bmp_start=$time;end
 if(perf_bmp_pending && dut.bmp_phy_end) begin
  perf_bmp_count=perf_bmp_count+1;perf_bmp_total=perf_bmp_total+($time-perf_bmp_start);
  if($time-perf_bmp_start>perf_bmp_max)perf_bmp_max=$time-perf_bmp_start;
  $fdisplay(perf_log,"BMP,%0d,%0d,%0d",dut.bmp_phy_addr,perf_bmp_start,$time);
  perf_bmp_pending=0;
 end
 if(!perf_wav_pending && dut.wav_phy_read)begin perf_wav_pending=1;perf_wav_start=$time;end
 if(perf_wav_pending && dut.wav_phy_end) begin
  perf_wav_count=perf_wav_count+1;perf_wav_total=perf_wav_total+($time-perf_wav_start);
  if($time-perf_wav_start>perf_wav_max)perf_wav_max=$time-perf_wav_start;
  $fdisplay(perf_log,"WAV,%0d,%0d,%0d",dut.wav_phy_addr,perf_wav_start,$time);
  perf_wav_pending=0;
 end
end
task check_spi_performance;
begin
 if(dut.sd_crc_bad!=0 || dut.sd_crc_checked<perf_card_count) $fatal(1,"CRC check coverage or bad block");
 if(perf_min_sclk!=80 || perf_underruns!=0) $fatal(1,"SPI rate/underrun");
 if(perf_card_count<3 || perf_bmp_count<1 || perf_wav_count<1) $fatal(1,"SPI service coverage");
 perf_json=$fopen("spi_performance.json","w");
 $fdisplay(perf_json,"{");
 $fdisplay(perf_json,"\"status\":\"PASS\",\"time_unit\":\"ns\",");
 $fdisplay(perf_json,"\"init_ns\":%0d,\"fs_ns\":%0d,\"primed_ns\":%0d,\"first_pixel_ns\":%0d,\"commit_ns\":%0d,",perf_init,perf_fs,perf_primed,perf_first_pixel,perf_commit);
 $fdisplay(perf_json,"\"card_sectors\":%0d,\"card_bytes\":%0d,\"card_max_service_ns\":%0d,\"card_total_service_ns\":%0d,",perf_card_count,perf_card_bytes,perf_card_max,perf_card_total);
 $fdisplay(perf_json,"\"bmp_sectors\":%0d,\"bmp_max_service_ns\":%0d,\"bmp_total_service_ns\":%0d,",perf_bmp_count,perf_bmp_max,perf_bmp_total);
 $fdisplay(perf_json,"\"wav_sectors\":%0d,\"wav_max_service_ns\":%0d,\"wav_total_service_ns\":%0d,",perf_wav_count,perf_wav_max,perf_wav_total);
 $fdisplay(perf_json,"\"crc_checked\":%0d,\"crc_bad\":%0d,\"fifo_min_after_prime\":%0d,\"underruns\":%0d,",dut.sd_crc_checked,dut.sd_crc_bad,perf_fifo_min,perf_underruns);
 $fdisplay(perf_json,"\"first_data_ns\":%0d,\"last_data_ns\":%0d,\"min_sclk_period_ns\":%0d}",perf_data_first,perf_data_last,perf_min_sclk);
 $fclose(perf_json);$fclose(perf_log);
 $display("SPI_PERFORMANCE_PASS sectors=%0d CRC=%0d/%0d underruns=%0d commit_ns=%0d minSCLK_ns=%0d",perf_card_count,dut.sd_crc_checked,dut.sd_crc_bad,perf_underruns,perf_commit,perf_min_sclk);
end
endtask

// Passive proof of the production caller's compile-time header contract.
reg bmp_header_active=0;
reg [96:0] bmp_stable_header;
integer bmp_header_starts=0,bmp_row_checks=0,bmp_byte_checks=0;
wire [96:0] bmp_live_header={dut.u_bmp_file_player.u_scale.source_width,
 dut.u_bmp_file_player.u_scale.source_height,dut.u_bmp_file_player.u_scale.source_top_down,
 dut.u_bmp_file_player.u_scale.pixel_offset,dut.u_bmp_file_player.u_scale.file_size};
always @(posedge dut.sd_card_clk) begin
 if(dut.rst_all) bmp_header_active=0;
 else begin
  if(dut.u_bmp_file_player.scale_start) begin
   if(!dut.u_bmp_file_player.header_ok) $fatal(1,"BMP start without validated header");
   bmp_stable_header=bmp_live_header;bmp_header_active=1;bmp_header_starts=bmp_header_starts+1;
  end else if(dut.u_bmp_file_player.u_scale.state==0) bmp_header_active=0;
  if(bmp_header_active && bmp_stable_header!==bmp_live_header)
   $fatal(1,"BMP header changed while scaler active");
  if(dut.u_bmp_file_player.u_scale.state==3) begin
   if(dut.u_bmp_file_player.u_scale.src_w<1 || dut.u_bmp_file_player.u_scale.src_w>1024 ||
      dut.u_bmp_file_player.u_scale.src_h<1 || dut.u_bmp_file_player.u_scale.src_h>768 ||
      dut.u_bmp_file_player.u_scale.image_end>{1'b0,dut.u_bmp_file_player.file_size})
     $fatal(1,"BMP setup extent contract");
  end
  if(dut.u_bmp_file_player.u_scale.state==6) begin
   bmp_row_checks=bmp_row_checks+1;
   if(dut.u_bmp_file_player.u_scale.physical_row>=dut.u_bmp_file_player.u_scale.src_h ||
      dut.u_bmp_file_player.u_scale.row_address_wide[32]) $fatal(1,"BMP row extent contract");
  end
  if(dut.u_bmp_file_player.u_scale.state==7) begin
   bmp_byte_checks=bmp_byte_checks+1;
   if(dut.u_bmp_file_player.u_scale.src_col>=dut.u_bmp_file_player.u_scale.src_w ||
      dut.u_bmp_file_player.u_scale.component>2 || dut.u_bmp_file_player.u_scale.byte_address_wide[32] ||
      dut.u_bmp_file_player.u_scale.byte_address_wide[31:0]>=dut.u_bmp_file_player.file_size)
     $fatal(1,"BMP byte extent contract");
  end
 end
end
task check_bmp_header_contract;
begin
 if(bmp_header_starts<1 || bmp_row_checks<1 || bmp_byte_checks<1) $fatal(1,"BMP contract coverage");
 $display("BMP_HEADER_CONTRACT_PASS starts=%0d rows=%0d bytes=%0d",bmp_header_starts,bmp_row_checks,bmp_byte_checks);
end
endtask

// Observe the actual production FIFO used by the reduced RGB reservoir.
integer held_fifo_cycles=0, held_fifo_high_cycles=0;
reg [31:0] held_fifo_before;
reg held_fifo_check;
always @(posedge dut.u_frame_buffer.read_clk) begin
    held_fifo_before=dut.u_frame_buffer.read_word;
    held_fifo_check=!dut.u_frame_buffer.rst &&
        !dut.u_frame_buffer.read_fifo_clear && !dut.u_frame_buffer.read_word_pop;
    #1;
    if (held_fifo_check && !dut.u_frame_buffer.rst &&
        !dut.u_frame_buffer.read_fifo_clear && (^held_fifo_before !== 1'bx)) begin
        if(dut.u_frame_buffer.read_word !== held_fifo_before)
            $fatal(1,"Actual normal FIFO changed held output without read enable");
        held_fifo_cycles=held_fifo_cycles+1;
        if(dut.u_frame_buffer.u_unpack.byte_count>4)
            held_fifo_high_cycles=held_fifo_high_cycles+1;
    end
end
task check_fifo_hold_contract;
begin
    if(held_fifo_cycles<1000 || held_fifo_high_cycles<1000)
        $fatal(1,"FIFO hold contract lacks live suffix coverage");
    $display("FIFO_HOLD_CONTRACT_PASS held=%0d live_high=%0d",held_fifo_cycles,held_fifo_high_cycles);
end
endtask

endmodule
