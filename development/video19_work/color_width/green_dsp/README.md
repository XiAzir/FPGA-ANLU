# Green Color Multiplier Width Candidate

This is an isolated experiment derived from the current C02 JPEG source tree. It does not modify `player_video19` or the live C02 project.

## Source and Change

The parent JPEG source set was copied from `development/player_video19/src/user_source/hdl_source/jpeg` into `../parent/src_v`; all 24 Verilog files match the recorded parent SHA256 values in `verification_summary.json`. The parent `jpeg_output.v` SHA256 is `3806a1aa079bf0f0060750111e04dc40bacfe03f07c1cf44253fef00b2c08bbf`.

Only `src_v/jpeg_output.v` changes. The green `cr*2925` product uses signed `[16:0] x [12:0]`, retains its full 30-bit product, then sign-extends to 32 bits. The green `cb*1410` product uses signed `[16:0] x [11:0]`, retains its full 29-bit product, then sign-extends to 32 bits. The red/blue products, output shifts, and all other source files are unchanged. Candidate `jpeg_output.v` SHA256 is `6521e05eb857076b203c5ab696a3c82c09eeb5518e8be60a21bcb7ff12c9f5cf`.

## Verification

- Icarus Verilog exhaustive arithmetic TB checks every signed 17-bit input for both constants: 131072 values per path, PASS. Evidence: `arithmetic/run/run.log`.
- 640x480 JPEG frame with randomized output backpressure: parent and candidate each emit 307200 pixels with 76419 stalls, zero hold errors, zero duplicate coordinates, and zero out-of-range pixels. Both pixel stream SHA256 values equal the existing C01/C02 exact reference `a4d4b3b4b86a23831d06d4b3051dd4c9486b2141ebc4e5c62d67a605a9000440`. Evidence: `runs/parent_frame000_random_bp/` and `runs/candidate_frame000_random_bp/`.

## Independent Core TD

Control and candidate used the same TD 6.2.1 SP1, EG4S20BG256, 50 MHz/20 ns SDC, AreaHigh, `min_ripple_len=18`, `mapper_lut_delay=1600`, `add_map_lut_struct=high`, `map_mode=area_prior`, partition mapping, automatic resource sharing, registered shifter style, and `max_dsp=17` setting.

| Variant | LUT | Slices | BRAM9K | DSP | Setup WNS | Setup TNS |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Control | 5021 | 1000 | 16 | 18 | -2802 ps | -22416 ps |
| Green candidate | 5095 | 1056 | 16 | 18 | -4401 ps | -41881 ps |

TD kept `jpeg_output` at 2 DSPs and mapped the two green products into logic. The candidate adds 74 LUT and 56 slices while Setup WNS degrades by 1599 ps. The runs above used `max_dsp=17`; that cap is below the live core's 18 DSP result, so those numbers alone do not establish the 20-DSP-budget comparison.

## Corrected max_dsp=20 Comparison

After identifying the setting mismatch, separate control/candidate projects were run with `max_dsp=20`, preserving the other device, SDC, AreaHigh and mapping settings. The original 17-cap outputs remain in `td/green_control/` and `td/green_candidate/`; the corrected outputs are in `td_maxdsp20/green_control20/` and `td_maxdsp20/green_candidate20/`.

| Variant | LUT | Slices | BRAM9K | DSP | Setup WNS | Setup TNS |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Control, max_dsp=20 | 5021 | 1000 | 16 | 18 | -2802 ps | -22416 ps |
| Green candidate, max_dsp=20 | 5095 | 1056 | 16 | 18 | -4401 ps | -41881 ps |

The 20-cap run reproduces the 17-cap result: `jpeg_output` stays at 2 DSPs, while the green multipliers map into logic. Under the corrected 20-DSP setting, the candidate still adds 74 LUT and 56 slices and degrades Setup WNS by 1599 ps. The corrected comparison therefore provides no area or timing evidence for selecting this green-multiplier candidate. Candidate `jpeg_output.v` SHA256 remains `6521e05eb857076b203c5ab696a3c82c09eeb5518e8be60a21bcb7ff12c9f5cf`. No full-top synthesis, PNR, or hardware test was run for this candidate.
