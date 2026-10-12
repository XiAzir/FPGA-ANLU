import_device eagle_s20.db -package EG4S20BG256
set_param flow ooc_flow on
read_verilog -dir "C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/ip/apm/apm_cwc" -global_include "debug_hub_define.v" -top top_debug_hub
optimize_rtl
map_macro
map
pack
report_area -file top_debug_hub_gate.area
export_db -mode ooc "top_debug_hub_ooc.db"
