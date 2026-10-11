set task_root E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_place.db

    set target {u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_addr_1d_reg[16]_syn_3}
    set candidates [get_cells -hier -full_hier *app_rd_addr_1d_reg*]
    set target_index [lsearch -exact $candidates $target]
    if {$target_index >= 0} {
        set target_cell [lindex $candidates $target_index]
        puts "TARGET_COLLECTION=<$target_cell> LENGTH=[llength $target_cell]"
    } else {
        set target_cell {}
        puts "TARGET_COLLECTION_NOT_FOUND"
    }
    puts "=== target attributes ==="
    report_cells $target -attributes
    puts "=== SDRAM hard macro attributes ==="
    report_cells u_frame_buffer/u_sdram/sdram -attributes

    puts "=== center grid occupancy col12..28 row20..44 ==="
    for {set col 12} {$col <= 28} {incr col} {
        for {set row 20} {$row <= 44} {incr row} {
            set grid x${col}y${row}
            puts "--- GRID $grid ---"
            if {[catch {report_cells -grid $grid} message]} {
                puts "GRID_QUERY_ERROR $grid $message"
            }
        }
    }

    puts "=== source grid occupancy ==="
    report_cells -grid x2y24
} message]} {
    puts "OCCUPANCY_QUERY_ERROR: $message"
    exit 1
}
close_project
exit
