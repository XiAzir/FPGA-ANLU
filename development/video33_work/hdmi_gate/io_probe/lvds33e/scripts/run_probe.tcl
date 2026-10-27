proc taskProbeRun_lvds33e {taskProbeScriptPath} {
    set taskProbeRoot [file normalize [file join [file dirname $taskProbeScriptPath] ..]]
    set taskProbeProjectDir [file join $taskProbeRoot src td_project]
    set taskProbeOutputDir [file join $taskProbeRoot build]
    file mkdir $taskProbeOutputDir
    cd $taskProbeProjectDir

    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project hdmi_io_probe_lvds33e.al -single_run
        load_run_param -run syn_1
        elaborate -top hdmi_io_probe
        read_adc ../user_source/pin.adc
        read_sdc ../user_source/timing.sdc
        commit_param -step rtl
        optimize_rtl
        commit_param -step gate
        optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/lvds33e/build/hdmi_io_probe_lvds33e.area}
        legalize_phy_inst
        update_timing
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/lvds33e/build/hdmi_io_probe_lvds33e.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/lvds33e/build/hdmi_io_probe_lvds33e.timing}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/lvds33e/build/hdmi_io_probe_lvds33e.db}
    } taskProbeError]} {
        puts "BUILD_ERROR: $taskProbeError"
        catch {close_project}
        return -code error $taskProbeError
    }
    puts "IO_PROBE_COMPLETE_lvds33e"
    close_project
}
taskProbeRun_lvds33e [file normalize [info script]]


