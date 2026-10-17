# C11303 HDMI PHY 补强候选（实板待验证）

C11302 用户反馈整屏绿/彩条、无声，回载 C11206 同条件音画恢复；这次保留原包络、TF/音频/图片逻辑，仅补强 HDMI 的完整字捕获与 ODDR 输出前的数据准备，外加 build ID 更新。真实实板根因仍未唯一确认。

将本包解压到连接板卡电脑的纯英文目录。BitWriter Add music_envelope_phy.bit → PROGRAM_SRAM /5MHz → Run，确认 Downloading succeeded。数码管 D 页必须 DFC11303。TF 现有素材保持即可。

1. 默认音乐：确认底图、白字/黑底与包络面板没有规则绿/彩条，声音清晰。
2. 长按 KEY1 约 2 秒：确认内部音阶清晰；再次长按回音乐。
3. 如音画正常，再双键短按并松开验证 HOLD/恢复；观察曲线清晰度即可。

本轮先反馈音画和两音源结果；异常立即同条件回载包里的 bmp_scale.bit（C11206）。无需换卡或写 Flash。

本地模型和最终原约束 STA 通过：setup +0.119ns、hold +0.024ns、TNS0。模型不是电气测量，也不能代替此次候选板测。原 C11302 位流与 ZIP 保留取证，不覆盖。

位流 SHA256：1D0BD4198379E924EA59D8F62E940612AA3DFE0034C858C219F0ED77F6FE803F
成功回退 SHA256：C60464C0D4396D316DB7622E4CB0B70B5DE12C25148AFE234AC7C795C818625D
