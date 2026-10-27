import_device eagle_s20.db -package EG4S20BG256
puts "QUERY_SIP_COMMANDS [info commands *sip*]"
puts "QUERY_ATTRIBUTE_COMMANDS [info commands *attr*]"
puts "QUERY_PROPERTY_COMMANDS [info commands *prop*]"
help set_param
help set_pin_assignment
help set_instance_assignment
help phys_opt
if {[catch {set_param gate pack_seq_in_io on} message]} {
  puts "PACK_ON_ERROR $message"
} else {
  puts "PACK_ON_ACCEPTED"
}
exit
