# C11205 上下擦除转场

从C11204 waveform_keyfreeze verified成功开发基线隔离复制。新BMP完整预载后，从上往下每个显示帧增加8行，640×480共60次帧边界完成；首图直接显示。候选实板待验证。

## 数据与所有权

compact RGB888每行480个32-bit word，帧230400word。8行=3840word=15个256-word批次。保留原单读流/每帧900批次，仅player_wipe_address将上部映射到新buffer，其余仍旧buffer，不增加双路读或数据延迟。

pixel帧请求改变metadata，mem两级同步后在原backend ACK上升沿锁存；ACK在旧burst结束后、新burst之前。动画期间保留两buffer；最终全新图帧的请求ACK确认旧buffer脱离读路径，display finish toggle返回loader，才能复用。该ACK是请求受理/基址锁存，不是整帧读完。

loader完整写图后发布并WAIT_DISPLAY；忙时next最多合并一次，AUTO可切换，等待期间不积累计时。编号在最终全新帧边界提交。目标错误进入原HALT、旧图保留，不发布错误目标；无新重试。生产参数640×480/step8，不承诺任意尺寸步长。

## 操作与回退

原C11204映射保持：PLAY短KEY0下一图、短KEY1 AUTO、长KEY0切PLAY/BRI/CON，编辑短KEY0-/KEY1+；PLAY长KEY1 WAV/音阶并解除冻结；PLAY双键短按全松冻结/恢复，双长复参数默认。音乐/字幕/参数/波形应持续。TF素材不改，本机不操作远控电脑的JTAG/TF/Flash。

直接回退：../../download/waveform_keyfreeze.bit，C11204，SHA256 A16326B8266ED6CB52CE27E163B89DC1C2B37551B393AE5F1116BA16C6F54790。已用户反馈组合功能正常，带已知动态波形双线和低清晰度；本转场不处理这两项。

## 验证

范围见build/model/verification_scope.md和build/audit。通过scripts/build_candidate.ps1依次synthesis、physical、必要时原约束hold，再bitstream；最终setup/hold须非负。封存区分本地模型、时序与用户板测。模型不含加密SDRAM内部与真实外设，首次上板仍须验证实际读图/音频。

TD三阶段正式完成：SWNS +0.247 ns、HWNS +0.011 ns、TNS 0、coverage 99.97%，未fix_hold/改约束；13131 LUT、8238 reg、14651 LE、24 BRAM9K、1 DSP、2 GCLK。canonical位流629624 bytes，SHA256 748E0AF0F9BF0656410C09735E371F655BEDD330C259E43858B614B1D95AE8F9。封存与板测状态以交付info为准，工具结果不等于实际转场通过。
