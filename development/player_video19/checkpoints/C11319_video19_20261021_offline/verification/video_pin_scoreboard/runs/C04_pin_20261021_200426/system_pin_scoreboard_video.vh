// pin_rgb_reference is emitted by an offline run of the frozen JPEG core on
// the first four JPEG byte streams. pcm_gold is loaded from the source PCM file.
reg [23:0] pin_rgb_reference[0:1228799];
integer pin_axis_frame=-1,pin_axis_pos=0,pin_rgb_sent=0;
integer pin_rgb_checked=0,pin_audio_sent=0,pin_audio_checked=0;
integer pin_rgb_index=0,pin_distinct_pixels=0,pin_diff_scan=0;
integer pin_output_frame=0,pin_audio_index=0;
integer pin_checked_frame1=0,pin_checked_frame2=0,pin_checked_frame3=0;
reg pin_negative_rgb=0,pin_negative_pcm=0;
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

initial begin
 pin_negative_rgb=$test$plusargs("PIN_NEGATIVE_RGB");
 pin_negative_pcm=$test$plusargs("PIN_NEGATIVE_PCM");
 $readmemh("pin_rgb_reference.mem",pin_rgb_reference);
end

always @(posedge dut.video_clk) if(!dut.rst_all) begin
 if(dut.axis_s_valid) begin
  if(!dut.axis_s_ready)$fatal(1,"PIN scoreboard core input dropped pixel");
  if(dut.axis_s_user) begin
   if(pin_axis_frame>=0 && pin_axis_pos!=307200)
    $fatal(1,"PIN AXIS frame length frame=%0d pixels=%0d",pin_axis_frame,pin_axis_pos);
   pin_axis_frame=pin_axis_frame+1;
   pin_axis_pos=0;
  end
  if(pin_axis_frame<0 || pin_axis_pos>=307200)$fatal(1,"PIN AXIS frame boundary missing");
  if(^dut.axis_s_data===1'bx)$fatal(1,"PIN scoreboard unknown core RGB");
  pin_axis_pos=pin_axis_pos+1;
  pin_rgb_sent=pin_rgb_sent+1;
 end
 if(dut.audio_valid) begin
  if(pin_audio_sent>=16384)$fatal(1,"PIN audio golden queue overflow");
  pin_audio_sent=pin_audio_sent+1;
 end
end

always @(posedge pin_word_valid) begin
 #0.003;
 if(!dut.rst_all && pin_pixel_valid && pin_line>=480 && pin_line<1920) begin
  pin_rgb_index=pin_line*640+pin_column;
  pin_output_frame=pin_line/480;
  if(pin_output_frame>3 || pin_rgb_index>=4*307200)
   $fatal(1,"PIN RGB reference range frame=%0d index=%0d",pin_output_frame,pin_rgb_index);
  if(pin_rgb!==((pin_rgb_reference[pin_rgb_index] ^ (pin_negative_rgb ? 24'h000001 : 24'h000000))))
   $fatal(1,"PIN RGB mismatch frame=%0d index=%0d got=%h want=%h",pin_output_frame,pin_rgb_index,pin_rgb,pin_rgb_reference[pin_rgb_index]);
  case(pin_output_frame)
   1:pin_checked_frame1=pin_checked_frame1+1;
   2:pin_checked_frame2=pin_checked_frame2+1;
   3:pin_checked_frame3=pin_checked_frame3+1;
  endcase
  pin_rgb_checked=pin_rgb_checked+1;
 end
end

always @(posedge pin_packets.monitor_clk) if(!dut.rst_all && pin_packets.packet_monitor.audio_good) begin
 if(pin_packets.packet_monitor.sp!==4'b0001)$fatal(1,"PIN PCM checker requires one pair per packet");
 if(pin_audio_checked>=pin_audio_sent)$fatal(1,"PIN PCM output without accepted input");
 pin_audio_index=pin_audio_checked%960000;
 if(pin_packets.packet_monitor.body0_complete[47:0]!==
    ({pcm_gold[pin_audio_index],8'b0,pcm_gold[pin_audio_index],8'b0} ^ (pin_negative_pcm ? 48'h000000000001 : 48'h0)))
  $fatal(1,"PIN PCM mismatch index=%0d got=%h want=%h",pin_audio_checked,
         pin_packets.packet_monitor.body0_complete[47:0],
         {pcm_gold[pin_audio_index],8'b0,pcm_gold[pin_audio_index],8'b0});
 pin_audio_checked=pin_audio_checked+1;
end

task check_pin_scoreboard;
begin
 $display("SYSTEM_PIN_RESULT axis_frames=%0d axis_pixels=%0d rgb_checked=%0d rows=%0d pcm_sent=%0d pcm_checked=%0d",
          pin_axis_frame+1,pin_rgb_sent,pin_rgb_checked,pin_rows,pin_audio_sent,pin_audio_checked);
 if(pin_axis_frame<3 || pin_rgb_checked!=921600 || pin_rows<1920 ||
    pin_checked_frame1!=307200 || pin_checked_frame2!=307200 || pin_checked_frame3!=307200 ||
    !pin_locked || pin_malformed!=0 || pin_period_errors!=0 ||
    pin_audio_checked<12000 || pin_audio_sent-pin_audio_checked>4)
  $fatal(1,"PIN output coverage/liveness/alignment incomplete");
 for(pin_diff_scan=0;pin_diff_scan<307200;pin_diff_scan=pin_diff_scan+1)
  if(pin_rgb_reference[307200+pin_diff_scan]!==pin_rgb_reference[614400+pin_diff_scan] &&
     pin_rgb_reference[307200+pin_diff_scan]!==pin_rgb_reference[921600+pin_diff_scan] &&
     pin_rgb_reference[614400+pin_diff_scan]!==pin_rgb_reference[921600+pin_diff_scan])
   pin_distinct_pixels=pin_distinct_pixels+1;
 if(pin_distinct_pixels==0)$fatal(1,"PIN HDMI reference frames 1,2,3 lack a pixel where all differ");
 if(pin_packets.packet_monitor.win_bad_bch!=0 || pin_packets.packet_monitor.win_bad_terc!=0)
  $fatal(1,"PIN packet BCH/TERC corruption");
 $display("SYSTEM_PIN_CONTENT_PASS HDMI frames=1,2,3 exact against offline frozen-core RGB; three reference frames distinct_pixels=%0d; PCM samples exact against pcm.mem BCH/TERC clean",
          pin_distinct_pixels);
end
endtask
