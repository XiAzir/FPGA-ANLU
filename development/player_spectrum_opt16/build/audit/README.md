# C11316 route audit scripts (prepared; no results yet)

These read-only scripts target the current C11316 build and never launch Tang Dynasty. The parent must first provide a successful physical export of `routed_implementation.v` and the matching timing report, linked to the final successful synthesis `runId`.

After the routed netlist has been exported:

```powershell
pwsh -NoProfile -File development/player_spectrum_opt16/build/gate_verify/run_c11316_routed_audit.ps1 -RunId <successRunId> -TimingPath development/player_spectrum_opt16/build/manual/AC201_tf_hdmi_pr.timing
```

The routed-control audit binds the selected physical record, routed database, and exported-netlist freshness; the clock audit binds source scope, gate database, physical record, route netlist, and timing artifact hashes. It compares against the preserved C11308 baseline while reporting the C11316 route measurements.
