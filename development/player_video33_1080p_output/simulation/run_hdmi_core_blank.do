transcript on
if {[file exists work]} {vdel -lib work -all}
vlib work
vlog ../src/user_source/hdl_source/hdmi1.4b_transmitter_core/hdmi_1_4b_transmitter_core_wrapper.enc.v
vlog -sv ../src/user_source/hdl_source/video_timing_1080p_custom_colorbar.v ../src/user_source/hdl_source/video_axis_1080p_adapter.v tb_hdmi_core_blank.sv
vsim -c work.tb_hdmi_core_blank
run -all
quit -f
