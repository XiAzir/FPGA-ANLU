import_device eagle_s20.db -package EG4S20BG256
set_param flow ooc_flow on
read_verilog -file "player_count_chipwatcher_watcherInst.sv"
optimize_rtl
map_macro
map
pack
report_area -file player_count_chipwatcher_gate.area
export_db -mode ooc "player_count_chipwatcher_ooc.db"
