if {[catch {source {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/lvds33e/scripts/run_probe.tcl}} taskProbeRootError]} {
    puts "IO_PROBE_WRAPPER_ERROR: $taskProbeRootError"
    exit 1
}
exit 0
