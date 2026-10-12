source "C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/cw/atpl/templa.tcl"
set fd [open "C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/cw/atpl/cwc_ip.atpl" r]
set tmpl [read $fd]
close $fd
set parser [::tmpl_parser::tmpl_parser $tmpl]

set ComponentName        cw_smoke_ip
set bus_num              1
set depth                128
set ram_len              16
set input_pipe_num       0
set output_pipe_num      0
set capture_ctrl_exist   0
set trig_bus_num         1
set trig_bus_din_num     16
set trig_bus_ctrl_len    52
set trig_ctrl_len        72
set trig_bus_width       { 16 };
set trig_bus_din_pos     { 0 };
set trig_bus_ctrl_pos    { 0 };
set bus_size             {  16 }
set data_enable          { probe0 }
set trig_enable          { probe0 }
set fp [open "cw/cw_smoke_ip/cw_smoke_ip_watcherInst.sv" w+]
puts $fp [eval $parser]
close $fp
