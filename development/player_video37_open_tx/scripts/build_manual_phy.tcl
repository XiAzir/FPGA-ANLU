proc taskC11337RunPhysical {taskC11337ScriptPath} {
    set taskC11337Root [file normalize [file join [file dirname $taskC11337ScriptPath] ..]]
    set taskC11337ProjectDir [file join $taskC11337Root src td_project]
    cd $taskC11337ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video37_open_tx.al -single_run -noanalyze
        load_run_param -run phy_1
        import_db {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_gate.db}
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
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_place.ts}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_place.db}
        commit_param -step route
        route
        update_timing -mode final
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_phy.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_pr.timing}
        check_timing -verbose -file {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_chk.timing}
        report_timing_exception -file {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_exception.timing}
        report_area -io_info -file {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_phy.area}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/player_video37_open_tx/build/manual/AC201_video37_open_tx_pr.db}
    } taskC11337Error]} {
        puts "C11337_PHYSICAL_ERROR: $taskC11337Error"
        catch {close_project}
        return -code error $taskC11337Error
    }
    puts "C11337_PHYSICAL_COMPLETE"
    close_project
}
taskC11337RunPhysical [file normalize [info script]]


