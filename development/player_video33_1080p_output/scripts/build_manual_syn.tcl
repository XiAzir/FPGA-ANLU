proc taskC33RunSynthesis {taskC33ScriptPath} {
    set taskC33Root [file normalize [file join [file dirname $taskC33ScriptPath] ..]]
    set taskC33ProjectDir [file join $taskC33Root src td_project]
    cd $taskC33ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video33_1080p15_diag.al -single_run
        load_run_param -run syn_1
        elaborate -top top
        read_adc ../user_source/constraints_source/pin.adc
        read_sdc ../user_source/constraints_source/timing.sdc
        export_db [file join $taskC33Root {build/manual/AC201_video33_1080p15_elaborate.db}]
        commit_param -step rtl
        optimize_rtl
        export_db [file join $taskC33Root {build/manual/AC201_video33_1080p15_rtl.db}]
        commit_param -step gate
        optimize_gate -packarea [file join $taskC33Root {build/manual/AC201_video33_1080p15_gate.area}]
        legalize_phy_inst
        update_timing
        report_timing_status -file [file join $taskC33Root {build/manual/AC201_video33_1080p15_gate.ts}]
        report_timing_summary -file [file join $taskC33Root {build/manual/AC201_video33_1080p15_gate.timing}]
        write_verilog [file join $taskC33Root {build/manual/AC201_video33_1080p15_gate.v}]
        export_db [file join $taskC33Root {build/manual/AC201_video33_1080p15_gate.db}]
    } taskC33Error]} {
        puts "C33_SYNTHESIS_ERROR: $taskC33Error"
        catch {close_project}
        return -code error $taskC33Error
    }
    puts "C33_SYNTHESIS_COMPLETE"
    close_project
}
taskC33RunSynthesis [file normalize [info script]]
