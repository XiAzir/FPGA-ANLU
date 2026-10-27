# YUV420 scan cache

`yuv420_scan_cache.v` is an independent dual-clock memory client and display
line cache. It is not connected to shared C34 sources. The memory-side client
issues fixed BL4 reads through `rd_cmd_valid/ready` with a 21-bit word address,
accepts four ordered `rd_valid/rd_data` returns, and keeps only one command in
flight. It increments command state only on the fourth actual return.

## Frame and bank sizing

Parameters use visible frame width/height and the same 16×16 MCU-tiled YUV420
layout as `../yuv420/`. Frame height rounds up to a four-luma-line cache group;
tile addresses are derived from 16×16 MCU coordinates. For 1920×1080:

- 270 groups of four visible luma lines per frame; 1088-line tile padding is
  stored by the upstream frame writer and never requested by this scan client.
- Per group: 480 Y BL4 commands + 120 Cb + 120 Cr = 720 commands and 2,880
  returned 32-bit words.
- Full visible scan schedule: 194,400 commands and 777,600 returned words per
  frame. The remaining padded frame words are stored by the writer but omitted
  from display reads.
- Each bank holds four Y rows (`4*W` bytes), two Cb rows and two Cr rows
  (`2*(W/2)` bytes per plane). At W=1920 this is 2,880 words / 11,520 bytes
  per bank, 23,040 bytes for two banks.
- Group `g` uses bank `g[0]`. Memory may fill the other bank while one bank is
  displayed; it waits for the corresponding synchronized release toggle
  before reusing a busy bank.

## Command and cache indexes

Let `g` be the four-line group index, `inner=g%4`, and
`mcu_y=floor(g/4)`. Y command index `i` maps to:

```text
chunk=floor(i/2)             // 8-luma-pixel horizontal chunk
pair=i%2                     // two rows per BL4
mcu_x=floor(chunk/2)
y_block=floor(inner/2)*2 + (chunk%2)
row_in_block=(inner%2)*4 + pair*2
command_word=frame_base + mcu_index*64 + y_block*16 + row_in_block*2
```

The four returned words are two adjacent words from each of two rows. They are
stored at Y cache row `pair*2 + floor(beat/2)` and word column `chunk*2 +
beat%2`. Chroma commands follow the Y command range, first Cb then Cr, one
16-luma-pixel MCU column per command:

```text
command_word=frame_base + plane_offset + mcu_index*16 + inner*4
plane_offset(Cb)=Y_plane_words
plane_offset(Cr)=Y_plane_words + C_plane_words
cache_row=floor(beat/2), word_column=mcu_x*2 + beat%2
```

The pixel side uses `bank=(y>>2)&1`. Y cache word index is
`(y&3)*(W/4)+(x>>2)`, lane `x&3`. Chroma word index is
`(y&1)*(W/8)+(x>>3)`, lane `(x>>1)&3`; each chroma sample is read once per
2×2 luma footprint when the caller schedules sequential line bursts and reuses
the cache rows. The module exposes synchronous RAM read data one pixel clock
after input x/y/de, with the selected byte, coordinates, DE, bank-ready status,
and underflow indication aligned.

## CDC and frame-start contract

`frame_start_pixel` clears local valid bits and sets the local ready-toggle
epoch to the then-synchronized memory toggle. It does not reset the ready or
release toggles. Pulse it before, or in the same VBlank window as,
`frame_start_mem`; ensure the previous frame's last group was consumed and its
release toggles had time to synchronize. The memory caller must also ensure all
old read commands have returned before asserting `frame_start_mem`, and hold
`frame_base_word` for the new frame. Both clock resets should be asserted
together at cold start. There is no retry, timeout, or underflow recovery path.

The 1-cycle output is not stallable, matching a pixel timing stream. Underflow
is reported for an active visible input pixel whose bank is not ready; such
pixels still advance. `pixel_bank_ready` exposes both pixel-domain bank-valid
bits, while `out_bank_ready` reports the delayed read's bank state.

## Verification

Run from project root:

```powershell
python development/video34_work/yuv_scan/run_scan_tests.py
```

The Icarus test uses 32×32 pixels and asynchronous 100/33 MHz clocks, inserts
command-ready stalls, variable command delay and a gap within each four-word
return, scans eight groups per frame, reuses both banks, and changes the second
frame base. Python independently generates every MCU-tiled command address and
every pixel's Y/Cb/Cr word/lane from the storage-address-coded memory model.
The passing run compares 192 commands, 768 returns and 2,048 pixels, checks two
frame-done pulses, bank-ready on each output pixel and zero underflow. Output is
in `test_result.json`; cycle traces are in `sim.log`. This module-level check
does not validate the full SDRAM scheduler, HDMI timing closure or physical
service rate.

## Cache plus APUG011 arbiter regression

Run the additional integrated regression from project root:

```powershell
python development/video34_work/yuv_scan/run_arbiter_integration.py
```

It compiles this scan cache with the current C34 candidate
`yuv_sdram_burst_arbiter.v` as a read-only source dependency. The test models
APUG011 command/data pins, including four continuous read requests, ordered
actual responses with variable latency and gaps, returned data leading valid
by one memory clock, and periodic busy/refresh gating. A complete contiguous
16-word write block targets frame bank 1 while frame bank 0 is being scanned;
the second scan reads the written block back after changing the frame base.
The scoreboard rejects a write while read words remain outstanding and rejects
an early next command, read/write overlap, a gapped 4-word or 16-word request,
or YCbCr mismatch. It checks 192 BL4 commands, 768 actual returns, 16 writes,
2,048 YCbCr pixels, no underflow, and nonzero busy/refresh wait coverage.

Results are in `arbiter_integration_result.json`; the detailed Icarus trace is
in `sim_arbiter.log`. This validates the cache/arbiter protocol against the
testbench APUG011 interface model. It does not model physical SDRAM timing or
claim a board service-rate result. The RGB converter is not instantiated here;
the integration regression compares the Y/Cb/Cr bytes supplied to it.

## Native block-buffer/wrapper end-to-end regression

Run the complete small-frame regression from project root:

```powershell
python development/video34_work/yuv_scan/run_native_wrapper_regression.py
```

This compiles the C34 candidate `native_yuv420_frame_buffer.v` with its real
block buffer, arbiter, scan cache and RGB converter. The bench injects 24
plane/MCU blocks per 32×32 frame as 64-cycle nonstallable transactions, applying
the IDCT permutation `{sequence[2:0],sequence[5:3]}` and waiting for
`decode_block_space` before each block. Frame 0 is written and displayed while
the full frame 1 is written into the other bank; then frame 1 is prefetched and
displayed. The APUG model stores all actual writes, returns actual memory data
with variable delays/gaps and data one memory clock ahead of valid, and applies
busy/refresh pauses.

Python verifies every one of the 768 unique SDRAM write addresses and its four
byte lanes against the independent sample-coordinate function, both
`write_frame_done` pulses after exactly 384 writes, the complete BL4 read-word
schedule, and all 2,048 RGB pixels against the centered-sample clip plus C32
fixed-point conversion. The passing run has zero underflow and confirms frame 1
writes overlap frame 0 output pixels 58–756. Evidence is in
`native_wrapper_regression_result.json` and `sim_native_wrapper.log`. This
remains a small APUG interface simulation, not physical SDRAM or board evidence.
