proc taskC11339Bitgen {taskC11339ScriptPath} {
    set taskC11339Root [file normalize [file join [file dirname $taskC11339ScriptPath] ..]]
    set taskC11339ProjectDir [file join $taskC11339Root src td_project]
    cd $taskC11339ProjectDir
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        import_db [file join $taskC11339Root {build/manual/AC201_video39_native1080p30_pr.db}]
        commit_param -step bitgen
        bitgen -bit [file join $taskC11339Root {build/manual/AC201_video39_native1080p30.bit}]
    } taskC11339Error]} {
        puts "C11339_BITGEN_ERROR: $taskC11339Error"
        catch {close_project}
        return -code error $taskC11339Error
    }
    puts "C11339_BITSTREAM_GENERATED"
    close_project
}
taskC11339Bitgen [file normalize [info script]]


