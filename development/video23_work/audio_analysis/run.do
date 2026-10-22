if {[file exists work]} {vdel -lib work -all}
vlib work
vlog -work work ../../player_video22_audio_diag/src/user_source/hdl_source/audio_arc_calculate.v tb_acr_calculate.v
vsim -c -novopt work.tb_acr_calculate -do {run -all; quit -f} -l modelsim.log
