set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
# TD application commands only; offline inspection, no hardware access.
import_device eagle_s20.db -package EG4S20BG256
import_db ${fpga_project_root}/build/manual/AC201_tf_hdmi_gate.db
puts "CW_GUI_GATE_READY"
