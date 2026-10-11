# FAT mapper Brent counter width experiment

This is an isolated simulation-only candidate. It does not change any source under `compact/src`, does not modify TD databases or bitstreams, and is not an EOC bug fix. The only functional-source change is the declared width of Brent `power/length` and their cached copies. Module names are suffixed `_original` / `_narrow` only so both copies can be elaborated side by side in one Icarus simulation.

## Files

- `fat32_file_sector_original.v`: copy of `player_dynamic_text_compact/src/user_source/hdl_source/fat32_file_sector.v`; top module renamed for differential testing.
- `fat32_file_sector_narrow.v`: same copied implementation; module name renamed and Brent declarations narrowed to 14-bit power, 13-bit length, 32-bit anchors. `walk_count`, limits, FAT algorithm, errors, ports and handshakes are unchanged.
- `tb_fat32_file_sector_existing.v`: copied existing mapper test with only test/module instance names adapted. This keeps the existing 3-cycle byte-gap 512-byte sector model and its SPC1/8/64, cache, backward seek, errors and timeout coverage.
- `tb_fat32_file_sector_narrow_existing.v`: same existing model run against the narrowed mapper, with only its test module/instance names changed.
- `tb_mapper_width_equiv.v`: new original-vs-narrow pairwise TB. It compares all output interfaces every clock and compares the numeric Brent anchor/power/length state as passive observations; the model drives only external ports.
- `run_mapper_width_experiment.ps1`: reproducible Icarus compile/run entry point. Compile and runtime outputs are preserved beside the sources.

## Width bound

The mapper rejects `clusters_needed > 4096` before walking. With sectors-per-cluster shift 0, the largest accepted file therefore has 4096 sectors/clusters, indexed 0 through 4095. Reaching legal target sector 4095 from index 0 requires 4095 successful FAT advances. The `walk_count >= 4096` check remains unchanged as the defensive traversal cap; the TB does not force internal registers or bypass the size/range checks to make it fire.

Brent starts with power 1 and doubles only when its current window is exhausted. Through at most 4095 accepted advances, reachable power is at most 4096; 14 bits are intentionally conservative and can also represent 8192, but this experiment does **not** claim to reach or verify 8192. `brent_length` and its cache are 13 bits to preserve the `length + 1` boundary value 4096 without truncation. The 32-bit anchor remains required for the FAT cluster identifier. Thus the four power/length registers shrink from 128 to 54 bits, a theoretical reduction of 74 register bits before synthesis mapping.

## Validation

Run from the compact project directory:

```powershell
pwsh -NoProfile -File build/mapper_width_experiment/run_mapper_width_experiment.ps1
```

All three Icarus compile/run pairs exited 0:

- Existing byte-gap mapper model against original and narrowed copies: both print `PASS: mapper SPC1/8/64, fragmentation, cache, backward/descriptor reset, EOF, invalid/free, cross-request cycles, SD timeout, byte gaps`.
- Differential model: `PASS reachable Brent power boundary: cache power=4096 after legal sector 4095`; then `PASS: cycle-equivalent interfaces and Brent numeric state; valid 4096-cluster max, target 4095, cache continuation/backseek, 4097-cluster E_LIMIT, long EOC and late loop; cycles=6381198 sectors=12295`.

The differential model replays complete 512-byte FAT/data sectors through `sd_read/sd_addr`, `sd_valid/sd_data`, and `sd_end`, with contiguous valid bytes; it never writes DUT internal state. It checks the max legal 4096-cluster file at sectors 4094 then 4095 (cache extension to power 4096), a backward seek, 4097-cluster `E_LIMIT`, a long chain ending in `E_EOC`, and a long tail looping back to Brent's anchor (`E_LOOP`). Cycle-by-cycle interface and numeric Brent-state comparisons passed throughout.

Detailed logs: `tb_fat32_file_sector_existing_compile.log`, `tb_fat32_file_sector_existing_run.log`, `tb_fat32_file_sector_narrow_existing_compile.log`, `tb_fat32_file_sector_narrow_existing_run.log`, `tb_mapper_width_equiv_compile.log`, and `tb_mapper_width_equiv_run.log`. Compile emitted only the usual missing-timescale warning for RTL modules. No synthesis or area estimate was run; simulation establishes behavioral equivalence only, not slice savings or route feasibility. The existing width optimization must be evaluated in the new independent candidate build before any adoption.
