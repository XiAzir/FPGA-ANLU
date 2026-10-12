cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/src/td_project
if {[catch {
 open_project AC201_tf_hdmi.al -noanalyze
 add_files ../user_source/hdl_source/player_count_chipwatcher.sv
 close_project
} message]} {puts "ADD_SV_ERROR: $message"; exit 1}
puts "ADD_SV_COMPLETE"
exit
