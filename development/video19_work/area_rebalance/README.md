# JPEG core resource rebalance

Independent TD core synthesis trials for C11319. All source snapshots and generated TD artifacts are contained in this directory; live `development/player_video19/src` was read only.

## Baseline and method

- Device/top: EG4S20BG256 / `jpeg_core`.
- TD: 6.2.1 SP1 (`6.2.178.840`), 20 ns clock; AreaHigh, `min_ripple_len=18`, `mapper_lut_delay=1600`, `add_map_lut_struct=high`, `map_mode=area_prior`, partition mapping, automatic resource sharing, registered shifter style.
- A08 baseline uses the A08 snapshot and copies the live `jpeg_input.v` marker-valid qualification fix. Of the 24 RTL files, only `jpeg_input.v` differs from the A08 candidate source.
- A10 changes C4 multiplication and `dsp_style` on `mul4_q` in `jpeg_idct_x/y`.
- A11 changes the 5743 and 7258 signed color products, keeping a 32-bit signed product intermediate and arithmetic `>>>12`.
- A12 combines the A10 and A11 changes on the same A08+inputfix parent.
- Every run has a source hash manifest, full TD console log, `reports/gate.area`, and `td_project/gate.qor`. Original failed/partial artifacts, if any, are retained.

## Results

`LUT` is the gate area report's hierarchical `lut + ripple`; `FF` is the report's `seq` count. The separate utilization report's mapped `#Total_luts` and gate-level register count are preserved in each `gate.area`/`gate.qor` pair.

| Variant | Controlled change | LUT + ripple | FF | BRAM | DSP | Slices | Setup WNS | Setup TNS |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| A08_base | A08 + live inputfix | 5261 + 1222 = 6483 | 2905 | 17 | 13 | 1306 | -1.979 ns | -33128 ps |
| A10_c4_mul | C4 products in IDCT x/y mapped to DSP | 5180 + 1171 = 6351 | 2836 | 17 | 16 | 1255 | -1.000 ns | -10176 ps |
| A11_color_mul | 5743 and 7258 color products mapped to DSP | 5075 + 1089 = 6164 | 2905 | 17 | 17 | 1173 | -1.347 ns | -29480 ps |
| A12_c4_color_mul | A10 and A11 combined | 5050 + 1038 = 6088 | 2836 | 17 | 20 | 1122 | -0.460 ns | -6808 ps |

A12 saves 395 hierarchical LUT/ripple and 184 slices against A08 while using 20 DSP and 17 BRAM. It remains 1088 LUT above the requested 5000 core target. A10 saves 132 LUT/ripple and A11 saves 319; A12 combines these gains without exceeding the declared DSP cap. Full-player place-and-route has not been run on these core-only snapshots, so these results do not prove the reported 5613-to-4900 whole-system MSlice gap is closed.

## Evidence

- A08 baseline: `A08_base/manifest.json`, `A08_base/td_console.log`, `A08_base/reports/gate.area`, `A08_base/td_project/gate.qor`.
- A10: `A10_c4_mul/manifest.json`, `A10_c4_mul/td_console.log`, `A10_c4_mul/reports/gate.area`, `A10_c4_mul/td_project/gate.qor`.
- A11: `A11_color_mul/manifest.json`, `A11_color_mul/td_console.log`, `A11_color_mul/reports/gate.area`, `A11_color_mul/td_project/gate.qor`.
- A12: `A12_c4_color_mul/manifest.json`, `A12_c4_color_mul/td_console.log`, `A12_c4_color_mul/reports/gate.area`, `A12_c4_color_mul/td_project/gate.qor`.
- Reproduce preparation with `python prepare_area_rebalance.py`, then run one variant with `python run_area_rebalance.py A08_base|A10_c4_mul|A11_color_mul|A12_c4_color_mul`. Existing run directories are kept unchanged by the preparer.

TD reports include the same existing HDL-5373 declaration-order warnings in `jpeg_dht.v`, the same undriven byte-enable warnings in output RAM, and RAM initialization warnings. All four runs exited 0 and reported `SYNTHESIS_COMPLETE`.

Scope: independent `jpeg_core` synthesis only. No change was made to live player RTL, coordinates, arithmetic precision, framebuffer/cache structure, or parent integration. No whole-system PNR, simulation of these arithmetic variants, download, or board test was performed.
