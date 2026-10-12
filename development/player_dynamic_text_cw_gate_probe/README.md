# Bit17-focused ChipWatcher candidate C11105

This is an isolated diagnostic build. It is not an HDMI repair or a verified
board baseline. The board and AL-LINK are connected to the user's remote PC.

The prior C11102 attempts are retained under `build/preflight`: all 32 trigger
bits required 5079 MSlices; one trigger bit required 4989. The device limit is
4900. C11103 omitted only the passive `player_cadence_probe` instance. It retained
the original media/control paths, status counter/mailbox/received/display, and
the 32-bit captured bus. Its layouts fit but failed final setup timing. C11104
used 256 capture points and failed detailed routing. C11105 narrows only the
passive capture bus to the anomalous bit and its context (10 bits, 64 points).
The original counter/mailbox/received/display logic remains unchanged. Final
routing and setup/hold timing must pass before bit/CWC delivery.

Latest result (2026-10-11): all C11105 trials completed routing but failed
final timing. High/routability after hold: SWNS -0.102, HWNS -0.062 ns.
Seed 1 / timing: SWNS -0.192, HWNS -0.002 ns. A floating 10x10 bound
on the added debug hub improved setup to -0.044 ns, but after hold HWNS
remained -0.089 ns. No bit/CWC pair was generated or delivered. Full attempts
are preserved under `build/preflight/C11105_*`. A separate LED observation
candidate is being prepared without ChipWatcher; it has not been verified.

Pages 6 through B display unavailable markers (`6FFFFFFF` through `BFFFFFFF`),
not measurements. Page C displays `CFC11105`. Pages 1 and 3 retain their original
status meanings. The original cadence build and its measurements remain archived.

## Captured bus

| Bits | Signal |
| --- | --- |
| 9 | tone_mode |
| 8:5 | internal page (1 corresponds to display page 3) |
| 4 | request_toggle (the only trigger-enabled bit) |
| 3 | hex_value[17] |
| 2 | received[17] |
| 1 | mailbox[17] |
| 0 | audio_count[17] |

Capture clock: video/pixel clock rising edge, nominal 25 MHz. Depth: 64 (2.56 us).
This capture identifies the bit's first observed stage, not a numeric sample
count or an audio pulse cadence. Page context is essential: the unavailable
markers and build ID can legitimately have hex_value[17] set outside page 3.
Display/received logic updates on the falling edge. Interpret edge transitions
with that half-cycle relationship; captured fields are not a generic atomic
snapshot of unrelated clock domains. Debug insertion changes physical layout,
so this candidate cannot prove the exact internal state of the earlier bitstream.

## Build entry point

Use `scripts/build_candidate.ps1 -Stage synthesis`, then `physical`, optional
`hold`, and `bitstream`. The wrapper binds sources, configuration, scripts,
gate/route databases, and reports to stage evidence. Bit generation requires
nonnegative setup/hold status. Matching CWC is exported from the generated bit
using `setup_debugger -bit` followed by `export_chipwatcher -add_bid`.
Do not distribute files from a failed or uncertified stage.
