cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/src/td_project
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 open_project AC201_tf_hdmi.al -single_run -noanalyze
 import_db E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/manual/AC201_tf_hdmi_gate.db
 config_chipwatcher E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/preflight/native_empty.cwc -sp -sync -init_filter
 report_cwc_status
 export_chipwatcher E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/preflight/sync_discovered.cwc -sp
 compile_watcher
 report_area -file E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/preflight/sync_watcher.area
 write_verilog E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/preflight/sync_watcher.v
 export_db E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/preflight/sync_watcher.db
} message]} {puts "DISCOVERY_ERROR: $message"; exit 1}
puts "DISCOVERY_COMPLETE"
exit


