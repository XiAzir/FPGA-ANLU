# Query an offline configuration command's required arguments only.
puts "TCL_PROC [info procs add_watcher_node]"
if {[llength [info procs add_watcher_node]]} {
 puts "ARGS [info args add_watcher_node]"
 puts [info body add_watcher_node]
} else {
 if {[catch {add_watcher_node} message]} {puts "ARGUMENT_USAGE: $message"}
}
exit
