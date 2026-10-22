# C04 最终 routed 时钟静态审查

**结果：PASS**；run：synthesis `0c69ff10-3139-4672-acea-5a38d730eef0`，hold `387033ad-cf55-48fa-8c26-507e0577472e`，bitstream `bb977f9e-fce9-4d85-aca2-71693525de70`。

审查绑定 hold 修复后的最终 PR DB、其 routed timing、冻结导出的 routed 网表、源 scope 与 ROM truth proof。报告中 fanout 直接取 routed STA 的 Clock Summary。

## Routed clock summary

| 时钟 | SDC来源 | 频率 (MHz) | routed fanout |
|---|---|---:|---:|
| `sd_card_clk` | `sys_pll_m0/pll_inst.clkc[0]` | 50.0 | 3880 |
| `video_clk` | `video_pll_m0/pll_inst.clkc[0]` | 25.0 | 1903 |
| `ext_mem_clk` | `sys_pll_m0/pll_inst.clkc[1]` | 50.0 | 567 |
| `hdmi_5x_clk` | `video_pll_m0/pll_inst.clkc[1]` | 125.0 | 53 |
| `clk` | `clk` | 50.0 | 5 |
| `ext_mem_clk_sft` | `sys_pll_m0/pll_inst.clkc[2]` | 50.0 | 1 |

## Routed topology

- sys PLL: CLKC[0] `sys_pll_m0/clk0_buf` → GCLK `\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i`；CLKC[1] `u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mem_clk`；CLKC[2] `u_frame_buffer/u_sdram/u2_ram/SDRAM_CLK`。
- video PLL: CLKC[0] `video_pll_m0/clk0_buf` → GCLK `\u_adjust_control/clk`；CLKC[1] `hdmi_5x_clk_raw` → HDMI serializer GCLK `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk`。

## 生命周期与哈希绑定

- `synthesis_record` SHA-256 `bab019da768824e32081933b4c3be8a2172b235ba1d3a3d9f59ffff5047c486f`
- `physical_record` SHA-256 `261a79a9494ab10536bd33dae3e949a4b2826de8d17b300269cf0ce78b365bf4`
- `hold_record` SHA-256 `ffd683aef5d504709266ea3faa2685bf128b1f42568df5852d95b8db436346e8`
- `bitstream_record` SHA-256 `4c61f96f16d3a47dc957555d79a195faedf54e4ffac8f57e4c5302094804829e`
- `route_db` SHA-256 `ebf2577f96c6f12e30ee9c9d65b79f223105006771fae779e57a9e38250827df`
- `timing_report` SHA-256 `90ef4a7a52c898722eb47d9d32ff4c079c3b8ad0e5762543c1241a878a55cf9e`
- `source_scope` SHA-256 `da50f007f14cea02c6774c78bf8dec60403f0bb9f74afc3fa4479862c30a7b0d`
- `netlist` SHA-256 `335bcc3527aacc93c558bc9bc63e49e6277946aaf0f8e042208e301fc1116d3f`
- `sdc` SHA-256 `977abcdb8b6c4df93cbd8fe407d5dfa5ab2710ce45214d7713f583f91a732146`
- `rom_proof` SHA-256 `f9004744ff79dc13b313fe2f0e68c91f09a5873f29dcf5ef88034e139f8ba133`

## Assertions

- **PASS** — synthesis-record: C04 synthesis success record is selected
- **PASS** — physical-link: physical route links to selected synthesis
- **PASS** — hold-link: final hold-repaired route links to selected synthesis
- **PASS** — bitstream-link: successful bitstream links to the hold-repaired route
- **PASS** — final-route-db: final PR DB SHA256=ebf2577f96c6f12e30ee9c9d65b79f223105006771fae779e57a9e38250827df
- **PASS** — routed-timing: routed timing SHA256=90ef4a7a52c898722eb47d9d32ff4c079c3b8ad0e5762543c1241a878a55cf9e
- **PASS** — netlist-export: exported routed netlist SHA256=335bcc3527aacc93c558bc9bc63e49e6277946aaf0f8e042208e301fc1116d3f
- **PASS** — source-scope: common scopeHash=30d3d2458b4deaa502a49c510c7ed6ccddce0069c07f754f6b65f26299f82c1f
- **PASS** — rom-proof-binding: ROM truth proof PASS bound to this PR DB and timing report
- **PASS** — pll-cells: found 2 routed PLLs; sys/video instances present
- **PASS** — gclk-cells: found 3 routed EG_PHY_GCLK cells
- **PASS** — sys-pll-gclk: sys CLKC[0] sys_pll_m0/clk0_buf buffered to JPEG/core clock
- **PASS** — video-pll-gclk: video CLKC[0] video_pll_m0/clk0_buf buffered to pixel/control clock
- **PASS** — hdmi-serial-gclk: video CLKC[1] hdmi_5x_clk_raw buffered to HDMI serializer clock
- **PASS** — sdc-root-clock: 50 MHz input clk is constrained at 20 ns
- **PASS** — sdc-renamed-clocks: declared PLL clocks=['ext_mem_clk', 'ext_mem_clk_sft', 'hdmi_5x_clk', 'sd_card_clk', 'video_clk']
- **PASS** — sta-clock-summary: routed timing contains exactly six declared clocks: ['clk', 'ext_mem_clk', 'ext_mem_clk_sft', 'hdmi_5x_clk', 'sd_card_clk', 'video_clk']
- **PASS** — sdc-route:sd_card_clk: SDC pin=sys_pll_m0/pll_inst.clkc[0]; routed PLL output=sys_pll_m0/clk0_buf
- **PASS** — sdc-route:ext_mem_clk: SDC pin=sys_pll_m0/pll_inst.clkc[1]; routed PLL output=u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mem_clk
- **PASS** — sdc-route:ext_mem_clk_sft: SDC pin=sys_pll_m0/pll_inst.clkc[2]; routed PLL output=u_frame_buffer/u_sdram/u2_ram/SDRAM_CLK
- **PASS** — sdc-route:video_clk: SDC pin=video_pll_m0/pll_inst.clkc[0]; routed PLL output=video_pll_m0/clk0_buf
- **PASS** — sdc-route:hdmi_5x_clk: SDC pin=video_pll_m0/pll_inst.clkc[1]; routed PLL output=hdmi_5x_clk_raw
- **PASS** — clock-row:sd_card_clk: source=sys_pll_m0/pll_inst.clkc[0], STA frequency=50.0 MHz, true report fanout=3880
- **PASS** — clock-row:ext_mem_clk: source=sys_pll_m0/pll_inst.clkc[1], STA frequency=50.0 MHz, true report fanout=567
- **PASS** — clock-row:ext_mem_clk_sft: source=sys_pll_m0/pll_inst.clkc[2], STA frequency=50.0 MHz, true report fanout=1
- **PASS** — clock-row:video_clk: source=video_pll_m0/pll_inst.clkc[0], STA frequency=25.0 MHz, true report fanout=1903
- **PASS** — clock-row:hdmi_5x_clk: source=video_pll_m0/pll_inst.clkc[1], STA frequency=125.0 MHz, true report fanout=53
- **PASS** — clock-row:clk: source=clk, STA frequency=50.0 MHz, true report fanout=5

范围说明：PLL/GCLK 静态连线与 STA 报告时钟行完整性已核对；板级 SPI I/O delay 仍按工程 SDC 注释未表征。
