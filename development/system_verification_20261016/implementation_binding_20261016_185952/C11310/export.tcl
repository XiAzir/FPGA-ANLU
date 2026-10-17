cd {E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/implementation_binding_20261016_185952/C11310}
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 import_db {E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/implementation_binding_20261016_185952/C11310/AC201_tf_hdmi_pr.db}
 write_verilog {E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/implementation_binding_20261016_185952/C11310/routed.v}
} message]} {puts "EXPORT_ERROR: $message";exit 1}
puts "FINAL_IMPLEMENTATION_EXPORT_ONLY_COMPLETE"
exit
