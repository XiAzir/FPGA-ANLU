onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
run 1 us
checkpoint cp_000001us.chk
puts "CHECKPOINT_SAVED absolute_us=1 file=cp_000001us.chk"
run 49999 us
checkpoint cp_050ms.chk
puts "CHECKPOINT_SAVED absolute_us=50000 file=cp_050ms.chk"
run 50 ms
checkpoint cp_100ms.chk
puts "CHECKPOINT_SAVED absolute_us=100000 file=cp_100ms.chk"
run 50 ms
checkpoint cp_150ms.chk
puts "CHECKPOINT_SAVED absolute_us=150000 file=cp_150ms.chk"
run 40 ms
checkpoint cp_190ms.chk
puts "CHECKPOINT_SAVED absolute_us=190000 file=cp_190ms.chk"
run 20 ms
checkpoint cp_210ms.chk
puts "CHECKPOINT_SAVED absolute_us=210000 file=cp_210ms.chk"
run -all
quit -code 0 -f
