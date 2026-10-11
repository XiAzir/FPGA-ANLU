set task_root E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag
set grid $::env(FPGA_DIAG_MOVE_GRID)
if {![regexp {^x([0-9]+)y([0-9]+)$} $grid -> col row] || $col<12 || $col>28 || $row<20 || $row>44} {error "Invalid grid"}
set output_dir $task_root/build/attempt_streaming_move_$grid
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $output_dir/AC201_tf_hdmi_moved.db
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
    puts "MOVED_ROUTE_ERROR: $message"
    exit 1
}
puts "MOVED_ROUTE_HOLD_COMPLETE"
close_project
exit
