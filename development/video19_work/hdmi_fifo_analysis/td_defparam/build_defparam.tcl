set fpga_project_root [file normalize [file join [file dirname [info script]] project]]
set project_dir $fpga_project_root/td_project
set output_dir [file normalize [file join [file dirname [info script]] build]]
cd $project_dir
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run
    load_run_param -run syn_1
    elaborate -top top
    read_adc ../user_source/constraints_source/pin.adc
    read_sdc ../user_source/constraints_source/timing.sdc
    read_sdc -ip rfifo_32_32_512 ../user_source/hdl_source/IP/afifo_16_32_256.tcl
    read_sdc -ip wfifo_32_32_512 ../user_source/hdl_source/IP/afifo_32_16_256.tcl
    commit_param -step rtl
    optimize_rtl
    export_db $output_dir/AC201_tf_hdmi_rtl.db
    commit_param -step gate
    optimize_gate -packarea $output_dir/AC201_tf_hdmi_gate.area
    write_verilog $output_dir/AC201_tf_hdmi_gate.v
    export_db $output_dir/AC201_tf_hdmi_gate.db
} message]} {
    puts "BUILD_ERROR: $message"
    exit 1
}
puts "SYNTHESIS_COMPLETE_WITH_GATE_DATABASE"
close_project
exit
