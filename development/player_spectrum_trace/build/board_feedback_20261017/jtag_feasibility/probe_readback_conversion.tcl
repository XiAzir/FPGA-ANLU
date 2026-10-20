set here [file dirname [info script]]
if {[catch {
 bit_to_vec -chip EG4S20BG256 -m jtag_rdbk -freq 5.000000 -bit E:/VSCODE-project/FPGA-ANLU/download/spectrum_trace.bit -svf $here/readback_original.svf
} message]} {
 puts "OFFLINE_READBACK_CONVERSION_ERROR: $message"
 exit 1
}
puts "OFFLINE_READBACK_CONVERSION_COMPLETE_NO_CABLE"
exit
