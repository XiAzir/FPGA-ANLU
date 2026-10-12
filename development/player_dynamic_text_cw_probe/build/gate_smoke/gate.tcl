cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/gate_smoke
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    read_verilog -file counter.sv
    commit_param -step rtl
    optimize_rtl
    commit_param -step gate
    optimize_gate -packarea gate_smoke.area
    report_cwc_status
    insert_debugger chip_debugger -cwc chip_debugger/user.cfg
    report_cwc_status
    export_db debugger_gate.db
    write_verilog debugger_gate.v
    export_chipwatcher debugger_gate.cwc
} message]} {
    puts "GATE_SMOKE_ERROR: $message"
    exit 1
}
puts "GATE_SMOKE_GATE_COMPLETE"
exit


