// Verilog netlist created by Tang Dynasty v6.2.178840
// Fri Oct 23 13:56:38 2026

`timescale 1ns / 1ps
module audio_cone30  // ../user_source/hdl_source/top_tf_hdmi_audio.v(2)
  (
  clk,
  key1,
  key2,
  rst_n,
  sd_miso,
  HDMI_CLK_P,
  HDMI_D0_P,
  HDMI_D1_P,
  HDMI_D2_P,
  led,
  sd_dclk,
  sd_mosi,
  sd_ncs,
  seg7_dio,
  seg7_rclk,
  seg7_sclk
  );

  input clk;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(3)
  input key1;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(5)
  input key2;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(6)
  input rst_n;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(4)
  input sd_miso;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(21)
  output HDMI_CLK_P;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(12)
  output HDMI_D0_P;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(15)
  output HDMI_D1_P;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(14)
  output HDMI_D2_P;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(13)
  output [3:0] led;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(8)
  output sd_dclk;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(19)
  output sd_mosi;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(20)
  output sd_ncs;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(18)
  output seg7_dio;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(9)
  output seg7_rclk;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(9)
  output seg7_sclk;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(9)

  // localparam DISPLAY_HEIGHT = 480;
  // localparam DISPLAY_WIDTH = 640;
  wire [31:0] al_1559;
  wire [31:0] al_1591;
  wire [31:0] al_1688;
  wire [31:0] al_172;
  wire [31:0] al_1720;
  wire [31:0] al_236;
  wire [8:0] al_395;
  wire [8:0] al_413;
  wire [8:0] al_431;
  wire [10:0] al_577;
  wire [10:0] al_588;
  wire [9:0] al_736;
  wire [9:0] al_746;
  wire [31:0] al_787;
  wire [31:0] al_85;
  wire [31:0] al_852;
  wire [23:0] audio_left_data;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(105)
  wire [4:0] media_reset_count;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(155)
  wire [19:0] mux10_syn_2;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(131)
  wire [19:0] rst_cnt;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(126)
  wire [1:0] \u_adjust_control/auto_ack_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/player_adjust_control.v(41)
  wire [22:0] \u_adjust_control/auto_event_cooldown ;  // ../user_source/hdl_source/player_adjust_control.v(59)
  wire [22:0] \u_adjust_control/auto_event_cooldown_b7 ;
  wire [3:0] \u_adjust_control/brightness_pending ;  // ../user_source/hdl_source/player_adjust_control.v(62)
  wire [25:0] \u_adjust_control/chord_hold_count ;  // ../user_source/hdl_source/player_adjust_control.v(57)
  wire [25:0] \u_adjust_control/chord_hold_count_b7 ;
  wire [2:0] \u_adjust_control/contrast_pending ;  // ../user_source/hdl_source/player_adjust_control.v(63)
  wire [15:0] \u_adjust_control/debug_state ;  // ../user_source/hdl_source/player_adjust_control.v(20)
  wire [18:0] \u_adjust_control/key0_db_count ;  // ../user_source/hdl_source/player_adjust_control.v(46)
  wire [18:0] \u_adjust_control/key0_db_count_b3 ;
  wire [25:0] \u_adjust_control/key0_hold_count ;  // ../user_source/hdl_source/player_adjust_control.v(55)
  wire [25:0] \u_adjust_control/key0_hold_count_b6 ;
  wire [1:0] \u_adjust_control/key0_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/player_adjust_control.v(38)
  wire [18:0] \u_adjust_control/key1_db_count ;  // ../user_source/hdl_source/player_adjust_control.v(47)
  wire [18:0] \u_adjust_control/key1_db_count_b2 ;
  wire [25:0] \u_adjust_control/key1_hold_count ;  // ../user_source/hdl_source/player_adjust_control.v(56)
  wire [25:0] \u_adjust_control/key1_hold_count_b6 ;
  wire [1:0] \u_adjust_control/key1_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/player_adjust_control.v(39)
  wire [1:0] \u_adjust_control/mode ;  // ../user_source/hdl_source/player_adjust_control.v(21)
  wire [7:0] \u_adjust_control/mux40_syn_3 ;  // ../user_source/hdl_source/player_adjust_control.v(252)
  wire [7:0] \u_adjust_control/mux51_syn_3 ;  // ../user_source/hdl_source/player_adjust_control.v(266)
  wire [25:0] \u_adjust_control/mux57_syn_2 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire [25:0] \u_adjust_control/mux58_syn_2 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire [25:0] \u_adjust_control/mux62_syn_2 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire [1:0] \u_adjust_control/next_ack_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/player_adjust_control.v(40)
  wire [22:0] \u_adjust_control/next_event_cooldown ;  // ../user_source/hdl_source/player_adjust_control.v(58)
  wire [22:0] \u_adjust_control/next_event_cooldown_b6 ;
  wire [3:0] \u_adjust_osd/bo ;  // ../user_source/hdl_source/player_adjust_osd.v(207)
  wire [3:0] \u_adjust_osd/brightness_index ;  // ../user_source/hdl_source/player_adjust_osd.v(3)
  wire [2:0] \u_adjust_osd/contrast_index ;  // ../user_source/hdl_source/player_adjust_osd.v(3)
  wire [7:0] \u_adjust_osd/ct ;  // ../user_source/hdl_source/player_adjust_osd.v(207)
  wire [1:0] \u_adjust_osd/frame_mode ;  // ../user_source/hdl_source/player_adjust_osd.v(6)
  wire [8:0] \u_adjust_osd/mux11_syn_2 ;  // ../user_source/hdl_source/player_adjust_osd.v(11)
  wire [23:0] \u_adjust_osd/rgb_in ;  // ../user_source/hdl_source/player_adjust_osd.v(2)
  wire [9:0] \u_adjust_osd/x_pos ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire [9:0] \u_adjust_osd/x_pos_b ;
  wire [8:0] \u_adjust_osd/y_pos ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire [8:0] \u_adjust_osd/y_pos_b5 ;
  wire [19:0] \u_audio_probe/u_acr/S_acr_cts_cnt ;  // ../user_source/hdl_source/audio_arc_calculate.v(22)
  wire [19:0] \u_audio_probe/u_acr/S_acr_cts_cnt_b1 ;
  wire [7:0] \u_audio_probe/u_acr/S_audio_div_cnt ;  // ../user_source/hdl_source/audio_arc_calculate.v(20)
  wire [1:0] \u_audio_probe/u_bridge/acknowledge_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/wav_pcm_bridge.v(22)
  wire [23:0] \u_audio_probe/u_bridge/audio_left ;  // ../user_source/hdl_source/wav_pcm_bridge.v(14)
  wire [31:0] \u_audio_probe/u_bridge/mux6_syn_2 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(66)
  wire [31:0] \u_audio_probe/u_bridge/next_acc ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire [1:0] \u_audio_probe/u_bridge/play_sync ;  // ../user_source/hdl_source/wav_pcm_bridge.v(29)
  wire [15:0] \u_audio_probe/u_bridge/prefetch ;  // ../user_source/hdl_source/wav_pcm_bridge.v(27)
  wire [1:0] \u_audio_probe/u_bridge/primed_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/wav_pcm_bridge.v(23)
  wire [1:0] \u_audio_probe/u_bridge/request_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/wav_pcm_bridge.v(21)
  wire [31:0] \u_audio_probe/u_bridge/sample_acc ;  // ../user_source/hdl_source/wav_pcm_bridge.v(28)
  wire [31:0] \u_audio_probe/u_bridge/sample_acc_b1 ;
  wire [15:0] \u_audio_probe/u_bridge/sample_mailbox ;  // ../user_source/hdl_source/wav_pcm_bridge.v(20)
  wire [23:0] \u_audio_probe/u_tone/O_audio_left_data ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(11)
  wire [31:0] \u_audio_probe/u_tone/O_audio_left_data_b2 ;
  wire [2:0] \u_audio_probe/u_tone/S_note_idx ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(35)
  wire [31:0] \u_audio_probe/u_tone/S_note_sample_cnt ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(36)
  wire [31:0] \u_audio_probe/u_tone/S_note_sample_cnt_b2 ;
  wire [23:0] \u_audio_probe/u_tone/S_pcm_sample ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(37)
  wire [31:0] \u_audio_probe/u_tone/S_phase_acc ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(34)
  wire [31:0] \u_audio_probe/u_tone/S_phase_acc_b1 ;
  wire [31:0] \u_audio_probe/u_tone/S_sample_acc ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(33)
  wire [9:0] \u_bmp_file_player/abs_height_b2 ;
  wire [8:0] \u_bmp_file_player/add3_syn_3 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(55)
  wire [30:0] \u_bmp_file_player/add5_syn_2 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire [31:0] \u_bmp_file_player/auto_count ;  // ../user_source/hdl_source/tf_bmp_file_player.v(33)
  wire [31:0] \u_bmp_file_player/auto_count_b6 ;
  wire [7:0] \u_bmp_file_player/card_data ;  // ../user_source/hdl_source/tf_bmp_file_player.v(16)
  wire [1:0] \u_bmp_file_player/current_image_index ;  // ../user_source/hdl_source/tf_bmp_file_player.v(24)
  wire [31:0] \u_bmp_file_player/declared_size ;  // ../user_source/hdl_source/tf_bmp_file_player.v(39)
  wire [31:0] \u_bmp_file_player/declared_size_b ;
  wire [31:0] \u_bmp_file_player/dib_size ;  // ../user_source/hdl_source/tf_bmp_file_player.v(39)
  wire [31:0] \u_bmp_file_player/dib_size_b ;
  wire [1:0] \u_bmp_file_player/disp_buf_idx ;  // ../user_source/hdl_source/tf_bmp_file_player.v(19)
  wire [2:0] \u_bmp_file_player/display_finish_sync ;  // ../user_source/hdl_source/tf_bmp_file_player.v(38)
  wire [31:0] \u_bmp_file_player/file_cluster ;  // ../user_source/hdl_source/tf_bmp_file_player.v(14)
  wire [31:0] \u_bmp_file_player/file_size ;  // ../user_source/hdl_source/tf_bmp_file_player.v(14)
  wire [2:0] \u_bmp_file_player/finish_sync ;  // ../user_source/hdl_source/tf_bmp_file_player.v(38)
  wire [2:0] \u_bmp_file_player/gap_count ;  // ../user_source/hdl_source/tf_bmp_file_player.v(32)
  wire [30:0] \u_bmp_file_player/header_failure_mask_b ;
  wire [9:0] \u_bmp_file_player/height_low ;  // ../user_source/hdl_source/tf_bmp_file_player.v(43)
  wire [1:0] \u_bmp_file_player/load_index ;  // ../user_source/hdl_source/tf_bmp_file_player.v(35)
  wire [1:0] \u_bmp_file_player/pending_buffer ;  // ../user_source/hdl_source/tf_bmp_file_player.v(35)
  wire [31:0] \u_bmp_file_player/pixel_offset ;  // ../user_source/hdl_source/tf_bmp_file_player.v(39)
  wire [31:0] \u_bmp_file_player/pixel_offset_b ;
  wire [9:0] \u_bmp_file_player/sector_bytes ;  // ../user_source/hdl_source/tf_bmp_file_player.v(34)
  wire [21:0] \u_bmp_file_player/source_image_bytes ;  // ../user_source/hdl_source/tf_bmp_file_player.v(57)
  wire [11:0] \u_bmp_file_player/source_stride ;  // ../user_source/hdl_source/tf_bmp_file_player.v(56)
  wire [3:0] \u_bmp_file_player/state_code ;  // ../user_source/hdl_source/tf_bmp_file_player.v(23)
  wire [1:0] \u_bmp_file_player/u_key_event_mailbox/auto_req_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/tf_bmp_file_player.v(266)
  wire [1:0] \u_bmp_file_player/u_key_event_mailbox/next_req_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/tf_bmp_file_player.v(265)
  wire [29:0] \u_bmp_file_player/u_scale/add1_syn_3 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire [11:0] \u_bmp_file_player/u_scale/add2_syn_14 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire [9:0] \u_bmp_file_player/u_scale/add2_syn_3 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire [7:0] \u_bmp_file_player/u_scale/blue_value ;  // ../user_source/hdl_source/bmp_scale_engine.v(86)
  wire [7:0] \u_bmp_file_player/u_scale/blue_value_b1 ;
  wire [32:0] \u_bmp_file_player/u_scale/byte_address_wide ;  // ../user_source/hdl_source/bmp_scale_engine.v(106)
  wire [31:0] \u_bmp_file_player/u_scale/card_addr ;  // ../user_source/hdl_source/bmp_scale_engine.v(16)
  wire [1:0] \u_bmp_file_player/u_scale/component ;  // ../user_source/hdl_source/bmp_scale_engine.v(87)
  wire [10:0] \u_bmp_file_player/u_scale/denominator ;  // ../user_source/hdl_source/bmp_scale_engine.v(76)
  wire [19:0] \u_bmp_file_player/u_scale/denominator_b5 ;
  wire [19:0] \u_bmp_file_player/u_scale/denominator_b6 ;
  wire [8:0] \u_bmp_file_player/u_scale/dh ;  // ../user_source/hdl_source/bmp_scale_engine.v(74)
  wire [5:0] \u_bmp_file_player/u_scale/div_bit ;  // ../user_source/hdl_source/bmp_scale_engine.v(78)
  wire  \u_bmp_file_player/u_scale/div_for_width_i_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [11:0] \u_bmp_file_player/u_scale/div_next_rem_b1 ;
  wire [9:0] \u_bmp_file_player/u_scale/dw ;  // ../user_source/hdl_source/bmp_scale_engine.v(73)
  wire [1:0] \u_bmp_file_player/u_scale/gap_count ;  // ../user_source/hdl_source/bmp_scale_engine.v(85)
  wire [7:0] \u_bmp_file_player/u_scale/green_value ;  // ../user_source/hdl_source/bmp_scale_engine.v(86)
  wire [3:0] \u_bmp_file_player/u_scale/interval_count ;  // ../user_source/hdl_source/bmp_scale_engine.v(98)
  wire  \u_bmp_file_player/u_scale/mux0_syn_66 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux109_syn_1313 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux109_syn_1479 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux109_syn_2065 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux109_syn_2380 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux109_syn_717 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux109_syn_728 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux113_syn_116 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux115_syn_1623 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux131_syn_1005 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux131_syn_1306 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux131_syn_250 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux131_syn_401 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux131_syn_552 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux131_syn_703 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux131_syn_854 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux131_syn_99 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire [21:0] \u_bmp_file_player/u_scale/mux140_syn_1 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [10:0] \u_bmp_file_player/u_scale/mux142_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [9:0] \u_bmp_file_player/u_scale/mux143_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [10:0] \u_bmp_file_player/u_scale/mux144_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [8:0] \u_bmp_file_player/u_scale/mux145_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [9:0] \u_bmp_file_player/u_scale/mux146_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [3:0] \u_bmp_file_player/u_scale/mux147_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [23:0] \u_bmp_file_player/u_scale/mux148_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [9:0] \u_bmp_file_player/u_scale/mux149_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [7:0] \u_bmp_file_player/u_scale/mux150_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [7:0] \u_bmp_file_player/u_scale/mux152_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [9:0] \u_bmp_file_player/u_scale/mux153_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [1:0] \u_bmp_file_player/u_scale/mux154_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [9:0] \u_bmp_file_player/u_scale/mux155_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [22:0] \u_bmp_file_player/u_scale/mux156_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [31:0] \u_bmp_file_player/u_scale/mux158_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [31:0] \u_bmp_file_player/u_scale/mux159_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [9:0] \u_bmp_file_player/u_scale/mux160_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [9:0] \u_bmp_file_player/u_scale/mux161_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [9:0] \u_bmp_file_player/u_scale/mux162_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [18:0] \u_bmp_file_player/u_scale/mux163_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [5:0] \u_bmp_file_player/u_scale/mux167_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [8:0] \u_bmp_file_player/u_scale/mux168_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire [8:0] \u_bmp_file_player/u_scale/mux170_syn_2 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire  \u_bmp_file_player/u_scale/mux1_syn_71 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire  \u_bmp_file_player/u_scale/mux6_syn_223 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire [18:0] \u_bmp_file_player/u_scale/numerator ;  // ../user_source/hdl_source/bmp_scale_engine.v(75)
  wire [18:0] \u_bmp_file_player/u_scale/numerator_b4 ;
  wire [18:0] \u_bmp_file_player/u_scale/numerator_b5 ;
  wire [9:0] \u_bmp_file_player/u_scale/offx ;  // ../user_source/hdl_source/bmp_scale_engine.v(73)
  wire [8:0] \u_bmp_file_player/u_scale/offy ;  // ../user_source/hdl_source/bmp_scale_engine.v(74)
  wire [9:0] \u_bmp_file_player/u_scale/out_x ;  // ../user_source/hdl_source/bmp_scale_engine.v(93)
  wire [8:0] \u_bmp_file_player/u_scale/out_y ;  // ../user_source/hdl_source/bmp_scale_engine.v(94)
  wire [8:0] \u_bmp_file_player/u_scale/output_bottom ;  // ../user_source/hdl_source/bmp_scale_engine.v(116)
  wire [9:0] \u_bmp_file_player/u_scale/output_right ;  // ../user_source/hdl_source/bmp_scale_engine.v(115)
  wire [9:0] \u_bmp_file_player/u_scale/physical_row ;  // ../user_source/hdl_source/bmp_scale_engine.v(88)
  wire [9:0] \u_bmp_file_player/u_scale/physical_row_b11 ;
  wire [9:0] \u_bmp_file_player/u_scale/physical_row_b4 ;
  wire [23:0] \u_bmp_file_player/u_scale/pixel_rgb ;  // ../user_source/hdl_source/bmp_scale_engine.v(19)
  wire [9:0] \u_bmp_file_player/u_scale/quotient ;  // ../user_source/hdl_source/bmp_scale_engine.v(77)
  wire [10:0] \u_bmp_file_player/u_scale/remainder ;  // ../user_source/hdl_source/bmp_scale_engine.v(76)
  wire [31:0] \u_bmp_file_player/u_scale/row_base ;  // ../user_source/hdl_source/bmp_scale_engine.v(99)
  wire [21:0] \u_bmp_file_player/u_scale/row_offset ;  // ../user_source/hdl_source/bmp_scale_engine.v(103)
  wire [23:0] \u_bmp_file_player/u_scale/row_q ;  // ../user_source/hdl_source/bmp_scale_engine.v(92)
  wire [9:0] \u_bmp_file_player/u_scale/row_tag ;  // ../user_source/hdl_source/bmp_scale_engine.v(90)
  wire [9:0] \u_bmp_file_player/u_scale/sector_count ;  // ../user_source/hdl_source/bmp_scale_engine.v(80)
  wire [7:0] \u_bmp_file_player/u_scale/sector_q ;  // ../user_source/hdl_source/bmp_scale_engine.v(82)
  wire [8:0] \u_bmp_file_player/u_scale/sector_raddr ;  // ../user_source/hdl_source/bmp_scale_engine.v(81)
  wire [22:0] \u_bmp_file_player/u_scale/sector_tag ;  // ../user_source/hdl_source/bmp_scale_engine.v(83)
  wire [15:0] \u_bmp_file_player/u_scale/source_height ;  // ../user_source/hdl_source/bmp_scale_engine.v(12)
  wire [9:0] \u_bmp_file_player/u_scale/src_bottom ;  // ../user_source/hdl_source/bmp_scale_engine.v(88)
  wire [9:0] \u_bmp_file_player/u_scale/src_col ;  // ../user_source/hdl_source/bmp_scale_engine.v(89)
  wire [21:0] \u_bmp_file_player/u_scale/state_reg_syn_1 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire [11:0] \u_bmp_file_player/u_scale/stride ;  // ../user_source/hdl_source/bmp_scale_engine.v(49)
  wire [17:0] \u_bmp_file_player/u_scale/stride_b1 ;
  wire [10:0] \u_bmp_file_player/u_scale/x_phase ;  // ../user_source/hdl_source/bmp_scale_engine.v(95)
  wire [10:0] \u_bmp_file_player/u_scale/x_phase_b4 ;
  wire [10:0] \u_bmp_file_player/u_scale/x_phase_b8 ;
  wire [9:0] \u_bmp_file_player/u_scale/x_src ;  // ../user_source/hdl_source/bmp_scale_engine.v(97)
  wire [10:0] \u_bmp_file_player/u_scale/y_phase ;  // ../user_source/hdl_source/bmp_scale_engine.v(96)
  wire [10:0] \u_bmp_file_player/u_scale/y_phase_b8 ;
  wire [31:0] \u_bmp_file_player/watchdog ;  // ../user_source/hdl_source/tf_bmp_file_player.v(33)
  wire [31:0] \u_bmp_file_player/watchdog_b2 ;
  wire [10:0] \u_bmp_file_player/width_low ;  // ../user_source/hdl_source/tf_bmp_file_player.v(41)
  wire [23:0] \u_bmp_file_player/write_data ;  // ../user_source/hdl_source/tf_bmp_file_player.v(21)
  wire [31:0] \u_catalog/active_fat_offset_p0 ;  // ../user_source/hdl_source/fat32_catalog.v(75)
  wire [32:0] \u_catalog/add14_syn_3 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire [127:0] \u_catalog/bmp_clusters ;  // ../user_source/hdl_source/fat32_catalog.v(14)
  wire [127:0] \u_catalog/bmp_clusters_b1 ;
  wire [31:0] \u_catalog/bmp_clusters_b20 ;
  wire [2:0] \u_catalog/bmp_count ;  // ../user_source/hdl_source/fat32_catalog.v(14)
  wire [127:0] \u_catalog/bmp_sizes ;  // ../user_source/hdl_source/fat32_catalog.v(15)
  wire [127:0] \u_catalog/bmp_sizes_b1 ;
  wire [32:0] \u_catalog/bpb_header_candidate_b ;
  wire [33:0] \u_catalog/bpb_header_candidate_b1 ;
  wire [9:0] \u_catalog/byte_index ;  // ../user_source/hdl_source/fat32_catalog.v(28)
  wire [31:0] \u_catalog/cluster_count ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire [33:0] \u_catalog/cluster_count_p2 ;  // ../user_source/hdl_source/fat32_catalog.v(79)
  wire [31:0] \u_catalog/current_root_cluster ;  // ../user_source/hdl_source/fat32_catalog.v(47)
  wire [31:0] \u_catalog/data_lba ;  // ../user_source/hdl_source/fat32_catalog.v(12)
  wire [33:0] \u_catalog/data_lba_p1 ;  // ../user_source/hdl_source/fat32_catalog.v(79)
  wire [33:0] \u_catalog/data_lba_p1_b2 ;
  wire [31:0] \u_catalog/data_lba_p1_b4 ;
  wire [33:0] \u_catalog/data_sector_count_p1 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire [7:0] \u_catalog/dir_clhi_b[0] ;  // ../user_source/hdl_source/fat32_catalog.v(55)
  wire [7:0] \u_catalog/dir_clhi_b[1] ;  // ../user_source/hdl_source/fat32_catalog.v(55)
  wire [7:0] \u_catalog/dir_cllo_b[0] ;  // ../user_source/hdl_source/fat32_catalog.v(55)
  wire [7:0] \u_catalog/dir_cllo_b[1] ;  // ../user_source/hdl_source/fat32_catalog.v(55)
  wire [7:0] \u_catalog/dir_size_b[0] ;  // ../user_source/hdl_source/fat32_catalog.v(55)
  wire [7:0] \u_catalog/dir_size_b[1] ;  // ../user_source/hdl_source/fat32_catalog.v(55)
  wire [7:0] \u_catalog/dir_size_b[2] ;  // ../user_source/hdl_source/fat32_catalog.v(55)
  wire [7:0] \u_catalog/extflags_lo ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire  \u_catalog/fat16_fixed_valid_i1_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [33:0] \u_catalog/fat_area_end_p0 ;  // ../user_source/hdl_source/fat32_catalog.v(71)
  wire [33:0] \u_catalog/fat_area_end_p0_b2 ;
  wire [31:0] \u_catalog/fat_entry_value ;  // ../user_source/hdl_source/fat32_catalog.v(45)
  wire [31:0] \u_catalog/fat_lba ;  // ../user_source/hdl_source/fat32_catalog.v(12)
  wire [33:0] \u_catalog/fat_lba_p2 ;  // ../user_source/hdl_source/fat32_catalog.v(79)
  wire [33:0] \u_catalog/fat_lba_p2_b2 ;
  wire [8:0] \u_catalog/fat_offset ;  // ../user_source/hdl_source/fat32_catalog.v(46)
  wire [32:0] \u_catalog/fat_span ;  // ../user_source/hdl_source/fat32_catalog.v(81)
  wire [7:0] \u_catalog/fats ;  // ../user_source/hdl_source/fat32_catalog.v(31)
  wire [7:0] \u_catalog/fatsz32_b[0] ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire [7:0] \u_catalog/fatsz32_b[1] ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire [7:0] \u_catalog/fatsz32_b[2] ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire [7:0] \u_catalog/fatsz32_b[3] ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire [2:0] \u_catalog/gap_count ;  // ../user_source/hdl_source/fat32_catalog.v(30)
  wire  \u_catalog/is_mbr_i1_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(257)
  wire  \u_catalog/mux0_syn_126 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux0_syn_134 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux10_syn_135 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux11_syn_135 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux14_syn_135 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire [7:0] \u_catalog/mux191_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [7:0] \u_catalog/mux192_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [7:0] \u_catalog/mux193_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [7:0] \u_catalog/mux194_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [31:0] \u_catalog/mux197_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [31:0] \u_catalog/mux198_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [7:0] \u_catalog/mux199_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire  \u_catalog/mux1_syn_49 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire [31:0] \u_catalog/mux201_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [7:0] \u_catalog/mux202_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [7:0] \u_catalog/mux203_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire [9:0] \u_catalog/mux218_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire  \u_catalog/mux2_syn_129 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux2_syn_131 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux2_syn_48 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire [12:0] \u_catalog/mux315_syn_16 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux315_syn_534 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire [31:0] \u_catalog/mux316_syn_3 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire [9:0] \u_catalog/mux317_syn_3 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux317_syn_946 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire [19:0] \u_catalog/mux318_syn_3 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux319_syn_324 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux323_syn_1710 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux350_syn_142 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux350_syn_230 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux350_syn_318 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux351_syn_182 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux351_syn_94 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux352_syn_182 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux352_syn_94 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux353_syn_3510 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux357_syn_142 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire  \u_catalog/mux359_syn_2254 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire [32:0] \u_catalog/partition_end_p0 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire [7:0] \u_catalog/reserved_hi ;  // ../user_source/hdl_source/fat32_catalog.v(31)
  wire [7:0] \u_catalog/reserved_lo ;  // ../user_source/hdl_source/fat32_catalog.v(31)
  wire [7:0] \u_catalog/root_b[0] ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire [7:0] \u_catalog/root_b[1] ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire [7:0] \u_catalog/root_b[2] ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire [7:0] \u_catalog/root_b[3] ;  // ../user_source/hdl_source/fat32_catalog.v(33)
  wire [8:0] \u_catalog/root_clusters_read ;  // ../user_source/hdl_source/fat32_catalog.v(48)
  wire [35:0] \u_catalog/root_lba_p2 ;  // ../user_source/hdl_source/fat32_catalog.v(80)
  wire [35:0] \u_catalog/root_lba_p2_b3 ;
  wire [7:0] \u_catalog/root_sector_in_cluster ;  // ../user_source/hdl_source/fat32_catalog.v(49)
  wire [31:0] \u_catalog/sd_addr ;  // ../user_source/hdl_source/fat32_catalog.v(9)
  wire [31:0] \u_catalog/sd_addr_b12 ;
  wire [31:0] \u_catalog/sd_addr_b17 ;
  wire [31:0] \u_catalog/sd_addr_b2 ;
  wire [7:0] \u_catalog/sd_data ;  // ../user_source/hdl_source/fat32_catalog.v(10)
  wire [3:0] \u_catalog/sectors_per_cluster_shift ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire [3:0] \u_catalog/sectors_per_cluster_shift_b1 ;
  wire [2:0] \u_catalog/sel4_syn_6 ;  // ../user_source/hdl_source/fat32_catalog.v(63)
  wire [1:0] \u_catalog/selected_partition ;  // ../user_source/hdl_source/fat32_catalog.v(42)
  wire [31:0] \u_catalog/selected_size ;  // ../user_source/hdl_source/fat32_catalog.v(43)
  wire [31:0] \u_catalog/selected_start ;  // ../user_source/hdl_source/fat32_catalog.v(43)
  wire [7:0] \u_catalog/signature_hi ;  // ../user_source/hdl_source/fat32_catalog.v(34)
  wire [7:0] \u_catalog/signature_lo ;  // ../user_source/hdl_source/fat32_catalog.v(34)
  wire [7:0] \u_catalog/spc ;  // ../user_source/hdl_source/fat32_catalog.v(31)
  wire [12:0] \u_catalog/state_reg_syn_1 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire [26:0] \u_catalog/sub1_syn_4 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire [26:0] \u_catalog/sub6_syn_2 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire [7:0] \u_catalog/total32_b[0] ;  // ../user_source/hdl_source/fat32_catalog.v(32)
  wire [7:0] \u_catalog/total32_b[1] ;  // ../user_source/hdl_source/fat32_catalog.v(32)
  wire [7:0] \u_catalog/total32_b[2] ;  // ../user_source/hdl_source/fat32_catalog.v(32)
  wire [7:0] \u_catalog/total32_b[3] ;  // ../user_source/hdl_source/fat32_catalog.v(32)
  wire [31:0] \u_catalog/video_cluster ;  // ../user_source/hdl_source/fat32_catalog.v(17)
  wire [31:0] \u_catalog/video_size ;  // ../user_source/hdl_source/fat32_catalog.v(17)
  wire [31:0] \u_catalog/video_size_b1 ;
  wire [32:0] \u_catalog/volume_end_p0 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire [19:0] \u_catalog/wait_count ;  // ../user_source/hdl_source/fat32_catalog.v(29)
  wire [19:0] \u_catalog/wait_count_b11 ;
  wire [31:0] \u_catalog/wav_cluster ;  // ../user_source/hdl_source/fat32_catalog.v(16)
  wire [31:0] \u_catalog/wav_size ;  // ../user_source/hdl_source/fat32_catalog.v(16)
  wire [3:0] \u_dynamic_text/display_minute_ones ;  // ../user_source/hdl_source/player_dynamic_text.v(20)
  wire [3:0] \u_dynamic_text/display_minute_tens ;  // ../user_source/hdl_source/player_dynamic_text.v(19)
  wire [3:0] \u_dynamic_text/display_second_ones ;  // ../user_source/hdl_source/player_dynamic_text.v(22)
  wire [3:0] \u_dynamic_text/display_second_tens ;  // ../user_source/hdl_source/player_dynamic_text.v(21)
  wire [3:0] \u_dynamic_text/minute_ones ;  // ../user_source/hdl_source/player_dynamic_text.v(16)
  wire [3:0] \u_dynamic_text/minute_tens ;  // ../user_source/hdl_source/player_dynamic_text.v(15)
  wire [9:0] \u_dynamic_text/scroll_phase ;  // ../user_source/hdl_source/player_dynamic_text.v(29)
  wire [10:0] \u_dynamic_text/scroll_sum ;  // ../user_source/hdl_source/player_dynamic_text.v(245)
  wire [3:0] \u_dynamic_text/second_ones ;  // ../user_source/hdl_source/player_dynamic_text.v(18)
  wire [3:0] \u_dynamic_text/second_tens ;  // ../user_source/hdl_source/player_dynamic_text.v(17)
  wire [24:0] \u_dynamic_text/second_tick ;  // ../user_source/hdl_source/player_dynamic_text.v(14)
  wire [24:0] \u_dynamic_text/second_tick_b1 ;
  wire [0:1] \u_file_mapper/armed ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(60)
  wire [1:0] \u_file_mapper/audio_streak ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(67)
  wire [31:0] \u_file_mapper/bmp_error_b3 ;
  wire [27:0] \u_file_mapper/brent_anchor[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(57)
  wire [27:0] \u_file_mapper/brent_anchor[0]_b18 ;
  wire [27:0] \u_file_mapper/brent_anchor[1] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(57)
  wire [12:0] \u_file_mapper/brent_length[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(59)
  wire [12:0] \u_file_mapper/brent_length[0]_b25 ;
  wire [12:0] \u_file_mapper/brent_length[1] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(59)
  wire [12:0] \u_file_mapper/brent_power[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(58)
  wire [12:0] \u_file_mapper/brent_power[1] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(58)
  wire [0:1] \u_file_mapper/busy ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(61)
  wire [9:0] \u_file_mapper/byte_count ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(70)
  wire [31:0] \u_file_mapper/cache_size[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(50)
  wire [27:0] \u_file_mapper/cache_start[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(49)
  wire [0:1] \u_file_mapper/cache_valid ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(51)
  wire [7:0] \u_file_mapper/core_state_reg_syn_1 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire [27:0] \u_file_mapper/current_cluster[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(46)
  wire [27:0] \u_file_mapper/current_cluster[1] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(46)
  wire [43:0] \u_file_mapper/data_addr_tmp ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire [43:0] \u_file_mapper/data_addr_tmp_b1 ;
  wire [27:0] \u_file_mapper/data_addr_tmp_b5 ;
  wire [32:0] \u_file_mapper/fat_addr_tmp ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire [7:0] \u_file_mapper/fat_b0 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(72)
  wire [7:0] \u_file_mapper/fat_b1 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(72)
  wire [7:0] \u_file_mapper/fat_b2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(72)
  wire [7:0] \u_file_mapper/fat_b3 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(72)
  wire [7:0] \u_file_mapper/fat_b5 ;
  wire [1:0] \u_file_mapper/gap_count ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(68)
  wire [6:0] \u_file_mapper/mux171_syn_11 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [23:0] \u_file_mapper/mux176_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [55:0] \u_file_mapper/mux177_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [55:0] \u_file_mapper/mux178_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [25:0] \u_file_mapper/mux179_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [25:0] \u_file_mapper/mux180_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [23:0] \u_file_mapper/mux182_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [31:0] \u_file_mapper/mux183_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [9:0] \u_file_mapper/mux184_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [8:0] \u_file_mapper/mux185_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [7:0] \u_file_mapper/mux186_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire [0:1] \u_file_mapper/queued ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(62)
  wire [31:0] \u_file_mapper/sd_addr ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(29)
  wire [23:0] \u_file_mapper/sectors_needed ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(106)
  wire [22:0] \u_file_mapper/sectors_needed_b1 ;
  wire [26:0] \u_file_mapper/sub0_syn_2 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire [11:0] \u_file_mapper/target_index[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(47)
  wire [11:0] \u_file_mapper/target_index[1] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(47)
  wire [31:0] \u_file_mapper/wait_count[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(73)
  wire [31:0] \u_file_mapper/wait_count[0]_b11 ;
  wire [31:0] \u_file_mapper/wait_count[0]_b9 ;
  wire [31:0] \u_file_mapper/wait_count[1] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(73)
  wire [11:0] \u_file_mapper/walk_index[0] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(48)
  wire [23:0] \u_file_mapper/walk_index[0]_b1 ;
  wire [11:0] \u_file_mapper/walk_index[1] ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(48)
  wire [0:1] \u_file_mapper/walk_initialized ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(63)
  wire [8:0] \u_file_mapper/wanted_offset ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(71)
  wire [7:0] \u_file_mapper/wav_file_data ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(25)
  wire [15:0] \u_frame_buffer/debug_memory ;  // ../user_source/hdl_source/frame_buffer_rgb888.v(34)
  wire [23:0] \u_frame_buffer/photo_read_rgb ;  // ../user_source/hdl_source/frame_buffer_rgb888.v(62)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/App_rd_addr ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(29)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/App_rd_addr_r_b4 ;
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/burst_cnt ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(66)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mux11_syn_2 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(129)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mux17_syn_2 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(136)
  wire [3:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/rd_delay ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(73)
  wire [1:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_addr_index_d0 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(62)
  wire [1:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_addr_index_d1 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(63)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_cnt ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(60)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_len ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(39)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_len_d0 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(57)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_len_d1 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(58)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_len_latch ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(59)
  wire [5:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/state_reg_syn_1 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(161)
  wire [9:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/wrusedw ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(41)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_addr_r ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(75)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_addr_r_b4 ;
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en_d0_b ;
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/active_burst_size ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(89)
  wire [18:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_2 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/burst_cnt ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(78)
  wire [1:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/jpeg_mode_sync ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(85)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/mux22_syn_2 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(149)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/mux8_syn_2 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(156)
  wire [9:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/rdusedw ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(44)
  wire  \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/sel1_syn_8 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(216)
  wire [5:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/state_reg_syn_1 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(199)
  wire [7:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add5_syn_3 ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$base_q ;  // ../user_source/hdl_source/jpeg420_word_address.v(14)
  wire [1:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$column ;  // ../user_source/hdl_source/jpeg420_word_address.v(15)
  wire [11:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$high_offset ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire [5:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$mx ;  // ../user_source/hdl_source/jpeg420_word_address.v(18)
  wire [4:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$my ;  // ../user_source/hdl_source/jpeg420_word_address.v(19)
  wire [1:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$part ;  // ../user_source/hdl_source/jpeg420_word_address.v(17)
  wire [2:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$row ;  // ../user_source/hdl_source/jpeg420_word_address.v(16)
  wire [15:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/wr_x ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(76)
  wire [1:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_addr_index_d0 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(72)
  wire [1:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_addr_index_d1 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(73)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_cnt ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(71)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_cnt_b3 ;
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len_d0 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(68)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len_d1 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(69)
  wire [20:0] \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len_latch ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(70)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/rd_addr ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(54)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/rd_to_wr_cross_inst/primary_addr_gray ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(262)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/rd_to_wr_cross_inst/primary_addr_gray_reg  /* synthesis keep=true */ ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(263)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/rd_to_wr_cross_inst/primary_addr_gray_sync ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(265)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/rd_to_wr_cross_inst/secondary_addr_o_b ;
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/rd_to_wr_cross_inst/sync_r1  /* synthesis keep=true */ ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(264)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/rdusedw ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(37)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/shift_rdaddr ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(57)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/shift_wraddr ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(58)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/wr_addr ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(53)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/wr_to_rd_cross_inst/primary_addr_gray ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(262)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/wr_to_rd_cross_inst/primary_addr_gray_reg  /* synthesis keep=true */ ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(263)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/wr_to_rd_cross_inst/primary_addr_gray_sync ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(265)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/wr_to_rd_cross_inst/secondary_addr_o_b ;
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/wr_to_rd_cross_inst/sync_r1  /* synthesis keep=true */ ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(264)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/read_buf/wrusedw ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(36)
  wire [31:0] \u_frame_buffer/u_legacy_frame_backend/read_capture_data ;  // ../user_source/hdl_source/SD/frame_read_write.v(133)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_addr ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(54)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_addr_b ;
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_addr_b1 ;
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_to_wr_cross_inst/primary_addr_gray ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(262)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_to_wr_cross_inst/primary_addr_gray_reg  /* synthesis keep=true */ ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(263)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_to_wr_cross_inst/primary_addr_gray_sync ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(265)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_to_wr_cross_inst/secondary_addr_o_b ;
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_to_wr_cross_inst/sync_r1  /* synthesis keep=true */ ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(264)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/shift_rdaddr ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(57)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/shift_wraddr ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(58)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/wr_addr ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(53)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/wr_to_rd_cross_inst/primary_addr_gray ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(262)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/wr_to_rd_cross_inst/primary_addr_gray_reg  /* synthesis keep=true */ ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(263)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/wr_to_rd_cross_inst/primary_addr_gray_sync ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(265)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/wr_to_rd_cross_inst/secondary_addr_o_b ;
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_buf/wr_to_rd_cross_inst/sync_r1  /* synthesis keep=true */ ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(264)
  wire [31:0] \u_frame_buffer/u_legacy_frame_backend/write_data ;  // ../user_source/hdl_source/SD/frame_read_write.v(81)
  wire [8:0] \u_frame_buffer/u_legacy_frame_backend/write_fifo_used ;  // ../user_source/hdl_source/SD/frame_read_write.v(97)
  wire [1:0] \u_frame_buffer/u_legacy_frame_backend/write_ready_release ;  // ../user_source/hdl_source/SD/frame_read_write.v(99)
  wire [23:0] \u_frame_buffer/u_pack/carry ;  // ../user_source/hdl_source/rgb888_word_codec.v(16)
  wire [31:0] \u_frame_buffer/u_pack/mux4_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(26)
  wire [3:0] \u_frame_buffer/u_pack/phase_reg_syn_1 ;  // ../user_source/hdl_source/rgb888_word_codec.v(18)
  wire [23:0] \u_frame_buffer/u_pack/pixel_rgb ;  // ../user_source/hdl_source/rgb888_word_codec.v(11)
  wire [31:0] \u_frame_buffer/u_pack/word_data ;  // ../user_source/hdl_source/rgb888_word_codec.v(13)
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/App_rd_addr ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/App_wr_din ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(27)
  wire [11:0] \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_init_ref_addr ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(35)
  wire [17:0] \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/pwr_200ms_cnt ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(39)
  wire [17:0] \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/pwr_200ms_cnt_b3 ;
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/sdr_init_cnt ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(43)
  wire [19:0] \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/sdr_ref_ack_sft ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(46)
  wire [10:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/SDR_ADDR_b ;
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/Sdr_rd_dout  /* synthesis keep=true */ ;
  wire [1:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/active_ba ;
  wire [7:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/active_col ;
  wire [10:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/active_row ;
  wire [10:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/addr ;
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_addr_1d ;
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_addr_2d ;
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_addr_3d ;
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_addr_4d ;
  wire [10:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_en_sft ;
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_1d ;
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_2d ;
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_3d ;
  wire [20:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_addr_4d ;
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_1d ;
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_2d ;
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_3d ;
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_4d ;
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_5d ;
  wire [31:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_6d ;
  wire [7:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_en_sft ;
  wire [1:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ba ;
  wire [1:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/cnt4 ;
  wire [7:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/mux1_syn_2 ;
  wire [1:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/mux21_syn_2 ;
  wire [10:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/mux4_syn_2 ;
  wire [2:0] \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/state_reg_syn_1 ;
  wire [3:0] \u_frame_buffer/u_unpack/byte_count ;  // ../user_source/hdl_source/rgb888_word_codec.v(73)
  wire [3:0] \u_frame_buffer/u_unpack/merged_count ;  // ../user_source/hdl_source/rgb888_word_codec.v(76)
  wire [23:0] \u_frame_buffer/u_unpack/mux8_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(115)
  wire [63:0] \u_frame_buffer/u_unpack/reservoir ;  // ../user_source/hdl_source/rgb888_word_codec.v(72)
  wire [23:0] \u_frame_buffer/u_unpack/selected_pixel ;  // ../user_source/hdl_source/rgb888_word_codec.v(78)
  wire [31:0] \u_frame_buffer/u_unpack/word_data ;  // ../user_source/hdl_source/rgb888_word_codec.v(67)
  wire [15:0] \u_frame_buffer/u_video_pack/first_pixel ;  // ../user_source/hdl_source/rgb565_word_codec.v(13)
  wire [15:0] \u_frame_buffer/u_video_pack/mux2_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(26)
  wire [31:0] \u_frame_buffer/u_video_pack/mux3_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(26)
  wire [31:0] \u_frame_buffer/u_video_pack/word_data ;  // ../user_source/hdl_source/rgb565_word_codec.v(10)
  wire [2:0] \u_frame_buffer/u_video_unpack/half_count ;  // ../user_source/hdl_source/rgb565_word_codec.v(52)
  wire [2:0] \u_frame_buffer/u_video_unpack/merged_count ;  // ../user_source/hdl_source/rgb565_word_codec.v(55)
  wire [23:0] \u_frame_buffer/u_video_unpack/mux8_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(93)
  wire [63:0] \u_frame_buffer/u_video_unpack/reservoir ;  // ../user_source/hdl_source/rgb565_word_codec.v(59)
  wire [20:0] \u_frame_buffer/u_wipe_address/cut_words ;  // ../user_source/hdl_source/player_wipe_address.v(25)
  wire [20:0] \u_frame_buffer/u_wipe_address/cut_words_b1 ;
  wire [20:0] \u_frame_buffer/u_wipe_address/new_base ;  // ../user_source/hdl_source/player_wipe_address.v(25)
  wire [1:0] \u_frame_buffer/u_wipe_address/new_s0 ;  // ../user_source/hdl_source/player_wipe_address.v(23)
  wire [1:0] \u_frame_buffer/u_wipe_address/new_s1 ;  // ../user_source/hdl_source/player_wipe_address.v(23)
  wire [20:0] \u_frame_buffer/u_wipe_address/old_base ;  // ../user_source/hdl_source/player_wipe_address.v(25)
  wire [8:0] \u_frame_buffer/u_wipe_address/rows_s0 ;  // ../user_source/hdl_source/player_wipe_address.v(22)
  wire [8:0] \u_frame_buffer/u_wipe_address/rows_s1 ;  // ../user_source/hdl_source/player_wipe_address.v(22)
  wire [23:0] \u_frame_buffer/video_read_rgb ;  // ../user_source/hdl_source/frame_buffer_rgb888.v(62)
  wire [9:0] \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_data_in ;  // ../user_source/hdl_source/lane_lvds_10_1.v(11)
  wire [1:0] \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_oddr_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(24)
  wire [9:0] \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/I_data_in ;  // ../user_source/hdl_source/lane_lvds_10_1.v(11)
  wire [1:0] \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_oddr_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(24)
  wire [9:0] \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi2phy_wrapper/u1_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/I_data_in ;  // ../user_source/hdl_source/lane_lvds_10_1.v(11)
  wire [1:0] \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_oddr_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(24)
  wire [9:0] \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi2phy_wrapper/u2_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [1:0] \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_oddr_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(24)
  wire [9:0] \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi2phy_wrapper/u3_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [19:0] \u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts ;  // ../user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v(54)
  wire [19:0] \u_hdmi_1_4b_transmitter_core_wrapper/I_acr_n ;  // ../user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v(55)
  wire [23:0] \u_hdmi_1_4b_transmitter_core_wrapper/I_axis_s_data ;  // ../user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v(40)
  wire [1:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/I_control_data ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/I_island_data ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/I_video_data ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_0_q_m_0_7 ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_0_q_m_0_7_b ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_1_D ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_1_q_m_0_7 ;
  wire [4:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1 ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_control_signal_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_control_signal_code_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_control_signal_code_2d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_control_signal_code_3d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_control_signal_code_b ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_code_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_code_2d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_code_3d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_guard_band_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_guard_band_code_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_guard_band_code_2d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_guard_band_code_3d ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_q_m ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_q_m_1d ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_q_m_comb ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_data_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_data_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_data_code_b ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_data_guard_band_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_data_guard_band_code_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_data_guard_band_code_2d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_data_guard_band_code_3d ;
  wire [2:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/add19_syn_9 ;
  wire [1:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/I_control_data ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/I_island_data ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/I_video_data ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_0_q_m_0_7 ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_0_q_m_0_7_b ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_1_D ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_1_q_m_0_7 ;
  wire [4:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1 ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_control_signal_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_control_signal_code_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_control_signal_code_2d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_control_signal_code_3d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_data_island_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_data_island_code_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_data_island_code_2d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_data_island_code_3d ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_q_m ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_q_m_1d ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_q_m_comb ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_video_data_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_video_data_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_video_data_code_b ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/add18_syn_5 ;
  wire [2:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/add19_syn_9 ;
  wire [1:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/I_control_data ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/I_island_data ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/I_video_data ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_0_q_m_0_7 ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_0_q_m_0_7_b ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_1_D ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_1_q_m_0_7 ;
  wire [4:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1 ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_control_signal_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_control_signal_code_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_control_signal_code_2d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_control_signal_code_3d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_data_island_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_data_island_code_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_data_island_code_2d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_data_island_code_3d ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_q_m ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_q_m_1d ;
  wire [8:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_q_m_comb ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_video_data_1d ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_video_data_code ;
  wire [9:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_video_data_code_b ;
  wire [2:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/add19_syn_9 ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_island_data_ch0 ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_island_data_ch1 ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_island_data_ch2 ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_video_data_ch0 ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_video_data_ch1 ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_video_data_ch2 ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_video_data_ch0 ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_video_data_ch1 ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_video_data_ch2 ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH0_D2_shift ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH1_D0_shift ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH1_D1_shift ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH1_D2_shift ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH1_D3_shift ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH2_D0_shift ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH2_D1_shift ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH2_D2_shift ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_CH2_D3_shift ;
  wire [4:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_cnt ;
  wire [4:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_cnt_b ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch0_1d ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch0_2d ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch0_3d ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch1_1d ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch1_2d ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch1_3d ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch2_1d ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch2_2d ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_data_ch2_3d ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/O_BCH_block_0 ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/O_BCH_block_1 ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/O_BCH_block_2 ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/O_BCH_block_3 ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/O_BCH_block_4 ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/O_BCH_block_4_b7 ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/S_audio_clock_regeneration_packet_BCH_block_0 ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/S_audio_sample_packet_BCH_block_0 ;
  wire [31:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/S_audio_sample_packet_BCH_block_4 ;
  wire [3:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/S_packet_cnt ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_audio_frame_cnt ;
  wire [191:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_left_audio_channel_status_shift ;
  wire [55:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body ;
  wire [23:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_header ;
  wire [191:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_right_audio_channel_status_shift ;
  wire [95:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/I_fifo_wr_data ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel1_syn_2 ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel2_syn_2 ;
  wire [63:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel3_syn_2 ;
  wire [55:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body_parity ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_video_data_ch0 ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_video_data_ch1 ;
  wire [7:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_video_data_ch2 ;
  wire [13:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_col_cnt ;
  wire [13:0] \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_line_cnt ;
  wire [6:0] \u_jpeg_core/u_jpeg_bitbuffer/count_q ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(59)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/inport_data_i ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(40)
  wire [63:0] \u_jpeg_core/u_jpeg_bitbuffer/mux19_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(80)
  wire [5:0] \u_jpeg_core/u_jpeg_bitbuffer/outport_pop_i ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(42)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/ram_q[0] ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(56)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/ram_q[1] ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(56)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/ram_q[2] ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(56)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/ram_q[3] ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(56)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/ram_q[4] ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(56)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/ram_q[5] ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(56)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/ram_q[6] ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(56)
  wire [7:0] \u_jpeg_core/u_jpeg_bitbuffer/ram_q[7] ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(56)
  wire [5:0] \u_jpeg_core/u_jpeg_bitbuffer/rd_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(57)
  wire [5:0] \u_jpeg_core/u_jpeg_bitbuffer/wr_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(58)
  wire [7:0] \u_jpeg_core/u_jpeg_dht/u_fixed_cx_ac/sel0_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_dht_std_cx_ac.v(49)
  wire [7:0] \u_jpeg_core/u_jpeg_dht/u_fixed_y_ac/sel0_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_dht_std_y_ac.v(49)
  wire [7:0] \u_jpeg_core/u_jpeg_dht/u_fixed_y_ac/sel0_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_dht_std_y_ac.v(49)
  wire [7:0] \u_jpeg_core/u_jpeg_dqt/cfg_table_addr_w ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(96)
  wire [7:0] \u_jpeg_core/u_jpeg_dqt/dqt_entry_q ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(110)
  wire [7:0] \u_jpeg_core/u_jpeg_dqt/dqt_table_addr_w ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(108)
  wire [7:0] \u_jpeg_core/u_jpeg_dqt/idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(73)
  wire [31:0] \u_jpeg_core/u_jpeg_dqt/inport_id_q ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(204)
  wire [5:0] \u_jpeg_core/u_jpeg_dqt/inport_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(203)
  wire [7:0] \u_jpeg_core/u_jpeg_dqt/mux2_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(76)
  wire [5:0] \u_jpeg_core/u_jpeg_idct/input_beat_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(47)
  wire  \u_jpeg_core/u_jpeg_idct/input_y_q_i1_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(64)
  wire [3:0] \u_jpeg_core/u_jpeg_idct/u_id_fifo/count_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(72)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_id_fifo/data_in_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(48)
  wire [3:0] \u_jpeg_core/u_jpeg_idct/u_id_fifo/ramread0_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(119)
  wire [3:0] \u_jpeg_core/u_jpeg_idct/u_id_fifo/ramread0_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(119)
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_id_fifo/rd_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(70)
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_id_fifo/wr_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(71)
  wire [1:0] \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire [3:0] \u_jpeg_core/u_jpeg_idct/u_input/block_ready_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(59)
  wire [1:0] \u_jpeg_core/u_jpeg_idct/u_input/block_wr_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(57)
  wire [3:0] \u_jpeg_core/u_jpeg_idct/u_input/clear_addr_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(63)
  wire [1:0] \u_jpeg_core/u_jpeg_idct/u_input/clear_block_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(64)
  wire [15:0] \u_jpeg_core/u_jpeg_idct/u_input/inport_data_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(40)
  wire [5:0] \u_jpeg_core/u_jpeg_idct/u_input/inport_idx_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(41)
  wire [3:0] \u_jpeg_core/u_jpeg_idct/u_input/mux26_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(178)
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_input/outport_idx_o ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(52)
  wire [3:0] \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire [5:0] \u_jpeg_core/u_jpeg_idct/u_input/rd_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(60)
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_input/state_q_reg_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(264)
  wire [30:0] \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_3 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire [30:0] \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0] ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(326)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b13 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b15 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b16 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b17 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b18 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b19 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b21 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b22 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b24 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b25 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b26 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b27 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[0]_b28 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[1] ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(326)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[2] ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(326)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[3] ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(326)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[4] ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(326)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[5] ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(326)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[6] ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(326)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out[7] ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(326)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out_tmp ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(327)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out_tmp_b4 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/block_out_tmp_b5 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/i0 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(81)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/i0_b1 ;
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_shared/inport_idx_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(54)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/mul0_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(174)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/mul1_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(175)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/mul2_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(176)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/mul3_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(177)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/mul4_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(178)
  wire [13:0] \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_90 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire [13:0] \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_90 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire [255:0] \u_jpeg_core/u_jpeg_idct/u_shared/mux35_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(342)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_105 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_106 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_130 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_131 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_155 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_156 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_180 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_181 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_205 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_206 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_230 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_231 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_255 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_256 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_280 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_281 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_305 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_306 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_31 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_330 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_331 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_355 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_356 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_380 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_381 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_405 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_406 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_430 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_431 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_455 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_456 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_480 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_481 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_505 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_506 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_530 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_531 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_55 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_56 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_80 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire  \u_jpeg_core/u_jpeg_idct/u_shared/mux44_syn_81 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(385)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_s5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(228)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_s5_b1 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_s6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(229)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_s6_b1 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_s7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(230)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t0 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(231)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t0_b3 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t0_b5 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(232)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t1_b2 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(233)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t2_b2 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t3 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(234)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t3_b1 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t3_b4 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(235)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(236)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t5_6_b2 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t5_b2 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(237)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t6_5_b2 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t6_b2 ;
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(238)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_shared/o_t7_b2 ;
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_shared/out_stg0_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(199)
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_shared/out_stg3_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(312)
  wire [5:0] \u_jpeg_core/u_jpeg_idct/u_shared/ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(374)
  wire [7:0] \u_jpeg_core/u_jpeg_idct/u_shared/valid_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(364)
  wire [1:0] \u_jpeg_core/u_jpeg_idct/u_transpose/block_ready_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(152)
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_transpose/outport_idx_o ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(51)
  wire [3:0] \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire [5:0] \u_jpeg_core/u_jpeg_idct/u_transpose/rd_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(58)
  wire [2:0] \u_jpeg_core/u_jpeg_idct/u_transpose/state_q_reg_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(225)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_transpose/u_ram0/data1_o ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose_ram.v(48)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_transpose/u_ram1/data1_o ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose_ram.v(48)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_transpose/u_ram2/data1_o ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose_ram.v(48)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/u_transpose/u_ram3/data1_o ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose_ram.v(48)
  wire [4:0] \u_jpeg_core/u_jpeg_idct/u_transpose/wr_ptr_w ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(61)
  wire [15:0] \u_jpeg_core/u_jpeg_idct/x0 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(49)
  wire [15:0] \u_jpeg_core/u_jpeg_idct/x1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(49)
  wire [15:0] \u_jpeg_core/u_jpeg_idct/x2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(49)
  wire [15:0] \u_jpeg_core/u_jpeg_idct/x3 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(49)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/y0 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(50)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/y1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(50)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/y2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(50)
  wire [31:0] \u_jpeg_core/u_jpeg_idct/y3 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(50)
  wire [1:0] \u_jpeg_core/u_jpeg_input/byte_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(73)
  wire [7:0] \u_jpeg_core/u_jpeg_input/dht_cfg_data_o ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(59)
  wire [5:0] \u_jpeg_core/u_jpeg_input/idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(382)
  wire [1:0] \u_jpeg_core/u_jpeg_input/img_dqt_table_cb_o ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(53)
  wire [1:0] \u_jpeg_core/u_jpeg_input/img_dqt_table_cr_o ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(54)
  wire [1:0] \u_jpeg_core/u_jpeg_input/img_dqt_table_y_o ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(52)
  wire [7:0] \u_jpeg_core/u_jpeg_input/last_b_q ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(103)
  wire [15:0] \u_jpeg_core/u_jpeg_input/length_q ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(153)
  wire [15:0] \u_jpeg_core/u_jpeg_input/length_q_b5 ;
  wire [17:0] \u_jpeg_core/u_jpeg_input/mux10_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(160)
  wire [15:0] \u_jpeg_core/u_jpeg_input/mux15_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(309)
  wire [1:0] \u_jpeg_core/u_jpeg_input/mux9_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(76)
  wire [17:0] \u_jpeg_core/u_jpeg_input/state_q_reg_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(297)
  wire [7:0] \u_jpeg_core/u_jpeg_input/sub0_syn_3 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(316)
  wire [7:0] \u_jpeg_core/u_jpeg_mcu_proc/code_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(191)
  wire [4:0] \u_jpeg_core/u_jpeg_mcu_proc/coef_bits_w ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(238)
  wire [7:0] \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(123)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/coeff_r ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/coeff_r_b1 ;
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/coeff_r_b5 ;
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/coeff_r_b6 ;
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/coeff_r_b7 ;
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/dc_coeff_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(310)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/input_data_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(222)
  wire [4:0] \u_jpeg_core/u_jpeg_mcu_proc/input_shift_w_b1 ;
  wire [7:0] \u_jpeg_core/u_jpeg_mcu_proc/lookup_value_i ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(47)
  wire [4:0] \u_jpeg_core/u_jpeg_mcu_proc/lookup_width_i ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(46)
  wire [4:0] \u_jpeg_core/u_jpeg_mcu_proc/lookup_width_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(211)
  wire [7:0] \u_jpeg_core/u_jpeg_mcu_proc/mux23_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(371)
  wire [7:0] \u_jpeg_core/u_jpeg_mcu_proc/mux25_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(367)
  wire [63:0] \u_jpeg_core/u_jpeg_mcu_proc/mux7_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(327)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/outport_data_o ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(56)
  wire [5:0] \u_jpeg_core/u_jpeg_mcu_proc/outport_idx_o ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(57)
  wire [5:0] \u_jpeg_core/u_jpeg_mcu_proc/pop_bits_r_b3 ;
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/prev_dc_coeff_q[0] ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(309)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/prev_dc_coeff_q[1] ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(309)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/prev_dc_coeff_q[2] ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(309)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/prev_dc_coeff_q[3] ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(309)
  wire [5:0] \u_jpeg_core/u_jpeg_mcu_proc/state_q_reg_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(172)
  wire [31:0] \u_jpeg_core/u_jpeg_mcu_proc/u_id/block_id_o ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(46)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire [14:0] \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux7_syn_3 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(160)
  wire [2:0] \u_jpeg_core/u_jpeg_mcu_proc/u_id/type_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(67)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/u_id/x_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(123)
  wire [15:0] \u_jpeg_core/u_jpeg_mcu_proc/u_id/y_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(124)
  wire [16:0] \u_jpeg_core/u_jpeg_output/add4_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire [15:0] \u_jpeg_core/u_jpeg_output/add4_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire [10:0] \u_jpeg_core/u_jpeg_output/add4_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire [22:0] \u_jpeg_core/u_jpeg_output/add4_syn_52 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire [18:0] \u_jpeg_core/u_jpeg_output/add5_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire [16:0] \u_jpeg_core/u_jpeg_output/add5_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire [31:0] \u_jpeg_core/u_jpeg_output/cb_value_w ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(103)
  wire [31:0] \u_jpeg_core/u_jpeg_output/color_s1_cb_0344_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(220)
  wire [31:0] \u_jpeg_core/u_jpeg_output/color_s1_cb_1772_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(221)
  wire [31:0] \u_jpeg_core/u_jpeg_output/color_s1_cr_0714_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(219)
  wire [31:0] \u_jpeg_core/u_jpeg_output/color_s1_cr_1402_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(218)
  wire [31:0] \u_jpeg_core/u_jpeg_output/color_s1_y_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(217)
  wire [31:0] \u_jpeg_core/u_jpeg_output/color_s2_b_w_b1 ;
  wire [24:0] \u_jpeg_core/u_jpeg_output/color_s2_b_w_b2 ;
  wire [31:0] \u_jpeg_core/u_jpeg_output/color_s2_g_w_b1 ;
  wire [31:0] \u_jpeg_core/u_jpeg_output/color_s2_r_w_b1 ;
  wire [31:0] \u_jpeg_core/u_jpeg_output/cr_value_w ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(130)
  wire [5:0] \u_jpeg_core/u_jpeg_output/idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(186)
  wire [31:0] \u_jpeg_core/u_jpeg_output/inport_id_i ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(45)
  wire [31:0] \u_jpeg_core/u_jpeg_output/mux28_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(276)
  wire [7:0] \u_jpeg_core/u_jpeg_output/outport_pixel_b_o ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(57)
  wire [7:0] \u_jpeg_core/u_jpeg_output/outport_pixel_g_o ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(56)
  wire [7:0] \u_jpeg_core/u_jpeg_output/outport_pixel_r_o ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(55)
  wire [18:0] \u_jpeg_core/u_jpeg_output/sub4_syn_3 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire [1:0] \u_jpeg_core/u_jpeg_output/subsmpl_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(199)
  wire [3:0] \u_jpeg_core/u_jpeg_output/u_info/count_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(72)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_49 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_51 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_53 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_55 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_57 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_59 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_61 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_63 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire  \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_91 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire [2:0] \u_jpeg_core/u_jpeg_output/u_info/rd_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(70)
  wire [2:0] \u_jpeg_core/u_jpeg_output/u_info/wr_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(71)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/count_r ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(460)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/count_r_b ;
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(373)
  wire [7:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(99)
  wire [7:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_idx_q_b4 ;
  wire [5:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_rd_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/data_out_w ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(429)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/level_o ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(47)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/mux22_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(400)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/rd_skid_data_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(397)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/u_ram/data1_o ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(504)
  wire [7:0] \u_jpeg_core/u_jpeg_output/u_ram_cb/wr_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(56)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/count_r ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(460)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/count_r_b ;
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_half_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(373)
  wire [7:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_idx_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(99)
  wire [7:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_idx_q_b4 ;
  wire [5:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_rd_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/data_out_w ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(429)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/level_o ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(47)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/mux22_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(400)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/rd_skid_data_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(397)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/u_ram/data1_o ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(504)
  wire [7:0] \u_jpeg_core/u_jpeg_output/u_ram_cr/wr_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(56)
  wire [1:0] \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_3 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_y/count_r_b1 ;
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_y/data_out_w ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(133)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_y/mux7_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(104)
  wire [8:0] \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_y/rd_skid_data_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(101)
  wire [31:0] \u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/data1_o ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(208)
  wire [8:0] \u_jpeg_core/u_jpeg_output/u_ram_y/wr_ptr_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(55)
  wire [31:0] \u_jpeg_core/u_jpeg_output/y_level_w ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(79)
  wire [2:0] \u_osd/image_count ;  // ../user_source/hdl_source/player_osd.v(8)
  wire  \u_osd/mux0_syn_14 ;  // ../user_source/hdl_source/player_osd.v(254)
  wire [1:0] \u_osd_state/ack_sync_sd ;  // ../user_source/hdl_source/player_osd_state.v(26)
  wire [1:0] \u_osd_state/frame_buffer ;  // ../user_source/hdl_source/player_osd_state.v(15)
  wire [1:0] \u_osd_state/frame_image ;  // ../user_source/hdl_source/player_osd_state.v(15)
  wire [8:0] \u_osd_state/held_sd ;  // ../user_source/hdl_source/player_osd_state.v(24)
  wire [8:0] \u_osd_state/latest_pixel ;  // ../user_source/hdl_source/player_osd_state.v(27)
  wire [8:0] \u_osd_state/mux27_syn_2 ;  // ../user_source/hdl_source/player_osd_state.v(69)
  wire [1:0] \u_osd_state/read_ack_sync ;  // ../user_source/hdl_source/player_osd_state.v(28)
  wire [1:0] \u_osd_state/req_sync_pixel ;  // ../user_source/hdl_source/player_osd_state.v(26)
  wire [8:0] \u_osd_state/target_pixel ;  // ../user_source/hdl_source/player_osd_state.v(27)
  wire [1:0] \u_osd_state/wipe_new_buffer ;  // ../user_source/hdl_source/player_osd_state.v(20)
  wire [8:0] \u_osd_state/wipe_rows ;  // ../user_source/hdl_source/player_osd_state.v(19)
  wire [34:0] \u_pcm_waveform/legend_on_b2 ;
  wire [9:0] \u_pcm_waveform/legend_on_b3 ;
  wire [21:0] \u_pcm_waveform/mux25_syn_2 ;  // ../user_source/hdl_source/player_pcm_waveform.v(121)
  wire [4:0] \u_pcm_waveform/mux35_syn_2 ;  // ../user_source/hdl_source/player_pcm_waveform.v(128)
  wire [6:0] \u_pcm_waveform/next_height ;  // ../user_source/hdl_source/player_pcm_waveform.v(70)
  wire [3:0] \u_pcm_waveform/next_hold_b ;
  wire [6:0] \u_pcm_waveform/next_peak ;  // ../user_source/hdl_source/player_pcm_waveform.v(70)
  wire [5:0] \u_pcm_waveform/next_peak_b6 ;
  wire [4:0] \u_pcm_waveform/render_col_next ;  // ../user_source/hdl_source/player_pcm_waveform.v(225)
  wire [31:0] \u_pcm_waveform/rgb_out_b11 ;
  wire [34:0] \u_pcm_waveform/rgb_out_b16 ;
  wire [3:0] \u_pcm_waveform/rgb_out_b17 ;
  wire [23:0] \u_pcm_waveform/rgb_out_b2 ;
  wire [23:0] \u_pcm_waveform/rgb_out_b5 ;
  wire [23:0] \u_pcm_waveform/spectrum_debug_data ;  // ../user_source/hdl_source/player_pcm_waveform.v(12)
  wire [21:0] \u_pcm_waveform/stale_count ;  // ../user_source/hdl_source/player_pcm_waveform.v(102)
  wire [21:0] \u_pcm_waveform/stale_count_b5 ;
  wire [17:0] \u_pcm_waveform/state_q ;  // ../user_source/hdl_source/player_pcm_waveform.v(63)
  wire [17:0] \u_pcm_waveform/state_write_data ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire [2:0] \u_pcm_waveform/sub1_syn_3 ;  // ../user_source/hdl_source/player_pcm_waveform.v(45)
  wire [6:0] \u_pcm_waveform/target_mem_b ;
  wire [35:0] \u_pcm_waveform/target_mem_b6 ;
  wire [6:0] \u_pcm_waveform/target_q ;  // ../user_source/hdl_source/player_pcm_waveform.v(53)
  wire [4:0] \u_pcm_waveform/u_spectrum/band_index ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(16)
  wire [15:0] \u_pcm_waveform/u_spectrum/band_max ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(49)
  wire [15:0] \u_pcm_waveform/u_spectrum/band_max_b14 ;
  wire [15:0] \u_pcm_waveform/u_spectrum/band_max_b17 ;
  wire [15:0] \u_pcm_waveform/u_spectrum/band_value ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(17)
  wire [8:0] \u_pcm_waveform/u_spectrum/butterfly ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(46)
  wire [7:0] \u_pcm_waveform/u_spectrum/debug_control ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(21)
  wire [23:0] \u_pcm_waveform/u_spectrum/debug_progress ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(20)
  wire [16:0] \u_pcm_waveform/u_spectrum/diff_im_b5 ;
  wire [16:0] \u_pcm_waveform/u_spectrum/diff_re_b5 ;
  wire [4:0] \u_pcm_waveform/u_spectrum/emit_index ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(51)
  wire [15:0] \u_pcm_waveform/u_spectrum/emit_value ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(50)
  wire [15:0] \u_pcm_waveform/u_spectrum/fft_out_ai ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(219)
  wire [15:0] \u_pcm_waveform/u_spectrum/fft_out_ai_b3 ;
  wire [15:0] \u_pcm_waveform/u_spectrum/fft_out_ar ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(219)
  wire [15:0] \u_pcm_waveform/u_spectrum/fft_out_ar_b3 ;
  wire [15:0] \u_pcm_waveform/u_spectrum/fft_out_bi ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(219)
  wire [15:0] \u_pcm_waveform/u_spectrum/fft_out_bi_b3 ;
  wire [15:0] \u_pcm_waveform/u_spectrum/fft_out_br ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(219)
  wire [15:0] \u_pcm_waveform/u_spectrum/fft_out_br_b3 ;
  wire [3:0] \u_pcm_waveform/u_spectrum/fft_stage ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(45)
  wire [11:0] \u_pcm_waveform/u_spectrum/frame_age_samples ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(61)
  wire [15:0] \u_pcm_waveform/u_spectrum/hann_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(98)
  wire [15:0] \u_pcm_waveform/u_spectrum/imag_a_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(108)
  wire [15:0] \u_pcm_waveform/u_spectrum/imag_b_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(108)
  wire [15:0] \u_pcm_waveform/u_spectrum/lt1_syn_48 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(180)
  wire [32:0] \u_pcm_waveform/u_spectrum/mul_product ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(209)
  wire [8:0] \u_pcm_waveform/u_spectrum/mux101_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [9:0] \u_pcm_waveform/u_spectrum/mux102_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [4:0] \u_pcm_waveform/u_spectrum/mux106_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [4:0] \u_pcm_waveform/u_spectrum/mux107_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [16:0] \u_pcm_waveform/u_spectrum/mux109_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [31:0] \u_pcm_waveform/u_spectrum/mux111_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [15:0] \u_pcm_waveform/u_spectrum/mux122_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [31:0] \u_pcm_waveform/u_spectrum/mux126_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [31:0] \u_pcm_waveform/u_spectrum/mux127_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [31:0] \u_pcm_waveform/u_spectrum/mux128_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [31:0] \u_pcm_waveform/u_spectrum/mux129_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire [15:0] \u_pcm_waveform/u_spectrum/mux140_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire [31:0] \u_pcm_waveform/u_spectrum/mux144_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire [31:0] \u_pcm_waveform/u_spectrum/mux145_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire [31:0] \u_pcm_waveform/u_spectrum/mux146_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire  \u_pcm_waveform/u_spectrum/mux1_syn_66 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(333)
  wire [11:0] \u_pcm_waveform/u_spectrum/mux32_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(78)
  wire  \u_pcm_waveform/u_spectrum/mux68_syn_539 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(333)
  wire  \u_pcm_waveform/u_spectrum/mux70_syn_1251 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(333)
  wire [16:0] \u_pcm_waveform/u_spectrum/mux97_syn_1 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [9:0] \u_pcm_waveform/u_spectrum/mux98_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [9:0] \u_pcm_waveform/u_spectrum/mux99_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire [31:0] \u_pcm_waveform/u_spectrum/p0 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(213)
  wire [31:0] \u_pcm_waveform/u_spectrum/p0_b2 ;
  wire [31:0] \u_pcm_waveform/u_spectrum/p1 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(213)
  wire [31:0] \u_pcm_waveform/u_spectrum/p2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(213)
  wire [31:0] \u_pcm_waveform/u_spectrum/p3 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(213)
  wire [31:0] \u_pcm_waveform/u_spectrum/p3_b2 ;
  wire [15:0] \u_pcm_waveform/u_spectrum/real_a_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(108)
  wire [9:0] \u_pcm_waveform/u_spectrum/real_a_read_addr ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(261)
  wire [15:0] \u_pcm_waveform/u_spectrum/real_b_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(108)
  wire [1:0] \u_pcm_waveform/u_spectrum/reset_pipe  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(55)
  wire [15:0] \u_pcm_waveform/u_spectrum/sample_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(97)
  wire [4:0] \u_pcm_waveform/u_spectrum/scan_band ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(48)
  wire [9:0] \u_pcm_waveform/u_spectrum/scan_bin ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(47)
  wire [16:0] \u_pcm_waveform/u_spectrum/state_reg_syn_1 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire [15:0] \u_pcm_waveform/u_spectrum/tw_im_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(215)
  wire [16:0] \u_pcm_waveform/u_spectrum/tw_re_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(214)
  wire [31:0] \u_pcm_waveform/u_spectrum/twiddle_q ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(99)
  wire [9:0] \u_pcm_waveform/u_spectrum/win_index ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(44)
  wire [9:0] \u_pcm_waveform/u_spectrum/work_ram_write_addr ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire [15:0] \u_pcm_waveform/u_spectrum/work_ram_write_imag ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(275)
  wire [15:0] \u_pcm_waveform/u_spectrum/work_ram_write_real ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(272)
  wire [4:0] \u_pcm_waveform/update_index ;  // ../user_source/hdl_source/player_pcm_waveform.v(66)
  wire [4:0] \u_pcm_waveform/update_state_reg_syn_1 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire [13:0] \u_pcm_waveform/wave_q ;  // ../user_source/hdl_source/player_pcm_waveform.v(57)
  wire [4:0] \u_rgb_adjust/add1_syn_5 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire [4:0] \u_rgb_adjust/add2_syn_3 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire [4:0] \u_rgb_adjust/add5_syn_5 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire [3:0] \u_rgb_adjust/brightness ;  // ../user_source/hdl_source/player_rgb_adjust.v(8)
  wire [23:0] \u_rgb_adjust/rgb_in ;  // ../user_source/hdl_source/player_rgb_adjust.v(2)
  wire [9:0] \u_rgb_adjust/rgb_out_b15 ;
  wire [9:0] \u_rgb_adjust/rgb_out_b16 ;
  wire [9:0] \u_rgb_adjust/rgb_out_b27 ;
  wire [9:0] \u_rgb_adjust/rgb_out_b28 ;
  wire [9:0] \u_rgb_adjust/rgb_out_b3 ;
  wire [9:0] \u_rgb_adjust/rgb_out_b4 ;
  wire [3:0] \u_rgb_adjust/sub0_syn_3 ;  // ../user_source/hdl_source/player_rgb_adjust.v(11)
  wire [15:0] \u_shared_card/sd_card_cmd_m0/byte_cnt ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(51)
  wire [15:0] \u_shared_card/sd_card_cmd_m0/clk_div ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(21)
  wire  \u_shared_card/sd_card_cmd_m0/mux2_syn_3 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire  \u_shared_card/sd_card_cmd_m0/mux31_syn_210 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire [7:0] \u_shared_card/sd_card_cmd_m0/mux32_syn_3 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire  \u_shared_card/sd_card_cmd_m0/mux33_syn_2046 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire [15:0] \u_shared_card/sd_card_cmd_m0/mux33_syn_3 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire [7:0] \u_shared_card/sd_card_cmd_m0/spi_data_in ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(24)
  wire [7:0] \u_shared_card/sd_card_cmd_m0/spi_data_out ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(25)
  wire [17:0] \u_shared_card/sd_card_cmd_m0/state_reg_syn_1 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire [47:0] \u_shared_card/sd_card_sec_read_write_m0/cmd ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(27)
  wire [47:0] \u_shared_card/sd_card_sec_read_write_m0/cmd_b ;
  wire [15:0] \u_shared_card/sd_card_sec_read_write_m0/cmd_data_len ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(29)
  wire [7:0] \u_shared_card/sd_card_sec_read_write_m0/cmd_r1 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(28)
  wire [31:0] \u_shared_card/sd_card_sec_read_write_m0/sec_addr ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(59)
  wire  \u_shared_card/sd_card_sec_read_write_m0/sel0_syn_11 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire [9:0] \u_shared_card/sd_card_sec_read_write_m0/sel2_syn_13 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire  \u_shared_card/sd_card_sec_read_write_m0/sel2_syn_667 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire [15:0] \u_shared_card/sd_card_sec_read_write_m0/sel4_syn_2 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire [15:0] \u_shared_card/sd_card_sec_read_write_m0/spi_clk_div ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(23)
  wire [9:0] \u_shared_card/sd_card_sec_read_write_m0/state_reg_syn_1 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(69)
  wire [7:0] \u_shared_card/spi_master_m0/MOSI_shift ;  // ../user_source/hdl_source/SD/spi_master.v(27)
  wire [7:0] \u_shared_card/spi_master_m0/MOSI_shift_b ;
  wire [15:0] \u_shared_card/spi_master_m0/clk_cnt ;  // ../user_source/hdl_source/SD/spi_master.v(32)
  wire [4:0] \u_shared_card/spi_master_m0/clk_edge_cnt ;  // ../user_source/hdl_source/SD/spi_master.v(33)
  wire [7:0] \u_shared_card/spi_master_m0/mux13_syn_2 ;  // ../user_source/hdl_source/SD/spi_master.v(118)
  wire [7:0] \u_shared_card/spi_master_m0/mux2_syn_2 ;  // ../user_source/hdl_source/SD/spi_master.v(131)
  wire [4:0] \u_shared_card/spi_master_m0/mux9_syn_2 ;  // ../user_source/hdl_source/SD/spi_master.v(108)
  wire [5:0] \u_shared_card/spi_master_m0/state_reg_syn_1 ;  // ../user_source/hdl_source/SD/spi_master.v(41)
  wire [4:0] \u_status_hex/bit_count ;  // ../user_source/hdl_source/status_hex595.v(35)
  wire [2:0] \u_status_hex/digit_index ;  // ../user_source/hdl_source/status_hex595.v(36)
  wire [31:0] \u_status_hex/frame_value ;  // ../user_source/hdl_source/status_hex595.v(33)
  wire [31:0] \u_status_hex/half_count ;  // ../user_source/hdl_source/status_hex595.v(32)
  wire [31:0] \u_status_hex/hex_value ;  // ../user_source/hdl_source/status_hex595.v(12)
  wire [15:0] \u_status_hex/shift_word ;  // ../user_source/hdl_source/status_hex595.v(34)
  wire [31:0] \u_status_hex/slot_count ;  // ../user_source/hdl_source/status_hex595.v(31)
  wire [5:0] \u_status_hex/state_reg_syn_1 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire [1:0] \u_video_keys/auto_req_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/tf_bmp_file_player.v(266)
  wire [1:0] \u_video_keys/next_req_sync  /* synthesis async_reg=true */ ;  // ../user_source/hdl_source/tf_bmp_file_player.v(265)
  wire [31:0] \u_video_reader/card_addr ;  // ../user_source/hdl_source/mjp_file_reader.v(8)
  wire  \u_video_reader/file_ready_i_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [8:0] \u_video_reader/frame_index ;  // ../user_source/hdl_source/mjp_file_reader.v(17)
  wire [31:0] \u_video_reader/header_frame_index ;  // ../user_source/hdl_source/mjp_file_reader.v(44)
  wire [31:0] \u_video_reader/header_jpeg_length ;  // ../user_source/hdl_source/mjp_file_reader.v(45)
  wire [31:0] \u_video_reader/jpeg_data ;  // ../user_source/hdl_source/mjp_file_reader.v(21)
  wire [3:0] \u_video_reader/jpeg_strb ;  // ../user_source/hdl_source/mjp_file_reader.v(22)
  wire [3:0] \u_video_reader/jpeg_strb_b3 ;
  wire [8:0] \u_video_reader/last_index ;  // ../user_source/hdl_source/mjp_file_reader.v(15)
  wire [31:0] \u_video_reader/mux100_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [31:0] \u_video_reader/mux101_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [8:0] \u_video_reader/mux102_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [8:0] \u_video_reader/mux106_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [31:0] \u_video_reader/mux107_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [1:0] \u_video_reader/mux108_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [3:0] \u_video_reader/mux112_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [6:0] \u_video_reader/mux94_syn_1 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [31:0] \u_video_reader/mux95_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [9:0] \u_video_reader/mux96_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [31:0] \u_video_reader/mux97_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [31:0] \u_video_reader/mux99_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire [31:0] \u_video_reader/payload_remaining ;  // ../user_source/hdl_source/mjp_file_reader.v(46)
  wire [31:0] \u_video_reader/payload_remaining_b7 ;
  wire [31:0] \u_video_reader/sector_cursor ;  // ../user_source/hdl_source/mjp_file_reader.v(42)
  wire [31:0] \u_video_reader/sector_cursor_b6 ;
  wire [7:0] \u_video_reader/sector_q ;  // ../user_source/hdl_source/mjp_file_reader.v(53)
  wire [8:0] \u_video_reader/sector_read_index ;  // ../user_source/hdl_source/mjp_file_reader.v(41)
  wire [9:0] \u_video_reader/sector_write_count ;  // ../user_source/hdl_source/mjp_file_reader.v(40)
  wire  \u_video_reader/sel14_syn_54 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_122 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_175 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_228 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_281 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_334 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_387 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_440 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_493 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_597 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel19_syn_649 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel1_syn_12 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire  \u_video_reader/sel3_syn_9 ;  // ../user_source/hdl_source/mjp_file_reader.v(123)
  wire [6:0] \u_video_reader/state_reg_syn_1 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire [31:0] \u_video_reader/total_frames ;  // ../user_source/hdl_source/mjp_file_reader.v(43)
  wire [31:0] \u_video_reader/word_accum ;  // ../user_source/hdl_source/mjp_file_reader.v(48)
  wire [1:0] \u_video_reader/word_fill ;  // ../user_source/hdl_source/mjp_file_reader.v(49)
  wire [1:0] \u_video_schedule/display_buffer ;  // ../user_source/hdl_source/player_video_schedule.v(13)
  wire [2:0] \u_video_schedule/display_sync ;  // ../user_source/hdl_source/player_video_schedule.v(23)
  wire [3:0] \u_video_schedule/gap ;  // ../user_source/hdl_source/player_video_schedule.v(22)
  wire [11:0] \u_video_schedule/sample_in_frame ;  // ../user_source/hdl_source/player_video_schedule.v(25)
  wire [6:0] \u_video_schedule/state_reg_syn_1 ;  // ../user_source/hdl_source/player_video_schedule.v(31)
  wire [1:0] \u_video_schedule/write_buffer ;  // ../user_source/hdl_source/player_video_schedule.v(13)
  wire [2:0] \u_video_schedule/write_sync ;  // ../user_source/hdl_source/player_video_schedule.v(23)
  wire [1:0] \u_wav_player/add3_syn_5 ;  // ../user_source/hdl_source/tf_wav_file_player.v(89)
  wire [31:0] \u_wav_player/chunk_id ;  // ../user_source/hdl_source/tf_wav_file_player.v(53)
  wire [31:0] \u_wav_player/chunk_id_b16 ;
  wire [31:0] \u_wav_player/chunk_id_b18 ;
  wire [31:0] \u_wav_player/chunk_id_b19 ;
  wire [31:0] \u_wav_player/chunk_id_b20 ;
  wire [31:0] \u_wav_player/chunk_next ;  // ../user_source/hdl_source/tf_wav_file_player.v(54)
  wire [31:0] \u_wav_player/chunk_next_b7 ;
  wire [31:0] \u_wav_player/data_end ;  // ../user_source/hdl_source/tf_wav_file_player.v(58)
  wire [31:0] \u_wav_player/data_offset_b1 ;
  wire [31:0] \u_wav_player/debug_data_offset ;  // ../user_source/hdl_source/tf_wav_file_player.v(19)
  wire [12:0] \u_wav_player/debug_fifo_level ;  // ../user_source/hdl_source/tf_wav_file_player.v(17)
  wire [15:0] \u_wav_player/debug_push_data ;  // ../user_source/hdl_source/tf_wav_file_player.v(18)
  wire [31:0] \u_wav_player/debug_push_pos ;  // ../user_source/hdl_source/tf_wav_file_player.v(19)
  wire [7:0] \u_wav_player/debug_scan_byte ;  // ../user_source/hdl_source/tf_wav_file_player.v(16)
  wire [31:0] \u_wav_player/debug_scan_pos ;  // ../user_source/hdl_source/tf_wav_file_player.v(16)
  wire [31:0] \u_wav_player/field_acc ;  // ../user_source/hdl_source/tf_wav_file_player.v(52)
  wire [2:0] \u_wav_player/field_index ;  // ../user_source/hdl_source/tf_wav_file_player.v(51)
  wire [15:0] \u_wav_player/fifo_bypass_word ;  // ../user_source/hdl_source/tf_wav_file_player.v(77)
  wire [12:0] \u_wav_player/fifo_next_count ;  // ../user_source/hdl_source/tf_wav_file_player.v(89)
  wire [15:0] \u_wav_player/fifo_ram_q ;  // ../user_source/hdl_source/tf_wav_file_player.v(77)
  wire [4:0] \u_wav_player/fmt_index ;  // ../user_source/hdl_source/tf_wav_file_player.v(55)
  wire [31:0] \u_wav_player/loaded_sector ;  // ../user_source/hdl_source/tf_wav_file_player.v(40)
  wire [29:0] \u_wav_player/lt16_syn_4 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire [31:0] \u_wav_player/lt9_syn_105 ;  // ../user_source/hdl_source/tf_wav_file_player.v(205)
  wire  \u_wav_player/mux0_syn_43 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire [15:0] \u_wav_player/mux12_syn_2 ;  // ../user_source/hdl_source/tf_wav_file_player.v(149)
  wire  \u_wav_player/mux156_syn_437 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux156_syn_90 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire [9:0] \u_wav_player/mux158_syn_3 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire [31:0] \u_wav_player/mux160_syn_3 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux161_syn_783 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire [31:0] \u_wav_player/mux162_syn_3 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux164_syn_2989 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux165_syn_1005 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux165_syn_829 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux165_syn_917 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux166_syn_2989 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux168_syn_237 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux168_syn_412 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire [3:0] \u_wav_player/mux168_syn_8 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux170_syn_2989 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire [31:0] \u_wav_player/mux172_syn_3 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux173_syn_2900 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux174_syn_505 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire  \u_wav_player/mux178_syn_2273 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire [12:0] \u_wav_player/mux179_syn_1 ;  // ../user_source/hdl_source/tf_wav_file_player.v(371)
  wire [12:0] \u_wav_player/mux179_syn_16 ;  // ../user_source/hdl_source/tf_wav_file_player.v(371)
  wire [22:0] \u_wav_player/neq5_syn_27 ;  // ../user_source/hdl_source/tf_wav_file_player.v(219)
  wire [31:0] \u_wav_player/play_pos_b12 ;
  wire [12:0] \u_wav_player/prime_target ;  // ../user_source/hdl_source/tf_wav_file_player.v(97)
  wire [10:0] \u_wav_player/rd_ptr ;  // ../user_source/hdl_source/tf_wav_file_player.v(75)
  wire [10:0] \u_wav_player/rd_ptr_b1 ;
  wire [10:0] \u_wav_player/rd_ptr_b3 ;
  wire [31:0] \u_wav_player/riff_end ;  // ../user_source/hdl_source/tf_wav_file_player.v(42)
  wire [31:0] \u_wav_player/riff_end_b7 ;
  wire [23:0] \u_wav_player/riff_size_lo ;  // ../user_source/hdl_source/tf_wav_file_player.v(61)
  wire [23:0] \u_wav_player/riff_size_lo_b1 ;
  wire [3:0] \u_wav_player/scan_phase_reg_syn_1 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire [31:0] \u_wav_player/scan_pos ;  // ../user_source/hdl_source/tf_wav_file_player.v(42)
  wire [31:0] \u_wav_player/scan_pos_b7 ;
  wire [31:0] \u_wav_player/sd_addr ;  // ../user_source/hdl_source/tf_wav_file_player.v(11)
  wire [9:0] \u_wav_player/sector_write_count ;  // ../user_source/hdl_source/tf_wav_file_player.v(39)
  wire [12:0] \u_wav_player/state_reg_syn_1 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire [31:0] \u_wav_player/wait_count ;  // ../user_source/hdl_source/tf_wav_file_player.v(63)
  wire [31:0] \u_wav_player/wait_count_b8 ;
  wire [10:0] \u_wav_player/wr_ptr ;  // ../user_source/hdl_source/tf_wav_file_player.v(75)
  wire [20:0] \video_delay_m0/de_d ;  // ../user_source/hdl_source/SD/video_delay.v(22)
  wire [20:0] \video_delay_m0/vs_d ;  // ../user_source/hdl_source/SD/video_delay.v(21)
  wire [1:0] video_mode_sd_sync;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(156)
  wire [1:0] video_restart_sync;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(157)
  wire [11:0] \video_timing_data_m0/color_bar_m0/h_cnt ;  // ../user_source/hdl_source/SD/color_bar.v(141)
  wire [11:0] \video_timing_data_m0/color_bar_m0/v_cnt ;  // ../user_source/hdl_source/SD/color_bar.v(142)
  wire [23:0] vout_data_raw;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(42)
  wire al_2470;
  wire al_2478;
  wire al_2486;
  wire al_2682;
  wire al_2685;
  wire al_2689;
  wire al_2698;
  wire al_2701;
  wire al_2709;
  wire add0_syn_102;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_104;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_106;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_108;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_110;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_112;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_114;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_116;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_118;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire add0_syn_120;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(140)
  wire media_reset_active_reg_syn_3;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(165)
  wire rst_all_reg_reg_syn_3;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(130)
  wire rst_all_reg_reg_syn_6;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(130)
  wire rst_all_reg_reg_syn_8;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(130)
  wire audio_valid;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(104)
  wire audio_valid_dup_51;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(104)
  wire audio_valid_dup_54;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(104)
  wire clk_dup_1;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(3)
  wire de;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(40)
  wire frame_write_toggle_mem;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(64)
  wire fs_addr_n2;
  wire hdmi_5x_clk_raw;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(33)
  wire key1_dup_1;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(5)
  wire key2_dup_1;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(6)
  wire \led[3]_dup_1 ;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(8)
  wire \led[2]_dup_1 ;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(8)
  wire \led[1]_dup_1 ;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(8)
  wire media_reset_active;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(154)
  wire media_reset_active_dup_1;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(154)
  wire media_reset_active_dup_3;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(154)
  wire media_reset_active_dup_4;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(154)
  wire media_reset_active_dup_6;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(154)
  wire photo_write_en;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(234)
  wire rst_all_reg_n1;
  wire rst_n_dup_1;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(4)
  wire sd_dclk_dup_3;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(19)
  wire sd_miso_dup_1;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(21)
  wire sd_mosi_dup_3;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(20)
  wire sys_pll_lock;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(123)
  wire video_auto_press;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(160)
  wire video_card_read;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(241)
  wire video_mode_press;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(152)
  wire video_next_press;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(160)
  wire video_paused;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(254)
  wire video_pll_lock;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(124)
  wire video_restart_seen;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(158)
  wire video_restart_toggle;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(159)
  wire vs;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(39)
  wire \sys_pll_m0/clk0_buf ;  // ../user_source/hdl_source/ip/sys_pll.v(40)
  wire \u_adjust_control/add0_syn_132 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_134 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_136 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_138 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_140 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_142 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_144 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_146 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_148 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_150 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_152 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_154 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add0_syn_156 ;  // ../user_source/hdl_source/player_adjust_control.v(183)
  wire \u_adjust_control/add1_syn_132 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_134 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_136 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_138 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_140 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_142 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_144 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_146 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_148 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_150 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_152 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_154 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add1_syn_156 ;  // ../user_source/hdl_source/player_adjust_control.v(232)
  wire \u_adjust_control/add2_syn_132 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_134 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_136 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_138 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_140 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_142 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_144 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_146 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_148 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_150 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_152 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_154 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add2_syn_156 ;  // ../user_source/hdl_source/player_adjust_control.v(245)
  wire \u_adjust_control/add3_syn_97 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add3_syn_99 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add3_syn_101 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add3_syn_103 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add3_syn_105 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add3_syn_107 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add3_syn_109 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add3_syn_111 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add3_syn_113 ;  // ../user_source/hdl_source/player_adjust_control.v(90)
  wire \u_adjust_control/add6_syn_97 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/add6_syn_99 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/add6_syn_101 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/add6_syn_103 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/add6_syn_105 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/add6_syn_107 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/add6_syn_109 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/add6_syn_111 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/add6_syn_113 ;  // ../user_source/hdl_source/player_adjust_control.v(99)
  wire \u_adjust_control/lt0_syn_190 ;  // ../user_source/hdl_source/player_adjust_control.v(177)
  wire \u_adjust_control/lt1_syn_190 ;  // ../user_source/hdl_source/player_adjust_control.v(224)
  wire \u_adjust_control/lt2_syn_190 ;  // ../user_source/hdl_source/player_adjust_control.v(241)
  wire \u_adjust_control/lt3_syn_139 ;  // ../user_source/hdl_source/player_adjust_control.v(86)
  wire \u_adjust_control/lt6_syn_139 ;  // ../user_source/hdl_source/player_adjust_control.v(95)
  wire \u_adjust_control/mux40_syn_36 ;  // ../user_source/hdl_source/player_adjust_control.v(252)
  wire \u_adjust_control/mux40_syn_38 ;  // ../user_source/hdl_source/player_adjust_control.v(252)
  wire \u_adjust_control/mux40_syn_40 ;  // ../user_source/hdl_source/player_adjust_control.v(252)
  wire \u_adjust_control/mux40_syn_42 ;  // ../user_source/hdl_source/player_adjust_control.v(252)
  wire \u_adjust_control/mux40_syn_45 ;  // ../user_source/hdl_source/player_adjust_control.v(252)
  wire \u_adjust_control/mux42_syn_21 ;  // ../user_source/hdl_source/player_adjust_control.v(84)
  wire \u_adjust_control/mux51_syn_34 ;  // ../user_source/hdl_source/player_adjust_control.v(266)
  wire \u_adjust_control/mux51_syn_36 ;  // ../user_source/hdl_source/player_adjust_control.v(266)
  wire \u_adjust_control/mux51_syn_38 ;  // ../user_source/hdl_source/player_adjust_control.v(266)
  wire \u_adjust_control/mux51_syn_40 ;  // ../user_source/hdl_source/player_adjust_control.v(266)
  wire \u_adjust_control/mux51_syn_43 ;  // ../user_source/hdl_source/player_adjust_control.v(266)
  wire \u_adjust_control/mux57_syn_102 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux57_syn_163 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux57_syn_165 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux57_syn_167 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux57_syn_169 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux57_syn_171 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux58_syn_102 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux58_syn_163 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux58_syn_165 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux58_syn_167 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux58_syn_169 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux58_syn_171 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux58_syn_173 ;  // ../user_source/hdl_source/player_adjust_control.v(172)
  wire \u_adjust_control/mux66_syn_21 ;  // ../user_source/hdl_source/player_adjust_control.v(93)
  wire \u_adjust_control/sub0_syn_117 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_119 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_121 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_123 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_125 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_127 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_129 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_131 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_133 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_135 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub0_syn_137 ;  // ../user_source/hdl_source/player_adjust_control.v(157)
  wire \u_adjust_control/sub3_syn_117 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_119 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_121 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_123 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_125 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_127 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_129 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_131 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_133 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_135 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/sub3_syn_137 ;  // ../user_source/hdl_source/player_adjust_control.v(155)
  wire \u_adjust_control/key0_db_count_b[18]_syn_3 ;
  wire \u_adjust_control/key0_db_count_b[18]_syn_5 ;
  wire \u_adjust_control/key0_db_count_b[18]_syn_7 ;
  wire \u_adjust_control/key1_db_count_b[18]_syn_3 ;
  wire \u_adjust_control/key1_db_count_b[18]_syn_5 ;
  wire \u_adjust_control/key1_db_count_b[18]_syn_7 ;
  wire \u_adjust_control/auto_event_cooldown_b2_n3 ;
  wire \u_adjust_control/auto_event_cooldown_b3_n ;
  wire \u_adjust_control/auto_pending ;  // ../user_source/hdl_source/player_adjust_control.v(61)
  wire \u_adjust_control/auto_req_toggle ;  // ../user_source/hdl_source/player_adjust_control.v(15)
  wire \u_adjust_control/brightness_pending_b5_n ;
  wire \u_adjust_control/clk ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_2 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_3 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_4 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_5 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_6 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_7 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_8 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_9 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_10 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_11 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_12 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_13 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_95 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_96 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_97 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_98 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_99 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_100 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_101 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_102 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_103 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_104 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_105 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_106 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_281 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_282 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_283 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_284 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_285 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_286 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_287 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_288 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_289 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_290 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_291 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_292 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_374 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_375 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_376 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_377 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_378 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_379 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_380 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_381 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_382 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_383 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_384 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_385 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_564 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_566 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_568 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_570 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_573 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_575 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_577 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_579 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_583 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_585 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_587 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_589 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_592 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_594 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_596 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_598 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_604 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_623 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_632 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_640 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_645 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_648 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_651 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_654 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/clk_syn_665 ;  // ../user_source/hdl_source/player_adjust_control.v(8)
  wire \u_adjust_control/key0_armed ;  // ../user_source/hdl_source/player_adjust_control.v(49)
  wire \u_adjust_control/key0_long_done ;  // ../user_source/hdl_source/player_adjust_control.v(51)
  wire \u_adjust_control/key0_pressed_d ;  // ../user_source/hdl_source/player_adjust_control.v(44)
  wire \u_adjust_control/key1_armed ;  // ../user_source/hdl_source/player_adjust_control.v(50)
  wire \u_adjust_control/key1_long_done ;  // ../user_source/hdl_source/player_adjust_control.v(52)
  wire \u_adjust_control/key1_pressed_d ;  // ../user_source/hdl_source/player_adjust_control.v(45)
  wire \u_adjust_control/mode_b9_n ;
  wire \u_adjust_control/next_event_cooldown_b2_n3 ;
  wire \u_adjust_control/next_pending ;  // ../user_source/hdl_source/player_adjust_control.v(60)
  wire \u_adjust_control/next_req_toggle ;  // ../user_source/hdl_source/player_adjust_control.v(13)
  wire \u_adjust_control/rst_dup_8 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_9 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_12 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_13 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_14 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_15 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_16 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_17 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_18 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_19 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_20 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_21 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_22 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_23 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/rst_dup_24 ;  // ../user_source/hdl_source/player_adjust_control.v(9)
  wire \u_adjust_control/vs_d ;  // ../user_source/hdl_source/player_adjust_control.v(64)
  wire \u_adjust_osd/add0_syn_48 ;  // ../user_source/hdl_source/player_adjust_osd.v(12)
  wire \u_adjust_osd/mux10_syn_12 ;  // ../user_source/hdl_source/player_adjust_osd.v(11)
  wire \u_adjust_osd/mux11_syn_30 ;  // ../user_source/hdl_source/player_adjust_osd.v(11)
  wire \u_adjust_osd/mux11_syn_62 ;  // ../user_source/hdl_source/player_adjust_osd.v(11)
  wire \u_adjust_osd/bits_row_b12[4]_syn_2 ;
  wire \u_adjust_osd/ch[3]_syn_2 ;  // ../user_source/hdl_source/player_adjust_osd.v(207)
  wire \u_adjust_osd/ch[0]_syn_2 ;  // ../user_source/hdl_source/player_adjust_osd.v(207)
  wire \u_adjust_osd/y_pos[3]_dup_24 ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire \u_adjust_osd/y_pos[3]_dup_25 ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire \u_adjust_osd/y_pos[3]_dup_29 ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire \u_adjust_osd/y_pos[1]_syn_2 ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire \u_adjust_osd/y_pos_b5[1]_syn_2 ;
  wire \u_adjust_osd/arm_first_line ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire \u_adjust_osd/bits_row_b_n40 ;
  wire \u_adjust_osd/de_prev ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire \u_adjust_osd/de_prev_syn_4 ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire \u_adjust_osd/frame_mode_b_n ;
  wire \u_adjust_osd/glyph_on_n4_syn_2 ;
  wire \u_adjust_osd/vs_prev ;  // ../user_source/hdl_source/player_adjust_osd.v(5)
  wire \u_audio_probe/tone_mode ;  // ../user_source/hdl_source/player_audio_output.v(17)
  wire \u_audio_probe/tone_toggle ;  // ../user_source/hdl_source/player_audio_output.v(7)
  wire \u_audio_probe/tone_valid ;  // ../user_source/hdl_source/player_audio_output.v(19)
  wire \u_audio_probe/wav_valid ;  // ../user_source/hdl_source/player_audio_output.v(19)
  wire \u_audio_probe/u_acr/add0_syn_102 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_104 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_106 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_108 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_110 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_112 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_114 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_116 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_118 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/add0_syn_120 ;  // ../user_source/hdl_source/audio_arc_calculate.v(50)
  wire \u_audio_probe/u_acr/lt0_syn_31 ;  // ../user_source/hdl_source/audio_arc_calculate.v(31)
  wire \u_audio_probe/u_acr/lt0_syn_35 ;  // ../user_source/hdl_source/audio_arc_calculate.v(31)
  wire \u_audio_probe/u_acr/S_audio_valid_div ;  // ../user_source/hdl_source/audio_arc_calculate.v(21)
  wire \u_audio_probe/u_bridge/acknowledge_toggle_reg_syn_5 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(39)
  wire \u_audio_probe/u_bridge/add0_syn_95 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/add0_syn_97 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/add0_syn_99 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/add0_syn_101 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/add0_syn_103 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/add0_syn_105 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/add0_syn_107 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/add0_syn_109 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/add0_syn_111 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(35)
  wire \u_audio_probe/u_bridge/sub0_syn_100 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/sub0_syn_102 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/sub0_syn_104 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/sub0_syn_106 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/sub0_syn_108 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/sub0_syn_110 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/sub0_syn_112 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/sub0_syn_114 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/sub0_syn_116 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(87)
  wire \u_audio_probe/u_bridge/waiting_reg_syn_3 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(57)
  wire \u_audio_probe/u_bridge/waiting_reg_syn_6 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(57)
  wire \u_audio_probe/u_bridge/waiting_reg_syn_8 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(57)
  wire \u_audio_probe/u_bridge/waiting_reg_syn_10 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(57)
  wire \u_audio_probe/u_bridge/waiting_reg_syn_12 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(57)
  wire \u_audio_probe/u_bridge/sample_acc[7]_syn_2 ;  // ../user_source/hdl_source/wav_pcm_bridge.v(28)
  wire \u_audio_probe/u_bridge/ack_arrived ;  // ../user_source/hdl_source/wav_pcm_bridge.v(36)
  wire \u_audio_probe/u_bridge/ack_seen ;  // ../user_source/hdl_source/wav_pcm_bridge.v(25)
  wire \u_audio_probe/u_bridge/acknowledge_toggle ;  // ../user_source/hdl_source/wav_pcm_bridge.v(19)
  wire \u_audio_probe/u_bridge/audio_left_b1_n ;
  wire \u_audio_probe/u_bridge/audio_valid_n ;
  wire \u_audio_probe/u_bridge/play_run ;  // ../user_source/hdl_source/wav_pcm_bridge.v(30)
  wire \u_audio_probe/u_bridge/prefetch_valid ;  // ../user_source/hdl_source/wav_pcm_bridge.v(26)
  wire \u_audio_probe/u_bridge/request_toggle ;  // ../user_source/hdl_source/wav_pcm_bridge.v(18)
  wire \u_audio_probe/u_bridge/sample_take_n ;
  wire \u_audio_probe/u_bridge/started ;  // ../user_source/hdl_source/wav_pcm_bridge.v(26)
  wire \u_audio_probe/u_bridge/waiting ;  // ../user_source/hdl_source/wav_pcm_bridge.v(26)
  wire \u_audio_probe/u_tone/add0_syn_95 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add0_syn_97 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add0_syn_99 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add0_syn_101 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add0_syn_103 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add0_syn_105 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add0_syn_107 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add0_syn_109 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add0_syn_111 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(55)
  wire \u_audio_probe/u_tone/add1_syn_139 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(63)
  wire \u_audio_probe/u_tone/add1_syn_143 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(63)
  wire \u_audio_probe/u_tone/add1_syn_147 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(63)
  wire \u_audio_probe/u_tone/add1_syn_151 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(63)
  wire \u_audio_probe/u_tone/add1_syn_155 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(63)
  wire \u_audio_probe/u_tone/add1_syn_159 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(63)
  wire \u_audio_probe/u_tone/add1_syn_163 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(63)
  wire \u_audio_probe/u_tone/add1_syn_167 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(63)
  wire \u_audio_probe/u_tone/add3_syn_164 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(80)
  wire \u_audio_probe/u_tone/add3_syn_168 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(80)
  wire \u_audio_probe/u_tone/add3_syn_172 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(80)
  wire \u_audio_probe/u_tone/add3_syn_176 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(80)
  wire \u_audio_probe/u_tone/add3_syn_180 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(80)
  wire \u_audio_probe/u_tone/add3_syn_184 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(80)
  wire \u_audio_probe/u_tone/add3_syn_188 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(80)
  wire \u_audio_probe/u_tone/add3_syn_192 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(80)
  wire \u_audio_probe/u_tone/mux1_syn_44 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_54 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_66 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_78 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_90 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_102 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_112 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_114 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_126 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_136 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_142 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_156 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_168 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_180 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_192 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_202 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_222 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_234 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_244 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_256 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_266 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_278 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/mux1_syn_290 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(20)
  wire \u_audio_probe/u_tone/sub0_syn_103 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/sub0_syn_105 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/sub0_syn_107 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/sub0_syn_109 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/sub0_syn_111 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/sub0_syn_113 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/sub0_syn_115 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/sub0_syn_117 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/sub0_syn_119 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(59)
  wire \u_audio_probe/u_tone/S_note_idx[2]_syn_2 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(35)
  wire \u_audio_probe/u_tone/S_sample_acc[7]_syn_2 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(33)
  wire \u_audio_probe/u_tone/W_note_inc[10]_syn_2 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(40)
  wire \u_audio_probe/u_tone/O_audio_left_data_b_n ;
  wire \u_audio_probe/u_tone/S_note_idx_b1_n ;
  wire \u_bmp_file_player/add1_syn_164 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(143)
  wire \u_bmp_file_player/add1_syn_168 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(143)
  wire \u_bmp_file_player/add1_syn_172 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(143)
  wire \u_bmp_file_player/add1_syn_176 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(143)
  wire \u_bmp_file_player/add1_syn_180 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(143)
  wire \u_bmp_file_player/add1_syn_184 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(143)
  wire \u_bmp_file_player/add1_syn_188 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(143)
  wire \u_bmp_file_player/add1_syn_192 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(143)
  wire \u_bmp_file_player/add2_syn_164 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(148)
  wire \u_bmp_file_player/add2_syn_168 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(148)
  wire \u_bmp_file_player/add2_syn_172 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(148)
  wire \u_bmp_file_player/add2_syn_176 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(148)
  wire \u_bmp_file_player/add2_syn_180 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(148)
  wire \u_bmp_file_player/add2_syn_184 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(148)
  wire \u_bmp_file_player/add2_syn_188 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(148)
  wire \u_bmp_file_player/add2_syn_192 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(148)
  wire \u_bmp_file_player/add3_syn_48 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(55)
  wire \u_bmp_file_player/add3_syn_105 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(55)
  wire \u_bmp_file_player/add3_syn_107 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(55)
  wire \u_bmp_file_player/add3_syn_109 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(55)
  wire \u_bmp_file_player/add3_syn_111 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(55)
  wire \u_bmp_file_player/add3_syn_113 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(55)
  wire \u_bmp_file_player/add5_syn_167 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_169 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_171 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_173 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_175 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_177 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_179 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_181 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_183 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_185 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_187 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_189 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_191 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_193 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add5_syn_195 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(58)
  wire \u_bmp_file_player/add6_syn_36 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(208)
  wire \u_bmp_file_player/add6_syn_48 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(208)
  wire \u_bmp_file_player/add7_syn_161 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/add7_syn_165 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/add7_syn_169 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/add7_syn_173 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/add7_syn_177 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/add7_syn_181 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/add7_syn_185 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/add7_syn_189 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/bit_count_ok_reg_syn_6 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/compression_ok_reg_syn_6 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/compression_ok_reg_syn_8 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/eq13_syn_73 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(174)
  wire \u_bmp_file_player/header_read_reg_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/height_high_one_reg_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/height_high_one_reg_syn_7 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/height_high_zero_reg_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/height_high_zero_reg_syn_7 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/height_high_zero_reg_syn_9 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/height_high_zero_reg_syn_11 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/height_high_zero_reg_syn_13 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/lt5_syn_220 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/lt5_syn_247 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(64)
  wire \u_bmp_file_player/lt7_syn_220 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(68)
  wire \u_bmp_file_player/lt7_syn_247 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(68)
  wire \u_bmp_file_player/lt7_syn_267 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(68)
  wire \u_bmp_file_player/lt8_syn_214 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(68)
  wire \u_bmp_file_player/lt8_syn_241 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(68)
  wire \u_bmp_file_player/lt8_syn_261 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(68)
  wire \u_bmp_file_player/magic_ok_reg_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/magic_ok_reg_syn_7 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/magic_ok_reg_syn_9 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/mux11_syn_8 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux15_syn_13 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux2_syn_34 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux25_syn_103 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(146)
  wire \u_bmp_file_player/mux35_syn_103 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(154)
  wire \u_bmp_file_player/mux35_syn_106 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(154)
  wire \u_bmp_file_player/mux69_syn_109 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux75_syn_253 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux75_syn_291 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux75_syn_304 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_341 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_421 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_501 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_651 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_653 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_655 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_657 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_659 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_661 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_663 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_665 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux76_syn_667 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_341 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_421 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_501 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_651 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_655 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_657 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_659 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_661 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_663 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_665 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_667 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_669 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_783 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_785 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux77_syn_789 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_341 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_421 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_501 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_591 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_653 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_655 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_657 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_659 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_661 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_663 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_665 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_667 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux78_syn_786 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_42 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_50 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_58 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_66 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_82 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_90 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_98 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_118 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux79_syn_198 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux8_syn_28 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux80_syn_109 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/mux80_syn_199 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(150)
  wire \u_bmp_file_player/next_pending_reg_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/planes_ok_reg_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/planes_ok_reg_syn_7 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/sel5_syn_29 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(173)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_7 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_9 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_11 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_13 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_15 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_17 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_19 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_21 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_23 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_25 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_29 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_31 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_33 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_high_nonzero_reg_syn_36 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_7 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_9 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_11 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_13 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_15 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_17 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_19 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_21 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_23 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_26 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_28 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_30 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_32 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_34 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_36 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_38 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_40 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_42 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_44 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_47 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_49 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_51 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_53 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_55 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_57 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_59 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_61 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_63 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_65 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_67 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_69 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_71 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_73 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_75 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_77 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_79 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_82 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_84 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_86 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_88 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_90 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_92 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_94 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_96 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_98 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_102 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_104 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_106 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_108 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_110 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_112 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_114 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_116 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_118 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_120 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_122 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_124 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_126 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_128 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_130 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_132 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_135 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_137 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_139 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_141 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_143 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_145 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_149 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_151 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_153 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_155 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_157 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_159 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_161 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_163 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_165 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_167 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_169 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_171 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_173 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_175 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_177 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_179 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_181 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_183 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_185 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_187 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_189 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_191 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_193 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_195 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_197 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/write_req_reg_syn_199 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/file_cluster_b2[28]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[27]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[26]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[25]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[24]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[23]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[22]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[21]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[20]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[19]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[18]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[17]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[16]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[15]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[14]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[13]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[12]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[11]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[10]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[9]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[8]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[7]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[6]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[5]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[4]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[3]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[2]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[1]_syn_2 ;
  wire \u_bmp_file_player/file_cluster_b2[0]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[31]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[30]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[29]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[28]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[27]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[26]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[25]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[24]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[23]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[22]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[21]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[20]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[19]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[18]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[17]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[16]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[15]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[14]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[13]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[12]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[11]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[10]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[9]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[8]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[7]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[6]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[6]_syn_5 ;
  wire \u_bmp_file_player/file_size_b2[5]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[4]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[3]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[2]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[1]_syn_2 ;
  wire \u_bmp_file_player/file_size_b2[0]_syn_2 ;
  wire \u_bmp_file_player/next_image[0]_dup_1 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(48)
  wire \u_bmp_file_player/next_image[0]_dup_2 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(48)
  wire \u_bmp_file_player/next_image[0]_dup_3 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(48)
  wire \u_bmp_file_player/next_image[0]_dup_4 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(48)
  wire \u_bmp_file_player/sector_bytes[9]_syn_4 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(34)
  wire \u_bmp_file_player/state_b[3]_syn_5 ;
  wire \u_bmp_file_player/state_b[3]_syn_7 ;
  wire \u_bmp_file_player/state_b[3]_syn_9 ;
  wire \u_bmp_file_player/state_b[3]_syn_12 ;
  wire \u_bmp_file_player/state_b[3]_syn_14 ;
  wire \u_bmp_file_player/state_b[3]_syn_17 ;
  wire \u_bmp_file_player/state_b[3]_syn_19 ;
  wire \u_bmp_file_player/state_b[2]_syn_2 ;
  wire \u_bmp_file_player/state_b[1]_syn_4 ;
  wire \u_bmp_file_player/state_b[1]_syn_6 ;
  wire \u_bmp_file_player/state_b[1]_syn_8 ;
  wire \u_bmp_file_player/state_b[0]_syn_4 ;
  wire \u_bmp_file_player/state_b[0]_syn_6 ;
  wire \u_bmp_file_player/state_b[0]_syn_8 ;
  wire \u_bmp_file_player/watchdog_b[31]_syn_2 ;
  wire \u_bmp_file_player/auto_count_b3_n ;
  wire \u_bmp_file_player/auto_mode ;  // ../user_source/hdl_source/tf_bmp_file_player.v(25)
  wire \u_bmp_file_player/auto_press ;  // ../user_source/hdl_source/tf_bmp_file_player.v(45)
  wire \u_bmp_file_player/bit_count_ok ;  // ../user_source/hdl_source/tf_bmp_file_player.v(40)
  wire \u_bmp_file_player/bit_count_ok_n19 ;
  wire \u_bmp_file_player/card_valid ;  // ../user_source/hdl_source/tf_bmp_file_player.v(16)
  wire \u_bmp_file_player/compression_ok ;  // ../user_source/hdl_source/tf_bmp_file_player.v(40)
  wire \u_bmp_file_player/disp_buf_idx_b1_n_syn_2 ;
  wire \u_bmp_file_player/display_valid ;  // ../user_source/hdl_source/tf_bmp_file_player.v(22)
  wire \u_bmp_file_player/display_valid_dup_1 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(22)
  wire \u_bmp_file_player/display_valid_dup_2 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(22)
  wire \u_bmp_file_player/header_failure_mask_n5 ;
  wire \u_bmp_file_player/header_read ;  // ../user_source/hdl_source/tf_bmp_file_player.v(36)
  wire \u_bmp_file_player/height_high_one ;  // ../user_source/hdl_source/tf_bmp_file_player.v(44)
  wire \u_bmp_file_player/height_high_zero ;  // ../user_source/hdl_source/tf_bmp_file_player.v(44)
  wire \u_bmp_file_player/height_sign ;  // ../user_source/hdl_source/tf_bmp_file_player.v(44)
  wire \u_bmp_file_player/height_sign_dup_1 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(44)
  wire \u_bmp_file_player/height_sign_dup_2 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(44)
  wire \u_bmp_file_player/magic_ok ;  // ../user_source/hdl_source/tf_bmp_file_player.v(40)
  wire \u_bmp_file_player/next_pending ;  // ../user_source/hdl_source/tf_bmp_file_player.v(36)
  wire \u_bmp_file_player/next_press ;  // ../user_source/hdl_source/tf_bmp_file_player.v(45)
  wire \u_bmp_file_player/planes_ok ;  // ../user_source/hdl_source/tf_bmp_file_player.v(40)
  wire \u_bmp_file_player/rst ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_1 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_4 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_7 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_8 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_9 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_10 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_12 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_13 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_14 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_15 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_16 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/rst_dup_17 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(9)
  wire \u_bmp_file_player/scale_active ;  // ../user_source/hdl_source/tf_bmp_file_player.v(36)
  wire \u_bmp_file_player/width_high_nonzero ;  // ../user_source/hdl_source/tf_bmp_file_player.v(42)
  wire \u_bmp_file_player/write_done ;  // ../user_source/hdl_source/tf_bmp_file_player.v(36)
  wire \u_bmp_file_player/write_en_n1 ;
  wire \u_bmp_file_player/write_req ;  // ../user_source/hdl_source/tf_bmp_file_player.v(20)
  wire \u_bmp_file_player/u_key_event_mailbox/auto_ack_toggle ;  // ../user_source/hdl_source/tf_bmp_file_player.v(262)
  wire \u_bmp_file_player/u_key_event_mailbox/next_ack_toggle ;  // ../user_source/hdl_source/tf_bmp_file_player.v(259)
  wire \u_bmp_file_player/u_scale/add1_syn_165 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_167 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_169 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_171 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_173 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_175 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_177 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_179 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_181 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_183 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_185 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_187 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_189 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_191 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add1_syn_193 ;  // ../user_source/hdl_source/bmp_scale_engine.v(104)
  wire \u_bmp_file_player/u_scale/add10_syn_32 ;  // ../user_source/hdl_source/bmp_scale_engine.v(261)
  wire \u_bmp_file_player/u_scale/add10_syn_40 ;  // ../user_source/hdl_source/bmp_scale_engine.v(261)
  wire \u_bmp_file_player/u_scale/add10_syn_44 ;  // ../user_source/hdl_source/bmp_scale_engine.v(261)
  wire \u_bmp_file_player/u_scale/add11_syn_32 ;  // ../user_source/hdl_source/bmp_scale_engine.v(288)
  wire \u_bmp_file_player/u_scale/add11_syn_44 ;  // ../user_source/hdl_source/bmp_scale_engine.v(288)
  wire \u_bmp_file_player/u_scale/add12_syn_48 ;  // ../user_source/hdl_source/bmp_scale_engine.v(292)
  wire \u_bmp_file_player/u_scale/add12_syn_50 ;  // ../user_source/hdl_source/bmp_scale_engine.v(292)
  wire \u_bmp_file_player/u_scale/add12_syn_52 ;  // ../user_source/hdl_source/bmp_scale_engine.v(292)
  wire \u_bmp_file_player/u_scale/add12_syn_54 ;  // ../user_source/hdl_source/bmp_scale_engine.v(292)
  wire \u_bmp_file_player/u_scale/add12_syn_56 ;  // ../user_source/hdl_source/bmp_scale_engine.v(292)
  wire \u_bmp_file_player/u_scale/add13_syn_40 ;  // ../user_source/hdl_source/bmp_scale_engine.v(300)
  wire \u_bmp_file_player/u_scale/add13_syn_44 ;  // ../user_source/hdl_source/bmp_scale_engine.v(300)
  wire \u_bmp_file_player/u_scale/add14_syn_30 ;  // ../user_source/hdl_source/bmp_scale_engine.v(304)
  wire \u_bmp_file_player/u_scale/add14_syn_34 ;  // ../user_source/hdl_source/bmp_scale_engine.v(304)
  wire \u_bmp_file_player/u_scale/add14_syn_42 ;  // ../user_source/hdl_source/bmp_scale_engine.v(304)
  wire \u_bmp_file_player/u_scale/add14_syn_50 ;  // ../user_source/hdl_source/bmp_scale_engine.v(304)
  wire \u_bmp_file_player/u_scale/add16_syn_50 ;  // ../user_source/hdl_source/bmp_scale_engine.v(55)
  wire \u_bmp_file_player/u_scale/add16_syn_70 ;  // ../user_source/hdl_source/bmp_scale_engine.v(55)
  wire \u_bmp_file_player/u_scale/add2_syn_64 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_131 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_133 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_135 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_137 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_139 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_141 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_295 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_299 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_303 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_307 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_311 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_315 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_319 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add2_syn_323 ;  // ../user_source/hdl_source/bmp_scale_engine.v(105)
  wire \u_bmp_file_player/u_scale/add5_syn_55 ;  // ../user_source/hdl_source/bmp_scale_engine.v(193)
  wire \u_bmp_file_player/u_scale/add6_syn_28 ;  // ../user_source/hdl_source/bmp_scale_engine.v(215)
  wire \u_bmp_file_player/u_scale/add6_syn_44 ;  // ../user_source/hdl_source/bmp_scale_engine.v(215)
  wire \u_bmp_file_player/u_scale/add7_syn_40 ;  // ../user_source/hdl_source/bmp_scale_engine.v(240)
  wire \u_bmp_file_player/u_scale/add7_syn_44 ;  // ../user_source/hdl_source/bmp_scale_engine.v(240)
  wire \u_bmp_file_player/u_scale/add8_syn_44 ;  // ../user_source/hdl_source/bmp_scale_engine.v(115)
  wire \u_bmp_file_player/u_scale/add8_syn_46 ;  // ../user_source/hdl_source/bmp_scale_engine.v(115)
  wire \u_bmp_file_player/u_scale/add8_syn_48 ;  // ../user_source/hdl_source/bmp_scale_engine.v(115)
  wire \u_bmp_file_player/u_scale/add8_syn_50 ;  // ../user_source/hdl_source/bmp_scale_engine.v(115)
  wire \u_bmp_file_player/u_scale/add8_syn_52 ;  // ../user_source/hdl_source/bmp_scale_engine.v(115)
  wire \u_bmp_file_player/u_scale/add9_syn_40 ;  // ../user_source/hdl_source/bmp_scale_engine.v(116)
  wire \u_bmp_file_player/u_scale/add9_syn_42 ;  // ../user_source/hdl_source/bmp_scale_engine.v(116)
  wire \u_bmp_file_player/u_scale/add9_syn_44 ;  // ../user_source/hdl_source/bmp_scale_engine.v(116)
  wire \u_bmp_file_player/u_scale/add9_syn_46 ;  // ../user_source/hdl_source/bmp_scale_engine.v(116)
  wire \u_bmp_file_player/u_scale/card_read_reg_syn_5 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/done_reg_syn_6 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/error_reg_syn_5 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/error_reg_syn_8 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/lt0_syn_99 ;  // ../user_source/hdl_source/bmp_scale_engine.v(168)
  wire \u_bmp_file_player/u_scale/lt12_syn_70 ;  // ../user_source/hdl_source/bmp_scale_engine.v(290)
  wire \u_bmp_file_player/u_scale/lt12_syn_73 ;  // ../user_source/hdl_source/bmp_scale_engine.v(290)
  wire \u_bmp_file_player/u_scale/lt13_syn_69 ;  // ../user_source/hdl_source/bmp_scale_engine.v(300)
  wire \u_bmp_file_player/u_scale/lt17_syn_73 ;  // ../user_source/hdl_source/bmp_scale_engine.v(306)
  wire \u_bmp_file_player/u_scale/lt17_syn_76 ;  // ../user_source/hdl_source/bmp_scale_engine.v(306)
  wire \u_bmp_file_player/u_scale/lt2_syn_59 ;  // ../user_source/hdl_source/bmp_scale_engine.v(203)
  wire \u_bmp_file_player/u_scale/lt2_syn_60 ;  // ../user_source/hdl_source/bmp_scale_engine.v(203)
  wire \u_bmp_file_player/u_scale/lt3_syn_57 ;  // ../user_source/hdl_source/bmp_scale_engine.v(203)
  wire \u_bmp_file_player/u_scale/lt4_syn_75 ;  // ../user_source/hdl_source/bmp_scale_engine.v(110)
  wire \u_bmp_file_player/u_scale/lt5_syn_69 ;  // ../user_source/hdl_source/bmp_scale_engine.v(214)
  wire \u_bmp_file_player/u_scale/lt6_syn_71 ;  // ../user_source/hdl_source/bmp_scale_engine.v(261)
  wire \u_bmp_file_player/u_scale/lt8_syn_74 ;  // ../user_source/hdl_source/bmp_scale_engine.v(271)
  wire \u_bmp_file_player/u_scale/lt9_syn_72 ;  // ../user_source/hdl_source/bmp_scale_engine.v(271)
  wire \u_bmp_file_player/u_scale/mux111_syn_1836 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux113_syn_3329 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_171 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_321 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_471 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_621 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_771 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_921 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_1071 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_1221 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_1371 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux130_syn_1521 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux131_syn_1222 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux135_syn_1699 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux135_syn_1701 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux135_syn_1703 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux135_syn_1705 ;  // ../user_source/hdl_source/bmp_scale_engine.v(155)
  wire \u_bmp_file_player/u_scale/mux140_syn_132 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_142 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_144 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_146 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_148 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_150 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_153 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_155 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_157 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_159 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_161 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_163 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_165 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_167 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_169 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_171 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_173 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_175 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_178 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_184 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_187 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_189 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_192 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_194 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_196 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_200 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_204 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_207 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_210 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_212 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_214 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_219 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_221 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_223 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_225 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_227 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_231 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_233 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_235 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_237 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_240 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_243 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_245 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux140_syn_247 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux143_syn_29 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_35 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_37 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_39 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_43 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_46 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_49 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_51 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_53 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_55 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_57 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux144_syn_59 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux146_syn_29 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux146_syn_31 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux146_syn_33 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux146_syn_35 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/mux146_syn_39 ;  // ../user_source/hdl_source/bmp_scale_engine.v(152)
  wire \u_bmp_file_player/u_scale/pixel_valid_reg_syn_5 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/sub11_syn_48 ;  // ../user_source/hdl_source/bmp_scale_engine.v(300)
  wire \u_bmp_file_player/u_scale/sub11_syn_50 ;  // ../user_source/hdl_source/bmp_scale_engine.v(300)
  wire \u_bmp_file_player/u_scale/sub11_syn_52 ;  // ../user_source/hdl_source/bmp_scale_engine.v(300)
  wire \u_bmp_file_player/u_scale/sub11_syn_54 ;  // ../user_source/hdl_source/bmp_scale_engine.v(300)
  wire \u_bmp_file_player/u_scale/sub11_syn_56 ;  // ../user_source/hdl_source/bmp_scale_engine.v(300)
  wire \u_bmp_file_player/u_scale/sub2_syn_40 ;  // ../user_source/hdl_source/bmp_scale_engine.v(187)
  wire \u_bmp_file_player/u_scale/sub2_syn_55 ;  // ../user_source/hdl_source/bmp_scale_engine.v(187)
  wire \u_bmp_file_player/u_scale/sub2_syn_65 ;  // ../user_source/hdl_source/bmp_scale_engine.v(187)
  wire \u_bmp_file_player/u_scale/sub6_syn_44 ;  // ../user_source/hdl_source/bmp_scale_engine.v(209)
  wire \u_bmp_file_player/u_scale/sub6_syn_46 ;  // ../user_source/hdl_source/bmp_scale_engine.v(209)
  wire \u_bmp_file_player/u_scale/sub6_syn_48 ;  // ../user_source/hdl_source/bmp_scale_engine.v(209)
  wire \u_bmp_file_player/u_scale/sub6_syn_50 ;  // ../user_source/hdl_source/bmp_scale_engine.v(209)
  wire \u_bmp_file_player/u_scale/sub6_syn_52 ;  // ../user_source/hdl_source/bmp_scale_engine.v(209)
  wire \u_bmp_file_player/u_scale/sub7_syn_49 ;  // ../user_source/hdl_source/bmp_scale_engine.v(215)
  wire \u_bmp_file_player/u_scale/sub7_syn_51 ;  // ../user_source/hdl_source/bmp_scale_engine.v(215)
  wire \u_bmp_file_player/u_scale/sub7_syn_53 ;  // ../user_source/hdl_source/bmp_scale_engine.v(215)
  wire \u_bmp_file_player/u_scale/sub7_syn_55 ;  // ../user_source/hdl_source/bmp_scale_engine.v(215)
  wire \u_bmp_file_player/u_scale/sub7_syn_57 ;  // ../user_source/hdl_source/bmp_scale_engine.v(215)
  wire \u_bmp_file_player/u_scale/sub8_syn_45 ;  // ../user_source/hdl_source/bmp_scale_engine.v(216)
  wire \u_bmp_file_player/u_scale/sub8_syn_47 ;  // ../user_source/hdl_source/bmp_scale_engine.v(216)
  wire \u_bmp_file_player/u_scale/sub8_syn_49 ;  // ../user_source/hdl_source/bmp_scale_engine.v(216)
  wire \u_bmp_file_player/u_scale/sub8_syn_51 ;  // ../user_source/hdl_source/bmp_scale_engine.v(216)
  wire \u_bmp_file_player/u_scale/sub8_syn_53 ;  // ../user_source/hdl_source/bmp_scale_engine.v(216)
  wire \u_bmp_file_player/u_scale/sub9_syn_49 ;  // ../user_source/hdl_source/bmp_scale_engine.v(112)
  wire \u_bmp_file_player/u_scale/sub9_syn_51 ;  // ../user_source/hdl_source/bmp_scale_engine.v(112)
  wire \u_bmp_file_player/u_scale/sub9_syn_53 ;  // ../user_source/hdl_source/bmp_scale_engine.v(112)
  wire \u_bmp_file_player/u_scale/sub9_syn_55 ;  // ../user_source/hdl_source/bmp_scale_engine.v(112)
  wire \u_bmp_file_player/u_scale/sub9_syn_57 ;  // ../user_source/hdl_source/bmp_scale_engine.v(112)
  wire \u_bmp_file_player/u_scale/denominator_b1[9]_syn_2 ;
  wire \u_bmp_file_player/u_scale/denominator_b1[9]_syn_4 ;
  wire \u_bmp_file_player/u_scale/denominator_b1[9]_syn_7 ;
  wire \u_bmp_file_player/u_scale/denominator_b1[9]_syn_9 ;
  wire \u_bmp_file_player/u_scale/denominator_b1[9]_syn_11 ;
  wire \u_bmp_file_player/u_scale/denominator_b1[9]_syn_13 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_3 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_5 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_7 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_9 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_11 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_13 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_19 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_dup_22 ;
  wire \u_bmp_file_player/u_scale/offx_b1[9]_syn_dup_26 ;
  wire \u_bmp_file_player/u_scale/offy_b1[8]_syn_2 ;
  wire \u_bmp_file_player/u_scale/card_end ;  // ../user_source/hdl_source/bmp_scale_engine.v(17)
  wire \u_bmp_file_player/u_scale/card_read ;  // ../user_source/hdl_source/bmp_scale_engine.v(16)
  wire \u_bmp_file_player/u_scale/div_for_width ;  // ../user_source/hdl_source/bmp_scale_engine.v(79)
  wire \u_bmp_file_player/u_scale/done ;  // ../user_source/hdl_source/bmp_scale_engine.v(20)
  wire \u_bmp_file_player/u_scale/error ;  // ../user_source/hdl_source/bmp_scale_engine.v(20)
  wire \u_bmp_file_player/u_scale/error_n7 ;
  wire \u_bmp_file_player/u_scale/line_black ;  // ../user_source/hdl_source/bmp_scale_engine.v(100)
  wire \u_bmp_file_player/u_scale/pixel_rgb_b4_n_syn_2 ;
  wire \u_bmp_file_player/u_scale/pixel_valid ;  // ../user_source/hdl_source/bmp_scale_engine.v(19)
  wire \u_bmp_file_player/u_scale/row_mem_n ;
  wire \u_bmp_file_player/u_scale/row_tag_valid ;  // ../user_source/hdl_source/bmp_scale_engine.v(91)
  wire \u_bmp_file_player/u_scale/sector_mem_n ;
  wire \u_bmp_file_player/u_scale/sector_tag_valid ;  // ../user_source/hdl_source/bmp_scale_engine.v(84)
  wire \u_bmp_file_player/u_scale/src_col_b5_n_syn_4 ;
  wire \u_bmp_file_player/u_scale/start ;  // ../user_source/hdl_source/bmp_scale_engine.v(11)
  wire \u_bmp_file_player/u_scale/state_b60_n ;
  wire \u_catalog/add1_syn_44 ;  // ../user_source/hdl_source/fat32_catalog.v(222)
  wire \u_catalog/add11_syn_145 ;  // ../user_source/hdl_source/fat32_catalog.v(299)
  wire \u_catalog/add11_syn_149 ;  // ../user_source/hdl_source/fat32_catalog.v(299)
  wire \u_catalog/add11_syn_153 ;  // ../user_source/hdl_source/fat32_catalog.v(299)
  wire \u_catalog/add11_syn_157 ;  // ../user_source/hdl_source/fat32_catalog.v(299)
  wire \u_catalog/add11_syn_161 ;  // ../user_source/hdl_source/fat32_catalog.v(299)
  wire \u_catalog/add11_syn_165 ;  // ../user_source/hdl_source/fat32_catalog.v(299)
  wire \u_catalog/add11_syn_169 ;  // ../user_source/hdl_source/fat32_catalog.v(299)
  wire \u_catalog/add11_syn_173 ;  // ../user_source/hdl_source/fat32_catalog.v(299)
  wire \u_catalog/add12_syn_136 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire \u_catalog/add12_syn_140 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire \u_catalog/add12_syn_144 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire \u_catalog/add12_syn_148 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire \u_catalog/add12_syn_152 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire \u_catalog/add12_syn_156 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire \u_catalog/add12_syn_160 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire \u_catalog/add12_syn_164 ;  // ../user_source/hdl_source/fat32_catalog.v(73)
  wire \u_catalog/add13_syn_136 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire \u_catalog/add13_syn_140 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire \u_catalog/add13_syn_144 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire \u_catalog/add13_syn_148 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire \u_catalog/add13_syn_152 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire \u_catalog/add13_syn_156 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire \u_catalog/add13_syn_160 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire \u_catalog/add13_syn_164 ;  // ../user_source/hdl_source/fat32_catalog.v(74)
  wire \u_catalog/add14_syn_187 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_191 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_195 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_199 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_203 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_207 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_211 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_215 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_357 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_361 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_365 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_369 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_373 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_377 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_381 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add14_syn_385 ;  // ../user_source/hdl_source/fat32_catalog.v(78)
  wire \u_catalog/add15_syn_145 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_147 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_149 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_151 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_153 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_155 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_157 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_159 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_161 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_163 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_165 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_167 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_169 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add15_syn_171 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/add16_syn_174 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/add16_syn_178 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/add16_syn_182 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/add16_syn_186 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/add16_syn_190 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/add16_syn_194 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/add16_syn_198 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/add16_syn_202 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/add17_syn_171 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/add17_syn_175 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/add17_syn_179 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/add17_syn_183 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/add17_syn_187 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/add17_syn_191 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/add17_syn_195 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/add17_syn_199 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/add2_syn_156 ;  // ../user_source/hdl_source/fat32_catalog.v(241)
  wire \u_catalog/add2_syn_160 ;  // ../user_source/hdl_source/fat32_catalog.v(241)
  wire \u_catalog/add2_syn_164 ;  // ../user_source/hdl_source/fat32_catalog.v(241)
  wire \u_catalog/add2_syn_168 ;  // ../user_source/hdl_source/fat32_catalog.v(241)
  wire \u_catalog/add2_syn_172 ;  // ../user_source/hdl_source/fat32_catalog.v(241)
  wire \u_catalog/add2_syn_176 ;  // ../user_source/hdl_source/fat32_catalog.v(241)
  wire \u_catalog/add2_syn_180 ;  // ../user_source/hdl_source/fat32_catalog.v(241)
  wire \u_catalog/add2_syn_184 ;  // ../user_source/hdl_source/fat32_catalog.v(241)
  wire \u_catalog/add3_syn_144 ;  // ../user_source/hdl_source/fat32_catalog.v(245)
  wire \u_catalog/add3_syn_148 ;  // ../user_source/hdl_source/fat32_catalog.v(245)
  wire \u_catalog/add3_syn_152 ;  // ../user_source/hdl_source/fat32_catalog.v(245)
  wire \u_catalog/add3_syn_156 ;  // ../user_source/hdl_source/fat32_catalog.v(245)
  wire \u_catalog/add3_syn_160 ;  // ../user_source/hdl_source/fat32_catalog.v(245)
  wire \u_catalog/add3_syn_164 ;  // ../user_source/hdl_source/fat32_catalog.v(245)
  wire \u_catalog/add3_syn_168 ;  // ../user_source/hdl_source/fat32_catalog.v(245)
  wire \u_catalog/add3_syn_172 ;  // ../user_source/hdl_source/fat32_catalog.v(245)
  wire \u_catalog/add5_syn_148 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add5_syn_152 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add5_syn_156 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add5_syn_160 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add5_syn_164 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add5_syn_168 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add5_syn_172 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add5_syn_176 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add5_syn_180 ;  // ../user_source/hdl_source/fat32_catalog.v(251)
  wire \u_catalog/add6_syn_38 ;  // ../user_source/hdl_source/fat32_catalog.v(287)
  wire \u_catalog/add6_syn_42 ;  // ../user_source/hdl_source/fat32_catalog.v(287)
  wire \u_catalog/add7_syn_134 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/add7_syn_138 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/add7_syn_142 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/add7_syn_146 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/add7_syn_150 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/add7_syn_154 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/add7_syn_158 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/add7_syn_162 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/add8_syn_102 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_104 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_106 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_108 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_110 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_112 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_114 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_116 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_118 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add8_syn_120 ;  // ../user_source/hdl_source/fat32_catalog.v(147)
  wire \u_catalog/add9_syn_28 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/add9_syn_44 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/bmp_name_match_reg_syn_6 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/bmp_name_match_reg_syn_8 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/bps_fixed_valid_reg_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/bps_fixed_valid_reg_syn_7 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/dir_deleted_reg_syn_6 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/error_reg_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/error_reg_syn_7 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/error_reg_syn_9 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/error_reg_syn_13 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/fat16_fixed_valid_reg_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/left_shift6_syn_87 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_95 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_103 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_111 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_119 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_127 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_133 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_135 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_141 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_143 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_149 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_151 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_157 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_159 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_165 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_167 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_173 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_175 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_181 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_183 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_189 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_191 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_197 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_199 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_205 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_207 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_213 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_215 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_221 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_223 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_229 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_231 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_237 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_239 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_245 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_247 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_253 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_255 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_261 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_263 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_269 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_271 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_277 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_279 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_285 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_287 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_293 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_295 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_301 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_303 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_311 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_319 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_327 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_335 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_377 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_380 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_382 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_385 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_388 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_391 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_393 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift6_syn_403 ;  // ../user_source/hdl_source/fat32_catalog.v(289)
  wire \u_catalog/left_shift8_syn_92 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_98 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_104 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_110 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_116 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_122 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_126 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_128 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_132 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_134 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_138 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_140 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_144 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_146 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_150 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_152 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_156 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_158 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_162 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_164 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_168 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_170 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_174 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_176 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_180 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_182 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_186 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_188 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_192 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_194 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_198 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_200 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_204 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_206 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_210 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_212 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_216 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_218 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_222 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_224 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_228 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_230 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_234 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_236 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_240 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_242 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_246 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_248 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_252 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_254 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_260 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_266 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_272 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_278 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_282 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_286 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_288 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_293 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_296 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_299 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_338 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_349 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/left_shift8_syn_353 ;  // ../user_source/hdl_source/fat32_catalog.v(85)
  wire \u_catalog/lt10_syn_216 ;  // ../user_source/hdl_source/fat32_catalog.v(271)
  wire \u_catalog/lt10_syn_241 ;  // ../user_source/hdl_source/fat32_catalog.v(271)
  wire \u_catalog/lt10_syn_254 ;  // ../user_source/hdl_source/fat32_catalog.v(271)
  wire \u_catalog/lt10_syn_272 ;  // ../user_source/hdl_source/fat32_catalog.v(271)
  wire \u_catalog/lt11_syn_55 ;  // ../user_source/hdl_source/fat32_catalog.v(272)
  wire \u_catalog/lt17_syn_142 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_144 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_146 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_148 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_150 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_152 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_154 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_156 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_158 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_160 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_162 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_164 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_166 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt17_syn_168 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt19_syn_200 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt19_syn_237 ;  // ../user_source/hdl_source/fat32_catalog.v(285)
  wire \u_catalog/lt27_syn_239 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/lt28_syn_219 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/lt28_syn_244 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/lt28_syn_257 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/lt28_syn_258 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/lt28_syn_269 ;  // ../user_source/hdl_source/fat32_catalog.v(206)
  wire \u_catalog/lt30_syn_232 ;  // ../user_source/hdl_source/fat32_catalog.v(93)
  wire \u_catalog/lt30_syn_269 ;  // ../user_source/hdl_source/fat32_catalog.v(93)
  wire \u_catalog/lt32_syn_254 ;  // ../user_source/hdl_source/fat32_catalog.v(94)
  wire \u_catalog/lt33_syn_232 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/lt33_syn_234 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/lt33_syn_259 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/lt33_syn_273 ;  // ../user_source/hdl_source/fat32_catalog.v(95)
  wire \u_catalog/lt34_syn_311 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/lt34_syn_324 ;  // ../user_source/hdl_source/fat32_catalog.v(96)
  wire \u_catalog/mux189_syn_98 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux20_syn_14 ;  // ../user_source/hdl_source/fat32_catalog.v(181)
  wire \u_catalog/mux204_syn_69 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux204_syn_73 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux204_syn_77 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux204_syn_81 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux205_syn_69 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux205_syn_73 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux205_syn_77 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux205_syn_81 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux207_syn_75 ;  // ../user_source/hdl_source/fat32_catalog.v(145)
  wire \u_catalog/mux21_syn_16 ;  // ../user_source/hdl_source/fat32_catalog.v(181)
  wire \u_catalog/mux299_syn_4 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_6 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_8 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_10 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_12 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_14 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_16 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_18 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_20 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_22 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_24 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_26 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_28 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_30 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_32 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_34 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_36 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_38 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_40 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_42 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux299_syn_44 ;  // ../user_source/hdl_source/fat32_catalog.v(293)
  wire \u_catalog/mux323_syn_2620 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux325_syn_815 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux325_syn_828 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux325_syn_830 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux325_syn_832 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux325_syn_834 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux331_syn_349 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux332_syn_184 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux332_syn_271 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux332_syn_358 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_3556 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_3558 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_3560 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_3562 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_dup_3568 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_dup_3570 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_dup_3574 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_dup_3576 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux353_syn_dup_3580 ;  // ../user_source/hdl_source/fat32_catalog.v(141)
  wire \u_catalog/mux68_syn_45 ;  // ../user_source/hdl_source/fat32_catalog.v(201)
  wire \u_catalog/partition_found_reg_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/partition_found_reg_syn_7 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/partition_found_reg_syn_9 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/partition_found_reg_syn_11 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/partition_found_reg_syn_13 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/partition_found_reg_syn_15 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_6 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_8 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_10 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_12 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_14 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_16 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_19 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_22 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_24 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/ready_reg_syn_26 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/right_shift9_syn_83 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_103 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_109 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_115 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_121 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_127 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_133 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_139 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_145 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_151 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_157 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_163 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_169 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_175 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_181 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_187 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_193 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_199 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_205 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_211 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_217 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_223 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_229 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_235 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_241 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_693 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_698 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_701 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_704 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_755 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/right_shift9_syn_758 ;  // ../user_source/hdl_source/fat32_catalog.v(249)
  wire \u_catalog/root_end_marker_reg_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/rootent_fixed_valid_reg_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_6 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_8 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_10 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_12 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_14 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_17 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_20 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_22 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_24 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_26 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_28 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_30 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_32 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_36 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_38 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_40 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_42 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_44 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_46 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_48 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_50 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_52 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_54 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_57 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_59 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_62 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_64 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_66 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_70 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_72 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_74 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_76 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_78 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_80 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_83 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_85 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_87 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_89 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_91 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_93 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_95 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_97 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_99 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_101 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_104 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_106 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_110 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_112 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_114 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_116 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_118 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_120 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_122 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_124 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_126 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_128 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_130 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_132 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_134 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_136 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_138 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_140 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_142 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_144 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_147 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_149 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_151 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_153 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_155 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_157 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_159 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_162 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_164 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_166 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_168 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_170 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_172 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_174 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_176 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_178 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_180 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_182 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_184 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_186 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_188 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_190 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_192 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_194 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_196 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_198 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_200 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_202 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_204 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_206 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_208 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_210 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_212 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_214 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_217 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_219 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_222 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_224 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_228 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_230 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_232 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_234 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_236 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_238 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_240 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_242 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_244 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_246 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_248 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_251 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_253 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_255 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_257 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_259 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_261 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_263 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_265 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_267 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_269 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_271 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_273 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_275 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_278 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_280 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_282 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_284 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_286 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_288 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_290 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_292 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_294 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_296 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_298 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_300 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_303 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_305 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_307 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_309 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_311 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_313 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_315 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_317 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_321 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_323 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_325 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_327 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_329 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_331 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_333 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_336 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_338 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_340 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_342 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_344 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_346 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_348 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_350 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_353 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_356 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_358 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_360 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_362 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_364 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_366 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_368 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_370 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_372 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_374 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_376 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_378 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_380 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_383 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_385 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_387 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_389 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_391 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_394 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_396 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_398 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_400 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_402 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_404 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_407 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_409 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_411 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_413 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_415 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_417 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_420 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_422 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_424 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_426 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_428 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_431 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_433 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_435 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_437 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_439 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_441 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_443 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_445 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_447 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_449 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_451 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_454 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_456 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_458 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_460 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_462 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_464 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_466 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_468 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_471 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_473 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_475 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_477 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_479 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_481 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_483 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_485 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_487 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_489 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_491 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_494 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_496 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_498 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_500 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_502 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_504 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_506 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_508 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_511 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_515 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_517 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_519 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_521 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_523 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_525 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_527 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_529 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_531 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_533 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_535 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_537 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_543 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_545 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_548 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sd_read_reg_syn_550 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/state_reg_syn_dup_441 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/state_reg_syn_dup_444 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sub5_syn_143 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire \u_catalog/sub5_syn_147 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire \u_catalog/sub5_syn_151 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire \u_catalog/sub5_syn_155 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire \u_catalog/sub5_syn_159 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire \u_catalog/sub5_syn_163 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire \u_catalog/sub5_syn_167 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire \u_catalog/sub5_syn_171 ;  // ../user_source/hdl_source/fat32_catalog.v(77)
  wire \u_catalog/sub6_syn_165 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_167 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_169 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_171 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_173 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_175 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_177 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_179 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_181 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_183 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_185 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_187 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/sub6_syn_189 ;  // ../user_source/hdl_source/fat32_catalog.v(84)
  wire \u_catalog/version_fixed_valid_reg_syn_6 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/version_fixed_valid_reg_syn_8 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/video_name_match_reg_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/video_name_match_reg_syn_7 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/video_name_match_reg_syn_9 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/video_name_match_reg_syn_11 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/video_name_match_reg_syn_13 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/video_name_match_reg_syn_15 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/video_name_match_reg_syn_17 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/video_name_match_reg_syn_19 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/wav_name_match_reg_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/wav_name_match_reg_syn_7 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/wav_name_match_reg_syn_9 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/wav_name_match_reg_syn_11 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/wav_name_match_reg_syn_13 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/wav_name_match_reg_syn_15 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/sectors_per_cluster_shift[2]_dup_11 ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire \u_catalog/sectors_per_cluster_shift[2]_dup_12 ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire \u_catalog/sectors_per_cluster_shift[2]_dup_13 ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire \u_catalog/sectors_per_cluster_shift[1]_dup_10 ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire \u_catalog/sectors_per_cluster_shift[1]_dup_14 ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire \u_catalog/sectors_per_cluster_shift[0]_dup_11 ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire \u_catalog/sectors_per_cluster_shift[0]_dup_13 ;  // ../user_source/hdl_source/fat32_catalog.v(13)
  wire \u_catalog/sectors_per_cluster_shift_b1[1]_syn_2 ;
  wire \u_catalog/sectors_per_cluster_shift_b1[0]_syn_2 ;
  wire \u_catalog/sectors_per_cluster_shift_b1[0]_syn_4 ;
  wire \u_catalog/selected_size_b1[31]_syn_2 ;
  wire \u_catalog/selected_size_b1[23]_syn_2 ;
  wire \u_catalog/selected_size_b1[15]_syn_2 ;
  wire \u_catalog/selected_size_b1[7]_syn_2 ;
  wire \u_catalog/selected_start_b1[31]_syn_3 ;
  wire \u_catalog/selected_start_b1[31]_syn_5 ;
  wire \u_catalog/selected_start_b1[31]_syn_7 ;
  wire \u_catalog/selected_start_b1[23]_syn_2 ;
  wire \u_catalog/selected_start_b1[15]_syn_2 ;
  wire \u_catalog/selected_start_b1[7]_syn_2 ;
  wire \u_catalog/spc[7]_syn_24 ;  // ../user_source/hdl_source/fat32_catalog.v(31)
  wire \u_catalog/spc[7]_syn_dup_42 ;  // ../user_source/hdl_source/fat32_catalog.v(31)
  wire \u_catalog/bmp_clusters_b13_n_syn_2 ;
  wire \u_catalog/bmp_clusters_b8_n ;
  wire \u_catalog/bmp_name_match ;  // ../user_source/hdl_source/fat32_catalog.v(53)
  wire \u_catalog/bpb_header_candidate_n11 ;
  wire \u_catalog/bpb_header_candidate_n32 ;
  wire \u_catalog/bps_fixed_valid ;  // ../user_source/hdl_source/fat32_catalog.v(35)
  wire \u_catalog/bps_fixed_valid_n10 ;
  wire \u_catalog/byte_index_b15_n_syn_2 ;
  wire \u_catalog/byte_index_b15_n6 ;
  wire \u_catalog/byte_index_b15_n7 ;
  wire \u_catalog/byte_index_b17_n15 ;
  wire \u_catalog/byte_index_b17_n18 ;
  wire \u_catalog/byte_index_b17_n25 ;
  wire \u_catalog/byte_index_b17_n26 ;
  wire \u_catalog/byte_index_b3_n ;
  wire \u_catalog/byte_index_b9_n_syn_6 ;
  wire \u_catalog/byte_index_b9_n2 ;
  wire \u_catalog/byte_index_b9_n3 ;
  wire \u_catalog/dir_deleted ;  // ../user_source/hdl_source/fat32_catalog.v(53)
  wire \u_catalog/dir_first_zero ;  // ../user_source/hdl_source/fat32_catalog.v(53)
  wire \u_catalog/dir_skip ;  // ../user_source/hdl_source/fat32_catalog.v(53)
  wire \u_catalog/error ;  // ../user_source/hdl_source/fat32_catalog.v(11)
  wire \u_catalog/error_n15_syn_2 ;
  wire \u_catalog/fat16_fixed_valid ;  // ../user_source/hdl_source/fat32_catalog.v(37)
  wire \u_catalog/is_mbr ;  // ../user_source/hdl_source/fat32_catalog.v(44)
  wire \u_catalog/partition_found ;  // ../user_source/hdl_source/fat32_catalog.v(41)
  wire \u_catalog/ready ;  // ../user_source/hdl_source/fat32_catalog.v(11)
  wire \u_catalog/root_end_marker ;  // ../user_source/hdl_source/fat32_catalog.v(50)
  wire \u_catalog/root_end_marker_n1 ;
  wire \u_catalog/root_end_marker_n1_dup_1 ;
  wire \u_catalog/root_end_marker_n1_dup_2 ;
  wire \u_catalog/root_end_marker_n1_dup_3 ;
  wire \u_catalog/rootent_fixed_valid ;  // ../user_source/hdl_source/fat32_catalog.v(36)
  wire \u_catalog/sd_init_done ;  // ../user_source/hdl_source/fat32_catalog.v(8)
  wire \u_catalog/sd_read ;  // ../user_source/hdl_source/fat32_catalog.v(9)
  wire \u_catalog/version_fixed_valid ;  // ../user_source/hdl_source/fat32_catalog.v(38)
  wire \u_catalog/video_found ;  // ../user_source/hdl_source/fat32_catalog.v(17)
  wire \u_catalog/video_name_match ;  // ../user_source/hdl_source/fat32_catalog.v(54)
  wire \u_catalog/wav_found ;  // ../user_source/hdl_source/fat32_catalog.v(15)
  wire \u_catalog/wav_name_match ;  // ../user_source/hdl_source/fat32_catalog.v(53)
  wire \u_dynamic_text/add0_syn_46 ;  // ../user_source/hdl_source/player_dynamic_text.v(245)
  wire \u_dynamic_text/add0_syn_48 ;  // ../user_source/hdl_source/player_dynamic_text.v(245)
  wire \u_dynamic_text/add0_syn_50 ;  // ../user_source/hdl_source/player_dynamic_text.v(245)
  wire \u_dynamic_text/add0_syn_52 ;  // ../user_source/hdl_source/player_dynamic_text.v(245)
  wire \u_dynamic_text/add0_syn_54 ;  // ../user_source/hdl_source/player_dynamic_text.v(245)
  wire \u_dynamic_text/add5_syn_127 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_129 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_131 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_133 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_135 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_137 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_139 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_141 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_143 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_145 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_147 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add5_syn_149 ;  // ../user_source/hdl_source/player_dynamic_text.v(71)
  wire \u_dynamic_text/add6_syn_36 ;  // ../user_source/hdl_source/player_dynamic_text.v(87)
  wire \u_dynamic_text/add6_syn_52 ;  // ../user_source/hdl_source/player_dynamic_text.v(87)
  wire \u_dynamic_text/mux2_syn_73 ;  // ../user_source/hdl_source/player_dynamic_text.v(257)
  wire \u_dynamic_text/mux2_syn_95 ;  // ../user_source/hdl_source/player_dynamic_text.v(257)
  wire \u_dynamic_text/mux6_syn_83 ;  // ../user_source/hdl_source/player_dynamic_text.v(287)
  wire \u_dynamic_text/scroll_phase_b1[9]_syn_3 ;
  wire \u_dynamic_text/time_character[3]_syn_2 ;  // ../user_source/hdl_source/player_dynamic_text.v(242)
  wire \u_dynamic_text/in_scroll_box ;  // ../user_source/hdl_source/player_dynamic_text.v(309)
  wire \u_dynamic_text/in_scroll_box_n3 ;
  wire \u_dynamic_text/in_time_box ;  // ../user_source/hdl_source/player_dynamic_text.v(307)
  wire \u_dynamic_text/minute_ones_b_n ;
  wire \u_dynamic_text/scroll_phase_b1_n ;
  wire \u_file_mapper/active_client_reg_syn_3 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/add0_syn_40 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(346)
  wire \u_file_mapper/add0_syn_44 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(346)
  wire \u_file_mapper/add0_syn_48 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(346)
  wire \u_file_mapper/add0_syn_56 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(346)
  wire \u_file_mapper/add0_syn_64 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(346)
  wire \u_file_mapper/add1_syn_38 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(347)
  wire \u_file_mapper/add1_syn_42 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(347)
  wire \u_file_mapper/add1_syn_50 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(347)
  wire \u_file_mapper/add1_syn_58 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(347)
  wire \u_file_mapper/add1_syn_66 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(347)
  wire \u_file_mapper/add1_syn_70 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(347)
  wire \u_file_mapper/add12_syn_40 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(292)
  wire \u_file_mapper/add12_syn_44 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(292)
  wire \u_file_mapper/add2_syn_134 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_136 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_138 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_140 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_142 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_144 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_146 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_148 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_150 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_152 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_154 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_156 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add2_syn_158 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_134 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_136 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_138 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_140 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_142 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_144 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_146 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_148 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_150 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_152 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_154 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_156 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add3_syn_158 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(390)
  wire \u_file_mapper/add5_syn_119 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_121 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_123 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_125 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_127 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_129 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_131 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_133 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_135 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_137 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_139 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add5_syn_141 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(107)
  wire \u_file_mapper/add7_syn_3 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_153 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_157 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_161 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_165 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_169 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_173 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_177 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_181 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add7_syn_185 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(109)
  wire \u_file_mapper/add8_syn_146 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire \u_file_mapper/add8_syn_150 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire \u_file_mapper/add8_syn_154 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire \u_file_mapper/add8_syn_158 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire \u_file_mapper/add8_syn_162 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire \u_file_mapper/add8_syn_166 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire \u_file_mapper/add8_syn_170 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire \u_file_mapper/add8_syn_174 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(114)
  wire \u_file_mapper/core_state_reg_syn_dup_238 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg_syn_dup_239 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg_syn_dup_240 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/eq10_syn_148 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(233)
  wire \u_file_mapper/eq3_syn_115 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(342)
  wire \u_file_mapper/eq3_syn_116 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(342)
  wire \u_file_mapper/eq3_syn_136 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(342)
  wire \u_file_mapper/eq4_syn_61 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(347)
  wire \u_file_mapper/eq9_syn_173 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(232)
  wire \u_file_mapper/left_shift1_syn_138 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_146 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_170 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_178 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_180 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_186 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_188 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_194 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_196 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_202 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_204 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_210 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_212 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_218 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_220 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_226 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_228 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_234 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_236 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_242 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_244 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_250 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_252 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_258 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_260 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_266 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_268 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_274 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_276 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_282 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_284 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_290 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_292 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_298 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_300 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_306 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_308 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_314 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_316 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_322 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_324 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_330 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_332 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_338 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_340 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_348 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_356 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_364 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_372 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_380 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_388 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_396 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_477 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_484 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/left_shift1_syn_488 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/lt11_syn_219 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(227)
  wire \u_file_mapper/lt11_syn_231 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(227)
  wire \u_file_mapper/lt11_syn_244 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(227)
  wire \u_file_mapper/lt11_syn_256 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(227)
  wire \u_file_mapper/lt12_syn_233 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/lt4_syn_200 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(340)
  wire \u_file_mapper/lt4_syn_250 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(340)
  wire \u_file_mapper/lt5_syn_189 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(375)
  wire \u_file_mapper/lt6_syn_192 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(375)
  wire \u_file_mapper/lt8_syn_221 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(221)
  wire \u_file_mapper/lt9_syn_186 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(223)
  wire \u_file_mapper/lt9_syn_196 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(223)
  wire \u_file_mapper/mux100_syn_38 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(275)
  wire \u_file_mapper/mux150_syn_59 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_61 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_63 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_65 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_67 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_69 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_71 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_73 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_75 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_77 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_79 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_81 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_83 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_85 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_87 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_89 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_91 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_93 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_95 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_97 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_99 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_101 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_103 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_105 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_107 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_109 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_111 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux150_syn_113 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_31 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_33 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_35 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_37 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_39 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_41 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_43 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_45 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_47 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_49 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_51 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux152_syn_53 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_29 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_31 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_33 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_35 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_37 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_39 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_41 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_43 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_45 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_47 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_49 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_51 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux153_syn_53 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux156_syn_67 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(213)
  wire \u_file_mapper/mux171_syn_52 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux171_syn_68 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_124 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_127 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_129 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_131 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_133 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_135 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_137 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_139 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_141 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_143 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_147 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_149 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_151 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_153 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_155 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_157 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_159 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_161 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_163 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_165 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_167 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_170 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_174 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_178 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_182 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_186 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_190 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_194 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_198 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_202 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_206 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_210 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_214 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_216 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_222 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_224 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_226 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_228 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_230 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_232 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_234 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_236 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_239 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_241 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_243 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_245 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_247 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_249 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_251 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_255 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_257 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_259 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_261 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_263 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_266 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_268 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_270 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_272 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_274 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_277 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_279 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_281 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_283 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_285 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_287 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_289 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_291 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_293 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_295 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_298 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_300 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_303 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_305 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_307 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_310 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_312 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_314 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_316 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_319 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_321 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_323 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_325 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_327 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_330 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_332 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_334 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_336 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_338 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_340 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_342 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_344 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_346 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_349 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_351 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_353 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_355 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_357 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_359 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_361 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_363 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_365 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_367 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_370 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_372 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_374 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_376 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_378 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_380 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_382 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_384 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_386 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_388 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_390 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_392 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_394 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_396 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_398 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_400 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_402 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_404 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_406 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_408 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_410 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_413 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_415 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_417 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_419 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_421 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_423 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_425 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_427 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_429 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_432 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_434 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_436 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_438 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_440 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_442 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_444 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_446 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_448 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_450 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_452 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_454 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_456 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_458 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_460 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_462 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_464 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_466 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_468 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_470 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_472 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_474 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_476 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_478 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_480 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_482 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_484 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_486 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_489 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_491 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_493 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_495 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_497 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_499 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_501 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_503 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_505 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_507 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_509 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_512 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_514 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_516 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_518 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_520 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_522 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_524 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_526 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_528 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_530 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_532 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_534 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_536 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_538 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_540 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_543 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_545 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_547 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_549 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_551 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_553 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_555 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_557 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_559 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_561 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_563 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_565 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_568 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_570 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_572 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_574 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_576 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_578 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_581 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_584 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_586 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_588 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_590 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_592 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_595 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_597 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_599 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_601 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_603 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_605 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_607 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_609 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_611 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_613 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_615 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_617 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_619 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_621 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_623 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_625 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_627 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_629 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_631 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_633 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_635 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_637 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_639 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_641 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_644 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_646 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_648 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux179_syn_651 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux180_syn_60 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux180_syn_62 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux181_syn_17 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux186_syn_22 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux187_syn_21 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux188_syn_21 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux194_syn_125 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(198)
  wire \u_file_mapper/mux212_syn_82 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(368)
  wire \u_file_mapper/mux215_syn_42 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(393)
  wire \u_file_mapper/mux215_syn_88 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(393)
  wire \u_file_mapper/mux215_syn_90 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(393)
  wire \u_file_mapper/mux215_syn_95 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(393)
  wire \u_file_mapper/mux215_syn_97 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(393)
  wire \u_file_mapper/mux222_syn_34 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(200)
  wire \u_file_mapper/mux230_syn_34 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(112)
  wire \u_file_mapper/mux238_syn_103 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(366)
  wire \u_file_mapper/mux239_syn_103 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(366)
  wire \u_file_mapper/mux459_syn_33 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(295)
  wire \u_file_mapper/mux470_syn_16 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(323)
  wire \u_file_mapper/mux72_syn_31 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(328)
  wire \u_file_mapper/right_shift3_syn_100 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_106 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_108 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_114 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_116 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_122 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_124 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_130 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_132 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_138 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_140 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_146 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_148 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_154 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_156 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_162 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_164 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_170 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_172 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_178 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_180 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_186 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/right_shift3_syn_188 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(234)
  wire \u_file_mapper/sd_read_i19_syn_3 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(322)
  wire \u_file_mapper/sd_read_reg_syn_6 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/sub0_syn_165 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_167 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_169 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_171 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_173 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_175 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_177 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_179 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_181 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_183 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_185 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_187 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/sub0_syn_189 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(110)
  wire \u_file_mapper/walk_initialized_i2_syn_7 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(368)
  wire \u_file_mapper/wav_error_reg_syn_5 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/wav_error_reg_syn_7 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/wav_error_reg_syn_9 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/bmp_error_b[0]_syn_2 ;
  wire \u_file_mapper/brent_anchor[0]_b30[0]_syn_2 ;
  wire \u_file_mapper/data_addr_tmp_b1[5]_syn_2 ;
  wire \u_file_mapper/data_addr_tmp_b1[5]_syn_4 ;
  wire \u_file_mapper/walk_index[0]_b1[9]_syn_5 ;
  wire \u_file_mapper/walk_index[0]_b1[8]_syn_2 ;
  wire \u_file_mapper/walk_index[0]_b1[7]_syn_2 ;
  wire \u_file_mapper/walk_index[0]_b1[4]_syn_2 ;
  wire \u_file_mapper/walk_index[0]_b1[4]_syn_5 ;
  wire \u_file_mapper/walk_index[0]_b1[3]_syn_2 ;
  wire \u_file_mapper/walk_index[0]_b1[3]_syn_4 ;
  wire \u_file_mapper/walk_index[0]_b1[2]_syn_2 ;
  wire \u_file_mapper/active_client ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(66)
  wire \u_file_mapper/active_client_dup_47 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(66)
  wire \u_file_mapper/active_client_dup_50 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(66)
  wire \u_file_mapper/active_client_dup_51 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(66)
  wire \u_file_mapper/active_client_dup_55 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(66)
  wire \u_file_mapper/active_client_dup_57 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(66)
  wire \u_file_mapper/active_client_dup_58 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(66)
  wire \u_file_mapper/active_client_dup_59 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(66)
  wire \u_file_mapper/bmp_error ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(19)
  wire \u_file_mapper/bmp_error_n16_syn_2 ;
  wire \u_file_mapper/bmp_error_n29_syn_14 ;
  wire \u_file_mapper/bmp_error_n39 ;
  wire \u_file_mapper/bmp_error_n59_syn_12 ;
  wire \u_file_mapper/bmp_error_n83 ;
  wire \u_file_mapper/bmp_error_n87 ;
  wire \u_file_mapper/bmp_file_end_n_syn_2 ;
  wire \u_file_mapper/bmp_file_end_n11_syn_4 ;
  wire \u_file_mapper/bmp_file_valid_n_syn_2 ;
  wire \u_file_mapper/brent_anchor[0]_b22_n ;
  wire \u_file_mapper/core_state_b12_n ;
  wire \u_file_mapper/core_state_b19_n ;
  wire \u_file_mapper/gap_was_fat ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(69)
  wire \u_file_mapper/rst_dup_11 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_13 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_14 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_15 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_16 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_17 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_19 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_22 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_23 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_24 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_26 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_27 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_29 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_31 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_34 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_35 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_37 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_39 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_41 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_45 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_47 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_52 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_58 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_59 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_60 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_61 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_62 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_64 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_65 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_67 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_68 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_69 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_72 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_73 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_74 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_78 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_79 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_83 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_84 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_86 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_87 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_88 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_90 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_91 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_92 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_93 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_97 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_99 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_100 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_101 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_102 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_104 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_105 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_106 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_107 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_108 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/rst_dup_109 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(11)
  wire \u_file_mapper/sd_read ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(29)
  wire \u_file_mapper/sd_read_n1 ;
  wire \u_file_mapper/sectors_needed_b_n ;
  wire \u_file_mapper/sectors_needed_b_n_syn_2 ;
  wire \u_file_mapper/wav_error ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(26)
  wire \u_file_mapper/wav_file_end_n_syn_2 ;
  wire \u_file_mapper/wav_file_end_n_syn_4 ;
  wire \u_file_mapper/wav_file_read ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(23)
  wire \u_file_mapper/wav_file_valid_n_syn_2 ;
  wire \u_frame_buffer/photo_write_en ;  // ../user_source/hdl_source/frame_buffer_rgb888.v(61)
  wire \u_frame_buffer/read_pixel_en ;  // ../user_source/hdl_source/frame_buffer_rgb888.v(33)
  wire \u_frame_buffer/read_req ;  // ../user_source/hdl_source/frame_buffer_rgb888.v(26)
  wire \u_frame_buffer/video_write_en ;  // ../user_source/hdl_source/frame_buffer_rgb888.v(61)
  wire \u_frame_buffer/write_pixel_ready_n1 ;
  wire \u_frame_buffer/write_req ;  // ../user_source/hdl_source/frame_buffer_rgb888.v(17)
  wire \u_frame_buffer/u_legacy_frame_backend/lt0_syn_67 ;  // ../user_source/hdl_source/SD/frame_read_write.v(108)
  wire \u_frame_buffer/u_legacy_frame_backend/Sdr_init_done ;  // ../user_source/hdl_source/SD/frame_read_write.v(20)
  wire \u_frame_buffer/u_legacy_frame_backend/Sdr_rd_en ;  // ../user_source/hdl_source/SD/frame_read_write.v(34)
  wire \u_frame_buffer/u_legacy_frame_backend/read_en ;  // ../user_source/hdl_source/SD/frame_read_write.v(47)
  wire \u_frame_buffer/u_legacy_frame_backend/read_en_syn_4 ;  // ../user_source/hdl_source/SD/frame_read_write.v(47)
  wire \u_frame_buffer/u_legacy_frame_backend/read_en_syn_8 ;  // ../user_source/hdl_source/SD/frame_read_write.v(47)
  wire \u_frame_buffer/u_legacy_frame_backend/read_en_syn_17 ;  // ../user_source/hdl_source/SD/frame_read_write.v(47)
  wire \u_frame_buffer/u_legacy_frame_backend/read_fifo_clear ;  // ../user_source/hdl_source/SD/frame_read_write.v(50)
  wire \u_frame_buffer/u_legacy_frame_backend/write_en ;  // ../user_source/hdl_source/SD/frame_read_write.v(80)
  wire \u_frame_buffer/u_legacy_frame_backend/write_fifo_clear ;  // ../user_source/hdl_source/SD/frame_read_write.v(51)
  wire \u_frame_buffer/u_legacy_frame_backend/write_fifo_full ;  // ../user_source/hdl_source/SD/frame_read_write.v(96)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add0_syn_38 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(243)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add0_syn_54 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(243)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add0_syn_62 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(243)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add2_syn_39 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(132)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add2_syn_43 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(132)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_108 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_110 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_112 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_114 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_116 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_118 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_120 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_122 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_124 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/add3_syn_126 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_153 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_156 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_158 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_160 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_163 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_165 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_167 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_170 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_172 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_174 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel2_syn_176 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/sel4_syn_310 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(176)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/App_rd_en_r ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(68)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mem_clk ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(13)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/rd_burst_finish ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(67)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_req_d0 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(54)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_req_d1 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(55)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/read_req_d2 ;  // ../user_source/hdl_source/SD/frame_fifo_read.v(56)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add0_syn_53 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(179)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add0_syn_57 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(179)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add0_syn_73 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(179)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add0_syn_89 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(179)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_108 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_110 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_112 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_114 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_116 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_118 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_120 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_122 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_124 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add1_syn_126 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(180)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_102 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_104 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_106 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_108 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_110 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_112 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_114 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_116 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_118 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add3_syn_120 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(189)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_97 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_99 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_101 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_103 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_105 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_107 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_109 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_111 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add5_syn_113 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(284)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_111 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_113 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_115 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_117 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_119 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_121 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_123 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_125 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add6_syn_127 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(87)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add7_syn_39 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(152)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add7_syn_43 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(152)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/mux7_syn_51 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(156)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/sel2_syn_175 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(216)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/sel2_syn_178 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(216)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/sel2_syn_181 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(216)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/sel2_syn_185 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(216)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/sel2_syn_187 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(216)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/sel2_syn_189 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(216)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/sel4_syn_411 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(216)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/wr_x_b[8]_syn_2 ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/wr_x_b[8]_syn_4 ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_6 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(42)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_9 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(42)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_11 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(42)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_12 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(42)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_13 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(42)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_14 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(42)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_15 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(42)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_addr_r_b4_n ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(22)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en_d0_n3_syn_3 ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en_d0_n3_syn_5 ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en_d0_n3_syn_7 ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en_d0_n3_syn_9 ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en_d0_n3_syn_11 ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/App_wr_en_r ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(81)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/Sdr_busy ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(18)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/Sdr_init_ref_vld ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(17)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/debug_req_sync ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(34)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/into_burst_n7 ;
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/jpeg_mode_latch ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(86)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_req_d0 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(65)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_req_d1 ;  // ../user_source/hdl_source/SD/frame_fifo_write.v(66)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add5_syn_33 ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add5_syn_105 ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add5_syn_107 ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add5_syn_109 ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add5_syn_111 ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add5_syn_113 ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add5_syn_115 ;  // ../user_source/hdl_source/jpeg420_word_address.v(21)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/add7_syn_36 ;  // ../user_source/hdl_source/jpeg420_word_address.v(22)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/mux15_syn_15 ;  // ../user_source/hdl_source/jpeg420_word_address.v(26)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/add0_syn_42 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(120)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/add1_syn_42 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(131)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/sub0_syn_40 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/sub0_syn_42 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/sub0_syn_44 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/sub0_syn_46 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/sub1_syn_40 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(149)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/sub1_syn_42 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(149)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/sub1_syn_44 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(149)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/sub1_syn_46 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(149)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/asy_r_rst0 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(47)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/asy_w_rst0 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(45)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/rd_en_s ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(56)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/rd_en_s_syn_2 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(56)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/wr_en_s ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(55)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/wr_en_s_syn_2 ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(55)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/ram_inst/rsta ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(376)
  wire \u_frame_buffer/u_legacy_frame_backend/read_buf/ram_inst/rstb ;  // ../user_source/hdl_source/ip/afifo_32_16_256.v(383)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/add0_syn_42 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(120)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/add1_syn_26 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(131)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/add1_syn_42 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(131)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/sub0_syn_40 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/sub0_syn_42 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/sub0_syn_44 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/sub0_syn_46 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(148)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/sub1_syn_40 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(149)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/sub1_syn_42 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(149)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/sub1_syn_44 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(149)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/sub1_syn_46 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(149)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_addr_b[8]_syn_3 ;
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/asy_r_rst0 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(47)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/asy_w_rst0 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(45)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/rd_en_s ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(56)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/wr_en_s ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(55)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/wr_en_s_syn_2 ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(55)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/ram_inst/rsta ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(376)
  wire \u_frame_buffer/u_legacy_frame_backend/write_buf/ram_inst/rstb ;  // ../user_source/hdl_source/ip/afifo_16_32_256.v(383)
  wire \u_frame_buffer/u_pack/word_en_reg_syn_5 ;  // ../user_source/hdl_source/rgb888_word_codec.v(18)
  wire \u_frame_buffer/u_pack/word_data_b3[26]_syn_3 ;
  wire \u_frame_buffer/u_pack/word_data_b3[26]_syn_5 ;
  wire \u_frame_buffer/u_pack/word_data_b3[25]_syn_2 ;
  wire \u_frame_buffer/u_pack/word_data_b3[25]_syn_4 ;
  wire \u_frame_buffer/u_pack/word_data_b3[25]_syn_6 ;
  wire \u_frame_buffer/u_pack/word_data_b3[24]_syn_2 ;
  wire \u_frame_buffer/u_pack/word_data_b3[24]_syn_4 ;
  wire \u_frame_buffer/u_pack/word_data_b3[24]_syn_6 ;
  wire \u_frame_buffer/u_pack/carry_b_n_dup_1 ;
  wire \u_frame_buffer/u_pack/carry_b_n_dup_3 ;
  wire \u_frame_buffer/u_pack/pixel_en ;  // ../user_source/hdl_source/rgb888_word_codec.v(10)
  wire \u_frame_buffer/u_pack/rst ;  // ../user_source/hdl_source/rgb888_word_codec.v(8)
  wire \u_frame_buffer/u_sdram/App_rd_en  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(37)
  wire \u_frame_buffer/u_sdram/u2_ram/SDRAM_CLK  /* synthesis keep=true */ ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(35)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[18]_syn_2 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_2 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_6 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_8 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_10 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_13 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_15 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_17 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_19 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_21 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_rd_addr[15]_syn_24 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(30)
  wire \u_frame_buffer/u_sdram/u2_ram/App_wr_addr[18]_syn_2 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(25)
  wire \u_frame_buffer/u_sdram/u2_ram/App_wr_addr[17]_syn_2 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(25)
  wire \u_frame_buffer/u_sdram/u2_ram/App_wr_addr[17]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(25)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_92 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_94 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_96 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_98 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_100 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_102 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_104 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_106 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/add1_syn_108 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/ref_vld_reg_syn_7 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(122)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_init_ref_cas ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(32)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_init_ref_ras ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(31)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_init_ref_we ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(33)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/Sdr_ref_ack ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(27)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/cas_n3 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/init_vld ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(44)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/power_up_200ms_1d ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(40)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/power_up_200ms_2d ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(40)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/power_up_en ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(40)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/ref_vld ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(47)
  wire \u_frame_buffer/u_sdram/u2_ram/u1_init_ref/sdr_init_en ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(42)
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/rw_vld_reg_syn_7 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_reg_syn_5 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sel2_syn_92 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/SDR_CAS_n ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/SDR_RAS_n ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/SDR_WE_n ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/active_en ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/cas ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/col_en ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/init_ref_vld_1d ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ras ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ref_ack ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ref_over ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/ref_vld ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/rw_vld ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/rw_vld_1d ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_op_over ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_6 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_7 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_8 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_11 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_12 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_16 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_19 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_21 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_22 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_23 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_dup_25 ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/we ;
  wire \u_frame_buffer/u_sdram/u2_ram/u2_wrrd/wrrd_ref_ack ;
  wire \u_frame_buffer/u_unpack/lt0_syn_20 ;  // ../user_source/hdl_source/rgb888_word_codec.v(106)
  wire \u_frame_buffer/u_unpack/mux0_syn_195 ;  // ../user_source/hdl_source/rgb888_word_codec.v(95)
  wire \u_frame_buffer/u_unpack/byte_count[0]_dup_25 ;  // ../user_source/hdl_source/rgb888_word_codec.v(73)
  wire \u_frame_buffer/u_unpack/byte_count[0]_dup_27 ;  // ../user_source/hdl_source/rgb888_word_codec.v(73)
  wire \u_frame_buffer/u_unpack/merged[31]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[31]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[30]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[30]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[30]_syn_6 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[30]_syn_8 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[30]_syn_10 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[30]_syn_12 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[29]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[29]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[29]_syn_6 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[28]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[28]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[27]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[27]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[26]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[26]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[25]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[25]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[24]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[24]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[23]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[23]_syn_5 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[22]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[21]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[20]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[20]_syn_5 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[19]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[19]_syn_5 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[18]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[18]_syn_5 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[17]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[17]_syn_5 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[16]_syn_2 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[16]_syn_5 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[15]_syn_4 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[15]_syn_6 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[14]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[14]_syn_5 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[13]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[12]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[11]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[10]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[9]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/merged[8]_syn_3 ;  // ../user_source/hdl_source/rgb888_word_codec.v(75)
  wire \u_frame_buffer/u_unpack/byte_count_b_n ;
  wire \u_frame_buffer/u_unpack/pop_pending ;  // ../user_source/hdl_source/rgb888_word_codec.v(74)
  wire \u_frame_buffer/u_unpack/word_pop ;  // ../user_source/hdl_source/rgb888_word_codec.v(67)
  wire \u_frame_buffer/u_video_pack/first_pixel_valid ;  // ../user_source/hdl_source/rgb565_word_codec.v(12)
  wire \u_frame_buffer/u_video_unpack/mux0_syn_131 ;  // ../user_source/hdl_source/rgb565_word_codec.v(73)
  wire \u_frame_buffer/u_video_unpack/merged[31]_syn_3 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[31]_syn_5 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[31]_syn_7 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[15]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[14]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[13]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[12]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[11]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[10]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[9]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[8]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[7]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[6]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[5]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[4]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[3]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[2]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[1]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/merged[0]_syn_2 ;  // ../user_source/hdl_source/rgb565_word_codec.v(54)
  wire \u_frame_buffer/u_video_unpack/pop_pending ;  // ../user_source/hdl_source/rgb565_word_codec.v(53)
  wire \u_frame_buffer/u_video_unpack/word_pop ;  // ../user_source/hdl_source/rgb565_word_codec.v(47)
  wire \u_frame_buffer/u_wipe_address/lt0_syn_176 ;  // ../user_source/hdl_source/player_wipe_address.v(46)
  wire \u_frame_buffer/u_wipe_address/ack_prev ;  // ../user_source/hdl_source/player_wipe_address.v(24)
  wire \u_frame_buffer/u_wipe_address/active ;  // ../user_source/hdl_source/player_wipe_address.v(24)
  wire \u_frame_buffer/u_wipe_address/active_n2 ;
  wire \u_frame_buffer/u_wipe_address/active_s0 ;  // ../user_source/hdl_source/player_wipe_address.v(21)
  wire \u_frame_buffer/u_wipe_address/active_s1 ;  // ../user_source/hdl_source/player_wipe_address.v(21)
  wire \u_frame_buffer/u_wipe_address/mapped_addr_b_n ;
  wire \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk ;  // ../user_source/hdl_source/lane_lvds_10_1.v(8)
  wire \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_load_en ;  // ../user_source/hdl_source/lane_lvds_10_1.v(19)
  wire \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_load_en_1d ;  // ../user_source/hdl_source/lane_lvds_10_1.v(20)
  wire \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_load_en_2d ;  // ../user_source/hdl_source/lane_lvds_10_1.v(21)
  wire \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_odd_even_1d ;  // ../user_source/hdl_source/lane_lvds_10_1.v(17)
  wire \u_hdmi2phy_wrapper/u0_lane_lvds_8_1/S_odd_even_2d ;  // ../user_source/hdl_source/lane_lvds_10_1.v(18)
  wire \u_hdmi_1_4b_transmitter_core_wrapper/I_axis_s_user ;  // ../user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v(37)
  wire \u_hdmi_1_4b_transmitter_core_wrapper/O_video_locked ;  // ../user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v(60)
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u0_reset_sync/S_sync_reset_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_9 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_10 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_16 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_17 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_18 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_23 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_24 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_26 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_29 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_33 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_34 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_36 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/S_island_guard_band_valid ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/S_island_valid ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/S_video_guard_band_valid ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/S_video_valid ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/add0_syn_50 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/add18_syn_30 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux12_syn_11 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux12_syn_13 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux12_syn_19 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux12_syn_21 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux12_syn_27 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux13_syn_15 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux13_syn_17 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux13_syn_23 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux13_syn_25 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/mux13_syn_29 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_0_q_m_0_7_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_1_D_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_1_D_b[2]_syn_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_N_1_q_m_0_7_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_3 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_8 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_10 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_12 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_14 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_16 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_19 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_21 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_23 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_code_b[3]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_cnt_t_1_b2_n2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_guard_band_code_b1_n ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_guard_band_code_b2_n ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_data_island_guard_band_code_b3_n1 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_island_guard_valid_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_island_guard_valid_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_island_guard_valid_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_island_guard_valid_4d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_island_valid_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_island_valid_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_island_valid_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_island_valid_4d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_guard_valid_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_guard_valid_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_guard_valid_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_guard_valid_4d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_valid_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_valid_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_valid_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u0_hdmi_tmds_encode/S_video_valid_4d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/add0_syn_50 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/add18_syn_46 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/add18_syn_50 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/mux8_syn_200 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/O_tmds_code_data_b[8]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/O_tmds_code_data_b[7]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/O_tmds_code_data_b[6]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/O_tmds_code_data_b[5]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_0_q_m_0_7_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_1_D_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_1_D_b[2]_syn_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_N_1_q_m_0_7_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_3 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_10 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_13 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_15 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_17 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_19 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_21 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_23 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b[1]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u1_hdmi_tmds_encode/S_cnt_t_1_b2_n2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/add0_syn_50 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/add18_syn_30 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/mux8_syn_200 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/O_tmds_code_data_b[8]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/O_tmds_code_data_b[7]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/O_tmds_code_data_b[6]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/O_tmds_code_data_b[6]_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/O_tmds_code_data_b[5]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/O_tmds_code_data_b[3]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_0_q_m_0_7_b[3]_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_0_q_m_0_7_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_1_D_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_1_D_b[2]_syn_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_N_1_q_m_0_7_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_7 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_10 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_12 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_14 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_16 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_19 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_21 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[4]_syn_23 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b[2]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u2_hdmi_tmds_encode/S_cnt_t_1_b2_n2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_island_guard_band ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_island_period ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_island_preamble ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_video_guard_band ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_video_hsync ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_video_period ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_video_preamble ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_data_distribution/I_video_vsync ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_hsync ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_island_guard_band ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_island_period ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_island_preamble ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_video_guard_band ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_video_period ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_video_preamble ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/I_vsync ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_hsync_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_hsync_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_hsync_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_guard_band_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_guard_band_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_guard_band_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_1d_dup_9 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_1d_dup_10 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_1d_dup_11 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_2d_dup_1 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_2d_dup_3 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_2d_dup_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_2d_dup_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_2d_dup_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_2d_dup_8 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_packet_req_2d_dup_9 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_period_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_period_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_period_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_preamble_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_preamble_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_island_preamble_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_guard_band_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_guard_band_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_guard_band_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_period_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_period_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_period_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_preamble_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_preamble_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_video_preamble_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_vsync_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_vsync_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_assemble/S_vsync_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel0_syn_464 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel0_syn_dup_847 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel0_syn_dup_848 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel1_syn_931 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel4_syn_1669 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel4_syn_1671 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel4_syn_1673 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/sel4_syn_1676 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/S_packet_cnt[3]_syn_110 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/I_island_packet_req ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/S_acr_packet_valid ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/S_audio_sample_packet_valid ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/add48_syn_40 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_14 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_16 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_18 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_20 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_22 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_27 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[54]_syn_12 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[50]_syn_12 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/I_audio_sample_packet_req_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/O_audio_fifo_empty ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_audio_frame_start ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_audio_valid_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_1 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_3 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_7 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_8 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_9 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_10 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_11 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_12 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_13 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_14 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_15 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_16 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_17 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_18 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_19 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_20 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_21 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_22 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_23 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_24 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_25 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_26 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_27 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_28 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_29 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_30 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_31 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_32 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_33 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_45 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_46 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_47 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_48 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_49 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_50 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_51 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_52 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_53 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_54 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_55 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_78 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_79 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_80 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_81 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_82 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_83 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_84 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_85 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_86 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_87 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_88 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_253 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/u_logic_ramfifo_syn_255 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/I_fifo_wr_en ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/u_w96_d1024_fifo/I_fifo_wr_en_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[55]_syn_15 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[55]_syn_17 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[54]_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[53]_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[52]_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[51]_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[51]_syn_8 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[50]_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_packet_body[50]_syn_8 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/O_BCH_block_0_b_n ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_acr_pakcet_req ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_acr_req_wait_en ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_acr_valid_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_acr_valid_2d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/u_audio_clock_regeneration_packet/S_acr_valid_3d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_hsync ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_island_guard_band ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_island_period ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_island_preamble ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_video_guard_band ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_video_preamble ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/I_vsync ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/S_hsync_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/S_island_guard_band_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/S_island_period_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/S_island_preamble_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/S_video_guard_band_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/S_video_period_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/S_video_preamble_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_data_assemble/S_vsync_1d ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/add0_syn_48 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/add0_syn_68 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/add1_syn_52 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/add1_syn_72 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/lt4_syn_92 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_col_cnt_b3[9]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_col_cnt_b3[8]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_line_cnt_b3[9]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_line_cnt_b3[9]_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_line_cnt_b4[13]_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_island_period_n2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_island_period_n2_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_guard_band_n2_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_guard_band_n2_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_guard_band_n2_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_guard_band_n2_syn_8 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_guard_band_n2_syn_10 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_guard_band_n2_syn_12 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_sof_n2_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_sof_n2_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/O_video_sol_n2_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_line_cnt_b1_n ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_video_source/S_line_cnt_b3_n ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/I_video_source_sof ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/I_video_source_sol ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/O_video_source_pause ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_1 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_2 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_3 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_4 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_5 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_6 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_7 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_8 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_9 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_10 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_11 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_12 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_13 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_14 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_15 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_16 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_17 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_18 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_19 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_20 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_21 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_22 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_23 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_24 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_25 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_26 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_27 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_28 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_29 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_30 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_31 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_32 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_33 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_45 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_46 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_47 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_48 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_49 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_50 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_51 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_52 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_53 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_54 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_55 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_78 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_79 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_80 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_81 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_82 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_83 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_84 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_85 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_86 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_87 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_88 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_181 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/u_logic_ramfifo_syn_183 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/I_fifo_rd_en ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/I_fifo_rd_en_syn_8 ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/u_w24_d1024_fifo/I_rst ;
  wire \u_jpeg_core/rst_i_dup_46 ;  // ../user_source/hdl_source/jpeg/jpeg_core.v(48)
  wire \u_jpeg_core/rst_i_dup_48 ;  // ../user_source/hdl_source/jpeg/jpeg_core.v(48)
  wire \u_jpeg_core/rst_i_dup_49 ;  // ../user_source/hdl_source/jpeg/jpeg_core.v(48)
  wire \u_jpeg_core/rst_i_dup_52 ;  // ../user_source/hdl_source/jpeg/jpeg_core.v(48)
  wire \u_jpeg_core/rst_i_dup_53 ;  // ../user_source/hdl_source/jpeg/jpeg_core.v(48)
  wire \u_jpeg_core/rst_i_dup_54 ;  // ../user_source/hdl_source/jpeg/jpeg_core.v(48)
  wire \u_jpeg_core/u_jpeg_bitbuffer/add1_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(109)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_88 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_92 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_102 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_108 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_114 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_120 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_126 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_132 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_144 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_156 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_168 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_174 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_180 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_186 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_192 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_198 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_204 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_210 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_216 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_222 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_228 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_234 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_240 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_246 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_252 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_258 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/left_shift1_syn_1004 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(137)
  wire \u_jpeg_core/u_jpeg_bitbuffer/lt0_syn_33 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(114)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_29 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_39 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_53 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_55 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_67 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_69 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_81 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_83 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_95 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_97 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_109 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_111 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_119 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_127 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_135 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_143 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_151 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_159 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_167 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_175 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_183 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_191 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_199 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_207 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_215 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_223 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_231 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/mux21_syn_299 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(125)
  wire \u_jpeg_core/u_jpeg_bitbuffer/sub0_syn_44 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(76)
  wire \u_jpeg_core/u_jpeg_bitbuffer/count_r[6]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(65)
  wire \u_jpeg_core/u_jpeg_bitbuffer/count_r[6]_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(65)
  wire \u_jpeg_core/u_jpeg_bitbuffer/count_r[6]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(65)
  wire \u_jpeg_core/u_jpeg_bitbuffer/count_r[6]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(65)
  wire \u_jpeg_core/u_jpeg_bitbuffer/count_r[6]_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(65)
  wire \u_jpeg_core/u_jpeg_bitbuffer/count_r[6]_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(65)
  wire \u_jpeg_core/u_jpeg_bitbuffer/count_r[6]_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(65)
  wire \u_jpeg_core/u_jpeg_bitbuffer/rd_ptr_q[4]_dup_1 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(57)
  wire \u_jpeg_core/u_jpeg_bitbuffer/rd_ptr_q[4]_dup_2 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(57)
  wire \u_jpeg_core/u_jpeg_bitbuffer/count_r_b_n ;
  wire \u_jpeg_core/u_jpeg_bitbuffer/drain_q ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(60)
  wire \u_jpeg_core/u_jpeg_bitbuffer/img_start_i ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(37)
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_8 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_10 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_12 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_14 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_16 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[7]_syn_18 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_8 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_10 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_12 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_14 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_16 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_18 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_20 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[6]_syn_22 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_3 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_5 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_7 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_9 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_11 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_13 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_15 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_17 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_19 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_22 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_24 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_26 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_28 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_30 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_32 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_34 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[5]_syn_36 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_8 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_10 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_13 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_15 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_17 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[4]_syn_19 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_8 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_10 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_12 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_14 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_16 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[3]_syn_18 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_8 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_10 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_12 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_14 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_16 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_18 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_20 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_22 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[2]_syn_24 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_9 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_11 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_13 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_15 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_17 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_19 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_23 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_25 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_27 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_29 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_31 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[1]_syn_33 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_8 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_10 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_12 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_14 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_16 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_18 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_20 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_22 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_24 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_26 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_28 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_30 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_32 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_34 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_value_q_b1[0]_syn_36 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_9 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_11 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_13 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_15 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_17 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_20 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_22 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_24 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_26 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_28 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_30 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_32 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_34 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_36 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_38 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_40 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_42 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_44 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_46 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_48 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_50 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_52 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_54 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_56 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_60 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_63 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_66 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_71 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_74 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_77 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_80 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_82 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_85 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_87 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_90 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_92 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_95 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_97 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_100 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_106 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_112 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_114 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_116 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_118 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_120 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_122 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_124 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_126 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_128 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_130 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_133 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_135 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_138 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_140 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_142 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_144 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_146 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_148 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_150 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_152 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_154 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[4]_syn_dup_320 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[3]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[3]_syn_5 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[3]_syn_7 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[3]_syn_9 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[3]_syn_11 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[2]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[2]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[2]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_3 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_5 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_7 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_9 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_11 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_14 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_16 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_18 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_20 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_22 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_24 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[1]_syn_26 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[0]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[0]_syn_5 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[0]_syn_7 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[0]_syn_9 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[0]_syn_11 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[0]_syn_13 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[0]_syn_16 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_width_q_b1[0]_syn_18 ;
  wire \u_jpeg_core/u_jpeg_dht/lookup_req_i ;  // ../user_source/hdl_source/jpeg/jpeg_dht.v(49)
  wire \u_jpeg_core/u_jpeg_dht/u_fixed_cx_ac/eq101_syn_105 ;  // ../user_source/hdl_source/jpeg/jpeg_dht_std_cx_ac.v(91)
  wire \u_jpeg_core/u_jpeg_dht/u_fixed_cx_ac/sel1_syn_1109 ;  // ../user_source/hdl_source/jpeg/jpeg_dht_std_cx_ac.v(49)
  wire \u_jpeg_core/u_jpeg_dht/u_fixed_cx_ac/sel1_syn_3381 ;  // ../user_source/hdl_source/jpeg/jpeg_dht_std_cx_ac.v(49)
  wire \u_jpeg_core/u_jpeg_dht/u_fixed_cx_ac/lookup_input_i[15]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_dht_std_cx_ac.v(33)
  wire \u_jpeg_core/u_jpeg_dht/u_fixed_cx_dc/cx_dc_value_r_n2 ;
  wire \u_jpeg_core/u_jpeg_dht/u_fixed_cx_dc/cx_dc_value_r_n20 ;
  wire \u_jpeg_core/u_jpeg_dht/u_fixed_y_ac/lookup_input_i[6]_syn_218 ;  // ../user_source/hdl_source/jpeg/jpeg_dht_std_y_ac.v(33)
  wire \u_jpeg_core/u_jpeg_dqt/add0_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(81)
  wire \u_jpeg_core/u_jpeg_dqt/dqt_table_addr_w[7]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(108)
  wire \u_jpeg_core/u_jpeg_dqt/dqt_table_addr_w[6]_syn_3 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(108)
  wire \u_jpeg_core/u_jpeg_dqt/cfg_table_q_b1_n ;
  wire \u_jpeg_core/u_jpeg_dqt/cfg_valid_i ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(42)
  wire \u_jpeg_core/u_jpeg_dqt/dqt_write_w ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(107)
  wire \u_jpeg_core/u_jpeg_dqt/inport_eob_q ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(205)
  wire \u_jpeg_core/u_jpeg_dqt/inport_valid_q ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(201)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_36 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux2_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(91)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_36 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux3_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(92)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_36 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux4_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(93)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_36 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/mux5_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(94)
  wire \u_jpeg_core/u_jpeg_idct/x_reserved_q_reg_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(59)
  wire \u_jpeg_core/u_jpeg_idct/core_valid ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(48)
  wire \u_jpeg_core/u_jpeg_idct/img_end_i_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(35)
  wire \u_jpeg_core/u_jpeg_idct/inport_eob_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(38)
  wire \u_jpeg_core/u_jpeg_idct/input_valid_w ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(58)
  wire \u_jpeg_core/u_jpeg_idct/input_y_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(46)
  wire \u_jpeg_core/u_jpeg_idct/x_reserved_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(46)
  wire \u_jpeg_core/u_jpeg_idct/y_pass_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct.v(46)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/ramread0_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(119)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/ramread0_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(119)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/ramread0_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(119)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/ram_q_n ;
  wire \u_jpeg_core/u_jpeg_idct/u_input/mux13_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_input/mux13_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_input/mux13_syn_44 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_input/mux13_syn_46 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_input/mux13_syn_48 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_input/mux13_syn_50 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q[1]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q[1]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q[1]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q[0]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q[0]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_rd_q[0]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(58)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[3]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[3]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[3]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[3]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[2]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[2]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[2]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[2]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[1]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[1]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[1]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[0]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[0]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q[0]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(61)
  wire \u_jpeg_core/u_jpeg_idct/u_input/clear_active_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(62)
  wire \u_jpeg_core/u_jpeg_idct/u_input/inport_accept_o ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(46)
  wire \u_jpeg_core/u_jpeg_idct/u_input/inport_valid_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(39)
  wire \u_jpeg_core/u_jpeg_idct/u_input/slot_prepared_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(65)
  wire \u_jpeg_core/u_jpeg_idct/u_input/wr0_w ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(78)
  wire \u_jpeg_core/u_jpeg_idct/u_input/wr1_w ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(79)
  wire \u_jpeg_core/u_jpeg_idct/u_input/wr2_w ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(80)
  wire \u_jpeg_core/u_jpeg_idct/u_input/wr3_w ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(81)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[15]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[15]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[15]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[15]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[14]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[14]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[14]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[14]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[13]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[13]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[13]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[13]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[12]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[12]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[12]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[12]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[11]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[11]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[11]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[11]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[10]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[10]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[10]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[10]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[9]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[9]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[9]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[9]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[8]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[8]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[8]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[8]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[7]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[7]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[7]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[7]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[6]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[6]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[6]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[6]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[5]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[5]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[5]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[5]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[4]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[4]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[4]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[4]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[3]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[3]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[3]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[3]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[2]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[2]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[2]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[2]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[1]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[1]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[1]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[0]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[0]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/data0_i[0]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(38)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram0/wr0_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(39)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram1/wr0_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(39)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram2/wr0_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(39)
  wire \u_jpeg_core/u_jpeg_idct/u_input/u_ram3/wr0_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram_dp.v(39)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add0_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(266)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add0_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(266)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add0_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(266)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add0_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(266)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add0_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(266)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add0_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(266)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add0_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(266)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add0_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(266)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add10_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(346)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add10_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(346)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add10_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(346)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add10_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(346)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add10_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(346)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add10_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(346)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add10_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(346)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add10_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(346)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add11_syn_135 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(357)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add11_syn_139 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(357)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add11_syn_143 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(357)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add11_syn_147 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(357)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add11_syn_151 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(357)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add11_syn_155 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(357)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add11_syn_159 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(357)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add11_syn_163 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(357)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add12_syn_135 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(359)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add12_syn_139 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(359)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add12_syn_143 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(359)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add12_syn_147 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(359)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add12_syn_151 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(359)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add12_syn_155 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(359)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add12_syn_159 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(359)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add12_syn_163 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(359)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add2_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(276)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add2_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(276)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add2_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(276)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add2_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(276)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add2_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(276)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add2_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(276)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add2_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(276)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add2_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(276)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add3_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add3_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add3_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add3_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add3_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add3_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add3_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add3_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_193 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_195 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_197 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_199 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_201 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_203 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_205 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_207 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_209 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_211 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_213 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_215 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_217 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_219 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_221 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_351 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_353 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_355 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_357 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_359 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_361 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_363 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_365 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_367 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_369 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_371 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_373 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_375 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_377 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add4_syn_379 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add5_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(298)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add5_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(298)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add5_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(298)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add5_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(298)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add5_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(298)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add5_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(298)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add5_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(298)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add5_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(298)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add6_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(301)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add6_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(301)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add6_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(301)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add6_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(301)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add6_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(301)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add6_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(301)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add6_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(301)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add6_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(301)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add9_syn_136 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(306)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add9_syn_140 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(306)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add9_syn_144 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(306)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add9_syn_148 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(306)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add9_syn_152 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(306)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add9_syn_156 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(306)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add9_syn_160 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(306)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/add9_syn_164 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(306)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_29 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_31 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_33 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_37 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_39 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_43 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_44 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_45 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_46 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_47 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_48 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_49 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_50 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_164 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_166 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_168 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_170 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_172 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_174 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult0_syn_176 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(192)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_29 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_31 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_33 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_37 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_39 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_43 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_44 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_45 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_46 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_47 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_48 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_49 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_157 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_159 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_161 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_163 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_165 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult1_syn_167 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(193)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_29 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_31 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_33 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_37 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_39 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_43 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_44 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_45 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_46 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_47 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_48 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_49 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_157 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_159 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_161 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_163 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_165 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult2_syn_167 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(194)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_29 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_31 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_36 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_37 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_39 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_43 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_136 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_140 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult3_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(195)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_3 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_29 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_31 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_33 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_36 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_37 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_39 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_43 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_44 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_173 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_175 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_177 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_179 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_181 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_183 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult4_syn_185 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(241)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_3 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_29 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_31 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_33 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_36 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_37 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_39 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_43 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_44 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_173 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_175 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_177 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_179 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_181 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_183 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult5_syn_185 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(242)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_26 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_29 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_31 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_33 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_37 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_38 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_39 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_43 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_44 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_45 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_46 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_47 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_48 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_49 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_50 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_164 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_166 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_168 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_170 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_172 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_174 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mult6_syn_176 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(191)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux10_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_463 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_475 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_487 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_499 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_511 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_523 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_535 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_547 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_559 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_571 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_583 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_595 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_607 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_619 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_631 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_643 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_655 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_667 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_679 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_691 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_703 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_715 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_727 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_739 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_751 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_763 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_775 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_787 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_799 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_811 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_823 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_835 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_847 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux13_syn_859 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux14_syn_428 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux15_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux15_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux17_syn_559 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux18_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux19_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_45 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_57 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_69 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_81 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_93 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_105 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_117 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_129 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_141 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_153 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_165 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_177 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_189 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_201 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_213 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_225 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_237 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_249 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_261 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_273 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_285 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux46_syn_394 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux47_syn_99 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux47_syn_102 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux47_syn_105 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux47_syn_107 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux47_syn_117 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux47_syn_129 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux47_syn_141 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux49_syn_107 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux53_syn_1 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux56_syn_109 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_170 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_182 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_194 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_206 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_218 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_230 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_242 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_254 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_266 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_278 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_290 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_302 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_314 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_326 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_338 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_350 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_362 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_374 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_386 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_398 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_410 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux59_syn_577 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(111)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_295 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_305 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_315 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_325 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_335 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_345 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_355 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_365 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_375 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_385 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_395 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_405 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_415 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_425 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_435 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_445 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_455 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_465 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_475 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_485 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_495 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_505 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_515 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_525 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_535 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_545 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_555 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_565 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_575 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_585 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_595 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_605 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_683 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux7_syn_877 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_341 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_347 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_353 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_359 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_365 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_371 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_377 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_383 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_389 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_395 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_401 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_407 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_413 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_419 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_425 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_431 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_437 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_443 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_449 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_455 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_461 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_467 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_473 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_479 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_485 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_491 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_497 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_503 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_509 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_515 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_521 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_531 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_605 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mux8_syn_799 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(263)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub0_syn_136 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(277)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub0_syn_140 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(277)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub0_syn_144 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(277)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub0_syn_148 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(277)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub0_syn_152 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(277)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub0_syn_156 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(277)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub0_syn_160 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(277)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub0_syn_164 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(277)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub1_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub1_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub1_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub1_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub1_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub1_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub1_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub1_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub10_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(358)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub10_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(358)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub10_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(358)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub10_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(358)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub10_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(358)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub10_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(358)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub10_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(358)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub10_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(358)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub11_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(360)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub11_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(360)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub11_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(360)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub11_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(360)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub11_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(360)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub11_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(360)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub11_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(360)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub11_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(360)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub2_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub2_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub2_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub2_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub2_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub2_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub2_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub2_syn_166 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(282)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub3_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(293)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub3_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(293)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub3_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(293)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub3_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(293)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub3_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(293)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub3_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(293)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub3_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(293)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub3_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(293)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub4_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(294)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub4_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(294)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub4_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(294)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub4_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(294)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub4_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(294)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub4_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(294)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub4_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(294)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub4_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(294)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub5_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(299)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub5_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(299)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub5_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(299)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub5_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(299)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub5_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(299)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub5_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(299)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub5_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(299)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub5_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(299)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub6_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(300)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub6_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(300)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub6_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(300)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub6_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(300)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub6_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(300)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub6_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(300)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub6_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(300)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub6_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(300)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub7_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(347)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub7_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(347)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub7_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(347)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub7_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(347)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub7_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(347)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub7_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(347)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub7_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(347)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub7_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(347)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub8_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(349)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub8_syn_138 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(349)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub8_syn_142 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(349)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub8_syn_146 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(349)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub8_syn_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(349)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub8_syn_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(349)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub8_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(349)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub8_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(349)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub9_syn_158 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(135)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub9_syn_162 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(135)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub9_syn_166 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(135)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub9_syn_170 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(135)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub9_syn_174 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(135)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub9_syn_178 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(135)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub9_syn_182 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(135)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/sub9_syn_186 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(135)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mul0_b2[10]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mul0_b2[1]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_idct/u_shared/mul1_b2[0]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[2]_dup_149 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[2]_dup_150 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[2]_dup_152 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[2]_dup_153 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[2]_dup_154 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[1]_dup_49 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[1]_dup_50 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[1]_dup_52 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_idx_q[1]_dup_53 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(214)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/ptr_q[0]_dup_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(374)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/ptr_q[0]_dup_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(374)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg0_valid_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(198)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg1_valid_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(213)
  wire \u_jpeg_core/u_jpeg_idct/u_shared/out_stg3_valid_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_y.v(311)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_45 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_47 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_49 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_51 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_53 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_55 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_57 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_59 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_61 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_63 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_65 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_67 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_69 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_72 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/mux15_syn_74 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(203)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_19 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[18]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[18]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[18]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[18]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[18]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[18]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[18]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[18]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[17]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[17]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[17]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[17]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[17]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[17]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[17]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[17]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[16]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[16]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[16]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[16]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[16]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[16]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[16]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[16]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[15]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[15]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[15]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[15]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[15]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[15]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[15]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[15]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[14]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[14]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[14]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[14]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[14]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[14]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[14]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[14]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[13]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[13]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[13]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[13]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[13]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[13]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[13]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[13]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[12]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[12]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[12]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[12]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[12]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[12]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[12]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[12]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[11]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[11]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[11]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[11]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[11]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[11]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[11]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[11]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[10]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[10]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[10]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[10]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[10]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[10]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[10]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[10]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[9]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[9]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[9]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[9]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[9]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[9]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[9]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[9]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[8]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[8]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[8]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[8]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[8]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[8]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[8]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[8]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[7]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[7]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[7]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[7]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[7]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[7]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[7]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[7]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[6]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[6]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[6]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[6]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[6]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[6]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[6]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[6]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[5]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[5]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[5]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[5]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[5]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[5]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[5]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[5]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[4]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[4]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[4]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[4]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[4]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[4]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[4]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[4]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[3]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[3]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[3]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[3]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[3]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[2]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[2]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[2]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[2]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[2]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[1]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[1]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[1]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[1]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[0]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[0]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[0]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[0]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(40)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[3]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[3]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[3]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[3]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[2]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[2]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[2]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[2]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[1]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[1]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[1]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[0]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[0]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q[0]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(59)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/block_rd_q ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(57)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/block_rd_q_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(57)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/block_rd_q_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(57)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/block_rd_q_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(57)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/block_rd_q_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(57)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/u_ram0/wr0_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose_ram.v(39)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/u_ram1/wr0_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose_ram.v(39)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/u_ram2/wr0_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose_ram.v(39)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/u_ram3/wr0_i ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose_ram.v(39)
  wire \u_jpeg_core/u_jpeg_input/add0_syn_24 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(388)
  wire \u_jpeg_core/u_jpeg_input/add0_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(388)
  wire \u_jpeg_core/u_jpeg_input/mux10_syn_301 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(160)
  wire \u_jpeg_core/u_jpeg_input/mux10_syn_2414 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(160)
  wire \u_jpeg_core/u_jpeg_input/mux10_syn_2416 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(160)
  wire \u_jpeg_core/u_jpeg_input/mux10_syn_2424 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(160)
  wire \u_jpeg_core/u_jpeg_input/mux10_syn_2428 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(160)
  wire \u_jpeg_core/u_jpeg_input/mux10_syn_2431 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(160)
  wire \u_jpeg_core/u_jpeg_input/mux10_syn_2435 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(160)
  wire \u_jpeg_core/u_jpeg_input/mux15_syn_134 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(309)
  wire \u_jpeg_core/u_jpeg_input/start_q_reg_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(557)
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[15]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[15]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[15]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[14]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[13]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[12]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[10]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[9]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[8]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[7]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[6]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[6]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[5]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1[4]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/byte_idx_q_b3_n ;
  wire \u_jpeg_core/u_jpeg_input/data_accept_i ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(43)
  wire \u_jpeg_core/u_jpeg_input/data_data_q_b1_n ;
  wire \u_jpeg_core/u_jpeg_input/data_valid_q ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(341)
  wire \u_jpeg_core/u_jpeg_input/eof_q ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(545)
  wire \u_jpeg_core/u_jpeg_input/idx_q_b1_n ;
  wire \u_jpeg_core/u_jpeg_input/img_cb_dqt_table_q_b2_n ;
  wire \u_jpeg_core/u_jpeg_input/img_cr_dqt_table_q_b2_n ;
  wire \u_jpeg_core/u_jpeg_input/img_y_dqt_table_q_b2_n ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b1_n_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/length_q_b2_n_syn_2 ;
  wire \u_jpeg_core/u_jpeg_input/next_state_r_b2_n1 ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/add0_syn_41 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(298)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add1_syn_68 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add1_syn_70 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add1_syn_72 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add1_syn_74 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add1_syn_76 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add1_syn_78 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add1_syn_80 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add1_syn_82 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/add6_syn_23 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(249)
  wire \u_jpeg_core/u_jpeg_mcu_proc/eq10_syn_57 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(251)
  wire \u_jpeg_core/u_jpeg_mcu_proc/lt1_syn_58 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(139)
  wire \u_jpeg_core/u_jpeg_mcu_proc/mux26_syn_49 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(165)
  wire \u_jpeg_core/u_jpeg_mcu_proc/mux26_syn_53 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(165)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift3_syn_147 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift3_syn_177 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(338)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_94 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_96 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_98 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_100 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_112 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_136 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_156 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_186 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_194 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_244 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_272 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_279 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_283 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_290 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_292 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_295 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_297 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_300 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_302 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_305 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_307 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_313 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_316 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_321 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_324 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_326 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_330 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_334 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_336 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_339 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_341 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_343 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_345 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_347 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_349 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_351 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_353 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_355 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_357 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_364 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_370 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_372 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_375 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_377 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_383 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_385 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_387 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_389 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_391 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_395 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_397 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_399 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_402 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_405 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_408 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_410 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_413 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_415 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_419 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_421 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_424 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_426 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_429 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_433 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_437 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_439 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_442 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_445 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_447 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_450 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_453 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_457 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_459 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/right_shift4_syn_462 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(224)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q_b2[7]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q_b2[7]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q_b2[7]_syn_6 ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q_b2[7]_syn_8 ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q_b2[7]_syn_10 ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q_b2[7]_syn_12 ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q_b2[2]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_20 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_22 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_25 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_27 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_30 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_33 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_35 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_37 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_40 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_45 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_48 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_50 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_52 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_54 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_56 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_58 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_60 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_62 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_64 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_66 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_68 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_70 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_72 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_74 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_77 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_79 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_81 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_83 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_85 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[14]_syn_87 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[12]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[12]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[12]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[10]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[8]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[7]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[6]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[6]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[5]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[5]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r[5]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(333)
  wire \u_jpeg_core/u_jpeg_mcu_proc/code_bits_q_b1_n ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_idx_q_b5_n ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/coeff_r_b4_n ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/dc_coeff_q_b1_n ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/first_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(178)
  wire \u_jpeg_core/u_jpeg_mcu_proc/inport_valid_i_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(42)
  wire \u_jpeg_core/u_jpeg_mcu_proc/lookup_valid_i ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(45)
  wire \u_jpeg_core/u_jpeg_mcu_proc/outport_blk_space_i ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(48)
  wire \u_jpeg_core/u_jpeg_mcu_proc/push_q ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_proc.v(396)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/add6_syn_52 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(168)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/add6_syn_72 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(168)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/add6_syn_92 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(168)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/add7_syn_52 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(171)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/add7_syn_60 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(171)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/end_of_image_q_reg_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(130)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/end_of_image_q_reg_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(130)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/end_of_image_q_reg_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(130)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_55 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_57 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_60 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_63 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_66 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_69 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_72 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_75 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_78 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_83 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_89 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_92 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_94 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_96 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_99 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_103 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux18_syn_105 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(131)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/mux7_syn_34 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(160)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/block_x_q_b4_n ;
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/end_of_image_o ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(48)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/start_of_block_i ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(42)
  wire \u_jpeg_core/u_jpeg_output/add10_syn_161 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(247)
  wire \u_jpeg_core/u_jpeg_output/add10_syn_165 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(247)
  wire \u_jpeg_core/u_jpeg_output/add10_syn_169 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(247)
  wire \u_jpeg_core/u_jpeg_output/add10_syn_173 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(247)
  wire \u_jpeg_core/u_jpeg_output/add10_syn_177 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(247)
  wire \u_jpeg_core/u_jpeg_output/add10_syn_181 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(247)
  wire \u_jpeg_core/u_jpeg_output/add10_syn_185 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(247)
  wire \u_jpeg_core/u_jpeg_output/add10_syn_189 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(247)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_127 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_131 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_135 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_139 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_143 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_147 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_151 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_208 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_212 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_216 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_228 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_240 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_296 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_300 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_304 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_320 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_332 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_448 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_450 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_452 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_454 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_456 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_458 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_460 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_462 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_464 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_466 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_468 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_578 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_580 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_582 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_584 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_586 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_588 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_590 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_592 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_594 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_596 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_598 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_600 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_602 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_624 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_627 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_654 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_670 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add4_syn_684 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(238)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_83 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_87 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_91 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_95 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_99 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_103 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_115 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_188 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_192 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_196 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_200 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_208 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_216 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_228 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_232 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_340 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_342 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_344 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_346 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_348 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_350 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_352 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_354 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_356 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_358 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add5_syn_381 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(240)
  wire \u_jpeg_core/u_jpeg_output/add8_syn_89 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/add9_syn_161 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/add9_syn_165 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/add9_syn_169 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/add9_syn_173 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/add9_syn_177 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/add9_syn_181 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/add9_syn_185 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/add9_syn_189 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(245)
  wire \u_jpeg_core/u_jpeg_output/color_s1_emit_q_reg_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(275)
  wire \u_jpeg_core/u_jpeg_output/idle_q_reg_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(336)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_102 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_104 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_106 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_108 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_110 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_112 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_114 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_116 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_118 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_202 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_204 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_206 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_208 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_210 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_212 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_214 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_216 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_218 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/sub4_syn_220 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(246)
  wire \u_jpeg_core/u_jpeg_output/color_s1_y_q[7]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(217)
  wire \u_jpeg_core/u_jpeg_output/pixel_b_q_b3[5]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_output/pixel_b_q_b3[5]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_output/pixel_g_q_b2[5]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_output/pixel_g_q_b2[5]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_output/pixel_r_q_b2[5]_syn_2 ;
  wire \u_jpeg_core/u_jpeg_output/pixel_r_q_b2[5]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_output/active_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(212)
  wire \u_jpeg_core/u_jpeg_output/active_q_n15 ;
  wire \u_jpeg_core/u_jpeg_output/color_s1_emit_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(215)
  wire \u_jpeg_core/u_jpeg_output/color_s1_valid_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(214)
  wire \u_jpeg_core/u_jpeg_output/id_pop_w ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(158)
  wire \u_jpeg_core/u_jpeg_output/idle_q ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(334)
  wire \u_jpeg_core/u_jpeg_output/idle_q_n4_syn_2 ;
  wire \u_jpeg_core/u_jpeg_output/inport_accept_o_n1 ;
  wire \u_jpeg_core/u_jpeg_output/outport_valid_o ;  // ../user_source/hdl_source/jpeg/jpeg_output.v(50)
  wire \u_jpeg_core/u_jpeg_output/pixel_b_q_b1_n ;
  wire \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_160 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire \u_jpeg_core/u_jpeg_output/u_info/ramread0_syn_163 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(119)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/add2_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(61)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/add3_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(371)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_166 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_170 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_174 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_178 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_182 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_186 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_190 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_194 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_359 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_363 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_367 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_371 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_375 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_379 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_383 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/sub0_syn_387 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(373)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(373)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_rd_ptr_q[5]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_rd_ptr_q[4]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_rd_ptr_q[3]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_rd_ptr_q[2]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_rd_ptr_q[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_rd_ptr_q[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/count_r_b_n ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_b3_n ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_b3_n1 ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_b3_n3_syn_2 ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/push_i ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(39)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/push_i_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(39)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/rd_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(76)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/rd_skid_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(396)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/read_ok_w ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(75)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/add2_syn_28 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(61)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/add3_syn_32 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(371)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_166 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_170 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_174 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_178 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_182 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_186 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_190 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_194 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_359 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_363 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_367 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_371 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_375 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_379 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_383 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/sub0_syn_387 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(467)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_half_q[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(373)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_half_q[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(373)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_rd_ptr_q[5]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_rd_ptr_q[4]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_rd_ptr_q[3]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_rd_ptr_q[2]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_rd_ptr_q[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_rd_ptr_q[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(383)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/count_r_b_n ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_half_q_b3_n ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/cx_half_q_b3_n1 ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/push_i ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(39)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/push_i_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(39)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/rd_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(76)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/rd_skid_data_q_b2_n ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/rd_skid_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(396)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cr/read_ok_w ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(75)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add0_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(85)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add1_syn_42 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(60)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_212 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_216 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_220 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_224 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_228 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_232 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_236 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/add2_syn_240 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(174)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_87 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_88 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_89 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_93 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_96 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_98 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_100 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_101 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_102 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_103 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_104 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_109 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_110 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_112 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_113 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_115 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_116 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_117 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/mux12_syn_dup_118 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(178)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[8]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[7]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[6]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[5]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[4]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[3]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[2]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[1]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q[0]_syn_2 ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(54)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/push_i ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(39)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q_b3_n ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q_b3_n_syn_2 ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q_b3_n_syn_4 ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_ptr_q_b3_n_syn_6 ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(75)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_skid_data_q_b2_n ;
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/rd_skid_q ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(100)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/read_ok_w ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(74)
  wire \u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ;  // ../user_source/hdl_source/jpeg/jpeg_output_y_ram.v(200)
  wire \u_osd/mux12_syn_26 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux12_syn_48 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux12_syn_66 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux12_syn_137 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux12_syn_139 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux12_syn_141 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux12_syn_144 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux12_syn_146 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux12_syn_148 ;  // ../user_source/hdl_source/player_osd.v(107)
  wire \u_osd/mux13_syn_10 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_12 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_15 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_17 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_20 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_22 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_25 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_27 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_30 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux13_syn_32 ;  // ../user_source/hdl_source/player_osd.v(126)
  wire \u_osd/mux2_syn_26 ;  // ../user_source/hdl_source/player_osd.v(263)
  wire \u_osd/auto_mode ;  // ../user_source/hdl_source/player_osd.v(9)
  wire \u_osd_state/add0_syn_24 ;  // ../user_source/hdl_source/player_osd_state.v(32)
  wire \u_osd_state/mux20_syn_49 ;  // ../user_source/hdl_source/player_osd_state.v(96)
  wire \u_osd_state/release_pending_reg_syn_5 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_osd_state/release_pending_reg_syn_7 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_osd_state/wipe_active_reg_syn_5 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_osd_state/acknowledge_pixel ;  // ../user_source/hdl_source/player_osd_state.v(25)
  wire \u_osd_state/acknowledge_pixel_n2 ;
  wire \u_osd_state/display_finish_toggle ;  // ../user_source/hdl_source/player_osd_state.v(21)
  wire \u_osd_state/frame_valid ;  // ../user_source/hdl_source/player_osd_state.v(17)
  wire \u_osd_state/have_frame ;  // ../user_source/hdl_source/player_osd_state.v(29)
  wire \u_osd_state/held_sd_b_n1 ;
  wire \u_osd_state/read_ack_pixel ;  // ../user_source/hdl_source/player_osd_state.v(31)
  wire \u_osd_state/read_req ;  // ../user_source/hdl_source/player_osd_state.v(12)
  wire \u_osd_state/release_pending ;  // ../user_source/hdl_source/player_osd_state.v(29)
  wire \u_osd_state/request_sd ;  // ../user_source/hdl_source/player_osd_state.v(25)
  wire \u_osd_state/wipe_active ;  // ../user_source/hdl_source/player_osd_state.v(18)
  wire \u_pcm_waveform/add0_syn_26 ;  // ../user_source/hdl_source/player_pcm_waveform.v(45)
  wire \u_pcm_waveform/add0_syn_34 ;  // ../user_source/hdl_source/player_pcm_waveform.v(45)
  wire \u_pcm_waveform/add1_syn_112 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_114 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_116 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_118 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_120 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_122 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_124 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_126 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_128 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_130 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add1_syn_132 ;  // ../user_source/hdl_source/player_pcm_waveform.v(118)
  wire \u_pcm_waveform/add11_syn_123 ;  // ../user_source/hdl_source/player_pcm_waveform.v(309)
  wire \u_pcm_waveform/add2_syn_22 ;  // ../user_source/hdl_source/player_pcm_waveform.v(138)
  wire \u_pcm_waveform/add9_syn_28 ;  // ../user_source/hdl_source/player_pcm_waveform.v(87)
  wire \u_pcm_waveform/lt0_syn_117 ;  // ../user_source/hdl_source/player_pcm_waveform.v(42)
  wire \u_pcm_waveform/lt2_syn_162 ;  // ../user_source/hdl_source/player_pcm_waveform.v(117)
  wire \u_pcm_waveform/lt2_syn_193 ;  // ../user_source/hdl_source/player_pcm_waveform.v(117)
  wire \u_pcm_waveform/lt8_syn_27 ;  // ../user_source/hdl_source/player_pcm_waveform.v(84)
  wire \u_pcm_waveform/mux0_syn_16 ;  // ../user_source/hdl_source/player_pcm_waveform.v(304)
  wire \u_pcm_waveform/mux0_syn_32 ;  // ../user_source/hdl_source/player_pcm_waveform.v(304)
  wire \u_pcm_waveform/mux0_syn_99 ;  // ../user_source/hdl_source/player_pcm_waveform.v(304)
  wire \u_pcm_waveform/mux6_syn_4 ;  // ../user_source/hdl_source/player_pcm_waveform.v(41)
  wire \u_pcm_waveform/mux62_syn_81 ;  // ../user_source/hdl_source/player_pcm_waveform.v(269)
  wire \u_pcm_waveform/mux71_syn_83 ;  // ../user_source/hdl_source/player_pcm_waveform.v(279)
  wire \u_pcm_waveform/mux71_syn_99 ;  // ../user_source/hdl_source/player_pcm_waveform.v(279)
  wire \u_pcm_waveform/mux71_syn_323 ;  // ../user_source/hdl_source/player_pcm_waveform.v(279)
  wire \u_pcm_waveform/mux71_syn_353 ;  // ../user_source/hdl_source/player_pcm_waveform.v(279)
  wire \u_pcm_waveform/right_shift3_syn_106 ;  // ../user_source/hdl_source/player_pcm_waveform.v(44)
  wire \u_pcm_waveform/sel10_syn_48 ;  // ../user_source/hdl_source/player_pcm_waveform.v(135)
  wire \u_pcm_waveform/stale_reg_syn_7 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/stale_reg_syn_9 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/stale_reg_syn_12 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/legend_on_b[3]_syn_2 ;
  wire \u_pcm_waveform/state_write_data[10]_syn_2 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_4 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_6 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_8 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_10 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_12 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_14 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_16 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_18 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_20 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_22 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_24 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_26 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_28 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_30 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_32 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_34 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_36 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_38 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_40 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_42 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_44 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_46 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_48 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_50 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_52 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_54 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_56 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_58 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_60 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_62 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_64 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_66 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_68 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_70 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_72 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_74 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_77 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_79 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_81 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_83 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[10]_syn_85 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_3 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_5 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_8 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_11 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_14 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_19 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_22 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_25 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_27 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_30 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[9]_syn_32 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[8]_syn_2 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[1]_syn_2 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/state_write_data[1]_syn_4 ;  // ../user_source/hdl_source/player_pcm_waveform.v(90)
  wire \u_pcm_waveform/target_mem_b[5]_syn_3 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_6 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_8 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_10 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_12 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_17 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_19 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_22 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_24 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_26 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_28 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_30 ;
  wire \u_pcm_waveform/target_mem_b[5]_syn_32 ;
  wire \u_pcm_waveform/target_mem_b[3]_syn_2 ;
  wire \u_pcm_waveform/target_mem_b[2]_syn_2 ;
  wire \u_pcm_waveform/target_mem_b[2]_syn_4 ;
  wire \u_pcm_waveform/target_mem_b[2]_syn_6 ;
  wire \u_pcm_waveform/target_mem_b[1]_syn_2 ;
  wire \u_pcm_waveform/target_mem_b[1]_syn_4 ;
  wire \u_pcm_waveform/target_mem_b[0]_syn_2 ;
  wire \u_pcm_waveform/target_mem_b[0]_syn_4 ;
  wire \u_pcm_waveform/target_mem_b[0]_syn_6 ;
  wire \u_pcm_waveform/target_mem_b[0]_syn_8 ;
  wire \u_pcm_waveform/target_mem_b10[2]_syn_2 ;
  wire \u_pcm_waveform/target_mem_b10[1]_syn_4 ;
  wire \u_pcm_waveform/target_mem_b10[0]_syn_6 ;
  wire \u_pcm_waveform/band_valid ;  // ../user_source/hdl_source/player_pcm_waveform.v(23)
  wire \u_pcm_waveform/capture_bank ;  // ../user_source/hdl_source/player_pcm_waveform.v(54)
  wire \u_pcm_waveform/frame_done ;  // ../user_source/hdl_source/player_pcm_waveform.v(23)
  wire \u_pcm_waveform/frame_tone_mode ;  // ../user_source/hdl_source/player_pcm_waveform.v(101)
  wire \u_pcm_waveform/freeze_requested ;  // ../user_source/hdl_source/player_pcm_waveform.v(101)
  wire \u_pcm_waveform/freeze_toggle ;  // ../user_source/hdl_source/player_pcm_waveform.v(11)
  wire \u_pcm_waveform/front_bank ;  // ../user_source/hdl_source/player_pcm_waveform.v(58)
  wire \u_pcm_waveform/front_bank_n4 ;
  wire \u_pcm_waveform/front_valid ;  // ../user_source/hdl_source/player_pcm_waveform.v(58)
  wire \u_pcm_waveform/have_audio ;  // ../user_source/hdl_source/player_pcm_waveform.v(103)
  wire \u_pcm_waveform/legend_on_n16_syn_2 ;
  wire \u_pcm_waveform/next_hold_n_syn_2 ;
  wire \u_pcm_waveform/ready_bank ;  // ../user_source/hdl_source/player_pcm_waveform.v(54)
  wire \u_pcm_waveform/ready_valid ;  // ../user_source/hdl_source/player_pcm_waveform.v(54)
  wire \u_pcm_waveform/render_bank_next ;  // ../user_source/hdl_source/player_pcm_waveform.v(226)
  wire \u_pcm_waveform/rgb_out_n ;
  wire \u_pcm_waveform/snapshot_bank ;  // ../user_source/hdl_source/player_pcm_waveform.v(54)
  wire \u_pcm_waveform/snapshot_tone ;  // ../user_source/hdl_source/player_pcm_waveform.v(67)
  wire \u_pcm_waveform/snapshot_valid ;  // ../user_source/hdl_source/player_pcm_waveform.v(54)
  wire \u_pcm_waveform/snapshot_valid_n6 ;
  wire \u_pcm_waveform/source_pending ;  // ../user_source/hdl_source/player_pcm_waveform.v(19)
  wire \u_pcm_waveform/stale ;  // ../user_source/hdl_source/player_pcm_waveform.v(103)
  wire \u_pcm_waveform/state_write_en ;  // ../user_source/hdl_source/player_pcm_waveform.v(89)
  wire \u_pcm_waveform/target_mem_n ;
  wire \u_pcm_waveform/tone_prev ;  // ../user_source/hdl_source/player_pcm_waveform.v(19)
  wire \u_pcm_waveform/wave_mem_n ;
  wire \u_pcm_waveform/u_spectrum/add10_syn_38 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(399)
  wire \u_pcm_waveform/u_spectrum/add10_syn_42 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(399)
  wire \u_pcm_waveform/u_spectrum/add10_syn_50 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(399)
  wire \u_pcm_waveform/u_spectrum/add11_syn_74 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(173)
  wire \u_pcm_waveform/u_spectrum/add11_syn_84 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(173)
  wire \u_pcm_waveform/u_spectrum/add11_syn_114 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(173)
  wire \u_pcm_waveform/u_spectrum/add11_syn_124 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(173)
  wire \u_pcm_waveform/u_spectrum/add12_syn_84 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(173)
  wire \u_pcm_waveform/u_spectrum/add12_syn_109 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(173)
  wire \u_pcm_waveform/u_spectrum/add14_syn_40 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(414)
  wire \u_pcm_waveform/u_spectrum/add14_syn_44 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(414)
  wire \u_pcm_waveform/u_spectrum/add15_syn_22 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(427)
  wire \u_pcm_waveform/u_spectrum/add3_syn_44 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(89)
  wire \u_pcm_waveform/u_spectrum/add3_syn_56 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(89)
  wire \u_pcm_waveform/u_spectrum/add4_syn_40 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(340)
  wire \u_pcm_waveform/u_spectrum/add4_syn_44 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(340)
  wire \u_pcm_waveform/u_spectrum/add5_syn_40 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(352)
  wire \u_pcm_waveform/u_spectrum/add5_syn_44 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(352)
  wire \u_pcm_waveform/u_spectrum/add5_syn_56 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(352)
  wire \u_pcm_waveform/u_spectrum/add6_syn_135 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(370)
  wire \u_pcm_waveform/u_spectrum/add6_syn_139 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(370)
  wire \u_pcm_waveform/u_spectrum/add6_syn_143 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(370)
  wire \u_pcm_waveform/u_spectrum/add6_syn_147 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(370)
  wire \u_pcm_waveform/u_spectrum/add6_syn_151 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(370)
  wire \u_pcm_waveform/u_spectrum/add6_syn_155 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(370)
  wire \u_pcm_waveform/u_spectrum/add6_syn_159 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(370)
  wire \u_pcm_waveform/u_spectrum/add6_syn_163 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(370)
  wire \u_pcm_waveform/u_spectrum/add7_syn_74 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(373)
  wire \u_pcm_waveform/u_spectrum/add7_syn_76 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(373)
  wire \u_pcm_waveform/u_spectrum/add7_syn_78 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(373)
  wire \u_pcm_waveform/u_spectrum/add7_syn_80 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(373)
  wire \u_pcm_waveform/u_spectrum/add7_syn_82 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(373)
  wire \u_pcm_waveform/u_spectrum/add7_syn_84 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(373)
  wire \u_pcm_waveform/u_spectrum/add7_syn_86 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(373)
  wire \u_pcm_waveform/u_spectrum/add7_syn_88 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(373)
  wire \u_pcm_waveform/u_spectrum/add8_syn_74 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(375)
  wire \u_pcm_waveform/u_spectrum/add8_syn_76 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(375)
  wire \u_pcm_waveform/u_spectrum/add8_syn_78 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(375)
  wire \u_pcm_waveform/u_spectrum/add8_syn_80 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(375)
  wire \u_pcm_waveform/u_spectrum/add8_syn_82 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(375)
  wire \u_pcm_waveform/u_spectrum/add8_syn_84 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(375)
  wire \u_pcm_waveform/u_spectrum/add8_syn_86 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(375)
  wire \u_pcm_waveform/u_spectrum/add8_syn_88 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(375)
  wire \u_pcm_waveform/u_spectrum/eq13_syn_44 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(408)
  wire \u_pcm_waveform/u_spectrum/lt0_syn_108 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(180)
  wire \u_pcm_waveform/u_spectrum/lt1_syn_107 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(180)
  wire \u_pcm_waveform/u_spectrum/lt1_syn_109 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(180)
  wire \u_pcm_waveform/u_spectrum/lt1_syn_111 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(180)
  wire \u_pcm_waveform/u_spectrum/mux29_syn_22 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(334)
  wire \u_pcm_waveform/u_spectrum/mux4_syn_140 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_20 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_40 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_56 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_72 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_86 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_102 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_118 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_134 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_146 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux5_syn_160 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_14 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_22 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_34 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_46 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_58 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_60 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_70 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_82 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_94 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_106 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_141 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_143 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_145 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_147 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_151 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_154 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_156 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux6_syn_164 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(191)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_104 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_111 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_115 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_117 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_119 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_122 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_124 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_126 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_128 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_130 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_132 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_134 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/mux97_syn_136 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(328)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_78 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_124 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_170 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_216 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_262 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_308 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_354 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_400 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_446 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_492 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_538 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_584 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_630 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_676 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_722 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_768 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_770 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel0_syn_772 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_80 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_126 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_172 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_218 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_264 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_310 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_356 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_402 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_448 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_494 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_540 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_586 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_632 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_678 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_724 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_766 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sel1_syn_770 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(229)
  wire \u_pcm_waveform/u_spectrum/sub0_syn_135 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(369)
  wire \u_pcm_waveform/u_spectrum/sub0_syn_139 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(369)
  wire \u_pcm_waveform/u_spectrum/sub0_syn_143 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(369)
  wire \u_pcm_waveform/u_spectrum/sub0_syn_147 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(369)
  wire \u_pcm_waveform/u_spectrum/sub0_syn_151 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(369)
  wire \u_pcm_waveform/u_spectrum/sub0_syn_155 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(369)
  wire \u_pcm_waveform/u_spectrum/sub0_syn_159 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(369)
  wire \u_pcm_waveform/u_spectrum/sub0_syn_163 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(369)
  wire \u_pcm_waveform/u_spectrum/sub1_syn_74 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(374)
  wire \u_pcm_waveform/u_spectrum/sub1_syn_76 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(374)
  wire \u_pcm_waveform/u_spectrum/sub1_syn_78 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(374)
  wire \u_pcm_waveform/u_spectrum/sub1_syn_80 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(374)
  wire \u_pcm_waveform/u_spectrum/sub1_syn_82 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(374)
  wire \u_pcm_waveform/u_spectrum/sub1_syn_84 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(374)
  wire \u_pcm_waveform/u_spectrum/sub1_syn_86 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(374)
  wire \u_pcm_waveform/u_spectrum/sub1_syn_88 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(374)
  wire \u_pcm_waveform/u_spectrum/sub2_syn_74 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(376)
  wire \u_pcm_waveform/u_spectrum/sub2_syn_76 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(376)
  wire \u_pcm_waveform/u_spectrum/sub2_syn_78 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(376)
  wire \u_pcm_waveform/u_spectrum/sub2_syn_80 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(376)
  wire \u_pcm_waveform/u_spectrum/sub2_syn_82 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(376)
  wire \u_pcm_waveform/u_spectrum/sub2_syn_84 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(376)
  wire \u_pcm_waveform/u_spectrum/sub2_syn_86 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(376)
  wire \u_pcm_waveform/u_spectrum/sub2_syn_88 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(376)
  wire \u_pcm_waveform/u_spectrum/band_max_b[14]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_4 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_6 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_8 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_11 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_13 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_15 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_17 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_19 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_21 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_24 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_27 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_31 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_34 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_36 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_38 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_40 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_42 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_44 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_46 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_48 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_50 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_52 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_54 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_58 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_60 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_62 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_64 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_66 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_68 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[13]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[12]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[11]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[11]_syn_4 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[11]_syn_6 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[11]_syn_8 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_4 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_6 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_8 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_10 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_12 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_14 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_16 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_19 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_22 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_24 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_26 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_28 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_30 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_32 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_34 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_36 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_38 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_40 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_42 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_44 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_46 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_48 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_50 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_52 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_54 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_56 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_58 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_60 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_62 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_64 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_66 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_68 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_72 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_75 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_77 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_80 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_82 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[10]_syn_84 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_4 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_7 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_10 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_12 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_15 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_17 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_19 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_21 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_26 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_28 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[5]_syn_30 ;
  wire \u_pcm_waveform/u_spectrum/emit_value_b[1]_syn_3 ;
  wire \u_pcm_waveform/u_spectrum/frame_age_samples_b[11]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/frame_age_samples_b[11]_syn_4 ;
  wire \u_pcm_waveform/u_spectrum/real_a_read_addr[7]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(261)
  wire \u_pcm_waveform/u_spectrum/real_a_read_addr[6]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(261)
  wire \u_pcm_waveform/u_spectrum/real_a_read_addr[5]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(261)
  wire \u_pcm_waveform/u_spectrum/real_a_read_addr[4]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(261)
  wire \u_pcm_waveform/u_spectrum/real_a_read_addr[3]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(261)
  wire \u_pcm_waveform/u_spectrum/real_a_read_addr[2]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(261)
  wire \u_pcm_waveform/u_spectrum/real_a_read_addr[1]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(261)
  wire \u_pcm_waveform/u_spectrum/sample_count_b[9]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/scan_bin_b[9]_syn_3 ;
  wire \u_pcm_waveform/u_spectrum/win_index_b[9]_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[9]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[7]_syn_3 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[6]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[5]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[4]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[3]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[2]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[1]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/work_ram_write_addr[0]_syn_2 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(269)
  wire \u_pcm_waveform/u_spectrum/band_max_b5_n ;
  wire \u_pcm_waveform/u_spectrum/band_valid_n ;
  wire \u_pcm_waveform/u_spectrum/mul_product_b_n ;
  wire \u_pcm_waveform/u_spectrum/timeout_pulse_n_syn_2 ;
  wire \u_pcm_waveform/u_spectrum/work_ram_write_en ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(266)
  wire \u_rgb_adjust/add0_syn_29 ;  // ../user_source/hdl_source/player_rgb_adjust.v(22)
  wire \u_rgb_adjust/add1_syn_77 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_79 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_81 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_83 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_85 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_90 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_92 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_94 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_96 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_99 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_101 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_103 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_107 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add1_syn_111 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add2_syn_22 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_26 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_75 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_77 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_79 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_81 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_83 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_86 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_88 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_90 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_93 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add2_syn_95 ;  // ../user_source/hdl_source/player_rgb_adjust.v(32)
  wire \u_rgb_adjust/add5_syn_77 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_79 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_81 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_83 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_85 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_88 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_90 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_92 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_95 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_97 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_99 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_102 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/add5_syn_107 ;  // ../user_source/hdl_source/player_rgb_adjust.v(23)
  wire \u_rgb_adjust/mux0_syn_35 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux0_syn_45 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux0_syn_55 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux0_syn_65 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux4_syn_35 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux4_syn_45 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux4_syn_55 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux4_syn_65 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux8_syn_35 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux8_syn_45 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux8_syn_55 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/mux8_syn_65 ;  // ../user_source/hdl_source/player_rgb_adjust.v(24)
  wire \u_rgb_adjust/sub0_syn_40 ;  // ../user_source/hdl_source/player_rgb_adjust.v(11)
  wire \u_shared_card/sd_card_cmd_m0/add1_syn_56 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(102)
  wire \u_shared_card/sd_card_cmd_m0/add1_syn_60 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(102)
  wire \u_shared_card/sd_card_cmd_m0/add1_syn_76 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(102)
  wire \u_shared_card/sd_card_cmd_m0/add1_syn_80 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(102)
  wire \u_shared_card/sd_card_cmd_m0/mux15_syn_111 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(175)
  wire \u_shared_card/sd_card_cmd_m0/mux15_syn_112 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(175)
  wire \u_shared_card/sd_card_cmd_m0/mux15_syn_113 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(175)
  wire \u_shared_card/sd_card_cmd_m0/mux15_syn_114 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(175)
  wire \u_shared_card/sd_card_cmd_m0/mux15_syn_115 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(175)
  wire \u_shared_card/sd_card_cmd_m0/mux15_syn_116 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(175)
  wire \u_shared_card/sd_card_cmd_m0/mux15_syn_117 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(175)
  wire \u_shared_card/sd_card_cmd_m0/mux31_syn_2118 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire \u_shared_card/sd_card_cmd_m0/mux31_syn_2120 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire \u_shared_card/sd_card_cmd_m0/mux31_syn_2127 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire \u_shared_card/sd_card_cmd_m0/mux31_syn_2129 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(83)
  wire \u_shared_card/sd_card_cmd_m0/mux5_syn_31 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(148)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_i17_syn_6 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(148)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_5 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_7 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_9 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_12 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_14 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_17 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_19 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_22 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_24 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_26 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req_reg_syn_29 ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(71)
  wire \u_shared_card/sd_card_cmd_m0/byte_cnt_b[15]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/byte_cnt_b[15]_syn_4 ;
  wire \u_shared_card/sd_card_cmd_m0/byte_cnt_b[15]_syn_9 ;
  wire \u_shared_card/sd_card_cmd_m0/byte_cnt_b[2]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/byte_cnt_b[1]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[7]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[7]_syn_4 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[6]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[5]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[4]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[3]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[2]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[1]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[1]_syn_4 ;
  wire \u_shared_card/sd_card_cmd_m0/send_data_b[0]_syn_2 ;
  wire \u_shared_card/sd_card_cmd_m0/CS_reg_n ;
  wire \u_shared_card/sd_card_cmd_m0/byte_cnt_b11_n ;
  wire \u_shared_card/sd_card_cmd_m0/byte_cnt_b12_n ;
  wire \u_shared_card/sd_card_cmd_m0/cmd_req_error ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(8)
  wire \u_shared_card/sd_card_cmd_m0/spi_wr_req ;  // ../user_source/hdl_source/SD/sd_card_cmd.v(22)
  wire \u_shared_card/sd_card_sec_read_write_m0/cmd_req_reg_syn_5 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(69)
  wire \u_shared_card/sd_card_sec_read_write_m0/sel1_syn_108 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire \u_shared_card/sd_card_sec_read_write_m0/sel2_syn_1016 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire \u_shared_card/sd_card_sec_read_write_m0/sel2_syn_1023 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire \u_shared_card/sd_card_sec_read_write_m0/sel6_syn_3763 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire \u_shared_card/sd_card_sec_read_write_m0/sel6_syn_3861 ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(83)
  wire \u_shared_card/sd_card_sec_read_write_m0/block_read_req ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(30)
  wire \u_shared_card/sd_card_sec_read_write_m0/block_read_valid ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(31)
  wire \u_shared_card/sd_card_sec_read_write_m0/cmd_req ;  // ../user_source/hdl_source/SD/sd_card_sec_read_write.v(24)
  wire \u_shared_card/spi_master_m0/add0_syn_52 ;  // ../user_source/hdl_source/SD/spi_master.v(99)
  wire \u_shared_card/spi_master_m0/add0_syn_56 ;  // ../user_source/hdl_source/SD/spi_master.v(99)
  wire \u_shared_card/spi_master_m0/add0_syn_72 ;  // ../user_source/hdl_source/SD/spi_master.v(99)
  wire \u_shared_card/spi_master_m0/add0_syn_88 ;  // ../user_source/hdl_source/SD/spi_master.v(99)
  wire \u_shared_card/spi_master_m0/add1_syn_26 ;  // ../user_source/hdl_source/SD/spi_master.v(109)
  wire \u_shared_card/spi_master_m0/mux13_syn_72 ;  // ../user_source/hdl_source/SD/spi_master.v(118)
  wire \u_shared_card/spi_master_m0/mux6_syn_121 ;  // ../user_source/hdl_source/SD/spi_master.v(49)
  wire \u_shared_card/spi_master_m0/mux6_syn_123 ;  // ../user_source/hdl_source/SD/spi_master.v(49)
  wire \u_shared_card/spi_master_m0/mux6_syn_125 ;  // ../user_source/hdl_source/SD/spi_master.v(49)
  wire \u_shared_card/spi_master_m0/mux6_syn_132 ;  // ../user_source/hdl_source/SD/spi_master.v(49)
  wire \u_shared_card/spi_master_m0/clk_cnt_b[15]_syn_2 ;
  wire \u_shared_card/spi_master_m0/DCLK_reg_n ;
  wire \u_shared_card/spi_master_m0/next_state_b2_n ;
  wire \u_status_hex/add0_syn_60 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_status_hex/add0_syn_76 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_status_hex/lt0_syn_110 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_status_hex/lt0_syn_113 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_status_hex/mux0_syn_6 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux2_syn_20 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux24_syn_23 ;  // ../user_source/hdl_source/status_hex595.v(42)
  wire \u_status_hex/mux4_syn_19 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux4_syn_97 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux5_syn_316 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux5_syn_321 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux5_syn_323 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux7_syn_627 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux7_syn_638 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux7_syn_642 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux7_syn_648 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/mux8_syn_187 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_status_hex/hex_value[4]_syn_4069 ;  // ../user_source/hdl_source/status_hex595.v(12)
  wire \u_status_hex/hex_value[4]_syn_4073 ;  // ../user_source/hdl_source/status_hex595.v(12)
  wire \u_status_hex/tx_is_blank ;  // ../user_source/hdl_source/status_hex595.v(37)
  wire \u_video_keys/auto_ack_toggle ;  // ../user_source/hdl_source/tf_bmp_file_player.v(262)
  wire \u_video_keys/next_ack_toggle ;  // ../user_source/hdl_source/tf_bmp_file_player.v(259)
  wire \u_video_reader/add0_syn_40 ;  // ../user_source/hdl_source/mjp_file_reader.v(133)
  wire \u_video_reader/add0_syn_44 ;  // ../user_source/hdl_source/mjp_file_reader.v(133)
  wire \u_video_reader/add1_syn_164 ;  // ../user_source/hdl_source/mjp_file_reader.v(146)
  wire \u_video_reader/add1_syn_168 ;  // ../user_source/hdl_source/mjp_file_reader.v(146)
  wire \u_video_reader/add1_syn_172 ;  // ../user_source/hdl_source/mjp_file_reader.v(146)
  wire \u_video_reader/add1_syn_176 ;  // ../user_source/hdl_source/mjp_file_reader.v(146)
  wire \u_video_reader/add1_syn_180 ;  // ../user_source/hdl_source/mjp_file_reader.v(146)
  wire \u_video_reader/add1_syn_184 ;  // ../user_source/hdl_source/mjp_file_reader.v(146)
  wire \u_video_reader/add1_syn_188 ;  // ../user_source/hdl_source/mjp_file_reader.v(146)
  wire \u_video_reader/add1_syn_192 ;  // ../user_source/hdl_source/mjp_file_reader.v(146)
  wire \u_video_reader/add2_syn_42 ;  // ../user_source/hdl_source/mjp_file_reader.v(198)
  wire \u_video_reader/add2_syn_46 ;  // ../user_source/hdl_source/mjp_file_reader.v(198)
  wire \u_video_reader/jpeg_valid_reg_syn_8 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/jpeg_valid_reg_syn_10 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/jpeg_valid_reg_syn_12 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/mux100_syn_77 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux101_syn_87 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux107_syn_82 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux70_syn_123 ;  // ../user_source/hdl_source/mjp_file_reader.v(187)
  wire \u_video_reader/mux94_syn_47 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_51 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_53 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_55 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_57 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_59 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_61 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_63 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_65 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_67 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_70 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_73 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_75 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_79 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux94_syn_83 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux99_syn_73 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux99_syn_75 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux99_syn_78 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux99_syn_80 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/mux99_syn_82 ;  // ../user_source/hdl_source/mjp_file_reader.v(118)
  wire \u_video_reader/sector_loaded_reg_syn_5 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/state_reg_syn_dup_13 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/state_reg_syn_dup_14 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/state_reg_syn_dup_15 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/sub3_syn_162 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_164 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_166 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_168 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_170 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_172 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_174 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_176 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_178 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_180 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_182 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_184 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_186 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_188 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_190 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/sub3_syn_192 ;  // ../user_source/hdl_source/mjp_file_reader.v(199)
  wire \u_video_reader/tail_pending_reg_syn_6 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/tail_pending_reg_syn_8 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/tail_pending_reg_syn_10 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/tail_pending_reg_syn_12 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/tail_pending_reg_syn_14 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/tail_pending_reg_syn_16 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/tail_pending_reg_syn_18 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/last_index_b3[8]_syn_2 ;
  wire \u_video_reader/file_ready ;  // ../user_source/hdl_source/mjp_file_reader.v(14)
  wire \u_video_reader/frame_sent_n ;
  wire \u_video_reader/jpeg_data_b7_n ;
  wire \u_video_reader/jpeg_last ;  // ../user_source/hdl_source/mjp_file_reader.v(23)
  wire \u_video_reader/jpeg_valid ;  // ../user_source/hdl_source/mjp_file_reader.v(20)
  wire \u_video_reader/jpeg_valid_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(20)
  wire \u_video_reader/next_frame ;  // ../user_source/hdl_source/mjp_file_reader.v(5)
  wire \u_video_reader/sector_cursor_b12_n ;
  wire \u_video_reader/sector_loaded ;  // ../user_source/hdl_source/mjp_file_reader.v(50)
  wire \u_video_reader/sector_mem_n ;
  wire \u_video_reader/sector_mem_n1_syn_2 ;
  wire \u_video_reader/sector_ram_read ;  // ../user_source/hdl_source/mjp_file_reader.v(57)
  wire \u_video_reader/sector_ram_read_syn_2 ;  // ../user_source/hdl_source/mjp_file_reader.v(57)
  wire \u_video_reader/sector_read_pending ;  // ../user_source/hdl_source/mjp_file_reader.v(51)
  wire \u_video_reader/start ;  // ../user_source/hdl_source/mjp_file_reader.v(4)
  wire \u_video_reader/tail_pending ;  // ../user_source/hdl_source/mjp_file_reader.v(52)
  wire \u_video_rgb_to_axis_640x480/S_frame_arm_i_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(44)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_3 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_5 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_7 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_9 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_11 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_13 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_16 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_18 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_21 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_23 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_25 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_28 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_30 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_32 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_34 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_36 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_38 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_40 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_43 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_46 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_48 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_50 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_52 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_54 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_56 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_58 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_60 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_62 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_64 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_66 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_68 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_70 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_72 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_74 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_76 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_78 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_80 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_82 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_84 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_86 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_88 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_90 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_92 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_94 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_96 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_98 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_100 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_102 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_104 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_106 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_108 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_110 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_112 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_114 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_116 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_120 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_122 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_124 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_126 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_128 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_132 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_135 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_137 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_139 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_141 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_143 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_145 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_147 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_149 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_152 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_155 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_157 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_159 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_161 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_165 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_167 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_169 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_171 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_173 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_175 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_177 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_179 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_181 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_184 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_186 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_188 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_190 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_192 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_194 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_196 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_198 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_200 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_202 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_204 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_206 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_208 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_210 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_212 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_214 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_216 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_218 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_220 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_222 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_224 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_226 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_228 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_230 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_232 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_234 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_236 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_238 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_241 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_243 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_245 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_247 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_249 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_251 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_253 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_255 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_257 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_259 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_261 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_263 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_265 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_267 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_269 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_271 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_273 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_275 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_277 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_280 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_283 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_285 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_287 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_289 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_291 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_293 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_295 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_297 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_300 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_302 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_304 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_306 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_308 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_310 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_313 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_315 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_317 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_319 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_321 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_324 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_326 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_328 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_330 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_332 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_334 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_336 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_338 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_340 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_343 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_345 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_347 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_349 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_351 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_353 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_355 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_357 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_359 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_361 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_363 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_365 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_367 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_369 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_371 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_373 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_375 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_377 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_379 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_381 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_383 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_385 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_387 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_389 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_391 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_393 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_395 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_397 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_399 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_401 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_403 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_406 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_408 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_410 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_413 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_415 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_417 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_419 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_421 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_423 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_425 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_427 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_429 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_431 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_433 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_435 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_437 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_439 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_441 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_443 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_445 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[23]_syn_447 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[22]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[22]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[22]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[22]_syn_9 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[21]_syn_3 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[21]_syn_5 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[21]_syn_7 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[20]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[20]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[20]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[19]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[19]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[19]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[19]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[19]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[19]_syn_12 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[18]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[18]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[18]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[18]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[18]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[17]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[17]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[17]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[17]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[17]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[16]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[16]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[16]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[15]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[15]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[15]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[15]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[15]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[14]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[14]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[14]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[13]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[13]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[13]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[12]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[12]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[12]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[12]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_12 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_14 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_16 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_18 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_20 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_22 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_24 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_26 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_28 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_30 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_32 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[11]_syn_34 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[10]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[10]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[10]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[10]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[10]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[9]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[9]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[9]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[9]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[9]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[8]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[8]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[8]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[8]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[7]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[7]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[7]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[7]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[6]_syn_3 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[6]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[6]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[6]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[5]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[5]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[5]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[5]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[4]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[4]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[4]_syn_8 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[4]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[3]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[3]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[3]_syn_7 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[3]_syn_9 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[3]_syn_11 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[2]_syn_3 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[2]_syn_5 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[2]_syn_7 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[2]_syn_10 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[1]_syn_2 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[1]_syn_4 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[1]_syn_6 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[1]_syn_9 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[1]_syn_11 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[1]_syn_13 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[0]_syn_3 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[0]_syn_5 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/I_rgb[0]_syn_7 ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(7)
  wire \u_video_rgb_to_axis_640x480/S_frame_arm ;  // ../user_source/hdl_source/video_rgb_to_axis_640x480.v(17)
  wire \u_video_rgb_to_axis_640x480/S_frame_arm_n3 ;
  wire \u_video_schedule/add1_syn_40 ;  // ../user_source/hdl_source/player_video_schedule.v(45)
  wire \u_video_schedule/add1_syn_52 ;  // ../user_source/hdl_source/player_video_schedule.v(45)
  wire \u_video_schedule/frame_due_reg_syn_6 ;  // ../user_source/hdl_source/player_video_schedule.v(31)
  wire \u_video_schedule/sel1_syn_335 ;  // ../user_source/hdl_source/player_video_schedule.v(49)
  wire \u_video_schedule/sel1_syn_337 ;  // ../user_source/hdl_source/player_video_schedule.v(49)
  wire \u_video_schedule/sel3_syn_273 ;  // ../user_source/hdl_source/player_video_schedule.v(49)
  wire \u_video_schedule/write_req_reg_syn_5 ;  // ../user_source/hdl_source/player_video_schedule.v(31)
  wire \u_video_schedule/audio_go ;  // ../user_source/hdl_source/player_video_schedule.v(14)
  wire \u_video_schedule/display_valid ;  // ../user_source/hdl_source/player_video_schedule.v(14)
  wire \u_video_schedule/frame_due ;  // ../user_source/hdl_source/player_video_schedule.v(24)
  wire \u_video_schedule/frame_due_n4 ;
  wire \u_video_schedule/frame_due_n6 ;
  wire \u_video_schedule/input_done ;  // ../user_source/hdl_source/player_video_schedule.v(24)
  wire \u_video_schedule/memory_done ;  // ../user_source/hdl_source/player_video_schedule.v(24)
  wire \u_video_schedule/reader_frame_sent ;  // ../user_source/hdl_source/player_video_schedule.v(6)
  wire \u_video_schedule/reader_next_n ;
  wire \u_video_schedule/reader_start_n ;
  wire \u_video_schedule/write_req ;  // ../user_source/hdl_source/player_video_schedule.v(11)
  wire \u_wav_player/add0_syn_46 ;  // ../user_source/hdl_source/tf_wav_file_player.v(146)
  wire \u_wav_player/add1_syn_40 ;  // ../user_source/hdl_source/tf_wav_file_player.v(182)
  wire \u_wav_player/add1_syn_44 ;  // ../user_source/hdl_source/tf_wav_file_player.v(182)
  wire \u_wav_player/add11_syn_162 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_164 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_166 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_168 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_170 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_172 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_174 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_176 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_178 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_180 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_182 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_184 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_186 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_188 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_190 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add11_syn_192 ;  // ../user_source/hdl_source/tf_wav_file_player.v(341)
  wire \u_wav_player/add2_syn_162 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_164 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_166 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_168 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_170 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_172 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_174 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_176 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_178 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_180 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_182 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_184 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_186 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_188 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_190 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add2_syn_192 ;  // ../user_source/hdl_source/tf_wav_file_player.v(187)
  wire \u_wav_player/add4_syn_46 ;  // ../user_source/hdl_source/tf_wav_file_player.v(91)
  wire \u_wav_player/add5_syn_147 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_149 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_151 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_153 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_155 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_157 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_159 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_161 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_163 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_165 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_167 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_169 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_171 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add5_syn_173 ;  // ../user_source/hdl_source/tf_wav_file_player.v(246)
  wire \u_wav_player/add6_syn_166 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_168 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_170 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_172 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_174 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_176 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_178 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_180 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_182 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_184 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_186 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_188 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_190 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_192 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_194 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_196 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_359 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_361 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_363 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_365 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_367 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_369 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_371 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_373 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_375 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_377 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_379 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_381 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_383 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_385 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_387 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add6_syn_389 ;  // ../user_source/hdl_source/tf_wav_file_player.v(251)
  wire \u_wav_player/add8_syn_132 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_134 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_136 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_138 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_140 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_142 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_144 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_146 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_148 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_150 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_152 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_154 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_156 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_158 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_160 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add8_syn_162 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_165 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_167 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_169 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_171 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_173 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_175 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_177 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_179 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_181 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_183 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_185 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_187 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_189 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_191 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_193 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/add9_syn_195 ;  // ../user_source/hdl_source/tf_wav_file_player.v(265)
  wire \u_wav_player/data_found_reg_syn_5 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/data_found_reg_syn_7 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/eq0_syn_75 ;  // ../user_source/hdl_source/tf_wav_file_player.v(153)
  wire \u_wav_player/fifo_head_bypass_reg_syn_25 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_bypass_reg_syn_27 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_bypass_reg_syn_29 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_bypass_reg_syn_31 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_10 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_13 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_15 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_17 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_19 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_21 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_23 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_25 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_27 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_29 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_31 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_33 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_35 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_37 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_39 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_41 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_43 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_45 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_47 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_49 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_51 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_53 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_55 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_57 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_59 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_61 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_63 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_65 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_67 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_69 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_71 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_73 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_75 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_79 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_81 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_83 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_85 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_87 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_89 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_91 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_93 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_95 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_97 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_100 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_102 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_104 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_106 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_108 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_110 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_113 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_115 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_117 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_119 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_121 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_123 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_125 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_127 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_129 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_131 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_133 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_135 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_137 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_139 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_141 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_145 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_147 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_149 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_151 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_153 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_158 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_160 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_162 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_164 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_170 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_172 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_176 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_178 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_180 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_185 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_187 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fifo_head_valid_reg_syn_189 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fmt_fields_valid_reg_syn_6 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fmt_fields_valid_reg_syn_8 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fmt_fields_valid_reg_syn_10 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fmt_fields_valid_reg_syn_12 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fmt_fields_valid_reg_syn_15 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fmt_fields_valid_reg_syn_17 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/fmt_fields_valid_reg_syn_19 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/lt0_syn_76 ;  // ../user_source/hdl_source/tf_wav_file_player.v(154)
  wire \u_wav_player/lt10_syn_241 ;  // ../user_source/hdl_source/tf_wav_file_player.v(207)
  wire \u_wav_player/lt10_syn_272 ;  // ../user_source/hdl_source/tf_wav_file_player.v(207)
  wire \u_wav_player/lt16_syn_182 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_184 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_186 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_188 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_190 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_192 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_194 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_196 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_198 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_200 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_202 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_204 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_206 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_208 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt16_syn_210 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt17_syn_216 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt17_syn_254 ;  // ../user_source/hdl_source/tf_wav_file_player.v(248)
  wire \u_wav_player/lt18_syn_216 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/lt18_syn_241 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/lt18_syn_254 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/lt18_syn_255 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/lt18_syn_272 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/lt3_syn_214 ;  // ../user_source/hdl_source/tf_wav_file_player.v(84)
  wire \u_wav_player/lt3_syn_241 ;  // ../user_source/hdl_source/tf_wav_file_player.v(84)
  wire \u_wav_player/lt4_syn_272 ;  // ../user_source/hdl_source/tf_wav_file_player.v(85)
  wire \u_wav_player/lt6_syn_190 ;  // ../user_source/hdl_source/tf_wav_file_player.v(186)
  wire \u_wav_player/lt7_syn_214 ;  // ../user_source/hdl_source/tf_wav_file_player.v(204)
  wire \u_wav_player/lt8_syn_214 ;  // ../user_source/hdl_source/tf_wav_file_player.v(204)
  wire \u_wav_player/lt8_syn_241 ;  // ../user_source/hdl_source/tf_wav_file_player.v(204)
  wire \u_wav_player/lt9_syn_216 ;  // ../user_source/hdl_source/tf_wav_file_player.v(205)
  wire \u_wav_player/lt9_syn_228 ;  // ../user_source/hdl_source/tf_wav_file_player.v(205)
  wire \u_wav_player/lt9_syn_254 ;  // ../user_source/hdl_source/tf_wav_file_player.v(205)
  wire \u_wav_player/lt9_syn_272 ;  // ../user_source/hdl_source/tf_wav_file_player.v(205)
  wire \u_wav_player/mux157_syn_2943 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire \u_wav_player/mux157_syn_3029 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire \u_wav_player/mux157_syn_3064 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire \u_wav_player/mux168_syn_459 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire \u_wav_player/mux168_syn_462 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire \u_wav_player/mux168_syn_468 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire \u_wav_player/mux170_syn_3036 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire \u_wav_player/mux175_syn_dup_3039 ;  // ../user_source/hdl_source/tf_wav_file_player.v(158)
  wire \u_wav_player/mux179_syn_133 ;  // ../user_source/hdl_source/tf_wav_file_player.v(371)
  wire \u_wav_player/mux179_syn_137 ;  // ../user_source/hdl_source/tf_wav_file_player.v(371)
  wire \u_wav_player/mux179_syn_141 ;  // ../user_source/hdl_source/tf_wav_file_player.v(371)
  wire \u_wav_player/mux179_syn_144 ;  // ../user_source/hdl_source/tf_wav_file_player.v(371)
  wire \u_wav_player/mux179_syn_146 ;  // ../user_source/hdl_source/tf_wav_file_player.v(371)
  wire \u_wav_player/mux205_syn_114 ;  // ../user_source/hdl_source/tf_wav_file_player.v(347)
  wire \u_wav_player/mux213_syn_dup_38 ;  // ../user_source/hdl_source/tf_wav_file_player.v(258)
  wire \u_wav_player/mux213_syn_dup_41 ;  // ../user_source/hdl_source/tf_wav_file_player.v(258)
  wire \u_wav_player/mux213_syn_dup_42 ;  // ../user_source/hdl_source/tf_wav_file_player.v(258)
  wire \u_wav_player/mux213_syn_dup_43 ;  // ../user_source/hdl_source/tf_wav_file_player.v(258)
  wire \u_wav_player/primed_reg_syn_6 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_8 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_10 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_12 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_14 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_16 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_18 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_20 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_23 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_25 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_27 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_29 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_31 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_33 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_35 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_37 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_39 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_41 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_43 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_45 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/primed_reg_syn_47 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/scan_phase_reg_syn_dup_20 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/scan_phase_reg_syn_dup_21 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/scan_phase_reg_syn_dup_22 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/sd_read_reg_syn_6 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/sel0_syn_29 ;  // ../user_source/hdl_source/tf_wav_file_player.v(291)
  wire \u_wav_player/sel11_syn_104 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel2_syn_21 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel8_syn_152 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel8_syn_168 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel8_syn_468 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_117 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_135 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_153 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_171 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_189 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_207 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_225 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_243 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_261 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_279 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_297 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_315 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_333 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_351 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_369 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_387 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_405 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_423 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_441 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_459 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_477 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_495 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_513 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_531 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_549 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_567 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_585 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_603 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_621 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_639 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_657 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_673 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_689 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_691 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_694 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_697 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_700 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_703 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_706 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_709 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_712 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_715 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_718 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_721 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_724 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_727 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_730 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_733 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_736 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_739 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_742 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_745 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_748 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_751 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_754 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_757 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_760 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_763 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_766 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_769 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_772 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_775 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_778 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_781 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_784 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/sel9_syn_787 ;  // ../user_source/hdl_source/tf_wav_file_player.v(231)
  wire \u_wav_player/state_reg_syn_dup_24 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/state_reg_syn_dup_25 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/sub1_syn_71 ;  // ../user_source/hdl_source/tf_wav_file_player.v(83)
  wire \u_wav_player/sub1_syn_81 ;  // ../user_source/hdl_source/tf_wav_file_player.v(83)
  wire \u_wav_player/sub1_syn_86 ;  // ../user_source/hdl_source/tf_wav_file_player.v(83)
  wire \u_wav_player/sub3_syn_132 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_134 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_136 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_138 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_140 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_142 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_144 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_146 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_148 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_150 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_152 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_154 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_156 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_158 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_160 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub3_syn_162 ;  // ../user_source/hdl_source/tf_wav_file_player.v(267)
  wire \u_wav_player/sub4_syn_132 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_134 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_136 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_138 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_140 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_142 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_144 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_146 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_148 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_150 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_152 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_154 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_156 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_158 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_160 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/sub4_syn_162 ;  // ../user_source/hdl_source/tf_wav_file_player.v(268)
  wire \u_wav_player/prime_target_b1[9]_syn_2 ;
  wire \u_wav_player/scan_pos[3]_dup_29 ;  // ../user_source/hdl_source/tf_wav_file_player.v(42)
  wire \u_wav_player/scan_pos[2]_dup_27 ;  // ../user_source/hdl_source/tf_wav_file_player.v(42)
  wire \u_wav_player/scan_pos[1]_dup_31 ;  // ../user_source/hdl_source/tf_wav_file_player.v(42)
  wire \u_wav_player/scan_pos[0]_syn_2 ;  // ../user_source/hdl_source/tf_wav_file_player.v(42)
  wire \u_wav_player/chunk_id_b10_n ;
  wire \u_wav_player/chunk_id_b11_n2 ;
  wire \u_wav_player/chunk_id_b3_n_syn_2 ;
  wire \u_wav_player/chunk_id_b4_n_syn_2 ;
  wire \u_wav_player/chunk_id_b5_n_syn_2 ;
  wire \u_wav_player/chunk_id_b9_n ;
  wire \u_wav_player/data_found ;  // ../user_source/hdl_source/tf_wav_file_player.v(57)
  wire \u_wav_player/debug_sample_push ;  // ../user_source/hdl_source/tf_wav_file_player.v(18)
  wire \u_wav_player/error ;  // ../user_source/hdl_source/tf_wav_file_player.v(14)
  wire \u_wav_player/error_n1_syn_2 ;
  wire \u_wav_player/error_n1_syn_4 ;
  wire \u_wav_player/error_n1_syn_6 ;
  wire \u_wav_player/error_n1_syn_8 ;
  wire \u_wav_player/error_n1_syn_10 ;
  wire \u_wav_player/error_n1_syn_12 ;
  wire \u_wav_player/error_n1_syn_14 ;
  wire \u_wav_player/error_n1_syn_16 ;
  wire \u_wav_player/error_n1_syn_18 ;
  wire \u_wav_player/error_n1_syn_20 ;
  wire \u_wav_player/error_n1_syn_22 ;
  wire \u_wav_player/error_n1_syn_24 ;
  wire \u_wav_player/error_n1_syn_26 ;
  wire \u_wav_player/error_n1_syn_28 ;
  wire \u_wav_player/error_n1_syn_30 ;
  wire \u_wav_player/error_n1_syn_32 ;
  wire \u_wav_player/error_n1_syn_34 ;
  wire \u_wav_player/error_n1_syn_36 ;
  wire \u_wav_player/error_n1_syn_38 ;
  wire \u_wav_player/error_n1_syn_40 ;
  wire \u_wav_player/error_n1_syn_42 ;
  wire \u_wav_player/error_n1_syn_44 ;
  wire \u_wav_player/error_n1_syn_46 ;
  wire \u_wav_player/error_n1_syn_48 ;
  wire \u_wav_player/error_n1_syn_50 ;
  wire \u_wav_player/error_n1_syn_52 ;
  wire \u_wav_player/error_n1_syn_54 ;
  wire \u_wav_player/error_n1_syn_56 ;
  wire \u_wav_player/error_n1_syn_58 ;
  wire \u_wav_player/error_n1_syn_60 ;
  wire \u_wav_player/error_n1_syn_62 ;
  wire \u_wav_player/error_n1_syn_64 ;
  wire \u_wav_player/error_n1_syn_66 ;
  wire \u_wav_player/error_n1_syn_68 ;
  wire \u_wav_player/error_n1_syn_71 ;
  wire \u_wav_player/error_n1_syn_74 ;
  wire \u_wav_player/error_n1_syn_76 ;
  wire \u_wav_player/error_n1_syn_78 ;
  wire \u_wav_player/error_n1_syn_80 ;
  wire \u_wav_player/error_n1_syn_83 ;
  wire \u_wav_player/error_n1_syn_85 ;
  wire \u_wav_player/error_n1_syn_87 ;
  wire \u_wav_player/error_n1_syn_89 ;
  wire \u_wav_player/error_n1_syn_91 ;
  wire \u_wav_player/error_n1_syn_93 ;
  wire \u_wav_player/error_n1_syn_95 ;
  wire \u_wav_player/error_n1_syn_97 ;
  wire \u_wav_player/error_n1_syn_99 ;
  wire \u_wav_player/error_n1_syn_101 ;
  wire \u_wav_player/error_n1_syn_103 ;
  wire \u_wav_player/error_n1_syn_105 ;
  wire \u_wav_player/error_n1_syn_107 ;
  wire \u_wav_player/error_n1_syn_109 ;
  wire \u_wav_player/error_n1_syn_111 ;
  wire \u_wav_player/error_n1_syn_113 ;
  wire \u_wav_player/error_n1_syn_115 ;
  wire \u_wav_player/error_n1_syn_117 ;
  wire \u_wav_player/error_n1_syn_119 ;
  wire \u_wav_player/error_n1_syn_121 ;
  wire \u_wav_player/error_n1_syn_123 ;
  wire \u_wav_player/error_n1_syn_125 ;
  wire \u_wav_player/error_n1_syn_127 ;
  wire \u_wav_player/error_n1_syn_129 ;
  wire \u_wav_player/error_n1_syn_132 ;
  wire \u_wav_player/error_n1_syn_134 ;
  wire \u_wav_player/error_n1_syn_136 ;
  wire \u_wav_player/error_n1_syn_138 ;
  wire \u_wav_player/error_n1_syn_140 ;
  wire \u_wav_player/error_n1_syn_142 ;
  wire \u_wav_player/error_n1_syn_144 ;
  wire \u_wav_player/error_n1_syn_146 ;
  wire \u_wav_player/error_n1_syn_148 ;
  wire \u_wav_player/error_n1_syn_151 ;
  wire \u_wav_player/error_n1_syn_153 ;
  wire \u_wav_player/error_n1_syn_155 ;
  wire \u_wav_player/error_n1_syn_157 ;
  wire \u_wav_player/error_n1_syn_159 ;
  wire \u_wav_player/error_n1_syn_161 ;
  wire \u_wav_player/error_n1_syn_163 ;
  wire \u_wav_player/error_n1_syn_165 ;
  wire \u_wav_player/error_n1_syn_167 ;
  wire \u_wav_player/error_n1_syn_169 ;
  wire \u_wav_player/error_n1_syn_171 ;
  wire \u_wav_player/error_n1_syn_173 ;
  wire \u_wav_player/error_n1_syn_175 ;
  wire \u_wav_player/error_n1_syn_177 ;
  wire \u_wav_player/error_n1_syn_179 ;
  wire \u_wav_player/error_n1_syn_181 ;
  wire \u_wav_player/error_n1_syn_183 ;
  wire \u_wav_player/error_n1_syn_185 ;
  wire \u_wav_player/error_n1_syn_187 ;
  wire \u_wav_player/error_n1_syn_190 ;
  wire \u_wav_player/error_n1_syn_192 ;
  wire \u_wav_player/error_n1_syn_194 ;
  wire \u_wav_player/error_n1_syn_196 ;
  wire \u_wav_player/error_n1_syn_198 ;
  wire \u_wav_player/error_n1_syn_200 ;
  wire \u_wav_player/error_n1_syn_203 ;
  wire \u_wav_player/error_n1_syn_205 ;
  wire \u_wav_player/error_n1_syn_207 ;
  wire \u_wav_player/error_n1_syn_209 ;
  wire \u_wav_player/error_n1_syn_211 ;
  wire \u_wav_player/error_n1_syn_213 ;
  wire \u_wav_player/error_n1_syn_215 ;
  wire \u_wav_player/error_n1_syn_217 ;
  wire \u_wav_player/error_n1_syn_219 ;
  wire \u_wav_player/error_n1_syn_221 ;
  wire \u_wav_player/error_n1_syn_223 ;
  wire \u_wav_player/error_n1_syn_225 ;
  wire \u_wav_player/error_n1_syn_227 ;
  wire \u_wav_player/error_n1_syn_229 ;
  wire \u_wav_player/error_n1_syn_231 ;
  wire \u_wav_player/error_n1_syn_237 ;
  wire \u_wav_player/error_n1_syn_239 ;
  wire \u_wav_player/error_n1_syn_241 ;
  wire \u_wav_player/error_n1_syn_243 ;
  wire \u_wav_player/error_n1_syn_245 ;
  wire \u_wav_player/error_n1_syn_247 ;
  wire \u_wav_player/error_n1_syn_249 ;
  wire \u_wav_player/error_n1_syn_251 ;
  wire \u_wav_player/error_n1_syn_253 ;
  wire \u_wav_player/error_n1_syn_255 ;
  wire \u_wav_player/error_n1_syn_258 ;
  wire \u_wav_player/error_n1_syn_260 ;
  wire \u_wav_player/error_n1_syn_262 ;
  wire \u_wav_player/error_n1_syn_264 ;
  wire \u_wav_player/error_n1_syn_266 ;
  wire \u_wav_player/error_n1_syn_268 ;
  wire \u_wav_player/error_n1_syn_270 ;
  wire \u_wav_player/error_n1_syn_272 ;
  wire \u_wav_player/error_n1_syn_274 ;
  wire \u_wav_player/error_n1_syn_276 ;
  wire \u_wav_player/error_n1_syn_278 ;
  wire \u_wav_player/error_n1_syn_281 ;
  wire \u_wav_player/error_n1_syn_283 ;
  wire \u_wav_player/error_n1_syn_285 ;
  wire \u_wav_player/error_n1_syn_289 ;
  wire \u_wav_player/error_n1_syn_291 ;
  wire \u_wav_player/error_n1_syn_294 ;
  wire \u_wav_player/error_n1_syn_296 ;
  wire \u_wav_player/error_n1_syn_298 ;
  wire \u_wav_player/error_n1_syn_300 ;
  wire \u_wav_player/error_n1_syn_302 ;
  wire \u_wav_player/error_n1_syn_304 ;
  wire \u_wav_player/error_n1_syn_306 ;
  wire \u_wav_player/error_n1_syn_309 ;
  wire \u_wav_player/error_n1_syn_311 ;
  wire \u_wav_player/error_n1_syn_313 ;
  wire \u_wav_player/error_n1_syn_315 ;
  wire \u_wav_player/error_n1_syn_318 ;
  wire \u_wav_player/error_n1_syn_321 ;
  wire \u_wav_player/error_n1_syn_323 ;
  wire \u_wav_player/error_n1_syn_325 ;
  wire \u_wav_player/error_n1_syn_327 ;
  wire \u_wav_player/error_n1_syn_329 ;
  wire \u_wav_player/error_n1_syn_331 ;
  wire \u_wav_player/error_n1_syn_334 ;
  wire \u_wav_player/error_n1_syn_337 ;
  wire \u_wav_player/error_n1_syn_340 ;
  wire \u_wav_player/error_n1_syn_342 ;
  wire \u_wav_player/error_n1_syn_344 ;
  wire \u_wav_player/error_n1_syn_346 ;
  wire \u_wav_player/error_n1_syn_348 ;
  wire \u_wav_player/error_n1_syn_350 ;
  wire \u_wav_player/error_n1_syn_352 ;
  wire \u_wav_player/error_n1_syn_354 ;
  wire \u_wav_player/error_n1_syn_356 ;
  wire \u_wav_player/error_n1_syn_358 ;
  wire \u_wav_player/error_n1_syn_360 ;
  wire \u_wav_player/error_n1_syn_362 ;
  wire \u_wav_player/error_n1_syn_364 ;
  wire \u_wav_player/error_n1_syn_366 ;
  wire \u_wav_player/error_n1_syn_368 ;
  wire \u_wav_player/error_n1_syn_370 ;
  wire \u_wav_player/error_n1_syn_372 ;
  wire \u_wav_player/error_n1_syn_374 ;
  wire \u_wav_player/error_n1_syn_377 ;
  wire \u_wav_player/error_n1_syn_379 ;
  wire \u_wav_player/error_n1_syn_381 ;
  wire \u_wav_player/error_n1_syn_383 ;
  wire \u_wav_player/error_n1_syn_385 ;
  wire \u_wav_player/error_n1_syn_387 ;
  wire \u_wav_player/error_n1_syn_389 ;
  wire \u_wav_player/error_n1_syn_391 ;
  wire \u_wav_player/error_n1_syn_393 ;
  wire \u_wav_player/error_n1_syn_395 ;
  wire \u_wav_player/error_n1_syn_397 ;
  wire \u_wav_player/error_n1_syn_399 ;
  wire \u_wav_player/error_n1_syn_401 ;
  wire \u_wav_player/error_n1_syn_403 ;
  wire \u_wav_player/error_n1_syn_405 ;
  wire \u_wav_player/error_n1_syn_407 ;
  wire \u_wav_player/error_n1_syn_409 ;
  wire \u_wav_player/error_n1_syn_411 ;
  wire \u_wav_player/error_n1_syn_413 ;
  wire \u_wav_player/error_n1_syn_415 ;
  wire \u_wav_player/error_n1_syn_417 ;
  wire \u_wav_player/error_n1_syn_419 ;
  wire \u_wav_player/error_n1_syn_422 ;
  wire \u_wav_player/error_n1_syn_424 ;
  wire \u_wav_player/error_n1_syn_426 ;
  wire \u_wav_player/error_n1_syn_429 ;
  wire \u_wav_player/error_n1_syn_432 ;
  wire \u_wav_player/error_n1_syn_434 ;
  wire \u_wav_player/error_n1_syn_436 ;
  wire \u_wav_player/error_n1_syn_438 ;
  wire \u_wav_player/error_n1_syn_440 ;
  wire \u_wav_player/error_n1_syn_442 ;
  wire \u_wav_player/error_n1_syn_444 ;
  wire \u_wav_player/error_n1_syn_446 ;
  wire \u_wav_player/error_n1_syn_449 ;
  wire \u_wav_player/error_n1_syn_451 ;
  wire \u_wav_player/error_n1_syn_453 ;
  wire \u_wav_player/error_n1_syn_455 ;
  wire \u_wav_player/error_n1_syn_457 ;
  wire \u_wav_player/error_n1_syn_459 ;
  wire \u_wav_player/error_n1_syn_461 ;
  wire \u_wav_player/error_n1_syn_463 ;
  wire \u_wav_player/error_n1_syn_465 ;
  wire \u_wav_player/error_n1_syn_467 ;
  wire \u_wav_player/error_n1_syn_470 ;
  wire \u_wav_player/error_n1_syn_472 ;
  wire \u_wav_player/error_n1_syn_474 ;
  wire \u_wav_player/error_n1_syn_477 ;
  wire \u_wav_player/error_n1_syn_479 ;
  wire \u_wav_player/error_n1_syn_481 ;
  wire \u_wav_player/error_n1_syn_483 ;
  wire \u_wav_player/error_n1_syn_485 ;
  wire \u_wav_player/error_n1_syn_487 ;
  wire \u_wav_player/error_n1_syn_489 ;
  wire \u_wav_player/error_n1_syn_491 ;
  wire \u_wav_player/error_n1_syn_493 ;
  wire \u_wav_player/error_n1_syn_495 ;
  wire \u_wav_player/error_n1_syn_497 ;
  wire \u_wav_player/error_n1_syn_499 ;
  wire \u_wav_player/error_n1_syn_501 ;
  wire \u_wav_player/error_n1_syn_503 ;
  wire \u_wav_player/error_n1_syn_505 ;
  wire \u_wav_player/error_n1_syn_507 ;
  wire \u_wav_player/error_n1_syn_509 ;
  wire \u_wav_player/error_n1_syn_511 ;
  wire \u_wav_player/error_n1_syn_513 ;
  wire \u_wav_player/error_n1_syn_515 ;
  wire \u_wav_player/error_n1_syn_517 ;
  wire \u_wav_player/error_n1_syn_519 ;
  wire \u_wav_player/error_n1_syn_521 ;
  wire \u_wav_player/error_n1_syn_523 ;
  wire \u_wav_player/error_n1_syn_525 ;
  wire \u_wav_player/error_n1_syn_527 ;
  wire \u_wav_player/error_n1_syn_529 ;
  wire \u_wav_player/error_n1_syn_531 ;
  wire \u_wav_player/error_n1_syn_533 ;
  wire \u_wav_player/error_n1_syn_535 ;
  wire \u_wav_player/error_n1_syn_537 ;
  wire \u_wav_player/error_n1_syn_539 ;
  wire \u_wav_player/error_n1_syn_541 ;
  wire \u_wav_player/error_n1_syn_543 ;
  wire \u_wav_player/error_n1_syn_545 ;
  wire \u_wav_player/error_n1_syn_dup_1117 ;
  wire \u_wav_player/error_n1_syn_dup_1119 ;
  wire \u_wav_player/error_n1_syn_dup_1121 ;
  wire \u_wav_player/error_n1_syn_dup_1123 ;
  wire \u_wav_player/error_n1_syn_dup_1125 ;
  wire \u_wav_player/error_n25 ;
  wire \u_wav_player/error_n33 ;
  wire \u_wav_player/fifo_head_bypass ;  // ../user_source/hdl_source/tf_wav_file_player.v(78)
  wire \u_wav_player/fifo_head_valid ;  // ../user_source/hdl_source/tf_wav_file_player.v(80)
  wire \u_wav_player/fifo_mem_n ;
  wire \u_wav_player/fifo_pop ;  // ../user_source/hdl_source/tf_wav_file_player.v(81)
  wire \u_wav_player/fifo_ram_q_b_n ;
  wire \u_wav_player/fmt_fields_valid ;  // ../user_source/hdl_source/tf_wav_file_player.v(56)
  wire \u_wav_player/fmt_found ;  // ../user_source/hdl_source/tf_wav_file_player.v(57)
  wire \u_wav_player/loaded_sector_valid ;  // ../user_source/hdl_source/tf_wav_file_player.v(41)
  wire \u_wav_player/play_in_range_n1 ;
  wire \u_wav_player/play_in_range_n2_syn_2 ;
  wire \u_wav_player/play_push_req ;  // ../user_source/hdl_source/tf_wav_file_player.v(86)
  wire \u_wav_player/prefetch_bypass_n1 ;
  wire \u_wav_player/primed ;  // ../user_source/hdl_source/tf_wav_file_player.v(14)
  wire \u_wav_player/sample_take ;  // ../user_source/hdl_source/tf_wav_file_player.v(13)
  wire \u_wav_player/scan_byte_valid ;  // ../user_source/hdl_source/tf_wav_file_player.v(37)
  wire \u_wav_player/sd_end ;  // ../user_source/hdl_source/tf_wav_file_player.v(12)
  wire \u_wav_player/sd_valid ;  // ../user_source/hdl_source/tf_wav_file_player.v(12)
  wire \u_wav_player/sector_mem_n ;
  wire \video_pll_m0/clk0_buf ;  // ../user_source/hdl_source/ip/video_pll.v(37)
  wire \video_timing_data_m0/de ;  // ../user_source/hdl_source/SD/video_timing_data.v(14)
  wire \video_timing_data_m0/video_de ;  // ../user_source/hdl_source/SD/video_timing_data.v(19)
  wire \video_timing_data_m0/video_de_d0 ;  // ../user_source/hdl_source/SD/video_timing_data.v(23)
  wire \video_timing_data_m0/video_vs ;  // ../user_source/hdl_source/SD/video_timing_data.v(18)
  wire \video_timing_data_m0/video_vs_d0 ;  // ../user_source/hdl_source/SD/video_timing_data.v(22)
  wire \video_timing_data_m0/vs ;  // ../user_source/hdl_source/SD/video_timing_data.v(13)
  wire \video_timing_data_m0/color_bar_m0/add0_syn_44 ;  // ../user_source/hdl_source/SD/color_bar.v(182)
  wire \video_timing_data_m0/color_bar_m0/add0_syn_52 ;  // ../user_source/hdl_source/SD/color_bar.v(182)
  wire \video_timing_data_m0/color_bar_m0/add1_syn_48 ;  // ../user_source/hdl_source/SD/color_bar.v(203)
  wire \video_timing_data_m0/color_bar_m0/add1_syn_68 ;  // ../user_source/hdl_source/SD/color_bar.v(203)
  wire \video_timing_data_m0/color_bar_m0/v_active_reg_syn_5 ;  // ../user_source/hdl_source/SD/color_bar.v(246)
  wire \video_timing_data_m0/color_bar_m0/v_active_reg_syn_8 ;  // ../user_source/hdl_source/SD/color_bar.v(246)
  wire \video_timing_data_m0/color_bar_m0/vs_reg_reg_syn_5 ;  // ../user_source/hdl_source/SD/color_bar.v(234)
  wire \video_timing_data_m0/color_bar_m0/h_cnt_b[9]_syn_2 ;
  wire \video_timing_data_m0/color_bar_m0/h_cnt_b[9]_syn_4 ;
  wire \video_timing_data_m0/color_bar_m0/v_cnt_b2[9]_syn_2 ;
  wire \video_timing_data_m0/color_bar_m0/v_cnt_b2[9]_syn_4 ;
  wire \video_timing_data_m0/color_bar_m0/h_active ;  // ../user_source/hdl_source/SD/color_bar.v(148)
  wire \video_timing_data_m0/color_bar_m0/hs_reg_n2 ;
  wire \video_timing_data_m0/color_bar_m0/v_active ;  // ../user_source/hdl_source/SD/color_bar.v(149)
  wire \video_timing_data_m0/color_bar_m0/v_active_n6 ;
  wire \video_timing_data_m0/color_bar_m0/vs_reg ;  // ../user_source/hdl_source/SD/color_bar.v(138)
  wire \media_reset_count_reg[4]_syn_4 ;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(165)
  wire \media_reset_count_reg[4]_syn_6 ;  // ../user_source/hdl_source/top_tf_hdmi_audio.v(165)
  wire \u_adjust_control/brightness_pending_reg[1]_syn_2 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/brightness_pending_reg[2]_syn_4 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/brightness_pending_reg[3]_syn_5 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/brightness_pending_reg[3]_syn_7 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/brightness_pending_reg[3]_syn_9 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/contrast_pending_reg[0]_syn_4 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/contrast_pending_reg[2]_syn_4 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/mode_reg[1]_syn_5 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/mode_reg[1]_syn_7 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/mode_reg[1]_syn_9 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/mode_reg[1]_syn_11 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/mode_reg[1]_syn_13 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/mode_reg[1]_syn_15 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_adjust_control/mode_reg[1]_syn_17 ;  // ../user_source/hdl_source/player_adjust_control.v(119)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_4 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_6 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_8 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_10 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_12 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_14 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_17 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_19 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_21 ;  // ../user_source/hdl_source/hdmi_audio_tone_pcm_scale.v(43)
  wire \u_bmp_file_player/disp_buf_idx_reg[0]_syn_4 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/gap_count_reg[0]_syn_4 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/height_low_reg[8]_syn_4 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/width_low_reg[10]_syn_5 ;  // ../user_source/hdl_source/tf_bmp_file_player.v(120)
  wire \u_bmp_file_player/u_scale/div_bit_reg[4]_syn_5 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/div_bit_reg[4]_syn_7 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/interval_count_reg[1]_syn_4 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/interval_count_reg[1]_syn_7 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_bmp_file_player/u_scale/interval_count_reg[1]_syn_10 ;  // ../user_source/hdl_source/bmp_scale_engine.v(138)
  wire \u_catalog/fat_entry_value_reg[24]_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/fat_entry_value_reg[24]_syn_7 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/fat_entry_value_reg[24]_syn_9 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/fat_entry_value_reg[24]_syn_12 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/gap_count_reg[1]_syn_5 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/gap_count_reg[1]_syn_7 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/state_reg[1]_syn_4 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/state_reg[1]_syn_6 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/state_reg[1]_syn_8 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/state_reg[1]_syn_10 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_catalog/state_reg[1]_syn_12 ;  // ../user_source/hdl_source/fat32_catalog.v(120)
  wire \u_dynamic_text/minute_ones_reg[3]_syn_4 ;  // ../user_source/hdl_source/player_dynamic_text.v(32)
  wire \u_dynamic_text/minute_ones_reg[3]_syn_6 ;  // ../user_source/hdl_source/player_dynamic_text.v(32)
  wire \u_dynamic_text/minute_ones_reg[3]_syn_8 ;  // ../user_source/hdl_source/player_dynamic_text.v(32)
  wire \u_dynamic_text/minute_ones_reg[3]_syn_10 ;  // ../user_source/hdl_source/player_dynamic_text.v(32)
  wire \u_dynamic_text/minute_ones_reg[3]_syn_13 ;  // ../user_source/hdl_source/player_dynamic_text.v(32)
  wire \u_dynamic_text/minute_ones_reg[3]_syn_15 ;  // ../user_source/hdl_source/player_dynamic_text.v(32)
  wire \u_dynamic_text/minute_tens_reg[1]_syn_4 ;  // ../user_source/hdl_source/player_dynamic_text.v(32)
  wire \u_file_mapper/busy_reg[0]_syn_4 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[0]_syn_6 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[0]_syn_9 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[0]_syn_11 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[0]_syn_13 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[0]_syn_16 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[0]_syn_18 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[0]_syn_20 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[0]_syn_22 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/busy_reg[1]_syn_4 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/cache_valid_reg[0]_syn_5 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/cache_valid_reg[0]_syn_7 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[3]_syn_4 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_5 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_7 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_9 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_11 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_13 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_15 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_17 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_20 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_22 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_24 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_26 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_28 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_30 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_32 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_35 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_38 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_40 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_42 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_44 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_47 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_49 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_51 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_53 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_55 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_57 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_59 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_62 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_64 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_66 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_68 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_70 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_72 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_74 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_77 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_80 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_82 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_84 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_87 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_90 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_92 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_94 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_96 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_98 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/core_state_reg[6]_syn_100 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/fat_b3_reg[2]_syn_5 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/fat_b3_reg[2]_syn_7 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/fat_b3_reg[2]_syn_9 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/fat_b3_reg[2]_syn_11 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/fat_b3_reg[2]_syn_13 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/fat_b3_reg[2]_syn_15 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[0]_syn_4 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[0]_syn_6 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[0]_syn_8 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[0]_syn_10 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[0]_syn_12 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[0]_syn_14 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[0]_syn_16 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[0]_syn_18 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_4 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_6 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_8 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_10 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_12 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_14 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_16 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_18 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/queued_reg[1]_syn_20 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/walk_initialized_reg[0]_syn_4 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/walk_initialized_reg[0]_syn_6 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/walk_initialized_reg[1]_syn_4 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_file_mapper/wanted_offset_reg[2]_syn_4 ;  // ../user_source/hdl_source/fat32_dual_file_sector.v(142)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$my_reg[2]_syn_4 ;  // ../user_source/hdl_source/jpeg420_word_address.v(24)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$my_reg[2]_syn_7 ;  // ../user_source/hdl_source/jpeg420_word_address.v(24)
  wire \u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/u_jpeg_address/compact565$my_reg[2]_syn_9 ;  // ../user_source/hdl_source/jpeg420_word_address.v(24)
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/S_packet_cnt_reg[3]_syn_4 ;
  wire \u_jpeg_core/u_jpeg_bitbuffer/rd_ptr_q_reg[5]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(79)
  wire \u_jpeg_core/u_jpeg_bitbuffer/rd_ptr_q_reg[5]_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(79)
  wire \u_jpeg_core/u_jpeg_bitbuffer/rd_ptr_q_reg[5]_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_bitbuffer.v(79)
  wire \u_jpeg_core/u_jpeg_dqt/outport_idx_q_reg[0]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(258)
  wire \u_jpeg_core/u_jpeg_dqt/outport_idx_q_reg[1]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(258)
  wire \u_jpeg_core/u_jpeg_dqt/outport_idx_q_reg[2]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(258)
  wire \u_jpeg_core/u_jpeg_dqt/outport_idx_q_reg[3]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(258)
  wire \u_jpeg_core/u_jpeg_dqt/outport_idx_q_reg[4]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(258)
  wire \u_jpeg_core/u_jpeg_dqt/outport_idx_q_reg[5]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_dqt.v(258)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/count_q_reg[2]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/count_q_reg[3]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/count_q_reg[3]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/count_q_reg[3]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_idct/u_id_fifo/count_q_reg[3]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_ready_q_reg[0]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(197)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_ready_q_reg[1]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(197)
  wire \u_jpeg_core/u_jpeg_idct/u_input/block_ready_q_reg[2]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(197)
  wire \u_jpeg_core/u_jpeg_idct/u_input/clear_addr_q_reg[3]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(162)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q_reg[0]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q_reg[1]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q_reg[2]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_input/rd_addr_q_reg[3]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_ram.v(278)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/block_ready_q_reg[1]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(154)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q_reg[2]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(239)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q_reg[2]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(239)
  wire \u_jpeg_core/u_jpeg_idct/u_transpose/rd_addr_q_reg[3]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_idct_transpose.v(239)
  wire \u_jpeg_core/u_jpeg_input/img_cb_dqt_table_q_reg[0]_syn_6 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(475)
  wire \u_jpeg_core/u_jpeg_input/img_cb_dqt_table_q_reg[0]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(475)
  wire \u_jpeg_core/u_jpeg_input/img_cb_dqt_table_q_reg[0]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(475)
  wire \u_jpeg_core/u_jpeg_input/img_cb_dqt_table_q_reg[0]_syn_12 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(475)
  wire \u_jpeg_core/u_jpeg_input/img_cb_dqt_table_q_reg[0]_syn_14 ;  // ../user_source/hdl_source/jpeg/jpeg_input.v(475)
  wire \u_jpeg_core/u_jpeg_mcu_proc/u_id/block_type_q_reg[0]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_mcu_id.v(69)
  wire \u_jpeg_core/u_jpeg_output/u_info/count_q_reg[2]_syn_4 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_output/u_info/count_q_reg[3]_syn_8 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_output/u_info/count_q_reg[3]_syn_10 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_output/u_info/count_q_reg[3]_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_output/u_info/count_q_reg[3]_syn_16 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_output/u_info/count_q_reg[3]_syn_18 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_output/u_info/count_q_reg[3]_syn_21 ;  // ../user_source/hdl_source/jpeg/jpeg_output_fifo.v(78)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_reg[1]_syn_5 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(375)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_reg[1]_syn_7 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(375)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_reg[1]_syn_9 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(375)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_reg[1]_syn_11 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(375)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_reg[1]_syn_13 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(375)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_reg[1]_syn_15 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(375)
  wire \u_jpeg_core/u_jpeg_output/u_ram_cb/cx_half_q_reg[1]_syn_17 ;  // ../user_source/hdl_source/jpeg/jpeg_output_cx_ram.v(375)
  wire \u_osd_state/frame_pixel_reg[8]_syn_4 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_osd_state/wipe_rows_reg[8]_syn_5 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_osd_state/wipe_rows_reg[8]_syn_8 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_osd_state/wipe_rows_reg[8]_syn_10 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_osd_state/wipe_rows_reg[8]_syn_12 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_osd_state/wipe_rows_reg[8]_syn_14 ;  // ../user_source/hdl_source/player_osd_state.v(52)
  wire \u_pcm_waveform/update_index_reg[0]_syn_4 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/update_state_reg[1]_syn_4 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/update_state_reg[4]_syn_5 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/update_state_reg[4]_syn_7 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/update_state_reg[4]_syn_10 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/update_state_reg[4]_syn_12 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/update_state_reg[4]_syn_14 ;  // ../user_source/hdl_source/player_pcm_waveform.v(105)
  wire \u_pcm_waveform/u_spectrum/fft_stage_reg[2]_syn_4 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire \u_pcm_waveform/u_spectrum/fft_stage_reg[2]_syn_7 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire \u_pcm_waveform/u_spectrum/scan_band_reg[4]_syn_4 ;  // ../user_source/hdl_source/player_spectrum_analyzer.v(326)
  wire \u_status_hex/bit_count_reg[3]_syn_4 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_status_hex/bit_count_reg[3]_syn_6 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_status_hex/half_count_reg[3]_syn_4 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_video_reader/header_frame_index_reg[8]_syn_4 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/header_frame_index_reg[8]_syn_6 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/header_frame_index_reg[8]_syn_8 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_reader/header_frame_index_reg[8]_syn_10 ;  // ../user_source/hdl_source/mjp_file_reader.v(84)
  wire \u_video_schedule/gap_reg[3]_syn_4 ;  // ../user_source/hdl_source/player_video_schedule.v(31)
  wire \u_wav_player/field_index_reg[1]_syn_4 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \u_wav_player/field_index_reg[1]_syn_6 ;  // ../user_source/hdl_source/tf_wav_file_player.v(130)
  wire \dq[0] ;
  wire \dq[6] ;
  wire \dq[7] ;
  wire dm0;
  wire cke;
  wire we_n;
  wire \dq[1] ;
  wire cas_n;
  wire ras_n;
  wire cs_n;
  wire \addr[9] ;
  wire \addr[8] ;
  wire \addr[7] ;
  wire \addr[6] ;
  wire \addr[5] ;
  wire \addr[4] ;
  wire dm2;
  wire \dq[23] ;
  wire \dq[22] ;
  wire \dq[21] ;
  wire \dq[20] ;
  wire \dq[19] ;
  wire \dq[18] ;
  wire \dq[17] ;
  wire \dq[16] ;
  wire \dq[31] ;
  wire \dq[30] ;
  wire \dq[2] ;
  wire \dq[29] ;
  wire \dq[28] ;
  wire \dq[27] ;
  wire \dq[26] ;
  wire \dq[25] ;
  wire \dq[24] ;
  wire \dq[3] ;
  wire dm3;
  wire \addr[3] ;
  wire \addr[2] ;
  wire \addr[1] ;
  wire \addr[0] ;
  wire \addr[10] ;
  wire \ba[0] ;
  wire \dq[4] ;
  wire \ba[1] ;
  wire clk0;
  wire dm1;
  wire \dq[8] ;
  wire \dq[9] ;
  wire \dq[5] ;
  wire \dq[10] ;
  wire \dq[11] ;
  wire \dq[12] ;
  wire \dq[13] ;
  wire \dq[14] ;
  wire \dq[15] ;
  wire \u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst_dup_34_holdbuf ;

  EG_PHY_LSLICE #(
    //.LUTF0("(C@D)"),
    //.LUTG0("(C@D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111111110000),
    .INIT_LUTG0(16'b0000111111110000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/tone_mode_reg_syn_8  (
    .c({open_n8088,\u_audio_probe/tone_mode }),
    .clk(\u_adjust_control/clk ),
    .d({open_n8090,\u_audio_probe/tone_toggle }),
    .sr(\u_file_mapper/rst_dup_15 ),
    .q({open_n8112,\u_audio_probe/tone_mode }));
EG_PHY_LSLICE #(
    //.LUTF0("(~D)"),
    //.LUTG0("(~D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000011111111),
    .INIT_LUTG0(16'b0000000011111111),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[0]_syn_4  (
    .clk(\u_adjust_control/clk ),
    .d({open_n8120,\u_audio_probe/u_acr/S_acr_cts_cnt [0]}),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .q({open_n8142,\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [0]}));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[10]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [10:9]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_110 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [10:9]),
    .fco(\u_audio_probe/u_acr/add0_syn_112 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [10:9]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[12]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [12:11]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_112 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [12:11]),
    .fco(\u_audio_probe/u_acr/add0_syn_114 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [12:11]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[14]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [14:13]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_114 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [14:13]),
    .fco(\u_audio_probe/u_acr/add0_syn_116 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [14:13]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[16]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [16:15]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_116 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [16:15]),
    .fco(\u_audio_probe/u_acr/add0_syn_118 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [16:15]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[18]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [18:17]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_118 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [18:17]),
    .fco(\u_audio_probe/u_acr/add0_syn_120 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [18:17]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[19]_syn_4  (
    .a({open_n8233,\u_audio_probe/u_acr/S_acr_cts_cnt [19]}),
    .b({open_n8234,1'b0}),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_120 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f({open_n8251,\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [19]}),
    .q({open_n8255,\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [19]}));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[2]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [2:1]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_102 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [2:1]),
    .fco(\u_audio_probe/u_acr/add0_syn_104 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [2:1]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[4]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [4:3]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_104 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [4:3]),
    .fco(\u_audio_probe/u_acr/add0_syn_106 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [4:3]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[6]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [6:5]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_106 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [6:5]),
    .fco(\u_audio_probe/u_acr/add0_syn_108 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [6:5]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_audio_probe/u_acr/O_acr_cts_reg[8]_syn_4  (
    .a(\u_audio_probe/u_acr/S_acr_cts_cnt [8:7]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_acr/add0_syn_108 ),
    .sr(\u_audio_probe/u_acr/S_audio_valid_div ),
    .f(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [8:7]),
    .fco(\u_audio_probe/u_acr/add0_syn_110 ),
    .q(\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_cts [8:7]));
EG_PHY_LSLICE #(
    //.LUTF0("(D*C*B*~A)"),
    //.LUTG0("(D*C*B*~A)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0100000000000000),
    .INIT_LUTG0(16'b0100000000000000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_audio_probe/u_acr/O_acr_n_reg[11]_syn_4  (
    .a({open_n8328,\u_audio_probe/u_acr/S_audio_div_cnt [4]}),
    .b({open_n8329,\u_audio_probe/u_acr/S_audio_div_cnt [5]}),
    .c({open_n8330,audio_valid_dup_51}),
    .clk(\u_adjust_control/clk ),
    .d({open_n8332,\u_audio_probe/u_acr/lt0_syn_35 }),
    .f({open_n8350,\u_audio_probe/u_acr/S_audio_valid_div }),
    .q({open_n8354,\u_hdmi_1_4b_transmitter_core_wrapper/I_acr_n [11]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*D)"),
    //.LUTF1("(~C*D)"),
    //.LUTG0("(~C*D)"),
    //.LUTG1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100000000),
    .INIT_LUTF1(16'b0000111100000000),
    .INIT_LUTG0(16'b0000111100000000),
    .INIT_LUTG1(16'b0000111100000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[10]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d(\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [10:9]),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q(\u_audio_probe/u_acr/S_acr_cts_cnt [10:9]));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*D)"),
    //.LUTG0("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100000000),
    .INIT_LUTG0(16'b0000111100000000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[11]_syn_4  (
    .c({open_n8385,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({open_n8387,\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [11]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({open_n8409,\u_audio_probe/u_acr/S_acr_cts_cnt [11]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*D)"),
    //.LUTF1("(~C*D)"),
    //.LUTG0("(~C*D)"),
    //.LUTG1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100000000),
    .INIT_LUTF1(16'b0000111100000000),
    .INIT_LUTG0(16'b0000111100000000),
    .INIT_LUTG1(16'b0000111100000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[12]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [12],\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [13]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_acr_cts_cnt [12],\u_audio_probe/u_acr/S_acr_cts_cnt [13]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*D)"),
    //.LUT1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000111100000000),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[14]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [14],\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [15]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_acr_cts_cnt [14],\u_audio_probe/u_acr/S_acr_cts_cnt [15]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*D)"),
    //.LUT1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000111100000000),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[16]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [16],\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [17]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_acr_cts_cnt [16],\u_audio_probe/u_acr/S_acr_cts_cnt [17]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*D)"),
    //.LUTF1("(~C*D)"),
    //.LUTG0("(~C*D)"),
    //.LUTG1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100000000),
    .INIT_LUTF1(16'b0000111100000000),
    .INIT_LUTG0(16'b0000111100000000),
    .INIT_LUTG1(16'b0000111100000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[18]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [18],\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [19]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_acr_cts_cnt [18],\u_audio_probe/u_acr/S_acr_cts_cnt [19]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*D)"),
    //.LUTG0("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100000000),
    .INIT_LUTG0(16'b0000111100000000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[1]_syn_4  (
    .c({open_n8510,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({open_n8512,\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [1]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({open_n8534,\u_audio_probe/u_acr/S_acr_cts_cnt [1]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*D)"),
    //.LUT1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000111100000000),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[2]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [2],\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [3]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_acr_cts_cnt [2],\u_audio_probe/u_acr/S_acr_cts_cnt [3]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*~D)"),
    //.LUT1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001111),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[4]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [4],\u_audio_probe/u_acr/S_acr_cts_cnt [0]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_acr_cts_cnt [4],\u_audio_probe/u_acr/S_acr_cts_cnt [0]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*D)"),
    //.LUT1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000111100000000),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[5]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [5],\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [6]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_acr_cts_cnt [5],\u_audio_probe/u_acr/S_acr_cts_cnt [6]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*D)"),
    //.LUTF1("(~C*D)"),
    //.LUTG0("(~C*D)"),
    //.LUTG1("(~C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100000000),
    .INIT_LUTF1(16'b0000111100000000),
    .INIT_LUTG0(16'b0000111100000000),
    .INIT_LUTG1(16'b0000111100000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_acr_cts_cnt_reg[7]_syn_4  (
    .c({\u_audio_probe/u_acr/S_audio_valid_div ,\u_audio_probe/u_acr/S_audio_valid_div }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [7],\u_audio_probe/u_acr/S_acr_cts_cnt_b1 [8]}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_acr_cts_cnt [7],\u_audio_probe/u_acr/S_acr_cts_cnt [8]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*B*C*~(D)+~(A)*B*~(C)*D+A*B*~(C)*D+A*~(B)*C*D)"),
    //.LUTF1("(A*~((C*B))*~(D)+A*(C*B)*~(D)+~(A)*~((C*B))*D)"),
    //.LUTG0("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*B*C*~(D)+~(A)*B*~(C)*D+A*B*~(C)*D+A*~(B)*C*D)"),
    //.LUTG1("(A*~((C*B))*~(D)+A*(C*B)*~(D)+~(A)*~((C*B))*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0010110001001100),
    .INIT_LUTF1(16'b0001010110101010),
    .INIT_LUTG0(16'b0010110001001100),
    .INIT_LUTG1(16'b0001010110101010),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_audio_div_cnt_reg[0]_syn_7  (
    .a({\u_audio_probe/u_acr/S_audio_div_cnt [0],\u_audio_probe/u_acr/S_audio_div_cnt [4]}),
    .b({\u_audio_probe/u_acr/S_audio_div_cnt [4],\u_audio_probe/u_acr/S_audio_div_cnt [5]}),
    .c({\u_audio_probe/u_acr/S_audio_div_cnt [5],audio_valid_dup_51}),
    .clk(\u_adjust_control/clk ),
    .d({audio_valid_dup_51,\u_audio_probe/u_acr/lt0_syn_35 }),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({\u_audio_probe/u_acr/S_audio_div_cnt [0],\u_audio_probe/u_acr/S_audio_div_cnt [5]}));
EG_PHY_MSLICE #(
    //.LUT0("(~(A)*B*~((D*C))*~(0)+A*B*~((D*C))*~(0)+~(A)*B*(D*C)*~(0)+A*B*(D*C)*~(0)+A*~(B)*~((D*C))*0+~(A)*B*~((D*C))*0)"),
    //.LUT1("(~(A)*B*~((D*C))*~(1)+A*B*~((D*C))*~(1)+~(A)*B*(D*C)*~(1)+A*B*(D*C)*~(1)+A*~(B)*~((D*C))*1+~(A)*B*~((D*C))*1)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1100110011001100),
    .INIT_LUT1(16'b0000011001100110),
    .MODE("LOGIC"),
    .MSFXMUX("ON"),
    .REG0_REGSET("RESET"),
    .REG0_SD("FX"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_audio_div_cnt_reg[1]_syn_7  (
    .a({\u_audio_probe/u_acr/S_audio_div_cnt [0],\u_audio_probe/u_acr/S_audio_div_cnt [0]}),
    .b({\u_audio_probe/u_acr/S_audio_div_cnt [1],\u_audio_probe/u_acr/S_audio_div_cnt [1]}),
    .c({\u_audio_probe/u_acr/S_audio_div_cnt [4],\u_audio_probe/u_acr/S_audio_div_cnt [4]}),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_audio_div_cnt [5],\u_audio_probe/u_acr/S_audio_div_cnt [5]}),
    .mi({open_n8660,audio_valid_dup_51}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({open_n8666,\u_audio_probe/u_acr/S_audio_div_cnt [1]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~((B*A))*C*~((0*D))*~(0)+(B*A)*C*~((0*D))*~(0)+~((B*A))*C*(0*D)*~(0)+(B*A)*C*(0*D)*~(0)+(B*A)*~(C)*~((0*D))*0+~((B*A))*C*~((0*D))*0)"),
    //.LUTF1("(~((B*A))*C*~((0*D))*~(1)+(B*A)*C*~((0*D))*~(1)+~((B*A))*C*(0*D)*~(1)+(B*A)*C*(0*D)*~(1)+(B*A)*~(C)*~((0*D))*1+~((B*A))*C*~((0*D))*1)"),
    //.LUTG0("(~((B*A))*C*~((1*D))*~(0)+(B*A)*C*~((1*D))*~(0)+~((B*A))*C*(1*D)*~(0)+(B*A)*C*(1*D)*~(0)+(B*A)*~(C)*~((1*D))*0+~((B*A))*C*~((1*D))*0)"),
    //.LUTG1("(~((B*A))*C*~((1*D))*~(1)+(B*A)*C*~((1*D))*~(1)+~((B*A))*C*(1*D)*~(1)+(B*A)*C*(1*D)*~(1)+(B*A)*~(C)*~((1*D))*1+~((B*A))*C*~((1*D))*1)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111000011110000),
    .INIT_LUTF1(16'b0111100001111000),
    .INIT_LUTG0(16'b1111000011110000),
    .INIT_LUTG1(16'b0000000001111000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("FX"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_audio_div_cnt_reg[2]_syn_7  (
    .a({\u_audio_probe/u_acr/S_audio_div_cnt [0],\u_audio_probe/u_acr/S_audio_div_cnt [0]}),
    .b({\u_audio_probe/u_acr/S_audio_div_cnt [1],\u_audio_probe/u_acr/S_audio_div_cnt [1]}),
    .c({\u_audio_probe/u_acr/S_audio_div_cnt [2],\u_audio_probe/u_acr/S_audio_div_cnt [2]}),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_audio_div_cnt [4],\u_audio_probe/u_acr/S_audio_div_cnt [4]}),
    .e({\u_audio_probe/u_acr/S_audio_div_cnt [5],\u_audio_probe/u_acr/S_audio_div_cnt [5]}),
    .mi({open_n8669,audio_valid_dup_51}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({open_n8686,\u_audio_probe/u_acr/S_audio_div_cnt [2]}));
EG_PHY_MSLICE #(
    //.LUT0("(~(A)*B*~((D*C))*~(0)+A*B*~((D*C))*~(0)+~(A)*B*(D*C)*~(0)+A*B*(D*C)*~(0)+A*~(B)*~((D*C))*0+~(A)*B*~((D*C))*0)"),
    //.LUT1("(~(A)*B*~((D*C))*~(1)+A*B*~((D*C))*~(1)+~(A)*B*(D*C)*~(1)+A*B*(D*C)*~(1)+A*~(B)*~((D*C))*1+~(A)*B*~((D*C))*1)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1100110011001100),
    .INIT_LUT1(16'b0000011001100110),
    .MODE("LOGIC"),
    .MSFXMUX("ON"),
    .REG0_REGSET("RESET"),
    .REG0_SD("FX"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_audio_div_cnt_reg[3]_syn_8  (
    .a({\u_audio_probe/u_acr/lt0_syn_31 ,\u_audio_probe/u_acr/lt0_syn_31 }),
    .b({\u_audio_probe/u_acr/S_audio_div_cnt [3],\u_audio_probe/u_acr/S_audio_div_cnt [3]}),
    .c({\u_audio_probe/u_acr/S_audio_div_cnt [4],\u_audio_probe/u_acr/S_audio_div_cnt [4]}),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_acr/S_audio_div_cnt [5],\u_audio_probe/u_acr/S_audio_div_cnt [5]}),
    .mi({open_n8698,audio_valid_dup_51}),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({open_n8704,\u_audio_probe/u_acr/S_audio_div_cnt [3]}));
EG_PHY_MSLICE #(
    //.LUT0("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0001101000101010),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_acr/S_audio_div_cnt_reg[4]_syn_8  (
    .a({open_n8705,\u_audio_probe/u_acr/S_audio_div_cnt [4]}),
    .b({open_n8706,\u_audio_probe/u_acr/S_audio_div_cnt [5]}),
    .c({open_n8707,audio_valid_dup_51}),
    .clk(\u_adjust_control/clk ),
    .d({open_n8709,\u_audio_probe/u_acr/lt0_syn_35 }),
    .sr(\u_file_mapper/rst_dup_73 ),
    .q({open_n8727,\u_audio_probe/u_acr/S_audio_div_cnt [4]}));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_acr/add0_syn_126"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_acr/add0_syn_126  (
    .a({\u_audio_probe/u_acr/S_acr_cts_cnt [0],1'b0}),
    .b({1'b1,open_n8728}),
    .fco(\u_audio_probe/u_acr/add0_syn_102 ));
EG_PHY_LSLICE #(
    //.LUTF0("(A*~(0*~0*~D*~C*~B))"),
    //.LUTF1("(A*~(1*~0*~D*~C*~B))"),
    //.LUTG0("(A*~(0*~1*~D*~C*~B))"),
    //.LUTG1("(A*~(1*~1*~D*~C*~B))"),
    .INIT_LUTF0(16'b1010101010101010),
    .INIT_LUTF1(16'b1010101010101000),
    .INIT_LUTG0(16'b1010101010101010),
    .INIT_LUTG1(16'b1010101010101010),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"))
    \u_audio_probe/u_bridge/acknowledge_toggle_reg_syn_11  (
    .a({\u_wav_player/fifo_head_valid ,\u_wav_player/fifo_head_valid }),
    .b({\u_wav_player/debug_fifo_level [8],\u_wav_player/debug_fifo_level [8]}),
    .c({\u_wav_player/debug_fifo_level [9],\u_wav_player/debug_fifo_level [9]}),
    .d({\u_wav_player/debug_fifo_level [10],\u_wav_player/debug_fifo_level [10]}),
    .e({\u_wav_player/debug_fifo_level [11],\u_wav_player/debug_fifo_level [11]}),
    .mi({open_n8757,\u_wav_player/sub1_syn_81 }),
    .fx({open_n8773,\u_audio_probe/u_bridge/acknowledge_toggle_reg_syn_5 }));
EG_PHY_MSLICE #(
    //.LUT0("(D*~(B)*~(C)+D*B*~(C)+~(D)*B*C+D*B*C)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1100111111000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/acknowledge_toggle_reg_syn_13  (
    .b({open_n8778,\u_audio_probe/u_bridge/request_sync [1]}),
    .c({open_n8779,\u_audio_probe/u_bridge/acknowledge_toggle_reg_syn_5 }),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({open_n8781,\u_audio_probe/u_bridge/acknowledge_toggle }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({open_n8799,\u_audio_probe/u_bridge/acknowledge_toggle }));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/add0_syn_136  (
    .a({\u_audio_probe/u_bridge/sample_acc [7],1'b0}),
    .b({1'b1,open_n8800}),
    .clk(\u_adjust_control/clk ),
    .mi({\video_delay_m0/de_d [0],\video_timing_data_m0/de }),
    .sr(\u_file_mapper/rst_dup_102 ),
    .fco(\u_audio_probe/u_bridge/add0_syn_95 ),
    .q(\video_delay_m0/de_d [1:0]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_139  (
    .a(\u_audio_probe/u_bridge/sample_acc [9:8]),
    .b(2'b11),
    .fci(\u_audio_probe/u_bridge/add0_syn_95 ),
    .f(\u_audio_probe/u_bridge/next_acc [9:8]),
    .fco(\u_audio_probe/u_bridge/add0_syn_97 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_142  (
    .a(\u_audio_probe/u_bridge/sample_acc [11:10]),
    .b(2'b10),
    .fci(\u_audio_probe/u_bridge/add0_syn_97 ),
    .f(\u_audio_probe/u_bridge/next_acc [11:10]),
    .fco(\u_audio_probe/u_bridge/add0_syn_99 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_145  (
    .a(\u_audio_probe/u_bridge/sample_acc [13:12]),
    .b(2'b11),
    .fci(\u_audio_probe/u_bridge/add0_syn_99 ),
    .f(\u_audio_probe/u_bridge/next_acc [13:12]),
    .fco(\u_audio_probe/u_bridge/add0_syn_101 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_148  (
    .a(\u_audio_probe/u_bridge/sample_acc [15:14]),
    .b(2'b10),
    .fci(\u_audio_probe/u_bridge/add0_syn_101 ),
    .f(\u_audio_probe/u_bridge/next_acc [15:14]),
    .fco(\u_audio_probe/u_bridge/add0_syn_103 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_151  (
    .a(\u_audio_probe/u_bridge/sample_acc [17:16]),
    .b(2'b00),
    .fci(\u_audio_probe/u_bridge/add0_syn_103 ),
    .f(\u_audio_probe/u_bridge/next_acc [17:16]),
    .fco(\u_audio_probe/u_bridge/add0_syn_105 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_154  (
    .a(\u_audio_probe/u_bridge/sample_acc [19:18]),
    .b(2'b00),
    .fci(\u_audio_probe/u_bridge/add0_syn_105 ),
    .f(\u_audio_probe/u_bridge/next_acc [19:18]),
    .fco(\u_audio_probe/u_bridge/add0_syn_107 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_157  (
    .a(\u_audio_probe/u_bridge/sample_acc [21:20]),
    .b(2'b00),
    .fci(\u_audio_probe/u_bridge/add0_syn_107 ),
    .f(\u_audio_probe/u_bridge/next_acc [21:20]),
    .fco(\u_audio_probe/u_bridge/add0_syn_109 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_160  (
    .a(\u_audio_probe/u_bridge/sample_acc [23:22]),
    .b(2'b00),
    .fci(\u_audio_probe/u_bridge/add0_syn_109 ),
    .f(\u_audio_probe/u_bridge/next_acc [23:22]),
    .fco(\u_audio_probe/u_bridge/add0_syn_111 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/add0_syn_136"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/add0_syn_163  (
    .a({open_n8996,\u_audio_probe/u_bridge/sample_acc [24]}),
    .b({open_n8997,1'b0}),
    .fci(\u_audio_probe/u_bridge/add0_syn_111 ),
    .f(\u_audio_probe/u_bridge/next_acc [25:24]));
EG_PHY_LSLICE #(
    //.LUTF0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTF1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTG0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTG1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1101100010001000),
    .INIT_LUTF1(16'b1101100010001000),
    .INIT_LUTG0(16'b1101100010001000),
    .INIT_LUTG1(16'b1101100010001000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_left_reg[10]_syn_4  (
    .a({\u_audio_probe/u_bridge/prefetch_valid ,\u_audio_probe/u_bridge/prefetch_valid }),
    .b(\u_audio_probe/u_bridge/prefetch [2:1]),
    .c(\u_audio_probe/u_bridge/sample_mailbox [2:1]),
    .ce(\u_audio_probe/u_bridge/audio_valid_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q(\u_audio_probe/u_bridge/audio_left [10:9]));
EG_PHY_MSLICE #(
    //.LUT0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUT1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1101100010001000),
    .INIT_LUT1(16'b1101100010001000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_left_reg[11]_syn_4  (
    .a({\u_audio_probe/u_bridge/prefetch_valid ,\u_audio_probe/u_bridge/prefetch_valid }),
    .b({\u_audio_probe/u_bridge/prefetch [3],\u_audio_probe/u_bridge/prefetch [0]}),
    .c({\u_audio_probe/u_bridge/sample_mailbox [3],\u_audio_probe/u_bridge/sample_mailbox [0]}),
    .ce(\u_audio_probe/u_bridge/audio_valid_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .sr(\u_file_mapper/rst_dup_102 ),
    .q({\u_audio_probe/u_bridge/audio_left [11],\u_audio_probe/u_bridge/audio_left [8]}));
EG_PHY_MSLICE #(
    //.LUT0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUT1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1101100010001000),
    .INIT_LUT1(16'b1101100010001000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_left_reg[12]_syn_4  (
    .a({\u_audio_probe/u_bridge/prefetch_valid ,\u_audio_probe/u_bridge/prefetch_valid }),
    .b({\u_audio_probe/u_bridge/prefetch [4],\u_audio_probe/u_bridge/prefetch [7]}),
    .c({\u_audio_probe/u_bridge/sample_mailbox [4],\u_audio_probe/u_bridge/sample_mailbox [7]}),
    .ce(\u_audio_probe/u_bridge/audio_valid_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/audio_left [12],\u_audio_probe/u_bridge/audio_left [15]}));
EG_PHY_LSLICE #(
    //.LUTF0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTF1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTG0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTG1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1101100010001000),
    .INIT_LUTF1(16'b1101100010001000),
    .INIT_LUTG0(16'b1101100010001000),
    .INIT_LUTG1(16'b1101100010001000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_left_reg[13]_syn_4  (
    .a({\u_audio_probe/u_bridge/prefetch_valid ,\u_audio_probe/u_bridge/prefetch_valid }),
    .b({\u_audio_probe/u_bridge/prefetch [5],\u_audio_probe/u_bridge/prefetch [6]}),
    .c({\u_audio_probe/u_bridge/sample_mailbox [5],\u_audio_probe/u_bridge/sample_mailbox [6]}),
    .ce(\u_audio_probe/u_bridge/audio_valid_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/audio_left [13],\u_audio_probe/u_bridge/audio_left [14]}));
EG_PHY_MSLICE #(
    //.LUT0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUT1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1101100010001000),
    .INIT_LUT1(16'b1101100010001000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_left_reg[16]_syn_4  (
    .a({\u_audio_probe/u_bridge/prefetch_valid ,\u_audio_probe/u_bridge/prefetch_valid }),
    .b({\u_audio_probe/u_bridge/prefetch [8],\u_audio_probe/u_bridge/prefetch [9]}),
    .c({\u_audio_probe/u_bridge/sample_mailbox [8],\u_audio_probe/u_bridge/sample_mailbox [9]}),
    .ce(\u_audio_probe/u_bridge/audio_valid_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/audio_left [16],\u_audio_probe/u_bridge/audio_left [17]}));
EG_PHY_LSLICE #(
    //.LUTF0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTF1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTG0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTG1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1101100010001000),
    .INIT_LUTF1(16'b1101100010001000),
    .INIT_LUTG0(16'b1101100010001000),
    .INIT_LUTG1(16'b1101100010001000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_left_reg[18]_syn_4  (
    .a({\u_audio_probe/u_bridge/prefetch_valid ,\u_audio_probe/u_bridge/prefetch_valid }),
    .b({\u_audio_probe/u_bridge/prefetch [10],\u_audio_probe/u_bridge/prefetch [11]}),
    .c({\u_audio_probe/u_bridge/sample_mailbox [10],\u_audio_probe/u_bridge/sample_mailbox [11]}),
    .ce(\u_audio_probe/u_bridge/audio_valid_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/audio_left [18],\u_audio_probe/u_bridge/audio_left [19]}));
EG_PHY_LSLICE #(
    //.LUTF0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTF1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTG0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUTG1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1101100010001000),
    .INIT_LUTF1(16'b1101100010001000),
    .INIT_LUTG0(16'b1101100010001000),
    .INIT_LUTG1(16'b1101100010001000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_left_reg[20]_syn_4  (
    .a({\u_audio_probe/u_bridge/prefetch_valid ,\u_audio_probe/u_bridge/prefetch_valid }),
    .b({\u_audio_probe/u_bridge/prefetch [12],\u_audio_probe/u_bridge/prefetch [14]}),
    .c({\u_audio_probe/u_bridge/sample_mailbox [12],\u_audio_probe/u_bridge/sample_mailbox [14]}),
    .ce(\u_audio_probe/u_bridge/audio_valid_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/audio_left [20],\u_audio_probe/u_bridge/audio_left [22]}));
EG_PHY_MSLICE #(
    //.LUT0("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    //.LUT1("((D*C)*~(B)*~(A)+(D*C)*B*~(A)+~((D*C))*B*A+(D*C)*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1101100010001000),
    .INIT_LUT1(16'b1101100010001000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_left_reg[21]_syn_4  (
    .a({\u_audio_probe/u_bridge/prefetch_valid ,\u_audio_probe/u_bridge/prefetch_valid }),
    .b({\u_audio_probe/u_bridge/prefetch [13],\u_audio_probe/u_bridge/prefetch [15]}),
    .c({\u_audio_probe/u_bridge/sample_mailbox [13],\u_audio_probe/u_bridge/sample_mailbox [15]}),
    .ce(\u_audio_probe/u_bridge/audio_valid_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/audio_left [21],\u_audio_probe/u_bridge/audio_left [23]}));
EG_PHY_LSLICE #(
    //.LUTF0("(C*D)"),
    //.LUTG0("(C*D)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111000000000000),
    .INIT_LUTG0(16'b1111000000000000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/audio_valid_reg_syn_5  (
    .c({open_n9177,\u_audio_probe/u_bridge/audio_left_b1_n }),
    .clk(\u_adjust_control/clk ),
    .d({open_n9179,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_102 ),
    .f({open_n9196,\u_audio_probe/u_bridge/audio_valid_n }),
    .q({open_n9200,\u_audio_probe/wav_valid }));
EG_PHY_MSLICE #(
    //.LUT0("~(C*~(B*~D))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000111111001111),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/play_sync_reg[0]_syn_4  (
    .b({open_n9203,\u_video_schedule/audio_go }),
    .c({open_n9204,\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_12 }),
    .clk(\u_adjust_control/clk ),
    .d({open_n9206,video_paused}),
    .sr(\u_file_mapper/rst_dup_59 ),
    .q({open_n9224,\u_audio_probe/u_bridge/play_sync [0]}));
EG_PHY_MSLICE #(
    //.LUT0("(C*~B*~D)"),
    //.LUT1("(C*~D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000110000),
    .INIT_LUT1(16'b0000000011110000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[0]_syn_4  (
    .b({open_n9227,\u_jpeg_core/u_jpeg_input/dht_cfg_data_o [4]}),
    .c({\u_video_reader/mux94_syn_75 ,\u_jpeg_core/u_jpeg_input/length_q_b1[6]_syn_2 }),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d({\u_jpeg_core/u_jpeg_input/dht_cfg_data_o [7],\u_jpeg_core/u_jpeg_input/dht_cfg_data_o [5]}),
    .mi({\u_audio_probe/u_bridge/sample_mailbox [0],\u_audio_probe/u_bridge/sample_mailbox [3]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({\u_jpeg_core/u_jpeg_input/sub0_syn_3 [7],\u_jpeg_core/u_jpeg_input/length_q_b1[6]_syn_4 }),
    .q({\u_audio_probe/u_bridge/prefetch [0],\u_audio_probe/u_bridge/prefetch [3]}));
EG_PHY_MSLICE #(
    //.LUT0("(B@(C*D))"),
    //.LUT1("(D*~(C)*~(B)+D*C*~(B)+~(D)*C*B+D*C*B)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0011110011001100),
    .INIT_LUT1(16'b1111001111000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[11]_syn_4  (
    .b({\u_wav_player/fifo_pop ,\u_wav_player/rd_ptr [1]}),
    .c({\u_wav_player/rd_ptr_b3 [10],\u_wav_player/fifo_pop }),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d({\u_wav_player/rd_ptr [10],\u_wav_player/rd_ptr [0]}),
    .mi({\u_audio_probe/u_bridge/sample_mailbox [11],\u_audio_probe/u_bridge/sample_mailbox [13]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({\u_wav_player/rd_ptr_b1 [10],\u_wav_player/rd_ptr_b1 [1]}),
    .q({\u_audio_probe/u_bridge/prefetch [11],\u_audio_probe/u_bridge/prefetch [13]}));
EG_PHY_LSLICE #(
    //.LUTF0("(D@(C*B))"),
    //.LUTF1("(D*~(C)*~(B)+D*C*~(B)+~(D)*C*B+D*C*B)"),
    //.LUTG0("(D@(C*B))"),
    //.LUTG1("(D*~(C)*~(B)+D*C*~(B)+~(D)*C*B+D*C*B)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0011111111000000),
    .INIT_LUTF1(16'b1111001111000000),
    .INIT_LUTG0(16'b0011111111000000),
    .INIT_LUTG1(16'b1111001111000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[12]_syn_4  (
    .b({\u_wav_player/fifo_pop ,\u_wav_player/fifo_pop }),
    .c({\u_wav_player/rd_ptr_b3 [7],\u_wav_player/add4_syn_46 }),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d(\u_wav_player/rd_ptr [7:6]),
    .mi({\u_audio_probe/u_bridge/sample_mailbox [12],\u_audio_probe/u_bridge/sample_mailbox [14]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f(\u_wav_player/rd_ptr_b1 [7:6]),
    .q({\u_audio_probe/u_bridge/prefetch [12],\u_audio_probe/u_bridge/prefetch [14]}));
EG_PHY_LSLICE #(
    //.LUTF0("(D*~(C)*~(B)+D*C*~(B)+~(D)*C*B+D*C*B)"),
    //.LUTF1("(~C*D)"),
    //.LUTG0("(D*~(C)*~(B)+D*C*~(B)+~(D)*C*B+D*C*B)"),
    //.LUTG1("(~C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111001111000000),
    .INIT_LUTF1(16'b0000111100000000),
    .INIT_LUTG0(16'b1111001111000000),
    .INIT_LUTG1(16'b0000111100000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[15]_syn_4  (
    .b({open_n9277,\u_wav_player/fifo_pop }),
    .c({\u_wav_player/fifo_pop ,\u_wav_player/rd_ptr_b3 [9]}),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d({\u_wav_player/fifo_head_valid ,\u_wav_player/rd_ptr [9]}),
    .mi({\u_audio_probe/u_bridge/sample_mailbox [15],\u_audio_probe/u_bridge/sample_mailbox [10]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({\u_wav_player/fifo_head_valid_reg_syn_189 ,\u_wav_player/rd_ptr_b1 [9]}),
    .q({\u_audio_probe/u_bridge/prefetch [15],\u_audio_probe/u_bridge/prefetch [10]}));
EG_PHY_LSLICE #(
    //.LUTF0("~(C@B@D)"),
    //.LUTF1("~(C@D)"),
    //.LUTG0("~(C@B@D)"),
    //.LUTG1("~(C@D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0011110011000011),
    .INIT_LUTF1(16'b1111000000001111),
    .INIT_LUTG0(16'b0011110011000011),
    .INIT_LUTG1(16'b1111000000001111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[1]_syn_4  (
    .b({open_n9297,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [50]}),
    .c({\u_video_reader/mux94_syn_75 ,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_18 }),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d({\u_jpeg_core/u_jpeg_input/dht_cfg_data_o [7],\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [9]}),
    .mi({\u_audio_probe/u_bridge/sample_mailbox [1],\u_audio_probe/u_bridge/sample_mailbox [7]}),
    .sr(\u_file_mapper/rst_dup_102 ),
    .f({\u_jpeg_core/u_jpeg_input/length_q_b1[7]_syn_2 ,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_20 }),
    .q({\u_audio_probe/u_bridge/prefetch [1],\u_audio_probe/u_bridge/prefetch [7]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~A*(0*~(D)*~((C*~B))+0*D*~((C*~B))+~(0)*D*(C*~B)+0*D*(C*~B)))"),
    //.LUTG0("(~A*(1*~(D)*~((C*~B))+1*D*~((C*~B))+~(1)*D*(C*~B)+1*D*(C*~B)))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0001000000000000),
    .INIT_LUTG0(16'b0101010101000101),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[2]_syn_4  (
    .a({open_n9315,\u_wav_player/prime_target [6]}),
    .b({open_n9316,\u_wav_player/play_in_range_n2_syn_2 }),
    .c({open_n9317,\u_wav_player/fifo_head_valid_reg_syn_141 }),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d({open_n9318,\u_wav_player/fifo_head_valid_reg_syn_162 }),
    .e({open_n9319,\u_wav_player/fifo_head_valid_reg_syn_176 }),
    .mi({open_n9321,\u_audio_probe/u_bridge/sample_mailbox [2]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({open_n9333,\u_wav_player/primed_reg_syn_25 }),
    .q({open_n9337,\u_audio_probe/u_bridge/prefetch [2]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~D*~(C*~(B*~(~0*A))))"),
    //.LUTF1("~(D*~(C)*~((B*~A))+D*C*~((B*~A))+~(D)*C*(B*~A)+D*C*(B*~A))"),
    //.LUTG0("(~D*~(C*~(B*~(~1*A))))"),
    //.LUTG1("~(D*~(C)*~((B*~A))+D*C*~((B*~A))+~(D)*C*(B*~A)+D*C*(B*~A))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000001001111),
    .INIT_LUTF1(16'b0000010010111111),
    .INIT_LUTG0(16'b0000000011001111),
    .INIT_LUTG1(16'b0000010010111111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[5]_syn_4  (
    .a({\u_wav_player/play_in_range_n2_syn_2 ,\u_wav_player/debug_fifo_level [0]}),
    .b({\u_wav_player/fifo_head_valid_reg_syn_141 ,\u_wav_player/debug_fifo_level [1]}),
    .c({\u_wav_player/fifo_head_valid_reg_syn_162 ,\u_wav_player/prime_target [0]}),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d({\u_wav_player/fifo_head_valid_reg_syn_176 ,\u_wav_player/prime_target [1]}),
    .e({open_n9338,\u_wav_player/fifo_pop }),
    .mi(\u_audio_probe/u_bridge/sample_mailbox [5:4]),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({\u_wav_player/fifo_head_valid_reg_syn_178 ,\u_wav_player/primed_reg_syn_12 }),
    .q(\u_audio_probe/u_bridge/prefetch [5:4]));
EG_PHY_MSLICE #(
    //.LUT0("~(D@C@B@A)"),
    //.LUT1("(C@D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001011001101001),
    .INIT_LUT1(16'b0000111111110000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[6]_syn_4  (
    .a({open_n9354,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [15]}),
    .b({open_n9355,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [17]}),
    .c({\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_16 ,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [50]}),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d({\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [50],\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_22 }),
    .mi({\u_audio_probe/u_bridge/sample_mailbox [6],\u_audio_probe/u_bridge/sample_mailbox [9]}),
    .sr(\u_file_mapper/rst_dup_102 ),
    .f({\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[50]_syn_12 ,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_27 }),
    .q({\u_audio_probe/u_bridge/prefetch [6],\u_audio_probe/u_bridge/prefetch [9]}));
EG_PHY_LSLICE #(
    //.LUTF0("(B*A*~(D*~C))"),
    //.LUTG0("(B*A*~(D*~C))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1000000010001000),
    .INIT_LUTG0(16'b1000000010001000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_reg[8]_syn_4  (
    .a({open_n9369,\u_wav_player/sub1_syn_71 }),
    .b({open_n9370,\u_wav_player/fifo_pop }),
    .c({open_n9371,\u_wav_player/play_in_range_n2_syn_2 }),
    .ce(\u_audio_probe/u_bridge/ack_arrived ),
    .clk(\u_adjust_control/clk ),
    .d({open_n9372,\u_wav_player/fifo_head_valid_reg_syn_141 }),
    .mi({open_n9376,\u_audio_probe/u_bridge/sample_mailbox [8]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({open_n9388,\u_wav_player/fifo_head_valid_reg_syn_158 }),
    .q({open_n9392,\u_audio_probe/u_bridge/prefetch [8]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*~(~B*~D))"),
    //.LUTG0("(~C*~(~B*~D))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100001100),
    .INIT_LUTG0(16'b0000111100001100),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/prefetch_valid_reg_syn_10  (
    .b({open_n9395,\u_audio_probe/u_bridge/ack_arrived }),
    .c({open_n9396,\u_audio_probe/u_bridge/audio_valid_n }),
    .clk(\u_adjust_control/clk ),
    .d({open_n9398,\u_audio_probe/u_bridge/prefetch_valid }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({open_n9420,\u_audio_probe/u_bridge/prefetch_valid }));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C*~D))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1100110000001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/primed_sync_reg[0]_syn_4  (
    .b({open_n9423,\u_wav_player/primed }),
    .c({open_n9424,\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/write_len[11]_dup_14 }),
    .clk(\u_adjust_control/clk ),
    .d({open_n9426,\u_video_schedule/audio_go }),
    .sr(\u_file_mapper/rst_dup_79 ),
    .q({open_n9444,\u_audio_probe/u_bridge/primed_sync [0]}));
EG_PHY_LSLICE #(
    //.LUTF0("(D*~(C*~B))"),
    //.LUTG0("(D*~(C*~B))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1100111100000000),
    .INIT_LUTG0(16'b1100111100000000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/primed_sync_reg[1]_syn_4  (
    .b({open_n9447,\u_wav_player/play_in_range_n2_syn_2 }),
    .c({open_n9448,\u_wav_player/fifo_head_valid_reg_syn_141 }),
    .clk(\u_adjust_control/clk ),
    .d({open_n9450,\u_wav_player/fifo_pop }),
    .mi({open_n9454,\u_audio_probe/u_bridge/primed_sync [0]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({open_n9466,\u_wav_player/add3_syn_5 [1]}),
    .q({open_n9470,\u_audio_probe/u_bridge/primed_sync [1]}));
EG_PHY_MSLICE #(
    //.LUT0("(D*~(C)*~(B)+D*C*~(B)+~(D)*C*B+D*C*B)"),
    //.LUT1("(D*~(C)*~(B)+D*C*~(B)+~(D)*C*B+D*C*B)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111001111000000),
    .INIT_LUT1(16'b1111001111000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/request_sync_reg[0]_syn_4  (
    .b({\u_wav_player/fifo_pop ,\u_wav_player/fifo_pop }),
    .c(\u_wav_player/rd_ptr_b3 [5:4]),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d(\u_wav_player/rd_ptr [5:4]),
    .mi({\u_audio_probe/u_bridge/request_toggle ,\u_audio_probe/u_bridge/request_sync [0]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f(\u_wav_player/rd_ptr_b1 [5:4]),
    .q({\u_audio_probe/u_bridge/request_sync [0],\u_audio_probe/u_bridge/request_sync [1]}));
EG_PHY_LSLICE #(
    //.LUTF0("~(0@D@C@B@A)"),
    //.LUTF1("(A@(D*~(~C*B)))"),
    //.LUTG0("~(1@D@C@B@A)"),
    //.LUTG1("(A@(D*~(~C*B)))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1001011001101001),
    .INIT_LUTF1(16'b0101100110101010),
    .INIT_LUTG0(16'b0110100110010110),
    .INIT_LUTG1(16'b0101100110101010),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/request_toggle_reg_syn_8  (
    .a({\u_audio_probe/u_bridge/request_toggle ,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [10]}),
    .b({\u_audio_probe/u_bridge/waiting ,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [12]}),
    .c({\u_audio_probe/u_bridge/ack_arrived ,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [13]}),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/waiting_reg_syn_3 ,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [15]}),
    .e({open_n9488,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body [16]}),
    .mi({open_n9490,\video_delay_m0/de_d [8]}),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({open_n9502,\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_hdmi_island_data_gen/U_audio_sample_packet_2_channel/S_packet_body[55]_syn_14 }),
    .q({\u_audio_probe/u_bridge/request_toggle ,\video_delay_m0/de_d [9]}));
EG_PHY_LSLICE #(
    //.LUTF0("(C*D)"),
    //.LUTF1("(C*D)"),
    //.LUTG0("(C*D)"),
    //.LUTG1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111000000000000),
    .INIT_LUTF1(16'b1111000000000000),
    .INIT_LUTG0(16'b1111000000000000),
    .INIT_LUTG1(16'b1111000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[10]_syn_4  (
    .c(\u_audio_probe/u_bridge/sample_acc_b1 [10:9]),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q(\u_audio_probe/u_bridge/sample_acc [10:9]));
EG_PHY_LSLICE #(
    //.LUTF0("(C*D)"),
    //.LUTF1("(C*D)"),
    //.LUTG0("(C*D)"),
    //.LUTG1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111000000000000),
    .INIT_LUTF1(16'b1111000000000000),
    .INIT_LUTG0(16'b1111000000000000),
    .INIT_LUTG1(16'b1111000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[11]_syn_4  (
    .c({\u_audio_probe/u_bridge/sample_acc_b1 [11],\u_audio_probe/u_bridge/sample_acc_b1 [12]}),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_acc [11],\u_audio_probe/u_bridge/sample_acc [12]}));
EG_PHY_MSLICE #(
    //.LUT0("(C*D)"),
    //.LUT1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000000000000),
    .INIT_LUT1(16'b1111000000000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[13]_syn_4  (
    .c({\u_audio_probe/u_bridge/sample_acc_b1 [13],\u_audio_probe/u_bridge/sample_acc_b1 [14]}),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_acc [13],\u_audio_probe/u_bridge/sample_acc [14]}));
EG_PHY_MSLICE #(
    //.LUT0("(C*D)"),
    //.LUT1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000000000000),
    .INIT_LUT1(16'b1111000000000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[15]_syn_4  (
    .c({\u_audio_probe/u_bridge/sample_acc_b1 [15],\u_audio_probe/u_bridge/sample_acc_b1 [16]}),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_acc [15],\u_audio_probe/u_bridge/sample_acc [16]}));
EG_PHY_LSLICE #(
    //.LUTF0("(C*D)"),
    //.LUTF1("(C*D)"),
    //.LUTG0("(C*D)"),
    //.LUTG1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111000000000000),
    .INIT_LUTF1(16'b1111000000000000),
    .INIT_LUTG0(16'b1111000000000000),
    .INIT_LUTG1(16'b1111000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[17]_syn_4  (
    .c({\u_audio_probe/u_bridge/sample_acc_b1 [17],\u_audio_probe/u_bridge/sample_acc_b1 [18]}),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_acc [17],\u_audio_probe/u_bridge/sample_acc [18]}));
EG_PHY_LSLICE #(
    //.LUTF0("(C*D)"),
    //.LUTF1("(C*D)"),
    //.LUTG0("(C*D)"),
    //.LUTG1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111000000000000),
    .INIT_LUTF1(16'b1111000000000000),
    .INIT_LUTG0(16'b1111000000000000),
    .INIT_LUTG1(16'b1111000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[19]_syn_4  (
    .c({\u_audio_probe/u_bridge/sample_acc_b1 [19],\u_audio_probe/u_bridge/sample_acc_b1 [20]}),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_acc [19],\u_audio_probe/u_bridge/sample_acc [20]}));
EG_PHY_MSLICE #(
    //.LUT0("(C*D)"),
    //.LUT1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000000000000),
    .INIT_LUT1(16'b1111000000000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[21]_syn_4  (
    .c({\u_audio_probe/u_bridge/sample_acc_b1 [21],\u_audio_probe/u_bridge/sample_acc_b1 [22]}),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_acc [21],\u_audio_probe/u_bridge/sample_acc [22]}));
EG_PHY_MSLICE #(
    //.LUT0("(C*D)"),
    //.LUT1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000000000000),
    .INIT_LUT1(16'b1111000000000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[23]_syn_4  (
    .c({\u_audio_probe/u_bridge/sample_acc_b1 [23],\u_audio_probe/u_bridge/sample_acc_b1 [24]}),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_acc [23],\u_audio_probe/u_bridge/sample_acc [24]}));
EG_PHY_LSLICE #(
    //.LUTF0("(C*D)"),
    //.LUTF1("(C*D)"),
    //.LUTG0("(C*D)"),
    //.LUTG1("(C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111000000000000),
    .INIT_LUTF1(16'b1111000000000000),
    .INIT_LUTG0(16'b1111000000000000),
    .INIT_LUTG1(16'b1111000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_acc_reg[8]_syn_4  (
    .c(\u_audio_probe/u_bridge/sample_acc_b1 [8:7]),
    .ce(\u_audio_probe/u_bridge/mux6_syn_2 [7]),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q(\u_audio_probe/u_bridge/sample_acc [8:7]));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    //.LUT1("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011001100),
    .INIT_LUT1(16'b1111000011001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_mailbox_reg[0]_syn_4  (
    .b({\u_wav_player/fifo_ram_q [0],\u_wav_player/fifo_ram_q [3]}),
    .c({\u_wav_player/fifo_bypass_word [0],\u_wav_player/fifo_bypass_word [3]}),
    .ce(\u_audio_probe/u_bridge/sample_take_n ),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({\u_wav_player/fifo_head_bypass ,\u_wav_player/fifo_head_bypass }),
    .sr(\u_file_mapper/rst_dup_102 ),
    .q({\u_audio_probe/u_bridge/sample_mailbox [0],\u_audio_probe/u_bridge/sample_mailbox [3]}));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    //.LUT1("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011001100),
    .INIT_LUT1(16'b1111000011001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_mailbox_reg[10]_syn_4  (
    .b({\u_wav_player/fifo_ram_q [10],\u_wav_player/fifo_ram_q [8]}),
    .c({\u_wav_player/fifo_bypass_word [10],\u_wav_player/fifo_bypass_word [8]}),
    .ce(\u_audio_probe/u_bridge/sample_take_n ),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({\u_wav_player/fifo_head_bypass ,\u_wav_player/fifo_head_bypass }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_mailbox [10],\u_audio_probe/u_bridge/sample_mailbox [8]}));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    //.LUT1("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011001100),
    .INIT_LUT1(16'b1111000011001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_mailbox_reg[11]_syn_4  (
    .b({\u_wav_player/fifo_ram_q [11],\u_wav_player/fifo_ram_q [9]}),
    .c({\u_wav_player/fifo_bypass_word [11],\u_wav_player/fifo_bypass_word [9]}),
    .ce(\u_audio_probe/u_bridge/sample_take_n ),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({\u_wav_player/fifo_head_bypass ,\u_wav_player/fifo_head_bypass }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_mailbox [11],\u_audio_probe/u_bridge/sample_mailbox [9]}));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    //.LUT1("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011001100),
    .INIT_LUT1(16'b1111000011001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_mailbox_reg[12]_syn_4  (
    .b({\u_wav_player/fifo_ram_q [12],\u_wav_player/fifo_ram_q [13]}),
    .c({\u_wav_player/fifo_bypass_word [12],\u_wav_player/fifo_bypass_word [13]}),
    .ce(\u_audio_probe/u_bridge/sample_take_n ),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({\u_wav_player/fifo_head_bypass ,\u_wav_player/fifo_head_bypass }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_mailbox [12],\u_audio_probe/u_bridge/sample_mailbox [13]}));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    //.LUT1("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011001100),
    .INIT_LUT1(16'b1111000011001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_mailbox_reg[14]_syn_4  (
    .b({\u_wav_player/fifo_ram_q [14],\u_wav_player/fifo_ram_q [15]}),
    .c({\u_wav_player/fifo_bypass_word [14],\u_wav_player/fifo_bypass_word [15]}),
    .ce(\u_audio_probe/u_bridge/sample_take_n ),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({\u_wav_player/fifo_head_bypass ,\u_wav_player/fifo_head_bypass }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_mailbox [14],\u_audio_probe/u_bridge/sample_mailbox [15]}));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    //.LUT1("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011001100),
    .INIT_LUT1(16'b1111000011001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_mailbox_reg[1]_syn_4  (
    .b({\u_wav_player/fifo_ram_q [1],\u_wav_player/fifo_ram_q [2]}),
    .c({\u_wav_player/fifo_bypass_word [1],\u_wav_player/fifo_bypass_word [2]}),
    .ce(\u_audio_probe/u_bridge/sample_take_n ),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({\u_wav_player/fifo_head_bypass ,\u_wav_player/fifo_head_bypass }),
    .sr(\u_file_mapper/rst_dup_102 ),
    .q({\u_audio_probe/u_bridge/sample_mailbox [1],\u_audio_probe/u_bridge/sample_mailbox [2]}));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    //.LUT1("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011001100),
    .INIT_LUT1(16'b1111000011001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_mailbox_reg[4]_syn_4  (
    .b({\u_wav_player/fifo_ram_q [4],\u_wav_player/fifo_ram_q [5]}),
    .c({\u_wav_player/fifo_bypass_word [4],\u_wav_player/fifo_bypass_word [5]}),
    .ce(\u_audio_probe/u_bridge/sample_take_n ),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({\u_wav_player/fifo_head_bypass ,\u_wav_player/fifo_head_bypass }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .q({\u_audio_probe/u_bridge/sample_mailbox [4],\u_audio_probe/u_bridge/sample_mailbox [5]}));
EG_PHY_MSLICE #(
    //.LUT0("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    //.LUT1("(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011001100),
    .INIT_LUT1(16'b1111000011001100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_mailbox_reg[6]_syn_4  (
    .b({\u_wav_player/fifo_ram_q [6],\u_wav_player/fifo_ram_q [7]}),
    .c({\u_wav_player/fifo_bypass_word [6],\u_wav_player/fifo_bypass_word [7]}),
    .ce(\u_audio_probe/u_bridge/sample_take_n ),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({\u_wav_player/fifo_head_bypass ,\u_wav_player/fifo_head_bypass }),
    .sr(\u_file_mapper/rst_dup_102 ),
    .q({\u_audio_probe/u_bridge/sample_mailbox [6],\u_audio_probe/u_bridge/sample_mailbox [7]}));
EG_PHY_MSLICE #(
    //.LUT0("(C*(B@D))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0011000011000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sample_take_reg_syn_5  (
    .b({open_n9869,\u_audio_probe/u_bridge/request_sync [1]}),
    .c({open_n9870,\u_audio_probe/u_bridge/acknowledge_toggle_reg_syn_5 }),
    .clk(\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i ),
    .d({open_n9872,\u_audio_probe/u_bridge/acknowledge_toggle }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({open_n9885,\u_audio_probe/u_bridge/sample_take_n }),
    .q({open_n9889,\u_wav_player/sample_take }));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/sub0_syn_141  (
    .a({\u_audio_probe/u_bridge/next_acc [6],1'b0}),
    .b({\u_audio_probe/u_bridge/audio_left_b1_n ,open_n9890}),
    .clk(\u_adjust_control/clk ),
    .mi({\u_audio_probe/u_bridge/acknowledge_sync [0],\u_audio_probe/u_bridge/acknowledge_toggle }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .f({\u_audio_probe/u_bridge/sample_acc_b1 [6],open_n9906}),
    .fco(\u_audio_probe/u_bridge/sub0_syn_100 ),
    .q(\u_audio_probe/u_bridge/acknowledge_sync ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_144  (
    .a({\u_audio_probe/u_bridge/next_acc [8],\u_audio_probe/u_bridge/sample_acc[7]_syn_2 }),
    .b(2'b00),
    .fci(\u_audio_probe/u_bridge/sub0_syn_100 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [8:7]),
    .fco(\u_audio_probe/u_bridge/sub0_syn_102 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_147  (
    .a(\u_audio_probe/u_bridge/next_acc [10:9]),
    .b(2'b00),
    .fci(\u_audio_probe/u_bridge/sub0_syn_102 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [10:9]),
    .fco(\u_audio_probe/u_bridge/sub0_syn_104 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_150  (
    .a(\u_audio_probe/u_bridge/next_acc [12:11]),
    .b({\u_audio_probe/u_bridge/audio_left_b1_n ,\u_audio_probe/u_bridge/audio_left_b1_n }),
    .fci(\u_audio_probe/u_bridge/sub0_syn_104 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [12:11]),
    .fco(\u_audio_probe/u_bridge/sub0_syn_106 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_153  (
    .a(\u_audio_probe/u_bridge/next_acc [14:13]),
    .b({\u_audio_probe/u_bridge/audio_left_b1_n ,\u_audio_probe/u_bridge/audio_left_b1_n }),
    .fci(\u_audio_probe/u_bridge/sub0_syn_106 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [14:13]),
    .fco(\u_audio_probe/u_bridge/sub0_syn_108 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_156  (
    .a(\u_audio_probe/u_bridge/next_acc [16:15]),
    .b({\u_audio_probe/u_bridge/audio_left_b1_n ,1'b0}),
    .fci(\u_audio_probe/u_bridge/sub0_syn_108 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [16:15]),
    .fco(\u_audio_probe/u_bridge/sub0_syn_110 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_159  (
    .a(\u_audio_probe/u_bridge/next_acc [18:17]),
    .b({\u_audio_probe/u_bridge/audio_left_b1_n ,1'b0}),
    .fci(\u_audio_probe/u_bridge/sub0_syn_110 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [18:17]),
    .fco(\u_audio_probe/u_bridge/sub0_syn_112 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_162  (
    .a(\u_audio_probe/u_bridge/next_acc [20:19]),
    .b({\u_audio_probe/u_bridge/audio_left_b1_n ,\u_audio_probe/u_bridge/audio_left_b1_n }),
    .fci(\u_audio_probe/u_bridge/sub0_syn_112 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [20:19]),
    .fco(\u_audio_probe/u_bridge/sub0_syn_114 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_165  (
    .a(\u_audio_probe/u_bridge/next_acc [22:21]),
    .b({\u_audio_probe/u_bridge/audio_left_b1_n ,\u_audio_probe/u_bridge/audio_left_b1_n }),
    .fci(\u_audio_probe/u_bridge/sub0_syn_114 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [22:21]),
    .fco(\u_audio_probe/u_bridge/sub0_syn_116 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_bridge/sub0_syn_141"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_bridge/sub0_syn_168  (
    .a(\u_audio_probe/u_bridge/next_acc [24:23]),
    .b({\u_audio_probe/u_bridge/audio_left_b1_n ,1'b0}),
    .fci(\u_audio_probe/u_bridge/sub0_syn_116 ),
    .f(\u_audio_probe/u_bridge/sample_acc_b1 [24:23]));
EG_PHY_LSLICE #(
    //.LUTF0("(~(A)*B*~(C)*~(D)*~(0)*~(0)+A*B*~(C)*~(D)*~(0)*~(0)+~(A)*B*C*~(D)*~(0)*~(0)+A*B*C*~(D)*~(0)*~(0)+A*~(B)*~(C)*D*~(0)*~(0)+~(A)*B*~(C)*D*~(0)*~(0)+A*B*~(C)*D*~(0)*~(0)+~(A)*~(B)*C*D*~(0)*~(0)+A*~(B)*C*D*~(0)*~(0)+~(A)*B*C*D*~(0)*~(0)+A*B*C*D*~(0)*~(0)+A*~(B)*~(C)*D*0*~(0)+A*B*~(C)*D*0*~(0)+A*~(B)*C*D*0*~(0)+A*B*C*D*0*~(0)+~(A)*B*~(C)*~(D)*~(0)*0+A*B*~(C)*~(D)*~(0)*0+~(A)*B*C*~(D)*~(0)*0+A*B*C*~(D)*~(0)*0+~(A)*B*~(C)*D*~(0)*0+A*B*~(C)*D*~(0)*0+~(A)*~(B)*C*D*~(0)*0+~(A)*B*C*D*~(0)*0+A*B*C*D*~(0)*0)"),
    //.LUTF1("(~(A)*B*~(C)*~(D)*~(0)*~(1)+A*B*~(C)*~(D)*~(0)*~(1)+~(A)*B*C*~(D)*~(0)*~(1)+A*B*C*~(D)*~(0)*~(1)+A*~(B)*~(C)*D*~(0)*~(1)+~(A)*B*~(C)*D*~(0)*~(1)+A*B*~(C)*D*~(0)*~(1)+~(A)*~(B)*C*D*~(0)*~(1)+A*~(B)*C*D*~(0)*~(1)+~(A)*B*C*D*~(0)*~(1)+A*B*C*D*~(0)*~(1)+A*~(B)*~(C)*D*0*~(1)+A*B*~(C)*D*0*~(1)+A*~(B)*C*D*0*~(1)+A*B*C*D*0*~(1)+~(A)*B*~(C)*~(D)*~(0)*1+A*B*~(C)*~(D)*~(0)*1+~(A)*B*C*~(D)*~(0)*1+A*B*C*~(D)*~(0)*1+~(A)*B*~(C)*D*~(0)*1+A*B*~(C)*D*~(0)*1+~(A)*~(B)*C*D*~(0)*1+~(A)*B*C*D*~(0)*1+A*B*C*D*~(0)*1)"),
    //.LUTG0("(~(A)*B*~(C)*~(D)*~(1)*~(0)+A*B*~(C)*~(D)*~(1)*~(0)+~(A)*B*C*~(D)*~(1)*~(0)+A*B*C*~(D)*~(1)*~(0)+A*~(B)*~(C)*D*~(1)*~(0)+~(A)*B*~(C)*D*~(1)*~(0)+A*B*~(C)*D*~(1)*~(0)+~(A)*~(B)*C*D*~(1)*~(0)+A*~(B)*C*D*~(1)*~(0)+~(A)*B*C*D*~(1)*~(0)+A*B*C*D*~(1)*~(0)+A*~(B)*~(C)*D*1*~(0)+A*B*~(C)*D*1*~(0)+A*~(B)*C*D*1*~(0)+A*B*C*D*1*~(0)+~(A)*B*~(C)*~(D)*~(1)*0+A*B*~(C)*~(D)*~(1)*0+~(A)*B*C*~(D)*~(1)*0+A*B*C*~(D)*~(1)*0+~(A)*B*~(C)*D*~(1)*0+A*B*~(C)*D*~(1)*0+~(A)*~(B)*C*D*~(1)*0+~(A)*B*C*D*~(1)*0+A*B*C*D*~(1)*0)"),
    //.LUTG1("(~(A)*B*~(C)*~(D)*~(1)*~(1)+A*B*~(C)*~(D)*~(1)*~(1)+~(A)*B*C*~(D)*~(1)*~(1)+A*B*C*~(D)*~(1)*~(1)+A*~(B)*~(C)*D*~(1)*~(1)+~(A)*B*~(C)*D*~(1)*~(1)+A*B*~(C)*D*~(1)*~(1)+~(A)*~(B)*C*D*~(1)*~(1)+A*~(B)*C*D*~(1)*~(1)+~(A)*B*C*D*~(1)*~(1)+A*B*C*D*~(1)*~(1)+A*~(B)*~(C)*D*1*~(1)+A*B*~(C)*D*1*~(1)+A*~(B)*C*D*1*~(1)+A*B*C*D*1*~(1)+~(A)*B*~(C)*~(D)*~(1)*1+A*B*~(C)*~(D)*~(1)*1+~(A)*B*C*~(D)*~(1)*1+A*B*C*~(D)*~(1)*1+~(A)*B*~(C)*D*~(1)*1+A*B*~(C)*D*~(1)*1+~(A)*~(B)*C*D*~(1)*1+~(A)*B*C*D*~(1)*1+A*B*C*D*~(1)*1)"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111111011001100),
    .INIT_LUTF1(16'b1101110011001100),
    .INIT_LUTG0(16'b1010101000000000),
    .INIT_LUTG1(16'b0000000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("FX"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_bridge/waiting_reg_syn_20  (
    .a({\u_audio_probe/u_bridge/started ,\u_audio_probe/u_bridge/started }),
    .b({\u_audio_probe/u_bridge/waiting ,\u_audio_probe/u_bridge/waiting }),
    .c({\u_audio_probe/u_bridge/primed_sync [1],\u_audio_probe/u_bridge/primed_sync [1]}),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_bridge/play_run ,\u_audio_probe/u_bridge/play_run }),
    .e({\u_audio_probe/u_bridge/ack_arrived ,\u_audio_probe/u_bridge/ack_arrived }),
    .mi({open_n10110,\u_audio_probe/u_bridge/waiting_reg_syn_12 }),
    .sr(\u_file_mapper/rst_dup_86 ),
    .fx({open_n10125,\u_audio_probe/u_bridge/waiting_reg_syn_3 }),
    .q({open_n10126,\u_audio_probe/u_bridge/waiting }));
EG_PHY_LSLICE #(
    //.LUTF0("(D*~(0*~0*~C*~B*~A))"),
    //.LUTF1("(D*~(1*~0*~C*~B*~A))"),
    //.LUTG0("(D*~(0*~1*~C*~B*~A))"),
    //.LUTG1("(D*~(1*~1*~C*~B*~A))"),
    .INIT_LUTF0(16'b1111111100000000),
    .INIT_LUTF1(16'b1111111000000000),
    .INIT_LUTG0(16'b1111111100000000),
    .INIT_LUTG1(16'b1111111100000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"))
    \u_audio_probe/u_bridge/waiting_reg_syn_22  (
    .a({\u_audio_probe/u_bridge/next_acc [8],\u_audio_probe/u_bridge/next_acc [8]}),
    .b({\u_audio_probe/u_bridge/next_acc [9],\u_audio_probe/u_bridge/next_acc [9]}),
    .c({\u_audio_probe/u_bridge/next_acc [10],\u_audio_probe/u_bridge/next_acc [10]}),
    .d({\u_audio_probe/u_bridge/next_acc [14],\u_audio_probe/u_bridge/next_acc [14]}),
    .e({\u_audio_probe/u_bridge/next_acc [6],\u_audio_probe/u_bridge/next_acc [6]}),
    .mi({open_n10130,\u_audio_probe/u_bridge/sample_acc [7]}),
    .fx({open_n10146,\u_audio_probe/u_bridge/waiting_reg_syn_6 }));
EG_PHY_LSLICE #(
    //.LUTF0("(0*~(~0*~(D*C*B*A)))"),
    //.LUTF1("(1*~(~0*~(D*C*B*A)))"),
    //.LUTG0("(0*~(~1*~(D*C*B*A)))"),
    //.LUTG1("(1*~(~1*~(D*C*B*A)))"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b1000000000000000),
    .INIT_LUTG0(16'b0000000000000000),
    .INIT_LUTG1(16'b1111111111111111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"))
    \u_audio_probe/u_bridge/waiting_reg_syn_24  (
    .a({\u_audio_probe/u_bridge/waiting_reg_syn_6 ,\u_audio_probe/u_bridge/waiting_reg_syn_6 }),
    .b({\u_audio_probe/u_bridge/next_acc [11],\u_audio_probe/u_bridge/next_acc [11]}),
    .c({\u_audio_probe/u_bridge/next_acc [12],\u_audio_probe/u_bridge/next_acc [12]}),
    .d({\u_audio_probe/u_bridge/next_acc [13],\u_audio_probe/u_bridge/next_acc [13]}),
    .e({\u_audio_probe/u_bridge/next_acc [15],\u_audio_probe/u_bridge/next_acc [15]}),
    .mi({open_n10152,\u_audio_probe/u_bridge/next_acc [16]}),
    .fx({open_n10168,\u_audio_probe/u_bridge/waiting_reg_syn_8 }));
EG_PHY_LSLICE #(
    //.LUTF0("(~0*~(0*~(~D*~(C*B*A))))"),
    //.LUTF1("(~1*~(0*~(~D*~(C*B*A))))"),
    //.LUTG0("(~0*~(1*~(~D*~(C*B*A))))"),
    //.LUTG1("(~1*~(1*~(~D*~(C*B*A))))"),
    .INIT_LUTF0(16'b1111111111111111),
    .INIT_LUTF1(16'b0000000000000000),
    .INIT_LUTG0(16'b0000000001111111),
    .INIT_LUTG1(16'b0000000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"))
    \u_audio_probe/u_bridge/waiting_reg_syn_26  (
    .a({\u_audio_probe/u_bridge/waiting_reg_syn_10 ,\u_audio_probe/u_bridge/waiting_reg_syn_10 }),
    .b({\u_audio_probe/u_bridge/next_acc [18],\u_audio_probe/u_bridge/next_acc [18]}),
    .c({\u_audio_probe/u_bridge/next_acc [19],\u_audio_probe/u_bridge/next_acc [19]}),
    .d({\u_audio_probe/u_bridge/next_acc [23],\u_audio_probe/u_bridge/next_acc [23]}),
    .e({\u_audio_probe/u_bridge/next_acc [24],\u_audio_probe/u_bridge/next_acc [24]}),
    .mi({open_n10174,\u_audio_probe/u_bridge/next_acc [25]}),
    .fx({open_n10190,\u_audio_probe/u_bridge/waiting_reg_syn_12 }));
EG_PHY_LSLICE #(
    //.LUTF0("(A*B*~(C)*~(D)*~(0)+~(A)*~(B)*C*~(D)*~(0)+~(A)*~(B)*C*D*~(0)+A*B*~(C)*~(D)*0)"),
    //.LUTG0("(A*B*~(C)*~(D)*~(1)+~(A)*~(B)*C*~(D)*~(1)+~(A)*~(B)*C*D*~(1)+A*B*~(C)*~(D)*1)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0001000000011000),
    .INIT_LUTG0(16'b0000000000001000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/O_audio_left_data_reg[10]_syn_4  (
    .a({open_n10193,\u_pcm_waveform/u_spectrum/fft_stage [1]}),
    .b({open_n10194,\u_pcm_waveform/u_spectrum/fft_stage [2]}),
    .c({open_n10195,\u_pcm_waveform/u_spectrum/fft_stage [3]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({open_n10196,\u_pcm_waveform/u_spectrum/mux6_syn_151 }),
    .e({open_n10197,\u_pcm_waveform/u_spectrum/mux6_syn_156 }),
    .mi({open_n10199,\u_audio_probe/u_tone/S_pcm_sample [10]}),
    .sr(\u_file_mapper/rst_dup_93 ),
    .f({open_n10211,\u_pcm_waveform/u_spectrum/mux6_syn_46 }),
    .q({open_n10215,\u_audio_probe/u_tone/O_audio_left_data [10]}));
EG_PHY_LSLICE #(
    //.LUTF0("(0*D*C*B*A)"),
    //.LUTG0("(1*D*C*B*A)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTG0(16'b1000000000000000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/O_audio_left_data_reg[14]_syn_4  (
    .a({open_n10216,\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/burst_cnt [0]}),
    .b({open_n10217,\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/burst_cnt [1]}),
    .c({open_n10218,\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/burst_cnt [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({open_n10219,\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/burst_cnt [3]}),
    .e({open_n10220,\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/burst_cnt [4]}),
    .mi({open_n10222,\u_audio_probe/u_tone/S_pcm_sample [14]}),
    .sr(\u_file_mapper/rst_dup_93 ),
    .f({open_n10234,\u_frame_buffer/u_legacy_frame_backend/frame_fifo_write_m0/add7_syn_39 }),
    .q({open_n10238,\u_audio_probe/u_tone/O_audio_left_data [14]}));
EG_PHY_MSLICE #(
    //.LUT0("(~D*~(B)*~(C)+~D*B*~(C)+~(~D)*B*C+~D*B*C)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1100000011001111),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/O_audio_left_data_reg[6]_syn_4  (
    .b({open_n10241,\u_jpeg_core/u_jpeg_dqt/cfg_table_addr_w [6]}),
    .c({open_n10242,\u_jpeg_core/u_jpeg_dqt/dqt_write_w }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({open_n10243,\u_jpeg_core/u_jpeg_dqt/dqt_table_addr_w[6]_syn_3 }),
    .mi({open_n10254,\u_audio_probe/u_tone/S_pcm_sample [6]}),
    .sr(\u_file_mapper/rst_dup_67 ),
    .f({open_n10255,\u_jpeg_core/u_jpeg_dqt/dqt_table_addr_w [6]}),
    .q({open_n10259,\u_audio_probe/u_tone/O_audio_left_data [6]}));
EG_PHY_LSLICE #(
    //.LUTF0("~(~0*~(0*~(~D*~(C*B*A))))"),
    //.LUTF1("~(~1*~(0*~(~D*~(C*B*A))))"),
    //.LUTG0("~(~0*~(1*~(~D*~(C*B*A))))"),
    //.LUTG1("~(~1*~(1*~(~D*~(C*B*A))))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b1111111111111111),
    .INIT_LUTG0(16'b1111111110000000),
    .INIT_LUTG1(16'b1111111111111111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("FX"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/O_audio_valid_reg_syn_5  (
    .a({\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_21 ,\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_21 }),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b2 [18],\u_audio_probe/u_tone/O_audio_left_data_b2 [18]}),
    .c({\u_audio_probe/u_tone/O_audio_left_data_b2 [19],\u_audio_probe/u_tone/O_audio_left_data_b2 [19]}),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/O_audio_left_data_b2 [23],\u_audio_probe/u_tone/O_audio_left_data_b2 [23]}),
    .e({\u_audio_probe/u_tone/O_audio_left_data_b2 [24],\u_audio_probe/u_tone/O_audio_left_data_b2 [24]}),
    .mi({open_n10262,\u_audio_probe/u_tone/O_audio_left_data_b2 [25]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .fx({open_n10277,\u_audio_probe/u_tone/O_audio_left_data_b_n }),
    .q({open_n10278,\u_audio_probe/tone_valid }));
EG_PHY_MSLICE #(
    //.LUT0("(B@(D*C*A))"),
    //.LUT1("(D@(C*B))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110110011001100),
    .INIT_LUT1(16'b0011111111000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_idx_reg[0]_syn_7  (
    .a({open_n10279,\u_audio_probe/u_tone/S_note_idx [0]}),
    .b({\u_audio_probe/u_tone/S_note_idx_b1_n ,\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/O_audio_left_data_b_n ,\u_audio_probe/u_tone/S_note_idx_b1_n }),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/O_audio_left_data_b_n }),
    .sr(\u_file_mapper/rst_dup_101 ),
    .q({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [1]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~0*~0*~D*~C*~B*~A)"),
    //.LUTF1("(~1*~0*~D*~C*~B*~A)"),
    //.LUTG0("(~0*~1*~D*~C*~B*~A)"),
    //.LUTG1("(~1*~1*~D*~C*~B*~A)"),
    .INIT_LUTF0(16'b0000000000000001),
    .INIT_LUTF1(16'b0000000000000000),
    .INIT_LUTG0(16'b0000000000000000),
    .INIT_LUTG1(16'b0000000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"))
    \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_36  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [16],\u_audio_probe/u_tone/S_note_sample_cnt [16]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [17],\u_audio_probe/u_tone/S_note_sample_cnt [17]}),
    .c({\u_audio_probe/u_tone/S_note_sample_cnt [21],\u_audio_probe/u_tone/S_note_sample_cnt [21]}),
    .d({\u_audio_probe/u_tone/S_note_sample_cnt [22],\u_audio_probe/u_tone/S_note_sample_cnt [22]}),
    .e({\u_audio_probe/u_tone/S_note_sample_cnt [23],\u_audio_probe/u_tone/S_note_sample_cnt [23]}),
    .mi({open_n10301,\u_audio_probe/u_tone/S_note_sample_cnt [31]}),
    .fx({open_n10317,\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_4 }));
EG_PHY_LSLICE #(
    //.LUTF0("(0*~0*~D*~C*~B*~A)"),
    //.LUTF1("(1*~0*~D*~C*~B*~A)"),
    //.LUTG0("(0*~1*~D*~C*~B*~A)"),
    //.LUTG1("(1*~1*~D*~C*~B*~A)"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b0000000000000001),
    .INIT_LUTG0(16'b0000000000000000),
    .INIT_LUTG1(16'b0000000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"))
    \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_38  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [24],\u_audio_probe/u_tone/S_note_sample_cnt [24]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [25],\u_audio_probe/u_tone/S_note_sample_cnt [25]}),
    .c({\u_audio_probe/u_tone/S_note_sample_cnt [26],\u_audio_probe/u_tone/S_note_sample_cnt [26]}),
    .d({\u_audio_probe/u_tone/S_note_sample_cnt [27],\u_audio_probe/u_tone/S_note_sample_cnt [27]}),
    .e({\u_audio_probe/u_tone/S_note_sample_cnt [28],\u_audio_probe/u_tone/S_note_sample_cnt [28]}),
    .mi({open_n10323,\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_6 }),
    .fx({open_n10339,\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_8 }));
EG_PHY_LSLICE #(
    //.LUTF0("(0*~0*~D*~C*~B*~A)"),
    //.LUTF1("(1*~0*~D*~C*~B*~A)"),
    //.LUTG0("(0*~1*~D*~C*~B*~A)"),
    //.LUTG1("(1*~1*~D*~C*~B*~A)"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b0000000000000001),
    .INIT_LUTG0(16'b0000000000000000),
    .INIT_LUTG1(16'b0000000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"))
    \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_40  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [18],\u_audio_probe/u_tone/S_note_sample_cnt [18]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [19],\u_audio_probe/u_tone/S_note_sample_cnt [19]}),
    .c({\u_audio_probe/u_tone/S_note_sample_cnt [20],\u_audio_probe/u_tone/S_note_sample_cnt [20]}),
    .d({\u_audio_probe/u_tone/S_note_sample_cnt [29],\u_audio_probe/u_tone/S_note_sample_cnt [29]}),
    .e({\u_audio_probe/u_tone/S_note_sample_cnt [30],\u_audio_probe/u_tone/S_note_sample_cnt [30]}),
    .mi({open_n10345,\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_4 }),
    .fx({open_n10361,\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_6 }));
EG_PHY_LSLICE #(
    //.LUTF0("(0*0*D*~C*B*A)"),
    //.LUTF1("(1*0*D*~C*B*A)"),
    //.LUTG0("(0*1*D*~C*B*A)"),
    //.LUTG1("(1*1*D*~C*B*A)"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b0000000000000000),
    .INIT_LUTG0(16'b0000000000000000),
    .INIT_LUTG1(16'b0000100000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .LSFXMUX0("FUNC6"),
    .MODE("LOGIC"))
    \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_43  (
    .a({\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_10 ,\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_10 }),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [8],\u_audio_probe/u_tone/S_note_sample_cnt [8]}),
    .c({\u_audio_probe/u_tone/S_note_sample_cnt [9],\u_audio_probe/u_tone/S_note_sample_cnt [9]}),
    .d({\u_audio_probe/u_tone/S_note_sample_cnt [10],\u_audio_probe/u_tone/S_note_sample_cnt [10]}),
    .e({\u_audio_probe/u_tone/S_note_sample_cnt [11],\u_audio_probe/u_tone/S_note_sample_cnt [11]}),
    .mi({open_n10367,\u_audio_probe/u_tone/S_note_sample_cnt [12]}),
    .fx({open_n10383,\u_audio_probe/u_tone/S_note_idx_reg[2]_syn_12 }));
EG_PHY_MSLICE #(
    //.LUT0("(C@(0*D*B*A))"),
    //.LUT1("(C@(1*D*B*A))"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000011110000),
    .INIT_LUT1(16'b0111100011110000),
    .MODE("LOGIC"),
    .MSFXMUX("ON"),
    .REG0_REGSET("RESET"),
    .REG0_SD("FX"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_idx_reg[2]_syn_45  (
    .a({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [0]}),
    .b({\u_audio_probe/u_tone/S_note_idx [1],\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/S_note_idx [2],\u_audio_probe/u_tone/S_note_idx [2]}),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx_b1_n ,\u_audio_probe/u_tone/S_note_idx_b1_n }),
    .mi({open_n10397,\u_audio_probe/u_tone/O_audio_left_data_b_n }),
    .sr(\u_file_mapper/rst_dup_101 ),
    .q({open_n10403,\u_audio_probe/u_tone/S_note_idx [2]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*D)"),
    //.LUTF1("(~D)"),
    //.LUTG0("(~C*D)"),
    //.LUTG1("(~D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100000000),
    .INIT_LUTF1(16'b0000000011111111),
    .INIT_LUTG0(16'b0000111100000000),
    .INIT_LUTG1(16'b0000000011111111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[0]_syn_4  (
    .c({open_n10408,\u_audio_probe/u_tone/S_note_idx_b1_n }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_sample_cnt [0],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [6]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [0],\u_audio_probe/u_tone/S_note_sample_cnt [6]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*D)"),
    //.LUT1("(~C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000111100000000),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[10]_syn_4  (
    .c({\u_audio_probe/u_tone/S_note_idx_b1_n ,\u_audio_probe/u_tone/S_note_idx_b1_n }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [10],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [8]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [10],\u_audio_probe/u_tone/S_note_sample_cnt [8]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*D)"),
    //.LUT1("(~C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000111100000000),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[11]_syn_4  (
    .c({\u_audio_probe/u_tone/S_note_idx_b1_n ,\u_audio_probe/u_tone/S_note_idx_b1_n }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [11],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [12]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [11],\u_audio_probe/u_tone/S_note_sample_cnt [12]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*D)"),
    //.LUTF1("(~C*D)"),
    //.LUTG0("(~C*D)"),
    //.LUTG1("(~C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000111100000000),
    .INIT_LUTF1(16'b0000111100000000),
    .INIT_LUTG0(16'b0000111100000000),
    .INIT_LUTG1(16'b0000111100000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[14]_syn_4  (
    .c({\u_audio_probe/u_tone/S_note_idx_b1_n ,\u_audio_probe/u_tone/S_note_idx_b1_n }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [14],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [7]}),
    .sr(\u_file_mapper/rst_dup_59 ),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [14],\u_audio_probe/u_tone/S_note_sample_cnt [7]}));
EG_PHY_LSLICE #(
    //.LUTF0("(D@(~(A)*~((C*B))*~(0)+A*~((C*B))*~(0)+A*(C*B)*~(0)+A*~((C*B))*0))"),
    //.LUTF1("~(D@(C*B))"),
    //.LUTG0("(D@(~(A)*~((C*B))*~(1)+A*~((C*B))*~(1)+A*(C*B)*~(1)+A*~((C*B))*1))"),
    //.LUTG1("~(D@(C*B))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0100000010111111),
    .INIT_LUTF1(16'b1100000000111111),
    .INIT_LUTG0(16'b1101010100101010),
    .INIT_LUTG1(16'b1100000000111111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[17]_syn_4  (
    .a({open_n10497,\u_pcm_waveform/state_q [13]}),
    .b(\u_pcm_waveform/target_q [3:2]),
    .c({\u_pcm_waveform/snapshot_valid ,\u_pcm_waveform/snapshot_valid }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_q [14],\u_pcm_waveform/state_write_data[10]_syn_6 }),
    .e({open_n10498,\u_pcm_waveform/state_write_data[10]_syn_16 }),
    .mi(\u_audio_probe/u_tone/S_note_sample_cnt_b2 [17:16]),
    .sr(\u_file_mapper/rst_dup_59 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_6 ,\u_pcm_waveform/state_write_data[10]_syn_18 }),
    .q(\u_audio_probe/u_tone/S_note_sample_cnt [17:16]));
EG_PHY_LSLICE #(
    //.LUTF0("(0*~(~(D*~B)*~(C*~A)))"),
    //.LUTF1("(D*(~(A)*~(B)*~(C)*~(0)+A*~(B)*C*~(0)+~(A)*B*C*~(0)+~(A)*~(B)*C*0+A*~(B)*C*0+~(A)*B*C*0))"),
    //.LUTG0("(1*~(~(D*~B)*~(C*~A)))"),
    //.LUTG1("(D*(~(A)*~(B)*~(C)*~(1)+A*~(B)*C*~(1)+~(A)*B*C*~(1)+~(A)*~(B)*C*1+A*~(B)*C*1+~(A)*B*C*1))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b0110000100000000),
    .INIT_LUTG0(16'b0111001101010000),
    .INIT_LUTG1(16'b0111000000000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[18]_syn_4  (
    .a({\u_pcm_waveform/state_write_data[10]_syn_68 ,\u_pcm_waveform/state_q [17]}),
    .b(\u_pcm_waveform/state_q [17:16]),
    .c({\u_pcm_waveform/target_q [6],\u_pcm_waveform/target_q [6]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_write_data[10]_syn_14 ,\u_pcm_waveform/target_q [5]}),
    .e({\u_pcm_waveform/state_write_data[10]_syn_70 ,\u_pcm_waveform/snapshot_valid }),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [18],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [19]}),
    .sr(\u_file_mapper/rst_dup_59 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_72 ,\u_pcm_waveform/state_write_data[10]_syn_10 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [18],\u_audio_probe/u_tone/S_note_sample_cnt [19]}));
EG_PHY_MSLICE #(
    //.LUT0("(C*D)"),
    //.LUT1("(D*~(C*B))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000000000000),
    .INIT_LUT1(16'b0011111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[21]_syn_4  (
    .b({\u_pcm_waveform/target_q [6],open_n10531}),
    .c({\u_pcm_waveform/snapshot_valid ,\u_pcm_waveform/snapshot_valid }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_q [17],\u_pcm_waveform/target_q [3]}),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [21],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [27]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_2 ,\u_pcm_waveform/state_write_data[10]_syn_20 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [21],\u_audio_probe/u_tone/S_note_sample_cnt [27]}));
EG_PHY_MSLICE #(
    //.LUT0("(~(D*~B)*~(C*~A))"),
    //.LUT1("(C*B*~D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1000110010101111),
    .INIT_LUT1(16'b0000000011000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[22]_syn_4  (
    .a({open_n10545,\u_pcm_waveform/state_q [15]}),
    .b({\u_pcm_waveform/target_q [5],\u_pcm_waveform/state_q [14]}),
    .c({\u_pcm_waveform/state_write_data[10]_syn_66 ,\u_pcm_waveform/target_q [4]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_q [16],\u_pcm_waveform/target_q [3]}),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [22],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [20]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_68 ,\u_pcm_waveform/state_write_data[10]_syn_4 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [22],\u_audio_probe/u_tone/S_note_sample_cnt [20]}));
EG_PHY_LSLICE #(
    //.LUTF0("(0*~(~D*B)*~(C@A))"),
    //.LUTF1("(~((B*~A))*~(C)*~(D)*~(0)+~((B*~A))*C*~(D)*~(0)+~((B*~A))*C*D*~(0)+~((B*~A))*C*~(D)*0+(B*~A)*C*~(D)*0)"),
    //.LUTG0("(1*~(~D*B)*~(C@A))"),
    //.LUTG1("(~((B*~A))*~(C)*~(D)*~(1)+~((B*~A))*C*~(D)*~(1)+~((B*~A))*C*D*~(1)+~((B*~A))*C*~(D)*1+(B*~A)*C*~(D)*1)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b1011000010111011),
    .INIT_LUTG0(16'b1010010100100001),
    .INIT_LUTG1(16'b0000000011110000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[23]_syn_4  (
    .a({\u_pcm_waveform/state_q [15],\u_pcm_waveform/state_q [16]}),
    .b({\u_pcm_waveform/target_q [4],\u_pcm_waveform/state_q [15]}),
    .c({\u_pcm_waveform/state_q [16],\u_pcm_waveform/target_q [5]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d(\u_pcm_waveform/target_q [5:4]),
    .e({\u_pcm_waveform/state_write_data[10]_syn_60 ,\u_pcm_waveform/snapshot_valid }),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [23],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [26]}),
    .sr(\u_file_mapper/rst_dup_27 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_70 ,\u_pcm_waveform/state_write_data[10]_syn_12 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [23],\u_audio_probe/u_tone/S_note_sample_cnt [26]}));
EG_PHY_MSLICE #(
    //.LUT0("~(A@(D*(C@B)))"),
    //.LUT1("(C*(D@B@A))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110100101010101),
    .INIT_LUT1(16'b1001000001100000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[24]_syn_4  (
    .a(\u_pcm_waveform/state_q [16:15]),
    .b(\u_pcm_waveform/target_q [5:4]),
    .c({\u_pcm_waveform/state_write_data[10]_syn_14 ,\u_pcm_waveform/target_q [3]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_write_data[10]_syn_60 ,\u_pcm_waveform/snapshot_valid }),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [24],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [25]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_62 ,\u_pcm_waveform/state_write_data[10]_syn_22 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [24],\u_audio_probe/u_tone/S_note_sample_cnt [25]}));
EG_PHY_LSLICE #(
    //.LUTF0("(0*A*~(B@(~D*~C)))"),
    //.LUTF1("~(D@(~C*~B))"),
    //.LUTG0("(1*A*~(B@(~D*~C)))"),
    //.LUTG1("~(D@(~C*~B))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b0000001111111100),
    .INIT_LUTG0(16'b0010001000101000),
    .INIT_LUTG1(16'b0000001111111100),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[29]_syn_4  (
    .a({open_n10587,\u_pcm_waveform/state_q [16]}),
    .b({\u_pcm_waveform/state_write_data[10]_syn_40 ,\u_pcm_waveform/target_q [5]}),
    .c({\u_pcm_waveform/state_write_data[10]_syn_42 ,\u_pcm_waveform/target_q [4]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_q [14],\u_pcm_waveform/target_q [3]}),
    .e({open_n10588,\u_pcm_waveform/snapshot_valid }),
    .mi(\u_audio_probe/u_tone/S_note_sample_cnt_b2 [29:28]),
    .sr(\u_file_mapper/rst_dup_27 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_44 ,\u_pcm_waveform/state_write_data[10]_syn_56 }),
    .q(\u_audio_probe/u_tone/S_note_sample_cnt [29:28]));
EG_PHY_LSLICE #(
    //.LUTF0("(~(A)*~(B)*C*~(D)*~(0)+~(A)*B*C*~(D)*~(0)+~(A)*~(B)*~(C)*D*~(0)+~(A)*~(B)*C*D*~(0)+A*~(B)*C*D*~(0)+~(A)*B*C*D*~(0)+~(A)*~(B)*~(C)*~(D)*0+~(A)*~(B)*C*~(D)*0+A*~(B)*C*~(D)*0+~(A)*B*C*~(D)*0+~(A)*~(B)*~(C)*D*0+~(A)*B*~(C)*D*0+~(A)*~(B)*C*D*0+A*~(B)*C*D*0+~(A)*B*C*D*0+A*B*C*D*0)"),
    //.LUTF1("(0@A@(~(B)*C*~(D)+~(B)*~(C)*D+~(B)*C*D+B*C*D))"),
    //.LUTG0("(~(A)*~(B)*C*~(D)*~(1)+~(A)*B*C*~(D)*~(1)+~(A)*~(B)*~(C)*D*~(1)+~(A)*~(B)*C*D*~(1)+A*~(B)*C*D*~(1)+~(A)*B*C*D*~(1)+~(A)*~(B)*~(C)*~(D)*1+~(A)*~(B)*C*~(D)*1+A*~(B)*C*~(D)*1+~(A)*B*C*~(D)*1+~(A)*~(B)*~(C)*D*1+~(A)*B*~(C)*D*1+~(A)*~(B)*C*D*1+A*~(B)*C*D*1+~(A)*B*C*D*1+A*B*C*D*1)"),
    //.LUTG1("(1@A@(~(B)*C*~(D)+~(B)*~(C)*D+~(B)*C*D+B*C*D))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0111000101010000),
    .INIT_LUTF1(16'b0101100110011010),
    .INIT_LUTG0(16'b1111010101110001),
    .INIT_LUTG1(16'b1010011001100101),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[2]_syn_4  (
    .a({\u_pcm_waveform/state_q [16],\u_pcm_waveform/state_q [13]}),
    .b({\u_pcm_waveform/state_q [15],\u_pcm_waveform/state_q [12]}),
    .c({\u_pcm_waveform/state_write_data[10]_syn_62 ,\u_pcm_waveform/target_q [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_write_data[10]_syn_64 ,\u_pcm_waveform/target_q [1]}),
    .e({\u_pcm_waveform/state_write_data[10]_syn_72 ,\u_pcm_waveform/target_q [0]}),
    .mi(\u_audio_probe/u_tone/S_note_sample_cnt_b2 [2:1]),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_pcm_waveform/next_height [5],\u_pcm_waveform/state_write_data[10]_syn_8 }),
    .q(\u_audio_probe/u_tone/S_note_sample_cnt [2:1]));
EG_PHY_MSLICE #(
    //.LUT0("(~C*D)"),
    //.LUT1("(~C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000111100000000),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[30]_syn_4  (
    .c({\u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_19 ,\u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_18 }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_jpeg_core/u_jpeg_idct/u_transpose/u_ram0/wr0_i ,\u_jpeg_core/u_jpeg_idct/u_transpose/u_ram0/wr0_i }),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [30],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [31]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[19]_syn_2 ,\u_jpeg_core/u_jpeg_idct/u_transpose/inport_data_i[20]_syn_2 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [30],\u_audio_probe/u_tone/S_note_sample_cnt [31]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~(A)*~(B)*~(C)*~(D)*~(0)+~(A)*~(B)*C*~(D)*~(0)+~(A)*~(B)*~(C)*D*~(0)+~(A)*~(B)*C*D*~(0)+~(A)*~(B)*~(C)*~(D)*0+~(A)*~(B)*C*~(D)*0+A*~(B)*C*~(D)*0+~(A)*B*C*~(D)*0+~(A)*~(B)*~(C)*D*0+~(A)*B*~(C)*D*0+~(A)*~(B)*C*D*0+A*~(B)*C*D*0+~(A)*B*C*D*0+A*B*C*D*0)"),
    //.LUTF1("(~(A)*~(B)*~(C)*~(D)*~(0)+~(A)*~(B)*C*~(D)*~(0)+~(A)*B*C*~(D)*~(0)+~(A)*~(B)*C*D*~(0)+~(A)*~(B)*~(C)*~(D)*0+A*~(B)*~(C)*~(D)*0+~(A)*B*~(C)*~(D)*0+~(A)*~(B)*C*~(D)*0+A*~(B)*C*~(D)*0+~(A)*B*C*~(D)*0+A*B*C*~(D)*0+~(A)*~(B)*~(C)*D*0+~(A)*B*~(C)*D*0+~(A)*~(B)*C*D*0+A*~(B)*C*D*0+~(A)*B*C*D*0)"),
    //.LUTG0("(~(A)*~(B)*~(C)*~(D)*~(1)+~(A)*~(B)*C*~(D)*~(1)+~(A)*~(B)*~(C)*D*~(1)+~(A)*~(B)*C*D*~(1)+~(A)*~(B)*~(C)*~(D)*1+~(A)*~(B)*C*~(D)*1+A*~(B)*C*~(D)*1+~(A)*B*C*~(D)*1+~(A)*~(B)*~(C)*D*1+~(A)*B*~(C)*D*1+~(A)*~(B)*C*D*1+A*~(B)*C*D*1+~(A)*B*C*D*1+A*B*C*D*1)"),
    //.LUTG1("(~(A)*~(B)*~(C)*~(D)*~(1)+~(A)*~(B)*C*~(D)*~(1)+~(A)*B*C*~(D)*~(1)+~(A)*~(B)*C*D*~(1)+~(A)*~(B)*~(C)*~(D)*1+A*~(B)*~(C)*~(D)*1+~(A)*B*~(C)*~(D)*1+~(A)*~(B)*C*~(D)*1+A*~(B)*C*~(D)*1+~(A)*B*C*~(D)*1+A*B*C*~(D)*1+~(A)*~(B)*~(C)*D*1+~(A)*B*~(C)*D*1+~(A)*~(B)*C*D*1+A*~(B)*C*D*1+~(A)*B*C*D*1)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0001000100010001),
    .INIT_LUTF1(16'b0001000001010001),
    .INIT_LUTG0(16'b1111010101110001),
    .INIT_LUTG1(16'b0111010111110111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[3]_syn_4  (
    .a({\u_pcm_waveform/state_q [14],\u_pcm_waveform/state_q [12]}),
    .b({\u_pcm_waveform/state_q [13],\u_pcm_waveform/state_q [11]}),
    .c({\u_pcm_waveform/state_write_data[10]_syn_46 ,\u_pcm_waveform/target_q [1]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_write_data[10]_syn_48 ,\u_pcm_waveform/target_q [0]}),
    .e({\u_pcm_waveform/state_write_data[10]_syn_58 ,\u_pcm_waveform/snapshot_valid }),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [3],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [4]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_64 ,\u_pcm_waveform/state_write_data[10]_syn_16 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [3],\u_audio_probe/u_tone/S_note_sample_cnt [4]}));
EG_PHY_MSLICE #(
    //.LUT0("(C*~(A*~(D*~B)))"),
    //.LUT1("(C*B*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0111000001010000),
    .INIT_LUT1(16'b1100000000000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[5]_syn_4  (
    .a({open_n10651,\u_pcm_waveform/state_q [14]}),
    .b({\u_pcm_waveform/state_write_data[10]_syn_14 ,\u_pcm_waveform/target_q [3]}),
    .c({\u_pcm_waveform/state_write_data[10]_syn_28 ,\u_pcm_waveform/target_q [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/target_q [1],\u_pcm_waveform/snapshot_valid }),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [5],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [15]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_32 ,\u_pcm_waveform/state_write_data[10]_syn_24 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [5],\u_audio_probe/u_tone/S_note_sample_cnt [15]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~A*((~D*~C)*~(0)*~(B)+(~D*~C)*0*~(B)+~((~D*~C))*0*B+(~D*~C)*0*B))"),
    //.LUTF1("(D*~(~C*~B*A))"),
    //.LUTG0("(~A*((~D*~C)*~(1)*~(B)+(~D*~C)*1*~(B)+~((~D*~C))*1*B+(~D*~C)*1*B))"),
    //.LUTG1("(D*~(~C*~B*A))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000000000001),
    .INIT_LUTF1(16'b1111110100000000),
    .INIT_LUTG0(16'b0100010001000101),
    .INIT_LUTG1(16'b1111110100000000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_note_sample_cnt_reg[9]_syn_4  (
    .a(\u_pcm_waveform/state_q [12:11]),
    .b({\u_pcm_waveform/state_write_data[10]_syn_30 ,\u_pcm_waveform/state_write_data[10]_syn_14 }),
    .c({\u_pcm_waveform/state_write_data[10]_syn_32 ,\u_pcm_waveform/state_write_data[10]_syn_18 }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_write_data[10]_syn_34 ,\u_pcm_waveform/state_write_data[10]_syn_26 }),
    .e({open_n10665,\u_pcm_waveform/state_write_data[10]_syn_28 }),
    .mi({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [9],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [13]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_pcm_waveform/state_write_data[10]_syn_46 ,\u_pcm_waveform/state_write_data[10]_syn_30 }),
    .q({\u_audio_probe/u_tone/S_note_sample_cnt [9],\u_audio_probe/u_tone/S_note_sample_cnt [13]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~C*~D)"),
    //.LUTF1("(~D)"),
    //.LUTG0("(~C*~D)"),
    //.LUTG1("(~D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000000001111),
    .INIT_LUTF1(16'b0000000011111111),
    .INIT_LUTG0(16'b0000000000001111),
    .INIT_LUTG1(16'b0000000011111111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_pcm_sample_reg[10]_syn_4  (
    .c({open_n10685,\u_pcm_waveform/u_spectrum/state_reg_syn_1 [8]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_phase_acc [31],\u_pcm_waveform/u_spectrum/state_reg_syn_1 [7]}),
    .mi({open_n10689,\u_audio_probe/u_tone/S_phase_acc [31]}),
    .sr(\u_file_mapper/rst_dup_58 ),
    .f({open_n10701,\u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_6 }),
    .q({\u_audio_probe/u_tone/S_pcm_sample [10],\u_audio_probe/u_tone/S_pcm_sample [14]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*~D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001111),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_pcm_sample_reg[6]_syn_4  (
    .c({open_n10709,\u_pcm_waveform/u_spectrum/state_reg_syn_1 [9]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({open_n10710,\u_pcm_waveform/u_spectrum/state_reg_syn_1 [6]}),
    .mi({open_n10721,1'b1}),
    .sr(\u_file_mapper/rst_dup_68 ),
    .f({open_n10722,\u_pcm_waveform/u_spectrum/emit_value_b[14]_syn_8 }),
    .q({open_n10726,\u_audio_probe/u_tone/S_pcm_sample [6]}));
EG_PHY_MSLICE #(
    //.LUT0("~(B*~(C*D))"),
    //.LUT1("(~C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111001100110011),
    .INIT_LUT1(16'b0000111100000000),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[10]_syn_4  (
    .b({open_n10729,\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/S_note_idx [1],\u_audio_probe/u_tone/S_note_idx [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [0]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [10],\u_audio_probe/u_tone/S_phase_acc_b1 [12]}),
    .sr(\u_file_mapper/rst_dup_26 ),
    .f({\u_audio_probe/u_tone/mux1_syn_142 ,\u_audio_probe/u_tone/mux1_syn_192 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [10],\u_audio_probe/u_tone/S_phase_acc [12]}));
EG_PHY_MSLICE #(
    //.LUT0("~(~B*~(~C*D))"),
    //.LUT1("~(B*~(C@D))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1100111111001100),
    .INIT_LUT1(16'b0011111111110011),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[11]_syn_4  (
    .b({\u_audio_probe/u_tone/S_note_idx [1],\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/S_note_idx [2],\u_audio_probe/u_tone/S_note_idx [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [0]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [11],\u_audio_probe/u_tone/S_phase_acc_b1 [17]}),
    .sr(\u_file_mapper/rst_dup_26 ),
    .f({\u_audio_probe/u_tone/mux1_syn_180 ,\u_audio_probe/u_tone/mux1_syn_290 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [11],\u_audio_probe/u_tone/S_phase_acc [17]}));
EG_PHY_MSLICE #(
    //.LUT0("(~(D)*B*~(C)+D*~(B)*C+D*B*C)"),
    //.LUT1("(~(D)*~(B)*~(C)+~(D)*B*C+D*B*C)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000000001100),
    .INIT_LUT1(16'b1100000011000011),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[15]_syn_4  (
    .b({\u_audio_probe/u_tone/S_note_idx [1],\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/S_note_idx [2],\u_audio_probe/u_tone/S_note_idx [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [0]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [15],\u_audio_probe/u_tone/S_phase_acc_b1 [16]}),
    .sr(\u_file_mapper/rst_dup_26 ),
    .f({\u_audio_probe/u_tone/mux1_syn_126 ,\u_audio_probe/u_tone/mux1_syn_168 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [15],\u_audio_probe/u_tone/S_phase_acc [16]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~D)"),
    //.LUTF1("(~D)"),
    //.LUTG0("(~D)"),
    //.LUTG1("(~D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000011111111),
    .INIT_LUTF1(16'b0000000011111111),
    .INIT_LUTG0(16'b0000000011111111),
    .INIT_LUTG1(16'b0000000011111111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[19]_syn_4  (
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/mux1_syn_156 ,\u_audio_probe/u_tone/S_note_idx [2]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [19],\u_audio_probe/u_tone/S_phase_acc_b1 [30]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_audio_probe/u_tone/W_note_inc[10]_syn_2 ,\u_audio_probe/u_tone/S_note_idx[2]_syn_2 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [19],\u_audio_probe/u_tone/S_phase_acc [30]}));
EG_PHY_MSLICE #(
    //.LUT0("(~C*~D)"),
    //.LUT1("~(C@D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001111),
    .INIT_LUT1(16'b1111000000001111),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[1]_syn_4  (
    .c({\u_pcm_waveform/state_write_data[9]_syn_5 ,\u_pcm_waveform/update_state_reg_syn_1 [4]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_pcm_waveform/state_write_data[9]_syn_3 ,\u_pcm_waveform/update_state_reg_syn_1 [0]}),
    .mi(\u_audio_probe/u_tone/S_phase_acc_b1 [1:0]),
    .sr(\u_file_mapper/rst_dup_26 ),
    .f({\u_pcm_waveform/next_height [1],\u_pcm_waveform/update_state_reg[1]_syn_4 }),
    .q(\u_audio_probe/u_tone/S_phase_acc [1:0]));
EG_PHY_MSLICE #(
    //.LUT0("(D*~(C*B))"),
    //.LUT1("(~(D)*B*~(C)+~(D)*~(B)*C+~(D)*B*C+D*B*C)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0011111100000000),
    .INIT_LUT1(16'b1100000011111100),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[20]_syn_4  (
    .b({\u_audio_probe/u_tone/S_note_idx [1],\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/S_note_idx [2],\u_audio_probe/u_tone/S_note_idx [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [0]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [20],\u_audio_probe/u_tone/S_phase_acc_b1 [22]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_audio_probe/u_tone/mux1_syn_222 ,\u_audio_probe/u_tone/mux1_syn_202 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [20],\u_audio_probe/u_tone/S_phase_acc [22]}));
EG_PHY_MSLICE #(
    //.LUT0("(~(D)*~(B)*~(C)+D*B*~(C)+~(D)*~(B)*C)"),
    //.LUT1("(~C*~D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000110000110011),
    .INIT_LUT1(16'b0000000000001111),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[23]_syn_4  (
    .b({open_n10830,\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/S_note_idx [1],\u_audio_probe/u_tone/S_note_idx [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [0]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [23],\u_audio_probe/u_tone/S_phase_acc_b1 [21]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_audio_probe/u_tone/mux1_syn_112 ,\u_audio_probe/u_tone/mux1_syn_234 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [23],\u_audio_probe/u_tone/S_phase_acc [21]}));
EG_PHY_MSLICE #(
    //.LUT0("~(~D*~(B)*~(C)+~D*B*~(C)+~(~D)*B*C+~D*B*C)"),
    //.LUT1("(~D*~(C@B))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0011111100110000),
    .INIT_LUT1(16'b0000000011000011),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[24]_syn_4  (
    .b({\u_audio_probe/u_tone/S_note_idx [1],\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/S_note_idx [2],\u_audio_probe/u_tone/S_note_idx [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [0]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [24],\u_audio_probe/u_tone/S_phase_acc_b1 [27]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_audio_probe/u_tone/mux1_syn_266 ,\u_audio_probe/u_tone/mux1_syn_256 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [24],\u_audio_probe/u_tone/S_phase_acc [27]}));
EG_PHY_MSLICE #(
    //.LUT0("(D*~(~C*~B))"),
    //.LUT1("(~(D)*~(B)*~(C)+~(D)*B*~(C)+D*B*~(C)+D*~(B)*C+D*B*C)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111110000000000),
    .INIT_LUT1(16'b1111110000001111),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[25]_syn_4  (
    .b({\u_audio_probe/u_tone/S_note_idx [1],\u_audio_probe/u_tone/S_note_idx [1]}),
    .c({\u_audio_probe/u_tone/S_note_idx [2],\u_audio_probe/u_tone/S_note_idx [2]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_audio_probe/u_tone/S_note_idx [0]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [25],\u_audio_probe/u_tone/S_phase_acc_b1 [26]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_audio_probe/u_tone/mux1_syn_278 ,\u_audio_probe/u_tone/mux1_syn_244 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [25],\u_audio_probe/u_tone/S_phase_acc [26]}));
EG_PHY_LSLICE #(
    //.LUTF0("(0*D*C*B*A)"),
    //.LUTF1("(A*~(B)*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*B*C*D)"),
    //.LUTG0("(1*D*C*B*A)"),
    //.LUTG1("(A*~(B)*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0000000000000000),
    .INIT_LUTF1(16'b1001101010010010),
    .INIT_LUTG0(16'b1000000000000000),
    .INIT_LUTG1(16'b1001101010010010),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[3]_syn_4  (
    .a({\u_dynamic_text/scroll_sum [4],\u_dynamic_text/scroll_phase [4]}),
    .b({\u_dynamic_text/scroll_sum [5],\u_dynamic_text/scroll_phase [5]}),
    .c({\u_dynamic_text/scroll_sum [7],\u_dynamic_text/scroll_phase [6]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_dynamic_text/scroll_sum [8],\u_dynamic_text/scroll_phase [7]}),
    .e({open_n10874,\u_dynamic_text/add6_syn_36 }),
    .mi(\u_audio_probe/u_tone/S_phase_acc_b1 [3:2]),
    .sr(\u_file_mapper/rst_dup_26 ),
    .f({\u_video_rgb_to_axis_640x480/I_rgb[23]_syn_238 ,\u_dynamic_text/add6_syn_52 }),
    .q(\u_audio_probe/u_tone/S_phase_acc [3:2]));
EG_PHY_LSLICE #(
    //.LUTF0("(~(A)*~(B)*~(C)*~(D)*~(0)+A*~(B)*~(C)*~(D)*~(0)+~(A)*B*~(C)*~(D)*~(0)+A*B*~(C)*~(D)*~(0)+~(A)*~(B)*C*~(D)*~(0)+A*~(B)*C*~(D)*~(0)+~(A)*B*C*~(D)*~(0)+A*B*C*~(D)*~(0)+A*~(B)*~(C)*D*~(0)+~(A)*B*~(C)*D*~(0)+A*B*~(C)*D*~(0)+~(A)*~(B)*C*D*~(0)+A*~(B)*C*D*~(0)+~(A)*B*C*D*~(0)+A*B*C*D*~(0)+~(A)*~(B)*~(C)*~(D)*0+A*~(B)*~(C)*~(D)*0+A*B*~(C)*~(D)*0+~(A)*~(B)*C*~(D)*0+~(A)*B*C*~(D)*0+~(A)*~(B)*~(C)*D*0+A*~(B)*~(C)*D*0+~(A)*B*~(C)*D*0+A*B*~(C)*D*0+~(A)*~(B)*C*D*0+A*~(B)*C*D*0+~(A)*B*C*D*0+A*B*C*D*0)"),
    //.LUTF1("(A*B*~(C)*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    //.LUTG0("(~(A)*~(B)*~(C)*~(D)*~(1)+A*~(B)*~(C)*~(D)*~(1)+~(A)*B*~(C)*~(D)*~(1)+A*B*~(C)*~(D)*~(1)+~(A)*~(B)*C*~(D)*~(1)+A*~(B)*C*~(D)*~(1)+~(A)*B*C*~(D)*~(1)+A*B*C*~(D)*~(1)+A*~(B)*~(C)*D*~(1)+~(A)*B*~(C)*D*~(1)+A*B*~(C)*D*~(1)+~(A)*~(B)*C*D*~(1)+A*~(B)*C*D*~(1)+~(A)*B*C*D*~(1)+A*B*C*D*~(1)+~(A)*~(B)*~(C)*~(D)*1+A*~(B)*~(C)*~(D)*1+A*B*~(C)*~(D)*1+~(A)*~(B)*C*~(D)*1+~(A)*B*C*~(D)*1+~(A)*~(B)*~(C)*D*1+A*~(B)*~(C)*D*1+~(A)*B*~(C)*D*1+A*B*~(C)*D*1+~(A)*~(B)*C*D*1+A*~(B)*C*D*1+~(A)*B*C*D*1+A*B*C*D*1)"),
    //.LUTG1("(A*B*~(C)*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b1111111011111111),
    .INIT_LUTF1(16'b0111001011001000),
    .INIT_LUTG0(16'b1111111101011011),
    .INIT_LUTG1(16'b0111001011001000),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[5]_syn_4  (
    .a({\u_dynamic_text/scroll_sum [4],\u_dynamic_text/scroll_sum [4]}),
    .b({\u_dynamic_text/scroll_sum [5],\u_dynamic_text/scroll_sum [5]}),
    .c({\u_dynamic_text/scroll_sum [6],\u_dynamic_text/scroll_sum [6]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_dynamic_text/scroll_sum [7],\u_dynamic_text/scroll_sum [7]}),
    .e({open_n10890,\u_dynamic_text/scroll_sum [8]}),
    .mi(\u_audio_probe/u_tone/S_phase_acc_b1 [5:4]),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_dynamic_text/mux6_syn_83 ,\u_video_rgb_to_axis_640x480/I_rgb[23]_syn_243 }),
    .q(\u_audio_probe/u_tone/S_phase_acc [5:4]));
EG_PHY_LSLICE #(
    //.LUTF0("(D*(C@B))"),
    //.LUTG0("(D*(C@B))"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0011110000000000),
    .INIT_LUTG0(16'b0011110000000000),
    .LSFMUX0("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[6]_syn_4  (
    .b({open_n10908,\u_dynamic_text/scroll_sum [6]}),
    .c({open_n10909,\u_dynamic_text/scroll_sum [7]}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({open_n10910,\u_dynamic_text/scroll_sum [4]}),
    .mi({open_n10914,\u_audio_probe/u_tone/S_phase_acc_b1 [6]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({open_n10926,\u_video_rgb_to_axis_640x480/I_rgb[23]_syn_236 }),
    .q({open_n10930,\u_audio_probe/u_tone/S_phase_acc [6]}));
EG_PHY_MSLICE #(
    //.LUT0("~(C@D)"),
    //.LUT1("(~D)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1111000000001111),
    .INIT_LUT1(16'b0000000011111111),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[8]_syn_4  (
    .c({open_n10935,\u_audio_probe/u_tone/O_audio_left_data_b_n }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_sample_acc [7],\u_audio_probe/u_tone/S_note_sample_cnt [0]}),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [8],\u_audio_probe/u_tone/S_phase_acc_b1 [18]}),
    .sr(\u_file_mapper/rst_dup_101 ),
    .f({\u_audio_probe/u_tone/S_sample_acc[7]_syn_2 ,al_172[6]}),
    .q({\u_audio_probe/u_tone/S_phase_acc [8],\u_audio_probe/u_tone/S_phase_acc [18]}));
EG_PHY_LSLICE #(
    //.LUTF0("(~(B)*~((~D*C))*~((~0*A))+B*(~D*C)*~((~0*A))+~(B)*~((~D*C))*(~0*A))"),
    //.LUTF1("~(D*~(B)*~(C)+D*B*~(C)+~(D)*B*C+D*B*C)"),
    //.LUTG0("(~(B)*~((~D*C))*~((~1*A))+B*(~D*C)*~((~1*A))+~(B)*~((~D*C))*(~1*A))"),
    //.LUTG1("~(D*~(B)*~(C)+D*B*~(C)+~(D)*B*C+D*B*C)"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'b0011001101000011),
    .INIT_LUTF1(16'b0011000000111111),
    .INIT_LUTG0(16'b0011001111000011),
    .INIT_LUTG1(16'b0011000000111111),
    .LSFMUX0("FUNC5"),
    .LSFMUX1("FUNC5"),
    .MODE("LOGIC"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_phase_acc_reg[9]_syn_4  (
    .a({open_n10949,\u_adjust_osd/y_pos [1]}),
    .b({\u_audio_probe/u_tone/S_note_idx [1],\u_adjust_osd/y_pos [2]}),
    .c({\u_audio_probe/u_tone/S_note_idx [2],\u_video_rgb_to_axis_640x480/I_rgb[23]_syn_167 }),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/S_note_idx [0],\u_video_rgb_to_axis_640x480/I_rgb[23]_syn_173 }),
    .e({open_n10950,\u_video_rgb_to_axis_640x480/I_rgb[23]_syn_177 }),
    .mi({\u_audio_probe/u_tone/S_phase_acc_b1 [9],\u_audio_probe/u_tone/S_phase_acc_b1 [7]}),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_audio_probe/u_tone/mux1_syn_156 ,\u_video_rgb_to_axis_640x480/I_rgb[23]_syn_222 }),
    .q({\u_audio_probe/u_tone/S_phase_acc [9],\u_audio_probe/u_tone/S_phase_acc [7]}));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[10]_syn_4  (
    .a(\u_audio_probe/u_tone/O_audio_left_data_b2 [10:9]),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_105 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/sub0_syn_107 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [10:9]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[12]_syn_4  (
    .a(\u_audio_probe/u_tone/O_audio_left_data_b2 [12:11]),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b_n ,\u_audio_probe/u_tone/O_audio_left_data_b_n }),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_107 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/sub0_syn_109 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [12:11]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[14]_syn_4  (
    .a(\u_audio_probe/u_tone/O_audio_left_data_b2 [14:13]),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b_n ,\u_audio_probe/u_tone/O_audio_left_data_b_n }),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_109 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/sub0_syn_111 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [14:13]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[16]_syn_4  (
    .a(\u_audio_probe/u_tone/O_audio_left_data_b2 [16:15]),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b_n ,1'b0}),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_111 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/sub0_syn_113 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [16:15]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[18]_syn_4  (
    .a(\u_audio_probe/u_tone/O_audio_left_data_b2 [18:17]),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b_n ,1'b0}),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_113 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/sub0_syn_115 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [18:17]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[20]_syn_4  (
    .a(\u_audio_probe/u_tone/O_audio_left_data_b2 [20:19]),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b_n ,\u_audio_probe/u_tone/O_audio_left_data_b_n }),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_115 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/sub0_syn_117 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [20:19]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[22]_syn_4  (
    .a(\u_audio_probe/u_tone/O_audio_left_data_b2 [22:21]),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b_n ,\u_audio_probe/u_tone/O_audio_left_data_b_n }),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_117 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/sub0_syn_119 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [22:21]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[24]_syn_4  (
    .a(\u_audio_probe/u_tone/O_audio_left_data_b2 [24:23]),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b_n ,1'b0}),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_119 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [24:23]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/S_sample_acc_reg[8]_syn_4  (
    .a({\u_audio_probe/u_tone/O_audio_left_data_b2 [8],\u_audio_probe/u_tone/S_sample_acc[7]_syn_2 }),
    .b(2'b00),
    .clk(\u_adjust_control/clk ),
    .fci(\u_audio_probe/u_tone/sub0_syn_103 ),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/sub0_syn_105 ),
    .q(\u_audio_probe/u_tone/S_sample_acc [8:7]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/add0_syn_136  (
    .a({\u_audio_probe/u_tone/S_sample_acc [7],1'b0}),
    .b({1'b1,open_n11147}),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .mi(\u_audio_probe/u_tone/S_phase_acc_b1 [14:13]),
    .sr(\u_file_mapper/rst_dup_101 ),
    .fco(\u_audio_probe/u_tone/add0_syn_95 ),
    .q(\u_audio_probe/u_tone/S_phase_acc [14:13]));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_139  (
    .a(\u_audio_probe/u_tone/S_sample_acc [9:8]),
    .b(2'b11),
    .fci(\u_audio_probe/u_tone/add0_syn_95 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [9:8]),
    .fco(\u_audio_probe/u_tone/add0_syn_97 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_142  (
    .a(\u_audio_probe/u_tone/S_sample_acc [11:10]),
    .b(2'b10),
    .fci(\u_audio_probe/u_tone/add0_syn_97 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [11:10]),
    .fco(\u_audio_probe/u_tone/add0_syn_99 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_145  (
    .a(\u_audio_probe/u_tone/S_sample_acc [13:12]),
    .b(2'b11),
    .fci(\u_audio_probe/u_tone/add0_syn_99 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [13:12]),
    .fco(\u_audio_probe/u_tone/add0_syn_101 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_148  (
    .a(\u_audio_probe/u_tone/S_sample_acc [15:14]),
    .b(2'b10),
    .fci(\u_audio_probe/u_tone/add0_syn_101 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [15:14]),
    .fco(\u_audio_probe/u_tone/add0_syn_103 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_151  (
    .a(\u_audio_probe/u_tone/S_sample_acc [17:16]),
    .b(2'b00),
    .fci(\u_audio_probe/u_tone/add0_syn_103 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [17:16]),
    .fco(\u_audio_probe/u_tone/add0_syn_105 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_154  (
    .a(\u_audio_probe/u_tone/S_sample_acc [19:18]),
    .b(2'b00),
    .fci(\u_audio_probe/u_tone/add0_syn_105 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [19:18]),
    .fco(\u_audio_probe/u_tone/add0_syn_107 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_157  (
    .a(\u_audio_probe/u_tone/S_sample_acc [21:20]),
    .b(2'b00),
    .fci(\u_audio_probe/u_tone/add0_syn_107 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [21:20]),
    .fco(\u_audio_probe/u_tone/add0_syn_109 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_160  (
    .a(\u_audio_probe/u_tone/S_sample_acc [23:22]),
    .b(2'b00),
    .fci(\u_audio_probe/u_tone/add0_syn_109 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [23:22]),
    .fco(\u_audio_probe/u_tone/add0_syn_111 ));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/add0_syn_136"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add0_syn_163  (
    .a({open_n11342,\u_audio_probe/u_tone/S_sample_acc [24]}),
    .b({open_n11343,1'b0}),
    .fci(\u_audio_probe/u_tone/add0_syn_111 ),
    .f(\u_audio_probe/u_tone/O_audio_left_data_b2 [25:24]));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y0Z0"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'h000A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/add1_syn_169  (
    .a({\u_audio_probe/u_tone/S_phase_acc [1],1'b0}),
    .b({\u_audio_probe/u_tone/S_phase_acc [2],\u_audio_probe/u_tone/S_phase_acc [0]}),
    .c(2'b00),
    .ce(\u_video_rgb_to_axis_640x480/S_frame_arm_n3 ),
    .clk(\u_adjust_control/clk ),
    .d({\u_audio_probe/u_tone/mux1_syn_54 ,1'b1}),
    .e({\u_audio_probe/u_tone/mux1_syn_66 ,\u_audio_probe/u_tone/mux1_syn_44 }),
    .mi(\u_dynamic_text/second_ones [3:2]),
    .sr(\u_file_mapper/rst_dup_26 ),
    .f({\u_audio_probe/u_tone/S_phase_acc_b1 [1],open_n11379}),
    .fco(\u_audio_probe/u_tone/add1_syn_139 ),
    .fx({\u_audio_probe/u_tone/S_phase_acc_b1 [2],\u_audio_probe/u_tone/S_phase_acc_b1 [0]}),
    .q(\u_dynamic_text/display_second_ones [3:2]));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y0Z1"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add1_syn_170  (
    .a({\u_audio_probe/u_tone/S_phase_acc [5],\u_audio_probe/u_tone/S_phase_acc [3]}),
    .b({\u_audio_probe/u_tone/S_phase_acc [6],\u_audio_probe/u_tone/S_phase_acc [4]}),
    .c(2'b00),
    .d({\u_audio_probe/u_tone/mux1_syn_102 ,\u_audio_probe/u_tone/mux1_syn_78 }),
    .e({\u_audio_probe/u_tone/mux1_syn_114 ,\u_audio_probe/u_tone/mux1_syn_90 }),
    .fci(\u_audio_probe/u_tone/add1_syn_139 ),
    .f({\u_audio_probe/u_tone/S_phase_acc_b1 [5],\u_audio_probe/u_tone/S_phase_acc_b1 [3]}),
    .fco(\u_audio_probe/u_tone/add1_syn_143 ),
    .fx({\u_audio_probe/u_tone/S_phase_acc_b1 [6],\u_audio_probe/u_tone/S_phase_acc_b1 [4]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y1Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add1_syn_171  (
    .a({\u_audio_probe/u_tone/S_phase_acc [9],\u_audio_probe/u_tone/S_phase_acc [7]}),
    .b({\u_audio_probe/u_tone/S_phase_acc [10],\u_audio_probe/u_tone/S_phase_acc [8]}),
    .c(2'b00),
    .d({\u_audio_probe/u_tone/mux1_syn_142 ,\u_audio_probe/u_tone/mux1_syn_126 }),
    .e({\u_audio_probe/u_tone/mux1_syn_156 ,\u_audio_probe/u_tone/mux1_syn_136 }),
    .fci(\u_audio_probe/u_tone/add1_syn_143 ),
    .f({\u_audio_probe/u_tone/S_phase_acc_b1 [9],\u_audio_probe/u_tone/S_phase_acc_b1 [7]}),
    .fco(\u_audio_probe/u_tone/add1_syn_147 ),
    .fx({\u_audio_probe/u_tone/S_phase_acc_b1 [10],\u_audio_probe/u_tone/S_phase_acc_b1 [8]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y1Z1"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add1_syn_172  (
    .a({\u_audio_probe/u_tone/S_phase_acc [13],\u_audio_probe/u_tone/S_phase_acc [11]}),
    .b({\u_audio_probe/u_tone/S_phase_acc [14],\u_audio_probe/u_tone/S_phase_acc [12]}),
    .c(2'b00),
    .d({\u_audio_probe/u_tone/mux1_syn_192 ,\u_audio_probe/u_tone/mux1_syn_168 }),
    .e({\u_audio_probe/u_tone/W_note_inc[10]_syn_2 ,\u_audio_probe/u_tone/mux1_syn_180 }),
    .fci(\u_audio_probe/u_tone/add1_syn_147 ),
    .f({\u_audio_probe/u_tone/S_phase_acc_b1 [13],\u_audio_probe/u_tone/S_phase_acc_b1 [11]}),
    .fco(\u_audio_probe/u_tone/add1_syn_151 ),
    .fx({\u_audio_probe/u_tone/S_phase_acc_b1 [14],\u_audio_probe/u_tone/S_phase_acc_b1 [12]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y2Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add1_syn_173  (
    .a({\u_audio_probe/u_tone/S_phase_acc [17],\u_audio_probe/u_tone/S_phase_acc [15]}),
    .b({\u_audio_probe/u_tone/S_phase_acc [18],\u_audio_probe/u_tone/S_phase_acc [16]}),
    .c(2'b00),
    .d({\u_audio_probe/u_tone/mux1_syn_222 ,\u_audio_probe/u_tone/mux1_syn_202 }),
    .e({\u_audio_probe/u_tone/mux1_syn_234 ,\u_audio_probe/u_tone/mux1_syn_112 }),
    .fci(\u_audio_probe/u_tone/add1_syn_151 ),
    .f({\u_audio_probe/u_tone/S_phase_acc_b1 [17],\u_audio_probe/u_tone/S_phase_acc_b1 [15]}),
    .fco(\u_audio_probe/u_tone/add1_syn_155 ),
    .fx({\u_audio_probe/u_tone/S_phase_acc_b1 [18],\u_audio_probe/u_tone/S_phase_acc_b1 [16]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y2Z1"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add1_syn_174  (
    .a({\u_audio_probe/u_tone/S_phase_acc [21],\u_audio_probe/u_tone/S_phase_acc [19]}),
    .b({\u_audio_probe/u_tone/S_phase_acc [22],\u_audio_probe/u_tone/S_phase_acc [20]}),
    .c(2'b00),
    .d({\u_audio_probe/u_tone/mux1_syn_266 ,\u_audio_probe/u_tone/mux1_syn_244 }),
    .e({\u_audio_probe/u_tone/mux1_syn_278 ,\u_audio_probe/u_tone/mux1_syn_256 }),
    .fci(\u_audio_probe/u_tone/add1_syn_155 ),
    .f({\u_audio_probe/u_tone/S_phase_acc_b1 [21],\u_audio_probe/u_tone/S_phase_acc_b1 [19]}),
    .fco(\u_audio_probe/u_tone/add1_syn_159 ),
    .fx({\u_audio_probe/u_tone/S_phase_acc_b1 [22],\u_audio_probe/u_tone/S_phase_acc_b1 [20]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y3Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add1_syn_175  (
    .a({\u_audio_probe/u_tone/S_phase_acc [25],\u_audio_probe/u_tone/S_phase_acc [23]}),
    .b({\u_audio_probe/u_tone/S_phase_acc [26],\u_audio_probe/u_tone/S_phase_acc [24]}),
    .c(2'b00),
    .d({\u_audio_probe/u_tone/S_note_idx [2],\u_audio_probe/u_tone/mux1_syn_290 }),
    .e({1'b0,\u_audio_probe/u_tone/S_note_idx[2]_syn_2 }),
    .fci(\u_audio_probe/u_tone/add1_syn_159 ),
    .f({\u_audio_probe/u_tone/S_phase_acc_b1 [25],\u_audio_probe/u_tone/S_phase_acc_b1 [23]}),
    .fco(\u_audio_probe/u_tone/add1_syn_163 ),
    .fx({\u_audio_probe/u_tone/S_phase_acc_b1 [26],\u_audio_probe/u_tone/S_phase_acc_b1 [24]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y3Z1"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add1_syn_176  (
    .a({\u_audio_probe/u_tone/S_phase_acc [29],\u_audio_probe/u_tone/S_phase_acc [27]}),
    .b({\u_audio_probe/u_tone/S_phase_acc [30],\u_audio_probe/u_tone/S_phase_acc [28]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_audio_probe/u_tone/add1_syn_163 ),
    .f({\u_audio_probe/u_tone/S_phase_acc_b1 [29],\u_audio_probe/u_tone/S_phase_acc_b1 [27]}),
    .fco(\u_audio_probe/u_tone/add1_syn_167 ),
    .fx({\u_audio_probe/u_tone/S_phase_acc_b1 [30],\u_audio_probe/u_tone/S_phase_acc_b1 [28]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add1_syn_169"),
    //.R_POSITION("X0Y4Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add1_syn_177  (
    .a({open_n11506,\u_audio_probe/u_tone/S_phase_acc [31]}),
    .c(2'b00),
    .d({open_n11511,1'b0}),
    .fci(\u_audio_probe/u_tone/add1_syn_167 ),
    .f({open_n11528,\u_audio_probe/u_tone/S_phase_acc_b1 [31]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y0Z0"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .DFFMODE("FF"),
    .INIT_LUTF0(16'h000A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("MI"),
    .REG1_REGSET("RESET"),
    .REG1_SD("MI"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_audio_probe/u_tone/add3_syn_194  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [1],1'b0}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [2],\u_audio_probe/u_tone/S_note_sample_cnt [0]}),
    .c(2'b00),
    .ce(\u_audio_probe/u_tone/O_audio_left_data_b_n ),
    .clk(\u_adjust_control/clk ),
    .d(2'b01),
    .e(2'b01),
    .mi(\u_audio_probe/u_tone/S_phase_acc_b1 [29:28]),
    .sr(\u_file_mapper/rst_dup_24 ),
    .f({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [1],open_n11546}),
    .fco(\u_audio_probe/u_tone/add3_syn_164 ),
    .fx({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [2],open_n11547}),
    .q(\u_audio_probe/u_tone/S_phase_acc [29:28]));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y0Z1"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add3_syn_195  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [5],\u_audio_probe/u_tone/S_note_sample_cnt [3]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [6],\u_audio_probe/u_tone/S_note_sample_cnt [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_audio_probe/u_tone/add3_syn_164 ),
    .f({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [5],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [3]}),
    .fco(\u_audio_probe/u_tone/add3_syn_168 ),
    .fx({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [6],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [4]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y1Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add3_syn_196  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [9],\u_audio_probe/u_tone/S_note_sample_cnt [7]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [10],\u_audio_probe/u_tone/S_note_sample_cnt [8]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_audio_probe/u_tone/add3_syn_168 ),
    .f({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [9],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [7]}),
    .fco(\u_audio_probe/u_tone/add3_syn_172 ),
    .fx({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [10],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [8]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y1Z1"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add3_syn_197  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [13],\u_audio_probe/u_tone/S_note_sample_cnt [11]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [14],\u_audio_probe/u_tone/S_note_sample_cnt [12]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_audio_probe/u_tone/add3_syn_172 ),
    .f({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [13],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [11]}),
    .fco(\u_audio_probe/u_tone/add3_syn_176 ),
    .fx({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [14],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [12]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y2Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add3_syn_198  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [17],\u_audio_probe/u_tone/S_note_sample_cnt [15]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [18],\u_audio_probe/u_tone/S_note_sample_cnt [16]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_audio_probe/u_tone/add3_syn_176 ),
    .f({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [17],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [15]}),
    .fco(\u_audio_probe/u_tone/add3_syn_180 ),
    .fx({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [18],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [16]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y2Z1"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add3_syn_199  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [21],\u_audio_probe/u_tone/S_note_sample_cnt [19]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [22],\u_audio_probe/u_tone/S_note_sample_cnt [20]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_audio_probe/u_tone/add3_syn_180 ),
    .f({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [21],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [19]}),
    .fco(\u_audio_probe/u_tone/add3_syn_184 ),
    .fx({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [22],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [20]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y3Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add3_syn_200  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [25],\u_audio_probe/u_tone/S_note_sample_cnt [23]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [26],\u_audio_probe/u_tone/S_note_sample_cnt [24]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_audio_probe/u_tone/add3_syn_184 ),
    .f({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [25],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [23]}),
    .fco(\u_audio_probe/u_tone/add3_syn_188 ),
    .fx({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [26],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [24]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y3Z1"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add3_syn_201  (
    .a({\u_audio_probe/u_tone/S_note_sample_cnt [29],\u_audio_probe/u_tone/S_note_sample_cnt [27]}),
    .b({\u_audio_probe/u_tone/S_note_sample_cnt [30],\u_audio_probe/u_tone/S_note_sample_cnt [28]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_audio_probe/u_tone/add3_syn_188 ),
    .f({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [29],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [27]}),
    .fco(\u_audio_probe/u_tone/add3_syn_192 ),
    .fx({\u_audio_probe/u_tone/S_note_sample_cnt_b2 [30],\u_audio_probe/u_tone/S_note_sample_cnt_b2 [28]}));
EG_PHY_LSLICE #(
    //.MACRO("u_audio_probe/u_tone/add3_syn_194"),
    //.R_POSITION("X0Y4Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'hA55A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/add3_syn_202  (
    .a({open_n11674,\u_audio_probe/u_tone/S_note_sample_cnt [31]}),
    .c(2'b00),
    .d({open_n11679,1'b0}),
    .fci(\u_audio_probe/u_tone/add3_syn_192 ),
    .f({open_n11696,\u_audio_probe/u_tone/S_note_sample_cnt_b2 [31]}));
EG_PHY_MSLICE #(
    //.MACRO("u_audio_probe/u_tone/sub0_syn_126"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_audio_probe/u_tone/sub0_syn_126  (
    .a({al_172[6],1'b0}),
    .b({\u_audio_probe/u_tone/O_audio_left_data_b_n ,open_n11702}),
    .fco(\u_audio_probe/u_tone/sub0_syn_103 ));
endmodule
