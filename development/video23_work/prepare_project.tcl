set task_root [file normalize [file join [file dirname [info script]] .. player_video23_mode_switch]]
cd $task_root/src/td_project
import_device eagle_s20.db -package EG4S20BG256
open_project AC201_tf_hdmi.al -single_run
elaborate -top top
close_project
puts "PROJECT_ANALYSIS_COMPLETE"
exit

