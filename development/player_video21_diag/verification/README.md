# Icarus verification

Run from PowerShell 7:

```powershell
& .\development\player_video21_diag\verification\run_iverilog_tests.ps1
```

The script resolves Icarus through `scripts/anlu_tools.ps1`, compiles and runs three focused tests, and records every command and exit code under `results/`.

- `tb_player_compact_status_pages.v` checks all 16 page words, one full wrap, and reset during a page interval with `PAGE_CYCLES=3`.
- `tb_frame_fifo_write_diff.v` checks the diagnostic taps cycle by cycle against a renamed copy of the C20 source, including delayed SDRAM initialization, RGB/JPEG requests, and reset. The compile log records the unmodified C20 source SHA-256.
- `tb_first4_capture_observer.v` tests the exact SD-domain observer block extracted from `top_tf_hdmi_audio.v`. The compile log records both the top source hash and extracted block hash. Scenarios cover a one-cycle request followed by delayed/gapped valid bytes, sustained requests, nonzero sectors, end, and reset.

Latest run on 2026-10-22 passed all three compile/simulation pairs with exit code 0. Earlier failed attempts remain in `results/*failed_attempt1.log`; they document the generated-reference BOM/compile-order issue, the short test payload with the production burst default, and the extracted wrapper timescale quoting issue. The corrected final run passed without changing `src/`.
