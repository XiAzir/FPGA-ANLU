import_device eagle_s20.db -package EG4S20BG256
foreach setting {{place effort ultra} {place opt_timing ultra} {place post_place_opt ultra} {route effort high} {route effort timing}} {
    puts "VALIDATE_SETTING $setting"
    if {[catch {set_param {*}$setting} message]} {puts "SETTING_REJECTED $message"} else {puts "SETTING_ACCEPTED $setting"}
}
report_param -stage place -detail -file E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_gate_probe/build/place_params.txt
exit
