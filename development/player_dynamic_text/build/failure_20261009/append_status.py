import json
from datetime import datetime, timezone, timedelta
from pathlib import Path
root = Path('E:/VSCODE-project/FPGA-ANLU')
docs = Path('E:/QQ CACHE/Download/安路资料/开发记录')
now = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
paths = [root / 'development/player_dynamic_text/build/board_feedback_20261009.json',
    docs / '专题记录/OSD状态显示/动态字幕首版失败_20261009/feedback.json']
decode = dict(user_value='1d950007', mode='default WAV', leds='D3/D2/D1/D0 all off',
    startup=dict(sys_pll_lock=1, video_pll_lock=1, rst_all=0, card_init_done=1),
    file_flags=dict(fs_ready=1, fs_error=0, display_valid=0, bmp_error=1,
        wav_primed=0, wav_error=1, bmp_map_error=0, wav_map_error=1),
    fs_error_code='00', wav_map_error_code='07', wav_error_meaning='E_EOC: mapper saw end-of-chain before requested cluster',
    boundary='Status is user readout, not captured internal waveforms. Does not identify raw FAT bytes/cluster/sector or unique physical cause.')
for p in paths:
    d = json.loads(p.read_text(encoding='utf-8-sig'))
    d['status_readout'] = decode
    d['status_recorded_beijing'] = now
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
with (docs / '工作日志/2026-10-09.md').open('a', encoding='utf-8') as f:
    f.write(f'\n### {now[11:]}｜动态字幕失败版状态解码与审计｜进行中\n\n'
        '- 用户默认WAV数码管读数1d950007、D3/D2/D1/D0均灭。精确解码：PLL双lock/card_init/fs_ready为1、rst_all/fs_error为0、display_valid=0、BMP/WAV错误=1、BMP mapper无错误、WAV mapper E_EOC(07)。证明已挂载但图片未提交、WAV读到提前簇链结束；不能单凭此认定卡损坏或SPI/复位根因。反馈JSON已追加原值与解码。\n'
        '- 三项只读审计完成：build/failure_20261009/source_audit.md、clock_io_audit.md、physical_audit.md。当前SDC无exclusive，两版73老源/时钟/引脚/PLL一致，最终STA正裕量；SPI sd_miso无外部输入延迟，缺原始FAT条目/线级波形。内部tone不依赖卡，失真另待包计数分层。\n'
        '- 最终布线slice占用97.02%→98.76%是实现变化线索，不是根因证实；独立实验准备合并新字幕两份字模组合通路，仅减冗余，先做完整像素/计时模型，不改失败/成功冻结基线。尚未生成/交付新位流。\n'
        '- 已请用户读取失败版内部音階模式3/6/8/9页，待现场数据；同时继续有限本地检查。\n')
state_path = docs / '当前状态.md'
state = state_path.read_text(encoding='utf-8-sig')
anchor = '具体根因未证实。证据见[首版失败反馈]'
state = state.replace(anchor, '具体根因未证实。用户补读1d950007/四灯灭：已挂载、BMP错误、WAV mapper提前EOC(07)，内部音阶包计数待读；源码/时序审计完成，SPI外部采样缺约束。证据见[首版失败反馈]', 1)
state_path.write_text(state, encoding='utf-8')
print('Status evidence and project records saved.')
