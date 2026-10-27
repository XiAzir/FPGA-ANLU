proc taskC11336Bitgen {taskC11336ScriptPath} {
    set taskC11336Root [file normalize [file join [file dirname $taskC11336ScriptPath] ..]]
    set taskC11336ProjectDir [file join $taskC11336Root src td_project]
    cd $taskC11336ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        import_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg_pr.db}
        commit_param -step bitgen
        bitgen -bit {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11336_1080p15_serial_bufg/build/manual/AC201_C11336_1080p15_serial_bufg.bit}
    } taskC11336Error]} {
        puts "C11336_BITGEN_ERROR: $taskC11336Error"
        catch {close_project}
        return -code error $taskC11336Error
    }
    puts "C11336_BITSTREAM_GENERATED"
    close_project
}
taskC11336Bitgen [file normalize [info script]]


