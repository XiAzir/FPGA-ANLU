source "C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/cw/atpl/templa.tcl"
set fd [open "C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/cw/atpl/cwc_ip.atpl" r]
set tmpl [read $fd]
close $fd
set parser [::tmpl_parser::tmpl_parser $tmpl]

set ComponentName        player_count_chipwatcher
set bus_num              2
set depth                1024
set ram_len              32
set input_pipe_num       0
set output_pipe_num      0
set capture_ctrl_exist   0
set trig_bus_num         1
set trig_bus_din_num     1
set trig_bus_ctrl_len    4
set trig_ctrl_len        24
set trig_bus_width       { 1 };
set trig_bus_din_pos     { 0 };
set trig_bus_ctrl_pos    { 0 };
set bus_size             {  32 1 }
set data_enable          { probe0 }
set trig_enable          { probe1 }
set fp [open "cw/player_count_chipwatcher/player_count_chipwatcher_watcherInst.sv" w+]
puts $fp [eval $parser]
close $fp
