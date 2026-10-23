set task_root [file normalize [file join [file dirname [info script]] ..]]
cd $task_root/src/td_project
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run
    close_project
} message]} {
    puts "NORMALIZE_ERROR: $message"
    exit 1
}
puts "PROJECT_ANALYZED_BEFORE_SNAPSHOT"
exit
