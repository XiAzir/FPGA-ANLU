# C11320 final routed audit preparation

This folder contains the C11320-specific, read-only audit scripts and the completed final routed audit artifacts. Every result below is bound to the selected C11320 source scope, run records, final PR database, routed timing, and exported netlist. No C04 hash, run ID, ROM result, or clock result is reused.

## Selected synthesis and physical runs

The completed audit is bound to synthesis run `3ad0291b-3f04-444e-b43c-ccbe8caf6f55`, physical run `1a4b9f3a-541b-4b4a-969b-8bb74b578b99`, and final successful hold-repair run `3a5afb62-ab26-4bd9-9bc1-83a4e41c8ff4`. The command below documents how to reproduce the audit in a fresh folder:

```powershell
& 'development/video20_work/final_route_audit/run_c11320_final_route_audit.ps1' `
  -RunId '3ad0291b-3f04-444e-b43c-ccbe8caf6f55' `
  -PhysicalRunId '1a4b9f3a-541b-4b4a-969b-8bb74b578b99' `
  -HoldRunId '3a5afb62-ab26-4bd9-9bc1-83a4e41c8ff4'
```

The exporter requires successful latest-stage pointers and records for all three run IDs, matching synthesis links, source scope hashes, gate database hashes, final PR database hash, and routed timing hash. It then exports the selected hold-routed PR database through TD's read-only `import_db` / `write_verilog` commands. The exporter refuses to overwrite existing artifacts.

## ROM checks

The strict ROM report compares actual routed BRAM parameters against the current `player_video20` manifest. It preserves exact mux parameters and mismatches; a strict parameter mismatch remains visible in that report.

The functional proof separately resolves each routed BRAM control pin through its actual mux and LUT cone and enumerates 32 source-state values and all remaining open/leaf inputs. The state parser binds every routed `state_reg_syn_1[i]` net to the actual FF `.q` port lane. It does not infer bindings from physical slice instance suffixes, because TD can pack unrelated registers into different lanes of one slice. The proof also requires the expected state vector and every Q binding; a changed state representation, missing lane, or truth mismatch produces a failure. The one-hot state-index interpretation is recorded as an inference and its source-state comparisons must pass before the proof reports success.

Strict parameter results and functional truth results stay separate. No mismatch allowlist is applied.

## Clock and STA checks

The clock audit binds the selected synthesis, physical, and hold records, final PR database, routed timing, source scope, exported netlist, SDC, and ROM truth proof. It checks routed PLL and global clock-buffer topology, SDC clock names and sources, and frequency/fanout rows read from the selected final routed STA report. It records the actual fanout values from that report.

## Artifacts

Successful outputs and the initial orchestration failure are preserved in this folder. The first orchestration attempt stopped on a PowerShell result-count guard after export and strict ROM audit; the guard was corrected, then the same selected run IDs and hash-bound artifacts resumed successfully. The failure log remains available as `attempt_01_failure.log`.

- `AC201_tf_hdmi_c11320_pr_routed.v`: exported hold-routed PR netlist.
- `route_export_receipt.json`: synthesis/physical/hold IDs and source/database/timing/netlist hashes.
- `strict_routed_rom_control.json`: exact routed ROM primitive parameter comparison.
- `routed_rom_control_proof.json`, `.md`, and `_verified.json`: actual pin, polarity, Q-lane binding, and truth-table evidence.
- `routed_clock_audit.json` and `.md`: PLL/GCLK topology and routed STA clock/fanout evidence.
- `final_route_audit_summary.json`: selected IDs and the independent result states.

This is a static routed audit. It does not establish board-level SPI I/O delays or analog clock quality. The audit scripts are confined to this directory; they read `player_video20/build/manual` and its evidence but never modify it.

## Completed result

Final summary: `final_route_audit_summary.json` records PASS for strict ROM parameters, routed ROM control truth, and clock-route audit. The routed netlist SHA-256 is `d03f45350bb285fc3288957497afbe3cc35bc4f14d2ee148731320e69996bcc7`. The truth proof covers four BRAM banks and 192 control truth rows. The routed STA Clock Summary fanouts are recorded in `routed_clock_audit.md`.
