cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 import_db input_gate.db
 mark_debug {u_audio_probe/audio_valid}
 insert_debugger
 report_cwc_status
 export_chipwatcher marked.cwc
 report_area -file marked.area
 write_verilog marked.v
 export_db marked.db
} message]} {
 puts "MARKED_CW_ERROR: $message"
 exit 1
}
puts "MARKED_CW_COMPLETE"
exit
