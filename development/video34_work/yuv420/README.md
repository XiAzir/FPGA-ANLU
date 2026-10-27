# 1080p15 YUV420 cache building blocks

This directory is a stand-alone candidate for the C34 1080p15 player. It does
not instantiate SDRAM, a DMA scheduler, or line caches and is not wired into the
shared player sources.

## Memory layout

The stored planes use 16x16 MCU tiles so JPEG's native 4:2:0 block order writes
complete words without a full-width reorder buffer. Frame height rounds from
1080 to 1088; all samples in the final padded MCU row are written. The display
address block is used for visible coordinates `0 <= x < 1920`, `0 <= y < 1080`.

| Region | Layout | Bytes | 32-bit words |
|---|---|---:|---:|
| Y | 120 × 68 MCU tiles, four row-major 8×8 blocks per MCU, TL/TR/BL/BR | 2,088,960 | 522,240 |
| Cb | 120 × 68 MCU tiles, one row-major 8×8 block per MCU | 522,240 | 130,560 |
| Cr | same as Cb | 522,240 | 130,560 |
| One padded frame | Y + Cb + Cr | 3,133,440 | 783,360 |
| Two padded frames | frame bases 0 and 783,360 | 6,266,880 | 1,566,720 |

The visible two-frame payload is 6,220,800 bytes. Padding adds 46,080 bytes.
Both frames occupy 6,266,880 of the available 8 MiB (2,097,152 32-bit words).
The first frame uses word addresses 0–783,359; the second uses
783,360–1,566,719.

For a given frame base, the plane word offsets are Y=0, Cb=522,240 and
Cr=652,800. With `mcu = (y >> 4) * 120 + (x >> 4)`, luma byte addressing is:

```text
block = (((y >> 3) & 1) * 2) + ((x >> 3) & 1)
sample = (y & 7) * 8 + (x & 7)
Y_word = base + mcu * 64 + block * 16 + sample / 4
Y_lane = sample % 4
```

For chroma, use `cx=x/2`, `cy=y/2`, and
`sample=(cy & 7)*8+(cx & 7)`. Cb/Cr words are respectively
`base+522240+mcu*16+sample/4` and `base+652800+mcu*16+sample/4`;
the lane is `sample % 4`. Pixels in each 2×2 luma group share the chroma byte.

## Modules and interfaces

- `yuv420_cache_write_packer.v`: accepts one signed centered IDCT sample per
  handshake, tagged with plane, MCU coordinates, Y block number and row-major
  sample index. Input samples must follow one 8×8 block at a time with indices
  0–63. It adds 128, saturates to 8-bit, and packs four samples into an aligned
  word in little-endian lane order. It emits a one-entry `write_valid` /
  `write_ready` word interface with a 21-bit word address. Within each block,
  addresses are sequential; the four Y blocks of an MCU occupy one contiguous
  64-word span. A full 8×8 chroma block occupies 16 words. `frame_start` clears
  partial data and pending output; assert it after the previous frame's writes
  have drained.
- `yuv420_pixel_address.v`: maps a visible luma coordinate and frame base to
  three 21-bit word addresses plus byte lanes. The caller supplies sequential
  burst reads and line buffering; reading these addresses separately for every
  display pixel would create unnecessary random traffic.
- `yuv420_to_rgb888.v`: two-stage elastic ready/valid converter with the C32
  `jpeg_output.v` constants and signed arithmetic shifts. Stored Y/Cb/Cr bytes
  equal `clip(centered_sample+128, 0, 255)`. The display converter therefore
  uses Y directly and subtracts 128 from Cb/Cr before conversion. Clipping
  affects samples whose centered IDCT value is outside [-128,127]; the clipped
  8-bit representation is what later RGB conversion sees.

The fixed-point coefficients are `5743/4096` for Cr→R, `7258/4096` for Cb→B,
`1410/4096` for Cb→G and `2925/4096` for Cr→G. Each signed product uses an
arithmetic `>>> 12`, matching the operations in C32 `jpeg_output.v`; final
channels saturate to [0,255].

The tiled layout saves a roughly 46 KiB Y/Cb/Cr row-reorder buffer on the write
path. It adds address swizzling to display reads. The display-side reader should
fetch sequential tile rows into line buffers, not issue three SDRAM reads per
pixel. For each four luma output lines, it needs the two corresponding chroma
rows from each of Cb and Cr (four chroma rows total), then reuses each row for
the two luma lines mapped to it. Each chroma sample should be fetched once per
scan. The required SDRAM/line-buffer schedule and its bandwidth are outside
these modules and remain for root integration to verify against the display
service budget.

## Independent check

Run from the project root:

```powershell
python development/video34_work/yuv420/run_tests.py
```

The script runs only the three small modules and their testbench with Icarus.
Python independently checks the pixel-address equations across every visible
pixel, padding boundaries, frame addresses, written words and byte lanes,
frame restart, backpressure, centered-byte saturation and representative RGB
extrema. Results are saved to `test_result.json`; simulator traces are in
`sim.log`. This does not validate the full JPEG core, SDRAM arbitration, HDMI,
or physical service rate.
