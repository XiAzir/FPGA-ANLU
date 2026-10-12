import_device eagle_s20.db -package EG4S20BG256
foreach command {phys_opt route export_chipwatcher} {
    puts "COMMAND_HELP $command"
    catch {$command -help} message
    puts $message
}
report_param -stage route -detail -file E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/build/route_params.txt
exit
