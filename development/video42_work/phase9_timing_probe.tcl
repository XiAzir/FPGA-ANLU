# Analysis of the fixed initial routed database; no placement, routing or bitstream.
# Models a 9 ns forwarded clock and the explicitly delayed read capture edge.
set root [file normalize [file join [file dirname [info script]] .. ..]]
set work_dir [file dirname [file normalize [info script]]]
set project_dir $root/development/player_video42_sdram100/src/td_project
set output_dir $work_dir/phase9_timing_probe
file mkdir $output_dir
cd $project_dir
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project AC201_tf_hdmi.al -single_run -noanalyze
  load_run_param -run phy_1
  import_db $work_dir/initial_100mhz_4ns/build/AC201_tf_hdmi_pr.db
  create_clock -name ext_mem_clk_sft -period 10 -waveform {9 14} [get_pins {sys_pll_m0/pll_inst.clkc[2]}]
  set_multicycle_path 2 -setup -from [get_clocks ext_mem_clk_sft] -to [get_clocks ext_mem_clk]
  update_timing -mode final
  report_timing_status -file $output_dir/status.ts
  report_timing_summary -file $output_dir/timing.rpt
  report_timing_exception -file $output_dir/exceptions.rpt
} message]} {
  puts "PHASE9_ANALYSIS_ERROR $message"
  exit 1
}
puts "PHASE9_FIXED_ROUTE_ANALYSIS_COMPLETE"
close_project
exit
