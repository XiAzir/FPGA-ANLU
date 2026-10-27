proc taskC11339FixHold {taskC11339ScriptPath} {
    set taskC11339Root [file normalize [file join [file dirname $taskC11339ScriptPath] ..]]
    set taskC11339ProjectDir [file join $taskC11339Root src td_project]
    cd $taskC11339ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video39_native1080p30.al -single_run -noanalyze
        load_run_param -run phy_1
        import_db {E:/VSCODE-project/FPGA-ANLU/development/player_video39_native1080p30/build/manual/AC201_video39_native1080p30_pr.db}
        fix_hold
        update_timing -mode final
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/player_video39_native1080p30/build/manual/AC201_video39_native1080p30_phy.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/player_video39_native1080p30/build/manual/AC201_video39_native1080p30_pr.timing}
        check_timing -verbose -file {E:/VSCODE-project/FPGA-ANLU/development/player_video39_native1080p30/build/manual/AC201_video39_native1080p30_chk.timing}
        report_timing_exception -file {E:/VSCODE-project/FPGA-ANLU/development/player_video39_native1080p30/build/manual/AC201_video39_native1080p30_exception.timing}
        report_area -io_info -file {E:/VSCODE-project/FPGA-ANLU/development/player_video39_native1080p30/build/manual/AC201_video39_native1080p30_phy.area}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/player_video39_native1080p30/build/manual/AC201_video39_native1080p30_pr.db}
    } taskC11339Error]} {
        puts "C11339_HOLD_FIX_ERROR: $taskC11339Error"
        catch {close_project}
        return -code error $taskC11339Error
    }
    puts "C11339_HOLD_FIX_COMPLETE"
    close_project
}
taskC11339FixHold [file normalize [info script]]


