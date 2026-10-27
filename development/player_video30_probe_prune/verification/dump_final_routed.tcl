set task_root [file normalize [file join [file dirname [info script]] ..]]
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db $task_root/build/manual/AC201_tf_hdmi_pr.db
    write_verilog $task_root/verification/final_routed.v
} message]} {
    puts "READONLY_DUMP_ERROR: $message"
    exit 1
}
puts "READONLY_DUMP_COMPLETE"
exit
