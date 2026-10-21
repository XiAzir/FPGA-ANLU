# Standalone fat32_catalog AreaHigh baseline/candidate; min_ripple_len=18.
puts "AREA_BEGIN baseline"
cd {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/catalog_storage/td_area_high/baseline/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_00.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/catalog_storage/td_area_high/baseline/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/catalog_storage/td_area_high/baseline/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/catalog_storage/td_area_high/baseline/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR baseline: $message"; exit 1 }
puts "AREA_DONE baseline"
puts "AREA_BEGIN candidate"
cd {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/catalog_storage/td_area_high/candidate/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_01.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/catalog_storage/td_area_high/candidate/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/catalog_storage/td_area_high/candidate/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/arch17_work/catalog_storage/td_area_high/candidate/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR candidate: $message"; exit 1 }
puts "AREA_DONE candidate"
puts SYNTHESIS_COMPLETE
exit
