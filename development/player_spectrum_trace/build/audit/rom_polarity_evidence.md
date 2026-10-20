# C11312 ROM polarity evidence

**Result: PASS.** The inverted mux settings compensate for the active-high RTL enables in all four gate/routed BRAM instances. The original raw parameter audits remain unchanged and still show only the specified polarity differences.

The script verifies the RTL state constants and enable expressions, confirms the state FF Qs drive `debug_progress[19:23]`, reads each coefficient BRAM instance's actual control port and mux parameter, validates the exact raw mismatch allowlist, then enumerates all 32 state values and every open/leaf input assignment.

- gate/hann_high: cea=u_pcm_waveform/u_spectrum/eq15_syn_33 with CEAMUX=INV -> PASS
- gate/hann_low: cea=u_pcm_waveform/u_spectrum/eq15_syn_33 with CEAMUX=INV -> PASS
- gate/twiddle_high: csa[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSA2=INV -> PASS; csb[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSB2=INV -> PASS
- gate/twiddle_low: csa[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSA2=INV -> PASS; csb[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSB2=INV -> PASS
- routed/hann_high: cea=u_pcm_waveform/u_spectrum/eq15_syn_33 with CEAMUX=INV -> PASS
- routed/hann_low: cea=u_pcm_waveform/u_spectrum/eq15_syn_33 with CEAMUX=INV -> PASS
- routed/twiddle_high: csa[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSA2=INV -> PASS; csb[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSB2=INV -> PASS
- routed/twiddle_low: csa[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSA2=INV -> PASS; csb[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSB2=INV -> PASS

SHA-256 bindings are recorded in the JSON. Raw audit files and production RTL/netlists were not modified.
