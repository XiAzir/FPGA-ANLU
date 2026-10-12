# C11201 亮度 / 对比度实板验收

本地模型、TD综合/布局布线/原约束setup-hold通过；新候选尚未上板。
只用 PROGRAM_SRAM，不用写TF/Flash。现有四BMP/天之弱TEST.WAV保持；路径用英文。

1. BitWriter Add image_adjust.bit，PROGRAM_SRAM / 5MHz，Run并确认Downloading succeeded。
2. 默认应显示PLAY B+00 C1.00；图片、天之弱音乐、KEY0短切图、KEY1短轮播、RUN计时/滚动字幕正常。短操作松开后生效；点按间稍作间隔，极快多连点会合并。
3. KEY0长按约2秒看到BRI后松开：短KEY1增亮、短KEY0减亮。B=-64..+64步长16，端点不回绕；观察底图变化、文字清晰、音乐保持。
4. 再长KEY0看到CON后松开：短KEY1增对比度、短KEY0减。C=0.50/0.75/1.00/1.25/1.50；观察暗亮区域、端点无反色、OSD数字同步。
5. 同时按住两键约2秒后松开两键，应回PLAY B+00 C1.00、原图恢复，已有AUTO/音源不会因该恢复操作被重置。
6. PLAY模式长KEY1约2秒切内部音阶，再长按切回音乐；这版长KEY1不再顺带切AUTO。编辑模式长KEY1不切音源。

新候选失败时同条件回载pcm_bram_candidate.bit，这是C11109用户反馈全功能及30分钟短稳正常的直接回退。
成功只需逐项反馈，不必重录10页；异常保存照片/短视频及D页版本，必要时核对6/7/8 CRC。
