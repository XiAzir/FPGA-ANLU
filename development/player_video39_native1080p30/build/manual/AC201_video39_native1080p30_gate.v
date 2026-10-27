// Verilog netlist created by Tang Dynasty v6.2.178840
// Tue Oct 27 15:47:11 2026

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
  wire [23:0] rgb_b3;
  wire [19:0] startup_count;  // ../user_source/hdl_source/top.v(20)
  wire [19:0] startup_count_b;
  wire [19:0] startup_count_b4;
  wire [4:0] \u_build_id/bit_count ;  // ../user_source/hdl_source/status_hex595.v(35)
  wire [2:0] \u_build_id/digit_index ;  // ../user_source/hdl_source/status_hex595.v(36)
  wire [31:0] \u_build_id/frame_value ;  // ../user_source/hdl_source/status_hex595.v(33)
  wire [31:0] \u_build_id/half_count ;  // ../user_source/hdl_source/status_hex595.v(32)
  wire [31:0] \u_build_id/half_count_b4 ;
  wire [31:0] \u_build_id/hex_value ;  // ../user_source/hdl_source/status_hex595.v(12)
  wire [15:0] \u_build_id/shift_word ;  // ../user_source/hdl_source/status_hex595.v(34)
  wire [31:0] \u_build_id/slot_count ;  // ../user_source/hdl_source/status_hex595.v(31)
  wire [31:0] \u_build_id/slot_count_b5 ;
  wire [5:0] \u_build_id/state_reg_syn_1 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire [9:0] \u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data_b ;
  wire [9:0] \u_hdmi_phy/u1_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data_b ;
  wire [9:0] \u_hdmi_phy/u2_lane_lvds_8_1/S_pending_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(23)
  wire [9:0] \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data ;  // ../user_source/hdl_source/lane_lvds_10_1.v(22)
  wire [9:0] \u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data_b ;
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
  wire  \u_video_tx/tmds_blue/mux5_syn_17 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(89)
  wire [9:0] \u_video_tx/tmds_blue/tmds ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(11)
  wire [4:0] \u_video_tx/tmds_green/acc ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(13)
  wire [4:0] \u_video_tx/tmds_green/acc_add ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire [9:0] \u_video_tx/tmds_green/tmds ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(11)
  wire [4:0] \u_video_tx/tmds_red/acc ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(13)
  wire [4:0] \u_video_tx/tmds_red/acc_add ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire [9:0] \u_video_tx/tmds_red/tmds ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(11)
  wire [11:0] \u_video_tx/x_count_b1 ;
  wire [11:0] \u_video_tx/x_count_b3 ;
  wire [10:0] \u_video_tx/y_count_b3 ;
  wire [10:0] \u_video_tx/y_count_b4 ;
  wire add0_syn_104;  // ../user_source/hdl_source/top.v(33)
  wire add0_syn_108;  // ../user_source/hdl_source/top.v(33)
  wire add0_syn_112;  // ../user_source/hdl_source/top.v(33)
  wire add0_syn_116;  // ../user_source/hdl_source/top.v(33)
  wire add0_syn_120;  // ../user_source/hdl_source/top.v(33)
  wire frame_seen_reg_syn_3;  // ../user_source/hdl_source/top.v(66)
  wire lt0_syn_7;  // ../user_source/hdl_source/top.v(39)
  wire lt0_syn_11;  // ../user_source/hdl_source/top.v(39)
  wire lt0_syn_15;  // ../user_source/hdl_source/top.v(39)
  wire lt0_syn_19;  // ../user_source/hdl_source/top.v(39)
  wire lt1_syn_7;  // ../user_source/hdl_source/top.v(40)
  wire lt1_syn_11;  // ../user_source/hdl_source/top.v(40)
  wire lt1_syn_15;  // ../user_source/hdl_source/top.v(40)
  wire lt1_syn_19;  // ../user_source/hdl_source/top.v(40)
  wire lt2_syn_7;  // ../user_source/hdl_source/top.v(41)
  wire lt2_syn_11;  // ../user_source/hdl_source/top.v(41)
  wire lt2_syn_15;  // ../user_source/hdl_source/top.v(41)
  wire lt2_syn_19;  // ../user_source/hdl_source/top.v(41)
  wire lt3_syn_7;  // ../user_source/hdl_source/top.v(42)
  wire lt3_syn_11;  // ../user_source/hdl_source/top.v(42)
  wire lt3_syn_15;  // ../user_source/hdl_source/top.v(42)
  wire lt4_syn_7;  // ../user_source/hdl_source/top.v(43)
  wire lt4_syn_11;  // ../user_source/hdl_source/top.v(43)
  wire lt4_syn_15;  // ../user_source/hdl_source/top.v(43)
  wire lt4_syn_19;  // ../user_source/hdl_source/top.v(43)
  wire lt5_syn_7;  // ../user_source/hdl_source/top.v(44)
  wire lt5_syn_11;  // ../user_source/hdl_source/top.v(44)
  wire lt5_syn_15;  // ../user_source/hdl_source/top.v(44)
  wire lt5_syn_19;  // ../user_source/hdl_source/top.v(44)
  wire lt6_syn_7;  // ../user_source/hdl_source/top.v(45)
  wire lt6_syn_11;  // ../user_source/hdl_source/top.v(45)
  wire lt6_syn_15;  // ../user_source/hdl_source/top.v(45)
  wire lt6_syn_19;  // ../user_source/hdl_source/top.v(45)
  wire startup_done_reg_syn_3;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_5;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_7;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_9;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_11;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_13;  // ../user_source/hdl_source/top.v(23)
  wire startup_done_reg_syn_15;  // ../user_source/hdl_source/top.v(23)
  wire clk_dup_1;  // ../user_source/hdl_source/top.v(2)
  wire frame_count_b1_n1;
  wire frame_count_b1_n2;
  wire frame_seen;  // ../user_source/hdl_source/top.v(65)
  wire \led[3]_dup_1 ;  // ../user_source/hdl_source/top.v(4)
  wire \led[2]_dup_1 ;  // ../user_source/hdl_source/top.v(4)
  wire \led[1]_dup_1 ;  // ../user_source/hdl_source/top.v(4)
  wire \led[0]_dup_1 ;  // ../user_source/hdl_source/top.v(4)
  wire \rgb_b1[23]_syn_2 ;
  wire pll_lock;  // ../user_source/hdl_source/top.v(13)
  wire rgb_b1_n;
  wire rgb_b2_n;
  wire rgb_b3_n;
  wire rgb_b4_n;
  wire rgb_b5_n;
  wire rgb_b5_n1;
  wire rgb_b_n;
  wire rst_n_dup_1;  // ../user_source/hdl_source/top.v(3)
  wire serial_clk_raw;  // ../user_source/hdl_source/top.v(13)
  wire startup_done;  // ../user_source/hdl_source/top.v(21)
  wire \u_build_id/add0_syn_91 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_build_id/add0_syn_95 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_build_id/add0_syn_99 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_build_id/add0_syn_103 ;  // ../user_source/hdl_source/status_hex595.v(109)
  wire \u_build_id/add1_syn_34 ;  // ../user_source/hdl_source/status_hex595.v(126)
  wire \u_build_id/add1_syn_36 ;  // ../user_source/hdl_source/status_hex595.v(126)
  wire \u_build_id/add1_syn_38 ;  // ../user_source/hdl_source/status_hex595.v(126)
  wire \u_build_id/lt0_syn_7 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_11 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_15 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_19 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_23 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_27 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_31 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt0_syn_35 ;  // ../user_source/hdl_source/status_hex595.v(100)
  wire \u_build_id/lt1_syn_6 ;  // ../user_source/hdl_source/status_hex595.v(121)
  wire \u_build_id/lt1_syn_10 ;  // ../user_source/hdl_source/status_hex595.v(121)
  wire \u_build_id/lt1_syn_14 ;  // ../user_source/hdl_source/status_hex595.v(121)
  wire \u_build_id/mux2_syn_20 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux4_syn_39 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux4_syn_51 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux4_syn_79 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux4_syn_97 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_118 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_130 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_142 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_154 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_166 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_178 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_190 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_202 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_214 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_226 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_238 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_250 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_262 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_274 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_286 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_298 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_310 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux5_syn_342 ;  // ../user_source/hdl_source/status_hex595.v(96)
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
  wire \u_build_id/mux7_syn_646 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_650 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_653 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_656 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux7_syn_660 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/mux8_syn_187 ;  // ../user_source/hdl_source/status_hex595.v(96)
  wire \u_build_id/tx_is_blank_reg_syn_3 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/bit_count_b3_n ;
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
  wire \u_video_tx/add0_syn_59 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  wire \u_video_tx/add0_syn_63 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  wire \u_video_tx/add1_syn_64 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  wire \u_video_tx/add1_syn_68 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  wire \u_video_tx/add1_syn_72 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  wire \u_video_tx/lt0_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  wire \u_video_tx/lt0_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  wire \u_video_tx/lt0_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  wire \u_video_tx/lt0_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  wire \u_video_tx/lt0_syn_23 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  wire \u_video_tx/lt1_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  wire \u_video_tx/lt1_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  wire \u_video_tx/lt1_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  wire \u_video_tx/lt1_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  wire \u_video_tx/lt1_syn_22 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  wire \u_video_tx/lt11_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  wire \u_video_tx/lt11_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  wire \u_video_tx/lt11_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  wire \u_video_tx/lt11_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  wire \u_video_tx/lt12_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt12_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt12_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt12_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt12_syn_22 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt13_syn_23 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  wire \u_video_tx/lt15_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_23 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt15_syn_27 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  wire \u_video_tx/lt16_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_23 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt16_syn_27 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  wire \u_video_tx/lt17_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  wire \u_video_tx/lt17_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  wire \u_video_tx/lt17_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  wire \u_video_tx/lt17_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  wire \u_video_tx/lt2_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt2_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt2_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt2_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt2_syn_22 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  wire \u_video_tx/lt3_syn_5 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt3_syn_9 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt3_syn_13 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt3_syn_17 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt3_syn_21 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt3_syn_25 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  wire \u_video_tx/lt5_syn_6 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt5_syn_10 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt5_syn_14 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt5_syn_18 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt5_syn_22 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt5_syn_26 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_7 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_11 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_15 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_19 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_23 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt6_syn_27 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  wire \u_video_tx/lt8_syn_5 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_9 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_13 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_17 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_21 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/lt8_syn_25 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  wire \u_video_tx/cx[0]_syn_2 ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(18)
  wire \u_video_tx/x_count_b1[11]_syn_2 ;
  wire \u_video_tx/active ;  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(20)
  wire \u_video_tx/active_n2 ;
  wire \u_video_tx/data_island_guard_n4 ;
  wire \u_video_tx/data_island_guard_n5 ;
  wire \u_video_tx/data_island_guard_n6 ;
  wire \u_video_tx/data_island_preamble_n1 ;
  wire \u_video_tx/data_island_preamble_n2 ;
  wire \u_video_tx/hsync_pulse_n2 ;
  wire \u_video_tx/mode_b1_n6 ;
  wire \u_video_tx/video_preamble_n2 ;
  wire \u_video_tx/video_preamble_n3 ;
  wire \u_video_tx/vsync_n1 ;
  wire \u_video_tx/vsync_n2 ;
  wire \u_video_tx/vsync_n5 ;
  wire \u_video_tx/vsync_pulse_n1 ;
  wire \u_video_tx/vsync_pulse_n2 ;
  wire \u_video_tx/packet_ecc/add0_syn_22 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(66)
  wire \u_video_tx/packet_ecc/mux0_syn_68 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(38)
  wire \u_video_tx/packet_ecc/mux0_syn_70 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(38)
  wire \u_video_tx/packet_ecc/mux2_syn_28 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(40)
  wire \u_video_tx/packet_ecc/mux2_syn_50 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(40)
  wire \u_video_tx/packet_ecc/mux2_syn_52 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(40)
  wire \u_video_tx/packet_ecc/mux26_syn_66 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux26_syn_114 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux26_syn_116 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux26_syn_124 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux26_syn_152 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux26_syn_186 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(48)
  wire \u_video_tx/packet_ecc/mux27_syn_66 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_76 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_114 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_124 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_126 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_152 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_186 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux27_syn_206 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(50)
  wire \u_video_tx/packet_ecc/mux6_syn_22 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(44)
  wire \u_video_tx/packet_ecc/mux6_syn_44 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(44)
  wire \u_video_tx/packet_ecc/mux6_syn_48 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(44)
  wire \u_video_tx/packet_ecc/mux8_syn_44 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(46)
  wire \u_video_tx/packet_ecc/mux9_syn_36 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(51)
  wire \u_video_tx/packet_ecc/mux9_syn_38 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(51)
  wire \u_video_tx/packet_ecc/parity0_next2[1]_syn_3 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity1_next2[1]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity1_next2[1]_syn_5 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity2_next2[1]_syn_3 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity3_next2[1]_syn_3 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  wire \u_video_tx/packet_ecc/parity0_b1_n ;
  wire \u_video_tx/packet_ecc/parity4_b3_n ;
  wire \u_video_tx/tmds_blue/add1_syn_24 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_blue/add1_syn_26 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_blue/mux6_syn_30 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_blue/mux6_syn_42 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_blue/mux6_syn_94 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_blue/mux6_syn_112 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_blue/mux9_syn_23 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_35 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_47 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_55 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_67 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_87 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_111 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_119 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_140 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_142 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_146 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_148 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_150 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_152 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_155 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_158 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_163 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_165 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_168 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_172 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_174 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_179 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_181 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_185 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_187 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_191 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_193 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_195 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_198 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_201 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/mux9_syn_204 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_blue/acc_add[3]_syn_2 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire \u_video_tx/tmds_blue/video_data[7]_syn_2 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(7)
  wire \u_video_tx/tmds_blue/data_guard_band_b1_n ;
  wire \u_video_tx/tmds_blue/data_guard_band_b1_n1 ;
  wire \u_video_tx/tmds_blue/data_guard_band_b_n ;
  wire \u_video_tx/tmds_green/add1_syn_24 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_green/add1_syn_26 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_green/mux6_syn_52 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_green/mux6_syn_158 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_green/mux6_syn_178 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_green/mux6_syn_196 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_green/mux7_syn_23 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_31 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_43 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_49 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_57 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_67 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_75 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_81 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_89 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_99 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_117 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_122 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_125 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_127 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_129 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_131 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_134 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_136 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_138 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_140 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_144 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_146 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_151 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_153 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_155 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_160 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_162 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_164 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_166 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_168 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_170 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_173 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_175 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_179 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_181 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_184 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_186 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_190 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_192 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_194 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_197 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_201 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_204 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_206 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_210 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_213 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/mux7_syn_216 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_green/acc_add[3]_syn_2 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire \u_video_tx/tmds_red/add1_syn_24 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_red/add1_syn_26 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(86)
  wire \u_video_tx/tmds_red/mux6_syn_52 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_red/mux6_syn_138 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_red/mux6_syn_158 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_red/mux6_syn_178 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_red/mux6_syn_196 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(98)
  wire \u_video_tx/tmds_red/mux7_syn_23 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_31 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_43 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_49 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_57 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_67 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_75 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_81 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_89 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_99 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_119 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_121 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_125 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_128 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_130 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_132 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_134 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_136 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_138 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_140 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_143 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_145 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_148 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_150 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_153 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_155 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_159 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_162 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_164 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_171 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_174 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_181 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/mux7_syn_183 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  wire \u_video_tx/tmds_red/acc_add[3]_syn_2 ;  // ../user_source/hdl_source/open_tx/tmds_channel.v(20)
  wire \frame_count_reg[0]_syn_2 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[0]_syn_4 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[0]_syn_6 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[0]_syn_8 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[0]_syn_10 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[0]_syn_12 ;  // ../user_source/hdl_source/top.v(66)
  wire \frame_count_reg[1]_syn_2 ;  // ../user_source/hdl_source/top.v(66)
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
  wire \u_build_id/half_count_reg[0]_syn_4 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[1]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[2]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[3]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[4]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_build_id/half_count_reg[5]_syn_2 ;  // ../user_source/hdl_source/status_hex595.v(83)
  wire \u_video_tx/packet_ecc/counter_reg[0]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  wire \u_video_tx/packet_ecc/counter_reg[1]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  wire \u_video_tx/packet_ecc/counter_reg[2]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  wire \u_video_tx/packet_ecc/counter_reg[3]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  wire \u_video_tx/packet_ecc/counter_reg[4]_syn_2 ;  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)

  EG_PHY_PAD #(
    //.LOCATION("K11"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("NA"),
    .IOTYPE("LVDS33"),
    .MODE("OUT"),
    .ODDRMODE("DDRX1"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    HDMI_CLK_P_syn_2 (
    .do({open_n1,open_n2,\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [7],\u_hdmi_phy/u3_lane_lvds_8_1/S_shift_data [9]}),
    .osclk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .rst(\u_build_id/rst ),
    .opad(HDMI_CLK_P));  // ../user_source/hdl_source/top.v(8)
  EG_PHY_PAD #(
    //.LOCATION("J11"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    .DRIVE("NA"),
    .IOTYPE("LVDS33"),
    .MODE("OUT"),
    .TSMUX("0"))
    HDMI_CLK_P_syn_3 ();  // ../user_source/hdl_source/top.v(8)
  EG_PHY_PAD #(
    //.LOCATION("L14"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("NA"),
    .IOTYPE("LVDS33"),
    .MODE("OUT"),
    .ODDRMODE("DDRX1"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    HDMI_D0_P_syn_2 (
    .do({open_n34,open_n35,\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [8],\u_hdmi_phy/u0_lane_lvds_8_1/S_shift_data [9]}),
    .osclk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .rst(\u_build_id/rst ),
    .opad(HDMI_D0_P));  // ../user_source/hdl_source/top.v(9)
  EG_PHY_PAD #(
    //.LOCATION("M14"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    .DRIVE("NA"),
    .IOTYPE("LVDS33"),
    .MODE("OUT"),
    .TSMUX("0"))
    HDMI_D0_P_syn_3 ();  // ../user_source/hdl_source/top.v(9)
  EG_PHY_PAD #(
    //.LOCATION("K15"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("NA"),
    .IOTYPE("LVDS33"),
    .MODE("OUT"),
    .ODDRMODE("DDRX1"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    HDMI_D1_P_syn_2 (
    .do({open_n67,open_n68,\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [8],\u_hdmi_phy/u1_lane_lvds_8_1/S_shift_data [9]}),
    .osclk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .rst(\u_build_id/rst ),
    .opad(HDMI_D1_P));  // ../user_source/hdl_source/top.v(10)
  EG_PHY_PAD #(
    //.LOCATION("M15"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    .DRIVE("NA"),
    .IOTYPE("LVDS33"),
    .MODE("OUT"),
    .TSMUX("0"))
    HDMI_D1_P_syn_3 ();  // ../user_source/hdl_source/top.v(10)
  EG_PHY_PAD #(
    //.LOCATION("H13"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("NA"),
    .IOTYPE("LVDS33"),
    .MODE("OUT"),
    .ODDRMODE("DDRX1"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    HDMI_D2_P_syn_2 (
    .do({open_n100,open_n101,\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [8],\u_hdmi_phy/u2_lane_lvds_8_1/S_shift_data [9]}),
    .osclk(\u_hdmi_phy/u0_lane_lvds_8_1/I_serial_clk ),
    .rst(\u_build_id/rst ),
    .opad(HDMI_D2_P));  // ../user_source/hdl_source/top.v(11)
  EG_PHY_PAD #(
    //.LOCATION("J13"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    .DRIVE("NA"),
    .IOTYPE("LVDS33"),
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
    \frame_count_reg[0]_syn_11  (
    .a(\frame_count_reg[0]_syn_10 ),
    .b(\u_video_tx/tmds_green/mux7_syn_129 ),
    .c(\u_video_tx/tmds_green/mux7_syn_131 ),
    .d(\u_video_tx/tmds_green/mux7_syn_127 ),
    .o(\frame_count_reg[0]_syn_12 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \frame_count_reg[0]_syn_13  (
    .a(\frame_count_reg[0]_syn_12 ),
    .b(frame_count[0]),
    .o(\frame_count_reg[0]_syn_2 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \frame_count_reg[0]_syn_3  (
    .a(\u_video_tx/cx [0]),
    .b(\u_video_tx/cx [1]),
    .o(\frame_count_reg[0]_syn_4 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*~A)"),
    .INIT(16'h0100))
    \frame_count_reg[0]_syn_5  (
    .a(\u_video_tx/cx [8]),
    .b(\u_video_tx/cx [9]),
    .c(\u_video_tx/cx [10]),
    .d(\u_video_tx/cx [11]),
    .o(\frame_count_reg[0]_syn_6 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*A)"),
    .INIT(16'h0200))
    \frame_count_reg[0]_syn_7  (
    .a(\u_video_tx/cx [4]),
    .b(\u_video_tx/cx [5]),
    .c(\u_video_tx/cx [6]),
    .d(\u_video_tx/cx [7]),
    .o(\frame_count_reg[0]_syn_8 ));  // ../user_source/hdl_source/top.v(66)
  AL_MAP_LUT5 #(
    .EQN("(~E*D*C*B*A)"),
    .INIT(32'h00008000))
    \frame_count_reg[0]_syn_9  (
    .a(\frame_count_reg[0]_syn_6 ),
    .b(\frame_count_reg[0]_syn_8 ),
    .c(\frame_count_reg[0]_syn_4 ),
    .d(\u_video_tx/cx [2]),
    .e(\u_video_tx/cx [3]),
    .o(\frame_count_reg[0]_syn_10 ));  // ../user_source/hdl_source/top.v(66)
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
  AL_MAP_LUT3 #(
    .EQN("(C@(B*A))"),
    .INIT(8'h78))
    \frame_count_reg[1]_syn_3  (
    .a(\frame_count_reg[0]_syn_12 ),
    .b(frame_count[0]),
    .c(frame_count[1]),
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
  AL_MAP_LUT4 #(
    .EQN("(D@(C*B*A))"),
    .INIT(16'h7f80))
    \frame_count_reg[2]_syn_3  (
    .a(\frame_count_reg[0]_syn_12 ),
    .b(frame_count[0]),
    .c(frame_count[1]),
    .d(frame_count[2]),
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
    .a(\frame_count_reg[0]_syn_12 ),
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
    //.MACRO("lt0_syn_34"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_34 (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n389}),
    .fco(lt0_syn_7));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt0_syn_34"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_37 (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b11),
    .fci(lt0_syn_7),
    .fco(lt0_syn_11));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt0_syn_34"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_40 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b01),
    .fci(lt0_syn_11),
    .fco(lt0_syn_15));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt0_syn_34"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_43 (
    .a(\u_video_tx/cx [10:9]),
    .b(2'b00),
    .fci(lt0_syn_15),
    .fco(lt0_syn_19));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt0_syn_34"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt0_syn_46 (
    .a({1'b0,\u_video_tx/cx [11]}),
    .b(2'b10),
    .fci(lt0_syn_19),
    .f({rgb_b_n,open_n505}));  // ../user_source/hdl_source/top.v(39)
  EG_PHY_MSLICE #(
    //.MACRO("lt1_syn_31"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt1_syn_31 (
    .a({\u_video_tx/cx [5],1'b0}),
    .b({1'b1,open_n511}),
    .fco(lt1_syn_7));  // ../user_source/hdl_source/top.v(40)
  EG_PHY_MSLICE #(
    //.MACRO("lt1_syn_31"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt1_syn_34 (
    .a(\u_video_tx/cx [7:6]),
    .b(2'b11),
    .fci(lt1_syn_7),
    .fco(lt1_syn_11));  // ../user_source/hdl_source/top.v(40)
  EG_PHY_MSLICE #(
    //.MACRO("lt1_syn_31"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt1_syn_37 (
    .a(\u_video_tx/cx [9:8]),
    .b(2'b01),
    .fci(lt1_syn_11),
    .fco(lt1_syn_15));  // ../user_source/hdl_source/top.v(40)
  EG_PHY_MSLICE #(
    //.MACRO("lt1_syn_31"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt1_syn_40 (
    .a(\u_video_tx/cx [11:10]),
    .b(2'b00),
    .fci(lt1_syn_15),
    .fco(lt1_syn_19));  // ../user_source/hdl_source/top.v(40)
  EG_PHY_MSLICE #(
    //.MACRO("lt1_syn_31"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt1_syn_42 (
    .a({open_n609,1'b0}),
    .b({open_n610,1'b1}),
    .fci(lt1_syn_19),
    .f({open_n629,rgb_b1_n}));  // ../user_source/hdl_source/top.v(40)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_34"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_34 (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n635}),
    .fco(lt2_syn_7));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_34"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_37 (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b10),
    .fci(lt2_syn_7),
    .fco(lt2_syn_11));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_34"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_40 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b01),
    .fci(lt2_syn_11),
    .fco(lt2_syn_15));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_34"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_43 (
    .a(\u_video_tx/cx [10:9]),
    .b(2'b01),
    .fci(lt2_syn_15),
    .fco(lt2_syn_19));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt2_syn_34"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt2_syn_46 (
    .a({1'b0,\u_video_tx/cx [11]}),
    .b(2'b10),
    .fci(lt2_syn_19),
    .f({rgb_b2_n,open_n751}));  // ../user_source/hdl_source/top.v(41)
  EG_PHY_MSLICE #(
    //.MACRO("lt3_syn_28"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt3_syn_28 (
    .a({\u_video_tx/cx [6],1'b0}),
    .b({1'b1,open_n757}),
    .fco(lt3_syn_7));  // ../user_source/hdl_source/top.v(42)
  EG_PHY_MSLICE #(
    //.MACRO("lt3_syn_28"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt3_syn_31 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b11),
    .fci(lt3_syn_7),
    .fco(lt3_syn_11));  // ../user_source/hdl_source/top.v(42)
  EG_PHY_MSLICE #(
    //.MACRO("lt3_syn_28"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt3_syn_34 (
    .a(\u_video_tx/cx [10:9]),
    .b(2'b01),
    .fci(lt3_syn_11),
    .fco(lt3_syn_15));  // ../user_source/hdl_source/top.v(42)
  EG_PHY_MSLICE #(
    //.MACRO("lt3_syn_28"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt3_syn_37 (
    .a({1'b0,\u_video_tx/cx [11]}),
    .b(2'b10),
    .fci(lt3_syn_15),
    .f({rgb_b3_n,open_n849}));  // ../user_source/hdl_source/top.v(42)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_34"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_34 (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n855}),
    .fco(lt4_syn_7));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_34"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_37 (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b01),
    .fci(lt4_syn_7),
    .fco(lt4_syn_11));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_34"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_40 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b01),
    .fci(lt4_syn_11),
    .fco(lt4_syn_15));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_34"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_43 (
    .a(\u_video_tx/cx [10:9]),
    .b(2'b10),
    .fci(lt4_syn_15),
    .fco(lt4_syn_19));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt4_syn_34"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt4_syn_46 (
    .a({1'b0,\u_video_tx/cx [11]}),
    .b(2'b10),
    .fci(lt4_syn_19),
    .f({rgb_b4_n,open_n971}));  // ../user_source/hdl_source/top.v(43)
  EG_PHY_MSLICE #(
    //.MACRO("lt5_syn_31"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt5_syn_31 (
    .a({\u_video_tx/cx [5],1'b0}),
    .b({1'b1,open_n977}),
    .fco(lt5_syn_7));  // ../user_source/hdl_source/top.v(44)
  EG_PHY_MSLICE #(
    //.MACRO("lt5_syn_31"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt5_syn_34 (
    .a(\u_video_tx/cx [7:6]),
    .b(2'b10),
    .fci(lt5_syn_7),
    .fco(lt5_syn_11));  // ../user_source/hdl_source/top.v(44)
  EG_PHY_MSLICE #(
    //.MACRO("lt5_syn_31"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt5_syn_37 (
    .a(\u_video_tx/cx [9:8]),
    .b(2'b01),
    .fci(lt5_syn_11),
    .fco(lt5_syn_15));  // ../user_source/hdl_source/top.v(44)
  EG_PHY_MSLICE #(
    //.MACRO("lt5_syn_31"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt5_syn_40 (
    .a(\u_video_tx/cx [11:10]),
    .b(2'b01),
    .fci(lt5_syn_15),
    .fco(lt5_syn_19));  // ../user_source/hdl_source/top.v(44)
  EG_PHY_MSLICE #(
    //.MACRO("lt5_syn_31"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt5_syn_42 (
    .a({open_n1075,1'b0}),
    .b({open_n1076,1'b1}),
    .fci(lt5_syn_19),
    .f({open_n1095,rgb_b5_n1}));  // ../user_source/hdl_source/top.v(44)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_34"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_34 (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n1101}),
    .fco(lt6_syn_7));  // ../user_source/hdl_source/top.v(45)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_34"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_37 (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b00),
    .fci(lt6_syn_7),
    .fco(lt6_syn_11));  // ../user_source/hdl_source/top.v(45)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_34"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_40 (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b01),
    .fci(lt6_syn_11),
    .fco(lt6_syn_15));  // ../user_source/hdl_source/top.v(45)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_34"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_43 (
    .a(\u_video_tx/cx [10:9]),
    .b(2'b11),
    .fci(lt6_syn_15),
    .fco(lt6_syn_19));  // ../user_source/hdl_source/top.v(45)
  EG_PHY_MSLICE #(
    //.MACRO("lt6_syn_34"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    lt6_syn_46 (
    .a({1'b0,\u_video_tx/cx [11]}),
    .b(2'b10),
    .fci(lt6_syn_19),
    .f({rgb_b5_n,open_n1217}));  // ../user_source/hdl_source/top.v(45)
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
    .do({open_n1240,open_n1241,open_n1242,\u_build_id/shift_word [15]}),
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
    .do({open_n1255,open_n1256,open_n1257,\u_build_id/state_reg_syn_1 [4]}),
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
    .do({open_n1269,open_n1270,open_n1271,\u_build_id/state_reg_syn_1 [2]}),
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
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    startup_done_reg_syn_10 (
    .a(startup_count[16]),
    .b(startup_count[17]),
    .c(startup_count[18]),
    .d(startup_count[19]),
    .o(startup_done_reg_syn_11));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT5 #(
    .EQN("(E*~D*~C*~B*A)"),
    .INIT(32'h00020000))
    startup_done_reg_syn_12 (
    .a(startup_done_reg_syn_9),
    .b(startup_count[8]),
    .c(startup_count[10]),
    .d(startup_count[12]),
    .e(startup_count[14]),
    .o(startup_done_reg_syn_13));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*~C*B*A)"),
    .INIT(32'h00000008))
    startup_done_reg_syn_14 (
    .a(startup_done_reg_syn_11),
    .b(startup_count[9]),
    .c(startup_count[11]),
    .d(startup_count[13]),
    .e(startup_count[15]),
    .o(startup_done_reg_syn_15));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~C*~(B*A)))"),
    .INIT(16'hf800))
    startup_done_reg_syn_16 (
    .a(startup_done_reg_syn_13),
    .b(startup_done_reg_syn_15),
    .c(startup_done),
    .d(pll_lock),
    .o(startup_done_reg_syn_3));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT4 #(
    .EQN("~(D*~(~C*~(B*A)))"),
    .INIT(16'b0000011111111111))
    startup_done_reg_syn_18 (
    .a(startup_done_reg_syn_13),
    .b(startup_done_reg_syn_15),
    .c(startup_done),
    .d(pll_lock),
    .o(startup_done_reg_syn_5));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    startup_done_reg_syn_6 (
    .a(startup_count[0]),
    .b(startup_count[1]),
    .c(startup_count[2]),
    .d(startup_count[3]),
    .o(startup_done_reg_syn_7));  // ../user_source/hdl_source/top.v(23)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*C*B*A)"),
    .INIT(32'h00000080))
    startup_done_reg_syn_8 (
    .a(startup_done_reg_syn_7),
    .b(startup_count[4]),
    .c(startup_count[5]),
    .d(startup_count[6]),
    .e(startup_count[7]),
    .o(startup_done_reg_syn_9));  // ../user_source/hdl_source/top.v(23)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_106"),
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
    \u_build_id/add0_syn_106  (
    .a({\u_build_id/slot_count [1],1'b0}),
    .b({\u_build_id/slot_count [2],\u_build_id/slot_count [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_build_id/slot_count_b5 [1],open_n1301}),
    .fco(\u_build_id/add0_syn_91 ),
    .fx({\u_build_id/slot_count_b5 [2],open_n1302}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_106"),
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
    \u_build_id/add0_syn_107  (
    .a({\u_build_id/slot_count [5],\u_build_id/slot_count [3]}),
    .b({\u_build_id/slot_count [6],\u_build_id/slot_count [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_build_id/add0_syn_91 ),
    .f({\u_build_id/slot_count_b5 [5],\u_build_id/slot_count_b5 [3]}),
    .fco(\u_build_id/add0_syn_95 ),
    .fx({\u_build_id/slot_count_b5 [6],\u_build_id/slot_count_b5 [4]}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_106"),
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
    \u_build_id/add0_syn_108  (
    .a({\u_build_id/slot_count [9],\u_build_id/slot_count [7]}),
    .b({\u_build_id/slot_count [10],\u_build_id/slot_count [8]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_build_id/add0_syn_95 ),
    .f({\u_build_id/slot_count_b5 [9],\u_build_id/slot_count_b5 [7]}),
    .fco(\u_build_id/add0_syn_99 ),
    .fx({\u_build_id/slot_count_b5 [10],\u_build_id/slot_count_b5 [8]}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_106"),
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
    \u_build_id/add0_syn_109  (
    .a({\u_build_id/slot_count [13],\u_build_id/slot_count [11]}),
    .b({\u_build_id/slot_count [14],\u_build_id/slot_count [12]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_build_id/add0_syn_99 ),
    .f({\u_build_id/slot_count_b5 [13],\u_build_id/slot_count_b5 [11]}),
    .fco(\u_build_id/add0_syn_103 ),
    .fx({\u_build_id/slot_count_b5 [14],\u_build_id/slot_count_b5 [12]}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_LSLICE #(
    //.MACRO("u_build_id/add0_syn_106"),
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
    \u_build_id/add0_syn_110  (
    .a({open_n1359,\u_build_id/slot_count [15]}),
    .b({open_n1360,\u_build_id/slot_count [16]}),
    .c(2'b00),
    .d({open_n1363,1'b0}),
    .e({open_n1364,1'b0}),
    .fci(\u_build_id/add0_syn_103 ),
    .f({open_n1379,\u_build_id/slot_count_b5 [15]}),
    .fx({open_n1381,\u_build_id/slot_count_b5 [16]}));  // ../user_source/hdl_source/status_hex595.v(109)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/add1_syn_49"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_build_id/add1_syn_49  (
    .a({\u_build_id/half_count [0],1'b0}),
    .b({1'b1,open_n1384}),
    .fco(\u_build_id/add1_syn_34 ));  // ../user_source/hdl_source/status_hex595.v(126)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/add1_syn_49"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_build_id/add1_syn_52  (
    .a(\u_build_id/half_count [2:1]),
    .b(2'b00),
    .fci(\u_build_id/add1_syn_34 ),
    .f(\u_build_id/half_count_b4 [2:1]),
    .fco(\u_build_id/add1_syn_36 ));  // ../user_source/hdl_source/status_hex595.v(126)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/add1_syn_49"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_build_id/add1_syn_55  (
    .a(\u_build_id/half_count [4:3]),
    .b(2'b00),
    .fci(\u_build_id/add1_syn_36 ),
    .f(\u_build_id/half_count_b4 [4:3]),
    .fco(\u_build_id/add1_syn_38 ));  // ../user_source/hdl_source/status_hex595.v(126)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/add1_syn_49"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_build_id/add1_syn_57  (
    .a({open_n1454,\u_build_id/half_count [5]}),
    .b({open_n1455,1'b0}),
    .fci(\u_build_id/add1_syn_38 ),
    .f({open_n1474,\u_build_id/half_count_b4 [5]}));  // ../user_source/hdl_source/status_hex595.v(126)
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
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_build_id/bit_count_reg[3]_syn_10  (
    .a(\u_build_id/bit_count_reg[3]_syn_9 ),
    .b(\u_build_id/bit_count [3]),
    .o(\u_build_id/bit_count_reg[3]_syn_11 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(A*~(~D*C*B))"),
    .INIT(16'haa2a))
    \u_build_id/bit_count_reg[3]_syn_12  (
    .a(\u_build_id/mux7_syn_627 ),
    .b(\u_build_id/bit_count_reg[3]_syn_6 ),
    .c(\u_build_id/bit_count_reg[3]_syn_11 ),
    .d(\u_build_id/bit_count [4]),
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
    .b(\u_build_id/bit_count_b3_n ),
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
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*C*~(D)+~(A)*B*C*~(D)+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h7850))
    \u_build_id/bit_count_reg[4]_syn_3  (
    .a(\u_build_id/mux8_syn_187 ),
    .b(\u_build_id/bit_count_reg[3]_syn_11 ),
    .c(\u_build_id/bit_count [4]),
    .d(\u_build_id/state_reg_syn_1 [3]),
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
  AL_MAP_LUT4 #(
    .EQN("(C@(D*B*~A))"),
    .INIT(16'hb4f0))
    \u_build_id/digit_index_reg[1]_syn_3  (
    .a(\u_build_id/tx_is_blank ),
    .b(\u_build_id/digit_index [0]),
    .c(\u_build_id/digit_index [1]),
    .d(\u_build_id/state_reg_syn_1 [5]),
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
  AL_MAP_LUT5 #(
    .EQN("(D@(E*C*B*~A))"),
    .INIT(32'hbf40ff00))
    \u_build_id/digit_index_reg[2]_syn_3  (
    .a(\u_build_id/tx_is_blank ),
    .b(\u_build_id/digit_index [0]),
    .c(\u_build_id/digit_index [1]),
    .d(\u_build_id/digit_index [2]),
    .e(\u_build_id/state_reg_syn_1 [5]),
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
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_build_id/half_count_reg[0]_syn_3  (
    .a(\u_build_id/state_reg_syn_1 [2]),
    .b(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/half_count_reg[0]_syn_4 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D)"),
    .INIT(16'h01c1))
    \u_build_id/half_count_reg[0]_syn_5  (
    .a(\u_build_id/bit_count_b3_n ),
    .b(\u_build_id/half_count_reg[0]_syn_4 ),
    .c(\u_build_id/half_count [0]),
    .d(\u_build_id/state_reg_syn_1 [1]),
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
  AL_MAP_LUT5 #(
    .EQN("((B*~A)*~((~E*D))*~(C)+(B*~A)*(~E*D)*~(C)+~((B*~A))*(~E*D)*C+(B*~A)*(~E*D)*C)"),
    .INIT(32'h0404f404))
    \u_build_id/half_count_reg[1]_syn_3  (
    .a(\u_build_id/bit_count_b3_n ),
    .b(\u_build_id/half_count_b4 [1]),
    .c(\u_build_id/half_count_reg[0]_syn_4 ),
    .d(\u_build_id/half_count [1]),
    .e(\u_build_id/state_reg_syn_1 [1]),
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
    .EQN("((B*~A)*~((~E*D))*~(C)+(B*~A)*(~E*D)*~(C)+~((B*~A))*(~E*D)*C+(B*~A)*(~E*D)*C)"),
    .INIT(32'h0404f404))
    \u_build_id/half_count_reg[2]_syn_3  (
    .a(\u_build_id/bit_count_b3_n ),
    .b(\u_build_id/half_count_b4 [2]),
    .c(\u_build_id/half_count_reg[0]_syn_4 ),
    .d(\u_build_id/half_count [2]),
    .e(\u_build_id/state_reg_syn_1 [1]),
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
  AL_MAP_LUT5 #(
    .EQN("((B*~A)*~((~E*D))*~(C)+(B*~A)*(~E*D)*~(C)+~((B*~A))*(~E*D)*C+(B*~A)*(~E*D)*C)"),
    .INIT(32'h0404f404))
    \u_build_id/half_count_reg[3]_syn_3  (
    .a(\u_build_id/bit_count_b3_n ),
    .b(\u_build_id/half_count_b4 [3]),
    .c(\u_build_id/half_count_reg[0]_syn_4 ),
    .d(\u_build_id/half_count [3]),
    .e(\u_build_id/state_reg_syn_1 [1]),
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
  AL_MAP_LUT5 #(
    .EQN("((B*~A)*~((~E*D))*~(C)+(B*~A)*(~E*D)*~(C)+~((B*~A))*(~E*D)*C+(B*~A)*(~E*D)*C)"),
    .INIT(32'h0404f404))
    \u_build_id/half_count_reg[4]_syn_3  (
    .a(\u_build_id/bit_count_b3_n ),
    .b(\u_build_id/half_count_b4 [4]),
    .c(\u_build_id/half_count_reg[0]_syn_4 ),
    .d(\u_build_id/half_count [4]),
    .e(\u_build_id/state_reg_syn_1 [1]),
    .o(\u_build_id/half_count_reg[4]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/half_count_reg[5]  (
    .clk(\u_build_id/clk ),
    .d(\u_build_id/half_count_reg[5]_syn_2 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/half_count [5]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_LUT5 #(
    .EQN("((B*~A)*~((~E*D))*~(C)+(B*~A)*(~E*D)*~(C)+~((B*~A))*(~E*D)*C+(B*~A)*(~E*D)*C)"),
    .INIT(32'h0404f404))
    \u_build_id/half_count_reg[5]_syn_3  (
    .a(\u_build_id/bit_count_b3_n ),
    .b(\u_build_id/half_count_b4 [5]),
    .c(\u_build_id/half_count_reg[0]_syn_4 ),
    .d(\u_build_id/half_count [5]),
    .e(\u_build_id/state_reg_syn_1 [1]),
    .o(\u_build_id/half_count_reg[5]_syn_2 ));  // ../user_source/hdl_source/status_hex595.v(83)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_55  (
    .a(2'b11),
    .b({\u_build_id/slot_count [2],open_n1495}),
    .fco(\u_build_id/lt0_syn_7 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_58  (
    .a(2'b01),
    .b(\u_build_id/slot_count [4:3]),
    .fci(\u_build_id/lt0_syn_7 ),
    .fco(\u_build_id/lt0_syn_11 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_61  (
    .a(2'b01),
    .b(\u_build_id/slot_count [6:5]),
    .fci(\u_build_id/lt0_syn_11 ),
    .fco(\u_build_id/lt0_syn_15 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_64  (
    .a(2'b00),
    .b(\u_build_id/slot_count [8:7]),
    .fci(\u_build_id/lt0_syn_15 ),
    .fco(\u_build_id/lt0_syn_19 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_67  (
    .a(2'b01),
    .b(\u_build_id/slot_count [10:9]),
    .fci(\u_build_id/lt0_syn_19 ),
    .fco(\u_build_id/lt0_syn_23 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_70  (
    .a(2'b00),
    .b(\u_build_id/slot_count [12:11]),
    .fci(\u_build_id/lt0_syn_23 ),
    .fco(\u_build_id/lt0_syn_27 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_73  (
    .a(2'b01),
    .b(\u_build_id/slot_count [14:13]),
    .fci(\u_build_id/lt0_syn_27 ),
    .fco(\u_build_id/lt0_syn_31 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_76  (
    .a(2'b10),
    .b(\u_build_id/slot_count [16:15]),
    .fci(\u_build_id/lt0_syn_31 ),
    .fco(\u_build_id/lt0_syn_35 ));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt0_syn_55"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt0_syn_78  (
    .a({open_n1689,1'b0}),
    .b({open_n1690,1'b1}),
    .fci(\u_build_id/lt0_syn_35 ),
    .f({open_n1709,\u_build_id/bit_count_b4_n }));  // ../user_source/hdl_source/status_hex595.v(100)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt1_syn_27"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt1_syn_27  (
    .a(2'b11),
    .b({\u_build_id/half_count [0],open_n1715}),
    .fco(\u_build_id/lt1_syn_6 ));  // ../user_source/hdl_source/status_hex595.v(121)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt1_syn_27"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt1_syn_30  (
    .a(2'b10),
    .b(\u_build_id/half_count [2:1]),
    .fci(\u_build_id/lt1_syn_6 ),
    .fco(\u_build_id/lt1_syn_10 ));  // ../user_source/hdl_source/status_hex595.v(121)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt1_syn_27"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt1_syn_33  (
    .a(2'b00),
    .b(\u_build_id/half_count [4:3]),
    .fci(\u_build_id/lt1_syn_10 ),
    .fco(\u_build_id/lt1_syn_14 ));  // ../user_source/hdl_source/status_hex595.v(121)
  EG_PHY_MSLICE #(
    //.MACRO("u_build_id/lt1_syn_27"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_build_id/lt1_syn_36  (
    .a(2'b01),
    .b({1'b1,\u_build_id/half_count [5]}),
    .fci(\u_build_id/lt1_syn_14 ),
    .f({\u_build_id/bit_count_b3_n ,open_n1807}));  // ../user_source/hdl_source/status_hex595.v(121)
  AL_MAP_LUT4 #(
    .EQN("~(~D*~C*~(~B*A))"),
    .INIT(16'hfff2))
    \u_build_id/mux2_syn_25  (
    .a(\u_build_id/bit_count_b3_n ),
    .b(\u_build_id/half_count_reg[0]_syn_4 ),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [1]),
    .o(\u_build_id/mux2_syn_20 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_build_id/mux4_syn_102  (
    .a(\u_build_id/bit_count_b3_n ),
    .b(\u_build_id/state_reg_syn_1 [2]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux4_syn_79 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(C*~A))"),
    .INIT(8'hdc))
    \u_build_id/mux4_syn_103  (
    .a(\u_build_id/bit_count_b3_n ),
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
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*A)"),
    .INIT(16'h0800))
    \u_build_id/mux4_syn_105  (
    .a(\u_build_id/bit_count_reg[3]_syn_11 ),
    .b(\u_build_id/bit_count_b3_n ),
    .c(\u_build_id/bit_count [4]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux4_syn_97 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \u_build_id/mux5_syn_343  (
    .a(\u_build_id/slot_count_b5 [15]),
    .b(\u_build_id/bit_count_b4_n ),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_298 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \u_build_id/mux5_syn_344  (
    .a(\u_build_id/slot_count_b5 [16]),
    .b(\u_build_id/bit_count_b4_n ),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_310 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_345  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [1]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_130 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_346  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [2]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_142 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_347  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [3]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_154 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_348  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [4]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_166 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_349  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [5]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_178 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_350  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [6]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_190 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_351  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [7]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_202 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_352  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [8]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_214 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_353  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [9]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_226 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_354  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [10]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_238 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_355  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [11]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_250 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_356  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [12]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_262 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_357  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [13]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_274 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_build_id/mux5_syn_358  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count_b5 [14]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_286 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(C*~A))"),
    .INIT(8'hdc))
    \u_build_id/mux5_syn_359  (
    .a(\u_build_id/tx_is_blank ),
    .b(\u_build_id/state_reg_syn_1 [0]),
    .c(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux5_syn_342 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*~A)"),
    .INIT(8'h10))
    \u_build_id/mux5_syn_360  (
    .a(\u_build_id/bit_count_b4_n ),
    .b(\u_build_id/slot_count [0]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .o(\u_build_id/mux5_syn_118 ));  // ../user_source/hdl_source/status_hex595.v(96)
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
    .a(\u_build_id/digit_index [1]),
    .b(\u_build_id/digit_index [2]),
    .o(\u_build_id/mux7_syn_635 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_build_id/mux7_syn_636  (
    .a(\u_build_id/digit_index [0]),
    .b(\u_build_id/state_reg_syn_1 [5]),
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
    .b(\u_build_id/mux7_syn_635 ),
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
  AL_MAP_LUT5 #(
    .EQN("~(~(E*D)*~(C*~B*A))"),
    .INIT(32'hff202020))
    \u_build_id/mux7_syn_641  (
    .a(\u_build_id/mux7_syn_637 ),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/shift_word [4]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_259 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("~(~(E*D)*~(~C*~B*A))"),
    .INIT(32'hff020202))
    \u_build_id/mux7_syn_642  (
    .a(\u_build_id/mux7_syn_637 ),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/shift_word [0]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_123 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("~(~(E*D)*~(~C*B*A))"),
    .INIT(32'hff080808))
    \u_build_id/mux7_syn_643  (
    .a(\u_build_id/mux7_syn_629 ),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/shift_word [1]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_157 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("~(~(E*D)*~(~C*B*A))"),
    .INIT(32'hff080808))
    \u_build_id/mux7_syn_644  (
    .a(\u_build_id/mux7_syn_637 ),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/shift_word [2]),
    .e(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_191 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*A)"),
    .INIT(16'h2000))
    \u_build_id/mux7_syn_645  (
    .a(\u_build_id/digit_index [0]),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/frame_value [0]),
    .o(\u_build_id/mux7_syn_646 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("~(~C*~(D*B)*~(E*A))"),
    .INIT(32'hfefafcf0))
    \u_build_id/mux7_syn_647  (
    .a(\u_build_id/mux7_syn_646 ),
    .b(\u_build_id/shift_word [8]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .e(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux7_syn_395 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("~(~C*~(D*B)*~(E*A))"),
    .INIT(32'hfefafcf0))
    \u_build_id/mux7_syn_648  (
    .a(\u_build_id/mux7_syn_646 ),
    .b(\u_build_id/shift_word [9]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .e(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux7_syn_429 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~(B*~A))"),
    .INIT(16'hb000))
    \u_build_id/mux7_syn_649  (
    .a(\u_build_id/mux7_syn_631 ),
    .b(\u_build_id/digit_index [2]),
    .c(\u_build_id/frame_value [0]),
    .d(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux7_syn_650 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~A*~(D*B))"),
    .INIT(16'hfefa))
    \u_build_id/mux7_syn_651  (
    .a(\u_build_id/mux7_syn_650 ),
    .b(\u_build_id/shift_word [11]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_497 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~(B*A))"),
    .INIT(16'h0700))
    \u_build_id/mux7_syn_652  (
    .a(\u_build_id/digit_index [0]),
    .b(\u_build_id/digit_index [1]),
    .c(\u_build_id/digit_index [2]),
    .d(\u_build_id/frame_value [0]),
    .o(\u_build_id/mux7_syn_653 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT5 #(
    .EQN("~(~C*~(D*B)*~(E*~A))"),
    .INIT(32'hfdf5fcf0))
    \u_build_id/mux7_syn_654  (
    .a(\u_build_id/mux7_syn_653 ),
    .b(\u_build_id/shift_word [13]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .e(\u_build_id/state_reg_syn_1 [5]),
    .o(\u_build_id/mux7_syn_565 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_build_id/mux7_syn_655  (
    .a(\u_build_id/mux7_syn_650 ),
    .b(\u_build_id/mux7_syn_653 ),
    .o(\u_build_id/mux7_syn_656 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~A*~(D*B))"),
    .INIT(16'hfefa))
    \u_build_id/mux7_syn_657  (
    .a(\u_build_id/mux7_syn_656 ),
    .b(\u_build_id/shift_word [7]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_361 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~A*~(D*B))"),
    .INIT(16'hfefa))
    \u_build_id/mux7_syn_658  (
    .a(\u_build_id/mux7_syn_656 ),
    .b(\u_build_id/shift_word [10]),
    .c(\u_build_id/state_reg_syn_1 [0]),
    .d(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_463 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT3 #(
    .EQN("(~B*~(C*A))"),
    .INIT(8'h13))
    \u_build_id/mux7_syn_659  (
    .a(\u_build_id/shift_word [12]),
    .b(\u_build_id/state_reg_syn_1 [0]),
    .c(\u_build_id/state_reg_syn_1 [3]),
    .o(\u_build_id/mux7_syn_660 ));  // ../user_source/hdl_source/status_hex595.v(96)
  AL_MAP_LUT4 #(
    .EQN("~(B*~(A*~(~D*C)))"),
    .INIT(16'hbb3b))
    \u_build_id/mux7_syn_661  (
    .a(\u_build_id/mux7_syn_650 ),
    .b(\u_build_id/mux7_syn_660 ),
    .c(\u_build_id/mux7_syn_631 ),
    .d(\u_build_id/digit_index [2]),
    .o(\u_build_id/mux7_syn_531 ));  // ../user_source/hdl_source/status_hex595.v(96)
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
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[0]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_118 ),
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
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_238 ),
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
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_250 ),
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
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_262 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [12]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[13]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_274 ),
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
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_286 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [14]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[15]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_298 ),
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
    \u_build_id/slot_count_reg[16]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_310 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [16]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[1]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_130 ),
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
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_142 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [2]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[3]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_154 ),
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
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_166 ),
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
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_178 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [5]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[6]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_190 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [6]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[7]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_202 ),
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
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_214 ),
    .sr(\u_build_id/rst ),
    .q(\u_build_id/slot_count [8]));  // ../user_source/hdl_source/status_hex595.v(83)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \u_build_id/slot_count_reg[9]  (
    .ce(\u_build_id/mux5_syn_342 ),
    .clk(\u_build_id/clk ),
    .d(\u_build_id/mux5_syn_226 ),
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
    .d(\u_video_tx/tmds_blue/tmds [3]),
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
    .d(\u_video_tx/tmds_blue/tmds [0]),
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
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [2]),
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
    .b(\u_hdmi_phy/u0_lane_lvds_8_1/S_pending_data [4]),
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
    .CLKC0_CPHASE(9),
    .CLKC0_DIV(10),
    .CLKC0_DIV2_ENABLE("DISABLE"),
    .CLKC0_ENABLE("ENABLE"),
    .CLKC0_FPHASE(0),
    .CLKC1_CPHASE(1),
    .CLKC1_DIV(2),
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
    .FBCLK_DIV(104),
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
    .REFCLK_DIV(7),
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
    .clkc({open_n1864,open_n1865,open_n1866,serial_clk_raw,\u_video_pll/clk0_buf }),
    .extlock(pll_lock));  // ../user_source/hdl_source/IP/video_pll.v(47)
  EG_PHY_GCLK \u_video_pll/u_pixel_gclk  (
    .clki(\u_video_pll/clk0_buf ),
    .clko(\u_build_id/clk ));  // ../user_source/hdl_source/IP/video_pll.v(18)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add0_syn_68"),
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
    \u_video_tx/add0_syn_68  (
    .a({\u_video_tx/cy [1],1'b0}),
    .b({\u_video_tx/cy [2],\u_video_tx/cy [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_video_tx/y_count_b4 [1],open_n1893}),
    .fco(\u_video_tx/add0_syn_59 ),
    .fx({\u_video_tx/y_count_b4 [2],open_n1894}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add0_syn_68"),
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
    \u_video_tx/add0_syn_69  (
    .a({\u_video_tx/cy [5],\u_video_tx/cy [3]}),
    .b({\u_video_tx/cy [6],\u_video_tx/cy [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_video_tx/add0_syn_59 ),
    .f({\u_video_tx/y_count_b4 [5],\u_video_tx/y_count_b4 [3]}),
    .fco(\u_video_tx/add0_syn_63 ),
    .fx({\u_video_tx/y_count_b4 [6],\u_video_tx/y_count_b4 [4]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add0_syn_68"),
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
    \u_video_tx/add0_syn_70  (
    .a({\u_video_tx/cy [9],\u_video_tx/cy [7]}),
    .b({\u_video_tx/cy [10],\u_video_tx/cy [8]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_video_tx/add0_syn_63 ),
    .f({\u_video_tx/y_count_b4 [9],\u_video_tx/y_count_b4 [7]}),
    .fx({\u_video_tx/y_count_b4 [10],\u_video_tx/y_count_b4 [8]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(78)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add1_syn_74"),
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
    \u_video_tx/add1_syn_74  (
    .a({\u_video_tx/cx [1],1'b0}),
    .b({\u_video_tx/cx [2],\u_video_tx/cx [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_video_tx/x_count_b3 [1],open_n1951}),
    .fco(\u_video_tx/add1_syn_64 ),
    .fx({\u_video_tx/x_count_b3 [2],open_n1952}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add1_syn_74"),
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
    \u_video_tx/add1_syn_75  (
    .a({\u_video_tx/cx [5],\u_video_tx/cx [3]}),
    .b({\u_video_tx/cx [6],\u_video_tx/cx [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_video_tx/add1_syn_64 ),
    .f({\u_video_tx/x_count_b3 [5],\u_video_tx/x_count_b3 [3]}),
    .fco(\u_video_tx/add1_syn_68 ),
    .fx({\u_video_tx/x_count_b3 [6],\u_video_tx/x_count_b3 [4]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add1_syn_74"),
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
    \u_video_tx/add1_syn_76  (
    .a({\u_video_tx/cx [9],\u_video_tx/cx [7]}),
    .b({\u_video_tx/cx [10],\u_video_tx/cx [8]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_video_tx/add1_syn_68 ),
    .f({\u_video_tx/x_count_b3 [9],\u_video_tx/x_count_b3 [7]}),
    .fco(\u_video_tx/add1_syn_72 ),
    .fx({\u_video_tx/x_count_b3 [10],\u_video_tx/x_count_b3 [8]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  EG_PHY_LSLICE #(
    //.MACRO("u_video_tx/add1_syn_74"),
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
    \u_video_tx/add1_syn_77  (
    .a({open_n1991,\u_video_tx/cx [11]}),
    .c(2'b00),
    .d({open_n1996,1'b0}),
    .fci(\u_video_tx/add1_syn_72 ),
    .f({open_n2013,\u_video_tx/x_count_b3 [11]}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(80)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_video_tx/cx[0]_syn_5  (
    .a(\u_video_tx/cx [0]),
    .o(\u_video_tx/cx[0]_syn_2 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(18)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_37"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_37  (
    .a(2'b11),
    .b({\u_video_tx/cx [3],open_n2019}),
    .fco(\u_video_tx/lt0_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_37"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_40  (
    .a(2'b01),
    .b(\u_video_tx/cx [5:4]),
    .fci(\u_video_tx/lt0_syn_7 ),
    .fco(\u_video_tx/lt0_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_37"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_43  (
    .a(2'b11),
    .b(\u_video_tx/cx [7:6]),
    .fci(\u_video_tx/lt0_syn_11 ),
    .fco(\u_video_tx/lt0_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_37"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_46  (
    .a(2'b11),
    .b(\u_video_tx/cx [9:8]),
    .fci(\u_video_tx/lt0_syn_15 ),
    .fco(\u_video_tx/lt0_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_37"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_49  (
    .a(2'b01),
    .b(\u_video_tx/cx [11:10]),
    .fci(\u_video_tx/lt0_syn_19 ),
    .fco(\u_video_tx/lt0_syn_23 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt0_syn_37"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt0_syn_51  (
    .a({open_n2141,1'b0}),
    .b({open_n2142,1'b1}),
    .fci(\u_video_tx/lt0_syn_23 ),
    .f({open_n2161,\u_video_tx/vsync_n1 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(131)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt11_syn_33"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt11_syn_33  (
    .a({\u_video_tx/cy [3],1'b0}),
    .b({1'b1,open_n2167}),
    .fco(\u_video_tx/lt11_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt11_syn_33"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt11_syn_36  (
    .a(\u_video_tx/cy [5:4]),
    .b(2'b11),
    .fci(\u_video_tx/lt11_syn_6 ),
    .fco(\u_video_tx/lt11_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt11_syn_33"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt11_syn_39  (
    .a(\u_video_tx/cy [7:6]),
    .b(2'b00),
    .fci(\u_video_tx/lt11_syn_10 ),
    .fco(\u_video_tx/lt11_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt11_syn_33"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt11_syn_42  (
    .a(\u_video_tx/cy [9:8]),
    .b(2'b00),
    .fci(\u_video_tx/lt11_syn_14 ),
    .fco(\u_video_tx/lt11_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt11_syn_33"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt11_syn_45  (
    .a({1'b0,\u_video_tx/cy [10]}),
    .b(2'b11),
    .fci(\u_video_tx/lt11_syn_18 ),
    .f({\u_video_tx/active_n2 ,open_n2283}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(66)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_39"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_39  (
    .a(2'b11),
    .b({\u_video_tx/cx [2],open_n2289}),
    .fco(\u_video_tx/lt12_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_39"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_42  (
    .a(2'b00),
    .b(\u_video_tx/cx [4:3]),
    .fci(\u_video_tx/lt12_syn_6 ),
    .fco(\u_video_tx/lt12_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_39"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_45  (
    .a(2'b00),
    .b(\u_video_tx/cx [6:5]),
    .fci(\u_video_tx/lt12_syn_10 ),
    .fco(\u_video_tx/lt12_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_39"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_48  (
    .a(2'b11),
    .b(\u_video_tx/cx [8:7]),
    .fci(\u_video_tx/lt12_syn_14 ),
    .fco(\u_video_tx/lt12_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_39"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_51  (
    .a(2'b11),
    .b(\u_video_tx/cx [10:9]),
    .fci(\u_video_tx/lt12_syn_18 ),
    .fco(\u_video_tx/lt12_syn_22 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt12_syn_39"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt12_syn_54  (
    .a(2'b00),
    .b({1'b1,\u_video_tx/cx [11]}),
    .fci(\u_video_tx/lt12_syn_22 ),
    .f({\u_video_tx/data_island_preamble_n1 ,open_n2429}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_40"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_40  (
    .a({\u_video_tx/cx [2],1'b0}),
    .b({1'b1,open_n2435}),
    .fco(\u_video_tx/lt13_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_40"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_43  (
    .a(\u_video_tx/cx [4:3]),
    .b(2'b01),
    .fci(\u_video_tx/lt13_syn_7 ),
    .fco(\u_video_tx/lt13_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_40"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_46  (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b00),
    .fci(\u_video_tx/lt13_syn_11 ),
    .fco(\u_video_tx/lt13_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_40"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_49  (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b11),
    .fci(\u_video_tx/lt13_syn_15 ),
    .fco(\u_video_tx/lt13_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_40"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_52  (
    .a(\u_video_tx/cx [10:9]),
    .b(2'b11),
    .fci(\u_video_tx/lt13_syn_19 ),
    .fco(\u_video_tx/lt13_syn_23 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt13_syn_40"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt13_syn_55  (
    .a({1'b0,\u_video_tx/cx [11]}),
    .b(2'b10),
    .fci(\u_video_tx/lt13_syn_23 ),
    .f({\u_video_tx/data_island_preamble_n2 ,open_n2575}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(149)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_43"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_43  (
    .a({\u_video_tx/cx [1],1'b0}),
    .b({1'b1,open_n2581}),
    .fco(\u_video_tx/lt15_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_43"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_46  (
    .a(\u_video_tx/cx [3:2]),
    .b(2'b11),
    .fci(\u_video_tx/lt15_syn_7 ),
    .fco(\u_video_tx/lt15_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_43"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_49  (
    .a(\u_video_tx/cx [5:4]),
    .b(2'b00),
    .fci(\u_video_tx/lt15_syn_11 ),
    .fco(\u_video_tx/lt15_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_43"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_52  (
    .a(\u_video_tx/cx [7:6]),
    .b(2'b10),
    .fci(\u_video_tx/lt15_syn_15 ),
    .fco(\u_video_tx/lt15_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_43"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_55  (
    .a(\u_video_tx/cx [9:8]),
    .b(2'b11),
    .fci(\u_video_tx/lt15_syn_19 ),
    .fco(\u_video_tx/lt15_syn_23 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_43"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_58  (
    .a(\u_video_tx/cx [11:10]),
    .b(2'b01),
    .fci(\u_video_tx/lt15_syn_23 ),
    .fco(\u_video_tx/lt15_syn_27 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt15_syn_43"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt15_syn_60  (
    .a({open_n2727,1'b0}),
    .b({open_n2728,1'b1}),
    .fci(\u_video_tx/lt15_syn_27 ),
    .f({open_n2747,\u_video_tx/data_island_guard_n4 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(151)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_43"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_43  (
    .a(2'b11),
    .b({\u_video_tx/cx [1],open_n2753}),
    .fco(\u_video_tx/lt16_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_43"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_46  (
    .a(2'b11),
    .b(\u_video_tx/cx [3:2]),
    .fci(\u_video_tx/lt16_syn_7 ),
    .fco(\u_video_tx/lt16_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_43"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_49  (
    .a(2'b10),
    .b(\u_video_tx/cx [5:4]),
    .fci(\u_video_tx/lt16_syn_11 ),
    .fco(\u_video_tx/lt16_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_43"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_52  (
    .a(2'b10),
    .b(\u_video_tx/cx [7:6]),
    .fci(\u_video_tx/lt16_syn_15 ),
    .fco(\u_video_tx/lt16_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_43"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_55  (
    .a(2'b11),
    .b(\u_video_tx/cx [9:8]),
    .fci(\u_video_tx/lt16_syn_19 ),
    .fco(\u_video_tx/lt16_syn_23 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_43"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_58  (
    .a(2'b01),
    .b(\u_video_tx/cx [11:10]),
    .fci(\u_video_tx/lt16_syn_23 ),
    .fco(\u_video_tx/lt16_syn_27 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt16_syn_43"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt16_syn_60  (
    .a({open_n2899,1'b0}),
    .b({open_n2900,1'b1}),
    .fci(\u_video_tx/lt16_syn_27 ),
    .f({open_n2919,\u_video_tx/data_island_guard_n5 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(152)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_33"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_33  (
    .a({\u_video_tx/cx [4],1'b0}),
    .b({1'b1,open_n2925}),
    .fco(\u_video_tx/lt17_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_33"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_36  (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b01),
    .fci(\u_video_tx/lt17_syn_6 ),
    .fco(\u_video_tx/lt17_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_33"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_39  (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b11),
    .fci(\u_video_tx/lt17_syn_10 ),
    .fco(\u_video_tx/lt17_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_33"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_42  (
    .a(\u_video_tx/cx [10:9]),
    .b(2'b11),
    .fci(\u_video_tx/lt17_syn_14 ),
    .fco(\u_video_tx/lt17_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt17_syn_33"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt17_syn_45  (
    .a({1'b0,\u_video_tx/cx [11]}),
    .b(2'b10),
    .fci(\u_video_tx/lt17_syn_18 ),
    .f({\u_video_tx/data_island_guard_n6 ,open_n3041}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(153)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_39"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_39  (
    .a({\u_video_tx/cx [2],1'b0}),
    .b({1'b1,open_n3047}),
    .fco(\u_video_tx/lt1_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_39"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_42  (
    .a(\u_video_tx/cx [4:3]),
    .b(2'b00),
    .fci(\u_video_tx/lt1_syn_6 ),
    .fco(\u_video_tx/lt1_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_39"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_45  (
    .a(\u_video_tx/cx [6:5]),
    .b(2'b00),
    .fci(\u_video_tx/lt1_syn_10 ),
    .fco(\u_video_tx/lt1_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_39"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_48  (
    .a(\u_video_tx/cx [8:7]),
    .b(2'b00),
    .fci(\u_video_tx/lt1_syn_14 ),
    .fco(\u_video_tx/lt1_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_39"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_51  (
    .a(\u_video_tx/cx [10:9]),
    .b(2'b00),
    .fci(\u_video_tx/lt1_syn_18 ),
    .fco(\u_video_tx/lt1_syn_22 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt1_syn_39"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt1_syn_54  (
    .a({1'b0,\u_video_tx/cx [11]}),
    .b(2'b11),
    .fci(\u_video_tx/lt1_syn_22 ),
    .f({\u_video_tx/hsync_pulse_n2 ,open_n3187}));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(132)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt2_syn_36"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt2_syn_36  (
    .a(2'b11),
    .b({\u_video_tx/cy [2],open_n3193}),
    .fco(\u_video_tx/lt2_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt2_syn_36"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt2_syn_39  (
    .a(2'b11),
    .b(\u_video_tx/cy [4:3]),
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
    .a(2'b01),
    .b(\u_video_tx/cy [6:5]),
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
    .a(2'b00),
    .b(\u_video_tx/cy [8:7]),
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
    .a(2'b10),
    .b(\u_video_tx/cy [10:9]),
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
    .a({open_n3315,1'b0}),
    .b({open_n3316,1'b1}),
    .fci(\u_video_tx/lt2_syn_22 ),
    .f({open_n3335,\u_video_tx/vsync_pulse_n1 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(134)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_41"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_41  (
    .a({\u_video_tx/cy [0],1'b0}),
    .b({1'b1,open_n3341}),
    .fco(\u_video_tx/lt3_syn_5 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_41"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_44  (
    .a(\u_video_tx/cy [2:1]),
    .b(2'b00),
    .fci(\u_video_tx/lt3_syn_5 ),
    .fco(\u_video_tx/lt3_syn_9 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_41"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_47  (
    .a(\u_video_tx/cy [4:3]),
    .b(2'b00),
    .fci(\u_video_tx/lt3_syn_9 ),
    .fco(\u_video_tx/lt3_syn_13 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_41"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_50  (
    .a(\u_video_tx/cy [6:5]),
    .b(2'b10),
    .fci(\u_video_tx/lt3_syn_13 ),
    .fco(\u_video_tx/lt3_syn_17 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_41"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_53  (
    .a(\u_video_tx/cy [8:7]),
    .b(2'b00),
    .fci(\u_video_tx/lt3_syn_17 ),
    .fco(\u_video_tx/lt3_syn_21 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_41"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_56  (
    .a(\u_video_tx/cy [10:9]),
    .b(2'b10),
    .fci(\u_video_tx/lt3_syn_21 ),
    .fco(\u_video_tx/lt3_syn_25 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt3_syn_41"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt3_syn_58  (
    .a({open_n3487,1'b0}),
    .b({open_n3488,1'b1}),
    .fci(\u_video_tx/lt3_syn_25 ),
    .f({open_n3507,\u_video_tx/vsync_pulse_n2 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(135)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt5_syn_42"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt5_syn_42  (
    .a(2'b11),
    .b({\u_video_tx/cx [1],open_n3513}),
    .fco(\u_video_tx/lt5_syn_6 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt5_syn_42"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt5_syn_45  (
    .a(2'b11),
    .b(\u_video_tx/cx [3:2]),
    .fci(\u_video_tx/lt5_syn_6 ),
    .fco(\u_video_tx/lt5_syn_10 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt5_syn_42"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt5_syn_48  (
    .a(2'b00),
    .b(\u_video_tx/cx [5:4]),
    .fci(\u_video_tx/lt5_syn_10 ),
    .fco(\u_video_tx/lt5_syn_14 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt5_syn_42"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt5_syn_51  (
    .a(2'b10),
    .b(\u_video_tx/cx [7:6]),
    .fci(\u_video_tx/lt5_syn_14 ),
    .fco(\u_video_tx/lt5_syn_18 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt5_syn_42"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt5_syn_54  (
    .a(2'b00),
    .b(\u_video_tx/cx [9:8]),
    .fci(\u_video_tx/lt5_syn_18 ),
    .fco(\u_video_tx/lt5_syn_22 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt5_syn_42"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt5_syn_57  (
    .a(2'b10),
    .b(\u_video_tx/cx [11:10]),
    .fci(\u_video_tx/lt5_syn_22 ),
    .fco(\u_video_tx/lt5_syn_26 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt5_syn_42"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt5_syn_59  (
    .a({open_n3659,1'b0}),
    .b({open_n3660,1'b1}),
    .fci(\u_video_tx/lt5_syn_26 ),
    .f({open_n3679,\u_video_tx/video_preamble_n2 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_43"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_43  (
    .a({\u_video_tx/cx [1],1'b0}),
    .b({1'b1,open_n3685}),
    .fco(\u_video_tx/lt6_syn_7 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_43"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_46  (
    .a(\u_video_tx/cx [3:2]),
    .b(2'b01),
    .fci(\u_video_tx/lt6_syn_7 ),
    .fco(\u_video_tx/lt6_syn_11 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_43"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_49  (
    .a(\u_video_tx/cx [5:4]),
    .b(2'b01),
    .fci(\u_video_tx/lt6_syn_11 ),
    .fco(\u_video_tx/lt6_syn_15 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_43"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_52  (
    .a(\u_video_tx/cx [7:6]),
    .b(2'b10),
    .fci(\u_video_tx/lt6_syn_15 ),
    .fco(\u_video_tx/lt6_syn_19 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_43"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_55  (
    .a(\u_video_tx/cx [9:8]),
    .b(2'b00),
    .fci(\u_video_tx/lt6_syn_19 ),
    .fco(\u_video_tx/lt6_syn_23 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_43"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_58  (
    .a(\u_video_tx/cx [11:10]),
    .b(2'b10),
    .fci(\u_video_tx/lt6_syn_23 ),
    .fco(\u_video_tx/lt6_syn_27 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt6_syn_43"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt6_syn_60  (
    .a({open_n3831,1'b0}),
    .b({open_n3832,1'b1}),
    .fci(\u_video_tx/lt6_syn_27 ),
    .f({open_n3851,\u_video_tx/video_preamble_n3 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(145)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_41"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_41  (
    .a({\u_video_tx/cy [0],1'b0}),
    .b({1'b1,open_n3857}),
    .fco(\u_video_tx/lt8_syn_5 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_41"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_44  (
    .a(\u_video_tx/cy [2:1]),
    .b(2'b11),
    .fci(\u_video_tx/lt8_syn_5 ),
    .fco(\u_video_tx/lt8_syn_9 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_41"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_47  (
    .a(\u_video_tx/cy [4:3]),
    .b(2'b10),
    .fci(\u_video_tx/lt8_syn_9 ),
    .fco(\u_video_tx/lt8_syn_13 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_41"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_50  (
    .a(\u_video_tx/cy [6:5]),
    .b(2'b01),
    .fci(\u_video_tx/lt8_syn_13 ),
    .fco(\u_video_tx/lt8_syn_17 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_41"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_53  (
    .a(\u_video_tx/cy [8:7]),
    .b(2'b00),
    .fci(\u_video_tx/lt8_syn_17 ),
    .fco(\u_video_tx/lt8_syn_21 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_41"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_56  (
    .a(\u_video_tx/cy [10:9]),
    .b(2'b10),
    .fci(\u_video_tx/lt8_syn_21 ),
    .fco(\u_video_tx/lt8_syn_25 ));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
  EG_PHY_MSLICE #(
    //.MACRO("u_video_tx/lt8_syn_41"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_video_tx/lt8_syn_58  (
    .a({open_n4003,1'b0}),
    .b({open_n4004,1'b1}),
    .fci(\u_video_tx/lt8_syn_25 ),
    .f({open_n4023,\u_video_tx/mode_b1_n6 }));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(146)
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
  AL_MAP_LUT4 #(
    .EQN("(D@(C*B*A))"),
    .INIT(16'h7f80))
    \u_video_tx/packet_ecc/counter_reg[2]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
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
  AL_MAP_LUT3 #(
    .EQN("(C@(B*A))"),
    .INIT(8'h78))
    \u_video_tx/packet_ecc/counter_reg[3]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/add0_syn_22 ),
    .c(\u_video_tx/packet_ecc/counter [3]),
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
  AL_MAP_LUT4 #(
    .EQN("(D@(C*B*A))"),
    .INIT(16'h7f80))
    \u_video_tx/packet_ecc/counter_reg[4]_syn_3  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/add0_syn_22 ),
    .c(\u_video_tx/packet_ecc/counter [3]),
    .d(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/counter_reg[4]_syn_2 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(62)
  AL_MAP_LUT3 #(
    .EQN("~(C*B*A)"),
    .INIT(8'h7f))
    \u_video_tx/packet_ecc/mux25_syn_32  (
    .a(startup_done),
    .b(rst_n_dup_1),
    .c(pll_lock),
    .o(\u_build_id/rst ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(70)
  AL_MAP_LUT4 #(
    .EQN("~(~D*A*~(~C*B))"),
    .INIT(16'hff5d))
    \u_video_tx/packet_ecc/mux25_syn_33  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/packet_ecc/add0_syn_22 ),
    .c(\u_video_tx/packet_ecc/parity4_b3_n ),
    .d(\u_build_id/rst ),
    .o(\u_video_tx/packet_ecc/mux25_syn_2 [3]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(70)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity0_next2[0]_syn_1  (
    .a(\u_video_tx/packet_ecc/parity0_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/bch0 [58]),
    .o(\u_video_tx/packet_ecc/parity0_next2 [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity0_next2[1]_syn_1  (
    .a(\u_video_tx/packet_ecc/mux0_syn_70 ),
    .b(\u_video_tx/packet_ecc/bch0 [56]),
    .o(\u_video_tx/packet_ecc/parity0_next2 [6]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity0_next2[1]_syn_2  (
    .a(\u_video_tx/tmds_red/mux7_syn_136 ),
    .b(\u_video_tx/packet_ecc/bch0 [57]),
    .o(\u_video_tx/packet_ecc/parity0_next2[1]_syn_3 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
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
    .a(\u_video_tx/packet_ecc/parity1_next2[1]_syn_5 ),
    .b(\u_video_tx/packet_ecc/bch1 [58]),
    .o(\u_video_tx/packet_ecc/parity1_next2 [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hf335))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_1  (
    .a(\u_video_tx/packet_ecc/mux6_syn_22 ),
    .b(\u_video_tx/packet_ecc/mux2_syn_28 ),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/parity1_next2[1]_syn_2 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT4 #(
    .EQN("(D@~(~B*~(A)*~(C)+~B*A*~(C)+~(~B)*A*C+~B*A*C))"),
    .INIT(16'ha35c))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_3  (
    .a(\u_video_tx/packet_ecc/parity1_next2[1]_syn_2 ),
    .b(\u_video_tx/packet_ecc/mux27_syn_124 ),
    .c(\u_video_tx/packet_ecc/counter [4]),
    .d(\u_video_tx/packet_ecc/bch1 [56]),
    .o(\u_video_tx/packet_ecc/parity1_next2 [6]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_4  (
    .a(\u_video_tx/tmds_red/mux7_syn_128 ),
    .b(\u_video_tx/packet_ecc/bch1 [57]),
    .o(\u_video_tx/packet_ecc/parity1_next2[1]_syn_5 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_6  (
    .a(\u_video_tx/packet_ecc/parity1_next2 [6]),
    .b(\u_video_tx/packet_ecc/parity1_next2[1]_syn_5 ),
    .o(\u_video_tx/packet_ecc/parity1_next2 [7]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity1_next2[1]_syn_7  (
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
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity2_next2[1]_syn_2  (
    .a(\u_video_tx/tmds_red/mux7_syn_125 ),
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
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity3_next2[0]_syn_1  (
    .a(\u_video_tx/packet_ecc/parity3_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/bch3 [58]),
    .o(\u_video_tx/packet_ecc/parity3_next2 [0]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT4 #(
    .EQN("(D@(~C*B*A))"),
    .INIT(16'hf708))
    \u_video_tx/packet_ecc/parity3_next2[1]_syn_1  (
    .a(\u_video_tx/tmds_green/mux7_syn_140 ),
    .b(\u_video_tx/packet_ecc/mux27_syn_206 ),
    .c(\u_video_tx/packet_ecc/counter [4]),
    .d(\u_video_tx/packet_ecc/bch3 [56]),
    .o(\u_video_tx/packet_ecc/parity3_next2 [6]));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT4 #(
    .EQN("(D@(~C*~B*A))"),
    .INIT(16'hfd02))
    \u_video_tx/packet_ecc/parity3_next2[1]_syn_2  (
    .a(\u_video_tx/packet_ecc/mux26_syn_116 ),
    .b(\u_video_tx/packet_ecc/counter [3]),
    .c(\u_video_tx/packet_ecc/counter [4]),
    .d(\u_video_tx/packet_ecc/bch3 [57]),
    .o(\u_video_tx/packet_ecc/parity3_next2[1]_syn_3 ));  // ../user_source/hdl_source/open_tx/packet_assembler_compat.v(30)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity3_next2[1]_syn_4  (
    .a(\u_video_tx/packet_ecc/parity3_next2[1]_syn_3 ),
    .b(\u_video_tx/packet_ecc/parity3_next2 [6]),
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
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_video_tx/packet_ecc/parity4_next[1]_syn_1  (
    .a(\u_video_tx/packet_ecc/mux8_syn_44 ),
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
    .b({\u_video_tx/tmds_blue/acc [4],open_n4034}),
    .clk(\u_build_id/clk ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_blue/add1_syn_24 ),
    .q({\u_video_tx/tmds_blue/acc [1],open_n4056}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
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
    .a({open_n4077,1'b0}),
    .b({open_n4078,1'b1}),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_blue/add1_syn_26 ),
    .sr(\u_video_tx/active ),
    .q({open_n4100,\u_video_tx/tmds_blue/acc [4]}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \u_video_tx/tmds_blue/mux9_syn_138  (
    .a(\u_video_tx/packet_ecc/counter [0]),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/packet_ecc/add0_syn_22 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_video_tx/tmds_blue/mux9_syn_139  (
    .a(\u_video_tx/cx [6]),
    .b(\u_video_tx/cx [8]),
    .c(\u_video_tx/cx [9]),
    .d(\u_video_tx/cx [10]),
    .o(\u_video_tx/tmds_blue/mux9_syn_140 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_blue/mux9_syn_141  (
    .a(\u_video_tx/cx [3]),
    .b(\u_video_tx/cx [5]),
    .o(\u_video_tx/tmds_blue/mux9_syn_142 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~D*~(~A*~(~C*B)))"),
    .INIT(16'h00ae))
    \u_video_tx/tmds_blue/mux9_syn_143  (
    .a(rgb_b4_n),
    .b(rgb_b5_n),
    .c(rgb_b5_n1),
    .d(rgb_b3_n),
    .o(rgb_b3[7]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(~D*~(~C*~A)))"),
    .INIT(16'h3301))
    \u_video_tx/tmds_blue/mux9_syn_144  (
    .a(rgb_b3[7]),
    .b(rgb_b_n),
    .c(rgb_b2_n),
    .d(rgb_b1_n),
    .o(\u_video_tx/tmds_blue/video_data[7]_syn_2 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \u_video_tx/tmds_blue/mux9_syn_145  (
    .a(\u_video_tx/tmds_red/mux7_syn_119 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/tmds_blue/mux9_syn_146 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~C*~(~B*~A))"),
    .INIT(8'h0e))
    \u_video_tx/tmds_blue/mux9_syn_147  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/tmds_green/mux7_syn_153 ),
    .c(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/tmds_blue/mux9_syn_148 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~C*~(A*~(~D*~B)))"),
    .INIT(16'h0507))
    \u_video_tx/tmds_blue/mux9_syn_149  (
    .a(\u_video_tx/tmds_blue/mux9_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_119 ),
    .c(\u_video_tx/tmds_red/mux7_syn_121 ),
    .d(\u_video_tx/packet_ecc/add0_syn_22 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_150 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hfff513f1))
    \u_video_tx/tmds_blue/mux9_syn_151  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/tmds_green/mux7_syn_153 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .e(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_blue/mux9_syn_152 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~(~B*A)*~((~D*~C))*~(E)+~(~B*A)*(~D*~C)*~(E)+~(~(~B*A))*(~D*~C)*E+~(~B*A)*(~D*~C)*E)"),
    .INIT(32'h000fdddd))
    \u_video_tx/tmds_blue/mux9_syn_153  (
    .a(\u_video_tx/tmds_blue/mux9_syn_150 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_146 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_152 ),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/mux8_syn_44 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_blue/mux9_syn_154  (
    .a(\u_video_tx/packet_ecc/parity4 [3]),
    .b(\u_video_tx/packet_ecc/parity4 [2]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_blue/mux9_syn_155 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_blue/mux9_syn_156  (
    .a(\u_video_tx/packet_ecc/parity4 [0]),
    .b(\u_video_tx/packet_ecc/parity4 [1]),
    .c(\u_video_tx/tmds_blue/mux9_syn_155 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux9_syn_36 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_blue/mux9_syn_157  (
    .a(\u_video_tx/packet_ecc/parity4 [7]),
    .b(\u_video_tx/packet_ecc/parity4 [6]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_blue/mux9_syn_158 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_blue/mux9_syn_159  (
    .a(\u_video_tx/packet_ecc/parity4 [4]),
    .b(\u_video_tx/packet_ecc/parity4 [5]),
    .c(\u_video_tx/tmds_blue/mux9_syn_158 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux9_syn_38 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~A*~(~D*(B*~(C)*~(E)+B*C*~(E)+~(B)*C*E+B*C*E)))"),
    .INIT(32'h55055511))
    \u_video_tx/tmds_blue/mux9_syn_160  (
    .a(\u_video_tx/packet_ecc/mux8_syn_44 ),
    .b(\u_video_tx/packet_ecc/mux9_syn_36 ),
    .c(\u_video_tx/packet_ecc/mux9_syn_38 ),
    .d(\u_video_tx/packet_ecc/parity4_b3_n ),
    .e(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_blue/mux6_syn_112 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~E*D*~C*B*A)"),
    .INIT(32'h00000800))
    \u_video_tx/tmds_blue/mux9_syn_161  (
    .a(\u_video_tx/tmds_green/mux7_syn_151 ),
    .b(\u_video_tx/tmds_green/mux7_syn_127 ),
    .c(\u_video_tx/cy [5]),
    .d(\u_video_tx/cy [6]),
    .e(\u_video_tx/cy [7]),
    .o(\u_video_tx/vsync_n5 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*~A)"),
    .INIT(16'h4000))
    \u_video_tx/tmds_blue/mux9_syn_162  (
    .a(\u_video_tx/cy [2]),
    .b(\u_video_tx/cy [3]),
    .c(\u_video_tx/cy [4]),
    .d(\u_video_tx/cy [5]),
    .o(\u_video_tx/tmds_blue/mux9_syn_163 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*A)"),
    .INIT(16'h0008))
    \u_video_tx/tmds_blue/mux9_syn_164  (
    .a(\u_video_tx/cy [0]),
    .b(\u_video_tx/cy [1]),
    .c(\u_video_tx/cy [6]),
    .d(\u_video_tx/cy [7]),
    .o(\u_video_tx/tmds_blue/mux9_syn_165 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \u_video_tx/tmds_blue/mux9_syn_166  (
    .a(\u_video_tx/tmds_blue/mux9_syn_163 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_165 ),
    .c(\u_video_tx/tmds_green/mux7_syn_127 ),
    .o(\u_video_tx/vsync_n2 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~((E*D))+~(A)*B*~(C)*~((E*D))+A*B*~(C)*~((E*D))+~(A)*~(B)*C*~((E*D))+A*~(B)*C*~((E*D))+~(A)*B*~(C)*(E*D)+A*B*~(C)*(E*D)+A*~(B)*C*(E*D))"),
    .INIT(32'h2c3d3d3d))
    \u_video_tx/tmds_blue/mux9_syn_167  (
    .a(\u_video_tx/vsync_n5 ),
    .b(\u_video_tx/vsync_n2 ),
    .c(\u_video_tx/vsync_n1 ),
    .d(\u_video_tx/vsync_pulse_n2 ),
    .e(\u_video_tx/vsync_pulse_n1 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_168 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_blue/mux9_syn_169  (
    .a(\u_video_tx/vsync_n1 ),
    .b(\u_video_tx/hsync_pulse_n2 ),
    .o(\u_video_tx/tmds_blue/mux5_syn_17 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_blue/mux9_syn_170  (
    .a(\u_video_tx/tmds_blue/mux9_syn_168 ),
    .b(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .o(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_video_tx/tmds_blue/mux9_syn_171  (
    .a(\u_video_tx/cx [2]),
    .b(\u_video_tx/cx [4]),
    .c(\u_video_tx/cx [7]),
    .d(\u_video_tx/cx [11]),
    .o(\u_video_tx/tmds_blue/mux9_syn_172 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*C*B*A)"),
    .INIT(32'h00000080))
    \u_video_tx/tmds_blue/mux9_syn_173  (
    .a(\u_video_tx/tmds_blue/mux9_syn_140 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_172 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_142 ),
    .d(\u_video_tx/cx [0]),
    .e(\u_video_tx/cx [1]),
    .o(\u_video_tx/tmds_blue/mux9_syn_174 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_blue/mux9_syn_175  (
    .a(\u_video_tx/tmds_blue/mux9_syn_168 ),
    .b(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .o(\u_video_tx/tmds_blue/data_guard_band_b1_n ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_video_tx/tmds_blue/mux9_syn_176  (
    .a(\u_video_tx/tmds_blue/mux9_syn_168 ),
    .b(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .o(\u_video_tx/tmds_blue/data_guard_band_b_n ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("~(B@A)"),
    .INIT(4'h9))
    \u_video_tx/tmds_blue/mux9_syn_177  (
    .a(\u_video_tx/tmds_blue/mux9_syn_168 ),
    .b(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .o(\u_video_tx/tmds_blue/mux6_syn_42 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(B*(A*C*~(D)*~(E)+~(A)*~(C)*D*~(E)+A*~(C)*D*~(E)+~(A)*C*D*~(E)+A*C*D*~(E)+~(A)*~(C)*~(D)*E+~(A)*C*~(D)*E+~(A)*~(C)*D*E+~(A)*C*D*E))"),
    .INIT(32'h4444cc80))
    \u_video_tx/tmds_blue/mux9_syn_178  (
    .a(\u_video_tx/tmds_blue/mux6_syn_112 ),
    .b(\u_video_tx/tmds_green/mux7_syn_164 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ),
    .d(\u_video_tx/tmds_blue/data_guard_band_b1_n ),
    .e(\u_video_tx/tmds_blue/mux9_syn_174 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_179 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(B*~(~C*~(D@A)))"),
    .INIT(16'hc4c8))
    \u_video_tx/tmds_blue/mux9_syn_180  (
    .a(\u_video_tx/tmds_blue/video_data[7]_syn_2 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_green/mux7_syn_162 ),
    .d(\u_video_tx/tmds_blue/acc [4]),
    .o(\u_video_tx/tmds_blue/mux9_syn_181 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(B*~(D*~C)))"),
    .INIT(16'h1511))
    \u_video_tx/tmds_blue/mux9_syn_182  (
    .a(\u_video_tx/tmds_blue/mux9_syn_179 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_181 ),
    .c(\u_video_tx/tmds_blue/mux6_syn_42 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_119 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h661b))
    \u_video_tx/tmds_blue/mux9_syn_183  (
    .a(\u_video_tx/tmds_blue/mux6_syn_112 ),
    .b(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .c(\u_video_tx/tmds_blue/mux6_syn_42 ),
    .d(\u_video_tx/tmds_blue/mux9_syn_174 ),
    .o(\u_video_tx/tmds_blue/mux6_syn_94 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*~(~D*~(C)*~(B)+~D*C*~(B)+~(~D)*C*B+~D*C*B))"),
    .INIT(16'h2a08))
    \u_video_tx/tmds_blue/mux9_syn_184  (
    .a(\u_video_tx/tmds_green/mux7_syn_160 ),
    .b(\u_video_tx/tmds_green/mux7_syn_162 ),
    .c(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .d(\u_video_tx/tmds_blue/acc [4]),
    .o(\u_video_tx/tmds_blue/mux9_syn_185 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(~C*~(~D*~A)))"),
    .INIT(16'h3031))
    \u_video_tx/tmds_blue/mux9_syn_186  (
    .a(\u_video_tx/tmds_blue/mux6_syn_94 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_185 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_187 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'h53))
    \u_video_tx/tmds_blue/mux9_syn_188  (
    .a(\u_video_tx/tmds_blue/mux9_syn_187 ),
    .b(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .c(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_87 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(D@C)*~(B)*~(A)+~(D@C)*B*~(A)+~(~(D@C))*B*A+~(D@C)*B*A)"),
    .INIT(16'hd88d))
    \u_video_tx/tmds_blue/mux9_syn_189  (
    .a(\u_video_tx/tmds_blue/mux6_syn_112 ),
    .b(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .d(\u_video_tx/tmds_blue/mux9_syn_174 ),
    .o(\u_video_tx/tmds_blue/mux6_syn_30 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~B*~(~C*A))"),
    .INIT(8'h31))
    \u_video_tx/tmds_blue/mux9_syn_190  (
    .a(\u_video_tx/tmds_blue/mux6_syn_30 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_191 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*(D*~(C)*~(B)+D*C*~(B)+~(D)*C*B+D*C*B))"),
    .INIT(16'ha280))
    \u_video_tx/tmds_blue/mux9_syn_192  (
    .a(\u_video_tx/tmds_green/mux7_syn_160 ),
    .b(\u_video_tx/tmds_green/mux7_syn_162 ),
    .c(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .d(\u_video_tx/tmds_blue/acc [4]),
    .o(\u_video_tx/tmds_blue/mux9_syn_193 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(~D*~C*A))"),
    .INIT(16'h3331))
    \u_video_tx/tmds_blue/mux9_syn_194  (
    .a(\u_video_tx/tmds_blue/mux6_syn_30 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_193 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_195 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'h53))
    \u_video_tx/tmds_blue/mux9_syn_196  (
    .a(\u_video_tx/tmds_blue/mux9_syn_195 ),
    .b(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .c(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_23 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(B*(~(A)*~(C)*~(D)*~(E)+~(A)*C*~(D)*~(E)+~(A)*~(C)*D*~(E)+A*~(C)*D*~(E)+~(A)*~(C)*~(D)*E+A*~(C)*D*E+~(A)*C*D*E+A*C*D*E))"),
    .INIT(32'hc8040c44))
    \u_video_tx/tmds_blue/mux9_syn_197  (
    .a(\u_video_tx/tmds_blue/mux6_syn_112 ),
    .b(\u_video_tx/tmds_green/mux7_syn_164 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_168 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .e(\u_video_tx/tmds_blue/mux9_syn_174 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_198 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(C*~((~B*~A))*~(D)+C*(~B*~A)*~(D)+~(C)*(~B*~A)*D+C*(~B*~A)*D)"),
    .INIT(16'hee0f))
    \u_video_tx/tmds_blue/mux9_syn_199  (
    .a(\u_video_tx/tmds_blue/mux9_syn_198 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_193 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_35 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(B*(A*~(C)*~(D)*~(E)+~(A)*C*D*~(E)+A*C*D*~(E)+~(A)*C*~(D)*E+A*C*~(D)*E+~(A)*~(C)*D*E+~(A)*C*D*E))"),
    .INIT(32'h44c0c008))
    \u_video_tx/tmds_blue/mux9_syn_200  (
    .a(\u_video_tx/tmds_blue/mux6_syn_112 ),
    .b(\u_video_tx/tmds_green/mux7_syn_164 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_168 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .e(\u_video_tx/tmds_blue/mux9_syn_174 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_201 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~((~B*~A))*~(D)+~C*(~B*~A)*~(D)+~(~C)*(~B*~A)*D+~C*(~B*~A)*D)"),
    .INIT(16'heef0))
    \u_video_tx/tmds_blue/mux9_syn_202  (
    .a(\u_video_tx/tmds_blue/mux9_syn_201 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_185 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n1 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_67 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(B*~(~A*~(D)*~(C)+~A*D*~(C)+~(~A)*D*C+~A*D*C))"),
    .INIT(16'h08c8))
    \u_video_tx/tmds_blue/mux9_syn_203  (
    .a(\u_video_tx/tmds_blue/video_data[7]_syn_2 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_green/mux7_syn_162 ),
    .d(\u_video_tx/tmds_blue/mux5_syn_17 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_204 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~((~B*~A))*~(D)+~C*(~B*~A)*~(D)+~(~C)*(~B*~A)*D+~C*(~B*~A)*D)"),
    .INIT(16'heef0))
    \u_video_tx/tmds_blue/mux9_syn_205  (
    .a(\u_video_tx/tmds_blue/mux9_syn_179 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_204 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b1_n ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_111 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~((~B*~A))*~(D)+~C*(~B*~A)*~(D)+~(~C)*(~B*~A)*D+~C*(~B*~A)*D)"),
    .INIT(16'heef0))
    \u_video_tx/tmds_blue/mux9_syn_206  (
    .a(\u_video_tx/tmds_blue/mux9_syn_191 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_185 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_47 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(~C*~((~B*~A))*~(D)+~C*(~B*~A)*~(D)+~(~C)*(~B*~A)*D+~C*(~B*~A)*D)"),
    .INIT(16'heef0))
    \u_video_tx/tmds_blue/mux9_syn_207  (
    .a(\u_video_tx/tmds_blue/mux9_syn_191 ),
    .b(\u_video_tx/tmds_blue/mux9_syn_193 ),
    .c(\u_video_tx/tmds_blue/data_guard_band_b_n ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_blue/mux9_syn_55 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
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
    .q(\u_video_tx/tmds_blue/tmds [0]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_blue/tmds [1]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_blue/tmds [2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_blue/tmds [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_blue/tmds [4]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_blue/tmds [6]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_blue/tmds [8]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .d(\u_video_tx/tmds_blue/mux9_syn_119 ),
    .q(\u_video_tx/tmds_blue/tmds [9]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_green/acc_add[3]_syn_3  (
    .a(rgb_b3_n),
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
    .b({\u_video_tx/tmds_green/acc [4],open_n4117}),
    .clk(\u_build_id/clk ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_green/add1_syn_24 ),
    .q({\u_video_tx/tmds_green/acc [1],open_n4139}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
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
    .a({open_n4160,1'b0}),
    .b({open_n4161,1'b1}),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_green/add1_syn_26 ),
    .sr(\u_video_tx/active ),
    .q({open_n4183,\u_video_tx/tmds_green/acc [4]}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_green/mux7_syn_116  (
    .a(\u_video_tx/data_island_guard_n4 ),
    .b(\u_video_tx/data_island_guard_n5 ),
    .o(\u_video_tx/tmds_green/mux7_syn_117 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("~(B*A)"),
    .INIT(4'h7))
    \u_video_tx/tmds_green/mux7_syn_118  (
    .a(\u_video_tx/packet_ecc/counter [3]),
    .b(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/parity4_b3_n ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("~(B*~A)"),
    .INIT(4'hb))
    \u_video_tx/tmds_green/mux7_syn_119  (
    .a(\u_video_tx/packet_ecc/parity4_b3_n ),
    .b(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/packet_ecc/parity0_b1_n ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_green/mux7_syn_120  (
    .a(\u_video_tx/packet_ecc/counter [2]),
    .b(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/mux27_syn_206 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_video_tx/tmds_green/mux7_syn_121  (
    .a(\u_video_tx/cx [7]),
    .b(\u_video_tx/cx [8]),
    .c(\u_video_tx/cx [9]),
    .d(\u_video_tx/cx [10]),
    .o(\u_video_tx/tmds_green/mux7_syn_122 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \u_video_tx/tmds_green/mux7_syn_123  (
    .a(\u_video_tx/active_n2 ),
    .b(\u_video_tx/tmds_green/mux7_syn_122 ),
    .c(\u_video_tx/cx [11]),
    .o(\u_video_tx/active ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_green/mux7_syn_124  (
    .a(\u_video_tx/cy [3]),
    .b(\u_video_tx/cy [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_125 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*~A)"),
    .INIT(8'h10))
    \u_video_tx/tmds_green/mux7_syn_126  (
    .a(\u_video_tx/cy [8]),
    .b(\u_video_tx/cy [9]),
    .c(\u_video_tx/cy [10]),
    .o(\u_video_tx/tmds_green/mux7_syn_127 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~C*B*A)"),
    .INIT(8'h08))
    \u_video_tx/tmds_green/mux7_syn_128  (
    .a(\u_video_tx/tmds_green/mux7_syn_125 ),
    .b(\u_video_tx/cy [6]),
    .c(\u_video_tx/cy [7]),
    .o(\u_video_tx/tmds_green/mux7_syn_129 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*~A)"),
    .INIT(16'h1000))
    \u_video_tx/tmds_green/mux7_syn_130  (
    .a(\u_video_tx/cy [0]),
    .b(\u_video_tx/cy [1]),
    .c(\u_video_tx/cy [2]),
    .d(\u_video_tx/cy [5]),
    .o(\u_video_tx/tmds_green/mux7_syn_131 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \u_video_tx/tmds_green/mux7_syn_132  (
    .a(\u_video_tx/tmds_green/mux7_syn_129 ),
    .b(\u_video_tx/tmds_green/mux7_syn_131 ),
    .c(\u_video_tx/tmds_green/mux7_syn_127 ),
    .o(frame_count_b1_n2));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_video_tx/tmds_green/mux7_syn_133  (
    .a(\u_video_tx/cy [5]),
    .b(\u_video_tx/cy [8]),
    .c(\u_video_tx/cy [9]),
    .d(\u_video_tx/cy [10]),
    .o(\u_video_tx/tmds_green/mux7_syn_134 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \u_video_tx/tmds_green/mux7_syn_135  (
    .a(\u_video_tx/tmds_green/mux7_syn_134 ),
    .b(\u_video_tx/cy [6]),
    .c(\u_video_tx/cy [7]),
    .o(\u_video_tx/tmds_green/mux7_syn_136 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~E*~D*C*B*A)"),
    .INIT(32'h00000080))
    \u_video_tx/tmds_green/mux7_syn_137  (
    .a(\u_video_tx/tmds_green/mux7_syn_136 ),
    .b(\u_video_tx/tmds_green/mux7_syn_125 ),
    .c(\u_video_tx/cy [0]),
    .d(\u_video_tx/cy [1]),
    .e(\u_video_tx/cy [2]),
    .o(\u_video_tx/tmds_green/mux7_syn_138 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_green/mux7_syn_139  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_140 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_green/mux7_syn_141  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .o(\u_video_tx/packet_ecc/mux6_syn_22 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~D*A*~(~C*(E@B)))"),
    .INIT(32'h00a800a2))
    \u_video_tx/tmds_green/mux7_syn_142  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .e(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/mux2_syn_50 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \u_video_tx/tmds_green/mux7_syn_143  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_green/mux7_syn_144 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_video_tx/tmds_green/mux7_syn_145  (
    .a(\u_video_tx/tmds_green/mux7_syn_144 ),
    .b(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/tmds_green/mux7_syn_146 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("((~D*~(~B*~A))*~(C)*~(E)+(~D*~(~B*~A))*C*~(E)+~((~D*~(~B*~A)))*C*E+(~D*~(~B*~A))*C*E)"),
    .INIT(32'hf0f000ee))
    \u_video_tx/tmds_green/mux7_syn_147  (
    .a(\u_video_tx/tmds_green/mux7_syn_146 ),
    .b(\u_video_tx/packet_ecc/mux6_syn_22 ),
    .c(\u_video_tx/packet_ecc/mux2_syn_50 ),
    .d(\u_video_tx/packet_ecc/mux27_syn_206 ),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/mux2_syn_52 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*~B))"),
    .INIT(8'h8a))
    \u_video_tx/tmds_green/mux7_syn_148  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux2_syn_28 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(A*(B*~(C)*~(D)*~(E)+B*C*~(D)*~(E)+~(B)*~(C)*D*~(E)+B*~(C)*D*~(E)+~(B)*C*D*~(E)+B*C*D*~(E)+B*~(C)*~(D)*E+~(B)*C*~(D)*E+B*C*~(D)*E+~(B)*~(C)*D*E+B*C*D*E))"),
    .INIT(32'h82a8aa88))
    \u_video_tx/tmds_green/mux7_syn_149  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .e(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/mux27_syn_124 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \u_video_tx/tmds_green/mux7_syn_150  (
    .a(\u_video_tx/tmds_green/mux7_syn_125 ),
    .b(\u_video_tx/cy [0]),
    .c(\u_video_tx/cy [1]),
    .d(\u_video_tx/cy [2]),
    .o(\u_video_tx/tmds_green/mux7_syn_151 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_green/mux7_syn_152  (
    .a(\u_video_tx/tmds_green/mux7_syn_136 ),
    .b(\u_video_tx/tmds_green/mux7_syn_151 ),
    .o(\u_video_tx/tmds_green/mux7_syn_153 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+A*~(B)*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+~(A)*B*C*D*E)"),
    .INIT(32'h5f5f1533))
    \u_video_tx/tmds_green/mux7_syn_154  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/tmds_green/mux7_syn_153 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .e(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_green/mux7_syn_155 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~A*~((B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D))*~(E)+~A*(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)*~(E)+~(~A)*(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)*E+~A*(B*~(C)*~(D)+B*C*~(D)+~(B)*C*D+B*C*D)*E)"),
    .INIT(32'hf0cc5555))
    \u_video_tx/tmds_green/mux7_syn_156  (
    .a(\u_video_tx/tmds_green/mux7_syn_155 ),
    .b(\u_video_tx/tmds_green/mux7_syn_140 ),
    .c(\u_video_tx/packet_ecc/mux2_syn_28 ),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .e(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/mux27_syn_76 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(A*(~(B)*~(C)*~(D)*~(E)+B*C*~(D)*~(E)+~(B)*~(C)*D*~(E)+B*C*D*~(E)+B*~(C)*~(D)*E+B*C*~(D)*E))"),
    .INIT(32'h00888282))
    \u_video_tx/tmds_green/mux7_syn_157  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .e(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/mux0_syn_68 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_video_tx/tmds_green/mux7_syn_158  (
    .a(\u_video_tx/packet_ecc/mux27_syn_76 ),
    .b(\u_video_tx/packet_ecc/mux0_syn_68 ),
    .c(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/packet_ecc/mux0_syn_70 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(~C*~(~D*~B)))"),
    .INIT(16'h5051))
    \u_video_tx/tmds_green/mux7_syn_159  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(frame_count_b1_n2),
    .c(\u_video_tx/video_preamble_n3 ),
    .d(\u_video_tx/mode_b1_n6 ),
    .o(\u_video_tx/tmds_green/mux7_syn_160 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_green/mux7_syn_161  (
    .a(\u_video_tx/tmds_green/mux7_syn_117 ),
    .b(\u_video_tx/active ),
    .o(\u_video_tx/tmds_green/mux7_syn_162 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/tmds_green/mux7_syn_163  (
    .a(\u_video_tx/tmds_green/mux7_syn_160 ),
    .b(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_green/mux7_syn_164 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(D*C)*~(B*~A))"),
    .INIT(16'h0bbb))
    \u_video_tx/tmds_green/mux7_syn_165  (
    .a(\u_video_tx/data_island_preamble_n2 ),
    .b(\u_video_tx/data_island_guard_n4 ),
    .c(\u_video_tx/data_island_guard_n5 ),
    .d(\u_video_tx/data_island_guard_n6 ),
    .o(\u_video_tx/tmds_green/mux7_syn_166 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*B))"),
    .INIT(8'h2a))
    \u_video_tx/tmds_green/mux7_syn_167  (
    .a(\u_video_tx/tmds_green/mux7_syn_162 ),
    .b(\u_video_tx/data_island_preamble_n1 ),
    .c(\u_video_tx/data_island_preamble_n2 ),
    .o(\u_video_tx/tmds_green/mux7_syn_168 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_green/mux7_syn_169  (
    .a(\u_video_tx/packet_ecc/bch3 [62]),
    .b(\u_video_tx/packet_ecc/bch3 [60]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_170 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_green/mux7_syn_171  (
    .a(\u_video_tx/packet_ecc/bch3 [56]),
    .b(\u_video_tx/packet_ecc/bch3 [58]),
    .c(\u_video_tx/tmds_green/mux7_syn_170 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux27_syn_186 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E)"),
    .INIT(32'h3ffffff5))
    \u_video_tx/tmds_green/mux7_syn_172  (
    .a(\u_video_tx/tmds_green/mux7_syn_140 ),
    .b(\u_video_tx/packet_ecc/mux27_syn_186 ),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_173 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_green/mux7_syn_174  (
    .a(\u_video_tx/packet_ecc/bch1 [62]),
    .b(\u_video_tx/packet_ecc/bch1 [60]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_175 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_green/mux7_syn_176  (
    .a(\u_video_tx/packet_ecc/bch1 [56]),
    .b(\u_video_tx/packet_ecc/bch1 [58]),
    .c(\u_video_tx/tmds_green/mux7_syn_175 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux27_syn_114 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E+A*B*C*D*E)"),
    .INIT(32'hf0ccccaa))
    \u_video_tx/tmds_green/mux7_syn_177  (
    .a(\u_video_tx/packet_ecc/mux6_syn_22 ),
    .b(\u_video_tx/packet_ecc/mux2_syn_28 ),
    .c(\u_video_tx/packet_ecc/mux27_syn_114 ),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .e(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/mux27_syn_126 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_video_tx/tmds_green/mux7_syn_178  (
    .a(\u_video_tx/packet_ecc/mux27_syn_126 ),
    .b(\u_video_tx/packet_ecc/mux27_syn_124 ),
    .c(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_179 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_green/mux7_syn_180  (
    .a(\u_video_tx/packet_ecc/bch0 [62]),
    .b(\u_video_tx/packet_ecc/bch0 [60]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_181 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_green/mux7_syn_182  (
    .a(\u_video_tx/packet_ecc/bch0 [56]),
    .b(\u_video_tx/packet_ecc/bch0 [58]),
    .c(\u_video_tx/tmds_green/mux7_syn_181 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux27_syn_66 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u_video_tx/tmds_green/mux7_syn_183  (
    .a(\u_video_tx/packet_ecc/mux0_syn_70 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux27_syn_66 ),
    .o(\u_video_tx/tmds_green/mux7_syn_184 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_green/mux7_syn_185  (
    .a(\u_video_tx/packet_ecc/bch2 [62]),
    .b(\u_video_tx/packet_ecc/bch2 [60]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_green/mux7_syn_186 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_green/mux7_syn_187  (
    .a(\u_video_tx/packet_ecc/bch2 [56]),
    .b(\u_video_tx/packet_ecc/bch2 [58]),
    .c(\u_video_tx/tmds_green/mux7_syn_186 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux27_syn_152 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u_video_tx/tmds_green/mux7_syn_188  (
    .a(\u_video_tx/packet_ecc/mux2_syn_52 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux27_syn_152 ),
    .o(\u_video_tx/tmds_green/mux6_syn_196 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*B*~(C)*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'he47a))
    \u_video_tx/tmds_green/mux7_syn_189  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .o(\u_video_tx/tmds_green/mux7_syn_190 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(A*~(D*C*~(~E*~B)))"),
    .INIT(32'h0aaa2aaa))
    \u_video_tx/tmds_green/mux7_syn_191  (
    .a(\u_video_tx/tmds_green/mux7_syn_168 ),
    .b(frame_count_b1_n2),
    .c(\u_video_tx/video_preamble_n2 ),
    .d(\u_video_tx/video_preamble_n3 ),
    .e(\u_video_tx/mode_b1_n6 ),
    .o(\u_video_tx/tmds_green/mux7_syn_192 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(B*~(~A*~(D*~C)))"),
    .INIT(16'h8c88))
    \u_video_tx/tmds_green/mux7_syn_193  (
    .a(\u_video_tx/tmds_green/mux7_syn_192 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_green/mux7_syn_162 ),
    .d(\u_video_tx/tmds_green/acc [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_194 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(~B*~(~C*~(~D*A)))"),
    .INIT(16'hcfcd))
    \u_video_tx/tmds_green/mux7_syn_195  (
    .a(\u_video_tx/tmds_green/mux7_syn_190 ),
    .b(\u_video_tx/tmds_green/mux7_syn_194 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_green/mux7_syn_57 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(B*~A*~(~D*~C))"),
    .INIT(16'h4440))
    \u_video_tx/tmds_green/mux7_syn_196  (
    .a(\u_video_tx/tmds_green/mux7_syn_192 ),
    .b(\u_video_tx/tmds_green/mux7_syn_160 ),
    .c(\u_video_tx/tmds_green/mux7_syn_162 ),
    .d(\u_video_tx/tmds_green/acc [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_197 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+A*B*~(C)*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'he8da))
    \u_video_tx/tmds_green/mux7_syn_198  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .o(\u_video_tx/tmds_green/mux6_syn_178 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(C*A))"),
    .INIT(8'hec))
    \u_video_tx/tmds_green/mux7_syn_199  (
    .a(\u_video_tx/tmds_green/mux6_syn_178 ),
    .b(\u_video_tx/tmds_green/mux7_syn_197 ),
    .c(\u_video_tx/tmds_green/mux7_syn_164 ),
    .o(\u_video_tx/tmds_green/mux7_syn_81 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hc671))
    \u_video_tx/tmds_green/mux7_syn_200  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .o(\u_video_tx/tmds_green/mux7_syn_201 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(C*~A))"),
    .INIT(8'hdc))
    \u_video_tx/tmds_green/mux7_syn_202  (
    .a(\u_video_tx/tmds_green/mux7_syn_201 ),
    .b(\u_video_tx/tmds_green/mux7_syn_197 ),
    .c(\u_video_tx/tmds_green/mux7_syn_164 ),
    .o(\u_video_tx/tmds_green/mux7_syn_49 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~E*(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*B*C*D+A*B*C*D))"),
    .INIT(32'h0000cc5b))
    \u_video_tx/tmds_green/mux7_syn_203  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .e(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_green/mux7_syn_204 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(~B*(D@C)))"),
    .INIT(16'h5445))
    \u_video_tx/tmds_green/mux7_syn_205  (
    .a(\u_video_tx/tmds_green/mux7_syn_192 ),
    .b(\u_video_tx/tmds_green/mux7_syn_162 ),
    .c(rgb_b3_n),
    .d(\u_video_tx/tmds_green/acc [4]),
    .o(\u_video_tx/tmds_green/mux7_syn_206 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~A*~(B)*~(C)+~A*B*~(C)+~(~A)*B*C+~A*B*C))"),
    .INIT(16'h3a00))
    \u_video_tx/tmds_green/mux7_syn_207  (
    .a(\u_video_tx/tmds_green/mux7_syn_204 ),
    .b(\u_video_tx/tmds_green/mux7_syn_206 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_green/mux7_syn_99 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("~(A*~((~B*~(~E*~D)))*~(C)+A*(~B*~(~E*~D))*~(C)+~(A)*(~B*~(~E*~D))*C+A*(~B*~(~E*~D))*C)"),
    .INIT(32'hc5c5c5f5))
    \u_video_tx/tmds_green/mux7_syn_208  (
    .a(\u_video_tx/tmds_green/mux7_syn_204 ),
    .b(\u_video_tx/tmds_green/mux7_syn_192 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .e(rgb_b3_n),
    .o(\u_video_tx/tmds_green/mux7_syn_89 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~E*(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*B*~(C)*D+A*~(B)*C*D))"),
    .INIT(32'h000029da))
    \u_video_tx/tmds_green/mux7_syn_209  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .e(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_green/mux7_syn_210 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(D*~B*~(~C*~A))"),
    .INIT(16'hcdff))
    \u_video_tx/tmds_green/mux7_syn_211  (
    .a(\u_video_tx/tmds_green/mux7_syn_210 ),
    .b(\u_video_tx/tmds_green/mux7_syn_197 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_green/mux7_syn_67 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hf9ca))
    \u_video_tx/tmds_green/mux7_syn_212  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .o(\u_video_tx/tmds_green/mux7_syn_213 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("~(E*~B*~(~C*~(~D*A)))"),
    .INIT(32'hcfcdffff))
    \u_video_tx/tmds_green/mux7_syn_214  (
    .a(\u_video_tx/tmds_green/mux7_syn_213 ),
    .b(\u_video_tx/tmds_green/mux7_syn_197 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .e(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_green/mux7_syn_23 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*B*C*D)"),
    .INIT(16'h4635))
    \u_video_tx/tmds_green/mux7_syn_215  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .o(\u_video_tx/tmds_green/mux7_syn_216 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~B*~(C*~A)))"),
    .INIT(16'hdc00))
    \u_video_tx/tmds_green/mux7_syn_217  (
    .a(\u_video_tx/tmds_green/mux7_syn_216 ),
    .b(\u_video_tx/tmds_green/mux7_syn_194 ),
    .c(\u_video_tx/tmds_green/mux7_syn_164 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_green/mux7_syn_43 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*B*C*D+A*B*C*D)"),
    .INIT(16'hc679))
    \u_video_tx/tmds_green/mux7_syn_218  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .o(\u_video_tx/tmds_green/mux6_syn_158 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*~(~B*~(C*A)))"),
    .INIT(16'hec00))
    \u_video_tx/tmds_green/mux7_syn_219  (
    .a(\u_video_tx/tmds_green/mux6_syn_158 ),
    .b(\u_video_tx/tmds_green/mux7_syn_194 ),
    .c(\u_video_tx/tmds_green/mux7_syn_164 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_green/mux7_syn_75 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h6572))
    \u_video_tx/tmds_green/mux7_syn_220  (
    .a(\u_video_tx/tmds_green/mux7_syn_184 ),
    .b(\u_video_tx/tmds_green/mux6_syn_196 ),
    .c(\u_video_tx/tmds_green/mux7_syn_179 ),
    .d(\u_video_tx/tmds_green/mux7_syn_173 ),
    .o(\u_video_tx/tmds_green/mux6_syn_52 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("~(E*~B*~(~C*~(~D*~A)))"),
    .INIT(32'hcfceffff))
    \u_video_tx/tmds_green/mux7_syn_221  (
    .a(\u_video_tx/tmds_green/mux6_syn_52 ),
    .b(\u_video_tx/tmds_green/mux7_syn_197 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .e(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_green/mux7_syn_31 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
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
    .q(\u_video_tx/tmds_green/tmds [0]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [1]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [4]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [5]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [6]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [7]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [8]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_green/tmds [9]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .b({\u_video_tx/tmds_red/acc [4],open_n4204}),
    .clk(\u_build_id/clk ),
    .sr(\u_video_tx/active ),
    .fco(\u_video_tx/tmds_red/add1_syn_24 ),
    .q({\u_video_tx/tmds_red/acc [1],open_n4226}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
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
    .a({open_n4247,1'b0}),
    .b({open_n4248,1'b1}),
    .clk(\u_build_id/clk ),
    .fci(\u_video_tx/tmds_red/add1_syn_26 ),
    .sr(\u_video_tx/active ),
    .q({open_n4270,\u_video_tx/tmds_red/acc [4]}));  // ../user_source/hdl_source/open_tx/tmds_channel.v(85)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(~C*B))"),
    .INIT(8'h51))
    \u_video_tx/tmds_red/mux7_syn_116  (
    .a(rgb_b1_n),
    .b(rgb_b5_n1),
    .c(rgb_b3_n),
    .o(\rgb_b1[23]_syn_2 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \u_video_tx/tmds_red/mux7_syn_117  (
    .a(\u_video_tx/packet_ecc/mux6_syn_22 ),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/packet_ecc/mux26_syn_116 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \u_video_tx/tmds_red/mux7_syn_118  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [1]),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_red/mux7_syn_119 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*B*A)"),
    .INIT(16'h0008))
    \u_video_tx/tmds_red/mux7_syn_120  (
    .a(\u_video_tx/tmds_green/mux7_syn_153 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/tmds_red/mux7_syn_121 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*(B*~(C)*~(D)+~(B)*C*D))"),
    .INIT(16'h2008))
    \u_video_tx/tmds_red/mux7_syn_122  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .o(\u_video_tx/packet_ecc/mux6_syn_44 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(A*(~(B)*C*~(D)*~(E)+~(B)*~(C)*D*~(E)+B*~(C)*D*~(E)+~(B)*~(C)*~(D)*E+B*~(C)*~(D)*E+B*~(C)*D*E))"),
    .INIT(32'h080a0a20))
    \u_video_tx/tmds_red/mux7_syn_123  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .e(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/mux6_syn_48 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(B*~((~C*A))*~(D)+B*(~C*A)*~(D)+~(B)*(~C*A)*D+B*(~C*A)*D)"),
    .INIT(16'hf533))
    \u_video_tx/tmds_red/mux7_syn_124  (
    .a(\u_video_tx/packet_ecc/mux6_syn_44 ),
    .b(\u_video_tx/packet_ecc/mux6_syn_48 ),
    .c(\u_video_tx/packet_ecc/counter [3]),
    .d(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_125 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~C*A*(B*~(D)*~(E)+~(B)*~(D)*E+B*D*E))"),
    .INIT(32'h08020008))
    \u_video_tx/tmds_red/mux7_syn_126  (
    .a(\u_video_tx/tmds_green/mux7_syn_138 ),
    .b(\u_video_tx/packet_ecc/counter [0]),
    .c(\u_video_tx/packet_ecc/counter [1]),
    .d(\u_video_tx/packet_ecc/counter [2]),
    .e(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/packet_ecc/mux26_syn_124 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(B*~((C*A))*~(D)+B*(C*A)*~(D)+~(B)*(C*A)*D+B*(C*A)*D)"),
    .INIT(16'h5f33))
    \u_video_tx/tmds_red/mux7_syn_127  (
    .a(\u_video_tx/tmds_red/mux7_syn_119 ),
    .b(\u_video_tx/packet_ecc/mux26_syn_124 ),
    .c(\u_video_tx/packet_ecc/counter [3]),
    .d(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_128 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_video_tx/tmds_red/mux7_syn_129  (
    .a(\u_video_tx/tmds_red/mux7_syn_121 ),
    .b(\u_video_tx/packet_ecc/counter [3]),
    .o(\u_video_tx/tmds_red/mux7_syn_130 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~A*~(~E*~(~C*~(D*B))))"),
    .INIT(32'h55550105))
    \u_video_tx/tmds_red/mux7_syn_131  (
    .a(\u_video_tx/tmds_red/mux7_syn_130 ),
    .b(\u_video_tx/tmds_green/mux7_syn_140 ),
    .c(\u_video_tx/tmds_green/mux7_syn_144 ),
    .d(\u_video_tx/packet_ecc/mux27_syn_206 ),
    .e(\u_video_tx/packet_ecc/counter [0]),
    .o(\u_video_tx/tmds_red/mux7_syn_132 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*~C*B*A)"),
    .INIT(16'h0800))
    \u_video_tx/tmds_red/mux7_syn_133  (
    .a(\u_video_tx/tmds_green/mux7_syn_153 ),
    .b(\u_video_tx/packet_ecc/mux27_syn_206 ),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_134 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~C*~(~A*~((D*B))*~(E)+~A*(D*B)*~(E)+~(~A)*(D*B)*E+~A*(D*B)*E))"),
    .INIT(32'h030f0a0a))
    \u_video_tx/tmds_red/mux7_syn_135  (
    .a(\u_video_tx/tmds_red/mux7_syn_132 ),
    .b(\u_video_tx/tmds_red/mux7_syn_119 ),
    .c(\u_video_tx/tmds_red/mux7_syn_134 ),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_136 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u_video_tx/tmds_red/mux7_syn_137  (
    .a(\u_video_tx/tmds_green/mux7_syn_168 ),
    .b(\u_video_tx/tmds_green/mux7_syn_162 ),
    .c(\u_video_tx/tmds_red/acc [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_138 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_red/mux7_syn_139  (
    .a(\u_video_tx/packet_ecc/bch3 [63]),
    .b(\u_video_tx/packet_ecc/bch3 [61]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_140 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_red/mux7_syn_141  (
    .a(\u_video_tx/packet_ecc/bch3 [57]),
    .b(\u_video_tx/packet_ecc/bch3 [59]),
    .c(\u_video_tx/tmds_red/mux7_syn_140 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux26_syn_186 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~(A)*~((C*B))*~(D)*~(E)+~(A)*(C*B)*~(D)*~(E)+~(A)*~((C*B))*D*~(E)+A*~((C*B))*D*~(E)+~(A)*(C*B)*D*~(E)+A*(C*B)*D*~(E)+~(A)*~((C*B))*~(D)*E+A*~((C*B))*~(D)*E+~(A)*(C*B)*~(D)*E+A*(C*B)*~(D)*E+~(A)*~((C*B))*D*E+A*~((C*B))*D*E)"),
    .INIT(32'h3fffff55))
    \u_video_tx/tmds_red/mux7_syn_142  (
    .a(\u_video_tx/packet_ecc/mux26_syn_116 ),
    .b(\u_video_tx/packet_ecc/mux26_syn_186 ),
    .c(\u_video_tx/packet_ecc/counter [2]),
    .d(\u_video_tx/packet_ecc/counter [3]),
    .e(\u_video_tx/packet_ecc/counter [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_143 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_red/mux7_syn_144  (
    .a(\u_video_tx/packet_ecc/bch0 [63]),
    .b(\u_video_tx/packet_ecc/bch0 [61]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_145 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_red/mux7_syn_146  (
    .a(\u_video_tx/packet_ecc/bch0 [57]),
    .b(\u_video_tx/packet_ecc/bch0 [59]),
    .c(\u_video_tx/tmds_red/mux7_syn_145 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux26_syn_66 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*~B))"),
    .INIT(8'h8a))
    \u_video_tx/tmds_red/mux7_syn_147  (
    .a(\u_video_tx/tmds_red/mux7_syn_136 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux26_syn_66 ),
    .o(\u_video_tx/tmds_red/mux7_syn_148 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_red/mux7_syn_149  (
    .a(\u_video_tx/packet_ecc/bch1 [63]),
    .b(\u_video_tx/packet_ecc/bch1 [61]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_150 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_red/mux7_syn_151  (
    .a(\u_video_tx/packet_ecc/bch1 [57]),
    .b(\u_video_tx/packet_ecc/bch1 [59]),
    .c(\u_video_tx/tmds_red/mux7_syn_150 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux26_syn_114 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*~B))"),
    .INIT(8'h8a))
    \u_video_tx/tmds_red/mux7_syn_152  (
    .a(\u_video_tx/tmds_red/mux7_syn_128 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux26_syn_114 ),
    .o(\u_video_tx/tmds_red/mux7_syn_153 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h530f))
    \u_video_tx/tmds_red/mux7_syn_154  (
    .a(\u_video_tx/packet_ecc/bch2 [63]),
    .b(\u_video_tx/packet_ecc/bch2 [61]),
    .c(\u_video_tx/packet_ecc/counter [0]),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/tmds_red/mux7_syn_155 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D)"),
    .INIT(16'h0fac))
    \u_video_tx/tmds_red/mux7_syn_156  (
    .a(\u_video_tx/packet_ecc/bch2 [57]),
    .b(\u_video_tx/packet_ecc/bch2 [59]),
    .c(\u_video_tx/tmds_red/mux7_syn_155 ),
    .d(\u_video_tx/packet_ecc/counter [1]),
    .o(\u_video_tx/packet_ecc/mux26_syn_152 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C*~B))"),
    .INIT(8'h8a))
    \u_video_tx/tmds_red/mux7_syn_157  (
    .a(\u_video_tx/tmds_red/mux7_syn_125 ),
    .b(\u_video_tx/packet_ecc/parity0_b1_n ),
    .c(\u_video_tx/packet_ecc/mux26_syn_152 ),
    .o(\u_video_tx/tmds_red/mux6_syn_196 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h729b))
    \u_video_tx/tmds_red/mux7_syn_158  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .o(\u_video_tx/tmds_red/mux7_syn_159 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(~(~D*~A)*~(B)*~(C)+~(~D*~A)*B*~(C)+~(~(~D*~A))*B*C+~(~D*~A)*B*C)"),
    .INIT(16'h3035))
    \u_video_tx/tmds_red/mux7_syn_160  (
    .a(\u_video_tx/tmds_red/mux7_syn_159 ),
    .b(\u_video_tx/tmds_red/mux7_syn_138 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_red/mux7_syn_57 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h7817))
    \u_video_tx/tmds_red/mux7_syn_161  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .o(\u_video_tx/tmds_red/mux7_syn_162 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(A*(E*~((D*C))*~(B)+E*(D*C)*~(B)+~(E)*(D*C)*B+E*(D*C)*B))"),
    .INIT(32'ha2228000))
    \u_video_tx/tmds_red/mux7_syn_163  (
    .a(\u_video_tx/tmds_green/mux7_syn_160 ),
    .b(\u_video_tx/tmds_green/mux7_syn_162 ),
    .c(\u_video_tx/data_island_preamble_n1 ),
    .d(\u_video_tx/data_island_preamble_n2 ),
    .e(\u_video_tx/tmds_red/acc [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_164 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(~B*~(~C*~(~D*A)))"),
    .INIT(16'hcfcd))
    \u_video_tx/tmds_red/mux7_syn_165  (
    .a(\u_video_tx/tmds_red/mux7_syn_162 ),
    .b(\u_video_tx/tmds_red/mux7_syn_164 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_red/mux7_syn_49 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+A*~(B)*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'hb2b9))
    \u_video_tx/tmds_red/mux7_syn_166  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .o(\u_video_tx/tmds_red/mux6_syn_178 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(~B*~(~C*~(~D*~A)))"),
    .INIT(16'hcfce))
    \u_video_tx/tmds_red/mux7_syn_167  (
    .a(\u_video_tx/tmds_red/mux6_syn_178 ),
    .b(\u_video_tx/tmds_red/mux7_syn_164 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_red/mux7_syn_81 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h561b))
    \u_video_tx/tmds_red/mux7_syn_168  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .o(\u_video_tx/tmds_red/mux6_syn_52 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(D*~C*~(B*A))"),
    .INIT(16'hf8ff))
    \u_video_tx/tmds_red/mux7_syn_169  (
    .a(\u_video_tx/tmds_red/mux6_syn_52 ),
    .b(\u_video_tx/tmds_green/mux7_syn_164 ),
    .c(\u_video_tx/tmds_red/mux7_syn_164 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_red/mux7_syn_31 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+A*B*C*D)"),
    .INIT(16'hb7b8))
    \u_video_tx/tmds_red/mux7_syn_170  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .o(\u_video_tx/tmds_red/mux7_syn_171 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(D*~C*~(B*~A))"),
    .INIT(16'hf4ff))
    \u_video_tx/tmds_red/mux7_syn_172  (
    .a(\u_video_tx/tmds_red/mux7_syn_171 ),
    .b(\u_video_tx/tmds_green/mux7_syn_164 ),
    .c(\u_video_tx/tmds_red/mux7_syn_164 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_red/mux7_syn_23 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(~E*(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*B*C*~(D)+A*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D))"),
    .INIT(32'h00005847))
    \u_video_tx/tmds_red/mux7_syn_173  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .e(\u_video_tx/tmds_green/mux7_syn_162 ),
    .o(\u_video_tx/tmds_red/mux7_syn_174 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*~(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C))"),
    .INIT(16'h3500))
    \u_video_tx/tmds_red/mux7_syn_175  (
    .a(\u_video_tx/tmds_red/mux7_syn_174 ),
    .b(\u_video_tx/tmds_red/mux7_syn_138 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_red/mux7_syn_43 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h7946))
    \u_video_tx/tmds_red/mux7_syn_176  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .o(\u_video_tx/tmds_red/mux6_syn_138 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("~(D*~C*~(B*A))"),
    .INIT(16'hf8ff))
    \u_video_tx/tmds_red/mux7_syn_177  (
    .a(\u_video_tx/tmds_red/mux6_syn_138 ),
    .b(\u_video_tx/tmds_green/mux7_syn_164 ),
    .c(\u_video_tx/tmds_red/mux7_syn_164 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_red/mux7_syn_67 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*B*C*~(D)+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h7897))
    \u_video_tx/tmds_red/mux7_syn_178  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .o(\u_video_tx/tmds_red/mux6_syn_158 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(E*~(D*B)*~(C*~A))"),
    .INIT(32'h23af0000))
    \u_video_tx/tmds_red/mux7_syn_179  (
    .a(\u_video_tx/tmds_red/mux6_syn_158 ),
    .b(\u_video_tx/tmds_red/mux7_syn_138 ),
    .c(\u_video_tx/tmds_green/mux7_syn_164 ),
    .d(\u_video_tx/tmds_green/mux7_syn_160 ),
    .e(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_red/mux7_syn_75 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("(E*(A*~(B)*~(C)*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D))"),
    .INIT(32'h0f620000))
    \u_video_tx/tmds_red/mux7_syn_180  (
    .a(\u_video_tx/tmds_red/mux7_syn_148 ),
    .b(\u_video_tx/tmds_red/mux7_syn_153 ),
    .c(\u_video_tx/tmds_red/mux6_syn_196 ),
    .d(\u_video_tx/tmds_red/mux7_syn_143 ),
    .e(\u_video_tx/tmds_green/mux7_syn_164 ),
    .o(\u_video_tx/tmds_red/mux7_syn_181 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(~A*~(~B*~(D@C)))"),
    .INIT(16'h4554))
    \u_video_tx/tmds_red/mux7_syn_182  (
    .a(\u_video_tx/tmds_green/mux7_syn_168 ),
    .b(\u_video_tx/tmds_green/mux7_syn_162 ),
    .c(\rgb_b1[23]_syn_2 ),
    .d(\u_video_tx/tmds_red/acc [4]),
    .o(\u_video_tx/tmds_red/mux7_syn_183 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT4 #(
    .EQN("(D*~A*~(C*B))"),
    .INIT(16'h1500))
    \u_video_tx/tmds_red/mux7_syn_184  (
    .a(\u_video_tx/tmds_red/mux7_syn_181 ),
    .b(\u_video_tx/tmds_red/mux7_syn_183 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_166 ),
    .o(\u_video_tx/tmds_red/mux7_syn_99 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
  AL_MAP_LUT5 #(
    .EQN("~(~A*~(C*~(~B*~(E*~D))))"),
    .INIT(32'heafaeaea))
    \u_video_tx/tmds_red/mux7_syn_185  (
    .a(\u_video_tx/tmds_red/mux7_syn_181 ),
    .b(\u_video_tx/tmds_green/mux7_syn_168 ),
    .c(\u_video_tx/tmds_green/mux7_syn_160 ),
    .d(\u_video_tx/tmds_green/mux7_syn_162 ),
    .e(\rgb_b1[23]_syn_2 ),
    .o(\u_video_tx/tmds_red/mux7_syn_89 ));  // ../user_source/hdl_source/open_tx/tmds_channel.v(138)
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
    .q(\u_video_tx/tmds_red/tmds [0]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [1]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [2]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [3]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [4]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [5]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [6]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [7]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [8]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
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
    .q(\u_video_tx/tmds_red/tmds [9]));  // ../user_source/hdl_source/open_tx/tmds_channel.v(137)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_video_tx/x_count_b1[11]_syn_1  (
    .a(\u_video_tx/cx [2]),
    .b(\u_video_tx/cx [4]),
    .c(\u_video_tx/cx [7]),
    .d(\u_video_tx/cx [11]),
    .o(\u_video_tx/x_count_b1[11]_syn_2 ));
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_video_tx/x_count_b1[11]_syn_3  (
    .a(\u_video_tx/tmds_blue/mux9_syn_140 ),
    .b(\u_video_tx/x_count_b1[11]_syn_2 ),
    .c(\u_video_tx/tmds_blue/mux9_syn_142 ),
    .d(\frame_count_reg[0]_syn_4 ),
    .o(frame_count_b1_n1));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[11]_syn_4  (
    .a(frame_count_b1_n1),
    .b(\u_video_tx/x_count_b3 [11]),
    .o(\u_video_tx/x_count_b1 [11]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[3]_syn_1  (
    .a(frame_count_b1_n1),
    .b(\u_video_tx/x_count_b3 [3]),
    .o(\u_video_tx/x_count_b1 [3]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[4]_syn_1  (
    .a(frame_count_b1_n1),
    .b(\u_video_tx/x_count_b3 [4]),
    .o(\u_video_tx/x_count_b1 [4]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/x_count_b1[7]_syn_1  (
    .a(frame_count_b1_n1),
    .b(\u_video_tx/x_count_b3 [7]),
    .o(\u_video_tx/x_count_b1 [7]));
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
    \u_video_tx/x_count_reg[10]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b3 [10]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [10]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[11]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [11]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [11]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
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
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[4]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [4]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [4]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[5]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b3 [5]),
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
    .d(\u_video_tx/x_count_b3 [6]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [6]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[7]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b1 [7]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [7]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[8]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b3 [8]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [8]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/x_count_reg[9]  (
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/x_count_b3 [9]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cx [9]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_video_tx/y_count_b3[0]_syn_1  (
    .a(frame_count_b1_n2),
    .b(\u_video_tx/cy [0]),
    .o(\u_video_tx/y_count_b3 [0]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/y_count_b3[10]_syn_1  (
    .a(frame_count_b1_n2),
    .b(\u_video_tx/y_count_b4 [10]),
    .o(\u_video_tx/y_count_b3 [10]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/y_count_b3[2]_syn_1  (
    .a(frame_count_b1_n2),
    .b(\u_video_tx/y_count_b4 [2]),
    .o(\u_video_tx/y_count_b3 [2]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/y_count_b3[5]_syn_1  (
    .a(frame_count_b1_n2),
    .b(\u_video_tx/y_count_b4 [5]),
    .o(\u_video_tx/y_count_b3 [5]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_video_tx/y_count_b3[6]_syn_1  (
    .a(frame_count_b1_n2),
    .b(\u_video_tx/y_count_b4 [6]),
    .o(\u_video_tx/y_count_b3 [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[0]  (
    .ce(frame_count_b1_n1),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b3 [0]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [0]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[10]  (
    .ce(frame_count_b1_n1),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b3 [10]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [10]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[1]  (
    .ce(frame_count_b1_n1),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b4 [1]),
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
    .ce(frame_count_b1_n1),
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
    .ce(frame_count_b1_n1),
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
    .ce(frame_count_b1_n1),
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
    .ce(frame_count_b1_n1),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b3 [5]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [5]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[6]  (
    .ce(frame_count_b1_n1),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b3 [6]),
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
    .ce(frame_count_b1_n1),
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
    .ce(frame_count_b1_n1),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b4 [8]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [8]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_video_tx/y_count_reg[9]  (
    .ce(frame_count_b1_n1),
    .clk(\u_build_id/clk ),
    .d(\u_video_tx/y_count_b4 [9]),
    .sr(\u_build_id/rst ),
    .q(\u_video_tx/cy [9]));  // ../user_source/hdl_source/open_tx/video_only_tmds_tx.v(69)

endmodule 

