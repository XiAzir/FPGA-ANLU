# C04 最终 routed 静态审查

记录对象为 `player_video19` C04 最终 hold-repaired 路由与成功 bitstream，所有审查只读最终 PR DB、timing、SDC、TD 导出的 routed 网表与阶段凭据。

## 结论

- ROM：四个系数 BRAM 严格参数核对均为 PASS，每个 27 项、无差异；独立控制极性 proof 解析实际 BRAM pin、mux 参数及 LUT cone，对 6 个控制 pin × 32 个源状态穷举 192 行，全部 PASS。
- 状态映射：C04 摘除了旧状态快照，route 网表含 `state_reg_syn_1[16:0]` 17 个 FF Q 驱动状态位。TD 会把不同寄存器打包到 MSLICE/LSLICE 的 Q lanes，证明按实际端口连接绑定，不使用实例名与 lane 序号相同的旧假设。
- 时钟：最终 STA 的 6 个 SDC 时钟全部有实际频率与 Fanout 行；fanout 为 `sd_card_clk=3880`、`video_clk=1903`、`ext_mem_clk=567`、`hdmi_5x_clk=53`、`clk=5`、`ext_mem_clk_sft=1`。route 有 2 个 PLL、3 个 GCLK，SDC PLL 输出 pin 与 routed 输出网、GCLK 连线一致。
- ROM strict 参数结果和功能 truth 结果分别保留。C04 当前源 manifest 的 strict 比对为 PASS；既有 [历史 routed ROM proof](../../player_spectrum_arch17/build/audit/routed_rom_control_proof.json) 的整体功能结论 PASS、`raw_mismatch_policy.strict_status=FAIL`，两种结果仍分别保留，未被改写或合并结论。该历史 proof SHA-256 为 `4ce506d3552ecce877e23b633a1543b1f8fcccad03b614e49ad5e418a5cfa5ae`。

## 复现

PowerShell 7：

```powershell
& 'development/video19_work/final_route_audit/prove_c04_routed_rom_polarity.ps1' `
  -RunId '0c69ff10-3139-4672-acea-5a38d730eef0' `
  -PhysicalRunId 'b5370f50-01db-423e-86d9-407bff967274' `
  -HoldRunId '387033ad-cf55-48fa-8c26-507e0577472e'
python 'development/video19_work/final_route_audit/audit_c04_clock_route.py'
```

## 绑定证据

- Routed PR DB SHA-256：`ebf2577f96c6f12e30ee9c9d65b79f223105006771fae779e57a9e38250827df`
- Routed timing SHA-256：`90ef4a7a52c898722eb47d9d32ff4c079c3b8ad0e5762543c1241a878a55cf9e`
- TD routed 网表 SHA-256：`335bcc3527aacc93c558bc9bc63e49e6277946aaf0f8e042208e301fc1116d3f`
- Source scope SHA-256：`da50f007f14cea02c6774c78bf8dec60403f0bb9f74afc3fa4479862c30a7b0d`
- ROM truth proof SHA-256：`f9004744ff79dc13b313fe2f0e68c91f09a5873f29dcf5ef88034e139f8ba133`
- 综合/布局布线/hold/bitstream run ID、记录 SHA、源码 scope、gate DB 和 routed artifacts 绑定详见 `route_export_receipt.json` 与 `routed_clock_audit.json`。

## 文件

- `AC201_tf_hdmi_c04_pr_routed.v`：TD 6.2.178840 从最终 PR DB 导出的 routed 网表。
- `strict_routed_rom_control.json`：四个 ROM bank 的严格参数比较原始结果。
- `routed_rom_control_proof.json/.md`：实际 pin / polarity / 192 行 truth proof。
- `routed_clock_audit.json/.md`：PLL、GCLK、SDC 时钟、STA fanout 和哈希绑定。
- `export_c04_routed_netlist.ps1`、`dump_c04_routed_netlist.tcl`：只读 DB 导出入口。

## 范围与遗留

本审查验证静态 routed clock topology 和 STA Clock Summary，不覆盖板级 SPI I/O delay 与模拟时钟质量；当前 SDC 对 SPI I/O delay 仍注明未表征。产品 RTL、live、父级 build/gate_verify 及其他审查目录均未改动。
