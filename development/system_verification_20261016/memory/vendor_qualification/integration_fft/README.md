# Full-top FFT passive scoreboard

This directory contains a passive observation module, a small include snippet for the existing full-top `tb_system`, and a Python post-processor that reuses the C11310 candidate's independent fixed-point FFT oracle. It does not modify any production, frozen, archived, or parent integration files.

## Confirmed signal path

The current fulltop instance is `tb_system.dut` (`top_tf_hdmi_audio`). Its PCM bus enters `dut.u_pcm_waveform`; the analyzer is `dut.u_pcm_waveform.u_spectrum` (`player_spectrum_analyzer`). The analyzer input is signed `dut.audio_left_data[23:8]`. `state==5'd0` is `ST_CAPTURE`; the exact internal write enable is `sample_write_en`, which additionally gates reset, source-change, and timeout. The include snippet observes both the raw capture condition and the actual write-enable, and fatals if a sample write occurs outside `ST_CAPTURE && audio_valid`. It observes the actual analyzer `band_valid`, `band_index`, `band_value`, and `frame_done` outputs.

`fft_passive_observer.v` buffers exactly 1,024 accepted PCM samples and writes them to `fft_samples.csv` when that frame successfully emits all 24 ordered bands. It writes actual band outputs to `fft_bands.csv`. Unknown controls/data, unexpected index order, incomplete 24-band output, zero frames, partial trailing captures, or resets after observation begins are fatal. Aborted captures are discarded and counted.

## Hook into the existing testbench

1. Add `fft_passive_observer.v` to the simulation compile sources.
2. Include `tb_system_fft_observer.vh` inside `tb_system` after the instance named `dut` and its signal declarations.
3. In the existing system success branch, call `u_fft_observer.finish_check;` before `$finish`. Keep the existing startup, media, and pixel checks unchanged.
4. Run ModelSim from the per-run working directory so the observer creates `fft_samples.csv` and `fft_bands.csv` there. Keep `wave_samples.mem` in that directory.
5. After ModelSim closes, call the Python function or CLI shown below. Require its exit code 0 and `status=PASS` before considering FFT checked.

The instance snippet uses exact names from `development/player_spectrum_fft_recover/src/user_source/hdl_source/top_tf_hdmi_audio.v` and `player_pcm_waveform.v`. If a C11309/C11310 checkpoint changes these names, update only the testbench include hookup after inspecting that checkpoint's top and analyzer source; do not alter the DUT to expose new debug ports.

## Independent Python check

The post-processor imports `development/player_spectrum_fft_recover/checkpoints/music_spectrum_fft_recover_20261014_candidate/sim/spectrum_oracle.py`; it does not copy or restate the RTL FFT equations. The oracle computes a symmetric Q1.15 Hann window, a scaled radix-2 fixed-point FFT, then the 24 half-open band maxima. Before checking output, it verifies the oracle's Hann and twiddle ROMs against its independent generation formulas. It also checks each accepted frame against the exact looping PCM window in `card/wave_samples.mem`, requires all 1,024 samples and 24 bands, and compares every observed band exactly to the fixed-point oracle. A direct-DFT bound (max absolute band difference ≤16) is retained as a separate mathematical sanity check.

From the per-run directory:

```powershell
python E:\VSCODE-project\FPGA-ANLU\development\system_verification_20261016\memory\vendor_qualification\integration_fft\postprocess_fft.py `
  --samples fft_samples.csv --bands fft_bands.csv --source wave_samples.mem `
  --report fft_postprocess.json
```

The importable runner API is `postprocess_fft(samples_csv, bands_csv, source_mem, oracle_path, report_path, expected_frames)`. Missing files, empty files, zero frames, unknown values, partial/misordered samples or bands, source PCM mismatch, wrong expected-frame count, or any exact band mismatch return a failure and a nonzero CLI exit.

## Validation and limits

`selftest_postprocess_fft.py` creates two complete real-window fixture frames using the imported oracle and passes them through the same checker. It also proves rejection of zero frames, unknown PCM, a corrupted band, missing input, and a frame-count mismatch. This validates the observer post-processing and guards without launching a long full-top simulation.

The oracle is an independent implementation of the published fixed-point contract already used by C11310 FFT unit regressions. Its ROM check ties the formula to the candidate's coefficient files; the prior C11310 unit regression supplies evidence that this oracle matches that candidate's 24-band outputs. It is not a second implementation of the hardware or proof that other coefficient revisions are unchanged. The end-to-end checker verifies the actual sampled PCM and actual band outputs observed in the integrated simulator run. It does not validate physical SDRAM behavior, PLL hardware, or HDMI electrical operation.
