set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
cd ${fpga_project_root}/src/td_project
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 open_project AC201_tf_hdmi.al -single_run -noanalyze
 import_db ${fpga_project_root}/build/manual/AC201_tf_hdmi_gate.db
 config_chipwatcher -sp
 report_cwc_status
 export_chipwatcher ${fpga_project_root}/build/preflight/discovered_sp.cwc -sp
 compile_watcher
 report_area -file ${fpga_project_root}/build/preflight/compiled_watcher.area
 write_verilog ${fpga_project_root}/build/preflight/compiled_watcher.v
 export_db ${fpga_project_root}/build/preflight/compiled_watcher.db
} message]} {puts "DISCOVERY_ERROR: $message"; exit 1}
puts "DISCOVERY_COMPLETE"
exit
