cd E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/src/td_project
import_device eagle_s20.db -package EG4S20BG256
import_db E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/manual/AC201_tf_hdmi_place.db
set candidates [get_cells -hier -full_hier *app_rd_addr_1d_reg*]
puts "CANDIDATES=$candidates"
set target {u_frame_buffer/u_sdram/u2_ram/u2_wrrd/app_rd_addr_1d_reg[16]_syn_3}
if {[lsearch -exact $candidates $target] < 0} {error "Timing driver cell not found"}
puts "=== timing driver attributes and connections ==="
report_cells $target -attributes -connection -pin_loc
puts "=== sdr_t connections ==="
report_nets [get_nets -hier -full_hier */u2_wrrd/sdr_t] -connection -hierarchy
puts "=== destination grid ==="
report_cells -grid x032y040
exit
