proc taskC33Bitgen {taskC33ScriptPath} {
    set taskC33Root [file normalize [file join [file dirname $taskC33ScriptPath] ..]]
    set taskC33ProjectDir [file join $taskC33Root src td_project]
    cd $taskC33ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        import_db [file join $taskC33Root {build/manual/AC201_video33_1080p15_pr.db}]
        commit_param -step bitgen
        bitgen -bit [file join $taskC33Root {build/manual/AC201_video33_1080p15_diag.bit}]
    } taskC33Error]} {
        puts "C33_BITGEN_ERROR: $taskC33Error"
        catch {close_project}
        return -code error $taskC33Error
    }
    puts "C33_BITSTREAM_GENERATED"
    close_project
}
taskC33Bitgen [file normalize [info script]]
