set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root project]
set report_dir [file join $run_root reports]
cd $project_dir
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_baseline_default.al -single_run
  load_run_param -run syn_1
  report_param -stage rtl -detail -all -file [file join $report_dir actualparams.rtl.log]
  report_param -stage gate -detail -all -file [file join $report_dir actualparams.gate.log]
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea [file join $report_dir gate.area]
} message]} { puts "BUILD_ERROR: $message"; exit 1 }
puts SYNTHESIS_COMPLETE
close_project
exit
