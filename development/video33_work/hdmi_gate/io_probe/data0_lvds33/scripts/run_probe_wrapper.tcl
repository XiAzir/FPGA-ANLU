if {[catch {source {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/data0_lvds33/scripts/run_probe.tcl}} taskProbeRootError]} {
    puts "IO_PROBE_WRAPPER_ERROR: $taskProbeRootError"
    exit 1
}
exit 0
