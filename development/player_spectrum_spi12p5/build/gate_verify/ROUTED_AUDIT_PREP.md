# C11315 routed audit preparation

This directory contains the runnable routed-stage checker for a newly successful C11315 synthesis/physical pair. It is prepared only; no routed export was inspected and no routed audit was run during preparation.

After the parent exports the routed implementation netlist and provides the exact successful synthesis run ID, physical run ID, and current timing report path, run from the repository root:

```powershell
pwsh -NoProfile -File .\development\player_spectrum_spi12p5\build\gate_verify\run_c11315_routed_audit.ps1 `
  -RunId <synthesis-run-id> `
  -PhysicalRunId <physical-run-id> `
  -TimingPath .\development\player_spectrum_spi12p5\build\manual\AC201_tf_hdmi_pr.timing
```

The runner binds the latest synthesis and physical markers/records, physical-to-synthesis linkage, gate and route database hashes, route completion time, and the exported routed netlist hash. It writes fresh evidence to `build/audit/routed_rom_control.json`, `routed_rom_init.json`, `routed_rom_control_proof.json`, and `routed_clock_route.{md,json}`.

The INIT checker decodes all four routed BRAM lane images against the current source `.mem` files and manifest, requiring 1536 logical words and 3072 lane entries. The strict control checker preserves its raw SIG/INV mismatch report. The routed polarity proof inspects the actual routed BRAM control connections, each actual pin mux mode, and the routed LUT cones, then enumerates all 32 state values for each of the six control pins (192 truth rows). The clock audit must report exactly 45 checks with overall PASS.

The polarity parser still needs to be checked against the actual newly exported routed hierarchy before the audit is run. If the physical tool renames or restructures the BRAM instances, pin cells, or state feedback nets, adapt the parser to the observed routed netlist and rerun static syntax checks before producing evidence. No fixed mismatch allowlist is used.
