set variant_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $variant_root td_project]
set area_file [file join $variant_root reports gate.area]
cd $project_dir
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_catalog_narrow_cluster.al -single_run
  load_run_param -run syn_1
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea $area_file
} message]} { puts "BUILD_ERROR: $message"; exit 1 }
puts SYNTHESIS_COMPLETE
close_project
exit
