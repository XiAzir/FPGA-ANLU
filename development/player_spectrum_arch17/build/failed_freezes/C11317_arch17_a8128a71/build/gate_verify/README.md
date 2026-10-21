# C11317 gate verification (prepared; no results yet)

This folder contains only the adapted current-candidate verification inputs and scripts. It contains no copied C11313 logs, reports, or gate netlists. The FFT bench is the 9-port gate cone bench; its samples and expected values come from `../sim/vectors`.

After the parent supplies the final successful synthesis `runId`, run from the repository root:

```powershell
pwsh -NoProfile -File development/player_spectrum_arch17/build/gate_verify/run_c11317_gate_audit.ps1 -RunId <successRunId>
```

The runner binds the request to the latest successful synthesis pointer/record, current gate Verilog and database SHA, synthesis log marker, bench, extractor, and vector hashes. It then runs the gate FFT regression, strict BRAM control-parameter recording, four-bank INIT decoding, and the 32-state LUT plus pin-mux effective-polarity proof. Strict SIG/INV differences remain recorded in `build/audit/gate_rom_control.json`; the exhaustive proof decides whether their effective pin behavior matches the RTL. Its expected row count is 192 (six controls × 32 states).

ROM counts distinguish 1,536 logical words (Hann 1,024 + twiddle 512) from 3,072 bank-lane entries (1,024 + 1,024 + 512 + 512).
