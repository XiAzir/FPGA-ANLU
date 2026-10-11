# Autoplay with dynamic audio retained

2026-10-08. Isolated copy of the verified audio_probe checkpoint. Not hardware verified.

Only functional-source changes: top key_auto ties to key2; the existing pixel-domain tone key threshold changes from50ms to1500ms. Tone selector, waveform generator, WAV bridge, ACR and LED observers remain reachable and unchanged. This is a control experiment after fixed-WAV autoplay produced severe noise; preserving circuitry does not prove a physical root cause.

KEY0: manual next image.
KEY1 short press (50ms to less than1.5s): toggle autoplay; WAV continues.
KEY1 hold at least1.5s: diagnostic audio source toggle. A long press also triggers the normal autoplay toggle at50ms; allow at least1.5s release afterward for the diagnostic key to rearm.
Default WAV: D3/D2/D1/D0 are sticky FIFO/sample/varied PCM/ACR observations.
Internal tone: D3 blinks; D2/D1/D0 valid/nonzero/ACR observations.

Expected file: build/manual/AC201_player_fat32_autoplay_keepaudio.bit.
Same original card/power/HDMI and PROGRAM_SRAM. First test default WAV, KEY0 and short KEY1 auto on/off without long-press. If the WAV is still noisy, diagnostic long KEY1 can compare internal tone on the same bitstream.
Rollback: E:/VSCODE-project/FPGA-ANLU/development/player_fat32_audio_probe/build/manual/AC201_player_fat32_audio_probe.bit.
No TF writes, Flash programming, segment driver or assistant board operation.

## Build complete 2026-10-08 16:35:15 (Beijing), hardware pending

629624 bytes, SHA256 30BA033E29F0AFEBF2C3FC3FCE1633A4B3927AAF94F06C7B2E6E55653EA551A0.
TD synthesis/place/route/bitgen complete; original-constraint fix_hold clears initial HWNS-0.002/HTNS-0.002ns. Final SWNS0.394/HWNS0.027/STNS0/HTNS0ns; STA coverage99.99%.
Final resources:16116LUT/7403registers/17532LE/19BRAM9K/0DSP.
Gate area confirms u_audio_probe/u_tone remains reachable. Existing player_audio_probe/bridge/ACR source identical to verified audio_probe. New scaled-time key test passes short/long threshold, single toggle while held, release rearm and WAV return; no actual HDMI/SDRAM/card test represented by this PASS.
This build is a diagnostic candidate, not a confirmed audio repair. No TF/Flash write or assistant hardware operation.

## Hardware regression 2026-10-08 16:49:09 (Beijing)
User reports HDMI detected/backlit black picture, a single trembling tone, no visible response to short KEY0/KEY1 or audible change on long KEY1. This candidate failed; do not use as a successful baseline. Same-condition verified audio_probe rollback and LED observations requested, pending. Cause is not established. Candidate checkpoint preserved unchanged.


2026-10-08 17:07:40: same-condition rollback to verified audio_probe restores all tested functions. Failed keepaudio has all four LEDs on; long KEY1 causes D3 blink while sound remains unchanged. Tone selector control is active; no visible/audible response does not establish dead keys. Passive status-display diagnostic is being prepared separately.

