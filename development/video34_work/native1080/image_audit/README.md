# Native C34 1080p YUV420 pixel audit

This folder contains an offline pixel comparison of the two already-produced
C34 VVP raw frames. It does not rerun VVP, encode JPEG, or edit media, fixtures,
or shared RTL.

## Inputs and mapping

The inputs are `frame000_decode_yuv420_tiled_le32.raw` and
`frame108_max_service_yuv420_tiled_le32.raw` from
`development/video34_work/native1080/`, paired by SHA-256 with the original
Q65 JPEG fixtures `frame000.jpg` and `frame108_max.jpg`. Both raw files are
3,133,440 bytes, matching the VVP summary CRCs.

The audit unpacks the existing 16×16 MCU tile layout: Y first, with TL/TR/BL/BR
row-major 8×8 blocks per MCU, followed by tiled Cb and Cr. It crops 1080 visible
luma rows and 540 visible chroma rows from the 1088-row storage. Chroma uses the
same nearest-neighbor 2×2 reuse as the scan cache. RGB uses the C34 converter's
5743/4096, 1410/4096, 2925/4096 and 7258/4096 constants, signed `>>>12`
rounding, and final 0–255 saturation. The Y/Cb/Cr raw bytes already include the
block buffer's centered-sample +128 conversion and 8-bit clipping.

Reference images use Pillow 12.3.0 to decode the same JPEGs to RGB. Pillow's
JPEG IDCT rounding and 4:2:0 chroma reconstruction can differ from C34's native
IDCT and nearest-neighbor chroma reuse. Results therefore report the raw
differences without a pass/fail threshold.

## Results

| Fixture | RGB MAE | RGB RMSE | RGB PSNR | Max channel error | Stored Y vs Pillow RGB-derived luma PSNR |
|---|---:|---:|---:|---:|---:|
| frame000 | 2.169 | 2.356 | 40.686 dB | 64 at (31,31) | 50.514 dB |
| frame108_max | 2.132 | 2.335 | 40.765 dB | 17 at (1583,95) | 50.512 dB |

The maximum frame000 error is localized: four pixels have a maximum RGB
channel error of at least 40, clustered around x=30–32/y=30–32 in the top-left
overlay area; one pixel reaches 64. For frame108_max, no pixel reaches 20.
Average MCU-boundary MAE is 2.181 versus 2.166 interior for frame000 and 2.143
versus 2.129 for frame108_max. The previews show no visible tile or row shift.
Mean C34-minus-Pillow channel bias is small: frame000 [-2.412, +1.441,
-2.609], frame108_max [-2.371, +1.361, -2.621] for R/G/B. The concentrated
frame000 outlier coincides with a sharp saturated-color edge; the remaining
RGB error and Y-vs-luma statistics stay low. Chroma upsampling and JPEG decoder
rounding are material parts of this comparison.

## Artifacts

- `native1080_pixel_audit.json`: source identities, layout, exact per-channel
  MAE/RMSE/PSNR/max errors, luminance comparison, MCU boundary/interior
  statistics, and resource sample.
- `frame000_decode_c34_rgb.png` and `frame108_max_service_c34_rgb.png`: native
  tiled YUV reconstructed with the C34 conversion arithmetic.
- `*_pillow_rgb.png`: Pillow JPEG references.
- `*_comparison.png`: C34 RGB, Pillow RGB, and amplified absolute difference
  side by side.
- `resource_usage.json`: sampled process working set. Peak was 91.7 MiB while
  processing both frames sequentially; raw inputs are memory-mapped and color
  conversion works two luma rows at a time.
- `audit_native1080_pixels.py`: reproducible analysis script. Run with the
  bundled Python that has Pillow and NumPy installed.

This is an external pixel-reference audit of simulator output, not a hardware,
SDRAM, or timing result.
