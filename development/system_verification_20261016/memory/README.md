# 帧缓存与 SDRAM 模型边界

`framebuffer_20261016_174140/summary.json` 是首个完整数据验证通过凭据：真实 C11206 冻结的 `frame_buffer_rgb888`、读写后端、异步 FIFO、RGB888 pack/unpack 与翻转映射，写入并读回 640×480 全帧，307200 个输出像素逐项匹配独立坐标 RGB。两侧各 230400 个 32 位存储字。测试在 Icarus Verilog 执行；写端最多每两拍一个像素，以检查真实 ready/背压，未改生产 loader 的十拍输出节奏。

负例在写完后翻转存储首字一个 bit，检查器在首像素发现 `got=000001 want=000000` 并退出失败；runner 将这种**预期检出**单独记为负例通过。具体日志在同目录 `positive.log`、`negative.log`，所有编译输入均已复制并记录 SHA。

## 尚未证明的部分

`sdram_app_model.v` 是明确假设的应用接口存储模型：数据领先 valid 一拍、初始化后不主动刷新/施加 busy、保留未写位置为 X、地址越界或写入 X 报错。它用于验证真实后端/队列/编解码，**不是原厂 SDRAM 控制器或物理存储的功能、时序、刷新资格**。ModelSim并行背景读/写已另行通过（framebuffer_modelsim_20261016_180602）：184832个背景读与230400个有效读分开统计，重新发读帧并清FIFO后307200像素匹配；仿真副本在两处FIFO占用输入显式补0，保留差异与SHA。擦除转场、双缓冲交替等不能从这些测试继承通过。

原厂 protected 控制器的独立编译尝试保留在 `vendor_20261016_172047`，ModelSim10.1c 对 unsized concatenation 报错；TD自带物理宏直接探针无已知读回（physical_probe_20261016_182532）；APUG011官方IS42s32200总线模型同探针CAS2/3读回正确（182751）。随后用生产冻结SDRAM源码独立TD综合成gate，保留真实控制逻辑和原厂PAD，与APUG引脚模型配对。256字基础测试（controller_model_20261016_183434）零差错，确认数据领先valid一拍；1024字四bank/写掩码/刷新后读回正例（184042）也零差错，负例与最终汇总另见extended_matrix.json。它不是完整顶层实际实现、SiP电气或完整SDF资格。不能把替代接口模型通过写成原厂模型通过。

## 复跑

```powershell
python development/system_verification_20261016/memory/run_framebuffer.py
```

每次生成新的时间戳目录，不覆盖历史结果。较早的 framebuffer 目录是超时/性能调查或人工终止的夹具尝试，未获得 PASS；不能据此认定稳定 C11206 逻辑失败。

## 真实控制器复跑

```powershell
$env:MGLS_LICENSE_FILE=[Environment]::GetEnvironmentVariable('MGLS_LICENSE_FILE','User')
python development/system_verification_20261016/memory/run_controller_gate.py --matrix
python development/system_verification_20261016/memory/run_controller_gate.py --matrix --corrupt-data
```

runner核对controller_gate_latest.json中的综合网表SHA，保存每次输入与完整数据轨迹。保留真实131072拍power-up等待（约2.624ms），不force内部状态。读取期间DM须回0；DQM掩码同时影响读输出，原扩展fixture保持1010导致512个不匹配，已修正并保留失败证据。生产App_wr_dm固定0，未将测试台问题当作板端黑屏根因。
