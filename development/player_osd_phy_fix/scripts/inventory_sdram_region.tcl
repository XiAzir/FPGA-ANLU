# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set task_root ${fpga_project_root}
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_place.db
    for {set col 20} {$col<=38} {incr col} {
        for {set row 28} {$row<=56} {incr row} {
            puts "INSPECT_GRID x${col}y${row}"
            report_cells -grid x${col}y${row}
        }
    }
} message]} {
    puts "REGION_INSPECT_ERROR: $message"
    exit 1
}
puts "REGION_INSPECTION_COMPLETE"
close_project
exit
