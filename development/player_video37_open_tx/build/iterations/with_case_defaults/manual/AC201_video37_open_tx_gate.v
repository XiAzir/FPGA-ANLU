// Verilog netlist created by Tang Dynasty v6.2.178840
// Tue Oct 27 14:35:22 2026

`timescale 1ns / 1ps
module top  // ../user_source/hdl_source/top.v(1)
  (
  clk,
  rst_n,
  HDMI_CLK_P,
  HDMI_D0_P,
  HDMI_D1_P,
  HDMI_D2_P,
  led,
  seg7_dio,
  seg7_rclk,
  seg7_sclk
  );

  input clk;  // ../user_source/hdl_source/top.v(2)
  input rst_n;  // ../user_source/hdl_source/top.v(3)
  output HDMI_CLK_P;  // ../user_source/hdl_source/top.v(8)
  output HDMI_D0_P;  // ../user_source/hdl_source/top.v(9)
  output HDMI_D1_P;  // ../user_source/hdl_source/top.v(10)
  output HDMI_D2_P;  // ../user_source/hdl_source/top.v(11)
  output [3:0] led;  // ../user_source/hdl_source/top.v(4)
  output seg7_dio;  // ../user_source/hdl_source/top.v(5)
  output seg7_rclk;  // ../user_source/hdl_source/top.v(7)
  output seg7_sclk;  // ../user_source/hdl_source/top.v(6)

  wire [3:0] frame_count;  // ../user_source/hdl_source/top.v(64)
  wire [19:0] startup_count;  // ../user_source/hdl_source/top.v(20)
  wire [19:0] startup_count_b;
  wire [19:0] startup_count_b4;
  wire [4:0] \u_build_id/bit_count ;  // ../user_source/hdl_source/status_hex595.v(35)
  wire [2:0] \u_build_id/digit_index ;  // ../user_source/hdl_source/status_hex595.v(36)
  wire [31:0] \u_build_id/frame_value ;  // ../user_source/hdl_source/status_hex595.v(33)
  wire [31:0] \u_build_id/half_count ;  // ../user_source/hdl_source/status_hex595.v(32)
  wire [31:0] \u_build_id/hex_value ;  // ../user_source/hdl_source/status_hex595.v(12)
  wire [15:0] \u_build_id/shift_word ;  // ../user_source/hdl_source/status_hex595.v(34)
  wire [31:0] \u_build_id/slot_count ;  // ../user_source/hdl_source/status_hex595.v(31)
  wire [31:0] \u_build_id/slot_count_b5 ;
  wire [5:0] \u_build_id/state_reg_syn_1 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire [1:0] \u_hdmi_phy/u0_lane_lvds_8_1/S_oddr_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(24)
  wire [9:0] \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b ;
  wire [1:0] \u_hdmi_phy/u1_lane_lvds_8_1/S_oddr_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(24)
  wire [9:0] \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b ;
  wire [1:0] \u_hdmi_phy/u2_lane_lvds_8_1/S_oddr_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(24)
  wire [9:0] \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b ;
  wire [1:0] \u_hdmi_phy/u3_lane_lvds_8_1/S_oddr_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(24)
  wire [9:0] \u_hdmi_phy/u3_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b ;
  wire [15:0] \u_video_tx/cx ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(18)
  wire [15:0] \u_video_tx/cy ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(19)
  wire [63:0] \u_video_tx/packet_ecc/bch0 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(27)
  wire [63:0] \u_video_tx/packet_ecc/bch1 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(27)
  wire [63:0] \u_video_tx/packet_ecc/bch2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(27)
  wire [63:0] \u_video_tx/packet_ecc/bch3 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(27)
  wire [4:0] \u_video_tx/packet_ecc/counter ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(10)
  wire [7:0] \u_video_tx/packet_ecc/mux25_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(70)
  wire [7:0] \u_video_tx/packet_ecc/parity0_next2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire [7:0] \u_video_tx/packet_ecc/parity1_next2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire [7:0] \u_video_tx/packet_ecc/parity2_next2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire [7:0] \u_video_tx/packet_ecc/parity3_next2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire [7:0] \u_video_tx/packet_ecc/parity4 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(24)
  wire [7:0] \u_video_tx/packet_ecc/parity4_next ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(31)
  wire [4:0] \u_video_tx/tmds_blue/acc ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(13)
  wire [4:0] \u_video_tx/tmds_blue/acc_add ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire  \u_video_tx/tmds_blue/mux5_syn_16 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(89)
  wire [9:0] \u_video_tx/tmds_blue/tmds ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(11)
  wire [4:0] \u_video_tx/tmds_green/acc ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(13)
  wire [4:0] \u_video_tx/tmds_green/acc_add ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire [9:0] \u_video_tx/tmds_green/tmds ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(11)
  wire [4:0] \u_video_tx/tmds_red/acc ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(13)
  wire [4:0] \u_video_tx/tmds_red/acc_add ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire [9:0] \u_video_tx/tmds_red/tmds ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(11)
  wire [9:0] \u_video_tx/x_count_b1 ;
  wire [9:0] \u_video_tx/x_count_b3 ;
  wire [9:0] \u_video_tx/y_count_b3 ;
  wire [9:0] \u_video_tx/y_count_b4 ;
  wire add0_syn_104;  // ../user_source/hdl_source/top.v(33)
  wire add0_syn_108;  // ../user_source/hdl_source/top.v(33)
  wire add0_syn_112;  // ../user_source/hdl_source/top.v(33)
  wire add0_syn_116;  // ../user_source/hdl_source/top.v(33)
  wire add0_syn_120;  // ../user_source/hdl_source/top.v(33)
  wire frame_seen_reg_syn_3;  // ../user_source/hdl_source/top.v(66)
  wire lt0_syn_7;  // ../user_source/hdl_source/top.v(39)
  wire lt0_syn_11;  // ../user_source/hdl_source/top.v(39)
  wire lt0_syn_15;  // ../user_source/hdl_source/top.v(39)
  wire lt2_syn_7;  // ../user_source/hdl_source/top.v(41)
  wire lt2_syn_11;  // ../user_source/hdl_source/top.v(41)
  wire lt2_syn_15;  // ../user_source/hdl_source/top.v(41)
  wire lt4_syn_7;  // ../user_source/hdl_source/top.v(43)
  wire lt4_syn_11;  // ../user_source/hdl_source/top.v(43)
  wire lt4_syn_15;  // ../user_source/hdl_source/top.v(43)
  wire lt6_syn_7;  // ../user_source/hdl_source/top.v(45)
  wire lt6_syn_11;  // ../user_source/hdl_source/top.v(45)
  wire lt6_syn_15;  // ../user_source/hdl_source/top.v(45)
  wire startup_done_reg_syn_3;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_5;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_7;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_9;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_11;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_13;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_15;  // ../user_source/hdl_source/top.v(23)
  wire clk_dup_1;  // ../user_source/hdl_source/top.v(2)
  wire frame_seen;  // ../user_source/hdl_source/top.v(65)
  wire \led[3]_dup_1 ;  // ../user_source/hdl_source/top.v(4)
  wire \led[2]_dup_1 ;  // ../user_source/hdl_source/top.v(4)
  wire \led[1]_dup_1 ;  // ../user_source/hdl_source/top.v(4)
  wire \led[0]_dup_1 ;  // ../user_source/hdl_source/top.v(4)
  wire \rgb_b1[23]_syn_2 ;
  wire pll_lock;  // ../user_source/hdl_source/top.v(13)
  wire rgb_b2_n;
  wire rgb_b4_n;
  wire rgb_b5_n;
  wire rgb_b_n;
  wire rst_n_dup_1;  // ../user_source/hdl_source/top.v(3)
  wire serial_clk_raw;  // ../user_source/hdl_source/top.v(13)
  wire startup_done;  // ../user_source/hdl_source/top.v(21)
  wire \u_build_id/add0_syn_86 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_build_id/add0_syn_90 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_build_id/add0_syn_94 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_build_id/add0_syn_98 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_build_id/add1_syn_24 ;  // ../user_source/hdl_source/status_hex595.v(126)
  wire \u_build_id/lt0_syn_6 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_10 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_14 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_18 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_22 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_26 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_30 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_34 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/mux2_syn_20 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux4_syn_39 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux4_syn_51 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux4_syn_79 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux4_syn_97 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_117 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_129 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_141 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_153 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_165 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_177 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_189 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_201 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_213 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_225 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_237 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_249 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_261 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_273 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_285 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_297 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_329 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_89 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_123 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_157 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_191 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_225 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_259 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_293 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_327 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_361 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_395 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_429 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_463 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_497 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_531 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_565 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_593 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_627 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_629 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_631 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_635 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_637 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_642 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_646 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_650 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_654 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_656 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_660 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_663 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_666 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux8_syn_187 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/tx_is_blank_reg_syn_3 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_b4_n ;
  wire \u_build_id/clk ;  // ../user_source/hdl_source/status_hex595.v(10)
  wire \u_build_id/rst ;  // ../user_source/hdl_source/status_hex595.v(11)
  wire \u_build_id/tx_is_blank ;  // ../user_source/hdl_source/status_hex595.v(37)
  wire \u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ;  // ../user_source/hdl_source/lane_lvds_10_1.v(8)
  wire \u_hdmi_phy/u0_lane_lvds_8_1/S_load_en ;  // ../user_source/hdl_source/lane_lvds_10_1.v(19)
  wire \u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ;  // ../user_source/hdl_source/lane_lvds_10_1.v(20)
  wire \u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ;  // ../user_source/hdl_source/lane_lvds_10_1.v(21)
  wire \u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_n ;
  wire \u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even ;  // ../user_source/hdl_source/lane_lvds_10_1.v(16)
  wire \u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_1d ;  // ../user_source/hdl_source/lane_lvds_10_1.v(17)
  wire \u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_2d ;  // ../user_source/hdl_source/lane_lvds_10_1.v(18)
  wire \u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_n ;
  wire \u_video_pll/clk0_buf ;  // ../user_source/hdl_source/IP/video_pll.v(13)
  wire \u_video_tx/add0_syn_54 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  wire \u_video_tx/add0_syn_58 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  wire \u_video_tx/add1_syn_54 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  wire \u_video_tx/add1_syn_58 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  wire \u_video_tx/lt0_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  wire \u_video_tx/lt0_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  wire \u_video_tx/lt0_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  wire \u_video_tx/lt1_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  wire \u_video_tx/lt1_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  wire \u_video_tx/lt1_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  wire \u_video_tx/lt12_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt12_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt12_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt12_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt15_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_23 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt16_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_23 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt17_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  wire \u_video_tx/lt17_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  wire \u_video_tx/lt17_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  wire \u_video_tx/lt2_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt2_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt2_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt2_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt2_syn_22 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt3_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt3_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt3_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt3_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt6_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_22 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt7_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt7_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt7_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt7_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt7_syn_23 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt8_syn_5 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_9 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_13 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_17 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_21 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/cx[0]_syn_2 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(18)
  wire \u_video_tx/cy[0]_syn_2 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(19)
  wire \u_video_tx/active ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(20)
  wire \u_video_tx/data_island_guard_n4 ;
  wire \u_video_tx/data_island_guard_n5 ;
  wire \u_video_tx/data_island_guard_n6 ;
  wire \u_video_tx/data_island_preamble_n1 ;
  wire \u_video_tx/data_island_preamble_n2 ;
  wire \u_video_tx/hsync_pulse_n1 ;
  wire \u_video_tx/hsync_pulse_n2 ;
  wire \u_video_tx/mode_b1_n5 ;
  wire \u_video_tx/mode_b1_n6 ;
  wire \u_video_tx/video_preamble_n2 ;
  wire \u_video_tx/video_preamble_n3 ;
  wire \u_video_tx/vsync_pulse_n1 ;
  wire \u_video_tx/vsync_pulse_n2 ;
  wire \u_video_tx/x_count_b1_n ;
  wire \u_video_tx/packet_ecc/mux1_syn_52 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(39)
  wire \u_video_tx/packet_ecc/mux2_syn_52 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(40)
  wire \u_video_tx/packet_ecc/mux25_syn_34 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(70)
  wire \u_video_tx/packet_ecc/mux26_syn_62 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux26_syn_110 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux26_syn_148 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux26_syn_182 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux27_syn_62 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_110 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_148 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_182 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux3_syn_26 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(41)
  wire \u_video_tx/packet_ecc/mux6_syn_52 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(44)
  wire \u_video_tx/packet_ecc/mux9_syn_42 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(51)
  wire \u_video_tx/packet_ecc/mux9_syn_57 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(51)
  wire \u_video_tx/packet_ecc/parity0_next2[1]_syn_3 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity1_next2[1]_syn_3 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity2_next2[1]_syn_3 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity3_next2[1]_syn_3 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity0_b1_n ;
  wire \u_video_tx/packet_ecc/parity4_b3_n ;
  wire \u_video_tx/tmds_blue/add1_syn_24 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_blue/add1_syn_26 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_blue/mux6_syn_158 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_blue/mux6_syn_196 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_blue/mux6_syn_200 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_blue/mux9_syn_23 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_35 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_47 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_55 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_59 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_67 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_79 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_87 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_99 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_111 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_123 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_137 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_140 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_142 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_144 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_148 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_150 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_152 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_156 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_158 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_160 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_162 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_164 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_166 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_168 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_170 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_172 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_176 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_178 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_181 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_183 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_187 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_190 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_193 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_196 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_199 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_205 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_207 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/mux9_syn_210 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_blue/acc_add[3]_syn_2 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire \u_video_tx/tmds_blue/video_data[7]_syn_2 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(7)
  wire \u_video_tx/tmds_blue/data_guard_band_b1_n ;
  wire \u_video_tx/tmds_blue/data_guard_band_b1_n1 ;
  wire \u_video_tx/tmds_blue/data_guard_band_b_n ;
  wire \u_video_tx/tmds_green/add1_syn_24 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_green/add1_syn_26 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_green/mux6_syn_52 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_green/mux6_syn_74 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_green/mux6_syn_196 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_green/mux7_syn_23 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_31 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_43 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_49 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_57 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_67 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_75 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_81 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_89 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_99 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_117 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_121 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_124 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_126 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_129 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_131 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_134 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_136 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_139 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_141 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_144 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_146 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_148 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_150 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_152 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_154 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_156 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_158 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_160 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_162 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_164 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_166 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_168 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_171 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_173 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_176 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_178 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_181 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_183 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_187 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_190 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_192 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_195 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_198 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_200 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_204 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_206 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_209 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/mux7_syn_214 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_green/acc_add[3]_syn_2 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire \u_video_tx/tmds_red/add1_syn_24 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_red/add1_syn_26 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_red/mux6_syn_52 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_red/mux6_syn_138 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_red/mux6_syn_178 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_red/mux6_syn_196 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(99)
  wire \u_video_tx/tmds_red/mux7_syn_23 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_31 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_43 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_49 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_57 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_67 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_75 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_81 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_89 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_99 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_117 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_120 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_122 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_125 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_127 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_129 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_131 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_134 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_136 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_138 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_140 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_142 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_144 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_148 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_151 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_153 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_156 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_158 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_161 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_163 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_166 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_170 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_173 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_175 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_181 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_184 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/mux7_syn_187 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  wire \u_video_tx/tmds_red/acc_add[3]_syn_2 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire \frame_count_reg[0]_syn_2 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[0]_syn_4 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[0]_syn_7 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[1]_syn_2 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[1]_syn_4 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[2]_syn_2 ;  // ../user_source/hdl_source/top.v(66)
  wire \u_build_id/bit_count_reg[0]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[1]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[2]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[2]_syn_4 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[3]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[3]_syn_4 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[3]_syn_6 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[3]_syn_9 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[3]_syn_11 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_reg[4]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/digit_index_reg[0]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/digit_index_reg[1]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/digit_index_reg[2]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/frame_value_reg[0]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[0]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[1]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[2]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[3]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[4]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[4]_syn_4 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[4]_syn_6 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_video_tx/packet_ecc/counter_reg[0]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  wire \u_video_tx/packet_ecc/counter_reg[1]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  wire \u_video_tx/packet_ecc/counter_reg[2]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  wire \u_video_tx/packet_ecc/counter_reg[3]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  wire \u_video_tx/packet_ecc/counter_reg[4]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)

  EG_PHY_PAD #(
    //.LOCATION("B10"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("MED"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVDS33_E"),
    .MODE("OUT"),
    .ODDRMODE("DDRX1"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    HDMI_CLK_P_syn_2 (
    .do({open_n1,open_n2,\u_hdmi_phy/u3_lane_lvds_8_1/S_oddr_data [0],\u_hdmi_phy/u3_lane_lvds_8_1/S_oddr_data [1]}),
    .osclk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .rst(\u_build_id/rst ),
    .opad(HDMI_CLK_P));  // ../user_source/hdl_source/top.v(8)
  EG_PHY_PAD #(
    //.LOCATION("C9"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("MED"),
    .DRIVE("8"),
    .IOTYPE("LVDS33_E"),
    .MODE("OUT"),
    .TSMUX("0"))
    HDMI_CLK_P_syn_3 ();  // ../user_source/hdl_source/top.v(8)
  EG_PHY_PAD #(
    //.LOCATION("D11"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("MED"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVDS33_E"),
    .MODE("OUT"),
    .ODDRMODE("DDRX1"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    HDMI_D0_P_syn_2 (
    .do({open_n34,open_n35,\u_hdmi_phy/u0_lane_lvds_8_1/S_oddr_data [0],\u_hdmi_phy/u0_lane_lvds_8_1/S_oddr_data [1]}),
    .osclk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .rst(\u_build_id/rst ),
    .opad(HDMI_D0_P));  // ../user_source/hdl_source/top.v(9)
  EG_PHY_PAD #(
    //.LOCATION("D12"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("MED"),
    .DRIVE("8"),
    .IOTYPE("LVDS33_E"),
    .MODE("OUT"),
    .TSMUX("0"))
    HDMI_D0_P_syn_3 ();  // ../user_source/hdl_source/top.v(9)
  EG_PHY_PAD #(
    //.LOCATION("C11"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("MED"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVDS33_E"),
    .MODE("OUT"),
    .ODDRMODE("DDRX1"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    HDMI_D1_P_syn_2 (
    .do({open_n67,open_n68,\u_hdmi_phy/u1_lane_lvds_8_1/S_oddr_data [0],\u_hdmi_phy/u1_lane_lvds_8_1/S_oddr_data [1]}),
    .osclk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .rst(\u_build_id/rst ),
    .opad(HDMI_D1_P));  // ../user_source/hdl_source/top.v(10)
  EG_PHY_PAD #(
    //.LOCATION("A11"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("MED"),
    .DRIVE("8"),
    .IOTYPE("LVDS33_E"),
    .MODE("OUT"),
    .TSMUX("0"))
    HDMI_D1_P_syn_3 ();  // ../user_source/hdl_source/top.v(10)
  EG_PHY_PAD #(
    //.LOCATION("F10"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("MED"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVDS33_E"),
    .MODE("OUT"),
    .ODDRMODE("DDRX1"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    HDMI_D2_P_syn_2 (
    .do({open_n100,open_n101,\u_hdmi_phy/u2_lane_lvds_8_1/S_oddr_data [0],\u_hdmi_phy/u2_lane_lvds_8_1/S_oddr_data [1]}),
    .osclk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .rst(\u_build_id/rst ),
    .opad(HDMI_D2_P));  // ../user_source/hdl_source/top.v(11)
  EG_PHY_PAD #(
    //.LOCATION("H11"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("MED"),
    .DRIVE("8"),
    .IOTYPE("LVDS33_E"),
    .MODE("OUT"),
    .TSMUX("0"))
    HDMI_D2_P_syn_3 ();  // ../user_source/hdl_source/top.v(11)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_122"),
    //.R_POSITION("X0Y0Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'h000A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    add0_syn_122 (
    .a({startup_count[1],1'b0}),
    .b({startup_count[2],startup_count[0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({startup_count_b4[1],open_n149}),
    .fco(add0_syn_104),
    .fx({startup_count_b4[2],open_n150}));  // ../user_source/hdl_source/top.v(33)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_122"),
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
    add0_syn_123 (
    .a({startup_count[5],startup_count[3]}),
    .b({startup_count[6],startup_count[4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(add0_syn_104),
    .f({startup_count_b4[5],startup_count_b4[3]}),
    .fco(add0_syn_108),
    .fx({startup_count_b4[6],startup_count_b4[4]}));  // ../user_source/hdl_source/top.v(33)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_122"),
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
    add0_syn_124 (
    .a({startup_count[9],startup_count[7]}),
    .b({startup_count[10],startup_count[8]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(add0_syn_108),
    .f({startup_count_b4[9],startup_count_b4[7]}),
    .fco(add0_syn_112),
    .fx({startup_count_b4[10],startup_count_b4[8]}));  // ../user_source/hdl_source/top.v(33)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_122"),
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
    add0_syn_125 (
    .a({startup_count[13],startup_count[11]}),
    .b({startup_count[14],startup_count[12]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(add0_syn_112),
    .f({startup_count_b4[13],startup_count_b4[11]}),
    .fco(add0_syn_116),
    .fx({startup_count_b4[14],startup_count_b4[12]}));  // ../user_source/hdl_source/top.v(33)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_122"),
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
    add0_syn_126 (
    .a({startup_count[17],startup_count[15]}),
    .b({startup_count[18],startup_count[16]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(add0_syn_116),
    .f({startup_count_b4[17],startup_count_b4[15]}),
    .fco(add0_syn_120),
    .fx({startup_count_b4[18],startup_count_b4[16]}));  // ../user_source/hdl_source/top.v(33)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_122"),
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
    add0_syn_127 (
    .a({open_n225,startup_count[19]}),
    .c(2'b00),
    .d({open_n230,1'b0}),
    .fci(add0_syn_120),
    .f({open_n247,startup_count_b4[19]}));  // ../user_source/hdl_source/top.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("K14"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .TSMUX("1"))
    clk_syn_2 (
    .ipad(clk),
    .di(clk_dup_1));  // ../user_source/hdl_source/top.v(2)
  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \frame_count_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\frame_count_reg[0]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(frame_count[0]));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \frame_count_reg[0]_syn_3  (
    .a(\u_video_tx/cx [0]),
    .b(\u_video_tx/cx [1]),
    .c(\u_video_tx/cx [2]),
    .d(\u_video_tx/cx [9]),
    .o(\frame_count_reg[0]_syn_4 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*A)"),
    .INIT(16'h0008))
    \frame_count_reg[0]_syn_5  (
    .a(\u_video_tx/tmds_red/mux7_syn_117 ),
    .b(\frame_count_reg[0]_syn_4 ),
    .c(\u_video_tx/cx [3]),
    .d(\u_video_tx/cx [4]),
    .o(\u_video_tx/x_count_b1_n ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \frame_count_reg[0]_syn_6  (
    .a(\u_video_tx/mode_b1_n5 ),
    .b(\u_video_tx/x_count_b1_n ),
    .o(\frame_count_reg[0]_syn_7 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \frame_count_reg[0]_syn_8  (
    .a(\frame_count_reg[0]_syn_7 ),
    .b(frame_count[0]),
    .o(\frame_count_reg[0]_syn_2 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \frame_count_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\frame_count_reg[1]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(frame_count[1]));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \frame_count_reg[1]_syn_3  (
    .a(\frame_count_reg[0]_syn_7 ),
    .b(frame_count[0]),
    .o(\frame_count_reg[1]_syn_4 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \frame_count_reg[1]_syn_5  (
    .a(\frame_count_reg[1]_syn_4 ),
    .b(frame_count[1]),
    .o(\frame_count_reg[1]_syn_2 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \frame_count_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\frame_count_reg[2]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(frame_count[2]));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT3 #(
    .EQN("(C@(B*A))"),
    .INIT(8'h78))
    \frame_count_reg[2]_syn_3  (
    .a(\frame_count_reg[1]_syn_4 ),
    .b(frame_count[1]),
    .c(frame_count[2]),
    .o(\frame_count_reg[2]_syn_2 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    frame_seen_reg (
    .clk(\u_build_id/clk ),
    .d(frame_seen_reg_syn_3),
    .sr(\u_build_id/rst ),
    .q(frame_seen));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    frame_seen_reg_syn_4 (
    .a(\frame_count_reg[0]_syn_7 ),
    .b(frame_seen),
    .o(frame_seen_reg_syn_3));  // ../user_source/hdl_source/top.v(66)
  EG_PHY_PAD #(
    //.LOCATION("M12"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .TSMUX("0"))
    \led[0]_syn_2  (
    .do({open_n322,open_n323,open_n324,\led[0]_dup_1 }),
    .opad(led[0]));  // ../user_source/hdl_source/top.v(4)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \led[0]_syn_3  (
    .a(pll_lock),
    .o(\led[0]_dup_1 ));  // ../user_source/hdl_source/top.v(4)
  EG_PHY_PAD #(
    //.LOCATION("R16"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .TSMUX("0"))
    \led[1]_syn_2  (
    .do({open_n339,open_n340,open_n341,\led[1]_dup_1 }),
    .opad(led[1]));  // ../user_source/hdl_source/top.v(4)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \led[1]_syn_3  (
    .a(frame_seen),
    .o(\led[1]_dup_1 ));  // ../user_source/hdl_source/top.v(4)
  EG_PHY_PAD #(
    //.LOCATION("R15"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .TSMUX("0"))
    \led[2]_syn_2  (
    .do({open_n356,open_n357,open_n358,\led[2]_dup_1 }),
    .opad(led[2]));  // ../user_source/hdl_source/top.v(4)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \led[2]_syn_3  (
    .a(frame_count[2]),
    .o(\led[2]_dup_1 ));  // ../user_source/hdl_source/top.v(4)
  EG_PHY_PAD #(
    //.LOCATION("T15"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .TSMUX("0"))
    \led[3]_syn_2  (
    .do({open_n373,open_n374,open_n375,\led[3]_dup_1 }),
    .opad(led[3]));  // ../user_source/hdl_source/top.v(4)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \led[3]_syn_3  (
    .a(startup_done),
    .o(\led[3]_dup_1 ));  // ../user_source/hdl_source/top.v(4)
  EG_PHY_MSLICE #(
    //.MACRO("lt0_syn_28"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_28 (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n389}),
    .fco(lt0_syn_7));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt0_syn_28"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_31 (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b10),
    .fci(lt0_syn_7),
    .fco(lt0_syn_11));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt0_syn_28"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_34 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b00),
    .fci(lt0_syn_11),
    .fco(lt0_syn_15));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt0_syn_28"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_37 (
    .a({1'b0,\u_video_tx/cx [9]}),
    .b(2'b10),
    .fci(lt0_syn_15),
    .f({rgb_b_n,open_n481}));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_28"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_28 (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n487}),
    .fco(lt2_syn_7));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_28"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_31 (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b11),
    .fci(lt2_syn_7),
    .fco(lt2_syn_11));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_28"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_34 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b01),
    .fci(lt2_syn_11),
    .fco(lt2_syn_15));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_28"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_37 (
    .a({1'b0,\u_video_tx/cx [9]}),
    .b(2'b10),
    .fci(lt2_syn_15),
    .f({rgb_b2_n,open_n579}));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_28"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_28 (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n585}),
    .fco(lt4_syn_7));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_28"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_31 (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b00),
    .fci(lt4_syn_7),
    .fco(lt4_syn_11));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_28"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_34 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b11),
    .fci(lt4_syn_11),
    .fco(lt4_syn_15));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_28"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_37 (
    .a({1'b0,\u_video_tx/cx [9]}),
    .b(2'b10),
    .fci(lt4_syn_15),
    .f({rgb_b4_n,open_n677}));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_28"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_28 (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n683}),
    .fco(lt6_syn_7));  // ../user_source/hdl_source/top.v(45)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_28"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_31 (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b01),
    .fci(lt6_syn_7),
    .fco(lt6_syn_11));  // ../user_source/hdl_source/top.v(45)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_28"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_34 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b00),
    .fci(lt6_syn_11),
    .fco(lt6_syn_15));  // ../user_source/hdl_source/top.v(45)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_28"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_37 (
    .a({1'b0,\u_video_tx/cx [9]}),
    .b(2'b11),
    .fci(lt6_syn_15),
    .f({rgb_b5_n,open_n775}));  // ../user_source/hdl_source/top.v(45)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("H14"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS33"),
    .MODE("IN"),
    .TSMUX("1"))
    rst_n_syn_2 (
    .ipad(rst_n),
    .di(rst_n_dup_1));  // ../user_source/hdl_source/top.v(3)
  EG_PHY_PAD #(
    //.LOCATION("R14"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("SET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("CE"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    seg7_dio_syn_4 (
    .ce(\u_build_id/state_reg_syn_1 [1]),
    .do({open_n798,open_n799,open_n800,\u_build_id/shift_word [15]}),
    .osclk(\u_build_id/clk ),
    .rst(\u_build_id/rst ),
    .opad(seg7_dio));  // ../user_source/hdl_source/top.v(5)
  EG_PHY_PAD #(
    //.LOCATION("R12"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    seg7_rclk_syn_3 (
    .do({open_n813,open_n814,open_n815,\u_build_id/state_reg_syn_1 [4]}),
    .osclk(\u_build_id/clk ),
    .rst(\u_build_id/rst ),
    .opad(seg7_rclk));  // ../user_source/hdl_source/top.v(7)
  EG_PHY_PAD #(
    //.LOCATION("T14"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS33"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("CE"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    seg7_sclk_syn_4 (
    .ce(\u_build_id/mux2_syn_20 ),
    .do({open_n827,open_n828,open_n829,\u_build_id/state_reg_syn_1 [2]}),
    .osclk(\u_build_id/clk ),
    .rst(\u_build_id/rst ),
    .opad(seg7_sclk));  // ../user_source/hdl_source/top.v(6)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \startup_count_b[0]_syn_1  (
    .a(startup_count[0]),
    .b(pll_lock),
    .o(startup_count_b[0]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[10]_syn_1  (
    .a(startup_count_b4[10]),
    .b(pll_lock),
    .o(startup_count_b[10]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[11]_syn_1  (
    .a(startup_count_b4[11]),
    .b(pll_lock),
    .o(startup_count_b[11]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[12]_syn_1  (
    .a(startup_count_b4[12]),
    .b(pll_lock),
    .o(startup_count_b[12]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[13]_syn_1  (
    .a(startup_count_b4[13]),
    .b(pll_lock),
    .o(startup_count_b[13]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[14]_syn_1  (
    .a(startup_count_b4[14]),
    .b(pll_lock),
    .o(startup_count_b[14]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[15]_syn_1  (
    .a(startup_count_b4[15]),
    .b(pll_lock),
    .o(startup_count_b[15]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[16]_syn_1  (
    .a(startup_count_b4[16]),
    .b(pll_lock),
    .o(startup_count_b[16]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[17]_syn_1  (
    .a(startup_count_b4[17]),
    .b(pll_lock),
    .o(startup_count_b[17]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[18]_syn_1  (
    .a(startup_count_b4[18]),
    .b(pll_lock),
    .o(startup_count_b[18]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[19]_syn_1  (
    .a(startup_count_b4[19]),
    .b(pll_lock),
    .o(startup_count_b[19]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[1]_syn_1  (
    .a(startup_count_b4[1]),
    .b(pll_lock),
    .o(startup_count_b[1]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[2]_syn_1  (
    .a(startup_count_b4[2]),
    .b(pll_lock),
    .o(startup_count_b[2]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[3]_syn_1  (
    .a(startup_count_b4[3]),
    .b(pll_lock),
    .o(startup_count_b[3]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[4]_syn_1  (
    .a(startup_count_b4[4]),
    .b(pll_lock),
    .o(startup_count_b[4]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[5]_syn_1  (
    .a(startup_count_b4[5]),
    .b(pll_lock),
    .o(startup_count_b[5]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[6]_syn_1  (
    .a(startup_count_b4[6]),
    .b(pll_lock),
    .o(startup_count_b[6]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[7]_syn_1  (
    .a(startup_count_b4[7]),
    .b(pll_lock),
    .o(startup_count_b[7]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[8]_syn_1  (
    .a(startup_count_b4[8]),
    .b(pll_lock),
    .o(startup_count_b[8]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \startup_count_b[9]_syn_1  (
    .a(startup_count_b4[9]),
    .b(pll_lock),
    .o(startup_count_b[9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[0]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[0]),
    .sr(rst_n_dup_1),
    .q(startup_count[0]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[10]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[10]),
    .sr(rst_n_dup_1),
    .q(startup_count[10]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[11]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[11]),
    .sr(rst_n_dup_1),
    .q(startup_count[11]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[12]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[12]),
    .sr(rst_n_dup_1),
    .q(startup_count[12]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[13]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[13]),
    .sr(rst_n_dup_1),
    .q(startup_count[13]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[14]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[14]),
    .sr(rst_n_dup_1),
    .q(startup_count[14]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[15]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[15]),
    .sr(rst_n_dup_1),
    .q(startup_count[15]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[16]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[16]),
    .sr(rst_n_dup_1),
    .q(startup_count[16]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[17]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[17]),
    .sr(rst_n_dup_1),
    .q(startup_count[17]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[18]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[18]),
    .sr(rst_n_dup_1),
    .q(startup_count[18]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[19]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[19]),
    .sr(rst_n_dup_1),
    .q(startup_count[19]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[1]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[1]),
    .sr(rst_n_dup_1),
    .q(startup_count[1]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[2]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[2]),
    .sr(rst_n_dup_1),
    .q(startup_count[2]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[3]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[3]),
    .sr(rst_n_dup_1),
    .q(startup_count[3]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[4]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[4]),
    .sr(rst_n_dup_1),
    .q(startup_count[4]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[5]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[5]),
    .sr(rst_n_dup_1),
    .q(startup_count[5]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[6]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[6]),
    .sr(rst_n_dup_1),
    .q(startup_count[6]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[7]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[7]),
    .sr(rst_n_dup_1),
    .q(startup_count[7]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[8]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[8]),
    .sr(rst_n_dup_1),
    .q(startup_count[8]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \startup_count_reg[9]  (
    .ce(startup_done_reg_syn_5),
    .clk(\u_build_id/clk ),
    .d(startup_count_b[9]),
    .sr(rst_n_dup_1),
    .q(startup_count[9]));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    startup_done_reg (
    .clk(\u_build_id/clk ),
    .d(startup_done_reg_syn_3),
    .sr(rst_n_dup_1),
    .q(startup_done));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT5 #(
    .EQN("(E*~D*~C*~B*A)"),
    .INIT(32'h00020000))
    startup_done_reg_syn_10 (
    .a(startup_done_reg_syn_9),
    .b(startup_count[8]),
    .c(startup_count[10]),
    .d(startup_count[12]),
    .e(startup_count[14]),
    .o(startup_done_reg_syn_11));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    startup_done_reg_syn_12 (
    .a(startup_count[9]),
    .b(startup_count[11]),
    .c(startup_count[13]),
    .d(startup_count[15]),
    .o(startup_done_reg_syn_13));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    startup_done_reg_syn_14 (
    .a(startup_done_reg_syn_13),
    .b(startup_count[16]),
    .c(startup_count[17]),
    .d(startup_count[18]),
    .e(startup_count[19]),
    .o(startup_done_reg_syn_15));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~C*~(B*A)))"),
    .INIT(16'hf800))
    startup_done_reg_syn_16 (
    .a(startup_done_reg_syn_11),
    .b(startup_done_reg_syn_15),
    .c(startup_done),
    .d(pll_lock),
    .o(startup_done_reg_syn_3));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT4 #(
    .EQN("~(D*~(~C*~(B*A)))"),
    .INIT(16'b0000011111111111))
    startup_done_reg_syn_18 (
    .a(startup_done_reg_syn_11),
    .b(startup_done_reg_syn_15),
    .c(startup_done),
    .d(pll_lock),
    .o(startup_done_reg_syn_5));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*A)"),
    .INIT(16'h0080))
    startup_done_reg_syn_6 (
    .a(startup_count[0]),
    .b(startup_count[3]),
    .c(startup_count[5]),
    .d(startup_count[6]),
    .o(startup_done_reg_syn_7));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT5 #(
    .EQN("(~E*D*C*B*A)"),
    .INIT(32'h00008000))
    startup_done_reg_syn_8 (
    .a(startup_done_reg_syn_7),
    .b(startup_count[1]),
    .c(startup_count[2]),
    .d(startup_count[4]),
    .e(startup_count[7]),
    .o(startup_done_reg_syn_9));  // ../user_source/hdl_source/top.v(23)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_100"),
    //.R_POSITION("X0Y0Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'h000A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_build_id/add0_syn_100  (
    .a({\u_build_id/slot_count [1],1'b0}),
    .b({\u_build_id/slot_count [2],\u_build_id/slot_count [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_build_id/slot_count_b5 [1],open_n859}),
    .fco(\u_build_id/add0_syn_86 ),
    .fx({\u_build_id/slot_count_b5 [2],open_n860}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_100"),
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
    \u_build_id/add0_syn_101  (
    .a({\u_build_id/slot_count [5],\u_build_id/slot_count [3]}),
    .b({\u_build_id/slot_count [6],\u_build_id/slot_count [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_build_id/add0_syn_86 ),
    .f({\u_build_id/slot_count_b5 [5],\u_build_id/slot_count_b5 [3]}),
    .fco(\u_build_id/add0_syn_90 ),
    .fx({\u_build_id/slot_count_b5 [6],\u_build_id/slot_count_b5 [4]}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_100"),
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
    \u_build_id/add0_syn_102  (
    .a({\u_build_id/slot_count [9],\u_build_id/slot_count [7]}),
    .b({\u_build_id/slot_count [10],\u_build_id/slot_count [8]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_build_id/add0_syn_90 ),
    .f({\u_build_id/slot_count_b5 [9],\u_build_id/slot_count_b5 [7]}),
    .fco(\u_build_id/add0_syn_94 ),
    .fx({\u_build_id/slot_count_b5 [10],\u_build_id/slot_count_b5 [8]}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_100"),
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
    \u_build_id/add0_syn_103  (
    .a({\u_build_id/slot_count [13],\u_build_id/slot_count [11]}),
    .b({\u_build_id/slot_count [14],\u_build_id/slot_count [12]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_build_id/add0_syn_94 ),
    .f({\u_build_id/slot_count_b5 [13],\u_build_id/slot_count_b5 [11]}),
    .fco(\u_build_id/add0_syn_98 ),
    .fx({\u_build_id/slot_count_b5 [14],\u_build_id/slot_count_b5 [12]}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_100"),
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
    \u_build_id/add0_syn_104  (
    .a({open_n917,\u_build_id/slot_count [15]}),
    .c(2'b00),
    .d({open_n922,1'b0}),
    .fci(\u_build_id/add0_syn_98 ),
    .f({open_n939,\u_build_id/slot_count_b5 [15]}));  // ../user_source/hdl_source/status_hex595.v(109)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/bit_count_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/bit_count_reg[0]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/bit_count [0]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h7a72))
    \u_build_id/bit_count_reg[0]_syn_3  (
    .a(\u_build_id/mux8_syn_187 ),
    .b(\u_build_id/bit_count_reg[3]_syn_4 ),
    .c(\u_build_id/bit_count [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/bit_count_reg[0]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/bit_count_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/bit_count_reg[1]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/bit_count [1]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hf72a7722))
    \u_build_id/bit_count_reg[1]_syn_3  (
    .a(\u_build_id/mux8_syn_187 ),
    .b(\u_build_id/bit_count_reg[3]_syn_4 ),
    .c(\u_build_id/bit_count [0]),
    .d(\u_build_id/bit_count [1]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/bit_count_reg[1]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/bit_count_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/bit_count_reg[2]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/bit_count [2]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(D*(C@(~B*~A)))"),
    .INIT(16'he100))
    \u_build_id/bit_count_reg[2]_syn_3  (
    .a(\u_build_id/bit_count [0]),
    .b(\u_build_id/bit_count [1]),
    .c(\u_build_id/bit_count [2]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/bit_count_reg[2]_syn_4 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("~(~D*~((C*~B))*~(A)+~D*(C*~B)*~(A)+~(~D)*(C*~B)*A+~D*(C*~B)*A)"),
    .INIT(16'hdf8a))
    \u_build_id/bit_count_reg[2]_syn_5  (
    .a(\u_build_id/mux8_syn_187 ),
    .b(\u_build_id/bit_count_reg[2]_syn_4 ),
    .c(\u_build_id/bit_count_reg[3]_syn_4 ),
    .d(\u_build_id/bit_count [2]),
    .o(\u_build_id/bit_count_reg[2]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/bit_count_reg[3]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/bit_count_reg[3]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/bit_count [3]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \u_build_id/bit_count_reg[3]_syn_10  (
    .a(\u_build_id/bit_count_reg[3]_syn_9 ),
    .b(\u_build_id/bit_count [3]),
    .c(\u_build_id/bit_count [4]),
    .o(\u_build_id/bit_count_reg[3]_syn_11 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*B))"),
    .INIT(8'h2a))
    \u_build_id/bit_count_reg[3]_syn_12  (
    .a(\u_build_id/mux7_syn_627 ),
    .b(\u_build_id/bit_count_reg[3]_syn_6 ),
    .c(\u_build_id/bit_count_reg[3]_syn_11 ),
    .o(\u_build_id/mux8_syn_187 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E)"),
    .INIT(32'h7f8a5f0a))
    \u_build_id/bit_count_reg[3]_syn_13  (
    .a(\u_build_id/mux8_syn_187 ),
    .b(\u_build_id/bit_count_reg[3]_syn_9 ),
    .c(\u_build_id/bit_count_reg[3]_syn_4 ),
    .d(\u_build_id/bit_count [3]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/bit_count_reg[3]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_build_id/bit_count_reg[3]_syn_3  (
    .a(\u_build_id/state_reg_syn_1 [0]),
    .b(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/bit_count_reg[3]_syn_4 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(~(D*B)*~(C*A))"),
    .INIT(16'h135f))
    \u_build_id/bit_count_reg[3]_syn_5  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/tx_is_blank ),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/bit_count_reg[3]_syn_6 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("~(A*~(C*B))"),
    .INIT(8'hd5))
    \u_build_id/bit_count_reg[3]_syn_7  (
    .a(\u_build_id/bit_count_reg[3]_syn_6 ),
    .b(\u_build_id/half_count [4]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_627 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \u_build_id/bit_count_reg[3]_syn_8  (
    .a(\u_build_id/bit_count [0]),
    .b(\u_build_id/bit_count [1]),
    .c(\u_build_id/bit_count [2]),
    .o(\u_build_id/bit_count_reg[3]_syn_9 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/bit_count_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/bit_count_reg[4]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/bit_count [4]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~((~C*B))*D*~(E)+~(A)*(~C*B)*D*~(E)+A*(~C*B)*~(D)*E+~(A)*~((~C*B))*D*E+A*~((~C*B))*D*E+~(A)*(~C*B)*D*E)"),
    .INIT(32'hf7085500))
    \u_build_id/bit_count_reg[4]_syn_3  (
    .a(\u_build_id/mux8_syn_187 ),
    .b(\u_build_id/bit_count_reg[3]_syn_9 ),
    .c(\u_build_id/bit_count [3]),
    .d(\u_build_id/bit_count [4]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/bit_count_reg[4]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/digit_index_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/digit_index_reg[0]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/digit_index [0]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(B@(C*~A))"),
    .INIT(8'h9c))
    \u_build_id/digit_index_reg[0]_syn_3  (
    .a(\u_build_id/tx_is_blank ),
    .b(\u_build_id/digit_index [0]),
    .c(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/digit_index_reg[0]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/digit_index_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/digit_index_reg[1]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/digit_index [1]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(C@(~B*A))"),
    .INIT(8'hd2))
    \u_build_id/digit_index_reg[1]_syn_3  (
    .a(\u_build_id/mux7_syn_635 ),
    .b(\u_build_id/tx_is_blank ),
    .c(\u_build_id/digit_index [1]),
    .o(\u_build_id/digit_index_reg[1]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/digit_index_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/digit_index_reg[2]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/digit_index [2]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(D@(C*~B*A))"),
    .INIT(16'hdf20))
    \u_build_id/digit_index_reg[2]_syn_3  (
    .a(\u_build_id/mux7_syn_635 ),
    .b(\u_build_id/tx_is_blank ),
    .c(\u_build_id/digit_index [1]),
    .d(\u_build_id/digit_index [2]),
    .o(\u_build_id/digit_index_reg[2]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/frame_value_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/frame_value_reg[0]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/frame_value [0]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT5 #(
    .EQN("~(~D*~(E*~C*B*A))"),
    .INIT(32'hff08ff00))
    \u_build_id/frame_value_reg[0]_syn_3  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/mux7_syn_631 ),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/frame_value [0]),
    .e(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/frame_value_reg[0]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/half_count_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/half_count_reg[0]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/half_count [0]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_build_id/half_count_reg[0]_syn_3  (
    .a(\u_build_id/half_count_reg[4]_syn_4 ),
    .b(\u_build_id/half_count_reg[4]_syn_6 ),
    .c(\u_build_id/half_count [0]),
    .o(\u_build_id/half_count_reg[0]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/half_count_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/half_count_reg[1]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/half_count [1]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hcea0))
    \u_build_id/half_count_reg[1]_syn_3  (
    .a(\u_build_id/half_count_reg[4]_syn_4 ),
    .b(\u_build_id/half_count_reg[4]_syn_6 ),
    .c(\u_build_id/half_count [0]),
    .d(\u_build_id/half_count [1]),
    .o(\u_build_id/half_count_reg[1]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/half_count_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/half_count_reg[2]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/half_count [2]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*(D*C)*~(E)+A*B*(D*C)*~(E)+A*~(B)*~((D*C))*E+~(A)*B*~((D*C))*E+A*B*~((D*C))*E+~(A)*B*(D*C)*E+A*B*(D*C)*E)"),
    .INIT(32'hceeea000))
    \u_build_id/half_count_reg[2]_syn_3  (
    .a(\u_build_id/half_count_reg[4]_syn_4 ),
    .b(\u_build_id/half_count_reg[4]_syn_6 ),
    .c(\u_build_id/half_count [0]),
    .d(\u_build_id/half_count [1]),
    .e(\u_build_id/half_count [2]),
    .o(\u_build_id/half_count_reg[2]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/half_count_reg[3]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/half_count_reg[3]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/half_count [3]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hcea0))
    \u_build_id/half_count_reg[3]_syn_3  (
    .a(\u_build_id/half_count_reg[4]_syn_4 ),
    .b(\u_build_id/half_count_reg[4]_syn_6 ),
    .c(\u_build_id/add1_syn_24 ),
    .d(\u_build_id/half_count [3]),
    .o(\u_build_id/half_count_reg[3]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/half_count_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/half_count_reg[4]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/half_count [4]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(~C*~B))"),
    .INIT(8'h54))
    \u_build_id/half_count_reg[4]_syn_3  (
    .a(\u_build_id/half_count [4]),
    .b(\u_build_id/state_reg_syn_1 [2]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/half_count_reg[4]_syn_4 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \u_build_id/half_count_reg[4]_syn_5  (
    .a(\u_build_id/state_reg_syn_1 [1]),
    .b(\u_build_id/state_reg_syn_1 [2]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/half_count_reg[4]_syn_6 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \u_build_id/half_count_reg[4]_syn_7  (
    .a(\u_build_id/half_count [0]),
    .b(\u_build_id/half_count [1]),
    .c(\u_build_id/half_count [2]),
    .o(\u_build_id/add1_syn_24 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT5 #(
    .EQN("~(~(E*B)*~(D*C*A))"),
    .INIT(32'heccca000))
    \u_build_id/half_count_reg[4]_syn_8  (
    .a(\u_build_id/half_count_reg[4]_syn_4 ),
    .b(\u_build_id/half_count_reg[4]_syn_6 ),
    .c(\u_build_id/add1_syn_24 ),
    .d(\u_build_id/half_count [3]),
    .e(\u_build_id/half_count [4]),
    .o(\u_build_id/half_count_reg[4]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_57  (
    .a(2'b11),
    .b({\u_build_id/slot_count [0],open_n959}),
    .fco(\u_build_id/lt0_syn_6 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_60  (
    .a(2'b11),
    .b(\u_build_id/slot_count [2:1]),
    .fci(\u_build_id/lt0_syn_6 ),
    .fco(\u_build_id/lt0_syn_10 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_63  (
    .a(2'b00),
    .b(\u_build_id/slot_count [4:3]),
    .fci(\u_build_id/lt0_syn_10 ),
    .fco(\u_build_id/lt0_syn_14 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_66  (
    .a(2'b11),
    .b(\u_build_id/slot_count [6:5]),
    .fci(\u_build_id/lt0_syn_14 ),
    .fco(\u_build_id/lt0_syn_18 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_69  (
    .a(2'b01),
    .b(\u_build_id/slot_count [8:7]),
    .fci(\u_build_id/lt0_syn_18 ),
    .fco(\u_build_id/lt0_syn_22 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_72  (
    .a(2'b00),
    .b(\u_build_id/slot_count [10:9]),
    .fci(\u_build_id/lt0_syn_22 ),
    .fco(\u_build_id/lt0_syn_26 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_75  (
    .a(2'b00),
    .b(\u_build_id/slot_count [12:11]),
    .fci(\u_build_id/lt0_syn_26 ),
    .fco(\u_build_id/lt0_syn_30 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_78  (
    .a(2'b00),
    .b(\u_build_id/slot_count [14:13]),
    .fci(\u_build_id/lt0_syn_30 ),
    .fco(\u_build_id/lt0_syn_34 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_57"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_81  (
    .a(2'b01),
    .b({1'b1,\u_build_id/slot_count [15]}),
    .fci(\u_build_id/lt0_syn_34 ),
    .f({\u_build_id/bit_count_b4_n ,open_n1171}));  // ../user_source/hdl_source/status_hex595.v(100)
  AL_MAP_LUT5 #(
    .EQN("~(~C*~B*~(A*~(~E*~D)))"),
    .INIT(32'hfefefefc))
    \u_build_id/mux2_syn_25  (
    .a(\u_build_id/half_count [4]),
    .b(\u_build_id/state_reg_syn_1 [0]),
    .c(\u_build_id/state_reg_syn_1 [1]),
    .d(\u_build_id/state_reg_syn_1 [2]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux2_syn_20 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_build_id/mux4_syn_102  (
    .a(\u_build_id/half_count [4]),
    .b(\u_build_id/state_reg_syn_1 [2]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux4_syn_79 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(C*~A))"),
    .INIT(8'hdc))
    \u_build_id/mux4_syn_103  (
    .a(\u_build_id/half_count [4]),
    .b(\u_build_id/state_reg_syn_1 [1]),
    .c(\u_build_id/state_reg_syn_1 [2]),
    .o(\u_build_id/mux4_syn_51 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~(D*~B)*~(C*~A))"),
    .INIT(16'h7350))
    \u_build_id/mux4_syn_104  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/tx_is_blank ),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux4_syn_39 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \u_build_id/mux4_syn_105  (
    .a(\u_build_id/bit_count_reg[3]_syn_11 ),
    .b(\u_build_id/half_count [4]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux4_syn_97 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_330  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [15]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_297 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_331  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [14]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_285 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_332  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [1]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_129 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_333  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [2]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_141 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_334  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [3]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_153 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_335  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [4]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_165 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_336  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [5]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_177 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_337  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [6]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_189 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_338  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [7]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_201 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_339  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [8]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_213 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_340  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [9]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_225 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_341  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [10]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_237 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_342  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [11]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_249 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_343  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [12]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_261 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_344  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [13]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_273 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(C*~A))"),
    .INIT(8'hdc))
    \u_build_id/mux5_syn_345  (
    .a(\u_build_id/tx_is_blank ),
    .b(\u_build_id/state_reg_syn_1 [0]),
    .c(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux5_syn_329 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*~A)"),
    .INIT(8'h10))
    \u_build_id/mux5_syn_346  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count [0]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_117 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_build_id/mux7_syn_628  (
    .a(\u_build_id/digit_index [0]),
    .b(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux7_syn_629 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_build_id/mux7_syn_630  (
    .a(\u_build_id/digit_index [0]),
    .b(\u_build_id/digit_index [1]),
    .o(\u_build_id/mux7_syn_631 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \u_build_id/mux7_syn_632  (
    .a(\u_build_id/mux7_syn_629 ),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .o(\u_build_id/mux7_syn_89 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(A*~(C*B))"),
    .INIT(8'hd5))
    \u_build_id/mux7_syn_633  (
    .a(\u_build_id/bit_count_reg[3]_syn_4 ),
    .b(\u_build_id/shift_word [14]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_593 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_build_id/mux7_syn_634  (
    .a(\u_build_id/digit_index [0]),
    .b(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux7_syn_635 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_build_id/mux7_syn_636  (
    .a(\u_build_id/digit_index [1]),
    .b(\u_build_id/digit_index [2]),
    .o(\u_build_id/mux7_syn_637 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~(D*C)*~(B*A))"),
    .INIT(16'hf888))
    \u_build_id/mux7_syn_638  (
    .a(\u_build_id/mux7_syn_635 ),
    .b(\u_build_id/mux7_syn_637 ),
    .c(\u_build_id/shift_word [6]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_327 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~(D*C)*~(B*A))"),
    .INIT(16'hf888))
    \u_build_id/mux7_syn_639  (
    .a(\u_build_id/mux7_syn_629 ),
    .b(\u_build_id/mux7_syn_637 ),
    .c(\u_build_id/shift_word [5]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_293 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("~(~(E*D)*~(C*~B*A))"),
    .INIT(32'hff202020))
    \u_build_id/mux7_syn_640  (
    .a(\u_build_id/mux7_syn_629 ),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/shift_word [3]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_225 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \u_build_id/mux7_syn_641  (
    .a(\u_build_id/mux7_syn_635 ),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .o(\u_build_id/mux7_syn_642 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(~A*~(C*B))"),
    .INIT(8'hea))
    \u_build_id/mux7_syn_643  (
    .a(\u_build_id/mux7_syn_642 ),
    .b(\u_build_id/shift_word [4]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_259 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("~(~(E*D)*~(~C*~B*A))"),
    .INIT(32'hff020202))
    \u_build_id/mux7_syn_644  (
    .a(\u_build_id/mux7_syn_635 ),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/shift_word [0]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_123 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_build_id/mux7_syn_645  (
    .a(\u_build_id/digit_index [1]),
    .b(\u_build_id/digit_index [2]),
    .o(\u_build_id/mux7_syn_646 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~(D*C)*~(B*A))"),
    .INIT(16'hf888))
    \u_build_id/mux7_syn_647  (
    .a(\u_build_id/mux7_syn_629 ),
    .b(\u_build_id/mux7_syn_646 ),
    .c(\u_build_id/shift_word [1]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_157 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~(D*C)*~(B*A))"),
    .INIT(16'hf888))
    \u_build_id/mux7_syn_648  (
    .a(\u_build_id/mux7_syn_635 ),
    .b(\u_build_id/mux7_syn_646 ),
    .c(\u_build_id/shift_word [2]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_191 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(B*A))"),
    .INIT(8'h07))
    \u_build_id/mux7_syn_649  (
    .a(\u_build_id/mux7_syn_642 ),
    .b(\u_build_id/frame_value [0]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux7_syn_650 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(A*~(C*B))"),
    .INIT(8'hd5))
    \u_build_id/mux7_syn_651  (
    .a(\u_build_id/mux7_syn_650 ),
    .b(\u_build_id/shift_word [8]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_395 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(A*~(C*B))"),
    .INIT(8'hd5))
    \u_build_id/mux7_syn_652  (
    .a(\u_build_id/mux7_syn_650 ),
    .b(\u_build_id/shift_word [9]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_429 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_build_id/mux7_syn_653  (
    .a(\u_build_id/frame_value [0]),
    .b(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux7_syn_654 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(B*~(C*~A))"),
    .INIT(8'h8c))
    \u_build_id/mux7_syn_655  (
    .a(\u_build_id/mux7_syn_631 ),
    .b(\u_build_id/mux7_syn_654 ),
    .c(\u_build_id/digit_index [2]),
    .o(\u_build_id/mux7_syn_656 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~A*~(D*B))"),
    .INIT(16'hfefa))
    \u_build_id/mux7_syn_657  (
    .a(\u_build_id/mux7_syn_656 ),
    .b(\u_build_id/shift_word [11]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_497 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~A*~(D*B))"),
    .INIT(16'hfefa))
    \u_build_id/mux7_syn_658  (
    .a(\u_build_id/mux7_syn_656 ),
    .b(\u_build_id/shift_word [12]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_531 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("(A*(B*C*~(D)+~(B)*~(C)*D))"),
    .INIT(16'h0280))
    \u_build_id/mux7_syn_659  (
    .a(\u_build_id/mux7_syn_654 ),
    .b(\u_build_id/digit_index [0]),
    .c(\u_build_id/digit_index [1]),
    .d(\u_build_id/digit_index [2]),
    .o(\u_build_id/mux7_syn_660 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~A*~(D*B))"),
    .INIT(16'hfefa))
    \u_build_id/mux7_syn_661  (
    .a(\u_build_id/mux7_syn_660 ),
    .b(\u_build_id/shift_word [7]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_361 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("(~D*~(A*~(C@B)))"),
    .INIT(16'h007d))
    \u_build_id/mux7_syn_662  (
    .a(\u_build_id/mux7_syn_656 ),
    .b(\u_build_id/digit_index [0]),
    .c(\u_build_id/digit_index [1]),
    .d(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux7_syn_663 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(A*~(C*B))"),
    .INIT(8'hd5))
    \u_build_id/mux7_syn_664  (
    .a(\u_build_id/mux7_syn_663 ),
    .b(\u_build_id/shift_word [10]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_463 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("(E*~(D*~C*(B@A)))"),
    .INIT(32'hf9ff0000))
    \u_build_id/mux7_syn_665  (
    .a(\u_build_id/digit_index [0]),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/frame_value [0]),
    .e(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux7_syn_666 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~A*~(D*B))"),
    .INIT(16'hfefa))
    \u_build_id/mux7_syn_667  (
    .a(\u_build_id/mux7_syn_666 ),
    .b(\u_build_id/shift_word [13]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_565 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[0]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_89 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [0]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[10]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_429 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [10]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[11]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_463 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [11]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[12]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_497 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [12]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[13]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_531 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [13]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[14]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_565 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [14]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[15]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_593 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [15]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[1]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_123 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [1]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[2]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_157 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [2]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[3]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_191 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [3]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[4]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_225 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [4]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[5]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_259 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [5]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[6]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_293 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [6]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[7]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_327 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [7]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[8]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_361 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [8]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/shift_word_reg[9]  (
    .ce(\u_build_id/mux7_syn_627 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux7_syn_395 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/shift_word [9]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[0]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_117 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [0]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[10]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_237 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [10]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[11]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_249 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [11]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[12]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_261 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [12]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[13]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_273 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [13]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[14]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_285 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [14]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[15]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_297 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [15]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[1]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_129 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [1]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[2]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_141 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [2]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[3]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_153 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [3]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[4]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_165 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [4]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[5]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_177 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [5]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[6]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_189 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [6]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[7]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_201 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [7]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[8]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_213 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [8]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[9]  (
    .ce(\u_build_id/mux5_syn_329 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_225 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [9]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/state_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux4_syn_39 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/state_reg_syn_1 [0]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/state_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux8_syn_187 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/state_reg_syn_1 [1]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/state_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux4_syn_51 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/state_reg_syn_1 [2]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/state_reg[3]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux4_syn_79 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/state_reg_syn_1 [3]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/state_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux4_syn_97 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/state_reg_syn_1 [4]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/state_reg[5]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/state_reg_syn_1 [4]),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/state_reg_syn_1 [5]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/tx_is_blank_reg  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/tx_is_blank_reg_syn_3 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/tx_is_blank ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hf0ec))
    \u_build_id/tx_is_blank_reg_syn_4  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/tx_is_blank ),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/tx_is_blank_reg_syn_3 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d_reg  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ));  // ../user_source/hdl_source/lane_lvds_10_1.v(39)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d_reg  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ));  // ../user_source/hdl_source/lane_lvds_10_1.v(39)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_n_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_1d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_2d ),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_n ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_reg  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_n ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en ));  // ../user_source/hdl_source/lane_lvds_10_1.v(39)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_1d_reg  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_1d ));  // ../user_source/hdl_source/lane_lvds_10_1.v(34)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_2d_reg  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_1d ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_2d ));  // ../user_source/hdl_source/lane_lvds_10_1.v(34)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_n_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even ),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_n ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_reg  (
    .clk(\u_build_id/clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even_n ),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_odd_even ));  // ../user_source/hdl_source/lane_lvds_10_1.v(28)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("INV"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_oddr_data_reg[0]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [8]),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_oddr_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(64)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("INV"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_oddr_data_reg[1]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [9]),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_oddr_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(64)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[0]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [9]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[1]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [8]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[2]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [7]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [2]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[3]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [6]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [3]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[4]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [5]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [4]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[5]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [4]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [5]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[6]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [3]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [6]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[7]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [2]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [7]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[8]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [1]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [8]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data_reg[9]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_blue/tmds [0]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [9]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[0]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [0]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [0]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[1]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [1]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [1]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[2]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [2]),
    .c(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [0]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [2]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[3]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [3]),
    .c(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [1]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [3]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[4]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [4]),
    .c(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [2]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [4]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[5]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [5]),
    .c(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [3]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [5]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[6]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [6]),
    .c(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [4]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [6]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[7]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [7]),
    .c(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [5]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [7]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[8]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [8]),
    .c(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [6]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [8]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b[9]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [9]),
    .c(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [7]),
    .o(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[0]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [0]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[1]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [1]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[2]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [2]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [2]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[3]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [3]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [3]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[4]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [4]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [4]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[5]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [5]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [5]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[6]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [6]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [6]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[7]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [7]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [7]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[8]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [8]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [8]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_reg[9]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b [9]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [9]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("INV"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_oddr_data_reg[0]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [8]),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_oddr_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(64)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("INV"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_oddr_data_reg[1]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [9]),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_oddr_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(64)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[0]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [9]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[1]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [8]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[2]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [7]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [2]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[3]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [6]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [3]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[4]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [5]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [4]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[5]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [4]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [5]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[6]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [3]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [6]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[7]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [2]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [7]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[8]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [1]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [8]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data_reg[9]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_green/tmds [0]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [9]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[0]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [0]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [0]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[1]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [1]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [1]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[2]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [2]),
    .c(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [0]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [2]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[3]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [3]),
    .c(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [1]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [3]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[4]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [4]),
    .c(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [2]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [4]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[5]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [5]),
    .c(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [3]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [5]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[6]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [6]),
    .c(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [4]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [6]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[7]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [7]),
    .c(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [5]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [7]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[8]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [8]),
    .c(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [6]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [8]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b[9]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data [9]),
    .c(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [7]),
    .o(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[0]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [0]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[1]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [1]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[2]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [2]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [2]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[3]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [3]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [3]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[4]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [4]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [4]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[5]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [5]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [5]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[6]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [6]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [6]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[7]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [7]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [7]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[8]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [8]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [8]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_reg[9]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b [9]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [9]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("INV"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_oddr_data_reg[0]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [8]),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_oddr_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(64)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("INV"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_oddr_data_reg[1]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [9]),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_oddr_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(64)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[0]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [9]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[1]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [8]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[2]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [7]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [2]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[3]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [6]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [3]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[4]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [5]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [4]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[5]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [4]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [5]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[6]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [3]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [6]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[7]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [2]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [7]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[8]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [1]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [8]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data_reg[9]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_video_tx/tmds_red/tmds [0]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [9]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[0]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [0]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [0]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[1]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [1]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [1]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[2]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [2]),
    .c(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [0]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [2]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[3]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [3]),
    .c(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [1]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [3]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[4]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [4]),
    .c(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [2]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [4]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[5]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [5]),
    .c(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [3]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [5]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[6]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [6]),
    .c(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [4]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [6]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[7]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [7]),
    .c(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [5]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [7]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[8]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [8]),
    .c(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [6]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [8]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b[9]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data [9]),
    .c(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [7]),
    .o(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[0]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [0]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[1]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [1]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[2]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [2]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [2]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[3]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [3]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [3]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[4]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [4]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [4]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[5]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [5]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [5]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[6]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [6]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [6]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[7]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [7]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [7]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[8]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [8]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [8]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_reg[9]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b [9]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [9]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("INV"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_oddr_data_reg[0]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [7]),
    .q(\u_hdmi_phy/u3_lane_lvds_8_1/S_oddr_data [0]));  // ../user_source/hdl_source/lane_lvds_10_1.v(64)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("INV"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_oddr_data_reg[1]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [9]),
    .q(\u_hdmi_phy/u3_lane_lvds_8_1/S_oddr_data [1]));  // ../user_source/hdl_source/lane_lvds_10_1.v(64)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_pending_data_reg[5]  (
    .ce(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_1d ),
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(1'b1),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u3_lane_lvds_8_1/S_pending_data [5]));  // ../user_source/hdl_source/lane_lvds_10_1.v(48)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b[5]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u3_lane_lvds_8_1/S_pending_data [5]),
    .o(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b [5]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b[7]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u3_lane_lvds_8_1/S_pending_data [5]),
    .c(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [5]),
    .o(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b [7]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b[9]_syn_1  (
    .a(\u_hdmi_phy/u0_lane_lvds_8_1/S_load_en_2d ),
    .b(\u_hdmi_phy/u3_lane_lvds_8_1/S_pending_data [5]),
    .c(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [7]),
    .o(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_reg[5]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b [5]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [5]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_reg[7]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b [7]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [7]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_reg[9]  (
    .clk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .d(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data_b [9]),
    .sr(\u_build_id/rst ),
    .q(\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [9]));  // ../user_source/hdl_source/lane_lvds_10_1.v(55)
  EG_PHY_GCLK u_hdmi_serial_bufg (
    .clki(serial_clk_raw),
    .clko(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ));  // ../user_source/hdl_source/top.v(18)
  EG_PHY_PLL #(
    .CLKC0_CPHASE(24),
    .CLKC0_DIV(25),
    .CLKC0_DIV2_ENABLE("DISABLE"),
    .CLKC0_ENABLE("ENABLE"),
    .CLKC0_FPHASE(0),
    .CLKC1_CPHASE(4),
    .CLKC1_DIV(5),
    .CLKC1_DIV2_ENABLE("DISABLE"),
    .CLKC1_ENABLE("ENABLE"),
    .CLKC1_FPHASE(0),
    .CLKC2_CPHASE(1),
    .CLKC2_DIV(1),
    .CLKC2_DIV2_ENABLE("DISABLE"),
    .CLKC2_ENABLE("DISABLE"),
    .CLKC2_FPHASE(0),
    .CLKC3_CPHASE(1),
    .CLKC3_DIV(1),
    .CLKC3_DIV2_ENABLE("DISABLE"),
    .CLKC3_ENABLE("DISABLE"),
    .CLKC3_FPHASE(0),
    .CLKC4_CPHASE(1),
    .CLKC4_DIV(1),
    .CLKC4_DIV2_ENABLE("DISABLE"),
    .CLKC4_ENABLE("DISABLE"),
    .CLKC4_FPHASE(0),
    .DERIVE_PLL_CLOCKS("DISABLE"),
    .DPHASE_SOURCE("DISABLE"),
    .DYNCFG("DISABLE"),
    .FBCLK_DIV(33),
    .FEEDBK_MODE("NOCOMP"),
    .FEEDBK_PATH("VCO_PHASE_0"),
    .FIN("50.000000"),
    .FREQ_LOCK_ACCURACY(2),
    .GEN_BASIC_CLOCK("DISABLE"),
    .GMC_GAIN(2),
    .GMC_TEST(14),
    .ICP_CURRENT(9),
    .IF_ESCLKSTSW("DISABLE"),
    .INTFB_WAKE("DISABLE"),
    .KVCO(2),
    .LPF_CAPACITOR(1),
    .LPF_RESISTOR(8),
    .NORESET("DISABLE"),
    .ODIV_MUXC0("DIV"),
    .ODIV_MUXC1("DIV"),
    .ODIV_MUXC2("DIV"),
    .ODIV_MUXC3("DIV"),
    .ODIV_MUXC4("DIV"),
    .PLLC2RST_ENA("DISABLE"),
    .PLLC34RST_ENA("DISABLE"),
    .PLLMRST_ENA("DISABLE"),
    .PLLRST_ENA("ENABLE"),
    .PLL_LOCK_MODE(0),
    .PREDIV_MUXC0("VCO"),
    .PREDIV_MUXC1("VCO"),
    .PREDIV_MUXC2("VCO"),
    .PREDIV_MUXC3("VCO"),
    .PREDIV_MUXC4("VCO"),
    .REFCLK_DIV(2),
    .REFCLK_SEL("INTERNAL"),
    .STDBY_ENABLE("DISABLE"),
    .STDBY_VCO_ENA("DISABLE"),
    .SYNC_ENABLE("DISABLE"),
    .VCO_NORESET("DISABLE"))
    \u_video_pll/pll_inst  (
    .daddr(6'b000000),
    .dclk(1'b0),
    .dcs(1'b0),
    .di(8'b00000000),
    .dwe(1'b0),
    .fbclk(1'b0),
    .load_reg(1'b0),
    .psclk(1'b0),
    .psclksel(3'b000),
    .psdown(1'b0),
    .psstep(1'b0),
    .refclk(clk_dup_1),
    .reset(1'b0),
    .stdby(1'b0),
    .clkc({open_n1244,open_n1245,open_n1246,serial_clk_raw,\u_video_pll/clk0_buf }),
    .extlock(pll_lock));  // ../user_source/hdl_source/IP/video_pll.v(47)
  EG_PHY_GCLK \u_video_pll/u_pixel_gclk  (
    .clki(\u_video_pll/clk0_buf ),
    .clko(\u_build_id/clk ));  // ../user_source/hdl_source/IP/video_pll.v(18)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add0_syn_62"),
    //.R_POSITION("X0Y0Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'h000A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_video_tx/add0_syn_62  (
    .a({\u_video_tx/cy [1],1'b0}),
    .b({\u_video_tx/cy [2],\u_video_tx/cy [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_video_tx/y_count_b4 [1],open_n1273}),
    .fco(\u_video_tx/add0_syn_54 ),
    .fx({\u_video_tx/y_count_b4 [2],open_n1274}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add0_syn_62"),
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
    \u_video_tx/add0_syn_63  (
    .a({\u_video_tx/cy [5],\u_video_tx/cy [3]}),
    .b({\u_video_tx/cy [6],\u_video_tx/cy [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_video_tx/add0_syn_54 ),
    .f({\u_video_tx/y_count_b4 [5],\u_video_tx/y_count_b4 [3]}),
    .fco(\u_video_tx/add0_syn_58 ),
    .fx({\u_video_tx/y_count_b4 [6],\u_video_tx/y_count_b4 [4]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add0_syn_62"),
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
    \u_video_tx/add0_syn_64  (
    .a({\u_video_tx/cy [9],\u_video_tx/cy [7]}),
    .b({open_n1295,\u_video_tx/cy [8]}),
    .c(2'b00),
    .d(2'b00),
    .e({open_n1298,1'b0}),
    .fci(\u_video_tx/add0_syn_58 ),
    .f({\u_video_tx/y_count_b4 [9],\u_video_tx/y_count_b4 [7]}),
    .fx({open_n1314,\u_video_tx/y_count_b4 [8]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add1_syn_62"),
    //.R_POSITION("X0Y0Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'h000A),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_video_tx/add1_syn_62  (
    .a({\u_video_tx/cx [1],1'b0}),
    .b({\u_video_tx/cx [2],\u_video_tx/cx [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_video_tx/x_count_b3 [1],open_n1334}),
    .fco(\u_video_tx/add1_syn_54 ),
    .fx({\u_video_tx/x_count_b3 [2],open_n1335}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add1_syn_62"),
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
    \u_video_tx/add1_syn_63  (
    .a({\u_video_tx/cx [5],\u_video_tx/cx [3]}),
    .b({\u_video_tx/cx [6],\u_video_tx/cx [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_video_tx/add1_syn_54 ),
    .f({\u_video_tx/x_count_b3 [5],\u_video_tx/x_count_b3 [3]}),
    .fco(\u_video_tx/add1_syn_58 ),
    .fx({\u_video_tx/x_count_b3 [6],\u_video_tx/x_count_b3 [4]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add1_syn_62"),
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
    \u_video_tx/add1_syn_64  (
    .a({\u_video_tx/cx [9],\u_video_tx/cx [7]}),
    .b({open_n1356,\u_video_tx/cx [8]}),
    .c(2'b00),
    .d(2'b00),
    .e({open_n1359,1'b0}),
    .fci(\u_video_tx/add1_syn_58 ),
    .f({\u_video_tx/x_count_b3 [9],\u_video_tx/x_count_b3 [7]}),
    .fx({open_n1375,\u_video_tx/x_count_b3 [8]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_video_tx/cx[0]_syn_5  (
    .a(\u_video_tx/cx [0]),
    .o(\u_video_tx/cx[0]_syn_2 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(18)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_video_tx/cy[0]_syn_11  (
    .a(\u_video_tx/cy [0]),
    .o(\u_video_tx/cy[0]_syn_2 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(19)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_28"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_28  (
    .a(2'b11),
    .b({\u_video_tx/cx [4],open_n1378}),
    .fco(\u_video_tx/lt0_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_28"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_31  (
    .a(2'b00),
    .b(\u_video_tx/cx [6:5]),
    .fci(\u_video_tx/lt0_syn_7 ),
    .fco(\u_video_tx/lt0_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_28"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_34  (
    .a(2'b01),
    .b(\u_video_tx/cx [8:7]),
    .fci(\u_video_tx/lt0_syn_11 ),
    .fco(\u_video_tx/lt0_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_28"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_37  (
    .a(2'b01),
    .b({1'b1,\u_video_tx/cx [9]}),
    .fci(\u_video_tx/lt0_syn_15 ),
    .f({\u_video_tx/hsync_pulse_n1 ,open_n1470}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_33"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_33  (
    .a(2'b11),
    .b({\u_video_tx/cx [2],open_n1476}),
    .fco(\u_video_tx/lt12_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_33"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_36  (
    .a(2'b00),
    .b(\u_video_tx/cx [4:3]),
    .fci(\u_video_tx/lt12_syn_6 ),
    .fco(\u_video_tx/lt12_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_33"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_39  (
    .a(2'b00),
    .b(\u_video_tx/cx [6:5]),
    .fci(\u_video_tx/lt12_syn_10 ),
    .fco(\u_video_tx/lt12_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_33"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_42  (
    .a(2'b01),
    .b(\u_video_tx/cx [8:7]),
    .fci(\u_video_tx/lt12_syn_14 ),
    .fco(\u_video_tx/lt12_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_33"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_45  (
    .a(2'b01),
    .b({1'b1,\u_video_tx/cx [9]}),
    .fci(\u_video_tx/lt12_syn_18 ),
    .f({\u_video_tx/data_island_preamble_n1 ,open_n1592}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_34"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_34  (
    .a({\u_video_tx/cx [2],1'b0}),
    .b({1'b1,open_n1598}),
    .fco(\u_video_tx/lt13_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_34"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_37  (
    .a(\u_video_tx/cx [4:3]),
    .b(2'b01),
    .fci(\u_video_tx/lt13_syn_7 ),
    .fco(\u_video_tx/lt13_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_34"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_40  (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b00),
    .fci(\u_video_tx/lt13_syn_11 ),
    .fco(\u_video_tx/lt13_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_34"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_43  (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b01),
    .fci(\u_video_tx/lt13_syn_15 ),
    .fco(\u_video_tx/lt13_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_34"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_46  (
    .a({1'b0,\u_video_tx/cx [9]}),
    .b(2'b11),
    .fci(\u_video_tx/lt13_syn_19 ),
    .f({\u_video_tx/data_island_preamble_n2 ,open_n1714}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_37"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_37  (
    .a({\u_video_tx/cx [1],1'b0}),
    .b({1'b1,open_n1720}),
    .fco(\u_video_tx/lt15_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_37"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_40  (
    .a(\u_video_tx/cx [3:2]),
    .b(2'b11),
    .fci(\u_video_tx/lt15_syn_7 ),
    .fco(\u_video_tx/lt15_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_37"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_43  (
    .a(\u_video_tx/cx [5:4]),
    .b(2'b00),
    .fci(\u_video_tx/lt15_syn_11 ),
    .fco(\u_video_tx/lt15_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_37"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_46  (
    .a(\u_video_tx/cx [7:6]),
    .b(2'b10),
    .fci(\u_video_tx/lt15_syn_15 ),
    .fco(\u_video_tx/lt15_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_37"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_49  (
    .a(\u_video_tx/cx [9:8]),
    .b(2'b10),
    .fci(\u_video_tx/lt15_syn_19 ),
    .fco(\u_video_tx/lt15_syn_23 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_37"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_51  (
    .a({open_n1842,1'b0}),
    .b({open_n1843,1'b1}),
    .fci(\u_video_tx/lt15_syn_23 ),
    .f({open_n1862,\u_video_tx/data_island_guard_n4 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_37"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_37  (
    .a(2'b11),
    .b({\u_video_tx/cx [1],open_n1868}),
    .fco(\u_video_tx/lt16_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_37"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_40  (
    .a(2'b11),
    .b(\u_video_tx/cx [3:2]),
    .fci(\u_video_tx/lt16_syn_7 ),
    .fco(\u_video_tx/lt16_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_37"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_43  (
    .a(2'b10),
    .b(\u_video_tx/cx [5:4]),
    .fci(\u_video_tx/lt16_syn_11 ),
    .fco(\u_video_tx/lt16_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_37"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_46  (
    .a(2'b10),
    .b(\u_video_tx/cx [7:6]),
    .fci(\u_video_tx/lt16_syn_15 ),
    .fco(\u_video_tx/lt16_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_37"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_49  (
    .a(2'b10),
    .b(\u_video_tx/cx [9:8]),
    .fci(\u_video_tx/lt16_syn_19 ),
    .fco(\u_video_tx/lt16_syn_23 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_37"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_51  (
    .a({open_n1990,1'b0}),
    .b({open_n1991,1'b1}),
    .fci(\u_video_tx/lt16_syn_23 ),
    .f({open_n2010,\u_video_tx/data_island_guard_n5 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_27"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_27  (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n2016}),
    .fco(\u_video_tx/lt17_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_27"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_30  (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b01),
    .fci(\u_video_tx/lt17_syn_6 ),
    .fco(\u_video_tx/lt17_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_27"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_33  (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b01),
    .fci(\u_video_tx/lt17_syn_10 ),
    .fco(\u_video_tx/lt17_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_27"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_36  (
    .a({1'b0,\u_video_tx/cx [9]}),
    .b(2'b11),
    .fci(\u_video_tx/lt17_syn_14 ),
    .f({\u_video_tx/data_island_guard_n6 ,open_n2108}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_27"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_27  (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n2114}),
    .fco(\u_video_tx/lt1_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_27"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_30  (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b11),
    .fci(\u_video_tx/lt1_syn_6 ),
    .fco(\u_video_tx/lt1_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_27"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_33  (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b01),
    .fci(\u_video_tx/lt1_syn_10 ),
    .fco(\u_video_tx/lt1_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_27"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_36  (
    .a({1'b0,\u_video_tx/cx [9]}),
    .b(2'b11),
    .fci(\u_video_tx/lt1_syn_14 ),
    .f({\u_video_tx/hsync_pulse_n2 ,open_n2206}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt2_syn_36"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt2_syn_36  (
    .a(2'b11),
    .b({\u_video_tx/cy [1],open_n2212}),
    .fco(\u_video_tx/lt2_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt2_syn_36"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt2_syn_39  (
    .a(2'b10),
    .b(\u_video_tx/cy [3:2]),
    .fci(\u_video_tx/lt2_syn_6 ),
    .fco(\u_video_tx/lt2_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt2_syn_36"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt2_syn_42  (
    .a(2'b10),
    .b(\u_video_tx/cy [5:4]),
    .fci(\u_video_tx/lt2_syn_10 ),
    .fco(\u_video_tx/lt2_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt2_syn_36"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt2_syn_45  (
    .a(2'b11),
    .b(\u_video_tx/cy [7:6]),
    .fci(\u_video_tx/lt2_syn_14 ),
    .fco(\u_video_tx/lt2_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt2_syn_36"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt2_syn_48  (
    .a(2'b01),
    .b(\u_video_tx/cy [9:8]),
    .fci(\u_video_tx/lt2_syn_18 ),
    .fco(\u_video_tx/lt2_syn_22 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt2_syn_36"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt2_syn_50  (
    .a({open_n2334,1'b0}),
    .b({open_n2335,1'b1}),
    .fci(\u_video_tx/lt2_syn_22 ),
    .f({open_n2354,\u_video_tx/vsync_pulse_n1 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_33"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_33  (
    .a({\u_video_tx/cy [2],1'b0}),
    .b({1'b1,open_n2360}),
    .fco(\u_video_tx/lt3_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_33"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_36  (
    .a(\u_video_tx/cy [4:3]),
    .b(2'b01),
    .fci(\u_video_tx/lt3_syn_6 ),
    .fco(\u_video_tx/lt3_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_33"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_39  (
    .a(\u_video_tx/cy [6:5]),
    .b(2'b11),
    .fci(\u_video_tx/lt3_syn_10 ),
    .fco(\u_video_tx/lt3_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_33"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_42  (
    .a(\u_video_tx/cy [8:7]),
    .b(2'b11),
    .fci(\u_video_tx/lt3_syn_14 ),
    .fco(\u_video_tx/lt3_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_33"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_45  (
    .a({1'b0,\u_video_tx/cy [9]}),
    .b(2'b10),
    .fci(\u_video_tx/lt3_syn_18 ),
    .f({\u_video_tx/vsync_pulse_n2 ,open_n2476}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_36"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_36  (
    .a(2'b11),
    .b({\u_video_tx/cx [1],open_n2482}),
    .fco(\u_video_tx/lt6_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_36"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_39  (
    .a(2'b11),
    .b(\u_video_tx/cx [3:2]),
    .fci(\u_video_tx/lt6_syn_6 ),
    .fco(\u_video_tx/lt6_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_36"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_42  (
    .a(2'b01),
    .b(\u_video_tx/cx [5:4]),
    .fci(\u_video_tx/lt6_syn_10 ),
    .fco(\u_video_tx/lt6_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_36"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_45  (
    .a(2'b11),
    .b(\u_video_tx/cx [7:6]),
    .fci(\u_video_tx/lt6_syn_14 ),
    .fco(\u_video_tx/lt6_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_36"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_48  (
    .a(2'b11),
    .b(\u_video_tx/cx [9:8]),
    .fci(\u_video_tx/lt6_syn_18 ),
    .fco(\u_video_tx/lt6_syn_22 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_36"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_50  (
    .a({open_n2604,1'b0}),
    .b({open_n2605,1'b1}),
    .fci(\u_video_tx/lt6_syn_22 ),
    .f({open_n2624,\u_video_tx/video_preamble_n2 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt7_syn_37"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt7_syn_37  (
    .a({\u_video_tx/cx [1],1'b0}),
    .b({1'b1,open_n2630}),
    .fco(\u_video_tx/lt7_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt7_syn_37"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt7_syn_40  (
    .a(\u_video_tx/cx [3:2]),
    .b(2'b01),
    .fci(\u_video_tx/lt7_syn_7 ),
    .fco(\u_video_tx/lt7_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt7_syn_37"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt7_syn_43  (
    .a(\u_video_tx/cx [5:4]),
    .b(2'b10),
    .fci(\u_video_tx/lt7_syn_11 ),
    .fco(\u_video_tx/lt7_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt7_syn_37"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt7_syn_46  (
    .a(\u_video_tx/cx [7:6]),
    .b(2'b11),
    .fci(\u_video_tx/lt7_syn_15 ),
    .fco(\u_video_tx/lt7_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt7_syn_37"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt7_syn_49  (
    .a(\u_video_tx/cx [9:8]),
    .b(2'b11),
    .fci(\u_video_tx/lt7_syn_19 ),
    .fco(\u_video_tx/lt7_syn_23 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt7_syn_37"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt7_syn_51  (
    .a({open_n2752,1'b0}),
    .b({open_n2753,1'b1}),
    .fci(\u_video_tx/lt7_syn_23 ),
    .f({open_n2772,\u_video_tx/video_preamble_n3 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_38"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_38  (
    .a({\u_video_tx/cy [0],1'b0}),
    .b({1'b1,open_n2778}),
    .fco(\u_video_tx/lt8_syn_5 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_38"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_41  (
    .a(\u_video_tx/cy [2:1]),
    .b(2'b11),
    .fci(\u_video_tx/lt8_syn_5 ),
    .fco(\u_video_tx/lt8_syn_9 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_38"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_44  (
    .a(\u_video_tx/cy [4:3]),
    .b(2'b11),
    .fci(\u_video_tx/lt8_syn_9 ),
    .fco(\u_video_tx/lt8_syn_13 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_38"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_47  (
    .a(\u_video_tx/cy [6:5]),
    .b(2'b10),
    .fci(\u_video_tx/lt8_syn_13 ),
    .fco(\u_video_tx/lt8_syn_17 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_38"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_50  (
    .a(\u_video_tx/cy [8:7]),
    .b(2'b11),
    .fci(\u_video_tx/lt8_syn_17 ),
    .fco(\u_video_tx/lt8_syn_21 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_38"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_53  (
    .a({1'b0,\u_video_tx/cy [9]}),
    .b(2'b10),
    .fci(\u_video_tx/lt8_syn_21 ),
    .f({\u_video_tx/mode_b1_n6 ,open_n2918}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/counter_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/counter_reg[0]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/packet_ecc/counter [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/counter_reg[0]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .o(\u_video_tx/packet_ecc/counter_reg[0]_syn_2 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/counter_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/counter_reg[1]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/packet_ecc/counter [1]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_LUT3 #(
    .EQN("(C@(B*A))"),
    .INIT(8'h78))
    \u_video_tx/packet_ecc/counter_reg[1]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/counter_reg[1]_syn_2 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/counter_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/counter_reg[2]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/packet_ecc/counter [2]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_LUT3 #(
    .EQN("(C@(B*A))"),
    .INIT(8'h78))
    \u_video_tx/packet_ecc/counter_reg[2]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/mux25_syn_34 ),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/packet_ecc/counter_reg[2]_syn_2 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/counter_reg[3]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/counter_reg[3]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/packet_ecc/counter [3]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_LUT4 #(
    .EQN("(D@(C*B*A))"),
    .INIT(16'h7f80))
    \u_video_tx/packet_ecc/counter_reg[3]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/mux25_syn_34 ),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/counter_reg[3]_syn_2 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/counter_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/counter_reg[4]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/packet_ecc/counter [4]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_LUT5 #(
    .EQN("(E@(D*C*B*A))"),
    .INIT(32'h7fff8000))
    \u_video_tx/packet_ecc/counter_reg[4]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/mux25_syn_34 ),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/counter_reg[4]_syn_2 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_LUT3 #(
    .EQN("~(C*B*A)"),
    .INIT(8'h7f))
    \u_video_tx/packet_ecc/mux25_syn_32  (
    .a(startup_done),
    .b(rst_n_dup_1),
    .c(pll_lock),
    .o(\u_build_id/rst ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(70)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/packet_ecc/mux25_syn_33  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux25_syn_34 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(70)
  AL_MAP_LUT4 #(
    .EQN("~(~D*A*~(C*~B))"),
    .INIT(16'hff75))
    \u_video_tx/packet_ecc/mux25_syn_35  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux25_syn_34 ),
    .d(\u_build_id/rst ),
    .o(\u_video_tx/packet_ecc/mux25_syn_2 [3]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(70)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity0_next2[0]_syn_1  (
    .a(\u_video_tx/packet_ecc/parity0_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/bch0 [58]),
    .o(\u_video_tx/packet_ecc/parity0_next2 [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity0_next2[1]_syn_1  (
    .a(\u_video_tx/tmds_green/mux7_syn_152 ),
    .b(\u_video_tx/packet_ecc/bch0 [56]),
    .o(\u_video_tx/packet_ecc/parity0_next2 [6]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity0_next2[1]_syn_2  (
    .a(\u_video_tx/tmds_red/mux7_syn_140 ),
    .b(\u_video_tx/packet_ecc/bch0 [57]),
    .o(\u_video_tx/packet_ecc/parity0_next2[1]_syn_3 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity0_next2[1]_syn_4  (
    .a(\u_video_tx/packet_ecc/parity0_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/parity0_next2 [6]),
    .o(\u_video_tx/packet_ecc/parity0_next2 [7]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity0_next2[1]_syn_5  (
    .a(\u_video_tx/packet_ecc/parity0_next2 [7]),
    .b(\u_video_tx/packet_ecc/bch0 [59]),
    .o(\u_video_tx/packet_ecc/parity0_next2 [1]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity0_reg[0]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity0_next2 [0]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch0 [56]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity0_reg[1]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity0_next2 [1]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch0 [57]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity0_reg[2]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch0 [60]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch0 [58]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity0_reg[3]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch0 [61]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch0 [59]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity0_reg[4]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch0 [62]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch0 [60]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity0_reg[5]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch0 [63]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch0 [61]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity0_reg[6]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity0_next2 [6]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch0 [62]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity0_reg[7]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity0_next2 [7]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch0 [63]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity1_next2[0]_syn_1  (
    .a(\u_video_tx/packet_ecc/parity1_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/bch1 [58]),
    .o(\u_video_tx/packet_ecc/parity1_next2 [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_1  (
    .a(\u_video_tx/packet_ecc/mux1_syn_52 ),
    .b(\u_video_tx/packet_ecc/bch1 [56]),
    .o(\u_video_tx/packet_ecc/parity1_next2 [6]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_2  (
    .a(\u_video_tx/tmds_red/mux7_syn_129 ),
    .b(\u_video_tx/packet_ecc/bch1 [57]),
    .o(\u_video_tx/packet_ecc/parity1_next2[1]_syn_3 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_4  (
    .a(\u_video_tx/packet_ecc/parity1_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/parity1_next2 [6]),
    .o(\u_video_tx/packet_ecc/parity1_next2 [7]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_5  (
    .a(\u_video_tx/packet_ecc/parity1_next2 [7]),
    .b(\u_video_tx/packet_ecc/bch1 [59]),
    .o(\u_video_tx/packet_ecc/parity1_next2 [1]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity1_reg[0]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity1_next2 [0]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch1 [56]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity1_reg[1]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity1_next2 [1]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch1 [57]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity1_reg[2]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch1 [60]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch1 [58]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity1_reg[3]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch1 [61]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch1 [59]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity1_reg[4]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch1 [62]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch1 [60]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity1_reg[5]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch1 [63]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch1 [61]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity1_reg[6]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity1_next2 [6]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch1 [62]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity1_reg[7]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity1_next2 [7]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch1 [63]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity2_next2[0]_syn_1  (
    .a(\u_video_tx/packet_ecc/parity2_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/bch2 [58]),
    .o(\u_video_tx/packet_ecc/parity2_next2 [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity2_next2[1]_syn_1  (
    .a(\u_video_tx/packet_ecc/mux2_syn_52 ),
    .b(\u_video_tx/packet_ecc/bch2 [56]),
    .o(\u_video_tx/packet_ecc/parity2_next2 [6]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity2_next2[1]_syn_2  (
    .a(\u_video_tx/packet_ecc/mux6_syn_52 ),
    .b(\u_video_tx/packet_ecc/bch2 [57]),
    .o(\u_video_tx/packet_ecc/parity2_next2[1]_syn_3 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity2_next2[1]_syn_4  (
    .a(\u_video_tx/packet_ecc/parity2_next2 [6]),
    .b(\u_video_tx/packet_ecc/parity2_next2[1]_syn_3 ),
    .o(\u_video_tx/packet_ecc/parity2_next2 [7]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity2_next2[1]_syn_5  (
    .a(\u_video_tx/packet_ecc/parity2_next2 [7]),
    .b(\u_video_tx/packet_ecc/bch2 [59]),
    .o(\u_video_tx/packet_ecc/parity2_next2 [1]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity2_reg[0]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity2_next2 [0]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch2 [56]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity2_reg[1]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity2_next2 [1]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch2 [57]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity2_reg[2]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch2 [60]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch2 [58]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity2_reg[3]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch2 [61]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch2 [59]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity2_reg[4]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch2 [62]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch2 [60]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity2_reg[5]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch2 [63]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch2 [61]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity2_reg[6]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity2_next2 [6]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch2 [62]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity2_reg[7]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity2_next2 [7]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch2 [63]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity3_next2[0]_syn_1  (
    .a(\u_video_tx/packet_ecc/parity3_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/bch3 [58]),
    .o(\u_video_tx/packet_ecc/parity3_next2 [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity3_next2[1]_syn_1  (
    .a(\u_video_tx/packet_ecc/mux3_syn_26 ),
    .b(\u_video_tx/packet_ecc/bch3 [56]),
    .o(\u_video_tx/packet_ecc/parity3_next2 [6]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity3_next2[1]_syn_2  (
    .a(\u_video_tx/tmds_red/mux7_syn_120 ),
    .b(\u_video_tx/packet_ecc/bch3 [57]),
    .o(\u_video_tx/packet_ecc/parity3_next2[1]_syn_3 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity3_next2[1]_syn_4  (
    .a(\u_video_tx/packet_ecc/parity3_next2 [6]),
    .b(\u_video_tx/packet_ecc/parity3_next2[1]_syn_3 ),
    .o(\u_video_tx/packet_ecc/parity3_next2 [7]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity3_next2[1]_syn_5  (
    .a(\u_video_tx/packet_ecc/parity3_next2 [7]),
    .b(\u_video_tx/packet_ecc/bch3 [59]),
    .o(\u_video_tx/packet_ecc/parity3_next2 [1]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity3_reg[0]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity3_next2 [0]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch3 [56]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity3_reg[1]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity3_next2 [1]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch3 [57]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity3_reg[2]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch3 [60]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch3 [58]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity3_reg[3]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch3 [61]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch3 [59]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity3_reg[4]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch3 [62]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch3 [60]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity3_reg[5]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/bch3 [63]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch3 [61]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity3_reg[6]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity3_next2 [6]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch3 [62]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity3_reg[7]  (
    .ce(\u_video_tx/packet_ecc/parity0_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity3_next2 [7]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/bch3 [63]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity4_next[0]_syn_1  (
    .a(\u_video_tx/packet_ecc/parity4_next [7]),
    .b(\u_video_tx/packet_ecc/parity4 [1]),
    .o(\u_video_tx/packet_ecc/parity4_next [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(31)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity4_next[1]_syn_1  (
    .a(\u_video_tx/tmds_blue/mux9_syn_142 ),
    .b(\u_video_tx/packet_ecc/parity4 [0]),
    .o(\u_video_tx/packet_ecc/parity4_next [7]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(31)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity4_next[1]_syn_2  (
    .a(\u_video_tx/packet_ecc/parity4_next [7]),
    .b(\u_video_tx/packet_ecc/parity4 [2]),
    .o(\u_video_tx/packet_ecc/parity4_next [1]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(31)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity4_reg[0]  (
    .ce(\u_video_tx/packet_ecc/parity4_b3_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity4_next [0]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/parity4 [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity4_reg[1]  (
    .ce(\u_video_tx/packet_ecc/parity4_b3_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity4_next [1]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/parity4 [1]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity4_reg[2]  (
    .ce(\u_video_tx/packet_ecc/parity4_b3_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity4 [3]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/parity4 [2]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity4_reg[3]  (
    .ce(\u_video_tx/packet_ecc/parity4_b3_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity4 [4]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/parity4 [3]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity4_reg[4]  (
    .ce(\u_video_tx/packet_ecc/parity4_b3_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity4 [5]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/parity4 [4]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity4_reg[5]  (
    .ce(\u_video_tx/packet_ecc/parity4_b3_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity4 [6]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/parity4 [5]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity4_reg[6]  (
    .ce(\u_video_tx/packet_ecc/parity4_b3_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity4 [7]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/parity4 [6]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/packet_ecc/parity4_reg[7]  (
    .ce(\u_video_tx/packet_ecc/parity4_b3_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/packet_ecc/parity4_next [7]),
    .sr(\u_video_tx/packet_ecc/mux25_syn_2 [3]),
    .q(\u_video_tx/packet_ecc/parity4 [7]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(69)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/tmds_blue/acc_add[3]_syn_3  (
    .a(\u_video_tx/tmds_blue/video_data[7]_syn_2 ),
    .b(\u_video_tx/tmds_blue/acc [4]),
    .o(\u_video_tx/tmds_blue/acc_add[3]_syn_2 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_video_tx/tmds_blue/acc_add[3]_syn_4  (
    .a(\u_video_tx/tmds_blue/acc_add[3]_syn_2 ),
    .o(\u_video_tx/tmds_blue/acc_add [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_blue/acc_reg[1]_syn_4"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_video_tx/tmds_blue/acc_reg[1]_syn_4  (
    .a({\u_video_tx/tmds_blue/acc [1],1'b0}),
    .b({\u_video_tx/tmds_blue/acc [4],open_n2929}),
    .clk(\u_build_id/clk ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_blue/add1_syn_24 ),
    .q({\u_video_tx/tmds_blue/acc [1],open_n2951}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_blue/acc_reg[1]_syn_4"),
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
    \u_video_tx/tmds_blue/acc_reg[3]_syn_4  (
    .a(\u_video_tx/tmds_blue/acc [3:2]),
    .b({\u_video_tx/tmds_blue/acc_add [3],\u_video_tx/tmds_blue/acc_add[3]_syn_2 }),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_blue/add1_syn_24 ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_blue/add1_syn_26 ),
    .q(\u_video_tx/tmds_blue/acc [3:2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_blue/acc_reg[1]_syn_4"),
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
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_video_tx/tmds_blue/acc_reg[4]_syn_4  (
    .a({open_n2972,1'b0}),
    .b({open_n2973,1'b1}),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_blue/add1_syn_26 ),
    .sr(\u_video_tx/active ),
    .q({open_n2995,\u_video_tx/tmds_blue/acc [4]}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hfff513f1))
    \u_video_tx/tmds_blue/mux9_syn_136  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_148 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .e(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_blue/mux9_syn_137 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(C*(A*~(B)*~(D)+A*B*~(D)+~(A)*B*D+A*B*D))"),
    .INIT(16'hc0a0))
    \u_video_tx/tmds_blue/mux9_syn_138  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_148 ),
    .c(\u_video_tx/packet_ecc/mux9_syn_57 ),
    .d(\u_video_tx/packet_ecc/counter [0]),
    .o(\u_video_tx/packet_ecc/mux9_syn_42 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E)"),
    .INIT(32'h1fffff15))
    \u_video_tx/tmds_blue/mux9_syn_139  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_148 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .e(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_blue/mux9_syn_140 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+A*~(B)*~(C)*~(D)*E+A*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hffaa33f0))
    \u_video_tx/tmds_blue/mux9_syn_141  (
    .a(\u_video_tx/tmds_blue/mux9_syn_137 ),
    .b(\u_video_tx/packet_ecc/mux9_syn_42 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_140 ),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_blue/mux9_syn_142 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(B*~(~D*~C)))"),
    .INIT(16'h1115))
    \u_video_tx/tmds_blue/mux9_syn_143  (
    .a(rgb_b4_n),
    .b(rgb_b5_n),
    .c(\u_video_tx/tmds_red/mux7_syn_117 ),
    .d(\u_video_tx/cx [9]),
    .o(\u_video_tx/tmds_blue/mux9_syn_144 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~B*~(~D*~(~C*~(~E*~A))))"),
    .INIT(32'h33033302))
    \u_video_tx/tmds_blue/mux9_syn_145  (
    .a(\u_video_tx/tmds_blue/mux9_syn_144 ),
    .b(rgb_b_n),
    .c(rgb_b2_n),
    .d(\u_video_tx/tmds_red/mux7_syn_122 ),
    .e(\u_video_tx/tmds_green/mux7_syn_134 ),
    .o(\u_video_tx/tmds_blue/video_data[7]_syn_2 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_blue/mux9_syn_146  (
    .a(\u_video_tx/hsync_pulse_n1 ),
    .b(\u_video_tx/hsync_pulse_n2 ),
    .o(\u_video_tx/tmds_blue/mux5_syn_16 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*C*~B*A)"),
    .INIT(32'h00000020))
    \u_video_tx/tmds_blue/mux9_syn_147  (
    .a(\u_video_tx/tmds_green/mux7_syn_121 ),
    .b(\u_video_tx/cy [2]),
    .c(\u_video_tx/cy [3]),
    .d(\u_video_tx/cy [4]),
    .e(\u_video_tx/cy [9]),
    .o(\u_video_tx/tmds_blue/mux9_syn_148 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_blue/mux9_syn_149  (
    .a(\u_video_tx/vsync_pulse_n1 ),
    .b(\u_video_tx/vsync_pulse_n2 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_150 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("~(A*~((E@C))*~((D*B))+A*(E@C)*~((D*B))+~(A)*(E@C)*(D*B)+A*(E@C)*(D*B))"),
    .INIT(32'hd1551d55))
    \u_video_tx/tmds_blue/mux9_syn_151  (
    .a(\u_video_tx/tmds_blue/mux9_syn_150 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_148 ),
    .c(\u_video_tx/hsync_pulse_n1 ),
    .d(\u_video_tx/cy [0]),
    .e(\u_video_tx/cy [1]),
    .o(\u_video_tx/tmds_blue/mux9_syn_152 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_blue/mux9_syn_153  (
    .a(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .b(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .o(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_blue/mux9_syn_154  (
    .a(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .b(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .o(\u_video_tx/tmds_blue/data_guard_band_b1_n ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/tmds_blue/mux9_syn_155  (
    .a(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .b(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_156 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_video_tx/tmds_blue/mux9_syn_157  (
    .a(\u_video_tx/cx [0]),
    .b(\u_video_tx/cx [1]),
    .c(\u_video_tx/cx [2]),
    .d(\u_video_tx/cx [7]),
    .o(\u_video_tx/tmds_blue/mux9_syn_158 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_video_tx/tmds_blue/mux9_syn_159  (
    .a(\u_video_tx/cx [3]),
    .b(\u_video_tx/cx [4]),
    .c(\u_video_tx/cx [8]),
    .d(\u_video_tx/cx [9]),
    .o(\u_video_tx/tmds_blue/mux9_syn_160 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*A)"),
    .INIT(16'h0008))
    \u_video_tx/tmds_blue/mux9_syn_161  (
    .a(\u_video_tx/tmds_blue/mux9_syn_158 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_160 ),
    .c(\u_video_tx/cx [5]),
    .d(\u_video_tx/cx [6]),
    .o(\u_video_tx/tmds_blue/mux9_syn_162 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_blue/mux9_syn_163  (
    .a(\u_video_tx/packet_ecc/parity4 [7]),
    .b(\u_video_tx/packet_ecc/parity4 [6]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_blue/mux9_syn_164 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hf053))
    \u_video_tx/tmds_blue/mux9_syn_165  (
    .a(\u_video_tx/packet_ecc/parity4 [4]),
    .b(\u_video_tx/packet_ecc/parity4 [5]),
    .c(\u_video_tx/tmds_blue/mux9_syn_164 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_blue/mux9_syn_166 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(A*(C*~(D)*~(B)+C*D*~(B)+~(C)*D*B+C*D*B))"),
    .INIT(16'ha820))
    \u_video_tx/tmds_blue/mux9_syn_167  (
    .a(\u_video_tx/packet_ecc/mux9_syn_57 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/parity4 [0]),
    .d(\u_video_tx/packet_ecc/parity4 [1]),
    .o(\u_video_tx/tmds_blue/mux9_syn_168 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(A*(C*~(D)*~(B)+C*D*~(B)+~(C)*D*B+C*D*B))"),
    .INIT(16'ha820))
    \u_video_tx/tmds_blue/mux9_syn_169  (
    .a(\u_video_tx/tmds_green/mux7_syn_129 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/parity4 [2]),
    .d(\u_video_tx/packet_ecc/parity4 [3]),
    .o(\u_video_tx/tmds_blue/mux9_syn_170 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~B*~A*~(D*~C))"),
    .INIT(16'h1011))
    \u_video_tx/tmds_blue/mux9_syn_171  (
    .a(\u_video_tx/tmds_blue/mux9_syn_168 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_170 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_166 ),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_blue/mux9_syn_172 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(A*~(~C*~B))"),
    .INIT(8'ha8))
    \u_video_tx/tmds_blue/mux9_syn_173  (
    .a(\u_video_tx/tmds_blue/mux9_syn_142 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_172 ),
    .c(\u_video_tx/packet_ecc/parity4_b3_n ),
    .o(\u_video_tx/tmds_blue/mux6_syn_196 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/tmds_blue/mux9_syn_174  (
    .a(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .b(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .o(\u_video_tx/tmds_blue/data_guard_band_b_n ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*(~(A)*~(C)*~(D)*~(E)+A*~(C)*~(D)*~(E)+~(A)*C*D*~(E)+A*~(C)*~(D)*E+~(A)*C*~(D)*E+A*C*~(D)*E+~(A)*~(C)*D*E+A*C*D*E))"),
    .INIT(32'h84c8400c))
    \u_video_tx/tmds_blue/mux9_syn_175  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .e(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_176 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(C*~(A*~(~E*~(D)*~(B)+~E*D*~(B)+~(~E)*D*B+~E*D*B)))"),
    .INIT(32'hd050f070))
    \u_video_tx/tmds_blue/mux9_syn_177  (
    .a(\u_video_tx/tmds_green/mux7_syn_158 ),
    .b(\u_video_tx/tmds_green/mux7_syn_156 ),
    .c(\u_video_tx/tmds_green/mux7_syn_154 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .e(\u_video_tx/tmds_blue/acc [4]),
    .o(\u_video_tx/tmds_blue/mux9_syn_178 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(~D*~C)*~(B*~A))"),
    .INIT(16'hbbb0))
    \u_video_tx/tmds_blue/mux9_syn_179  (
    .a(\u_video_tx/tmds_blue/mux9_syn_176 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_178 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_156 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_79 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_blue/mux9_syn_180  (
    .a(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .b(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_181 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(C*~(A*~(E*~(D)*~(B)+E*D*~(B)+~(E)*D*B+E*D*B)))"),
    .INIT(32'hf070d050))
    \u_video_tx/tmds_blue/mux9_syn_182  (
    .a(\u_video_tx/tmds_green/mux7_syn_158 ),
    .b(\u_video_tx/tmds_green/mux7_syn_156 ),
    .c(\u_video_tx/tmds_green/mux7_syn_154 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .e(\u_video_tx/tmds_blue/acc [4]),
    .o(\u_video_tx/tmds_blue/mux9_syn_183 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*~(B)*C*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h5a27))
    \u_video_tx/tmds_blue/mux9_syn_184  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_156 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .d(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux6_syn_158 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(~B*~(D*~(C*~A)))"),
    .INIT(16'hefcc))
    \u_video_tx/tmds_blue/mux9_syn_185  (
    .a(\u_video_tx/tmds_blue/mux6_syn_158 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_181 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_blue/mux9_syn_183 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_87 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~B*(~(A)*~(C)*~(D)*~(E)+A*~(C)*~(D)*~(E)+~(A)*C*D*~(E)+~(A)*~(C)*~(D)*E+A*~(C)*~(D)*E+~(A)*C*~(D)*E+~(A)*~(C)*D*E))"),
    .INIT(32'h01131003))
    \u_video_tx/tmds_blue/mux9_syn_186  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_green/mux7_syn_156 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .e(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_187 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~(~E*C)*~(B*~(~D*~A)))"),
    .INIT(32'h33770307))
    \u_video_tx/tmds_blue/mux9_syn_188  (
    .a(\u_video_tx/tmds_blue/mux9_syn_187 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_178 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_156 ),
    .d(\u_video_tx/tmds_green/mux7_syn_158 ),
    .e(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_99 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*(~(E@D)*~(C)*~(A)+~(E@D)*C*~(A)+~(~(E@D))*C*A+~(E@D)*C*A))"),
    .INIT(32'hc48080c4))
    \u_video_tx/tmds_blue/mux9_syn_189  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ),
    .d(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .e(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_190 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(~D*C)*~(B*~A))"),
    .INIT(16'hbb0b))
    \u_video_tx/tmds_blue/mux9_syn_191  (
    .a(\u_video_tx/tmds_blue/mux9_syn_190 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_178 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_23 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*(~(A)*C*~(D)*~(E)+A*C*~(D)*~(E)+~(A)*~(C)*D*~(E)+~(A)*C*D*~(E)+~(A)*~(C)*~(D)*E+A*~(C)*~(D)*E+A*C*~(D)*E+~(A)*C*D*E))"),
    .INIT(32'h408c44c0))
    \u_video_tx/tmds_blue/mux9_syn_192  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .e(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_193 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(~D*C)*~(B*~A))"),
    .INIT(16'hbb0b))
    \u_video_tx/tmds_blue/mux9_syn_194  (
    .a(\u_video_tx/tmds_blue/mux9_syn_193 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_178 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_35 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*(~(A)*~(C)*~(D)*~(E)+A*~(C)*~(D)*~(E)+~(A)*C*~(D)*~(E)+~(A)*C*D*~(E)+A*~(C)*~(D)*E+A*C*~(D)*E+~(A)*~(C)*D*E))"),
    .INIT(32'h0488404c))
    \u_video_tx/tmds_blue/mux9_syn_195  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .e(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_196 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(~(~D*C)*~(B*~A))"),
    .INIT(16'h44f4))
    \u_video_tx/tmds_blue/mux9_syn_197  (
    .a(\u_video_tx/tmds_blue/mux9_syn_196 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_183 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_47 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~B*(~(A)*~(C)*~(D)*~(E)+~(A)*C*~(D)*~(E)+A*C*~(D)*~(E)+~(A)*C*D*~(E)+A*~(C)*~(D)*E+A*C*~(D)*E+~(A)*~(C)*D*E+A*C*D*E))"),
    .INIT(32'h21221031))
    \u_video_tx/tmds_blue/mux9_syn_198  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_green/mux7_syn_156 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .e(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_199 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(C*~(~D*~A)))"),
    .INIT(16'h0313))
    \u_video_tx/tmds_blue/mux9_syn_200  (
    .a(\u_video_tx/tmds_blue/mux9_syn_199 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_181 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_178 ),
    .d(\u_video_tx/tmds_green/mux7_syn_158 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_55 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~B*(~(A)*~(C)*~(D)*~(E)+A*~(C)*~(D)*~(E)+A*C*D*~(E)+~(A)*~(C)*~(D)*E+~(A)*C*~(D)*E+~(A)*~(C)*D*E+A*~(C)*D*E))"),
    .INIT(32'h03112003))
    \u_video_tx/tmds_blue/mux9_syn_201  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_green/mux7_syn_156 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .e(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_59 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("~(~(~E*C)*~(B*~(~D*~A)))"),
    .INIT(32'hcc88fcf8))
    \u_video_tx/tmds_blue/mux9_syn_202  (
    .a(\u_video_tx/tmds_blue/mux9_syn_59 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_183 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ),
    .d(\u_video_tx/tmds_green/mux7_syn_158 ),
    .e(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_67 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'haa3d))
    \u_video_tx/tmds_blue/mux9_syn_203  (
    .a(\u_video_tx/tmds_blue/mux6_syn_196 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .c(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .d(\u_video_tx/tmds_blue/mux9_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux6_syn_200 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(~B*~(~C*~A))"),
    .INIT(8'h32))
    \u_video_tx/tmds_blue/mux9_syn_204  (
    .a(\u_video_tx/tmds_blue/mux6_syn_200 ),
    .b(\u_video_tx/tmds_green/mux7_syn_158 ),
    .c(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_205 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*~((E@C)*~(A)*~(D)+(E@C)*A*~(D)+~((E@C))*A*D+(E@C)*A*D))"),
    .INIT(32'h44c0440c))
    \u_video_tx/tmds_blue/mux9_syn_206  (
    .a(\u_video_tx/tmds_blue/mux9_syn_156 ),
    .b(\u_video_tx/tmds_green/mux7_syn_158 ),
    .c(\u_video_tx/tmds_blue/video_data[7]_syn_2 ),
    .d(\u_video_tx/tmds_green/mux7_syn_156 ),
    .e(\u_video_tx/tmds_blue/acc [4]),
    .o(\u_video_tx/tmds_blue/mux9_syn_207 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(C*~((~B*~A))*~(D)+C*(~B*~A)*~(D)+~(C)*(~B*~A)*D+C*(~B*~A)*D)"),
    .INIT(16'hee0f))
    \u_video_tx/tmds_blue/mux9_syn_208  (
    .a(\u_video_tx/tmds_blue/mux9_syn_205 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_207 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_123 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B*~(D)*~(C)+B*D*~(C)+~(B)*D*C+B*D*C))"),
    .INIT(16'h02a2))
    \u_video_tx/tmds_blue/mux9_syn_209  (
    .a(\u_video_tx/tmds_green/mux7_syn_158 ),
    .b(\u_video_tx/tmds_blue/video_data[7]_syn_2 ),
    .c(\u_video_tx/tmds_green/mux7_syn_156 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_16 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_210 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(C*~((~B*~A))*~(D)+C*(~B*~A)*~(D)+~(C)*(~B*~A)*D+C*(~B*~A)*D)"),
    .INIT(16'h11f0))
    \u_video_tx/tmds_blue/mux9_syn_211  (
    .a(\u_video_tx/tmds_blue/mux9_syn_205 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_210 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_111 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_23 ),
    .q(\u_video_tx/tmds_blue/tmds [0]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_35 ),
    .q(\u_video_tx/tmds_blue/tmds [1]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_47 ),
    .q(\u_video_tx/tmds_blue/tmds [2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[3]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_55 ),
    .q(\u_video_tx/tmds_blue/tmds [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_67 ),
    .q(\u_video_tx/tmds_blue/tmds [4]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[5]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_79 ),
    .q(\u_video_tx/tmds_blue/tmds [5]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[6]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_87 ),
    .q(\u_video_tx/tmds_blue/tmds [6]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[7]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_99 ),
    .q(\u_video_tx/tmds_blue/tmds [7]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[8]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_111 ),
    .q(\u_video_tx/tmds_blue/tmds [8]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_blue/tmds_reg[9]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_blue/mux9_syn_123 ),
    .q(\u_video_tx/tmds_blue/tmds [9]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_green/acc_add[3]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_134 ),
    .b(\u_video_tx/tmds_green/acc [4]),
    .o(\u_video_tx/tmds_green/acc_add[3]_syn_2 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_video_tx/tmds_green/acc_add[3]_syn_4  (
    .a(\u_video_tx/tmds_green/acc_add[3]_syn_2 ),
    .o(\u_video_tx/tmds_green/acc_add [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_green/acc_reg[1]_syn_4"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_video_tx/tmds_green/acc_reg[1]_syn_4  (
    .a({\u_video_tx/tmds_green/acc [1],1'b0}),
    .b({\u_video_tx/tmds_green/acc [4],open_n3016}),
    .clk(\u_build_id/clk ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_green/add1_syn_24 ),
    .q({\u_video_tx/tmds_green/acc [1],open_n3038}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_green/acc_reg[1]_syn_4"),
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
    \u_video_tx/tmds_green/acc_reg[3]_syn_4  (
    .a(\u_video_tx/tmds_green/acc [3:2]),
    .b({\u_video_tx/tmds_green/acc_add [3],\u_video_tx/tmds_green/acc_add[3]_syn_2 }),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_green/add1_syn_24 ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_green/add1_syn_26 ),
    .q(\u_video_tx/tmds_green/acc [3:2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_green/acc_reg[1]_syn_4"),
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
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_video_tx/tmds_green/acc_reg[4]_syn_4  (
    .a({open_n3059,1'b0}),
    .b({open_n3060,1'b1}),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_green/add1_syn_26 ),
    .sr(\u_video_tx/active ),
    .q({open_n3082,\u_video_tx/tmds_green/acc [4]}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_green/mux7_syn_116  (
    .a(\u_video_tx/data_island_guard_n4 ),
    .b(\u_video_tx/data_island_guard_n5 ),
    .o(\u_video_tx/tmds_green/mux7_syn_117 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("~(B*A)"),
    .INIT(4'h7))
    \u_video_tx/tmds_green/mux7_syn_118  (
    .a(\u_video_tx/packet_ecc/counter [3]),
    .b(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/parity4_b3_n ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("~(B*~A)"),
    .INIT(4'hb))
    \u_video_tx/tmds_green/mux7_syn_119  (
    .a(\u_video_tx/packet_ecc/parity4_b3_n ),
    .b(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/packet_ecc/parity0_b1_n ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_video_tx/tmds_green/mux7_syn_120  (
    .a(\u_video_tx/cy [5]),
    .b(\u_video_tx/cy [6]),
    .c(\u_video_tx/cy [7]),
    .d(\u_video_tx/cy [8]),
    .o(\u_video_tx/tmds_green/mux7_syn_121 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*~A*~(D*~(~C*~B)))"),
    .INIT(32'h00000155))
    \u_video_tx/tmds_green/mux7_syn_122  (
    .a(\u_video_tx/tmds_green/mux7_syn_121 ),
    .b(\u_video_tx/cx [7]),
    .c(\u_video_tx/cx [8]),
    .d(\u_video_tx/cx [9]),
    .e(\u_video_tx/cy [9]),
    .o(\u_video_tx/active ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \u_video_tx/tmds_green/mux7_syn_123  (
    .a(\u_video_tx/cy [6]),
    .b(\u_video_tx/cy [7]),
    .c(\u_video_tx/cy [8]),
    .o(\u_video_tx/tmds_green/mux7_syn_124 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~C*B*A)"),
    .INIT(32'h00000008))
    \u_video_tx/tmds_green/mux7_syn_125  (
    .a(\u_video_tx/tmds_green/mux7_syn_124 ),
    .b(\u_video_tx/cy [0]),
    .c(\u_video_tx/cy [1]),
    .d(\u_video_tx/cy [3]),
    .e(\u_video_tx/cy [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_126 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_video_tx/tmds_green/mux7_syn_127  (
    .a(\u_video_tx/tmds_green/mux7_syn_126 ),
    .b(\u_video_tx/cy [2]),
    .c(\u_video_tx/cy [5]),
    .d(\u_video_tx/cy [9]),
    .o(\u_video_tx/mode_b1_n5 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_video_tx/tmds_green/mux7_syn_128  (
    .a(\u_video_tx/packet_ecc/counter [1]),
    .b(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_green/mux7_syn_129 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \u_video_tx/tmds_green/mux7_syn_130  (
    .a(\u_video_tx/tmds_green/mux7_syn_126 ),
    .b(\u_video_tx/cy [2]),
    .c(\u_video_tx/cy [5]),
    .d(\u_video_tx/cy [9]),
    .o(\u_video_tx/tmds_green/mux7_syn_131 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*A)"),
    .INIT(16'h0008))
    \u_video_tx/tmds_green/mux7_syn_132  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_129 ),
    .c(\u_video_tx/packet_ecc/counter [3]),
    .d(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/mux3_syn_26 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~D*~(C*~(~B*~A)))"),
    .INIT(16'h001f))
    \u_video_tx/tmds_green/mux7_syn_133  (
    .a(\u_video_tx/cx [6]),
    .b(\u_video_tx/cx [7]),
    .c(\u_video_tx/cx [8]),
    .d(\u_video_tx/cx [9]),
    .o(\u_video_tx/tmds_green/mux7_syn_134 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+A*B*~(C)*D*E)"),
    .INIT(32'h0bba9efa))
    \u_video_tx/tmds_green/mux7_syn_135  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_136 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_green/mux7_syn_137  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_136 ),
    .o(\u_video_tx/packet_ecc/mux1_syn_52 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'haab0))
    \u_video_tx/tmds_green/mux7_syn_138  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/tmds_green/mux7_syn_139 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(~B*(C@A))"),
    .INIT(8'h12))
    \u_video_tx/tmds_green/mux7_syn_140  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/tmds_green/mux7_syn_141 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(A*(B*~((~D*~C))*~(E)+B*(~D*~C)*~(E)+~(B)*(~D*~C)*E+B*(~D*~C)*E))"),
    .INIT(32'h000a8888))
    \u_video_tx/tmds_green/mux7_syn_142  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_139 ),
    .c(\u_video_tx/tmds_green/mux7_syn_141 ),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/mux2_syn_52 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+A*~(B)*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*C*D*~(E)+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hf5664353))
    \u_video_tx/tmds_green/mux7_syn_143  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_144 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~C*~B*A)"),
    .INIT(32'h00000002))
    \u_video_tx/tmds_green/mux7_syn_145  (
    .a(\u_video_tx/tmds_green/mux7_syn_124 ),
    .b(\u_video_tx/cy [0]),
    .c(\u_video_tx/cy [1]),
    .d(\u_video_tx/cy [3]),
    .e(\u_video_tx/cy [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_146 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \u_video_tx/tmds_green/mux7_syn_147  (
    .a(\u_video_tx/tmds_green/mux7_syn_146 ),
    .b(\u_video_tx/cy [2]),
    .c(\u_video_tx/cy [5]),
    .d(\u_video_tx/cy [9]),
    .o(\u_video_tx/tmds_green/mux7_syn_148 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~C*~(B*~A))"),
    .INIT(32'h0000000b))
    \u_video_tx/tmds_green/mux7_syn_149  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_150 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(D*B)*~(~C*A))"),
    .INIT(16'h31f5))
    \u_video_tx/tmds_green/mux7_syn_151  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_148 ),
    .c(\u_video_tx/tmds_green/mux7_syn_144 ),
    .d(\u_video_tx/tmds_green/mux7_syn_150 ),
    .o(\u_video_tx/tmds_green/mux7_syn_152 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(D*C)*~(B*~A))"),
    .INIT(16'h0bbb))
    \u_video_tx/tmds_green/mux7_syn_153  (
    .a(\u_video_tx/data_island_preamble_n2 ),
    .b(\u_video_tx/data_island_guard_n4 ),
    .c(\u_video_tx/data_island_guard_n5 ),
    .d(\u_video_tx/data_island_guard_n6 ),
    .o(\u_video_tx/tmds_green/mux7_syn_154 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_green/mux7_syn_155  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/active ),
    .o(\u_video_tx/tmds_green/mux7_syn_156 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(~C*~(~D*~A)))"),
    .INIT(16'h3031))
    \u_video_tx/tmds_green/mux7_syn_157  (
    .a(\u_video_tx/mode_b1_n5 ),
    .b(\u_video_tx/tmds_green/mux7_syn_117 ),
    .c(\u_video_tx/video_preamble_n3 ),
    .d(\u_video_tx/mode_b1_n6 ),
    .o(\u_video_tx/tmds_green/mux7_syn_158 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_green/mux7_syn_159  (
    .a(\u_video_tx/tmds_green/mux7_syn_158 ),
    .b(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_green/mux7_syn_160 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*B))"),
    .INIT(8'h2a))
    \u_video_tx/tmds_green/mux7_syn_161  (
    .a(\u_video_tx/tmds_green/mux7_syn_156 ),
    .b(\u_video_tx/data_island_preamble_n1 ),
    .c(\u_video_tx/data_island_preamble_n2 ),
    .o(\u_video_tx/tmds_green/mux7_syn_162 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(A*~(D*C*~(~E*~B)))"),
    .INIT(32'h0aaa2aaa))
    \u_video_tx/tmds_green/mux7_syn_163  (
    .a(\u_video_tx/tmds_green/mux7_syn_162 ),
    .b(\u_video_tx/mode_b1_n5 ),
    .c(\u_video_tx/video_preamble_n2 ),
    .d(\u_video_tx/video_preamble_n3 ),
    .e(\u_video_tx/mode_b1_n6 ),
    .o(\u_video_tx/tmds_green/mux7_syn_164 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(B*~(~A*~(D*~C)))"),
    .INIT(16'h8c88))
    \u_video_tx/tmds_green/mux7_syn_165  (
    .a(\u_video_tx/tmds_green/mux7_syn_164 ),
    .b(\u_video_tx/tmds_green/mux7_syn_158 ),
    .c(\u_video_tx/tmds_green/mux7_syn_156 ),
    .d(\u_video_tx/tmds_green/acc [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_166 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_green/mux7_syn_167  (
    .a(\u_video_tx/packet_ecc/bch3 [62]),
    .b(\u_video_tx/packet_ecc/bch3 [60]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_168 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_green/mux7_syn_169  (
    .a(\u_video_tx/packet_ecc/bch3 [56]),
    .b(\u_video_tx/packet_ecc/bch3 [58]),
    .c(\u_video_tx/tmds_green/mux7_syn_168 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux27_syn_182 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u_video_tx/tmds_green/mux7_syn_170  (
    .a(\u_video_tx/packet_ecc/mux3_syn_26 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux27_syn_182 ),
    .o(\u_video_tx/tmds_green/mux7_syn_171 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_green/mux7_syn_172  (
    .a(\u_video_tx/packet_ecc/bch0 [62]),
    .b(\u_video_tx/packet_ecc/bch0 [60]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_173 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_green/mux7_syn_174  (
    .a(\u_video_tx/packet_ecc/bch0 [56]),
    .b(\u_video_tx/packet_ecc/bch0 [58]),
    .c(\u_video_tx/tmds_green/mux7_syn_173 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux27_syn_62 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*~B))"),
    .INIT(8'h8a))
    \u_video_tx/tmds_green/mux7_syn_175  (
    .a(\u_video_tx/tmds_green/mux7_syn_152 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux27_syn_62 ),
    .o(\u_video_tx/tmds_green/mux7_syn_176 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_green/mux7_syn_177  (
    .a(\u_video_tx/packet_ecc/bch1 [62]),
    .b(\u_video_tx/packet_ecc/bch1 [60]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_178 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_green/mux7_syn_179  (
    .a(\u_video_tx/packet_ecc/bch1 [56]),
    .b(\u_video_tx/packet_ecc/bch1 [58]),
    .c(\u_video_tx/tmds_green/mux7_syn_178 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux27_syn_110 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u_video_tx/tmds_green/mux7_syn_180  (
    .a(\u_video_tx/packet_ecc/mux1_syn_52 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux27_syn_110 ),
    .o(\u_video_tx/tmds_green/mux7_syn_181 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_green/mux7_syn_182  (
    .a(\u_video_tx/packet_ecc/bch2 [62]),
    .b(\u_video_tx/packet_ecc/bch2 [60]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_183 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_green/mux7_syn_184  (
    .a(\u_video_tx/packet_ecc/bch2 [56]),
    .b(\u_video_tx/packet_ecc/bch2 [58]),
    .c(\u_video_tx/tmds_green/mux7_syn_183 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux27_syn_148 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u_video_tx/tmds_green/mux7_syn_185  (
    .a(\u_video_tx/packet_ecc/mux2_syn_52 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux27_syn_148 ),
    .o(\u_video_tx/tmds_green/mux6_syn_196 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+A*~(B)*C*D+~(A)*B*C*D))"),
    .INIT(32'h00006d2b))
    \u_video_tx/tmds_green/mux7_syn_186  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_171 ),
    .c(\u_video_tx/tmds_green/mux7_syn_181 ),
    .d(\u_video_tx/tmds_green/mux6_syn_196 ),
    .e(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_green/mux7_syn_187 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("~(~A*~(~C*~B))"),
    .INIT(8'hab))
    \u_video_tx/tmds_green/mux7_syn_188  (
    .a(\u_video_tx/tmds_green/mux7_syn_166 ),
    .b(\u_video_tx/tmds_green/mux7_syn_187 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .o(\u_video_tx/tmds_green/mux7_syn_57 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(B*~A*~(~D*~C))"),
    .INIT(16'h4440))
    \u_video_tx/tmds_green/mux7_syn_189  (
    .a(\u_video_tx/tmds_green/mux7_syn_164 ),
    .b(\u_video_tx/tmds_green/mux7_syn_158 ),
    .c(\u_video_tx/tmds_green/mux7_syn_156 ),
    .d(\u_video_tx/tmds_green/acc [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_190 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*(~(A)*~(C)*~(D)*~(E)+A*C*~(D)*~(E)+A*~(C)*D*~(E)+~(A)*~(C)*~(D)*E+A*~(C)*~(D)*E+~(A)*C*~(D)*E+A*C*~(D)*E+A*~(C)*D*E+A*C*D*E))"),
    .INIT(32'h88cc0884))
    \u_video_tx/tmds_green/mux7_syn_191  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_green/mux7_syn_171 ),
    .d(\u_video_tx/tmds_green/mux7_syn_181 ),
    .e(\u_video_tx/tmds_green/mux6_syn_196 ),
    .o(\u_video_tx/tmds_green/mux7_syn_192 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u_video_tx/tmds_green/mux7_syn_193  (
    .a(\u_video_tx/tmds_green/mux7_syn_190 ),
    .b(\u_video_tx/tmds_green/mux7_syn_192 ),
    .o(\u_video_tx/tmds_green/mux7_syn_81 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*B*C*D)"),
    .INIT(16'h4d93))
    \u_video_tx/tmds_green/mux7_syn_194  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_171 ),
    .c(\u_video_tx/tmds_green/mux7_syn_181 ),
    .d(\u_video_tx/tmds_green/mux6_syn_196 ),
    .o(\u_video_tx/tmds_green/mux7_syn_195 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("~(~A*~(C*~B))"),
    .INIT(8'hba))
    \u_video_tx/tmds_green/mux7_syn_196  (
    .a(\u_video_tx/tmds_green/mux7_syn_190 ),
    .b(\u_video_tx/tmds_green/mux7_syn_195 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .o(\u_video_tx/tmds_green/mux7_syn_49 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*(~(A)*~(C)*~(D)*~(E)+~(A)*~(C)*D*~(E)+A*~(C)*D*~(E)+~(A)*~(C)*~(D)*E+~(A)*C*~(D)*E+A*C*~(D)*E+A*~(C)*D*E+~(A)*C*D*E+A*C*D*E))"),
    .INIT(32'hc8c40c04))
    \u_video_tx/tmds_green/mux7_syn_197  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_green/mux7_syn_171 ),
    .d(\u_video_tx/tmds_green/mux7_syn_181 ),
    .e(\u_video_tx/tmds_green/mux6_syn_196 ),
    .o(\u_video_tx/tmds_green/mux7_syn_198 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(~B*(D@C)))"),
    .INIT(16'h5445))
    \u_video_tx/tmds_green/mux7_syn_199  (
    .a(\u_video_tx/tmds_green/mux7_syn_164 ),
    .b(\u_video_tx/tmds_green/mux7_syn_156 ),
    .c(\u_video_tx/tmds_green/mux7_syn_134 ),
    .d(\u_video_tx/tmds_green/acc [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_200 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~B*~(C*~A)))"),
    .INIT(16'hdc00))
    \u_video_tx/tmds_green/mux7_syn_201  (
    .a(\u_video_tx/tmds_green/mux7_syn_200 ),
    .b(\u_video_tx/tmds_green/mux7_syn_198 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_green/mux7_syn_99 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~A*~(C*~B*~(~E*~D)))"),
    .INIT(32'h45454555))
    \u_video_tx/tmds_green/mux7_syn_202  (
    .a(\u_video_tx/tmds_green/mux7_syn_198 ),
    .b(\u_video_tx/tmds_green/mux7_syn_164 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .d(\u_video_tx/tmds_green/mux7_syn_156 ),
    .e(\u_video_tx/tmds_green/mux7_syn_134 ),
    .o(\u_video_tx/tmds_green/mux7_syn_89 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*(~(A)*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+A*~(B)*C*D+A*B*C*D))"),
    .INIT(32'h0000a369))
    \u_video_tx/tmds_green/mux7_syn_203  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_171 ),
    .c(\u_video_tx/tmds_green/mux7_syn_181 ),
    .d(\u_video_tx/tmds_green/mux6_syn_196 ),
    .e(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_green/mux7_syn_204 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/tmds_green/mux7_syn_205  (
    .a(\u_video_tx/tmds_green/mux7_syn_190 ),
    .b(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_green/mux7_syn_206 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("~(A*~(~C*~B))"),
    .INIT(8'h57))
    \u_video_tx/tmds_green/mux7_syn_207  (
    .a(\u_video_tx/tmds_green/mux7_syn_206 ),
    .b(\u_video_tx/tmds_green/mux7_syn_204 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .o(\u_video_tx/tmds_green/mux7_syn_67 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'haf6c))
    \u_video_tx/tmds_green/mux7_syn_208  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_171 ),
    .c(\u_video_tx/tmds_green/mux7_syn_181 ),
    .d(\u_video_tx/tmds_green/mux6_syn_196 ),
    .o(\u_video_tx/tmds_green/mux7_syn_209 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(A*~(~C*~(~D*B)))"),
    .INIT(16'h5f57))
    \u_video_tx/tmds_green/mux7_syn_210  (
    .a(\u_video_tx/tmds_green/mux7_syn_206 ),
    .b(\u_video_tx/tmds_green/mux7_syn_209 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .d(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_green/mux7_syn_23 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+A*B*~(C)*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'hab6c))
    \u_video_tx/tmds_green/mux7_syn_211  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_171 ),
    .c(\u_video_tx/tmds_green/mux7_syn_181 ),
    .d(\u_video_tx/tmds_green/mux6_syn_196 ),
    .o(\u_video_tx/tmds_green/mux6_syn_74 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~A*~(C*B)))"),
    .INIT(16'hea00))
    \u_video_tx/tmds_green/mux7_syn_212  (
    .a(\u_video_tx/tmds_green/mux7_syn_166 ),
    .b(\u_video_tx/tmds_green/mux6_syn_74 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_green/mux7_syn_43 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*(~(A)*~(C)*~(D)*~(E)+A*~(C)*~(D)*~(E)+~(A)*~(C)*D*~(E)+A*C*D*~(E)+~(A)*~(C)*~(D)*E+~(A)*C*~(D)*E+A*C*~(D)*E+A*~(C)*D*E+~(A)*C*D*E))"),
    .INIT(32'h48c4840c))
    \u_video_tx/tmds_green/mux7_syn_213  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_green/mux7_syn_171 ),
    .d(\u_video_tx/tmds_green/mux7_syn_181 ),
    .e(\u_video_tx/tmds_green/mux6_syn_196 ),
    .o(\u_video_tx/tmds_green/mux7_syn_214 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(C*~(~B*~A))"),
    .INIT(8'he0))
    \u_video_tx/tmds_green/mux7_syn_215  (
    .a(\u_video_tx/tmds_green/mux7_syn_166 ),
    .b(\u_video_tx/tmds_green/mux7_syn_214 ),
    .c(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_green/mux7_syn_75 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*B*C*D)"),
    .INIT(16'h456b))
    \u_video_tx/tmds_green/mux7_syn_216  (
    .a(\u_video_tx/tmds_green/mux7_syn_176 ),
    .b(\u_video_tx/tmds_green/mux7_syn_171 ),
    .c(\u_video_tx/tmds_green/mux7_syn_181 ),
    .d(\u_video_tx/tmds_green/mux6_syn_196 ),
    .o(\u_video_tx/tmds_green/mux6_syn_52 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(A*~(~C*~(~D*~B)))"),
    .INIT(16'h5f5d))
    \u_video_tx/tmds_green/mux7_syn_217  (
    .a(\u_video_tx/tmds_green/mux7_syn_206 ),
    .b(\u_video_tx/tmds_green/mux6_syn_52 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .d(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_green/mux7_syn_31 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_23 ),
    .q(\u_video_tx/tmds_green/tmds [0]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_31 ),
    .q(\u_video_tx/tmds_green/tmds [1]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_43 ),
    .q(\u_video_tx/tmds_green/tmds [2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[3]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_49 ),
    .q(\u_video_tx/tmds_green/tmds [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_57 ),
    .q(\u_video_tx/tmds_green/tmds [4]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[5]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_67 ),
    .q(\u_video_tx/tmds_green/tmds [5]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[6]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_75 ),
    .q(\u_video_tx/tmds_green/tmds [6]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[7]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_81 ),
    .q(\u_video_tx/tmds_green/tmds [7]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[8]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_89 ),
    .q(\u_video_tx/tmds_green/tmds [8]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_green/tmds_reg[9]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_green/mux7_syn_99 ),
    .q(\u_video_tx/tmds_green/tmds [9]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/tmds_red/acc_add[3]_syn_3  (
    .a(\rgb_b1[23]_syn_2 ),
    .b(\u_video_tx/tmds_red/acc [4]),
    .o(\u_video_tx/tmds_red/acc_add[3]_syn_2 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_video_tx/tmds_red/acc_add[3]_syn_4  (
    .a(\u_video_tx/tmds_red/acc_add[3]_syn_2 ),
    .o(\u_video_tx/tmds_red/acc_add [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_red/acc_reg[1]_syn_4"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_video_tx/tmds_red/acc_reg[1]_syn_4  (
    .a({\u_video_tx/tmds_red/acc [1],1'b0}),
    .b({\u_video_tx/tmds_red/acc [4],open_n3103}),
    .clk(\u_build_id/clk ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_red/add1_syn_24 ),
    .q({\u_video_tx/tmds_red/acc [1],open_n3125}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_red/acc_reg[1]_syn_4"),
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
    \u_video_tx/tmds_red/acc_reg[3]_syn_4  (
    .a(\u_video_tx/tmds_red/acc [3:2]),
    .b({\u_video_tx/tmds_red/acc_add [3],\u_video_tx/tmds_red/acc_add[3]_syn_2 }),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_red/add1_syn_24 ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_red/add1_syn_26 ),
    .q(\u_video_tx/tmds_red/acc [3:2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/tmds_red/acc_reg[1]_syn_4"),
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
    .SRMODE("SYNC"),
    .SRMUX("INV"))
    \u_video_tx/tmds_red/acc_reg[4]_syn_4  (
    .a({open_n3146,1'b0}),
    .b({open_n3147,1'b1}),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_red/add1_syn_26 ),
    .sr(\u_video_tx/active ),
    .q({open_n3169,\u_video_tx/tmds_red/acc [4]}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_video_tx/tmds_red/mux7_syn_116  (
    .a(\u_video_tx/cx [5]),
    .b(\u_video_tx/cx [6]),
    .c(\u_video_tx/cx [7]),
    .d(\u_video_tx/cx [8]),
    .o(\u_video_tx/tmds_red/mux7_syn_117 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_red/mux7_syn_118  (
    .a(\u_video_tx/packet_ecc/counter [1]),
    .b(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/packet_ecc/mux9_syn_57 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*C*B*A)"),
    .INIT(32'h00000080))
    \u_video_tx/tmds_red/mux7_syn_119  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/packet_ecc/mux9_syn_57 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_120 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~(C*~(~B*~A)))"),
    .INIT(32'h0000001f))
    \u_video_tx/tmds_red/mux7_syn_121  (
    .a(\u_video_tx/cx [5]),
    .b(\u_video_tx/cx [6]),
    .c(\u_video_tx/cx [7]),
    .d(\u_video_tx/cx [8]),
    .e(\u_video_tx/cx [9]),
    .o(\u_video_tx/tmds_red/mux7_syn_122 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(~D*~C*~B))"),
    .INIT(16'h5554))
    \u_video_tx/tmds_red/mux7_syn_123  (
    .a(\u_video_tx/tmds_red/mux7_syn_122 ),
    .b(\u_video_tx/tmds_red/mux7_syn_117 ),
    .c(\u_video_tx/tmds_green/mux7_syn_134 ),
    .d(\u_video_tx/cx [9]),
    .o(\rgb_b1[23]_syn_2 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~(B@A))"),
    .INIT(16'h0090))
    \u_video_tx/tmds_red/mux7_syn_124  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [2]),
    .c(\u_video_tx/packet_ecc/counter [3]),
    .d(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_125 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*A*(C*~(D)*~(E)+~(C)*D*E+C*D*E))"),
    .INIT(32'h88000080))
    \u_video_tx/tmds_red/mux7_syn_126  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/packet_ecc/mux9_syn_57 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_127 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(~D*C*B))"),
    .INIT(16'h5515))
    \u_video_tx/tmds_red/mux7_syn_128  (
    .a(\u_video_tx/tmds_red/mux7_syn_127 ),
    .b(\u_video_tx/tmds_green/mux7_syn_131 ),
    .c(\u_video_tx/tmds_red/mux7_syn_125 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_129 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+A*~(B)*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+A*B*C*D*E)"),
    .INIT(32'hbdbddccb))
    \u_video_tx/tmds_red/mux7_syn_130  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_131 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \u_video_tx/tmds_red/mux7_syn_132  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_red/mux7_syn_131 ),
    .c(\u_video_tx/packet_ecc/parity4_b3_n ),
    .o(\u_video_tx/packet_ecc/mux6_syn_52 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hf513))
    \u_video_tx/tmds_red/mux7_syn_133  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_148 ),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_red/mux7_syn_134 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hf53f))
    \u_video_tx/tmds_red/mux7_syn_135  (
    .a(\u_video_tx/tmds_green/mux7_syn_131 ),
    .b(\u_video_tx/tmds_green/mux7_syn_148 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_red/mux7_syn_136 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("~((~C*~A)*~((~D*~B))*~(E)+(~C*~A)*(~D*~B)*~(E)+~((~C*~A))*(~D*~B)*E+(~C*~A)*(~D*~B)*E)"),
    .INIT(32'hffccfafa))
    \u_video_tx/tmds_red/mux7_syn_137  (
    .a(\u_video_tx/tmds_red/mux7_syn_134 ),
    .b(\u_video_tx/tmds_red/mux7_syn_136 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .e(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/tmds_red/mux7_syn_138 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("~(~A*~((D*C*B))*~(E)+~A*(D*C*B)*~(E)+~(~A)*(D*C*B)*E+~A*(D*C*B)*E)"),
    .INIT(32'h3fffaaaa))
    \u_video_tx/tmds_red/mux7_syn_139  (
    .a(\u_video_tx/tmds_red/mux7_syn_138 ),
    .b(\u_video_tx/tmds_green/mux7_syn_131 ),
    .c(\u_video_tx/packet_ecc/mux9_syn_57 ),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_140 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(B*~(~A*~(D*~C)))"),
    .INIT(16'h8c88))
    \u_video_tx/tmds_red/mux7_syn_141  (
    .a(\u_video_tx/tmds_green/mux7_syn_162 ),
    .b(\u_video_tx/tmds_green/mux7_syn_158 ),
    .c(\u_video_tx/tmds_green/mux7_syn_156 ),
    .d(\u_video_tx/tmds_red/acc [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_142 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_red/mux7_syn_143  (
    .a(\u_video_tx/packet_ecc/bch2 [63]),
    .b(\u_video_tx/packet_ecc/bch2 [61]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_144 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_red/mux7_syn_145  (
    .a(\u_video_tx/packet_ecc/bch2 [57]),
    .b(\u_video_tx/packet_ecc/bch2 [59]),
    .c(\u_video_tx/tmds_red/mux7_syn_144 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux26_syn_148 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u_video_tx/tmds_red/mux7_syn_146  (
    .a(\u_video_tx/packet_ecc/mux6_syn_52 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux26_syn_148 ),
    .o(\u_video_tx/tmds_red/mux6_syn_196 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_red/mux7_syn_147  (
    .a(\u_video_tx/packet_ecc/bch3 [63]),
    .b(\u_video_tx/packet_ecc/bch3 [61]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_148 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_red/mux7_syn_149  (
    .a(\u_video_tx/packet_ecc/bch3 [57]),
    .b(\u_video_tx/packet_ecc/bch3 [59]),
    .c(\u_video_tx/tmds_red/mux7_syn_148 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux26_syn_182 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u_video_tx/tmds_red/mux7_syn_150  (
    .a(\u_video_tx/tmds_red/mux7_syn_120 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux26_syn_182 ),
    .o(\u_video_tx/tmds_red/mux7_syn_151 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_red/mux7_syn_152  (
    .a(\u_video_tx/packet_ecc/bch1 [63]),
    .b(\u_video_tx/packet_ecc/bch1 [61]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_153 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_red/mux7_syn_154  (
    .a(\u_video_tx/packet_ecc/bch1 [57]),
    .b(\u_video_tx/packet_ecc/bch1 [59]),
    .c(\u_video_tx/tmds_red/mux7_syn_153 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux26_syn_110 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*~B))"),
    .INIT(8'h8a))
    \u_video_tx/tmds_red/mux7_syn_155  (
    .a(\u_video_tx/tmds_red/mux7_syn_129 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux26_syn_110 ),
    .o(\u_video_tx/tmds_red/mux7_syn_156 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_red/mux7_syn_157  (
    .a(\u_video_tx/packet_ecc/bch0 [63]),
    .b(\u_video_tx/packet_ecc/bch0 [61]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_158 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_red/mux7_syn_159  (
    .a(\u_video_tx/packet_ecc/bch0 [57]),
    .b(\u_video_tx/packet_ecc/bch0 [59]),
    .c(\u_video_tx/tmds_red/mux7_syn_158 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux26_syn_62 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*~B))"),
    .INIT(8'h8a))
    \u_video_tx/tmds_red/mux7_syn_160  (
    .a(\u_video_tx/tmds_red/mux7_syn_140 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux26_syn_62 ),
    .o(\u_video_tx/tmds_red/mux7_syn_161 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h729b))
    \u_video_tx/tmds_red/mux7_syn_162  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_151 ),
    .o(\u_video_tx/tmds_red/mux7_syn_163 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(C*~A))"),
    .INIT(8'hdc))
    \u_video_tx/tmds_red/mux7_syn_164  (
    .a(\u_video_tx/tmds_red/mux7_syn_163 ),
    .b(\u_video_tx/tmds_red/mux7_syn_142 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .o(\u_video_tx/tmds_red/mux7_syn_57 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(B*~A*~(~D*~C))"),
    .INIT(16'h4440))
    \u_video_tx/tmds_red/mux7_syn_165  (
    .a(\u_video_tx/tmds_green/mux7_syn_162 ),
    .b(\u_video_tx/tmds_green/mux7_syn_158 ),
    .c(\u_video_tx/tmds_green/mux7_syn_156 ),
    .d(\u_video_tx/tmds_red/acc [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_166 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'hb2b9))
    \u_video_tx/tmds_red/mux7_syn_167  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_151 ),
    .o(\u_video_tx/tmds_red/mux6_syn_178 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(~B*~(~C*~(~D*~A)))"),
    .INIT(16'hcfce))
    \u_video_tx/tmds_red/mux7_syn_168  (
    .a(\u_video_tx/tmds_red/mux6_syn_178 ),
    .b(\u_video_tx/tmds_red/mux7_syn_166 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .d(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_red/mux7_syn_81 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D))"),
    .INIT(32'h00007817))
    \u_video_tx/tmds_red/mux7_syn_169  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_151 ),
    .e(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_red/mux7_syn_170 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(~C*~A))"),
    .INIT(8'hcd))
    \u_video_tx/tmds_red/mux7_syn_171  (
    .a(\u_video_tx/tmds_red/mux7_syn_170 ),
    .b(\u_video_tx/tmds_red/mux7_syn_166 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .o(\u_video_tx/tmds_red/mux7_syn_49 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(C*(A*~(B)*~(D)*~(E)+A*~(B)*D*~(E)+~(A)*B*D*~(E)+~(A)*~(B)*~(D)*E+A*~(B)*~(D)*E+~(A)*B*~(D)*E+A*B*~(D)*E))"),
    .INIT(32'h00f06020))
    \u_video_tx/tmds_red/mux7_syn_172  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_red/mux6_syn_196 ),
    .e(\u_video_tx/tmds_red/mux7_syn_151 ),
    .o(\u_video_tx/tmds_red/mux7_syn_173 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(B*~A*~(~C*~(E@D)))"),
    .INIT(32'h40444440))
    \u_video_tx/tmds_red/mux7_syn_174  (
    .a(\u_video_tx/tmds_green/mux7_syn_162 ),
    .b(\u_video_tx/tmds_green/mux7_syn_158 ),
    .c(\u_video_tx/tmds_green/mux7_syn_156 ),
    .d(\rgb_b1[23]_syn_2 ),
    .e(\u_video_tx/tmds_red/acc [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_175 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*~A)"),
    .INIT(8'h10))
    \u_video_tx/tmds_red/mux7_syn_176  (
    .a(\u_video_tx/tmds_red/mux7_syn_173 ),
    .b(\u_video_tx/tmds_red/mux7_syn_175 ),
    .c(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_red/mux7_syn_99 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("~(~A*~(C*~(~B*~(E*~D))))"),
    .INIT(32'heafaeaea))
    \u_video_tx/tmds_red/mux7_syn_177  (
    .a(\u_video_tx/tmds_red/mux7_syn_173 ),
    .b(\u_video_tx/tmds_green/mux7_syn_162 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .d(\u_video_tx/tmds_green/mux7_syn_156 ),
    .e(\rgb_b1[23]_syn_2 ),
    .o(\u_video_tx/tmds_red/mux7_syn_89 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h7946))
    \u_video_tx/tmds_red/mux7_syn_178  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_151 ),
    .o(\u_video_tx/tmds_red/mux6_syn_138 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(D*~B*~(C*A))"),
    .INIT(16'hecff))
    \u_video_tx/tmds_red/mux7_syn_179  (
    .a(\u_video_tx/tmds_red/mux6_syn_138 ),
    .b(\u_video_tx/tmds_red/mux7_syn_166 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_red/mux7_syn_67 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'hb7b8))
    \u_video_tx/tmds_red/mux7_syn_180  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_151 ),
    .o(\u_video_tx/tmds_red/mux7_syn_181 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(D*~B*~(C*~A))"),
    .INIT(16'hdcff))
    \u_video_tx/tmds_red/mux7_syn_182  (
    .a(\u_video_tx/tmds_red/mux7_syn_181 ),
    .b(\u_video_tx/tmds_red/mux7_syn_166 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_red/mux7_syn_23 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*B*C*~(D)+A*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D))"),
    .INIT(32'h00005847))
    \u_video_tx/tmds_red/mux7_syn_183  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_151 ),
    .e(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_red/mux7_syn_184 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~B*~(~C*~A)))"),
    .INIT(16'hcd00))
    \u_video_tx/tmds_red/mux7_syn_185  (
    .a(\u_video_tx/tmds_red/mux7_syn_184 ),
    .b(\u_video_tx/tmds_red/mux7_syn_142 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_red/mux7_syn_43 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT5 #(
    .EQN("(~E*(A*B*~(C)*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*C*D))"),
    .INIT(32'h00008768))
    \u_video_tx/tmds_red/mux7_syn_186  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_151 ),
    .e(\u_video_tx/tmds_green/mux7_syn_156 ),
    .o(\u_video_tx/tmds_red/mux7_syn_187 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~B*~(~C*~A)))"),
    .INIT(16'hcd00))
    \u_video_tx/tmds_red/mux7_syn_188  (
    .a(\u_video_tx/tmds_red/mux7_syn_187 ),
    .b(\u_video_tx/tmds_red/mux7_syn_142 ),
    .c(\u_video_tx/tmds_green/mux7_syn_158 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_red/mux7_syn_75 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h561b))
    \u_video_tx/tmds_red/mux7_syn_189  (
    .a(\u_video_tx/tmds_red/mux7_syn_161 ),
    .b(\u_video_tx/tmds_red/mux7_syn_156 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_151 ),
    .o(\u_video_tx/tmds_red/mux6_syn_52 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_LUT4 #(
    .EQN("~(D*~B*~(C*A))"),
    .INIT(16'hecff))
    \u_video_tx/tmds_red/mux7_syn_190  (
    .a(\u_video_tx/tmds_red/mux6_syn_52 ),
    .b(\u_video_tx/tmds_red/mux7_syn_166 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_154 ),
    .o(\u_video_tx/tmds_red/mux7_syn_31 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(140)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_23 ),
    .q(\u_video_tx/tmds_red/tmds [0]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_31 ),
    .q(\u_video_tx/tmds_red/tmds [1]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_43 ),
    .q(\u_video_tx/tmds_red/tmds [2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[3]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_49 ),
    .q(\u_video_tx/tmds_red/tmds [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_57 ),
    .q(\u_video_tx/tmds_red/tmds [4]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[5]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_67 ),
    .q(\u_video_tx/tmds_red/tmds [5]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[6]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_75 ),
    .q(\u_video_tx/tmds_red/tmds [6]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[7]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_81 ),
    .q(\u_video_tx/tmds_red/tmds [7]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[8]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_89 ),
    .q(\u_video_tx/tmds_red/tmds [8]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_video_tx/tmds_red/tmds_reg[9]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/tmds_red/mux7_syn_99 ),
    .q(\u_video_tx/tmds_red/tmds [9]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(139)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[3]_syn_1  (
    .a(\u_video_tx/x_count_b1_n ),
    .b(\u_video_tx/x_count_b3 [3]),
    .o(\u_video_tx/x_count_b1 [3]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[5]_syn_1  (
    .a(\u_video_tx/x_count_b1_n ),
    .b(\u_video_tx/x_count_b3 [5]),
    .o(\u_video_tx/x_count_b1 [5]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[6]_syn_1  (
    .a(\u_video_tx/x_count_b1_n ),
    .b(\u_video_tx/x_count_b3 [6]),
    .o(\u_video_tx/x_count_b1 [6]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[7]_syn_1  (
    .a(\u_video_tx/x_count_b1_n ),
    .b(\u_video_tx/x_count_b3 [7]),
    .o(\u_video_tx/x_count_b1 [7]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[8]_syn_1  (
    .a(\u_video_tx/x_count_b1_n ),
    .b(\u_video_tx/x_count_b3 [8]),
    .o(\u_video_tx/x_count_b1 [8]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[9]_syn_1  (
    .a(\u_video_tx/x_count_b1_n ),
    .b(\u_video_tx/x_count_b3 [9]),
    .o(\u_video_tx/x_count_b1 [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[0]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/cx[0]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [0]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[1]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b3 [1]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [1]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[2]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b3 [2]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [2]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[3]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [3]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [3]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b3 [4]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [4]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[5]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [5]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [5]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[6]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [6]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [6]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[7]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [7]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [7]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[8]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [8]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [8]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[9]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [9]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [9]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/y_count_b3[1]_syn_1  (
    .a(\u_video_tx/mode_b1_n5 ),
    .b(\u_video_tx/y_count_b4 [1]),
    .o(\u_video_tx/y_count_b3 [1]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/y_count_b3[2]_syn_1  (
    .a(\u_video_tx/mode_b1_n5 ),
    .b(\u_video_tx/y_count_b4 [2]),
    .o(\u_video_tx/y_count_b3 [2]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/y_count_b3[5]_syn_1  (
    .a(\u_video_tx/mode_b1_n5 ),
    .b(\u_video_tx/y_count_b4 [5]),
    .o(\u_video_tx/y_count_b3 [5]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/y_count_b3[9]_syn_1  (
    .a(\u_video_tx/mode_b1_n5 ),
    .b(\u_video_tx/y_count_b4 [9]),
    .o(\u_video_tx/y_count_b3 [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[0]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/cy[0]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [0]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[1]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b3 [1]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [1]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[2]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b3 [2]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [2]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[3]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b4 [3]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [3]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[4]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b4 [4]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [4]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[5]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b3 [5]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [5]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[6]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b4 [6]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [6]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[7]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b4 [7]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [7]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[8]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b4 [8]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [8]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[9]  (
    .ce(\u_video_tx/x_count_b1_n ),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b3 [9]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [9]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)

endmodule 

