proc taskC33FixHold {taskC33ScriptPath} {
    set taskC33Root [file normalize [file join [file dirname $taskC33ScriptPath] ..]]
    set taskC33ProjectDir [file join $taskC33Root src td_project]
    cd $taskC33ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video33_1080p15_diag.al -single_run -noanalyze
        load_run_param -run phy_1
        import_db {E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_pr.db}
        fix_hold
        update_timing -mode final
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_phy.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_pr.timing}
        check_timing -verbose -file {E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_chk.timing}
        report_timing_exception -file {E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_exception.timing}
        report_area -io_info -file {E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_phy.area}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/player_video33_1080p_output/build/manual/AC201_video33_1080p15_pr.db}
    } taskC33Error]} {
        puts "C33_HOLD_FIX_ERROR: $taskC33Error"
        catch {close_project}
        return -code error $taskC33Error
    }
    puts "C33_HOLD_FIX_COMPLETE"
    close_project
}
taskC33FixHold [file normalize [info script]]
