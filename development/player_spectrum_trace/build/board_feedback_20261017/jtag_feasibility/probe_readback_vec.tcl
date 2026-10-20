set here [file dirname [info script]]
cd $here
if {[catch {
 bit_to_vec -chip EG4S20BG256 -m jtag_rdbk -freq 5.000000 -bit E:/VSCODE-project/FPGA-ANLU/download/spectrum_trace.bit -vec $here/readback_original.vec
} message]} {
 puts "OFFLINE_READBACK_VEC_ERROR: $message"
 exit 1
}
puts "OFFLINE_READBACK_VEC_COMPLETE_NO_CABLE"
exit
