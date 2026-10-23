# HDMI packet monitor 单元验证

## 范围和来源

此目录只包含 C29 后核音频观测候选与轻量 Icarus 验证。`hdmi_packet_monitor.v` 从 C28 原样复制；SHA256与C28源文件完全一致：`E0755EEF660DF07B56C576E6A07565B9189C50E68112F885CD2A08831B38024B`。本轮没有改动任何 monitor RTL。父任务确认先前关于 `win_tone_bad` 累计遗漏的判断来自阅读长输出时漏行，已收回；实际C28文件的正常窗口else分支已有`win_tone_bad<=sat_add(win_tone_bad,ev_tone)`，窗口到期输出也合并当拍`ev_tone`。

独立TB自行编码并行10-bit TMDS data-island输入：8个控制前导字、2个guard-band字、32字符packet与尾guard。header/body使用同一BCH LFSR规则生成校验；TERC字符按monitor解码表反向编码。音频packet含SP1，tone幅度参数为24'd1000000，与`player_audio_probe`实际tone实例一致。ACR有4个一致subpacket，按monitor字段映射编码N=6144、CTS=25000。`CLK_HZ=80` 缩短窗口；每个packet完整发送且没有跨reset。

## 复跑

PowerShell 7：

```powershell
& .\development\video29_work\packet_monitor\scripts\run_tests.ps1
```

工具通过共享`Resolve-AnluTool`定位；compile/simulation日志和vvp位于`results/`。

## 结果

Icarus Verilog 2012编译通过，仿真`PACKET_MONITOR_PASS cases=8 window=80`。覆盖：

- 同一island内两个连续合法SP1 packet；PCM正、负1,000,000，audio packet/sample计数为2，BCH/TERC/tone坏计数均为0。
- 错误幅度500,000并重算正确BCH：tone mode下tone_bad=1、BCH=0、audio packet正常计数。
- 两个窗口后无新packet，输出计数归零；另外独立空窗口也保持全零。
- 原声模式（tone_mode=0）送500,000样本时，monitor不执行内置tone幅度约束。
- 翻转header BCH parity：坏BCH计数增加1，合法audio packet不计数。
- packet中注入非法TERC字符：bad_terc增加且format/error sticky置位。
- 合法ACR四子包：输出N=6144、CTS=25000，ACR sticky置位，BCH/TERC为0。

Tone坏幅度事件在一秒窗口边界前被接收、窗口期满后从`tone_bad_sec`读到1；紧接着下一窗口无新packet则读到0。这验证现有window accumulator行为。由于C28源码本身已经含正确累计，不存在可做的“修前缺行/修后补行”差分；没有构造人为删行版本，也没有报告虚构的修复。

## C28板测页读数更正（来自父任务）

父任务复核完整视频页9后更正先前快读：图片block为`0x0282`（642），CRC `4490`；视频block为`0x004f`（79），CRC `0779`；首块`9dc4`也吻合。旧读数图片674 / 视频70应废弃，不再作为当前样本长度/文件进度证据。

## 边界

本测试验证`hdmi_packet_monitor`对构造的并行TMDS字流的解析与计数；不包含真实加密HDMI core、PHY/串行线路或实板packet采集。C29应可直接复用此字节一致候选；父任务如需实例化，仍应做其集成/综合/位流绑定和板测。
