set task_root [file normalize [file join [file dirname [info script]] ..]]
set project_dir $task_root/src/td_project
set output_dir $task_root/build
file mkdir $output_dir
cd $project_dir
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project spectrum_coeff_rom_probe.al -single_run
    load_run_param -run syn_1
    set_param -run syn_1 gate eram_init off
    elaborate -top top
    commit_param -step rtl
    optimize_rtl
    commit_param -step gate
    optimize_gate -packarea $output_dir/probe_gate.area
    write_verilog $output_dir/spectrum_coeff_rom_probe_gate.v
    export_db $output_dir/spectrum_coeff_rom_probe_gate.db
} message]} {
    puts "PROBE_BUILD_ERROR: $message"
    exit 1
}
puts "ROM_PROBE_SYNTHESIS_COMPLETE_ERAM_INIT_OFF"
close_project
exit
