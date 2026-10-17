set project_dir {E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/memory/controller_gate_20261016_182914/src/td_project}
set output_dir {E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/memory/controller_gate_20261016_182914/build}
cd $project_dir
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 open_project AC201_tf_hdmi.al -single_run
 load_run_param -run syn_1
 set_param -run syn_1 gate eram_init off
 elaborate -top sdram
 commit_param -step rtl
 optimize_rtl
 commit_param -step gate
 optimize_gate -packarea $output_dir/controller_gate.area
 legalize_phy_inst
 write_verilog $output_dir/controller_gate.v
 export_db $output_dir/controller_gate.db
} message]} {
 puts "CONTROLLER_BUILD_ERROR: $message"
 exit 1
}
puts "CONTROLLER_SYNTHESIS_ONLY_COMPLETE_NO_BIT"
close_project
exit
