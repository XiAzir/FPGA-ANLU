set output_dir E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/build/manual
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $output_dir/AC201_tf_hdmi_pr.db
    cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/src/td_project
    commit_param -step bitgen
    bitgen -bit $output_dir/AC201_player_dynamic_text_cw_gate_probe.bit
    setup_debugger chip_debugger -bit $output_dir/AC201_player_dynamic_text_cw_gate_probe.bit
    export_chipwatcher $output_dir/cw_gate_probe.cwc -add_bid
    export_chipwatcher $output_dir/cw_gate_probe_sp.cwc -sp -add_bid
} message]} {
    puts "BITGEN_ERROR: $message"
    exit 1
}
puts "BITSTREAM_GENERATED"
exit








