# FAT32 autoplay restoration

2026-10-08. Isolated copy of player_fat32_audio_probe/checkpoints/audio_probe_20261008_verified. This new bitstream is not yet hardware verified.

KEY0: manually select the next picture.
KEY1: enable/disable automatic picture switching.
Audio: default WAV path, continuing during picture switching. KEY1 no longer selects the internal tone in this build.
LED: same WAV event observations as the verified audio probe: D3 FIFO nonzero; D2 sample consumed; D1 HDMI PCM varied; D0 expected ACR occurred. These are sticky events, not continuous playback proof.

Changes to functional HDL: top only. Restore image key_auto to key2; disconnect the diagnostic tone-toggle key and tie tone_toggle inactive. Keep player_audio_probe, WAV parser/FIFO/bridge/ACR, image/frame-buffer, SD/HDMI/IP/PLL/pins/SDC source unchanged. Synthesis may prune unreachable tone circuitry and will reroute the design, so unchanged source modules do not imply identical physical placement/routing.

Expected output: build/manual/AC201_player_fat32_autoplay.bit. Use PROGRAM_SRAM after successful build/timing review. Keep the original card and wiring. Verify image/colors and WAV playback, KEY0 manual switch, then KEY1 auto on/off while WAV continues; record LEDs and any display/audio regression.

Rollback: E:/VSCODE-project/FPGA-ANLU/development/player_fat32_audio_probe/build/manual/AC201_player_fat32_audio_probe.bit (basic picture/WAV/internal tone passed by user feedback; KEY1 there changes audio source).
Earlier stable fallback: E:/VSCODE-project/FPGA-ANLU/development/player_480p/build/manual/AC201_tf_hdmi_data_d1.bit.

No TF writes, Flash programming, or assistant hardware operation. Numeric display is not connected in this step. Previous failed revisions' root cause remains unresolved.

## Build completed 2026-10-08 16:15:58 (Beijing)

Bitstream: build/manual/AC201_player_fat32_autoplay.bit; 629624 bytes; SHA256 A917B200BE2D058FB88AC7732FD0772800360F7CAC3B24CC6011F7211DAD4912.
TD synthesis/place/route/bitgen completed. Initial routed hold SWNS0.384/STNS0/HWNS-0.012/HTNS-0.027ns is preserved in build/attempt_hold_violation. Original-constraint fix_hold gives final SWNS0.384/STNS0/HWNS0.038/HTNS0ns; STA coverage99.99%.
Final resources: 15713 LUT / 7250 registers / 17058 LE / 19 BRAM9K / 0 DSP.
Existing autoplay/manual/WAV model checks pass in both fast-card and SPI12.5MHz-paced 16x64 scenarios, with three exact frames and4600 exact ordered PCM samples in each. These checks do not simulate encrypted HDMI/SDRAM or the actual top's physical implementation.
The earlier encrypted SDRAM warnings, relocation warnings and uncharacterized IO-delay limits remain. This build is pending hardware verification.

Use the same PROGRAM_SRAM flow. After loading wait for the first image and WAV, try KEY0, press KEY1 to start the four-picture cycle, then press KEY1 again to stop. Listen for uninterrupted WAV during switching. WAV LED events should eventually illuminate all four lights; no internal-tone mode/blinking is assigned to KEY1 here.
