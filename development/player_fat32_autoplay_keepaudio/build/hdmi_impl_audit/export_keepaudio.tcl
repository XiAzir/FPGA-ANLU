import_device eagle_s20.db -package EG4S20BG256
import_db E:/VSCODE-project/FPGA-ANLU/development/player_fat32_autoplay_keepaudio/build/manual/AC201_tf_hdmi_pr.db
write_verilog E:/VSCODE-project/FPGA-ANLU/development/player_fat32_autoplay_keepaudio/build/hdmi_impl_audit/keepaudio_routed.v -implement
puts HDMI_NETLIST_EXPORTED
exit
