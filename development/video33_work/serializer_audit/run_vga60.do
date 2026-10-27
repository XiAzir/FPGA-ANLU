transcript on
if {[file exists work_vga]} {vdel -lib work_vga -all}
vlib work_vga
vlog -work work_vga -timescale 1ns/1ps ../candidates/C11335_640x480_60hz_33_165_bufg/src/user_source/hdl_source/video_timing_1080p_custom_colorbar.v ../candidates/C11335_640x480_60hz_33_165_bufg/src/user_source/hdl_source/video_axis_1080p_adapter.v tb_vga60_timing.sv
vsim -c work_vga.tb_vga60_timing
run -all
quit -f

