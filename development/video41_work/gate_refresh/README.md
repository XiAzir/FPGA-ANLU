# Gate 网表实际 SDRAM AREF 计数准备件

用途：从 C40/C41 普通综合网表的 `EG_PHY_SDRAM_2M_32` 命令端口统计实际 AREF 命令，并同时记录刷新请求、ack 和命令间隔。这里只替换仿真副本里的 SDRAM 器件为空壳 sink；不模拟存储阵列、刷新保持或数据读写行为。无需读取/解密 `pragma protect` 源文件。

## 静态确认的 C40 节点

- 输入器件实例：`development/player_video40_spi25/build/manual/AC201_tf_hdmi_gate.v:104757`，`EG_PHY_SDRAM_2M_32 \\u_frame_buffer/u_sdram/sdram`。
- AREF pin 编码在该实例上直接采样：`cs_n=0, cke=1, ras_n=0, cas_n=0, we_n=1`；信号来自顶层内部普通网 `clk0/cs_n/cke/ras_n/cas_n/we_n`。
- C40 周期请求被常量化：行108042 `.../u2_wrrd/Sdr_ref_req` 输入接 `1'b0`；行108043 转接到 `.../Sdr_ref_req_syn_4`。ack 为 `.../u1_init_ref/Sdr_ref_ack`。
- C40 gate SHA256：`200C8DE5910970B96EA29A9913075BA96D07BCBEE1B398B541103332E4F301D6`。

## 文件

- `tb_gate_refresh.sv`：实例化重命名后的生产 gate，simulation-only force 时钟、reset、初始化加速计数器和读写闲置节点；等待生产 init_done 后计 req rise、ack rise、AREF 命令数与命令间隔。
- `eg_phy_sdram_shell.sv`：只将 DQ 三态化，便于命令 pin 观察；不提供虚构的 SDRAM 行为结果。
- `run_gate_refresh.ps1`：校验指定 gate SHA，仿真副本仅改顶层模块名，生成 source_binding 与隔离 ModelSim work 库。默认仅准备目录；只有传 `-RunSimulation` 才编译/运行。按要求本次未传该开关、未编译、未运行。

## 根执行时的命令

C40 baseline 与单请求注入各跑一遍；C41 gate 完成唯一 TD 综合后传入真实路径及 SHA。以下为根方可串行执行的示例：

```powershell
pwsh -File development/video41_work/gate_refresh/run_gate_refresh.ps1 `
  -Case C40 `
  -GateFile development/player_video40_spi25/build/manual/AC201_tf_hdmi_gate.v `
  -ExpectedSha256 200C8DE5910970B96EA29A9913075BA96D07BCBEE1B398B541103332E4F301D6 -RunSimulation -TargetArefCommands 0 -MaxMeasureCycles 3000

pwsh -File development/video41_work/gate_refresh/run_gate_refresh.ps1 `
  -Case C40 `
  -GateFile development/player_video40_spi25/build/manual/AC201_tf_hdmi_gate.v `
  -ExpectedSha256 200C8DE5910970B96EA29A9913075BA96D07BCBEE1B398B541103332E4F301D6 `
  -InjectC40Request -RunSimulation -TargetArefCommands 0 -MaxMeasureCycles 3000
```

C41 gate SHA256 为 `3D5C2DFAAA2BB07D458EA689A61114F1727CD0C5D51F36069982FACFFE8C3C9E`。C41 模式不注入请求；观察周期自动请求和实际 AREF 数。若 C40 注入单个请求得到 2 条 AREF，且 C41 显示每个请求平均 2 条 AREF，则 4096次/64ms 可由约2048次请求/64ms满足，C41请求周期应以约1562个memclocks核对；若比例为1:1，则需约781 clocks。以网表实测为准，再决定宏节拍。

```powershell
pwsh -File development/video41_work/gate_refresh/run_gate_refresh.ps1 `
  -Case C41 `
  -GateFile development/player_video41_refresh/build/manual/AC201_tf_hdmi_gate.v `
  -ExpectedSha256 3D5C2DFAAA2BB07D458EA689A61114F1727CD0C5D51F36069982FACFFE8C3C9E `
  -RunSimulation -TargetArefCommands 10
```

## 重要限制

1. Bench 中对 `sys_pll_m0/clk0_buf`、`u_legacy_frame_backend/frame_fifo_read_m0/mem_clk`、`Sdr_clk_sft`、`clk0`施加同相20ns仿真时钟；其中综合网表的 init counter/ref ack 寄存器由 `mem_clk`驱动。对 `rst_all` 进行仿真复位；短暂 force `pwr_200ms_cnt`跳过约200ms启动计数；init_done 后 force `rw_vld=0`隔离应用读写。所有 force 仅发生在 testbench 仿真，gate 文件保持 SHA 绑定。
2. C40 注入模式只用于测量“一个 scheduler 请求触发几条实际 AREF”，不代表周期刷新逻辑已在C40修复。对 C40 `Sdr_ref_req` 常量输出网的 force 会暂时覆盖该常量，仅此一次并随后 release。
3. 普通 gate 是工具映射网表；外部设备 shell 只观测命令。结果可证明当前综合网表是否发出 AREF、间隔及 req/ack 比例，不能证明 EM638325 数据保持、完整初始化时序或物理器件可靠性。
4. 运行脚本的 ModelSim 映射依赖清单参照 `development/video37_work/run_pin.ps1`，并按 C40/C41 普通网表 cell type 盘点：AL_MAP_SEQ/LUT1–6、EG_PHY_MSLICE/LSLICE/PAD/BRAM/PLL/CONFIG/GCLK、EG_PHY_MULT18（26个实例）及工具提供的 `buf`；脚本补入 `eg4/eg_phy_mult18.v`。C40 与 C41 均含上述同一组 cell type。TD安装位置为 `C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release`。若综合网表增加新 primitive，先补充对应厂商 sim_release 映射模块；不要用行为替身替换生产控制器。



