cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/gate_smoke
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    import_db debugger_gate.db
    read_adc pin.adc
    read_sdc timing.sdc
    commit_param -step place
    place
    update_timing -mode manhattan
    report_timing_status -file place.ts
    report_timing_summary -file place.timing
    commit_param -step route
    route
    update_timing -mode final
    report_timing_status -file final.ts
    report_timing_summary -file final.timing
    report_timing_exception -file exception.timing
    check_timing -verbose -file check.timing
    report_area -io_info -file placed_routed.area
    export_db debugger_pr.db
} message]} {
    puts "GATE_SMOKE_PHY_ERROR: $message"
    exit 1
}
puts "GATE_SMOKE_PLACE_ROUTE_COMPLETE"
exit
