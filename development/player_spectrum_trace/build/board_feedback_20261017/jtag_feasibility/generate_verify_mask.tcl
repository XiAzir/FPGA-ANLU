set here [file dirname [info script]]
file mkdir $here/reference_mask
cd $here/reference_mask
if {[catch {
 import_device eagle_s20.db -package EG4S20BG256
 import_db E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_trace/build/manual/AC201_tf_hdmi_pr.db
 bitgen -bit $here/reference_mask/spectrum_trace.bit -gen_mask
} message]} {
 puts "VERIFY_MASK_GENERATION_ERROR: $message"
 exit 1
}
puts "VERIFY_MASK_GENERATION_COMPLETE_SAME_ROUTED_DATABASE_NO_REPLACEMENT"
exit
