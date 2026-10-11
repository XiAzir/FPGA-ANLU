# Target the packed SDRAM tristate driver found in the new setup-failing report.
set task_root E:/VSCODE-project/FPGA-ANLU/development/player_osd_phy_fix
set output_dir $task_root/build/attempt_sdram_x17y36
file mkdir $output_dir
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_place.db
    set cells [get_cells -hier -full_hier *app_wr_din_6d_reg?20?_syn_4]
    set target {u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_6d_reg[20]_syn_4}
    if {[llength $cells]!=1 || [lsearch -exact $cells $target]<0} {error "SDRAM driver not uniquely verified"}
    puts "SDRAM_DRIVER_BEFORE_MOVE"
    report_cells $target -attributes
    move_cells -inst $target -location x17y36 -mode enforce -step place
    puts "SDRAM_DRIVER_AFTER_MOVE"
    report_cells $target -attributes
    export_db $output_dir/AC201_tf_hdmi_moved.db
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
    puts "SDRAM_MOVE_ROUTE_ERROR: $message"
    exit 1
}
puts "SDRAM_MOVE_ROUTE_HOLD_COMPLETE"
close_project
exit
