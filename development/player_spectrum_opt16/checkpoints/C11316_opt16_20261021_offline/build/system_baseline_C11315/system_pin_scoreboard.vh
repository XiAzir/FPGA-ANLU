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
