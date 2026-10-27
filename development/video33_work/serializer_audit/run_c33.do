transcript on
if {[file exists work]} {vdel -lib work -all}
vlib work
vlog -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_pll.v
vlog -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_logic_io.v
vlog -timescale 1ps/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_logic_clk.v
vlog -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v
vlog -timescale 1ns/1ps ../../player_video33_1080p_output/src/user_source/hdl_source/IP/video_pll.v ../../player_video33_1080p_output/src/user_source/hdl_source/lane_lvds_10_1.v tb_lane_scoreboard_c33.sv
vsim -c work.tb_lane_scoreboard work.glbl
run -all
quit -f






