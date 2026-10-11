# dynamic_text_fit 固定竖线：SDRAM / RGB 输入捕获与时序审计

日期：2026-10-09（北京时间）  
性质：只读静态审计；未操作板卡、未修改 RTL/约束/位流，未重新构建。

## 范围与身份

- 候选位流 `build/manual/AC201_player_dynamic_text_fit.bit`：SHA256 `028D9D9A742A2CD980ECBEA48FFBE824D89DA34CF6B2B3E66EA0AA42B6D6456D`，与 `AC201_player_dynamic_text_fit.info.json` 一致。
- 对照成功版 `player_osd_phy_fix/build/manual/AC201_player_osd_phy_fix.bit`：SHA256 `9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F`，对应资料状态记录中的成功基线。
- 两工程下列关键文件 SHA256 完全相同：`frame_read_write.v`=`036D2C3D...0F47C6F`；`frame_buffer_rgb888.v`=`5F653151...82455CC`；`timing.sdc`=`977ABCDB...A732146`；`sys_pll.v`=`4A410FC8...F88D0B4E`；`SD/sdram.v`=`2D985C24...22DFC99`。这里省略号只用于正文缩短；原始完整哈希可由文件现场复算。
- 两版实际走同一 SDRAM/RGB888 读通路，`frame_buffer_rgb888` 选择 `SDR_READ_CAPTURE_DELAY=0`、`SDR_READ_DATA_DELAY=1`。候选相对 `player_dynamic_text` 的唯一 RTL 改动是 `fat32_file_sector` 中 Brent 计数器缩窄；动态 renderer 保留。因而本轮没有发现候选版在 SDRAM DQ 捕获、RGB 解包或 PLL 配置上的 RTL/约束差异。

## 路由 STA 与实际采样路径

两版 `AC201_tf_hdmi_pr.timing` 在组 `ext_mem_clk_sft -> ext_mem_clk` 的 32 条路径给出完全相同结果：slow/setup SWNS=1.706 ns、0 个违例；fast/hold HWNS=12.301 ns、0 个违例。最差路径两版也一致：

- 起点 `u_frame_buffer/u_sdram/sdram.dq[0]`，时钟 `ext_mem_clk_sft` 上升沿 8 ns；终点 `u_frame_buffer/u_sdram/sdram_syn_1.bpad`，捕获时钟 `ext_mem_clk` 上升沿 20 ns。预算 12 ns，报告路径延迟 6.453 ns（模型列为 hard-IP 输入 5.000 ns + PAD(reg) 1.453 ns），setup slack 1.706 ns。
- 源 PLL 配置将 `ext_mem_clk_sft` 设成 144°，50 MHz，即报告相位 8 ns；`ext_mem_clk` 是 0°。`SD/sdram.v` 把 `Clk_sft` 接入 `sdr_as_ram.Sdr_clk_sft`，其生成 SDRAM_CLK；普通 `Clk` 驱动控制器。报告的 DQ 路径因此覆盖“输出 SDRAM 时钟相位到 DQ pad / ext_mem_clk 捕获边”的内部时序关系，而不只是像素寄存器之间的逻辑路径。
- 这些数字是 Tang Dynasty 路由模型对硬 IP/PAD 的估算，不是板上 SDRAM DQ 波形、SDRAM 芯片 tAC/板级走线延迟或采样眼图测量。`ext_mem_clk` 源时钟与 SDRAM 外部时钟反馈/芯片数据有效窗口的板级误差没有实测。1.706 ns 正 slack不能证明所有现场器件、电压、温度与布线状态下的电气裕量。

STA 也显示 `ext_mem_clk_sft -> ext_mem_clk` 按名义相位有 setup 闭合；它没有为顶层 SDRAM DQ 建立用户 `set_input_delay`，因为 DQ 被封装在 `EG_PHY_SDRAM_2M_32` / 加密 wrapper 内部，顶层 check 不会把它列作未约束的普通输入端口。故应同时保留“工具给出内部模型收敛”与“板级 DQ 时序未校准”这两个事实。

## I/O 约束缺口与综合警告

两版 SDC 只有输入 50 MHz `clk`、`derive_clocks` 和 PLL 时钟重命名；无 SDRAM 外部输入/输出延迟，也无 HDMI 接收端输出预算。SDC 本身注明板级 SPI I/O 延迟尚未表征。路由 check 文件两版都列出 4 个无 input delay 顶层端口（`key1`,`key2`,`rst_n`,`sd_miso`）与 14 个无 output delay 端口；HDMI 的 `HDMI_CLK_P`,`HDMI_D0_P`,`HDMI_D1_P`,`HDMI_D2_P` 在缺项清单内。即使内部 RGB/serializer STA 全绿，也不能得出 HDMI 接收器端 setup/hold 裕量结论。

两份 synthesis 日志都出现相同警告：加密文件 `include/sdr_wrrd.enc.v(0)` 中 `Sdr_rd_dout_reg[0..9]` 实例的 `clk` pin 被报为 undriven；日志随后记录 `Using 0 for all undriven pins and nets`。它可能来自受保护网表/综合模型的不可见实现边界；报告里的 DQ hard-IP/PAD 路由时序又确实被建模并通过，因此不能据此断言实际硬件寄存器时钟为 0、也不能把它直接判为条纹根因。应将其作为必须向明文 RTL/器件网表或安路支持核实的模型可信度缺口。

## 对图像现象的解释范围

背景图像有固定规则浅灰竖线、OSD 黑底白字和滚动字幕没有同类线，说明异常更符合背景图像生成/取数路径上的差异，至少值得先检查 SDRAM DQ→`Sdr_rd_dout`/valid→FIFO→RGB888 unpack→合成器前的路径。OSD 像素会覆盖底图；被覆盖区域干净与“底图数据已经带线、OSD 区域恰好遮住”相容，也与用户观察到的显示差异相容。它不能单独证明线一定来自 SDRAM，也不能排除底图处理后至 HDMI 前的组合逻辑或空间相关的输出电气问题。

关键反证约束：成功 OSD 基线与候选版 SDRAM/RGB/PLL/SDRAM约束文件及 routed DQ path完全一致。因此目前没有证据把条纹归因于“候选的 Brent 缩位”直接改变了采样代码；但动态文字 renderer 的其余逻辑会改变布局布线，不能由 RTL 文件相同推成两个完整 routed netlist 等价。黑底白字正常降低了“全屏 serializer/接收器普遍坏掉”的可能性，但仍不是电气测试。

已知公共 TLAST 问题在成功基线中也存在，现有证据没有显示它在这两个版本间发生变化；本审计不把它认定为新故障或条纹根因。

## 建议的最小可测试方案

1. **先做单一诊断位流，分开底图链路与 HDMI 后段。** 在视频 RGB 进入 OSD/最终 HDMI 输入前加可选的纯色/逐行色带测试源，运行时绕过 SDRAM 底图读出，但保持同一 HDMI serializer、PLL、引脚与接线。实物显示该测试源：若仍有相同竖线，优先查 renderer/serializer/HDMI 输出与接收端电气时序；若纯色干净而真实底图有线，优先把观察点推进到 DQ捕获、FIFO、unpack。此项是诊断隔离，不能单独证明哪一级是根因。
2. **仅在测试源干净时，做 SDRAM DQ 捕获窗 A/B。** 先核对 `EG_PHY_SDRAM_2M_32` 的准确时序模型、AC601板级 SDRAM走线/器件速度等级，再保持图像/HDMI其余功能一致，每次只改变一个读采样相位/捕获边沿设置，生成独立候选位流并用原卡同一静态图对照。保留当前 `data_d1` 数据/valid关系作为一组基线；不要同时改 serializer、renderer 和 unpack。由于当前 DQ 初始捕获藏在加密 SDRAM IP 内，需先确认可控制的capture点和 PLL/工具支持，不能把任意改 `SDR_READ_DATA_DELAY` 当成采样相位扫点。
3. **每次候选只看两个可复现指标：** 同一素材/接线/显示器上条纹是否在固定列出现；对明确列出 ROI 做照片/视频或屏幕采集。记录位流 SHA、PLL相位、候选 RTL diff、路由 DQ path/约束及用户现场结果。STA 只用于确认约束变化和名义时序结果，最终电气判断需实物观察，最好进一步用片上可观测/逻辑分析或示波器测 SDRAM CLK/DQ。

## 未完成与限制

本审计未访问板上逻辑分析器/示波器，未探测 SDRAM CLK/DQ，未读取 HDMI 接收端 timing spec，也未解密或证明 `sdr_as_ram` 的完整内部寄存器结构；实际 DQ 输入采样窗、供应电压/温度裕量、条纹像素坐标和数据字错位均未证实。不能仅凭 STA PASS 认定物理接口正确，也不能因告警存在就认定它造成条纹。需将候选现场条纹现象与本报告合并复核。
