`timescale 1ns/1ps
module tb_hdmi_tone_metadata;
    reg pixel_clk=0, serial_clk=0, rst=1;
    integer h=0,v=0, sent_pixels=0, accepted_audio=0,dropped_pixels=0;
    integer compared_pixels=0, mismatched_pixels=0, nonvideo_words=0,total_words=0;
    integer first_gold=-1, mismatch_prints=0,near_index=-1,j;
    reg [23:0] expected_rgb [0:921599];
    wire [23:0] tx_rgb;
    wire tx_user,tx_valid,tx_last;
    wire audio_valid;
    reg sequence_audio_mode=0;
    integer audio_received=0,audio_mismatches=0;
integer audio_sp1_packets=0,audio_sp_invalid=0;
    reg [47:0] tone_sample_queue[0:8191];
    integer tone_sample_queued=0,tone_packet_checked=0,tone_pcm_mismatches=0;
    integer meta_packets=0,avi_packets=0,audio_info_packets=0,sample_packets=0,acr_packets=0;
    integer audio_meta_prints=0;
    initial if($test$plusargs("sequence_audio"))sequence_audio_mode=1;
    function [23:0] pcm_l;input integer i;reg [15:0] s;begin s=16'h8001+i*16'h0137;pcm_l={s,8'h00};end endfunction
function [23:0] pcm_r;input integer i;reg [15:0] s;begin s=16'h7003+i*16'h01B5;pcm_r={s,8'h00};end endfunction

    wire [23:0] audio_left,audio_right;
    wire tone_valid;
wire [23:0] tone_left,tone_right;
assign audio_valid=tone_valid;
assign audio_left=tone_left;
assign audio_right=tone_right;
integer side_file,subframes_logged=0,packet_header_file,audio_headers_logged=0,bflag_count=0,bflag_first_index=-1,bflag_first_flags=0;
integer status_file,status_capture_active=0,status_frames_captured=0,status_parity_errors=0;
integer patch_cursor_trace_file,trace_output_audio_packet=0,trace_cursor_rows=0;
integer baseline_status_file,baseline_status_capture=0,baseline_status_frames=0,baseline_status_bindex=-1,baseline_status_parity_errors=0,baseline_audio_packet_count=0;
reg [191:0] baseline_c_left=0,baseline_c_right=0;
reg baseline_event_clk=0;
reg [191:0] c_left_bits=0,c_right_bits=0;
integer patch_delay_samples=0,patch_delay_errors=0,patch_delay_checks=0;
reg [39:0] core_delay_pipe[0:8];
reg [9:0] clock_delay_pipe[0:8];
integer delay_i,byte_i,bit_i,byte_sum;
reg [7:0] c_left_byte,c_right_byte;
    wire axis_ready,video_locked;
    wire [9:0] core_ch0,core_ch1,core_ch2,core_clk;
    wire [9:0] patch_ch0,patch_ch1,patch_ch2,patch_clk;
    wire patch_metadata_word=
      ((metadata_patch.in_type==8'h84 &&
        (metadata_patch.packet_index_pipe[7]<12 || metadata_patch.packet_index_pipe[7]>=28)) ||
       (metadata_patch.in_type==8'h02 &&
        (metadata_patch.packet_index_pipe[7]==25 || metadata_patch.packet_index_pipe[7]==27 ||
         metadata_patch.packet_index_pipe[7]>=28)));
    wire serial0,serial1,serial2,serialclk;
    wire rx_valid,rx_locked;
    wire [9:0] rx0,rx1,rx2,rxclk;
    wire [31:0] malformed_words;
    wire [23:0] packet_samples,packet_packets,bad_bch,bad_terc,tone_bad;
    wire [23:0] base_samples,base_packets,base_bad_bch,base_bad_terc,base_tone_bad;
    wire [19:0] base_acr_cts,base_acr_n;
    wire [3:0] base_flags;
    wire [19:0] acr_cts_seen,acr_n_seen;
    wire [3:0] packet_flags;
    wire acr_valid;
    wire [19:0] acr_cts,acr_n;
    wire rgb_pixel_valid;
    wire [31:0] pixel_line,pixel_column,rows_completed,period_errors;
    wire [23:0] decoded_rgb;
    reg [23:0] expected_pixel;
    integer found_index,i;
    integer cycles=0;
    reg [9:0] core_hist0[0:31],core_hist1[0:31],core_hist2[0:31];
    integer parallel_delay_hits[0:31];
    integer pin_words=0,pin_word_match_cur=0,pin_word_match_hist=0,unknown_rx=0,unknown_core=0,hi,hidx,hit_sum=0, video_guard_hits=0, control_preamble_hits=0;
    reg corrupt_rgb=0, corrupt_audio=0;
    reg solid_rgb_mode=0;
    reg negative_rgb_mode=0;
    reg [10:0] src_x_d1=0;
    reg [9:0] src_y_d1=0;
    wire source_de=(h>=144 && h<784 && v>=45 && v<525);
    wire source_vs=(v<2);
    wire [23:0] source_rgb_base=source_de ? rgb_for(h-144,v-45):24'd0;
    wire [23:0] source_rgb=negative_rgb_mode && h==144+(1234%640) && v==45+(1234/640)
                         ? source_rgb_base^24'h000001:source_rgb_base;
    tri1 ddc_sda;
    wire ddc_scl;

    initial begin #0.000; forever #20 pixel_clk=~pixel_clk; end
always #4 serial_clk=~serial_clk;
    hdmi_audio_tone_pcm_scale #(.CLK_FREQ_HZ(25000000),.SAMPLE_RATE_HZ(48000),.AMP(24'sd1000000),.NOTE_HOLD_SAMPLES(24000)) u_tone (
      .I_clk(pixel_clk),.I_rst(rst),.O_audio_valid(tone_valid),
      .O_audio_left_data(tone_left),.O_audio_right_data(tone_right));
    initial begin
      side_file=$fopen("audio_subframe_sideband.csv","w"); $fdisplay(side_file,"index,left24,right24,sideband_raw,side_lo_nibble,side_hi_nibble");
      packet_header_file=$fopen("audio_sample_packet_headers.csv","w");
      $fdisplay(packet_header_file,"packet_index,HB1_SP,HB2,B_flags_HB2_7_4");
      status_file=$fopen("patched_channel_status_block.csv","w");
      $fdisplay(status_file,"frame_index,left24,right24,C_left,C_right,P_left,P_right,parity_ok,B_flags");
      patch_cursor_trace_file=$fopen("patch_cursor_trace.csv","w");
      $fdisplay(patch_cursor_trace_file,"time_ns,event,out_packet_seq,out_idx,out_valid,in_type,in_idx,cursor,cvalid,bit0,bit1,lane1_o,lane2_o");
      baseline_status_file=$fopen("baseline_core_channel_status_block.csv","w");
      $fdisplay(baseline_status_file,"frame_index,left24,right24,V_L,U_L,C_L,P_L,V_R,U_R,C_R,P_R,parity_ok,B_flags");
    end

    function [23:0] rgb_for;
        input integer x,y;
        reg [7:0] r,g,b;
        begin
            if(solid_rgb_mode) rgb_for=24'h123456;
            else begin
                r=(x*3+y*5+(x>>2)) & 8'hff;
                g=(x*7) ^ (y*11);
                b=x ^ ((y<<4) | (x>>4));
                rgb_for={r,g,b};
            end
        end
    endfunction

    always @(posedge pixel_clk) begin
        if (rst) begin h<=0;v<=0;cycles=0; end
        else begin
            cycles=cycles+1;
            if(h==799) begin h<=0; if(v==524) v<=0; else v<=v+1; end
            else h<=h+1;
            if(tx_valid && axis_ready) begin
                if(sent_pixels<921600) expected_rgb[sent_pixels]=rgb_for(src_x_d1,src_y_d1);
                sent_pixels=sent_pixels+1;
            end
            if(tx_valid && !axis_ready) dropped_pixels=dropped_pixels+1;
            if(audio_valid) begin
              if(tone_sample_queued>=8192)$fatal(1,"tone PCM queue overflow");
              tone_sample_queue[tone_sample_queued]={audio_right,audio_left};
              tone_sample_queued=tone_sample_queued+1;
              accepted_audio=accepted_audio+1;
            end
            src_x_d1<=h-144;
            src_y_d1<=v-45;
        end
    end

    // Four-way word/clock pipeline scoreboard. The metadata patch must present
    // the corresponding core words exactly eight pixel clocks later.
    always @(posedge pixel_clk) begin
      if(rst) begin
        patch_delay_samples=0;
        for(delay_i=0;delay_i<=8;delay_i=delay_i+1) begin
          core_delay_pipe[delay_i]<=40'd0;
          clock_delay_pipe[delay_i]<=10'b1111100000;
        end
      end else begin
        core_delay_pipe[0]<={core_clk,core_ch2,core_ch1,core_ch0};
        clock_delay_pipe[0]<=core_clk;
        for(delay_i=1;delay_i<=8;delay_i=delay_i+1) begin
          core_delay_pipe[delay_i]<=core_delay_pipe[delay_i-1];
          clock_delay_pipe[delay_i]<=clock_delay_pipe[delay_i-1];
        end
        #0.002;
        patch_delay_samples=patch_delay_samples+1;
        if(patch_delay_samples>8) begin
          patch_delay_checks=patch_delay_checks+1;
          if(patch_clk!==core_delay_pipe[8][39:30] || patch_ch0!==core_delay_pipe[8][9:0]) begin
            patch_delay_errors=patch_delay_errors+1;
            if(patch_delay_errors<=4)$display("PATCH_DELAY_MISMATCH sample=%0d clk/ch0=%020h exp=%020h",patch_delay_samples,{patch_clk,patch_ch0},{core_delay_pipe[8][39:30],core_delay_pipe[8][9:0]});
          end
          if(!patch_metadata_word &&
             (patch_ch1!==core_delay_pipe[8][19:10] || patch_ch2!==core_delay_pipe[8][29:20])) begin
            patch_delay_errors=patch_delay_errors+1;
            if(patch_delay_errors<=4)$display("PATCH_UNEXPECTED_WORD_CHANGE sample=%0d got=%03h/%03h exp=%03h/%03h type=%02h idx=%0d valid=%b in_idx=%0d cidx=%0d",patch_delay_samples,patch_ch1,patch_ch2,core_delay_pipe[8][19:10],core_delay_pipe[8][29:20],metadata_patch.in_type,metadata_patch.packet_index_pipe[7],metadata_patch.packet_valid_pipe[7],metadata_patch.in_idx,metadata_patch.channel_status_index);
          end
        end
      end
    end

    // Use the actual production RGB/DE-to-AXIS source so user/valid/last timing
    // and the core's ready handshake match the board design.
    video_rgb_to_axis_640x480 video_source(
        .I_clk(pixel_clk),.I_rst(rst),.I_vs(source_vs),.I_de(source_de),.I_rgb(source_rgb),
        .O_video_user(tx_user),.O_video_valid(tx_valid),.O_video_last(tx_last),.O_video_data(tx_rgb)
    );

    initial begin
        if($test$plusargs("negative_rgb")) negative_rgb_mode=1;
        if($test$plusargs("solid")) solid_rgb_mode=1;
        for(hi=0;hi<32;hi=hi+1) parallel_delay_hits[hi]=0;
    end

hdmi_1_4b_transmitter_core_wrapper #(
        .DEVICE("EG"), .HTOTAL(800), .HSA(96), .HFP(16), .HBP(48), .HACTIVE(640),
        .VTOTAL(525), .VSA(2), .VFP(10), .VBP(33), .VACTIVE(480),
        .VIDEO_TPG("Disable"), .VIDEO_FORMAT("RGB"), .VIDEO_VIC(1),
        .AUDIO_SAMPLE_RATE("48K"), .IIC_SCL_DIV(250)
    ) core (
        .I_pixel_clk(pixel_clk),.I_rst(rst),.I_edid_read_trig(1'b0),
        .O_edid_read_valid(),.O_edid_read_data(),
        .I_axis_s_user(tx_user),.I_axis_s_valid(tx_valid),.I_axis_s_last(tx_last),
        .I_axis_s_data(tx_rgb),.O_axis_s_ready(axis_ready),
        .I_audio_valid(audio_valid),.I_audio_left_data(audio_left),.I_audio_right_data(audio_right),
        .I_acr_valid(acr_valid),.I_acr_cts(acr_cts),.I_acr_n(acr_n),
        .O_video_locked(video_locked),.O_ddc_scl(ddc_scl),.IO_ddc_sda(ddc_sda),
        .O_ch0_tmds_data(core_ch0),.O_ch1_tmds_data(core_ch1),.O_ch2_tmds_data(core_ch2),
        .O_clk_tmds_data(core_clk)
    );

    hdmi_audio_metadata_patch metadata_patch(
        .pixel_clk(pixel_clk),.reset(rst),
        .lane0_i(core_ch0),.lane1_i(core_ch1),.lane2_i(core_ch2),.clock_i(core_clk),
        .lane0_o(patch_ch0),.lane1_o(patch_ch1),.lane2_o(patch_ch2),.clock_o(patch_clk)
    );
    wire baseline_monitor_clk=baseline_event_clk|rst;
    always @(posedge pixel_clk) begin
      if(rst) baseline_event_clk=0;
      else begin #0.001 baseline_event_clk=1; #0.001 baseline_event_clk=0; end
    end
    hdmi_packet_monitor #(.CLK_HZ(25000000),.TONE_AMP(24'd1000000)) baseline_core_monitor(
      .clk(baseline_monitor_clk),.rst(rst),.tone_mode(1'b0),
      .ch0(core_ch0),.ch1(core_ch1),.ch2(core_ch2),
      .audio_samples_sec(base_samples),.audio_packets_sec(base_packets),
      .bad_bch_sec(base_bad_bch),.bad_terc_sec(base_bad_terc),.tone_bad_sec(base_tone_bad),
      .acr_cts_last(base_acr_cts),.acr_n_last(base_acr_n),.probe_flags(base_flags)
    );
    always @(posedge pixel_clk) if(!rst) begin
      if(metadata_patch.packet_valid_pipe[7] && metadata_patch.in_type==8'h02 &&
         metadata_patch.packet_index_pipe[7]==0)
        trace_output_audio_packet=trace_output_audio_packet+1;
      if(metadata_patch.packet_valid_pipe[7] && metadata_patch.in_type==8'h02 &&
         (metadata_patch.packet_index_pipe[7]==25 || metadata_patch.packet_index_pipe[7]==27) && trace_cursor_rows<8000) begin
        $fdisplay(patch_cursor_trace_file,"%0t,OUT_C_P,%0d,%0d,%b,%02h,%0d,%0d,%b,%1h,%1h,%03h,%03h",$time,
          trace_output_audio_packet,metadata_patch.packet_index_pipe[7],metadata_patch.packet_valid_pipe[7],
          metadata_patch.in_type,metadata_patch.in_idx,metadata_patch.channel_status_index,
          metadata_patch.channel_status_valid,metadata_patch.n1,metadata_patch.n2,patch_ch1,patch_ch2);
        trace_cursor_rows=trace_cursor_rows+1;
      end
      if(metadata_patch.in_type==8'h02 && metadata_patch.in_idx==4 &&
         metadata_patch.channel_status_valid && trace_cursor_rows<8000) begin
        $fdisplay(patch_cursor_trace_file,"%0t,INCREMENT,%0d,%0d,%b,%02h,%0d,%0d,%b,%1h,%1h,%03h,%03h",$time,
          trace_output_audio_packet,metadata_patch.packet_index_pipe[7],metadata_patch.packet_valid_pipe[7],
          metadata_patch.in_type,metadata_patch.in_idx,metadata_patch.channel_status_index,
          metadata_patch.channel_status_valid,metadata_patch.n1,metadata_patch.n2,patch_ch1,patch_ch2);
        trace_cursor_rows=trace_cursor_rows+1;
      end
      if(metadata_patch.in_type==8'h02 && metadata_patch.in_idx==20 && trace_cursor_rows<8000) begin
        $fdisplay(patch_cursor_trace_file,"%0t,IN_B_PROBE,%0d,%0d,%b,%02h,%0d,%0d,%b,%1h,%1h,%03h,%03h",$time,
          trace_output_audio_packet,metadata_patch.packet_index_pipe[7],metadata_patch.packet_valid_pipe[7],
          metadata_patch.in_type,metadata_patch.in_idx,metadata_patch.channel_status_index,
          metadata_patch.channel_status_valid,metadata_patch.id0[2],metadata_patch.id0[1],patch_ch1,patch_ch2);
        trace_cursor_rows=trace_cursor_rows+1;
      end
    end
    always @(posedge baseline_monitor_clk) begin
      if(!rst && baseline_core_monitor.packet_done && baseline_core_monitor.packet_good &&
         baseline_core_monitor.header_complete[7:0]==8'h02 && baseline_core_monitor.audio_good) begin
        if(!baseline_status_capture && baseline_core_monitor.header_complete[23:20]==4'h1) begin
          baseline_status_capture=1;
          baseline_status_bindex=baseline_audio_packet_count;
        end
        if(baseline_status_capture && baseline_status_frames<192) begin
          $fdisplay(baseline_status_file,"%0d,%06h,%06h,%1h,%1h,%1h,%1h,%1h,%1h,%1h,%1h,%0d,%1h",baseline_status_frames,
            baseline_core_monitor.body0_complete[23:0],baseline_core_monitor.body0_complete[47:24],
            baseline_core_monitor.body0_complete[48],baseline_core_monitor.body0_complete[49],
            baseline_core_monitor.body0_complete[50],baseline_core_monitor.body0_complete[51],
            baseline_core_monitor.body0_complete[52],baseline_core_monitor.body0_complete[53],
            baseline_core_monitor.body0_complete[54],baseline_core_monitor.body0_complete[55],
            ((^baseline_core_monitor.body0_complete[23:0] ^ baseline_core_monitor.body0_complete[48] ^ baseline_core_monitor.body0_complete[49] ^ baseline_core_monitor.body0_complete[50])==baseline_core_monitor.body0_complete[51] &&
             (^baseline_core_monitor.body0_complete[47:24] ^ baseline_core_monitor.body0_complete[52] ^ baseline_core_monitor.body0_complete[53] ^ baseline_core_monitor.body0_complete[54])==baseline_core_monitor.body0_complete[55]),
            baseline_core_monitor.header_complete[23:20]);
          baseline_c_left[baseline_status_frames]=baseline_core_monitor.body0_complete[50];
          baseline_c_right[baseline_status_frames]=baseline_core_monitor.body0_complete[54];
          if((^baseline_core_monitor.body0_complete[23:0] ^ baseline_core_monitor.body0_complete[48] ^ baseline_core_monitor.body0_complete[49] ^ baseline_core_monitor.body0_complete[50])!==baseline_core_monitor.body0_complete[51] ||
             (^baseline_core_monitor.body0_complete[47:24] ^ baseline_core_monitor.body0_complete[52] ^ baseline_core_monitor.body0_complete[53] ^ baseline_core_monitor.body0_complete[54])!==baseline_core_monitor.body0_complete[55])
            baseline_status_parity_errors=baseline_status_parity_errors+1;
          baseline_status_frames=baseline_status_frames+1;
        end
        baseline_audio_packet_count=baseline_audio_packet_count+1;
      end
    end
    audio_arc_calculate #(.ACR_N(6144)) audio_clock_reference(
        .I_clk(pixel_clk),.I_rst(rst),.I_audio_valid(audio_valid),
        .O_acr_valid(acr_valid),.O_acr_cts(acr_cts),.O_acr_n(acr_n)
    );

    hdmi_phy_wrapper #(.DEVICE("EG")) phy(
        .I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),
        .I_tmds_channel_0(patch_ch0),.I_tmds_channel_1(patch_ch1),
        .I_tmds_channel_2(patch_ch2),.I_tmds_channel_clk(patch_clk),
        .O_tmds_ch0_p(serial0),.O_tmds_ch1_p(serial1),
        .O_tmds_ch2_p(serial2),.O_tmds_clk_p(serialclk)
    );

    always @(posedge pixel_clk) begin
        for(hidx=31;hidx>0;hidx=hidx-1) begin
            core_hist0[hidx]=core_hist0[hidx-1];
            core_hist1[hidx]=core_hist1[hidx-1];
            core_hist2[hidx]=core_hist2[hidx-1];
        end
        core_hist0[0]=core_ch0;core_hist1[0]=core_ch1;core_hist2[0]=core_ch2;
    end
    hdmi_serial_receiver #(.CLOCK_WORD(10'b0000011111)) receiver(
        .serial_clk(serial_clk),.pixel_clk(pixel_clk),.rst(rst),
        .tmds_clk(serialclk),.tmds_d0(serial0),.tmds_d1(serial1),.tmds_d2(serial2),
        .symbol_valid(rx_valid),.ch0(rx0),.ch1(rx1),.ch2(rx2),.chclk(rxclk),
        .alignment_locked(rx_locked),.malformed_words(malformed_words)
    );
    hdmi_serial_packet_monitor #(.CLK_HZ(25000000),.TONE_AMP(24'd1000000),.CLOCK_WORD(10'b0000011111)) pin_packets(
        .serial_clk(serial_clk),.pixel_clk(pixel_clk),.rst(rst),
        .tmds_clk(serialclk),.tmds_d0(serial0),.tmds_d1(serial1),.tmds_d2(serial2),.tone_mode(1'b0),
        .alignment_locked(),.malformed_words(),
        .audio_samples_sec(packet_samples),.audio_packets_sec(packet_packets),
        .bad_bch_sec(bad_bch),.bad_terc_sec(bad_terc),.tone_bad_sec(tone_bad),
        .acr_cts_last(acr_cts_seen),.acr_n_last(acr_n_seen),.probe_flags(packet_flags)
    );

    hdmi_video_period_receiver rgb_decode(.word_clk(rx_valid),.rst(rst),.ch0(rx0),.ch1(rx1),.ch2(rx2),
      .pixel_valid(rgb_pixel_valid),.rgb(decoded_rgb),.pixel_line(pixel_line),.pixel_column(pixel_column),
      .rows_completed(rows_completed),.protocol_errors(period_errors));
    always @(posedge rx_valid)begin
      #0.003;total_words=total_words+1;
      if(rgb_pixel_valid && pixel_line>=480 && pixel_line<960)begin
        found_index=307200+(pixel_line-480)*640+pixel_column;
        if(found_index>=sent_pixels)$fatal(1,"gold queue missing input index=%0d accepted=%0d",found_index,sent_pixels);
        if((pixel_line-480)*640+pixel_column!=compared_pixels)$fatal(1,"pixel order/count gap");
        expected_pixel=expected_rgb[found_index];
        if(^expected_pixel===1'bx)$fatal(1,"unknown gold pixel");
        if(decoded_rgb!==expected_pixel)begin
          mismatched_pixels=mismatched_pixels+1;
          if(mismatch_prints<8)begin
            $display("STRICT_RGB_MISMATCH index=%0d got=%06x want=%06x",found_index,decoded_rgb,expected_pixel);
            mismatch_prints=mismatch_prints+1;
          end
        end
        compared_pixels=compared_pixels+1;
      end
    end

    // Reconstruct complete subpacket zero through the existing TERC/BCH parser.
    // At this sample cadence the tested core emits one stereo pair per packet;
    // reject other packetization rather than silently ignoring extra pairs.
    always @(posedge pin_packets.monitor_clk)if(!rst && sequence_audio_mode && pin_packets.packet_monitor.audio_good)begin
      if(pin_packets.packet_monitor.sp!==4'b0001)$fatal(1,"Ordered PCM checker requires one stereo pair per packet");
      if(pin_packets.packet_monitor.body0_complete[23:0]!==pcm_l(audio_received) ||
         pin_packets.packet_monitor.body0_complete[47:24]!==pcm_r(audio_received))begin
        audio_mismatches=audio_mismatches+1;
        if(audio_mismatches<=4)$display("ORDERED_PCM_MISMATCH index=%0d L=%06h/%06h R=%06h/%06h",audio_received,
          pin_packets.packet_monitor.body0_complete[23:0],pcm_l(audio_received),
          pin_packets.packet_monitor.body0_complete[47:24],pcm_r(audio_received));
      end
      audio_received=audio_received+1;
    end

    // Packet metadata and channel sideband captured after serial pin recovery.
    always @(posedge pin_packets.monitor_clk) begin
      if(!rst && pin_packets.packet_monitor.packet_done && pin_packets.packet_monitor.packet_good) begin
        meta_packets=meta_packets+1;
        if(pin_packets.packet_monitor.header_complete[7:0]==8'h82) begin
          avi_packets=avi_packets+1;
          if(avi_packets<=2)$display("AVI_INFOFRAME HB=%06h PB0_6=%014h",pin_packets.packet_monitor.header_complete,pin_packets.packet_monitor.body0_complete);
        end else if(pin_packets.packet_monitor.header_complete[7:0]==8'h84) begin
          audio_info_packets=audio_info_packets+1;
          if(pin_packets.packet_monitor.body0_complete[7:0]!==8'h61 ||
             pin_packets.packet_monitor.body0_complete[15:8]!==8'h01 ||
             pin_packets.packet_monitor.body0_complete[23:16]!==8'h0F ||
             pin_packets.packet_monitor.body0_complete[20:18]!==3'b011 ||
             pin_packets.packet_monitor.body0_complete[17:16]!==2'b11)
            $fatal(1,"patched Audio InfoFrame PB0/PB1/PB2 or SF/SS invalid: %014h",pin_packets.packet_monitor.body0_complete);
          byte_sum=pin_packets.packet_monitor.header_complete[7:0]+
                   pin_packets.packet_monitor.header_complete[15:8]+
                   pin_packets.packet_monitor.header_complete[23:16];
          for(byte_i=0;byte_i<7;byte_i=byte_i+1)
            byte_sum=byte_sum+pin_packets.packet_monitor.body0_complete[byte_i*8 +: 8]+
              pin_packets.packet_monitor.body1_complete[byte_i*8 +: 8]+
              pin_packets.packet_monitor.body2_complete[byte_i*8 +: 8]+
              pin_packets.packet_monitor.body3_complete[byte_i*8 +: 8];
          if((byte_sum&255)!=0)$fatal(1,"patched Audio InfoFrame checksum invalid sum=%02h",byte_sum&255);
          if(audio_info_packets<=4)$display("AUDIO_INFOFRAME HB=%06h PB0_6=%014h",pin_packets.packet_monitor.header_complete,pin_packets.packet_monitor.body0_complete);
        end else if(pin_packets.packet_monitor.header_complete[7:0]==8'h02) begin
          sample_packets=sample_packets+1;
          if(pin_packets.packet_monitor.audio_good && audio_headers_logged<192) begin
            $fdisplay(packet_header_file,"%0d,%02h,%02h,%1h",audio_headers_logged,
              pin_packets.packet_monitor.header_complete[15:8],
              pin_packets.packet_monitor.header_complete[23:16],
              pin_packets.packet_monitor.header_complete[23:20]);
            if(pin_packets.packet_monitor.header_complete[11:8]!=4'h1)
              $fatal(1,"Audio sample packet SP != 4'h1: HB1=%02h",pin_packets.packet_monitor.header_complete[15:8]);
            bflag_count=bflag_count+pin_packets.packet_monitor.header_complete[20]
              +pin_packets.packet_monitor.header_complete[21]
              +pin_packets.packet_monitor.header_complete[22]
              +pin_packets.packet_monitor.header_complete[23];
            if(pin_packets.packet_monitor.header_complete[23:20]!=0 && bflag_first_index<0) begin
              bflag_first_index=audio_headers_logged;
              bflag_first_flags=pin_packets.packet_monitor.header_complete[23:20];
            end
            audio_headers_logged=audio_headers_logged+1;
          end
          if(pin_packets.packet_monitor.audio_good) begin
            if(pin_packets.packet_monitor.sp!==4'b0001) audio_sp_invalid=audio_sp_invalid+1;
            else audio_sp1_packets=audio_sp1_packets+1;
            if(tone_packet_checked>=tone_sample_queued)
              $fatal(1,"serial PCM arrived before corresponding tone sample index=%0d queued=%0d",tone_packet_checked,tone_sample_queued);
            if(pin_packets.packet_monitor.body0_complete[23:0]!==tone_sample_queue[tone_packet_checked][23:0] ||
               pin_packets.packet_monitor.body0_complete[47:24]!==tone_sample_queue[tone_packet_checked][47:24]) begin
              tone_pcm_mismatches=tone_pcm_mismatches+1;
              if(tone_pcm_mismatches<=4)$display("TONE_PCM_MISMATCH sample=%0d L=%06h/%06h R=%06h/%06h",tone_packet_checked,
                pin_packets.packet_monitor.body0_complete[23:0],tone_sample_queue[tone_packet_checked][23:0],
                pin_packets.packet_monitor.body0_complete[47:24],tone_sample_queue[tone_packet_checked][47:24]);
            end
            tone_packet_checked=tone_packet_checked+1;
          end
          if(!status_capture_active && pin_packets.packet_monitor.header_complete[23:20]==4'h1)
            status_capture_active=1;
          if(status_capture_active && status_frames_captured<192 && pin_packets.packet_monitor.audio_good) begin
            $fdisplay(status_file,"%0d,%06h,%06h,%1h,%1h,%1h,%1h,%0d,%1h",status_frames_captured,
              pin_packets.packet_monitor.body0_complete[23:0],pin_packets.packet_monitor.body0_complete[47:24],
              pin_packets.packet_monitor.body0_complete[50],pin_packets.packet_monitor.body0_complete[54],
              pin_packets.packet_monitor.body0_complete[51],pin_packets.packet_monitor.body0_complete[55],
              ((^pin_packets.packet_monitor.body0_complete[23:0] ^ pin_packets.packet_monitor.body0_complete[48] ^ pin_packets.packet_monitor.body0_complete[49] ^ pin_packets.packet_monitor.body0_complete[50])==pin_packets.packet_monitor.body0_complete[51] &&
               (^pin_packets.packet_monitor.body0_complete[47:24] ^ pin_packets.packet_monitor.body0_complete[52] ^ pin_packets.packet_monitor.body0_complete[53] ^ pin_packets.packet_monitor.body0_complete[54])==pin_packets.packet_monitor.body0_complete[55]),
              pin_packets.packet_monitor.header_complete[23:20]);
            c_left_bits[status_frames_captured]=pin_packets.packet_monitor.body0_complete[50];
            c_right_bits[status_frames_captured]=pin_packets.packet_monitor.body0_complete[54];
            if((^pin_packets.packet_monitor.body0_complete[23:0] ^ pin_packets.packet_monitor.body0_complete[48] ^ pin_packets.packet_monitor.body0_complete[49] ^ pin_packets.packet_monitor.body0_complete[50])!==pin_packets.packet_monitor.body0_complete[51] ||
               (^pin_packets.packet_monitor.body0_complete[47:24] ^ pin_packets.packet_monitor.body0_complete[52] ^ pin_packets.packet_monitor.body0_complete[53] ^ pin_packets.packet_monitor.body0_complete[54])!==pin_packets.packet_monitor.body0_complete[55])
              status_parity_errors=status_parity_errors+1;
            status_frames_captured=status_frames_captured+1;
          end
          if(subframes_logged<192 && pin_packets.packet_monitor.audio_good) begin
            $fdisplay(side_file,"%0d,%06h,%06h,%02h,%1h,%1h",subframes_logged,pin_packets.packet_monitor.body0_complete[23:0],pin_packets.packet_monitor.body0_complete[47:24],pin_packets.packet_monitor.body0_complete[55:48],pin_packets.packet_monitor.body0_complete[51:48],pin_packets.packet_monitor.body0_complete[55:52]);
            subframes_logged=subframes_logged+1;
          end
        end else if(pin_packets.packet_monitor.header_complete[7:0]==8'h01) begin
          acr_packets=acr_packets+1;
        end
      end
    end
    initial begin
        repeat(20) @(posedge pixel_clk);
        rst=0;
        wait(rows_completed>=960);
        repeat(10)@(posedge pixel_clk);
        $fclose(side_file);
        $fclose(packet_header_file);
        $fclose(status_file);
        $fclose(patch_cursor_trace_file);
        $fclose(baseline_status_file);
        $display("BASELINE_CORE_STATUS_SUMMARY packets=%0d frames=%0d B_start=%0d parity_errors=%0d",baseline_audio_packet_count,baseline_status_frames,baseline_status_bindex,baseline_status_parity_errors);
        for(byte_i=0;byte_i<5;byte_i=byte_i+1) begin
          c_left_byte=0;c_right_byte=0;
          for(bit_i=0;bit_i<8;bit_i=bit_i+1) begin
            c_left_byte[bit_i]=baseline_c_left[byte_i*8+bit_i];
            c_right_byte[bit_i]=baseline_c_right[byte_i*8+bit_i];
          end
          $display("BASELINE_CORE_STATUS_BYTE index=%0d left=%02h right=%02h",byte_i,c_left_byte,c_right_byte);
        end
        $display("PATCH_DELAY_SUMMARY samples=%0d checks=%0d errors=%0d",patch_delay_samples,patch_delay_checks,patch_delay_errors);
        $display("TONE_PCM_SUMMARY queued=%0d received=%0d mismatches=%0d",tone_sample_queued,tone_packet_checked,tone_pcm_mismatches);
        $display("AUDIO_PACKET_STATS packets=%0d SP1=%0d SP_invalid=%0d ACR_packets=%0d",sample_packets,audio_sp1_packets,audio_sp_invalid,acr_packets);
        $display("CHANNEL_STATUS_SUMMARY frames=%0d parity_errors=%0d B_start=%0d",status_frames_captured,status_parity_errors,bflag_first_index);
        for(byte_i=0;byte_i<5;byte_i=byte_i+1) begin
          c_left_byte=0;c_right_byte=0;
          for(bit_i=0;bit_i<8;bit_i=bit_i+1) begin
            c_left_byte[bit_i]=c_left_bits[byte_i*8+bit_i];
            c_right_byte[bit_i]=c_right_bits[byte_i*8+bit_i];
          end
          $display("CHANNEL_STATUS_BYTE index=%0d left=%02h right=%02h",byte_i,c_left_byte,c_right_byte);
        end
        for(i=0;i<192;i=i+1) begin
          if(c_left_bits[i]!==baseline_c_left[i] || c_right_bits[i]!==baseline_c_right[i])
            $fatal(1,"patched C bit differs from encrypted-core baseline frame=%0d patched=%b%b baseline=%b%b",i,c_left_bits[i],c_right_bits[i],baseline_c_left[i],baseline_c_right[i]);
        end
        $display("META_SUMMARY packets=%0d AVI=%0d AUDIO_INFO=%0d AUDIO_SAMPLE=%0d ACR=%0d SUBFRAMES=%0d",meta_packets,avi_packets,audio_info_packets,sample_packets,acr_packets,subframes_logged);
        $display("AUDIO_HEADER_SUMMARY packets=%0d B_flags=%0d",audio_headers_logged,bflag_count);
        $display("AUDIO_BLOCK_START packet_index=%0d B_flags=%1h",bflag_first_index,bflag_first_flags);
        $display("RGB_SUMMARY queued=%0d decoded=%0d mismatches=%0d first_gold=%0d video_locked=%0b rx_locked=%0b malformed=%0d nonvideo=%0d total_words=%0d parallel_current_match=%0d parallel_history_match=%0d dropped=%0d",
          sent_pixels,compared_pixels,mismatched_pixels,first_gold,video_locked,rx_locked,malformed_words,nonvideo_words,total_words,pin_word_match_cur,pin_word_match_hist,dropped_pixels);
        $display("AUDIO_SUMMARY input_samples=%0d packets=%0d subpacket_samples=%0d bch_bad=%0d terc_bad=%0d tone_bad=%0d flags=%b acr_n=%0d acr_cts=%0d",
          accepted_audio,pin_packets.packet_monitor.win_packets,pin_packets.packet_monitor.win_samples,
          pin_packets.packet_monitor.win_bad_bch,pin_packets.packet_monitor.win_bad_terc,
          pin_packets.packet_monitor.win_tone_bad,packet_flags,acr_n_seen,acr_cts_seen);
        $display("PERIOD_SUMMARY rows=%0d errors=%0d",rows_completed,period_errors);
        if(!rx_locked || malformed_words!=0 || !video_locked) $fatal(1,"core/PHY alignment failed");
        if(sent_pixels<614400 || compared_pixels!=307200 || period_errors!=0 || dropped_pixels!=0) $fatal(1,"RGB golden queue or decoder empty");
        if($test$plusargs("negative_rgb")) begin
            if(mismatched_pixels!=1) $fatal(1,"negative RGB must produce exactly one mismatch");
        end else if(mismatched_pixels!=0) $fatal(1,"RGB scoreboard mismatch");
        if(pin_packets.packet_monitor.win_packets==0 || pin_packets.packet_monitor.win_samples==0 ||
           pin_packets.packet_monitor.win_bad_bch!=0 || pin_packets.packet_monitor.win_bad_terc!=0)
            $fatal(1,"audio packet/checksum coverage incomplete or invalid");
        if(audio_headers_logged!=192 || subframes_logged!=192)
            $fatal(1,"expected 192 one-sample audio packets / 192 subframes, got packets=%0d subframes=%0d",audio_headers_logged,subframes_logged);
        if(bflag_count!=1 || bflag_first_index!=191 || bflag_first_flags!=1)
            $fatal(1,"expected one B0_j block-start at packet 191 across 192 samples, count=%0d first=%0d flags=%1h",bflag_count,bflag_first_index,bflag_first_flags);
        if(status_frames_captured!=192 || status_parity_errors!=0 || baseline_status_frames!=192 || baseline_status_parity_errors!=0)
            $fatal(1,"channel-status coverage/parity failure frames=%0d parity=%0d",status_frames_captured,status_parity_errors);
        if(!c_left_bits[25] || !c_right_bits[25] || !c_left_bits[32] || !c_left_bits[33] || !c_left_bits[35] ||
           !c_right_bits[32] || !c_right_bits[33] || !c_right_bits[35])
            $fatal(1,"48-kHz/24-bit C byte Fs/word-length target bits are absent");
        if(patch_delay_checks<100000 || patch_delay_errors!=0)
            $fatal(1,"unified 8-word patch delay failure checks=%0d errors=%0d",patch_delay_checks,patch_delay_errors);
        if(tone_packet_checked<1500 || tone_sample_queued-tone_packet_checked>4 || tone_pcm_mismatches!=0)
            $fatal(1,"tone PCM sample-by-sample compare failed queued=%0d received=%0d mismatches=%0d",tone_sample_queued,tone_packet_checked,tone_pcm_mismatches);
        if(sample_packets!=tone_packet_checked || audio_sp1_packets!=sample_packets || audio_sp_invalid!=0)
            $fatal(1,"audio packet/SP1 sample accounting mismatch packets=%0d PCM=%0d SP1=%0d invalid=%0d",sample_packets,tone_packet_checked,audio_sp1_packets,audio_sp_invalid);
        if(audio_info_packets==0 || acr_n_seen!=20'd6144 || acr_cts_seen!=20'd25000)
            $fatal(1,"AIF or ACR metadata missing/invalid AIF=%0d N=%0d CTS=%0d",audio_info_packets,acr_n_seen,acr_cts_seen);
        if(sequence_audio_mode)begin
          $display("ORDERED_PCM_SUMMARY sent=%0d received=%0d mismatches=%0d",accepted_audio,audio_received,audio_mismatches);
          if(audio_received<1500 || accepted_audio-audio_received>4)$fatal(1,"Ordered PCM coverage/tail incomplete");
          if($test$plusargs("negative_audio"))begin
            if(audio_mismatches!=1)$fatal(1,"One changed PCM sample must cause exactly one mismatch");
          end else if(audio_mismatches!=0)$fatal(1,"Ordered PCM mismatch");
        end else begin
        if($test$plusargs("negative_audio")) begin
            if(pin_packets.packet_monitor.win_tone_bad==0) $fatal(1,"negative audio sample was not detected");
        end else if(pin_packets.packet_monitor.win_tone_bad!=0) $fatal(1,"audio PCM content mismatch");
        end
        $display("PATCHED_PIN_PASS RGB exact after 8-word delay; PCM exact; AIF/SF/SS/checksum; baseline C fields preserved with Fs=48k SS=24; P parity; ACR 6144/25000; BCH/TERC clean");
        $display("STRICT_PERIOD_CONTENT_PASS second complete frame 307200 exact pixels; PCM payload checks plus BCH/TERC (see test mode)");
        $finish;
    end
    initial begin #55000000; $display("TIMEOUT_STATUS rows=%0d errors=%0d rx_locked=%b rx_malformed=%0d video_locked=%b rgb_words=%0d tone_in=%0d tone_out=%0d audio_good=%b pinstate=%0d",rows_completed,period_errors,rx_locked,malformed_words,video_locked,total_words,tone_sample_queued,tone_packet_checked,pin_packets.packet_monitor.audio_good,pin_packets.packet_monitor.state); $fatal(1,"content test timeout"); end
endmodule

