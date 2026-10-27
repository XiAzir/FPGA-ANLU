# Analysis only: zero external delays expose FPGA pin paths, not a card timing guarantee.
file mkdir {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output}
cd {E:/VSCODE-project/FPGA-ANLU/development/player_video40_spi25/src/td_project}
import_device eagle_s20.db -package EG4S20BG256
open_project AC201_tf_hdmi.al -single_run -noanalyze
load_run_param -run phy_1
import_db {E:/VSCODE-project/FPGA-ANLU/development/player_video40_spi25/build/manual/AC201_tf_hdmi_pr.db}
read_sdc {E:/VSCODE-project/FPGA-ANLU/development/player_video40_spi25/src/user_source/constraints_source/timing.sdc}
update_timing -mode final
puts "C40_CLOCK_OBJECT [get_clocks {sd_card_clk}]"
puts "C40_MISO_OBJECT [get_ports {sd_miso}]"
set_input_delay -clock {sd_card_clk} -max 0.0 [get_ports {sd_miso}]
set_input_delay -clock {sd_card_clk} -min 0.0 [get_ports {sd_miso}]
set_output_delay -clock {sd_card_clk} -max 0.0 [get_ports {sd_dclk}]
set_output_delay -clock {sd_card_clk} -min 0.0 [get_ports {sd_dclk}]
set_output_delay -clock {sd_card_clk} -max 0.0 [get_ports {sd_mosi}]
set_output_delay -clock {sd_card_clk} -min 0.0 [get_ports {sd_mosi}]
update_timing -mode final
report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output/rawio_timing_summary_v2.rpt}
report_timing_path -from [get_ports {sd_miso}] -ep_num 100 -path_num 1 -file {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output/rawio_from_sd_miso_v2.rpt}
report_timing_path -to [get_ports {sd_dclk}] -ep_num 1 -path_num 100 -file {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output/rawio_to_sd_dclk_v2.rpt}
report_timing_path -to [get_ports {sd_mosi}] -ep_num 1 -path_num 100 -file {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output/rawio_to_sd_mosi_v2.rpt}
puts "C40_RAW_IO_REPORTS_COMPLETE"
close_project
exit
