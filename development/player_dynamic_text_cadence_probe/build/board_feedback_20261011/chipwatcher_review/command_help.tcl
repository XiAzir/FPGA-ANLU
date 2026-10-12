# Offline command discovery only. No hardware/JTAG/program operations.
foreach pattern {*probe* *watch* *debug* *help*} {
    puts "AVAILABLE $pattern: [info commands $pattern]"
}
foreach cmd {compile_probe import_chipprobe_config insert_debugger setup_debugger} {
    puts "HELP_BEGIN $cmd"
    if {[catch {help $cmd} message]} {puts "HELP_UNAVAILABLE: $message"}
    puts "HELP_END $cmd"
}
exit
