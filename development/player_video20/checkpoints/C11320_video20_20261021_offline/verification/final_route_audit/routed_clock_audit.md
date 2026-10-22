# C11320 最终 routed 时钟静态审查

**结果：PASS**；run：synthesis `3ad0291b-3f04-444e-b43c-ccbe8caf6f55`，physical `1a4b9f3a-541b-4b4a-969b-8bb74b578b99`，hold `3a5afb62-ab26-4bd9-9bc1-83a4e41c8ff4`。

审查绑定 hold 修复后的最终 PR DB、其 routed timing、冻结导出的 routed 网表、源 scope 与 ROM truth proof。报告中 fanout 直接取 routed STA 的 Clock Summary。

## Routed clock summary

| 时钟 | SDC来源 | 频率 (MHz) | routed fanout |
|---|---|---:|---:|
| `sd_card_clk` | `sys_pll_m0/pll_inst.clkc[0]` | 50.0 | 3317 |
| `video_clk` | `video_pll_m0/pll_inst.clkc[0]` | 25.0 | 1931 |
| `ext_mem_clk` | `sys_pll_m0/pll_inst.clkc[1]` | 50.0 | 581 |
| `hdmi_5x_clk` | `video_pll_m0/pll_inst.clkc[1]` | 125.0 | 56 |
| `clk` | `clk` | 50.0 | 5 |
| `ext_mem_clk_sft` | `sys_pll_m0/pll_inst.clkc[2]` | 50.0 | 1 |

## Routed topology

- sys PLL: CLKC[0] `sys_pll_m0/clk0_buf` → GCLK `\u_jpeg_core/u_jpeg_output/u_ram_y/u_ram/clk1_i`；CLKC[1] `u_frame_buffer/u_legacy_frame_backend/frame_fifo_read_m0/mem_clk`；CLKC[2] `u_frame_buffer/u_sdram/u2_ram/SDRAM_CLK`。
- video PLL: CLKC[0] `video_pll_m0/clk0_buf` → GCLK `\u_adjust_control/clk`；CLKC[1] `hdmi_5x_clk_raw` → HDMI serializer GCLK `\u_hdmi2phy_wrapper/u0_lane_lvds_8_1/I_serial_clk`。

## 生命周期与哈希绑定

- `synthesis_record` SHA-256 `891e8ed565c647bf2de077456c7d217cac21b26a09ef5990dbfa659b744902f9`
- `physical_record` SHA-256 `c8eb2df7faf98b8a69d0a91069a17603c375115769e2cb70d634683dd1745ea3`
- `hold_record` SHA-256 `a61e2d60ec450be45d005df95f8cd55cf0415c53ab6258535e8887c291962133`
- `route_db` SHA-256 `73b4ffa8e61a9ea61a162573025214080ec392657799ac24dcd34019cbc3c7c5`
- `timing_report` SHA-256 `247d404d6a69b27a6ae194912a533fdc47972e870bc7ef3d3ac8ea9d0789bc0e`
- `source_scope` SHA-256 `99342fd072b4559d6245806d36036fb9ae3d0b0a9d3c089a59153812e9fc40c9`
- `netlist` SHA-256 `d03f45350bb285fc3288957497afbe3cc35bc4f14d2ee148731320e69996bcc7`
- `sdc` SHA-256 `977abcdb8b6c4df93cbd8fe407d5dfa5ab2710ce45214d7713f583f91a732146`
- `rom_proof` SHA-256 `279b309704c20e606642b6b912b3f99ba70404cfd218fb94f8f6bf51b54827af`

## Assertions

- **PASS** — synthesis-record: selected C11320 synthesis record is successful
- **PASS** — physical-link: selected physical route links to selected synthesis
- **PASS** — hold-link: selected final hold-repaired route links to selected synthesis
- **PASS** — receipt-run-ids: export receipt run IDs={'synthesis': '3ad0291b-3f04-444e-b43c-ccbe8caf6f55', 'physical': '1a4b9f3a-541b-4b4a-969b-8bb74b578b99', 'hold': '3a5afb62-ab26-4bd9-9bc1-83a4e41c8ff4'}
- **PASS** — final-route-db: final PR DB SHA256=73b4ffa8e61a9ea61a162573025214080ec392657799ac24dcd34019cbc3c7c5
- **PASS** — routed-timing: routed timing SHA256=247d404d6a69b27a6ae194912a533fdc47972e870bc7ef3d3ac8ea9d0789bc0e
- **PASS** — netlist-export: exported routed netlist SHA256=d03f45350bb285fc3288957497afbe3cc35bc4f14d2ee148731320e69996bcc7
- **PASS** — source-scope: common scopeHash=0c3bbcc4f678a6124407fa5cded2b0e09095f61e4b9091a5376f12d3bb39d560
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
- **PASS** — clock-row:sd_card_clk: source=sys_pll_m0/pll_inst.clkc[0], STA frequency=50.0 MHz, true report fanout=3317
- **PASS** — clock-row:ext_mem_clk: source=sys_pll_m0/pll_inst.clkc[1], STA frequency=50.0 MHz, true report fanout=581
- **PASS** — clock-row:ext_mem_clk_sft: source=sys_pll_m0/pll_inst.clkc[2], STA frequency=50.0 MHz, true report fanout=1
- **PASS** — clock-row:video_clk: source=video_pll_m0/pll_inst.clkc[0], STA frequency=25.0 MHz, true report fanout=1931
- **PASS** — clock-row:hdmi_5x_clk: source=video_pll_m0/pll_inst.clkc[1], STA frequency=125.0 MHz, true report fanout=56
- **PASS** — clock-row:clk: source=clk, STA frequency=50.0 MHz, true report fanout=5

范围说明：PLL/GCLK 静态连线与 STA 报告时钟行完整性已核对；板级 SPI I/O delay 仍按工程 SDC 注释未表征。
