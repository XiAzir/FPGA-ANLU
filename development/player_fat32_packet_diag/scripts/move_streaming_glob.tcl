# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
# Query a typed collection using one-character wildcards for bus brackets.
# Exact canonical name/count are checked before touching the placement.
set task_root ${fpga_project_root}
set output_dir $task_root/build/attempt_streaming_move_glob
file mkdir $output_dir
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_place.db
    set target_cells [get_cells -hier -full_hier *app_rd_addr_1d_reg?16?_syn_3]
    set target {u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_addr_1d_reg[16]_syn_3}
    puts "TARGET_COUNT=[llength $target_cells] TARGET=$target_cells"
    if {[llength $target_cells] != 1 || [lsearch -exact $target_cells $target] < 0} {error "Expected exactly one canonical timing driver"}
    puts "=== driver before move ==="
    report_cells $target_cells -attributes
    move_cells -inst $target_cells -location {x20y30} -mode enforce -step place
    puts "=== driver after move ==="
    report_cells $target_cells -attributes
    export_db $output_dir/AC201_tf_hdmi_moved.db
} message]} {
    puts "LOCAL_MOVE_ERROR: $message"
    exit 1
}
puts "LOCAL_MOVE_COMMAND_COMPLETE_VERIFY_ATTRIBUTES"
close_project
exit
