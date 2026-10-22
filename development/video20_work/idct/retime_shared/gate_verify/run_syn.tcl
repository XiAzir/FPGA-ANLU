set root [file normalize [file join [file dirname [info script]]]]
set project_dir [file join $root td_project]
set output_dir [file join $root reports]
file mkdir $output_dir
cd $project_dir
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project idct_y_gate.al -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate max_dsp 29
  elaborate -top idct_y_area_top
  read_sdc ../idct_y_area.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea $output_dir/gate.area
  legalize_phy_inst
  update_timing
  report_timing_summary -file $output_dir/timing.summary
  write_verilog $output_dir/idct_y_gate.v
  export_db $output_dir/idct_y_gate.db
} message]} { puts "BUILD_ERROR: $message"; exit 1 }
puts SYNTHESIS_COMPLETE
close_project
exit
