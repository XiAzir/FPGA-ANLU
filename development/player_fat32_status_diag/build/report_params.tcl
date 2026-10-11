import_device eagle_s20.db -package EG4S20BG256
open_project E:/VSCODE-project/FPGA-ANLU/development/player_fat32_status_diag/src/td_project/AC201_tf_hdmi.al -single_run -noanalyze
load_run_param -run phy_1
puts [non_default_params -allParams -run phy_1]
exit

