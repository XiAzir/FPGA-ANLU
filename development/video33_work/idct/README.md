# IDCT DC-only 快速路径候选

工作目录隔离在 `development/video33_work/idct/`；未修改共享 C32 或根候选源。

## 候选 RTL

`jpeg_idct_dc_fast.v` 接口与基线 `jpeg_idct` 相同，适合在 JPEG core 实例处替换。候选把每个已接受 EOB 块放入 8 项顺序描述队列，保存 DC-only 标记与 DC 值；输入 RAM 和 ID FIFO 空间共同约束上游 `inport_accept_o`。所有块仍按原顺序写入输入 RAM。

DC-only 块的 RAM 读出仍用 64 拍完成槽位回收，数据不进入 X/Y 共享核心，输出端按原索引置换连续产生 64 个常量样本。精确 DC 值复刻两级 signed 32-bit 乘 2896、算术右移 11，最终右移 4。非 DC 块仍走原始 X/Y 核心。候选禁止跨当前块预读下一 RAM 槽，确保 DC/AC 混合时的队列顺序；这一选择使普通块平均多 13 拍启动开销。

`jpeg_idct_dc_2pass_fast.v` 保留先前较保守的候选：X 趟正常计算，Y 趟旁路。它逐值通过，但每个 DC 块仅省 10 拍；当前 `jpeg_idct_dc_fast.v` 才是整块旁路版本。

## Icarus 对照

用 PowerShell 从项目根目录编译 `tb_compare.v`，加入基线与候选 RTL：

```powershell
$iv = 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vv = 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
& $iv -g2012 -s tb -o development/video33_work/idct/tb_compare.vvp `
  development/video33_work/idct/tb_compare.v `
  development/video33_work/idct/jpeg_idct.v `
  development/video33_work/idct/jpeg_idct_dc_fast.v `
  development/video33_work/idct/jpeg_idct_ram.v `
  development/video33_work/idct/jpeg_idct_ram_dp.v `
  development/video33_work/idct/jpeg_idct_transpose.v `
  development/video33_work/idct/jpeg_idct_transpose_ram.v `
  development/video33_work/idct/jpeg_idct_y.v `
  development/video33_work/idct/jpeg_idct_fifo.v
& $vv development/video33_work/idct/tb_compare.vvp
```

结果：82 块、5248 个输出样本逐值对照，数据、索引、ID 均无差异。含 DC 0、±1、±128、±32768、32767、64 个 16-bit LCG 值；含普通 AC 合成块、混合顺序、真实素材量化后系数块。输出接受端先保持 100 拍低电平，同时排入 4 个 DC 块；输入 RAM 队列达到 4 项后候选拒绝新块，再放行并按序完成。另在 DC 输出中段复位并丢弃 20 个已输出样本，重启后 64 个样本对照无残留。

负控脚本 [`tb_negative_control.ps1`](./tb_negative_control.ps1) 临时把 DC 乘数 2896 改为 2895；对照报 3520 项差异并以预期的非零退出结束。脚本会删除临时变体与仿真镜像。

独立持续供数测试 `tb_throughput.v` 对 80 块（64 DC-only、16 AC）分别驱动基线和候选，不用较慢实例的 ready 信号节流另一实例。实测基线 10,509 拍，候选 6,609 拍，节省 3,900 拍（37.1%）。块间平均间隔：DC 块基线 131 拍、候选 67 拍；AC 块基线 131 拍、候选 144 拍。

## VIDEO.MJP Q65 素材覆盖

`jpeg_dc_stats.py` 直接解析 `development/video33_work/media1080/VIDEO.MJP` 中 7 个间隔抽样帧（帧 0、49、99、149、199、249、299）的基线 JPEG 熵流，解码 Huffman AC EOB，并按 DQT 反量化导出代表块系数。每帧均解析出 48,960 个 4:2:0 系数块。合计 342,720 块中 272,086 块 DC-only，占 79.390%；各抽样帧比例为 80.64%、79.47%、78.17%、78.43%、79.65%、78.52%、80.85%。`tb_compare.v` 中的真实块夹具来自帧 0，覆盖 Cb/Cr/Y DC-only，以及 Y/Cb 含多项 AC 的去量化块。

按抽样比例和持续供数间隔估算，IDCT 平均降至约 82.87 拍/块，较基线 131 拍/块节省约 36.7%。这仍不足以让 50 MHz IDCT 单独满足 15fps：约 81.1ms/帧，超过 66.7ms 预算。该测量只覆盖 IDCT，不代表整机 15fps。

## 资源与未覆盖项

候选新增两级定点常量乘法和 8 项描述队列。乘法可能映射为 2 个 DSP，按当前 26/29 DSP 估算会到 28/29；Slice 增量尚未由 TD 综合测量。依照根代理统一调度，未运行 TD 构建或完整系统仿真。

目前逐值覆盖了多组 DC 值、AC 负控、真实帧抽样块、混合块队列、输出启动背压、ID 顺序和复位重启。未做 65,536 个 DC 值穷举、随机背压中途改变、TD 时序/资源验证，也未将候选接入整机实测。板级 Slice 89.57% 的余量可能限制集成；整机 15fps 仍需由根代理按系统链路验证。

## DQT/MCU 前端 EOB 契约修正

C34 集成回归发现 MCU 的 EOB 与最后一个 coefficient valid 是分开的流水事件：`jpeg_mcu_proc` 在 `STATE_EOB` 脉冲 EOB，此时 coeff index 已回绕/截为 0 且 `outport_valid` 为低；DQT 又分别寄存 valid、index、ID 与 EOB。因此 IDCT 必须接受 standalone EOB。旧候选把 EOB 描述符入队、输入 RAM EOB 和 ID FIFO push 都要求与 valid 同拍，首块描述符被丢弃，后续只观察到 EOF。

当前集成版在整个块的已接受 valid 流中保存 DC，并累积 `idx!=0 && data!=0` 的 AC 标记；独立 EOB 到达时依据累积状态决定 DC-only/普通块，保存已采样 DC 与 EOB 的 ID，并将 EOB 传入输入 RAM 与 ID FIFO。EOB 当拍若同时有 valid 也参与块类型判定。C34 `jpeg_idct.v` 与本目录 `jpeg_idct_dc_fast.v` 为算法相同、模块名适配的版本。

真实前端集成复测命令：

```powershell
python development/video34_work/run_native_jpeg.py gradient
python development/video34_work/run_native_jpeg.py solid
python development/video34_work/run_native_jpeg.py blocks
```

三种 16×16 JPEG 均通过：RGB 256 像素、native IDCT 384 样本、YUV 96 字。该回归覆盖 C32 参考、C34 默认 RGB 与 C34 native 输出。源与 fixture 哈希见 `development/video34_work/native/source_binding_{gradient,solid,blocks}.json`；逐次日志见 `compare_{gradient,solid,blocks}.log`。
