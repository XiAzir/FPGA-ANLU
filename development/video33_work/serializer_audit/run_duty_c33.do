transcript on
vlib work_duty
vlog -work work_duty -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_pll.v
vlog -work work_duty -timescale 1ps/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_logic_clk.v
vlog -work work_duty -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v
vlog -work work_duty -timescale 1ns/1ps ../../player_video33_1080p_output/src/user_source/hdl_source/IP/video_pll.v tb_pll_duty.sv
vsim -c work_duty.tb_pll_duty work_duty.glbl
run -all
quit -f
