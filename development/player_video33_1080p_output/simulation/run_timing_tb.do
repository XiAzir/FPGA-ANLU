transcript on
if {[file exists work]} {vdel -lib work -all}
vlib work
vlog -sv ../src/user_source/hdl_source/video_timing_1080p_custom_colorbar.v ../src/user_source/hdl_source/video_axis_1080p_adapter.v tb_video_timing_1080p15.sv
vsim -c work.tb_video_timing_1080p15
run -all
quit -f
