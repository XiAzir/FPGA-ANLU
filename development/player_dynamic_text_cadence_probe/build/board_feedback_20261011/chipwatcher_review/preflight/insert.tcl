# Offline only: no hardware connection or programming commands.
cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight/input_gate.db
    write_verilog E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight/input_gate.v
    insert_debugger E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight -cwc E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight/preflight.cwc
    report_area -file E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight/inserted.area
    export_db E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review/preflight/inserted_gate.db
} message]} {
    puts "CW_PREFLIGHT_ERROR: $message"
    exit 1
}
puts "CW_PREFLIGHT_INSERT_COMPLETE"
exit
