# Startup Clock Unit

This isolated ModelSim test compares the production startup controller before and after C03 moved its clock from the input reference `clk` to the global 50 MHz `sd_card_clk`. The runner extracts the actual `always` block from frozen top-level source snapshots and wraps the unchanged block in two small DUTs. It records the full source SHA256, extraction line range, and extracted block hash in each run's `source_manifest.json`.

## Inputs

- Old controller: `development/player_video19/build/video_system_20261021_191508/frozen/src/user_source/hdl_source/top_tf_hdmi_audio.v`, lines 151-170, SHA256 `B2B4B6A83B2E27466814D0804CFA1CAAF1B665E82D25D0905F53F20A01060FE8`.
- C03 controller: `development/player_video19/build/syn_20261021_193057.frozen/src/user_source/hdl_source/top_tf_hdmi_audio.v`, lines 150-169, SHA256 `EF50C946A8E5A6092EB6E4FCB0DEEE2130643CBCA3EF0415E396714B9ED3DDB8`.
- Nominal PLL replay: `development/player_video19/build/video_system_20261021_191508/pll_clock_replay.v` and `pll_replay_wrappers.v`; SHA256 values are captured in the run manifest. The fixture replays recorded sys/video PLL lock and clock timing from a 20 ns reference clock. The test gates lock signals only for explicit unstable-lock cases; generated clocks continue running from the replay.

The snapshots contain the same startup counter and state logic; the C03 always block uses `posedge sd_card_clk`. Both DUTs receive the same external reset and nominal replay lock signals. The test counts relevant clock edges independently, so phase differences between `clk` and `sd_card_clk` do not affect the expected threshold.

## Run

```powershell
pwsh -NoProfile -File development/video19_work/startup_clock_unit/run.ps1
```

The script uses the configured ModelSim SE-64 10.1c installation found on `PATH`, creates an isolated timestamped run directory, extracts and hashes the controller blocks, compiles them with the preserved nominal replay, then runs the testbench.

## Result

Run `runs/modelsim_20261021_193057_final/` passed on 2026-10-21 with ModelSim SE-64 10.1c:

- Both controllers held reset while `rst_n` was asserted and while either lock was gated low.
- A 100-edge partial qualification followed by lock loss cleared both counters to zero and kept reset asserted.
- Both old and C03 controllers released reset on exactly edge 1,000,001, with `rst_cnt=1,000,000`. This full-count case ran twice; the second round followed a runtime reset and began from zero.
- After release, a short lock drop left both controllers released with the counter unchanged, matching the existing sticky-release behavior.
- Replay clock activity was observed: 2,000,142 system-clock edges, 1,000,071 video-clock edges, and 5,000,353 serial-clock edges. The nominal sys/video lock outputs were both high at completion.
- Final log markers: `UNSTABLE_LOCK_CLEAR_PASS`, two `FULL_COUNT_PASS` lines, `POST_RELEASE_LOCK_DROP_PASS`, `NOMINAL_PLL_CLOCKS_PASS`, and `STARTUP_CLOCK_UNIT_PASS`.
- Early harness attempts are preserved in `runs/modelsim_20261021_193057/` and `runs/modelsim_20261021_193057_fix1/`: the first caught a generated module separator error; the next exposed that the second reset-release edge could be counted before the monitor was armed. The runner separator and TB lock-gating sequence were corrected before the final passing run; these were harness issues.

This verifies the extracted startup controller against the recorded nominal PLL replay and counts a complete 20 ms qualification interval twice. It does not run the full player, TD synthesis, routed timing, electrical PLL primitive simulation, or board startup. Recheck the C03 route recovery/removal paths separately.
