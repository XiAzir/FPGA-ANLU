# C11205 backend/router 仿真审查

日期：2026-10-12（北京时间）  
范围：仅审查实际 `player_osd_state`、`frame_fifo_read`、`player_wipe_address` 三模块的跨域请求/ACK和读地址路由；未改 `src`、构建脚本或其他 TB。

## 复现与结果

在工程根执行：

```powershell
& 'development\player_transition_wipe\build\model\run_wipe_backend.ps1'
```

脚本用本工程 Icarus Verilog 编译实际 RTL，产出 `wipe_backend.vvp`、`wipe_backend_compile.log` 和 `wipe_backend.log`。最终日志包含 `WIPE_BACKEND PASS`，无 `FAIL`/`FATAL`：

编译通过。`-Wall` 只报告源码 timescale 继承，以及 32-bit `FRAME_WORDS` 常量接到 21-bit backend 地址/长度端口时的高位裁剪；230400 可由 21 位无符号端口完整表示。

- `streams=121 production_frames=121`：首幅完整图像，加两个方向各 60 个生产转场读帧；每帧均逐一核对 230400 个 `App_rd_en` 地址和对应路由地址。
- 两方向分别为 buffer 0→1 和 1→0。活动帧覆盖 8、16、…、472 行；最终 480 行提交态由 `player_osd_state` 将显示 buffer 切至目标 buffer、清除 wipe 状态，随后按新 buffer base 对完整帧做 passthrough 核对。
- `app_reads=28109056` 包含 overlap 定向用例与生产帧读；生产帧本身为 121×230400 个 word。
- `release_toggles=3`：首图一次，两次完整擦除各一次；不会因中间 wipe 帧额外 toggle。
- `PENDING_BURST PASS trigger_count=126 ack_delta=126`：在旧 256-word burst 期间提出新 frame request；ACK 观察时断言实际 backend 在 `S_ACK` 且 `burst_cnt==256`，旧上下文在 ACK 前保持 passthrough；ACK 后上下文为 old buffer 0、new buffer 1、8 行，随后从首地址完整读取 230400 word 并逐地址比对。

地址期望由 TB 的独立 host-side 公式计算，不依赖 DUT 内部 `cut_words/old_base/new_base`。生产读流要求线性基址连续递增，wipe 前缀应路由到新 buffer，剩余部分留在旧 buffer；最终提交态完整读新 buffer。

## 时钟与模型边界

像素域 25 MHz、memory 域 50 MHz，SD mailbox 域 25 MHz 且相位偏移；没有把 CDC 简化成同一时钟。帧间空白按 ACK 拉低、backend 完成整帧后再发下一请求，缩短为最短可复现握手间隔，没有模拟 60 Hz 的真实 VS 周期。

`fifo_wrusedw` 固定为 0、`App_wr_busy` 固定为 0、`Sdr_init_done` 固定为 1。没有实例化加密 vendor SDRAM、真实 FIFO、SDRAM 返回数据/valid 延迟、像素 unpack/FIFO 或 HDMI 像素输出；因此本结果只证明控制器发出的地址、请求 ACK/drain 边界和 wipe 路由，不代表 SDRAM 电气/时序、显示端逐像素、板级运行或硬件验收。

## TB 调试记录

初期曾出现两条 TB 自检失败，均由监测断言/启用时刻错误引起，未修改任何 RTL：其一把地址递增误判成路由 context 在 ACK 前变化；改为断言旧 context 下 `mapped_addr==app_rd_addr`。其二在 ACK 拉低并延迟数个 pixel 周期后才启用整帧地址监测，漏掉开头 8 个 word；改为在请求释放前启用监测，并在 memory posedge 采样本周期被接受的地址。修正后完整加严轮 PASS。

上述两次初期失败的原始重定向日志已被后续运行覆盖，未保留原始文件；此处只记故障类型与修正，不伪造原始日志。最终复现证据以 `wipe_backend_compile.log`、`wipe_backend.log` 和 `wipe_backend.vvp` 为准。
