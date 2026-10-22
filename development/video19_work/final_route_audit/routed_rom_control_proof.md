# C04 routed ROM control proof

**Result: PASS.** The actual routed pin mux and LUT cones produce the active-high RTL enable for all 32 states. The strict parameter report is retained separately from this functional truth proof.

The C04 implementation folds the former status snapshot away and maps the analyzer state to 17 routed state nets. The proof binds each `state_reg_syn_1[0..16]` lane to exactly one routed FF Q output. TD packs unrelated registers into MSLICE/LSLICE lanes, so some physical FF instance names follow the other packed register (for example `timeout_pulse_reg_syn_5` drives state-vector lane 2); the proof relies on actual Q-port connectivity, not instance-name similarity. It uses source `ST_WIN_REQ=1` and `ST_FFT_ISSUE=4` as the one-hot state indices, reads each coefficient BRAM control pin and mux, then evaluates all 32 RTL state values and every open/leaf input assignment. The strict parameter audit remains a separate bound artifact.

- routed/hann_high: cea=u_pcm_waveform/u_spectrum/state_reg_syn_1[1] with CEAMUX=SIG -> PASS
- routed/hann_low: cea=u_pcm_waveform/u_spectrum/state_reg_syn_1[1] with CEAMUX=SIG -> PASS
- routed/twiddle_high: csa[2]=u_pcm_waveform/u_spectrum/state_reg_syn_1[4] with CSA2=SIG -> PASS; csb[2]=u_pcm_waveform/u_spectrum/state_reg_syn_1[4] with CSB2=SIG -> PASS
- routed/twiddle_low: csa[2]=u_pcm_waveform/u_spectrum/state_reg_syn_1[4] with CSA2=SIG -> PASS; csb[2]=u_pcm_waveform/u_spectrum/state_reg_syn_1[4] with CSB2=SIG -> PASS

SHA-256 bindings are recorded in the JSON. Raw audit files and production RTL/netlists were not modified.
