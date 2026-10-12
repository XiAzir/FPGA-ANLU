import_device eagle_s20.db -package EG4S20BG256
set_param flow ooc_flow on
read_verilog -file "cw_smoke_ip_watcherInst.sv"
optimize_rtl
map_macro
map
pack
report_area -file cw_smoke_ip_gate.area
export_db -mode ooc "cw_smoke_ip_ooc.db"
