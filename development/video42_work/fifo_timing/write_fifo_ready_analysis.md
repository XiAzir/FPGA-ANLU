# `write_fifo_ready` raw reset gate experiment

## Candidate

Production equation:

```verilog
write_fifo_ready = !write_ready_reset && write_ready_release[1] &&
                   !write_fifo_full && (write_fifo_used <= 9'd480);
```

`write_ready_release` asynchronously clears on `write_ready_reset` and shifts in ones on `write_clk`. The experiment removes only `!write_ready_reset`; both reset sources and the two-flop release chain remain unchanged. The mini RTL in `tb_write_fifo_ready.v` models both equations side by side at 50 MHz write and 100 MHz memory clocks.

## Unit result

Ran `pwsh -File run_write_fifo_ready.ps1` with the specified Icarus binaries. The gate-deleted candidate passed against the original for write-clock acceptance sampling and settled ready recovery across 31 sampled write edges and 4 reset epochs. Reset assertion phases included before, coincident with, and after a write edge, plus a memory-clock edge aligned with a write edge. Both `rst` and `fifo_aclr` were exercised. Full and occupancy-above-480 suppression, then occupancy-480 readiness, were checked.

The negative control removes the two-stage release qualification while retaining the raw reset term. It was detected with `EARLY_ACCEPT` at write edge 3 while the release pipeline was `00`. Logs are `write_fifo_ready_positive.log` and `write_fifo_ready_negative.log`.

## Timing interpretation

At the synchronous consumer sampling points after reset assertion has propagated and before the two release stages complete, deleting the raw gate produced no acceptance difference in this unit model. In zero-delay RTL the async clear drives `write_ready_release[1]` low, making the direct term logically implied after event settling. A same-timestamp reset/write edge has simulator scheduling semantics; the bench captures the consumer's active-region sample and separately checks settled outputs, so a delta-cycle transition is not reported as an independent functional failure.

The raw gate gives the ready output a direct asynchronous suppression path. Removing it makes suppression depend on propagation through the release flop's asynchronous clear output. Whether that changes a real write-clock acceptance near reset assertion depends on reset assertion timing, the flop's asynchronous clear propagation, downstream setup, and the FIFO/packer reset contract. The unit test establishes cycle-level equivalence after settling; it does not prove behavior inside that physical timing aperture. Removing the raw gate is therefore a plausible timing candidate for the reported `fifo_aclr -> write_fifo_ready -> JPEG counter` setup path, subject to reviewing the controller timing report and confirming that the packer and FIFO write enables reset on the same `write_fifo_reset` contract.

No production RTL or reset logic was changed.
