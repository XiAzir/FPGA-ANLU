set output_dir E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_axis_last_fix/build/manual
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $output_dir/AC201_tf_hdmi_pr.db
    commit_param -step bitgen
    bitgen -bit $output_dir/AC201_player_dynamic_text_axis_last_fix.bit
} message]} {
    puts "BITGEN_ERROR: $message"
    exit 1
}
puts "BITSTREAM_GENERATED"
exit








