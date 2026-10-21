# BMP standalone synthesis

Five isolated synthesis-only projects use `EG4S20BG256`, a 20 ns `clk` SDC, and the same TD 6.2.178840 `import_device` / RTL optimization / gate packing flow. No placement, routing, timing repair, or bitstream stage was invoked.

The area fields use separate names for different report sections. `generic_luts` is `#Total_luts` under LUT Statistics. `device_lut` and `device_reg` are the device utilization fields `#lut` and `#reg`. `hierarchy_luts`, `ripple_carry`, and `hierarchy_seq_including_pad_registers` come from Report Hierarchy Area; the latter includes PAD registers, so it can exceed `device_reg`. Deltas below compare matching standalone projects and report fields.

| Variant | Generic LUTs (`#Total_luts`) | Device LUT (`#lut`) | Device reg (`#reg`) | Hierarchy LUTs | Ripple carry | Hierarchy seq incl. PAD regs | BRAM | DSP |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Engine reference | 724 | 1728 | 598 | 1226 | 502 | 676 | 4 | 5 |
| Engine safe widths, 32 S_DIV cycles | 553 | 1039 | 352 | 796 | 243 | 406 | 4 | 5 |
| Engine safe widths, 19 S_DIV cycles | 549 | 1033 | 352 | 791 | 242 | 406 | 4 | 5 |
| Loader reference (original engine + key debounce) | 1437 | 2993 | 1128 | 2215 | 778 | 1233 | 4 | 8 |
| Loader diagnostic direct (original engine + key debounce) | 1435 | 2901 | 1084 | 2168 | 733 | 1189 | 4 | 7 |

Relative to the standalone engine reference, width32 changes `generic_luts` by -171, `device_lut` by -689, `device_reg` by -246, hierarchy LUTs by -430, ripple carry by -259, and hierarchy sequential count by -270. Width19 changes those fields by -175, -695, -246, -435, -260, and -270. The 19-cycle divider saves 6 additional device LUTs over width32, with matching device register count.

Relative to `loader_reference`, `loader_diag_direct` changes `generic_luts` by -2, `device_lut` by -92, `device_reg` by -44, hierarchy LUTs by -47, ripple carry by -45, hierarchy sequential count by -44, and DSP by -1. It removes the passive diagnostic stages while preserving the original scaler engine. The public failure-detail TB passed all 21 cases on the direct variant.

The parent project’s full-top BMP ablation belongs to a separate measurement scope. Its values include the integrated hierarchy and its top-level optimization context, including other changed modules and top-level ports. Keep those full-top figures in a separate table and compare only full-top baseline against full-top candidate using the same report fields; subtracting a standalone engine or loader result from a full-top value does not isolate BMP savings. The standalone figures here quantify the isolated engine/loader variants only.

`runs/input_manifest.json` binds the source file hashes and project inputs. Each `runs/<variant>/console.log` and `runs/<variant>/reports/gate.area` is retained in full. `runs/synthesis_status.json` contains the distinctly named resource fields and per-run source/report hashes. Diagnostic simulation evidence is under `diag_verify/run_20261020_202825_658809/`. Exhaustive divider and engine equivalence evidence is under `../verification_runs/run_20261020_203248_809178/`.
