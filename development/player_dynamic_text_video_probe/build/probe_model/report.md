# Video source probe functional model report

Date: 2026-10-09 (Beijing time)

## Scope and source binding

The diagnostic is in a root-created copy at `development/player_dynamic_text_video_probe`; the frozen `player_dynamic_text_fit` source, bitstream and checkpoints were not edited. Only the copied `top_tf_hdmi_audio.v`, `player_dynamic_text.v`, the new `player_video_source_probe.v`, the new module's single `.al` source entry, and simulation/report artifacts changed. The current RTL source hashes and per-model run-log/testbench hashes are recorded in `../model_results.json`.

In this project's existing port names, the physical KEY0 modifier is top-level `key1` (active low, manual-next input) and the long KEY1/tone button is `key2` (active low, auto input). The source model preserves either single-key gesture and masks the BMP commands only when both are low:

- `bmp_key_next = key1 | !key2`
- `bmp_key_auto = key2 | !key1`

The KEY0 signal is synchronized through two flops into `video_clk` for long-press classification. `debug_tone_press` with synchronized KEY0 high still reaches the audio tone toggle. With synchronized KEY0 low, it queues an even/odd source-toggle request; the selected mode changes only on VS rising. The pending/new request parity expression handles a request coincident with VS without losing or duplicating a toggle. Reset returns to BMP mode. The BMP path retains the `osd_frame_valid` black-before-first-frame behavior; the internal reference palette does not depend on BMP validity and uses `osd_image_index`: white `ffffff`, gray `808080`, red `ff0000`, green `00ff00`.

The dynamic-text time label renders `RUN` in BMP mode and `REF` in reference mode. Existing timer, bottom scrolling text, positions, and blanking/pass-through behavior remain unchanged.

## Icarus results

All three final runs returned PASS:

1. `source_probe` — the actual `key_press_debounce` RTL with scaled counters covered short KEY0, short KEY1, long KEY1 alone, KEY0+long KEY1, one-shot tone gating, both-low BMP masking, release/rearm, reset, BMP-valid black/passthrough, all four exact 24-bit colors, and KEY0 synchronizer edge cases. The edge checks covered raw KEY0 asserted with `tone_press` (old synchronized high selects tone), KEY0 stable low (selects probe), raw KEY0 released with `tone_press` (old synchronized low selects probe), request latching at VS rising, and a pending request plus a new request on the same VS edge cancelling by parity. See `source_probe_run.log`.
2. `pixels_probe` — parallel `probe_mode=0` and `probe_mode=1` instances matched an independent pixel oracle for 1,843,200 active pixels over six 640x480 frames. `RUN` and `REF` glyphs, timer snapshots, scroll phases, the unchanged bottom text, non-overlay pass-through, blanking pixels and VS boundaries all matched. See `pixels_probe_run.log`.
3. `timer_probe` — the existing timer regression passed 00:59→01:00, 99:20, 99:59→00:00, reset/restart, and its 12,000-cycle wrap test. See `timer_probe_run.log`.

The precise tool, top-module name, PASS marker, result, file path, and SHA256 for each run and testbench are in `../model_results.json`.

## Limits

These are standalone functional RTL models. They do not simulate the full top, TF card, framebuffer/SDRAM hard-IP, encrypted HDMI core, TD synthesis/placement, or board behavior. They verify the control intent and RGB reference path, not whether the candidate's physical stripe artifact comes from the framebuffer or HDMI output chain. Root's TD build and any subsequent board A/B remain separate evidence.

The earlier audit wording is corrected in `../../player_dynamic_text_fit/build/stripe_readonly_audit/audit.md`: missing `sd_miso` input delay and HDMI output delays do not establish missing SDRAM DQ constraints. SDRAM is behind EG_PHY hard-IP; its read phase needs review against that IP configuration and board timing evidence.
