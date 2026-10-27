proc taskC11339RunSynthesis {taskC11339ScriptPath} {
    set taskC11339Root [file normalize [file join [file dirname $taskC11339ScriptPath] ..]]
    set taskC11339ProjectDir [file join $taskC11339Root src td_project]
    cd $taskC11339ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video39_native1080p30.al -single_run
        load_run_param -run syn_1
        elaborate -top top
        read_adc ../user_source/constraints_source/pin.adc
        read_sdc ../user_source/constraints_source/timing.sdc
        export_db [file join $taskC11339Root {build/manual/AC201_video39_native1080p30_elaborate.db}]
        commit_param -step rtl
        optimize_rtl
        export_db [file join $taskC11339Root {build/manual/AC201_video39_native1080p30_rtl.db}]
        commit_param -step gate
        optimize_gate -packarea [file join $taskC11339Root {build/manual/AC201_video39_native1080p30_gate.area}]
        legalize_phy_inst
        update_timing
        report_timing_status -file [file join $taskC11339Root {build/manual/AC201_video39_native1080p30_gate.ts}]
        report_timing_summary -file [file join $taskC11339Root {build/manual/AC201_video39_native1080p30_gate.timing}]
        write_verilog [file join $taskC11339Root {build/manual/AC201_video39_native1080p30_gate.v}]
        export_db [file join $taskC11339Root {build/manual/AC201_video39_native1080p30_gate.db}]
    } taskC11339Error]} {
        puts "C11339_SYNTHESIS_ERROR: $taskC11339Error"
        catch {close_project}
        return -code error $taskC11339Error
    }
    puts "C11339_SYNTHESIS_COMPLETE"
    close_project
}
taskC11339RunSynthesis [file normalize [info script]]


