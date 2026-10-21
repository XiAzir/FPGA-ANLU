puts "AREA_BEGIN baseline"
cd {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/scaler_lifetime/td_area_high/baseline/td_project}
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 open_project baseline.al -single_run
 load_run_param -run syn_1
 set_param gate add_map_lut_struct high
 set_param gate map_mode area_prior
 set_param gate multi_thread_mapping partition
 set_param rtl resource_sharing auto
 set_param rtl shifter_style shifter_reg
 set_param rtl min_ripple_len 18
 set_param gate mapper_lut_delay 1600
 report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/scaler_lifetime/td_area_high/baseline/reports/actualparams.rtl.log}
 report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/scaler_lifetime/td_area_high/baseline/reports/actualparams.gate.log}
 elaborate -top tf_bmp_file_player
 read_sdc ../standalone.sdc
 commit_param -step rtl
 optimize_rtl
 commit_param -step gate
 optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/scaler_lifetime/td_area_high/baseline/reports/gate.area}
 close_project
} message]} { puts "BUILD_ERROR: $message"; exit 1 }
puts "AREA_DONE baseline"
puts SYNTHESIS_COMPLETE
exit
