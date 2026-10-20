set task_root [file normalize [file dirname [info script]]]
set project_dir $task_root/project
set output_dir $task_root/reports
file mkdir $output_dir
cd $project_dir
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 open_project rom_probe.al -single_run
 load_run_param -run syn_1
 set_param -run syn_1 gate eram_init on
 elaborate -top top
 export_db $output_dir/rom_probe_elaborate.db
 commit_param -step rtl
 optimize_rtl
 export_db $output_dir/rom_probe_rtl.db
 commit_param -step gate
 optimize_gate -packarea $output_dir/rom_probe_gate.area
 write_verilog $output_dir/rom_probe_gate.v
 export_db $output_dir/rom_probe_gate.db
} message]} {puts "PROBE_ERROR: $message"; exit 1}
puts "ROM_PROBE_SYNTHESIS_COMPLETE"
close_project
exit
