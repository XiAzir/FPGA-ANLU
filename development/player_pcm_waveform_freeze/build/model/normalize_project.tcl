set fpga_project_root [file normalize [file join [file dirname [info script]] ../..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
cd ${fpga_project_root}/src/td_project
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 open_project AC201_tf_hdmi.al -single_run
 close_project
} message]} { puts "PROJECT_NORMALIZATION_ERROR: $message"; exit 1 }
puts PROJECT_NORMALIZATION_COMPLETE
exit
