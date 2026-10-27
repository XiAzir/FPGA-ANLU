proc taskC11337Bitgen {taskC11337ScriptPath} {
    set taskC11337Root [file normalize [file join [file dirname $taskC11337ScriptPath] ..]]
    set taskC11337ProjectDir [file join $taskC11337Root src td_project]
    cd $taskC11337ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        import_db [file join $taskC11337Root {build/manual/AC201_video37_open_tx_pr.db}]
        commit_param -step bitgen
        bitgen -bit [file join $taskC11337Root {build/manual/AC201_video37_open_tx.bit}]
    } taskC11337Error]} {
        puts "C11337_BITGEN_ERROR: $taskC11337Error"
        catch {close_project}
        return -code error $taskC11337Error
    }
    puts "C11337_BITSTREAM_GENERATED"
    close_project
}
taskC11337Bitgen [file normalize [info script]]


