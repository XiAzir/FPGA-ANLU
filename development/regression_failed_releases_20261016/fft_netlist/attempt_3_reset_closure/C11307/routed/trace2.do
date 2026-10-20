onerror {quit -code 2 -f}
proc snap {} {
 global now
 echo "SNAPSHOT $now"
 foreach pattern {*sample_count* *state_reg_syn_1* *sample_write_en* *tone_prev* *S_sync_reset_1d*} {
  foreach sig [find signals -recursive /tb_fft_cone/dut/$pattern] {
   if {![catch {examine -radix hex $sig} value]} {echo "$sig = $value"}
  }
 }
}
run 1200 ns
snap
run 41000 ns
snap
run 100000 ns
snap
quit -code 0 -f
