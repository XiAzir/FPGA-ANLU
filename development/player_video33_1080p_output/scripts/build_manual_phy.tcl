proc taskC33RunPhysical {taskC33ScriptPath} {
    set taskC33Root [file normalize [file join [file dirname $taskC33ScriptPath] ..]]
    set taskC33ProjectDir [file join $taskC33Root src td_project]
    cd $taskC33ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video33_1080p15_diag.al -single_run -noanalyze
        load_run_param -run phy_1
        import_db [file join $taskC33Root {build/manual/AC201_video33_1080p15_gate.db}]
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
        report_timing_status -file [file join $taskC33Root {build/manual/AC201_video33_1080p15_place.ts}]
        export_db [file join $taskC33Root {build/manual/AC201_video33_1080p15_place.db}]
        commit_param -step route
        route
        update_timing -mode final
        report_timing_status -file [file join $taskC33Root {build/manual/AC201_video33_1080p15_phy.ts}]
        report_timing_summary -file [file join $taskC33Root {build/manual/AC201_video33_1080p15_pr.timing}]
        check_timing -verbose -file [file join $taskC33Root {build/manual/AC201_video33_1080p15_chk.timing}]
        report_timing_exception -file [file join $taskC33Root {build/manual/AC201_video33_1080p15_exception.timing}]
        report_area -io_info -file [file join $taskC33Root {build/manual/AC201_video33_1080p15_phy.area}]
        export_db [file join $taskC33Root {build/manual/AC201_video33_1080p15_pr.db}]
    } taskC33Error]} {
        puts "C33_PHYSICAL_ERROR: $taskC33Error"
        catch {close_project}
        return -code error $taskC33Error
    }
    puts "C33_PHYSICAL_COMPLETE"
    close_project
}
taskC33RunPhysical [file normalize [info script]]
