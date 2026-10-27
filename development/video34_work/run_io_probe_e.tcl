if {[catch {source {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/lvds33e/scripts/run_probe.tcl}} message]} {
    puts "ROOT_IO_PROBE_FAILED: $message"
    exit 1
}
exit 0
