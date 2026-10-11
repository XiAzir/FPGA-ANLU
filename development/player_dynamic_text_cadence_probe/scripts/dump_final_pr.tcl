# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db ${fpga_project_root}/build/manual/AC201_tf_hdmi_pr.db
    write_verilog ${fpga_project_root}/build/audit/final_pr_routed.v
} message]} {
    puts "READONLY_DUMP_ERROR: $message"
    exit 1
}
puts "READONLY_DUMP_COMPLETE"
exit
