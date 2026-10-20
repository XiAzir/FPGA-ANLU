# Routed FFT Cone Boundary Audit

Date: 2026-10-16

## Finding: `I_rst_dup_*` Were Forced Incorrectly

In `attempt_2_guarded`, the routed extractor treated every net named `.../I_rst_dup_*` as an external copy of `rst`. The generated C11308 cone shows this at `C11308/routed/fft_cone.v:9672` and `:9675`; the same cone then uses `I_rst_dup_17` and `_20` as sequential `.sr` inputs, for example at `:12771` and `:16705`.

Those names are not direct reset pins. In the archived C11308 routed netlist, `I_rst_dup_20` is an `EG_PHY_MSLICE` Q output at line 121710, clocked from `u_status_monitor/sys_clk` and fed from `u0_reset_sync/S_sync_reset_1d`. `I_rst_dup_17` is also an FF Q output inside `u_pcm_waveform/u_spectrum/mux42_syn_315` at line 164189; its lane data input is `S_sync_reset_1d`, with an asynchronous startup reset. Replacing these Q outputs with raw TB `rst` bypasses the synchronized reset-release state and is not a faithful routed dependency cone.

The later `attempt_3_reset_closure` removed those extra `I_rst_dup_*` boundaries and included their actual drivers. The affected routed outcomes did not change: C11307 still produced 24 outputs with 8 errors at 55309 cycles; C11308 and C11309 still produced zero outputs and timed out; C11310 still passed its 72-band check. Therefore the `I_rst_dup_*` forcing was a real fixture defect, but it is not sufficient to explain the observed routed failures.

## `startup_flags[1]_dup_*` Boundary

The source-level meaning is reset: `top_tf_hdmi_audio.v:558` connects `startup_flags` as `{sys_pll_lock,video_pll_lock,rst_all,card_init_done}`, so bit 1 is `rst_all`; `rst_all` is assigned from `rst_all_reg` at line 182. That register holds reset while PLL locks settle and the 20-bit counter advances to 1,000,000 cycles (lines 159-178), so the FFT TB's external fast reset intentionally skips the full board startup interval.

The routed names are not all literal pass-through wires. For example, C11308 `startup_flags[1]_dup_4401` is an FF Q output from `rst_all_reg_reg_syn_517` at routed netlist line 11740, clocked from `clk_dup_1` and fed by `rst_all_reg_reg_syn_3`; the FFT analyzer consumes it as `.sr` at line 10239. This is consistent with a registered fanout copy of the reset state, but the accelerated TB boundary collapses that release timing to its external `rst`. The current evidence does not show that this abstraction caused C11307's 8-value error or C11308/09's zero outputs. Keep it as a startup-timing assumption to verify if exact reset-release behavior becomes part of the test objective; do not infer a board root cause from it.

## Scope

This was a read-only audit of the archived routed netlists, extracted cones, manifests and extractor logic. No producer RTL, archived netlist, extractor or simulation result was changed by this audit. The FFT tests remain controlled functional cones with accelerated PCM and no SDF/full system startup; they do not establish a hardware cause.
