# Routed Audio/Counter Cone Audit

Date: 2026-10-09

Scope: read-only inspection of the existing routed netlist `../independent_audit/AC201_tf_hdmi_axis_probe_pr_routed.v` (TD v6.2.178840, 210,881 source lines / 10,988,025 bytes) and official EG4 primitive model declarations. No product RTL, constraints, routed database, or bitstream was changed. No full-netlist simulation or bit generation was run.

## Findings

- The RTL declares `player_status_monitor.second_count` as a 25-bit pixel-clock counter comparing against `PIXEL_HZ-1`; `player_dynamic_text.second_tick` is also 25 bits and compares against `CLK_FREQ_HZ-1`. Both instances use 25,000,000 Hz and `rst_all`. In the routed netlist, there is no `u_status_monitor/second_count` declaration or register instance, while `u_dynamic_text/second_tick[24:0]` remains and its FF bank is clocked by `u_status_monitor/sys_clk` (the top-level `video_clk`). This is consistent with synthesis sharing/eliminating the status timebase in favor of the subtitle counter. It is not a complete proof that the terminal comparator and all status clear/mailbox enables are the same logic: the full fan-in/fan-out cone was not closed.
- `u_status_monitor/audio_count[23:0]` remains a separate register bank, with routed FF instances attributed to `player_status_monitor.v(37)`. Its FFs share the routed video clock and use duplicated `startup_flags[1]` reset nets. Thus the audio sample count itself was not merged with the subtitle timer.
- The 28-bit `mailbox` and `received` vectors plus request/ack toggle nets are still declared in the routed netlist. Their existence is consistent with the RTL handshake mailbox, but this limited inspection did not close the latch condition, payload mux, CDC synchronization, or acknowledge feedback cones; routed mailbox behavior is therefore not verified here.
- `u_audio_probe/tone_valid` remains a routed FF output (`EG_PHY_MSLICE` instance at netlist line 18986; `.q` at line 18993), clocked by `u_status_monitor/sys_clk` and reset by a duplicated `startup_flags[1]` net. `u_audio_probe/u_tone/S_sample_acc` also remains as routed state, with FF instances attributed to `hdmi_audio_tone_pcm_scale.v(43)` around lines 19651-19868.
- The source instance overrides tone parameters to `CLK_FREQ_HZ=25,000,000`, `SAMPLE_RATE_HZ=48,000`, and `AMP=1,000,000` in `player_audio_probe.v`; the accumulator source assigns a next value on every pixel-clock edge and asserts `O_audio_valid` when the accumulated rate crosses the clock threshold. Representative accumulator FFs use `.CEMUX("1")`, which is consistent with an always-updating register. This static inspection does not decode every LUT/carry input back to the arithmetic constants, so exact routed arithmetic equivalence is not claimed from this report alone.
- The status count's RTL window and the tone accumulator's nominal rates agree at the source-parameter level (25 MHz / 48 kHz). The existing RTL simulation in `audio_model/` independently verified 48,000 tone-valid events per 25,000,000-edge window, but it did not simulate these routed primitives.

## Extraction Boundary

The official model files expose the expected packed `q[1:0]` slice interfaces. In the routed netlist, a single packed primitive output can contain signals from separate hierarchy paths: for example, the `h_cnt_reg[10]` slice instance around line 210506 has `.q({video_timing_data...h_cnt[10], u_dynamic_text/second_tick[16]})`. Therefore selecting instances only by hierarchy would omit another driver/state bit on the same packed port and could change primitive semantics. The candidate tone/status logic also uses packed MSLICE/LSLICE ports whose outputs include open pins, derived nets, and cross-logic outputs.

No closed extracted cone was produced. As a result, no primitive sub-netlist simulation was attempted. A credible next extraction would need to parse whole primitive instances, preserve every packed input/output bit and its driver, and iteratively close all fan-in and fan-out dependencies for the selected counter/audio/mailbox cones. Until then, the routed netlist supports the structural observations above but not a routed sample-rate or mailbox-count simulation.

## Conclusion

The routed netlist is consistent with `second_count` being eliminated/shared with the subtitle `second_tick` timebase, while retaining a separate `audio_count`, tone accumulator, and tone-valid register. Full sharing of the terminal event and exact routed arithmetic/enable behavior remain unproven. The existing 25 MHz RTL result remains valid only for RTL simulation, not as routed-netlist proof.
