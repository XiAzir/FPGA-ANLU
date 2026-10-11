import_device eagle_s20.db -package EG4S20BG256
import_db E:/VSCODE-project/FPGA-ANLU/development/player_fat32_audio_probe/build/manual/AC201_tf_hdmi_pr.db
write_verilog E:/VSCODE-project/FPGA-ANLU/development/player_fat32_autoplay/build/audio_impl_audit/audio_probe_routed.v -implement
puts AUDIO_NETLIST_EXPORTED
exit
