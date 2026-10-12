set fpga_project_root [file normalize [file join [file dirname [info script]] ../..]]
set fpga_repo_root [file normalize [file join $fpga_project_root ../..]]
cd ${fpga_project_root}/build/ip_smoke
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 import_db smoke_gate.db
 read_adc pin.adc
 read_sdc timing.sdc
 commit_param -step place
 place
 commit_param -step route
 route
 update_timing -mode final
 report_timing_status -file smoke.ts
 export_db smoke_pr.db
 commit_param -step bitgen
 bitgen -bit smoke_offline_only.bit
 setup_debugger . -bit smoke_offline_only.bit
 report_cwc_status
 export_chipwatcher smoke_after_bit.cwc -add_bid
 export_chipwatcher smoke_sp.cwc -sp -add_bid
} message]} {
 puts "SMOKE_PHY_ERROR: $message"
 exit 1
}
puts "SMOKE_OFFLINE_BIT_COMPLETE"
exit
