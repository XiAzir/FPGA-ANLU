# C35/C36 mapped-netlist TMDS pin recovery

This fixture replays the independent C35/C36 post-synthesis mapped gate netlists with the original official TD6.2.1 SP1 EG4 functional primitive models. It samples all four output pins on both edges of the serializer clock, aligns ten-bit words to the clock lane, then independently decodes control symbols, TERC4 packet islands, video guard bands and RGB pixels.

## Inputs and model isolation

- `run.ps1` selects the candidate's original `*_gate.v`, copies it with only `top` renamed to `hdmi_diag_gate`, and records SHA256 plus exact normalized-text equality in `C35_binding.json` or `C36_binding.json`.
- Each candidate uses a fresh local logical `work` mapping and directly compiles official primitive source files. Earlier use of an old shared `EG4` alias loaded another project's `top`; that setup was rejected before simulation. A separate attempt failed because `AL_MAP_SEQ` had no default timescale; explicit `vlog -timescale 1ns/1ps` fixes compilation without modifying vendor sources.
- The testbench forces only `startup_count=999999` and releases reset after2us to shorten the diagnostic's approximately30ms startup timer. HDMI kernel, PLL, serializer and pad logic remain as generated. Startup effects are retained in the stream and reported separately.
- These are functional gate models with no routed SDF, physical board skew/jitter or HDMI receiver. The timer acceleration also excludes the real startup wait from the test.

## C35 results

Command:

```powershell
./development/video33_work/protocol_gate/run.ps1 -Version 35 -Words 1200000
python development/video33_work/protocol_gate/analyze_words.py 35
```

Simulation wall time443.31s, sampled model-process working set about153.4MiB. All simulator processes exited after this run.

| Observation | Value |
| --- | --- |
| Recovered words | 1,200,000 |
| First internal input-lock word | 550,001 |
| Words with internal input lock | 650,000 |
| Unknown data words | 0 |
| Complete video lines after lock | 580, each640 pixels |
| Video frame groups | Complete480-line frame, followed by100 visible lines of next frame |
| Video frame-start distance | 550,000 words = 1000×550 |
| H periods after lock | 649 periods, all1000 words |
| HSync low width after lock | 96 words |
| VSync low width after lock | 2000 words = 2 rows |
| Data-island payload lengths | 96 symbols, three32-symbol packets |
| RGB pixels compared | 371,200 |
| RGB differences | 7, all in first locked line at the seven bar boundaries |
| RGB differences in later lines | 0 |

The result is `DIGITAL_TIMING_PASS_STARTUP_RGB_DIFFERENCE`. The first-line difference is preserved and remains unclosed; it has not been assigned to hardware or used to change production RTL. Initial pre-lock H/V intervals are retained in the JSON and are excluded only from the separately named locked timing statistics.

The20k and100k exploratory captures ended before internal input lock, so they provide no locked RGB/frame validation.

## Decoder negative control

```powershell
python development/video33_work/protocol_gate/analyze_words.py 35 --flip-bit-word 555065
```

The independent reader flips lane0 bit0 at one later locked pixel. The original captured stream is preserved. The checker reports the existing7 first-line differences plus exactly1 later-line RGB error and changes status to `CAPTURE_REQUIRES_REVIEW`; see `C35_analysis_negative.json`.

## C36 current scope

The100k original stream and log were copied to `C36_100k_prelock_*`. A2.4M-word replay is running in the sole heavy-task window; results are pending. Given a2.2M-word frame, this window may contain only the start of the first locked video frame. The absence of two locked video-frame starts will be reported as limited coverage rather than a validated frame period.

C36 horizontal blanking is80 pixels. C35's observed96-symbol island payload is a scheduling clue to compare against the C36 stream; no conflict or root cause is claimed until the actual C36 output has been decoded.
