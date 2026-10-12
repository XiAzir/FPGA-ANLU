# T22 本地验证范围

- RGB整数golden穷举256×9×5（三通道同时覆盖全部字节），加混色/非法索引，共11,524vectors；负值除法显式floor与0..255饱和。
- 控制器缩放时钟行为模型：短/长按、去抖、组合优先、连续组合计时、全放rearm、单tone脉冲、亮度/对比度端点饱和、VS提交。
- 默认真实25MHz参数层级断言：DB500000、HOLD37500000、PULSE/GAP2500000；真实旧key_press_debounce的50ms路径缩放集成，低100ms/高100ms，忙时1位pending。
- 3整帧模型：默认恒等、B+64/C1.50、B-64/C0.50；800×480×3=1,152,000周期，24,576参数栏周期逐字模/数值/颜色比较；原OSD/RUN/滚动模块并行golden路径保留原色，DE消隐原样透传。
- 根代理复核并重跑RGB/控制模型，修正生产参数乘法溢出、多process pending驱动、pressed同步reset/非法B fallback、组合键阈值同沿优先；此前缩放初版PASS不构成最终通过，pre_review日志保留。
- parent_source_audit.json：原141文件verified快照全部SHA复核；继承user_source仅top集成/player_status_monitor BUILD_ID变化，音频FIFO/FAT/SDRAM/HDMI/PHY/时钟约束哈希保持。
- 只读gpt-6-luna集成复核未见新增必改项；主代理负责完整构建/产物与资料留档。

模型不含加密HDMI/SDRAM核内部时序或实板PHY；默认周期断言不是连续真实25MHz 1.5秒硬件测量。1位播放按键pending会合并忙时多次快速tap，编辑模式逐次按释放生效。
