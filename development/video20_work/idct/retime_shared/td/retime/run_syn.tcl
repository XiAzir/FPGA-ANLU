set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
set output_dir [file join $run_root reports]
cd $project_dir
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project idct_y_area.al -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate max_dsp 29
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/retime_shared/td/retime/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/retime_shared/td/retime/reports/actualparams.gate.log}
  elaborate -top idct_y_area_top
  read_sdc ../idct_y_area.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/retime_shared/td/retime/reports/gate.area}
  legalize_phy_inst
  update_timing
  report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/retime_shared/td/retime/reports/timing.status}
  report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video20_work/idct/retime_shared/td/retime/reports/timing.summary}
} message]} { puts "BUILD_ERROR: $message"; exit 1 }
puts SYNTHESIS_COMPLETE
close_project
exit
