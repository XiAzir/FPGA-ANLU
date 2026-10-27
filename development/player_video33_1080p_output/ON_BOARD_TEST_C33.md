# C33 1080p15 彩条诊断位流上板说明

版本：C33，显示内容标识 `00C11333`。用途仅为测试 AC201 现有 HDMI 接线是否能接受自定义 1920×1080、15 Hz 扫描时序；该位流没有 TF、SDRAM、BMP 解码、音频或播放器菜单。

## 位流与时序

- 位流：[AC201_video33_1080p15_diag.bit](../player_video33_1080p_output/build/manual/AC201_video33_1080p15_diag.bit)
- SHA-256：`DA3403C8390C27FE6579E7B0CFB060144464B6AFCC3A44A21D08885431CEB44D`
- HDMI 参数：有效 1920×1080，总计 2000×1100；H front/sync/back=8/8/64，V front/sync/back=4/5/11；RGB八色竖条、无音频。
- PLL：EG4 `No compensation`/`VCO_PHASE_0`；参考50MHz，REFCLK_DIV=2、FBCLK_DIV=33，VCO名义825MHz；CLKC0_DIV=25→33MHz像素时钟，CLKC1_DIV=5→165MHz串行时钟。SDC `derive_clocks` 报告由50MHz派生为33MHz和165MHz；TD最终报告实算32.999MHz和165.017MHz。
- 最终 routed STA：setup SWNS +1.606ns、STNS 0；hold HWNS +0.022ns、HTNS 0；覆盖率99.62%。输出使用现有 `LVDS33_E` 引脚，165.017MHz 靠近166MHz器件上限。报告没有HDMI接收器的板级输出延迟，时序结果描述FPGA内的约束模型。

## 接线与下载

1. 使用已验证稳定的“插座 + 普通5V USB电源适配器 + USB-A转USB-C线”给AC601/AC201供电，AL-LINK单独接电脑。板卡放在绝缘桌面，避免底部金属短接。
2. 需要更换 HDMI 线或接线时，先断板卡电源；连好显示器 HDMI 线后再上电。此诊断不需要插TF卡。
3. 在Tang Dynasty/BitWriter中选择EG4S20BG256，使用 `PROGRAM_SRAM` 下载上述位流。等待软件显示编程成功；编程期间保持供电和JTAG连线稳定。
4. 等待约30ms启动延时。数码管应轮显版本码 `C11333`；AC201 LED为低电平点亮：LED0亮表示PLL lock，LED1亮表示 HDMI Core 的 `video_locked`，LED2约每1.07秒翻转一次表示帧计数在运行，LED3亮表示启动延时结束。
5. 观察显示器是否识别输入、是否显示完整彩条、是否间歇黑屏/失锁；在显示器信息页面记录报告的分辨率、刷新率和输入状态。此模式使用总时序2000×1100及VIC=0，不属于常见HDMI标准时序，底板DDC未连FPGA，接收端兼容性必须通过实机判定。

## 回退与边界

需要返回原C32时，重新选择并下载原位流：[AC201_player_video32_read_return.bit](../player_video32_read_return/build/manual/AC201_player_video32_read_return.bit)。`PROGRAM_SRAM` 配置掉电丢失；确认没有烧录任务后可断板卡电源，再按需要加载对应位流。

C33是纯彩条与同步诊断；1080p视频读取/解码、音频、菜单和标准模式兼容性未在此位流中实现。ModelSim测试覆盖像素时序和EG4 PLL输出频率；HDMI Core加密实现无法由当前ModelSim解密，`video_locked` 指示及显示器识别仍需现场观察。若显示器拒绝该时序，这个结果只说明该接收端不接受当前自定义模式；标准1080p30仍需解决371.25MHz串行输出的I/O等级与时钟源。
