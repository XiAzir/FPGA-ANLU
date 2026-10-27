proc parserProbeRun {scriptPath} {
 set pdir [file dirname $scriptPath]
 cd $pdir
 if {[catch {
  import_device eagle_s20.db -package EG4S20BG256
  read_hdl -file ./top.v -top lvds_property_parser_probe
  read_adc ./pin.adc
 } err]} { puts "ADC_PARSER_PROBE_ERROR: $err"; exit 2 }
 puts ADC_PARSER_PROBE_ACCEPTED
 exit 0
}
parserProbeRun [file normalize [info script]]
