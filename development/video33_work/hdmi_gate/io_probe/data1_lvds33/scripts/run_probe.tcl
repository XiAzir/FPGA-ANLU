proc taskProbeRun_data1_lvds33 {taskProbeScriptPath} {
    set taskProbeRoot [file normalize [file join [file dirname $taskProbeScriptPath] ..]]
    set taskProbeProjectDir [file join $taskProbeRoot src td_project]
    cd $taskProbeProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project hdmi_io_probe_data1_lvds33.al -single_run
        load_run_param -run syn_1
        elaborate -top hdmi_io_probe
        read_adc ../user_source/pin.adc
        read_sdc ../user_source/timing.sdc
        commit_param -step rtl
        optimize_rtl
        commit_param -step gate
        optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/data1_lvds33/build/hdmi_io_probe_data1_lvds33.area}
        legalize_phy_inst
        update_timing
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/data1_lvds33/build/hdmi_io_probe_data1_lvds33.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/data1_lvds33/build/hdmi_io_probe_data1_lvds33.timing}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/hdmi_gate/io_probe/data1_lvds33/build/hdmi_io_probe_data1_lvds33.db}
    } taskProbeError]} {
        puts "BUILD_ERROR: $taskProbeError"
        catch {close_project}
        return -code error $taskProbeError
    }
    puts "IO_PROBE_COMPLETE_data1_lvds33"
    close_project
}
taskProbeRun_data1_lvds33 [file normalize [info script]]
