# C11205 display ownership model review

## Behavior covered

- Loader COMMIT publishes the committed buffer/image and enters `WAIT_DISPLAY` (state 9). The synchronized `display_finish_toggle` is the only normal exit; the loading watchdog is disabled in this state, while queued-next and auto mode remain under the existing loader logic.
- `player_osd_state` keeps the 9-bit SD-to-pixel mailbox coherent. Its first valid source is adopted whole. A changed buffer/image starts a frame-boundary wipe, with the old source identity retained until the final boundary; count/auto labels follow coherent mailbox updates.
- `wipe_rows` advances once per rising `read_req`, saturates at `FRAME_HEIGHT`, and target identity is locked for the active transition. The final boundary changes the visible source and starts one release wait.
- `read_req_ack` passes through two pixel-clock synchronizer flops. A delayed ACK is accepted after both raw request and delayed `read_req_out` have fallen; `release_pending` clears with the single completion toggle.
- Identical buffer/image refreshes labels without a wipe or completion. The model also covers loader error before commit and ensures no image publication.

## Reproducible model

Run from the project root:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File development/player_transition_wipe/build/model/run_display_ownership.ps1
```

The test uses asynchronous SD, pixel, and memory clocks. It scales the wipe to 16 rows with 8-row steps, so the 8-row and final-boundary cases are quick to exercise. The production defaults remain 480 rows and 8 rows per frame; 480/8 is exactly 60 read boundaries. The bench checks the loader's 3-flop completion synchronization separately after exercising the pixel-domain delayed memory ACK.

## Evidence limits

This is an RTL ownership model only. It does not model actual SDRAM arbitration, pixel fetch latency, audio, image-content blending, TD synthesis/timing, or board behavior. In particular, the wrapper must consume `wipe_rows`, `wipe_active`, and `wipe_new_buffer` with the intended raster and read-address mapping. No claim is made about real SDRAM safety or visible transition quality before integrated simulation and hardware verification.
