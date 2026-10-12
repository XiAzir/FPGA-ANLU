# BMP scaler RTL review

## Interface and data flow

`tf_bmp_file_player` keeps its prior status/control ports and adds `write_ready`. During HEADER it reads the first logical sector for the BMP fields. After `write_req_ack`, it drops `write_req`, waits the existing three-cycle GAP, then pulses the scaler start. During PAYLOAD it routes sector requests from `bmp_scale_engine` and forwards accepted `pixel_valid && write_ready` RGB888 pixels. COMMIT still waits for the write-finish toggle; WAIT_DISPLAY still waits for the display-finish toggle. A scale or card error halts without updating the committed image index/buffer.

The loader accepts 24-bit BI_RGB images with width 1..1024 and absolute height 1..768, including top-down images and padded rows. It checks the signed-height minimum, DIB/pixel-offset boundary, padded image end, declared size, and catalog file size before requesting the write buffer.

The engine computes letterbox geometry using a 32-step restoring divider. It traverses output rows bottom-up, uses the bottom-offset ceiling for vertical letterbox placement, and uses phase accumulation for source coordinates. A complete source RGB row receives its tag only after all pixels have been written. The row RAM is synchronous and reused when later output rows map to the same physical source row. Sector reads collect exactly 512 bytes before making the single-sector cache valid; cache misses are separated by three idle cycles. BGR source bytes are converted to RGB888, including triples that cross sector boundaries.

The pixel interface is ready/valid: once `pixel_valid` is asserted, RGB remains stable until `pixel_ready` is high on an accepting clock edge. The engine advances the output coordinate only on that edge. Accepted pixels are separated by at least `PIXEL_INTERVAL` clocks, including black pixels.

## Storage and arithmetic bounds

- Source RGB row RAM: `MAX_SOURCE_WIDTH * 24` bits, 24,576 bits (3 KiB) at width 1024.
- Sector RAM: 512 * 8 bits, 4,096 bits (512 bytes).
- Row stride is 12 bits (maximum 3,072); source height is 10 bits; row offsets and full image byte count are 22 bits before adding the 32-bit pixel offset.
- No variable combinational division or RAM reset/array clear is used. Both arrays carry `(* ram_style = "bram" *)`; sector write, RGB-row write, and synchronous RAM reads use separate reset-free clocked processes. The source row address is explicitly sliced to 10 bits after enforcing the 1024-pixel source-width limit.

## Verification evidence

- Icarus engine smoke after BRAM inference edits: [run_engine_smoke.ps1](run_engine_smoke.ps1), output [engine_smoke.log](logs/engine_smoke.log). PASS: 48 exact pixels for 8x6 output from a 5x2 padded BMP at byte offset 510; odd three-row vertical remainder uses bottom offset 2; the black rows are zero; bottom-up source colors and horizontal nearest-neighbour mapping match; only two complete source rows are built for three content rows; exactly two sectors are read across the byte-510 boundary; ready stalls preserve valid/data.
- Icarus loader elaboration with the engine and existing debounce module: [loader_compile.log](logs/loader_compile.log). Exit 0.
- Full host/BMP golden loader regression: pending the parallel golden-model agent; no completion claim is made here.
- Vendor synthesis/timing/BRAM mapping: not run by this scoped RTL task; root task owns the isolated-project compile/resource review.

## Follow-up

Review the full golden loader regression and the isolated vendor synthesis report before treating the scaler as release-ready. In particular, confirm inferred RAMs and resource/timing use in the target toolchain.
