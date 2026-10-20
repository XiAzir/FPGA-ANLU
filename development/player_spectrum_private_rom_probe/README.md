# 频谱系数独立 BRAM 初始化 probe

本目录把 C11305 频谱系数 ROM 改成显式 EG4 `EG_PHY_BRAM` 初始化参数，用独立小工程检验 TD `eram_init off` 时 gate 网表仍保留原系数。目录为隔离 probe；未修改 C11305 或主代理准备的 C11306。

## 模块接口与接入

`src/spectrum_coeff_rom.v` 由 `src/gen_private_spectrum_rom.py` 生成。模块接口为：

```verilog
module spectrum_coeff_rom #(
  parameter HANN_FILE = "spectrum_hann.mem",
  parameter TWIDDLE_FILE = "spectrum_twiddle.mem"
) (
  input wire clk,
  input wire hann_en,
  input wire [9:0] hann_addr,
  output wire [15:0] hann_q,
  input wire twiddle_en,
  input wire [8:0] twiddle_addr,
  output wire [31:0] twiddle_q
);
```

综合分支使用四个只读物理 bank：Hann 1024×16 拆成 9+7 位；twiddle 512×32 拆成 18+14 位。18-bit bank 将原语 A/B 两组 9-bit 输出按 `{dob, doa}` 合并。4 个 bank 的 `CEA/CEB` 由对应的 enable 控制，保持 analyzer 原先 `ST_WIN_REQ` / `ST_FFT_ISSUE` 的同步读使能和读出保持行为；原语本身完成一个时钟周期的读延迟，没有额外包装寄存器。模块没有复位端口，首次使能读之前 q 未定义，和原 analyzer 的未初始化 ROM 输出边界一致。

C11306 接 analyzer 时可删掉原 `hann_rom`、`twiddle_rom` 数组及其 `$readmemh` 初始化，声明 `wire [15:0] hann_q` / `wire [31:0] twiddle_q`，将 `hann_en` 接原 `state == ST_WIN_REQ`、地址接 `win_index`，将 `twiddle_en` 接原 `state == ST_FFT_ISSUE`、地址接 `twiddle_addr`。此目录没有修改主代理的 C11306 工程。

## 生成与 probe

```powershell
python src/gen_private_spectrum_rom.py
python src/make_td_project.py <C11305 的 AC201_tf_hdmi.al 路径> src/td_project/spectrum_coeff_rom_probe.al
& 'C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe' 'E:/VSCODE-project/FPGA-ANLU/development/player_spectrum_private_rom_probe/scripts/synth_probe.tcl'
python src/audit_probe_gate_init.py
```

本次在 TD 6.2.1_SP1_6.2.178.840 完成的是**独立 4-ROM synthesis probe**，非全设计。日志确认 `syn_1 gate::eram_init::off` 设置成功，面积报告为 4 个 BRAM9K、0 LUT、0 寄存器；gate 网表有 4 组 EG_PHY_BRAM INIT/INITP 参数。`build/probe_gate_init_audit.json` 将 gate 参数逐 lane 解码并与 MEM 比较：Hann 1024/1024、twiddle 512/512 全字一致，1536 个地址均被比较，差异为 0；其中 1532 个逻辑系数非零、4 个 Hann 系数为 0。合并后 SHA256 分别与 C11305 审计值一致：Hann `baf7df624b80fcd112ba3cdf1a5e6052d53a9a187aa14870d274ad8de75c9c3f`，twiddle `b7782524c8b0d3b7a42d4f5e59a8e1a34f9b5328f01795baa7779388027c5259`。

证据在 `build/synthesis_console.log`、`build/spectrum_coeff_rom_probe_gate.v`、`build/probe_gate_init_audit.json`。结论限于 TD synthesis 后 EG_PHY_BRAM 初始化参数在 `eram_init off` 下保留且逐字正确；此 probe **未生成 bitstream、未做布局布线、未上板**，所以不宣称位流解析、主工程其余 RAM 初始化、C11306 音视频或实板通过。

## 仿真与代价

定义 `PRIVATE_ROM_BEHAVIORAL_SIM` 时走 `$readmemh` 行为分支，仍按 `posedge clk` 在 enable 为 1 时更新输出、enable 为 0 时保持。`sim/tb_coeff_rom.v` 覆盖 1024 个 Hann 地址、512 个 twiddle 地址、独立 enable 与 disable hold。已用工程自带 Icarus Verilog 12.0 运行并通过；日志在 `build/iverilog_behavioral.log` / `build/vvp_behavioral.log`。这是独立行为分支仿真，TD 随包的 `EG_PHY_BRAM` 模型为受保护源码，未将其当作官方物理原语仿真证据。运行方式：

```powershell
& 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe' -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM -o ../build/tb_coeff_rom.vvp ../sim/tb_coeff_rom.v spectrum_coeff_rom.v
& 'E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe' ../build/tb_coeff_rom.vvp
```

原 C11305 gate 已用 4 个物理 BRAM 映射这两个 ROM；probe 也使用 4 个 BRAM9K，故当前实现未增加 BRAM 块数。代价是代码绑定 EG4 `EG_PHY_BRAM` INIT/INITP 位平面和地址打包规则，需随器件或 ROM 数据变更重新生成并审计；TD gate 的全局 `eram_init off` 仍会影响本模块以外的 RAM/FIFO，不能据此推断那些存储器仍带初始化。
