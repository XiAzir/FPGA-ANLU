proc run_synth_map {scriptPath} {
    set root [file normalize [file join [file dirname $scriptPath] ..]]
    set projectDir [file join $root src td_project]
    set outputDir [file join $root build manual]
    cd $projectDir
    set projectName [file rootname [file tail [glob *.al]]]
    set gatePath [file join $outputDir "${projectName}_gate.v"]
    set areaPath [file join $outputDir "${projectName}_gate.area"]
    set statusPath [file join $outputDir "${projectName}_gate.ts"]
    set timingPath [file join $outputDir "${projectName}_gate.timing"]
    if {[catch {
        import_device eagle_s20.db -package EG4S20BG256
        open_project "${projectName}.al" -single_run
        load_run_param -run syn_1
        elaborate -top top
        read_adc ../user_source/constraints_source/pin.adc
        read_sdc ../user_source/constraints_source/timing.sdc
        commit_param -step rtl
        optimize_rtl
        commit_param -step gate
        optimize_gate -packarea $areaPath
        legalize_phy_inst
        update_timing
        report_timing_status -file $statusPath
        report_timing_summary -file $timingPath
        write_verilog $gatePath
    } err]} {
        puts "SYN_MAP_ERROR: $err"
        catch {close_project}
        return -code error $err
    }
    puts "SYN_MAP_COMPLETE gate=$gatePath area=$areaPath"
    close_project
}
run_synth_map [file normalize [info script]]