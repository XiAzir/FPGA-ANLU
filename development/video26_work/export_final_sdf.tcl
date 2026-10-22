set task_root E:/VSCODE-project/FPGA-ANLU/development/player_video26_runtime_diag
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $task_root/build/manual/AC201_tf_hdmi_pr.db
    update_timing -mode final
    write_sdf -file E:/VSCODE-project/FPGA-ANLU/development/video26_work/final_slow.sdf -check_corner slow
} task_message]} {
    puts "SDF_EXPORT_ERROR $task_message"
    exit 1
}
puts "READONLY_SDF_EXPORTED"
exit
