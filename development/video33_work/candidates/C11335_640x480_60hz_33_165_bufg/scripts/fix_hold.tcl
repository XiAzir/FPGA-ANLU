proc taskC11335FixHold {taskC11335ScriptPath} {
    set taskC11335Root [file normalize [file join [file dirname $taskC11335ScriptPath] ..]]
    set taskC11335ProjectDir [file join $taskC11335Root src td_project]
    cd $taskC11335ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_C11335_640x480_60hz_33_165_bufg.al -single_run -noanalyze
        load_run_param -run phy_1
        import_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_pr.db}
        fix_hold
        update_timing -mode final
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_phy.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_pr.timing}
        check_timing -verbose -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_chk.timing}
        report_timing_exception -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_exception.timing}
        report_area -io_info -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_phy.area}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_pr.db}
    } taskC11335Error]} {
        puts "C11335_HOLD_FIX_ERROR: $taskC11335Error"
        catch {close_project}
        return -code error $taskC11335Error
    }
    puts "C11335_HOLD_FIX_COMPLETE"
    close_project
}
taskC11335FixHold [file normalize [info script]]


