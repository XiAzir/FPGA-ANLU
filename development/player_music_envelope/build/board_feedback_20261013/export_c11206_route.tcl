set task_root E:/VSCODE-project/FPGA-ANLU/development/player_bmp_scale
set output_dir E:/VSCODE-project/FPGA-ANLU/development/player_music_envelope/build/board_feedback_20261013
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_pr.db
    write_verilog $output_dir/C11206_tf_hdmi_pr_impl.v -implement -pinorder
} message]} {
    puts "BASELINE_EXPORT_ERROR: $message"
    exit 1
}
puts "BASELINE_ROUTE_NETLIST_EXPORT_COMPLETE"
close_project
exit
