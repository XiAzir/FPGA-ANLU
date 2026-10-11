if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db E:/VSCODE-project/FPGA-ANLU/development/player_osd_phy_fix/build/manual/AC201_tf_hdmi_pr.db
    write_verilog E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_video_probe/build/startup_readonly_audit/AC201_osd_phy_fix_pr_routed.v
} message]} {
    puts "READONLY_DUMP_ERROR: "
    exit 1
}
puts "READONLY_DUMP_COMPLETE"
exit
