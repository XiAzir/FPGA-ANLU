proc taskC11335RunSynthesis {taskC11335ScriptPath} {
    set taskC11335Root [file normalize [file join [file dirname $taskC11335ScriptPath] ..]]
    set taskC11335ProjectDir [file join $taskC11335Root src td_project]
    cd $taskC11335ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_C11335_640x480_60hz_33_165_bufg.al -single_run
        load_run_param -run syn_1
        elaborate -top top
        read_adc ../user_source/constraints_source/pin.adc
        read_sdc ../user_source/constraints_source/timing.sdc
        export_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_elaborate.db}
        commit_param -step rtl
        optimize_rtl
        export_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_rtl.db}
        commit_param -step gate
        optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_gate.area}
        legalize_phy_inst
        update_timing
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_gate.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_gate.timing}
        write_verilog {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_gate.v}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_gate.db}
    } taskC11335Error]} {
        puts "C11335_SYNTHESIS_ERROR: $taskC11335Error"
        catch {close_project}
        return -code error $taskC11335Error
    }
    puts "C11335_SYNTHESIS_COMPLETE"
    close_project
}
taskC11335RunSynthesis [file normalize [info script]]


