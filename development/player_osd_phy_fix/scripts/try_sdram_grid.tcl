# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
# Placement-only experiment for the single setup-critical SDRAM tristate slice.
set task_root ${fpga_project_root}
set grid $::env(FPGA_OSD_SDRAM_GRID)
if {[lsearch -exact {x28y40 x30y44 x26y48} $grid]<0} {error "Unexpected trial grid"}
set output_dir $task_root/build/attempt_sdram_$grid
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
    move_cells -inst $target -location $grid -mode enforce -step place
    puts "SDRAM_DRIVER_AFTER_MOVE"
    report_cells $target -attributes
    export_db $output_dir/AC201_tf_hdmi_moved.db
} message]} {
    puts "SDRAM_GRID_ERROR: $message"
    exit 1
}
puts "SDRAM_GRID_TRIAL_COMPLETE"
close_project
exit
