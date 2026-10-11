from pathlib import Path
from datetime import datetime, timezone, timedelta
import json

root = Path('E:/VSCODE-project/FPGA-ANLU')
records = Path('E:/QQ CACHE/Download/安路资料/开发记录')
stamp = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
obs = {
    'source_video': 'E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori/77a8f88d707a4c3b83e74c9de47b3061.mp4',
    'sha256': '71D32F9BBCFB8A7239D6D365B0414DE6559163AE2A92BE5122B67ECEB4896742',
    'duration_seconds': 23.067289, 'bytes': 6264756, 'orientation': 'native 1280x720; no rotation',
    'source': 'assistant visual decode of extracted frames; audio quality from user report',
    'observations': [
        {'time_s': 'initial', 'value': '01234567/88888888', 'meaning': 'display startup self test'},
        {'time_s': 7.5, 'value': '3300bb80', 'meaning': 'WAV valid samples 48000'},
        {'time_s': 8.5, 'value': '3b00bb80', 'meaning': 'tone mode; valid samples 48000'},
        {'time_s': 9.5, 'value': '4b0002A7', 'changes': 679},
        {'time_s': 10.5, 'value': '4b000340', 'changes': 832},
        {'time_s': 19.5, 'value': '4b0003F9', 'changes': 1017},
        {'time_s': 20.5, 'value': '4b00022b', 'changes': 555},
        {'value': '1dA80000', 'meaning': 'startup/file state unchanged'},
        {'value': '2b04b000', 'meaning': '307200 nonblack pixels per complete frame'},
        {'value': '5b04b000', 'meaning': '307200 valid pixels per complete frame'},
    ],
    'mode_B': {'tone_mode': 1, 'underflow': 0, 'hdmi_locked': 1, 'frame_seen': 1},
    'user_audio_report': 'Internal tone still has hiss',
    'boundary': 'Startup self test seen; not established whether two videos are the same uninterrupted run. Counts do not prove amplitude/order/HDMI packets/PHY.',
}
Path(__file__).with_name('observations.json').write_text(json.dumps(obs, ensure_ascii=False, indent=2), encoding='utf-8')

section = f'''\n\n### {stamp}｜status_diag 内部音阶视频判读｜输入计数有效，杂音未修复

- 用户提供第二视频23.067289秒、1280×720原生横向，无需旋转；6264756字节，SHA256 `{obs['sha256']}`。原视频已复制到[内部音阶视频](2026-10-08/status_diag_internal_tone.mp4)，副本哈希一致，判读裁图为`2026-10-08/status_diag_tone_display_crops.jpg`；逐帧、observations.json、独立DDS数学模型保存在工程`development/player_fat32_status_diag/build/tone_video_20261008`。原视频不改。
- 代理视觉判读：起始数码管01234567/88888888自检，7.5秒仍3300bb80；8.5秒以后为内部tone模式B，页1=1dA80000、页2=2b04b000、页3=3b00bb80、页4=4b0002A7/4b000340/4b0003F9/4b00022b（679/832/1017/555）、页5=5b04b000。B含tone=1、underflow=0、HDMI locked=1、frame_seen=1；每名义秒48000 valid，每完整帧307200有效/非黑像素。用户反馈内部音阶仍沙沙杂音。是否重新下载/复位、是否与第一视频属同一连续运行未确认，不宣称同一不间断周期。
- 独立Python样本域数学模型按原DDS LUT/32位phase/48kHz/每音24000样本及输出寄存器延迟计算变化序列556、679、832、1017、555、679、832、1017；与上述实读数值吻合。只证实模式及输入计数符合预期，不证明逐样本幅值/顺序、输出包、物理TMDS；不能单用TF/WAV问题解释内部tone也杂音，优先查共享HDMI发送路径，根因仍未确定。
- 已在隔离工程`development/player_fat32_packet_diag`接入并行TMDS被动包观察分支，扩展数码管到12页；原音视频/PHY/PLL/引脚/SDC不改。包解析独立BCH向量+22项定向仿真PASS，12页状态模型PASS；正在TD综合，尚无新位流、尚未上板、不是修复结论。首个工程属性错误UsedInSim已纠正，失败日志保留`build/project_attr_failure.log`。未写TF/Flash，代理未操作板卡。
- 下一步：包观察工程完成综合、布局布线与原约束时序核对后才生成候选位流；观察音频样本/包数、BCH/TERC错误、内部tone幅值、CTS/N，继续区分核心输出和PHY/接收端。暂不要求再次补录status_diag视频。
'''
topic = records/'专题记录/FAT32文件播放/keepaudio黑屏诊断_20261008.md'
topic.write_text(topic.read_text(encoding='utf-8')+section, encoding='utf-8')
log = records/'工作日志/2026-10-08.md'
log.write_text(log.read_text(encoding='utf-8')+section.replace('(2026-10-08/', '(../专题记录/FAT32文件播放/2026-10-08/'), encoding='utf-8')
state = records/'当前状态.md'
s = state.read_text(encoding='utf-8')
s = s.replace('更新：2026-10-08 18:06:35', '更新：'+stamp)
start = s.index('**最新status_diag已上板：')
end = s.index('\n**FAT32',start)
s = s[:start]+'''**status_diag图像正常，默认WAV与内部音阶均仍沙沙杂音（用户反馈）。两段视频已判读：WAV模式M=3、内部tone模式M=B；每名义秒48000 audio_valid、每完整帧307200有效/非黑像素，显示的文件错误为0。内部tone页4变化679/832/1017/555与独立DDS数学模型吻合，未证明每样本幅值/顺序或HDMI包。第二视频起始有数码管自检，不确认两视频为同一连续运行。根因和音频修复仍未完成；已转入隔离packet_diag并行TMDS包观测，模型PASS、TD综合进行中，尚无候选位流/实板结果。**'''+s[end:]
s = s.replace('默认WAV五页视频已判读；长按KEY1后的听感仍杂音，下一步补录D3闪烁模式五页以核实M/B与音阶输入变化，保持同一位流不重烧。', '默认WAV与内部tone视频均已判读，内部模式B且页3/4计数与预期相符，两源仍杂音；暂不需继续录制status_diag。下一步隔离packet_diag观察核心并行输出包，尚无新位流。')
s = s.replace('下一步优先同一位流补录长按后模式的数码管页；如需强证序列，后续观测版从首个WAV valid开始采384000笔输入PCM CRC，尚未实施。', '内部tone视频现已提供，模式B及679/832/1017/555变化与独立DDS模型吻合；优先完成隔离packet_diag输出包观测。WAV逐样本CRC尚未实施。')
state.write_text(s, encoding='utf-8')
info = root/'development/player_fat32_status_diag/build/manual/AC201_player_fat32_status_diag.info.json'
data=json.loads(info.read_text(encoding='utf-8-sig'))
data['hardware_result'] = 'User reports image normal and both WAV/internal tone hiss. Two videos visually decoded: WAV mode3 and internal tone modeB, 48000 audio_valid/sec, 307200 pixels/frame. Tone changes 679/832/1017/555 match independent DDS model. Second video contains startup self test; same uninterrupted run as first is not established. Root cause unresolved.'
data['tone_video_sha256']=obs['sha256']
data['tone_video_evidence']='build/tone_video_20261008/observations.json'
info.write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
readme = root/'development/player_fat32_status_diag/README.md'
readme.write_text(readme.read_text(encoding='utf-8')+'''\n\n## Internal tone video observation (2026-10-08)

Second video confirms mode B, 48000 valid samples per nominal second and 307200
valid/nonblack pixels per complete frame. Change counts 679/832/1017/555 match
the independent sample-domain DDS model in build/tone_video_20261008.
User still reports hiss. Input counts do not prove sample amplitude/order or
HDMI packet/PHY correctness. Startup self test is visible; the two videos are
not established to be the same uninterrupted run. Candidate checkpoint metadata
is historical and remains unchanged. Output-packet monitoring is now being
implemented separately in ../player_fat32_packet_diag; this bitstream is unchanged.
''',encoding='utf-8')
print('Saved internal tone observations and current development records at',stamp)
