# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
set output_dir ${fpga_project_root}/build/manual
cd ${fpga_project_root}/src/td_project
import_device eagle_s20.db -package EG4S20BG256
open_project AC201_tf_hdmi.al -single_run -noanalyze
load_run_param -run phy_1
import_db $output_dir/AC201_tf_hdmi_pr.db
fix_hold -help
exit
