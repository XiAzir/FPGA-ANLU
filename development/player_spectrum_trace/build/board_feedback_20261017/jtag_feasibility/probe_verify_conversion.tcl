set here [file dirname [info script]]
if {[catch {
 bit_to_vec -chip EG4S20BG256 -m verify -freq 5.000000 -bit E:/VSCODE-project/FPGA-ANLU/download/spectrum_trace.bit -svf $here/verify_original.svf
} message]} {
 puts "OFFLINE_VERIFY_CONVERSION_ERROR: $message"
 exit 1
}
puts "OFFLINE_VERIFY_CONVERSION_COMPLETE_NO_CABLE"
exit
