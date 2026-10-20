# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set output_dir ${fpga_project_root}/build/manual
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $output_dir/AC201_tf_hdmi_pr.db
    commit_param -step bitgen
    bitgen -bit $output_dir/AC201_player_dynamic_text_fit.bit
} message]} {
    puts "BITGEN_ERROR: $message"
    exit 1
}
puts "BITSTREAM_GENERATED"
exit








