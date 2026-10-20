set here [file dirname [info script]]
cd $here
if {[catch {
 bit_to_vec -chip EG4S20BG256 -m jtag_rdbk -freq 5.000000 -bit $here/verify_input/spectrum_trace.bit -bas $here/verify_input/spectrum_trace.bmk
} message]} {
 puts "OFFLINE_MASK_ARGUMENT_ERROR: $message"
 exit 1
}
puts "OFFLINE_MASK_ARGUMENT_COMPLETE_NO_CABLE"
exit
