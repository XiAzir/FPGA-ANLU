set output_dir E:/VSCODE-project/FPGA-ANLU/bringup/tf_hdmi/build/manual
import_device eagle_s20.db -package EG4S20BG256
foreach stage {elaborate} {
    puts "CLOCK_AUDIT_STAGE: $stage"
    import_db $output_dir/AC201_tf_hdmi_${stage}.db
    report_cells {U3/u2_ram/u2_wrrd/Sdr_rd_dout_reg} -connection
    report_cells {U3/u2_ram/u2_wrrd} -connection
}
exit
