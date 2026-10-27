# TD Verilog-2001 compatibility copy

This directory holds a Verilog-2001 translation of the frozen video-only TMDS candidate in `development/video33_work/open_tx_work/video_only_tx/`. The original SystemVerilog directory was left untouched. The translated top module remains `video_only_tmds_tx` with the same parameter names, top-level port names and widths.

## Files and translation choices

- `tmds_channel.v` translates the pinned TMDS channel encoder. `logic` declarations became `reg` or `wire`, `always_comb` became `always @*`, `always_ff` became `always @(posedge ...)`, and `unique case` became complete ordinary `case` statements. Two out-of-range `default` assignments were removed after review because all legal control and TERC4 values are enumerated.
- `auxiliary_video_information_info_frame.v` retains the module name and VIC0 metadata used by this experiment. Its unpacked `sub[3:0]` output is represented as `sub_flat[223:0]`; subpacket 0 occupies bits `[55:0]`. The general AVI parameter list was reduced to the experiment's fixed RGB/VIC0/default-field values.
- `packet_assembler_compat.v` retains the scalar ECC registers, polynomial, counter cadence and packet bit order. Its unpacked four-subpacket port became `sub_flat[223:0]`, with subpacket 0 in bits `[55:0]`, then subpackets 1, 2 and 3.
- `video_only_tmds_tx.v` retains the public top interface and fixed one-packet-per-line schedule. The `$clog2` calls became a Verilog-2001 `clog2` function. Scan-counter widths remain `$clog2(H_TOTAL)` and `$clog2(V_TOTAL)` in effect. AVI VIC0 is constant; SPD and NULL packet content, timing, same-pixel RGB sampling and `clockword=10'b0000011111` are preserved.

The only array interfaces were flattened; no serializer, audio ports, fallback behavior, retry logic or additional mode table was added. The upstream basis is hdl-util/hdmi commit `83b1c9543a91b776671a44e68e130f81cae437b7`; details and SHA-256 values are in `source-provenance.json`.

## Icarus checks

`pwsh -NoLogo -NoProfile -File .\tb\run_all.ps1` compiles the four RTL files with Icarus `-g2005`, then compiles and runs three independent SystemVerilog testbench copies with `-g2012`:

1. Short vertical timing: exact C36 horizontal timing, 16 active lines, two complete frames.
2. C35: 640+16+96+248 by 480+10+2+58, one full frame.
3. C36: 1920+8+8+64 by 1080+4+5+11, one full frame.

Each simulation checks startup control/preamble/guard symbols, active-row pixel counts and decoded RGB888, one full 32-symbol packet per line, AVI/SPD/NULL packet headers and checksums, packet BCH ECC, sync state in control/TERC4/guard symbols, and the one-bit TERC4 negative control. Logs are kept under `tb/`; aggregate results are in `results.json`.

The final `tmds_channel.v` change removed only two case defaults for out-of-range/unknown values. The short-V test and `-g2005` compile were rerun after that change. C35 and C36 full-frame simulations passed immediately before that edit; they drove fully-known legal control and TERC4 symbols, so those two case defaults were unreachable. Full-frame simulations were not repeated after the edit.
