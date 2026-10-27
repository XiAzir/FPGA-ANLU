proc taskC11338RunSynthesis {taskC11338ScriptPath} {
    set taskC11338Root [file normalize [file join [file dirname $taskC11338ScriptPath] ..]]
    set taskC11338ProjectDir [file join $taskC11338Root src td_project]
    cd $taskC11338ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project AC201_video38_open_tx.al -single_run
        load_run_param -run syn_1
        elaborate -top top
        read_adc ../user_source/constraints_source/pin.adc
        read_sdc ../user_source/constraints_source/timing.sdc
        export_db {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_elaborate.db}
        commit_param -step rtl
        optimize_rtl
        export_db {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_rtl.db}
        commit_param -step gate
        optimize_gate -packarea {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_gate.area}
        legalize_phy_inst
        update_timing
        report_timing_status -file {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_gate.ts}
        report_timing_summary -file {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_gate.timing}
        write_verilog {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_gate.v}
        export_db {E:/VSCODE-project/FPGA-ANLU/development/player_video38_open_tx/build/manual/AC201_video38_open_tx_gate.db}
    } taskC11338Error]} {
        puts "C11338_SYNTHESIS_ERROR: $taskC11338Error"
        catch {close_project}
        return -code error $taskC11338Error
    }
    puts "C11338_SYNTHESIS_COMPLETE"
    close_project
}
taskC11338RunSynthesis [file normalize [info script]]


