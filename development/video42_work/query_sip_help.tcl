import_device eagle_s20.db -package EG4S20BG256
catch {set_sippin_assignment -help} message
puts "SIP_HELP_RESULT $message"
catch {set_pin_assignment -help} message
puts "PIN_HELP_RESULT $message"
catch {set_property -help} message
puts "PROPERTY_HELP_RESULT $message"
exit
