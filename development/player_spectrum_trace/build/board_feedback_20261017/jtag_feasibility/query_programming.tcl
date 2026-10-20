foreach command {download bit_to_vec program bitgen} {
 puts "QUERY_HELP_$command"
 catch {help $command} result
 puts $result
}
exit
