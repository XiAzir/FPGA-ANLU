set task_root [file normalize [file join [file dirname [info script]] ../..]]
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $task_root/build/manual/AC201_tf_hdmi_pr.db
    write_verilog $task_root/build/audit/routed_implementation.v
} message]} {
    puts "ROUTE_ROM_EXPORT_ERROR: $message"
    exit 1
}
puts "ROUTE_ROM_EXPORT_COMPLETE_READ_ONLY"
exit

