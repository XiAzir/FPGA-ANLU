# C42 FIFO timing candidate

Scope: isolated timing experiment for `player_video42_sdram100` C42. Source RTL in this directory is copied from the C42 source tree; production and baseline files are untouched.

## Candidate transformation

`frame_fifo_write_candidate.v` replaces cumulative `write_cnt` plus total `write_len_latch` with `remaining_words`:

- On each ACK cycle, load the synchronized request length.
- On burst completion, subtract `active_burst_size` directly.
- Keep the FIFO admission predicate as `remaining_words <= rdusedw || rdusedw > BURST_SIZE`.
- Limit each data request using `burst_cnt + App_wr_en < remaining_words`.

For the no-wrap operating domain, let `R = L - C`, where `L` is request length and `C` is the completed-burst count. Then `L <= rdusedw + C` iff `R <= rdusedw`, and `C + sent < L` iff `sent < R`. Production photo lengths are multiples of 256 words and video4 lengths are multiples of 4 words, so every completed burst has at least one full active burst remaining and direct subtraction does not underflow. The C42 contract assumes frame lengths and completed word counts leave room below the 21-bit counter maximum; wraparound requests are outside this equivalence.

The prompt phrase “entering burst directly `remaining <= rdusedw`” is implemented as the admission comparison, with `<=` meaning less-than-or-equal. Assigning the FIFO occupancy into the frame remaining counter on state entry would discard unconsumed frame length and would not preserve behavior.

## Validation artifacts

- `tb_equiv.v`: parallel original/candidate RTL comparison for state, synchronized request, ACK, finish, address, FIFO clear, FIFO read enable, and writer busy. Both instances use production `BURST_SIZE=256`. Scenarios cover photo lengths 256/512/1024 and JPEG lengths 4/12/320, FIFO feeding, read-arbiter contention, SDR busy/ref delays, ACK/finish timing, mid-burst reset, and new requests after reset and completed requests. A simulation assertion enforces the photo 256-word and JPEG 4-word alignment contracts, and checks that remaining words cover a full burst at burst completion.
- `frame_fifo_write_negative.v`: isolated mutation that advances the admission threshold by one FIFO word. `run_equiv.ps1` expects this build to fail the same output comparison after the positive comparison passes. The clean candidate has no negative-control macro.
- `check_equivalence.py`: finite-width exhaustive Python checks of the admission, per-word limit, and completion identities within the no-wrap domain.
- `run_equiv.ps1`: compiles/runs both Icarus simulations. Requires `iverilog` and `vvp` in PATH.
- `tb_write_fifo_ready.v` and `run_write_fifo_ready.ps1`: targeted 50 MHz / 100 MHz reset-gate unit and release-synchronizer negative control; uses the project's configured Icarus absolute path and preserves per-run logs. Analysis is in `write_fifo_ready_analysis.md`.

## `write_fifo_ready` reset gate

`write_ready_release[1]` asynchronously clears from `write_ready_reset` and takes two `write_clk` edges to release. In an ideal zero-delay RTL model, `!write_ready_reset` is implied whenever that bit is high. The direct reset gate still provides immediate combinational suppression at the ready output while the release flop's asynchronous clear propagates, and retains explicit reset behavior independent of the release-chain implementation. Treat it as intentional; removing it requires timing/CDC review of the raw asynchronous assertion path and the FIFO IP reset contract. No reset logic was changed in this candidate.

## Execution status

Parent-reported initial `BURST_SIZE=128` run: 2115 cycles passed; the +1-word negative control was detected at cycle 90 with FIFO occupancy 127. Output is preserved in `equiv_20261027_202352.log`. The production `BURST_SIZE=256` extension is prepared for rerun with `run_equiv.ps1`; this shell has no `iverilog` or `vvp` in PATH, so the extension remains unrun here. No TD or ModelSim is used.
