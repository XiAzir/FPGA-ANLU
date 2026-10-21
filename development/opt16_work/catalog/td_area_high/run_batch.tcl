# One TD process; same standalone device and parameter recipe for each project.
puts "AREA_BEGIN baseline"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/baseline/td_project}
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
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/baseline/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/baseline/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/baseline/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/baseline/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR baseline: $message"; exit 1 }
puts "AREA_DONE baseline"
puts "AREA_BEGIN bps+rootent+fat16+version"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16+version/td_project}
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
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16+version/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16+version/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16+version/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16+version/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR bps+rootent+fat16+version: $message"; exit 1 }
puts "AREA_DONE bps+rootent+fat16+version"
puts "AREA_BEGIN bps"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_02.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR bps: $message"; exit 1 }
puts "AREA_DONE bps"
puts "AREA_BEGIN rootent"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_03.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR rootent: $message"; exit 1 }
puts "AREA_DONE rootent"
puts "AREA_BEGIN bps+rootent"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_04.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR bps+rootent: $message"; exit 1 }
puts "AREA_DONE bps+rootent"
puts "AREA_BEGIN fat16"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_05.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR fat16: $message"; exit 1 }
puts "AREA_DONE fat16"
puts "AREA_BEGIN bps+fat16"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_06.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR bps+fat16: $message"; exit 1 }
puts "AREA_DONE bps+fat16"
puts "AREA_BEGIN rootent+fat16"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_07.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR rootent+fat16: $message"; exit 1 }
puts "AREA_DONE rootent+fat16"
puts "AREA_BEGIN bps+rootent+fat16"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_08.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+fat16/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR bps+rootent+fat16: $message"; exit 1 }
puts "AREA_DONE bps+rootent+fat16"
puts "AREA_BEGIN version"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/version/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_09.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/version/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/version/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/version/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/version/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR version: $message"; exit 1 }
puts "AREA_DONE version"
puts "AREA_BEGIN bps+version"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+version/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_10.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+version/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+version/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+version/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+version/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR bps+version: $message"; exit 1 }
puts "AREA_DONE bps+version"
puts "AREA_BEGIN rootent+version"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+version/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_11.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+version/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+version/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+version/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+version/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR rootent+version: $message"; exit 1 }
puts "AREA_DONE rootent+version"
puts "AREA_BEGIN bps+rootent+version"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+version/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_12.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+version/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+version/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+version/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+rootent+version/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR bps+rootent+version: $message"; exit 1 }
puts "AREA_DONE bps+rootent+version"
puts "AREA_BEGIN fat16+version"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16+version/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_13.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16+version/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16+version/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16+version/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/fat16+version/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR fat16+version: $message"; exit 1 }
puts "AREA_DONE fat16+version"
puts "AREA_BEGIN bps+fat16+version"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16+version/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_14.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16+version/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16+version/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16+version/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/bps+fat16+version/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR bps+fat16+version: $message"; exit 1 }
puts "AREA_DONE bps+fat16+version"
puts "AREA_BEGIN rootent+fat16+version"
cd {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16+version/td_project}
if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  open_project catalog_15.al -single_run
  load_run_param -run syn_1
  set_param rtl min_ripple_len 18
  set_param gate mapper_lut_delay 1600
  set_param gate add_map_lut_struct high
  set_param gate map_mode area_prior
  set_param gate multi_thread_mapping partition
  set_param rtl resource_sharing auto
  set_param rtl shifter_style shifter_reg
  report_param -stage rtl -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16+version/reports/actualparams.rtl.log}
  report_param -stage gate -detail -all -file {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16+version/reports/actualparams.gate.log}
  elaborate -top fat32_catalog
  read_sdc ../mapper.sdc
  commit_param -step rtl
  optimize_rtl
  commit_param -step gate
  puts "AREA_OUTPUT={E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16+version/reports/gate.area}"
  optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/opt16_work/catalog/td_area_high/rootent+fat16+version/reports/gate.area}
  close_project
} message]} { puts "AREA_ERROR rootent+fat16+version: $message"; exit 1 }
puts "AREA_DONE rootent+fat16+version"
puts SYNTHESIS_COMPLETE
exit
