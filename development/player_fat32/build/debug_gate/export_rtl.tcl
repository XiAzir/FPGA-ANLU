cd E:/VSCODE-project/FPGA-ANLU/development/player_fat32/build/debug_gate
import_device eagle_s20.db -package EG4S20BG256
open_project fat_probe.al -single_run
load_run_param -run syn_1
elaborate -top fat_probe
commit_param -step rtl
optimize_rtl
write_verilog probe_rtl.v
commit_param -step gate
optimize_gate -packarea probe.area
write_verilog probe_gate.v
puts PROBE_EXPORTED
close_project
exit

