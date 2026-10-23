# C29 memory and pixel path observer

This directory contains a passive `player_memory_runtime_probe` and a focused Icarus testbench. It has no connection to media control and never drives a request, reset, FIFO clear, or pixel value.

## Interface and output encoding

`page5` is `{4'h5, mem_flags[7:0], last_return_word_count[18:0], 1'b0}`. The last count and flags are published after a completed read session through a held-data/toggle/ack mailbox from `mem_clk` to `pixel_clk`.

`mem_flags` bits `[7:0]` are `{app_read_seen, returned_seen, nonzero_read_seen, app_write_seen, nonzero_write_seen, last_count_mismatch_seen, 2'b00}`. At each rising edge of `mem_read_ack`, the previous session is closed and the next session starts. The first rising edge only seeds the first session. App-read and valid-return counts are 19-bit word counts; a return is nonzero when `mem_read_valid && |mem_read_word`. Writes are observed on `mem_app_write`, with nonzero detection from `mem_write_word`. Count mismatch compares app-read and returned-valid totals for the closed session.
`app_write_seen` and `nonzero_write_seen` describe only the just-closed read session. Every `mem_read_ack` rising edge clears those flags as it opens the next read session, so a read session with no write activity reports both as zero; the TB checks this on its second session.

`page6_tail` is `{read_state_sync[3:0], pixel_flags[7:0]}`. Pixel flag bits `[7:0]` are `{osd_valid, source_valid_sync, read_req, read_ack_sync, read_fifo_clear_sync, pixel_underflow_seen, raw_nonzero_seen, gated_nonzero_seen}`. Source validity, read ACK, FIFO clear, and the 4-bit reader state use two-stage observation synchronizers. Sticky pixel flags set only when `pixel_de` is high and clear on `rst`. `page6_tail` keeps the synchronized state live even without another read ACK.

The mailbox is intended for frame-rate session updates: a closed-session sample is published only when the prior toggle has been acknowledged. It adds no media-side wait, retry, timeout, or recovery path. It has no consumer feedback into the observed system.

## Verification

Run with Icarus from this directory:

```powershell
iverilog -g2012 -s tb_player_memory_runtime_probe -o memory_probe_tb.vvp player_memory_runtime_probe.v tb_player_memory_runtime_probe.v
vvp memory_probe_tb.vvp
```

The test covers phase-offset clocks, first-session initialization, equal and unequal request/return counts, zero and nonzero memory data, write observations and per-read-session write-flag clearing, `osd_valid=0` with nonzero raw RGB and zero gated RGB, a negative control with leaked nonzero gated RGB, live reader state without a read ACK, and asynchronous reset clearing. Expected terminal result: `PASS`.



Validated locally with repository-resolved Icarus (`iverilog -g2012 -Wall`) and `vvp`: PASS. The test checks page5 session flags/counts including per-session write-flag clearing, observes the gate-negative-control page6 tail `A47`, then verifies reset values `page5=50000000` and `page6_tail=000`.

