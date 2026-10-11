cd E:/VSCODE-project/FPGA-ANLU/bringup/tf_hdmi/src/td_project
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
