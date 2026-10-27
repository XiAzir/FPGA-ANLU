proc nativeProbeRun {scriptPath} {
 set root [file normalize [file join [file dirname $scriptPath] ..]]
 set projectDir [file join $root src td_project]
 set outDir [file join $root build]
 file mkdir $outDir
 cd $projectDir
 if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project native_io_probe.al -single_run
  load_run_param -run syn_1
  elaborate -top native_io_probe
  read_adc ../user_source/pin.adc
  read_sdc ../user_source/timing.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/build/native_io_probe.area}
  legalize_phy_inst
  update_timing
  report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/build/native_io_probe.ts}
  report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/build/native_io_probe.timing}
  export_db {E:/VSCODE-project/FPGA-ANLU/development/video39_work/native_probe/build/native_io_probe.db}
 } err]} { puts "BUILD_ERROR: $err"; catch {close_project}; return -code error $err }
 puts NATIVE_IO_PROBE_COMPLETE
 close_project
}
nativeProbeRun [file normalize [info script]]
