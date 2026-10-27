proc taskC11337RunSynthesis {taskC11337ScriptPath} {
    set taskC11337Root [file normalize [file join [file dirname $taskC11337ScriptPath] ..]]
    set taskC11337ProjectDir [file join $taskC11337Root src td_project]
    cd $taskC11337ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video37_open_tx.al -single_run
        load_run_param -run syn_1
        elaborate -top top
        read_adc ../user_source/constraints_source/pin.adc
        read_sdc ../user_source/constraints_source/timing.sdc
        export_db [file join $taskC11337Root {build/manual/AC201_video37_open_tx_elaborate.db}]
        commit_param -step rtl
        optimize_rtl
        export_db [file join $taskC11337Root {build/manual/AC201_video37_open_tx_rtl.db}]
        commit_param -step gate
        optimize_gate -packarea [file join $taskC11337Root {build/manual/AC201_video37_open_tx_gate.area}]
        legalize_phy_inst
        update_timing
        report_timing_status -file [file join $taskC11337Root {build/manual/AC201_video37_open_tx_gate.ts}]
        report_timing_summary -file [file join $taskC11337Root {build/manual/AC201_video37_open_tx_gate.timing}]
        write_verilog [file join $taskC11337Root {build/manual/AC201_video37_open_tx_gate.v}]
        export_db [file join $taskC11337Root {build/manual/AC201_video37_open_tx_gate.db}]
    } taskC11337Error]} {
        puts "C11337_SYNTHESIS_ERROR: $taskC11337Error"
        catch {close_project}
        return -code error $taskC11337Error
    }
    puts "C11337_SYNTHESIS_COMPLETE"
    close_project
}
taskC11337RunSynthesis [file normalize [info script]]


