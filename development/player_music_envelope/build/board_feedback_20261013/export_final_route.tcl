set task_root E:/VSCODE-project/FPGA-ANLU/development/player_music_envelope
set output_dir $task_root/build/board_feedback_20261013
file mkdir $output_dir
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $task_root/build/manual/AC201_tf_hdmi_pr.db
    write_verilog $output_dir/AC201_tf_hdmi_pr_impl.v -implement -pinorder
} message]} {
    puts "POST_ROUTE_EXPORT_ERROR: $message"
    exit 1
}
puts "POST_ROUTE_NETLIST_EXPORT_COMPLETE"
close_project
exit
