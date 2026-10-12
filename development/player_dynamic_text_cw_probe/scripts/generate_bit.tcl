set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
set output_dir ${fpga_project_root}/build/manual
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $output_dir/AC201_tf_hdmi_pr.db
    cd ${fpga_project_root}/src/td_project
    commit_param -step bitgen
    bitgen -bit $output_dir/AC201_player_dynamic_text_cw_probe.bit
    setup_debugger . -bit $output_dir/AC201_player_dynamic_text_cw_probe.bit
    export_chipwatcher $output_dir/cw_probe.cwc -add_bid
    export_chipwatcher $output_dir/cw_probe_sp.cwc -sp -add_bid
} message]} {
    puts "BITGEN_ERROR: $message"
    exit 1
}
puts "BITSTREAM_GENERATED"
exit








