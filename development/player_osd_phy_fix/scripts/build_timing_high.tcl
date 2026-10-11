# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
# Documented place settings from installed official_strategy_ph1.json TimingUltra.
# Reuse the same synthesized database, HDL, PLL, pins and SDC. No seed search.
set task_root ${fpga_project_root}
set output_dir $task_root/build/attempt_timing_high
file mkdir $output_dir
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_gate.db
    set_param place effort high
    set_param place opt_timing high
    set_param place crit_path_opt on
    set_param place post_place_opt high
    set_param place hfn_opt_effort high
    commit_param -step place
    place
    update_timing -mode manhattan
    report_timing_status -file $output_dir/AC201_tf_hdmi_place.ts
    export_db $output_dir/AC201_tf_hdmi_place.db
    commit_param -step route
    route
    update_timing -mode final
    report_timing_status -file $output_dir/prehold.ts
    report_timing_summary -file $output_dir/prehold.timing
    export_db $output_dir/prehold.db
    fix_hold
    update_timing -mode final
    report_timing_status -file $output_dir/AC201_tf_hdmi_phy.ts
    report_timing_summary -file $output_dir/AC201_tf_hdmi_pr.timing
    check_timing -verbose -file $output_dir/AC201_tf_hdmi_chk.timing
    report_timing_exception -file $output_dir/AC201_tf_hdmi_exception.timing
    report_area -io_info -file $output_dir/AC201_tf_hdmi_phy.area
    export_db $output_dir/AC201_tf_hdmi_pr.db
} message]} {
    puts "TIMING_HIGH_ERROR: $message"
    exit 1
}
puts "TIMING_HIGH_PLACE_ROUTE_HOLD_COMPLETE"
close_project
exit
