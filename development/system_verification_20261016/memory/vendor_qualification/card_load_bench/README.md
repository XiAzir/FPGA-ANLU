# Packed SD card ModelSim load benchmark

This isolated diagnostic compiles only `sd_spi_card_model.v` and a 1 µs testbench. It reads `packed_mem.mem` and `lba_map.mem`, validates all 2,073 entries at time zero, then prints `TB_AFTER_1US` and finishes. The exact 10.1c run log is `novopt.log`; `vlog.log` records the isolated compile.

Command, from this folder:

```powershell
vlib work
vlog -modelsimini modelsim.ini -work work E:/VSCODE-project/FPGA-ANLU/development/system_verification_20261016/card/sd_spi_card_model.v tb_load_bench.v
vsim -c -novopt -modelsimini modelsim.ini -lib work tb_load_bench -do "run 1 us; quit -code 0 -f" -l novopt.log
```

Observed: ModelSim SE-64 10.1c returned exit 0 in about 6 seconds. Both `$readmemh` calls completed at t=0, the full map/data integrity scan completed before the 1 µs marker, and the test finished at 1 µs. Thus the packed memory itself is not a time-zero load blocker when optimization is disabled; the default optimized launch stalled before testbench progress in this environment.

The negative testbench `tb_missing_file.v` uses a nonexistent packed image. `missing_file.log` shows the simulator's open warning and the card model's explicit FATAL at 0 ps. ModelSim 10.1c reports `$finish` after `$fatal` and returns CLI exit 0, so unattended runs must inspect logs and require the intended PASS marker rather than relying only on process status.
