set output_dir E:/VSCODE-project/FPGA-ANLU/development/player_fat32_autoplay/build/manual
cd E:/VSCODE-project/FPGA-ANLU/development/player_fat32_autoplay/src/td_project
import_device eagle_s20.db -package EG4S20BG256
open_project AC201_tf_hdmi.al -single_run -noanalyze
load_run_param -run phy_1
import_db $output_dir/AC201_tf_hdmi_pr.db
fix_hold -help
exit

