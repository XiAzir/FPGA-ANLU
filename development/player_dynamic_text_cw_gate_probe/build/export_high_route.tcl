set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
import_device eagle_s20.db -package EG4S20BG256
import_db ${fpga_project_root}/build/preflight/C11103_high_routability/AC201_tf_hdmi_pr.db
write_verilog ${fpga_project_root}/build/high_hold_routed.v
puts "ARCHIVED_ROUTE_NETLIST_EXPORTED"
exit
