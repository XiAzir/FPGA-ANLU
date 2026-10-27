proc taskC11338RunPhysical {taskC11338ScriptPath} {
    set taskC11338Root [file normalize [file join [file dirname $taskC11338ScriptPath] ..]]
    set taskC11338ProjectDir [file join $taskC11338Root src td_project]
    cd $taskC11338ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video38_open_tx.al -single_run -noanalyze
        load_run_param -run phy_1
        import_db [file join $taskC11338Root {build/manual/AC201_video38_open_tx_gate.db}]
        set_param flow enable_seed off
        set_param place effort high
        set_param place opt_timing high
        set_param place crit_path_opt on
        set_param place post_place_opt high
        set_param place hfn_opt_effort high
        set_param route effort routability
        set_param gate pack_effort high
        commit_param -step place
        place
        update_timing -mode manhattan
        report_timing_status -file [file join $taskC11338Root {build/manual/AC201_video38_open_tx_place.ts}]
        export_db [file join $taskC11338Root {build/manual/AC201_video38_open_tx_place.db}]
        commit_param -step route
        route
        update_timing -mode final
        report_timing_status -file [file join $taskC11338Root {build/manual/AC201_video38_open_tx_phy.ts}]
        report_timing_summary -file [file join $taskC11338Root {build/manual/AC201_video38_open_tx_pr.timing}]
        check_timing -verbose -file [file join $taskC11338Root {build/manual/AC201_video38_open_tx_chk.timing}]
        report_timing_exception -file [file join $taskC11338Root {build/manual/AC201_video38_open_tx_exception.timing}]
        report_area -io_info -file [file join $taskC11338Root {build/manual/AC201_video38_open_tx_phy.area}]
        export_db [file join $taskC11338Root {build/manual/AC201_video38_open_tx_pr.db}]
    } taskC11338Error]} {
        puts "C11338_PHYSICAL_ERROR: $taskC11338Error"
        catch {close_project}
        return -code error $taskC11338Error
    }
    puts "C11338_PHYSICAL_COMPLETE"
    close_project
}
taskC11338RunPhysical [file normalize [info script]]


