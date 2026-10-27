transcript on
if {[file exists work]} {vdel -lib work -all}
vlib work
vlog -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_pll.v
vlog -timescale 1ns/1ps C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_logic_clk.v tb_pll_c32_model.v
vsim -c work.tb_pll_c32_model
run -all
quit -f

