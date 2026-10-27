transcript on
if {[file exists work]} {vdel -lib work -all}
vlib work
vlog -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_pll.v
vlog -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_logic_clk.v
vlog -timescale 1ns/1ps ../src/user_source/hdl_source/IP/video_pll.v tb_video_pll.sv
vsim -c work.tb_video_pll
run -all
quit -f
