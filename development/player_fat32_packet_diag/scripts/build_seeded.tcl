# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
# Seed selection follows the installed TD scripts/MultiSeed.tcl flow.
# No pin, clock, HDL or timing exception changes. No post-route phys_opt.
set task_root ${fpga_project_root}
set place_seed $::env(FPGA_DIAG_PLACE_SEED)
if {![string is integer -strict $place_seed] || $place_seed < 2 || $place_seed > 5} {
    error "Invalid bounded diagnostic placement seed"
}
set output_dir $task_root/build/attempt_streaming_seed_$place_seed
file mkdir $output_dir
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_gate.db
    set_param place seed $place_seed
    puts "DIAGNOSTIC_PLACE_SEED=$place_seed"
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
    puts "SEEDED_BUILD_ERROR: $message"
    exit 1
}
puts "SEEDED_PLACE_ROUTE_HOLD_COMPLETE"
close_project
exit
