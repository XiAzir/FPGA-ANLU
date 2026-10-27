# C11335｜640×480/60Hz 接收端对照

此候选保持 33/165MHz PLL、HDMI Core/四lane PHY及串行 `EG_LOGIC_BUFG` 路由与 C11336 相同，只改栅格和 Core 几何参数，用于观察同一高频链路在约60Hz低分辨率扫描下是否被显示器识别。

## 时序

- 有效区：640×480。
- H：前肩16、负极性同步96、后肩248，总计1000像素。
- V：前肩10、负极性同步2、后肩58，总计550行。
- 像素时钟：33MHz；每帧550,000像素，计算刷新率60Hz。
- HDMI Core 参数逐项对应以上有效区、肩宽和同步长度；`VIDEO_VIC=0`，不向显示器发送 EDID 能力协商。
- build ID：`00C11335`；输出位流预期为 `build/manual/AC201_C11335_640x480_60hz_33_165_bufg.bit`。

该时序使用自定义总消隐，并非标准 640×480/25.175MHz 模式；用相同165MHz串行链路保留 PHY 变量，重点比较接收端对帧率/图像尺寸的接受情况。彩条测试不含媒体播放和音频。

- 工程：[AC201_C11335_640x480_60hz_33_165_bufg.al](src/td_project/AC201_C11335_640x480_60hz_33_165_bufg.al)
- 顶层：[top.v](src/user_source/hdl_source/top.v)
- 构建脚本：[scripts](scripts/)
- 一帧 ModelSim 时序夹具：[tb_vga60_timing.sv](../serializer_audit/tb_vga60_timing.sv)，实跑记录在 `../serializer_audit/vga60.log`。
- 目录本次建立时尚未运行 Tang Dynasty；构建、路由、时序和位流状态以本目录 build/manual 报告为准。

测试目的：与 C11336 分别加载，用同一显示器/HDMI线/板卡供电比较“高频PHY全局路由”与“自定义1080p15接收兼容性”。根代理协调顺序与现场判读。

## 构建结果（2026-10-27）

- Tang Dynasty 6.2.1 SP1（6.2.178.840）独立综合、布局布线、hold修复、STA和bitgen均完成；每步CLI退出码0，PID均已退出。
- 综合网表全局时钟资源：gclk 2。模型时序夹具与TD网表参数均使用33/165MHz，H=640+16+96+248=1000、V=480+10+2+58=550。
- Routed STA coverage 99.64%；pixel 32.999MHz、serial 165.017MHz；SWNS +1.755ns、STNS 0、hold修复后HWNS +0.041ns、HTNS 0。未建模显示器接收端/cable时序。
- P&R日志含 `PHY-5014` PLL `fbclk[0]` Detail route提示；该实例使用 `FEEDBK_PATH=VCO_PHASE_0` 且`fbclk`接常量0，此脚不参与所选内部反馈。日志保留供复核。
- 位流：[AC201_C11335_640x480_60hz_33_165_bufg.bit](build/manual/AC201_C11335_640x480_60hz_33_165_bufg.bit)，629,624 bytes，SHA-256 `627F77A1DD1B19F3130F78448FB10F589954CD417D9CEB60CF49F82BAA550C78`。
- TD阶段实测最大进程内存：综合WS/Private 173.5/288.4MiB；route 502.3/491.7MiB；hold 431.3/437.3MiB；bitgen 432.8/437.9MiB。各日志以 `build/manual/td_C11335_...log` 保存，单独进程均已退出。
- 源码修改：`top.v` 中几何/Core参数为640×480及1000×550，并给串行时钟加BUFG；`video_axis_1080p_adapter.v` 将行尾由固定1919参数化为H_ACTIVE-1；`video_timing_1080p_custom_colorbar.v` 新增负极性同步选择；build ID=`00C11335`。核心PLL/PHY与C11336相同。

HDMI Core wrapper没有H/V同步输入端口；本源的`hsync/vsync`诊断信号为低电平有效，Core实际输出由其加密实现按HSA/VSA等参数编码，未直接从可见信号接入，因此输出端控制符极性仍待现场/解密模型确认。上板操作见 [ON_BOARD_TEST_C11335.md](ON_BOARD_TEST_C11335.md)。
