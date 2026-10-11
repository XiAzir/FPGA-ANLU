if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/manual/AC201_tf_hdmi_pr.db
    write_verilog E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cadence_probe/build/audit/final_pr_routed.v
} message]} {
    puts "READONLY_DUMP_ERROR: $message"
    exit 1
}
puts "READONLY_DUMP_COMPLETE"
exit
