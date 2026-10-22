import_device eagle_s20.db -package EG4S20BG256
open_project address_top.al -single_run
load_run_param -run syn_1
set_param gate add_map_lut_struct high
set_param gate map_mode area_prior
set_param rtl min_ripple_len 18
set_param gate mapper_lut_delay 1600
elaborate -top address_top
create_clock -name clk -period 20 [get_ports clk]
commit_param -step rtl
optimize_rtl
commit_param -step gate
optimize_gate -packarea area.rpt
close_project
exit
