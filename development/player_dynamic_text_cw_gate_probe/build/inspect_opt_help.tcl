set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
import_device eagle_s20.db -package EG4S20BG256
foreach command {phys_opt route export_chipwatcher} {
    puts "COMMAND_HELP $command"
    catch {$command -help} message
    puts $message
}
report_param -stage route -detail -file ${fpga_project_root}/build/route_params.txt
exit
