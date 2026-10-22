# JPEG Simulation Receipt

## Scope

Simulation uses the local Icarus/VVP binaries and `SUPPORT_WRITABLE_DHT=0`. The baseline RTL is `development/video19_work/vendor/core_jpeg` at commit `bb03cce45d0b7459d395486e9e1db3de1b416bd2`. No vendor or player top-level files were modified. Each run directory under `runs/` retains its manifest, source hashes, compile/console logs, and pixel output.

## Verified baseline behavior

| Fixture/run | Input bytes | Accepted bytes | Pixels and checks | Cycles | Pillow RGB result |
| --- | ---: | ---: | --- | ---: | --- |
| `frame_000_nobp` | 37,704 | 37,704 | 307,200 unique; duplicate/out-of-range/hold errors 0 | 659,842 | PSNR 41.808 dB; max error 53 |
| `frame_109_nobp` | 43,231 | 43,231, tail strb `0x7` | 307,200 unique; duplicate/out-of-range/hold errors 0 | 659,456 | PSNR 42.151 dB; max error 22 |
| `frame_299_nobp` | 35,721 | 35,721, tail strb `0x1` | 307,200 unique; duplicate/out-of-range/hold errors 0 | 659,601 | PSNR 41.971 dB; max error 53 |
| `frame_299_random_both_fixed` | 35,721 | 35,721 | 307,200 unique; 76,347 output stalls; hold errors 0 | 697,177 | PSNR 41.971 dB; max error 53 |
| `frame_109_reset_recovery` | 43,231 | 20,000 accepted before reset, then 43,231 after reset | 307,200 unique after recovery; hold errors 0 | 659,456 after reset | PSNR 42.151 dB; max error 22 |
| `two_frames_after_idle` | 80,935 | 80,935 | Two frames, each 307,200 unique; no global reset; hold errors 0 | 1,319,297 | Per-frame results match the corresponding single-frame runs |

The Pillow comparison uses its default fancy chroma upsampling. The decoder uses its own nearest chroma expansion, so these measurements describe the combined decoder/upsampling difference. They are measured results, not acceptance thresholds.

The first eight MCU block starts and all 4,800 block starts match the TL/TR/BL/BR ordering described in the README. The complete coordinate set is unique for every tested frame.

## Candidate A08 exact comparison

Candidate runs use the source directory `development/video19_work/td/candidate_src/A08`. Each run's `manifest.json` contains the individual SHA-256 of all 24 RTL files, the fixture, and testbench.

| Run | Input variation | Coordinate coverage | Backpressure | Difference from baseline pixels |
| --- | --- | --- | --- | --- |
| `A08_micro_64_bp` | 64x64 center crop, 763-byte JPEG, tail strb `0x7` | 4,096 unique | 1,052 output stalls; hold errors 0 | MSE 0, max error 0 |
| `A08_frame_109_random_output` | 43,231-byte JPEG, tail strb `0x7` | 307,200 unique | 76,912 output stalls; hold errors 0 | MSE 0, max error 0 |
| `A08_frame_299_nobp` | 35,721-byte JPEG, tail strb `0x1` | 307,200 unique | None | MSE 0, max error 0 |
| `A08_frame_000_nobp` | Full 640x480 frame | 307,200 unique | None | MSE 0, max error 0 |

The candidate and baseline record sets have identical coordinates and RGB values, byte for byte. The A08 Pillow metrics therefore match the baseline values above.

## Resolved candidate error

A03 and its derivatives initially produced severe color differences. The 64x64 center-crop test measured A03 at PSNR 4.824 dB and max error 228; direct comparison with baseline measured PSNR 4.900 dB and max error 229. The issue was in candidate `jpeg_output.v`: the replacement Cb/Cr shift-add constants omitted the original arithmetic `>>> 12`. A08 restores that shift. A06 full-frame exploratory output measured PSNR 5.544 dB and max error 255; it is retained under `runs/A06_frame_000_nobp` and must not be used as a qualified decoder result.

## Input-gap and frame sequencing notes

The testbench's no-gap stream is qualified for the listed results. A random-input-gap run completed, but the parent identified unqualified marker decoding in `jpeg_input.v`: SOI/SOF/EOI token wires are not valid-gated. Input gaps can expose stale-byte marker handling; A08 evidence above therefore uses output backpressure without input gaps. A separate immediate-concatenation experiment timed out; sending frame two after frame one has drained to `idle` completed both frames with no reset.

## SDRAM gate probe

`memory_jump/runs/jpeg420_gate_20261021_180050` binds the SHA-checked synthesized production SDRAM controller gate to the APUG011 IS42s32200 pin model. For 768 RGB888 mapped writes, the command trace showed 192 SDRAM WRITE commands (BL4), 2,240 ACT commands, and 64 model `tRP` errors. Linear readback found 432 mismatches among 768 mapped addresses. This is a valuable warning about six-word RGB888 block-row alignment, but it is not a final qualification: the app stream exceeded the controller's 128-word burst contract and the testbench did not insert the production inter-burst idle/drain. A later 512-word RGB565 attempt also omitted those burst boundaries and is exploratory. The parent owns the corrected controller test; do not infer a final RGB565 controller result from these directories.
