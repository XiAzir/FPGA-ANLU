set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
cd ${fpga_project_root}/src/td_project
if {[catch {
 open_project AC201_tf_hdmi.al -noanalyze
 add_files ../user_source/hdl_source/player_count_chipwatcher.sv
 close_project
} message]} {puts "ADD_SV_ERROR: $message"; exit 1}
puts "ADD_SV_COMPLETE"
exit
