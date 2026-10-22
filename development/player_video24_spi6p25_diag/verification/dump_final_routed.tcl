if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db E:/VSCODE-project/FPGA-ANLU/development/player_video24_spi6p25_diag/build/manual/AC201_tf_hdmi_pr.db
    write_verilog E:/VSCODE-project/FPGA-ANLU/development/player_video24_spi6p25_diag/verification/final_routed.v
} message]} {
    puts "READONLY_DUMP_ERROR: $message"
    exit 1
}
puts "READONLY_DUMP_COMPLETE"
exit

