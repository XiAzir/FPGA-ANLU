// Verilog netlist created by Tang Dynasty v6.2.178840
// Fri Oct 16 18:29:24 2026

`timescale 1ns / 1ps
module sdram  // ../user_source/hdl_source/SD/sdram.v(12)
  (
  App_rd_addr,
  App_rd_en,
  App_wr_addr,
  App_wr_din,
  App_wr_dm,
  App_wr_en,
  Clk,
  Clk_sft,
  Rst,
  Sdr_busy,
  Sdr_init_done,
  Sdr_init_ref_vld,
  Sdr_rd_dout,
  Sdr_rd_en
  );

  input [20:0] App_rd_addr;  // ../user_source/hdl_source/SD/sdram.v(38)
  input App_rd_en /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(37)
  input [20:0] App_wr_addr;  // ../user_source/hdl_source/SD/sdram.v(33)
  input [31:0] App_wr_din;  // ../user_source/hdl_source/SD/sdram.v(35)
  input [3:0] App_wr_dm;  // ../user_source/hdl_source/SD/sdram.v(34)
  input App_wr_en;  // ../user_source/hdl_source/SD/sdram.v(32)
  input Clk;  // ../user_source/hdl_source/SD/sdram.v(24)
  input Clk_sft;  // ../user_source/hdl_source/SD/sdram.v(25)
  input Rst;  // ../user_source/hdl_source/SD/sdram.v(26)
  output Sdr_busy;  // ../user_source/hdl_source/SD/sdram.v(30)
  output Sdr_init_done;  // ../user_source/hdl_source/SD/sdram.v(28)
  output Sdr_init_ref_vld;  // ../user_source/hdl_source/SD/sdram.v(29)
  output [31:0] Sdr_rd_dout /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  output Sdr_rd_en;  // ../user_source/hdl_source/SD/sdram.v(39)

  wire [31:0] \u2_ram/Sdr_rd_dout  /* synthesis keep=true */ ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire [11:0] \u2_ram/u1_init_ref/Sdr_init_ref_addr ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(35)
  wire [17:0] \u2_ram/u1_init_ref/pwr_200ms_cnt ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(39)
  wire [17:0] \u2_ram/u1_init_ref/pwr_200ms_cnt_b1 ;
  wire [17:0] \u2_ram/u1_init_ref/pwr_200ms_cnt_b3 ;
  wire [31:0] \u2_ram/u1_init_ref/sdr_init_cnt ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(43)
  wire [19:0] \u2_ram/u1_init_ref/sdr_ref_ack_sft ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(46)
  wire [10:0] \u2_ram/u2_wrrd/SDR_ADDR_b ;
  wire [31:0] \u2_ram/u2_wrrd/Sdr_rd_dout  /* synthesis keep=true */ ;
  wire [1:0] \u2_ram/u2_wrrd/active_ba ;
  wire [1:0] \u2_ram/u2_wrrd/active_ba_b1 ;
  wire [7:0] \u2_ram/u2_wrrd/active_col ;
  wire [7:0] \u2_ram/u2_wrrd/active_col_b1 ;
  wire [10:0] \u2_ram/u2_wrrd/active_row ;
  wire [10:0] \u2_ram/u2_wrrd/active_row_b1 ;
  wire [10:0] \u2_ram/u2_wrrd/addr ;
  wire [10:0] \u2_ram/u2_wrrd/addr_b ;
  wire [20:0] \u2_ram/u2_wrrd/app_rd_addr_1d ;
  wire [20:0] \u2_ram/u2_wrrd/app_rd_addr_2d ;
  wire [20:0] \u2_ram/u2_wrrd/app_rd_addr_3d ;
  wire [20:0] \u2_ram/u2_wrrd/app_rd_addr_4d ;
  wire [10:0] \u2_ram/u2_wrrd/app_rd_en_sft ;
  wire [20:0] \u2_ram/u2_wrrd/app_wr_addr_1d ;
  wire [20:0] \u2_ram/u2_wrrd/app_wr_addr_2d ;
  wire [20:0] \u2_ram/u2_wrrd/app_wr_addr_3d ;
  wire [20:0] \u2_ram/u2_wrrd/app_wr_addr_4d ;
  wire [31:0] \u2_ram/u2_wrrd/app_wr_din_1d ;
  wire [31:0] \u2_ram/u2_wrrd/app_wr_din_2d ;
  wire [31:0] \u2_ram/u2_wrrd/app_wr_din_3d ;
  wire [31:0] \u2_ram/u2_wrrd/app_wr_din_4d ;
  wire [31:0] \u2_ram/u2_wrrd/app_wr_din_5d ;
  wire [31:0] \u2_ram/u2_wrrd/app_wr_din_6d ;
  wire [3:0] \u2_ram/u2_wrrd/app_wr_dm_1d ;
  wire [3:0] \u2_ram/u2_wrrd/app_wr_dm_2d ;
  wire [3:0] \u2_ram/u2_wrrd/app_wr_dm_3d ;
  wire [3:0] \u2_ram/u2_wrrd/app_wr_dm_4d ;
  wire [3:0] \u2_ram/u2_wrrd/app_wr_dm_5d ;
  wire [3:0] \u2_ram/u2_wrrd/app_wr_dm_6d ;
  wire [7:0] \u2_ram/u2_wrrd/app_wr_en_sft ;
  wire [1:0] \u2_ram/u2_wrrd/ba ;
  wire [1:0] \u2_ram/u2_wrrd/cnt4 ;
  wire [7:0] \u2_ram/u2_wrrd/mux1_syn_2 ;
  wire [1:0] \u2_ram/u2_wrrd/mux21_syn_2 ;
  wire [10:0] \u2_ram/u2_wrrd/mux4_syn_2 ;
  wire [2:0] \u2_ram/u2_wrrd/mux9_syn_1 ;
  wire [2:0] \u2_ram/u2_wrrd/sel2_syn_1 ;
  wire [2:0] \u2_ram/u2_wrrd/state_reg_syn_1 ;
  wire App_rd_en_dup_3 /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(37)
  wire App_wr_en_dup_5;  // ../user_source/hdl_source/SD/sdram.v(32)
  wire Clk_dup_1;  // ../user_source/hdl_source/SD/sdram.v(24)
  wire Clk_sft_dup_1;  // ../user_source/hdl_source/SD/sdram.v(25)
  wire Rst_dup_175;  // ../user_source/hdl_source/SD/sdram.v(26)
  wire SDRAM_CLK;  // ../user_source/hdl_source/SD/sdram.v(46)
  wire Sdr_init_ref_vld_dup_1;  // ../user_source/hdl_source/SD/sdram.v(29)
  wire \Sdr_rd_dout[31]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[30]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[29]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[28]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[27]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[26]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[25]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[24]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[23]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[22]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[21]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[20]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[19]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[18]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[17]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[16]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[15]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[14]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[13]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[12]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[11]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[10]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[9]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[8]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[7]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[6]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[5]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[4]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[3]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[2]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[1]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \Sdr_rd_dout[0]_dup_3  /* synthesis keep=true */ ;  // ../user_source/hdl_source/SD/sdram.v(40)
  wire \u2_ram/SDRAM_CLK  /* synthesis keep=true */ ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(35)
  wire \u2_ram/Sdr_rd_dout[31]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[30]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[29]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[28]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[27]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[26]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[25]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[24]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[23]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[22]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[21]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[20]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[19]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[18]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[17]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[16]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[15]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[14]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[13]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[12]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[11]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[10]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[9]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[8]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[7]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[6]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[5]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[4]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[3]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[2]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[1]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/Sdr_rd_dout[0]_syn_4 ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  wire \u2_ram/App_rd_en ;  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(29)
  wire \u2_ram/u1_init_ref/add1_syn_94 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u2_ram/u1_init_ref/add1_syn_98 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u2_ram/u1_init_ref/add1_syn_102 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u2_ram/u1_init_ref/add1_syn_106 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  wire \u2_ram/u1_init_ref/cas_reg_syn_3 ;
  wire \u2_ram/u1_init_ref/cas_reg_syn_5 ;
  wire \u2_ram/u1_init_ref/init_vld_reg_syn_5 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(78)
  wire \u2_ram/u1_init_ref/ras_reg_syn_3 ;
  wire \u2_ram/u1_init_ref/ras_reg_syn_5 ;
  wire \u2_ram/u1_init_ref/ras_reg_syn_7 ;
  wire \u2_ram/u1_init_ref/ref_vld_reg_syn_5 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(122)
  wire \u2_ram/u1_init_ref/ref_vld_reg_syn_7 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(122)
  wire \u2_ram/u1_init_ref/we_reg_syn_3 ;
  wire \u2_ram/u1_init_ref/pwr_200ms_cnt[0]_syn_2 ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(39)
  wire \u2_ram/u1_init_ref/Sdr_init_ref_cas ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(32)
  wire \u2_ram/u1_init_ref/Sdr_init_ref_ras ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(31)
  wire \u2_ram/u1_init_ref/Sdr_init_ref_we ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(33)
  wire \u2_ram/u1_init_ref/Sdr_ref_ack ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(27)
  wire \u2_ram/u1_init_ref/init_done_n2 ;
  wire \u2_ram/u1_init_ref/init_vld ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(44)
  wire \u2_ram/u1_init_ref/power_up_200ms_1d ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(40)
  wire \u2_ram/u1_init_ref/power_up_200ms_2d ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(40)
  wire \u2_ram/u1_init_ref/power_up_en ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(40)
  wire \u2_ram/u1_init_ref/power_up_en_n ;
  wire \u2_ram/u1_init_ref/ref_vld ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(47)
  wire \u2_ram/u1_init_ref/sdr_init_en ;  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(42)
  wire \u2_ram/u2_wrrd/active_en_reg_syn_3 ;
  wire \u2_ram/u2_wrrd/cas_reg_syn_3 ;
  wire \u2_ram/u2_wrrd/col_en_reg_syn_3 ;
  wire \u2_ram/u2_wrrd/ref_ack_reg_syn_3 ;
  wire \u2_ram/u2_wrrd/ref_vld_reg_syn_5 ;
  wire \u2_ram/u2_wrrd/rw_vld_reg_syn_5 ;
  wire \u2_ram/u2_wrrd/rw_vld_reg_syn_7 ;
  wire \u2_ram/u2_wrrd/sdr_t_reg_syn_5 ;
  wire \u2_ram/u2_wrrd/sdr_t_reg_syn_7 ;
  wire \u2_ram/u2_wrrd/sel2_syn_92 ;
  wire \u2_ram/u2_wrrd/sel2_syn_94 ;
  wire \u2_ram/u2_wrrd/sel2_syn_97 ;
  wire \u2_ram/u2_wrrd/sel2_syn_99 ;
  wire \u2_ram/u2_wrrd/we_reg_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[31]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[31]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[30]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[30]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[29]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[29]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[28]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[28]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[27]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[27]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[26]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[26]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[25]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[25]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[24]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[24]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[23]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[23]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[22]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[22]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[21]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[21]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[20]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[20]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[19]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[19]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[18]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[18]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[17]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[17]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[16]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[16]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[15]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[15]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[14]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[14]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[13]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[13]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[12]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[12]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[11]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[11]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[10]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[10]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[9]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[9]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[8]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[8]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[7]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[7]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[6]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[6]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[5]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[5]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[4]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[4]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[3]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[3]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[2]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[2]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[1]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[1]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[0]_syn_3 ;
  wire \u2_ram/u2_wrrd/Sdr_rd_dout[0]_syn_4 ;
  wire \u2_ram/u2_wrrd/Sdr_ref_req  /* synthesis keep=true */ ;
  wire \u2_ram/u2_wrrd/Sdr_ref_req_syn_4 ;
  wire \u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ;
  wire \u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ;
  wire \u2_ram/u2_wrrd/SDR_CAS_n ;
  wire \u2_ram/u2_wrrd/SDR_RAS_n ;
  wire \u2_ram/u2_wrrd/SDR_WE_n ;
  wire \u2_ram/u2_wrrd/Sdr_busy_n4 ;
  wire \u2_ram/u2_wrrd/Sdr_ref_ack_n ;
  wire \u2_ram/u2_wrrd/active_en ;
  wire \u2_ram/u2_wrrd/active_en_syn_2 ;
  wire \u2_ram/u2_wrrd/cas ;
  wire \u2_ram/u2_wrrd/col_en ;
  wire \u2_ram/u2_wrrd/init_ref_vld_1d ;
  wire \u2_ram/u2_wrrd/ras ;
  wire \u2_ram/u2_wrrd/ref_ack ;
  wire \u2_ram/u2_wrrd/ref_over ;
  wire \u2_ram/u2_wrrd/ref_over_n ;
  wire \u2_ram/u2_wrrd/ref_vld ;
  wire \u2_ram/u2_wrrd/rw_vld ;
  wire \u2_ram/u2_wrrd/rw_vld_1d ;
  wire \u2_ram/u2_wrrd/sdr_op_over ;
  wire \u2_ram/u2_wrrd/sdr_op_over_n ;
  wire \u2_ram/u2_wrrd/sdr_t ;
  wire \u2_ram/u2_wrrd/we ;
  wire \u2_ram/u2_wrrd/wrrd_ref_ack ;
  wire \u2_ram/u1_init_ref/ad_reg[1]_syn_4 ;
  wire \u2_ram/u1_init_ref/ad_reg[10]_syn_4 ;
  wire \u2_ram/u2_wrrd/addr_reg[8]_syn_2 ;
  wire \u2_ram/u2_wrrd/addr_reg[9]_syn_2 ;
  wire \u2_ram/u2_wrrd/ba_reg[0]_syn_2 ;
  wire \u2_ram/u2_wrrd/ba_reg[1]_syn_2 ;
  wire \u2_ram/u2_wrrd/cnt4_reg[0]_syn_2 ;
  wire \u2_ram/u2_wrrd/cnt4_reg[0]_syn_4 ;
  wire \u2_ram/u2_wrrd/cnt4_reg[1]_syn_2 ;
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
  wire clk;
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

  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[0]_syn_6  (
    .ipad(App_rd_addr[0]),
    .ipclk(Clk_dup_1),
    .diq({open_n11,open_n12,open_n13,\u2_ram/u2_wrrd/app_rd_addr_1d [0]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[10]_syn_6  (
    .ipad(App_rd_addr[10]),
    .ipclk(Clk_dup_1),
    .diq({open_n27,open_n28,open_n29,\u2_ram/u2_wrrd/app_rd_addr_1d [10]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[11]_syn_6  (
    .ipad(App_rd_addr[11]),
    .ipclk(Clk_dup_1),
    .diq({open_n43,open_n44,open_n45,\u2_ram/u2_wrrd/app_rd_addr_1d [11]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[12]_syn_6  (
    .ipad(App_rd_addr[12]),
    .ipclk(Clk_dup_1),
    .diq({open_n59,open_n60,open_n61,\u2_ram/u2_wrrd/app_rd_addr_1d [12]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[13]_syn_6  (
    .ipad(App_rd_addr[13]),
    .ipclk(Clk_dup_1),
    .diq({open_n75,open_n76,open_n77,\u2_ram/u2_wrrd/app_rd_addr_1d [13]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[14]_syn_6  (
    .ipad(App_rd_addr[14]),
    .ipclk(Clk_dup_1),
    .diq({open_n91,open_n92,open_n93,\u2_ram/u2_wrrd/app_rd_addr_1d [14]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[15]_syn_6  (
    .ipad(App_rd_addr[15]),
    .ipclk(Clk_dup_1),
    .diq({open_n107,open_n108,open_n109,\u2_ram/u2_wrrd/app_rd_addr_1d [15]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[16]_syn_6  (
    .ipad(App_rd_addr[16]),
    .ipclk(Clk_dup_1),
    .diq({open_n123,open_n124,open_n125,\u2_ram/u2_wrrd/app_rd_addr_1d [16]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[17]_syn_6  (
    .ipad(App_rd_addr[17]),
    .ipclk(Clk_dup_1),
    .diq({open_n139,open_n140,open_n141,\u2_ram/u2_wrrd/app_rd_addr_1d [17]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[18]_syn_6  (
    .ipad(App_rd_addr[18]),
    .ipclk(Clk_dup_1),
    .diq({open_n155,open_n156,open_n157,\u2_ram/u2_wrrd/app_rd_addr_1d [18]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[19]_syn_6  (
    .ipad(App_rd_addr[19]),
    .ipclk(Clk_dup_1),
    .diq({open_n171,open_n172,open_n173,\u2_ram/u2_wrrd/app_rd_addr_1d [19]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[1]_syn_6  (
    .ipad(App_rd_addr[1]),
    .ipclk(Clk_dup_1),
    .diq({open_n187,open_n188,open_n189,\u2_ram/u2_wrrd/app_rd_addr_1d [1]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[20]_syn_6  (
    .ipad(App_rd_addr[20]),
    .ipclk(Clk_dup_1),
    .diq({open_n203,open_n204,open_n205,\u2_ram/u2_wrrd/app_rd_addr_1d [20]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[2]_syn_6  (
    .ipad(App_rd_addr[2]),
    .ipclk(Clk_dup_1),
    .diq({open_n219,open_n220,open_n221,\u2_ram/u2_wrrd/app_rd_addr_1d [2]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[3]_syn_6  (
    .ipad(App_rd_addr[3]),
    .ipclk(Clk_dup_1),
    .diq({open_n235,open_n236,open_n237,\u2_ram/u2_wrrd/app_rd_addr_1d [3]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[4]_syn_6  (
    .ipad(App_rd_addr[4]),
    .ipclk(Clk_dup_1),
    .diq({open_n251,open_n252,open_n253,\u2_ram/u2_wrrd/app_rd_addr_1d [4]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[5]_syn_6  (
    .ipad(App_rd_addr[5]),
    .ipclk(Clk_dup_1),
    .diq({open_n267,open_n268,open_n269,\u2_ram/u2_wrrd/app_rd_addr_1d [5]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[6]_syn_6  (
    .ipad(App_rd_addr[6]),
    .ipclk(Clk_dup_1),
    .diq({open_n283,open_n284,open_n285,\u2_ram/u2_wrrd/app_rd_addr_1d [6]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[7]_syn_6  (
    .ipad(App_rd_addr[7]),
    .ipclk(Clk_dup_1),
    .diq({open_n299,open_n300,open_n301,\u2_ram/u2_wrrd/app_rd_addr_1d [7]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[8]_syn_6  (
    .ipad(App_rd_addr[8]),
    .ipclk(Clk_dup_1),
    .diq({open_n315,open_n316,open_n317,\u2_ram/u2_wrrd/app_rd_addr_1d [8]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_rd_addr[9]_syn_6  (
    .ipad(App_rd_addr[9]),
    .ipclk(Clk_dup_1),
    .diq({open_n331,open_n332,open_n333,\u2_ram/u2_wrrd/app_rd_addr_1d [9]}));  // ../user_source/hdl_source/SD/sdram.v(38)
  buf App_rd_en_syn_1 (\u2_ram/App_rd_en , App_rd_en_dup_3);  // ../user_source/hdl_source/SD/sdram.v(37)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    App_rd_en_syn_4 (
    .ipad(App_rd_en),
    .di(App_rd_en_dup_3));  // ../user_source/hdl_source/SD/sdram.v(37)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[0]_syn_6  (
    .ipad(App_wr_addr[0]),
    .ipclk(Clk_dup_1),
    .diq({open_n364,open_n365,open_n366,\u2_ram/u2_wrrd/app_wr_addr_1d [0]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[10]_syn_6  (
    .ipad(App_wr_addr[10]),
    .ipclk(Clk_dup_1),
    .diq({open_n380,open_n381,open_n382,\u2_ram/u2_wrrd/app_wr_addr_1d [10]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[11]_syn_6  (
    .ipad(App_wr_addr[11]),
    .ipclk(Clk_dup_1),
    .diq({open_n396,open_n397,open_n398,\u2_ram/u2_wrrd/app_wr_addr_1d [11]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[12]_syn_6  (
    .ipad(App_wr_addr[12]),
    .ipclk(Clk_dup_1),
    .diq({open_n412,open_n413,open_n414,\u2_ram/u2_wrrd/app_wr_addr_1d [12]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[13]_syn_6  (
    .ipad(App_wr_addr[13]),
    .ipclk(Clk_dup_1),
    .diq({open_n428,open_n429,open_n430,\u2_ram/u2_wrrd/app_wr_addr_1d [13]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[14]_syn_6  (
    .ipad(App_wr_addr[14]),
    .ipclk(Clk_dup_1),
    .diq({open_n444,open_n445,open_n446,\u2_ram/u2_wrrd/app_wr_addr_1d [14]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[15]_syn_6  (
    .ipad(App_wr_addr[15]),
    .ipclk(Clk_dup_1),
    .diq({open_n460,open_n461,open_n462,\u2_ram/u2_wrrd/app_wr_addr_1d [15]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[16]_syn_6  (
    .ipad(App_wr_addr[16]),
    .ipclk(Clk_dup_1),
    .diq({open_n476,open_n477,open_n478,\u2_ram/u2_wrrd/app_wr_addr_1d [16]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[17]_syn_6  (
    .ipad(App_wr_addr[17]),
    .ipclk(Clk_dup_1),
    .diq({open_n492,open_n493,open_n494,\u2_ram/u2_wrrd/app_wr_addr_1d [17]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[18]_syn_6  (
    .ipad(App_wr_addr[18]),
    .ipclk(Clk_dup_1),
    .diq({open_n508,open_n509,open_n510,\u2_ram/u2_wrrd/app_wr_addr_1d [18]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[19]_syn_6  (
    .ipad(App_wr_addr[19]),
    .ipclk(Clk_dup_1),
    .diq({open_n524,open_n525,open_n526,\u2_ram/u2_wrrd/app_wr_addr_1d [19]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[1]_syn_6  (
    .ipad(App_wr_addr[1]),
    .ipclk(Clk_dup_1),
    .diq({open_n540,open_n541,open_n542,\u2_ram/u2_wrrd/app_wr_addr_1d [1]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[20]_syn_6  (
    .ipad(App_wr_addr[20]),
    .ipclk(Clk_dup_1),
    .diq({open_n556,open_n557,open_n558,\u2_ram/u2_wrrd/app_wr_addr_1d [20]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[2]_syn_6  (
    .ipad(App_wr_addr[2]),
    .ipclk(Clk_dup_1),
    .diq({open_n572,open_n573,open_n574,\u2_ram/u2_wrrd/app_wr_addr_1d [2]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[3]_syn_6  (
    .ipad(App_wr_addr[3]),
    .ipclk(Clk_dup_1),
    .diq({open_n588,open_n589,open_n590,\u2_ram/u2_wrrd/app_wr_addr_1d [3]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[4]_syn_6  (
    .ipad(App_wr_addr[4]),
    .ipclk(Clk_dup_1),
    .diq({open_n604,open_n605,open_n606,\u2_ram/u2_wrrd/app_wr_addr_1d [4]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[5]_syn_6  (
    .ipad(App_wr_addr[5]),
    .ipclk(Clk_dup_1),
    .diq({open_n620,open_n621,open_n622,\u2_ram/u2_wrrd/app_wr_addr_1d [5]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[6]_syn_6  (
    .ipad(App_wr_addr[6]),
    .ipclk(Clk_dup_1),
    .diq({open_n636,open_n637,open_n638,\u2_ram/u2_wrrd/app_wr_addr_1d [6]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[7]_syn_6  (
    .ipad(App_wr_addr[7]),
    .ipclk(Clk_dup_1),
    .diq({open_n652,open_n653,open_n654,\u2_ram/u2_wrrd/app_wr_addr_1d [7]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[8]_syn_6  (
    .ipad(App_wr_addr[8]),
    .ipclk(Clk_dup_1),
    .diq({open_n668,open_n669,open_n670,\u2_ram/u2_wrrd/app_wr_addr_1d [8]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_addr[9]_syn_6  (
    .ipad(App_wr_addr[9]),
    .ipclk(Clk_dup_1),
    .diq({open_n684,open_n685,open_n686,\u2_ram/u2_wrrd/app_wr_addr_1d [9]}));  // ../user_source/hdl_source/SD/sdram.v(33)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[0]_syn_6  (
    .ipad(App_wr_din[0]),
    .ipclk(Clk_dup_1),
    .diq({open_n700,open_n701,open_n702,\u2_ram/u2_wrrd/app_wr_din_1d [0]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[10]_syn_6  (
    .ipad(App_wr_din[10]),
    .ipclk(Clk_dup_1),
    .diq({open_n716,open_n717,open_n718,\u2_ram/u2_wrrd/app_wr_din_1d [10]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[11]_syn_6  (
    .ipad(App_wr_din[11]),
    .ipclk(Clk_dup_1),
    .diq({open_n732,open_n733,open_n734,\u2_ram/u2_wrrd/app_wr_din_1d [11]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[12]_syn_6  (
    .ipad(App_wr_din[12]),
    .ipclk(Clk_dup_1),
    .diq({open_n748,open_n749,open_n750,\u2_ram/u2_wrrd/app_wr_din_1d [12]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[13]_syn_6  (
    .ipad(App_wr_din[13]),
    .ipclk(Clk_dup_1),
    .diq({open_n764,open_n765,open_n766,\u2_ram/u2_wrrd/app_wr_din_1d [13]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[14]_syn_6  (
    .ipad(App_wr_din[14]),
    .ipclk(Clk_dup_1),
    .diq({open_n780,open_n781,open_n782,\u2_ram/u2_wrrd/app_wr_din_1d [14]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[15]_syn_6  (
    .ipad(App_wr_din[15]),
    .ipclk(Clk_dup_1),
    .diq({open_n796,open_n797,open_n798,\u2_ram/u2_wrrd/app_wr_din_1d [15]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[16]_syn_6  (
    .ipad(App_wr_din[16]),
    .ipclk(Clk_dup_1),
    .diq({open_n812,open_n813,open_n814,\u2_ram/u2_wrrd/app_wr_din_1d [16]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[17]_syn_6  (
    .ipad(App_wr_din[17]),
    .ipclk(Clk_dup_1),
    .diq({open_n828,open_n829,open_n830,\u2_ram/u2_wrrd/app_wr_din_1d [17]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[18]_syn_6  (
    .ipad(App_wr_din[18]),
    .ipclk(Clk_dup_1),
    .diq({open_n844,open_n845,open_n846,\u2_ram/u2_wrrd/app_wr_din_1d [18]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[19]_syn_6  (
    .ipad(App_wr_din[19]),
    .ipclk(Clk_dup_1),
    .diq({open_n860,open_n861,open_n862,\u2_ram/u2_wrrd/app_wr_din_1d [19]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[1]_syn_6  (
    .ipad(App_wr_din[1]),
    .ipclk(Clk_dup_1),
    .diq({open_n876,open_n877,open_n878,\u2_ram/u2_wrrd/app_wr_din_1d [1]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[20]_syn_6  (
    .ipad(App_wr_din[20]),
    .ipclk(Clk_dup_1),
    .diq({open_n892,open_n893,open_n894,\u2_ram/u2_wrrd/app_wr_din_1d [20]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[21]_syn_6  (
    .ipad(App_wr_din[21]),
    .ipclk(Clk_dup_1),
    .diq({open_n908,open_n909,open_n910,\u2_ram/u2_wrrd/app_wr_din_1d [21]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[22]_syn_6  (
    .ipad(App_wr_din[22]),
    .ipclk(Clk_dup_1),
    .diq({open_n924,open_n925,open_n926,\u2_ram/u2_wrrd/app_wr_din_1d [22]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[23]_syn_6  (
    .ipad(App_wr_din[23]),
    .ipclk(Clk_dup_1),
    .diq({open_n940,open_n941,open_n942,\u2_ram/u2_wrrd/app_wr_din_1d [23]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[24]_syn_6  (
    .ipad(App_wr_din[24]),
    .ipclk(Clk_dup_1),
    .diq({open_n956,open_n957,open_n958,\u2_ram/u2_wrrd/app_wr_din_1d [24]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[25]_syn_6  (
    .ipad(App_wr_din[25]),
    .ipclk(Clk_dup_1),
    .diq({open_n972,open_n973,open_n974,\u2_ram/u2_wrrd/app_wr_din_1d [25]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[26]_syn_6  (
    .ipad(App_wr_din[26]),
    .ipclk(Clk_dup_1),
    .diq({open_n988,open_n989,open_n990,\u2_ram/u2_wrrd/app_wr_din_1d [26]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[27]_syn_6  (
    .ipad(App_wr_din[27]),
    .ipclk(Clk_dup_1),
    .diq({open_n1004,open_n1005,open_n1006,\u2_ram/u2_wrrd/app_wr_din_1d [27]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[28]_syn_6  (
    .ipad(App_wr_din[28]),
    .ipclk(Clk_dup_1),
    .diq({open_n1020,open_n1021,open_n1022,\u2_ram/u2_wrrd/app_wr_din_1d [28]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[29]_syn_6  (
    .ipad(App_wr_din[29]),
    .ipclk(Clk_dup_1),
    .diq({open_n1036,open_n1037,open_n1038,\u2_ram/u2_wrrd/app_wr_din_1d [29]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[2]_syn_6  (
    .ipad(App_wr_din[2]),
    .ipclk(Clk_dup_1),
    .diq({open_n1052,open_n1053,open_n1054,\u2_ram/u2_wrrd/app_wr_din_1d [2]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[30]_syn_6  (
    .ipad(App_wr_din[30]),
    .ipclk(Clk_dup_1),
    .diq({open_n1068,open_n1069,open_n1070,\u2_ram/u2_wrrd/app_wr_din_1d [30]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[31]_syn_6  (
    .ipad(App_wr_din[31]),
    .ipclk(Clk_dup_1),
    .diq({open_n1084,open_n1085,open_n1086,\u2_ram/u2_wrrd/app_wr_din_1d [31]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[3]_syn_6  (
    .ipad(App_wr_din[3]),
    .ipclk(Clk_dup_1),
    .diq({open_n1100,open_n1101,open_n1102,\u2_ram/u2_wrrd/app_wr_din_1d [3]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[4]_syn_6  (
    .ipad(App_wr_din[4]),
    .ipclk(Clk_dup_1),
    .diq({open_n1116,open_n1117,open_n1118,\u2_ram/u2_wrrd/app_wr_din_1d [4]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[5]_syn_6  (
    .ipad(App_wr_din[5]),
    .ipclk(Clk_dup_1),
    .diq({open_n1132,open_n1133,open_n1134,\u2_ram/u2_wrrd/app_wr_din_1d [5]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[6]_syn_6  (
    .ipad(App_wr_din[6]),
    .ipclk(Clk_dup_1),
    .diq({open_n1148,open_n1149,open_n1150,\u2_ram/u2_wrrd/app_wr_din_1d [6]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[7]_syn_6  (
    .ipad(App_wr_din[7]),
    .ipclk(Clk_dup_1),
    .diq({open_n1164,open_n1165,open_n1166,\u2_ram/u2_wrrd/app_wr_din_1d [7]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[8]_syn_6  (
    .ipad(App_wr_din[8]),
    .ipclk(Clk_dup_1),
    .diq({open_n1180,open_n1181,open_n1182,\u2_ram/u2_wrrd/app_wr_din_1d [8]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_din[9]_syn_6  (
    .ipad(App_wr_din[9]),
    .ipclk(Clk_dup_1),
    .diq({open_n1196,open_n1197,open_n1198,\u2_ram/u2_wrrd/app_wr_din_1d [9]}));  // ../user_source/hdl_source/SD/sdram.v(35)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_dm[0]_syn_6  (
    .ipad(App_wr_dm[0]),
    .ipclk(Clk_dup_1),
    .diq({open_n1212,open_n1213,open_n1214,\u2_ram/u2_wrrd/app_wr_dm_1d [0]}));  // ../user_source/hdl_source/SD/sdram.v(34)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_dm[1]_syn_6  (
    .ipad(App_wr_dm[1]),
    .ipclk(Clk_dup_1),
    .diq({open_n1228,open_n1229,open_n1230,\u2_ram/u2_wrrd/app_wr_dm_1d [1]}));  // ../user_source/hdl_source/SD/sdram.v(34)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_dm[2]_syn_6  (
    .ipad(App_wr_dm[2]),
    .ipclk(Clk_dup_1),
    .diq({open_n1244,open_n1245,open_n1246,\u2_ram/u2_wrrd/app_wr_dm_1d [2]}));  // ../user_source/hdl_source/SD/sdram.v(34)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .SRMODE("ASYNC"),
    .TSMUX("1"))
    \App_wr_dm[3]_syn_6  (
    .ipad(App_wr_dm[3]),
    .ipclk(Clk_dup_1),
    .diq({open_n1260,open_n1261,open_n1262,\u2_ram/u2_wrrd/app_wr_dm_1d [3]}));  // ../user_source/hdl_source/SD/sdram.v(34)
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
    App_wr_en_syn_6 (
    .ipad(App_wr_en),
    .ipclk(Clk_dup_1),
    .rst(Rst_dup_175),
    .di(App_wr_en_dup_5),
    .diq({open_n1274,open_n1275,open_n1276,\u2_ram/u2_wrrd/app_wr_en_sft [0]}));  // ../user_source/hdl_source/SD/sdram.v(32)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    Clk_sft_syn_2 (
    .ipad(Clk_sft),
    .di(Clk_sft_dup_1));  // ../user_source/hdl_source/SD/sdram.v(25)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    Clk_syn_2 (
    .ipad(Clk),
    .di(Clk_dup_1));  // ../user_source/hdl_source/SD/sdram.v(24)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    Rst_syn_176 (
    .ipad(Rst),
    .di(Rst_dup_175));  // ../user_source/hdl_source/SD/sdram.v(26)
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
    Sdr_busy_syn_6 (
    .do({open_n1331,open_n1332,open_n1333,\u2_ram/u2_wrrd/Sdr_busy_n4 }),
    .osclk(Clk_dup_1),
    .rst(Rst_dup_175),
    .opad(Sdr_busy));  // ../user_source/hdl_source/SD/sdram.v(30)
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
    Sdr_init_done_syn_6 (
    .ce(\u2_ram/u1_init_ref/sdr_init_cnt [30]),
    .do({open_n1345,open_n1346,open_n1347,1'b1}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u1_init_ref/init_done_n2 ),
    .opad(Sdr_init_done));  // ../user_source/hdl_source/SD/sdram.v(28)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    Sdr_init_ref_vld_syn_2 (
    .do({open_n1360,open_n1361,open_n1362,Sdr_init_ref_vld_dup_1}),
    .opad(Sdr_init_ref_vld));  // ../user_source/hdl_source/SD/sdram.v(29)
  buf \Sdr_rd_dout[0]_syn_1  (\Sdr_rd_dout[0]_dup_3 , \u2_ram/Sdr_rd_dout[0]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[0]_syn_4  (
    .do({open_n1377,open_n1378,open_n1379,\Sdr_rd_dout[0]_dup_3 }),
    .opad(Sdr_rd_dout[0]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[10]_syn_1  (\Sdr_rd_dout[10]_dup_3 , \u2_ram/Sdr_rd_dout[10]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[10]_syn_4  (
    .do({open_n1394,open_n1395,open_n1396,\Sdr_rd_dout[10]_dup_3 }),
    .opad(Sdr_rd_dout[10]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[11]_syn_1  (\Sdr_rd_dout[11]_dup_3 , \u2_ram/Sdr_rd_dout[11]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[11]_syn_4  (
    .do({open_n1411,open_n1412,open_n1413,\Sdr_rd_dout[11]_dup_3 }),
    .opad(Sdr_rd_dout[11]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[12]_syn_1  (\Sdr_rd_dout[12]_dup_3 , \u2_ram/Sdr_rd_dout[12]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[12]_syn_4  (
    .do({open_n1428,open_n1429,open_n1430,\Sdr_rd_dout[12]_dup_3 }),
    .opad(Sdr_rd_dout[12]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[13]_syn_1  (\Sdr_rd_dout[13]_dup_3 , \u2_ram/Sdr_rd_dout[13]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[13]_syn_4  (
    .do({open_n1445,open_n1446,open_n1447,\Sdr_rd_dout[13]_dup_3 }),
    .opad(Sdr_rd_dout[13]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[14]_syn_1  (\Sdr_rd_dout[14]_dup_3 , \u2_ram/Sdr_rd_dout[14]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[14]_syn_4  (
    .do({open_n1462,open_n1463,open_n1464,\Sdr_rd_dout[14]_dup_3 }),
    .opad(Sdr_rd_dout[14]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[15]_syn_1  (\Sdr_rd_dout[15]_dup_3 , \u2_ram/Sdr_rd_dout[15]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[15]_syn_4  (
    .do({open_n1479,open_n1480,open_n1481,\Sdr_rd_dout[15]_dup_3 }),
    .opad(Sdr_rd_dout[15]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[16]_syn_1  (\Sdr_rd_dout[16]_dup_3 , \u2_ram/Sdr_rd_dout[16]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[16]_syn_4  (
    .do({open_n1496,open_n1497,open_n1498,\Sdr_rd_dout[16]_dup_3 }),
    .opad(Sdr_rd_dout[16]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[17]_syn_1  (\Sdr_rd_dout[17]_dup_3 , \u2_ram/Sdr_rd_dout[17]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[17]_syn_4  (
    .do({open_n1513,open_n1514,open_n1515,\Sdr_rd_dout[17]_dup_3 }),
    .opad(Sdr_rd_dout[17]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[18]_syn_1  (\Sdr_rd_dout[18]_dup_3 , \u2_ram/Sdr_rd_dout[18]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[18]_syn_4  (
    .do({open_n1530,open_n1531,open_n1532,\Sdr_rd_dout[18]_dup_3 }),
    .opad(Sdr_rd_dout[18]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[19]_syn_1  (\Sdr_rd_dout[19]_dup_3 , \u2_ram/Sdr_rd_dout[19]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[19]_syn_4  (
    .do({open_n1547,open_n1548,open_n1549,\Sdr_rd_dout[19]_dup_3 }),
    .opad(Sdr_rd_dout[19]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[1]_syn_1  (\Sdr_rd_dout[1]_dup_3 , \u2_ram/Sdr_rd_dout[1]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[1]_syn_4  (
    .do({open_n1564,open_n1565,open_n1566,\Sdr_rd_dout[1]_dup_3 }),
    .opad(Sdr_rd_dout[1]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[20]_syn_1  (\Sdr_rd_dout[20]_dup_3 , \u2_ram/Sdr_rd_dout[20]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[20]_syn_4  (
    .do({open_n1581,open_n1582,open_n1583,\Sdr_rd_dout[20]_dup_3 }),
    .opad(Sdr_rd_dout[20]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[21]_syn_1  (\Sdr_rd_dout[21]_dup_3 , \u2_ram/Sdr_rd_dout[21]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[21]_syn_4  (
    .do({open_n1598,open_n1599,open_n1600,\Sdr_rd_dout[21]_dup_3 }),
    .opad(Sdr_rd_dout[21]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[22]_syn_1  (\Sdr_rd_dout[22]_dup_3 , \u2_ram/Sdr_rd_dout[22]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[22]_syn_4  (
    .do({open_n1615,open_n1616,open_n1617,\Sdr_rd_dout[22]_dup_3 }),
    .opad(Sdr_rd_dout[22]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[23]_syn_1  (\Sdr_rd_dout[23]_dup_3 , \u2_ram/Sdr_rd_dout[23]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[23]_syn_4  (
    .do({open_n1632,open_n1633,open_n1634,\Sdr_rd_dout[23]_dup_3 }),
    .opad(Sdr_rd_dout[23]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[24]_syn_1  (\Sdr_rd_dout[24]_dup_3 , \u2_ram/Sdr_rd_dout[24]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[24]_syn_4  (
    .do({open_n1649,open_n1650,open_n1651,\Sdr_rd_dout[24]_dup_3 }),
    .opad(Sdr_rd_dout[24]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[25]_syn_1  (\Sdr_rd_dout[25]_dup_3 , \u2_ram/Sdr_rd_dout[25]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[25]_syn_4  (
    .do({open_n1666,open_n1667,open_n1668,\Sdr_rd_dout[25]_dup_3 }),
    .opad(Sdr_rd_dout[25]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[26]_syn_1  (\Sdr_rd_dout[26]_dup_3 , \u2_ram/Sdr_rd_dout[26]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[26]_syn_4  (
    .do({open_n1683,open_n1684,open_n1685,\Sdr_rd_dout[26]_dup_3 }),
    .opad(Sdr_rd_dout[26]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[27]_syn_1  (\Sdr_rd_dout[27]_dup_3 , \u2_ram/Sdr_rd_dout[27]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[27]_syn_4  (
    .do({open_n1700,open_n1701,open_n1702,\Sdr_rd_dout[27]_dup_3 }),
    .opad(Sdr_rd_dout[27]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[28]_syn_1  (\Sdr_rd_dout[28]_dup_3 , \u2_ram/Sdr_rd_dout[28]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[28]_syn_4  (
    .do({open_n1717,open_n1718,open_n1719,\Sdr_rd_dout[28]_dup_3 }),
    .opad(Sdr_rd_dout[28]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[29]_syn_1  (\Sdr_rd_dout[29]_dup_3 , \u2_ram/Sdr_rd_dout[29]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[29]_syn_4  (
    .do({open_n1734,open_n1735,open_n1736,\Sdr_rd_dout[29]_dup_3 }),
    .opad(Sdr_rd_dout[29]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[2]_syn_1  (\Sdr_rd_dout[2]_dup_3 , \u2_ram/Sdr_rd_dout[2]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[2]_syn_4  (
    .do({open_n1751,open_n1752,open_n1753,\Sdr_rd_dout[2]_dup_3 }),
    .opad(Sdr_rd_dout[2]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[30]_syn_1  (\Sdr_rd_dout[30]_dup_3 , \u2_ram/Sdr_rd_dout[30]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[30]_syn_4  (
    .do({open_n1768,open_n1769,open_n1770,\Sdr_rd_dout[30]_dup_3 }),
    .opad(Sdr_rd_dout[30]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[31]_syn_1  (\Sdr_rd_dout[31]_dup_3 , \u2_ram/Sdr_rd_dout[31]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[31]_syn_4  (
    .do({open_n1785,open_n1786,open_n1787,\Sdr_rd_dout[31]_dup_3 }),
    .opad(Sdr_rd_dout[31]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[3]_syn_1  (\Sdr_rd_dout[3]_dup_3 , \u2_ram/Sdr_rd_dout[3]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[3]_syn_4  (
    .do({open_n1802,open_n1803,open_n1804,\Sdr_rd_dout[3]_dup_3 }),
    .opad(Sdr_rd_dout[3]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[4]_syn_1  (\Sdr_rd_dout[4]_dup_3 , \u2_ram/Sdr_rd_dout[4]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[4]_syn_4  (
    .do({open_n1819,open_n1820,open_n1821,\Sdr_rd_dout[4]_dup_3 }),
    .opad(Sdr_rd_dout[4]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[5]_syn_1  (\Sdr_rd_dout[5]_dup_3 , \u2_ram/Sdr_rd_dout[5]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[5]_syn_4  (
    .do({open_n1836,open_n1837,open_n1838,\Sdr_rd_dout[5]_dup_3 }),
    .opad(Sdr_rd_dout[5]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[6]_syn_1  (\Sdr_rd_dout[6]_dup_3 , \u2_ram/Sdr_rd_dout[6]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[6]_syn_4  (
    .do({open_n1853,open_n1854,open_n1855,\Sdr_rd_dout[6]_dup_3 }),
    .opad(Sdr_rd_dout[6]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[7]_syn_1  (\Sdr_rd_dout[7]_dup_3 , \u2_ram/Sdr_rd_dout[7]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[7]_syn_4  (
    .do({open_n1870,open_n1871,open_n1872,\Sdr_rd_dout[7]_dup_3 }),
    .opad(Sdr_rd_dout[7]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[8]_syn_1  (\Sdr_rd_dout[8]_dup_3 , \u2_ram/Sdr_rd_dout[8]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[8]_syn_4  (
    .do({open_n1887,open_n1888,open_n1889,\Sdr_rd_dout[8]_dup_3 }),
    .opad(Sdr_rd_dout[8]));  // ../user_source/hdl_source/SD/sdram.v(40)
  buf \Sdr_rd_dout[9]_syn_1  (\Sdr_rd_dout[9]_dup_3 , \u2_ram/Sdr_rd_dout[9]_syn_4 );  // ../user_source/hdl_source/SD/sdram.v(40)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \Sdr_rd_dout[9]_syn_4  (
    .do({open_n1904,open_n1905,open_n1906,\Sdr_rd_dout[9]_dup_3 }),
    .opad(Sdr_rd_dout[9]));  // ../user_source/hdl_source/SD/sdram.v(40)
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
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    Sdr_rd_en_syn_6 (
    .do({open_n1921,open_n1922,open_n1923,\u2_ram/u2_wrrd/app_rd_en_sft [9]}),
    .osclk(Clk_dup_1),
    .opad(Sdr_rd_en));  // ../user_source/hdl_source/SD/sdram.v(39)
  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  EG_PHY_SDRAM_2M_32 sdram (
    .addr({\addr[10] ,\addr[9] ,\addr[8] ,\addr[7] ,\addr[6] ,\addr[5] ,\addr[4] ,\addr[3] ,\addr[2] ,\addr[1] ,\addr[0] }),
    .ba({\ba[1] ,\ba[0] }),
    .cas_n(cas_n),
    .cke(cke),
    .clk(clk),
    .cs_n(cs_n),
    .dm0(dm0),
    .dm1(dm1),
    .dm2(dm2),
    .dm3(dm3),
    .ras_n(ras_n),
    .we_n(we_n),
    .dq({\dq[31] ,\dq[30] ,\dq[29] ,\dq[28] ,\dq[27] ,\dq[26] ,\dq[25] ,\dq[24] ,\dq[23] ,\dq[22] ,\dq[21] ,\dq[20] ,\dq[19] ,\dq[18] ,\dq[17] ,\dq[16] ,\dq[15] ,\dq[14] ,\dq[13] ,\dq[12] ,\dq[11] ,\dq[10] ,\dq[9] ,\dq[8] ,\dq[7] ,\dq[6] ,\dq[5] ,\dq[4] ,\dq[3] ,\dq[2] ,\dq[1] ,\dq[0] }));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S1"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[0]/S1"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_1 (
    .do({open_n1984,open_n1985,open_n1986,\u2_ram/u2_wrrd/app_wr_din_6d [0]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n1992,open_n1993,open_n1994,\u2_ram/u2_wrrd/Sdr_rd_dout[0]_syn_3 }),
    .bpad(\dq[0] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S22"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("cs_n/S22"),
    //.SLEWRATE("FAST"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    sdram_syn_10 (
    .do({open_n1997,open_n1998,open_n1999,1'b0}),
    .opad(cs_n));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S23"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[9]/S23"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_11 (
    .do({open_n2014,open_n2015,open_n2016,\u2_ram/u2_wrrd/addr [9]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\addr[9] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S24"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[8]/S24"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_12 (
    .do({open_n2029,open_n2030,open_n2031,\u2_ram/u2_wrrd/addr [8]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\addr[8] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S25"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[7]/S25"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_13 (
    .do({open_n2044,open_n2045,open_n2046,\u2_ram/u2_wrrd/addr [7]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\addr[7] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S26"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[6]/S26"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_14 (
    .do({open_n2059,open_n2060,open_n2061,\u2_ram/u2_wrrd/addr [6]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\addr[6] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S27"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[5]/S27"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    sdram_syn_15 (
    .do({open_n2074,open_n2075,open_n2076,\u2_ram/u2_wrrd/SDR_ADDR_b [5]}),
    .osclk(Clk_dup_1),
    .opad(\addr[5] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S28"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[4]/S28"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    sdram_syn_16 (
    .do({open_n2090,open_n2091,open_n2092,\u2_ram/u2_wrrd/SDR_ADDR_b [4]}),
    .osclk(Clk_dup_1),
    .opad(\addr[4] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S29"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("dm2/S29"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("SET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_17 (
    .do({open_n2106,open_n2107,open_n2108,\u2_ram/u2_wrrd/app_wr_dm_6d [2]}),
    .osclk(Clk_dup_1),
    .rst(Rst_dup_175),
    .opad(dm2));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S31"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[23]/S31"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_18 (
    .do({open_n2121,open_n2122,open_n2123,\u2_ram/u2_wrrd/app_wr_din_6d [23]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2129,open_n2130,open_n2131,\u2_ram/u2_wrrd/Sdr_rd_dout[23]_syn_3 }),
    .bpad(\dq[23] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S32"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[22]/S32"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_19 (
    .do({open_n2134,open_n2135,open_n2136,\u2_ram/u2_wrrd/app_wr_din_6d [22]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2142,open_n2143,open_n2144,\u2_ram/u2_wrrd/Sdr_rd_dout[22]_syn_3 }),
    .bpad(\dq[22] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S11"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[6]/S11"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_2 (
    .do({open_n2147,open_n2148,open_n2149,\u2_ram/u2_wrrd/app_wr_din_6d [6]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2155,open_n2156,open_n2157,\u2_ram/u2_wrrd/Sdr_rd_dout[6]_syn_3 }),
    .bpad(\dq[6] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S35"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[21]/S35"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_20 (
    .do({open_n2160,open_n2161,open_n2162,\u2_ram/u2_wrrd/app_wr_din_6d [21]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2168,open_n2169,open_n2170,\u2_ram/u2_wrrd/Sdr_rd_dout[21]_syn_3 }),
    .bpad(\dq[21] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S36"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[20]/S36"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_21 (
    .do({open_n2173,open_n2174,open_n2175,\u2_ram/u2_wrrd/app_wr_din_6d [20]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2181,open_n2182,open_n2183,\u2_ram/u2_wrrd/Sdr_rd_dout[20]_syn_3 }),
    .bpad(\dq[20] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S37"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[19]/S37"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_22 (
    .do({open_n2186,open_n2187,open_n2188,\u2_ram/u2_wrrd/app_wr_din_6d [19]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2194,open_n2195,open_n2196,\u2_ram/u2_wrrd/Sdr_rd_dout[19]_syn_3 }),
    .bpad(\dq[19] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S38"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[18]/S38"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_23 (
    .do({open_n2199,open_n2200,open_n2201,\u2_ram/u2_wrrd/app_wr_din_6d [18]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2207,open_n2208,open_n2209,\u2_ram/u2_wrrd/Sdr_rd_dout[18]_syn_3 }),
    .bpad(\dq[18] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S41"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[17]/S41"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_24 (
    .do({open_n2212,open_n2213,open_n2214,\u2_ram/u2_wrrd/app_wr_din_6d [17]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2220,open_n2221,open_n2222,\u2_ram/u2_wrrd/Sdr_rd_dout[17]_syn_3 }),
    .bpad(\dq[17] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S42"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[16]/S42"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_25 (
    .do({open_n2225,open_n2226,open_n2227,\u2_ram/u2_wrrd/app_wr_din_6d [16]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2233,open_n2234,open_n2235,\u2_ram/u2_wrrd/Sdr_rd_dout[16]_syn_3 }),
    .bpad(\dq[16] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S48"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[31]/S48"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_26 (
    .do({open_n2238,open_n2239,open_n2240,\u2_ram/u2_wrrd/app_wr_din_6d [31]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2246,open_n2247,open_n2248,\u2_ram/u2_wrrd/Sdr_rd_dout[31]_syn_3 }),
    .bpad(\dq[31] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S49"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[30]/S49"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_27 (
    .do({open_n2251,open_n2252,open_n2253,\u2_ram/u2_wrrd/app_wr_din_6d [30]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2259,open_n2260,open_n2261,\u2_ram/u2_wrrd/Sdr_rd_dout[30]_syn_3 }),
    .bpad(\dq[30] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S5"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[2]/S5"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_28 (
    .do({open_n2264,open_n2265,open_n2266,\u2_ram/u2_wrrd/app_wr_din_6d [2]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2272,open_n2273,open_n2274,\u2_ram/u2_wrrd/Sdr_rd_dout[2]_syn_3 }),
    .bpad(\dq[2] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S52"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[29]/S52"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_29 (
    .do({open_n2277,open_n2278,open_n2279,\u2_ram/u2_wrrd/app_wr_din_6d [29]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2285,open_n2286,open_n2287,\u2_ram/u2_wrrd/Sdr_rd_dout[29]_syn_3 }),
    .bpad(\dq[29] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S12"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[7]/S12"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_3 (
    .do({open_n2290,open_n2291,open_n2292,\u2_ram/u2_wrrd/app_wr_din_6d [7]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2298,open_n2299,open_n2300,\u2_ram/u2_wrrd/Sdr_rd_dout[7]_syn_3 }),
    .bpad(\dq[7] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S53"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[28]/S53"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_30 (
    .do({open_n2303,open_n2304,open_n2305,\u2_ram/u2_wrrd/app_wr_din_6d [28]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2311,open_n2312,open_n2313,\u2_ram/u2_wrrd/Sdr_rd_dout[28]_syn_3 }),
    .bpad(\dq[28] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S54"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[27]/S54"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_31 (
    .do({open_n2316,open_n2317,open_n2318,\u2_ram/u2_wrrd/app_wr_din_6d [27]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2324,open_n2325,open_n2326,\u2_ram/u2_wrrd/Sdr_rd_dout[27]_syn_3 }),
    .bpad(\dq[27] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S55"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[26]/S55"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_32 (
    .do({open_n2329,open_n2330,open_n2331,\u2_ram/u2_wrrd/app_wr_din_6d [26]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2337,open_n2338,open_n2339,\u2_ram/u2_wrrd/Sdr_rd_dout[26]_syn_3 }),
    .bpad(\dq[26] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S58"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[25]/S58"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_33 (
    .do({open_n2342,open_n2343,open_n2344,\u2_ram/u2_wrrd/app_wr_din_6d [25]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2350,open_n2351,open_n2352,\u2_ram/u2_wrrd/Sdr_rd_dout[25]_syn_3 }),
    .bpad(\dq[25] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S59"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[24]/S59"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_34 (
    .do({open_n2355,open_n2356,open_n2357,\u2_ram/u2_wrrd/app_wr_din_6d [24]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2363,open_n2364,open_n2365,\u2_ram/u2_wrrd/Sdr_rd_dout[24]_syn_3 }),
    .bpad(\dq[24] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S6"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[3]/S6"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_35 (
    .do({open_n2368,open_n2369,open_n2370,\u2_ram/u2_wrrd/app_wr_din_6d [3]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2376,open_n2377,open_n2378,\u2_ram/u2_wrrd/Sdr_rd_dout[3]_syn_3 }),
    .bpad(\dq[3] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S61"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("dm3/S61"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("SET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_36 (
    .do({open_n2381,open_n2382,open_n2383,\u2_ram/u2_wrrd/app_wr_dm_6d [3]}),
    .osclk(Clk_dup_1),
    .rst(Rst_dup_175),
    .opad(dm3));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S64"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[3]/S64"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_37 (
    .do({open_n2396,open_n2397,open_n2398,\u2_ram/u2_wrrd/addr [3]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\addr[3] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S65"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[2]/S65"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_38 (
    .do({open_n2411,open_n2412,open_n2413,\u2_ram/u2_wrrd/addr [2]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\addr[2] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S66"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[1]/S66"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    sdram_syn_39 (
    .do({open_n2426,open_n2427,open_n2428,\u2_ram/u2_wrrd/SDR_ADDR_b [1]}),
    .osclk(Clk_dup_1),
    .opad(\addr[1] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S14"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("dm0/S14"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("SET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_4 (
    .do({open_n2442,open_n2443,open_n2444,\u2_ram/u2_wrrd/app_wr_dm_6d [0]}),
    .osclk(Clk_dup_1),
    .rst(Rst_dup_175),
    .opad(dm0));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S67"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[0]/S67"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_40 (
    .do({open_n2457,open_n2458,open_n2459,\u2_ram/u2_wrrd/addr [0]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\addr[0] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S68"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("addr[10]/S68"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    sdram_syn_41 (
    .do({open_n2472,open_n2473,open_n2474,\u2_ram/u2_wrrd/SDR_ADDR_b [10]}),
    .osclk(Clk_dup_1),
    .opad(\addr[10] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S69"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("ba[0]/S69"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_42 (
    .do({open_n2488,open_n2489,open_n2490,\u2_ram/u2_wrrd/ba [0]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\ba[0] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S7"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[4]/S7"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_43 (
    .do({open_n2503,open_n2504,open_n2505,\u2_ram/u2_wrrd/app_wr_din_6d [4]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2511,open_n2512,open_n2513,\u2_ram/u2_wrrd/Sdr_rd_dout[4]_syn_3 }),
    .bpad(\dq[4] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S70"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("ba[1]/S70"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("INV"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_44 (
    .do({open_n2516,open_n2517,open_n2518,\u2_ram/u2_wrrd/ba [1]}),
    .osclk(Clk_dup_1),
    .rst(\u2_ram/u2_wrrd/rw_vld ),
    .opad(\ba[1] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S73"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("clk/S73"),
    //.SLEWRATE("FAST"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    sdram_syn_45 (
    .do({open_n2531,open_n2532,open_n2533,SDRAM_CLK}),
    .opad(clk));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S76"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("dm1/S76"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("SET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("RST"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("SYNC"),
    .TSMUX("0"))
    sdram_syn_46 (
    .do({open_n2548,open_n2549,open_n2550,\u2_ram/u2_wrrd/app_wr_dm_6d [1]}),
    .osclk(Clk_dup_1),
    .rst(Rst_dup_175),
    .opad(dm1));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S78"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[8]/S78"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_47 (
    .do({open_n2563,open_n2564,open_n2565,\u2_ram/u2_wrrd/app_wr_din_6d [8]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2571,open_n2572,open_n2573,\u2_ram/u2_wrrd/Sdr_rd_dout[8]_syn_3 }),
    .bpad(\dq[8] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S79"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[9]/S79"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_48 (
    .do({open_n2576,open_n2577,open_n2578,\u2_ram/u2_wrrd/app_wr_din_6d [9]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2584,open_n2585,open_n2586,\u2_ram/u2_wrrd/Sdr_rd_dout[9]_syn_3 }),
    .bpad(\dq[9] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S8"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[5]/S8"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_49 (
    .do({open_n2589,open_n2590,open_n2591,\u2_ram/u2_wrrd/app_wr_din_6d [5]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2597,open_n2598,open_n2599,\u2_ram/u2_wrrd/Sdr_rd_dout[5]_syn_3 }),
    .bpad(\dq[5] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S18"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("cke/S18"),
    //.SLEWRATE("FAST"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    sdram_syn_5 (
    .do({open_n2602,open_n2603,open_n2604,1'b1}),
    .opad(cke));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S82"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[10]/S82"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_50 (
    .do({open_n2619,open_n2620,open_n2621,\u2_ram/u2_wrrd/app_wr_din_6d [10]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2627,open_n2628,open_n2629,\u2_ram/u2_wrrd/Sdr_rd_dout[10]_syn_3 }),
    .bpad(\dq[10] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S83"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[11]/S83"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_51 (
    .do({open_n2632,open_n2633,open_n2634,\u2_ram/u2_wrrd/app_wr_din_6d [11]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2640,open_n2641,open_n2642,\u2_ram/u2_wrrd/Sdr_rd_dout[11]_syn_3 }),
    .bpad(\dq[11] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S84"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[12]/S84"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_52 (
    .do({open_n2645,open_n2646,open_n2647,\u2_ram/u2_wrrd/app_wr_din_6d [12]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2653,open_n2654,open_n2655,\u2_ram/u2_wrrd/Sdr_rd_dout[12]_syn_3 }),
    .bpad(\dq[12] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S85"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[13]/S85"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_53 (
    .do({open_n2658,open_n2659,open_n2660,\u2_ram/u2_wrrd/app_wr_din_6d [13]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2666,open_n2667,open_n2668,\u2_ram/u2_wrrd/Sdr_rd_dout[13]_syn_3 }),
    .bpad(\dq[13] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S88"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[14]/S88"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_54 (
    .do({open_n2671,open_n2672,open_n2673,\u2_ram/u2_wrrd/app_wr_din_6d [14]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2679,open_n2680,open_n2681,\u2_ram/u2_wrrd/Sdr_rd_dout[14]_syn_3 }),
    .bpad(\dq[14] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S89"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[15]/S89"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_55 (
    .do({open_n2684,open_n2685,open_n2686,\u2_ram/u2_wrrd/app_wr_din_6d [15]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2692,open_n2693,open_n2694,\u2_ram/u2_wrrd/Sdr_rd_dout[15]_syn_3 }),
    .bpad(\dq[15] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S19"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("we_n/S19"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    sdram_syn_6 (
    .do({open_n2697,open_n2698,open_n2699,\u2_ram/u2_wrrd/SDR_WE_n }),
    .osclk(Clk_dup_1),
    .opad(we_n));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.LOCATION("S2"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    //.SIP_INFO("dq[1]/S2"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IDDRMODE("OFF"),
    .IDDRPIPEMODE("NONE"),
    .INCEMUX("1"),
    .INPCLKMUX("CLK"),
    .INRSTMUX("0"),
    .IN_DFFMODE("FF"),
    .IN_REGSET("RESET"),
    .IOTYPE("LVCMOS25"),
    .MODE("BI"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("INV"))
    sdram_syn_7 (
    .do({open_n2713,open_n2714,open_n2715,\u2_ram/u2_wrrd/app_wr_din_6d [1]}),
    .ipclk(Clk_dup_1),
    .osclk(Clk_dup_1),
    .ts(\u2_ram/u2_wrrd/sdr_t ),
    .diq({open_n2721,open_n2722,open_n2723,\u2_ram/u2_wrrd/Sdr_rd_dout[1]_syn_3 }),
    .bpad(\dq[1] ));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S20"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("cas_n/S20"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    sdram_syn_8 (
    .do({open_n2726,open_n2727,open_n2728,\u2_ram/u2_wrrd/SDR_CAS_n }),
    .osclk(Clk_dup_1),
    .opad(cas_n));  // ../user_source/hdl_source/SD/sdram.v(92)
  EG_PHY_PAD #(
    //.LOCATION("S21"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SIP_INFO("ras_n/S21"),
    //.SLEWRATE("FAST"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    sdram_syn_9 (
    .do({open_n2742,open_n2743,open_n2744,\u2_ram/u2_wrrd/SDR_RAS_n }),
    .osclk(Clk_dup_1),
    .opad(ras_n));  // ../user_source/hdl_source/SD/sdram.v(92)
  buf \u2_ram/SDRAM_CLK_syn_1  (\u2_ram/SDRAM_CLK , Clk_sft_dup_1);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(35)
  buf \u2_ram/SDRAM_CLK_syn_2  (SDRAM_CLK, \u2_ram/SDRAM_CLK );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(35)
  buf \u2_ram/Sdr_rd_dout[0]_syn_1  (\u2_ram/Sdr_rd_dout [0], \u2_ram/u2_wrrd/Sdr_rd_dout[0]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[0]_syn_2  (\u2_ram/Sdr_rd_dout[0]_syn_4 , \u2_ram/Sdr_rd_dout [0]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[10]_syn_1  (\u2_ram/Sdr_rd_dout [10], \u2_ram/u2_wrrd/Sdr_rd_dout[10]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[10]_syn_2  (\u2_ram/Sdr_rd_dout[10]_syn_4 , \u2_ram/Sdr_rd_dout [10]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[11]_syn_1  (\u2_ram/Sdr_rd_dout [11], \u2_ram/u2_wrrd/Sdr_rd_dout[11]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[11]_syn_2  (\u2_ram/Sdr_rd_dout[11]_syn_4 , \u2_ram/Sdr_rd_dout [11]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[12]_syn_1  (\u2_ram/Sdr_rd_dout [12], \u2_ram/u2_wrrd/Sdr_rd_dout[12]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[12]_syn_2  (\u2_ram/Sdr_rd_dout[12]_syn_4 , \u2_ram/Sdr_rd_dout [12]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[13]_syn_1  (\u2_ram/Sdr_rd_dout [13], \u2_ram/u2_wrrd/Sdr_rd_dout[13]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[13]_syn_2  (\u2_ram/Sdr_rd_dout[13]_syn_4 , \u2_ram/Sdr_rd_dout [13]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[14]_syn_1  (\u2_ram/Sdr_rd_dout [14], \u2_ram/u2_wrrd/Sdr_rd_dout[14]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[14]_syn_2  (\u2_ram/Sdr_rd_dout[14]_syn_4 , \u2_ram/Sdr_rd_dout [14]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[15]_syn_1  (\u2_ram/Sdr_rd_dout [15], \u2_ram/u2_wrrd/Sdr_rd_dout[15]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[15]_syn_2  (\u2_ram/Sdr_rd_dout[15]_syn_4 , \u2_ram/Sdr_rd_dout [15]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[16]_syn_1  (\u2_ram/Sdr_rd_dout [16], \u2_ram/u2_wrrd/Sdr_rd_dout[16]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[16]_syn_2  (\u2_ram/Sdr_rd_dout[16]_syn_4 , \u2_ram/Sdr_rd_dout [16]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[17]_syn_1  (\u2_ram/Sdr_rd_dout [17], \u2_ram/u2_wrrd/Sdr_rd_dout[17]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[17]_syn_2  (\u2_ram/Sdr_rd_dout[17]_syn_4 , \u2_ram/Sdr_rd_dout [17]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[18]_syn_1  (\u2_ram/Sdr_rd_dout [18], \u2_ram/u2_wrrd/Sdr_rd_dout[18]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[18]_syn_2  (\u2_ram/Sdr_rd_dout[18]_syn_4 , \u2_ram/Sdr_rd_dout [18]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[19]_syn_1  (\u2_ram/Sdr_rd_dout [19], \u2_ram/u2_wrrd/Sdr_rd_dout[19]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[19]_syn_2  (\u2_ram/Sdr_rd_dout[19]_syn_4 , \u2_ram/Sdr_rd_dout [19]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[1]_syn_1  (\u2_ram/Sdr_rd_dout [1], \u2_ram/u2_wrrd/Sdr_rd_dout[1]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[1]_syn_2  (\u2_ram/Sdr_rd_dout[1]_syn_4 , \u2_ram/Sdr_rd_dout [1]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[20]_syn_1  (\u2_ram/Sdr_rd_dout [20], \u2_ram/u2_wrrd/Sdr_rd_dout[20]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[20]_syn_2  (\u2_ram/Sdr_rd_dout[20]_syn_4 , \u2_ram/Sdr_rd_dout [20]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[21]_syn_1  (\u2_ram/Sdr_rd_dout [21], \u2_ram/u2_wrrd/Sdr_rd_dout[21]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[21]_syn_2  (\u2_ram/Sdr_rd_dout[21]_syn_4 , \u2_ram/Sdr_rd_dout [21]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[22]_syn_1  (\u2_ram/Sdr_rd_dout [22], \u2_ram/u2_wrrd/Sdr_rd_dout[22]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[22]_syn_2  (\u2_ram/Sdr_rd_dout[22]_syn_4 , \u2_ram/Sdr_rd_dout [22]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[23]_syn_1  (\u2_ram/Sdr_rd_dout [23], \u2_ram/u2_wrrd/Sdr_rd_dout[23]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[23]_syn_2  (\u2_ram/Sdr_rd_dout[23]_syn_4 , \u2_ram/Sdr_rd_dout [23]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[24]_syn_1  (\u2_ram/Sdr_rd_dout [24], \u2_ram/u2_wrrd/Sdr_rd_dout[24]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[24]_syn_2  (\u2_ram/Sdr_rd_dout[24]_syn_4 , \u2_ram/Sdr_rd_dout [24]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[25]_syn_1  (\u2_ram/Sdr_rd_dout [25], \u2_ram/u2_wrrd/Sdr_rd_dout[25]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[25]_syn_2  (\u2_ram/Sdr_rd_dout[25]_syn_4 , \u2_ram/Sdr_rd_dout [25]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[26]_syn_1  (\u2_ram/Sdr_rd_dout [26], \u2_ram/u2_wrrd/Sdr_rd_dout[26]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[26]_syn_2  (\u2_ram/Sdr_rd_dout[26]_syn_4 , \u2_ram/Sdr_rd_dout [26]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[27]_syn_1  (\u2_ram/Sdr_rd_dout [27], \u2_ram/u2_wrrd/Sdr_rd_dout[27]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[27]_syn_2  (\u2_ram/Sdr_rd_dout[27]_syn_4 , \u2_ram/Sdr_rd_dout [27]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[28]_syn_1  (\u2_ram/Sdr_rd_dout [28], \u2_ram/u2_wrrd/Sdr_rd_dout[28]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[28]_syn_2  (\u2_ram/Sdr_rd_dout[28]_syn_4 , \u2_ram/Sdr_rd_dout [28]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[29]_syn_1  (\u2_ram/Sdr_rd_dout [29], \u2_ram/u2_wrrd/Sdr_rd_dout[29]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[29]_syn_2  (\u2_ram/Sdr_rd_dout[29]_syn_4 , \u2_ram/Sdr_rd_dout [29]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[2]_syn_1  (\u2_ram/Sdr_rd_dout [2], \u2_ram/u2_wrrd/Sdr_rd_dout[2]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[2]_syn_2  (\u2_ram/Sdr_rd_dout[2]_syn_4 , \u2_ram/Sdr_rd_dout [2]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[30]_syn_1  (\u2_ram/Sdr_rd_dout [30], \u2_ram/u2_wrrd/Sdr_rd_dout[30]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[30]_syn_2  (\u2_ram/Sdr_rd_dout[30]_syn_4 , \u2_ram/Sdr_rd_dout [30]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[31]_syn_1  (\u2_ram/Sdr_rd_dout [31], \u2_ram/u2_wrrd/Sdr_rd_dout[31]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[31]_syn_2  (\u2_ram/Sdr_rd_dout[31]_syn_4 , \u2_ram/Sdr_rd_dout [31]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[3]_syn_1  (\u2_ram/Sdr_rd_dout [3], \u2_ram/u2_wrrd/Sdr_rd_dout[3]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[3]_syn_2  (\u2_ram/Sdr_rd_dout[3]_syn_4 , \u2_ram/Sdr_rd_dout [3]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[4]_syn_1  (\u2_ram/Sdr_rd_dout [4], \u2_ram/u2_wrrd/Sdr_rd_dout[4]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[4]_syn_2  (\u2_ram/Sdr_rd_dout[4]_syn_4 , \u2_ram/Sdr_rd_dout [4]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[5]_syn_1  (\u2_ram/Sdr_rd_dout [5], \u2_ram/u2_wrrd/Sdr_rd_dout[5]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[5]_syn_2  (\u2_ram/Sdr_rd_dout[5]_syn_4 , \u2_ram/Sdr_rd_dout [5]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[6]_syn_1  (\u2_ram/Sdr_rd_dout [6], \u2_ram/u2_wrrd/Sdr_rd_dout[6]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[6]_syn_2  (\u2_ram/Sdr_rd_dout[6]_syn_4 , \u2_ram/Sdr_rd_dout [6]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[7]_syn_1  (\u2_ram/Sdr_rd_dout [7], \u2_ram/u2_wrrd/Sdr_rd_dout[7]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[7]_syn_2  (\u2_ram/Sdr_rd_dout[7]_syn_4 , \u2_ram/Sdr_rd_dout [7]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[8]_syn_1  (\u2_ram/Sdr_rd_dout [8], \u2_ram/u2_wrrd/Sdr_rd_dout[8]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[8]_syn_2  (\u2_ram/Sdr_rd_dout[8]_syn_4 , \u2_ram/Sdr_rd_dout [8]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[9]_syn_1  (\u2_ram/Sdr_rd_dout [9], \u2_ram/u2_wrrd/Sdr_rd_dout[9]_syn_4 );  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  buf \u2_ram/Sdr_rd_dout[9]_syn_2  (\u2_ram/Sdr_rd_dout[9]_syn_4 , \u2_ram/Sdr_rd_dout [9]);  // ../user_source/hdl_source/include/sdr_as_ram.enc.v(32)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/ad_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/ad_reg[10]_syn_4 ),
    .q(\u2_ram/u1_init_ref/Sdr_init_ref_addr [10]));
  AL_MAP_LUT5 #(
    .EQN("(~B*~(~(E*~D)*~(C*~A)))"),
    .INIT(32'h10331010))
    \u2_ram/u1_init_ref/ad_reg[10]_syn_5  (
    .a(\u2_ram/u1_init_ref/ras_reg_syn_5 ),
    .b(Rst_dup_175),
    .c(\u2_ram/u1_init_ref/Sdr_init_ref_addr [10]),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [0]),
    .e(\u2_ram/u1_init_ref/sdr_init_cnt [1]),
    .o(\u2_ram/u1_init_ref/ad_reg[10]_syn_4 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/ad_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/ad_reg[1]_syn_4 ),
    .q(\u2_ram/u1_init_ref/Sdr_init_ref_addr [1]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(~C*~B))"),
    .INIT(8'ha8))
    \u2_ram/u1_init_ref/ad_reg[1]_syn_5  (
    .a(\u2_ram/u1_init_ref/cas_reg_syn_5 ),
    .b(\u2_ram/u1_init_ref/ras_reg_syn_5 ),
    .c(\u2_ram/u1_init_ref/Sdr_init_ref_addr [1]),
    .o(\u2_ram/u1_init_ref/ad_reg[1]_syn_4 ));
  EG_PHY_LSLICE #(
    //.MACRO("u2_ram/u1_init_ref/add1_syn_110"),
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
    \u2_ram/u1_init_ref/add1_syn_110  (
    .a({\u2_ram/u1_init_ref/pwr_200ms_cnt [1],1'b0}),
    .b({\u2_ram/u1_init_ref/pwr_200ms_cnt [2],\u2_ram/u1_init_ref/pwr_200ms_cnt [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [1],open_n2778}),
    .fco(\u2_ram/u1_init_ref/add1_syn_94 ),
    .fx({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [2],open_n2779}));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  EG_PHY_LSLICE #(
    //.MACRO("u2_ram/u1_init_ref/add1_syn_110"),
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
    \u2_ram/u1_init_ref/add1_syn_111  (
    .a({\u2_ram/u1_init_ref/pwr_200ms_cnt [5],\u2_ram/u1_init_ref/pwr_200ms_cnt [3]}),
    .b({\u2_ram/u1_init_ref/pwr_200ms_cnt [6],\u2_ram/u1_init_ref/pwr_200ms_cnt [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u2_ram/u1_init_ref/add1_syn_94 ),
    .f({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [5],\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [3]}),
    .fco(\u2_ram/u1_init_ref/add1_syn_98 ),
    .fx({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [6],\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [4]}));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  EG_PHY_LSLICE #(
    //.MACRO("u2_ram/u1_init_ref/add1_syn_110"),
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
    \u2_ram/u1_init_ref/add1_syn_112  (
    .a({\u2_ram/u1_init_ref/pwr_200ms_cnt [9],\u2_ram/u1_init_ref/pwr_200ms_cnt [7]}),
    .b({\u2_ram/u1_init_ref/pwr_200ms_cnt [10],\u2_ram/u1_init_ref/pwr_200ms_cnt [8]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u2_ram/u1_init_ref/add1_syn_98 ),
    .f({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [9],\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [7]}),
    .fco(\u2_ram/u1_init_ref/add1_syn_102 ),
    .fx({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [10],\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [8]}));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  EG_PHY_LSLICE #(
    //.MACRO("u2_ram/u1_init_ref/add1_syn_110"),
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
    \u2_ram/u1_init_ref/add1_syn_113  (
    .a({\u2_ram/u1_init_ref/pwr_200ms_cnt [13],\u2_ram/u1_init_ref/pwr_200ms_cnt [11]}),
    .b({\u2_ram/u1_init_ref/pwr_200ms_cnt [14],\u2_ram/u1_init_ref/pwr_200ms_cnt [12]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u2_ram/u1_init_ref/add1_syn_102 ),
    .f({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [13],\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [11]}),
    .fco(\u2_ram/u1_init_ref/add1_syn_106 ),
    .fx({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [14],\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [12]}));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  EG_PHY_LSLICE #(
    //.MACRO("u2_ram/u1_init_ref/add1_syn_110"),
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
    \u2_ram/u1_init_ref/add1_syn_114  (
    .a({\u2_ram/u1_init_ref/pwr_200ms_cnt [17],\u2_ram/u1_init_ref/pwr_200ms_cnt [15]}),
    .b({open_n2836,\u2_ram/u1_init_ref/pwr_200ms_cnt [16]}),
    .c(2'b00),
    .d(2'b00),
    .e({open_n2839,1'b0}),
    .fci(\u2_ram/u1_init_ref/add1_syn_106 ),
    .f({\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [17],\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [15]}),
    .fx({open_n2855,\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [16]}));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(62)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/cas_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/cas_reg_syn_3 ),
    .q(\u2_ram/u1_init_ref/Sdr_init_ref_cas ));
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u2_ram/u1_init_ref/cas_reg_syn_4  (
    .a(Rst_dup_175),
    .b(\u2_ram/u1_init_ref/sdr_init_cnt [0]),
    .c(\u2_ram/u1_init_ref/sdr_init_cnt [1]),
    .o(\u2_ram/u1_init_ref/cas_reg_syn_5 ));
  AL_MAP_LUT3 #(
    .EQN("~(B*~(~C*~A))"),
    .INIT(8'h37))
    \u2_ram/u1_init_ref/cas_reg_syn_6  (
    .a(\u2_ram/u1_init_ref/ras_reg_syn_7 ),
    .b(\u2_ram/u1_init_ref/cas_reg_syn_5 ),
    .c(\u2_ram/u1_init_ref/ras_reg_syn_5 ),
    .o(\u2_ram/u1_init_ref/cas_reg_syn_3 ));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u2_ram/u1_init_ref/init_done_n2_syn_1  (
    .a(Rst_dup_175),
    .b(\u2_ram/u1_init_ref/sdr_init_en ),
    .o(\u2_ram/u1_init_ref/init_done_n2 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/init_vld_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/init_vld_reg_syn_5 ),
    .q(\u2_ram/u1_init_ref/init_vld ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(78)
  AL_MAP_LUT4 #(
    .EQN("(~D*~A*~(~C*~B))"),
    .INIT(16'h0054))
    \u2_ram/u1_init_ref/init_vld_reg_syn_6  (
    .a(Rst_dup_175),
    .b(\u2_ram/u1_init_ref/init_vld ),
    .c(\u2_ram/u1_init_ref/sdr_init_cnt [0]),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [30]),
    .o(\u2_ram/u1_init_ref/init_vld_reg_syn_5 ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(78)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/power_up_200ms_1d_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .q(\u2_ram/u1_init_ref/power_up_200ms_1d ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/power_up_200ms_2d_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/power_up_200ms_1d ),
    .q(\u2_ram/u1_init_ref/power_up_200ms_2d ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u2_ram/u1_init_ref/power_up_en_n_syn_1  (
    .a(\u2_ram/u1_init_ref/power_up_200ms_1d ),
    .b(\u2_ram/u1_init_ref/power_up_200ms_2d ),
    .o(\u2_ram/u1_init_ref/power_up_en_n ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/power_up_en_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/power_up_en_n ),
    .q(\u2_ram/u1_init_ref/power_up_en ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u2_ram/u1_init_ref/pwr_200ms_cnt[0]_syn_3  (
    .a(\u2_ram/u1_init_ref/pwr_200ms_cnt [0]),
    .o(\u2_ram/u1_init_ref/pwr_200ms_cnt[0]_syn_2 ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(39)
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_b1[17]_syn_1  (
    .a(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [17]),
    .b(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .o(\u2_ram/u1_init_ref/pwr_200ms_cnt_b1 [17]));
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[0]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt[0]_syn_2 ),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [0]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[10]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [10]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [10]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[11]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [11]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [11]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[12]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [12]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [12]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[13]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [13]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [13]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[14]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [14]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [14]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[15]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [15]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [15]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[16]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [16]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [16]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[17]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b1 [17]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[1]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [1]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [1]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[2]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [2]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [2]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[3]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [3]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [3]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[4]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [4]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [4]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[5]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [5]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [5]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[6]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [6]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [6]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[7]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [7]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [7]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[8]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [8]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [8]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/pwr_200ms_cnt_reg[9]  (
    .ce(\u2_ram/u1_init_ref/pwr_200ms_cnt [17]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/pwr_200ms_cnt_b3 [9]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/pwr_200ms_cnt [9]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/ras_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/ras_reg_syn_3 ),
    .q(\u2_ram/u1_init_ref/Sdr_init_ref_ras ));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u2_ram/u1_init_ref/ras_reg_syn_4  (
    .a(\u2_ram/u1_init_ref/sdr_init_cnt [7]),
    .b(\u2_ram/u1_init_ref/sdr_init_cnt [8]),
    .o(\u2_ram/u1_init_ref/ras_reg_syn_5 ));
  AL_MAP_LUT4 #(
    .EQN("(D*~C*~B*~A)"),
    .INIT(16'h0100))
    \u2_ram/u1_init_ref/ras_reg_syn_6  (
    .a(\u2_ram/App_rd_en ),
    .b(App_wr_en_dup_5),
    .c(\u2_ram/u2_wrrd/rw_vld ),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [2]),
    .o(\u2_ram/u1_init_ref/ras_reg_syn_7 ));
  AL_MAP_LUT5 #(
    .EQN("~(~C*~(~B*~A*~(E*~D)))"),
    .INIT(32'hf1f0f1f1))
    \u2_ram/u1_init_ref/ras_reg_syn_8  (
    .a(\u2_ram/u1_init_ref/ras_reg_syn_7 ),
    .b(\u2_ram/u1_init_ref/ras_reg_syn_5 ),
    .c(Rst_dup_175),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [0]),
    .e(\u2_ram/u1_init_ref/sdr_init_cnt [1]),
    .o(\u2_ram/u1_init_ref/ras_reg_syn_3 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/ref_vld_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/ref_vld_reg_syn_5 ),
    .q(\u2_ram/u1_init_ref/ref_vld ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(122)
  AL_MAP_LUT4 #(
    .EQN("(~D*C*~B*~A)"),
    .INIT(16'h0010))
    \u2_ram/u1_init_ref/ref_vld_reg_syn_6  (
    .a(\u2_ram/App_rd_en ),
    .b(App_wr_en_dup_5),
    .c(\u2_ram/u1_init_ref/Sdr_ref_ack ),
    .d(\u2_ram/u2_wrrd/rw_vld ),
    .o(\u2_ram/u1_init_ref/ref_vld_reg_syn_7 ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(122)
  AL_MAP_LUT4 #(
    .EQN("(~B*~(~A*~(~D*C)))"),
    .INIT(16'h2232))
    \u2_ram/u1_init_ref/ref_vld_reg_syn_8  (
    .a(\u2_ram/u1_init_ref/ref_vld_reg_syn_7 ),
    .b(Rst_dup_175),
    .c(\u2_ram/u1_init_ref/ref_vld ),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [19]),
    .o(\u2_ram/u1_init_ref/ref_vld_reg_syn_5 ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(122)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_en ),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [0]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [9]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [10]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[11]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [10]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [11]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[12]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [11]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [12]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[13]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [12]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [13]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[14]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [13]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [14]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[15]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [14]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [15]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[16]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [15]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [16]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[17]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [16]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [17]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[18]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [17]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [18]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[19]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [18]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [19]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [0]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [1]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[20]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [19]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [20]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[21]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [20]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [21]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[22]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [21]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [22]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[23]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [22]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [23]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[24]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [23]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [24]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[25]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [24]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [25]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[26]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [25]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [26]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[27]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [26]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [27]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[28]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [27]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [28]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[29]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [28]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [29]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [1]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [2]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[30]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [29]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [30]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [2]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [3]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [3]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [4]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [4]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [5]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [5]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [6]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [6]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [7]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [7]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [8]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_cnt_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [8]),
    .q(\u2_ram/u1_init_ref/sdr_init_cnt [9]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(72)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/sdr_init_en_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/power_up_en ),
    .q(\u2_ram/u1_init_ref/sdr_init_en ));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(55)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/Sdr_ref_ack ),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [0]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [9]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [10]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[11]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [10]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [11]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[12]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [11]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [12]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[13]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [12]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [13]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[14]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [13]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [14]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[15]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [14]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [15]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[16]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [15]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [16]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[17]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [16]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [17]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[18]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [17]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [18]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[19]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [18]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [19]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [0]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [1]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [1]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [2]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [2]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [3]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [3]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [4]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [4]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [5]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [5]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [6]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [6]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [7]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [7]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [8]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u1_init_ref/sdr_ref_ack_sft_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/sdr_ref_ack_sft [8]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u1_init_ref/sdr_ref_ack_sft [9]));  // ../user_source/hdl_source/include/sdr_init_ref.enc.v(109)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u1_init_ref/we_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u1_init_ref/we_reg_syn_3 ),
    .q(\u2_ram/u1_init_ref/Sdr_init_ref_we ));
  AL_MAP_LUT4 #(
    .EQN("~(~B*~(~A*~(D*~C)))"),
    .INIT(16'hdcdd))
    \u2_ram/u1_init_ref/we_reg_syn_4  (
    .a(\u2_ram/u1_init_ref/ras_reg_syn_5 ),
    .b(Rst_dup_175),
    .c(\u2_ram/u1_init_ref/sdr_init_cnt [0]),
    .d(\u2_ram/u1_init_ref/sdr_init_cnt [1]),
    .o(\u2_ram/u1_init_ref/we_reg_syn_3 ));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/SDR_ADDR_b[10]_syn_1  (
    .a(\u2_ram/u2_wrrd/rw_vld ),
    .b(\u2_ram/u1_init_ref/Sdr_init_ref_addr [10]),
    .c(\u2_ram/u2_wrrd/addr [10]),
    .o(\u2_ram/u2_wrrd/SDR_ADDR_b [10]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/SDR_ADDR_b[1]_syn_1  (
    .a(\u2_ram/u2_wrrd/rw_vld ),
    .b(\u2_ram/u1_init_ref/Sdr_init_ref_addr [1]),
    .c(\u2_ram/u2_wrrd/addr [1]),
    .o(\u2_ram/u2_wrrd/SDR_ADDR_b [1]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/SDR_ADDR_b[4]_syn_1  (
    .a(\u2_ram/u2_wrrd/rw_vld ),
    .b(\u2_ram/u1_init_ref/Sdr_init_ref_addr [1]),
    .c(\u2_ram/u2_wrrd/addr [4]),
    .o(\u2_ram/u2_wrrd/SDR_ADDR_b [4]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/SDR_ADDR_b[5]_syn_1  (
    .a(\u2_ram/u2_wrrd/rw_vld ),
    .b(\u2_ram/u1_init_ref/Sdr_init_ref_addr [1]),
    .c(\u2_ram/u2_wrrd/addr [5]),
    .o(\u2_ram/u2_wrrd/SDR_ADDR_b [5]));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u2_ram/u2_wrrd/SDR_CAS_n_syn_1  (
    .a(\u2_ram/u1_init_ref/Sdr_init_ref_cas ),
    .b(\u2_ram/u2_wrrd/cas ),
    .c(\u2_ram/u2_wrrd/rw_vld ),
    .o(\u2_ram/u2_wrrd/SDR_CAS_n ));
  AL_MAP_LUT3 #(
    .EQN("(A*~(B)*~(C)+A*B*~(C)+~(A)*B*C+A*B*C)"),
    .INIT(8'hca))
    \u2_ram/u2_wrrd/SDR_RAS_n_syn_1  (
    .a(\u2_ram/u1_init_ref/Sdr_init_ref_ras ),
    .b(\u2_ram/u2_wrrd/ras ),
    .c(\u2_ram/u2_wrrd/rw_vld ),
    .o(\u2_ram/u2_wrrd/SDR_RAS_n ));
  AL_MAP_LUT3 #(
    .EQN("(A*~(C)*~(B)+A*C*~(B)+~(A)*C*B+A*C*B)"),
    .INIT(8'he2))
    \u2_ram/u2_wrrd/SDR_WE_n_syn_1  (
    .a(\u2_ram/u1_init_ref/Sdr_init_ref_we ),
    .b(\u2_ram/u2_wrrd/rw_vld ),
    .c(\u2_ram/u2_wrrd/we ),
    .o(\u2_ram/u2_wrrd/SDR_WE_n ));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u2_ram/u2_wrrd/Sdr_busy_n4_syn_1  (
    .a(\u2_ram/u2_wrrd/state_reg_syn_1 [1]),
    .b(\u2_ram/u2_wrrd/state_reg_syn_1 [2]),
    .o(\u2_ram/u2_wrrd/Sdr_busy_n4 ));
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[0]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [0], \u2_ram/u2_wrrd/Sdr_rd_dout[0]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[0]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[0]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [0]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[10]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [10], \u2_ram/u2_wrrd/Sdr_rd_dout[10]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[10]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[10]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [10]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[11]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [11], \u2_ram/u2_wrrd/Sdr_rd_dout[11]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[11]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[11]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [11]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[12]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [12], \u2_ram/u2_wrrd/Sdr_rd_dout[12]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[12]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[12]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [12]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[13]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [13], \u2_ram/u2_wrrd/Sdr_rd_dout[13]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[13]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[13]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [13]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[14]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [14], \u2_ram/u2_wrrd/Sdr_rd_dout[14]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[14]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[14]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [14]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[15]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [15], \u2_ram/u2_wrrd/Sdr_rd_dout[15]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[15]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[15]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [15]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[16]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [16], \u2_ram/u2_wrrd/Sdr_rd_dout[16]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[16]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[16]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [16]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[17]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [17], \u2_ram/u2_wrrd/Sdr_rd_dout[17]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[17]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[17]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [17]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[18]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [18], \u2_ram/u2_wrrd/Sdr_rd_dout[18]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[18]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[18]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [18]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[19]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [19], \u2_ram/u2_wrrd/Sdr_rd_dout[19]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[19]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[19]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [19]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[1]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [1], \u2_ram/u2_wrrd/Sdr_rd_dout[1]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[1]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[1]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [1]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[20]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [20], \u2_ram/u2_wrrd/Sdr_rd_dout[20]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[20]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[20]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [20]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[21]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [21], \u2_ram/u2_wrrd/Sdr_rd_dout[21]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[21]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[21]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [21]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[22]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [22], \u2_ram/u2_wrrd/Sdr_rd_dout[22]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[22]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[22]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [22]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[23]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [23], \u2_ram/u2_wrrd/Sdr_rd_dout[23]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[23]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[23]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [23]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[24]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [24], \u2_ram/u2_wrrd/Sdr_rd_dout[24]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[24]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[24]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [24]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[25]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [25], \u2_ram/u2_wrrd/Sdr_rd_dout[25]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[25]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[25]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [25]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[26]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [26], \u2_ram/u2_wrrd/Sdr_rd_dout[26]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[26]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[26]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [26]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[27]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [27], \u2_ram/u2_wrrd/Sdr_rd_dout[27]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[27]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[27]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [27]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[28]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [28], \u2_ram/u2_wrrd/Sdr_rd_dout[28]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[28]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[28]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [28]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[29]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [29], \u2_ram/u2_wrrd/Sdr_rd_dout[29]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[29]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[29]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [29]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[2]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [2], \u2_ram/u2_wrrd/Sdr_rd_dout[2]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[2]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[2]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [2]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[30]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [30], \u2_ram/u2_wrrd/Sdr_rd_dout[30]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[30]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[30]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [30]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[31]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [31], \u2_ram/u2_wrrd/Sdr_rd_dout[31]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[31]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[31]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [31]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[3]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [3], \u2_ram/u2_wrrd/Sdr_rd_dout[3]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[3]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[3]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [3]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[4]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [4], \u2_ram/u2_wrrd/Sdr_rd_dout[4]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[4]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[4]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [4]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[5]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [5], \u2_ram/u2_wrrd/Sdr_rd_dout[5]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[5]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[5]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [5]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[6]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [6], \u2_ram/u2_wrrd/Sdr_rd_dout[6]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[6]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[6]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [6]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[7]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [7], \u2_ram/u2_wrrd/Sdr_rd_dout[7]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[7]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[7]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [7]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[8]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [8], \u2_ram/u2_wrrd/Sdr_rd_dout[8]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[8]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[8]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [8]);
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[9]_syn_1  (\u2_ram/u2_wrrd/Sdr_rd_dout [9], \u2_ram/u2_wrrd/Sdr_rd_dout[9]_syn_3 );
  buf \u2_ram/u2_wrrd/Sdr_rd_dout[9]_syn_2  (\u2_ram/u2_wrrd/Sdr_rd_dout[9]_syn_4 , \u2_ram/u2_wrrd/Sdr_rd_dout [9]);
  AL_MAP_LUT4 #(
    .EQN("(~B*~A*~(~D*~C))"),
    .INIT(16'h1110))
    \u2_ram/u2_wrrd/Sdr_ref_ack_n_syn_1  (
    .a(\u2_ram/App_rd_en ),
    .b(App_wr_en_dup_5),
    .c(\u2_ram/u2_wrrd/ref_ack ),
    .d(\u2_ram/u2_wrrd/wrrd_ref_ack ),
    .o(\u2_ram/u2_wrrd/Sdr_ref_ack_n ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/Sdr_ref_ack_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/Sdr_ref_ack_n ),
    .q(\u2_ram/u1_init_ref/Sdr_ref_ack ));
  buf \u2_ram/u2_wrrd/Sdr_ref_req_syn_1  (\u2_ram/u2_wrrd/Sdr_ref_req , 1'b0);
  buf \u2_ram/u2_wrrd/Sdr_ref_req_syn_2  (\u2_ram/u2_wrrd/Sdr_ref_req_syn_4 , \u2_ram/u2_wrrd/Sdr_ref_req );
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_ba_b1[0]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [2]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [2]),
    .o(\u2_ram/u2_wrrd/active_ba_b1 [0]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_ba_b1[1]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [3]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [3]),
    .o(\u2_ram/u2_wrrd/active_ba_b1 [1]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_ba_reg[0]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_ba_b1 [0]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_ba [0]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_ba_reg[1]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_ba_b1 [1]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_ba [1]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_col_b1[0]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_4d [0]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_4d [0]),
    .o(\u2_ram/u2_wrrd/active_col_b1 [0]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_col_b1[1]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_4d [1]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_4d [1]),
    .o(\u2_ram/u2_wrrd/active_col_b1 [1]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_col_b1[2]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_4d [4]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_4d [4]),
    .o(\u2_ram/u2_wrrd/active_col_b1 [2]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_col_b1[3]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_4d [5]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_4d [5]),
    .o(\u2_ram/u2_wrrd/active_col_b1 [3]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_col_b1[4]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_4d [6]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_4d [6]),
    .o(\u2_ram/u2_wrrd/active_col_b1 [4]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_col_b1[5]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_4d [7]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_4d [7]),
    .o(\u2_ram/u2_wrrd/active_col_b1 [5]));
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \u2_ram/u2_wrrd/active_col_b1[6]_syn_1  (
    .a(\u2_ram/u2_wrrd/app_wr_en_sft [0]),
    .b(\u2_ram/u2_wrrd/cnt4 [0]),
    .c(\u2_ram/u2_wrrd/cnt4 [1]),
    .o(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_col_b1[6]_syn_3  (
    .a(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_4d [8]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_4d [8]),
    .o(\u2_ram/u2_wrrd/active_col_b1 [6]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_col_b1[7]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_col_b1[6]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_4d [9]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_4d [9]),
    .o(\u2_ram/u2_wrrd/active_col_b1 [7]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_col_reg[0]  (
    .ce(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_col_b1 [0]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_col [0]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_col_reg[1]  (
    .ce(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_col_b1 [1]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_col [1]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_col_reg[2]  (
    .ce(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_col_b1 [2]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_col [2]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_col_reg[3]  (
    .ce(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_col_b1 [3]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_col [3]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_col_reg[4]  (
    .ce(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_col_b1 [4]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_col [4]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_col_reg[5]  (
    .ce(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_col_b1 [5]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_col [5]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_col_reg[6]  (
    .ce(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_col_b1 [6]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_col [6]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_col_reg[7]  (
    .ce(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_col_b1 [7]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_col [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/active_en_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_en_reg_syn_3 ),
    .q(\u2_ram/u2_wrrd/active_en ));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u2_ram/u2_wrrd/active_en_reg_syn_4  (
    .a(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .b(Rst_dup_175),
    .o(\u2_ram/u2_wrrd/active_en_reg_syn_3 ));
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u2_ram/u2_wrrd/active_en_syn_15  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .o(\u2_ram/u2_wrrd/active_en_syn_2 ));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[0]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [10]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [10]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [0]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[10]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [20]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [20]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [10]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[1]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [11]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [11]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [1]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[2]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [12]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [12]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [2]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[3]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [13]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [13]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [3]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[4]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [14]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [14]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [4]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[5]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [15]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [15]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [5]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[6]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [16]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [16]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [6]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[7]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [17]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [17]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [7]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[8]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [18]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [18]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [8]));
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*A)"),
    .INIT(8'h02))
    \u2_ram/u2_wrrd/active_row_b1[9]_syn_1  (
    .a(\u2_ram/u2_wrrd/app_wr_en_sft [0]),
    .b(\u2_ram/u2_wrrd/cnt4 [0]),
    .c(\u2_ram/u2_wrrd/cnt4 [1]),
    .o(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/active_row_b1[9]_syn_3  (
    .a(\u2_ram/u2_wrrd/active_row_b1[9]_syn_2 ),
    .b(\u2_ram/u2_wrrd/app_rd_addr_1d [19]),
    .c(\u2_ram/u2_wrrd/app_wr_addr_1d [19]),
    .o(\u2_ram/u2_wrrd/active_row_b1 [9]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[0]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [0]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [0]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[10]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [10]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [10]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[1]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [1]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [1]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[2]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [2]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [2]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[3]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [3]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [3]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[4]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [4]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [4]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[5]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [5]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [5]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[6]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [6]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [6]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[7]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [7]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [7]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[8]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [8]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [8]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/active_row_reg[9]  (
    .ce(\u2_ram/u2_wrrd/mux21_syn_2 [0]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_row_b1 [9]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/active_row [9]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/addr_b[0]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_col [0]),
    .c(\u2_ram/u2_wrrd/active_row [0]),
    .o(\u2_ram/u2_wrrd/addr_b [0]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*A)"),
    .INIT(4'hd))
    \u2_ram/u2_wrrd/addr_b[10]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_row [10]),
    .o(\u2_ram/u2_wrrd/addr_b [10]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/addr_b[1]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_col [1]),
    .c(\u2_ram/u2_wrrd/active_row [1]),
    .o(\u2_ram/u2_wrrd/addr_b [1]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/addr_b[2]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_col [2]),
    .c(\u2_ram/u2_wrrd/active_row [2]),
    .o(\u2_ram/u2_wrrd/addr_b [2]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/addr_b[3]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_col [3]),
    .c(\u2_ram/u2_wrrd/active_row [3]),
    .o(\u2_ram/u2_wrrd/addr_b [3]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/addr_b[4]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_col [4]),
    .c(\u2_ram/u2_wrrd/active_row [4]),
    .o(\u2_ram/u2_wrrd/addr_b [4]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/addr_b[5]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_col [5]),
    .c(\u2_ram/u2_wrrd/active_row [5]),
    .o(\u2_ram/u2_wrrd/addr_b [5]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/addr_b[6]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_col [6]),
    .c(\u2_ram/u2_wrrd/active_row [6]),
    .o(\u2_ram/u2_wrrd/addr_b [6]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u2_ram/u2_wrrd/addr_b[7]_syn_1  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_col [7]),
    .c(\u2_ram/u2_wrrd/active_row [7]),
    .o(\u2_ram/u2_wrrd/addr_b [7]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[0]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [0]),
    .q(\u2_ram/u2_wrrd/addr [0]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[10]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [10]),
    .q(\u2_ram/u2_wrrd/addr [10]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[1]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [1]),
    .q(\u2_ram/u2_wrrd/addr [1]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[2]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [2]),
    .q(\u2_ram/u2_wrrd/addr [2]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[3]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [3]),
    .q(\u2_ram/u2_wrrd/addr [3]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[4]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [4]),
    .q(\u2_ram/u2_wrrd/addr [4]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[5]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [5]),
    .q(\u2_ram/u2_wrrd/addr [5]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[6]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [6]),
    .q(\u2_ram/u2_wrrd/addr [6]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[7]  (
    .ce(\u2_ram/u2_wrrd/mux4_syn_2 [10]),
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_b [7]),
    .q(\u2_ram/u2_wrrd/addr [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_reg[8]_syn_2 ),
    .q(\u2_ram/u2_wrrd/addr [8]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u2_ram/u2_wrrd/addr_reg[8]_syn_3  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_row [8]),
    .c(\u2_ram/u2_wrrd/addr [8]),
    .o(\u2_ram/u2_wrrd/addr_reg[8]_syn_2 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/addr_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/addr_reg[9]_syn_2 ),
    .q(\u2_ram/u2_wrrd/addr [9]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u2_ram/u2_wrrd/addr_reg[9]_syn_3  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_row [9]),
    .c(\u2_ram/u2_wrrd/addr [9]),
    .o(\u2_ram/u2_wrrd/addr_reg[9]_syn_2 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_2d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_1d [0]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_2d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_2d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_1d [1]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_2d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_2d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_1d [4]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_2d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_2d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_1d [5]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_2d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_2d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_1d [6]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_2d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_2d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_1d [7]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_2d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_2d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_1d [8]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_2d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_2d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_1d [9]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_2d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_3d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_2d [0]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_3d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_3d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_2d [1]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_3d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_3d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_2d [4]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_3d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_3d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_2d [5]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_3d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_3d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_2d [6]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_3d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_3d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_2d [7]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_3d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_3d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_2d [8]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_3d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_3d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_2d [9]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_3d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_4d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_3d [0]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_4d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_4d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_3d [1]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_4d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_4d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_3d [4]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_4d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_4d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_3d [5]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_4d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_4d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_3d [6]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_4d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_4d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_3d [7]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_4d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_4d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_3d [8]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_4d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_rd_addr_4d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_addr_3d [9]),
    .q(\u2_ram/u2_wrrd/app_rd_addr_4d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/App_rd_en ),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [9]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [10]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [0]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [1]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [2]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [3]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [4]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [5]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [6]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [7]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_rd_en_sft_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [8]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_rd_en_sft [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_2d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_1d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_2d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_2d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_1d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_2d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_2d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_1d [4]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_2d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_2d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_1d [5]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_2d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_2d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_1d [6]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_2d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_2d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_1d [7]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_2d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_2d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_1d [8]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_2d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_2d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_1d [9]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_2d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_3d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_2d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_3d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_3d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_2d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_3d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_3d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_2d [4]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_3d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_3d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_2d [5]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_3d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_3d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_2d [6]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_3d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_3d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_2d [7]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_3d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_3d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_2d [8]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_3d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_3d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_2d [9]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_3d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_4d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_3d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_4d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_4d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_3d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_4d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_4d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_3d [4]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_4d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_4d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_3d [5]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_4d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_4d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_3d [6]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_4d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_4d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_3d [7]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_4d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_4d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_3d [8]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_4d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_addr_4d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_addr_3d [9]),
    .q(\u2_ram/u2_wrrd/app_wr_addr_4d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [10]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [10]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[11]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [11]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [11]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[12]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [12]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [12]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[13]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [13]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [13]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[14]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [14]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [14]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[15]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [15]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [15]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[16]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [16]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [16]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[17]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [17]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [17]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[18]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [18]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [18]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[19]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [19]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [19]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[20]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [20]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [20]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[21]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [21]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [21]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[22]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [22]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [22]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[23]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [23]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [23]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[24]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [24]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [24]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[25]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [25]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [25]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[26]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [26]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [26]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[27]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [27]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [27]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[28]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [28]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [28]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[29]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [29]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [29]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[30]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [30]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [30]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[31]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [31]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [31]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [4]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [5]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [6]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [7]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [8]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_2d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_1d [9]),
    .q(\u2_ram/u2_wrrd/app_wr_din_2d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [10]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [10]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[11]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [11]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [11]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[12]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [12]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [12]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[13]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [13]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [13]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[14]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [14]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [14]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[15]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [15]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [15]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[16]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [16]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [16]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[17]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [17]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [17]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[18]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [18]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [18]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[19]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [19]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [19]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[20]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [20]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [20]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[21]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [21]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [21]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[22]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [22]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [22]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[23]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [23]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [23]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[24]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [24]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [24]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[25]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [25]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [25]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[26]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [26]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [26]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[27]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [27]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [27]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[28]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [28]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [28]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[29]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [29]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [29]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[30]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [30]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [30]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[31]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [31]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [31]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [4]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [5]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [6]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [7]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [8]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_3d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_2d [9]),
    .q(\u2_ram/u2_wrrd/app_wr_din_3d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [10]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [10]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[11]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [11]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [11]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[12]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [12]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [12]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[13]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [13]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [13]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[14]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [14]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [14]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[15]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [15]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [15]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[16]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [16]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [16]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[17]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [17]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [17]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[18]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [18]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [18]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[19]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [19]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [19]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[20]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [20]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [20]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[21]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [21]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [21]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[22]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [22]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [22]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[23]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [23]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [23]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[24]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [24]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [24]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[25]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [25]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [25]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[26]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [26]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [26]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[27]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [27]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [27]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[28]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [28]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [28]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[29]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [29]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [29]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[30]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [30]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [30]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[31]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [31]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [31]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [4]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [5]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [6]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [7]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [8]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_4d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_3d [9]),
    .q(\u2_ram/u2_wrrd/app_wr_din_4d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [10]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [10]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[11]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [11]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [11]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[12]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [12]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [12]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[13]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [13]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [13]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[14]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [14]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [14]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[15]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [15]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [15]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[16]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [16]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [16]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[17]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [17]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [17]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[18]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [18]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [18]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[19]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [19]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [19]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[20]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [20]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [20]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[21]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [21]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [21]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[22]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [22]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [22]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[23]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [23]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [23]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[24]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [24]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [24]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[25]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [25]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [25]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[26]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [26]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [26]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[27]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [27]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [27]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[28]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [28]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [28]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[29]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [29]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [29]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[30]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [30]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [30]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[31]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [31]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [31]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [4]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [5]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [6]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [7]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [8]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_5d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_4d [9]),
    .q(\u2_ram/u2_wrrd/app_wr_din_5d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[10]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [10]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [10]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[11]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [11]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [11]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[12]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [12]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [12]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[13]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [13]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [13]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[14]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [14]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [14]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[15]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [15]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [15]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[16]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [16]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [16]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[17]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [17]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [17]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[18]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [18]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [18]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[19]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [19]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [19]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[20]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [20]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [20]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[21]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [21]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [21]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[22]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [22]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [22]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[23]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [23]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [23]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[24]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [24]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [24]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[25]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [25]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [25]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[26]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [26]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [26]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[27]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [27]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [27]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[28]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [28]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [28]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[29]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [29]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [29]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[30]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [30]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [30]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[31]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [31]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [31]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [4]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [5]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [6]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [7]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[8]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [8]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [8]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_din_6d_reg[9]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_din_5d [9]),
    .q(\u2_ram/u2_wrrd/app_wr_din_6d [9]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_2d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_1d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_2d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_2d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_1d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_2d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_2d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_1d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_2d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_2d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_1d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_2d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_3d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_2d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_3d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_3d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_2d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_3d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_3d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_2d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_3d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_3d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_2d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_3d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_4d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_3d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_4d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_4d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_3d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_4d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_4d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_3d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_4d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_4d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_3d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_4d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_5d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_4d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_5d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_5d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_4d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_5d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_5d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_4d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_5d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_5d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_4d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_5d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_6d_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_5d [0]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_6d [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_6d_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_5d [1]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_6d [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_6d_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_5d [2]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_6d [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/app_wr_dm_6d_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_dm_5d [3]),
    .q(\u2_ram/u2_wrrd/app_wr_dm_6d [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_wr_en_sft_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [0]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_wr_en_sft [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_wr_en_sft_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [1]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_wr_en_sft [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_wr_en_sft_reg[3]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [2]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_wr_en_sft [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_wr_en_sft_reg[4]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [3]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_wr_en_sft [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_wr_en_sft_reg[5]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [4]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_wr_en_sft [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_wr_en_sft_reg[6]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [5]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_wr_en_sft [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/app_wr_en_sft_reg[7]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [6]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/app_wr_en_sft [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/ba_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/ba_reg[0]_syn_2 ),
    .q(\u2_ram/u2_wrrd/ba [0]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u2_ram/u2_wrrd/ba_reg[0]_syn_3  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_ba [0]),
    .c(\u2_ram/u2_wrrd/ba [0]),
    .o(\u2_ram/u2_wrrd/ba_reg[0]_syn_2 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/ba_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/ba_reg[1]_syn_2 ),
    .q(\u2_ram/u2_wrrd/ba [1]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u2_ram/u2_wrrd/ba_reg[1]_syn_3  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/active_ba [1]),
    .c(\u2_ram/u2_wrrd/ba [1]),
    .o(\u2_ram/u2_wrrd/ba_reg[1]_syn_2 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/cas_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/cas_reg_syn_3 ),
    .q(\u2_ram/u2_wrrd/cas ));
  AL_MAP_LUT4 #(
    .EQN("~(B*~A*(D@C))"),
    .INIT(16'hfbbf))
    \u2_ram/u2_wrrd/cas_reg_syn_4  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/col_en ),
    .c(\u2_ram/u2_wrrd/app_rd_en_sft [1]),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [1]),
    .o(\u2_ram/u2_wrrd/cas_reg_syn_3 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/cnt4_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/cnt4_reg[0]_syn_2 ),
    .q(\u2_ram/u2_wrrd/cnt4 [0]));
  AL_MAP_LUT3 #(
    .EQN("(~B*~(~C*~A))"),
    .INIT(8'h32))
    \u2_ram/u2_wrrd/cnt4_reg[0]_syn_3  (
    .a(\u2_ram/u2_wrrd/app_wr_en_sft [0]),
    .b(Rst_dup_175),
    .c(\u2_ram/u2_wrrd/app_rd_en_sft [0]),
    .o(\u2_ram/u2_wrrd/cnt4_reg[0]_syn_4 ));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u2_ram/u2_wrrd/cnt4_reg[0]_syn_5  (
    .a(\u2_ram/u2_wrrd/cnt4_reg[0]_syn_4 ),
    .b(\u2_ram/u2_wrrd/cnt4 [0]),
    .o(\u2_ram/u2_wrrd/cnt4_reg[0]_syn_2 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/cnt4_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/cnt4_reg[1]_syn_2 ),
    .q(\u2_ram/u2_wrrd/cnt4 [1]));
  AL_MAP_LUT3 #(
    .EQN("(A*(C@B))"),
    .INIT(8'h28))
    \u2_ram/u2_wrrd/cnt4_reg[1]_syn_3  (
    .a(\u2_ram/u2_wrrd/cnt4_reg[0]_syn_4 ),
    .b(\u2_ram/u2_wrrd/cnt4 [0]),
    .c(\u2_ram/u2_wrrd/cnt4 [1]),
    .o(\u2_ram/u2_wrrd/cnt4_reg[1]_syn_2 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/col_en_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/col_en_reg_syn_3 ),
    .q(\u2_ram/u2_wrrd/col_en ));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u2_ram/u2_wrrd/col_en_reg_syn_4  (
    .a(\u2_ram/u2_wrrd/mux1_syn_2 [7]),
    .b(Rst_dup_175),
    .o(\u2_ram/u2_wrrd/col_en_reg_syn_3 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/init_ref_vld_1d_reg  (
    .clk(Clk_dup_1),
    .d(Sdr_init_ref_vld_dup_1),
    .q(\u2_ram/u2_wrrd/init_ref_vld_1d ));
  AL_MAP_LUT4 #(
    .EQN("(D*C*~(~B*~A))"),
    .INIT(16'he000))
    \u2_ram/u2_wrrd/mux1_syn_71  (
    .a(\u2_ram/u2_wrrd/app_wr_en_sft [0]),
    .b(\u2_ram/u2_wrrd/app_rd_en_sft [0]),
    .c(\u2_ram/u2_wrrd/cnt4 [0]),
    .d(\u2_ram/u2_wrrd/cnt4 [1]),
    .o(\u2_ram/u2_wrrd/mux1_syn_2 [7]));
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~(~B*~A))"),
    .INIT(16'h000e))
    \u2_ram/u2_wrrd/mux21_syn_23  (
    .a(\u2_ram/u2_wrrd/app_wr_en_sft [0]),
    .b(\u2_ram/u2_wrrd/app_rd_en_sft [0]),
    .c(\u2_ram/u2_wrrd/cnt4 [0]),
    .d(\u2_ram/u2_wrrd/cnt4 [1]),
    .o(\u2_ram/u2_wrrd/mux21_syn_2 [0]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u2_ram/u2_wrrd/mux4_syn_85  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/col_en ),
    .o(\u2_ram/u2_wrrd/mux4_syn_2 [10]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u2_ram/u2_wrrd/mux9_syn_22  (
    .a(\u2_ram/u2_wrrd/ref_vld ),
    .b(\u2_ram/u2_wrrd/sdr_op_over ),
    .o(\u2_ram/u2_wrrd/mux9_syn_1 [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/ras_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/active_en_syn_2 ),
    .q(\u2_ram/u2_wrrd/ras ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/ref_ack_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/ref_ack_reg_syn_3 ),
    .q(\u2_ram/u2_wrrd/ref_ack ));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u2_ram/u2_wrrd/ref_ack_reg_syn_4  (
    .a(\u2_ram/u2_wrrd/rw_vld ),
    .b(\u2_ram/u2_wrrd/Sdr_ref_req_syn_4 ),
    .o(\u2_ram/u2_wrrd/ref_ack_reg_syn_3 ));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u2_ram/u2_wrrd/ref_over_n_syn_1  (
    .a(\u2_ram/u1_init_ref/init_vld ),
    .b(\u2_ram/u1_init_ref/ref_vld ),
    .o(Sdr_init_ref_vld_dup_1));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u2_ram/u2_wrrd/ref_over_n_syn_2  (
    .a(Sdr_init_ref_vld_dup_1),
    .b(\u2_ram/u2_wrrd/init_ref_vld_1d ),
    .o(\u2_ram/u2_wrrd/ref_over_n ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/ref_over_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/ref_over_n ),
    .q(\u2_ram/u2_wrrd/ref_over ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/ref_vld_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/ref_vld_reg_syn_5 ),
    .q(\u2_ram/u2_wrrd/ref_vld ));
  AL_MAP_LUT3 #(
    .EQN("(~A*~(~C*~B))"),
    .INIT(8'h54))
    \u2_ram/u2_wrrd/ref_vld_reg_syn_6  (
    .a(\u2_ram/u2_wrrd/ref_over ),
    .b(\u2_ram/u2_wrrd/ref_vld ),
    .c(\u2_ram/u2_wrrd/Sdr_ref_req_syn_4 ),
    .o(\u2_ram/u2_wrrd/ref_vld_reg_syn_5 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/rw_vld_1d_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/rw_vld ),
    .q(\u2_ram/u2_wrrd/rw_vld_1d ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/rw_vld_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/rw_vld_reg_syn_5 ),
    .q(\u2_ram/u2_wrrd/rw_vld ));
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \u2_ram/u2_wrrd/rw_vld_reg_syn_6  (
    .a(\u2_ram/u2_wrrd/app_wr_en_sft [0]),
    .b(\u2_ram/u2_wrrd/rw_vld ),
    .c(\u2_ram/u2_wrrd/app_rd_en_sft [0]),
    .o(\u2_ram/u2_wrrd/rw_vld_reg_syn_7 ));
  AL_MAP_LUT4 #(
    .EQN("(B*~A*~(D*~C))"),
    .INIT(16'h4044))
    \u2_ram/u2_wrrd/rw_vld_reg_syn_8  (
    .a(\u2_ram/u2_wrrd/rw_vld_reg_syn_7 ),
    .b(\u2_ram/u2_wrrd/sdr_t_reg_syn_7 ),
    .c(\u2_ram/u2_wrrd/app_rd_en_sft [9]),
    .d(\u2_ram/u2_wrrd/app_rd_en_sft [10]),
    .o(\u2_ram/u2_wrrd/rw_vld_reg_syn_5 ));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u2_ram/u2_wrrd/sdr_op_over_n_syn_1  (
    .a(\u2_ram/u2_wrrd/rw_vld_1d ),
    .b(\u2_ram/u2_wrrd/rw_vld ),
    .o(\u2_ram/u2_wrrd/sdr_op_over_n ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/sdr_op_over_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/sdr_op_over_n ),
    .q(\u2_ram/u2_wrrd/sdr_op_over ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/sdr_t_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/sdr_t_reg_syn_5 ),
    .q(\u2_ram/u2_wrrd/sdr_t ));
  AL_MAP_LUT3 #(
    .EQN("(~A*~(C*~B))"),
    .INIT(8'h45))
    \u2_ram/u2_wrrd/sdr_t_reg_syn_6  (
    .a(Rst_dup_175),
    .b(\u2_ram/u2_wrrd/app_wr_en_sft [6]),
    .c(\u2_ram/u2_wrrd/app_wr_en_sft [7]),
    .o(\u2_ram/u2_wrrd/sdr_t_reg_syn_7 ));
  AL_MAP_LUT5 #(
    .EQN("~(~(~E*~C*B)*~(D*A))"),
    .INIT(32'haa00ae0c))
    \u2_ram/u2_wrrd/sdr_t_reg_syn_8  (
    .a(\u2_ram/u2_wrrd/sdr_t_reg_syn_7 ),
    .b(\u2_ram/u2_wrrd/app_wr_en_sft [0]),
    .c(Rst_dup_175),
    .d(\u2_ram/u2_wrrd/sdr_t ),
    .e(\u2_ram/u2_wrrd/app_wr_en_sft [1]),
    .o(\u2_ram/u2_wrrd/sdr_t_reg_syn_5 ));
  AL_MAP_LUT5 #(
    .EQN("~(~B*~A*~(E*~D*~C))"),
    .INIT(32'heeefeeee))
    \u2_ram/u2_wrrd/sel2_syn_100  (
    .a(\u2_ram/u2_wrrd/sel2_syn_97 ),
    .b(\u2_ram/u2_wrrd/sel2_syn_99 ),
    .c(\u2_ram/u2_wrrd/ref_vld ),
    .d(\u2_ram/u2_wrrd/rw_vld ),
    .e(\u2_ram/u2_wrrd/state_reg_syn_1 [0]),
    .o(\u2_ram/u2_wrrd/sel2_syn_1 [0]));
  AL_MAP_LUT4 #(
    .EQN("~(~(D*~B)*~(C*A))"),
    .INIT(16'hb3a0))
    \u2_ram/u2_wrrd/sel2_syn_90  (
    .a(\u2_ram/u2_wrrd/rw_vld ),
    .b(\u2_ram/u2_wrrd/sdr_op_over ),
    .c(\u2_ram/u2_wrrd/state_reg_syn_1 [0]),
    .d(\u2_ram/u2_wrrd/state_reg_syn_1 [1]),
    .o(\u2_ram/u2_wrrd/sel2_syn_1 [1]));
  AL_MAP_LUT3 #(
    .EQN("(C*B*A)"),
    .INIT(8'h80))
    \u2_ram/u2_wrrd/sel2_syn_91  (
    .a(\u2_ram/u2_wrrd/ref_vld ),
    .b(\u2_ram/u2_wrrd/sdr_op_over ),
    .c(\u2_ram/u2_wrrd/state_reg_syn_1 [1]),
    .o(\u2_ram/u2_wrrd/sel2_syn_92 ));
  AL_MAP_LUT3 #(
    .EQN("(C*~B*A)"),
    .INIT(8'h20))
    \u2_ram/u2_wrrd/sel2_syn_93  (
    .a(\u2_ram/u2_wrrd/ref_vld ),
    .b(\u2_ram/u2_wrrd/rw_vld ),
    .c(\u2_ram/u2_wrrd/state_reg_syn_1 [0]),
    .o(\u2_ram/u2_wrrd/sel2_syn_94 ));
  AL_MAP_LUT4 #(
    .EQN("~(~B*~A*~(D*~C))"),
    .INIT(16'hefee))
    \u2_ram/u2_wrrd/sel2_syn_95  (
    .a(\u2_ram/u2_wrrd/sel2_syn_92 ),
    .b(\u2_ram/u2_wrrd/sel2_syn_94 ),
    .c(\u2_ram/u2_wrrd/ref_over ),
    .d(\u2_ram/u2_wrrd/state_reg_syn_1 [2]),
    .o(\u2_ram/u2_wrrd/sel2_syn_1 [2]));
  AL_MAP_LUT5 #(
    .EQN("(D*~(~(C*~B)*~(E*A)))"),
    .INIT(32'hba003000))
    \u2_ram/u2_wrrd/sel2_syn_96  (
    .a(\u2_ram/u2_wrrd/ref_over ),
    .b(\u2_ram/u2_wrrd/ref_vld ),
    .c(\u2_ram/u2_wrrd/sdr_op_over ),
    .d(\u2_ram/u2_wrrd/state_reg_syn_1 [1]),
    .e(\u2_ram/u2_wrrd/state_reg_syn_1 [2]),
    .o(\u2_ram/u2_wrrd/sel2_syn_97 ));
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+A*B*C*D)"),
    .INIT(16'h8a03))
    \u2_ram/u2_wrrd/sel2_syn_98  (
    .a(\u2_ram/u2_wrrd/ref_over ),
    .b(\u2_ram/u2_wrrd/state_reg_syn_1 [0]),
    .c(\u2_ram/u2_wrrd/state_reg_syn_1 [1]),
    .d(\u2_ram/u2_wrrd/state_reg_syn_1 [2]),
    .o(\u2_ram/u2_wrrd/sel2_syn_99 ));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/state_reg[0]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/sel2_syn_1 [0]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/state_reg_syn_1 [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/state_reg[1]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/sel2_syn_1 [1]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/state_reg_syn_1 [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("SYNC"),
    .SRMUX("SR"))
    \u2_ram/u2_wrrd/state_reg[2]  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/sel2_syn_1 [2]),
    .sr(Rst_dup_175),
    .q(\u2_ram/u2_wrrd/state_reg_syn_1 [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/we_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/we_reg_syn_3 ),
    .q(\u2_ram/u2_wrrd/we ));
  AL_MAP_LUT4 #(
    .EQN("~(D*~C*B*~A)"),
    .INIT(16'hfbff))
    \u2_ram/u2_wrrd/we_reg_syn_4  (
    .a(\u2_ram/u2_wrrd/active_en ),
    .b(\u2_ram/u2_wrrd/col_en ),
    .c(\u2_ram/u2_wrrd/app_rd_en_sft [1]),
    .d(\u2_ram/u2_wrrd/app_wr_en_sft [1]),
    .o(\u2_ram/u2_wrrd/we_reg_syn_3 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u2_ram/u2_wrrd/wrrd_ref_ack_reg  (
    .clk(Clk_dup_1),
    .d(\u2_ram/u2_wrrd/mux9_syn_1 [2]),
    .q(\u2_ram/u2_wrrd/wrrd_ref_ack ));

endmodule 

