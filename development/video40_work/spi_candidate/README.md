# SPI master 25 MHz candidate

## Scope and implementation

Baseline: `development/player_video32_read_return/src/user_source/hdl_source/SD/spi_master.v`. Candidate source is isolated in this directory. `FAST_DIV0` defaults to 0 for the original behavior; when enabled and `clk_div==0`, the FSM emits one DCLK edge each 50 MHz `sys_clk`, skips `DCLK_IDLE` between edges, and enters ACK directly after edge 16. For nonzero dividers, the original wait behavior remains. `FAST_ACK_WAIT_BYPASS` is a separate default-off compile-time ablation. It bypasses `ACK_WAIT` only for enabled fast div0.

## Verification

Icarus Verilog from `bringup/tf_wav_hdmi/tools/iverilog/app/bin`, six baseline/fast runs at MISO output delays 0/7/14 ns, all PASS. Each run checks pin-decoded MOSI bytes, MISO return bytes, 5 fixed patterns, 8 `$random` bytes, ACK handshake, CS passthrough, divider 248, and mid-byte asynchronous reset. The delayed MISO BFM changes its value from each falling DCLK edge after the selected `tOD`, then the master captures at the following rising edge. Source logs are `run_{baseline|fast}_tod{0|7|14}_keep_inject-1.log`.

The single-bit MOSI negative control flips captured bit 2 and fails as expected with `PIN MOSI mismatch`; see `run_negative_mosi_bit2.log`.

## Pin timing and throughput

At 50 MHz sys_clk, candidate fast div0 measured 20 ns between each DCLK transition (25 MHz SCK), 300 ns from first to 16th edge and 320 ns per complete 8-clock byte. Original div0 measured 40 ns per transition (12.5 MHz SCK), 600 ns edge span and 640 ns full byte. Divider 248 remains 5 us half-period/100 kHz and 80 us per byte. With the current sequential consumer BFM, fast div0 ACK-to-next-first-edge gap is 100 ns. `FAST_ACK_WAIT_BYPASS=1` passed the same regression and reduced that gap to 80 ns; the normal/default candidate keeps the wait.

At 14 ns modeled card output delay, fast div0 retains 6 ns until the next rising sample edge. This leaves out FPGA input delay, card/board propagation, setup requirements, routing, and timing constraints. It is a digital stimulus result only; root must evaluate the real TF path and timing budget before integration.

## Frozen source hashes

See `results.json` for baseline and candidate SHA256. `spi_master.diff` is the direct baseline-to-candidate diff. Re-run with `./run.ps1 -Mode fast -TodNs 14` or `-Mode baseline`; add `-BypassAckWait` for the optional ablation.
