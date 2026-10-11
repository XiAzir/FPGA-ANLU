cd E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/src/td_project
import_device eagle_s20.db -package EG4S20BG256
import_db E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/attempt_packet_replicated_placed/AC201_tf_hdmi_replicated.db
puts "=== get_nets help ==="
get_nets -help
puts "=== query name pattern ==="
set found [get_nets -hier -full_hier *sdr_t*]
puts "COUNT=[llength $found] NAMES=$found"
puts "=== report matched net connections ==="
report_nets $found -connection -hierarchy
exit
