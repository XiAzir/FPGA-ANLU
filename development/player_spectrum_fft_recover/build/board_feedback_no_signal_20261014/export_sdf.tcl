set task_root [file normalize [file join [file dirname [info script]] ../..]]
set evidence [file dirname [info script]]
cd $task_root/src/td_project
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 import_db $task_root/build/manual/AC201_tf_hdmi_pr.db
 update_timing
 write_sdf -file $evidence/modelsim/routed.sdf
} message]} {
 puts "SDF_EXPORT_ERROR: $message"
 exit 1
}
puts "SDF_EXPORT_COMPLETE_READ_ONLY"
exit
