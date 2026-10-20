# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
import_device eagle_s20.db -package EG4S20BG256
import_db ${fpga_project_root}/build/manual/AC201_tf_hdmi_pr.db
write_verilog ${fpga_project_root}/build/manual/compact_v1_routed.v -implement
exit

