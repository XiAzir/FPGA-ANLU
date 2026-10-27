# SPI production candidate variant

This artifact is the minimal integration source requested by the root task. The previous experimental `spi_master.v` and `results.json` remain unchanged, including the optional ACK_WAIT ablation evidence.

`spi_master_production.v` retains only `FAST_DIV0` (default 0). With `FAST_DIV0=1` and `clk_div=0`, DCLK edges run on consecutive 50 MHz system clocks. The original `DCLK_IDLE` divider equality check applies uniformly. ACK always transitions to ACK_WAIT. Nonzero divider operation retains the original divider wait and was exercised at `clk_div=248`.

## Verification

`run_production.ps1` runs the production source and production TB copy. Icarus baseline/fast × tOD=0/7/14 ns: all six runs PASS. The BFM decodes MOSI from DCLK pin transitions, drives MISO after a selected delay from each falling SCK edge, and checks return bytes, handshake, CS passthrough, reset interruption, and divider 248. A captured MOSI bit-2 fault fails as expected in `run_production_negative_mosi_bit2.log`.

Fast div0 measured 20 ns per SCK half-period and 320 ns per full 8-bit byte; baseline div0 measured 40 ns and 640 ns. Divider 248 measured 5 us half-period and 80 us per byte. The 14 ns MISO delay leaves 6 ns to the modeled rising sample edge; this omits board/input propagation and setup requirements.

## Frozen files and hashes

`results_production.json` contains baseline, production source, testbench, and runner SHA256 values. `spi_master_production.diff` compares the production variant directly with the original source. Re-run, for example: `./run_production.ps1 -Mode fast -TodNs 14`.
