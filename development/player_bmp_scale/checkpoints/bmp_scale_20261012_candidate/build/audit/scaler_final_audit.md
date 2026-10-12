# C11206 BMP 缩放最终静态与 RAM 映射审查

状态：**FINAL，本轮静态审查和RAM映射核验完成；根代理后续确认新full-gold、physical及bitstream均完成，实板待验证**。审查时间：2026-10-12 13:31（北京时间）。只读源码、模型凭据和 TD 综合产物；仅更新本报告。

## 稳定源指纹与阶段绑定

| 源文件 | SHA-256 |
|---|---|
| `src/user_source/hdl_source/bmp_scale_engine.v` | `A6C607738DB921E02C3D717F9C6CC9044CC3DDBC4FA02DD90B253FB541EF2C4D` |
| `src/user_source/hdl_source/tf_bmp_file_player.v` | `9CDDACB2F20A36D2E066EB74BF8FE55C5D675115281CE73B7D64EDAD3B8F93DF` |
| `src/user_source/hdl_source/frame_buffer_rgb888.v` | `65FF9ABF03C19D3BA27192AD645535F92D9542E7C18D74102C744C700713379D` |
| `src/user_source/hdl_source/SD/frame_read_write.v` | `E9672C35C1982E756788F600954C169D52E581A9D47BFA6CB93B07D47936CB39` |
| `src/user_source/hdl_source/top_tf_hdmi_audio.v` | `DB211234F22FBCADCFAC039DC8D81964DC274148719B830D3B076C8D70C91F4C` |
| `src/user_source/hdl_source/player_status_monitor.v` | `A5FA8DECBE9997105DF17D13564DFDA0FFF7EFDE53AFD5150134EC62DB78935C` |
| 规格 `build/scaler_spec.md` | `F06BD759AF02B6E6F6D80FB9D68F4A5B97917E02DC117712124F98B060F9F766` |

正式综合的 `build/manual/build_source_scope.json` 将 `bmp_scale_engine.v` 绑定到上表 A6 SHA，loader 绑定到上表 SHA。stage evidence：synthesis run `03c1c1aa-4c00-4a51-8a44-44c994410696`，状态 `success`，gate DB SHA `ee12030fde7f70c707a519979e1f4f8173626d5440e73d23aadbcd6abb7de67f`。当前 physical stage evidence 仍为 `running`；不得视为布局布线完成。

## 新增 RAM 写端复审

A6 engine 把 sector 与 row 的写操作拆到独立 `always @(posedge clk)` 进程，两个写使能均包含 `!rst`；原异步复位控制状态机不再承载 RAM 写口。row 写/读索引均显式取 `[9:0]`，输入 start 限制 `source_width<=MAX_SOURCE_WIDTH` 且 `<=1024`，所以合法最大列索引是1023；`src_h` 为10位，入口限制高度不超过768。

`file_error` 与 RAM 写口不直接互斥：若错误与一个原先已在途的 sector byte 或 row pixel 同拍，写端最多再写入当前槽位。但 FSM 在同沿转入 terminal、不更新 sector/row tag，pixel-valid 清零；loader 的全局错误处理压低 `write_en` 并进 HALT，不发布该帧。新一次 start 会清除两个 tag-valid，因此这类未提交写入不会成为可见有效缓存。复位时 `!rst` 同样阻止 RAM 写。静态检查未发现由该同拍写造成的可见语义漏洞。

## 正式综合的 RAM 映射核验

绑定 A6 engine 的 `build/manual/synthesis_console.log` 记录 scaler 的 sector RAM `512x8` 与 row RAM `1024x24` 均为 Logic BRAM；汇总为 `0 Logic DRAMs, 7 Logic BRAMs`。`build/manual/AC201_tf_hdmi_gate.v` 的 scaler row RAM 展开为3个物理 BRAM primitive，sector RAM为1个，总计4块；`AC201_tf_hdmi_gate.area` 层级表中 `u_scale` 也是4 BRAM。目标观察项均核实：

- `u_scale`：1208 LUT、502 ripple、646 seq、4 BRAM、5 DSP。
- `u_wav_player/ramread1_syn_4`：层级 4 BRAM；gate netlist 展开为4个物理 BRAM primitive。
- `u_pcm_waveform/ramread0_syn_4`：层级1 BRAM；gate netlist配置 `MODE("PDPW8K")`，波形 RAM 的 PDPW 属性保留。
- 整机 gate area：14633 LUT、8675 reg、28 BRAM9K、8 DSP。

以上是 TD 综合及 gate netlist 结构证据，足以确认当前正式综合中的逻辑 RAM 映射；不表示 FPGA 板上物理 RAM 实测或时序已通过。报告文件不嵌入完整工具日志，复核证据位于 `build/manual/`。

另有 `build/initial_ram_mapping/manual/` 冻结保留了上一轮 engine（SHA `9846713515DDADFC9D5F9B758F76E68CE7B3E80B0A08A247965016399974358C`）的数据库及失败结果：该旧版本 row RAM 被映射为 DRAM，placement 报 `mslice number=5099` 超器件上限4900并以 `BUILD_ERROR` 结束。那是旧 SHA 的结果；不能套用到 A6。A6 新综合现已把两组 scaler RAM 映射成 BRAM，新的 placement 仍在运行。

## 功能模型证据边界

`scaler_validation_receipt_first_pass.json` 记载 6个640×480帧、共1,843,200像素、4个错误 fixture 通过；但其中 `sourceSha256.bmp_scale_engine.v` 是旧 SHA `984671...`，不是本报告的 A6。该 PASS 证明旧 engine 版本在对应模型下通过，**不能记作 RAM 写端重构后的 A6 回归**。针对 A6 创建的 `scaler_source_snapshot_20261012_132640_324.json` 绑定了 A6/loader，但相应 full-loader run log 当时为空；截至本报告时间，新的六帧 full-gold 仍在运行，尚无与 A6 SHA 绑定的 PASS 结果。早期失败日志保留在 `build/model/scaler_full_loader_run_20261012_131802_836.log` 与 `...131929_613.log`，对应当时修正前快照，不作为 A6 失败结论。

已有 `build/model/write_backpressure.log` 的实际 pack + frame backend + FIFO RTL 压力模型结果仍为 `4096 pixels / 3072 words / max_used=481 / stalled=5908`；范围是线性48 words×64 rows，强制后端拥塞，不包含完整 scaler BMP 输入、加密 SDRAM、TF卡或板级链路。早期 TB 采样/忙信号假设失败日志继续作为测试平台修正历史，不是 RTL 失败证据。

## 未覆盖

新的 A6 full-gold 结果待补；physical placement 尚未结束，因此没有当前候选的布局布线/时序通过结论，也没有位流。未进行 JTAG、TF、Flash 或实板验证。综合结果和 host 模型均不能替代这些验证。

## 根代理最终本地结果补记

源hash保持上方A6/9CDDAC等六项不变。新六帧1843200逐像素与四个32×24目标错误用例通过，receipt当前source一致；正式physical与bitstream成功，无holdfix，SWNS+.628ns、HWNS+.004ns、TNS0、STA99.97%，phy资源15031LUT/8803reg/16520LE/28BRAM9K/8DSP/2GCLK。上述仍属本地验证，无实板/TF/Flash动作；候选封存/交付另见delivery_verified.json。首次failed physical报告保存，未改原约束。
