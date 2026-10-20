# C11306 显式系数 ROM read-path 只读核查

日期：2026-10-13。范围仅为 ROM 原语映射、TD 官方资料和行为仿真分支。没有改动 `development/player_spectrum_private_init` 的源文件、构建产物或交付包，也没有启动新综合或 route。

## 结果

**有一项明确的 twiddle 原语控制映射差异，值得作为频谱为空的首要未决点；但本地可读资料不足以证明它单独造成了板测失败。** C11306 系数的 INIT 值正确并不能证明 PDPW8K 读控制与旧推断 ROM 等价。

Hann 的 9-bit `SP8K` 读路径基本符合原推断映射：同为 9-bit、A 口地址 `{win_index,3'b111}`、`sys_clk`、`cea=ST_WIN_REQ`、`OCEAMUX=1`、`REGMODE=NOREG`；C11306 多了显式 mux 常量，未见功能性差异。

Twiddle 的宽度/数据线/地址/时钟是匹配的：两者都用 `PDPW8K`、`DATA_WIDTH_A/B=18`、同一地址送 A/B 并在低位补 `4'b1111`、A/B 都是 `sys_clk`，`OCEAMUX/B=1`、`REGMODE_A/B=NOREG`；`doa` 接逻辑 lane 的低 9 位，`dob` 接其高 9 位。C11306 的 A/B 输出拼接方向与 C11305 推断网表一致。

**twiddle 的 enable/select 映射不同：**

| 项目 | C11305 推断 ROM gate | C11306 显式 ROM gate |
|---|---|---|
| `CEAMUX/CEBMUX` | `0 / 1` | `SIG / SIG` |
| `CSA0/1/2`, `CSB0/1/2` | `1/1/SIG`, `1/1/SIG` | 全部 `1` |
| `cea/ceb` 信号 | mux 常量，无动态 CE 端口连接 | 两口均接 `ST_FFT_ISSUE` |
| `csa/csb` 信号 | 两口最高位均接 `ST_FFT_ISSUE` | 两口固定 `3'b111` |
| 写使能 mux | `WEAMUX=1`, `WEBMUX=0` | `WEAMUX=0`, `WEBMUX=0`，显式 `.wea(0)` |

所以 C11306 把 `ST_FFT_ISSUE` 从 CS 选择端移到 CEA/CEB 端。NOREG、OCE=1、时钟和 q 拼接相同；**但是 CEA/CEB mux 的时钟使能与 CS 的 RAM 选择不是可从 INIT 审计推出的等价关系**。当前最明确的 read-path 风险就是这处变化。`WEAMUX` 的差异也需结合 PDPW 原语定义查证，不能仅凭参数名判定是否有写副作用。

## 证据与边界

- C11304 推断 ROM：`development/player_spectrum/build/manual/AC201_tf_hdmi_gate.v`。twiddle 两个 `ramread4_syn_4_512x32` primitive 的参数、地址和控制见约 213316–213459 行；该两路明确为 18+14 bit。SHA256：`5DAB202F00B97E6AC7512C252CD9DF7E5FD2087341E8BC2BE612803B8CE69052`。C11305 基线 PHY gate（`development/player_spectrum_baseline_phy/build/manual/AC201_tf_hdmi_gate.v`）对应 twiddle 两路见约 212646–212787 行，参数控制映射相同；SHA256：`67C6B73419486532A009914E9338C725A7353A02AD59721FE41BA57012CF3B95`。
- C11306 实际 synthesis gate：`development/player_spectrum_private_init/build/manual/AC201_tf_hdmi_gate.v`。Hann 及 twiddle explicit primitive 实例行号为 213891、213965、214039、214115；twiddle high 参数段 213974–214038、端口段 214039–214049；twiddle low 参数段 214050–214114、端口段 214115 之后。SHA256：`DC1F8B483DA6335B88BBD87B4FE34FAA3A190D71FDE62F5D09E6DFDCB450D9BF`。
- C11306 已有的 `routed_rom_init_audit.json` 证明 route netlist 的四个 BRAM INIT 值匹配，不能证明原语 read controls 功能等价。
- TD 6.2.1 `sim_release/eg4/eg_phy_bram.v` 的 module 声明在第 83 行起，源码被 `pragma protect` 包围；可读参数注释把 CEAMUX 说明为 DFF clock-enable mux、OCEAMUX 说明为 output clock-enable mux，且 18-bit 模式要求 `PDPW8K` 或 `FIFO8K`。这个文件不是可交给 Icarus 的完整行为模型。
- 本机官方 [UG301 EG4 Libraries Guide](C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/doc/UG301_EG4_Libraries_Guide_for_HDL_Designs.pdf)，2023.04，PDF 第40–44页（印刷页33–37），覆盖 `EG_LOGIC_BRAM` 端口/属性并给出 `EG_PHY_BRAM` 例化；未找到 PDPW8K 读周期、CE/CS优先关系或两输出配对的时序图。因此上述参数差异可以确认，效果不能只据此定论。
- 用 C11306 提供的 Icarus 12.0 执行 `PRIVATE_ROM_BEHAVIORAL_SIM` 分支；`sim/tb_coeff_rom.v` 对 1024 Hann、512 twiddle 地址、twiddle-only 读和 disable-hold 全部 PASS，日志为 `build/iverilog_behavioral.log`、`build/vvp_behavioral.log`。这是独立等价行为分支，未调用官方 `EG_PHY_BRAM` primitive，**不是硬件 primitive 仿真证据**。

## 下一步建议

若继续修改，建议新建单独候选，只调整 twiddle primitive 控制映射以对齐原推断 gate（CE mux 常量和 `CSA/CSB` 由 FFT issue 控制），保持 INIT、算法和其余播放链路不动；并在提交前确认 PDPW8K 下 `WEAMUX` 的预期静态值。若 TD 可执行原语的 gate-level 仿真，先让两个配置对相同 512×32 表做周期级读出比较，再决定是否板测。当前没有证据要求改变 Hann ROM、系数值、twiddle 地址或 `doa/dob` 拼接。
