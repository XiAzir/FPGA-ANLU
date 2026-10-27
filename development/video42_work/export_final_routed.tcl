set root [file normalize [file join [file dirname [info script]] .. ..]]
set project $root/development/player_video42_sdram100
cd $project/src/td_project
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  import_db $project/build/manual/AC201_tf_hdmi_pr.db
  write_verilog $project/verification/final_routed.v -implement
  report_qor -step route -file $project/verification/final_route.qor
} message]} {
  puts "C42_EXPORT_FAILED $message"
  exit 1
}
puts "C42_FINAL_ROUTED_EXPORTED"
exit
