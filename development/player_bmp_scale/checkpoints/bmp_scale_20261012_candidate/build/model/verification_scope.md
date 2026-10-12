# C11206 验证范围

父版本为C11205 verified169，manifest SHA A6B0AE1DBCAF1A92D360FA7F6E4AA935C1777A06D705940ED1364999A239A4A9。隔离工程从其逐项核验复制src/scripts，没有旧数据库。79继承源字节保持、5源改变、1新engine；正式源码范围见parent_source_audit.json。复制的旧TB与review仅作父证据材料，没有本版日志的模型未重跑。

## 新增模型

- scaler_make_media.py：独立生成原尺寸BMP与目标显示域gold；TB expected mem为底向上目标流，preview仅供人看且翻转到top-down。交付TF_ROOT仅原BMP，不能将preview/gold送板冒充FPGA缩放。完整loader回归结果待scaler_full_loader.log，本文件在候选封存时补最终数目和边界。
- run_write_backpressure.ps1：真实rgb888_pack32/frame_read_write/frame_fifo_write/read/写读FIFO IP，mock producer与一拍loader输出寄存。4096像素、3072words逐项地址/data通过，max_used481（实际FIFO可用511），stalled5908，ready落沿phase mask d观察到pack相位0/2/3。人为强制App_rd_busy长停12000拍，再进行600拍服务/4000拍停顿；Sdr_busy输入在原writer中未用。线性48word×64行、WRITE_V_FLIP=0，未含真实engine/loader或加密SDRAM、真实视频60Hz读争用，也非带宽/长稳证明。停发余量30word覆盖寄存与packer在途，wrapper仅额外门控req/rst。
- 两个write_backpressure_initial_*日志为TB错误，非RTL失败：SHOW_AHEAD FIFO读口需要沿前头值，#1后是下一头；busy错误假设被App_rd_busy受控拥塞替代。保留错误与修正日志。

## 未改变模块与限制

父版本成功反馈涵盖转场、两音源、按键、字幕、参数、波形冻结。音频/PHY/PLL/引脚/约束/读侧转场源字节未改，不能据此声明本次布局下也已上板通过。正式TD与RAM实际映射/时序以build/manual和最终info为准。模型不含加密SDRAM、SD卡物理信号、实际BRAM/HDMI PHY、显示器和实板，不证明动态波形双线已修复；top-down碎片FAT的最坏加载时长仍未测。

## 最终候选模型与TD结果

engine A6C607738DB921E02C3D717F9C6CC9044CC3DDBC4FA02DD90B253FB541EF2C4D / loader 9CDDACB2F20A36D2E066EB74BF8FE55C5D675115281CE73B7D64EDAD3B8F93DF：六个完整640×480帧逐像素gold通过，共1843200像素；四个原尺寸生产素材+native640×480+800×599奇数纵向黑边。每例真实解析header/扇区/payload/COMMIT，无COMMIT状态注入；最长ready低322拍、接受全部307200像素，真实drain mock计数后才给write_finish；延迟display_finish时已排队NEXT不能重新读取。扇区数452/2371/683/386/1802/2367（按素材顺序）。证据与源/TB/gold哈希绑定在scaler_validation_receipt.json及其successfulRunLog。

四个错误用例输出目标缩小32×24：先通过真实loader提交旧320×240原图，再加载零宽、宽1025、首扇区511字节、认可头后的payload截断，错误后不发布目标、旧display_valid/buffer/index保留。此错误模型是完整控制/解析路径，但不使用生产640×480输出尺寸。卡端按逻辑扇区mock，不含真实FAT mapper/SD仲裁，未验证top-down碎片链最坏加载时间。

最初功能实现984671...有完整模型PASS，但行RAM被TD推为分布式存储，整机17897LUT/25BRAM/8DSP，placement返回空文本BUILD_ERROR；保留initial_ram_mapping/manual DB/日志/报告。添加BRAM属性、拆无reset同步写口并使用10bit行索引后，A6版本再次完成上述六帧与四错误PASS。旧first_pass不冒充新版本证据。当前正式综合scale row3+sector1物理BRAM、PCM FIFO4与波形1PDPW保持；原约束最终SWNS+.628ns/HWNS+.004ns/TNS0/coverage99.97%，无holdfix；资源15031LUT/8803reg/16520LE/28BRAM9K/8DSP/2GCLK。

根代理核对最终源/脚本/DB/报告/位流来源后封存候选，实板仍待验证。上板需备份旧图到电脑、根目录仅放4张SCALE原BMP并保留原WAV；回退旧C11205时必须恢复原640×480素材。
