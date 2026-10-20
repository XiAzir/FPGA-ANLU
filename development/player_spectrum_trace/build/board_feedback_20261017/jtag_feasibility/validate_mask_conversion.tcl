set here [file dirname [info script]]
cd $here
if {[catch {
 bit_to_vec -chip EG4S20BG256 -m jtag_rdbk -freq 5.000000 -bit $here/verify_input/spectrum_trace.bit -vec $here/verify_input/verify_masked.vec
} message]} {
 puts "OFFLINE_MASKED_VERIFY_CONVERSION_ERROR: $message"
 exit 1
}
puts "OFFLINE_MASKED_VERIFY_CONVERSION_COMPLETE_NO_CABLE"
exit
