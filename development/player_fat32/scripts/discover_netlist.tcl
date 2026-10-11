puts "VERILOG_COMMANDS=[lsort [info commands *ver*]]"
puts "EXPORT_COMMANDS=[lsort [info commands *export*]]"
puts "HELP_COMMANDS=[lsort [info commands *help*]]"
catch {help export_verilog}
catch {help export_netlist}
exit

