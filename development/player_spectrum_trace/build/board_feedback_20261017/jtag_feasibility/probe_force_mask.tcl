set here [file dirname [info script]]
cd $here
if {[catch {
 bit_to_vec -chip EG4S20BG256 -m jtag_rdbk -freq 5.000000 -force_dram_mask -bit $here/verify_input/spectrum_trace.bit
} message]} {
 puts "OFFLINE_FORCE_MASK_ERROR: $message"
 exit 1
}
puts "OFFLINE_FORCE_MASK_COMPLETE_NO_CABLE"
exit
