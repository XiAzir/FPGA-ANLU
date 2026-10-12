set output_dir E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/build/manual
cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $output_dir/AC201_tf_hdmi_gate.db
    # Isolated timing strategy trial; original HDL/PLL/constraints retained.
    # The prior high/routability route and hold reports are archived.
    set_param place effort ultra
    set_param place opt_timing ultra
    set_param place crit_path_opt on
    set_param place post_place_opt ultra
    set_param place hfn_opt_effort high
    commit_param -step place
    insert_debugger chip_debugger -cwc chip_debugger/user.cfg
    export_chipwatcher $output_dir/cw_gate_before_place.cwc
    write_verilog $output_dir/AC201_tf_hdmi_debug_gate.v
    export_db $output_dir/AC201_tf_hdmi_debug_gate.db
    place
    update_timing -mode manhattan
    report_timing_status -file $output_dir/AC201_tf_hdmi_place.ts
    report_area -io_info -file $output_dir/AC201_tf_hdmi_phy.area
    export_db $output_dir/AC201_tf_hdmi_place.db
    set_param route effort timing
    commit_param -step route
    route
    update_timing -mode final
    report_timing_status -file $output_dir/AC201_tf_hdmi_phy.ts
    report_timing_summary -file $output_dir/AC201_tf_hdmi_pr.timing
    check_timing -verbose -file $output_dir/AC201_tf_hdmi_chk.timing
    report_timing_exception -file $output_dir/AC201_tf_hdmi_exception.timing
    export_db $output_dir/AC201_tf_hdmi_pr.db
} message]} {
    puts "BUILD_ERROR: $message"
    exit 1
}
puts "PLACE_ROUTE_COMPLETE_WITH_REPORTS"
# Bitstream generation is a separate step after timing and clock warnings review.
close_project
exit









