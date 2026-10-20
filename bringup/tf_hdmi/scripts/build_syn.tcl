# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
cd ${fpga_project_root}/src/td_project
if {[catch {
    open_project AC201_tf_hdmi.al
    launch_runs syn_1 -jobs 1
    wait_run syn_1
} message]} {
    puts "BUILD_ERROR: $message"
    exit 1
}
puts "SYNTHESIS_WAIT_FINISHED"
close_project
exit
