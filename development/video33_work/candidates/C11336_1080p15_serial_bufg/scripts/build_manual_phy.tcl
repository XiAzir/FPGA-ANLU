proc taskC11336RunPhysical {taskC11336ScriptPath} {
    set taskC11336Root [file normalize [file join [file dirname $taskC11336ScriptPath] ..]]
    set taskC11336ProjectDir [file join $taskC11336Root src td_project]
    cd $taskC11336ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_C11336_1080p15_serial_bufg.al -single_run -noanalyze
        load_run_param -run phy_1
        import_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_gate.db}
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
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_place.ts}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_place.db}
        commit_param -step route
        route
        update_timing -mode final
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_phy.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_pr.timing}
        check_timing -verbose -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_chk.timing}
        report_timing_exception -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_exception.timing}
        report_area -io_info -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_phy.area}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_pr.db}
    } taskC11336Error]} {
        puts "C11336_PHYSICAL_ERROR: $taskC11336Error"
        catch {close_project}
        return -code error $taskC11336Error
    }
    puts "C11336_PHYSICAL_COMPLETE"
    close_project
}
taskC11336RunPhysical [file normalize [info script]]


