# C11316 routed ROM control proof

**Result: PASS.** The actual routed pin mux and LUT cones produce the active-high RTL enable for all 32 states. The strict parameter report is retained verbatim; any SIG/INV differences are documented from the current routed netlist and are accepted only when the exhaustive effective-control proof passes.

The script verifies the RTL state constants and enable expressions, confirms the state FF Qs drive `debug_progress[19:23]`, reads each coefficient BRAM instance's actual control port and mux parameter, records strict SIG/INV differences without a mismatch whitelist, then enumerates all 32 state values and every open/leaf input assignment.

- routed/hann_high: cea=u_pcm_waveform/u_spectrum/eq15_syn_33 with CEAMUX=INV -> PASS
- routed/hann_low: cea=u_pcm_waveform/u_spectrum/eq15_syn_33 with CEAMUX=INV -> PASS
- routed/twiddle_high: csa[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSA2=INV -> PASS; csb[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSB2=INV -> PASS
- routed/twiddle_low: csa[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSA2=INV -> PASS; csb[2]=u_pcm_waveform/u_spectrum/eq16_syn_33 with CSB2=INV -> PASS

SHA-256 bindings are recorded in the JSON. Raw audit files and production RTL/netlists were not modified.
