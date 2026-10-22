# Shared IDCT Study

Status: read-only architecture review and implementation spec. No live RTL, constraints, or build settings were changed.

## Objective

Evaluate one time-multiplexed 8-point IDCT arithmetic pipeline for the horizontal and vertical passes. The target is at least 500 LUT-equivalent reduction and fewer DSPs in the C02 whole-player build, while preserving coefficient order, pixel bits, block IDs, backpressure, and the existing 15 fps operating point.

## Source Evidence

The current live X and Y units have the same registered arithmetic sequence and C1..C7 constants. Both form the same `i0`, four general products, C4 product, staged butterflies, scale-by-1/sqrt(2), and eight output samples. Their differences are:

| Property | X pass | Y pass |
|---|---|---|
| Input | Four signed 16-bit values, sign-extended to 32 bits | Four signed 32-bit values |
| Final shift | `OUT_SHIFT=11` | `OUT_SHIFT=15` |
| Output index | `ptr_conv(ptr_q)` maps the 0..63 stream into X-transpose order | `ptr_conv(ptr_q)` maps to final block order |
| Parent stage | Reads the four-bank coefficient RAM | Reads the transpose RAM |
| Downstream | Writes the transpose RAM | Feeds `jpeg_output` and the block-ID FIFO consumer |

The active source has `mul4_q <= mul4_a * mul4_b` in both passes. The isolated A13/A11 study source uses C4 shift-add; use live C02 as the implementation baseline for a future shared-kernel experiment.

The A13/A11 core gate hierarchy gives a conservative arithmetic baseline: X is 625 LUT + 336 ripple + 782 FF + 5 DSP; Y is 615 LUT + 373 ripple + 926 FF + 10 DSP. C01 whole-player gate reports X=625/336/782/5 and Y=615/373/926/10 in the same columns. Combined arithmetic is therefore 1240 LUT, 709 ripple, 1708 FF and 15 DSP before sharing. The report is `development/video19_work/combined_area/C01/whole_gate/AC201_tf_hdmi_gate.area`.

## Proposed Datapath

Factor the duplicated registered arithmetic into one 32-bit signed `jpeg_idct_1d_shared` core. Keep the existing X coefficient RAM, transpose RAM, and A13 valid-slot clearing. Add a block-level scheduler in the IDCT wrapper and explicit ready/valid on both shared-core boundaries. Keep all intermediate products, butterflies, and final outputs at the existing 32-bit modulo width; carry a per-beat `pass` tag and apply the existing pass-specific output shift only at the final result register. X inputs are sign-extended exactly as today. Y inputs pass through unchanged.

The wrapper should reserve a complete destination before starting a non-stallable 64-beat block transfer. A block read from `jpeg_idct_ram` starts only when the shared core is in its X-launch state and the transpose write slot is free. Count accepted X input beats in a 7-bit counter because the X input index is only three bits and repeats 0..7 across the 64-beat block. Route all 64 X results to the reserved transpose slot. Treat X completion as the accepted output beat with full block index 63, not the input beat with index 63; the arithmetic core has pipeline latency.

After the final X result is stored, wait until the transpose reports a ready block and the shared core can reserve the entire Y stream. Then read exactly 64 transpose beats into the Y pass. Route Y results to the output and retire the current block ID only on an accepted Y output beat with block index 63. This preserves block order without an extra reorder RAM. The transpose's two slots remain useful for ping-pong timing, while the scheduler keeps at most one transform job active.

Recommended phase sequence:

```text
IDLE
  -> X_RESERVE (free A13 input slot already filled; transpose write slot available)
  -> X_LOAD (64 accepted RAM beats)
  -> X_DRAIN (wait for shared output idx 63; commit transpose block)
  -> Y_WAIT (transpose block ready)
  -> Y_LOAD (64 accepted transpose beats)
  -> Y_DRAIN (deliver output through ready/valid; retire ID at accepted idx 63)
  -> IDLE
```

`img_start_i` flushes the shared pipeline-valid bits, scheduler phase and counters, transpose state, A13 input-slot state, and ID queue just as it does today. `img_end_i` must not truncate either drain phase. A new X job stays blocked while Y outputs are stalled. X and transpose Y readers must hold their data and index stable whenever their accepted handshake is low.

## Backpressure Contract

The current X/Y modules have no output-ready input, so they cannot be time-shared safely behind a variable-latency scheduler without a wrapper-level block reservation. The shared core should expose `in_valid/in_ready`, `out_valid/out_ready`, a 64-beat block boundary, pass tag, 32-bit data, and the existing output index.

Use source-ready only when the scheduler has reserved all destination capacity for the current 64-beat phase. Once a source starts, allow the entire 64-beat transfer to complete without bubbles; each existing RAM block reader streams a block without per-beat pause. When the downstream pixel path stalls, hold the shared Y output register and block index stable, and do not launch the next X block. Keep transpose writes and input-RAM reads gated by their respective accepted transfers. Preserve the current four-slot A13 input-buffer preclear: it runs independently while a slot is free, lowers coefficient accept until all 16 words in each of the four banks are cleared, and releases preparation on the same EOB/accept condition that advances `block_wr_q`.

Block identity is currently FIFO ordered: `jpeg_idct` pushes IDs at EOB and pops the head at the final Y output index. Keep one ID at the head through the entire Y result block, then pop only on `out_valid && out_ready && out_idx == 63`. Do not pop at X completion or transpose completion. If block-ID FIFO acceptance is not guaranteed, add an explicit ID reservation before accepting a new EOB.

## Throughput Budget

For 640x480 4:2:0 there are 40x30 MCUs and six 8x8 blocks per MCU, for 7200 blocks per frame. A conservative shared-kernel overhead versus the current parallel X/Y passes is one extra 64-beat pass per block: 7200 x 64 = 460,800 additional 50 MHz cycles, or 9.22 ms. Allowing up to 14 drain/phase-bubble cycles per block adds at most 100,800 cycles (2.02 ms). The combined conservative increment is 561,600 cycles, or 11.23 ms.

The 15 fps budget is 3,333,333 system cycles (66.67 ms). Frame 109 is the large measured input at 43,231 bytes; at the measured 7.6 Mbps card-stream rate its transfer alone is about 2.28M system cycles (45.5 ms). Adding the shared-pass bound gives about 2.84M cycles (56.7 ms), leaving about 0.49M cycles (9.9 ms). This estimate assumes the existing reader can overlap decode with transfer as it does today; the acceptance criterion must be the full reader/core simulation, not the arithmetic estimate.

The isolated C02 decoder/frame0 simulation completes in about 0.66M core cycles, and the reader/core frame0 and frame1 runs complete in about 2.02M and 2.04M cycles. Use frame 109, then a 300-frame steady-state run, to validate the estimated margin. Monitor max per-frame cycles, block queue occupancy, input backpressure and output stalls.

## Resource Estimate

The duplicated C01 arithmetic hierarchy totals 1240 LUT, 709 ripple, 1708 FF and 15 DSP. A single 32-bit Y-sized datapath is the safe upper-width choice: around 615 LUT + 373 ripple + 926 FF + 10 DSP before scheduler/mux overhead. Estimate 100-250 LUT for pass selection, launch control and handshake, yielding roughly 700-850 LUT-equivalent saved and about 5 DSP saved. A reasonable first gate target is at least 500 LUT net savings and no more than 11 DSP in the shared kernel. The estimate is directional; only an isolated TD synthesis can settle DSP packing and LUT sharing.

Do not share or resize the transpose, A13 input RAM, C02 green-channel path, DHT tables, or output RAM as part of this first experiment. Keeping those constant makes the X/Y datapath delta attributable.

## Timing Review

C01's frozen gate timing report identifies `u_jpeg_core/u_jpeg_output/u_ram_cr/u_ram/ramread0_syn_58.clkb` to `u_jpeg_core/u_jpeg_output/pixel_g_q_reg[0].d` as the worst path. Data-path delay is 24.625 ns with 19 logic levels, including eight adders. The C02 gate result most recently reported by the parent is 25.283 ns with 20 logic levels and eight adders on the same Cr-to-green output path. The source logic is the exact CSD products for green, followed by the Y/Cb/Cr combination and signed saturation. This path is separate from X/Y sharing and currently dominates whole-player timing.

The parent reports C02 highpack place-and-route completed at 4790 MSlice, with physical totals 17879 LUT / 9752 FF / 62 BRAM / 27 DSP. Setup is -0.328 ns on the HDMI 5x clock, the sdcard-green path is -0.050 ns, and hold is -0.020 ns. The parent plans C03 with green DSP multiplication and read-priority integration before the final whole-player rerun. These reported paths show that the green color path remains the immediate timing item; shared IDCT is an area/DSP opportunity and does not address that critical cone.

If the planned two green DSP multipliers do not close timing, insert an elastic conversion register after the signed 32-bit products. For a LUT-only split, register balanced partials such as `cr_hi=(cr<<12)-(cr<<10)`, `cr_lo=(cr<<7)+(cr<<4)+(cr<<2)-cr`, `cb_hi=(cb<<10)+(cb<<8)`, and `cb_lo=(cb<<7)+(cb<<1)`; then finish each 32-bit modulo product and the final green sum in a following stage. Preserve arithmetic `>>>12`, 32-bit wrap, clamp expression, and all pixel metadata.

Backpressure must move with the registers. Define `pixel_ready = !pixel_valid_q || outport_accept_i`, `conv_ready = !conv_valid_q || pixel_ready`, and pop Y/Cb/Cr sources together only on `source_fire = active_q && conv_ready`. Capture product partials, Y, coordinates/ID, idx, mode, and valid on `source_fire`; advance `idx_q`, 4:2:0 subsampling, and ID pop only on that same accepted source beat. Advance each stage valid/data only when its downstream stage is ready. Hold every stage stable during stalls. Delay `idle_o` until EOF is observed and all conversion/pixel stages have drained. This adds latency but retains one accepted pixel per clock after fill and should add only pipeline fill/drain cycles per frame.

## Validation Gate

Before any live integration, build an isolated shared variant and compare against C02 for:

- Deterministic vectors covering all eight indices, positive/negative extremes, overflow wrap, zero blocks, sparse AC, dense AC, and both X/Y output-index maps.
- A block-level scoreboard for X output -> transpose contents -> Y output, including `block_id` ordering across the four A13 input slots and both transpose slots.
- Random input gaps and output backpressure with stable data/index assertions at every ready/valid boundary.
- Abort/reset during X load, X drain, Y wait, Y load, and Y drain; ensure no pre-reset valid or ID escapes after `img_start_i`.
- Frame 109 and 299 A/B pixel equivalence, then all 300 frames with max-frame-cycle assertion below 3,333,333 cycles.
- TD gate area and setup/hold timing. The shared unit must save at least 500 LUT-equivalent and five DSP before considering whole-player PNR.

This document is a spec only. No RTL refactor or constraint change has been performed.
