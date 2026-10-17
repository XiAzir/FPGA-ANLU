# SD test card and isolated SD-controller simulation

This folder is an isolated verification fixture for the current production `player_spectrum_fft_recover` SD core. It does not alter production RTL, frozen sources, bitstreams, or release archives.

## Rebuild and run

From PowerShell 7:

```powershell
python .\gen_card.py
.\run.ps1
```

`gen_card.py` writes the sparse byte image for inspection plus `packed_mem.mem` and its explicit `lba_map.mem`, `manifest.json`, goldens, and the 4096-sample PCM-byte `wave_samples.mem`. The simulator loads 2,073 packed 512-byte sectors rather than allocating a byte-addressed 64 MiB array. `run.ps1` compiles the real production SD modules with the installed Icarus Verilog and runs the testbench. See `run.log` and `summary.json` for the last run.

## Image contents and provenance

The image has 64 MiB geometry, an MBR partition at LBA 2048, a FAT32 VBR, two FATs, and 126,944 data clusters. The FAT is fully represented; only allocated file sectors are emitted as sparse data. The root directory contains `PIC.BMP` (16x16, 24-bit RGB) and `TEST.WAV` (PCM16, mono, 48 kHz). The BMP gold bytes and source/window hashes are in `manifest.json`.

`TEST.WAV` is an 8,236-byte test WAV built from 4,096 samples at payload byte offset 262,144 of `deliverables/real_music_20261008/card/TEST.WAV`. The source file SHA256, sample count, window SHA256, and nonzero sample count are in the manifest. This is a short excerpt for simulation, not a complete-song acceptance artifact.

The card model accepts only commands used by this production driver: CMD0, CMD8, CMD55, ACMD41, CMD16, and CMD17. It uses the actual production SPI mode 3 (CPOL=1, CPHA=1), SDHC block addressing, and CRC16/CCITT (init 0, polynomial 0x1021). Unsupported commands set `protocol_error`; an LBA absent from the map or any mapped byte that is X causes a fatal simulation error. Card geometry remains 64 MiB; only the 2,073 explicitly listed sectors are readable, and every other read fails loudly.

## Test boundary

The testbench instantiates the real production `sd_card_top` with its original divider and startup waits. It validates initialization, every byte from LBA 0 and LBA 4130, and the production CRC monitor (`checked=2`, `bad=0`). A second card instance exercises initialization and recovery after CS is raised in the middle of a CMD17 response/data transfer.

ModelSim SE-64 10.1c `vlog` compiles the compact packed-sector test and production RTL successfully. The earlier byte-addressed model caused `vish` to lose its `vsimk` connection. The compact model loads all sectors and passes the full SD unit test with `vsim -novopt`; see `modelsim/vlog.log` and `modelsim/unit_novopt.log`. The default optimized `vsim` path stalled before test progress in this setup; `-novopt` completed in about 8 seconds. A missing-image negative test logs a time-zero FATAL, though this ModelSim build exits with status 0 after `$fatal`, so automation must check for the failure text and the expected PASS marker. Icarus Verilog / `vvp` also passes the current packed model and TB. No TD compilation or hardware operation was performed.
