# C04 video JPEG compile-time profile area trial

The baseline is the copied `development/player_video19/src` project before any candidate edits. TD 6.2 synthesis completed with the same C04 report totals as `player_video19/build/manual/AC201_tf_hdmi_gate.area` and max DSP allowance 29.

| Build | `#lut` | `Total_luts` | registers | BRAM | DSP | Change vs baseline `#lut` |
|---|---:|---:|---:|---:|---:|---:|
| C04 baseline | 17,025 | 10,848 | 9,762 | 62 | 27 | — |
| Fixed mode 4:2:0 | 16,849 | 10,701 | 9,714 | 62 | 27 | -176 |
| Fixed mode + 640×480 | 16,730 | 10,648 | 9,698 | 62 | 27 | -295 |
| Fixed mode + size + narrow MCU counters | 16,793 | 10,668 | 9,663 | 62 | 27 | -232 |

The fixed-profile candidate adds optional `jpeg_core` parameters `FIXED_MODE`, `FIXED_WIDTH`, and `FIXED_HEIGHT`; defaults retain runtime parsing. The production video instantiation selects mode 2 and 640×480. The narrower counter experiment is enabled only when all three values match that profile. It uses 7/6/8/6 bits for block X, block Y, X index, and Y index. The 420×640×480 bound review covered `block_x_next=80`, `x_idx=159` before row wrap, `y_idx=60` after the final row advance, `block_y<=59`, and zero extension of block IDs.

The fixed-profile and narrowed-counter candidates each passed the mature standalone JPEG testbench against the dynamic core. Both runs accepted the 30,551-byte 640×480 4:2:0 JPEG, accepted the empty-last beat, emitted 307,200 unique in-bounds pixels, reached `idle=1`, reported zero duplicate/bad coordinates, and completed in 659,758 cycles. Both output files were 2,150,400 bytes with SHA-256 `3DB632B288485D26752E5ADF7F0551A886FE956ADBDCC9558DA59F53582482F9`.

The first custom harness omitted the empty-last beat and stopped at 306,688 pixels with `idle=0`; its failure is preserved in [underfull_dual_core_failure.log](underfull_dual_core_failure.log). The quiet-window experiment was not accepted as a full-frame pass. The mature harness and final full-frame evidence are under `../sim/` and `fixed_profile/`.

The narrowed-counter result uses fewer registers and reduces the `jpeg_mcu_proc` hierarchy from 535 LUT / 192 sequential cells to 452 LUT / 161 sequential cells. Whole-design LUT rises by 63 from the fixed mode+size result due to mapping changes, so the narrower-counter variant should remain a separate optional follow-up. The production-ready D02 source freeze is in [fixed_profile](fixed_profile); D03 experimental source hashes are in [narrow_counter/sha256.json](narrow_counter/sha256.json).
