if {[info exists ::env(ANLU_TD_BIN)] && $::env(ANLU_TD_BIN) ne ""} {
    set anlu_td_bin [file normalize $::env(ANLU_TD_BIN)]
} else {
    set anlu_td_bin [file dirname [info nameofexecutable]]
}
import_device eagle_s20.db -package EG4S20BG256
set_param flow ooc_flow on
read_verilog -dir [file normalize [file join $anlu_td_bin ../ip/apm/apm_cwc]] -global_include "debug_hub_define.v" -top top_debug_hub
optimize_rtl
map_macro
map
pack
report_area -file top_debug_hub_gate.area
export_db -mode ooc "top_debug_hub_ooc.db"
