// Verilog netlist created by Tang Dynasty v6.2.178840
// Wed Oct 21 22:02:24 2026

`timescale 1ns / 1ps
module idct_y_area_top  // ../src_v/idct_y_area_top.v(1)
  (
  clk_i,
  img_start_i,
  inport_data0_i,
  inport_data1_i,
  inport_data2_i,
  inport_data3_i,
  inport_idx_i,
  inport_valid_i,
  rst_i,
  outport_data_o,
  outport_idx_o,
  outport_valid_o
  );

  input clk_i;  // ../src_v/idct_y_area_top.v(2)
  input img_start_i;  // ../src_v/idct_y_area_top.v(2)
  input [31:0] inport_data0_i;  // ../src_v/idct_y_area_top.v(3)
  input [31:0] inport_data1_i;  // ../src_v/idct_y_area_top.v(3)
  input [31:0] inport_data2_i;  // ../src_v/idct_y_area_top.v(3)
  input [31:0] inport_data3_i;  // ../src_v/idct_y_area_top.v(3)
  input [2:0] inport_idx_i;  // ../src_v/idct_y_area_top.v(3)
  input inport_valid_i;  // ../src_v/idct_y_area_top.v(2)
  input rst_i;  // ../src_v/idct_y_area_top.v(2)
  output [31:0] outport_data_o;  // ../src_v/idct_y_area_top.v(4)
  output [5:0] outport_idx_o;  // ../src_v/idct_y_area_top.v(4)
  output outport_valid_o;  // ../src_v/idct_y_area_top.v(4)

  wire [31:0] al_131;
  wire [31:0] al_196;
  wire [31:0] al_66;
  wire [30:0] \u_y/add4_syn_3 ;  // ../src_v/jpeg_idct_y.v(282)
  wire [30:0] \u_y/add4_syn_35 ;  // ../src_v/jpeg_idct_y.v(282)
  wire [31:0] \u_y/block_out[0] ;  // ../src_v/jpeg_idct_y.v(326)
  wire [31:0] \u_y/block_out[0]_b13 ;
  wire [31:0] \u_y/block_out[0]_b16 ;
  wire [31:0] \u_y/block_out[0]_b17 ;
  wire [31:0] \u_y/block_out[0]_b18 ;
  wire [31:0] \u_y/block_out[0]_b19 ;
  wire [31:0] \u_y/block_out[0]_b21 ;
  wire [31:0] \u_y/block_out[0]_b22 ;
  wire [31:0] \u_y/block_out[0]_b25 ;
  wire [31:0] \u_y/block_out[0]_b26 ;
  wire [31:0] \u_y/block_out[0]_b27 ;
  wire [31:0] \u_y/block_out[0]_b28 ;
  wire [31:0] \u_y/block_out[1] ;  // ../src_v/jpeg_idct_y.v(326)
  wire [31:0] \u_y/block_out[2] ;  // ../src_v/jpeg_idct_y.v(326)
  wire [31:0] \u_y/block_out[3] ;  // ../src_v/jpeg_idct_y.v(326)
  wire [31:0] \u_y/block_out[4] ;  // ../src_v/jpeg_idct_y.v(326)
  wire [31:0] \u_y/block_out[5] ;  // ../src_v/jpeg_idct_y.v(326)
  wire [31:0] \u_y/block_out[6] ;  // ../src_v/jpeg_idct_y.v(326)
  wire [31:0] \u_y/block_out[7] ;  // ../src_v/jpeg_idct_y.v(326)
  wire [31:0] \u_y/block_out_tmp ;  // ../src_v/jpeg_idct_y.v(327)
  wire [31:0] \u_y/i0 ;  // ../src_v/jpeg_idct_y.v(81)
  wire [31:0] \u_y/mul0_a_b1 ;
  wire [31:0] \u_y/mul0_q ;  // ../src_v/jpeg_idct_y.v(174)
  wire [31:0] \u_y/mul1_a ;  // ../src_v/jpeg_idct_y.v(84)
  wire [31:0] \u_y/mul1_q ;  // ../src_v/jpeg_idct_y.v(175)
  wire [31:0] \u_y/mul2_a ;  // ../src_v/jpeg_idct_y.v(86)
  wire [31:0] \u_y/mul2_q ;  // ../src_v/jpeg_idct_y.v(176)
  wire [31:0] \u_y/mul3_a ;  // ../src_v/jpeg_idct_y.v(88)
  wire [31:0] \u_y/mul3_q ;  // ../src_v/jpeg_idct_y.v(177)
  wire [31:0] \u_y/mul4_q ;  // ../src_v/jpeg_idct_y.v(178)
  wire [13:0] \u_y/mult4_syn_90 ;  // ../src_v/jpeg_idct_y.v(241)
  wire [13:0] \u_y/mult5_syn_90 ;  // ../src_v/jpeg_idct_y.v(242)
  wire [255:0] \u_y/mux35_syn_2 ;  // ../src_v/jpeg_idct_y.v(342)
  wire [5:0] \u_y/mux43_syn_2 ;  // ../src_v/jpeg_idct_y.v(377)
  wire [31:0] \u_y/o_s5 ;  // ../src_v/jpeg_idct_y.v(228)
  wire [31:0] \u_y/o_s6 ;  // ../src_v/jpeg_idct_y.v(229)
  wire [31:0] \u_y/o_s6_b1 ;
  wire [31:0] \u_y/o_s7 ;  // ../src_v/jpeg_idct_y.v(230)
  wire [31:0] \u_y/o_t0 ;  // ../src_v/jpeg_idct_y.v(231)
  wire [31:0] \u_y/o_t0_b1 ;
  wire [31:0] \u_y/o_t0_b3 ;
  wire [31:0] \u_y/o_t0_b5 ;
  wire [31:0] \u_y/o_t1 ;  // ../src_v/jpeg_idct_y.v(232)
  wire [31:0] \u_y/o_t1_b2 ;
  wire [31:0] \u_y/o_t2 ;  // ../src_v/jpeg_idct_y.v(233)
  wire [31:0] \u_y/o_t3 ;  // ../src_v/jpeg_idct_y.v(234)
  wire [31:0] \u_y/o_t3_b1 ;
  wire [31:0] \u_y/o_t3_b4 ;
  wire [31:0] \u_y/o_t4 ;  // ../src_v/jpeg_idct_y.v(235)
  wire [31:0] \u_y/o_t4_b1 ;
  wire [31:0] \u_y/o_t5 ;  // ../src_v/jpeg_idct_y.v(236)
  wire [31:0] \u_y/o_t5_6_b2 ;
  wire [31:0] \u_y/o_t6 ;  // ../src_v/jpeg_idct_y.v(237)
  wire [31:0] \u_y/o_t6_5_b2 ;
  wire [31:0] \u_y/o_t6_b2 ;
  wire [31:0] \u_y/o_t7 ;  // ../src_v/jpeg_idct_y.v(238)
  wire [31:0] \u_y/o_t7_b2 ;
  wire [2:0] \u_y/out_stg0_idx_q ;  // ../src_v/jpeg_idct_y.v(199)
  wire [2:0] \u_y/out_stg1_idx_q ;  // ../src_v/jpeg_idct_y.v(214)
  wire [2:0] \u_y/out_stg3_idx_q ;  // ../src_v/jpeg_idct_y.v(312)
  wire [5:0] \u_y/ptr_q ;  // ../src_v/jpeg_idct_y.v(374)
  wire [5:0] \u_y/ptr_q_b4 ;
  wire [7:0] \u_y/valid_q ;  // ../src_v/jpeg_idct_y.v(364)
  wire clk_i_dup_1;  // ../src_v/idct_y_area_top.v(2)
  wire img_start_i_dup_15;  // ../src_v/idct_y_area_top.v(2)
  wire \inport_data0_i[31]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[30]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[29]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[28]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[27]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[26]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[25]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[24]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[23]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[22]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[21]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[20]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[19]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[18]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[17]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[16]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[15]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[14]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[13]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[12]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[11]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[10]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[9]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[8]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[7]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[6]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[5]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[4]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[3]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[2]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[1]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data0_i[0]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[31]_dup_1 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[30]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[29]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[28]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[27]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[26]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[25]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[24]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[23]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[22]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[21]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[20]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[19]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[18]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[17]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[16]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[15]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[14]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[13]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[12]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[11]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[10]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[9]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[8]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[7]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[6]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[5]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[4]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[3]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[2]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[1]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data1_i[0]_dup_5 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[27]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[26]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[25]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[24]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[23]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[22]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[21]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[20]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[19]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[18]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[17]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[16]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[15]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[14]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[13]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[12]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[11]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[10]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[9]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[8]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[7]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[6]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[5]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[4]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[3]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[2]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[1]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_data2_i[0]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_idx_i[2]_dup_37 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_idx_i[1]_dup_17 ;  // ../src_v/idct_y_area_top.v(3)
  wire \inport_idx_i[0]_dup_15 ;  // ../src_v/idct_y_area_top.v(3)
  wire \outport_data_o[20]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[20]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[20]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[19]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[19]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[19]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[18]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[18]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[18]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[17]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[17]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[17]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[16]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[16]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[16]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[15]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[15]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[15]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[14]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[14]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[14]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[13]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[13]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[13]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[12]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[12]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[12]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[11]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[11]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[11]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[10]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[10]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[10]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[9]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[9]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[9]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[8]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[8]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[8]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[7]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[7]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[7]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[6]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[6]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[6]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[5]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[5]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[5]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[4]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[4]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[4]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[3]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[3]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[3]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[2]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[2]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[2]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[1]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[1]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[1]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[0]_dup_1 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[0]_syn_4 ;  // ../src_v/idct_y_area_top.v(4)
  wire \outport_data_o[0]_syn_6 ;  // ../src_v/idct_y_area_top.v(4)
  wire outport_valid_o_dup_17;  // ../src_v/idct_y_area_top.v(4)
  wire rst_i_dup_1951;  // ../src_v/idct_y_area_top.v(2)
  wire \u_y/add0_syn_134 ;  // ../src_v/jpeg_idct_y.v(266)
  wire \u_y/add0_syn_138 ;  // ../src_v/jpeg_idct_y.v(266)
  wire \u_y/add0_syn_142 ;  // ../src_v/jpeg_idct_y.v(266)
  wire \u_y/add0_syn_146 ;  // ../src_v/jpeg_idct_y.v(266)
  wire \u_y/add0_syn_150 ;  // ../src_v/jpeg_idct_y.v(266)
  wire \u_y/add0_syn_154 ;  // ../src_v/jpeg_idct_y.v(266)
  wire \u_y/add0_syn_158 ;  // ../src_v/jpeg_idct_y.v(266)
  wire \u_y/add0_syn_162 ;  // ../src_v/jpeg_idct_y.v(266)
  wire \u_y/add10_syn_134 ;  // ../src_v/jpeg_idct_y.v(346)
  wire \u_y/add10_syn_138 ;  // ../src_v/jpeg_idct_y.v(346)
  wire \u_y/add10_syn_142 ;  // ../src_v/jpeg_idct_y.v(346)
  wire \u_y/add10_syn_146 ;  // ../src_v/jpeg_idct_y.v(346)
  wire \u_y/add10_syn_150 ;  // ../src_v/jpeg_idct_y.v(346)
  wire \u_y/add10_syn_154 ;  // ../src_v/jpeg_idct_y.v(346)
  wire \u_y/add10_syn_158 ;  // ../src_v/jpeg_idct_y.v(346)
  wire \u_y/add10_syn_162 ;  // ../src_v/jpeg_idct_y.v(346)
  wire \u_y/add11_syn_135 ;  // ../src_v/jpeg_idct_y.v(357)
  wire \u_y/add11_syn_139 ;  // ../src_v/jpeg_idct_y.v(357)
  wire \u_y/add11_syn_143 ;  // ../src_v/jpeg_idct_y.v(357)
  wire \u_y/add11_syn_147 ;  // ../src_v/jpeg_idct_y.v(357)
  wire \u_y/add11_syn_151 ;  // ../src_v/jpeg_idct_y.v(357)
  wire \u_y/add11_syn_155 ;  // ../src_v/jpeg_idct_y.v(357)
  wire \u_y/add11_syn_159 ;  // ../src_v/jpeg_idct_y.v(357)
  wire \u_y/add11_syn_163 ;  // ../src_v/jpeg_idct_y.v(357)
  wire \u_y/add12_syn_135 ;  // ../src_v/jpeg_idct_y.v(359)
  wire \u_y/add12_syn_139 ;  // ../src_v/jpeg_idct_y.v(359)
  wire \u_y/add12_syn_143 ;  // ../src_v/jpeg_idct_y.v(359)
  wire \u_y/add12_syn_147 ;  // ../src_v/jpeg_idct_y.v(359)
  wire \u_y/add12_syn_151 ;  // ../src_v/jpeg_idct_y.v(359)
  wire \u_y/add12_syn_155 ;  // ../src_v/jpeg_idct_y.v(359)
  wire \u_y/add12_syn_159 ;  // ../src_v/jpeg_idct_y.v(359)
  wire \u_y/add12_syn_163 ;  // ../src_v/jpeg_idct_y.v(359)
  wire \u_y/add2_syn_134 ;  // ../src_v/jpeg_idct_y.v(276)
  wire \u_y/add2_syn_138 ;  // ../src_v/jpeg_idct_y.v(276)
  wire \u_y/add2_syn_142 ;  // ../src_v/jpeg_idct_y.v(276)
  wire \u_y/add2_syn_146 ;  // ../src_v/jpeg_idct_y.v(276)
  wire \u_y/add2_syn_150 ;  // ../src_v/jpeg_idct_y.v(276)
  wire \u_y/add2_syn_154 ;  // ../src_v/jpeg_idct_y.v(276)
  wire \u_y/add2_syn_158 ;  // ../src_v/jpeg_idct_y.v(276)
  wire \u_y/add2_syn_162 ;  // ../src_v/jpeg_idct_y.v(276)
  wire \u_y/add3_syn_134 ;  // ../src_v/jpeg_idct_y.v(278)
  wire \u_y/add3_syn_138 ;  // ../src_v/jpeg_idct_y.v(278)
  wire \u_y/add3_syn_142 ;  // ../src_v/jpeg_idct_y.v(278)
  wire \u_y/add3_syn_146 ;  // ../src_v/jpeg_idct_y.v(278)
  wire \u_y/add3_syn_150 ;  // ../src_v/jpeg_idct_y.v(278)
  wire \u_y/add3_syn_154 ;  // ../src_v/jpeg_idct_y.v(278)
  wire \u_y/add3_syn_158 ;  // ../src_v/jpeg_idct_y.v(278)
  wire \u_y/add3_syn_162 ;  // ../src_v/jpeg_idct_y.v(278)
  wire \u_y/add4_syn_193 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_195 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_197 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_199 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_201 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_203 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_205 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_207 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_209 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_211 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_213 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_215 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_217 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_219 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_221 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_351 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_353 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_355 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_357 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_359 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_361 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_363 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_365 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_367 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_369 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_371 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_373 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_375 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_377 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add4_syn_379 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/add5_syn_134 ;  // ../src_v/jpeg_idct_y.v(298)
  wire \u_y/add5_syn_138 ;  // ../src_v/jpeg_idct_y.v(298)
  wire \u_y/add5_syn_142 ;  // ../src_v/jpeg_idct_y.v(298)
  wire \u_y/add5_syn_146 ;  // ../src_v/jpeg_idct_y.v(298)
  wire \u_y/add5_syn_150 ;  // ../src_v/jpeg_idct_y.v(298)
  wire \u_y/add5_syn_154 ;  // ../src_v/jpeg_idct_y.v(298)
  wire \u_y/add5_syn_158 ;  // ../src_v/jpeg_idct_y.v(298)
  wire \u_y/add5_syn_162 ;  // ../src_v/jpeg_idct_y.v(298)
  wire \u_y/add6_syn_134 ;  // ../src_v/jpeg_idct_y.v(301)
  wire \u_y/add6_syn_138 ;  // ../src_v/jpeg_idct_y.v(301)
  wire \u_y/add6_syn_142 ;  // ../src_v/jpeg_idct_y.v(301)
  wire \u_y/add6_syn_146 ;  // ../src_v/jpeg_idct_y.v(301)
  wire \u_y/add6_syn_150 ;  // ../src_v/jpeg_idct_y.v(301)
  wire \u_y/add6_syn_154 ;  // ../src_v/jpeg_idct_y.v(301)
  wire \u_y/add6_syn_158 ;  // ../src_v/jpeg_idct_y.v(301)
  wire \u_y/add6_syn_162 ;  // ../src_v/jpeg_idct_y.v(301)
  wire \u_y/add9_syn_136 ;  // ../src_v/jpeg_idct_y.v(306)
  wire \u_y/add9_syn_140 ;  // ../src_v/jpeg_idct_y.v(306)
  wire \u_y/add9_syn_144 ;  // ../src_v/jpeg_idct_y.v(306)
  wire \u_y/add9_syn_148 ;  // ../src_v/jpeg_idct_y.v(306)
  wire \u_y/add9_syn_152 ;  // ../src_v/jpeg_idct_y.v(306)
  wire \u_y/add9_syn_156 ;  // ../src_v/jpeg_idct_y.v(306)
  wire \u_y/add9_syn_160 ;  // ../src_v/jpeg_idct_y.v(306)
  wire \u_y/add9_syn_164 ;  // ../src_v/jpeg_idct_y.v(306)
  wire \u_y/mult0_syn_4 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_5 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_6 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_7 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_8 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_9 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_10 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_11 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_12 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_13 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_14 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_15 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_16 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_17 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_18 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_19 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_20 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_21 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_22 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_23 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_24 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_25 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_26 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_27 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_28 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_29 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_30 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_31 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_32 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_33 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_34 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_36 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_37 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_38 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_39 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_40 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_41 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_42 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_43 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_44 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_45 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_46 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_47 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_48 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_49 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_174 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_176 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_178 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_180 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_182 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_184 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult0_syn_186 ;  // ../src_v/jpeg_idct_y.v(192)
  wire \u_y/mult1_syn_5 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_6 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_7 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_8 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_9 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_10 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_11 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_12 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_13 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_14 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_15 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_16 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_17 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_18 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_19 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_20 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_21 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_22 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_23 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_24 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_25 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_26 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_27 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_28 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_29 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_30 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_31 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_32 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_33 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_34 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_36 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_37 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_38 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_39 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_40 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_41 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_42 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_43 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_44 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_45 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_46 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_47 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_48 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_166 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_168 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_170 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_172 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_174 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult1_syn_176 ;  // ../src_v/jpeg_idct_y.v(193)
  wire \u_y/mult2_syn_5 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_6 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_7 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_8 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_9 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_10 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_11 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_12 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_13 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_14 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_15 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_16 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_17 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_18 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_19 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_20 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_21 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_22 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_23 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_24 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_25 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_26 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_27 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_28 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_29 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_30 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_31 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_32 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_33 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_34 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_36 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_37 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_38 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_39 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_40 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_41 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_42 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_43 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_44 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_45 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_46 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_47 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_48 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_166 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_168 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_170 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_172 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_174 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult2_syn_176 ;  // ../src_v/jpeg_idct_y.v(194)
  wire \u_y/mult3_syn_5 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_6 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_7 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_8 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_9 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_10 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_11 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_12 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_13 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_14 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_15 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_16 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_17 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_18 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_19 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_20 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_21 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_22 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_23 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_24 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_25 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_26 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_27 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_28 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_29 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_30 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_31 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_33 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_34 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_35 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_36 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_37 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_38 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_39 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_40 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_41 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_42 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_139 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_141 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_143 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_145 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult3_syn_147 ;  // ../src_v/jpeg_idct_y.v(195)
  wire \u_y/mult4_syn_3 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_4 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_5 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_6 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_7 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_8 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_9 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_10 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_11 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_12 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_13 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_14 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_15 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_16 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_17 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_18 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_19 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_20 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_21 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_22 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_23 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_24 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_25 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_26 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_27 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_28 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_29 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_31 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_32 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_33 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_34 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_35 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_36 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_37 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_38 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_39 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_40 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_41 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_42 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_43 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_44 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_173 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_175 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_177 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_179 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_181 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_183 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult4_syn_185 ;  // ../src_v/jpeg_idct_y.v(241)
  wire \u_y/mult5_syn_3 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_4 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_5 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_6 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_7 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_8 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_9 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_10 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_11 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_12 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_13 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_14 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_15 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_16 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_17 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_18 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_19 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_20 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_21 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_22 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_23 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_24 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_25 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_26 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_27 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_28 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_29 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_31 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_32 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_33 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_34 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_35 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_36 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_37 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_38 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_39 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_40 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_41 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_42 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_43 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_44 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_173 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_175 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_177 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_179 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_181 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_183 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult5_syn_185 ;  // ../src_v/jpeg_idct_y.v(242)
  wire \u_y/mult6_syn_4 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_5 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_6 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_7 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_8 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_9 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_10 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_11 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_12 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_13 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_14 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_15 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_16 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_17 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_18 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_19 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_20 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_21 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_22 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_23 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_24 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_25 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_26 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_27 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_28 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_29 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_30 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_31 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_32 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_33 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_34 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_36 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_37 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_38 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_39 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_40 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_41 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_42 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_43 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_44 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_45 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_46 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_47 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_48 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_49 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_174 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_176 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_178 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_180 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_182 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_184 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mult6_syn_186 ;  // ../src_v/jpeg_idct_y.v(191)
  wire \u_y/mux10_syn_1 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_463 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_475 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_487 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_499 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_511 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_523 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_535 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_547 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_559 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_571 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_583 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_595 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_607 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_619 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_631 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_643 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_655 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_667 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_679 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_691 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_703 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_715 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_727 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_739 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_751 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_763 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_775 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_787 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_799 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_811 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_823 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_835 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_847 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux13_syn_859 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux14_syn_428 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux15_syn_1 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux15_syn_4 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux17_syn_559 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux18_syn_1 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux19_syn_1 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux46_syn_496 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux47_syn_99 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux47_syn_102 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux47_syn_105 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux47_syn_107 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux47_syn_117 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux47_syn_129 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux47_syn_141 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux49_syn_107 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux53_syn_1 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux56_syn_109 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_236 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_248 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_260 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_272 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_284 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_296 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_308 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_320 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_332 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_344 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_356 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_368 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_380 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_392 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_404 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_416 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_428 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_440 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_452 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_464 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_476 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_488 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_500 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_512 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_524 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_536 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_548 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_560 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux59_syn_654 ;  // ../src_v/jpeg_idct_y.v(111)
  wire \u_y/mux7_syn_295 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_305 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_315 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_325 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_335 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_345 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_355 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_365 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_375 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_385 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_395 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_405 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_415 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_425 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_435 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_445 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_455 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_465 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_475 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_485 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_495 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_505 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_515 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_525 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_535 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_545 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_555 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_565 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_575 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_585 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_595 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_605 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_683 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux7_syn_877 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_341 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_347 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_353 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_359 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_365 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_371 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_377 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_383 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_389 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_395 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_401 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_407 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_413 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_419 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_425 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_431 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_437 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_443 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_449 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_455 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_461 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_467 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_473 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_479 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_485 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_491 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_497 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_503 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_509 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_515 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_521 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_531 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_605 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/mux8_syn_799 ;  // ../src_v/jpeg_idct_y.v(263)
  wire \u_y/sub0_syn_136 ;  // ../src_v/jpeg_idct_y.v(277)
  wire \u_y/sub0_syn_140 ;  // ../src_v/jpeg_idct_y.v(277)
  wire \u_y/sub0_syn_144 ;  // ../src_v/jpeg_idct_y.v(277)
  wire \u_y/sub0_syn_148 ;  // ../src_v/jpeg_idct_y.v(277)
  wire \u_y/sub0_syn_152 ;  // ../src_v/jpeg_idct_y.v(277)
  wire \u_y/sub0_syn_156 ;  // ../src_v/jpeg_idct_y.v(277)
  wire \u_y/sub0_syn_160 ;  // ../src_v/jpeg_idct_y.v(277)
  wire \u_y/sub0_syn_164 ;  // ../src_v/jpeg_idct_y.v(277)
  wire \u_y/sub1_syn_134 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub1_syn_138 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub1_syn_142 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub1_syn_146 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub1_syn_150 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub1_syn_154 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub1_syn_158 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub1_syn_162 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub10_syn_134 ;  // ../src_v/jpeg_idct_y.v(358)
  wire \u_y/sub10_syn_138 ;  // ../src_v/jpeg_idct_y.v(358)
  wire \u_y/sub10_syn_142 ;  // ../src_v/jpeg_idct_y.v(358)
  wire \u_y/sub10_syn_146 ;  // ../src_v/jpeg_idct_y.v(358)
  wire \u_y/sub10_syn_150 ;  // ../src_v/jpeg_idct_y.v(358)
  wire \u_y/sub10_syn_154 ;  // ../src_v/jpeg_idct_y.v(358)
  wire \u_y/sub10_syn_158 ;  // ../src_v/jpeg_idct_y.v(358)
  wire \u_y/sub10_syn_162 ;  // ../src_v/jpeg_idct_y.v(358)
  wire \u_y/sub11_syn_134 ;  // ../src_v/jpeg_idct_y.v(360)
  wire \u_y/sub11_syn_138 ;  // ../src_v/jpeg_idct_y.v(360)
  wire \u_y/sub11_syn_142 ;  // ../src_v/jpeg_idct_y.v(360)
  wire \u_y/sub11_syn_146 ;  // ../src_v/jpeg_idct_y.v(360)
  wire \u_y/sub11_syn_150 ;  // ../src_v/jpeg_idct_y.v(360)
  wire \u_y/sub11_syn_154 ;  // ../src_v/jpeg_idct_y.v(360)
  wire \u_y/sub11_syn_158 ;  // ../src_v/jpeg_idct_y.v(360)
  wire \u_y/sub11_syn_162 ;  // ../src_v/jpeg_idct_y.v(360)
  wire \u_y/sub2_syn_136 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_138 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_140 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_142 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_144 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_146 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_148 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_150 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_152 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_154 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_156 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_158 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_160 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_162 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_164 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub2_syn_166 ;  // ../src_v/jpeg_idct_y.v(282)
  wire \u_y/sub3_syn_132 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_134 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_136 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_138 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_140 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_142 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_144 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_146 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_148 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_150 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_152 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_154 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_156 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_158 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_160 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub3_syn_162 ;  // ../src_v/jpeg_idct_y.v(293)
  wire \u_y/sub4_syn_132 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_134 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_136 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_138 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_140 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_142 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_144 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_146 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_148 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_150 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_152 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_154 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_156 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_158 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_160 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub4_syn_162 ;  // ../src_v/jpeg_idct_y.v(294)
  wire \u_y/sub5_syn_132 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_134 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_136 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_138 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_140 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_142 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_144 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_146 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_148 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_150 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_152 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_154 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_156 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_158 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_160 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub5_syn_162 ;  // ../src_v/jpeg_idct_y.v(299)
  wire \u_y/sub6_syn_132 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_134 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_136 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_138 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_140 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_142 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_144 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_146 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_148 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_150 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_152 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_154 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_156 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_158 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_160 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub6_syn_162 ;  // ../src_v/jpeg_idct_y.v(300)
  wire \u_y/sub7_syn_132 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_134 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_136 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_138 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_140 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_142 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_144 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_146 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_148 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_150 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_152 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_154 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_156 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_158 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_160 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub7_syn_162 ;  // ../src_v/jpeg_idct_y.v(347)
  wire \u_y/sub8_syn_132 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_134 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_136 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_138 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_140 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_142 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_144 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_146 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_148 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_150 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_152 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_154 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_156 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_158 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_160 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub8_syn_162 ;  // ../src_v/jpeg_idct_y.v(349)
  wire \u_y/sub9_syn_120 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_122 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_124 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_126 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_128 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_130 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_132 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_134 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_136 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_138 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_140 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_142 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_144 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/sub9_syn_146 ;  // ../src_v/jpeg_idct_y.v(135)
  wire \u_y/mul0_b2[10]_syn_2 ;
  wire \u_y/mul0_b2[1]_syn_2 ;
  wire \u_y/mul1_b2[0]_syn_2 ;
  wire \u_y/ptr_q[0]_syn_2 ;  // ../src_v/jpeg_idct_y.v(374)
  wire \u_y/out_stg0_valid_q ;  // ../src_v/jpeg_idct_y.v(198)
  wire \u_y/out_stg1_valid_q ;  // ../src_v/jpeg_idct_y.v(213)
  wire \u_y/out_stg3_valid_q ;  // ../src_v/jpeg_idct_y.v(311)
  wire \u_y/ptr_q_reg[0]_syn_2 ;  // ../src_v/jpeg_idct_y.v(376)
  wire \u_y/ptr_q_reg[1]_syn_2 ;  // ../src_v/jpeg_idct_y.v(376)
  wire \u_y/ptr_q_reg[2]_syn_2 ;  // ../src_v/jpeg_idct_y.v(376)
  wire \u_y/ptr_q_reg[3]_syn_2 ;  // ../src_v/jpeg_idct_y.v(376)
  wire \u_y/ptr_q_reg[4]_syn_2 ;  // ../src_v/jpeg_idct_y.v(376)
  wire \u_y/ptr_q_reg[5]_syn_2 ;  // ../src_v/jpeg_idct_y.v(376)

  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_261 (
    .a(\u_y/mult4_syn_90 [1]),
    .b(\u_y/mul2_q [11]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[11]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_262 (
    .a(\u_y/mult4_syn_90 [2]),
    .b(\u_y/mul2_q [12]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[12]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_263 (
    .a(\u_y/mult4_syn_90 [3]),
    .b(\u_y/mul2_q [13]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[13]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_264 (
    .a(\u_y/mult4_syn_90 [4]),
    .b(\u_y/mul2_q [14]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[14]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_265 (
    .a(\u_y/mult4_syn_90 [5]),
    .b(\u_y/mul2_q [15]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[15]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_266 (
    .a(\u_y/mult4_syn_90 [6]),
    .b(\u_y/mul2_q [16]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[16]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_267 (
    .a(\u_y/mult4_syn_90 [7]),
    .b(\u_y/mul2_q [17]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[17]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_268 (
    .a(\u_y/mult4_syn_90 [8]),
    .b(\u_y/mul2_q [18]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[18]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_269 (
    .a(\u_y/mult4_syn_90 [9]),
    .b(\u_y/mul2_q [19]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[19]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_270 (
    .a(\u_y/mult4_syn_90 [10]),
    .b(\u_y/mul2_q [20]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[20]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_271 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [31]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[31]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    al_272 (
    .a(\u_y/mult4_syn_11 ),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(al_131[0]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_273 (
    .a(\u_y/mult4_syn_90 [11]),
    .b(\u_y/mul2_q [21]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[21]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_274 (
    .a(\u_y/mult4_syn_90 [12]),
    .b(\u_y/mul2_q [22]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[22]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_275 (
    .a(\u_y/mult4_syn_12 ),
    .b(\u_y/mul2_q [1]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[1]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_276 (
    .a(\u_y/mult4_syn_13 ),
    .b(\u_y/mul2_q [2]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[2]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_277 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [23]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[23]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_278 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [24]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[24]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_279 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [25]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[25]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_280 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [26]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[26]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_281 (
    .a(\u_y/mult4_syn_14 ),
    .b(\u_y/mul2_q [3]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[3]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_282 (
    .a(\u_y/mult4_syn_15 ),
    .b(\u_y/mul2_q [4]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[4]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_283 (
    .a(\u_y/mult4_syn_16 ),
    .b(\u_y/mul2_q [5]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[5]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_284 (
    .a(\u_y/mult4_syn_17 ),
    .b(\u_y/mul2_q [6]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[6]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_285 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [27]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[27]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_286 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [28]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[28]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_287 (
    .a(\u_y/mult4_syn_18 ),
    .b(\u_y/mul2_q [7]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[7]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_288 (
    .a(\u_y/mult4_syn_19 ),
    .b(\u_y/mul2_q [8]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[8]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_289 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [29]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[29]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_290 (
    .a(\u_y/mult4_syn_90 [13]),
    .b(\u_y/mul2_q [30]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[30]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_291 (
    .a(\u_y/mult4_syn_20 ),
    .b(\u_y/mul2_q [9]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[9]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_292 (
    .a(\u_y/mult4_syn_90 [0]),
    .b(\u_y/mul2_q [10]),
    .c(\u_y/out_stg1_idx_q [1]),
    .o(al_131[10]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_293 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [31]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[31]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    al_294 (
    .a(\u_y/mult5_syn_11 ),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(al_196[0]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_295 (
    .a(\u_y/mult5_syn_12 ),
    .b(\u_y/mul2_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[1]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_296 (
    .a(\u_y/mult5_syn_13 ),
    .b(\u_y/mul2_q [2]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[2]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_297 (
    .a(\u_y/mult5_syn_14 ),
    .b(\u_y/mul2_q [3]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[3]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_298 (
    .a(\u_y/mult5_syn_15 ),
    .b(\u_y/mul2_q [4]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[4]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_299 (
    .a(\u_y/mult5_syn_16 ),
    .b(\u_y/mul2_q [5]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[5]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_300 (
    .a(\u_y/mult5_syn_17 ),
    .b(\u_y/mul2_q [6]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[6]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_301 (
    .a(\u_y/mult5_syn_18 ),
    .b(\u_y/mul2_q [7]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[7]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_302 (
    .a(\u_y/mult5_syn_19 ),
    .b(\u_y/mul2_q [8]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[8]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_303 (
    .a(\u_y/mult5_syn_20 ),
    .b(\u_y/mul2_q [9]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[9]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_304 (
    .a(\u_y/mult5_syn_90 [0]),
    .b(\u_y/mul2_q [10]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[10]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_305 (
    .a(\u_y/mult5_syn_90 [1]),
    .b(\u_y/mul2_q [11]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[11]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_306 (
    .a(\u_y/mult5_syn_90 [2]),
    .b(\u_y/mul2_q [12]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[12]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_307 (
    .a(\u_y/mult5_syn_90 [3]),
    .b(\u_y/mul2_q [13]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[13]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_308 (
    .a(\u_y/mult5_syn_90 [4]),
    .b(\u_y/mul2_q [14]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[14]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_309 (
    .a(\u_y/mult5_syn_90 [5]),
    .b(\u_y/mul2_q [15]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[15]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_310 (
    .a(\u_y/mult5_syn_90 [6]),
    .b(\u_y/mul2_q [16]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[16]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_311 (
    .a(\u_y/mult5_syn_90 [7]),
    .b(\u_y/mul2_q [17]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[17]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_312 (
    .a(\u_y/mult5_syn_90 [8]),
    .b(\u_y/mul2_q [18]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[18]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_313 (
    .a(\u_y/mult5_syn_90 [9]),
    .b(\u_y/mul2_q [19]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[19]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_314 (
    .a(\u_y/mult5_syn_90 [10]),
    .b(\u_y/mul2_q [20]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[20]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_315 (
    .a(\u_y/mult5_syn_90 [11]),
    .b(\u_y/mul2_q [21]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[21]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_316 (
    .a(\u_y/mult5_syn_90 [12]),
    .b(\u_y/mul2_q [22]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[22]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_317 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [23]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[23]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_318 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [24]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[24]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_319 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [25]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[25]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_320 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [26]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[26]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_321 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [27]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[27]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_322 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [28]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[28]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_323 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [29]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[29]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    al_324 (
    .a(\u_y/mult5_syn_90 [13]),
    .b(\u_y/mul2_q [30]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(al_196[30]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_325 (
    .a(\u_y/mul0_q [31]),
    .b(\u_y/o_t0 [31]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[31]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_326 (
    .a(\u_y/mul0_q [0]),
    .b(\u_y/o_t0 [0]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[0]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_327 (
    .a(\u_y/mul0_q [1]),
    .b(\u_y/o_t0 [1]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[1]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_328 (
    .a(\u_y/mul0_q [2]),
    .b(\u_y/o_t0 [2]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[2]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_329 (
    .a(\u_y/mul0_q [3]),
    .b(\u_y/o_t0 [3]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[3]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_330 (
    .a(\u_y/mul0_q [4]),
    .b(\u_y/o_t0 [4]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[4]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_331 (
    .a(\u_y/mul0_q [5]),
    .b(\u_y/o_t0 [5]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[5]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_332 (
    .a(\u_y/mul0_q [6]),
    .b(\u_y/o_t0 [6]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[6]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_333 (
    .a(\u_y/mul0_q [7]),
    .b(\u_y/o_t0 [7]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[7]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_334 (
    .a(\u_y/mul0_q [8]),
    .b(\u_y/o_t0 [8]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[8]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_335 (
    .a(\u_y/mul0_q [9]),
    .b(\u_y/o_t0 [9]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[9]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_336 (
    .a(\u_y/mul0_q [10]),
    .b(\u_y/o_t0 [10]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[10]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_337 (
    .a(\u_y/mul0_q [11]),
    .b(\u_y/o_t0 [11]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[11]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_338 (
    .a(\u_y/mul0_q [12]),
    .b(\u_y/o_t0 [12]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[12]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_339 (
    .a(\u_y/mul0_q [13]),
    .b(\u_y/o_t0 [13]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[13]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_340 (
    .a(\u_y/mul0_q [14]),
    .b(\u_y/o_t0 [14]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[14]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_341 (
    .a(\u_y/mul0_q [15]),
    .b(\u_y/o_t0 [15]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[15]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_342 (
    .a(\u_y/mul0_q [16]),
    .b(\u_y/o_t0 [16]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[16]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_343 (
    .a(\u_y/mul0_q [17]),
    .b(\u_y/o_t0 [17]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[17]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_344 (
    .a(\u_y/mul0_q [18]),
    .b(\u_y/o_t0 [18]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[18]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_345 (
    .a(\u_y/mul0_q [19]),
    .b(\u_y/o_t0 [19]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[19]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_346 (
    .a(\u_y/mul0_q [20]),
    .b(\u_y/o_t0 [20]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[20]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_347 (
    .a(\u_y/mul0_q [21]),
    .b(\u_y/o_t0 [21]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[21]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_348 (
    .a(\u_y/mul0_q [22]),
    .b(\u_y/o_t0 [22]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[22]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_349 (
    .a(\u_y/mul0_q [23]),
    .b(\u_y/o_t0 [23]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[23]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_350 (
    .a(\u_y/mul0_q [24]),
    .b(\u_y/o_t0 [24]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[24]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_351 (
    .a(\u_y/mul0_q [25]),
    .b(\u_y/o_t0 [25]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[25]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_352 (
    .a(\u_y/mul0_q [26]),
    .b(\u_y/o_t0 [26]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[26]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_353 (
    .a(\u_y/mul0_q [27]),
    .b(\u_y/o_t0 [27]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[27]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_354 (
    .a(\u_y/mul0_q [28]),
    .b(\u_y/o_t0 [28]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[28]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_355 (
    .a(\u_y/mul0_q [29]),
    .b(\u_y/o_t0 [29]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[29]));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~((~D*C))+A*B*~((~D*C))+~(A)*B*(~D*C)+A*B*(~D*C))"),
    .INIT(16'haaca))
    al_356 (
    .a(\u_y/mul0_q [30]),
    .b(\u_y/o_t0 [30]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(al_66[30]));
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    clk_i_syn_2 (
    .ipad(clk_i),
    .di(clk_i_dup_1));  // ../src_v/idct_y_area_top.v(2)
  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    img_start_i_syn_16 (
    .ipad(img_start_i),
    .di(img_start_i_dup_15));  // ../src_v/idct_y_area_top.v(2)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[0]_syn_2  (
    .ipad(inport_data0_i[0]),
    .di(\inport_data0_i[0]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[10]_syn_2  (
    .ipad(inport_data0_i[10]),
    .di(\inport_data0_i[10]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[11]_syn_2  (
    .ipad(inport_data0_i[11]),
    .di(\inport_data0_i[11]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[12]_syn_2  (
    .ipad(inport_data0_i[12]),
    .di(\inport_data0_i[12]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[13]_syn_2  (
    .ipad(inport_data0_i[13]),
    .di(\inport_data0_i[13]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[14]_syn_2  (
    .ipad(inport_data0_i[14]),
    .di(\inport_data0_i[14]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[15]_syn_2  (
    .ipad(inport_data0_i[15]),
    .di(\inport_data0_i[15]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[16]_syn_2  (
    .ipad(inport_data0_i[16]),
    .di(\inport_data0_i[16]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[17]_syn_2  (
    .ipad(inport_data0_i[17]),
    .di(\inport_data0_i[17]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[18]_syn_2  (
    .ipad(inport_data0_i[18]),
    .di(\inport_data0_i[18]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[19]_syn_2  (
    .ipad(inport_data0_i[19]),
    .di(\inport_data0_i[19]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[1]_syn_2  (
    .ipad(inport_data0_i[1]),
    .di(\inport_data0_i[1]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[20]_syn_2  (
    .ipad(inport_data0_i[20]),
    .di(\inport_data0_i[20]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[21]_syn_2  (
    .ipad(inport_data0_i[21]),
    .di(\inport_data0_i[21]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[22]_syn_2  (
    .ipad(inport_data0_i[22]),
    .di(\inport_data0_i[22]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[23]_syn_2  (
    .ipad(inport_data0_i[23]),
    .di(\inport_data0_i[23]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[24]_syn_2  (
    .ipad(inport_data0_i[24]),
    .di(\inport_data0_i[24]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[25]_syn_2  (
    .ipad(inport_data0_i[25]),
    .di(\inport_data0_i[25]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[26]_syn_2  (
    .ipad(inport_data0_i[26]),
    .di(\inport_data0_i[26]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[27]_syn_2  (
    .ipad(inport_data0_i[27]),
    .di(\inport_data0_i[27]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[28]_syn_2  (
    .ipad(inport_data0_i[28]),
    .di(\inport_data0_i[28]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[29]_syn_2  (
    .ipad(inport_data0_i[29]),
    .di(\inport_data0_i[29]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[2]_syn_2  (
    .ipad(inport_data0_i[2]),
    .di(\inport_data0_i[2]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[30]_syn_2  (
    .ipad(inport_data0_i[30]),
    .di(\inport_data0_i[30]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[31]_syn_2  (
    .ipad(inport_data0_i[31]),
    .di(\inport_data0_i[31]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[3]_syn_2  (
    .ipad(inport_data0_i[3]),
    .di(\inport_data0_i[3]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[4]_syn_2  (
    .ipad(inport_data0_i[4]),
    .di(\inport_data0_i[4]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[5]_syn_2  (
    .ipad(inport_data0_i[5]),
    .di(\inport_data0_i[5]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[6]_syn_2  (
    .ipad(inport_data0_i[6]),
    .di(\inport_data0_i[6]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[7]_syn_2  (
    .ipad(inport_data0_i[7]),
    .di(\inport_data0_i[7]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[8]_syn_2  (
    .ipad(inport_data0_i[8]),
    .di(\inport_data0_i[8]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data0_i[9]_syn_2  (
    .ipad(inport_data0_i[9]),
    .di(\inport_data0_i[9]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[0]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[0]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[0]_dup_5 ),
    .diq({open_n633,open_n634,open_n635,\u_y/mul3_a [0]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[10]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[10]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[10]_dup_5 ),
    .diq({open_n646,open_n647,open_n648,\u_y/mul3_a [10]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[11]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[11]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[11]_dup_5 ),
    .diq({open_n659,open_n660,open_n661,\u_y/mul3_a [11]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[12]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[12]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[12]_dup_5 ),
    .diq({open_n672,open_n673,open_n674,\u_y/mul3_a [12]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[13]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[13]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[13]_dup_5 ),
    .diq({open_n685,open_n686,open_n687,\u_y/mul3_a [13]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[14]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[14]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[14]_dup_5 ),
    .diq({open_n698,open_n699,open_n700,\u_y/mul3_a [14]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[15]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[15]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[15]_dup_5 ),
    .diq({open_n711,open_n712,open_n713,\u_y/mul3_a [15]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[16]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[16]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[16]_dup_5 ),
    .diq({open_n724,open_n725,open_n726,\u_y/mul3_a [16]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[17]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[17]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[17]_dup_5 ),
    .diq({open_n737,open_n738,open_n739,\u_y/mul3_a [17]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[18]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[18]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[18]_dup_5 ),
    .diq({open_n750,open_n751,open_n752,\u_y/mul3_a [18]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[19]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[19]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[19]_dup_5 ),
    .diq({open_n763,open_n764,open_n765,\u_y/mul3_a [19]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[1]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[1]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[1]_dup_5 ),
    .diq({open_n776,open_n777,open_n778,\u_y/mul3_a [1]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[20]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[20]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[20]_dup_5 ),
    .diq({open_n789,open_n790,open_n791,\u_y/mul3_a [20]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[21]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[21]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[21]_dup_5 ),
    .diq({open_n802,open_n803,open_n804,\u_y/mul3_a [21]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[22]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[22]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[22]_dup_5 ),
    .diq({open_n815,open_n816,open_n817,\u_y/mul3_a [22]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[23]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[23]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[23]_dup_5 ),
    .diq({open_n828,open_n829,open_n830,\u_y/mul3_a [23]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[24]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[24]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[24]_dup_5 ),
    .diq({open_n841,open_n842,open_n843,\u_y/mul3_a [24]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[25]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[25]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[25]_dup_5 ),
    .diq({open_n854,open_n855,open_n856,\u_y/mul3_a [25]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[26]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[26]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[26]_dup_5 ),
    .diq({open_n867,open_n868,open_n869,\u_y/mul3_a [26]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[27]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[27]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[27]_dup_5 ),
    .diq({open_n880,open_n881,open_n882,\u_y/mul3_a [27]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[28]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[28]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[28]_dup_5 ),
    .diq({open_n893,open_n894,open_n895,\u_y/mul3_a [28]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[29]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[29]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[29]_dup_5 ),
    .diq({open_n906,open_n907,open_n908,\u_y/mul3_a [29]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[2]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[2]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[2]_dup_5 ),
    .diq({open_n919,open_n920,open_n921,\u_y/mul3_a [2]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[30]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[30]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[30]_dup_5 ),
    .diq({open_n932,open_n933,open_n934,\u_y/mul3_a [30]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \inport_data1_i[31]_syn_2  (
    .ipad(inport_data1_i[31]),
    .di(\inport_data1_i[31]_dup_1 ));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[3]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[3]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[3]_dup_5 ),
    .diq({open_n962,open_n963,open_n964,\u_y/mul3_a [3]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[4]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[4]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[4]_dup_5 ),
    .diq({open_n975,open_n976,open_n977,\u_y/mul3_a [4]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[5]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[5]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[5]_dup_5 ),
    .diq({open_n988,open_n989,open_n990,\u_y/mul3_a [5]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[6]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[6]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[6]_dup_5 ),
    .diq({open_n1001,open_n1002,open_n1003,\u_y/mul3_a [6]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[7]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[7]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[7]_dup_5 ),
    .diq({open_n1014,open_n1015,open_n1016,\u_y/mul3_a [7]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[8]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[8]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[8]_dup_5 ),
    .diq({open_n1027,open_n1028,open_n1029,\u_y/mul3_a [8]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data1_i[9]_syn_6  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data1_i[9]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data1_i[9]_dup_5 ),
    .diq({open_n1040,open_n1041,open_n1042,\u_y/mul3_a [9]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[0]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[0]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[0]_dup_15 ),
    .diq({open_n1053,open_n1054,open_n1055,\u_y/mul2_a [0]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[10]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[10]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[10]_dup_15 ),
    .diq({open_n1066,open_n1067,open_n1068,\u_y/mul2_a [10]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[11]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[11]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[11]_dup_15 ),
    .diq({open_n1079,open_n1080,open_n1081,\u_y/mul2_a [11]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[12]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[12]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[12]_dup_15 ),
    .diq({open_n1092,open_n1093,open_n1094,\u_y/mul2_a [12]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[13]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[13]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[13]_dup_15 ),
    .diq({open_n1105,open_n1106,open_n1107,\u_y/mul2_a [13]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[14]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[14]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[14]_dup_15 ),
    .diq({open_n1118,open_n1119,open_n1120,\u_y/mul2_a [14]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[15]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[15]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[15]_dup_15 ),
    .diq({open_n1131,open_n1132,open_n1133,\u_y/mul2_a [15]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[16]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[16]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[16]_dup_15 ),
    .diq({open_n1144,open_n1145,open_n1146,\u_y/mul2_a [16]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[17]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[17]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[17]_dup_15 ),
    .diq({open_n1157,open_n1158,open_n1159,\u_y/mul2_a [17]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[18]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[18]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[18]_dup_15 ),
    .diq({open_n1170,open_n1171,open_n1172,\u_y/mul2_a [18]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[19]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[19]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[19]_dup_15 ),
    .diq({open_n1183,open_n1184,open_n1185,\u_y/mul2_a [19]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[1]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[1]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[1]_dup_15 ),
    .diq({open_n1196,open_n1197,open_n1198,\u_y/mul2_a [1]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[20]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[20]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[20]_dup_15 ),
    .diq({open_n1209,open_n1210,open_n1211,\u_y/mul2_a [20]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[21]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[21]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[21]_dup_15 ),
    .diq({open_n1222,open_n1223,open_n1224,\u_y/mul2_a [21]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[22]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[22]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[22]_dup_15 ),
    .diq({open_n1235,open_n1236,open_n1237,\u_y/mul2_a [22]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[23]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[23]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[23]_dup_15 ),
    .diq({open_n1248,open_n1249,open_n1250,\u_y/mul2_a [23]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[24]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[24]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[24]_dup_15 ),
    .diq({open_n1261,open_n1262,open_n1263,\u_y/mul2_a [24]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[25]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[25]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[25]_dup_15 ),
    .diq({open_n1274,open_n1275,open_n1276,\u_y/mul2_a [25]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[26]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[26]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[26]_dup_15 ),
    .diq({open_n1287,open_n1288,open_n1289,\u_y/mul2_a [26]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[27]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[27]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[27]_dup_15 ),
    .diq({open_n1300,open_n1301,open_n1302,\u_y/mul2_a [27]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[28]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[28]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1314,open_n1315,open_n1316,\u_y/mul2_a [28]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[29]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[29]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1328,open_n1329,open_n1330,\u_y/mul2_a [29]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[2]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[2]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[2]_dup_15 ),
    .diq({open_n1341,open_n1342,open_n1343,\u_y/mul2_a [2]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[30]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[30]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1355,open_n1356,open_n1357,\u_y/mul2_a [30]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[3]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[3]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[3]_dup_15 ),
    .diq({open_n1368,open_n1369,open_n1370,\u_y/mul2_a [3]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[4]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[4]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[4]_dup_15 ),
    .diq({open_n1381,open_n1382,open_n1383,\u_y/mul2_a [4]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[5]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[5]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[5]_dup_15 ),
    .diq({open_n1394,open_n1395,open_n1396,\u_y/mul2_a [5]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[6]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[6]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[6]_dup_15 ),
    .diq({open_n1407,open_n1408,open_n1409,\u_y/mul2_a [6]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[7]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[7]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[7]_dup_15 ),
    .diq({open_n1420,open_n1421,open_n1422,\u_y/mul2_a [7]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[8]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[8]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[8]_dup_15 ),
    .diq({open_n1433,open_n1434,open_n1435,\u_y/mul2_a [8]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data2_i[9]_syn_16  (
    .ce(\u_y/mux56_syn_109 ),
    .ipad(inport_data2_i[9]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_data2_i[9]_dup_15 ),
    .diq({open_n1446,open_n1447,open_n1448,\u_y/mul2_a [9]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[0]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[0]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1460,open_n1461,open_n1462,\u_y/mul1_a [0]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[10]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[10]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1474,open_n1475,open_n1476,\u_y/mul1_a [10]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[11]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[11]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1488,open_n1489,open_n1490,\u_y/mul1_a [11]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[12]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[12]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1502,open_n1503,open_n1504,\u_y/mul1_a [12]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[13]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[13]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1516,open_n1517,open_n1518,\u_y/mul1_a [13]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[14]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[14]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1530,open_n1531,open_n1532,\u_y/mul1_a [14]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[15]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[15]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1544,open_n1545,open_n1546,\u_y/mul1_a [15]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[16]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[16]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1558,open_n1559,open_n1560,\u_y/mul1_a [16]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[17]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[17]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1572,open_n1573,open_n1574,\u_y/mul1_a [17]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[18]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[18]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1586,open_n1587,open_n1588,\u_y/mul1_a [18]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[19]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[19]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1600,open_n1601,open_n1602,\u_y/mul1_a [19]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[1]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[1]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1614,open_n1615,open_n1616,\u_y/mul1_a [1]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[20]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[20]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1628,open_n1629,open_n1630,\u_y/mul1_a [20]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[21]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[21]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1642,open_n1643,open_n1644,\u_y/mul1_a [21]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[22]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[22]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1656,open_n1657,open_n1658,\u_y/mul1_a [22]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[23]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[23]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1670,open_n1671,open_n1672,\u_y/mul1_a [23]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[24]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[24]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1684,open_n1685,open_n1686,\u_y/mul1_a [24]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[25]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[25]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1698,open_n1699,open_n1700,\u_y/mul1_a [25]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[26]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[26]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1712,open_n1713,open_n1714,\u_y/mul1_a [26]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[27]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[27]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1726,open_n1727,open_n1728,\u_y/mul1_a [27]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[28]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[28]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1740,open_n1741,open_n1742,\u_y/mul1_a [28]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[29]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[29]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1754,open_n1755,open_n1756,\u_y/mul1_a [29]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[2]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[2]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1768,open_n1769,open_n1770,\u_y/mul1_a [2]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[30]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[30]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1782,open_n1783,open_n1784,\u_y/mul1_a [30]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[31]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[31]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1796,open_n1797,open_n1798,\u_y/mul1_a [31]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[3]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[3]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1810,open_n1811,open_n1812,\u_y/mul1_a [3]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[4]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[4]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1824,open_n1825,open_n1826,\u_y/mul1_a [4]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[5]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[5]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1838,open_n1839,open_n1840,\u_y/mul1_a [5]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[6]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[6]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1852,open_n1853,open_n1854,\u_y/mul1_a [6]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[7]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[7]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1866,open_n1867,open_n1868,\u_y/mul1_a [7]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[8]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[8]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1880,open_n1881,open_n1882,\u_y/mul1_a [8]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("CE"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_data3_i[9]_syn_6  (
    .ce(\u_y/mux46_syn_496 ),
    .ipad(inport_data3_i[9]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1894,open_n1895,open_n1896,\u_y/mul1_a [9]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_idx_i[0]_syn_16  (
    .ipad(inport_idx_i[0]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_idx_i[0]_dup_15 ),
    .diq({open_n1908,open_n1909,open_n1910,\u_y/out_stg0_idx_q [0]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_idx_i[1]_syn_18  (
    .ipad(inport_idx_i[1]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_idx_i[1]_dup_17 ),
    .diq({open_n1922,open_n1923,open_n1924,\u_y/out_stg0_idx_q [1]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    \inport_idx_i[2]_syn_38  (
    .ipad(inport_idx_i[2]),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .di(\inport_idx_i[2]_dup_37 ),
    .diq({open_n1936,open_n1937,open_n1938,\u_y/out_stg0_idx_q [2]}));  // ../src_v/idct_y_area_top.v(3)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("RST"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("SYNC"),
    .TSMUX("1"))
    inport_valid_i_syn_6 (
    .ipad(inport_valid_i),
    .ipclk(clk_i_dup_1),
    .rst(rst_i_dup_1951),
    .diq({open_n1951,open_n1952,open_n1953,\u_y/out_stg0_valid_q }));  // ../src_v/idct_y_area_top.v(2)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[0]_syn_2  (
    .do({open_n1957,open_n1958,open_n1959,\outport_data_o[0]_dup_1 }),
    .opad(outport_data_o[0]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[0]_syn_3  (
    .a(\u_y/block_out[7] [0]),
    .b(\u_y/block_out[5] [0]),
    .c(\u_y/block_out[3] [0]),
    .d(\u_y/block_out[1] [0]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[0]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[0]_syn_5  (
    .a(\u_y/block_out[6] [0]),
    .b(\u_y/block_out[4] [0]),
    .c(\u_y/block_out[2] [0]),
    .d(\u_y/block_out[0] [0]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[0]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[0]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[0]_syn_4 ),
    .c(\outport_data_o[0]_syn_6 ),
    .o(\outport_data_o[0]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[10]_syn_2  (
    .do({open_n1974,open_n1975,open_n1976,\outport_data_o[10]_dup_1 }),
    .opad(outport_data_o[10]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[10]_syn_3  (
    .a(\u_y/block_out[7] [10]),
    .b(\u_y/block_out[5] [10]),
    .c(\u_y/block_out[3] [10]),
    .d(\u_y/block_out[1] [10]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[10]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[10]_syn_5  (
    .a(\u_y/block_out[6] [10]),
    .b(\u_y/block_out[4] [10]),
    .c(\u_y/block_out[2] [10]),
    .d(\u_y/block_out[0] [10]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[10]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[10]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[10]_syn_4 ),
    .c(\outport_data_o[10]_syn_6 ),
    .o(\outport_data_o[10]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[11]_syn_2  (
    .do({open_n1991,open_n1992,open_n1993,\outport_data_o[11]_dup_1 }),
    .opad(outport_data_o[11]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[11]_syn_3  (
    .a(\u_y/block_out[7] [11]),
    .b(\u_y/block_out[5] [11]),
    .c(\u_y/block_out[3] [11]),
    .d(\u_y/block_out[1] [11]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[11]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[11]_syn_5  (
    .a(\u_y/block_out[6] [11]),
    .b(\u_y/block_out[4] [11]),
    .c(\u_y/block_out[2] [11]),
    .d(\u_y/block_out[0] [11]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[11]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[11]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[11]_syn_4 ),
    .c(\outport_data_o[11]_syn_6 ),
    .o(\outport_data_o[11]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[12]_syn_2  (
    .do({open_n2008,open_n2009,open_n2010,\outport_data_o[12]_dup_1 }),
    .opad(outport_data_o[12]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[12]_syn_3  (
    .a(\u_y/block_out[7] [12]),
    .b(\u_y/block_out[5] [12]),
    .c(\u_y/block_out[3] [12]),
    .d(\u_y/block_out[1] [12]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[12]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[12]_syn_5  (
    .a(\u_y/block_out[6] [12]),
    .b(\u_y/block_out[4] [12]),
    .c(\u_y/block_out[2] [12]),
    .d(\u_y/block_out[0] [12]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[12]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[12]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[12]_syn_4 ),
    .c(\outport_data_o[12]_syn_6 ),
    .o(\outport_data_o[12]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[13]_syn_2  (
    .do({open_n2025,open_n2026,open_n2027,\outport_data_o[13]_dup_1 }),
    .opad(outport_data_o[13]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[13]_syn_3  (
    .a(\u_y/block_out[7] [13]),
    .b(\u_y/block_out[5] [13]),
    .c(\u_y/block_out[3] [13]),
    .d(\u_y/block_out[1] [13]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[13]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[13]_syn_5  (
    .a(\u_y/block_out[6] [13]),
    .b(\u_y/block_out[4] [13]),
    .c(\u_y/block_out[2] [13]),
    .d(\u_y/block_out[0] [13]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[13]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[13]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[13]_syn_4 ),
    .c(\outport_data_o[13]_syn_6 ),
    .o(\outport_data_o[13]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[14]_syn_2  (
    .do({open_n2042,open_n2043,open_n2044,\outport_data_o[14]_dup_1 }),
    .opad(outport_data_o[14]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[14]_syn_3  (
    .a(\u_y/block_out[7] [14]),
    .b(\u_y/block_out[5] [14]),
    .c(\u_y/block_out[3] [14]),
    .d(\u_y/block_out[1] [14]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[14]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[14]_syn_5  (
    .a(\u_y/block_out[6] [14]),
    .b(\u_y/block_out[4] [14]),
    .c(\u_y/block_out[2] [14]),
    .d(\u_y/block_out[0] [14]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[14]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[14]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[14]_syn_4 ),
    .c(\outport_data_o[14]_syn_6 ),
    .o(\outport_data_o[14]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[15]_syn_2  (
    .do({open_n2059,open_n2060,open_n2061,\outport_data_o[15]_dup_1 }),
    .opad(outport_data_o[15]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[15]_syn_3  (
    .a(\u_y/block_out[7] [15]),
    .b(\u_y/block_out[5] [15]),
    .c(\u_y/block_out[3] [15]),
    .d(\u_y/block_out[1] [15]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[15]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[15]_syn_5  (
    .a(\u_y/block_out[6] [15]),
    .b(\u_y/block_out[4] [15]),
    .c(\u_y/block_out[2] [15]),
    .d(\u_y/block_out[0] [15]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[15]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[15]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[15]_syn_4 ),
    .c(\outport_data_o[15]_syn_6 ),
    .o(\outport_data_o[15]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[16]_syn_2  (
    .do({open_n2076,open_n2077,open_n2078,\outport_data_o[16]_dup_1 }),
    .opad(outport_data_o[16]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[16]_syn_3  (
    .a(\u_y/block_out[7] [16]),
    .b(\u_y/block_out[5] [16]),
    .c(\u_y/block_out[3] [16]),
    .d(\u_y/block_out[1] [16]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[16]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[16]_syn_5  (
    .a(\u_y/block_out[6] [16]),
    .b(\u_y/block_out[4] [16]),
    .c(\u_y/block_out[2] [16]),
    .d(\u_y/block_out[0] [16]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[16]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[16]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[16]_syn_4 ),
    .c(\outport_data_o[16]_syn_6 ),
    .o(\outport_data_o[16]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[17]_syn_2  (
    .do({open_n2093,open_n2094,open_n2095,\outport_data_o[17]_dup_1 }),
    .opad(outport_data_o[17]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[17]_syn_3  (
    .a(\u_y/block_out[7] [17]),
    .b(\u_y/block_out[5] [17]),
    .c(\u_y/block_out[3] [17]),
    .d(\u_y/block_out[1] [17]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[17]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[17]_syn_5  (
    .a(\u_y/block_out[6] [17]),
    .b(\u_y/block_out[4] [17]),
    .c(\u_y/block_out[2] [17]),
    .d(\u_y/block_out[0] [17]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[17]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[17]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[17]_syn_4 ),
    .c(\outport_data_o[17]_syn_6 ),
    .o(\outport_data_o[17]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[18]_syn_2  (
    .do({open_n2110,open_n2111,open_n2112,\outport_data_o[18]_dup_1 }),
    .opad(outport_data_o[18]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[18]_syn_3  (
    .a(\u_y/block_out[7] [18]),
    .b(\u_y/block_out[5] [18]),
    .c(\u_y/block_out[3] [18]),
    .d(\u_y/block_out[1] [18]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[18]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[18]_syn_5  (
    .a(\u_y/block_out[6] [18]),
    .b(\u_y/block_out[4] [18]),
    .c(\u_y/block_out[2] [18]),
    .d(\u_y/block_out[0] [18]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[18]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[18]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[18]_syn_4 ),
    .c(\outport_data_o[18]_syn_6 ),
    .o(\outport_data_o[18]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[19]_syn_2  (
    .do({open_n2127,open_n2128,open_n2129,\outport_data_o[19]_dup_1 }),
    .opad(outport_data_o[19]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[19]_syn_3  (
    .a(\u_y/block_out[7] [19]),
    .b(\u_y/block_out[5] [19]),
    .c(\u_y/block_out[3] [19]),
    .d(\u_y/block_out[1] [19]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[19]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[19]_syn_5  (
    .a(\u_y/block_out[6] [19]),
    .b(\u_y/block_out[4] [19]),
    .c(\u_y/block_out[2] [19]),
    .d(\u_y/block_out[0] [19]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[19]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[19]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[19]_syn_4 ),
    .c(\outport_data_o[19]_syn_6 ),
    .o(\outport_data_o[19]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[1]_syn_2  (
    .do({open_n2144,open_n2145,open_n2146,\outport_data_o[1]_dup_1 }),
    .opad(outport_data_o[1]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[1]_syn_3  (
    .a(\u_y/block_out[7] [1]),
    .b(\u_y/block_out[5] [1]),
    .c(\u_y/block_out[3] [1]),
    .d(\u_y/block_out[1] [1]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[1]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[1]_syn_5  (
    .a(\u_y/block_out[6] [1]),
    .b(\u_y/block_out[4] [1]),
    .c(\u_y/block_out[2] [1]),
    .d(\u_y/block_out[0] [1]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[1]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[1]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[1]_syn_4 ),
    .c(\outport_data_o[1]_syn_6 ),
    .o(\outport_data_o[1]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[20]_syn_2  (
    .do({open_n2161,open_n2162,open_n2163,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[20]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[20]_syn_3  (
    .a(\u_y/block_out[7] [20]),
    .b(\u_y/block_out[5] [20]),
    .c(\u_y/block_out[3] [20]),
    .d(\u_y/block_out[1] [20]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[20]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[20]_syn_5  (
    .a(\u_y/block_out[6] [20]),
    .b(\u_y/block_out[4] [20]),
    .c(\u_y/block_out[2] [20]),
    .d(\u_y/block_out[0] [20]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[20]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[20]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[20]_syn_4 ),
    .c(\outport_data_o[20]_syn_6 ),
    .o(\outport_data_o[20]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[21]_syn_1  (
    .do({open_n2178,open_n2179,open_n2180,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[21]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[22]_syn_1  (
    .do({open_n2195,open_n2196,open_n2197,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[22]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[23]_syn_1  (
    .do({open_n2212,open_n2213,open_n2214,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[23]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[24]_syn_1  (
    .do({open_n2229,open_n2230,open_n2231,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[24]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[25]_syn_1  (
    .do({open_n2246,open_n2247,open_n2248,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[25]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[26]_syn_1  (
    .do({open_n2263,open_n2264,open_n2265,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[26]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[27]_syn_1  (
    .do({open_n2280,open_n2281,open_n2282,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[27]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[28]_syn_1  (
    .do({open_n2297,open_n2298,open_n2299,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[28]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[29]_syn_1  (
    .do({open_n2314,open_n2315,open_n2316,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[29]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[2]_syn_2  (
    .do({open_n2331,open_n2332,open_n2333,\outport_data_o[2]_dup_1 }),
    .opad(outport_data_o[2]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[2]_syn_3  (
    .a(\u_y/block_out[7] [2]),
    .b(\u_y/block_out[5] [2]),
    .c(\u_y/block_out[3] [2]),
    .d(\u_y/block_out[1] [2]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[2]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[2]_syn_5  (
    .a(\u_y/block_out[6] [2]),
    .b(\u_y/block_out[4] [2]),
    .c(\u_y/block_out[2] [2]),
    .d(\u_y/block_out[0] [2]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[2]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[2]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[2]_syn_4 ),
    .c(\outport_data_o[2]_syn_6 ),
    .o(\outport_data_o[2]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[30]_syn_1  (
    .do({open_n2348,open_n2349,open_n2350,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[30]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[31]_syn_1  (
    .do({open_n2365,open_n2366,open_n2367,\outport_data_o[20]_dup_1 }),
    .opad(outport_data_o[31]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[3]_syn_2  (
    .do({open_n2382,open_n2383,open_n2384,\outport_data_o[3]_dup_1 }),
    .opad(outport_data_o[3]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[3]_syn_3  (
    .a(\u_y/block_out[7] [3]),
    .b(\u_y/block_out[5] [3]),
    .c(\u_y/block_out[3] [3]),
    .d(\u_y/block_out[1] [3]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[3]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[3]_syn_5  (
    .a(\u_y/block_out[6] [3]),
    .b(\u_y/block_out[4] [3]),
    .c(\u_y/block_out[2] [3]),
    .d(\u_y/block_out[0] [3]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[3]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[3]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[3]_syn_4 ),
    .c(\outport_data_o[3]_syn_6 ),
    .o(\outport_data_o[3]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[4]_syn_2  (
    .do({open_n2399,open_n2400,open_n2401,\outport_data_o[4]_dup_1 }),
    .opad(outport_data_o[4]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[4]_syn_3  (
    .a(\u_y/block_out[7] [4]),
    .b(\u_y/block_out[5] [4]),
    .c(\u_y/block_out[3] [4]),
    .d(\u_y/block_out[1] [4]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[4]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[4]_syn_5  (
    .a(\u_y/block_out[6] [4]),
    .b(\u_y/block_out[4] [4]),
    .c(\u_y/block_out[2] [4]),
    .d(\u_y/block_out[0] [4]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[4]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[4]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[4]_syn_4 ),
    .c(\outport_data_o[4]_syn_6 ),
    .o(\outport_data_o[4]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[5]_syn_2  (
    .do({open_n2416,open_n2417,open_n2418,\outport_data_o[5]_dup_1 }),
    .opad(outport_data_o[5]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[5]_syn_3  (
    .a(\u_y/block_out[7] [5]),
    .b(\u_y/block_out[5] [5]),
    .c(\u_y/block_out[3] [5]),
    .d(\u_y/block_out[1] [5]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[5]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[5]_syn_5  (
    .a(\u_y/block_out[6] [5]),
    .b(\u_y/block_out[4] [5]),
    .c(\u_y/block_out[2] [5]),
    .d(\u_y/block_out[0] [5]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[5]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[5]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[5]_syn_4 ),
    .c(\outport_data_o[5]_syn_6 ),
    .o(\outport_data_o[5]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[6]_syn_2  (
    .do({open_n2433,open_n2434,open_n2435,\outport_data_o[6]_dup_1 }),
    .opad(outport_data_o[6]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[6]_syn_3  (
    .a(\u_y/block_out[7] [6]),
    .b(\u_y/block_out[5] [6]),
    .c(\u_y/block_out[3] [6]),
    .d(\u_y/block_out[1] [6]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[6]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[6]_syn_5  (
    .a(\u_y/block_out[6] [6]),
    .b(\u_y/block_out[4] [6]),
    .c(\u_y/block_out[2] [6]),
    .d(\u_y/block_out[0] [6]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[6]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[6]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[6]_syn_4 ),
    .c(\outport_data_o[6]_syn_6 ),
    .o(\outport_data_o[6]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[7]_syn_2  (
    .do({open_n2450,open_n2451,open_n2452,\outport_data_o[7]_dup_1 }),
    .opad(outport_data_o[7]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[7]_syn_3  (
    .a(\u_y/block_out[7] [7]),
    .b(\u_y/block_out[5] [7]),
    .c(\u_y/block_out[3] [7]),
    .d(\u_y/block_out[1] [7]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[7]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[7]_syn_5  (
    .a(\u_y/block_out[6] [7]),
    .b(\u_y/block_out[4] [7]),
    .c(\u_y/block_out[2] [7]),
    .d(\u_y/block_out[0] [7]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[7]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[7]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[7]_syn_4 ),
    .c(\outport_data_o[7]_syn_6 ),
    .o(\outport_data_o[7]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[8]_syn_2  (
    .do({open_n2467,open_n2468,open_n2469,\outport_data_o[8]_dup_1 }),
    .opad(outport_data_o[8]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[8]_syn_3  (
    .a(\u_y/block_out[7] [8]),
    .b(\u_y/block_out[5] [8]),
    .c(\u_y/block_out[3] [8]),
    .d(\u_y/block_out[1] [8]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[8]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[8]_syn_5  (
    .a(\u_y/block_out[6] [8]),
    .b(\u_y/block_out[4] [8]),
    .c(\u_y/block_out[2] [8]),
    .d(\u_y/block_out[0] [8]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[8]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[8]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[8]_syn_4 ),
    .c(\outport_data_o[8]_syn_6 ),
    .o(\outport_data_o[8]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \outport_data_o[9]_syn_2  (
    .do({open_n2484,open_n2485,open_n2486,\outport_data_o[9]_dup_1 }),
    .opad(outport_data_o[9]));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[9]_syn_3  (
    .a(\u_y/block_out[7] [9]),
    .b(\u_y/block_out[5] [9]),
    .c(\u_y/block_out[3] [9]),
    .d(\u_y/block_out[1] [9]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[9]_syn_4 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT6 #(
    .EQN("(~(A)*~(B)*~(C)*D*~(E)*~(F)+A*~(B)*~(C)*D*~(E)*~(F)+~(A)*B*~(C)*D*~(E)*~(F)+A*B*~(C)*D*~(E)*~(F)+~(A)*~(B)*C*D*~(E)*~(F)+A*~(B)*C*D*~(E)*~(F)+~(A)*B*C*D*~(E)*~(F)+A*B*C*D*~(E)*~(F)+~(A)*~(B)*C*~(D)*E*~(F)+A*~(B)*C*~(D)*E*~(F)+~(A)*B*C*~(D)*E*~(F)+A*B*C*~(D)*E*~(F)+~(A)*~(B)*C*D*E*~(F)+A*~(B)*C*D*E*~(F)+~(A)*B*C*D*E*~(F)+A*B*C*D*E*~(F)+~(A)*B*~(C)*~(D)*~(E)*F+A*B*~(C)*~(D)*~(E)*F+~(A)*B*C*~(D)*~(E)*F+A*B*C*~(D)*~(E)*F+~(A)*B*~(C)*D*~(E)*F+A*B*~(C)*D*~(E)*F+~(A)*B*C*D*~(E)*F+A*B*C*D*~(E)*F+A*~(B)*~(C)*~(D)*E*F+A*B*~(C)*~(D)*E*F+A*~(B)*C*~(D)*E*F+A*B*C*~(D)*E*F+A*~(B)*~(C)*D*E*F+A*B*~(C)*D*E*F+A*~(B)*C*D*E*F+A*B*C*D*E*F)"),
    .INIT(64'haaaaccccf0f0ff00))
    \outport_data_o[9]_syn_5  (
    .a(\u_y/block_out[6] [9]),
    .b(\u_y/block_out[4] [9]),
    .c(\u_y/block_out[2] [9]),
    .d(\u_y/block_out[0] [9]),
    .e(\u_y/ptr_q [1]),
    .f(\u_y/ptr_q [2]),
    .o(\outport_data_o[9]_syn_6 ));  // ../src_v/idct_y_area_top.v(4)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \outport_data_o[9]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .b(\outport_data_o[9]_syn_4 ),
    .c(\outport_data_o[9]_syn_6 ),
    .o(\outport_data_o[9]_dup_1 ));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("CE"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    \outport_idx_o[0]_syn_1  (
    .ce(outport_valid_o_dup_17),
    .do({open_n2500,open_n2501,open_n2502,\u_y/ptr_q_b4 [3]}),
    .osclk(clk_i_dup_1),
    .rst(\u_y/mux43_syn_2 [5]),
    .opad(outport_idx_o[0]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("CE"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    \outport_idx_o[1]_syn_1  (
    .ce(outport_valid_o_dup_17),
    .do({open_n2514,open_n2515,open_n2516,\u_y/ptr_q_b4 [4]}),
    .osclk(clk_i_dup_1),
    .rst(\u_y/mux43_syn_2 [5]),
    .opad(outport_idx_o[1]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("CE"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    \outport_idx_o[2]_syn_1  (
    .ce(outport_valid_o_dup_17),
    .do({open_n2528,open_n2529,open_n2530,\u_y/ptr_q_b4 [5]}),
    .osclk(clk_i_dup_1),
    .rst(\u_y/mux43_syn_2 [5]),
    .opad(outport_idx_o[2]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("CE"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    \outport_idx_o[3]_syn_1  (
    .ce(outport_valid_o_dup_17),
    .do({open_n2542,open_n2543,open_n2544,\u_y/ptr_q[0]_syn_2 }),
    .osclk(clk_i_dup_1),
    .rst(\u_y/mux43_syn_2 [5]),
    .opad(outport_idx_o[3]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("CE"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    \outport_idx_o[4]_syn_1  (
    .ce(outport_valid_o_dup_17),
    .do({open_n2556,open_n2557,open_n2558,\u_y/ptr_q_b4 [1]}),
    .osclk(clk_i_dup_1),
    .rst(\u_y/mux43_syn_2 [5]),
    .opad(outport_idx_o[4]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("CE"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    \outport_idx_o[5]_syn_1  (
    .ce(outport_valid_o_dup_17),
    .do({open_n2570,open_n2571,open_n2572,\u_y/ptr_q_b4 [2]}),
    .osclk(clk_i_dup_1),
    .rst(\u_y/mux43_syn_2 [5]),
    .opad(outport_idx_o[5]));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    outport_valid_o_syn_18 (
    .do({open_n2585,open_n2586,open_n2587,\u_y/valid_q [5]}),
    .osclk(clk_i_dup_1),
    .rst(\u_y/mux43_syn_2 [5]),
    .opad(outport_valid_o));  // ../src_v/idct_y_area_top.v(4)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    rst_i_syn_1952 (
    .ipad(rst_i),
    .di(rst_i_dup_1951));  // ../src_v/idct_y_area_top.v(2)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_164  (
    .a({\u_y/mul0_q [1],1'b0}),
    .b({\u_y/mul0_q [2],\u_y/mul0_q [0]}),
    .c(2'b00),
    .d({\u_y/mul1_q [1],1'b1}),
    .e({\u_y/mul1_q [2],\u_y/mul1_q [0]}),
    .f({\u_y/o_t3_b4 [1],open_n2633}),
    .fco(\u_y/add0_syn_134 ),
    .fx({\u_y/o_t3_b4 [2],open_n2634}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_165  (
    .a({\u_y/mul0_q [5],\u_y/mul0_q [3]}),
    .b({\u_y/mul0_q [6],\u_y/mul0_q [4]}),
    .c(2'b00),
    .d({\u_y/mul1_q [5],\u_y/mul1_q [3]}),
    .e({\u_y/mul1_q [6],\u_y/mul1_q [4]}),
    .fci(\u_y/add0_syn_134 ),
    .f({\u_y/o_t3_b4 [5],\u_y/o_t3_b4 [3]}),
    .fco(\u_y/add0_syn_138 ),
    .fx({\u_y/o_t3_b4 [6],\u_y/o_t3_b4 [4]}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_166  (
    .a({\u_y/mul0_q [9],\u_y/mul0_q [7]}),
    .b({\u_y/mul0_q [10],\u_y/mul0_q [8]}),
    .c(2'b00),
    .d({\u_y/mul1_q [9],\u_y/mul1_q [7]}),
    .e({\u_y/mul1_q [10],\u_y/mul1_q [8]}),
    .fci(\u_y/add0_syn_138 ),
    .f({\u_y/o_t3_b4 [9],\u_y/o_t3_b4 [7]}),
    .fco(\u_y/add0_syn_142 ),
    .fx({\u_y/o_t3_b4 [10],\u_y/o_t3_b4 [8]}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_167  (
    .a({\u_y/mul0_q [13],\u_y/mul0_q [11]}),
    .b({\u_y/mul0_q [14],\u_y/mul0_q [12]}),
    .c(2'b00),
    .d({\u_y/mul1_q [13],\u_y/mul1_q [11]}),
    .e({\u_y/mul1_q [14],\u_y/mul1_q [12]}),
    .fci(\u_y/add0_syn_142 ),
    .f({\u_y/o_t3_b4 [13],\u_y/o_t3_b4 [11]}),
    .fco(\u_y/add0_syn_146 ),
    .fx({\u_y/o_t3_b4 [14],\u_y/o_t3_b4 [12]}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_168  (
    .a({\u_y/mul0_q [17],\u_y/mul0_q [15]}),
    .b({\u_y/mul0_q [18],\u_y/mul0_q [16]}),
    .c(2'b00),
    .d({\u_y/mul1_q [17],\u_y/mul1_q [15]}),
    .e({\u_y/mul1_q [18],\u_y/mul1_q [16]}),
    .fci(\u_y/add0_syn_146 ),
    .f({\u_y/o_t3_b4 [17],\u_y/o_t3_b4 [15]}),
    .fco(\u_y/add0_syn_150 ),
    .fx({\u_y/o_t3_b4 [18],\u_y/o_t3_b4 [16]}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_169  (
    .a({\u_y/mul0_q [21],\u_y/mul0_q [19]}),
    .b({\u_y/mul0_q [22],\u_y/mul0_q [20]}),
    .c(2'b00),
    .d({\u_y/mul1_q [21],\u_y/mul1_q [19]}),
    .e({\u_y/mul1_q [22],\u_y/mul1_q [20]}),
    .fci(\u_y/add0_syn_150 ),
    .f({\u_y/o_t3_b4 [21],\u_y/o_t3_b4 [19]}),
    .fco(\u_y/add0_syn_154 ),
    .fx({\u_y/o_t3_b4 [22],\u_y/o_t3_b4 [20]}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_170  (
    .a({\u_y/mul0_q [25],\u_y/mul0_q [23]}),
    .b({\u_y/mul0_q [26],\u_y/mul0_q [24]}),
    .c(2'b00),
    .d({\u_y/mul1_q [25],\u_y/mul1_q [23]}),
    .e({\u_y/mul1_q [26],\u_y/mul1_q [24]}),
    .fci(\u_y/add0_syn_154 ),
    .f({\u_y/o_t3_b4 [25],\u_y/o_t3_b4 [23]}),
    .fco(\u_y/add0_syn_158 ),
    .fx({\u_y/o_t3_b4 [26],\u_y/o_t3_b4 [24]}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_171  (
    .a({\u_y/mul0_q [29],\u_y/mul0_q [27]}),
    .b({\u_y/mul0_q [30],\u_y/mul0_q [28]}),
    .c(2'b00),
    .d({\u_y/mul1_q [29],\u_y/mul1_q [27]}),
    .e({\u_y/mul1_q [30],\u_y/mul1_q [28]}),
    .fci(\u_y/add0_syn_158 ),
    .f({\u_y/o_t3_b4 [29],\u_y/o_t3_b4 [27]}),
    .fco(\u_y/add0_syn_162 ),
    .fx({\u_y/o_t3_b4 [30],\u_y/o_t3_b4 [28]}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add0_syn_164"),
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
    \u_y/add0_syn_172  (
    .a({open_n2763,\u_y/mul0_q [31]}),
    .c(2'b00),
    .d({open_n2768,\u_y/mul1_q [31]}),
    .fci(\u_y/add0_syn_162 ),
    .f({open_n2785,\u_y/o_t3_b4 [31]}));  // ../src_v/jpeg_idct_y.v(266)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_164  (
    .a({\u_y/o_t0 [1],1'b0}),
    .b({\u_y/o_t0 [2],\u_y/o_t0 [0]}),
    .c(2'b00),
    .d({\u_y/o_t7 [1],1'b1}),
    .e({\u_y/o_t7 [2],\u_y/o_t7 [0]}),
    .fco(\u_y/add10_syn_134 ));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_165  (
    .a({\u_y/o_t0 [5],\u_y/o_t0 [3]}),
    .b({\u_y/o_t0 [6],\u_y/o_t0 [4]}),
    .c(2'b00),
    .d({\u_y/o_t7 [5],\u_y/o_t7 [3]}),
    .e({\u_y/o_t7 [6],\u_y/o_t7 [4]}),
    .fci(\u_y/add10_syn_134 ),
    .fco(\u_y/add10_syn_138 ));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_166  (
    .a({\u_y/o_t0 [9],\u_y/o_t0 [7]}),
    .b({\u_y/o_t0 [10],\u_y/o_t0 [8]}),
    .c(2'b00),
    .d({\u_y/o_t7 [9],\u_y/o_t7 [7]}),
    .e({\u_y/o_t7 [10],\u_y/o_t7 [8]}),
    .fci(\u_y/add10_syn_138 ),
    .fco(\u_y/add10_syn_142 ));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_167  (
    .a({\u_y/o_t0 [13],\u_y/o_t0 [11]}),
    .b({\u_y/o_t0 [14],\u_y/o_t0 [12]}),
    .c(2'b00),
    .d({\u_y/o_t7 [13],\u_y/o_t7 [11]}),
    .e({\u_y/o_t7 [14],\u_y/o_t7 [12]}),
    .fci(\u_y/add10_syn_142 ),
    .f({\u_y/block_out[0]_b13 [2],\u_y/block_out[0]_b13 [0]}),
    .fco(\u_y/add10_syn_146 ),
    .fx({\u_y/block_out[0]_b13 [3],\u_y/block_out[0]_b13 [1]}));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_168  (
    .a({\u_y/o_t0 [17],\u_y/o_t0 [15]}),
    .b({\u_y/o_t0 [18],\u_y/o_t0 [16]}),
    .c(2'b00),
    .d({\u_y/o_t7 [17],\u_y/o_t7 [15]}),
    .e({\u_y/o_t7 [18],\u_y/o_t7 [16]}),
    .fci(\u_y/add10_syn_146 ),
    .f({\u_y/block_out[0]_b13 [6],\u_y/block_out[0]_b13 [4]}),
    .fco(\u_y/add10_syn_150 ),
    .fx({\u_y/block_out[0]_b13 [7],\u_y/block_out[0]_b13 [5]}));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_169  (
    .a({\u_y/o_t0 [21],\u_y/o_t0 [19]}),
    .b({\u_y/o_t0 [22],\u_y/o_t0 [20]}),
    .c(2'b00),
    .d({\u_y/o_t7 [21],\u_y/o_t7 [19]}),
    .e({\u_y/o_t7 [22],\u_y/o_t7 [20]}),
    .fci(\u_y/add10_syn_150 ),
    .f({\u_y/block_out[0]_b13 [10],\u_y/block_out[0]_b13 [8]}),
    .fco(\u_y/add10_syn_154 ),
    .fx({\u_y/block_out[0]_b13 [11],\u_y/block_out[0]_b13 [9]}));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_170  (
    .a({\u_y/o_t0 [25],\u_y/o_t0 [23]}),
    .b({\u_y/o_t0 [26],\u_y/o_t0 [24]}),
    .c(2'b00),
    .d({\u_y/o_t7 [25],\u_y/o_t7 [23]}),
    .e({\u_y/o_t7 [26],\u_y/o_t7 [24]}),
    .fci(\u_y/add10_syn_154 ),
    .f({\u_y/block_out[0]_b13 [14],\u_y/block_out[0]_b13 [12]}),
    .fco(\u_y/add10_syn_158 ),
    .fx({\u_y/block_out[0]_b13 [15],\u_y/block_out[0]_b13 [13]}));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_171  (
    .a({\u_y/o_t0 [29],\u_y/o_t0 [27]}),
    .b({\u_y/o_t0 [30],\u_y/o_t0 [28]}),
    .c(2'b00),
    .d({\u_y/o_t7 [29],\u_y/o_t7 [27]}),
    .e({\u_y/o_t7 [30],\u_y/o_t7 [28]}),
    .fci(\u_y/add10_syn_158 ),
    .f({\u_y/block_out[0]_b13 [18],\u_y/block_out[0]_b13 [16]}),
    .fco(\u_y/add10_syn_162 ),
    .fx({\u_y/block_out[0]_b13 [19],\u_y/block_out[0]_b13 [17]}));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add10_syn_164"),
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
    \u_y/add10_syn_172  (
    .a({open_n2948,\u_y/o_t0 [31]}),
    .c(2'b00),
    .d({open_n2953,\u_y/o_t7 [31]}),
    .fci(\u_y/add10_syn_162 ),
    .f({open_n2970,\u_y/block_out[0]_b21 [31]}));  // ../src_v/jpeg_idct_y.v(346)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_165  (
    .a({\u_y/o_s5 [1],1'b0}),
    .b({\u_y/o_s5 [2],\u_y/o_s5 [0]}),
    .c(2'b00),
    .d({\u_y/o_t2 [1],1'b1}),
    .e({\u_y/o_t2 [2],\u_y/o_t1 [0]}),
    .fco(\u_y/add11_syn_135 ));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_166  (
    .a({\u_y/o_s5 [5],\u_y/o_s5 [3]}),
    .b({\u_y/o_s5 [6],\u_y/o_s5 [4]}),
    .c(2'b00),
    .d({\u_y/o_t2 [5],\u_y/o_t2 [3]}),
    .e({\u_y/o_t2 [6],\u_y/o_t2 [4]}),
    .fci(\u_y/add11_syn_135 ),
    .fco(\u_y/add11_syn_139 ));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_167  (
    .a({\u_y/o_s5 [9],\u_y/o_s5 [7]}),
    .b({\u_y/o_s5 [10],\u_y/o_s5 [8]}),
    .c(2'b00),
    .d({\u_y/o_t2 [9],\u_y/o_t2 [7]}),
    .e({\u_y/o_t2 [10],\u_y/o_t2 [8]}),
    .fci(\u_y/add11_syn_139 ),
    .fco(\u_y/add11_syn_143 ));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_168  (
    .a({\u_y/o_s5 [13],\u_y/o_s5 [11]}),
    .b({\u_y/o_s5 [14],\u_y/o_s5 [12]}),
    .c(2'b00),
    .d({\u_y/o_t2 [13],\u_y/o_t2 [11]}),
    .e({\u_y/o_t2 [14],\u_y/o_t2 [12]}),
    .fci(\u_y/add11_syn_143 ),
    .f({\u_y/block_out[0]_b17 [2],\u_y/block_out[0]_b17 [0]}),
    .fco(\u_y/add11_syn_147 ),
    .fx({\u_y/block_out[0]_b17 [3],\u_y/block_out[0]_b17 [1]}));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_169  (
    .a({\u_y/o_s5 [17],\u_y/o_s5 [15]}),
    .b({\u_y/o_s5 [18],\u_y/o_s5 [16]}),
    .c(2'b00),
    .d({\u_y/o_t2 [17],\u_y/o_t2 [15]}),
    .e({\u_y/o_t2 [18],\u_y/o_t2 [16]}),
    .fci(\u_y/add11_syn_147 ),
    .f({\u_y/block_out[0]_b17 [6],\u_y/block_out[0]_b17 [4]}),
    .fco(\u_y/add11_syn_151 ),
    .fx({\u_y/block_out[0]_b17 [7],\u_y/block_out[0]_b17 [5]}));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_170  (
    .a({\u_y/o_s5 [21],\u_y/o_s5 [19]}),
    .b({\u_y/o_s5 [22],\u_y/o_s5 [20]}),
    .c(2'b00),
    .d({\u_y/o_t2 [21],\u_y/o_t2 [19]}),
    .e({\u_y/o_t2 [22],\u_y/o_t2 [20]}),
    .fci(\u_y/add11_syn_151 ),
    .f({\u_y/block_out[0]_b17 [10],\u_y/block_out[0]_b17 [8]}),
    .fco(\u_y/add11_syn_155 ),
    .fx({\u_y/block_out[0]_b17 [11],\u_y/block_out[0]_b17 [9]}));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_171  (
    .a({\u_y/o_s5 [25],\u_y/o_s5 [23]}),
    .b({\u_y/o_s5 [26],\u_y/o_s5 [24]}),
    .c(2'b00),
    .d({\u_y/o_t2 [25],\u_y/o_t2 [23]}),
    .e({\u_y/o_t2 [26],\u_y/o_t2 [24]}),
    .fci(\u_y/add11_syn_155 ),
    .f({\u_y/block_out[0]_b17 [14],\u_y/block_out[0]_b17 [12]}),
    .fco(\u_y/add11_syn_159 ),
    .fx({\u_y/block_out[0]_b17 [15],\u_y/block_out[0]_b17 [13]}));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_172  (
    .a({\u_y/o_s5 [29],\u_y/o_s5 [27]}),
    .b({\u_y/o_s5 [30],\u_y/o_s5 [28]}),
    .c(2'b00),
    .d({\u_y/o_t2 [29],\u_y/o_t2 [27]}),
    .e({\u_y/o_t2 [30],\u_y/o_t2 [28]}),
    .fci(\u_y/add11_syn_159 ),
    .f({\u_y/block_out[0]_b17 [18],\u_y/block_out[0]_b17 [16]}),
    .fco(\u_y/add11_syn_163 ),
    .fx({\u_y/block_out[0]_b17 [19],\u_y/block_out[0]_b17 [17]}));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add11_syn_165"),
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
    \u_y/add11_syn_173  (
    .a({open_n3133,\u_y/o_s5 [31]}),
    .c(2'b00),
    .d({open_n3138,\u_y/o_t2 [31]}),
    .fci(\u_y/add11_syn_163 ),
    .f({open_n3155,\u_y/block_out[0]_b26 [31]}));  // ../src_v/jpeg_idct_y.v(357)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_165  (
    .a({\u_y/o_s6 [1],1'b0}),
    .b({\u_y/o_s6 [2],\u_y/o_s6 [0]}),
    .c(2'b00),
    .d({\u_y/o_t1 [1],1'b1}),
    .e({\u_y/o_t1 [2],\u_y/o_t1 [0]}),
    .fco(\u_y/add12_syn_135 ));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_166  (
    .a({\u_y/o_s6 [5],\u_y/o_s6 [3]}),
    .b({\u_y/o_s6 [6],\u_y/o_s6 [4]}),
    .c(2'b00),
    .d({\u_y/o_t1 [5],\u_y/o_t1 [3]}),
    .e({\u_y/o_t1 [6],\u_y/o_t1 [4]}),
    .fci(\u_y/add12_syn_135 ),
    .fco(\u_y/add12_syn_139 ));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_167  (
    .a({\u_y/o_s6 [9],\u_y/o_s6 [7]}),
    .b({\u_y/o_s6 [10],\u_y/o_s6 [8]}),
    .c(2'b00),
    .d({\u_y/o_t1 [9],\u_y/o_t1 [7]}),
    .e({\u_y/o_t1 [10],\u_y/o_t1 [8]}),
    .fci(\u_y/add12_syn_139 ),
    .fco(\u_y/add12_syn_143 ));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_168  (
    .a({\u_y/o_s6 [13],\u_y/o_s6 [11]}),
    .b({\u_y/o_s6 [14],\u_y/o_s6 [12]}),
    .c(2'b00),
    .d({\u_y/o_t1 [13],\u_y/o_t1 [11]}),
    .e({\u_y/o_t1 [14],\u_y/o_t1 [12]}),
    .fci(\u_y/add12_syn_143 ),
    .f({\u_y/block_out[0]_b16 [2],\u_y/block_out[0]_b16 [0]}),
    .fco(\u_y/add12_syn_147 ),
    .fx({\u_y/block_out[0]_b16 [3],\u_y/block_out[0]_b16 [1]}));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_169  (
    .a({\u_y/o_s6 [17],\u_y/o_s6 [15]}),
    .b({\u_y/o_s6 [18],\u_y/o_s6 [16]}),
    .c(2'b00),
    .d({\u_y/o_t1 [17],\u_y/o_t1 [15]}),
    .e({\u_y/o_t1 [18],\u_y/o_t1 [16]}),
    .fci(\u_y/add12_syn_147 ),
    .f({\u_y/block_out[0]_b16 [6],\u_y/block_out[0]_b16 [4]}),
    .fco(\u_y/add12_syn_151 ),
    .fx({\u_y/block_out[0]_b16 [7],\u_y/block_out[0]_b16 [5]}));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_170  (
    .a({\u_y/o_s6 [21],\u_y/o_s6 [19]}),
    .b({\u_y/o_s6 [22],\u_y/o_s6 [20]}),
    .c(2'b00),
    .d({\u_y/o_t1 [21],\u_y/o_t1 [19]}),
    .e({\u_y/o_t1 [22],\u_y/o_t1 [20]}),
    .fci(\u_y/add12_syn_151 ),
    .f({\u_y/block_out[0]_b16 [10],\u_y/block_out[0]_b16 [8]}),
    .fco(\u_y/add12_syn_155 ),
    .fx({\u_y/block_out[0]_b16 [11],\u_y/block_out[0]_b16 [9]}));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_171  (
    .a({\u_y/o_s6 [25],\u_y/o_s6 [23]}),
    .b({\u_y/o_s6 [26],\u_y/o_s6 [24]}),
    .c(2'b00),
    .d({\u_y/o_t1 [25],\u_y/o_t1 [23]}),
    .e({\u_y/o_t1 [26],\u_y/o_t1 [24]}),
    .fci(\u_y/add12_syn_155 ),
    .f({\u_y/block_out[0]_b16 [14],\u_y/block_out[0]_b16 [12]}),
    .fco(\u_y/add12_syn_159 ),
    .fx({\u_y/block_out[0]_b16 [15],\u_y/block_out[0]_b16 [13]}));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_172  (
    .a({\u_y/o_s6 [29],\u_y/o_s6 [27]}),
    .b({\u_y/o_s6 [30],\u_y/o_s6 [28]}),
    .c(2'b00),
    .d({\u_y/o_t1 [29],\u_y/o_t1 [27]}),
    .e({\u_y/o_t1 [30],\u_y/o_t1 [28]}),
    .fci(\u_y/add12_syn_159 ),
    .f({\u_y/block_out[0]_b16 [18],\u_y/block_out[0]_b16 [16]}),
    .fco(\u_y/add12_syn_163 ),
    .fx({\u_y/block_out[0]_b16 [19],\u_y/block_out[0]_b16 [17]}));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add12_syn_165"),
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
    \u_y/add12_syn_173  (
    .a({open_n3318,\u_y/o_s6 [31]}),
    .c(2'b00),
    .d({open_n3323,\u_y/o_t1 [31]}),
    .fci(\u_y/add12_syn_163 ),
    .f({open_n3340,\u_y/block_out[0]_b25 [31]}));  // ../src_v/jpeg_idct_y.v(359)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_164  (
    .a({\u_y/o_t0 [1],1'b0}),
    .b({\u_y/o_t0 [2],\u_y/o_t0 [0]}),
    .c(2'b00),
    .d({\u_y/o_t3 [1],1'b1}),
    .e({\u_y/o_t3 [2],\u_y/o_t3 [0]}),
    .f({\u_y/o_t0_b3 [1],open_n3363}),
    .fco(\u_y/add2_syn_134 ),
    .fx({\u_y/o_t0_b3 [2],\u_y/o_t0_b3 [0]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_165  (
    .a({\u_y/o_t0 [5],\u_y/o_t0 [3]}),
    .b({\u_y/o_t0 [6],\u_y/o_t0 [4]}),
    .c(2'b00),
    .d({\u_y/o_t3 [5],\u_y/o_t3 [3]}),
    .e({\u_y/o_t3 [6],\u_y/o_t3 [4]}),
    .fci(\u_y/add2_syn_134 ),
    .f({\u_y/o_t0_b3 [5],\u_y/o_t0_b3 [3]}),
    .fco(\u_y/add2_syn_138 ),
    .fx({\u_y/o_t0_b3 [6],\u_y/o_t0_b3 [4]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_166  (
    .a({\u_y/o_t0 [9],\u_y/o_t0 [7]}),
    .b({\u_y/o_t0 [10],\u_y/o_t0 [8]}),
    .c(2'b00),
    .d({\u_y/o_t3 [9],\u_y/o_t3 [7]}),
    .e({\u_y/o_t3 [10],\u_y/o_t3 [8]}),
    .fci(\u_y/add2_syn_138 ),
    .f({\u_y/o_t0_b3 [9],\u_y/o_t0_b3 [7]}),
    .fco(\u_y/add2_syn_142 ),
    .fx({\u_y/o_t0_b3 [10],\u_y/o_t0_b3 [8]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_167  (
    .a({\u_y/o_t0 [13],\u_y/o_t0 [11]}),
    .b({\u_y/o_t0 [14],\u_y/o_t0 [12]}),
    .c(2'b00),
    .d({\u_y/o_t3 [13],\u_y/o_t3 [11]}),
    .e({\u_y/o_t3 [14],\u_y/o_t3 [12]}),
    .fci(\u_y/add2_syn_142 ),
    .f({\u_y/o_t0_b3 [13],\u_y/o_t0_b3 [11]}),
    .fco(\u_y/add2_syn_146 ),
    .fx({\u_y/o_t0_b3 [14],\u_y/o_t0_b3 [12]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_168  (
    .a({\u_y/o_t0 [17],\u_y/o_t0 [15]}),
    .b({\u_y/o_t0 [18],\u_y/o_t0 [16]}),
    .c(2'b00),
    .d({\u_y/o_t3 [17],\u_y/o_t3 [15]}),
    .e({\u_y/o_t3 [18],\u_y/o_t3 [16]}),
    .fci(\u_y/add2_syn_146 ),
    .f({\u_y/o_t0_b3 [17],\u_y/o_t0_b3 [15]}),
    .fco(\u_y/add2_syn_150 ),
    .fx({\u_y/o_t0_b3 [18],\u_y/o_t0_b3 [16]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_169  (
    .a({\u_y/o_t0 [21],\u_y/o_t0 [19]}),
    .b({\u_y/o_t0 [22],\u_y/o_t0 [20]}),
    .c(2'b00),
    .d({\u_y/o_t3 [21],\u_y/o_t3 [19]}),
    .e({\u_y/o_t3 [22],\u_y/o_t3 [20]}),
    .fci(\u_y/add2_syn_150 ),
    .f({\u_y/o_t0_b3 [21],\u_y/o_t0_b3 [19]}),
    .fco(\u_y/add2_syn_154 ),
    .fx({\u_y/o_t0_b3 [22],\u_y/o_t0_b3 [20]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_170  (
    .a({\u_y/o_t0 [25],\u_y/o_t0 [23]}),
    .b({\u_y/o_t0 [26],\u_y/o_t0 [24]}),
    .c(2'b00),
    .d({\u_y/o_t3 [25],\u_y/o_t3 [23]}),
    .e({\u_y/o_t3 [26],\u_y/o_t3 [24]}),
    .fci(\u_y/add2_syn_154 ),
    .f({\u_y/o_t0_b3 [25],\u_y/o_t0_b3 [23]}),
    .fco(\u_y/add2_syn_158 ),
    .fx({\u_y/o_t0_b3 [26],\u_y/o_t0_b3 [24]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_171  (
    .a({\u_y/o_t0 [29],\u_y/o_t0 [27]}),
    .b({\u_y/o_t0 [30],\u_y/o_t0 [28]}),
    .c(2'b00),
    .d({\u_y/o_t3 [29],\u_y/o_t3 [27]}),
    .e({\u_y/o_t3 [30],\u_y/o_t3 [28]}),
    .fci(\u_y/add2_syn_158 ),
    .f({\u_y/o_t0_b3 [29],\u_y/o_t0_b3 [27]}),
    .fco(\u_y/add2_syn_162 ),
    .fx({\u_y/o_t0_b3 [30],\u_y/o_t0_b3 [28]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add2_syn_164"),
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
    \u_y/add2_syn_172  (
    .a({open_n3492,\u_y/o_t0 [31]}),
    .c(2'b00),
    .d({open_n3497,\u_y/o_t3 [31]}),
    .fci(\u_y/add2_syn_162 ),
    .f({open_n3514,\u_y/o_t0_b3 [31]}));  // ../src_v/jpeg_idct_y.v(276)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_164  (
    .a({\u_y/o_s6 [1],1'b0}),
    .b({\u_y/o_s6 [2],\u_y/o_s6 [0]}),
    .c(2'b00),
    .d({\u_y/o_s7 [1],1'b1}),
    .e({\u_y/o_s7 [2],\u_y/o_s7 [0]}),
    .f({\u_y/o_t7_b2 [1],open_n3537}),
    .fco(\u_y/add3_syn_134 ),
    .fx({\u_y/o_t7_b2 [2],open_n3538}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_165  (
    .a({\u_y/o_s6 [5],\u_y/o_s6 [3]}),
    .b({\u_y/o_s6 [6],\u_y/o_s6 [4]}),
    .c(2'b00),
    .d({\u_y/o_s7 [5],\u_y/o_s7 [3]}),
    .e({\u_y/o_s7 [6],\u_y/o_s7 [4]}),
    .fci(\u_y/add3_syn_134 ),
    .f({\u_y/o_t7_b2 [5],\u_y/o_t7_b2 [3]}),
    .fco(\u_y/add3_syn_138 ),
    .fx({\u_y/o_t7_b2 [6],\u_y/o_t7_b2 [4]}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_166  (
    .a({\u_y/o_s6 [9],\u_y/o_s6 [7]}),
    .b({\u_y/o_s6 [10],\u_y/o_s6 [8]}),
    .c(2'b00),
    .d({\u_y/o_s7 [9],\u_y/o_s7 [7]}),
    .e({\u_y/o_s7 [10],\u_y/o_s7 [8]}),
    .fci(\u_y/add3_syn_138 ),
    .f({\u_y/o_t7_b2 [9],\u_y/o_t7_b2 [7]}),
    .fco(\u_y/add3_syn_142 ),
    .fx({\u_y/o_t7_b2 [10],\u_y/o_t7_b2 [8]}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_167  (
    .a({\u_y/o_s6 [13],\u_y/o_s6 [11]}),
    .b({\u_y/o_s6 [14],\u_y/o_s6 [12]}),
    .c(2'b00),
    .d({\u_y/o_s7 [13],\u_y/o_s7 [11]}),
    .e({\u_y/o_s7 [14],\u_y/o_s7 [12]}),
    .fci(\u_y/add3_syn_142 ),
    .f({\u_y/o_t7_b2 [13],\u_y/o_t7_b2 [11]}),
    .fco(\u_y/add3_syn_146 ),
    .fx({\u_y/o_t7_b2 [14],\u_y/o_t7_b2 [12]}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_168  (
    .a({\u_y/o_s6 [17],\u_y/o_s6 [15]}),
    .b({\u_y/o_s6 [18],\u_y/o_s6 [16]}),
    .c(2'b00),
    .d({\u_y/o_s7 [17],\u_y/o_s7 [15]}),
    .e({\u_y/o_s7 [18],\u_y/o_s7 [16]}),
    .fci(\u_y/add3_syn_146 ),
    .f({\u_y/o_t7_b2 [17],\u_y/o_t7_b2 [15]}),
    .fco(\u_y/add3_syn_150 ),
    .fx({\u_y/o_t7_b2 [18],\u_y/o_t7_b2 [16]}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_169  (
    .a({\u_y/o_s6 [21],\u_y/o_s6 [19]}),
    .b({\u_y/o_s6 [22],\u_y/o_s6 [20]}),
    .c(2'b00),
    .d({\u_y/o_s7 [21],\u_y/o_s7 [19]}),
    .e({\u_y/o_s7 [22],\u_y/o_s7 [20]}),
    .fci(\u_y/add3_syn_150 ),
    .f({\u_y/o_t7_b2 [21],\u_y/o_t7_b2 [19]}),
    .fco(\u_y/add3_syn_154 ),
    .fx({\u_y/o_t7_b2 [22],\u_y/o_t7_b2 [20]}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_170  (
    .a({\u_y/o_s6 [25],\u_y/o_s6 [23]}),
    .b({\u_y/o_s6 [26],\u_y/o_s6 [24]}),
    .c(2'b00),
    .d({\u_y/o_s7 [25],\u_y/o_s7 [23]}),
    .e({\u_y/o_s7 [26],\u_y/o_s7 [24]}),
    .fci(\u_y/add3_syn_154 ),
    .f({\u_y/o_t7_b2 [25],\u_y/o_t7_b2 [23]}),
    .fco(\u_y/add3_syn_158 ),
    .fx({\u_y/o_t7_b2 [26],\u_y/o_t7_b2 [24]}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_171  (
    .a({\u_y/o_s6 [29],\u_y/o_s6 [27]}),
    .b({\u_y/o_s6 [30],\u_y/o_s6 [28]}),
    .c(2'b00),
    .d({\u_y/o_s7 [29],\u_y/o_s7 [27]}),
    .e({\u_y/o_s7 [30],\u_y/o_s7 [28]}),
    .fci(\u_y/add3_syn_158 ),
    .f({\u_y/o_t7_b2 [29],\u_y/o_t7_b2 [27]}),
    .fco(\u_y/add3_syn_162 ),
    .fx({\u_y/o_t7_b2 [30],\u_y/o_t7_b2 [28]}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add3_syn_164"),
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
    \u_y/add3_syn_172  (
    .a({open_n3667,\u_y/o_s6 [31]}),
    .c(2'b00),
    .d({open_n3672,\u_y/o_s7 [31]}),
    .fci(\u_y/add3_syn_162 ),
    .f({open_n3689,\u_y/o_t7_b2 [31]}));  // ../src_v/jpeg_idct_y.v(278)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_448  (
    .a({\u_y/mul2_q [1],1'b0}),
    .b({\u_y/mul3_q [1],open_n3695}),
    .f({\u_y/add4_syn_3 [0],open_n3715}),
    .fco(\u_y/add4_syn_193 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_451  (
    .a(\u_y/mul2_q [3:2]),
    .b(\u_y/mul3_q [3:2]),
    .fci(\u_y/add4_syn_193 ),
    .f(\u_y/add4_syn_3 [2:1]),
    .fco(\u_y/add4_syn_195 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_454  (
    .a(\u_y/mul2_q [5:4]),
    .b(\u_y/mul3_q [5:4]),
    .fci(\u_y/add4_syn_195 ),
    .f(\u_y/add4_syn_3 [4:3]),
    .fco(\u_y/add4_syn_197 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_457  (
    .a(\u_y/mul2_q [7:6]),
    .b(\u_y/mul3_q [7:6]),
    .fci(\u_y/add4_syn_197 ),
    .f(\u_y/add4_syn_3 [6:5]),
    .fco(\u_y/add4_syn_199 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_460  (
    .a(\u_y/mul2_q [9:8]),
    .b(\u_y/mul3_q [9:8]),
    .fci(\u_y/add4_syn_199 ),
    .f(\u_y/add4_syn_3 [8:7]),
    .fco(\u_y/add4_syn_201 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_463  (
    .a(\u_y/mul2_q [11:10]),
    .b(\u_y/mul3_q [11:10]),
    .fci(\u_y/add4_syn_201 ),
    .f(\u_y/add4_syn_3 [10:9]),
    .fco(\u_y/add4_syn_203 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_466  (
    .a(\u_y/mul2_q [13:12]),
    .b(\u_y/mul3_q [13:12]),
    .fci(\u_y/add4_syn_203 ),
    .f(\u_y/add4_syn_3 [12:11]),
    .fco(\u_y/add4_syn_205 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_469  (
    .a(\u_y/mul2_q [15:14]),
    .b(\u_y/mul3_q [15:14]),
    .fci(\u_y/add4_syn_205 ),
    .f(\u_y/add4_syn_3 [14:13]),
    .fco(\u_y/add4_syn_207 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_472  (
    .a(\u_y/mul2_q [17:16]),
    .b(\u_y/mul3_q [17:16]),
    .fci(\u_y/add4_syn_207 ),
    .f(\u_y/add4_syn_3 [16:15]),
    .fco(\u_y/add4_syn_209 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_475  (
    .a(\u_y/mul2_q [19:18]),
    .b(\u_y/mul3_q [19:18]),
    .fci(\u_y/add4_syn_209 ),
    .f(\u_y/add4_syn_3 [18:17]),
    .fco(\u_y/add4_syn_211 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_478  (
    .a(\u_y/mul2_q [21:20]),
    .b(\u_y/mul3_q [21:20]),
    .fci(\u_y/add4_syn_211 ),
    .f(\u_y/add4_syn_3 [20:19]),
    .fco(\u_y/add4_syn_213 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_481  (
    .a(\u_y/mul2_q [23:22]),
    .b(\u_y/mul3_q [23:22]),
    .fci(\u_y/add4_syn_213 ),
    .f(\u_y/add4_syn_3 [22:21]),
    .fco(\u_y/add4_syn_215 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_484  (
    .a(\u_y/mul2_q [25:24]),
    .b(\u_y/mul3_q [25:24]),
    .fci(\u_y/add4_syn_215 ),
    .f(\u_y/add4_syn_3 [24:23]),
    .fco(\u_y/add4_syn_217 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_487  (
    .a(\u_y/mul2_q [27:26]),
    .b(\u_y/mul3_q [27:26]),
    .fci(\u_y/add4_syn_217 ),
    .f(\u_y/add4_syn_3 [26:25]),
    .fco(\u_y/add4_syn_219 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_490  (
    .a(\u_y/mul2_q [29:28]),
    .b(\u_y/mul3_q [29:28]),
    .fci(\u_y/add4_syn_219 ),
    .f(\u_y/add4_syn_3 [28:27]),
    .fco(\u_y/add4_syn_221 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_448"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_493  (
    .a(\u_y/mul2_q [31:30]),
    .b(\u_y/mul3_q [31:30]),
    .fci(\u_y/add4_syn_221 ),
    .f(\u_y/add4_syn_3 [30:29]));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_496  (
    .a({\u_y/o_t0_b5 [1],1'b0}),
    .b({\u_y/add4_syn_3 [0],open_n4051}),
    .f({\u_y/add4_syn_35 [0],open_n4071}),
    .fco(\u_y/add4_syn_351 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_499  (
    .a(\u_y/o_t0_b5 [3:2]),
    .b(\u_y/add4_syn_3 [2:1]),
    .fci(\u_y/add4_syn_351 ),
    .f(\u_y/add4_syn_35 [2:1]),
    .fco(\u_y/add4_syn_353 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_502  (
    .a(\u_y/o_t0_b5 [5:4]),
    .b(\u_y/add4_syn_3 [4:3]),
    .fci(\u_y/add4_syn_353 ),
    .f(\u_y/add4_syn_35 [4:3]),
    .fco(\u_y/add4_syn_355 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_505  (
    .a(\u_y/o_t0_b5 [7:6]),
    .b(\u_y/add4_syn_3 [6:5]),
    .fci(\u_y/add4_syn_355 ),
    .f(\u_y/add4_syn_35 [6:5]),
    .fco(\u_y/add4_syn_357 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_508  (
    .a(\u_y/o_t0_b5 [9:8]),
    .b(\u_y/add4_syn_3 [8:7]),
    .fci(\u_y/add4_syn_357 ),
    .f(\u_y/add4_syn_35 [8:7]),
    .fco(\u_y/add4_syn_359 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_511  (
    .a(\u_y/o_t0_b5 [11:10]),
    .b(\u_y/add4_syn_3 [10:9]),
    .fci(\u_y/add4_syn_359 ),
    .f(\u_y/add4_syn_35 [10:9]),
    .fco(\u_y/add4_syn_361 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_514  (
    .a(\u_y/o_t0_b5 [13:12]),
    .b(\u_y/add4_syn_3 [12:11]),
    .fci(\u_y/add4_syn_361 ),
    .f(\u_y/add4_syn_35 [12:11]),
    .fco(\u_y/add4_syn_363 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_517  (
    .a(\u_y/o_t0_b5 [15:14]),
    .b(\u_y/add4_syn_3 [14:13]),
    .fci(\u_y/add4_syn_363 ),
    .f(\u_y/add4_syn_35 [14:13]),
    .fco(\u_y/add4_syn_365 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_520  (
    .a(\u_y/o_t0_b5 [17:16]),
    .b(\u_y/add4_syn_3 [16:15]),
    .fci(\u_y/add4_syn_365 ),
    .f(\u_y/add4_syn_35 [16:15]),
    .fco(\u_y/add4_syn_367 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_523  (
    .a(\u_y/o_t0_b5 [19:18]),
    .b(\u_y/add4_syn_3 [18:17]),
    .fci(\u_y/add4_syn_367 ),
    .f(\u_y/add4_syn_35 [18:17]),
    .fco(\u_y/add4_syn_369 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_526  (
    .a(\u_y/o_t0_b5 [21:20]),
    .b(\u_y/add4_syn_3 [20:19]),
    .fci(\u_y/add4_syn_369 ),
    .f(\u_y/add4_syn_35 [20:19]),
    .fco(\u_y/add4_syn_371 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_529  (
    .a(\u_y/o_t0_b5 [23:22]),
    .b(\u_y/add4_syn_3 [22:21]),
    .fci(\u_y/add4_syn_371 ),
    .f(\u_y/add4_syn_35 [22:21]),
    .fco(\u_y/add4_syn_373 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_532  (
    .a(\u_y/o_t0_b5 [25:24]),
    .b(\u_y/add4_syn_3 [24:23]),
    .fci(\u_y/add4_syn_373 ),
    .f(\u_y/add4_syn_35 [24:23]),
    .fco(\u_y/add4_syn_375 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_535  (
    .a(\u_y/o_t0_b5 [27:26]),
    .b(\u_y/add4_syn_3 [26:25]),
    .fci(\u_y/add4_syn_375 ),
    .f(\u_y/add4_syn_35 [26:25]),
    .fco(\u_y/add4_syn_377 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_538  (
    .a(\u_y/o_t0_b5 [29:28]),
    .b(\u_y/add4_syn_3 [28:27]),
    .fci(\u_y/add4_syn_377 ),
    .f(\u_y/add4_syn_35 [28:27]),
    .fco(\u_y/add4_syn_379 ));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/add4_syn_496"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/add4_syn_541  (
    .a(\u_y/o_t0_b5 [31:30]),
    .b(\u_y/add4_syn_3 [30:29]),
    .fci(\u_y/add4_syn_379 ),
    .f(\u_y/add4_syn_35 [30:29]));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_164  (
    .a({\u_y/o_t4 [1],1'b0}),
    .b({\u_y/o_t4 [2],\u_y/o_t4 [0]}),
    .c(2'b00),
    .d({\u_y/o_t3 [1],1'b1}),
    .e({\u_y/o_t3 [2],\u_y/o_t3 [0]}),
    .f({\u_y/o_t1_b2 [1],open_n4424}),
    .fco(\u_y/add5_syn_134 ),
    .fx({\u_y/o_t1_b2 [2],open_n4425}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_165  (
    .a({\u_y/o_t4 [5],\u_y/o_t4 [3]}),
    .b({\u_y/o_t4 [6],\u_y/o_t4 [4]}),
    .c(2'b00),
    .d({\u_y/o_t3 [5],\u_y/o_t3 [3]}),
    .e({\u_y/o_t3 [6],\u_y/o_t3 [4]}),
    .fci(\u_y/add5_syn_134 ),
    .f({\u_y/o_t1_b2 [5],\u_y/o_t1_b2 [3]}),
    .fco(\u_y/add5_syn_138 ),
    .fx({\u_y/o_t1_b2 [6],\u_y/o_t1_b2 [4]}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_166  (
    .a({\u_y/o_t4 [9],\u_y/o_t4 [7]}),
    .b({\u_y/o_t4 [10],\u_y/o_t4 [8]}),
    .c(2'b00),
    .d({\u_y/o_t3 [9],\u_y/o_t3 [7]}),
    .e({\u_y/o_t3 [10],\u_y/o_t3 [8]}),
    .fci(\u_y/add5_syn_138 ),
    .f({\u_y/o_t1_b2 [9],\u_y/o_t1_b2 [7]}),
    .fco(\u_y/add5_syn_142 ),
    .fx({\u_y/o_t1_b2 [10],\u_y/o_t1_b2 [8]}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_167  (
    .a({\u_y/o_t4 [13],\u_y/o_t4 [11]}),
    .b({\u_y/o_t4 [14],\u_y/o_t4 [12]}),
    .c(2'b00),
    .d({\u_y/o_t3 [13],\u_y/o_t3 [11]}),
    .e({\u_y/o_t3 [14],\u_y/o_t3 [12]}),
    .fci(\u_y/add5_syn_142 ),
    .f({\u_y/o_t1_b2 [13],\u_y/o_t1_b2 [11]}),
    .fco(\u_y/add5_syn_146 ),
    .fx({\u_y/o_t1_b2 [14],\u_y/o_t1_b2 [12]}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_168  (
    .a({\u_y/o_t4 [17],\u_y/o_t4 [15]}),
    .b({\u_y/o_t4 [18],\u_y/o_t4 [16]}),
    .c(2'b00),
    .d({\u_y/o_t3 [17],\u_y/o_t3 [15]}),
    .e({\u_y/o_t3 [18],\u_y/o_t3 [16]}),
    .fci(\u_y/add5_syn_146 ),
    .f({\u_y/o_t1_b2 [17],\u_y/o_t1_b2 [15]}),
    .fco(\u_y/add5_syn_150 ),
    .fx({\u_y/o_t1_b2 [18],\u_y/o_t1_b2 [16]}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_169  (
    .a({\u_y/o_t4 [21],\u_y/o_t4 [19]}),
    .b({\u_y/o_t4 [22],\u_y/o_t4 [20]}),
    .c(2'b00),
    .d({\u_y/o_t3 [21],\u_y/o_t3 [19]}),
    .e({\u_y/o_t3 [22],\u_y/o_t3 [20]}),
    .fci(\u_y/add5_syn_150 ),
    .f({\u_y/o_t1_b2 [21],\u_y/o_t1_b2 [19]}),
    .fco(\u_y/add5_syn_154 ),
    .fx({\u_y/o_t1_b2 [22],\u_y/o_t1_b2 [20]}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_170  (
    .a({\u_y/o_t4 [25],\u_y/o_t4 [23]}),
    .b({\u_y/o_t4 [26],\u_y/o_t4 [24]}),
    .c(2'b00),
    .d({\u_y/o_t3 [25],\u_y/o_t3 [23]}),
    .e({\u_y/o_t3 [26],\u_y/o_t3 [24]}),
    .fci(\u_y/add5_syn_154 ),
    .f({\u_y/o_t1_b2 [25],\u_y/o_t1_b2 [23]}),
    .fco(\u_y/add5_syn_158 ),
    .fx({\u_y/o_t1_b2 [26],\u_y/o_t1_b2 [24]}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_171  (
    .a({\u_y/o_t4 [29],\u_y/o_t4 [27]}),
    .b({\u_y/o_t4 [30],\u_y/o_t4 [28]}),
    .c(2'b00),
    .d({\u_y/o_t3 [29],\u_y/o_t3 [27]}),
    .e({\u_y/o_t3 [30],\u_y/o_t3 [28]}),
    .fci(\u_y/add5_syn_158 ),
    .f({\u_y/o_t1_b2 [29],\u_y/o_t1_b2 [27]}),
    .fco(\u_y/add5_syn_162 ),
    .fx({\u_y/o_t1_b2 [30],\u_y/o_t1_b2 [28]}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add5_syn_164"),
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
    \u_y/add5_syn_172  (
    .a({open_n4554,\u_y/o_t4 [31]}),
    .c(2'b00),
    .d({open_n4559,\u_y/o_t3 [31]}),
    .fci(\u_y/add5_syn_162 ),
    .f({open_n4576,\u_y/block_out[0]_b22 [31]}));  // ../src_v/jpeg_idct_y.v(298)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_164  (
    .a({\u_y/o_t5 [1],1'b0}),
    .b({\u_y/o_t5 [2],\u_y/o_t5 [0]}),
    .c(2'b00),
    .d({\u_y/o_t6 [1],1'b1}),
    .e({\u_y/o_t6 [2],\u_y/o_t6 [0]}),
    .f({\u_y/o_t5_6_b2 [1],open_n4599}),
    .fco(\u_y/add6_syn_134 ),
    .fx({\u_y/o_t5_6_b2 [2],\u_y/o_t5_6_b2 [0]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_165  (
    .a({\u_y/o_t5 [5],\u_y/o_t5 [3]}),
    .b({\u_y/o_t5 [6],\u_y/o_t5 [4]}),
    .c(2'b00),
    .d({\u_y/o_t6 [5],\u_y/o_t6 [3]}),
    .e({\u_y/o_t6 [6],\u_y/o_t6 [4]}),
    .fci(\u_y/add6_syn_134 ),
    .f({\u_y/o_t5_6_b2 [5],\u_y/o_t5_6_b2 [3]}),
    .fco(\u_y/add6_syn_138 ),
    .fx({\u_y/o_t5_6_b2 [6],\u_y/o_t5_6_b2 [4]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_166  (
    .a({\u_y/o_t5 [9],\u_y/o_t5 [7]}),
    .b({\u_y/o_t5 [10],\u_y/o_t5 [8]}),
    .c(2'b00),
    .d({\u_y/o_t6 [9],\u_y/o_t6 [7]}),
    .e({\u_y/o_t6 [10],\u_y/o_t6 [8]}),
    .fci(\u_y/add6_syn_138 ),
    .f({\u_y/o_t5_6_b2 [9],\u_y/o_t5_6_b2 [7]}),
    .fco(\u_y/add6_syn_142 ),
    .fx({\u_y/o_t5_6_b2 [10],\u_y/o_t5_6_b2 [8]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_167  (
    .a({\u_y/o_t5 [13],\u_y/o_t5 [11]}),
    .b({\u_y/o_t5 [14],\u_y/o_t5 [12]}),
    .c(2'b00),
    .d({\u_y/o_t6 [13],\u_y/o_t6 [11]}),
    .e({\u_y/o_t6 [14],\u_y/o_t6 [12]}),
    .fci(\u_y/add6_syn_142 ),
    .f({\u_y/o_t5_6_b2 [13],\u_y/o_t5_6_b2 [11]}),
    .fco(\u_y/add6_syn_146 ),
    .fx({\u_y/o_t5_6_b2 [14],\u_y/o_t5_6_b2 [12]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_168  (
    .a({\u_y/o_t5 [17],\u_y/o_t5 [15]}),
    .b({\u_y/o_t5 [18],\u_y/o_t5 [16]}),
    .c(2'b00),
    .d({\u_y/o_t6 [17],\u_y/o_t6 [15]}),
    .e({\u_y/o_t6 [18],\u_y/o_t6 [16]}),
    .fci(\u_y/add6_syn_146 ),
    .f({\u_y/o_t5_6_b2 [17],\u_y/o_t5_6_b2 [15]}),
    .fco(\u_y/add6_syn_150 ),
    .fx({\u_y/o_t5_6_b2 [18],\u_y/o_t5_6_b2 [16]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_169  (
    .a({\u_y/o_t5 [21],\u_y/o_t5 [19]}),
    .b({\u_y/o_t5 [22],\u_y/o_t5 [20]}),
    .c(2'b00),
    .d({\u_y/o_t6 [21],\u_y/o_t6 [19]}),
    .e({\u_y/o_t6 [22],\u_y/o_t6 [20]}),
    .fci(\u_y/add6_syn_150 ),
    .f({\u_y/o_t5_6_b2 [21],\u_y/o_t5_6_b2 [19]}),
    .fco(\u_y/add6_syn_154 ),
    .fx({\u_y/o_t5_6_b2 [22],\u_y/o_t5_6_b2 [20]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_170  (
    .a({\u_y/o_t5 [25],\u_y/o_t5 [23]}),
    .b({\u_y/o_t5 [26],\u_y/o_t5 [24]}),
    .c(2'b00),
    .d({\u_y/o_t6 [25],\u_y/o_t6 [23]}),
    .e({\u_y/o_t6 [26],\u_y/o_t6 [24]}),
    .fci(\u_y/add6_syn_154 ),
    .f({\u_y/o_t5_6_b2 [25],\u_y/o_t5_6_b2 [23]}),
    .fco(\u_y/add6_syn_158 ),
    .fx({\u_y/o_t5_6_b2 [26],\u_y/o_t5_6_b2 [24]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_171  (
    .a({\u_y/o_t5 [29],\u_y/o_t5 [27]}),
    .b({\u_y/o_t5 [30],\u_y/o_t5 [28]}),
    .c(2'b00),
    .d({\u_y/o_t6 [29],\u_y/o_t6 [27]}),
    .e({\u_y/o_t6 [30],\u_y/o_t6 [28]}),
    .fci(\u_y/add6_syn_158 ),
    .f({\u_y/o_t5_6_b2 [29],\u_y/o_t5_6_b2 [27]}),
    .fco(\u_y/add6_syn_162 ),
    .fx({\u_y/o_t5_6_b2 [30],\u_y/o_t5_6_b2 [28]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add6_syn_164"),
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
    \u_y/add6_syn_172  (
    .a({open_n4728,\u_y/o_t5 [31]}),
    .c(2'b00),
    .d({open_n4733,\u_y/o_t6 [31]}),
    .fci(\u_y/add6_syn_162 ),
    .f({open_n4750,\u_y/o_t5_6_b2 [31]}));  // ../src_v/jpeg_idct_y.v(301)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_166  (
    .a({\u_y/mux8_syn_341 ,1'b0}),
    .b({\u_y/mux8_syn_347 ,\u_y/mux8_syn_531 }),
    .c(2'b00),
    .d({al_196[1],1'b1}),
    .e({al_196[2],al_196[0]}),
    .f({\u_y/o_s6_b1 [1],open_n4773}),
    .fco(\u_y/add9_syn_136 ),
    .fx({\u_y/o_s6_b1 [2],\u_y/o_s6_b1 [0]}));  // ../src_v/jpeg_idct_y.v(306)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_167  (
    .a({\u_y/mux8_syn_365 ,\u_y/mux8_syn_353 }),
    .b({\u_y/mux8_syn_371 ,\u_y/mux8_syn_359 }),
    .c(2'b00),
    .d({al_196[5],al_196[3]}),
    .e({al_196[6],al_196[4]}),
    .fci(\u_y/add9_syn_136 ),
    .f({\u_y/o_s6_b1 [5],\u_y/o_s6_b1 [3]}),
    .fco(\u_y/add9_syn_140 ),
    .fx({\u_y/o_s6_b1 [6],\u_y/o_s6_b1 [4]}));  // ../src_v/jpeg_idct_y.v(306)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_168  (
    .a({\u_y/mux8_syn_389 ,\u_y/mux8_syn_377 }),
    .b({\u_y/mux8_syn_395 ,\u_y/mux8_syn_383 }),
    .c(2'b00),
    .d({al_196[9],al_196[7]}),
    .e({al_196[10],al_196[8]}),
    .fci(\u_y/add9_syn_140 ),
    .f({\u_y/o_s6_b1 [9],\u_y/o_s6_b1 [7]}),
    .fco(\u_y/add9_syn_144 ),
    .fx({\u_y/o_s6_b1 [10],\u_y/o_s6_b1 [8]}));  // ../src_v/jpeg_idct_y.v(306)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_169  (
    .a({\u_y/mux8_syn_413 ,\u_y/mux8_syn_401 }),
    .b({\u_y/mux8_syn_419 ,\u_y/mux8_syn_407 }),
    .c(2'b00),
    .d({al_196[13],al_196[11]}),
    .e({al_196[14],al_196[12]}),
    .fci(\u_y/add9_syn_144 ),
    .f({\u_y/o_s6_b1 [13],\u_y/o_s6_b1 [11]}),
    .fco(\u_y/add9_syn_148 ),
    .fx({\u_y/o_s6_b1 [14],\u_y/o_s6_b1 [12]}));  // ../src_v/jpeg_idct_y.v(306)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_170  (
    .a({\u_y/mux8_syn_437 ,\u_y/mux8_syn_425 }),
    .b({\u_y/mux8_syn_443 ,\u_y/mux8_syn_431 }),
    .c(2'b00),
    .d({al_196[17],al_196[15]}),
    .e({al_196[18],al_196[16]}),
    .fci(\u_y/add9_syn_148 ),
    .f({\u_y/o_s6_b1 [17],\u_y/o_s6_b1 [15]}),
    .fco(\u_y/add9_syn_152 ),
    .fx({\u_y/o_s6_b1 [18],\u_y/o_s6_b1 [16]}));  // ../src_v/jpeg_idct_y.v(306)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_171  (
    .a({\u_y/mux8_syn_461 ,\u_y/mux8_syn_449 }),
    .b({\u_y/mux8_syn_467 ,\u_y/mux8_syn_455 }),
    .c(2'b00),
    .d({al_196[21],al_196[19]}),
    .e({al_196[22],al_196[20]}),
    .fci(\u_y/add9_syn_152 ),
    .f({\u_y/o_s6_b1 [21],\u_y/o_s6_b1 [19]}),
    .fco(\u_y/add9_syn_156 ),
    .fx({\u_y/o_s6_b1 [22],\u_y/o_s6_b1 [20]}));  // ../src_v/jpeg_idct_y.v(306)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_172  (
    .a({\u_y/mux8_syn_485 ,\u_y/mux8_syn_473 }),
    .b({\u_y/mux8_syn_491 ,\u_y/mux8_syn_479 }),
    .c(2'b00),
    .d({al_196[25],al_196[23]}),
    .e({al_196[26],al_196[24]}),
    .fci(\u_y/add9_syn_156 ),
    .f({\u_y/o_s6_b1 [25],\u_y/o_s6_b1 [23]}),
    .fco(\u_y/add9_syn_160 ),
    .fx({\u_y/o_s6_b1 [26],\u_y/o_s6_b1 [24]}));  // ../src_v/jpeg_idct_y.v(306)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_173  (
    .a({\u_y/mux8_syn_509 ,\u_y/mux8_syn_497 }),
    .b({\u_y/mux8_syn_515 ,\u_y/mux8_syn_503 }),
    .c(2'b00),
    .d({al_196[29],al_196[27]}),
    .e({al_196[30],al_196[28]}),
    .fci(\u_y/add9_syn_160 ),
    .f({\u_y/o_s6_b1 [29],\u_y/o_s6_b1 [27]}),
    .fco(\u_y/add9_syn_164 ),
    .fx({\u_y/o_s6_b1 [30],\u_y/o_s6_b1 [28]}));  // ../src_v/jpeg_idct_y.v(306)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/add9_syn_166"),
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
    \u_y/add9_syn_174  (
    .a({open_n4902,\u_y/mux8_syn_521 }),
    .c(2'b00),
    .d({open_n4907,al_196[31]}),
    .fci(\u_y/add9_syn_164 ),
    .f({open_n4924,\u_y/o_s6_b1 [31]}));  // ../src_v/jpeg_idct_y.v(306)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[0]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [0]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[101]_syn_4  (
    .a(\u_y/o_t3 [16:15]),
    .b(\u_y/o_t4 [16:15]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_146 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_148 ),
    .q(\u_y/block_out[4] [5:4]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[103]_syn_4  (
    .a(\u_y/o_t3 [18:17]),
    .b(\u_y/o_t4 [18:17]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_148 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_150 ),
    .q(\u_y/block_out[4] [7:6]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[105]_syn_4  (
    .a(\u_y/o_t3 [20:19]),
    .b(\u_y/o_t4 [20:19]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_150 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_152 ),
    .q(\u_y/block_out[4] [9:8]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[107]_syn_4  (
    .a(\u_y/o_t3 [22:21]),
    .b(\u_y/o_t4 [22:21]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_152 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_154 ),
    .q(\u_y/block_out[4] [11:10]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[109]_syn_4  (
    .a(\u_y/o_t3 [24:23]),
    .b(\u_y/o_t4 [24:23]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_154 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_156 ),
    .q(\u_y/block_out[4] [13:12]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[10]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [10]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[111]_syn_4  (
    .a(\u_y/o_t3 [26:25]),
    .b(\u_y/o_t4 [26:25]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_156 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_158 ),
    .q(\u_y/block_out[4] [15:14]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[113]_syn_4  (
    .a(\u_y/o_t3 [28:27]),
    .b(\u_y/o_t4 [28:27]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_158 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_160 ),
    .q(\u_y/block_out[4] [17:16]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[115]_syn_4  (
    .a(\u_y/o_t3 [30:29]),
    .b(\u_y/o_t4 [30:29]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_160 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_162 ),
    .q(\u_y/block_out[4] [19:18]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y8Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[116]_syn_4  (
    .a({open_n5082,\u_y/o_t3 [31]}),
    .b({open_n5083,\u_y/o_t4 [31]}),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_162 ),
    .sr(rst_i_dup_1951),
    .q({open_n5104,\u_y/block_out[4] [20]}));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[11]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [11]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[128]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [0]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[129]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [1]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[12]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [12]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[130]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [2]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[131]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [3]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[132]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [4]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[133]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [5]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[134]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [6]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[135]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [7]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[136]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [8]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[137]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [9]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[138]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [21]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [10]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[139]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [22]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [11]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[13]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [13]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[140]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [23]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [12]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[141]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [24]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [13]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[142]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [25]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [14]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[143]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [26]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [15]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[144]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [27]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [16]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[145]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [28]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [17]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[146]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [29]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [18]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[147]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [30]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [19]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[148]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b22 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[3] [20]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[14]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [14]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[15]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [15]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[160]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [0]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[161]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [1]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[162]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [2]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[163]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [3]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[164]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [4]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[165]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [5]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[166]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [6]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[167]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [7]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[168]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [8]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[169]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [9]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[16]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [16]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[170]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [10]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[171]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [11]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[172]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [12]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[173]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [13]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[174]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [14]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[175]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [15]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[176]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [16]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[177]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [17]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[178]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [18]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[179]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b17 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [19]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[17]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [17]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[180]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b26 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[2] [20]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[18]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [18]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[192]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [0]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[193]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [1]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[194]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [2]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[195]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [3]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[196]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [4]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[197]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [5]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[198]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [6]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[199]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [7]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[19]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [19]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[1]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [1]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[200]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [8]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[201]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [9]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[202]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [10]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[203]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [11]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[204]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [12]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[205]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [13]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[206]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [14]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[207]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [15]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[208]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [16]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[209]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [17]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[20]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [20]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[210]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [18]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[211]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b16 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [19]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[212]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b25 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[1] [20]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[224]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [0]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[225]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [1]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[226]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [2]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[227]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [3]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[228]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [4]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[229]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [5]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[230]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [6]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[231]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [7]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[232]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [8]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[233]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [9]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[234]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [10]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[235]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [11]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[236]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [12]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[237]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [13]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[238]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [14]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[239]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [15]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[240]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [16]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[241]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [17]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[242]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [18]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[243]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b13 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [19]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[244]  (
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b21 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[0] [20]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[2]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [2]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[32]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [0]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[33]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [1]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[34]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [2]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[35]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [3]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[36]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [4]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[37]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [5]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[38]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [6]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[39]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [7]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[3]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [3]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[40]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [8]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[41]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [9]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[42]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [10]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[43]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [11]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[44]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [12]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[45]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [13]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[46]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [14]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[47]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [15]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[48]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [16]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[49]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [17]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[4]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [4]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[50]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [18]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[51]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b19 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [19]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[52]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b28 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[6] [20]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[5]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [5]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[64]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [0]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[65]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [1]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[66]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [2]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[67]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [3]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[68]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [4]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[69]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [5]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[6]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [6]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[70]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [6]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[71]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [7]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[72]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [8]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[73]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [9]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[74]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [10]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[75]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [11]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[76]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [12]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[77]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [13]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[78]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [14]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[79]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [15]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[7]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [7]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[80]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [16]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[81]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [17]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[82]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [18]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[83]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b18 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [19]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[84]  (
    .ce(\u_y/mux35_syn_2 [223]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b27 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[5] [20]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[8]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [8]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[97]_syn_4  (
    .a(\u_y/o_t3 [12:11]),
    .b(\u_y/o_t4 [12:11]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_142 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_144 ),
    .q(\u_y/block_out[4] [1:0]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[99]_syn_4  (
    .a(\u_y/o_t3 [14:13]),
    .b(\u_y/o_t4 [14:13]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub8_syn_144 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub8_syn_146 ),
    .q(\u_y/block_out[4] [3:2]));  // ../src_v/jpeg_idct_y.v(329)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_reg[9]  (
    .ce(\u_y/mux35_syn_2 [31]),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out_tmp [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/block_out[7] [9]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[11]_syn_4  (
    .a(\u_y/o_t0 [22:21]),
    .b(\u_y/o_t7 [22:21]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_152 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_154 ),
    .q(\u_y/block_out_tmp [11:10]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[13]_syn_4  (
    .a(\u_y/o_t0 [24:23]),
    .b(\u_y/o_t7 [24:23]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_154 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_156 ),
    .q(\u_y/block_out_tmp [13:12]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[15]_syn_4  (
    .a(\u_y/o_t0 [26:25]),
    .b(\u_y/o_t7 [26:25]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_156 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_158 ),
    .q(\u_y/block_out_tmp [15:14]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[17]_syn_4  (
    .a(\u_y/o_t0 [28:27]),
    .b(\u_y/o_t7 [28:27]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_158 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_160 ),
    .q(\u_y/block_out_tmp [17:16]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[19]_syn_4  (
    .a(\u_y/o_t0 [30:29]),
    .b(\u_y/o_t7 [30:29]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_160 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_162 ),
    .q(\u_y/block_out_tmp [19:18]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[1]_syn_4  (
    .a(\u_y/o_t0 [12:11]),
    .b(\u_y/o_t7 [12:11]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_142 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_144 ),
    .q(\u_y/block_out_tmp [1:0]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y8Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[20]_syn_4  (
    .a({open_n5257,\u_y/o_t0 [31]}),
    .b({open_n5258,\u_y/o_t7 [31]}),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_162 ),
    .sr(rst_i_dup_1951),
    .q({open_n5279,\u_y/block_out_tmp [20]}));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[3]_syn_4  (
    .a(\u_y/o_t0 [14:13]),
    .b(\u_y/o_t7 [14:13]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_144 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_146 ),
    .q(\u_y/block_out_tmp [3:2]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[5]_syn_4  (
    .a(\u_y/o_t0 [16:15]),
    .b(\u_y/o_t7 [16:15]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_146 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_148 ),
    .q(\u_y/block_out_tmp [5:4]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[7]_syn_4  (
    .a(\u_y/o_t0 [18:17]),
    .b(\u_y/o_t7 [18:17]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_148 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_150 ),
    .q(\u_y/block_out_tmp [7:6]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/block_out_tmp_reg[9]_syn_4  (
    .a(\u_y/o_t0 [20:19]),
    .b(\u_y/o_t7 [20:19]),
    .ce(\u_y/mux35_syn_2 [254]),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub7_syn_150 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub7_syn_152 ),
    .q(\u_y/block_out_tmp [9:8]));  // ../src_v/jpeg_idct_y.v(329)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/i0_reg[0]_syn_4  (
    .a({\u_y/mux59_syn_236 ,\inport_idx_i[1]_dup_17 }),
    .b({\inport_data0_i[0]_dup_1 ,open_n5356}),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_120 ),
    .q({\u_y/i0 [0],open_n5377}));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[10]_syn_4  (
    .a({\u_y/mux59_syn_356 ,\u_y/mux59_syn_344 }),
    .b({\inport_data0_i[10]_dup_1 ,\inport_data0_i[9]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_128 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_130 ),
    .q(\u_y/i0 [10:9]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[12]_syn_4  (
    .a({\u_y/mux59_syn_380 ,\u_y/mux59_syn_368 }),
    .b({\inport_data0_i[12]_dup_1 ,\inport_data0_i[11]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_130 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_132 ),
    .q(\u_y/i0 [12:11]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[14]_syn_4  (
    .a({\u_y/mux59_syn_404 ,\u_y/mux59_syn_392 }),
    .b({\inport_data0_i[14]_dup_1 ,\inport_data0_i[13]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_132 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_134 ),
    .q(\u_y/i0 [14:13]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[16]_syn_4  (
    .a({\u_y/mux59_syn_428 ,\u_y/mux59_syn_416 }),
    .b({\inport_data0_i[16]_dup_1 ,\inport_data0_i[15]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_134 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_136 ),
    .q(\u_y/i0 [16:15]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[18]_syn_4  (
    .a({\u_y/mux59_syn_452 ,\u_y/mux59_syn_440 }),
    .b({\inport_data0_i[18]_dup_1 ,\inport_data0_i[17]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_136 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_138 ),
    .q(\u_y/i0 [18:17]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[20]_syn_4  (
    .a({\u_y/mux59_syn_476 ,\u_y/mux59_syn_464 }),
    .b({\inport_data0_i[20]_dup_1 ,\inport_data0_i[19]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_138 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_140 ),
    .q(\u_y/i0 [20:19]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[22]_syn_4  (
    .a({\u_y/mux59_syn_500 ,\u_y/mux59_syn_488 }),
    .b({\inport_data0_i[22]_dup_1 ,\inport_data0_i[21]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_140 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_142 ),
    .q(\u_y/i0 [22:21]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[24]_syn_4  (
    .a({\u_y/mux59_syn_524 ,\u_y/mux59_syn_512 }),
    .b({\inport_data0_i[24]_dup_1 ,\inport_data0_i[23]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_142 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_144 ),
    .q(\u_y/i0 [24:23]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[26]_syn_4  (
    .a({\u_y/mux59_syn_548 ,\u_y/mux59_syn_536 }),
    .b({\inport_data0_i[26]_dup_1 ,\inport_data0_i[25]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_144 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_146 ),
    .q(\u_y/i0 [26:25]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/i0_reg[27]_syn_4  (
    .a({open_n5549,\u_y/mux59_syn_560 }),
    .b({open_n5550,\inport_data0_i[27]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_146 ),
    .sr(rst_i_dup_1951),
    .q({open_n5571,\u_y/i0 [27]}));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[2]_syn_4  (
    .a({\u_y/mux59_syn_260 ,\u_y/mux59_syn_248 }),
    .b({\inport_data0_i[2]_dup_1 ,\inport_data0_i[1]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_120 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_122 ),
    .q(\u_y/i0 [2:1]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[4]_syn_4  (
    .a({\u_y/mux59_syn_284 ,\u_y/mux59_syn_272 }),
    .b({\inport_data0_i[4]_dup_1 ,\inport_data0_i[3]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_122 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_124 ),
    .q(\u_y/i0 [4:3]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[6]_syn_4  (
    .a({\u_y/mux59_syn_308 ,\u_y/mux59_syn_296 }),
    .b({\inport_data0_i[6]_dup_1 ,\inport_data0_i[5]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_124 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_126 ),
    .q(\u_y/i0 [6:5]));  // ../src_v/jpeg_idct_y.v(93)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/i0_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/i0_reg[8]_syn_4  (
    .a({\u_y/mux59_syn_332 ,\u_y/mux59_syn_320 }),
    .b({\inport_data0_i[8]_dup_1 ,\inport_data0_i[7]_dup_1 }),
    .ce(\u_y/mux59_syn_654 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub9_syn_126 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub9_syn_128 ),
    .q(\u_y/i0 [8:7]));  // ../src_v/jpeg_idct_y.v(93)
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[0]_syn_1  (
    .a(\inport_data0_i[0]_dup_1 ),
    .b(\inport_data1_i[0]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [0]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[10]_syn_1  (
    .a(\inport_data0_i[10]_dup_1 ),
    .b(\inport_data1_i[10]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [10]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[11]_syn_1  (
    .a(\inport_data0_i[11]_dup_1 ),
    .b(\inport_data1_i[11]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [11]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[12]_syn_1  (
    .a(\inport_data0_i[12]_dup_1 ),
    .b(\inport_data1_i[12]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [12]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[13]_syn_1  (
    .a(\inport_data0_i[13]_dup_1 ),
    .b(\inport_data1_i[13]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [13]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[14]_syn_1  (
    .a(\inport_data0_i[14]_dup_1 ),
    .b(\inport_data1_i[14]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [14]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[15]_syn_1  (
    .a(\inport_data0_i[15]_dup_1 ),
    .b(\inport_data1_i[15]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [15]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[16]_syn_1  (
    .a(\inport_data0_i[16]_dup_1 ),
    .b(\inport_data1_i[16]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [16]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[17]_syn_1  (
    .a(\inport_data0_i[17]_dup_1 ),
    .b(\inport_data1_i[17]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [17]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[18]_syn_1  (
    .a(\inport_data0_i[18]_dup_1 ),
    .b(\inport_data1_i[18]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [18]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[19]_syn_1  (
    .a(\inport_data0_i[19]_dup_1 ),
    .b(\inport_data1_i[19]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [19]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[1]_syn_1  (
    .a(\inport_data0_i[1]_dup_1 ),
    .b(\inport_data1_i[1]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [1]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[20]_syn_1  (
    .a(\inport_data0_i[20]_dup_1 ),
    .b(\inport_data1_i[20]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [20]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[21]_syn_1  (
    .a(\inport_data0_i[21]_dup_1 ),
    .b(\inport_data1_i[21]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [21]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[22]_syn_1  (
    .a(\inport_data0_i[22]_dup_1 ),
    .b(\inport_data1_i[22]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [22]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[23]_syn_1  (
    .a(\inport_data0_i[23]_dup_1 ),
    .b(\inport_data1_i[23]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [23]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[24]_syn_1  (
    .a(\inport_data0_i[24]_dup_1 ),
    .b(\inport_data1_i[24]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [24]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[25]_syn_1  (
    .a(\inport_data0_i[25]_dup_1 ),
    .b(\inport_data1_i[25]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [25]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[26]_syn_1  (
    .a(\inport_data0_i[26]_dup_1 ),
    .b(\inport_data1_i[26]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [26]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[27]_syn_1  (
    .a(\inport_data0_i[27]_dup_1 ),
    .b(\inport_data1_i[27]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [27]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[28]_syn_1  (
    .a(\inport_data0_i[28]_dup_1 ),
    .b(\inport_data1_i[28]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [28]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+~(A)*B*~(C)+A*B*~(C)+~(A)*~(B)*C+~(A)*B*C)"),
    .INIT(8'h5e))
    \u_y/mul0_a_b1[29]_syn_1  (
    .a(\inport_idx_i[2]_dup_37 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .c(\inport_idx_i[0]_dup_15 ),
    .o(\u_y/mux47_syn_129 ));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[29]_syn_2  (
    .a(\inport_data0_i[29]_dup_1 ),
    .b(\inport_data1_i[29]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [29]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[2]_syn_1  (
    .a(\inport_data0_i[2]_dup_1 ),
    .b(\inport_data1_i[2]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [2]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[30]_syn_1  (
    .a(\inport_data0_i[30]_dup_1 ),
    .b(\inport_data1_i[30]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [30]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[31]_syn_1  (
    .a(\inport_data0_i[31]_dup_1 ),
    .b(\inport_data1_i[31]_dup_1 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [31]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[3]_syn_1  (
    .a(\inport_data0_i[3]_dup_1 ),
    .b(\inport_data1_i[3]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [3]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[4]_syn_1  (
    .a(\inport_data0_i[4]_dup_1 ),
    .b(\inport_data1_i[4]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [4]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[5]_syn_1  (
    .a(\inport_data0_i[5]_dup_1 ),
    .b(\inport_data1_i[5]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [5]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[6]_syn_1  (
    .a(\inport_data0_i[6]_dup_1 ),
    .b(\inport_data1_i[6]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [6]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[7]_syn_1  (
    .a(\inport_data0_i[7]_dup_1 ),
    .b(\inport_data1_i[7]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [7]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[8]_syn_1  (
    .a(\inport_data0_i[8]_dup_1 ),
    .b(\inport_data1_i[8]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [8]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(A)*~(C)+B*A*~(C)+~(B)*A*C+B*A*C)"),
    .INIT(8'hac))
    \u_y/mul0_a_b1[9]_syn_1  (
    .a(\inport_data0_i[9]_dup_1 ),
    .b(\inport_data1_i[9]_dup_5 ),
    .c(\u_y/mux47_syn_129 ),
    .o(\u_y/mul0_a_b1 [9]));
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mul0_b2[10]_syn_3  (
    .a(\inport_idx_i[2]_dup_37 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mul0_b2[1]_syn_2 ));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_y/mul0_b2[10]_syn_4  (
    .a(\inport_idx_i[2]_dup_37 ),
    .b(\inport_idx_i[0]_dup_15 ),
    .o(\u_y/mul1_b2[0]_syn_2 ));
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mul0_b2[10]_syn_5  (
    .a(\u_y/mul0_b2[1]_syn_2 ),
    .b(\u_y/mul1_b2[0]_syn_2 ),
    .o(\u_y/mul0_b2[10]_syn_2 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[0]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_4 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [0]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[10]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_14 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [10]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[11]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_15 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [11]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[12]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_16 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [12]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[13]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_17 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [13]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[14]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_18 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [14]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[15]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_19 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [15]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[16]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_20 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [16]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[17]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_21 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [17]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul0_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul0_q_reg[18]_syn_4  (
    .a({\u_y/mult6_syn_22 ,1'b0}),
    .b({\u_y/mult6_syn_36 ,open_n5657}),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult6_syn_174 ),
    .q({\u_y/mul0_q [18],open_n5679}));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[1]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_5 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [1]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul0_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul0_q_reg[20]_syn_4  (
    .a({\u_y/mult6_syn_24 ,\u_y/mult6_syn_23 }),
    .b({\u_y/mult6_syn_38 ,\u_y/mult6_syn_37 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult6_syn_174 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult6_syn_176 ),
    .q(\u_y/mul0_q [20:19]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul0_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul0_q_reg[22]_syn_4  (
    .a({\u_y/mult6_syn_26 ,\u_y/mult6_syn_25 }),
    .b({\u_y/mult6_syn_40 ,\u_y/mult6_syn_39 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult6_syn_176 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult6_syn_178 ),
    .q(\u_y/mul0_q [22:21]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul0_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul0_q_reg[24]_syn_4  (
    .a({\u_y/mult6_syn_28 ,\u_y/mult6_syn_27 }),
    .b({\u_y/mult6_syn_42 ,\u_y/mult6_syn_41 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult6_syn_178 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult6_syn_180 ),
    .q(\u_y/mul0_q [24:23]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul0_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul0_q_reg[26]_syn_4  (
    .a({\u_y/mult6_syn_30 ,\u_y/mult6_syn_29 }),
    .b({\u_y/mult6_syn_44 ,\u_y/mult6_syn_43 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult6_syn_180 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult6_syn_182 ),
    .q(\u_y/mul0_q [26:25]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul0_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul0_q_reg[28]_syn_4  (
    .a({\u_y/mult6_syn_32 ,\u_y/mult6_syn_31 }),
    .b({\u_y/mult6_syn_46 ,\u_y/mult6_syn_45 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult6_syn_182 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult6_syn_184 ),
    .q(\u_y/mul0_q [28:27]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[2]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_6 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [2]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul0_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul0_q_reg[30]_syn_4  (
    .a({\u_y/mult6_syn_34 ,\u_y/mult6_syn_33 }),
    .b({\u_y/mult6_syn_48 ,\u_y/mult6_syn_47 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult6_syn_184 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult6_syn_186 ),
    .q(\u_y/mul0_q [30:29]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul0_q_reg[18]_syn_4"),
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
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[31]_syn_4  (
    .a({open_n5802,\u_y/mult6_syn_34 }),
    .b({open_n5803,\u_y/mult6_syn_49 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult6_syn_186 ),
    .sr(rst_i_dup_1951),
    .q({open_n5825,\u_y/mul0_q [31]}));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[3]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_7 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [3]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[4]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_8 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [4]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[5]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_9 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [5]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[6]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_10 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [6]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[7]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_11 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [7]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[8]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_12 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [8]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul0_q_reg[9]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult6_syn_13 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul0_q [9]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[0]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_4 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [0]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[10]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_14 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [10]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[11]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_15 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [11]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[12]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_16 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [12]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[13]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_17 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [13]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[14]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_18 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [14]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[15]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_19 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [15]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[16]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_20 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [16]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[17]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_21 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [17]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul1_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul1_q_reg[18]_syn_4  (
    .a({\u_y/mult0_syn_22 ,1'b0}),
    .b({\u_y/mult0_syn_36 ,open_n5842}),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult0_syn_174 ),
    .q({\u_y/mul1_q [18],open_n5864}));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[1]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_5 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [1]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul1_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul1_q_reg[20]_syn_4  (
    .a({\u_y/mult0_syn_24 ,\u_y/mult0_syn_23 }),
    .b({\u_y/mult0_syn_38 ,\u_y/mult0_syn_37 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult0_syn_174 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult0_syn_176 ),
    .q(\u_y/mul1_q [20:19]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul1_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul1_q_reg[22]_syn_4  (
    .a({\u_y/mult0_syn_26 ,\u_y/mult0_syn_25 }),
    .b({\u_y/mult0_syn_40 ,\u_y/mult0_syn_39 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult0_syn_176 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult0_syn_178 ),
    .q(\u_y/mul1_q [22:21]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul1_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul1_q_reg[24]_syn_4  (
    .a({\u_y/mult0_syn_28 ,\u_y/mult0_syn_27 }),
    .b({\u_y/mult0_syn_42 ,\u_y/mult0_syn_41 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult0_syn_178 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult0_syn_180 ),
    .q(\u_y/mul1_q [24:23]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul1_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul1_q_reg[26]_syn_4  (
    .a({\u_y/mult0_syn_30 ,\u_y/mult0_syn_29 }),
    .b({\u_y/mult0_syn_44 ,\u_y/mult0_syn_43 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult0_syn_180 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult0_syn_182 ),
    .q(\u_y/mul1_q [26:25]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul1_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul1_q_reg[28]_syn_4  (
    .a({\u_y/mult0_syn_32 ,\u_y/mult0_syn_31 }),
    .b({\u_y/mult0_syn_46 ,\u_y/mult0_syn_45 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult0_syn_182 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult0_syn_184 ),
    .q(\u_y/mul1_q [28:27]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[2]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_6 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [2]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul1_q_reg[18]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul1_q_reg[30]_syn_4  (
    .a({\u_y/mult0_syn_34 ,\u_y/mult0_syn_33 }),
    .b({\u_y/mult0_syn_48 ,\u_y/mult0_syn_47 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult0_syn_184 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult0_syn_186 ),
    .q(\u_y/mul1_q [30:29]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul1_q_reg[18]_syn_4"),
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
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[31]_syn_4  (
    .a({open_n5987,\u_y/mult0_syn_34 }),
    .b({open_n5988,\u_y/mult0_syn_49 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult0_syn_186 ),
    .sr(rst_i_dup_1951),
    .q({open_n6010,\u_y/mul1_q [31]}));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[3]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_7 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [3]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[4]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_8 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [4]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[5]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_9 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [5]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[6]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_10 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [6]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[7]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_11 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [7]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[8]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_12 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [8]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul1_q_reg[9]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult0_syn_13 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul1_q [9]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[10]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_14 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [10]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[11]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_15 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [11]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[12]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_16 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [12]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[13]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_17 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [13]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[14]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_18 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [14]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[15]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_19 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [15]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[16]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_20 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [16]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[17]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_21 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [17]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[18]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_22 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [18]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul2_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul2_q_reg[19]_syn_4  (
    .a({\u_y/mult1_syn_23 ,1'b0}),
    .b({\u_y/mult1_syn_36 ,open_n6027}),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult1_syn_166 ),
    .q({\u_y/mul2_q [19],open_n6049}));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[1]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_5 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [1]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul2_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul2_q_reg[21]_syn_4  (
    .a({\u_y/mult1_syn_25 ,\u_y/mult1_syn_24 }),
    .b({\u_y/mult1_syn_38 ,\u_y/mult1_syn_37 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult1_syn_166 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult1_syn_168 ),
    .q(\u_y/mul2_q [21:20]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul2_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul2_q_reg[23]_syn_4  (
    .a({\u_y/mult1_syn_27 ,\u_y/mult1_syn_26 }),
    .b({\u_y/mult1_syn_40 ,\u_y/mult1_syn_39 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult1_syn_168 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult1_syn_170 ),
    .q(\u_y/mul2_q [23:22]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul2_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul2_q_reg[25]_syn_4  (
    .a({\u_y/mult1_syn_29 ,\u_y/mult1_syn_28 }),
    .b({\u_y/mult1_syn_42 ,\u_y/mult1_syn_41 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult1_syn_170 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult1_syn_172 ),
    .q(\u_y/mul2_q [25:24]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul2_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul2_q_reg[27]_syn_4  (
    .a({\u_y/mult1_syn_31 ,\u_y/mult1_syn_30 }),
    .b({\u_y/mult1_syn_44 ,\u_y/mult1_syn_43 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult1_syn_172 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult1_syn_174 ),
    .q(\u_y/mul2_q [27:26]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul2_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul2_q_reg[29]_syn_4  (
    .a({\u_y/mult1_syn_33 ,\u_y/mult1_syn_32 }),
    .b({\u_y/mult1_syn_46 ,\u_y/mult1_syn_45 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult1_syn_174 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult1_syn_176 ),
    .q(\u_y/mul2_q [29:28]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[2]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_6 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [2]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul2_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul2_q_reg[31]_syn_4  (
    .a({\u_y/mult1_syn_34 ,\u_y/mult1_syn_34 }),
    .b({\u_y/mult1_syn_48 ,\u_y/mult1_syn_47 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult1_syn_176 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [31:30]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[3]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_7 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [3]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[4]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_8 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [4]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[5]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_9 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [5]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[6]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_10 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [6]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[7]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_11 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [7]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[8]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_12 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [8]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul2_q_reg[9]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult1_syn_13 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul2_q [9]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[10]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_14 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [10]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[11]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_15 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [11]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[12]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_16 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [12]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[13]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_17 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [13]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[14]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_18 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [14]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[15]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_19 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [15]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[16]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_20 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [16]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[17]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_21 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [17]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[18]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_22 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [18]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul3_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul3_q_reg[19]_syn_4  (
    .a({\u_y/mult2_syn_23 ,1'b0}),
    .b({\u_y/mult2_syn_36 ,open_n6189}),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult2_syn_166 ),
    .q({\u_y/mul3_q [19],open_n6211}));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[1]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_5 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [1]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul3_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul3_q_reg[21]_syn_4  (
    .a({\u_y/mult2_syn_25 ,\u_y/mult2_syn_24 }),
    .b({\u_y/mult2_syn_38 ,\u_y/mult2_syn_37 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult2_syn_166 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult2_syn_168 ),
    .q(\u_y/mul3_q [21:20]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul3_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul3_q_reg[23]_syn_4  (
    .a({\u_y/mult2_syn_27 ,\u_y/mult2_syn_26 }),
    .b({\u_y/mult2_syn_40 ,\u_y/mult2_syn_39 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult2_syn_168 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult2_syn_170 ),
    .q(\u_y/mul3_q [23:22]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul3_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul3_q_reg[25]_syn_4  (
    .a({\u_y/mult2_syn_29 ,\u_y/mult2_syn_28 }),
    .b({\u_y/mult2_syn_42 ,\u_y/mult2_syn_41 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult2_syn_170 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult2_syn_172 ),
    .q(\u_y/mul3_q [25:24]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul3_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul3_q_reg[27]_syn_4  (
    .a({\u_y/mult2_syn_31 ,\u_y/mult2_syn_30 }),
    .b({\u_y/mult2_syn_44 ,\u_y/mult2_syn_43 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult2_syn_172 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult2_syn_174 ),
    .q(\u_y/mul3_q [27:26]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul3_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul3_q_reg[29]_syn_4  (
    .a({\u_y/mult2_syn_33 ,\u_y/mult2_syn_32 }),
    .b({\u_y/mult2_syn_46 ,\u_y/mult2_syn_45 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult2_syn_174 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult2_syn_176 ),
    .q(\u_y/mul3_q [29:28]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[2]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_6 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [2]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul3_q_reg[19]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul3_q_reg[31]_syn_4  (
    .a({\u_y/mult2_syn_34 ,\u_y/mult2_syn_34 }),
    .b({\u_y/mult2_syn_48 ,\u_y/mult2_syn_47 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult2_syn_176 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [31:30]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[3]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_7 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [3]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[4]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_8 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [4]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[5]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_9 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [5]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[6]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_10 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [6]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[7]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_11 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [7]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[8]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_12 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [8]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul3_q_reg[9]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult2_syn_13 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul3_q [9]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[10]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_11 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [10]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[11]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_12 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [11]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[12]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_13 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [12]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[13]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_14 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [13]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[14]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_15 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [14]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[15]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_16 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [15]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[16]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_17 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [16]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[17]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_18 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [17]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[18]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_19 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [18]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[19]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_20 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [19]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[20]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_21 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [20]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[21]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_22 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [21]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul4_q_reg[22]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul4_q_reg[22]_syn_4  (
    .a({\u_y/mult3_syn_23 ,1'b0}),
    .b({\u_y/mult3_syn_33 ,open_n6354}),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult3_syn_139 ),
    .q({\u_y/mul4_q [22],open_n6376}));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul4_q_reg[22]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul4_q_reg[24]_syn_4  (
    .a({\u_y/mult3_syn_25 ,\u_y/mult3_syn_24 }),
    .b({\u_y/mult3_syn_35 ,\u_y/mult3_syn_34 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult3_syn_139 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult3_syn_141 ),
    .q(\u_y/mul4_q [24:23]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul4_q_reg[22]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul4_q_reg[26]_syn_4  (
    .a({\u_y/mult3_syn_27 ,\u_y/mult3_syn_26 }),
    .b({\u_y/mult3_syn_37 ,\u_y/mult3_syn_36 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult3_syn_141 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult3_syn_143 ),
    .q(\u_y/mul4_q [26:25]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul4_q_reg[22]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul4_q_reg[28]_syn_4  (
    .a({\u_y/mult3_syn_29 ,\u_y/mult3_syn_28 }),
    .b({\u_y/mult3_syn_39 ,\u_y/mult3_syn_38 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult3_syn_143 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult3_syn_145 ),
    .q(\u_y/mul4_q [28:27]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul4_q_reg[22]_syn_4"),
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
    .SRMUX("SR"))
    \u_y/mul4_q_reg[30]_syn_4  (
    .a({\u_y/mult3_syn_31 ,\u_y/mult3_syn_30 }),
    .b({\u_y/mult3_syn_41 ,\u_y/mult3_syn_40 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult3_syn_145 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/mult3_syn_147 ),
    .q(\u_y/mul4_q [30:29]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mul4_q_reg[22]_syn_4"),
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
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[31]_syn_4  (
    .a({open_n6457,\u_y/mult3_syn_31 }),
    .b({open_n6458,\u_y/mult3_syn_42 }),
    .clk(clk_i_dup_1),
    .fci(\u_y/mult3_syn_147 ),
    .sr(rst_i_dup_1951),
    .q({open_n6480,\u_y/mul4_q [31]}));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[4]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_5 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [4]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[5]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_6 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [5]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[6]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_7 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [6]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[7]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_8 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [7]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[8]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_9 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [8]));  // ../src_v/jpeg_idct_y.v(180)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/mul4_q_reg[9]  (
    .clk(clk_i_dup_1),
    .d(\u_y/mult3_syn_10 ),
    .sr(rst_i_dup_1951),
    .q(\u_y/mul4_q [9]));  // ../src_v/jpeg_idct_y.v(180)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("DISABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("0"),
    .SRMODE("SYNC"))
    \u_y/mult0_syn_96  (
    .a({6'b000000,\u_y/mux47_syn_117 ,\u_y/mux47_syn_107 ,1'b1,\u_y/mux47_syn_129 ,\u_y/mux47_syn_117 ,\u_y/mul1_b2[0]_syn_2 ,\u_y/mul0_b2[10]_syn_2 ,\u_y/mux49_syn_107 ,\u_y/mux47_syn_141 ,\u_y/mul0_b2[1]_syn_2 ,\u_y/mul0_b2[1]_syn_2 ,\u_y/mux49_syn_107 }),
    .b(\u_y/mul1_a [17:0]),
    .cea(\u_y/mux46_syn_496 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .p({open_n6567,open_n6568,open_n6569,open_n6570,open_n6571,\u_y/mult0_syn_34 ,\u_y/mult0_syn_33 ,\u_y/mult0_syn_32 ,\u_y/mult0_syn_31 ,\u_y/mult0_syn_30 ,\u_y/mult0_syn_29 ,\u_y/mult0_syn_28 ,\u_y/mult0_syn_27 ,\u_y/mult0_syn_26 ,\u_y/mult0_syn_25 ,\u_y/mult0_syn_24 ,\u_y/mult0_syn_23 ,\u_y/mult0_syn_22 ,\u_y/mult0_syn_21 ,\u_y/mult0_syn_20 ,\u_y/mult0_syn_19 ,\u_y/mult0_syn_18 ,\u_y/mult0_syn_17 ,\u_y/mult0_syn_16 ,\u_y/mult0_syn_15 ,\u_y/mult0_syn_14 ,\u_y/mult0_syn_13 ,\u_y/mult0_syn_12 ,\u_y/mult0_syn_11 ,\u_y/mult0_syn_10 ,\u_y/mult0_syn_9 ,\u_y/mult0_syn_8 ,\u_y/mult0_syn_7 ,\u_y/mult0_syn_6 ,\u_y/mult0_syn_5 ,\u_y/mult0_syn_4 }));  // ../src_v/jpeg_idct_y.v(192)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("DISABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("1"),
    .SRMODE("SYNC"))
    \u_y/mult0_syn_97  (
    .a({6'b000000,\u_y/mux47_syn_117 ,\u_y/mux47_syn_107 ,1'b1,\u_y/mux47_syn_129 ,\u_y/mux47_syn_117 ,\u_y/mul1_b2[0]_syn_2 ,\u_y/mul0_b2[10]_syn_2 ,\u_y/mux49_syn_107 ,\u_y/mux47_syn_141 ,\u_y/mul0_b2[1]_syn_2 ,\u_y/mul0_b2[1]_syn_2 ,\u_y/mux49_syn_107 }),
    .b({\u_y/mul1_a [31],\u_y/mul1_a [31],\u_y/mul1_a [31],\u_y/mul1_a [31],\u_y/mul1_a [31:18]}),
    .cea(\u_y/mux46_syn_496 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .p({open_n6652,open_n6653,open_n6654,open_n6655,open_n6656,open_n6657,open_n6658,open_n6659,open_n6660,open_n6661,open_n6662,open_n6663,open_n6664,open_n6665,open_n6666,open_n6667,open_n6668,open_n6669,open_n6670,open_n6671,open_n6672,open_n6673,\u_y/mult0_syn_49 ,\u_y/mult0_syn_48 ,\u_y/mult0_syn_47 ,\u_y/mult0_syn_46 ,\u_y/mult0_syn_45 ,\u_y/mult0_syn_44 ,\u_y/mult0_syn_43 ,\u_y/mult0_syn_42 ,\u_y/mult0_syn_41 ,\u_y/mult0_syn_40 ,\u_y/mult0_syn_39 ,\u_y/mult0_syn_38 ,\u_y/mult0_syn_37 ,\u_y/mult0_syn_36 }));  // ../src_v/jpeg_idct_y.v(192)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("DISABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("0"),
    .SRMODE("SYNC"))
    \u_y/mult1_syn_93  (
    .a({8'b00000001,\u_y/mux47_syn_117 ,1'b0,\u_y/mux47_syn_117 ,\u_y/mul0_b2[1]_syn_2 ,1'b1,\u_y/mul0_b2[1]_syn_2 ,1'b0,\u_y/mux47_syn_117 ,1'b1,\u_y/mux47_syn_117 }),
    .b(\u_y/mul2_a [17:0]),
    .cea(\u_y/mux56_syn_109 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .p({open_n6754,open_n6755,open_n6756,open_n6757,open_n6758,open_n6759,\u_y/mult1_syn_34 ,\u_y/mult1_syn_33 ,\u_y/mult1_syn_32 ,\u_y/mult1_syn_31 ,\u_y/mult1_syn_30 ,\u_y/mult1_syn_29 ,\u_y/mult1_syn_28 ,\u_y/mult1_syn_27 ,\u_y/mult1_syn_26 ,\u_y/mult1_syn_25 ,\u_y/mult1_syn_24 ,\u_y/mult1_syn_23 ,\u_y/mult1_syn_22 ,\u_y/mult1_syn_21 ,\u_y/mult1_syn_20 ,\u_y/mult1_syn_19 ,\u_y/mult1_syn_18 ,\u_y/mult1_syn_17 ,\u_y/mult1_syn_16 ,\u_y/mult1_syn_15 ,\u_y/mult1_syn_14 ,\u_y/mult1_syn_13 ,\u_y/mult1_syn_12 ,\u_y/mult1_syn_11 ,\u_y/mult1_syn_10 ,\u_y/mult1_syn_9 ,\u_y/mult1_syn_8 ,\u_y/mult1_syn_7 ,\u_y/mult1_syn_6 ,\u_y/mult1_syn_5 }));  // ../src_v/jpeg_idct_y.v(193)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("DISABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("1"),
    .SRMODE("SYNC"))
    \u_y/mult1_syn_94  (
    .a({8'b00000001,\u_y/mux47_syn_117 ,1'b0,\u_y/mux47_syn_117 ,\u_y/mul0_b2[1]_syn_2 ,1'b1,\u_y/mul0_b2[1]_syn_2 ,1'b0,\u_y/mux47_syn_117 ,1'b1,\u_y/mux47_syn_117 }),
    .b({\u_y/mul2_a [30],\u_y/mul2_a [30],\u_y/mul2_a [30],\u_y/mul2_a [30],\u_y/mul2_a [30],\u_y/mul2_a [30:18]}),
    .cea(\u_y/mux56_syn_109 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .p({open_n6840,open_n6841,open_n6842,open_n6843,open_n6844,open_n6845,open_n6846,open_n6847,open_n6848,open_n6849,open_n6850,open_n6851,open_n6852,open_n6853,open_n6854,open_n6855,open_n6856,open_n6857,open_n6858,open_n6859,open_n6860,open_n6861,open_n6862,\u_y/mult1_syn_48 ,\u_y/mult1_syn_47 ,\u_y/mult1_syn_46 ,\u_y/mult1_syn_45 ,\u_y/mult1_syn_44 ,\u_y/mult1_syn_43 ,\u_y/mult1_syn_42 ,\u_y/mult1_syn_41 ,\u_y/mult1_syn_40 ,\u_y/mult1_syn_39 ,\u_y/mult1_syn_38 ,\u_y/mult1_syn_37 ,\u_y/mult1_syn_36 }));  // ../src_v/jpeg_idct_y.v(193)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("DISABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("0"),
    .SRMODE("SYNC"))
    \u_y/mult2_syn_93  (
    .a({8'b00000001,\u_y/mul0_b2[1]_syn_2 ,1'b0,\u_y/mul0_b2[1]_syn_2 ,\u_y/mux47_syn_117 ,1'b1,\u_y/mux47_syn_117 ,1'b0,\u_y/mul0_b2[1]_syn_2 ,1'b1,\u_y/mul0_b2[1]_syn_2 }),
    .b(\u_y/mul3_a [17:0]),
    .cea(\u_y/mux56_syn_109 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .p({open_n6943,open_n6944,open_n6945,open_n6946,open_n6947,open_n6948,\u_y/mult2_syn_34 ,\u_y/mult2_syn_33 ,\u_y/mult2_syn_32 ,\u_y/mult2_syn_31 ,\u_y/mult2_syn_30 ,\u_y/mult2_syn_29 ,\u_y/mult2_syn_28 ,\u_y/mult2_syn_27 ,\u_y/mult2_syn_26 ,\u_y/mult2_syn_25 ,\u_y/mult2_syn_24 ,\u_y/mult2_syn_23 ,\u_y/mult2_syn_22 ,\u_y/mult2_syn_21 ,\u_y/mult2_syn_20 ,\u_y/mult2_syn_19 ,\u_y/mult2_syn_18 ,\u_y/mult2_syn_17 ,\u_y/mult2_syn_16 ,\u_y/mult2_syn_15 ,\u_y/mult2_syn_14 ,\u_y/mult2_syn_13 ,\u_y/mult2_syn_12 ,\u_y/mult2_syn_11 ,\u_y/mult2_syn_10 ,\u_y/mult2_syn_9 ,\u_y/mult2_syn_8 ,\u_y/mult2_syn_7 ,\u_y/mult2_syn_6 ,\u_y/mult2_syn_5 }));  // ../src_v/jpeg_idct_y.v(194)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("DISABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("1"),
    .SRMODE("SYNC"))
    \u_y/mult2_syn_94  (
    .a({8'b00000001,\u_y/mul0_b2[1]_syn_2 ,1'b0,\u_y/mul0_b2[1]_syn_2 ,\u_y/mux47_syn_117 ,1'b1,\u_y/mux47_syn_117 ,1'b0,\u_y/mul0_b2[1]_syn_2 ,1'b1,\u_y/mul0_b2[1]_syn_2 }),
    .b({\u_y/mul3_a [30],\u_y/mul3_a [30],\u_y/mul3_a [30],\u_y/mul3_a [30],\u_y/mul3_a [30],\u_y/mul3_a [30:18]}),
    .cea(\u_y/mux56_syn_109 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .p({open_n7029,open_n7030,open_n7031,open_n7032,open_n7033,open_n7034,open_n7035,open_n7036,open_n7037,open_n7038,open_n7039,open_n7040,open_n7041,open_n7042,open_n7043,open_n7044,open_n7045,open_n7046,open_n7047,open_n7048,open_n7049,open_n7050,open_n7051,\u_y/mult2_syn_48 ,\u_y/mult2_syn_47 ,\u_y/mult2_syn_46 ,\u_y/mult2_syn_45 ,\u_y/mult2_syn_44 ,\u_y/mult2_syn_43 ,\u_y/mult2_syn_42 ,\u_y/mult2_syn_41 ,\u_y/mult2_syn_40 ,\u_y/mult2_syn_39 ,\u_y/mult2_syn_38 ,\u_y/mult2_syn_37 ,\u_y/mult2_syn_36 }));  // ../src_v/jpeg_idct_y.v(194)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CEBMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("ENABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .RSTBNMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("0"),
    .SRMODE("SYNC"))
    \u_y/mult3_syn_81  (
    .a(18'b000000000010110101),
    .b(\u_y/i0 [17:0]),
    .cea(\u_y/mux53_syn_1 ),
    .ceb(\u_y/mux53_syn_1 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .rstbn(rst_i_dup_1951),
    .p({open_n7130,open_n7131,open_n7132,open_n7133,open_n7134,open_n7135,open_n7136,open_n7137,open_n7138,\u_y/mult3_syn_31 ,\u_y/mult3_syn_30 ,\u_y/mult3_syn_29 ,\u_y/mult3_syn_28 ,\u_y/mult3_syn_27 ,\u_y/mult3_syn_26 ,\u_y/mult3_syn_25 ,\u_y/mult3_syn_24 ,\u_y/mult3_syn_23 ,\u_y/mult3_syn_22 ,\u_y/mult3_syn_21 ,\u_y/mult3_syn_20 ,\u_y/mult3_syn_19 ,\u_y/mult3_syn_18 ,\u_y/mult3_syn_17 ,\u_y/mult3_syn_16 ,\u_y/mult3_syn_15 ,\u_y/mult3_syn_14 ,\u_y/mult3_syn_13 ,\u_y/mult3_syn_12 ,\u_y/mult3_syn_11 ,\u_y/mult3_syn_10 ,\u_y/mult3_syn_9 ,\u_y/mult3_syn_8 ,\u_y/mult3_syn_7 ,\u_y/mult3_syn_6 ,\u_y/mult3_syn_5 }));  // ../src_v/jpeg_idct_y.v(195)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CEBMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("ENABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .RSTBNMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("1"),
    .SRMODE("SYNC"))
    \u_y/mult3_syn_82  (
    .a(18'b000000000010110101),
    .b({\u_y/i0 [27],\u_y/i0 [27],\u_y/i0 [27],\u_y/i0 [27],\u_y/i0 [27],\u_y/i0 [27],\u_y/i0 [27],\u_y/i0 [27],\u_y/i0 [27:18]}),
    .cea(\u_y/mux53_syn_1 ),
    .ceb(\u_y/mux53_syn_1 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .rstbn(rst_i_dup_1951),
    .p({open_n7217,open_n7218,open_n7219,open_n7220,open_n7221,open_n7222,open_n7223,open_n7224,open_n7225,open_n7226,open_n7227,open_n7228,open_n7229,open_n7230,open_n7231,open_n7232,open_n7233,open_n7234,open_n7235,open_n7236,open_n7237,open_n7238,open_n7239,open_n7240,open_n7241,open_n7242,\u_y/mult3_syn_42 ,\u_y/mult3_syn_41 ,\u_y/mult3_syn_40 ,\u_y/mult3_syn_39 ,\u_y/mult3_syn_38 ,\u_y/mult3_syn_37 ,\u_y/mult3_syn_36 ,\u_y/mult3_syn_35 ,\u_y/mult3_syn_34 ,\u_y/mult3_syn_33 }));  // ../src_v/jpeg_idct_y.v(195)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult4_syn_204"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult4_syn_204  (
    .a({\u_y/mult4_syn_21 ,1'b0}),
    .b({\u_y/mult4_syn_31 ,open_n7243}),
    .f({\u_y/mult4_syn_90 [0],open_n7263}),
    .fco(\u_y/mult4_syn_173 ));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult4_syn_204"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult4_syn_207  (
    .a({\u_y/mult4_syn_23 ,\u_y/mult4_syn_22 }),
    .b({\u_y/mult4_syn_33 ,\u_y/mult4_syn_32 }),
    .fci(\u_y/mult4_syn_173 ),
    .f(\u_y/mult4_syn_90 [2:1]),
    .fco(\u_y/mult4_syn_175 ));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult4_syn_204"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult4_syn_210  (
    .a({\u_y/mult4_syn_25 ,\u_y/mult4_syn_24 }),
    .b({\u_y/mult4_syn_35 ,\u_y/mult4_syn_34 }),
    .fci(\u_y/mult4_syn_175 ),
    .f(\u_y/mult4_syn_90 [4:3]),
    .fco(\u_y/mult4_syn_177 ));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult4_syn_204"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult4_syn_213  (
    .a({\u_y/mult4_syn_27 ,\u_y/mult4_syn_26 }),
    .b({\u_y/mult4_syn_37 ,\u_y/mult4_syn_36 }),
    .fci(\u_y/mult4_syn_177 ),
    .f(\u_y/mult4_syn_90 [6:5]),
    .fco(\u_y/mult4_syn_179 ));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult4_syn_204"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult4_syn_216  (
    .a({\u_y/mult4_syn_29 ,\u_y/mult4_syn_28 }),
    .b({\u_y/mult4_syn_39 ,\u_y/mult4_syn_38 }),
    .fci(\u_y/mult4_syn_179 ),
    .f(\u_y/mult4_syn_90 [8:7]),
    .fco(\u_y/mult4_syn_181 ));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult4_syn_204"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult4_syn_219  (
    .a({\u_y/mult4_syn_29 ,\u_y/mult4_syn_29 }),
    .b({\u_y/mult4_syn_41 ,\u_y/mult4_syn_40 }),
    .fci(\u_y/mult4_syn_181 ),
    .f(\u_y/mult4_syn_90 [10:9]),
    .fco(\u_y/mult4_syn_183 ));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult4_syn_204"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult4_syn_222  (
    .a({\u_y/mult4_syn_29 ,\u_y/mult4_syn_29 }),
    .b({\u_y/mult4_syn_43 ,\u_y/mult4_syn_42 }),
    .fci(\u_y/mult4_syn_183 ),
    .f(\u_y/mult4_syn_90 [12:11]),
    .fco(\u_y/mult4_syn_185 ));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult4_syn_204"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult4_syn_224  (
    .a({open_n7400,\u_y/mult4_syn_29 }),
    .b({open_n7401,\u_y/mult4_syn_44 }),
    .fci(\u_y/mult4_syn_185 ),
    .f({open_n7420,\u_y/mult4_syn_90 [13]}));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MULT18 #(
    .CEBMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("DISABLE"),
    .INPUTREGB("ENABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTBNMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("0"),
    .SRMODE("SYNC"))
    \u_y/mult4_syn_87  (
    .a(18'b000000000010110101),
    .b({\u_y/o_t6_5_b2 [17:1],\u_y/o_t5_6_b2 [0]}),
    .ceb(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .rstbn(rst_i_dup_1951),
    .p({open_n7506,open_n7507,open_n7508,open_n7509,open_n7510,open_n7511,open_n7512,open_n7513,open_n7514,\u_y/mult4_syn_29 ,\u_y/mult4_syn_28 ,\u_y/mult4_syn_27 ,\u_y/mult4_syn_26 ,\u_y/mult4_syn_25 ,\u_y/mult4_syn_24 ,\u_y/mult4_syn_23 ,\u_y/mult4_syn_22 ,\u_y/mult4_syn_21 ,\u_y/mult4_syn_20 ,\u_y/mult4_syn_19 ,\u_y/mult4_syn_18 ,\u_y/mult4_syn_17 ,\u_y/mult4_syn_16 ,\u_y/mult4_syn_15 ,\u_y/mult4_syn_14 ,\u_y/mult4_syn_13 ,\u_y/mult4_syn_12 ,\u_y/mult4_syn_11 ,\u_y/mult4_syn_10 ,\u_y/mult4_syn_9 ,\u_y/mult4_syn_8 ,\u_y/mult4_syn_7 ,\u_y/mult4_syn_6 ,\u_y/mult4_syn_5 ,\u_y/mult4_syn_4 ,\u_y/mult4_syn_3 }));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MULT18 #(
    .CEBMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("DISABLE"),
    .INPUTREGB("ENABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTBNMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("1"),
    .SRMODE("SYNC"))
    \u_y/mult4_syn_88  (
    .a(18'b000000000010110101),
    .b({\u_y/o_t6_5_b2 [31],\u_y/o_t6_5_b2 [31],\u_y/o_t6_5_b2 [31],\u_y/o_t6_5_b2 [31],\u_y/o_t6_5_b2 [31:18]}),
    .ceb(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .rstbn(rst_i_dup_1951),
    .p({open_n7595,open_n7596,open_n7597,open_n7598,open_n7599,open_n7600,open_n7601,open_n7602,open_n7603,open_n7604,open_n7605,open_n7606,open_n7607,open_n7608,open_n7609,open_n7610,open_n7611,open_n7612,open_n7613,open_n7614,open_n7615,open_n7616,\u_y/mult4_syn_44 ,\u_y/mult4_syn_43 ,\u_y/mult4_syn_42 ,\u_y/mult4_syn_41 ,\u_y/mult4_syn_40 ,\u_y/mult4_syn_39 ,\u_y/mult4_syn_38 ,\u_y/mult4_syn_37 ,\u_y/mult4_syn_36 ,\u_y/mult4_syn_35 ,\u_y/mult4_syn_34 ,\u_y/mult4_syn_33 ,\u_y/mult4_syn_32 ,\u_y/mult4_syn_31 }));  // ../src_v/jpeg_idct_y.v(241)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult5_syn_204"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult5_syn_204  (
    .a({\u_y/mult5_syn_21 ,1'b0}),
    .b({\u_y/mult5_syn_31 ,open_n7617}),
    .f({\u_y/mult5_syn_90 [0],open_n7637}),
    .fco(\u_y/mult5_syn_173 ));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult5_syn_204"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult5_syn_207  (
    .a({\u_y/mult5_syn_23 ,\u_y/mult5_syn_22 }),
    .b({\u_y/mult5_syn_33 ,\u_y/mult5_syn_32 }),
    .fci(\u_y/mult5_syn_173 ),
    .f(\u_y/mult5_syn_90 [2:1]),
    .fco(\u_y/mult5_syn_175 ));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult5_syn_204"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult5_syn_210  (
    .a({\u_y/mult5_syn_25 ,\u_y/mult5_syn_24 }),
    .b({\u_y/mult5_syn_35 ,\u_y/mult5_syn_34 }),
    .fci(\u_y/mult5_syn_175 ),
    .f(\u_y/mult5_syn_90 [4:3]),
    .fco(\u_y/mult5_syn_177 ));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult5_syn_204"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult5_syn_213  (
    .a({\u_y/mult5_syn_27 ,\u_y/mult5_syn_26 }),
    .b({\u_y/mult5_syn_37 ,\u_y/mult5_syn_36 }),
    .fci(\u_y/mult5_syn_177 ),
    .f(\u_y/mult5_syn_90 [6:5]),
    .fco(\u_y/mult5_syn_179 ));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult5_syn_204"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult5_syn_216  (
    .a({\u_y/mult5_syn_29 ,\u_y/mult5_syn_28 }),
    .b({\u_y/mult5_syn_39 ,\u_y/mult5_syn_38 }),
    .fci(\u_y/mult5_syn_179 ),
    .f(\u_y/mult5_syn_90 [8:7]),
    .fco(\u_y/mult5_syn_181 ));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult5_syn_204"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult5_syn_219  (
    .a({\u_y/mult5_syn_29 ,\u_y/mult5_syn_29 }),
    .b({\u_y/mult5_syn_41 ,\u_y/mult5_syn_40 }),
    .fci(\u_y/mult5_syn_181 ),
    .f(\u_y/mult5_syn_90 [10:9]),
    .fco(\u_y/mult5_syn_183 ));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult5_syn_204"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult5_syn_222  (
    .a({\u_y/mult5_syn_29 ,\u_y/mult5_syn_29 }),
    .b({\u_y/mult5_syn_43 ,\u_y/mult5_syn_42 }),
    .fci(\u_y/mult5_syn_183 ),
    .f(\u_y/mult5_syn_90 [12:11]),
    .fco(\u_y/mult5_syn_185 ));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/mult5_syn_204"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("ADD"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"))
    \u_y/mult5_syn_224  (
    .a({open_n7774,\u_y/mult5_syn_29 }),
    .b({open_n7775,\u_y/mult5_syn_44 }),
    .fci(\u_y/mult5_syn_185 ),
    .f({open_n7794,\u_y/mult5_syn_90 [13]}));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MULT18 #(
    .CEBMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("DISABLE"),
    .INPUTREGB("ENABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTBNMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("0"),
    .SRMODE("SYNC"))
    \u_y/mult5_syn_87  (
    .a(18'b000000000010110101),
    .b(\u_y/o_t5_6_b2 [17:0]),
    .ceb(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .rstbn(rst_i_dup_1951),
    .p({open_n7880,open_n7881,open_n7882,open_n7883,open_n7884,open_n7885,open_n7886,open_n7887,open_n7888,\u_y/mult5_syn_29 ,\u_y/mult5_syn_28 ,\u_y/mult5_syn_27 ,\u_y/mult5_syn_26 ,\u_y/mult5_syn_25 ,\u_y/mult5_syn_24 ,\u_y/mult5_syn_23 ,\u_y/mult5_syn_22 ,\u_y/mult5_syn_21 ,\u_y/mult5_syn_20 ,\u_y/mult5_syn_19 ,\u_y/mult5_syn_18 ,\u_y/mult5_syn_17 ,\u_y/mult5_syn_16 ,\u_y/mult5_syn_15 ,\u_y/mult5_syn_14 ,\u_y/mult5_syn_13 ,\u_y/mult5_syn_12 ,\u_y/mult5_syn_11 ,\u_y/mult5_syn_10 ,\u_y/mult5_syn_9 ,\u_y/mult5_syn_8 ,\u_y/mult5_syn_7 ,\u_y/mult5_syn_6 ,\u_y/mult5_syn_5 ,\u_y/mult5_syn_4 ,\u_y/mult5_syn_3 }));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MULT18 #(
    .CEBMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("DISABLE"),
    .INPUTREGB("ENABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTBNMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("1"),
    .SRMODE("SYNC"))
    \u_y/mult5_syn_88  (
    .a(18'b000000000010110101),
    .b({\u_y/o_t5_6_b2 [31],\u_y/o_t5_6_b2 [31],\u_y/o_t5_6_b2 [31],\u_y/o_t5_6_b2 [31],\u_y/o_t5_6_b2 [31:18]}),
    .ceb(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .rstbn(rst_i_dup_1951),
    .p({open_n7969,open_n7970,open_n7971,open_n7972,open_n7973,open_n7974,open_n7975,open_n7976,open_n7977,open_n7978,open_n7979,open_n7980,open_n7981,open_n7982,open_n7983,open_n7984,open_n7985,open_n7986,open_n7987,open_n7988,open_n7989,open_n7990,\u_y/mult5_syn_44 ,\u_y/mult5_syn_43 ,\u_y/mult5_syn_42 ,\u_y/mult5_syn_41 ,\u_y/mult5_syn_40 ,\u_y/mult5_syn_39 ,\u_y/mult5_syn_38 ,\u_y/mult5_syn_37 ,\u_y/mult5_syn_36 ,\u_y/mult5_syn_35 ,\u_y/mult5_syn_34 ,\u_y/mult5_syn_33 ,\u_y/mult5_syn_32 ,\u_y/mult5_syn_31 }));  // ../src_v/jpeg_idct_y.v(242)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CEBMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("ENABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .RSTBNMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("0"),
    .SRMODE("SYNC"))
    \u_y/mult6_syn_96  (
    .a({6'b000000,\u_y/mul0_b2[1]_syn_2 ,\u_y/mux47_syn_141 ,1'b1,\u_y/mux47_syn_129 ,\u_y/mul0_b2[1]_syn_2 ,\u_y/mux47_syn_99 ,\u_y/mux47_syn_102 ,\u_y/mux47_syn_105 ,\u_y/mux47_syn_107 ,\u_y/mux47_syn_117 ,\u_y/mux47_syn_117 ,\u_y/mux47_syn_105 }),
    .b(\u_y/mul0_a_b1 [17:0]),
    .cea(\u_y/mux46_syn_496 ),
    .ceb(\u_y/mux46_syn_496 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .rstbn(rst_i_dup_1951),
    .p({open_n8069,open_n8070,open_n8071,open_n8072,open_n8073,\u_y/mult6_syn_34 ,\u_y/mult6_syn_33 ,\u_y/mult6_syn_32 ,\u_y/mult6_syn_31 ,\u_y/mult6_syn_30 ,\u_y/mult6_syn_29 ,\u_y/mult6_syn_28 ,\u_y/mult6_syn_27 ,\u_y/mult6_syn_26 ,\u_y/mult6_syn_25 ,\u_y/mult6_syn_24 ,\u_y/mult6_syn_23 ,\u_y/mult6_syn_22 ,\u_y/mult6_syn_21 ,\u_y/mult6_syn_20 ,\u_y/mult6_syn_19 ,\u_y/mult6_syn_18 ,\u_y/mult6_syn_17 ,\u_y/mult6_syn_16 ,\u_y/mult6_syn_15 ,\u_y/mult6_syn_14 ,\u_y/mult6_syn_13 ,\u_y/mult6_syn_12 ,\u_y/mult6_syn_11 ,\u_y/mult6_syn_10 ,\u_y/mult6_syn_9 ,\u_y/mult6_syn_8 ,\u_y/mult6_syn_7 ,\u_y/mult6_syn_6 ,\u_y/mult6_syn_5 ,\u_y/mult6_syn_4 }));  // ../src_v/jpeg_idct_y.v(191)
  EG_PHY_MULT18 #(
    .CEAMUX("SIG"),
    .CEBMUX("SIG"),
    .CLKMUX("SIG"),
    .INPUTREGA("ENABLE"),
    .INPUTREGB("ENABLE"),
    .MODE("MULT18X18C"),
    .OUTPUTREG("DISABLE"),
    .RSTANMUX("INV"),
    .RSTBNMUX("INV"),
    .SIGNEDAMUX("1"),
    .SIGNEDBMUX("1"),
    .SRMODE("SYNC"))
    \u_y/mult6_syn_97  (
    .a({6'b000000,\u_y/mul0_b2[1]_syn_2 ,\u_y/mux47_syn_141 ,1'b1,\u_y/mux47_syn_129 ,\u_y/mul0_b2[1]_syn_2 ,\u_y/mux47_syn_99 ,\u_y/mux47_syn_102 ,\u_y/mux47_syn_105 ,\u_y/mux47_syn_107 ,\u_y/mux47_syn_117 ,\u_y/mux47_syn_117 ,\u_y/mux47_syn_105 }),
    .b({\u_y/mul0_a_b1 [31],\u_y/mul0_a_b1 [31],\u_y/mul0_a_b1 [31],\u_y/mul0_a_b1 [31],\u_y/mul0_a_b1 [31:18]}),
    .cea(\u_y/mux46_syn_496 ),
    .ceb(\u_y/mux46_syn_496 ),
    .clk(clk_i_dup_1),
    .rstan(rst_i_dup_1951),
    .rstbn(rst_i_dup_1951),
    .p({open_n8152,open_n8153,open_n8154,open_n8155,open_n8156,open_n8157,open_n8158,open_n8159,open_n8160,open_n8161,open_n8162,open_n8163,open_n8164,open_n8165,open_n8166,open_n8167,open_n8168,open_n8169,open_n8170,open_n8171,open_n8172,open_n8173,\u_y/mult6_syn_49 ,\u_y/mult6_syn_48 ,\u_y/mult6_syn_47 ,\u_y/mult6_syn_46 ,\u_y/mult6_syn_45 ,\u_y/mult6_syn_44 ,\u_y/mult6_syn_43 ,\u_y/mult6_syn_42 ,\u_y/mult6_syn_41 ,\u_y/mult6_syn_40 ,\u_y/mult6_syn_39 ,\u_y/mult6_syn_38 ,\u_y/mult6_syn_37 ,\u_y/mult6_syn_36 }));  // ../src_v/jpeg_idct_y.v(191)
  AL_MAP_LUT3 #(
    .EQN("(C*B*~A)"),
    .INIT(8'h40))
    \u_y/mux10_syn_71  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/out_stg1_idx_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux10_syn_1 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1020  (
    .a(\u_y/mul1_q [0]),
    .b(\u_y/o_t3 [0]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_487 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1021  (
    .a(\u_y/mul1_q [1]),
    .b(\u_y/o_t3 [1]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_499 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1022  (
    .a(\u_y/mul1_q [2]),
    .b(\u_y/o_t3 [2]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_511 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1023  (
    .a(\u_y/mul1_q [3]),
    .b(\u_y/o_t3 [3]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_523 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1024  (
    .a(\u_y/mul1_q [4]),
    .b(\u_y/o_t3 [4]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_535 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1025  (
    .a(\u_y/mul1_q [5]),
    .b(\u_y/o_t3 [5]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_547 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1026  (
    .a(\u_y/mul1_q [6]),
    .b(\u_y/o_t3 [6]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_559 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1027  (
    .a(\u_y/mul1_q [7]),
    .b(\u_y/o_t3 [7]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_571 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1028  (
    .a(\u_y/mul1_q [8]),
    .b(\u_y/o_t3 [8]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_583 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1029  (
    .a(\u_y/mul1_q [9]),
    .b(\u_y/o_t3 [9]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_595 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1030  (
    .a(\u_y/mul1_q [10]),
    .b(\u_y/o_t3 [10]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_607 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1031  (
    .a(\u_y/mul1_q [11]),
    .b(\u_y/o_t3 [11]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_619 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1032  (
    .a(\u_y/mul1_q [12]),
    .b(\u_y/o_t3 [12]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_631 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1033  (
    .a(\u_y/mul1_q [13]),
    .b(\u_y/o_t3 [13]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_643 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1034  (
    .a(\u_y/mul1_q [14]),
    .b(\u_y/o_t3 [14]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_655 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1035  (
    .a(\u_y/mul1_q [15]),
    .b(\u_y/o_t3 [15]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_667 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1036  (
    .a(\u_y/mul1_q [16]),
    .b(\u_y/o_t3 [16]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_679 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1037  (
    .a(\u_y/mul1_q [17]),
    .b(\u_y/o_t3 [17]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_691 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1038  (
    .a(\u_y/mul1_q [18]),
    .b(\u_y/o_t3 [18]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_703 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1039  (
    .a(\u_y/mul1_q [19]),
    .b(\u_y/o_t3 [19]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_715 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1040  (
    .a(\u_y/mul1_q [20]),
    .b(\u_y/o_t3 [20]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_727 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1041  (
    .a(\u_y/mul1_q [21]),
    .b(\u_y/o_t3 [21]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_739 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1042  (
    .a(\u_y/mul1_q [22]),
    .b(\u_y/o_t3 [22]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_751 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1043  (
    .a(\u_y/mul1_q [23]),
    .b(\u_y/o_t3 [23]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_763 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1044  (
    .a(\u_y/mul1_q [24]),
    .b(\u_y/o_t3 [24]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_775 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1045  (
    .a(\u_y/mul1_q [25]),
    .b(\u_y/o_t3 [25]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_787 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1046  (
    .a(\u_y/mul1_q [26]),
    .b(\u_y/o_t3 [26]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_799 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1047  (
    .a(\u_y/mul1_q [27]),
    .b(\u_y/o_t3 [27]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_811 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1048  (
    .a(\u_y/mul1_q [28]),
    .b(\u_y/o_t3 [28]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_823 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1049  (
    .a(\u_y/mul1_q [29]),
    .b(\u_y/o_t3 [29]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_835 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1050  (
    .a(\u_y/mul1_q [30]),
    .b(\u_y/o_t3 [30]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_847 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h553a))
    \u_y/mux13_syn_1051  (
    .a(\u_y/mul1_q [31]),
    .b(\u_y/o_t3 [31]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_859 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT3 #(
    .EQN("(~(A)*~(B)*~(C)+~(A)*B*~(C)+A*~(B)*C)"),
    .INIT(8'h25))
    \u_y/mux13_syn_1052  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/out_stg1_idx_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_475 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT3 #(
    .EQN("(A*(C@B))"),
    .INIT(8'h28))
    \u_y/mux14_syn_589  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/out_stg1_idx_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux14_syn_428 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \u_y/mux15_syn_71  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/out_stg1_idx_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux15_syn_1 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_y/mux15_syn_72  (
    .a(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux15_syn_4 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+~(A)*B*~(C)+~(A)*~(B)*C)"),
    .INIT(8'h16))
    \u_y/mux17_syn_880  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/out_stg1_idx_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux17_syn_559 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT3 #(
    .EQN("(~C*B*~A)"),
    .INIT(8'h04))
    \u_y/mux18_syn_73  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/out_stg1_idx_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux18_syn_1 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u_y/mux19_syn_73  (
    .a(\u_y/out_stg1_idx_q [1]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux13_syn_463 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux19_syn_74  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/mux13_syn_463 ),
    .o(\u_y/mux19_syn_1 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*B*A)"),
    .INIT(16'h0080))
    \u_y/mux35_syn_529  (
    .a(\u_y/out_stg3_valid_q ),
    .b(\u_y/out_stg3_idx_q [0]),
    .c(\u_y/out_stg3_idx_q [1]),
    .d(\u_y/out_stg3_idx_q [2]),
    .o(\u_y/mux35_syn_2 [254]));  // ../src_v/jpeg_idct_y.v(342)
  AL_MAP_LUT4 #(
    .EQN("(D*C*~B*A)"),
    .INIT(16'h2000))
    \u_y/mux35_syn_530  (
    .a(\u_y/out_stg3_valid_q ),
    .b(\u_y/out_stg3_idx_q [0]),
    .c(\u_y/out_stg3_idx_q [1]),
    .d(\u_y/out_stg3_idx_q [2]),
    .o(\u_y/mux35_syn_2 [31]));  // ../src_v/jpeg_idct_y.v(342)
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_y/mux35_syn_531  (
    .a(\u_y/out_stg3_valid_q ),
    .b(\u_y/out_stg3_idx_q [0]),
    .c(\u_y/out_stg3_idx_q [1]),
    .d(\u_y/out_stg3_idx_q [2]),
    .o(\u_y/mux35_syn_2 [223]));  // ../src_v/jpeg_idct_y.v(342)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u_y/mux43_syn_28  (
    .a(img_start_i_dup_15),
    .b(rst_i_dup_1951),
    .o(\u_y/mux43_syn_2 [5]));  // ../src_v/jpeg_idct_y.v(377)
  AL_MAP_LUT3 #(
    .EQN("~(B*~(C*~A))"),
    .INIT(8'h73))
    \u_y/mux46_syn_657  (
    .a(\inport_idx_i[2]_dup_37 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .c(\inport_idx_i[0]_dup_15 ),
    .o(\u_y/mux46_syn_496 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_y/mux47_syn_142  (
    .a(\inport_idx_i[2]_dup_37 ),
    .b(\u_y/mux53_syn_1 ),
    .o(\u_y/mux47_syn_102 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux47_syn_143  (
    .a(\inport_idx_i[2]_dup_37 ),
    .b(\inport_idx_i[0]_dup_15 ),
    .o(\u_y/mux59_syn_654 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_y/mux47_syn_144  (
    .a(\inport_idx_i[1]_dup_17 ),
    .b(\u_y/mux59_syn_654 ),
    .o(\u_y/mux47_syn_99 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_y/mux47_syn_145  (
    .a(\u_y/mul0_b2[1]_syn_2 ),
    .o(\u_y/mux47_syn_117 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_y/mux47_syn_146  (
    .a(\u_y/mul0_b2[10]_syn_2 ),
    .o(\u_y/mux47_syn_141 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_y/mux47_syn_147  (
    .a(\u_y/mux47_syn_102 ),
    .o(\u_y/mux47_syn_107 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_y/mux47_syn_148  (
    .a(\u_y/mux47_syn_99 ),
    .o(\u_y/mux47_syn_105 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_y/mux49_syn_108  (
    .a(\u_y/mul1_b2[0]_syn_2 ),
    .o(\u_y/mux49_syn_107 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_y/mux53_syn_79  (
    .a(\inport_idx_i[1]_dup_17 ),
    .b(\inport_idx_i[0]_dup_15 ),
    .o(\u_y/mux53_syn_1 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+~(A)*~(B)*C+~(A)*B*C)"),
    .INIT(8'h52))
    \u_y/mux56_syn_110  (
    .a(\inport_idx_i[2]_dup_37 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .c(\inport_idx_i[0]_dup_15 ),
    .o(\u_y/mux56_syn_109 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_655  (
    .a(\inport_data2_i[27]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_560 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_656  (
    .a(\inport_data2_i[26]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_548 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_657  (
    .a(\inport_data2_i[25]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_536 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_658  (
    .a(\inport_data2_i[24]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_524 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_659  (
    .a(\inport_data2_i[23]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_512 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_660  (
    .a(\inport_data2_i[22]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_500 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_661  (
    .a(\inport_data2_i[21]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_488 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_662  (
    .a(\inport_data2_i[20]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_476 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_663  (
    .a(\inport_data2_i[19]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_464 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_664  (
    .a(\inport_data2_i[18]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_452 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_665  (
    .a(\inport_data2_i[17]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_440 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_666  (
    .a(\inport_data2_i[16]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_428 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_667  (
    .a(\inport_data2_i[15]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_416 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_668  (
    .a(\inport_data2_i[14]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_404 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_669  (
    .a(\inport_data2_i[13]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_392 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_670  (
    .a(\inport_data2_i[12]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_380 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_671  (
    .a(\inport_data2_i[11]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_368 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_672  (
    .a(\inport_data2_i[10]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_356 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_673  (
    .a(\inport_data2_i[9]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_344 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_674  (
    .a(\inport_data2_i[8]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_332 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_675  (
    .a(\inport_data2_i[7]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_320 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_676  (
    .a(\inport_data2_i[6]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_308 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_677  (
    .a(\inport_data2_i[5]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_296 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_678  (
    .a(\inport_data2_i[4]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_284 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_679  (
    .a(\inport_data2_i[3]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_272 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_680  (
    .a(\inport_data2_i[2]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_260 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_681  (
    .a(\inport_data2_i[1]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_248 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/mux59_syn_682  (
    .a(\inport_data2_i[0]_dup_15 ),
    .b(\inport_idx_i[1]_dup_17 ),
    .o(\u_y/mux59_syn_236 ));  // ../src_v/jpeg_idct_y.v(111)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_844  (
    .a(\u_y/mul3_q [1]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_295 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_845  (
    .a(\u_y/mul3_q [2]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_305 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_846  (
    .a(\u_y/mul3_q [3]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_315 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_847  (
    .a(\u_y/mul3_q [4]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_325 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_848  (
    .a(\u_y/mul3_q [5]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_335 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_849  (
    .a(\u_y/mul3_q [6]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_345 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_850  (
    .a(\u_y/mul3_q [7]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_355 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_851  (
    .a(\u_y/mul3_q [8]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_365 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_852  (
    .a(\u_y/mul3_q [9]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_375 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_853  (
    .a(\u_y/mul3_q [10]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_385 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_854  (
    .a(\u_y/mul3_q [11]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_395 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_855  (
    .a(\u_y/mul3_q [12]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_405 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_856  (
    .a(\u_y/mul3_q [13]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_415 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_857  (
    .a(\u_y/mul3_q [14]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_425 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_858  (
    .a(\u_y/mul3_q [15]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_435 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_859  (
    .a(\u_y/mul3_q [16]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_445 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_860  (
    .a(\u_y/mul3_q [17]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_455 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_861  (
    .a(\u_y/mul3_q [18]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_465 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_862  (
    .a(\u_y/mul3_q [19]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_475 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_863  (
    .a(\u_y/mul3_q [20]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_485 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_864  (
    .a(\u_y/mul3_q [21]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_495 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_865  (
    .a(\u_y/mul3_q [22]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_505 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_866  (
    .a(\u_y/mul3_q [23]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_515 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_867  (
    .a(\u_y/mul3_q [24]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_525 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_868  (
    .a(\u_y/mul3_q [25]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_535 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_869  (
    .a(\u_y/mul3_q [26]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_545 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_870  (
    .a(\u_y/mul3_q [27]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_555 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_871  (
    .a(\u_y/mul3_q [28]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_565 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_872  (
    .a(\u_y/mul3_q [29]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_575 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_873  (
    .a(\u_y/mul3_q [30]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_585 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_y/mux7_syn_874  (
    .a(\u_y/mul3_q [31]),
    .b(\u_y/out_stg1_idx_q [1]),
    .o(\u_y/mux7_syn_595 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT3 #(
    .EQN("(C*~(B@A))"),
    .INIT(8'h90))
    \u_y/mux7_syn_875  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/out_stg1_idx_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux7_syn_683 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*~D*~C*~B*~A)"),
    .INIT(64'h0000000000000001))
    \u_y/mux7_syn_876  (
    .a(\u_y/mult4_syn_10 ),
    .b(\u_y/mult4_syn_9 ),
    .c(\u_y/mult4_syn_8 ),
    .d(\u_y/mult4_syn_7 ),
    .e(\u_y/mult4_syn_6 ),
    .f(\u_y/mult4_syn_5 ),
    .o(\u_y/mux7_syn_877 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT5 #(
    .EQN("~(D*~(C*~(E*~B*~A)))"),
    .INIT(32'he0fff0ff))
    \u_y/mux7_syn_878  (
    .a(\u_y/mult4_syn_4 ),
    .b(\u_y/mult4_syn_3 ),
    .c(\u_y/mult4_syn_90 [13]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/mux7_syn_877 ),
    .o(\u_y/mux7_syn_605 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_766  (
    .a(\u_y/mul3_q [26]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_491 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_767  (
    .a(\u_y/mul3_q [29]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_509 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_768  (
    .a(\u_y/mul3_q [25]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_485 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_769  (
    .a(\u_y/mul3_q [24]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_479 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_770  (
    .a(\u_y/mul3_q [27]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_497 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_771  (
    .a(\u_y/mul3_q [28]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_503 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_772  (
    .a(\u_y/mul3_q [30]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_515 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_773  (
    .a(\u_y/mul3_q [31]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_521 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_774  (
    .a(\u_y/mul3_q [14]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_419 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_775  (
    .a(\u_y/mul3_q [15]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_425 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_776  (
    .a(\u_y/mul3_q [16]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_431 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_777  (
    .a(\u_y/mul3_q [17]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_437 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_778  (
    .a(\u_y/mul3_q [18]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_443 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_779  (
    .a(\u_y/mul3_q [19]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_449 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_780  (
    .a(\u_y/mul3_q [20]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_455 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_781  (
    .a(\u_y/mul3_q [21]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_461 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_782  (
    .a(\u_y/mul3_q [22]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_467 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_783  (
    .a(\u_y/mul3_q [23]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_473 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_784  (
    .a(\u_y/mul3_q [1]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_341 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_785  (
    .a(\u_y/mul3_q [2]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_347 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_786  (
    .a(\u_y/mul3_q [3]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_353 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_787  (
    .a(\u_y/mul3_q [4]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_359 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_788  (
    .a(\u_y/mul3_q [5]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_365 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_789  (
    .a(\u_y/mul3_q [6]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_371 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_790  (
    .a(\u_y/mul3_q [7]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_377 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_791  (
    .a(\u_y/mul3_q [8]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_383 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_792  (
    .a(\u_y/mul3_q [9]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_389 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_793  (
    .a(\u_y/mul3_q [10]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_395 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_794  (
    .a(\u_y/mul3_q [11]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_401 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_795  (
    .a(\u_y/mul3_q [12]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_407 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/mux8_syn_796  (
    .a(\u_y/mul3_q [13]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_413 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C@B))"),
    .INIT(8'h82))
    \u_y/mux8_syn_797  (
    .a(\u_y/out_stg1_idx_q [0]),
    .b(\u_y/out_stg1_idx_q [1]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/mux8_syn_605 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT6 #(
    .EQN("(~F*~E*~D*~C*~B*~A)"),
    .INIT(64'h0000000000000001))
    \u_y/mux8_syn_798  (
    .a(\u_y/mult5_syn_10 ),
    .b(\u_y/mult5_syn_9 ),
    .c(\u_y/mult5_syn_8 ),
    .d(\u_y/mult5_syn_7 ),
    .e(\u_y/mult5_syn_6 ),
    .f(\u_y/mult5_syn_3 ),
    .o(\u_y/mux8_syn_799 ));  // ../src_v/jpeg_idct_y.v(263)
  AL_MAP_LUT5 #(
    .EQN("(D*C*~(E*~B*~A))"),
    .INIT(32'he000f000))
    \u_y/mux8_syn_800  (
    .a(\u_y/mult5_syn_5 ),
    .b(\u_y/mult5_syn_4 ),
    .c(\u_y/mult5_syn_90 [13]),
    .d(\u_y/out_stg1_idx_q [2]),
    .e(\u_y/mux8_syn_799 ),
    .o(\u_y/mux8_syn_531 ));  // ../src_v/jpeg_idct_y.v(263)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("ADD_CARRY"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s5_reg[0]_syn_4  (
    .a({al_131[0],\u_y/mux7_syn_605 }),
    .b({\u_y/mux15_syn_4 ,open_n8174}),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_136 ),
    .q({\u_y/o_s5 [0],open_n8195}));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[10]_syn_4  (
    .a(al_131[10:9]),
    .b({\u_y/mux7_syn_385 ,\u_y/mux7_syn_375 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_144 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_146 ),
    .q(\u_y/o_s5 [10:9]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[12]_syn_4  (
    .a(al_131[12:11]),
    .b({\u_y/mux7_syn_405 ,\u_y/mux7_syn_395 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_146 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_148 ),
    .q(\u_y/o_s5 [12:11]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[14]_syn_4  (
    .a(al_131[14:13]),
    .b({\u_y/mux7_syn_425 ,\u_y/mux7_syn_415 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_148 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_150 ),
    .q(\u_y/o_s5 [14:13]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[16]_syn_4  (
    .a(al_131[16:15]),
    .b({\u_y/mux7_syn_445 ,\u_y/mux7_syn_435 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_150 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_152 ),
    .q(\u_y/o_s5 [16:15]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[18]_syn_4  (
    .a(al_131[18:17]),
    .b({\u_y/mux7_syn_465 ,\u_y/mux7_syn_455 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_152 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_154 ),
    .q(\u_y/o_s5 [18:17]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[20]_syn_4  (
    .a(al_131[20:19]),
    .b({\u_y/mux7_syn_485 ,\u_y/mux7_syn_475 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_154 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_156 ),
    .q(\u_y/o_s5 [20:19]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[22]_syn_4  (
    .a(al_131[22:21]),
    .b({\u_y/mux7_syn_505 ,\u_y/mux7_syn_495 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_156 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_158 ),
    .q(\u_y/o_s5 [22:21]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[24]_syn_4  (
    .a(al_131[24:23]),
    .b({\u_y/mux7_syn_525 ,\u_y/mux7_syn_515 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_158 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_160 ),
    .q(\u_y/o_s5 [24:23]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[26]_syn_4  (
    .a(al_131[26:25]),
    .b({\u_y/mux7_syn_545 ,\u_y/mux7_syn_535 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_160 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_162 ),
    .q(\u_y/o_s5 [26:25]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[28]_syn_4  (
    .a(al_131[28:27]),
    .b({\u_y/mux7_syn_565 ,\u_y/mux7_syn_555 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_162 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_164 ),
    .q(\u_y/o_s5 [28:27]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[2]_syn_4  (
    .a(al_131[2:1]),
    .b({\u_y/mux7_syn_305 ,\u_y/mux7_syn_295 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_136 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_138 ),
    .q(\u_y/o_s5 [2:1]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[30]_syn_4  (
    .a(al_131[30:29]),
    .b({\u_y/mux7_syn_585 ,\u_y/mux7_syn_575 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_164 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_166 ),
    .q(\u_y/o_s5 [30:29]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y8Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0110011001101010),
    .INIT_LUT1(16'b0110011001101010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s5_reg[31]_syn_4  (
    .a({open_n8424,al_131[31]}),
    .b({open_n8425,\u_y/mux7_syn_595 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_166 ),
    .sr(rst_i_dup_1951),
    .q({open_n8446,\u_y/o_s5 [31]}));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[4]_syn_4  (
    .a(al_131[4:3]),
    .b({\u_y/mux7_syn_325 ,\u_y/mux7_syn_315 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_138 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_140 ),
    .q(\u_y/o_s5 [4:3]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[6]_syn_4  (
    .a(al_131[6:5]),
    .b({\u_y/mux7_syn_345 ,\u_y/mux7_syn_335 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_140 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_142 ),
    .q(\u_y/o_s5 [6:5]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_s5_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("ADD"),
    .CEMUX("CE"),
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
    .SRMUX("SR"))
    \u_y/o_s5_reg[8]_syn_4  (
    .a(al_131[8:7]),
    .b({\u_y/mux7_syn_365 ,\u_y/mux7_syn_355 }),
    .ce(\u_y/mux7_syn_683 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub2_syn_142 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub2_syn_144 ),
    .q(\u_y/o_s5 [8:7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[0]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [0]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[10]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [10]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[11]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [11]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[12]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [12]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[13]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [13]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[14]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [14]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[15]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [15]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[16]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [16]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[17]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [17]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[18]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [18]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[19]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [19]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[1]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [1]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[20]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [20]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[21]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [21]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [21]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[22]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [22]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [22]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[23]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [23]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [23]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[24]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [24]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [24]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[25]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [25]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [25]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[26]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [26]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [26]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[27]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [27]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [27]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[28]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [28]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [28]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[29]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [29]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [29]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[2]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [2]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[30]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [30]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [30]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[31]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [31]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[3]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [3]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[4]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [4]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[5]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [5]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[6]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [6]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[7]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[8]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [8]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s6_reg[9]  (
    .ce(\u_y/mux8_syn_605 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_s6_b1 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s6 [9]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[0]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b5 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [0]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[10]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [10]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[11]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [11]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[12]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [12]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[13]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [13]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[14]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [14]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[15]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [15]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[16]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [16]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[17]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [17]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[18]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [18]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[19]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [19]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[1]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [1]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[20]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [20]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[21]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [21]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [21]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[22]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [22]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [22]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[23]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [23]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [23]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[24]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [24]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [24]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[25]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [25]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [25]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[26]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [26]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [26]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[27]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [27]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [27]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[28]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [28]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [28]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[29]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [29]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [29]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[2]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [2]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[30]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [30]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [30]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[31]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [31]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[3]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [3]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[4]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [4]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[5]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [5]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[6]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [6]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[7]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[8]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [8]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_s7_reg[9]  (
    .ce(\u_y/mux19_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b4 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_s7 [9]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_LUT4 #(
    .EQN("((C*A)*~(B)*~(D)+(C*A)*B*~(D)+~((C*A))*B*D+(C*A)*B*D)"),
    .INIT(16'hcca0))
    \u_y/o_t0_b1[0]_syn_1  (
    .a(\u_y/o_t0_b3 [0]),
    .b(\u_y/o_t0_b5 [0]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [0]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[10]_syn_1  (
    .a(\u_y/o_t0_b3 [10]),
    .b(\u_y/o_t0_b5 [10]),
    .c(\u_y/mul4_q [10]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [10]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[11]_syn_1  (
    .a(\u_y/o_t0_b3 [11]),
    .b(\u_y/o_t0_b5 [11]),
    .c(\u_y/mul4_q [11]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [11]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[12]_syn_1  (
    .a(\u_y/o_t0_b3 [12]),
    .b(\u_y/o_t0_b5 [12]),
    .c(\u_y/mul4_q [12]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [12]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[13]_syn_1  (
    .a(\u_y/o_t0_b3 [13]),
    .b(\u_y/o_t0_b5 [13]),
    .c(\u_y/mul4_q [13]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [13]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[14]_syn_1  (
    .a(\u_y/o_t0_b3 [14]),
    .b(\u_y/o_t0_b5 [14]),
    .c(\u_y/mul4_q [14]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [14]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[15]_syn_1  (
    .a(\u_y/o_t0_b3 [15]),
    .b(\u_y/o_t0_b5 [15]),
    .c(\u_y/mul4_q [15]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [15]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[16]_syn_1  (
    .a(\u_y/o_t0_b3 [16]),
    .b(\u_y/o_t0_b5 [16]),
    .c(\u_y/mul4_q [16]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [16]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[17]_syn_1  (
    .a(\u_y/o_t0_b3 [17]),
    .b(\u_y/o_t0_b5 [17]),
    .c(\u_y/mul4_q [17]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [17]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[18]_syn_1  (
    .a(\u_y/o_t0_b3 [18]),
    .b(\u_y/o_t0_b5 [18]),
    .c(\u_y/mul4_q [18]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [18]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[19]_syn_1  (
    .a(\u_y/o_t0_b3 [19]),
    .b(\u_y/o_t0_b5 [19]),
    .c(\u_y/mul4_q [19]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [19]));
  AL_MAP_LUT4 #(
    .EQN("((C*A)*~(B)*~(D)+(C*A)*B*~(D)+~((C*A))*B*D+(C*A)*B*D)"),
    .INIT(16'hcca0))
    \u_y/o_t0_b1[1]_syn_1  (
    .a(\u_y/o_t0_b3 [1]),
    .b(\u_y/o_t0_b5 [1]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [1]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[20]_syn_1  (
    .a(\u_y/o_t0_b3 [20]),
    .b(\u_y/o_t0_b5 [20]),
    .c(\u_y/mul4_q [20]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [20]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[21]_syn_1  (
    .a(\u_y/o_t0_b3 [21]),
    .b(\u_y/o_t0_b5 [21]),
    .c(\u_y/mul4_q [21]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [21]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[22]_syn_1  (
    .a(\u_y/o_t0_b3 [22]),
    .b(\u_y/o_t0_b5 [22]),
    .c(\u_y/mul4_q [22]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [22]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[23]_syn_1  (
    .a(\u_y/o_t0_b3 [23]),
    .b(\u_y/o_t0_b5 [23]),
    .c(\u_y/mul4_q [23]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [23]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[24]_syn_1  (
    .a(\u_y/o_t0_b3 [24]),
    .b(\u_y/o_t0_b5 [24]),
    .c(\u_y/mul4_q [24]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [24]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[25]_syn_1  (
    .a(\u_y/o_t0_b3 [25]),
    .b(\u_y/o_t0_b5 [25]),
    .c(\u_y/mul4_q [25]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [25]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[26]_syn_1  (
    .a(\u_y/o_t0_b3 [26]),
    .b(\u_y/o_t0_b5 [26]),
    .c(\u_y/mul4_q [26]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [26]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[27]_syn_1  (
    .a(\u_y/o_t0_b3 [27]),
    .b(\u_y/o_t0_b5 [27]),
    .c(\u_y/mul4_q [27]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [27]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[28]_syn_1  (
    .a(\u_y/o_t0_b3 [28]),
    .b(\u_y/o_t0_b5 [28]),
    .c(\u_y/mul4_q [28]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [28]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[29]_syn_1  (
    .a(\u_y/o_t0_b3 [29]),
    .b(\u_y/o_t0_b5 [29]),
    .c(\u_y/mul4_q [29]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [29]));
  AL_MAP_LUT4 #(
    .EQN("((C*A)*~(B)*~(D)+(C*A)*B*~(D)+~((C*A))*B*D+(C*A)*B*D)"),
    .INIT(16'hcca0))
    \u_y/o_t0_b1[2]_syn_1  (
    .a(\u_y/o_t0_b3 [2]),
    .b(\u_y/o_t0_b5 [2]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [2]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[30]_syn_1  (
    .a(\u_y/o_t0_b3 [30]),
    .b(\u_y/o_t0_b5 [30]),
    .c(\u_y/mul4_q [30]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [30]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[31]_syn_1  (
    .a(\u_y/o_t0_b3 [31]),
    .b(\u_y/o_t0_b5 [31]),
    .c(\u_y/mul4_q [31]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [31]));
  AL_MAP_LUT4 #(
    .EQN("((C*A)*~(B)*~(D)+(C*A)*B*~(D)+~((C*A))*B*D+(C*A)*B*D)"),
    .INIT(16'hcca0))
    \u_y/o_t0_b1[3]_syn_1  (
    .a(\u_y/o_t0_b3 [3]),
    .b(\u_y/o_t0_b5 [3]),
    .c(\u_y/out_stg1_idx_q [1]),
    .d(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [3]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[4]_syn_1  (
    .a(\u_y/o_t0_b3 [4]),
    .b(\u_y/o_t0_b5 [4]),
    .c(\u_y/mul4_q [4]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [4]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[5]_syn_1  (
    .a(\u_y/o_t0_b3 [5]),
    .b(\u_y/o_t0_b5 [5]),
    .c(\u_y/mul4_q [5]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [5]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[6]_syn_1  (
    .a(\u_y/o_t0_b3 [6]),
    .b(\u_y/o_t0_b5 [6]),
    .c(\u_y/mul4_q [6]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [6]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[7]_syn_1  (
    .a(\u_y/o_t0_b3 [7]),
    .b(\u_y/o_t0_b5 [7]),
    .c(\u_y/mul4_q [7]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [7]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[8]_syn_1  (
    .a(\u_y/o_t0_b3 [8]),
    .b(\u_y/o_t0_b5 [8]),
    .c(\u_y/mul4_q [8]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [8]));
  AL_MAP_LUT5 #(
    .EQN("((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*~(B)*~(E)+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*~(E)+~((C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D))*B*E+(C*~(A)*~(D)+C*A*~(D)+~(C)*A*D+C*A*D)*B*E)"),
    .INIT(32'hccccaaf0))
    \u_y/o_t0_b1[9]_syn_1  (
    .a(\u_y/o_t0_b3 [9]),
    .b(\u_y/o_t0_b5 [9]),
    .c(\u_y/mul4_q [9]),
    .d(\u_y/out_stg1_idx_q [1]),
    .e(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t0_b1 [9]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[0]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [0]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[10]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [10]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[11]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [11]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[12]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [12]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[13]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [13]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[14]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [14]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[15]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [15]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[16]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [16]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[17]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [17]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[18]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [18]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[19]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [19]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[1]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [1]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[20]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [20]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[21]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [21]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [21]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[22]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [22]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [22]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[23]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [23]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [23]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[24]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [24]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [24]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[25]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [25]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [25]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[26]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [26]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [26]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[27]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [27]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [27]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[28]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [28]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [28]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[29]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [29]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [29]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[2]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [2]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[30]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [30]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [30]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[31]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [31]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[3]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [3]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[4]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [4]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[5]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [5]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[6]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [6]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[7]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[8]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [8]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t0_reg[9]  (
    .ce(\u_y/mux17_syn_559 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t0_b1 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t0 [9]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[0]_syn_4  (
    .a({\u_y/o_t4 [0],1'b0}),
    .b({\u_y/o_t3 [0],open_n8504}),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_132 ),
    .q({\u_y/o_t1 [0],open_n8525}));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[10]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [10]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[11]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [11]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[12]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [12]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[13]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [13]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[14]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [14]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[15]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [15]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[16]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [16]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[17]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [17]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[18]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [18]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[19]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [19]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[1]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [1]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[20]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [20]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[21]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [21]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [21]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[22]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [22]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [22]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[23]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [23]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [23]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[24]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [24]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [24]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[25]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [25]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [25]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[26]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [26]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [26]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[27]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [27]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [27]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[28]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [28]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [28]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[29]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [29]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [29]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[2]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [2]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[30]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [30]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [30]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[31]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/block_out[0]_b22 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [31]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[3]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [3]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[4]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [4]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[5]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [5]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[6]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [6]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[7]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[8]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [8]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t1_reg[9]  (
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t1_b2 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t1 [9]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[10]_syn_4  (
    .a(\u_y/o_t4 [10:9]),
    .b(\u_y/o_t3 [10:9]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_140 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_142 ),
    .q(\u_y/o_t2 [10:9]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[12]_syn_4  (
    .a(\u_y/o_t4 [12:11]),
    .b(\u_y/o_t3 [12:11]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_142 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_144 ),
    .q(\u_y/o_t2 [12:11]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[14]_syn_4  (
    .a(\u_y/o_t4 [14:13]),
    .b(\u_y/o_t3 [14:13]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_144 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_146 ),
    .q(\u_y/o_t2 [14:13]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[16]_syn_4  (
    .a(\u_y/o_t4 [16:15]),
    .b(\u_y/o_t3 [16:15]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_146 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_148 ),
    .q(\u_y/o_t2 [16:15]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[18]_syn_4  (
    .a(\u_y/o_t4 [18:17]),
    .b(\u_y/o_t3 [18:17]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_148 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_150 ),
    .q(\u_y/o_t2 [18:17]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[20]_syn_4  (
    .a(\u_y/o_t4 [20:19]),
    .b(\u_y/o_t3 [20:19]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_150 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_152 ),
    .q(\u_y/o_t2 [20:19]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[22]_syn_4  (
    .a(\u_y/o_t4 [22:21]),
    .b(\u_y/o_t3 [22:21]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_152 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_154 ),
    .q(\u_y/o_t2 [22:21]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[24]_syn_4  (
    .a(\u_y/o_t4 [24:23]),
    .b(\u_y/o_t3 [24:23]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_154 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_156 ),
    .q(\u_y/o_t2 [24:23]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[26]_syn_4  (
    .a(\u_y/o_t4 [26:25]),
    .b(\u_y/o_t3 [26:25]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_156 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_158 ),
    .q(\u_y/o_t2 [26:25]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[28]_syn_4  (
    .a(\u_y/o_t4 [28:27]),
    .b(\u_y/o_t3 [28:27]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_158 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_160 ),
    .q(\u_y/o_t2 [28:27]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[2]_syn_4  (
    .a(\u_y/o_t4 [2:1]),
    .b(\u_y/o_t3 [2:1]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_132 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_134 ),
    .q(\u_y/o_t2 [2:1]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[30]_syn_4  (
    .a(\u_y/o_t4 [30:29]),
    .b(\u_y/o_t3 [30:29]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_160 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_162 ),
    .q(\u_y/o_t2 [30:29]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y8Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[31]_syn_4  (
    .a({open_n8754,\u_y/o_t4 [31]}),
    .b({open_n8755,\u_y/o_t3 [31]}),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_162 ),
    .sr(rst_i_dup_1951),
    .q({open_n8776,\u_y/o_t2 [31]}));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[4]_syn_4  (
    .a(\u_y/o_t4 [4:3]),
    .b(\u_y/o_t3 [4:3]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_134 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_136 ),
    .q(\u_y/o_t2 [4:3]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[6]_syn_4  (
    .a(\u_y/o_t4 [6:5]),
    .b(\u_y/o_t3 [6:5]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_136 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_138 ),
    .q(\u_y/o_t2 [6:5]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t1_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t2_reg[8]_syn_4  (
    .a(\u_y/o_t4 [8:7]),
    .b(\u_y/o_t3 [8:7]),
    .ce(\u_y/mux10_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub5_syn_138 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub5_syn_140 ),
    .q(\u_y/o_t2 [8:7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[0]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [0]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[10]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [10]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[11]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [11]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[12]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [12]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[13]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [13]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[14]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [14]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[15]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [15]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[16]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [16]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[17]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [17]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[18]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [18]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[19]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [19]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[1]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [1]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[20]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [20]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[21]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [21]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [21]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[22]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [22]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [22]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[23]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [23]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [23]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[24]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [24]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [24]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[25]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [25]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [25]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[26]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [26]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [26]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[27]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [27]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [27]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[28]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [28]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [28]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[29]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [29]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [29]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[2]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [2]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[30]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [30]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [30]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[31]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [31]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[3]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [3]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[4]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [4]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[5]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [5]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[6]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [6]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[7]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[8]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [8]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t3_reg[9]  (
    .ce(\u_y/mux13_syn_475 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t3_b1 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t3 [9]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/o_t4_b1[0]_syn_1  (
    .a(\u_y/o_t0_b5 [0]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [0]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[10]_syn_1  (
    .a(\u_y/add4_syn_35 [9]),
    .b(\u_y/mul4_q [10]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [10]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[11]_syn_1  (
    .a(\u_y/add4_syn_35 [10]),
    .b(\u_y/mul4_q [11]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [11]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[12]_syn_1  (
    .a(\u_y/add4_syn_35 [11]),
    .b(\u_y/mul4_q [12]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [12]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[13]_syn_1  (
    .a(\u_y/add4_syn_35 [12]),
    .b(\u_y/mul4_q [13]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [13]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[14]_syn_1  (
    .a(\u_y/add4_syn_35 [13]),
    .b(\u_y/mul4_q [14]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [14]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[15]_syn_1  (
    .a(\u_y/add4_syn_35 [14]),
    .b(\u_y/mul4_q [15]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [15]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[16]_syn_1  (
    .a(\u_y/add4_syn_35 [15]),
    .b(\u_y/mul4_q [16]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [16]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[17]_syn_1  (
    .a(\u_y/add4_syn_35 [16]),
    .b(\u_y/mul4_q [17]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [17]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[18]_syn_1  (
    .a(\u_y/add4_syn_35 [17]),
    .b(\u_y/mul4_q [18]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [18]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[19]_syn_1  (
    .a(\u_y/add4_syn_35 [18]),
    .b(\u_y/mul4_q [19]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [19]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/o_t4_b1[1]_syn_1  (
    .a(\u_y/add4_syn_35 [0]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [1]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[20]_syn_1  (
    .a(\u_y/add4_syn_35 [19]),
    .b(\u_y/mul4_q [20]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [20]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[21]_syn_1  (
    .a(\u_y/add4_syn_35 [20]),
    .b(\u_y/mul4_q [21]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [21]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[22]_syn_1  (
    .a(\u_y/add4_syn_35 [21]),
    .b(\u_y/mul4_q [22]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [22]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[23]_syn_1  (
    .a(\u_y/add4_syn_35 [22]),
    .b(\u_y/mul4_q [23]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [23]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[24]_syn_1  (
    .a(\u_y/add4_syn_35 [23]),
    .b(\u_y/mul4_q [24]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [24]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[25]_syn_1  (
    .a(\u_y/add4_syn_35 [24]),
    .b(\u_y/mul4_q [25]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [25]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[26]_syn_1  (
    .a(\u_y/add4_syn_35 [25]),
    .b(\u_y/mul4_q [26]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [26]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[27]_syn_1  (
    .a(\u_y/add4_syn_35 [26]),
    .b(\u_y/mul4_q [27]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [27]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[28]_syn_1  (
    .a(\u_y/add4_syn_35 [27]),
    .b(\u_y/mul4_q [28]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [28]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[29]_syn_1  (
    .a(\u_y/add4_syn_35 [28]),
    .b(\u_y/mul4_q [29]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [29]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/o_t4_b1[2]_syn_1  (
    .a(\u_y/add4_syn_35 [1]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [2]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[30]_syn_1  (
    .a(\u_y/add4_syn_35 [29]),
    .b(\u_y/mul4_q [30]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [30]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[31]_syn_1  (
    .a(\u_y/add4_syn_35 [30]),
    .b(\u_y/mul4_q [31]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [31]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_y/o_t4_b1[3]_syn_1  (
    .a(\u_y/add4_syn_35 [2]),
    .b(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [3]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[4]_syn_1  (
    .a(\u_y/add4_syn_35 [3]),
    .b(\u_y/mul4_q [4]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [4]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[5]_syn_1  (
    .a(\u_y/add4_syn_35 [4]),
    .b(\u_y/mul4_q [5]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [5]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[6]_syn_1  (
    .a(\u_y/add4_syn_35 [5]),
    .b(\u_y/mul4_q [6]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [6]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[7]_syn_1  (
    .a(\u_y/add4_syn_35 [6]),
    .b(\u_y/mul4_q [7]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [7]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[8]_syn_1  (
    .a(\u_y/add4_syn_35 [7]),
    .b(\u_y/mul4_q [8]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [8]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u_y/o_t4_b1[9]_syn_1  (
    .a(\u_y/add4_syn_35 [8]),
    .b(\u_y/mul4_q [9]),
    .c(\u_y/out_stg1_idx_q [2]),
    .o(\u_y/o_t4_b1 [9]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[0]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [0]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[10]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [10]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[11]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [11]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[12]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [12]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[13]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [13]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[14]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [14]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[15]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [15]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[16]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [16]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[17]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [17]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[18]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [18]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[19]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [19]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[1]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [1]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[20]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [20]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[21]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [21]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [21]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[22]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [22]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [22]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[23]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [23]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [23]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[24]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [24]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [24]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[25]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [25]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [25]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[26]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [26]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [26]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[27]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [27]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [27]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[28]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [28]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [28]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[29]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [29]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [29]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[2]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [2]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[30]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [30]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [30]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[31]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [31]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[3]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [3]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[4]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [4]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[5]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [5]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[6]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [6]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[7]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[8]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [8]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t4_reg[9]  (
    .ce(\u_y/mux14_syn_428 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t4_b1 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t4 [9]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[0]_syn_4  (
    .a({\u_y/o_t0 [0],1'b0}),
    .b({\u_y/o_s5 [0],open_n8834}),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_132 ),
    .q({\u_y/o_t5 [0],open_n8855}));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[10]_syn_4  (
    .a(\u_y/o_t0 [10:9]),
    .b(\u_y/o_s5 [10:9]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_140 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_142 ),
    .q(\u_y/o_t5 [10:9]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[12]_syn_4  (
    .a(\u_y/o_t0 [12:11]),
    .b(\u_y/o_s5 [12:11]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_142 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_144 ),
    .q(\u_y/o_t5 [12:11]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[14]_syn_4  (
    .a(\u_y/o_t0 [14:13]),
    .b(\u_y/o_s5 [14:13]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_144 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_146 ),
    .q(\u_y/o_t5 [14:13]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[16]_syn_4  (
    .a(\u_y/o_t0 [16:15]),
    .b(\u_y/o_s5 [16:15]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_146 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_148 ),
    .q(\u_y/o_t5 [16:15]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[18]_syn_4  (
    .a(\u_y/o_t0 [18:17]),
    .b(\u_y/o_s5 [18:17]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_148 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_150 ),
    .q(\u_y/o_t5 [18:17]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[20]_syn_4  (
    .a(\u_y/o_t0 [20:19]),
    .b(\u_y/o_s5 [20:19]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_150 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_152 ),
    .q(\u_y/o_t5 [20:19]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[22]_syn_4  (
    .a(\u_y/o_t0 [22:21]),
    .b(\u_y/o_s5 [22:21]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_152 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_154 ),
    .q(\u_y/o_t5 [22:21]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[24]_syn_4  (
    .a(\u_y/o_t0 [24:23]),
    .b(\u_y/o_s5 [24:23]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_154 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_156 ),
    .q(\u_y/o_t5 [24:23]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[26]_syn_4  (
    .a(\u_y/o_t0 [26:25]),
    .b(\u_y/o_s5 [26:25]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_156 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_158 ),
    .q(\u_y/o_t5 [26:25]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[28]_syn_4  (
    .a(\u_y/o_t0 [28:27]),
    .b(\u_y/o_s5 [28:27]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_158 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_160 ),
    .q(\u_y/o_t5 [28:27]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[2]_syn_4  (
    .a(\u_y/o_t0 [2:1]),
    .b(\u_y/o_s5 [2:1]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_132 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_134 ),
    .q(\u_y/o_t5 [2:1]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[30]_syn_4  (
    .a(\u_y/o_t0 [30:29]),
    .b(\u_y/o_s5 [30:29]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_160 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_162 ),
    .q(\u_y/o_t5 [30:29]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y8Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[31]_syn_4  (
    .a({open_n9084,\u_y/o_t0 [31]}),
    .b({open_n9085,\u_y/o_s5 [31]}),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_162 ),
    .sr(rst_i_dup_1951),
    .q({open_n9106,\u_y/o_t5 [31]}));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[4]_syn_4  (
    .a(\u_y/o_t0 [4:3]),
    .b(\u_y/o_s5 [4:3]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_134 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_136 ),
    .q(\u_y/o_t5 [4:3]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[6]_syn_4  (
    .a(\u_y/o_t0 [6:5]),
    .b(\u_y/o_s5 [6:5]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_136 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_138 ),
    .q(\u_y/o_t5 [6:5]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t5_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t5_reg[8]_syn_4  (
    .a(\u_y/o_t0 [8:7]),
    .b(\u_y/o_s5 [8:7]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub3_syn_138 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub3_syn_140 ),
    .q(\u_y/o_t5 [8:7]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[0]_syn_4  (
    .a({\u_y/o_s7 [0],1'b0}),
    .b({\u_y/o_s6 [0],open_n9164}),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .sr(rst_i_dup_1951),
    .f({\u_y/o_t6_b2 [0],open_n9181}),
    .fco(\u_y/sub4_syn_132 ),
    .q({\u_y/o_t6 [0],open_n9184}));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[10]_syn_4  (
    .a(\u_y/o_s7 [10:9]),
    .b(\u_y/o_s6 [10:9]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_140 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_142 ),
    .q(\u_y/o_t6 [10:9]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[12]_syn_4  (
    .a(\u_y/o_s7 [12:11]),
    .b(\u_y/o_s6 [12:11]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_142 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_144 ),
    .q(\u_y/o_t6 [12:11]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[14]_syn_4  (
    .a(\u_y/o_s7 [14:13]),
    .b(\u_y/o_s6 [14:13]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_144 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_146 ),
    .q(\u_y/o_t6 [14:13]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[16]_syn_4  (
    .a(\u_y/o_s7 [16:15]),
    .b(\u_y/o_s6 [16:15]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_146 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_148 ),
    .q(\u_y/o_t6 [16:15]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[18]_syn_4  (
    .a(\u_y/o_s7 [18:17]),
    .b(\u_y/o_s6 [18:17]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_148 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_150 ),
    .q(\u_y/o_t6 [18:17]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[20]_syn_4  (
    .a(\u_y/o_s7 [20:19]),
    .b(\u_y/o_s6 [20:19]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_150 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_152 ),
    .q(\u_y/o_t6 [20:19]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[22]_syn_4  (
    .a(\u_y/o_s7 [22:21]),
    .b(\u_y/o_s6 [22:21]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_152 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_154 ),
    .q(\u_y/o_t6 [22:21]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[24]_syn_4  (
    .a(\u_y/o_s7 [24:23]),
    .b(\u_y/o_s6 [24:23]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_154 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_156 ),
    .q(\u_y/o_t6 [24:23]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[26]_syn_4  (
    .a(\u_y/o_s7 [26:25]),
    .b(\u_y/o_s6 [26:25]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_156 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_158 ),
    .q(\u_y/o_t6 [26:25]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[28]_syn_4  (
    .a(\u_y/o_s7 [28:27]),
    .b(\u_y/o_s6 [28:27]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_158 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_160 ),
    .q(\u_y/o_t6 [28:27]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[2]_syn_4  (
    .a(\u_y/o_s7 [2:1]),
    .b(\u_y/o_s6 [2:1]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_132 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_134 ),
    .q(\u_y/o_t6 [2:1]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[30]_syn_4  (
    .a(\u_y/o_s7 [30:29]),
    .b(\u_y/o_s6 [30:29]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_160 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_162 ),
    .q(\u_y/o_t6 [30:29]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y8Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[31]_syn_4  (
    .a({open_n9413,\u_y/o_s7 [31]}),
    .b({open_n9414,\u_y/o_s6 [31]}),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_162 ),
    .sr(rst_i_dup_1951),
    .q({open_n9435,\u_y/o_t6 [31]}));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[4]_syn_4  (
    .a(\u_y/o_s7 [4:3]),
    .b(\u_y/o_s6 [4:3]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_134 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_136 ),
    .q(\u_y/o_t6 [4:3]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[6]_syn_4  (
    .a(\u_y/o_s7 [6:5]),
    .b(\u_y/o_s6 [6:5]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_136 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_138 ),
    .q(\u_y/o_t6 [6:5]));  // ../src_v/jpeg_idct_y.v(244)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/o_t6_reg[0]_syn_4"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t6_reg[8]_syn_4  (
    .a(\u_y/o_s7 [8:7]),
    .b(\u_y/o_s6 [8:7]),
    .ce(\u_y/mux15_syn_1 ),
    .clk(clk_i_dup_1),
    .fci(\u_y/sub4_syn_138 ),
    .sr(rst_i_dup_1951),
    .fco(\u_y/sub4_syn_140 ),
    .q(\u_y/o_t6 [8:7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[0]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t6_b2 [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [0]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[10]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [10]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [10]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[11]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [11]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [11]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[12]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [12]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [12]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[13]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [13]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [13]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[14]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [14]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [14]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[15]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [15]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [15]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[16]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [16]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [16]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[17]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [17]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [17]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[18]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [18]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [18]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[19]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [19]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [19]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[1]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [1]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[20]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [20]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [20]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[21]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [21]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [21]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[22]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [22]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [22]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[23]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [23]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [23]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[24]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [24]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [24]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[25]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [25]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [25]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[26]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [26]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [26]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[27]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [27]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [27]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[28]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [28]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [28]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[29]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [29]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [29]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[2]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [2]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[30]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [30]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [30]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[31]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [31]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [31]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[3]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [3]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [3]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[4]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [4]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [4]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[5]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [5]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [5]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[6]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [6]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [6]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[7]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [7]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [7]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[8]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [8]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [8]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/o_t7_reg[9]  (
    .ce(\u_y/mux18_syn_1 ),
    .clk(clk_i_dup_1),
    .d(\u_y/o_t7_b2 [9]),
    .sr(rst_i_dup_1951),
    .q(\u_y/o_t7 [9]));  // ../src_v/jpeg_idct_y.v(244)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/out_stg1_idx_q_reg[0]  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg0_idx_q [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/out_stg1_idx_q [0]));  // ../src_v/jpeg_idct_y.v(216)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/out_stg1_idx_q_reg[1]  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg0_idx_q [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/out_stg1_idx_q [1]));  // ../src_v/jpeg_idct_y.v(216)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/out_stg1_idx_q_reg[2]  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg0_idx_q [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/out_stg1_idx_q [2]));  // ../src_v/jpeg_idct_y.v(216)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/out_stg1_valid_q_reg  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg0_valid_q ),
    .sr(rst_i_dup_1951),
    .q(\u_y/out_stg1_valid_q ));  // ../src_v/jpeg_idct_y.v(216)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/out_stg3_idx_q_reg[0]  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg1_idx_q [0]),
    .sr(rst_i_dup_1951),
    .q(\u_y/out_stg3_idx_q [0]));  // ../src_v/jpeg_idct_y.v(314)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/out_stg3_idx_q_reg[1]  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg1_idx_q [1]),
    .sr(rst_i_dup_1951),
    .q(\u_y/out_stg3_idx_q [1]));  // ../src_v/jpeg_idct_y.v(314)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/out_stg3_idx_q_reg[2]  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg1_idx_q [2]),
    .sr(rst_i_dup_1951),
    .q(\u_y/out_stg3_idx_q [2]));  // ../src_v/jpeg_idct_y.v(314)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/out_stg3_valid_q_reg  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg1_valid_q ),
    .sr(rst_i_dup_1951),
    .q(\u_y/out_stg3_valid_q ));  // ../src_v/jpeg_idct_y.v(314)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_y/ptr_q[0]_syn_7  (
    .a(\u_y/ptr_q [0]),
    .o(\u_y/ptr_q[0]_syn_2 ));  // ../src_v/jpeg_idct_y.v(374)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/ptr_q_b4[1]_syn_1  (
    .a(\u_y/ptr_q [0]),
    .b(\u_y/ptr_q [1]),
    .o(\u_y/ptr_q_b4 [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/ptr_q_reg[0]  (
    .clk(clk_i_dup_1),
    .d(\u_y/ptr_q_reg[0]_syn_2 ),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/ptr_q [0]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_y/ptr_q_reg[0]_syn_3  (
    .a(\u_y/ptr_q [0]),
    .b(outport_valid_o_dup_17),
    .o(\u_y/ptr_q_reg[0]_syn_2 ));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/ptr_q_reg[1]  (
    .clk(clk_i_dup_1),
    .d(\u_y/ptr_q_reg[1]_syn_2 ),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/ptr_q [1]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT3 #(
    .EQN("(B@(C*A))"),
    .INIT(8'h6c))
    \u_y/ptr_q_reg[1]_syn_3  (
    .a(\u_y/ptr_q [0]),
    .b(\u_y/ptr_q [1]),
    .c(outport_valid_o_dup_17),
    .o(\u_y/ptr_q_reg[1]_syn_2 ));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/ptr_q_reg[2]  (
    .clk(clk_i_dup_1),
    .d(\u_y/ptr_q_reg[2]_syn_2 ),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/ptr_q [2]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT3 #(
    .EQN("(C@(B*A))"),
    .INIT(8'h78))
    \u_y/ptr_q_reg[2]_syn_3  (
    .a(\u_y/ptr_q [0]),
    .b(\u_y/ptr_q [1]),
    .c(\u_y/ptr_q [2]),
    .o(\u_y/ptr_q_b4 [2]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    \u_y/ptr_q_reg[2]_syn_4  (
    .a(\u_y/ptr_q [2]),
    .b(outport_valid_o_dup_17),
    .c(\u_y/ptr_q_b4 [2]),
    .o(\u_y/ptr_q_reg[2]_syn_2 ));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/ptr_q_reg[3]  (
    .clk(clk_i_dup_1),
    .d(\u_y/ptr_q_reg[3]_syn_2 ),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/ptr_q [3]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT4 #(
    .EQN("(D@(C*B*A))"),
    .INIT(16'h7f80))
    \u_y/ptr_q_reg[3]_syn_3  (
    .a(\u_y/ptr_q [0]),
    .b(\u_y/ptr_q [1]),
    .c(\u_y/ptr_q [2]),
    .d(\u_y/ptr_q [3]),
    .o(\u_y/ptr_q_b4 [3]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    \u_y/ptr_q_reg[3]_syn_4  (
    .a(\u_y/ptr_q [3]),
    .b(outport_valid_o_dup_17),
    .c(\u_y/ptr_q_b4 [3]),
    .o(\u_y/ptr_q_reg[3]_syn_2 ));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/ptr_q_reg[4]  (
    .clk(clk_i_dup_1),
    .d(\u_y/ptr_q_reg[4]_syn_2 ),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/ptr_q [4]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT5 #(
    .EQN("(E@(D*C*B*A))"),
    .INIT(32'h7fff8000))
    \u_y/ptr_q_reg[4]_syn_3  (
    .a(\u_y/ptr_q [0]),
    .b(\u_y/ptr_q [1]),
    .c(\u_y/ptr_q [2]),
    .d(\u_y/ptr_q [3]),
    .e(\u_y/ptr_q [4]),
    .o(\u_y/ptr_q_b4 [4]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    \u_y/ptr_q_reg[4]_syn_4  (
    .a(\u_y/ptr_q [4]),
    .b(outport_valid_o_dup_17),
    .c(\u_y/ptr_q_b4 [4]),
    .o(\u_y/ptr_q_reg[4]_syn_2 ));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/ptr_q_reg[5]  (
    .clk(clk_i_dup_1),
    .d(\u_y/ptr_q_reg[5]_syn_2 ),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/ptr_q [5]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT6 #(
    .EQN("(F@(E*D*C*B*A))"),
    .INIT(64'h7fffffff80000000))
    \u_y/ptr_q_reg[5]_syn_3  (
    .a(\u_y/ptr_q [0]),
    .b(\u_y/ptr_q [1]),
    .c(\u_y/ptr_q [2]),
    .d(\u_y/ptr_q [3]),
    .e(\u_y/ptr_q [4]),
    .f(\u_y/ptr_q [5]),
    .o(\u_y/ptr_q_b4 [5]));  // ../src_v/jpeg_idct_y.v(376)
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    \u_y/ptr_q_reg[5]_syn_4  (
    .a(\u_y/ptr_q [5]),
    .b(outport_valid_o_dup_17),
    .c(\u_y/ptr_q_b4 [5]),
    .o(\u_y/ptr_q_reg[5]_syn_2 ));  // ../src_v/jpeg_idct_y.v(376)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_167  (
    .a({\u_y/mux13_syn_499 ,\u_y/mux13_syn_463 }),
    .b({\u_y/mux13_syn_511 ,\u_y/mux13_syn_487 }),
    .c(2'b00),
    .d({al_66[1],1'b1}),
    .e({al_66[2],al_66[0]}),
    .f({\u_y/o_t3_b1 [1],open_n9524}),
    .fco(\u_y/sub0_syn_136 ),
    .fx({\u_y/o_t3_b1 [2],\u_y/o_t3_b1 [0]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_168  (
    .a({\u_y/mux13_syn_547 ,\u_y/mux13_syn_523 }),
    .b({\u_y/mux13_syn_559 ,\u_y/mux13_syn_535 }),
    .c(2'b00),
    .d({al_66[5],al_66[3]}),
    .e({al_66[6],al_66[4]}),
    .fci(\u_y/sub0_syn_136 ),
    .f({\u_y/o_t3_b1 [5],\u_y/o_t3_b1 [3]}),
    .fco(\u_y/sub0_syn_140 ),
    .fx({\u_y/o_t3_b1 [6],\u_y/o_t3_b1 [4]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_169  (
    .a({\u_y/mux13_syn_595 ,\u_y/mux13_syn_571 }),
    .b({\u_y/mux13_syn_607 ,\u_y/mux13_syn_583 }),
    .c(2'b00),
    .d({al_66[9],al_66[7]}),
    .e({al_66[10],al_66[8]}),
    .fci(\u_y/sub0_syn_140 ),
    .f({\u_y/o_t3_b1 [9],\u_y/o_t3_b1 [7]}),
    .fco(\u_y/sub0_syn_144 ),
    .fx({\u_y/o_t3_b1 [10],\u_y/o_t3_b1 [8]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_170  (
    .a({\u_y/mux13_syn_643 ,\u_y/mux13_syn_619 }),
    .b({\u_y/mux13_syn_655 ,\u_y/mux13_syn_631 }),
    .c(2'b00),
    .d({al_66[13],al_66[11]}),
    .e({al_66[14],al_66[12]}),
    .fci(\u_y/sub0_syn_144 ),
    .f({\u_y/o_t3_b1 [13],\u_y/o_t3_b1 [11]}),
    .fco(\u_y/sub0_syn_148 ),
    .fx({\u_y/o_t3_b1 [14],\u_y/o_t3_b1 [12]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_171  (
    .a({\u_y/mux13_syn_691 ,\u_y/mux13_syn_667 }),
    .b({\u_y/mux13_syn_703 ,\u_y/mux13_syn_679 }),
    .c(2'b00),
    .d({al_66[17],al_66[15]}),
    .e({al_66[18],al_66[16]}),
    .fci(\u_y/sub0_syn_148 ),
    .f({\u_y/o_t3_b1 [17],\u_y/o_t3_b1 [15]}),
    .fco(\u_y/sub0_syn_152 ),
    .fx({\u_y/o_t3_b1 [18],\u_y/o_t3_b1 [16]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_172  (
    .a({\u_y/mux13_syn_739 ,\u_y/mux13_syn_715 }),
    .b({\u_y/mux13_syn_751 ,\u_y/mux13_syn_727 }),
    .c(2'b00),
    .d({al_66[21],al_66[19]}),
    .e({al_66[22],al_66[20]}),
    .fci(\u_y/sub0_syn_152 ),
    .f({\u_y/o_t3_b1 [21],\u_y/o_t3_b1 [19]}),
    .fco(\u_y/sub0_syn_156 ),
    .fx({\u_y/o_t3_b1 [22],\u_y/o_t3_b1 [20]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_173  (
    .a({\u_y/mux13_syn_787 ,\u_y/mux13_syn_763 }),
    .b({\u_y/mux13_syn_799 ,\u_y/mux13_syn_775 }),
    .c(2'b00),
    .d({al_66[25],al_66[23]}),
    .e({al_66[26],al_66[24]}),
    .fci(\u_y/sub0_syn_156 ),
    .f({\u_y/o_t3_b1 [25],\u_y/o_t3_b1 [23]}),
    .fco(\u_y/sub0_syn_160 ),
    .fx({\u_y/o_t3_b1 [26],\u_y/o_t3_b1 [24]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_174  (
    .a({\u_y/mux13_syn_835 ,\u_y/mux13_syn_811 }),
    .b({\u_y/mux13_syn_847 ,\u_y/mux13_syn_823 }),
    .c(2'b00),
    .d({al_66[29],al_66[27]}),
    .e({al_66[30],al_66[28]}),
    .fci(\u_y/sub0_syn_160 ),
    .f({\u_y/o_t3_b1 [29],\u_y/o_t3_b1 [27]}),
    .fco(\u_y/sub0_syn_164 ),
    .fx({\u_y/o_t3_b1 [30],\u_y/o_t3_b1 [28]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub0_syn_167"),
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
    \u_y/sub0_syn_175  (
    .a({open_n9653,\u_y/mux13_syn_859 }),
    .c(2'b00),
    .d({open_n9658,al_66[31]}),
    .fci(\u_y/sub0_syn_164 ),
    .f({open_n9675,\u_y/o_t3_b1 [31]}));  // ../src_v/jpeg_idct_y.v(277)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
    //.R_POSITION("X0Y0Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'h0005),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_y/sub10_syn_164  (
    .a({\u_y/o_t2 [1],1'b0}),
    .b({\u_y/o_t2 [2],\u_y/o_t1 [0]}),
    .c(2'b11),
    .d({\u_y/o_s5 [1],1'b1}),
    .e({\u_y/o_s5 [2],\u_y/o_s5 [0]}),
    .fco(\u_y/sub10_syn_134 ));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
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
    \u_y/sub10_syn_165  (
    .a({\u_y/o_t2 [5],\u_y/o_t2 [3]}),
    .b({\u_y/o_t2 [6],\u_y/o_t2 [4]}),
    .c(2'b11),
    .d({\u_y/o_s5 [5],\u_y/o_s5 [3]}),
    .e({\u_y/o_s5 [6],\u_y/o_s5 [4]}),
    .fci(\u_y/sub10_syn_134 ),
    .fco(\u_y/sub10_syn_138 ));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
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
    \u_y/sub10_syn_166  (
    .a({\u_y/o_t2 [9],\u_y/o_t2 [7]}),
    .b({\u_y/o_t2 [10],\u_y/o_t2 [8]}),
    .c(2'b11),
    .d({\u_y/o_s5 [9],\u_y/o_s5 [7]}),
    .e({\u_y/o_s5 [10],\u_y/o_s5 [8]}),
    .fci(\u_y/sub10_syn_138 ),
    .fco(\u_y/sub10_syn_142 ));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
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
    \u_y/sub10_syn_167  (
    .a({\u_y/o_t2 [13],\u_y/o_t2 [11]}),
    .b({\u_y/o_t2 [14],\u_y/o_t2 [12]}),
    .c(2'b11),
    .d({\u_y/o_s5 [13],\u_y/o_s5 [11]}),
    .e({\u_y/o_s5 [14],\u_y/o_s5 [12]}),
    .fci(\u_y/sub10_syn_142 ),
    .f({\u_y/block_out[0]_b18 [2],\u_y/block_out[0]_b18 [0]}),
    .fco(\u_y/sub10_syn_146 ),
    .fx({\u_y/block_out[0]_b18 [3],\u_y/block_out[0]_b18 [1]}));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
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
    \u_y/sub10_syn_168  (
    .a({\u_y/o_t2 [17],\u_y/o_t2 [15]}),
    .b({\u_y/o_t2 [18],\u_y/o_t2 [16]}),
    .c(2'b11),
    .d({\u_y/o_s5 [17],\u_y/o_s5 [15]}),
    .e({\u_y/o_s5 [18],\u_y/o_s5 [16]}),
    .fci(\u_y/sub10_syn_146 ),
    .f({\u_y/block_out[0]_b18 [6],\u_y/block_out[0]_b18 [4]}),
    .fco(\u_y/sub10_syn_150 ),
    .fx({\u_y/block_out[0]_b18 [7],\u_y/block_out[0]_b18 [5]}));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
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
    \u_y/sub10_syn_169  (
    .a({\u_y/o_t2 [21],\u_y/o_t2 [19]}),
    .b({\u_y/o_t2 [22],\u_y/o_t2 [20]}),
    .c(2'b11),
    .d({\u_y/o_s5 [21],\u_y/o_s5 [19]}),
    .e({\u_y/o_s5 [22],\u_y/o_s5 [20]}),
    .fci(\u_y/sub10_syn_150 ),
    .f({\u_y/block_out[0]_b18 [10],\u_y/block_out[0]_b18 [8]}),
    .fco(\u_y/sub10_syn_154 ),
    .fx({\u_y/block_out[0]_b18 [11],\u_y/block_out[0]_b18 [9]}));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
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
    \u_y/sub10_syn_170  (
    .a({\u_y/o_t2 [25],\u_y/o_t2 [23]}),
    .b({\u_y/o_t2 [26],\u_y/o_t2 [24]}),
    .c(2'b11),
    .d({\u_y/o_s5 [25],\u_y/o_s5 [23]}),
    .e({\u_y/o_s5 [26],\u_y/o_s5 [24]}),
    .fci(\u_y/sub10_syn_154 ),
    .f({\u_y/block_out[0]_b18 [14],\u_y/block_out[0]_b18 [12]}),
    .fco(\u_y/sub10_syn_158 ),
    .fx({\u_y/block_out[0]_b18 [15],\u_y/block_out[0]_b18 [13]}));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
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
    \u_y/sub10_syn_171  (
    .a({\u_y/o_t2 [29],\u_y/o_t2 [27]}),
    .b({\u_y/o_t2 [30],\u_y/o_t2 [28]}),
    .c(2'b11),
    .d({\u_y/o_s5 [29],\u_y/o_s5 [27]}),
    .e({\u_y/o_s5 [30],\u_y/o_s5 [28]}),
    .fci(\u_y/sub10_syn_158 ),
    .f({\u_y/block_out[0]_b18 [18],\u_y/block_out[0]_b18 [16]}),
    .fco(\u_y/sub10_syn_162 ),
    .fx({\u_y/block_out[0]_b18 [19],\u_y/block_out[0]_b18 [17]}));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub10_syn_164"),
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
    \u_y/sub10_syn_172  (
    .a({open_n9838,\u_y/o_t2 [31]}),
    .c(2'b11),
    .d({open_n9843,\u_y/o_s5 [31]}),
    .fci(\u_y/sub10_syn_162 ),
    .f({open_n9860,\u_y/block_out[0]_b27 [31]}));  // ../src_v/jpeg_idct_y.v(358)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
    //.R_POSITION("X0Y0Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'h0005),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_y/sub11_syn_164  (
    .a({\u_y/o_t1 [1],1'b0}),
    .b({\u_y/o_t1 [2],\u_y/o_t1 [0]}),
    .c(2'b11),
    .d({\u_y/o_s6 [1],1'b1}),
    .e({\u_y/o_s6 [2],\u_y/o_s6 [0]}),
    .fco(\u_y/sub11_syn_134 ));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
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
    \u_y/sub11_syn_165  (
    .a({\u_y/o_t1 [5],\u_y/o_t1 [3]}),
    .b({\u_y/o_t1 [6],\u_y/o_t1 [4]}),
    .c(2'b11),
    .d({\u_y/o_s6 [5],\u_y/o_s6 [3]}),
    .e({\u_y/o_s6 [6],\u_y/o_s6 [4]}),
    .fci(\u_y/sub11_syn_134 ),
    .fco(\u_y/sub11_syn_138 ));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
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
    \u_y/sub11_syn_166  (
    .a({\u_y/o_t1 [9],\u_y/o_t1 [7]}),
    .b({\u_y/o_t1 [10],\u_y/o_t1 [8]}),
    .c(2'b11),
    .d({\u_y/o_s6 [9],\u_y/o_s6 [7]}),
    .e({\u_y/o_s6 [10],\u_y/o_s6 [8]}),
    .fci(\u_y/sub11_syn_138 ),
    .fco(\u_y/sub11_syn_142 ));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
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
    \u_y/sub11_syn_167  (
    .a({\u_y/o_t1 [13],\u_y/o_t1 [11]}),
    .b({\u_y/o_t1 [14],\u_y/o_t1 [12]}),
    .c(2'b11),
    .d({\u_y/o_s6 [13],\u_y/o_s6 [11]}),
    .e({\u_y/o_s6 [14],\u_y/o_s6 [12]}),
    .fci(\u_y/sub11_syn_142 ),
    .f({\u_y/block_out[0]_b19 [2],\u_y/block_out[0]_b19 [0]}),
    .fco(\u_y/sub11_syn_146 ),
    .fx({\u_y/block_out[0]_b19 [3],\u_y/block_out[0]_b19 [1]}));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
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
    \u_y/sub11_syn_168  (
    .a({\u_y/o_t1 [17],\u_y/o_t1 [15]}),
    .b({\u_y/o_t1 [18],\u_y/o_t1 [16]}),
    .c(2'b11),
    .d({\u_y/o_s6 [17],\u_y/o_s6 [15]}),
    .e({\u_y/o_s6 [18],\u_y/o_s6 [16]}),
    .fci(\u_y/sub11_syn_146 ),
    .f({\u_y/block_out[0]_b19 [6],\u_y/block_out[0]_b19 [4]}),
    .fco(\u_y/sub11_syn_150 ),
    .fx({\u_y/block_out[0]_b19 [7],\u_y/block_out[0]_b19 [5]}));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
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
    \u_y/sub11_syn_169  (
    .a({\u_y/o_t1 [21],\u_y/o_t1 [19]}),
    .b({\u_y/o_t1 [22],\u_y/o_t1 [20]}),
    .c(2'b11),
    .d({\u_y/o_s6 [21],\u_y/o_s6 [19]}),
    .e({\u_y/o_s6 [22],\u_y/o_s6 [20]}),
    .fci(\u_y/sub11_syn_150 ),
    .f({\u_y/block_out[0]_b19 [10],\u_y/block_out[0]_b19 [8]}),
    .fco(\u_y/sub11_syn_154 ),
    .fx({\u_y/block_out[0]_b19 [11],\u_y/block_out[0]_b19 [9]}));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
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
    \u_y/sub11_syn_170  (
    .a({\u_y/o_t1 [25],\u_y/o_t1 [23]}),
    .b({\u_y/o_t1 [26],\u_y/o_t1 [24]}),
    .c(2'b11),
    .d({\u_y/o_s6 [25],\u_y/o_s6 [23]}),
    .e({\u_y/o_s6 [26],\u_y/o_s6 [24]}),
    .fci(\u_y/sub11_syn_154 ),
    .f({\u_y/block_out[0]_b19 [14],\u_y/block_out[0]_b19 [12]}),
    .fco(\u_y/sub11_syn_158 ),
    .fx({\u_y/block_out[0]_b19 [15],\u_y/block_out[0]_b19 [13]}));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
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
    \u_y/sub11_syn_171  (
    .a({\u_y/o_t1 [29],\u_y/o_t1 [27]}),
    .b({\u_y/o_t1 [30],\u_y/o_t1 [28]}),
    .c(2'b11),
    .d({\u_y/o_s6 [29],\u_y/o_s6 [27]}),
    .e({\u_y/o_s6 [30],\u_y/o_s6 [28]}),
    .fci(\u_y/sub11_syn_158 ),
    .f({\u_y/block_out[0]_b19 [18],\u_y/block_out[0]_b19 [16]}),
    .fco(\u_y/sub11_syn_162 ),
    .fx({\u_y/block_out[0]_b19 [19],\u_y/block_out[0]_b19 [17]}));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub11_syn_164"),
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
    \u_y/sub11_syn_172  (
    .a({open_n10023,\u_y/o_t1 [31]}),
    .c(2'b11),
    .d({open_n10028,\u_y/o_s6 [31]}),
    .fci(\u_y/sub11_syn_162 ),
    .f({open_n10045,\u_y/block_out[0]_b28 [31]}));  // ../src_v/jpeg_idct_y.v(360)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
    //.R_POSITION("X0Y0Z0"),
    .DEMUX0("E"),
    .DEMUX1("E"),
    .INIT_LUTF0(16'h0005),
    .INIT_LUTF1(16'hA55A),
    .INIT_LUTG0(16'hC33C),
    .INIT_LUTG1(16'hC33C),
    .LSFMUX0("SUM"),
    .LSFMUX1("SUM"),
    .LSFXMUX0("SUM"),
    .LSFXMUX1("SUM"),
    .MODE("RIPPLE"))
    \u_y/sub1_syn_164  (
    .a({\u_y/mul0_q [1],1'b0}),
    .b({\u_y/mul0_q [2],\u_y/mul0_q [0]}),
    .c(2'b11),
    .d({\u_y/mul1_q [1],1'b1}),
    .e({\u_y/mul1_q [2],\u_y/mul1_q [0]}),
    .f({\u_y/o_t0_b5 [1],open_n10068}),
    .fco(\u_y/sub1_syn_134 ),
    .fx({\u_y/o_t0_b5 [2],\u_y/o_t0_b5 [0]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
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
    \u_y/sub1_syn_165  (
    .a({\u_y/mul0_q [5],\u_y/mul0_q [3]}),
    .b({\u_y/mul0_q [6],\u_y/mul0_q [4]}),
    .c(2'b11),
    .d({\u_y/mul1_q [5],\u_y/mul1_q [3]}),
    .e({\u_y/mul1_q [6],\u_y/mul1_q [4]}),
    .fci(\u_y/sub1_syn_134 ),
    .f({\u_y/o_t0_b5 [5],\u_y/o_t0_b5 [3]}),
    .fco(\u_y/sub1_syn_138 ),
    .fx({\u_y/o_t0_b5 [6],\u_y/o_t0_b5 [4]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
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
    \u_y/sub1_syn_166  (
    .a({\u_y/mul0_q [9],\u_y/mul0_q [7]}),
    .b({\u_y/mul0_q [10],\u_y/mul0_q [8]}),
    .c(2'b11),
    .d({\u_y/mul1_q [9],\u_y/mul1_q [7]}),
    .e({\u_y/mul1_q [10],\u_y/mul1_q [8]}),
    .fci(\u_y/sub1_syn_138 ),
    .f({\u_y/o_t0_b5 [9],\u_y/o_t0_b5 [7]}),
    .fco(\u_y/sub1_syn_142 ),
    .fx({\u_y/o_t0_b5 [10],\u_y/o_t0_b5 [8]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
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
    \u_y/sub1_syn_167  (
    .a({\u_y/mul0_q [13],\u_y/mul0_q [11]}),
    .b({\u_y/mul0_q [14],\u_y/mul0_q [12]}),
    .c(2'b11),
    .d({\u_y/mul1_q [13],\u_y/mul1_q [11]}),
    .e({\u_y/mul1_q [14],\u_y/mul1_q [12]}),
    .fci(\u_y/sub1_syn_142 ),
    .f({\u_y/o_t0_b5 [13],\u_y/o_t0_b5 [11]}),
    .fco(\u_y/sub1_syn_146 ),
    .fx({\u_y/o_t0_b5 [14],\u_y/o_t0_b5 [12]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
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
    \u_y/sub1_syn_168  (
    .a({\u_y/mul0_q [17],\u_y/mul0_q [15]}),
    .b({\u_y/mul0_q [18],\u_y/mul0_q [16]}),
    .c(2'b11),
    .d({\u_y/mul1_q [17],\u_y/mul1_q [15]}),
    .e({\u_y/mul1_q [18],\u_y/mul1_q [16]}),
    .fci(\u_y/sub1_syn_146 ),
    .f({\u_y/o_t0_b5 [17],\u_y/o_t0_b5 [15]}),
    .fco(\u_y/sub1_syn_150 ),
    .fx({\u_y/o_t0_b5 [18],\u_y/o_t0_b5 [16]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
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
    \u_y/sub1_syn_169  (
    .a({\u_y/mul0_q [21],\u_y/mul0_q [19]}),
    .b({\u_y/mul0_q [22],\u_y/mul0_q [20]}),
    .c(2'b11),
    .d({\u_y/mul1_q [21],\u_y/mul1_q [19]}),
    .e({\u_y/mul1_q [22],\u_y/mul1_q [20]}),
    .fci(\u_y/sub1_syn_150 ),
    .f({\u_y/o_t0_b5 [21],\u_y/o_t0_b5 [19]}),
    .fco(\u_y/sub1_syn_154 ),
    .fx({\u_y/o_t0_b5 [22],\u_y/o_t0_b5 [20]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
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
    \u_y/sub1_syn_170  (
    .a({\u_y/mul0_q [25],\u_y/mul0_q [23]}),
    .b({\u_y/mul0_q [26],\u_y/mul0_q [24]}),
    .c(2'b11),
    .d({\u_y/mul1_q [25],\u_y/mul1_q [23]}),
    .e({\u_y/mul1_q [26],\u_y/mul1_q [24]}),
    .fci(\u_y/sub1_syn_154 ),
    .f({\u_y/o_t0_b5 [25],\u_y/o_t0_b5 [23]}),
    .fco(\u_y/sub1_syn_158 ),
    .fx({\u_y/o_t0_b5 [26],\u_y/o_t0_b5 [24]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
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
    \u_y/sub1_syn_171  (
    .a({\u_y/mul0_q [29],\u_y/mul0_q [27]}),
    .b({\u_y/mul0_q [30],\u_y/mul0_q [28]}),
    .c(2'b11),
    .d({\u_y/mul1_q [29],\u_y/mul1_q [27]}),
    .e({\u_y/mul1_q [30],\u_y/mul1_q [28]}),
    .fci(\u_y/sub1_syn_158 ),
    .f({\u_y/o_t0_b5 [29],\u_y/o_t0_b5 [27]}),
    .fco(\u_y/sub1_syn_162 ),
    .fx({\u_y/o_t0_b5 [30],\u_y/o_t0_b5 [28]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_LSLICE #(
    //.MACRO("u_y/sub1_syn_164"),
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
    \u_y/sub1_syn_172  (
    .a({open_n10197,\u_y/mul0_q [31]}),
    .c(2'b11),
    .d({open_n10202,\u_y/mul1_q [31]}),
    .fci(\u_y/sub1_syn_162 ),
    .f({open_n10219,\u_y/o_t0_b5 [31]}));  // ../src_v/jpeg_idct_y.v(282)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_199  (
    .a({\u_y/o_t6 [0],1'b0}),
    .b({\u_y/o_t5 [0],open_n10225}),
    .fco(\u_y/sub6_syn_132 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_202  (
    .a(\u_y/o_t6 [2:1]),
    .b(\u_y/o_t5 [2:1]),
    .fci(\u_y/sub6_syn_132 ),
    .f(\u_y/o_t6_5_b2 [2:1]),
    .fco(\u_y/sub6_syn_134 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_205  (
    .a(\u_y/o_t6 [4:3]),
    .b(\u_y/o_t5 [4:3]),
    .fci(\u_y/sub6_syn_134 ),
    .f(\u_y/o_t6_5_b2 [4:3]),
    .fco(\u_y/sub6_syn_136 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_208  (
    .a(\u_y/o_t6 [6:5]),
    .b(\u_y/o_t5 [6:5]),
    .fci(\u_y/sub6_syn_136 ),
    .f(\u_y/o_t6_5_b2 [6:5]),
    .fco(\u_y/sub6_syn_138 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_211  (
    .a(\u_y/o_t6 [8:7]),
    .b(\u_y/o_t5 [8:7]),
    .fci(\u_y/sub6_syn_138 ),
    .f(\u_y/o_t6_5_b2 [8:7]),
    .fco(\u_y/sub6_syn_140 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_214  (
    .a(\u_y/o_t6 [10:9]),
    .b(\u_y/o_t5 [10:9]),
    .fci(\u_y/sub6_syn_140 ),
    .f(\u_y/o_t6_5_b2 [10:9]),
    .fco(\u_y/sub6_syn_142 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_217  (
    .a(\u_y/o_t6 [12:11]),
    .b(\u_y/o_t5 [12:11]),
    .fci(\u_y/sub6_syn_142 ),
    .f(\u_y/o_t6_5_b2 [12:11]),
    .fco(\u_y/sub6_syn_144 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_220  (
    .a(\u_y/o_t6 [14:13]),
    .b(\u_y/o_t5 [14:13]),
    .fci(\u_y/sub6_syn_144 ),
    .f(\u_y/o_t6_5_b2 [14:13]),
    .fco(\u_y/sub6_syn_146 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_223  (
    .a(\u_y/o_t6 [16:15]),
    .b(\u_y/o_t5 [16:15]),
    .fci(\u_y/sub6_syn_146 ),
    .f(\u_y/o_t6_5_b2 [16:15]),
    .fco(\u_y/sub6_syn_148 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_226  (
    .a(\u_y/o_t6 [18:17]),
    .b(\u_y/o_t5 [18:17]),
    .fci(\u_y/sub6_syn_148 ),
    .f(\u_y/o_t6_5_b2 [18:17]),
    .fco(\u_y/sub6_syn_150 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y5Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_229  (
    .a(\u_y/o_t6 [20:19]),
    .b(\u_y/o_t5 [20:19]),
    .fci(\u_y/sub6_syn_150 ),
    .f(\u_y/o_t6_5_b2 [20:19]),
    .fco(\u_y/sub6_syn_152 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y5Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_232  (
    .a(\u_y/o_t6 [22:21]),
    .b(\u_y/o_t5 [22:21]),
    .fci(\u_y/sub6_syn_152 ),
    .f(\u_y/o_t6_5_b2 [22:21]),
    .fco(\u_y/sub6_syn_154 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y6Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_235  (
    .a(\u_y/o_t6 [24:23]),
    .b(\u_y/o_t5 [24:23]),
    .fci(\u_y/sub6_syn_154 ),
    .f(\u_y/o_t6_5_b2 [24:23]),
    .fco(\u_y/sub6_syn_156 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y6Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_238  (
    .a(\u_y/o_t6 [26:25]),
    .b(\u_y/o_t5 [26:25]),
    .fci(\u_y/sub6_syn_156 ),
    .f(\u_y/o_t6_5_b2 [26:25]),
    .fco(\u_y/sub6_syn_158 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y7Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_241  (
    .a(\u_y/o_t6 [28:27]),
    .b(\u_y/o_t5 [28:27]),
    .fci(\u_y/sub6_syn_158 ),
    .f(\u_y/o_t6_5_b2 [28:27]),
    .fco(\u_y/sub6_syn_160 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y7Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_244  (
    .a(\u_y/o_t6 [30:29]),
    .b(\u_y/o_t5 [30:29]),
    .fci(\u_y/sub6_syn_160 ),
    .f(\u_y/o_t6_5_b2 [30:29]),
    .fco(\u_y/sub6_syn_162 ));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub6_syn_199"),
    //.R_POSITION("X0Y8Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub6_syn_246  (
    .a({open_n10581,\u_y/o_t6 [31]}),
    .b({open_n10582,\u_y/o_t5 [31]}),
    .fci(\u_y/sub6_syn_162 ),
    .f({open_n10601,\u_y/o_t6_5_b2 [31]}));  // ../src_v/jpeg_idct_y.v(300)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub7_syn_178  (
    .a({\u_y/o_t0 [0],1'b0}),
    .b({\u_y/o_t7 [0],open_n10607}),
    .fco(\u_y/sub7_syn_132 ));  // ../src_v/jpeg_idct_y.v(347)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub7_syn_181  (
    .a(\u_y/o_t0 [2:1]),
    .b(\u_y/o_t7 [2:1]),
    .fci(\u_y/sub7_syn_132 ),
    .fco(\u_y/sub7_syn_134 ));  // ../src_v/jpeg_idct_y.v(347)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub7_syn_184  (
    .a(\u_y/o_t0 [4:3]),
    .b(\u_y/o_t7 [4:3]),
    .fci(\u_y/sub7_syn_134 ),
    .fco(\u_y/sub7_syn_136 ));  // ../src_v/jpeg_idct_y.v(347)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub7_syn_187  (
    .a(\u_y/o_t0 [6:5]),
    .b(\u_y/o_t7 [6:5]),
    .fci(\u_y/sub7_syn_136 ),
    .fco(\u_y/sub7_syn_138 ));  // ../src_v/jpeg_idct_y.v(347)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub7_syn_190  (
    .a(\u_y/o_t0 [8:7]),
    .b(\u_y/o_t7 [8:7]),
    .fci(\u_y/sub7_syn_138 ),
    .fco(\u_y/sub7_syn_140 ));  // ../src_v/jpeg_idct_y.v(347)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub7_syn_178"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub7_syn_193  (
    .a(\u_y/o_t0 [10:9]),
    .b(\u_y/o_t7 [10:9]),
    .fci(\u_y/sub7_syn_140 ),
    .fco(\u_y/sub7_syn_142 ));  // ../src_v/jpeg_idct_y.v(347)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("SUB_CARRY"),
    .INIT_LUT0(16'b0000000000000101),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub8_syn_178  (
    .a({\u_y/o_t3 [0],1'b0}),
    .b({\u_y/o_t4 [0],open_n10753}),
    .fco(\u_y/sub8_syn_132 ));  // ../src_v/jpeg_idct_y.v(349)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub8_syn_181  (
    .a(\u_y/o_t3 [2:1]),
    .b(\u_y/o_t4 [2:1]),
    .fci(\u_y/sub8_syn_132 ),
    .fco(\u_y/sub8_syn_134 ));  // ../src_v/jpeg_idct_y.v(349)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub8_syn_184  (
    .a(\u_y/o_t3 [4:3]),
    .b(\u_y/o_t4 [4:3]),
    .fci(\u_y/sub8_syn_134 ),
    .fco(\u_y/sub8_syn_136 ));  // ../src_v/jpeg_idct_y.v(349)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub8_syn_187  (
    .a(\u_y/o_t3 [6:5]),
    .b(\u_y/o_t4 [6:5]),
    .fci(\u_y/sub8_syn_136 ),
    .fco(\u_y/sub8_syn_138 ));  // ../src_v/jpeg_idct_y.v(349)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub8_syn_190  (
    .a(\u_y/o_t3 [8:7]),
    .b(\u_y/o_t4 [8:7]),
    .fci(\u_y/sub8_syn_138 ),
    .fco(\u_y/sub8_syn_140 ));  // ../src_v/jpeg_idct_y.v(349)
  EG_PHY_MSLICE #(
    //.MACRO("u_y/sub8_syn_178"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("SUB"),
    .INIT_LUT0(16'b1001100110011010),
    .INIT_LUT1(16'b1001100110011010),
    .MODE("RIPPLE"))
    \u_y/sub8_syn_193  (
    .a(\u_y/o_t3 [10:9]),
    .b(\u_y/o_t4 [10:9]),
    .fci(\u_y/sub8_syn_140 ),
    .fco(\u_y/sub8_syn_142 ));  // ../src_v/jpeg_idct_y.v(349)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/valid_q_reg[0]  (
    .clk(clk_i_dup_1),
    .d(\u_y/out_stg3_valid_q ),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/valid_q [0]));  // ../src_v/jpeg_idct_y.v(366)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/valid_q_reg[1]  (
    .clk(clk_i_dup_1),
    .d(\u_y/valid_q [0]),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/valid_q [1]));  // ../src_v/jpeg_idct_y.v(366)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/valid_q_reg[2]  (
    .clk(clk_i_dup_1),
    .d(\u_y/valid_q [1]),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/valid_q [2]));  // ../src_v/jpeg_idct_y.v(366)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/valid_q_reg[3]  (
    .clk(clk_i_dup_1),
    .d(\u_y/valid_q [2]),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/valid_q [3]));  // ../src_v/jpeg_idct_y.v(366)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/valid_q_reg[4]  (
    .clk(clk_i_dup_1),
    .d(\u_y/valid_q [3]),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/valid_q [4]));  // ../src_v/jpeg_idct_y.v(366)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/valid_q_reg[5]  (
    .clk(clk_i_dup_1),
    .d(\u_y/valid_q [4]),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(\u_y/valid_q [5]));  // ../src_v/jpeg_idct_y.v(366)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u_y/valid_q_reg[6]  (
    .clk(clk_i_dup_1),
    .d(\u_y/valid_q [5]),
    .sr(\u_y/mux43_syn_2 [5]),
    .q(outport_valid_o_dup_17));  // ../src_v/jpeg_idct_y.v(366)

endmodule 

