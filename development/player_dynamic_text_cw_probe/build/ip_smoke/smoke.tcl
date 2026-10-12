cd E:/VSCODE-project/FPGA-ANLU/development/player_dynamic_text_cw_probe/build/ip_smoke
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 read_verilog -file smoke.sv
 commit_param -step rtl
 insert_debugger .
 report_cwc_status
 optimize_rtl
 commit_param -step gate
 optimize_gate -packarea smoke.area
 export_db smoke_gate.db
 write_verilog smoke_gate.v
 export_chipwatcher smoke.cwc
} message]} {
 puts "IP_SMOKE_ERROR: $message"
 exit 1
}
puts "IP_SMOKE_GATE_COMPLETE"
exit
