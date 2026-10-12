import_device eagle_s20.db -package EG4S20BG256
foreach command {route place set_param export_chipwatcher optimize_setup fix_setup report_param} {
    puts "COMMAND_HELP $command"
    catch {help $command} message
    puts $message
}
puts "MATCHING_COMMANDS [lsort [concat [info commands *param*] [info commands *opt*] [info commands *route*]]]"
exit
