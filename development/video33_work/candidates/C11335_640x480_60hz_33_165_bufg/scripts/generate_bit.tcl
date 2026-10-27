proc taskC11335Bitgen {taskC11335ScriptPath} {
    set taskC11335Root [file normalize [file join [file dirname $taskC11335ScriptPath] ..]]
    set taskC11335ProjectDir [file join $taskC11335Root src td_project]
    cd $taskC11335ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        import_db {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg_pr.db}
        commit_param -step bitgen
        bitgen -bit {E:/VSCODE-project/FPGA-ANLU/development/video33_work/candidates/C11335_640x480_60hz_33_165_bufg/build/manual/AC201_C11335_640x480_60hz_33_165_bufg.bit}
    } taskC11335Error]} {
        puts "C11335_BITGEN_ERROR: $taskC11335Error"
        catch {close_project}
        return -code error $taskC11335Error
    }
    puts "C11335_BITSTREAM_GENERATED"
    close_project
}
taskC11335Bitgen [file normalize [info script]]


