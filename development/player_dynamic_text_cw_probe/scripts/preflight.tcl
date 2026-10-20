set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
set root ${fpga_project_root}
set trial ${fpga_repo_root}/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight
cd $root/src/td_project
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 open_project AC201_tf_hdmi.al -single_run -noanalyze
 load_run_param -run phy_1
 import_db $trial/input_gate.db
 config_chipwatcher $trial/explicit.cwc
 report_cwc_status
 export_chipwatcher $root/build/preflight/parsed.cwc
 compile_watcher
 report_cwc_status
 report_area -file $root/build/preflight/cw.area
 write_verilog $root/build/preflight/cw.v
 export_db $root/build/preflight/cw.db
 close_project
} message]} {
 puts "PROJECT_CW_ERROR: $message"
 exit 1
}
puts "PROJECT_CW_COMPLETE"
exit
