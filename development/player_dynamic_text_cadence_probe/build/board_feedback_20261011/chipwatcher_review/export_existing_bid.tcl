# Offline export from the existing routed DB only; no hardware operations.
set out E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/board_feedback_20261011/chipwatcher_review
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/manual/AC201_tf_hdmi_pr.db
    export_bid $out/cadence_probe.bid
} message]} {
    puts "EXPORT_BID_ERROR: $message"
    exit 1
}
puts "EXISTING_ROUTED_BID_EXPORT_COMPLETE"
exit
