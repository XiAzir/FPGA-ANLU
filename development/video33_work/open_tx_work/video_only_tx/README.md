# Video-only parallel-TMDS short-blank experiment

This directory is an isolated RTL candidate for the AC601 + AC201 EG4 HDMI path. It emits RGB888 video, AVI/VIC0, SPD and NULL data-island packets as three parallel 10-bit TMDS words plus a fixed TMDS clock word. It has no audio input, sample-clock input, serializer, board wrapper or production-source edits.

## Supported timing configurations

| Candidate | Pixel rate | Horizontal timing | Vertical timing | Sync polarity | AVI VIC |
|---|---:|---|---|---|---:|
| C35 | 33 MHz | 640 + 16 + 96 + 248 = 1000 | 480 + 10 + 2 + 58 = 550 | negative / negative | 0 |
| C36 | 33 MHz | 1920 + 8 + 8 + 64 = 2000 | 1080 + 4 + 5 + 11 = 1100 | negative / negative | 0 |

The module parameters default to C36; instantiate C35 by overriding its timing parameters with the row above. The output counter widths use `$clog2(H_TOTAL)` and `$clog2(V_TOTAL)`, while `cx/cy` remain zero-extended 16-bit request coordinates. Only these two measured geometries are in scope. The scheduler deliberately emits exactly one packet on each line: C36's 80-clock blank satisfies `floor((80 - 30) / 32) = 1`, while C35's 360-clock blank also fits at least one packet.

## Interfaces and timing

`cx/cy/active` identify the RGB request for the current pixel-clock interval. The caller supplies the matching RGB888 value before the next rising edge. The registered TMDS channel words after that edge encode that requested pixel, so the stream has the encoder's one-edge output latency. No ready, timeout, retry, fallback or generated sampling clock is present. `clockword` is `10'b0000011111`, matching the current PHY bit order.

The startup counter begins at `(H_TOTAL-32, V_TOTAL-1)`. It outputs 22 control symbols, an 8-symbol video preamble and a 2-symbol video guard band before reaching `(0,0)`. This gives the first active pixel the same preamble/guard sequence checked on later line starts.

After the 32-symbol startup pre-roll, every line has one data island at `cx=H_ACTIVE+14`: 8-symbol DI preamble, 2-symbol leading guard, 32 packet symbols, 2-symbol trailing guard. The remaining clocks provide the control interval and line-ending video preamble/guard where required. Channel 0 carries `{cx_nonzero, packet_bit0, vsync, hsync}` during TERC4, preserving the sync state through the island even when the pulse overlaps the preamble or packet.

Packet choice is fixed by line: AVI InfoFrame on line 0, SPD InfoFrame on line 1, and NULL packets on the other lines. AVI VIC is zero. The local SPD payload uses vendor `FPGAANLU`, product `VIDEO ONLY TX`, source-device code zero, length 25, and a computed InfoFrame checksum. All packets include upstream BCH ECC calculation order. This verifies packet framing and metadata bytes; it makes no audio support claim.

## Upstream sources and local fork

Pinned upstream: [hdl-util/hdmi commit `83b1c9543a91b776671a44e68e130f81cae437b7`](https://github.com/hdl-util/hdmi/tree/83b1c9543a91b776671a44e68e130f81cae437b7). Only the three sources used for the encoder, AVI generation, and packet ECC basis are included under `upstream/src/`; the MIT license file is copied from this commit, and the canonical Apache 2.0 text is included under `upstream/LICENSE-APACHE-2.0.txt`. The upstream README identifies the project as dual-licensed MIT OR Apache-2.0.

- `upstream/src/tmds_channel.sv`: upstream TMDS video/control/TERC4/guard-band encoder, used without logic edits.
- `upstream/src/auxiliary_video_information_info_frame.sv`: upstream AVI/VIC0 generator, used without logic edits. The source viewer omitted one `//` prefix in a wrapped long comment; the comment marker was restored in the local copy so the file remains valid SystemVerilog.
- `upstream/src/packet_assembler.sv`: upstream reference retained unchanged. Icarus 12 rejects its unpacked-array assignment patterns, so the exercised fork is `rtl/packet_assembler_compat.sv`. The fork scalarizes the five ECC state bytes and preserves the upstream BCH polynomial, two-bit-per-symbol ordering, reset and 32-symbol counter behavior.
- SPD packet construction and fixed per-line packet selection are local code in `rtl/video_only_tmds_tx.sv`; no upstream SPD module is included.

The source commit, file URLs, local hashes and license provenance are recorded in `source-provenance.json`.

## Behavior-level verification

Run `pwsh -File .\tb\run_tb.ps1` from this directory. The test uses the exact C36 horizontal geometry and shortens vertical active/blank to 16 + 20 lines. It checks the reset startup preamble/guard, two full frame starts, 1920 decoded RGB pixels on every active row, packet lengths and all payload symbols, AVI/SPD/NULL headers and checksums, all five BCH ECC bytes, tail/leading guards, 8-symbol video preambles, H/V control and TERC4 sync bits, and the parallel clock word. A single-bit-corrupted TERC4 code is the negative control.

Latest run: see `results.json`. Icarus behavior-level simulation passed. No TD mapping, EG4 area/timing report, PHY integration build, bitstream or board run has been produced. The C33 display's persistent “input not supported” overlay and C35 first-lock row offset remain open system-level observations.
