proc taskC11338FixHold {taskC11338ScriptPath} {
    set taskC11338Root [file normalize [file join [file dirname $taskC11338ScriptPath] ..]]
    set taskC11338ProjectDir [file join $taskC11338Root src td_project]
    cd $taskC11338ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video38_open_tx.al -single_run -noanalyze
        load_run_param -run phy_1
        import_db {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_pr.db}
        fix_hold
        update_timing -mode final
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_phy.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_pr.timing}
        check_timing -verbose -file {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_chk.timing}
        report_timing_exception -file {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_exception.timing}
        report_area -io_info -file {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_phy.area}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_pr.db}
    } taskC11338Error]} {
        puts "C11338_HOLD_FIX_ERROR: $taskC11338Error"
        catch {close_project}
        return -code error $taskC11338Error
    }
    puts "C11338_HOLD_FIX_COMPLETE"
    close_project
}
taskC11338FixHold [file normalize [info script]]


