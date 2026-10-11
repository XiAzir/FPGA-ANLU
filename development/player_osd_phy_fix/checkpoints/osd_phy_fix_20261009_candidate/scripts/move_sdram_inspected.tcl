# Inventory found offset 3 free at x29y39 in the saved placed DB.
set task_root E:/VSCODE-project/FPGA-ANLU/development/player_osd_phy_fix
set output_dir $task_root/build/attempt_sdram_x29y39
file mkdir $output_dir
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_place.db
    set cells [get_cells -hier -full_hier *app_wr_din_6d_reg?20?_syn_4]
    set target {u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_6d_reg[20]_syn_4}
    if {[llength $cells]!=1 || [lsearch -exact $cells $target]<0} {error "Driver is not unique"}
    puts "SDRAM_DRIVER_BEFORE_MOVE"
    report_cells $target -attributes
    report_cells -grid x29y39
    move_cells -inst $target -location x29y39 -mode nonforce -step place
    puts "SDRAM_DRIVER_AFTER_MOVE"
    report_cells $target -attributes
    export_db $output_dir/AC201_tf_hdmi_moved.db
} message]} {
    puts "SDRAM_INSPECTED_MOVE_ERROR: $message"
    exit 1
}
puts "SDRAM_INSPECTED_MOVE_COMPLETE"
close_project
exit
