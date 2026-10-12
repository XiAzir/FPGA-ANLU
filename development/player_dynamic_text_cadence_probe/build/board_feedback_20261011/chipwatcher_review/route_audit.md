# ChipWatcher / 状态读回路线核查

核查时间：2026-10-11。只读核查本机 TD 6.2.1 SP1 官方 SWUG111（2025.07，PDF 共 74 页）；同时用 SWUG110 核对“回读”含义。未打开硬件连接、未运行编译/下载、未改 RTL。

## 结论

- **ChipWatcher 可用于片内逻辑在线采样，但要把它插入设计并重新生成 bit。** 最轻的源码改动路线是 Read Design 后通过 Mark Debug 选信号；更灵活的网表路线是在 Optimize Gate 后加节点。两条路线都要继续完成后续 Opt/Phy 并 Generate Bitstream，再下载带 ChipWatcher 的新 bit。现有 cadence_probe bit 不能因此直接观测内部信号，也没有 SWUG111 所述的“现有 bit 上免重新布局布线读任意寄存器”的入口。
- **SWUG111 没有记载 Readback-based Signal Probe 或任意 FF/状态寄存器读回功能。** 手册中的 Read Design 后 Mark Debug 是“后续继续编译时插入观测逻辑”，不是下载后对已有配置做寄存器回读。SWUG110 所说的 Verify SRAM / Read Save SRAM 读回对象是配置 RAM 位流数据，不是用户设计的寄存器值；Verify SRAM 明确不含用户 ERAM 数据（打印页 19，PDF p.20）；Read Save SRAM 保存配置 RAM 帧数据（打印页 20，PDF p.22）。
- **EG4S20BG256 支持性未能由 SWUG111 单独确认。** 手册没有器件支持矩阵；本机安装中存在 ChipWatcher IP Catalog 包 `C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\ip\depot\ChipWatcher_1.0`，这只证明工具带有该 IP，不等于证明 EG4S20 映射/资源/下载链路支持。需在工程中确认 IP Catalog 可生成且该目标完成 Syn/Phy/Generate Bitstream；本次按要求未运行编译。
- **AL-LINK：** SWUG111 只写“硬件平台链接好后”下载，器件名自动识别；未点名 AL-LINK 型号、驱动或连接步骤。因此手册支持的是“JTAG 硬件连接已建立后在 Watch 窗口下载”的一般路径，不能据此确认具体 AL-LINK 在本机当前可用。若 Watch 的 Device 未识别，手册要求先检查硬件平台连接。

## 可执行路线和 GUI

1. **源码插 IP（适合固定选定少量信号）**：`Tools -> IP Catalog -> Debug -> ChipWatcher`，配置 probe 数、位宽、采样深度并例化连接。保存后从 Read Design 跑至 Generate Bitstream；不需 Opt Gate 中另加信号时，中间不用交互。完成后打开 ChipWatcher，`Watch` 下载并采样。（SWUG111 PDF pp.6–10 / 打印页 2–6）
2. **Read Design 后 Mark Debug（不用改 RTL）**：Flow 到 Read Design 后，通过工具栏 ChipWatcher 图标、Hierarchy 下双击 ChipWatcher，或 `Tools -> Debug Tools -> ChipWatcher` 打开；对目标信号右键 `Mark Debug`，`Save`，然后继续 Flow 到 Generate Bitstream。源码自带 `MARK_DEBUG` 也会在综合后分配到 ChipWatcher，但同样要编译。（PDF pp.12–19 / 打印页 8–15）
3. **Optimize Gate 后加网表信号**：Flow 到 Optimize Gate 并 `Open Run` 后，用上述入口打开 ChipWatcher，在 Net View 点左上 `+ / Add Nodes` 选择网表信号，保存后继续 Opt/Phy 至 Generate Bitstream。如果 Flow 已跑过 Phy，可在 Flow Runs 对 `phy(active)` 右键 `Reset runs`，等自动回到 Open Run，再插入探针。它允许不重跑到 Optimize Gate 前的步骤，但**仍需重新跑后续物理优化并重新生成 bit**。（PDF pp.20–33 / 打印页 16–29）
4. **实板采样**：bit 生成后在 ChipWatcher 设置窗口点 `Watch`；Watch 的 JTAG Configuration 窗口在平台连接后可下载 bit。Device 自动识别；波形区可 `Add Signals`，在触发区加触发条件后点 `Single Trigger` 或 `Continue Trigger`。`Instant Trigger` 会忽略触发条件并立即刷新。（PDF pp.21、37–46 / 打印页 17、33–42）
5. **导出**：Watch 页面 `File -> Export Wave Data` 导出 CSV（PDF p.50 / 打印页 46）；如需离线复现，ChipWatcher 设置页 `Export` 输出 `.bit`、`.cwc`，可选 `.data`（含保存的波形配置/上电触发设置），离线调试至少需要 `.bit` 和 `.cwc`（PDF pp.21、57–58 / 打印页 17、53–54）。

## 与 LA / VPI 的区别及前置准备

- SWUG111 的 ChipWatcher 是片内逻辑分析仪：新插探针和采样 RAM 消耗 FPGA 资源；调试路径依赖重新编译。
- Virtual Probe Interface (VPI) 用于运行时驱动和监看接入的信号，也要源码例化并连接；其输入/输出探针可接 ChipWatcher 观察。它不是读取任意既有寄存器的免改版方案。（PDF pp.60–65 / 打印页 56–61）
- 本机可以**先做离线准备**：复制一份工程/Run用于插入探针；选定内部状态信号、时钟域和触发条件；配置采样深度/探针；确认该目标的 IP/器件映射能力；准备后续重新编译。由于尚未确认 EG4 支持和 AL-LINK 在线识别，不能预先完成有证据的实板采样或导出实际数据。

## 依据

- 官方本机文件：`C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\doc\SWUG\SWUG111_Debug_Tools_User_Guide.pdf`（SWUG111，2025.07）。资料副本：`E:\QQ CACHE\Download\安路资料\赛题1_工作资料\02_关键IP与工具手册\SWUG111_TangDynasty调试工具使用指南_v1.0.pdf`。
- SRAM 回读区别：本机 `C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\doc\SWUG\SWUG110_BitWizard_User_Guide.pdf`，打印页 19–20（PDF pp.20、22）。
- 页码均同时给 PDF 阅读器页码与手册印刷页码，便于定位。
