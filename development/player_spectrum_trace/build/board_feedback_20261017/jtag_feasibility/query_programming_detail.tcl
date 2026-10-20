foreach command {download bit_to_vec program bitgen} {
 puts "QUERY_$command"
 catch {$command -help} result
 puts $result
}
exit
