set here [file dirname [info script]]
cd $here
if {[catch {
 bit_to_vec -chip EG4S20BG256 -m jtag_rdbk -freq 5.000000 -v -bit $here/verify_input/spectrum_trace.bit
} message]} {
 puts "OFFLINE_VERIFY_FLAG_ERROR: $message"
 exit 1
}
puts "OFFLINE_VERIFY_FLAG_COMPLETE_NO_CABLE"
exit
