# C11322 audio diagnostic verification

Run from PowerShell 7:

```powershell
& .\development\player_video22_audio_diag\verification\run_audio_diag_tests.ps1
```

The runner resolves Icarus with `scripts/anlu_tools.ps1`. The successful run used escalated execution because restricted Icarus invocations fail while creating temporary files. It does not modify `src/` or `scripts/`; binaries, extracted wrappers, logs, and the summary stay under `verification/results/`.

- `tb_player_compact_status_pages.v` is based on C21's 16-page test with the page-zero ID changed to C11322. It checks all legacy and diagnostic page words, wrap, and reset.
- `tb_audio_crc_snapshot.v` changes CRC, block, sample count, and underflow count every five clocks while the real status-page module advances every three clocks. The extracted C22 snapshot always block must capture once on each page-7 entry, hold through pages 8/9/A/D, and clear on reset.
- `tb_audio_sd_observer.v` tests the extracted C22 SD observer with delayed first-valid responses, sustained and repeated reads, take-gated FIFO low-water tracking, and reset.

The runner removes only the declared output-tap lines from C22's `wav_pcm_bridge.v`, `player_audio_probe.v`, and `tf_wav_file_player.v`, then requires exact normalized source equality with C21. The log also records C21/C22 hashes, C22 top hash, and SHA-256 values for both extracted always blocks.

Latest compile and simulation exit codes are all 0. The three early static-comparison attempts and their causes remain in `results/static_comparison_failed_attempt*.log`.
