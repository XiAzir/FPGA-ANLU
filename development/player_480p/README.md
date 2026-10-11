# 480p播放器开发工程

当前阶段：紧凑RGB888的data_d1修正版获用户“现在正常了”的上板反馈，本次错色/点带回归记为已解决。保持raw valid、读数据保存一拍后入FIFO；模型仿真和TD构建通过。实际控制器波形及长期稳定性未测量，该版按键/音频未单独复述验证结果。

工程：[AC201_tf_hdmi.al](src/td_project/AC201_tf_hdmi.al)。当前修正版位流：[AC201_tf_hdmi_data_d1.bit](build/manual/AC201_tf_hdmi_data_d1.bit)。哈希、源码哈希和验证范围见[元数据](build/manual/AC201_tf_hdmi_data_d1.info.json)。已保存[已验证检查点](checkpoints/compact_data_d1_verified/)及112文件SHA256清单。

原成功版bringup/tf_wav_hdmi保留；接口版源码和位流在[检查点](checkpoints/rgb888_interface/)。本阶段仅修改帧包装、旧后端FIFO状态端口，新增codec；PLL/引脚/SDC/音频/TF/视频时序不改，见[源码核查](build/source_change_audit.json)。

每行640像素存480个32位字；每帧230400字/921600字节，双帧1843200字节，比32位存储减少25%，颜色位数不变。SDRAM物理接口仍32位，预取解包保持原视频消费延迟。

排查路线、原因与证据边界见[排查总结](<E:/QQ CACHE/Download/安路资料/开发记录/专题记录/RGB888紧凑帧缓存/排查路线与结论.md>)；详细过程见[专题记录](<E:/QQ CACHE/Download/安路资料/开发记录/专题记录/RGB888紧凑帧缓存/2026-10-07.md>)，进度见[当前状态](<E:/QQ CACHE/Download/安路资料/开发记录/当前状态.md>)。旧docs/pixel_interface.md仅描述第一阶段，后续以专题记录为准。

仿真脚本scripts/run_codec_sim.ps1、scripts/run_frame_sim.ps1，日志build/sim。集成仿真使用实际FIFO/帧控制RTL和SDRAM应用接口模型，不覆盖加密控制器或电气时序。

TD依次运行scripts/build_manual_syn.tcl、scripts/build_manual_phy.tcl；检查最终时序后运行scripts/generate_bit.tcl。紧凑版Routed SWNS0.398ns、HWNS0.014ns、TNS均0、coverage99.98%；9590 LUT/3896寄存器/10340 LE/18 BRAM9K。原加密SDRAMclk告警、IO延迟缺项和旧ack回传域跨越未修复。

已保留两份失败检查点、[成功接口版](checkpoints/rgb888_interface/AC201_tf_hdmi.bit)和当前修正版源码/位流/报告/测试证据。此次上板反馈解除显示回归对FAT开发的阻塞，下一步推进只读FAT32目录/簇链及WAV数据区解析；长期稳定性与最终功能回归另行记录。

本阶段没有实现FAT32/通用WAV或图像扩展，原TF物理布局限制仍在。当前为SRAM临时配置，Flash固化未完成；720p60后续另行评估。

