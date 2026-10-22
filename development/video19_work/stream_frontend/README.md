# Stream Frontend

This directory contains the PC-side MJP1 packer, the sector-cached JPEG file reader, and its standalone Icarus regression. It does not modify the production player or its clock/SDRAM/HDMI interfaces.

## MJP1 Layout

All metadata fields are little-endian. Every structure starts at a 512-byte sector boundary. Padding bytes are zero and never enter the JPEG stream.

| Sector/offset | Fields |
| --- | --- |
| File sector 0, bytes 0..3 | `MJP1` magic |
| File sector 0, offsets 4..19 | `uint16 version=1`, `uint16 header_bytes=512`, `uint16 width=640`, `uint16 height=480`, `uint16 fps_num=15`, `uint16 fps_den=1`, `uint32 frame_count=300` |
| File sector 0, offset 20 | `uint32 first_frame_sector=1` |
| Each frame record sector, bytes 0..3 | `FRM1` magic |
| Frame sector, offsets 4..19 | `uint16 version=1`, `uint16 header_bytes=512`, `uint32 frame_index`, `uint32 jpeg_length`, `uint32 jpeg_crc32` |
| Following sectors | Exact JPEG bytes followed by zero padding to the next 512-byte boundary |

The packer also writes `index.json` with sector/byte offsets and per-frame SHA256/CRC32, and copies the matching 48 kHz PCM16 mono WAV to `TEST.WAV` with source/copy SHA256 metadata. Defaults point at the existing Q95 640×480/15 fps MJPEG and audio fixtures.

```powershell
python development/video19_work/stream_frontend/pack_video_mjp.py
python development/video19_work/stream_frontend/run_mjp_reader_test.py
python development/video19_work/stream_frontend/run_mjp_jpeg_core_test.py
```

Generated media and Icarus logs stay under this directory's `output/` and `runs/` folders.

`run_mjp_jpeg_core_test.py` compiles the unmodified reference `jpeg_core`, drives the reader from the generated MJP at one sector byte per 36 system clocks (720 ns), keeps decoded output ready, resets the core between frames, and captures two complete coordinate/RGB streams. It compares frame 0 byte-for-byte with the existing `jpeg_unit` no-backpressure baseline and reports frame 1 software RGB error plus per-frame cycles and measured card throughput. The runner uses FFmpeg for the frame 1 software decode.

## Reader Contract

`mjp_file_reader` runs in one clock domain with the sector client and JPEG core input. `start` reads file sector 0 and holds `file_ready` high after capturing the frame count; `last_index` then reports `frame_count - 1`. `next_frame` is a one-cycle request accepted while idle. The reader loads the next `FRM1` sector, pulses `frame_ready` with `frame_index` and `frame_length`, then fetches the JPEG sectors and emits the image bytes. It increments through the records and wraps the sector cursor to sector 1 after the last record. The caller resets the JPEG core before each `next_frame` request and prepares its framebuffer write transaction first.

The card interface uses sector numbers relative to the MJP file. `card_read` is a one-cycle request; `card_addr` remains stable during the response. The client supplies 512 `card_valid` bytes and a `card_end` pulse per sector. One synchronous 512×8 BRAM buffers a complete sector before the JPEG stream drains it, so `jpeg_accept` backpressure never reaches the card response.

JPEG bytes are packed low byte first into 32-bit words. Full words use `jpeg_strb=4'b1111`; a partial final word marks its low valid lanes and zeroes the remaining lanes. `jpeg_last` is asserted on a separate empty accepted beat (`jpeg_valid=1`, `jpeg_data=0`, `jpeg_strb=0`). This matches `jpeg_input.v`: the core accepts the final byte group on a complete word, then the empty last beat resets the byte lane index. All JPEG output fields remain stable while `jpeg_valid && !jpeg_accept`.

`frame_sent` pulses after the core accepts that empty last beat. `sequence_index` identifies the completed source frame. `file_error` raises sticky `error`; malformed input checks are intentionally limited to the fixed generated-file contract.

## RGB565 Stream Candidate

`video_rgb565_packer.v` accepts RGB888 pixels and emits one 32-bit word per pair. Pixel 0 occupies bits 15:0 and pixel 1 occupies bits 31:16; each channel is truncated to its high RGB565 bits. `video_rgb565_unpacker.v` emits the low halfword first and expands 5/6-bit channels by replicating their most significant bits. Both modules use valid/ready handshakes; invalid input cycles represent blanking, and the unpacker can accept the next word while the current high-half pixel is consumed.

`run_video_rgb565_stream_test.py` runs two Icarus checks: 1024 pixels through the paired packer/unpacker with randomized source gaps and output backpressure, and 256 consecutive words through the unpacker with 512 contiguous output pixels. The 640-pixel line width has an even pixel count, so line boundaries preserve halfword pairing; four words align eight pixels for SDRAM burst-length-four scheduling.

`rgb565_word_codec.v` is the production-shaped variant with the `rgb888_pack32` / `rgb888_unpack32` port contract. Its unpacker expects a normal, non-show-ahead FIFO whose `word_data` updates one rising edge after `word_pop`; a 64-bit reservoir tracks zero through four halfwords and only pops when the post-consume count leaves room for the two-halfword response. `run_rgb565_normal_fifo_test.py` models that FIFO latency and checks a continuous 1-pixel/clk write/read packet plus two packets with randomized source/read blank cycles, multiple packet clears, and clearing a partial pixel. All three packets match the RGB565-expanded pixel reference with no underflow.

`run_mjp_jpeg_core_modelsim.py` runs the joint reader/original-core comparison in ModelSim SE-64 10.1c, with all artifacts under a timestamped `runs/` directory. It copies the vendor core into that run and qualifies the 12 JPEG marker tokens in `jpeg_input.v` with `inport_valid_i`; the independent baseline core remains available for A/B comparison. The unmodified core reproduces the second-frame stop at 217344 pixels even though the reader delivers all 37905 bytes with the expected CRC32. With the run-local input fix, both frames produce 307200 pixels, frame 0 matches the existing no-backpressure baseline byte-for-byte, and frame 1 reaches 42.76 dB PSNR against FFmpeg RGB. The PASS evidence is `runs/reader_jpeg_core_modelsim_20261021_181336/`.

## FAT32 SDHC Fixture

`build_card_fixture.py` emits a sparse 512 MiB FAT32 SDHC fixture with eight sectors per cluster. `card_image/summary.json` provides `image_bytes`, `mapped_sectors`, per-file SHA256, extents and cluster counts. `packed_mem.mem` stores one 512-byte sector as a 1024-character hex line, byte 0 first/high-order in the word; `lba_map.mem` gives the matching sorted 8-hex-digit LBA on each line. `card.mem` is the byte-addressed sparse readmemh variant. Golden files live under `card_image/golden/`.

The full MJP occupies 2870 clusters, below the playback file-chain limit of 4096. All six file payloads were extracted from packed mapped sectors and compared byte-for-byte with their goldens. The 2026-10-21 standalone Icarus reader+JPEG-core attempt exceeded its 240-second budget and produced no frame output; no joint PASS is claimed. Its preserved run is `runs/reader_jpeg_core_20261021_timeout240/`.
