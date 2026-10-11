set output_dir E:/VSCODE-project/FPGA-ANLU/development/player_fat32_status_diag/build/manual
cd E:/VSCODE-project/FPGA-ANLU/development/player_fat32_status_diag/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $output_dir/AC201_tf_hdmi_pr.db
    phys_opt -post_route -effort high -mode relocation
    route -incremental
    fix_hold
    update_timing -mode final
    report_timing_status -file $output_dir/AC201_tf_hdmi_phy.ts
    report_timing_summary -file $output_dir/AC201_tf_hdmi_pr.timing
    check_timing -verbose -file $output_dir/AC201_tf_hdmi_chk.timing
    report_area -io_info -file $output_dir/AC201_tf_hdmi_phy.area
    export_db $output_dir/AC201_tf_hdmi_pr.db
} message]} {
    puts "PHYS_OPT_ERROR: $message"
    exit 1
}
puts POST_ROUTE_OPTIMIZATION_COMPLETE
close_project
exit
