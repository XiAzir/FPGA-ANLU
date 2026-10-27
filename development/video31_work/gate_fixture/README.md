# C29/C30 routed audio cone fixture — initial attempt

Date: 2026-10-23 (Asia/Shanghai)

## Inputs

- C29: `../player_video29_media_flow/verification/final_routed.v` (14,734,570 bytes)
- C30: `../player_video30_probe_prune/verification/final_routed.v` (13,721,791 bytes)
- ModelSim SE-64 10.1c: `E:/ModelsimSE/win64`; TD EG4 compiled library: `development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work`, mapped by `development/system_verification_20261016/hdmi/modelsim.ini`.

## Extraction and attempted run

`extract_audio_cone.py` currently selects primitive instances by final source comment for audio probe/output, tone, bridge, and ACR RTL. It produced C29 238 cells (including 51 probe, 88 tone, 70 bridge, 29 ACR) and C30 178 cells (1 output, 80 tone, 68 bridge, 29 ACR). The generated subset keeps the full top declaration prefix. `tb_cone_pair.v` supplies a 25 MHz clock, reset clones, and tone mode; the run used 50,010 cycles with `glbl` and `-novopt`.

The run reached 2.00038 ms, but its measured values are invalid as functional evidence: tone data showed Z, tone valid counts were 96 vs 290, and direct comparison mismatch count was 26,943. The source-comment subset omits drivers and mixed-slice cross-module dependencies. Do not interpret this as C29/C30 behavior or as a PASS/FAIL of either routed design.

An earlier full-top pair failed elaboration because the first vsim call did not search EG4; that attempt was stopped within seconds. The later cone run loaded EG4 and `glbl` successfully but exposed the incomplete extraction. ModelSim is no longer running.

## Next step

Replace source-comment selection with a per-port/per-bit backward driver closure. Include both halves of packed LSLICE/MSLICE outputs or recursively resolve each half. Cut at matched audio boundaries (`video_clk`/`sd_clk`, reset, tone toggle, sample data/available/primed/play enable), drive those boundaries identically, and compare tone PCM/valid plus HDMI ACR N/CTS and FIFO write-data bits. Keep the cone below 500 primitive instances and under 200 MB before simulation. Only call it a PASS after outputs are known, C29/C30 match, and the tone/ACR golden checks pass.

## Full-netlist fixture prepared (not yet run)

- `tb_full_pair.v` and `prepare_full_pair.ps1` use renamed C29/C30 top modules for a paired ModelSim run. The testbench applies a 25 MHz forced audio clock (`video_clk` for C29, `u_adjust_control/clk` for C30), holds unrelated top clock and SD activity still, sets tone mode, drives the audio reset aliases high then low, and compares audio valid/data and ACR N/CTS for 50,010 cycles.
- The prepared testbench has not been compiled or run. Wait for TD scheduling clearance before invoking it. The expected 96 valid samples and N=6144 are checks to assess during the authorized run, not recorded results.

## Strengthened full-netlist checks (prepared, not run)

The full-pair bench releases reset on a falling audio-clock edge after four rising edges and samples only on falling edges. It checks X/Z across valid, PCM, and ACR N/CTS using reduction-XOR, checks the first valid PCM sample is zero and subsequent valid samples are exactly ±1,000,000, requires 90–100 valid samples per image and at least one ACR N=6144 pulse per image, and compares all selected C29/C30 outputs. Every failure uses `$fatal`; success emits only the unique `FULL_PAIR_PASS` token.

`prepare_full_pair.ps1` has been executed to create full top copies and `input_binding_receipt.json`. The receipt binds source/copy SHA256 and byte counts, confirms each copy normalizes byte-for-byte to its source after reversing the sole module-name change, and binds the testbench SHA. Both PowerShell scripts pass parser validation. The ModelSim compile/simulation script `run.ps1` is ready but has not been executed; wait for TD clearance.

## First full-netlist run — ABORTED_HOST_MEMORY_PRESSURE, no PASS

After TD scheduling clearance, full C29/C30 Verilog netlists compiled in Verilog mode, then the SystemVerilog testbench compiled. The first attempt with `-sv` on the netlists failed because the routed EG4 pad port `.do` is a SystemVerilog keyword; that compile failure is preserved as `full_compile_sv_failed.log`. The corrected split-language compile passed.

The full pair started, but the host reached 93% RAM use with 0.914 GiB available while `vsimk` used about 2.46 GiB. The orchestrator stopped this fixture run and requested no retry. The captured terminal line is `FULL_PAIR_FAIL unknown audio/ACR observations=50000`; no `FULL_PAIR_PASS` exists. ModelSim exited after the testbench fatal at 2.0004 ms. Record disposition is `ABORTED_HOST_MEMORY_PRESSURE`; the unknown observations could be a testbench force/alias or observation-mapping issue and provide no routed-design root-cause evidence. The full log SHA256 and run disposition are in `simulation_status.json` and `input_binding_receipt.json`. No process remains.
