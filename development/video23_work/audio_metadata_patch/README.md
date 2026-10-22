# HDMI audio metadata patch prototype

This isolated raw-vector experiment inserts between the encrypted HDMI transmitter wrapper's parallel TMDS outputs and the PHY. Three 10-bit TMDS data words and the clock word share an eight-pixel-clock delay. Reset-fill uses the real core clock word `01F`, preventing a serial receiver from locking to a temporary `3E0` pattern.

The experiment can force Audio InfoFrame PB0 `70→61`, PB2 `00→0F`, and channel-status C bits 25/32/33/35 after a B marker, with corresponding P and BCH updates. The raw test uses synthetic status bytes and proves the packet transformation mechanics; its C vector does not represent the original core's complete steady-state channel-status block.

A later serial-pin review captured 192 frames from B0 on the original core and compared them with the patched output. Both carry L=`04 80 10 02 0B` and R=`04 80 20 02 0B`; Fs=48kHz and word length=24bit were already correct, V/U/C/P parity errors were zero, and patched channel status matched the baseline bit for bit. The earlier 191-frame window began before B0 and did not cover a complete status block. The original InfoFrame PB0/PB1/PB2 (`70/01/00`) also has a valid checksum; zero PB2 uses stream-based values in the existing format.

The raw-vector run still validates the isolated rewriter over 7,412 words: AIF checksum, sample payload preservation, video/control/ACR transparency, eight-clock delay, original BCH/TERC checker at 0/0, and detection of one deliberately corrupted parity bit. Run `./run_raw_tb.ps1` in PowerShell 7; output is in `raw_run.log`.

Keep the artifact for format experiments and later A/B work. Its metadata edits are unnecessary for the verified production stream, and the module has no TD build or board result. The full review and source-path findings are in `CORE_AUDIO_PATH_AUDIT.md`.
