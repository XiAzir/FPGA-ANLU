cd E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/src/td_project
import_device eagle_s20.db -package EG4S20BG256
import_db E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/manual/AC201_tf_hdmi_gate.db
puts "=== prepacking control cells ==="
set cells [get_cells -hier -full_hier *sdr_t_reg*]
puts "CELLS=$cells"
report_cells $cells -attributes -connection
puts "=== bound commands ==="
create_bound -help
add_cells_to_bound -help
exit
