# C40 Raw SPI Path Review (draft only; do not run until routed PR DB exists)
# Purpose: extract FPGA path delays with zero external I/O delay as an analysis
# convention. This does not establish card/board timing compliance.

set review_dir [file normalize [file dirname [info script]]]
set repo_root [file normalize [file join $review_dir .. .. ..]]
set project_root [file join $repo_root development player_video40_spi25]
set project_dir [file join $project_root src td_project]
set source_db [file join $project_root build manual AC201_tf_hdmi_pr.db]
set analysis_dir [file join $review_dir c40_spi_raw_path_output]
set analysis_db [file join $analysis_dir AC201_tf_hdmi_pr_rawio.db]
set summary_file [file join $analysis_dir rawio_timing_summary.rpt]
set miso_report [file join $analysis_dir rawio_from_sd_miso.rpt]
set sck_report [file join $analysis_dir rawio_to_sd_dclk.rpt]
set mosi_report [file join $analysis_dir rawio_to_sd_mosi.rpt]

if {![file exists $source_db]} {
    error "Final routed DB not found: $source_db"
}
file mkdir $analysis_dir
cd $project_dir
import_device eagle_s20.db -package EG4S20BG256
open_project AC201_tf_hdmi.al -single_run -noanalyze
load_run_param -run phy_1
import_db $source_db
write_verilog [file join $project_root verification final_routed.v]

# Zero-delay test model: reports internal FPGA path delays from/to TF ports.
# These numbers intentionally omit card output delay and all PCB delays.
set_input_delay -clock [get_clocks {sd_card_clk}] -max 0.0 [get_ports {sd_miso}]
set_input_delay -clock [get_clocks {sd_card_clk}] -min 0.0 [get_ports {sd_miso}]
set_output_delay -clock [get_clocks {sd_card_clk}] -max 0.0 [get_ports {sd_dclk}]
set_output_delay -clock [get_clocks {sd_card_clk}] -min 0.0 [get_ports {sd_dclk}]
set_output_delay -clock [get_clocks {sd_card_clk}] -max 0.0 [get_ports {sd_mosi}]
set_output_delay -clock [get_clocks {sd_card_clk}] -min 0.0 [get_ports {sd_mosi}]

update_timing -mode final
report_timing_summary -file $summary_file
report_timing_path -from [get_ports {sd_miso}] -ep_num 100 -path_num 1 -file $miso_report
report_timing_path -to [get_ports {sd_dclk}] -ep_num 1 -path_num 100 -file $sck_report
report_timing_path -to [get_ports {sd_mosi}] -ep_num 1 -path_num 100 -file $mosi_report

# Save the timing-model variant under timing_review; never overwrite source_db.
export_db $analysis_db
close_project
exit
