set output_dir E:/VSCODE-project/FPGA-ANLU/bringup/tf_hdmi/build/manual
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $output_dir/AC201_tf_hdmi_pr.db
    commit_param -step bitgen
    bitgen -bit $output_dir/AC201_tf_hdmi.bit
} message]} {
    puts "BITGEN_ERROR: $message"
    exit 1
}
puts "BITSTREAM_GENERATED"
exit
