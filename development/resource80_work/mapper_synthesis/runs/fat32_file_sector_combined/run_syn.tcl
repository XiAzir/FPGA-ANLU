set run_root [file normalize [file join [file dirname [info script]] .]]
set project_dir [file join $run_root td_project]
set report_dir [file join $run_root reports]
file mkdir $report_dir
set project_file fat32_file_sector_combined.al
cd $project_dir
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project $project_file -single_run
  load_run_param -run syn_1
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file E:/VSCODE-project/FPGA-ANLU/development/resource80_work/mapper_synthesis/runs/fat32_file_sector_combined/reports/actualparams.rtl.log
  report_param -stage gate -detail -all -file E:/VSCODE-project/FPGA-ANLU/development/resource80_work/mapper_synthesis/runs/fat32_file_sector_combined/reports/actualparams.gate.log
  elaborate -top fat32_file_sector
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT=E:/VSCODE-project/FPGA-ANLU/development/resource80_work/mapper_synthesis/runs/fat32_file_sector_combined/reports/gate.area"
  optimize_gate -packarea E:/VSCODE-project/FPGA-ANLU/development/resource80_work/mapper_synthesis/runs/fat32_file_sector_combined/reports/gate.area
} message]} { puts "BUILD_ERROR: $message"; exit 1 }
puts SYNTHESIS_COMPLETE
close_project
exit
