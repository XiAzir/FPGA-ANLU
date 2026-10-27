# C41 SDRAM 周期刷新规格与计数复核

日期：2026-10-27（Asia/Shanghai）。只读资料/RTL复核；未运行 TD、整机仿真、硬件操作或网络检索。只检查 C40 宏与已提取的公开前缀，不读取 `pragma protect begin_protected` 后内容。

## 更正与结论

原厂 EM638325 数据手册现已补充确认：Features 页规定 **4096 refresh cycles / 64ms**；第 16 页 AutoRefresh 正文同样规定 64ms 内 4096 次刷新。以原厂器件要求为准，C40 刷新间隔应按 4096 次计算。原报告从 APUG011 的 `2**ROW_WIDTH` 和 `ROW_WIDTH=11` 推断 2048 次的判断作废：它把行地址位数当成了器件要求的刷新命令次数，不能代表 EM638325 规格。来源为原厂 PDF：[EM638325 Rev. 3.2](https://etron.com/wp-content/uploads/2022/04/EM638325_Rev-3.2.pdf)，Features（PDF 第 1 页）及 AutoRefresh（PDF 第 16 页）。

- 保留 `ROW_WIDTH=11`，它描述 SDRAM 行地址宽度，不代表刷新次数。`BA_WIDTH=2` 继续用于 bank 地址。
- 宏需以器件命令数 4096 计算，且把计数器由 0 起计、终值包含在周期内的 1 拍计入：

  ```verilog
  `define SDR_CLK_PERIOD          (1000000000/50000000)
  `define SELF_REFRESH_INTERVAL   (64000000/(`SDR_CLK_PERIOD)/4096-1)
  ```

- **50MHz**：`SDR_CLK_PERIOD=20ns`；理想间隔 `64ms / 4096 = 15.625us = 781.25 clocks`。整数安全请求间隔取 781 clocks，故终值为 **780**，公开计数周期 `0..780` 共 781 clocks，实际间隔 **15.62us**。4096 个间隔覆盖 **63.97952ms**，距 64ms 窗口尚有 20.48us；每次间隔相对 15.625us 理想值短 5ns。
- **100MHz**：`SDR_CLK_PERIOD=10ns`；理想间隔为 1562.5 clocks。整数安全请求间隔取 1562 clocks，故终值为 **1561**，公开计数周期 `0..1561` 共 1562 clocks，实际间隔同为 **15.62us**。4096 个间隔同样覆盖 **63.97952ms**，距 64ms 窗口尚有 20.48us；每次间隔短 5ns。
- 先保持 50MHz；50→100MHz 另行处理。两个计算点均依据原厂规格；周期请求节拍并非实际 AREF 命令的端到端实测。若控制器因读写忙延迟服务请求，须确认服务延迟不会耗尽窗口余量。加密调度区未检查，本文不对其作行为断言。

## 旧公式差异及 off-by-one

- APUG011 v1.2 第 2.5 节（PDF 第 9 页）给出的通用说明称 SDRAM 在 64ms 刷新所有行，并示例用 `2**ROW_WIDTH` 计算 `SELF_REFRESH_INTERVAL`。在此工程 `ROW_WIDTH=11` 时结果对应 2048 个行地址步进；但 EM638325 原厂数据手册明确要求 4096 个 refresh cycles/64ms，因此按 `2**ROW_WIDTH` 作为命令数会将刷新频率减半，不能满足已知原厂规格。应改用原厂给出的4096次。
- `SELF_REFRESH_INTERVAL` 表示计数回绕比较的终值。计数器从0开始并在等于终值时归零，故周期长度是 `终值+1`。宏内的 `-1` 用来抵消这一个计数拍。50MHz 若只括号化原公式，宏值1562会产生1563 clocks，即 31.26us；相对 APUG 的 2048假设预算31.25us，差为 **0.5个20ns时钟周期，即10ns**，并且相对原厂4096次要求更是约慢一倍。此次结论以原厂4096要求为准，不能采用1562周期作为最终间隔。
- 前缀中的 `ref_req` 在 `SELF_REFRESH_INTERVAL-10` 拉起，减10用于原有请求对齐。它不改变周期请求间隔；公开前缀测试应改为预期 50MHz 脉冲间隔781周期、100MHz为1562周期。现有 fixA/fixB日志预期1563周期，属于旧公式结果，需在 C41 修复验证时更新。

## 精确本地证据

1. `E:/QQ CACHE/Download/安路资料/赛题1_工作资料/04_补充芯片手册/DS301_EG4S20数据手册_v2.7.8_官方.pdf`：PDF 第 7 页 §4 确认 EG4S20 内嵌 SDRAM 为 EM638325、容量2M×32；该 DS301 自身没有列出刷新周期表。
2. 原厂器件依据：[EM638325 Rev. 3.2 PDF](https://etron.com/wp-content/uploads/2022/04/EM638325_Rev-3.2.pdf)：Features（PDF 第 1 页）列 4096 refresh cycles / 64ms；AutoRefresh（PDF 第 16 页）正文规定 64ms 内 4096 次刷新。此原厂规格解决了此前本地资料的次数冲突。
3. `E:/QQ CACHE/Download/安路资料/赛题1_工作资料/02_关键IP与工具手册/APUG011_基于ERAM接口实现的高性能SDRAM读写v1.2.pdf`：PDF 第 9 页 §2.5 给出 64ms 刷新所有行及按 `2**ROW_WIDTH` 的通用计算；PDF 第 15 页 §7 再列示例宏，`defien` 为原文拼写。此通用算法与EM638325器件明确的4096 refresh cycles不能混同。
4. C40 生产公开头文件（只读）：`E:/VSCODE-project/FPGA-ANLU/development/player_video40_spi25/src/user_source/hdl_source/include/global_def.v:8-12`，`ROW_WIDTH=11`、`SDR_CLK_PERIOD=1000000000/50000000`、`SELF_REFRESH_INTERVAL=64000000/SDR_CLK_PERIOD/2**ROW_WIDTH`。
5. 已提取的 C40 公开前缀：`E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/refresh_macro/sdr_init_ref_public_prefix_C40.v:38-41` 有 4096次/64ms 注释及单位笔误（写为15.625ms，应为µs）；行101–107 为终值比较回绕计数器，行127–135 在 `SELF_REFRESH_INTERVAL-10` 请求刷新。文件在首个保护标记前结束。
6. 既有宏微测试记录：`E:/VSCODE-project/FPGA-ANLU/development/video40_work/timing_review/refresh_macro/README.md`、`prefix_fixA.log`、`prefix_fixB.log`。括号方案输出宏值1562，请求脉冲在cycle 1553、3116、4679，间隔1563。该结果已被原厂规格复核超越；它仅覆盖公开前缀请求节拍，不是生产构建或实际SDRAM命令验证。

## 宏影响范围与 50→100MHz 事项

- 对 C40 公开 HDL（排除 `.enc.v`）搜索 `SDR_CLK_PERIOD`、`SELF_REFRESH_INTERVAL`：相关定义仅在上述 `global_def.v`；允许检查的公开 `sdr_init_ref` 前缀中，周期宏仅用于刷新终值公式。`ROW_WIDTH`、`BA_WIDTH` 还用于 `sdram.v` 地址/Bank 端口宽度，保持原值。用途扫描不覆盖加密区。
- 50→100MHz 前，按4096刷新周期重新计算间隔；核对 SDRAM PHY/约束/相位与控制器最高频率；构建后确认 gate/routed 刷新请求不再常量化并复核时序；随后进行板上读写及长时间数据保持观察。当前 100MHz 控制器时序、实际 AREF 服务延迟、最终路由及硬件保持均未验证。
