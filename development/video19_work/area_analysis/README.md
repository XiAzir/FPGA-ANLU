# JPEG Area Analysis

Each candidate is created under this directory and remains isolated from `player_video19` and the shared `area_rebalance` runs.

## A12_valid_prefix

Parent: the frozen A11 color-multiplier source set. The experiment replaces four 64-bit valid-bit maps in `jpeg_idct_ram` with four block slots by four bank prefix counters. Read-valid becomes `valid_count[block][bank] > rd_addr`.

This candidate failed pixel equivalence (307200 coordinates, MSE 84.14, PSNR 28.88 dB, max error 255, exact-pixel ratio 55.8%). The ascending-index assumption was invalid because `jpeg_dqt` dezigzags coefficient indices. Its files and frame output remain as a failure record; no TD synthesis was run.

## A13_valid_clear

Parent: frozen A11 source set. Removes the four 64-bit per-bank valid maps and their output masks. Before a free write slot accepts input, a 4-bit counter clears all 16 addresses in each of the four data RAM banks. Preparation begins proactively so the upstream DQT block-space handshake can complete. `slot_prepared_q` is cleared on the same EOB/accept condition that advances `block_wr_q`.

Pixel equivalence passed against A08/A11:

- 16x16 audit: 256 pixels, no coordinate or hold errors; SHA256 `72CCA47B8C1CDDC12A43B2FE72FBB494880A48F6217FBEF760269A38872B8C40`.
- Frame 0, 640x480 without backpressure: 307200 pixels, 662368 cycles, no coordinate or hold errors; SHA256 `A4D4B3B4B86A23831D06D4B3051DD4C9486B2141EBC4E5C62D67A605A9000440`, equal to A08.
- Frame 0, MODE=2, SEED=324508639: A13 699285 cycles/77392 stalls; A11 697328/77265. Both output hashes equal the A08 frame-0 hash.
- Frame 109, MODE=3, GAP=7, SEED=324508639, ABORT_BYTES=10000: 10000 bytes accepted before reset, then full 43231-byte replay; 307200 pixels, 77482 stalls, no coordinate or hold errors, idle=1. Output SHA256 `CDE70E8F13E1982BC48F72480221462D1D3E4EA35B4C1584A8309A4754263E87`, equal to A11.
- Frame 299, MODE=3, GAP=7, SEED=1597463007: full 35721-byte input, 307200 pixels, 77414 stalls, no coordinate or hold errors, idle=1. Output SHA256 `53A1A0AF77BCAB1ED8130C177865C7D55C0FB1ABCE99250CBA4FE6C7929F3485`, equal to A11.
- Three standard-DHT 64x64 synthetic cases (flat / zero-AC, black-white step / negative DC delta, deterministic high-frequency / dense AC) all pass MODE=3/GAP=7 with 4096 pixels and no coordinate or hold errors. A13/A11 output hashes match respectively: flat `CA6947A799844F29B8101473642C7CB9B0935E57C14C9A3CFF3BA2BC227061F6`; step `11D1E7C687A96553207DF178666B0DCF3511B9FE7FFAC96C1FADE68013A7A90F`; dense `71364D7BF7BFA92960CAA385F65C288AD88C5550D8935EFAF986C7D134314D47`.

The first synthetic JPEG used ffmpeg's default optimal/custom Huffman tables; the A11 baseline stalled at zero pixels because `SUPPORT_WRITABLE_DHT=0`. That first run's console showed `timeout pixels=0 idle=0`; its same-name log was overwritten by the subsequent standard-DHT rerun, and this limitation is recorded here and in the dated work log. A13 was not tested with the custom-DHT fixture. The generator now selects the decoder's standard Huffman tables.

TD 6.2.178840 synthesis, EG4S20BG256, AreaHigh: A13 is 5627 LUT (including ripple), 2653 FF, 17 BRAM9K, 17 DSP. A11 is 6164/2905/17/17, so A13 saves 537 LUT and 252 FF. `u_jpeg_idct/u_input` falls from 707 to 181 LUT and from 281 to 29 FF. Setup WNS changes from -1347ps to -1679ps; TNS changes from -29480ps to -26368ps; 24 setup endpoints remain violated. Hold WNS is +556ps and hold TNS is 0. Full place-and-route and integrated player validation remain pending.

Rebuild the isolated TD input with `prepare_A13_valid_clear.py` and synthesize with `run_A13_valid_clear.py`. Re-run frame/fixture simulation with `sim/run_A13.ps1`; create the three standard-DHT stress cases with `sim/make_synthetic_cases.ps1`.
