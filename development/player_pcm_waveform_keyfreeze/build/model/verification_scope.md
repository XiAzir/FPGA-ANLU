# C11204本地验证范围

根代理独立重跑全部以下模型，通过后才构建/封存。控制器与wave专项由gpt-6-luna实现TB及只读审查，未修改音频或其它链路。

- `run_waveform_model.ps1`：继承量化/min-max/1024完整窗/像素/stale等303检查，freeze输入绑0。
- `run_control_model.ps1`：原控制38项检查，25MHz默认计数位宽、原单键/长按/参数/legacy队列。
- `run_short_chord_model.ps1`：11项新组合键检查及脉冲不连续监视，缩放消抖/hold；不是真实按钮测量。
- `run_keyfreeze_wave.ps1`：819项，既有front优先、back ready不覆盖、两bank全字保持、stale/新样本、恢复丢弃partial、换源优先、同沿VS/toggle及快速取消；专项SAMPLES1缩放时间，默认参数另144000个密集事件无自动freeze。
- `run_integration.ps1`：默认SAMPLES8，本地音乐1024点按520/521周期输入，128组独立hostgold；两帧768000时钟、全部512图形列58368像素核验，原B/C/OSD/RUN/滚动/blanking像素保持。
- `run_keyfreeze_music.ps1`：同真实音乐窗口与节拍，先完整VS显示，再手动请求和第二VS冻结；之后持续密集新极值输入，两帧全512列仍为原hostgold，HOLD标题可见，外区功能保持。密集输入为压力条件，不是实际48k完整曲目。

TD构建/时序的最终结果另见build/manual与候选info。行为模型未包含vendor物理BRAM、加密HDMI核、PHY、真实TF及显示器，不称板测通过或重影根因已确认。顶层short chord到wave仅同步直连，新wire连接经正式综合；模块模型分别验证事件生成与响应，未模拟整机真实开关及外设。
