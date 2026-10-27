proc taskC11338Bitgen {taskC11338ScriptPath} {
    set taskC11338Root [file normalize [file join [file dirname $taskC11338ScriptPath] ..]]
    set taskC11338ProjectDir [file join $taskC11338Root src td_project]
    cd $taskC11338ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        import_db [file join $taskC11338Root {build/manual/AC201_video38_open_tx_pr.db}]
        commit_param -step bitgen
        bitgen -bit [file join $taskC11338Root {build/manual/AC201_video38_open_tx.bit}]
    } taskC11338Error]} {
        puts "C11338_BITGEN_ERROR: $taskC11338Error"
        catch {close_project}
        return -code error $taskC11338Error
    }
    puts "C11338_BITSTREAM_GENERATED"
    close_project
}
taskC11338Bitgen [file normalize [info script]]


