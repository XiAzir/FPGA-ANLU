cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 import_db input_gate.db
 config_chipwatcher explicit.cwc
 report_cwc_status
 export_chipwatcher parsed.cwc
 compile_watcher
 report_cwc_status
 report_area -file explicit.area
 write_verilog explicit.v
 export_db explicit.db
} message]} {
 puts "EXPLICIT_CW_ERROR: $message"
 exit 1
}
puts "EXPLICIT_CW_COMPLETE"
exit
