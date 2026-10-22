import_device eagle_s20.db -package EG4S20BG256
foreach task_command {write_sdf report_timing report_timing_summary check_timing} {
    puts "COMMAND_HELP $task_command"
    catch {help $task_command} task_message
    puts $task_message
}
exit
