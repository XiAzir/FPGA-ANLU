cd {E:/VSCODE-project/FPGA-ANLU/development/player_video40_spi25/src/td_project}
import_device eagle_s20.db -package EG4S20BG256
open_project AC201_tf_hdmi.al -single_run -noanalyze
load_run_param -run phy_1
import_db {E:/VSCODE-project/FPGA-ANLU/development/player_video40_spi25/build/manual/AC201_tf_hdmi_pr.db}
read_sdc {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/raw_io_analysis.sdc}
update_timing -mode final
report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output/rawio_timing_summary_v4.rpt}
report_timing_path -from sd_miso -ep_num 100 -path_num 1 -file {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output/rawio_from_sd_miso_v4.rpt}
report_timing_path -to sd_dclk -ep_num 1 -path_num 100 -file {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output/rawio_to_sd_dclk_v4.rpt}
report_timing_path -to sd_mosi -ep_num 1 -path_num 100 -file {E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/c40_spi_raw_path_output/rawio_to_sd_mosi_v4.rpt}
puts "C40_RAW_IO_SDC_REPORTS_COMPLETE"
close_project
exit
