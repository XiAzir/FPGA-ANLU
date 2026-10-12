// Verilog netlist created by Tang Dynasty v6.2.178840
// Sun Oct 11 14:22:41 2026

`timescale 1ns / 1ps
module cw_smoke_top  // smoke.sv(14)
  (
  clk,
  rst,
  led
  );

  input clk;  // smoke.sv(14)
  input rst;  // smoke.sv(14)
  output led;  // smoke.sv(14)

  wire [15:0] count;  // smoke.sv(15)
  wire [15:0] count_b;
  wire [71:0] \u_watch/cwc_control ;  // cw_smoke_ip_watcherInst.sv(20)
  wire [23:0] \u_watch/cwc_status ;  // cw_smoke_ip_watcherInst.sv(21)
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 ;
  wire [6:0] \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr ;
  wire [51:0] \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b ;
  wire [71:0] \u_watch/wrapper_cwc_top/U_cwc/control ;
  wire [2:0] \u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/force_acq_len ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg ;
  wire [7:0] \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 ;
  wire [19:0] \u_watch/wrapper_cwc_top/U_cwc/main_control ;
  wire [6:0] \u_watch/wrapper_cwc_top/U_cwc/stop_len ;
  wire [6:0] \u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 ;
  wire [0:0] \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en ;
  wire [6:0] \u_watch/wrapper_cwc_top/U_cwc/trig_length ;
  wire [6:0] \u_watch/wrapper_cwc_top/U_cwc/trig_position ;
  wire  \u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ;
  wire [6:0] \u_watch/wrapper_cwc_top/U_cwc_ram/addra ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc_ram/dia  /* synthesis keep=true */ ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc_ram/doa ;
  wire [15:0] \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep  /* synthesis keep=true */ ;
  wire [3:0] \u_watch/wrapper_cwc_top/cnt_b ;
  wire [71:0] \u_watch/wrapper_cwc_top/cwc_control  /* synthesis keep=true */ ;
  wire [23:0] \u_watch/wrapper_cwc_top/cwc_status  /* synthesis keep=true */ ;
  wire [15:0] \u_watch/wrapper_cwc_top/ram_data ;
  wire [23:0] \u_watch/wrapper_cwc_top/status_pipe/data_in ;
  wire [23:0] \u_watch/wrapper_cwc_top/status_pipe/data_out ;
  wire [15:0] \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 ;
  wire [15:0] \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 ;
  wire [15:0] \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 ;
  wire [15:0] \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 ;
  wire [15:0] \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 ;
  wire add0_syn_84;  // smoke.sv(18)
  wire add0_syn_88;  // smoke.sv(18)
  wire add0_syn_92;  // smoke.sv(18)
  wire add0_syn_96;  // smoke.sv(18)
  wire clk_dup_1;  // smoke.sv(14)
  wire \count[0]_syn_2 ;  // smoke.sv(15)
  wire led_dup_3;  // smoke.sv(14)
  wire rst_dup_1;  // smoke.sv(14)
  wire \u_watch/wrapper_cwc_top/U_cwc/add0_syn_44 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/add0_syn_48 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/add1_syn_39 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/emb_store_en_reg_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_5 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_9 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_13 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_17 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_5 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_9 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_13 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_17 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/sub0_syn_40 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/sub1_syn_43 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/sub1_syn_47 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg[0]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_6 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_8 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_10 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_12 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_14 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_16 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_18 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_44 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_48 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_44 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_48 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_5 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_9 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_13 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_17 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_6 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_reg_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_5 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_9 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_13 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_17 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_21 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_25 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_29 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_33 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_36 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_5 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_9 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_13 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_17 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_21 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_25 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_29 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_33 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_36 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_6 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_8 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_10 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_12 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_14 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_16 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_18 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_20 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[15]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[15]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[14]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[14]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[13]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[13]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[12]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[12]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[11]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[11]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[10]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[10]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[9]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[9]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[8]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[8]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[7]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[7]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[6]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[6]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[5]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[5]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[4]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[4]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[3]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[3]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[2]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[2]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[1]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[1]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[0]_syn_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/dia[0]_syn_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/mem_n ;
  wire \u_watch/wrapper_cwc_top/status_pipe/data_in[18]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[0]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[0]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[1]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[2]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[3]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[4]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[5]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[6]_syn_2 ;
  wire \u_watch/wrapper_cwc_top/cwc_wt_ce ;
  wire \u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/mux1_syn_14 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/mux1_syn_22 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/emb_store_en ;
  wire \u_watch/wrapper_cwc_top/U_cwc/force_acq_fin ;
  wire \u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/state_rstn ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n ;
  wire \u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_pause ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_pause_sync0 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trig_rstn ;
  wire \u_watch/wrapper_cwc_top/U_cwc/trigger_or_en ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq0_syn_50 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq1_syn_44 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq1_syn_47 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/pause ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_n1 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_ce_n2_syn_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_0 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_2 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_3 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_5 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n4 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n5 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n6 ;
  wire \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n7 ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/cea ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/clka ;
  wire \u_watch/wrapper_cwc_top/U_cwc_ram/wea ;

  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_98"),
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
    add0_syn_100 (
    .a({count[9],count[7]}),
    .b({count[10],count[8]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(add0_syn_88),
    .f({count_b[9],count_b[7]}),
    .fco(add0_syn_92),
    .fx({count_b[10],count_b[8]}));  // smoke.sv(18)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_98"),
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
    add0_syn_101 (
    .a({count[13],count[11]}),
    .b({count[14],count[12]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(add0_syn_92),
    .f({count_b[13],count_b[11]}),
    .fco(add0_syn_96),
    .fx({count_b[14],count_b[12]}));  // smoke.sv(18)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_98"),
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
    add0_syn_102 (
    .a({open_n36,led_dup_3}),
    .c(2'b00),
    .d({open_n41,1'b0}),
    .fci(add0_syn_96),
    .f({open_n58,count_b[15]}));  // smoke.sv(18)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_98"),
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
    add0_syn_98 (
    .a({count[1],1'b0}),
    .b({count[2],count[0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({count_b[1],open_n81}),
    .fco(add0_syn_84),
    .fx({count_b[2],open_n82}));  // smoke.sv(18)
  EG_PHY_LSLICE #(
    //.MACRO("add0_syn_98"),
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
    add0_syn_99 (
    .a({count[5],count[3]}),
    .b({count[6],count[4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(add0_syn_84),
    .f({count_b[5],count_b[3]}),
    .fco(add0_syn_88),
    .fx({count_b[6],count_b[4]}));  // smoke.sv(18)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    clk_syn_2 (
    .ipad(clk),
    .di(clk_dup_1));  // smoke.sv(14)
  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \count[0]_syn_5  (
    .a(count[0]),
    .o(\count[0]_syn_2 ));  // smoke.sv(15)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[0]  (
    .clk(clk_dup_1),
    .d(\count[0]_syn_2 ),
    .sr(rst_dup_1),
    .q(count[0]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[10]  (
    .clk(clk_dup_1),
    .d(count_b[10]),
    .sr(rst_dup_1),
    .q(count[10]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[11]  (
    .clk(clk_dup_1),
    .d(count_b[11]),
    .sr(rst_dup_1),
    .q(count[11]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[12]  (
    .clk(clk_dup_1),
    .d(count_b[12]),
    .sr(rst_dup_1),
    .q(count[12]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[13]  (
    .clk(clk_dup_1),
    .d(count_b[13]),
    .sr(rst_dup_1),
    .q(count[13]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[14]  (
    .clk(clk_dup_1),
    .d(count_b[14]),
    .sr(rst_dup_1),
    .q(count[14]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[15]  (
    .clk(clk_dup_1),
    .d(count_b[15]),
    .sr(rst_dup_1),
    .q(led_dup_3));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[1]  (
    .clk(clk_dup_1),
    .d(count_b[1]),
    .sr(rst_dup_1),
    .q(count[1]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[2]  (
    .clk(clk_dup_1),
    .d(count_b[2]),
    .sr(rst_dup_1),
    .q(count[2]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[3]  (
    .clk(clk_dup_1),
    .d(count_b[3]),
    .sr(rst_dup_1),
    .q(count[3]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[4]  (
    .clk(clk_dup_1),
    .d(count_b[4]),
    .sr(rst_dup_1),
    .q(count[4]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[5]  (
    .clk(clk_dup_1),
    .d(count_b[5]),
    .sr(rst_dup_1),
    .q(count[5]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[6]  (
    .clk(clk_dup_1),
    .d(count_b[6]),
    .sr(rst_dup_1),
    .q(count[6]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[7]  (
    .clk(clk_dup_1),
    .d(count_b[7]),
    .sr(rst_dup_1),
    .q(count[7]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[8]  (
    .clk(clk_dup_1),
    .d(count_b[8]),
    .sr(rst_dup_1),
    .q(count[8]));  // smoke.sv(17)
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("SR"))
    \count_reg[9]  (
    .clk(clk_dup_1),
    .d(count_b[9]),
    .sr(rst_dup_1),
    .q(count[9]));  // smoke.sv(17)
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
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    led_syn_4 (
    .do({open_n184,open_n185,open_n186,count_b[15]}),
    .osclk(clk_dup_1),
    .rst(rst_dup_1),
    .opad(led));  // smoke.sv(14)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    rst_syn_2 (
    .ipad(rst),
    .di(rst_dup_1));  // smoke.sv(14)
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_50  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [1],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [2],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [1],open_n232}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_44 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [2],open_n233}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_51  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [5],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [3]}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [6],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_44 ),
    .f({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [5],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [3]}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_48 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [6],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [4]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_52  (
    .a({open_n254,\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long [7]}),
    .c(2'b00),
    .d({open_n259,1'b0}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add0_syn_48 ),
    .f({open_n276,\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [7]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_50  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [1],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [2],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [1],open_n299}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_44 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [2],open_n300}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_51  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [5],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [3]}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [6],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_44 ),
    .f({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [5],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [3]}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_48 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [6],\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [4]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_52  (
    .a({open_n321,\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [7]}),
    .c(2'b00),
    .d({open_n326,1'b0}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/add1_syn_48 ),
    .f({open_n343,\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [7]}));
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E)"),
    .INIT(32'h7ffffffe))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [3]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [4]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [5]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [6]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq1_syn_47 ));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h7ffe))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_2  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [0]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [1]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [2]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq1_syn_44 ));
  AL_MAP_LUT3 #(
    .EQN("(~C*~B*~A)"),
    .INIT(8'h01))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq1_syn_47 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq1_syn_44 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_4 ));
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_5  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_4 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b [0]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[7]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_4 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [7]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_reg[0]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b [0]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_reg[1]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [1]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_reg[2]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [2]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_reg[3]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [3]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_reg[4]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [4]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_reg[5]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [5]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_reg[6]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b3 [6]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b1),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("SET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_reg[7]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b [7]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [0]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [0]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [1]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [1]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [2]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [2]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [3]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [3]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [4]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [4]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [5]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [5]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [6]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [6]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long [7]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [7]));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_32"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_32  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/stop_len [0],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [0],open_n357}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_5 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_32"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_35  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len [2:1]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [2:1]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_5 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_9 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_32"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_38  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len [4:3]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [4:3]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_9 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_13 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_32"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_41  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len [6:5]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [6:5]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_13 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_17 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_32"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_44  (
    .a(2'b00),
    .b({1'b1,\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [7]}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/lt0_syn_17 ),
    .f({\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_n1 ,open_n473}));
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_41  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/pause ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_ce_n2_syn_2 ));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_42  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_long_b[0]_syn_4 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_ce_n2_syn_2 ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux1_syn_2 [7]));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_71  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/emb_store_en ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_3 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_in [16]));
  AL_MAP_LUT5 #(
    .EQN("(A*~(B)*~(C)*~(D)*~(E)+~(A)*B*~(C)*~(D)*~(E)+A*B*~(C)*~(D)*~(E)+~(A)*~(B)*C*~(D)*~(E)+A*~(B)*C*~(D)*~(E)+~(A)*B*C*~(D)*~(E)+A*B*C*~(D)*~(E)+~(A)*~(B)*~(C)*D*~(E)+A*~(B)*~(C)*D*~(E)+~(A)*B*~(C)*D*~(E)+A*B*~(C)*D*~(E)+~(A)*~(B)*C*D*~(E)+A*~(B)*C*D*~(E)+~(A)*B*C*D*~(E)+A*B*C*D*~(E)+~(A)*~(B)*~(C)*~(D)*E+A*~(B)*~(C)*~(D)*E+~(A)*B*~(C)*~(D)*E+A*B*~(C)*~(D)*E+~(A)*~(B)*C*~(D)*E+A*~(B)*C*~(D)*E+~(A)*B*C*~(D)*E+A*B*C*~(D)*E+~(A)*~(B)*~(C)*D*E+A*~(B)*~(C)*D*E+~(A)*B*~(C)*D*E+A*B*~(C)*D*E+~(A)*~(B)*C*D*E+A*~(B)*C*D*E+~(A)*B*C*D*E)"),
    .INIT(32'h7ffffffe))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_4  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [0]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [1]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [2]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [3]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq0_syn_50 ));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D+~(A)*B*~(C)*D+A*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D)"),
    .INIT(16'h7ffe))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_5  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [4]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [5]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [6]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_6 ));
  AL_MAP_LUT5 #(
    .EQN("~(~C*~(~E*~D*~B*~A))"),
    .INIT(32'hf0f0f0f1))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_7  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/eq0_syn_50 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_6 ),
    .c(\u_watch/wrapper_cwc_top/status_pipe/data_in [16]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .e(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/addr_tmp [7]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/overflow_reg_syn_3 ));
  AL_MAP_LUT2 #(
    .EQN("(~B*~A)"),
    .INIT(4'h1))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b[0]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [0]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b[1]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [1]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [1]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b[2]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [2]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [2]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b[3]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [3]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [3]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b[4]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [4]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [4]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b[5]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [5]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [5]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b[6]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [6]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [6]));
  AL_MAP_LUT2 #(
    .EQN("(~B*A)"),
    .INIT(4'h2))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b[7]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b2 [7]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [7]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_reg[0]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [0]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [0]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_reg[1]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [1]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [1]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_reg[2]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [2]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [2]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_reg[3]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [3]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [3]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_reg[4]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [4]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [4]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_reg[5]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [5]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [5]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_reg[6]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [6]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [6]));
  AL_MAP_SEQ #(
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_reg[7]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/mux3_syn_2 [7]),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count_b [7]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_count [7]));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_reg_syn_3 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_reg_syn_4  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_n1 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop_reg_syn_3 ));
  AL_MAP_SEQ #(
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_ce_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_ce_n2_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/cwc_wt_ce ));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[0]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [32]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [0]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[10]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [42]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [10]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [10]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[11]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [43]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [11]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [11]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[12]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [44]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [12]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [12]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[13]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [45]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [13]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [13]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[14]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [46]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [14]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [14]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[15]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [47]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [15]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [15]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[1]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [33]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [1]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [1]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[2]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [34]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [2]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [2]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[3]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [35]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [3]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [3]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[4]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [36]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [4]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [4]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[5]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [37]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [5]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [5]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[6]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [38]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [6]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [6]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[7]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [39]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [7]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [7]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[8]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [40]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [8]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [8]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b[9]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [41]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [9]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [0]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [10]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [11]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [12]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [13]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [14]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [15]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [1]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [2]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [3]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [4]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [5]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [6]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [7]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [8]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask_b [9]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [9]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[0]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [0]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [16]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [32]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [0]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [0]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[10]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [10]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [26]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [42]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [10]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [10]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [10]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[11]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [11]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [27]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [43]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [11]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [11]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [11]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[12]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [12]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [28]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [44]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [12]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [12]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [12]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[13]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [13]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [29]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [45]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [13]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [13]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [13]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[14]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [14]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [30]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [46]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [14]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [14]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [14]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[15]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [15]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [31]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [47]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [15]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [15]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [15]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[1]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [1]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [17]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [33]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [1]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [1]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [1]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[2]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [2]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [18]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [34]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [2]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [2]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [2]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[3]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [3]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [19]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [35]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [3]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [3]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [3]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[4]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [4]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [20]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [36]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [4]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [4]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [4]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[5]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [5]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [21]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [37]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [5]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [5]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [5]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[6]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [6]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [22]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [38]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [6]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [6]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [6]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[7]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [7]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [23]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [39]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [7]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [7]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [7]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[8]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [8]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [24]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [40]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [8]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [8]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [8]));
  AL_MAP_LUT5 #(
    .EQN("~(C*(~(A)*~(B)*~(D)*~(E)+~(A)*B*~(D)*~(E)+A*B*~(D)*~(E)+~(A)*~(B)*D*~(E)+A*~(B)*D*~(E)+~(A)*B*~(D)*E+A*B*~(D)*E+~(A)*~(B)*D*E+A*~(B)*D*E+~(A)*B*D*E))"),
    .INIT(32'h8f3fcf2f))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b[9]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [9]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [25]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [41]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [9]),
    .e(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [9]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [0]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [10]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [11]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [12]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [13]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [14]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [15]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [1]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [2]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [3]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [4]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [5]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [6]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [7]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [8]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask_b [9]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[0]  (
    .clk(clk_dup_1),
    .d(count[0]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[10]  (
    .clk(clk_dup_1),
    .d(count[10]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[11]  (
    .clk(clk_dup_1),
    .d(count[11]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[12]  (
    .clk(clk_dup_1),
    .d(count[12]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[13]  (
    .clk(clk_dup_1),
    .d(count[13]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[14]  (
    .clk(clk_dup_1),
    .d(count[14]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[15]  (
    .clk(clk_dup_1),
    .d(led_dup_3),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[1]  (
    .clk(clk_dup_1),
    .d(count[1]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[2]  (
    .clk(clk_dup_1),
    .d(count[2]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[3]  (
    .clk(clk_dup_1),
    .d(count[3]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[4]  (
    .clk(clk_dup_1),
    .d(count[4]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[5]  (
    .clk(clk_dup_1),
    .d(count[5]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[6]  (
    .clk(clk_dup_1),
    .d(count[6]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[7]  (
    .clk(clk_dup_1),
    .d(count[7]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[8]  (
    .clk(clk_dup_1),
    .d(count[8]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_reg[9]  (
    .clk(clk_dup_1),
    .d(count[9]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [9]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[0]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [16]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [32]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [0]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[10]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [26]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [42]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [10]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[11]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [27]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [43]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [11]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[12]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [28]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [44]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [12]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[13]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [29]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [45]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [13]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[14]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [30]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [46]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [14]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[15]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [31]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [47]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [15]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[1]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [17]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [33]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [1]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[2]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [18]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [34]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [2]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[3]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [19]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [35]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [3]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[4]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [20]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [36]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [4]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[5]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [21]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [37]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [5]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[6]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [22]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [38]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [6]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[7]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [23]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [39]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [7]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[8]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [24]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [40]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [8]));
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b[9]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [25]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [41]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [0]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [10]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [11]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [12]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [13]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [14]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [15]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [1]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [2]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [3]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [4]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [5]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [6]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [7]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [8]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask_b [9]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_0_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_2 ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_0 ));
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_11  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_4 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_6 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_8 ),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_10 ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_12 ));
  AL_MAP_LUT4 #(
    .EQN("(~(D@B)*~(C@A))"),
    .INIT(16'h8421))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_13  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [7]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [12]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [7]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [12]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_14 ));
  AL_MAP_LUT4 #(
    .EQN("(~(D@B)*~(C@A))"),
    .INIT(16'h8421))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_15  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [1]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [9]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [1]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [9]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_16 ));
  AL_MAP_LUT4 #(
    .EQN("(~(D@B)*~(C@A))"),
    .INIT(16'h8421))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_17  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [5]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [14]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [5]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [14]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_18 ));
  AL_MAP_LUT4 #(
    .EQN("(~(D@B)*~(C@A))"),
    .INIT(16'h8421))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_19  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [2]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [11]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [2]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [11]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_20 ));
  AL_MAP_LUT5 #(
    .EQN("(E*D*C*B*A)"),
    .INIT(32'h80000000))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_21  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_12 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_14 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_16 ),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_18 ),
    .e(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_20 ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_2 ));
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_22  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_2 ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n ));
  AL_MAP_LUT4 #(
    .EQN("(~(D@B)*~(C@A))"),
    .INIT(16'h8421))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [0]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [6]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [0]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [6]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_4 ));
  AL_MAP_LUT4 #(
    .EQN("(~(D@B)*~(C@A))"),
    .INIT(16'h8421))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_5  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [8]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [13]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [8]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [13]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_6 ));
  AL_MAP_LUT4 #(
    .EQN("(~(D@B)*~(C@A))"),
    .INIT(16'h8421))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_7  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [10]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [15]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [10]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [15]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_8 ));
  AL_MAP_LUT4 #(
    .EQN("(~(D@B)*~(C@A))"),
    .INIT(16'h8421))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_9  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [3]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [4]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [3]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [4]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n_syn_10 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1_n ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("A_LE_B"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_2_reg_syn_5  (
    .a({open_n614,1'b0}),
    .b({open_n615,1'b1}),
    .clk(clk_dup_1),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_36 ),
    .q({open_n638,\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_2 }));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y4Z1"),
    .ALUTYPE("A_LE_B"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"),
    .REG0_REGSET("RESET"),
    .REG0_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_3_reg_syn_5  (
    .a({open_n639,1'b0}),
    .b({open_n640,1'b1}),
    .clk(clk_dup_1),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_36 ),
    .q({open_n663,\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_3 }));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("A_LE_B"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_4_reg_syn_5  (
    .a({1'b0,\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [15]}),
    .b({1'b0,\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [15]}),
    .clk(clk_dup_1),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_33 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_36 ),
    .q({\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_4 ,open_n685}));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y4Z0"),
    .ALUTYPE("A_LE_B"),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"),
    .REG1_REGSET("RESET"),
    .REG1_SD("F"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_5_reg_syn_5  (
    .a({1'b0,\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [15]}),
    .b({1'b0,\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [15]}),
    .clk(clk_dup_1),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_33 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_36 ),
    .q({\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_5 ,open_n707}));
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [4]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [5]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [6]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [7]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n5 ));
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n_syn_2  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [0]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [1]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [2]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [3]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n4 ));
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [12]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [13]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [14]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [15]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n7 ));
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n_syn_4  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [8]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [9]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [10]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_edge_hit_or_mask [11]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n6 ));
  AL_MAP_LUT4 #(
    .EQN("(D*C*B*A)"),
    .INIT(16'h8000))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n_syn_5  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n5 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n4 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n7 ),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n6 ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8_n ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [0],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [0],open_n710}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_5 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_60  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [2:1]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [2:1]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_5 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_9 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_63  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [4:3]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [4:3]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_9 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_13 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_66  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [6:5]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [6:5]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_13 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_17 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_69  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [8:7]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [8:7]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_17 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_21 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_72  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [10:9]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [10:9]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_21 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_25 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_75  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [12:11]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [12:11]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_25 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_29 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_57"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_78  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [14:13]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [14:13]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_29 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt0_syn_33 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [0],1'b1}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [0],open_n904}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_5 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_60  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [2:1]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [2:1]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_5 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_9 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_63  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [4:3]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [4:3]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_9 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_13 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_66  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [6:5]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [6:5]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_13 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_17 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_69  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [8:7]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [8:7]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_17 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_21 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y2Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_72  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [10:9]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [10:9]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_21 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_25 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y3Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_75  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [12:11]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [12:11]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_25 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_29 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_57"),
    //.R_POSITION("X0Y3Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_78  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg_and_mask [14:13]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_value_and_mask [14:13]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_29 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/lt1_syn_33 ));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/add0_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/add0_syn_50  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [1],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [2],\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [0]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b01),
    .f({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [1],open_n1115}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/add0_syn_44 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [2],open_n1116}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/add0_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/add0_syn_51  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [5],\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [3]}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [6],\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [4]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/add0_syn_44 ),
    .f({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [5],\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [3]}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/add0_syn_48 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [6],\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [4]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/add0_syn_50"),
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
    \u_watch/wrapper_cwc_top/U_cwc/add0_syn_52  (
    .a({open_n1137,\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [7]}),
    .c(2'b00),
    .d({open_n1142,1'b0}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/add0_syn_48 ),
    .f({open_n1159,\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [7]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/add1_syn_44"),
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
    \u_watch/wrapper_cwc_top/U_cwc/add1_syn_44  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [2],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [3],\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [1]}),
    .c(2'b00),
    .d(2'b01),
    .e(2'b11),
    .f({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [2],open_n1182}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/add1_syn_39 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [3],open_n1183}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/add1_syn_44"),
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
    \u_watch/wrapper_cwc_top/U_cwc/add1_syn_45  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [6],\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [4]}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [7],\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [5]}),
    .c(2'b00),
    .d(2'b00),
    .e(2'b00),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/add1_syn_39 ),
    .f({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [6],\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [4]}),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [7],\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [5]}));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [20]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [30]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [31]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [32]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [33]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [34]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [35]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[16]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [36]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [16]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[17]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [37]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [17]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[18]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [38]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [18]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[19]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [39]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [19]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [21]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[20]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [40]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [20]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[21]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [41]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [21]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[22]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [42]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [22]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[23]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [43]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [23]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[24]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [44]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [24]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[25]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [45]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [25]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[26]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [46]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [26]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[27]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [47]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [27]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[28]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [48]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [28]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[29]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [49]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [29]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [22]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[30]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [50]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [30]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[31]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [51]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [31]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[32]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [52]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [32]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[33]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [53]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [33]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[34]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [54]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [34]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[35]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [55]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [35]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[36]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [56]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [36]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[37]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [57]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [37]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[38]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [58]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [38]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[39]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [59]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [39]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [23]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[40]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [60]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [40]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[41]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [61]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [41]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[42]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [62]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [42]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[43]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [63]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [43]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[44]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [64]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [44]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[45]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [65]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [45]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[46]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [66]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [46]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[47]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [67]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [47]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[48]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [68]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [48]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[49]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [69]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [49]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [24]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[50]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [70]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [50]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[51]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [71]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [51]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [25]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [26]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [27]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [28]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/bus_control_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [29]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/mux1_syn_14 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/mux1_syn_22 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/emb_store_en_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/emb_store_en_reg_syn_3 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/emb_store_en ));
  AL_MAP_LUT2 #(
    .EQN("~(~B*~A)"),
    .INIT(4'he))
    \u_watch/wrapper_cwc_top/U_cwc/emb_store_en_reg_syn_4  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/emb_store_en ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/trigger_or_en ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/emb_store_en_reg_syn_3 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("INV"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_reg  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(1'b1),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin ));
  AL_MAP_LUT3 #(
    .EQN("~(~B*~(C)*~(A)+~B*C*~(A)+~(~B)*C*A+~B*C*A)"),
    .INIT(8'h4e))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[1]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [1]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [1]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [1]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[2]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [2]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [2]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [2]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[3]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [3]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [3]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [3]));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[4]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [1]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ));
  AL_MAP_LUT2 #(
    .EQN("~(~B*A)"),
    .INIT(4'hd))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[4]_syn_2  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[4]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [4]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [4]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [4]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[5]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [5]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [5]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [5]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[6]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [6]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [6]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [6]));
  AL_MAP_LUT3 #(
    .EQN("(C*~(B)*~(A)+C*B*~(A)+~(C)*B*A+C*B*A)"),
    .INIT(8'hd8))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b[7]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b3 [7]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [7]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[0]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [0]));
  AL_MAP_LUT3 #(
    .EQN("(B*~(C)*~(A)+B*C*~(A)+~(B)*C*A+B*C*A)"),
    .INIT(8'he4))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[0]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [0]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[0]_syn_2 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[1]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [1]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[2]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [2]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[3]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [3]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[4]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [4]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[5]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [5]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[6]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [6]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_len_reg[7]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b [7]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [7]));
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg[0]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg[0]_syn_2 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_reg[0]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg[0]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_reg[1]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [1]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_reg[2]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [2]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_reg[3]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [3]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_reg[4]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [4]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_reg[5]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [5]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_reg[6]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [6]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_reg[7]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg_b1 [7]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [7]));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt0_syn_32"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_32  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [0],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [0],open_n1313}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/lt0_syn_5 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt0_syn_32"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_35  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [2:1]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [2:1]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/lt0_syn_5 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/lt0_syn_9 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt0_syn_32"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_38  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [4:3]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [4:3]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/lt0_syn_9 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/lt0_syn_13 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt0_syn_32"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_41  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [6:5]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [6:5]),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/lt0_syn_13 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/lt0_syn_17 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt0_syn_32"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt0_syn_44  (
    .a({1'b0,\u_watch/wrapper_cwc_top/U_cwc/force_acq_reg [7]}),
    .b({1'b1,\u_watch/wrapper_cwc_top/U_cwc/force_acq_len [7]}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/lt0_syn_17 ),
    .f({\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin_n1 ,open_n1429}));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt1_syn_29"),
    //.R_POSITION("X0Y0Z0"),
    .ALUTYPE("A_LE_B_CARRY"),
    .INIT_LUT0(16'b0000000000001010),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_29  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/trig_position [0],1'b1}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],open_n1435}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/lt1_syn_5 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt1_syn_29"),
    //.R_POSITION("X0Y0Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_32  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_position [2:1]),
    .b({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/lt1_syn_5 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/lt1_syn_9 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt1_syn_29"),
    //.R_POSITION("X0Y1Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_35  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_position [4:3]),
    .b({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/lt1_syn_9 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/lt1_syn_13 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt1_syn_29"),
    //.R_POSITION("X0Y1Z1"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_38  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_position [6:5]),
    .b({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/lt1_syn_13 ),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/lt1_syn_17 ));
  EG_PHY_MSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/lt1_syn_29"),
    //.R_POSITION("X0Y2Z0"),
    .ALUTYPE("A_LE_B"),
    .INIT_LUT0(16'b1001100110011100),
    .INIT_LUT1(16'b1001100110011100),
    .MODE("RIPPLE"))
    \u_watch/wrapper_cwc_top/U_cwc/lt1_syn_40  (
    .a({open_n1533,1'b0}),
    .b({open_n1534,1'b1}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/lt1_syn_17 ),
    .f({open_n1553,\u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n }));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/main_control_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [10]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/main_control [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/main_control_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [4]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/main_control [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/main_control_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [5]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/main_control [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/main_control_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [6]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/main_control [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/main_control_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [7]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/main_control [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/main_control_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [8]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/main_control [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/main_control_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [9]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/main_control [9]));
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/state_rstn_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/control [0]),
    .q(\u_watch/wrapper_cwc_top/U_cwc/state_rstn )); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[0]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/stop_len [0]));
  AL_MAP_LUT5 #(
    .EQN("(D*~((E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B))*~(A)+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*~(A)+~(D)*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A)"),
    .INIT(32'hf7a2d580))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[0]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [0]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len [0]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[0]_syn_2 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[1]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/stop_len [1]));
  AL_MAP_LUT5 #(
    .EQN("(D*~((E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B))*~(A)+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*~(A)+~(D)*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A)"),
    .INIT(32'hf7a2d580))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[1]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [1]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len [1]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[1]_syn_2 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[2]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/stop_len [2]));
  AL_MAP_LUT5 #(
    .EQN("(D*~((E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B))*~(A)+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*~(A)+~(D)*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A)"),
    .INIT(32'hf7a2d580))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[2]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [2]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len [2]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[2]_syn_2 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[3]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/stop_len [3]));
  AL_MAP_LUT5 #(
    .EQN("(D*~((E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B))*~(A)+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*~(A)+~(D)*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A)"),
    .INIT(32'hf7a2d580))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[3]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [3]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len [3]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[3]_syn_2 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[4]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/stop_len [4]));
  AL_MAP_LUT3 #(
    .EQN("(~A*(C@B))"),
    .INIT(8'h14))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[4]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [0]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [1]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/mux1_syn_22 ));
  AL_MAP_LUT4 #(
    .EQN("(A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*B*C*~(D)+A*B*C*~(D)+~(A)*~(B)*~(C)*D+A*~(B)*~(C)*D)"),
    .INIT(16'h03ce))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[4]_syn_4  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [0]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [1]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/mux1_syn_14 ));
  AL_MAP_LUT2 #(
    .EQN("(B*~A)"),
    .INIT(4'h4))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[4]_syn_5  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/mux1_syn_14 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/mux1_syn_22 ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ));
  AL_MAP_LUT5 #(
    .EQN("(D*~((E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B))*~(A)+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*~(A)+~(D)*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A)"),
    .INIT(32'hf7a2d580))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[4]_syn_6  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [4]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len [4]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[4]_syn_2 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[5]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/stop_len [5]));
  AL_MAP_LUT5 #(
    .EQN("(D*~((E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B))*~(A)+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*~(A)+~(D)*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A+D*(E*~(C)*~(B)+E*C*~(B)+~(E)*C*B+E*C*B)*A)"),
    .INIT(32'hf7a2d580))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[5]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [5]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len [5]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[5]_syn_2 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[6]_syn_2 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/stop_len [6]));
  AL_MAP_LUT4 #(
    .EQN("(D*~((C*B))*~(A)+D*(C*B)*~(A)+~(D)*(C*B)*A+D*(C*B)*A)"),
    .INIT(16'hd580))
    \u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[6]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b_n ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b1_n ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [6]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/stop_len [6]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/stop_len_reg[6]_syn_2 ));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/sub0_syn_45"),
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
    \u_watch/wrapper_cwc_top/U_cwc/sub0_syn_45  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .c(2'b11),
    .d({\u_watch/wrapper_cwc_top/U_cwc/trig_position [1],1'b1}),
    .e({\u_watch/wrapper_cwc_top/U_cwc/trig_position [2],\u_watch/wrapper_cwc_top/U_cwc/trig_position [0]}),
    .f({\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [1],open_n1599}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/sub0_syn_40 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [2],\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [0]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/sub0_syn_45"),
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
    \u_watch/wrapper_cwc_top/U_cwc/sub0_syn_46  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .c(2'b11),
    .d({\u_watch/wrapper_cwc_top/U_cwc/trig_position [5],\u_watch/wrapper_cwc_top/U_cwc/trig_position [3]}),
    .e({\u_watch/wrapper_cwc_top/U_cwc/trig_position [6],\u_watch/wrapper_cwc_top/U_cwc/trig_position [4]}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/sub0_syn_40 ),
    .f({\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [5],\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [3]}),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [6],\u_watch/wrapper_cwc_top/U_cwc/stop_len_b3 [4]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/sub1_syn_49"),
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
    \u_watch/wrapper_cwc_top/U_cwc/sub1_syn_49  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],1'b0}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .c(2'b11),
    .d({\u_watch/wrapper_cwc_top/U_cwc/stop_len [1],1'b1}),
    .e({\u_watch/wrapper_cwc_top/U_cwc/stop_len [2],\u_watch/wrapper_cwc_top/U_cwc/stop_len [0]}),
    .f({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [1],open_n1638}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/sub1_syn_43 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [2],\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [0]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/sub1_syn_49"),
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
    \u_watch/wrapper_cwc_top/U_cwc/sub1_syn_50  (
    .a({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .b({\u_watch/wrapper_cwc_top/U_cwc/trig_length [0],\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]}),
    .c(2'b11),
    .d({\u_watch/wrapper_cwc_top/U_cwc/stop_len [5],\u_watch/wrapper_cwc_top/U_cwc/stop_len [3]}),
    .e({\u_watch/wrapper_cwc_top/U_cwc/stop_len [6],\u_watch/wrapper_cwc_top/U_cwc/stop_len [4]}),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/sub1_syn_43 ),
    .f({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [5],\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [3]}),
    .fco(\u_watch/wrapper_cwc_top/U_cwc/sub1_syn_47 ),
    .fx({\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [6],\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [4]}));
  EG_PHY_LSLICE #(
    //.MACRO("u_watch/wrapper_cwc_top/U_cwc/sub1_syn_49"),
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
    \u_watch/wrapper_cwc_top/U_cwc/sub1_syn_51  (
    .c(2'b11),
    .fci(\u_watch/wrapper_cwc_top/U_cwc/sub1_syn_47 ),
    .f({open_n1683,\u_watch/wrapper_cwc_top/U_cwc/force_acq_len_b2 [7]}));
  AL_MAP_LUT4 #(
    .EQN("(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*B*~(C)*~(D)+~(A)*~(B)*~(C)*D+~(A)*B*~(C)*D+~(A)*~(B)*C*D+A*~(B)*C*D)"),
    .INIT(16'h350f))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_2 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_3 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [48]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [49]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_2 ));
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_11  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [32]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [33]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [34]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [35]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_12 ));
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_13  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [44]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [45]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [46]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [47]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_14 ));
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_15  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [40]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [41]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [42]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [43]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_16 ));
  AL_MAP_LUT5 #(
    .EQN("(~A*~(E*D*C*B))"),
    .INIT(32'h15555555))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_17  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_8 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_10 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_12 ),
    .d(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_14 ),
    .e(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_16 ),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_18 ));
  AL_MAP_LUT5 #(
    .EQN("(D*~(A*~(~E*~C*~B)))"),
    .INIT(32'h55005700))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_19  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_18 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_4 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_6 ),
    .d(\u_watch/wrapper_cwc_top/U_cwc/force_acq_fin ),
    .e(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [51]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en ));
  AL_MAP_LUT5 #(
    .EQN("(~E*(~(A)*~(B)*~(C)*~(D)+A*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+A*~(B)*C*~(D)+A*~(B)*~(C)*D+A*B*~(C)*D+A*~(B)*C*D+A*B*C*D))"),
    .INIT(32'h0000aa27))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_3  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_2 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_0 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_1 ),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [49]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [50]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_4 ));
  AL_MAP_LUT5 #(
    .EQN("(E*(~(A)*~(B)*~(C)*~(D)+~(A)*B*~(C)*~(D)+~(A)*~(B)*C*~(D)+A*~(B)*C*~(D)+~(A)*~(B)*C*D+A*~(B)*C*D+~(A)*B*C*D+A*B*C*D))"),
    .INIT(32'hf0350000))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_5  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_4 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_5 ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [48]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [49]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [50]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_6 ));
  AL_MAP_LUT5 #(
    .EQN("(E*~D*~C*~B*A)"),
    .INIT(32'h00020000))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_7  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/compare_result_8 ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [48]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [49]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [50]),
    .e(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [51]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_8 ));
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*~A)"),
    .INIT(16'h0001))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_9  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [36]),
    .b(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [37]),
    .c(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [38]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_ctrl [39]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en[0]_syn_10 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_bus_en_ff_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/trig_bus_en ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trigger_or_en ));
  AL_MAP_LUT4 #(
    .EQN("(~D*~C*~B*A)"),
    .INIT(16'h0002))
    \u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .b(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ),
    .c(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [0]),
    .d(\u_watch/wrapper_cwc_top/U_cwc/ctrl_state_c [1]),
    .o(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_length_reg[0]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(1'b1),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_length [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_pause_reg  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_out [23]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_pause ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_pause_sync0_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/trig_pause ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_pause_sync0 ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_pause_sync1_reg  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/trig_pause_sync0 ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/pause ));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_position_reg[0]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/main_control [4]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_position [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_position_reg[1]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/main_control [5]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_position [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_position_reg[2]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/main_control [6]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_position [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_position_reg[3]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/main_control [7]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_position [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_position_reg[4]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/main_control [8]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_position [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_position_reg[5]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/main_control [9]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_position [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_position_reg[6]  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_length_b_n ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/main_control [10]),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_position [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("CE"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("INV"))
    \u_watch/wrapper_cwc_top/U_cwc/trig_rstn_reg  (
    .ce(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn_i_syn_2 ),
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/eq3_syn_19 ),
    .sr(\u_watch/wrapper_cwc_top/U_cwc/state_rstn ),
    .q(\u_watch/wrapper_cwc_top/U_cwc/trig_rstn ));
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[0]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [0], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[0]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[0]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[0]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [0]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[10]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [10], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[10]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[10]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[10]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [10]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[11]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [11], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[11]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[11]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[11]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [11]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[12]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [12], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[12]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[12]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[12]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [12]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[13]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [13], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[13]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[13]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[13]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [13]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[14]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [14], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[14]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[14]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[14]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [14]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[15]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [15], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[15]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[15]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[15]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [15]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[1]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [1], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[1]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[1]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[1]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [1]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[2]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [2], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[2]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[2]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[2]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [2]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[3]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [3], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[3]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[3]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[3]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [3]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[4]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [4], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[4]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[4]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[4]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [4]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[5]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [5], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[5]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[5]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[5]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [5]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[6]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [6], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[6]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[6]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[6]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [6]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[7]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [7], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[7]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[7]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[7]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [7]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[8]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [8], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[8]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[8]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[8]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [8]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[9]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia [9], \u_watch/wrapper_cwc_top/U_cwc_ram/dia[9]_syn_3 );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/dia[9]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[9]_syn_4 , \u_watch/wrapper_cwc_top/U_cwc_ram/dia [9]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[0]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [0], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [0]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[0]_syn_2  (open_n1694, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [0]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[10]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [10], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [10]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[10]_syn_2  (open_n1695, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [10]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[11]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [11], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [11]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[11]_syn_2  (open_n1696, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [11]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[12]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [12], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [12]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[12]_syn_2  (open_n1697, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [12]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[13]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [13], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [13]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[13]_syn_2  (open_n1698, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [13]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[14]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [14], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [14]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[14]_syn_2  (open_n1699, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [14]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[15]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [15], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [15]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[15]_syn_2  (open_n1700, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [15]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[1]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [1], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [1]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[1]_syn_2  (open_n1701, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [1]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[2]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [2], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [2]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[2]_syn_2  (open_n1702, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [2]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[3]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [3], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [3]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[3]_syn_2  (open_n1703, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [3]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[4]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [4], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [4]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[4]_syn_2  (open_n1704, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [4]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[5]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [5], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [5]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[5]_syn_2  (open_n1705, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [5]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[6]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [6], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [6]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[6]_syn_2  (open_n1706, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [6]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[7]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [7], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [7]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[7]_syn_2  (open_n1707, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [7]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[8]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [8], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [8]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[8]_syn_2  (open_n1708, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [8]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[9]_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [9], \u_watch/wrapper_cwc_top/U_cwc_ram/doa [9]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep[9]_syn_2  (open_n1709, \u_watch/wrapper_cwc_top/U_cwc_ram/doa_keep [9]);
  AL_MAP_LUT2 #(
    .EQN("(B*A)"),
    .INIT(4'h8))
    \u_watch/wrapper_cwc_top/U_cwc_ram/mem_n_syn_1  (
    .a(\u_watch/wrapper_cwc_top/U_cwc_ram/cea ),
    .b(\u_watch/wrapper_cwc_top/U_cwc_ram/wea ),
    .o(\u_watch/wrapper_cwc_top/U_cwc_ram/mem_n ));
  // address_offset=0;data_offset=9;depth=128;width=7;num_section=1;width_per_section=7;section_size=16;working_depth=1024;working_width=9;working_numbyte=1;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // u_watch/wrapper_cwc_top/U_cwc_ram/ramread0_syn_4_128x16
  EG_PHY_BRAM #(
    //.FORCE_KEEP("ON"),
    .CEAMUX("1"),
    .CEBMUX("0"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .MODE("SP8K"),
    .OCEAMUX("1"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("READBEFOREWRITE"),
    .WRITEMODE_B("NORMAL"))
    \u_watch/wrapper_cwc_top/U_cwc_ram/ramread0_syn_15  (
    .addra({3'b000,\u_watch/wrapper_cwc_top/U_cwc_ram/addra ,3'b111}),
    .clka(\u_watch/wrapper_cwc_top/U_cwc_ram/clka ),
    .dia({open_n1732,open_n1733,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[15]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[14]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[13]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[12]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[11]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[10]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[9]_syn_4 }),
    .wea(\u_watch/wrapper_cwc_top/U_cwc_ram/mem_n ),
    .doa({open_n1748,open_n1749,\u_watch/wrapper_cwc_top/U_cwc_ram/doa [15:9]}));
  // address_offset=0;data_offset=0;depth=128;width=9;num_section=1;width_per_section=9;section_size=16;working_depth=1024;working_width=9;working_numbyte=1;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // u_watch/wrapper_cwc_top/U_cwc_ram/ramread0_syn_4_128x16
  EG_PHY_BRAM #(
    //.FORCE_KEEP("ON"),
    .CEAMUX("1"),
    .CEBMUX("0"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .MODE("SP8K"),
    .OCEAMUX("1"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("READBEFOREWRITE"),
    .WRITEMODE_B("NORMAL"))
    \u_watch/wrapper_cwc_top/U_cwc_ram/ramread0_syn_5  (
    .addra({3'b000,\u_watch/wrapper_cwc_top/U_cwc_ram/addra ,3'b111}),
    .clka(\u_watch/wrapper_cwc_top/U_cwc_ram/clka ),
    .dia({\u_watch/wrapper_cwc_top/U_cwc_ram/dia[8]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[7]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[6]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[5]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[4]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[3]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[2]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[1]_syn_4 ,\u_watch/wrapper_cwc_top/U_cwc_ram/dia[0]_syn_4 }),
    .wea(\u_watch/wrapper_cwc_top/U_cwc_ram/mem_n ),
    .doa(\u_watch/wrapper_cwc_top/U_cwc_ram/doa [8:0]));
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_1  (\u_watch/wrapper_cwc_top/U_cwc_ram/addra [6], \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [6]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_10  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[15]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [15]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_11  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[14]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [14]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_12  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[13]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [13]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_13  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[12]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [12]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_14  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[11]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [11]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_15  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[10]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [10]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_16  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[9]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [9]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_17  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[8]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [8]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_18  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[7]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [7]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_19  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[6]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [6]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_2  (\u_watch/wrapper_cwc_top/U_cwc_ram/addra [5], \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [5]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_20  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[5]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [5]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_21  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[4]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [4]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_22  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[3]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [3]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_23  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[2]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [2]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_24  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[1]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [1]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_25  (\u_watch/wrapper_cwc_top/U_cwc_ram/dia[0]_syn_3 , \u_watch/wrapper_cwc_top/ram_data [0]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_26  (\u_watch/wrapper_cwc_top/U_cwc_ram/wea , \u_watch/wrapper_cwc_top/cwc_wt_ce );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_3  (\u_watch/wrapper_cwc_top/U_cwc_ram/addra [4], \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [4]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_4  (\u_watch/wrapper_cwc_top/U_cwc_ram/addra [3], \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [3]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_5  (\u_watch/wrapper_cwc_top/U_cwc_ram/addra [2], \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [2]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_6  (\u_watch/wrapper_cwc_top/U_cwc_ram/addra [1], \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [1]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_7  (\u_watch/wrapper_cwc_top/U_cwc_ram/addra [0], \u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [0]);
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_8  (\u_watch/wrapper_cwc_top/U_cwc_ram/cea , \u_watch/wrapper_cwc_top/cwc_wt_ce );
  buf \u_watch/wrapper_cwc_top/U_cwc_ram_syn_9  (\u_watch/wrapper_cwc_top/U_cwc_ram/clka , clk_dup_1);
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \u_watch/wrapper_cwc_top/cnt_b[1]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/status_pipe/data_in [18]),
    .b(\u_watch/wrapper_cwc_top/status_pipe/data_in [19]),
    .o(\u_watch/wrapper_cwc_top/cnt_b [1]));
  AL_MAP_LUT3 #(
    .EQN("(C@(B*A))"),
    .INIT(8'h78))
    \u_watch/wrapper_cwc_top/cnt_b[2]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/status_pipe/data_in [18]),
    .b(\u_watch/wrapper_cwc_top/status_pipe/data_in [19]),
    .c(\u_watch/wrapper_cwc_top/status_pipe/data_in [20]),
    .o(\u_watch/wrapper_cwc_top/cnt_b [2]));
  AL_MAP_LUT4 #(
    .EQN("(D@(C*B*A))"),
    .INIT(16'h7f80))
    \u_watch/wrapper_cwc_top/cnt_b[3]_syn_1  (
    .a(\u_watch/wrapper_cwc_top/status_pipe/data_in [18]),
    .b(\u_watch/wrapper_cwc_top/status_pipe/data_in [19]),
    .c(\u_watch/wrapper_cwc_top/status_pipe/data_in [20]),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_in [21]),
    .o(\u_watch/wrapper_cwc_top/cnt_b [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/cnt_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_in[18]_syn_2 ),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_in [18]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/cnt_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/cnt_b [1]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_in [19]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/cnt_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/cnt_b [2]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_in [20]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/cnt_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/cnt_b [3]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_in [21]));
  buf \u_watch/wrapper_cwc_top/cwc_control[0]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [0], \u_watch/cwc_control [0]);
  buf \u_watch/wrapper_cwc_top/cwc_control[0]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [0], \u_watch/wrapper_cwc_top/cwc_control [0]);
  buf \u_watch/wrapper_cwc_top/cwc_control[10]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [10], \u_watch/cwc_control [10]);
  buf \u_watch/wrapper_cwc_top/cwc_control[10]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [10], \u_watch/wrapper_cwc_top/cwc_control [10]);
  buf \u_watch/wrapper_cwc_top/cwc_control[11]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [11], \u_watch/cwc_control [11]);
  buf \u_watch/wrapper_cwc_top/cwc_control[11]_syn_2  (open_n1812, \u_watch/wrapper_cwc_top/cwc_control [11]);
  buf \u_watch/wrapper_cwc_top/cwc_control[12]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [12], \u_watch/cwc_control [12]);
  buf \u_watch/wrapper_cwc_top/cwc_control[12]_syn_2  (open_n1813, \u_watch/wrapper_cwc_top/cwc_control [12]);
  buf \u_watch/wrapper_cwc_top/cwc_control[13]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [13], \u_watch/cwc_control [13]);
  buf \u_watch/wrapper_cwc_top/cwc_control[13]_syn_2  (open_n1814, \u_watch/wrapper_cwc_top/cwc_control [13]);
  buf \u_watch/wrapper_cwc_top/cwc_control[14]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [14], \u_watch/cwc_control [14]);
  buf \u_watch/wrapper_cwc_top/cwc_control[14]_syn_2  (open_n1815, \u_watch/wrapper_cwc_top/cwc_control [14]);
  buf \u_watch/wrapper_cwc_top/cwc_control[15]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [15], \u_watch/cwc_control [15]);
  buf \u_watch/wrapper_cwc_top/cwc_control[15]_syn_2  (open_n1816, \u_watch/wrapper_cwc_top/cwc_control [15]);
  buf \u_watch/wrapper_cwc_top/cwc_control[16]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [16], \u_watch/cwc_control [16]);
  buf \u_watch/wrapper_cwc_top/cwc_control[16]_syn_2  (open_n1817, \u_watch/wrapper_cwc_top/cwc_control [16]);
  buf \u_watch/wrapper_cwc_top/cwc_control[17]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [17], \u_watch/cwc_control [17]);
  buf \u_watch/wrapper_cwc_top/cwc_control[17]_syn_2  (open_n1818, \u_watch/wrapper_cwc_top/cwc_control [17]);
  buf \u_watch/wrapper_cwc_top/cwc_control[18]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [18], \u_watch/cwc_control [18]);
  buf \u_watch/wrapper_cwc_top/cwc_control[18]_syn_2  (open_n1819, \u_watch/wrapper_cwc_top/cwc_control [18]);
  buf \u_watch/wrapper_cwc_top/cwc_control[19]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [19], \u_watch/cwc_control [19]);
  buf \u_watch/wrapper_cwc_top/cwc_control[19]_syn_2  (open_n1820, \u_watch/wrapper_cwc_top/cwc_control [19]);
  buf \u_watch/wrapper_cwc_top/cwc_control[1]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [1], \u_watch/cwc_control [1]);
  buf \u_watch/wrapper_cwc_top/cwc_control[1]_syn_2  (\u_watch/wrapper_cwc_top/status_pipe/data_in [23], \u_watch/wrapper_cwc_top/cwc_control [1]);
  buf \u_watch/wrapper_cwc_top/cwc_control[20]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [20], \u_watch/cwc_control [20]);
  buf \u_watch/wrapper_cwc_top/cwc_control[20]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [20], \u_watch/wrapper_cwc_top/cwc_control [20]);
  buf \u_watch/wrapper_cwc_top/cwc_control[21]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [21], \u_watch/cwc_control [21]);
  buf \u_watch/wrapper_cwc_top/cwc_control[21]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [21], \u_watch/wrapper_cwc_top/cwc_control [21]);
  buf \u_watch/wrapper_cwc_top/cwc_control[22]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [22], \u_watch/cwc_control [22]);
  buf \u_watch/wrapper_cwc_top/cwc_control[22]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [22], \u_watch/wrapper_cwc_top/cwc_control [22]);
  buf \u_watch/wrapper_cwc_top/cwc_control[23]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [23], \u_watch/cwc_control [23]);
  buf \u_watch/wrapper_cwc_top/cwc_control[23]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [23], \u_watch/wrapper_cwc_top/cwc_control [23]);
  buf \u_watch/wrapper_cwc_top/cwc_control[24]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [24], \u_watch/cwc_control [24]);
  buf \u_watch/wrapper_cwc_top/cwc_control[24]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [24], \u_watch/wrapper_cwc_top/cwc_control [24]);
  buf \u_watch/wrapper_cwc_top/cwc_control[25]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [25], \u_watch/cwc_control [25]);
  buf \u_watch/wrapper_cwc_top/cwc_control[25]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [25], \u_watch/wrapper_cwc_top/cwc_control [25]);
  buf \u_watch/wrapper_cwc_top/cwc_control[26]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [26], \u_watch/cwc_control [26]);
  buf \u_watch/wrapper_cwc_top/cwc_control[26]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [26], \u_watch/wrapper_cwc_top/cwc_control [26]);
  buf \u_watch/wrapper_cwc_top/cwc_control[27]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [27], \u_watch/cwc_control [27]);
  buf \u_watch/wrapper_cwc_top/cwc_control[27]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [27], \u_watch/wrapper_cwc_top/cwc_control [27]);
  buf \u_watch/wrapper_cwc_top/cwc_control[28]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [28], \u_watch/cwc_control [28]);
  buf \u_watch/wrapper_cwc_top/cwc_control[28]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [28], \u_watch/wrapper_cwc_top/cwc_control [28]);
  buf \u_watch/wrapper_cwc_top/cwc_control[29]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [29], \u_watch/cwc_control [29]);
  buf \u_watch/wrapper_cwc_top/cwc_control[29]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [29], \u_watch/wrapper_cwc_top/cwc_control [29]);
  buf \u_watch/wrapper_cwc_top/cwc_control[2]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [2], \u_watch/cwc_control [2]);
  buf \u_watch/wrapper_cwc_top/cwc_control[2]_syn_2  (open_n1821, \u_watch/wrapper_cwc_top/cwc_control [2]);
  buf \u_watch/wrapper_cwc_top/cwc_control[30]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [30], \u_watch/cwc_control [30]);
  buf \u_watch/wrapper_cwc_top/cwc_control[30]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [30], \u_watch/wrapper_cwc_top/cwc_control [30]);
  buf \u_watch/wrapper_cwc_top/cwc_control[31]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [31], \u_watch/cwc_control [31]);
  buf \u_watch/wrapper_cwc_top/cwc_control[31]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [31], \u_watch/wrapper_cwc_top/cwc_control [31]);
  buf \u_watch/wrapper_cwc_top/cwc_control[32]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [32], \u_watch/cwc_control [32]);
  buf \u_watch/wrapper_cwc_top/cwc_control[32]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [32], \u_watch/wrapper_cwc_top/cwc_control [32]);
  buf \u_watch/wrapper_cwc_top/cwc_control[33]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [33], \u_watch/cwc_control [33]);
  buf \u_watch/wrapper_cwc_top/cwc_control[33]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [33], \u_watch/wrapper_cwc_top/cwc_control [33]);
  buf \u_watch/wrapper_cwc_top/cwc_control[34]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [34], \u_watch/cwc_control [34]);
  buf \u_watch/wrapper_cwc_top/cwc_control[34]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [34], \u_watch/wrapper_cwc_top/cwc_control [34]);
  buf \u_watch/wrapper_cwc_top/cwc_control[35]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [35], \u_watch/cwc_control [35]);
  buf \u_watch/wrapper_cwc_top/cwc_control[35]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [35], \u_watch/wrapper_cwc_top/cwc_control [35]);
  buf \u_watch/wrapper_cwc_top/cwc_control[36]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [36], \u_watch/cwc_control [36]);
  buf \u_watch/wrapper_cwc_top/cwc_control[36]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [36], \u_watch/wrapper_cwc_top/cwc_control [36]);
  buf \u_watch/wrapper_cwc_top/cwc_control[37]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [37], \u_watch/cwc_control [37]);
  buf \u_watch/wrapper_cwc_top/cwc_control[37]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [37], \u_watch/wrapper_cwc_top/cwc_control [37]);
  buf \u_watch/wrapper_cwc_top/cwc_control[38]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [38], \u_watch/cwc_control [38]);
  buf \u_watch/wrapper_cwc_top/cwc_control[38]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [38], \u_watch/wrapper_cwc_top/cwc_control [38]);
  buf \u_watch/wrapper_cwc_top/cwc_control[39]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [39], \u_watch/cwc_control [39]);
  buf \u_watch/wrapper_cwc_top/cwc_control[39]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [39], \u_watch/wrapper_cwc_top/cwc_control [39]);
  buf \u_watch/wrapper_cwc_top/cwc_control[3]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [3], \u_watch/cwc_control [3]);
  buf \u_watch/wrapper_cwc_top/cwc_control[3]_syn_2  (open_n1822, \u_watch/wrapper_cwc_top/cwc_control [3]);
  buf \u_watch/wrapper_cwc_top/cwc_control[40]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [40], \u_watch/cwc_control [40]);
  buf \u_watch/wrapper_cwc_top/cwc_control[40]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [40], \u_watch/wrapper_cwc_top/cwc_control [40]);
  buf \u_watch/wrapper_cwc_top/cwc_control[41]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [41], \u_watch/cwc_control [41]);
  buf \u_watch/wrapper_cwc_top/cwc_control[41]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [41], \u_watch/wrapper_cwc_top/cwc_control [41]);
  buf \u_watch/wrapper_cwc_top/cwc_control[42]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [42], \u_watch/cwc_control [42]);
  buf \u_watch/wrapper_cwc_top/cwc_control[42]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [42], \u_watch/wrapper_cwc_top/cwc_control [42]);
  buf \u_watch/wrapper_cwc_top/cwc_control[43]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [43], \u_watch/cwc_control [43]);
  buf \u_watch/wrapper_cwc_top/cwc_control[43]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [43], \u_watch/wrapper_cwc_top/cwc_control [43]);
  buf \u_watch/wrapper_cwc_top/cwc_control[44]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [44], \u_watch/cwc_control [44]);
  buf \u_watch/wrapper_cwc_top/cwc_control[44]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [44], \u_watch/wrapper_cwc_top/cwc_control [44]);
  buf \u_watch/wrapper_cwc_top/cwc_control[45]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [45], \u_watch/cwc_control [45]);
  buf \u_watch/wrapper_cwc_top/cwc_control[45]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [45], \u_watch/wrapper_cwc_top/cwc_control [45]);
  buf \u_watch/wrapper_cwc_top/cwc_control[46]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [46], \u_watch/cwc_control [46]);
  buf \u_watch/wrapper_cwc_top/cwc_control[46]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [46], \u_watch/wrapper_cwc_top/cwc_control [46]);
  buf \u_watch/wrapper_cwc_top/cwc_control[47]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [47], \u_watch/cwc_control [47]);
  buf \u_watch/wrapper_cwc_top/cwc_control[47]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [47], \u_watch/wrapper_cwc_top/cwc_control [47]);
  buf \u_watch/wrapper_cwc_top/cwc_control[48]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [48], \u_watch/cwc_control [48]);
  buf \u_watch/wrapper_cwc_top/cwc_control[48]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [48], \u_watch/wrapper_cwc_top/cwc_control [48]);
  buf \u_watch/wrapper_cwc_top/cwc_control[49]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [49], \u_watch/cwc_control [49]);
  buf \u_watch/wrapper_cwc_top/cwc_control[49]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [49], \u_watch/wrapper_cwc_top/cwc_control [49]);
  buf \u_watch/wrapper_cwc_top/cwc_control[4]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [4], \u_watch/cwc_control [4]);
  buf \u_watch/wrapper_cwc_top/cwc_control[4]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [4], \u_watch/wrapper_cwc_top/cwc_control [4]);
  buf \u_watch/wrapper_cwc_top/cwc_control[50]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [50], \u_watch/cwc_control [50]);
  buf \u_watch/wrapper_cwc_top/cwc_control[50]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [50], \u_watch/wrapper_cwc_top/cwc_control [50]);
  buf \u_watch/wrapper_cwc_top/cwc_control[51]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [51], \u_watch/cwc_control [51]);
  buf \u_watch/wrapper_cwc_top/cwc_control[51]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [51], \u_watch/wrapper_cwc_top/cwc_control [51]);
  buf \u_watch/wrapper_cwc_top/cwc_control[52]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [52], \u_watch/cwc_control [52]);
  buf \u_watch/wrapper_cwc_top/cwc_control[52]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [52], \u_watch/wrapper_cwc_top/cwc_control [52]);
  buf \u_watch/wrapper_cwc_top/cwc_control[53]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [53], \u_watch/cwc_control [53]);
  buf \u_watch/wrapper_cwc_top/cwc_control[53]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [53], \u_watch/wrapper_cwc_top/cwc_control [53]);
  buf \u_watch/wrapper_cwc_top/cwc_control[54]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [54], \u_watch/cwc_control [54]);
  buf \u_watch/wrapper_cwc_top/cwc_control[54]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [54], \u_watch/wrapper_cwc_top/cwc_control [54]);
  buf \u_watch/wrapper_cwc_top/cwc_control[55]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [55], \u_watch/cwc_control [55]);
  buf \u_watch/wrapper_cwc_top/cwc_control[55]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [55], \u_watch/wrapper_cwc_top/cwc_control [55]);
  buf \u_watch/wrapper_cwc_top/cwc_control[56]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [56], \u_watch/cwc_control [56]);
  buf \u_watch/wrapper_cwc_top/cwc_control[56]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [56], \u_watch/wrapper_cwc_top/cwc_control [56]);
  buf \u_watch/wrapper_cwc_top/cwc_control[57]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [57], \u_watch/cwc_control [57]);
  buf \u_watch/wrapper_cwc_top/cwc_control[57]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [57], \u_watch/wrapper_cwc_top/cwc_control [57]);
  buf \u_watch/wrapper_cwc_top/cwc_control[58]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [58], \u_watch/cwc_control [58]);
  buf \u_watch/wrapper_cwc_top/cwc_control[58]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [58], \u_watch/wrapper_cwc_top/cwc_control [58]);
  buf \u_watch/wrapper_cwc_top/cwc_control[59]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [59], \u_watch/cwc_control [59]);
  buf \u_watch/wrapper_cwc_top/cwc_control[59]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [59], \u_watch/wrapper_cwc_top/cwc_control [59]);
  buf \u_watch/wrapper_cwc_top/cwc_control[5]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [5], \u_watch/cwc_control [5]);
  buf \u_watch/wrapper_cwc_top/cwc_control[5]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [5], \u_watch/wrapper_cwc_top/cwc_control [5]);
  buf \u_watch/wrapper_cwc_top/cwc_control[60]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [60], \u_watch/cwc_control [60]);
  buf \u_watch/wrapper_cwc_top/cwc_control[60]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [60], \u_watch/wrapper_cwc_top/cwc_control [60]);
  buf \u_watch/wrapper_cwc_top/cwc_control[61]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [61], \u_watch/cwc_control [61]);
  buf \u_watch/wrapper_cwc_top/cwc_control[61]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [61], \u_watch/wrapper_cwc_top/cwc_control [61]);
  buf \u_watch/wrapper_cwc_top/cwc_control[62]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [62], \u_watch/cwc_control [62]);
  buf \u_watch/wrapper_cwc_top/cwc_control[62]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [62], \u_watch/wrapper_cwc_top/cwc_control [62]);
  buf \u_watch/wrapper_cwc_top/cwc_control[63]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [63], \u_watch/cwc_control [63]);
  buf \u_watch/wrapper_cwc_top/cwc_control[63]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [63], \u_watch/wrapper_cwc_top/cwc_control [63]);
  buf \u_watch/wrapper_cwc_top/cwc_control[64]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [64], \u_watch/cwc_control [64]);
  buf \u_watch/wrapper_cwc_top/cwc_control[64]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [64], \u_watch/wrapper_cwc_top/cwc_control [64]);
  buf \u_watch/wrapper_cwc_top/cwc_control[65]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [65], \u_watch/cwc_control [65]);
  buf \u_watch/wrapper_cwc_top/cwc_control[65]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [65], \u_watch/wrapper_cwc_top/cwc_control [65]);
  buf \u_watch/wrapper_cwc_top/cwc_control[66]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [66], \u_watch/cwc_control [66]);
  buf \u_watch/wrapper_cwc_top/cwc_control[66]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [66], \u_watch/wrapper_cwc_top/cwc_control [66]);
  buf \u_watch/wrapper_cwc_top/cwc_control[67]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [67], \u_watch/cwc_control [67]);
  buf \u_watch/wrapper_cwc_top/cwc_control[67]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [67], \u_watch/wrapper_cwc_top/cwc_control [67]);
  buf \u_watch/wrapper_cwc_top/cwc_control[68]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [68], \u_watch/cwc_control [68]);
  buf \u_watch/wrapper_cwc_top/cwc_control[68]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [68], \u_watch/wrapper_cwc_top/cwc_control [68]);
  buf \u_watch/wrapper_cwc_top/cwc_control[69]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [69], \u_watch/cwc_control [69]);
  buf \u_watch/wrapper_cwc_top/cwc_control[69]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [69], \u_watch/wrapper_cwc_top/cwc_control [69]);
  buf \u_watch/wrapper_cwc_top/cwc_control[6]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [6], \u_watch/cwc_control [6]);
  buf \u_watch/wrapper_cwc_top/cwc_control[6]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [6], \u_watch/wrapper_cwc_top/cwc_control [6]);
  buf \u_watch/wrapper_cwc_top/cwc_control[70]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [70], \u_watch/cwc_control [70]);
  buf \u_watch/wrapper_cwc_top/cwc_control[70]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [70], \u_watch/wrapper_cwc_top/cwc_control [70]);
  buf \u_watch/wrapper_cwc_top/cwc_control[71]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [71], \u_watch/cwc_control [71]);
  buf \u_watch/wrapper_cwc_top/cwc_control[71]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [71], \u_watch/wrapper_cwc_top/cwc_control [71]);
  buf \u_watch/wrapper_cwc_top/cwc_control[7]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [7], \u_watch/cwc_control [7]);
  buf \u_watch/wrapper_cwc_top/cwc_control[7]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [7], \u_watch/wrapper_cwc_top/cwc_control [7]);
  buf \u_watch/wrapper_cwc_top/cwc_control[8]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [8], \u_watch/cwc_control [8]);
  buf \u_watch/wrapper_cwc_top/cwc_control[8]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [8], \u_watch/wrapper_cwc_top/cwc_control [8]);
  buf \u_watch/wrapper_cwc_top/cwc_control[9]_syn_1  (\u_watch/wrapper_cwc_top/cwc_control [9], \u_watch/cwc_control [9]);
  buf \u_watch/wrapper_cwc_top/cwc_control[9]_syn_2  (\u_watch/wrapper_cwc_top/U_cwc/control [9], \u_watch/wrapper_cwc_top/cwc_control [9]);
  buf \u_watch/wrapper_cwc_top/cwc_status[0]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [0], \u_watch/wrapper_cwc_top/status_pipe/data_out [0]);
  buf \u_watch/wrapper_cwc_top/cwc_status[0]_syn_2  (\u_watch/cwc_status [0], \u_watch/wrapper_cwc_top/cwc_status [0]);
  buf \u_watch/wrapper_cwc_top/cwc_status[10]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [10], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[10]_syn_2  (\u_watch/cwc_status [10], \u_watch/wrapper_cwc_top/cwc_status [10]);
  buf \u_watch/wrapper_cwc_top/cwc_status[11]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [11], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[11]_syn_2  (\u_watch/cwc_status [11], \u_watch/wrapper_cwc_top/cwc_status [11]);
  buf \u_watch/wrapper_cwc_top/cwc_status[12]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [12], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[12]_syn_2  (\u_watch/cwc_status [12], \u_watch/wrapper_cwc_top/cwc_status [12]);
  buf \u_watch/wrapper_cwc_top/cwc_status[13]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [13], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[13]_syn_2  (\u_watch/cwc_status [13], \u_watch/wrapper_cwc_top/cwc_status [13]);
  buf \u_watch/wrapper_cwc_top/cwc_status[14]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [14], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[14]_syn_2  (\u_watch/cwc_status [14], \u_watch/wrapper_cwc_top/cwc_status [14]);
  buf \u_watch/wrapper_cwc_top/cwc_status[15]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [15], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[15]_syn_2  (\u_watch/cwc_status [15], \u_watch/wrapper_cwc_top/cwc_status [15]);
  buf \u_watch/wrapper_cwc_top/cwc_status[16]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [16], \u_watch/wrapper_cwc_top/status_pipe/data_out [16]);
  buf \u_watch/wrapper_cwc_top/cwc_status[16]_syn_2  (\u_watch/cwc_status [16], \u_watch/wrapper_cwc_top/cwc_status [16]);
  buf \u_watch/wrapper_cwc_top/cwc_status[17]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [17], \u_watch/wrapper_cwc_top/status_pipe/data_out [17]);
  buf \u_watch/wrapper_cwc_top/cwc_status[17]_syn_2  (\u_watch/cwc_status [17], \u_watch/wrapper_cwc_top/cwc_status [17]);
  buf \u_watch/wrapper_cwc_top/cwc_status[18]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [18], \u_watch/wrapper_cwc_top/status_pipe/data_out [18]);
  buf \u_watch/wrapper_cwc_top/cwc_status[18]_syn_2  (\u_watch/cwc_status [18], \u_watch/wrapper_cwc_top/cwc_status [18]);
  buf \u_watch/wrapper_cwc_top/cwc_status[19]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [19], \u_watch/wrapper_cwc_top/status_pipe/data_out [19]);
  buf \u_watch/wrapper_cwc_top/cwc_status[19]_syn_2  (\u_watch/cwc_status [19], \u_watch/wrapper_cwc_top/cwc_status [19]);
  buf \u_watch/wrapper_cwc_top/cwc_status[1]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [1], \u_watch/wrapper_cwc_top/status_pipe/data_out [1]);
  buf \u_watch/wrapper_cwc_top/cwc_status[1]_syn_2  (\u_watch/cwc_status [1], \u_watch/wrapper_cwc_top/cwc_status [1]);
  buf \u_watch/wrapper_cwc_top/cwc_status[20]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [20], \u_watch/wrapper_cwc_top/status_pipe/data_out [20]);
  buf \u_watch/wrapper_cwc_top/cwc_status[20]_syn_2  (\u_watch/cwc_status [20], \u_watch/wrapper_cwc_top/cwc_status [20]);
  buf \u_watch/wrapper_cwc_top/cwc_status[21]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [21], \u_watch/wrapper_cwc_top/status_pipe/data_out [21]);
  buf \u_watch/wrapper_cwc_top/cwc_status[21]_syn_2  (\u_watch/cwc_status [21], \u_watch/wrapper_cwc_top/cwc_status [21]);
  buf \u_watch/wrapper_cwc_top/cwc_status[22]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [22], \u_watch/wrapper_cwc_top/U_cwc/state_rstn );
  buf \u_watch/wrapper_cwc_top/cwc_status[22]_syn_2  (\u_watch/cwc_status [22], \u_watch/wrapper_cwc_top/cwc_status [22]);
  buf \u_watch/wrapper_cwc_top/cwc_status[23]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [23], \u_watch/wrapper_cwc_top/status_pipe/data_out [23]);
  buf \u_watch/wrapper_cwc_top/cwc_status[23]_syn_2  (\u_watch/cwc_status [23], \u_watch/wrapper_cwc_top/cwc_status [23]);
  buf \u_watch/wrapper_cwc_top/cwc_status[2]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [2], \u_watch/wrapper_cwc_top/status_pipe/data_out [2]);
  buf \u_watch/wrapper_cwc_top/cwc_status[2]_syn_2  (\u_watch/cwc_status [2], \u_watch/wrapper_cwc_top/cwc_status [2]);
  buf \u_watch/wrapper_cwc_top/cwc_status[3]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [3], \u_watch/wrapper_cwc_top/status_pipe/data_out [3]);
  buf \u_watch/wrapper_cwc_top/cwc_status[3]_syn_2  (\u_watch/cwc_status [3], \u_watch/wrapper_cwc_top/cwc_status [3]);
  buf \u_watch/wrapper_cwc_top/cwc_status[4]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [4], \u_watch/wrapper_cwc_top/status_pipe/data_out [4]);
  buf \u_watch/wrapper_cwc_top/cwc_status[4]_syn_2  (\u_watch/cwc_status [4], \u_watch/wrapper_cwc_top/cwc_status [4]);
  buf \u_watch/wrapper_cwc_top/cwc_status[5]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [5], \u_watch/wrapper_cwc_top/status_pipe/data_out [5]);
  buf \u_watch/wrapper_cwc_top/cwc_status[5]_syn_2  (\u_watch/cwc_status [5], \u_watch/wrapper_cwc_top/cwc_status [5]);
  buf \u_watch/wrapper_cwc_top/cwc_status[6]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [6], \u_watch/wrapper_cwc_top/status_pipe/data_out [6]);
  buf \u_watch/wrapper_cwc_top/cwc_status[6]_syn_2  (\u_watch/cwc_status [6], \u_watch/wrapper_cwc_top/cwc_status [6]);
  buf \u_watch/wrapper_cwc_top/cwc_status[7]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [7], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[7]_syn_2  (\u_watch/cwc_status [7], \u_watch/wrapper_cwc_top/cwc_status [7]);
  buf \u_watch/wrapper_cwc_top/cwc_status[8]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [8], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[8]_syn_2  (\u_watch/cwc_status [8], \u_watch/wrapper_cwc_top/cwc_status [8]);
  buf \u_watch/wrapper_cwc_top/cwc_status[9]_syn_1  (\u_watch/wrapper_cwc_top/cwc_status [9], 1'b0);
  buf \u_watch/wrapper_cwc_top/cwc_status[9]_syn_2  (\u_watch/cwc_status [9], \u_watch/wrapper_cwc_top/cwc_status [9]);
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \u_watch/wrapper_cwc_top/status_pipe/data_in[18]_syn_7  (
    .a(\u_watch/wrapper_cwc_top/status_pipe/data_in [18]),
    .o(\u_watch/wrapper_cwc_top/status_pipe/data_in[18]_syn_2 ));
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [0]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [0])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[16]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_in [16]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [16])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[17]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/stop ),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [17])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[18]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_in [18]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [18])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[19]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_in [19]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [19])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [1]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [1])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[20]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_in [20]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [20])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[21]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_in [21]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [21])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[23]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/status_pipe/data_in [23]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [23])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [2]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [2])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [3]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [3])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [4]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [4])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [5]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [5])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/status_pipe/data_in_d1_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/TRIG_ONLY_MODE$U_emb_ctrl/wt_addr [6]),
    .q(\u_watch/wrapper_cwc_top/status_pipe/data_out [6])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [0]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [10]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [11]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [12]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [13]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [14]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [15]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [1]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [2]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [3]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [4]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [5]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [6]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [7]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [8]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d2_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/U_cwc/U_cwc_bus_top/CWC_BUS_DETECTOR[0]$BUS_DETECTOR$U_cwc_bus_det/bus_reg [9]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [0]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [10]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [11]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [12]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [13]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [14]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [15]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [1]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [2]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [3]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [4]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [5]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [6]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [7]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [8]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d3_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d2 [9]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [0]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [10]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [11]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [12]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [13]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [14]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [15]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [1]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [2]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [3]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [4]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [5]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [6]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [7]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [8]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d4_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d3 [9]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [0]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [10]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [11]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [12]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [13]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [14]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [15]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [1]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [2]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [3]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [4]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [5]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [6]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [7]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [8]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d5_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d4 [9]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [9]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [0]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [0]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [10]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [10]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [11]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [11]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [12]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [12]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [13]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [13]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [14]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [14]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [15]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [15]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [1]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [1]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [2]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [2]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [3]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [3]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [4]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [4]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [5]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [5]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [6]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [6]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [7]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [7]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [8]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [8]));
  AL_MAP_SEQ #(
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d6_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d5 [9]),
    .q(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [9]));
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[0]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [0]),
    .q(\u_watch/wrapper_cwc_top/ram_data [0])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[10]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [10]),
    .q(\u_watch/wrapper_cwc_top/ram_data [10])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[11]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [11]),
    .q(\u_watch/wrapper_cwc_top/ram_data [11])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[12]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [12]),
    .q(\u_watch/wrapper_cwc_top/ram_data [12])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[13]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [13]),
    .q(\u_watch/wrapper_cwc_top/ram_data [13])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[14]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [14]),
    .q(\u_watch/wrapper_cwc_top/ram_data [14])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[15]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [15]),
    .q(\u_watch/wrapper_cwc_top/ram_data [15])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[1]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [1]),
    .q(\u_watch/wrapper_cwc_top/ram_data [1])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[2]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [2]),
    .q(\u_watch/wrapper_cwc_top/ram_data [2])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[3]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [3]),
    .q(\u_watch/wrapper_cwc_top/ram_data [3])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[4]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [4]),
    .q(\u_watch/wrapper_cwc_top/ram_data [4])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[5]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [5]),
    .q(\u_watch/wrapper_cwc_top/ram_data [5])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[6]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [6]),
    .q(\u_watch/wrapper_cwc_top/ram_data [6])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[7]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [7]),
    .q(\u_watch/wrapper_cwc_top/ram_data [7])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[8]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [8]),
    .q(\u_watch/wrapper_cwc_top/ram_data [8])); /* synthesis keep=true */ 
  AL_MAP_SEQ #(
    //.FORCE_KEEP("ON"),
    //.INIT(1'b0),
    .CEMUX("1"),
    .CLKMUX("CLK"),
    .DFFMODE("FF"),
    .REGSET("RESET"),
    .SRMODE("ASYNC"),
    .SRMUX("0"))
    \u_watch/wrapper_cwc_top/watch_pipe/data_in_d7_reg[9]  (
    .clk(clk_dup_1),
    .d(\u_watch/wrapper_cwc_top/watch_pipe/data_in_d6 [9]),
    .q(\u_watch/wrapper_cwc_top/ram_data [9])); /* synthesis keep=true */ 
  AL_LOGIC_DEBUGHUB #(
    .CTRL_LEN("72"),
    .PWR_ON_CTRL("68'b00000000000000000000000000000000000000000000000000000000000000000000"),
    .PWR_ON_EXIST("0"),
    .STAT_LEN("24"))
    \u_watch/wrapper_debughub  (
    .clk(clk_dup_1),
    .status(\u_watch/cwc_status ),
    .control(\u_watch/cwc_control ));  // cw_smoke_ip_watcherInst.sv(50)

endmodule 

