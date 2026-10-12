set output_dir E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/build/postroute_documented_trial
file mkdir $output_dir
cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/build/manual/AC201_tf_hdmi_pr.db
    phys_opt -post_route -effort high
    update_timing -mode final
    report_timing_status -file $output_dir/trial.ts
    report_timing_summary -file $output_dir/trial.timing
    export_db $output_dir/trial.db
} message]} {
    puts "TRIAL_ERROR: $message"
    exit 1
}
puts "DOCUMENTED_POST_ROUTE_TRIAL_COMPLETE_NO_BITGEN"
close_project
exit
