set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
cd $project_dir
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project idct_area.al -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate max_dsp 17
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/td_isolated/y_candidate/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/td_isolated/y_candidate/reports/actualparams.gate.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/td_isolated/y_candidate/reports/actualparams.gate.after.log}
  elaborate -top jpeg_idct_y
  read_sdc ../idct_area.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/td_isolated/y_candidate/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/td_isolated/y_candidate/reports/gate.area}
} message]} { puts "BUILD_ERROR: $message"; exit 1 }
puts SYNTHESIS_COMPLETE
close_project
exit
