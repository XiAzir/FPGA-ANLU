proc nativeClockProbeBRun {scriptPath} {
 set projectDir [file normalize [file join [file dirname $scriptPath] .. src td_project]]
 cd $projectDir
 if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project native_clock_serializer_probe_b.al -single_run
  load_run_param -run syn_1
  elaborate -top native_clock_serializer_probe_b
  read_adc ../user_source/pin.adc
  read_sdc ../user_source/timing.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b.area}
  legalize_phy_inst
  update_timing
  report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b.ts}
  report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b.timing}
  export_db {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_gate.db}
  load_run_param -run phy_1
  import_db {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_gate.db}
  set_param flow enable_seed off
  set_param place effort high
  set_param place opt_timing high
  set_param place crit_path_opt on
  set_param place post_place_opt high
  set_param place hfn_opt_effort high
  set_param route effort routability
  set_param gate pack_effort high
  commit_param -step place
  place
  update_timing -mode manhattan
  report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_place.ts}
  commit_param -step route
  route
  update_timing -mode final
  report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_phy.ts}
  report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_pr.timing}
  check_timing -verbose -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_chk.timing}
  report_timing_exception -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_exception.timing}
  report_area -io_info -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_phy.area}
  export_db {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/B/build/native_clock_serializer_probe_b_pr.db}
 } err]} { puts "NATIVE_CLOCK_SERIALIZER_B_ERROR: $err"; catch {close_project}; return -code error $err }
 puts NATIVE_CLOCK_SERIALIZER_PROBE_B_COMPLETE
 close_project
}
nativeClockProbeBRun [file normalize [info script]]


