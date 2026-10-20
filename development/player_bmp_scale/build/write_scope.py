from pathlib import Path
import sys

for _anlu_root in Path(__file__).resolve().parents:
    if (_anlu_root / 'scripts' / 'anlu_paths.py').is_file():
        sys.path.insert(0, str(_anlu_root / 'scripts'))
        break
from anlu_paths import DOCS_ROOT, REPOSITORY_ROOT, recorded_path

p=REPOSITORY_ROOT / 'development/player_bmp_scale/build/model/verification_scope.md'
p.write_text('''# C11206 验证范围

父版本为C11205 verified169，manifest SHA A6B0AE1DBCAF1A92D360FA7F6E4AA935C1777A06D705940ED1364999A239A4A9。隔离工程从其逐项核验复制src/scripts，没有旧数据库。79继承源字节保持、5源改变、1新engine；正式源码范围见parent_source_audit.json。复制的旧TB与review仅作父证据材料，没有本版日志的模型未重跑。

## 新增模型

- scaler_make_media.py：独立生成原尺寸BMP与目标显示域gold；TB expected mem为底向上目标流，preview仅供人看且翻转到top-down。交付TF_ROOT仅原BMP，不能将preview/gold送板冒充FPGA缩放。完整loader回归结果待scaler_full_loader.log，本文件在候选封存时补最终数目和边界。
- run_write_backpressure.ps1：真实rgb888_pack32/frame_read_write/frame_fifo_write/read/写读FIFO IP，mock producer与一拍loader输出寄存。4096像素、3072words逐项地址/data通过，max_used481（实际FIFO可用511），stalled5908，ready落沿phase mask d观察到pack相位0/2/3。人为强制App_rd_busy长停12000拍，再进行600拍服务/4000拍停顿；Sdr_busy输入在原writer中未用。线性48word×64行、WRITE_V_FLIP=0，未含真实engine/loader或加密SDRAM、真实视频60Hz读争用，也非带宽/长稳证明。停发余量30word覆盖寄存与packer在途，wrapper仅额外门控req/rst。
- 两个write_backpressure_initial_*日志为TB错误，非RTL失败：SHOW_AHEAD FIFO读口需要沿前头值，#1后是下一头；busy错误假设被App_rd_busy受控拥塞替代。保留错误与修正日志。

## 未改变模块与限制

父版本成功反馈涵盖转场、两音源、按键、字幕、参数、波形冻结。音频/PHY/PLL/引脚/约束/读侧转场源字节未改，不能据此声明本次布局下也已上板通过。正式TD与RAM实际映射/时序以build/manual和最终info为准。模型不含加密SDRAM、SD卡物理信号、实际BRAM/HDMI PHY、显示器和实板，不证明动态波形双线已修复；top-down碎片FAT的最坏加载时长仍未测。
''',encoding='utf-8')
