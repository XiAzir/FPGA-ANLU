set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
set task_root ${fpga_project_root}
set project_dir $task_root/src/td_project
set output_dir $task_root/build/manual
cd $project_dir
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $output_dir/AC201_tf_hdmi_pr.db
    commit_param -step bitgen
    bitgen -bit $output_dir/AC201_player_transition_wipe.bit
} message]} {
    puts "BITGEN_ERROR: $message"
    exit 1
}
puts "BITSTREAM_GENERATED"
exit



