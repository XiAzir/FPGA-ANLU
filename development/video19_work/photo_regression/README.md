# Photo Regression

`run_photo_system.py` runs the established C11309 full-system photo, PCM and FFT golden against the current `player_video19` candidate. It parses `src/td_project/AC201_tf_hdmi.al`, freezes the selected live RTL under a timestamped run directory, and applies only the old ModelSim declaration/FIFO-count compatibility copies used by the video-system runner.

The run reuses `system_verification_20261016/integration/run_C11309_20261016_181233/tb_system.v`, `prepare_golden.py`, `verify_fft_trace.py`, and the independent `spectrum_oracle.py`. It uses the archived 64 MiB FAT32 fixture containing a 16x16 PIC.BMP and a 4096-sample PCM window. The run-local testbench addition asserts that `video_mode_press`, `video_mode`, and `video_mode_sd` stay low; key1/key2 remain inactive, and photo framebuffer RGB888 remains selected.

Run the full regression with:

```powershell
python development/video19_work/photo_regression/run_photo_system.py
```

To rerun the FFT oracle against a preserved trace without launching ModelSim:

```powershell
python development/video19_work/photo_regression/run_photo_system.py --fft-only development/video19_work/photo_regression/runs/photo_system_20261021_182337
```

The 2026-10-21 run passed at `runs/photo_system_20261021_182337/`: 307200 BMP pixels written and read back exactly, 6378 PCM pushes and 4447 exact sample consumes, three complete FFT frames and 72 bands matching the fixed-point oracle with zero error. It used qualified nominal PLL edge replay and the application-interface SDRAM model. Physical SDRAM timing, SDF and board behavior remain outside this regression.
