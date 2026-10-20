set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
import_device eagle_s20.db -package EG4S20BG256
foreach setting {{place effort ultra} {place opt_timing ultra} {place post_place_opt ultra} {route effort high} {route effort timing}} {
    puts "VALIDATE_SETTING $setting"
    if {[catch {set_param {*}$setting} message]} {puts "SETTING_REJECTED $message"} else {puts "SETTING_ACCEPTED $setting"}
}
report_param -stage place -detail -file ${fpga_project_root}/build/place_params.txt
exit
