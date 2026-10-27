cd {E:/VSCODE-project/FPGA-ANLU/development/player_video41_refresh/src/td_project}
import_device eagle_s20.db -package EG4S20BG256
open_project AC201_tf_hdmi.al -single_run -noanalyze
load_run_param -run phy_1
import_db {E:/VSCODE-project/FPGA-ANLU/development/player_video41_refresh/build/manual/AC201_tf_hdmi_pr.db}
read_sdc {E:/VSCODE-project/FPGA-ANLU/development/video41_work/raw_io_pressure.sdc}
update_timing -mode final
report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video41_work/raw_io_report.rpt}
puts "C41_RAW_IO_ANALYSIS_COMPLETE"
close_project
exit
