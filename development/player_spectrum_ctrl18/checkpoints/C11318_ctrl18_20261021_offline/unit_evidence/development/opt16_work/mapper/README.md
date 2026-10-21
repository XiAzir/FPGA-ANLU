# opt16 mapper FAT decode width ablation

## Inputs

- C11315 baseline RTL: development/player_spectrum_spi12p5/src/user_source/hdl_source/fat32_file_sector.v
- Baseline SHA256: df0c358c07806e09e113fe8db863467afebb79430d55003269a25d8d418bf897
- Candidate: candidate.v; SHA256: a8deea887db2ad39f549e644cb031d9f3add29c3ebeebfe1e69cd5b6a35d583f
- Candidate change: FAT decode value is formed directly as a 28-bit concatenation from the four FAT bytes. Removed the 32-bit temporary register declaration, its reset, and its state-local blocking assignment. The original mask made bits 31:28 constant zero; comparisons and external behavior are preserved.
- Existing synthesis wrapper SHA256: dd445ece3a9110250fae1997b0d9dfae4231da9f8d20617cca0aba3018f5e9eb; EG4S20BG256, 20ns clock, AreaHigh, AdderThreshold18. Prior same-source top_specialized baseline: 2015 device LUT / 569 FF / 1280 generic LUT; source SHA matched baseline.

## Differential evidence

Copied reference module SHA256: 13ef94010c901b155029e3b5cd3d3a397848640fcec4c9a359e2a49f45ec60ee (module rename only). TB compares external data/valid/end/error/error_code/SD request/address each cycle and six Brent/cache numeric states.

- BMP101 edges: PASS, 13,344 cycles. Covers shifts 0..15, address boundaries/overflow, cluster, size, and limit checks.
- BMP101 long: PASS, 6,381,198 cycles; 12,295 SD sectors. Covers 4096-cluster chain, cache continuation/backseek, Brent power=4096, 4097-cluster limit, EOC, and late loop.
- WAV111 edges: PASS, 13,344 cycles.
- WAV111 long: PASS, 6,381,201 cycles; 12,295 SD sectors; same boundary classes and cycle-equivalent outputs/state.
- Logs and compile output are in this directory (bmp_*.log, wav_*.log).

## TD status

TD candidate completed once at td/candidate using EG4S20BG256, 20ns clock, AreaHigh and AdderThreshold18. SYNTHESIS_COMPLETE and actual synthesis parameters were verified. Against the existing same-source specialized baseline (source SHA256 df0c358c07806e09e113fe8db863467afebb79430d55003269a25d8d418bf897), candidate area is unchanged: device LUT 2015, FF 569, generic LUT 1280; hierarchy reports BMP/WAV mapper 999/883 LUT. The 28-bit expression gives no measurable resource reduction, so it is not recommended for C11316. Full console, gate.area and actualparams reports are retained in td/candidate.
