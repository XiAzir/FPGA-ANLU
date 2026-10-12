# C11106 bit17 active-low LED probe

This isolated candidate adds a lightweight observer to the C11105 source. It is
intended to help collect board evidence for the bit17 path; it has not been
tested on the board and does not establish or repair the root cause.
The original player, audio/mode behavior, and the status monitor's three
sequential blocks are retained. `cw_count_data[9:0]` remains available as a
passive signal, and no ChipWatcher is inserted.

## LED interpretation

The four flags are sticky while tone mode is active. The external LEDs are
active-low, so a latched flag lights its corresponding LED:

| LED | `cw_count_data` bit | Observation |
| --- | ---: | --- |
| `led[0]` | 0 | `audio_count[17]` |
| `led[1]` | 1 | `mailbox[17]` |
| `led[2]` | 2 | `received[17]` |
| `led[3]` | 3 | `hex_value[17]`, recorded only when `cw_count_data[8:5] == 1` |

Internal page 1 displays the original page label 3. The hex LED therefore
records `hex_value[17]` only while that page is selected. Reset or returning
to WAV mode clears all four flags; WAV mode never latches observations.

For a board observation, use the existing long KEY1 gesture to switch to tone
mode, then wait until the display reaches label 3 and leave it there for at
least one page interval. The monitor advances pages every 2 seconds after its
startup self-test. A lit LED proves that its sampled bit was high at least once
under the stated mode/page condition; it does not prove event timing or the
underlying root cause.

## Verification and build flow

The small Icarus model is in `build/model/tb_player_bit17_led_probe.sv`; the
simulation transcript is `build/model/model.log`. To rerun it, invoke the
workspace Icarus `iverilog.exe` and `vvp.exe` with the observer and testbench.

The staged TD Tcl scripts are in `scripts/`: synthesis, normal place/route,
post-route `fix_hold`, and bit generation. They retain the existing SDC and pin
constraints. The physical stage uses timing-oriented placement effort `high` and route
effort `routability`, with seed disabled; it does not insert a debugger or placement
bound. The bit stage only writes
`AC201_player_dynamic_text_bit17_led_probe.bit`; it exports no CWC.

The current TD stage status is recorded under `build/manual/stage_evidence/`;
consult its `latest_*.json` pointer before using any generated artifact. The first synthesis was rejected by the input-hash guard because TD normalized the project .al bytes (script hashes remained unchanged). Its uncertified artifacts are archived. Synthesis was rerun from normalized, frozen inputs and certified successfully. The first complete high/timing route failed with SWNS -0.287ns and HWNS -0.011ns, predominantly SDRAM tristate-output setup paths; the full attempt is archived in build/preflight/C11106_high_timing. A second strategy uses the previously applied timing-placement settings and route routability; it completed route and official hold repair. Final SWNS +0.621ns, STNS 0, HWNS +0.030ns, HTNS 0, coverage 99.97%. Bitstream generation and stage input/artifact hashes passed. The candidate has not been tested on the board. Original timing constraints are retained.



C11106 bit SHA256: 62749e0485a34671d6fdf3b761b00da17981768084482bef7942f0c38a5dadb5. LED D3 is a page-gated observation of the same received bit as D2 on page label 3; it is not proof of the external 595 or physical display. Only long-press board KEY1, without KEY0, then keep tone mode for at least 25 seconds. Default WAV LEDs are off; D3 no longer blinks.

