# Official route effort option; rerun standard routing from saved placement.
# Do not call phys_opt (post-route modes crashed this TD installation).
set project_dir E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/src/td_project
set source_db E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/manual/AC201_tf_hdmi_place.db
set output_dir E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/attempt_packet_routability
file mkdir $output_dir
cd $project_dir
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    set_param -run phy_1 route effort routability
    load_run_param -run phy_1
    import_db $source_db
    commit_param -step route
    route
    fix_hold
    update_timing -mode final
    report_timing_status -file $output_dir/AC201_tf_hdmi_phy.ts
    report_timing_summary -file $output_dir/AC201_tf_hdmi_pr.timing
    check_timing -verbose -file $output_dir/AC201_tf_hdmi_chk.timing
    report_area -io_info -file $output_dir/AC201_tf_hdmi_phy.area
    export_db $output_dir/AC201_tf_hdmi_pr.db
} message]} {
    puts "ROUTABILITY_ERROR: $message"
    exit 1
}
puts ROUTABILITY_COMPLETE
close_project
exit
