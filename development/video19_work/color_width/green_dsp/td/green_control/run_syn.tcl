set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
cd $project_dir
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project jpeg_core.al -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate max_dsp 17
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/video19_work/color_width/green_dsp/td/green_control/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/video19_work/color_width/green_dsp/td/green_control/reports/actualparams.gate.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/video19_work/color_width/green_dsp/td/green_control/reports/actualparams.gate.after.log}
  elaborate -top jpeg_core
  read_sdc ../jpeg_core.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/video19_work/color_width/green_dsp/td/green_control/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/video19_work/color_width/green_dsp/td/green_control/reports/gate.area}
} message]} { puts "BUILD_ERROR: $message"; exit 1 }
puts SYNTHESIS_COMPLETE
close_project
exit
