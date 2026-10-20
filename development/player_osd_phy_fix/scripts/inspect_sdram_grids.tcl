# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set task_root ${fpga_project_root}
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_place.db
    report_cells {u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_wr_din_6d_reg[20]_syn_4} -connection -attributes
    foreach grid {x20y28 x20y44 x24y32 x24y48 x28y28 x28y52 x32y32 x32y52 x36y28 x36y40 x36y52} {
        puts "INSPECT_GRID $grid"
        report_cells -grid $grid
    }
} message]} {
    puts "GRID_INSPECT_ERROR: $message"
    exit 1
}
puts "GRID_INSPECTION_COMPLETE"
close_project
exit
