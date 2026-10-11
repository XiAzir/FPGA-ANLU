# FAT32 status diagnostic (not a repair)

Isolated from the failed keepaudio build. Default WAV, KEY0 manual next image,
short KEY1 automatic slideshow, long KEY1 (>=1.5s) internal tone remain unchanged.
After long KEY1, release for >=1.5s before another source toggle. D3 blink indicates tone mode.

Adds passive monitors and AC201 serial 595 display on known board_test pins:
DIO R14, RCLK R12, SCLK T14. Playback modules/IP/PLLs unchanged; SDC unchanged.
Final observer/display uses the existing 25MHz pixel clock, with its own reset release independent of playback reset. If the pixel clock stops, the display also stops; D3 blink previously proved this clock was running in the reported fault.
Instrumentation can change implementation and routing. Results apply to this build;
they cannot be taken as a captured waveform of the old failing bitstream.

## Reading the display

First 2s: 01234567 (check direction and all eight positions).
Next 2s: 88888888. Then five pages rotate every 2s. All values are hexadecimal.
A,b,C,d,E,F are hex digits; decimal points are off.

Page 1: 1 K FF EE WW
- K four bits [sys PLL locked, video PLL locked, playback reset, SD initialized].
  D means locks=1, reset=0, SD=1. E means both locks=1, reset=1, SD=0.
- FF eight bits [FAT ready, FAT error, display frame committed, BMP error,
  WAV primed, WAV error, BMP mapper error, WAV mapper error]. Healthy ongoing playback is A8.
- EE FAT catalog error code; WW WAV mapper error code. Zero means no recorded error.
  These independent slow flags are synchronized individually, not an atomic FSM dump.

Pages 2-5: P M CCCCCC
- P is page number. M four bits [tone selected, underflow sticky, HDMI O_video_locked,
  input frame start observed]. M is a snapshot, not an HDMI protocol assertion.
- Page2 C: nonblack pixels in the last completed frame presented to HDMI AXIS input.
- Page3 C: number of audio_valid samples presented to HDMI input in a nominal one-second window.
  Expected 00BB80 (48000) for either WAV or tone if the pixel clock is truly 25MHz.
- Page4 C: number of valid PCM samples different from the preceding valid sample;
  the first sample can be compared with the previous window's final sample.
  Constant/DC/silence produces zero; scale should produce changing positive values.
- Page5 C: number of valid pixels in the last complete frame presented to HDMI AXIS input.
  Expected 04B000 (307200) for 640x480. Does not assert receiver acceptance or packet validity.

Pixel counters use an acknowledged, held 92-bit snapshot to the falling-edge pixel-clock display logic.
During normal operation without reset, all 92 bits remain stable until the receiver accepts them.
Reset cancels pending snapshots. One-second period is based
on nominal clock constants, not a physical oscillator measurement. Counters/pages are passive;
no TF writes, Flash programming or assistant hardware operation.

## Validation

RTL tests: exact five-page observations, source audio sample/change counts, black/nonblack frames,
and continuing startup display while playback is reset. External 595 shift/latch model verifies
16 shifts per latch, blanking before selection, onehot digit select, 0-F segment patterns and refresh.
See build/status_monitor_sim and build/status_hex_sim. No real HDMI/SDRAM model is included.

First implementation (no extra status BUFG) failed setup/hold. Reports and routed DB kept under
build/attempt_initial; no bitstream generated from that revision. Added BUFG for the new observer
clock only; playback clocks unchanged. The BUFG revision still had hold-1.539ns, archived in build/attempt_status_bufg. The opposite-edge reference-clock observer removed the large hold violations, but SRAM setup still failed (SWNS -0.790ns); saved in build/attempt_status_negedge. TD post-route phys_opt crashed (optimize_console.log and minidump); no bitstream generated. Final low-impact observer uses the existing pixel clock on opposite edges and a 25MHz segment driver. No false-path or relaxed clock constraints added. Current TD result recorded separately when complete.

## Final candidate (2026-10-08; hardware pending)

The pixel-clock observer revision passed synthesis and place/route. Initial hold slack
was -0.020ns (HTNS -0.037ns), archived in build/attempt_pixel_prehold.
With the original SDC and standard fix_hold, final SWNS is 0.253ns, HWNS 0.024ns,
both TNS zero; STA coverage 99.97%. These are checks of analyzed internal paths;
the board IO-delay and external HDMI electrical/protocol limitations remain.
Resources: 16533 LUT, 7912 registers, 17907 LE, 19 BRAM9K, zero DSP.
The bitstream was generated only after nonnegative final setup/hold status.

Download file: build/manual/AC201_player_fat32_status_diag.bit.
Exact byte count, SHA256 and source hashes are in the adjacent .info.json.
Checkpoint: checkpoints/status_diag_20261008_candidate, with per-file manifest.
Both monitor and external 595 model tests passed. The playback path is not fully
simulated here. No hardware result has been obtained; this is not a verified repair.

Board observation: keep the same TF, power, HDMI and volume; PROGRAM_SRAM load
this candidate. After the four-second digit self-test, wait ten seconds and record
the five complete eight-character pages (or a clear video covering a full cycle),
plus whether image/audio are normal. Then hold KEY1 for about two seconds until
D3 blinks, release, wait several seconds and record pages 3/4 and audio behavior.
The five pages start with digits 1 through 5; do not interpret b/d as decimal digits.

Rollback: ../player_fat32_audio_probe/build/manual/AC201_player_fat32_audio_probe.bit
SHA256: 4FC48C6678758FC1B74BD0BB9D9DA4FDD6132198BB1AEE8C294C6340EA81CF8C.




## Subsequent hardware observation (2026-10-08)

The default-WAV board video was decoded after a 90-degree CCW rotation. Pages:
1DA80000, 2304B000, 3300BB80, 43008Cxx, 5304B000. Default M=3:
tone not selected, no bridge underflow flag, HDMI video locked, input frame seen.
Input audio valid events: 48000 per nominal second; valid/nonblack pixels: 307200
per complete frame. PCM changes around 359xx are consistent with canonical
TEST.WAV (750ms note plus 250ms silence). Counts do not establish exact PCM values,
order, HDMI packet correctness or external TMDS.

User reports correct images, cyclic scale with hiss in default WAV, and hiss
persists after the requested long KEY1 toggle. Tone-mode page values were not
provided. Audio repair remains unresolved. The next observation is a full display
cycle while D3 blinks in tone mode, without changing/reloading the implementation.
Video metadata, CCW frames, contacts, crops, observations.json and the canonical
PCM audit are saved in build/board_video_20261008. Original recording is archived
in the materials FAT32 topic under 2026-10-08/status_diag_default_wav.mp4.
Live .info.json reflects hardware findings; the candidate checkpoint retains its
original build-time hardware-pending metadata. No new source/build/TF/Flash change.


## Internal tone video observation (2026-10-08)

Second video confirms mode B, 48000 valid samples per nominal second and 307200
valid/nonblack pixels per complete frame. Change counts 679/832/1017/555 match
the independent sample-domain DDS model in build/tone_video_20261008.
User still reports hiss. Input counts do not prove sample amplitude/order or
HDMI packet/PHY correctness. Startup self test is visible; the two videos are
not established to be the same uninterrupted run. Candidate checkpoint metadata
is historical and remains unchanged. Output-packet monitoring is now being
implemented separately in ../player_fat32_packet_diag; this bitstream is unchanged.
