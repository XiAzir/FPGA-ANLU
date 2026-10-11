"""Archive manually checked video evidence; does not change HDL, bitstreams or checkpoints."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib
import json
import re
import shutil
import subprocess

BASE = Path(__file__).resolve().parent
ROOT = BASE.parent.parent
RECORDS = Path('E:/QQ CACHE/Download/安路资料/开发记录')
TOPIC = RECORDS / '专题记录/FAT32文件播放'
MEDIA = TOPIC / '2026-10-08'
ORIGINALS = Path('E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori')
SHA = 'C2B3DEAFB78355C124CE8958015EED31CEBA38CD4B0B41D9179A7190E4200818'
NOW = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def copy_checked(source, destination):
    if destination.exists():
        assert digest(destination) == digest(source), f'Preserve differing destination: {destination}'
    else:
        shutil.copy2(source, destination)
    assert digest(destination) == digest(source)


assert not (BASE / 'observations.json').exists(), 'Evidence already saved; do not append duplicate logs'
bit = ROOT / 'build/manual/AC201_player_fat32_packet_diag.bit'
assert bit.stat().st_size == 629624 and digest(bit) == SHA
MEDIA.mkdir(exist_ok=True)
pages = ['1', '3', '6', '7', '8', '9', 'A', 'B', 'C']
definitions = [
    ('default', '627fe2d528011f1d7f1c5d0c96efe5d7.mp4', '4A9755F1612F60A89672A815EFD502E8F63564969717914579B8994321047A3F', [14, 16, 18, 2, 4, 6, 8, 10, 12], 3),
    ('tone', '4d68c80af78f897671bd73cf63c68257.mp4', '380AEB0B16C21FEBF59D52C6C058E42DF470E46E79585CA7974D1AA23A96B10B', [9, 11, 13, 15, 17, 19, 21, 5, 7], 11),
]
videos = []
for mode, filename, expected, times, mode_flag in definitions:
    source = ORIGINALS / filename
    assert digest(source) == expected
    meta = json.loads(subprocess.check_output([
        'ffprobe', '-v', 'error', '-show_entries',
        'format=duration:stream=index,codec_type,codec_name,width,height,avg_frame_rate,sample_rate,channels:stream_tags=rotate:stream_side_data=rotation',
        '-of', 'json', str(source)], encoding='utf-8'))
    (BASE / mode / 'video_metadata.json').write_text(json.dumps(meta, indent=2) + '\n', encoding='utf-8')
    destination = MEDIA / ('packet_diag_default_wav.mp4' if mode == 'default' else 'packet_diag_internal_tone.mp4')
    copy_checked(source, destination)
    values = ['1DA80000', f'3{mode_flag:X}00BB80', '6E00BB80', '7E00BB80', '8E000000', '9E000000', 'AE000000', 'BE0061A8', 'CE001800']
    samples = []
    for page, value, seconds in zip(pages, values, times):
        selected = BASE / mode / 'selected' / f'page_{page}_at_{seconds}s.png'
        assert selected.is_file()
        samples.append({'page': page, 'hex_normalized': value, 'seek_seconds': seconds,
                        'selected_frame': str(selected), 'interpretation': 'manual visual reading; normalize seven-segment b/d to hex B/D'})
    videos.append({'mode': mode, 'original': str(source), 'archive': str(destination),
                   'bytes': source.stat().st_size, 'sha256': expected,
                   'duration_seconds': float(meta['format']['duration']),
                   'rotation_applied': False, 'mode_flag': mode_flag, 'packet_flags': 14,
                   'audio_valid_per_nominal_second': 48000, 'packet_sample_pairs_per_nominal_second': 48000,
                   'audio_packets_per_nominal_second': 48000, 'bad_bch_observed': 0, 'bad_terc_observed': 0,
                   'tone_amplitude_bad_observed': 0, 'tone_amplitude_check_enabled': mode == 'tone',
                   'cts': 25000, 'n': 6144, 'page_observations': samples})
copy_checked(BASE / 'selected_pages.jpg', MEDIA / 'packet_diag_selected_pages.jpg')
evidence = {
    'recorded_beijing': NOW, 'candidate_sha256': SHA, 'videos': videos,
    'method': 'ffprobe metadata/hash; ffmpeg 2fps contact frames; selected exact -ss frames; manual visual readings; independent second reader for tone with B/6 segment distinction verified',
    'result': 'Recorded stable default/internal display windows conform to expected input, packet, error, tone amplitude and ACR fields',
    'packet_grouping_inference': 'Equal 48000 sample-pair and packet counts in stable windows is consistent with one sample pair per audio packet; 12000 packets applies only to four pairs per packet',
    'audio_evidence': 'Source videos retain AAC microphone recordings; subjective clean sound is prior user feedback; no calibrated audio measurement or listening claim added',
    'limits': ['Display presents selected one-second windows, not complete per-packet waveforms',
               'WAV page A=0 does not check WAV payload amplitude',
               'Nominal 25MHz clock frequency unmeasured',
               'No complete PCM order/IEC parity/V/U/C/InfoFrame/AVMUTE/PHY or receiver waveform check',
               'Short videos are not long-term reliability evidence',
               'Old noisy implementations were not captured with this observer; root cause unresolved'],
    'operations': 'Archive/evidence/live metadata only; no HDL/constraints/DB/bitstream/checkpoint changes; no assistant board/card/Flash actions',
    'next_step': 'No further baseline video needed; proceed to supported-format actual music and changed-file/card/long-run validation when media and card are available'
}
(BASE / 'observations.json').write_text(json.dumps(evidence, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
rows = []
labels = ['启动/文件状态', '输入模式/有效样本', '音频包内样本对', '音频包数', '坏BCH包', '非法TERC/guard', '内部音阶幅值异常', 'CTS', 'N']
for i, (page, label) in enumerate(zip(pages, labels)):
    d, t = videos[0]['page_observations'][i], videos[1]['page_observations'][i]
    rows.append(f"| {page}：{label} | `{d['hex_normalized']}`（{d['seek_seconds']}秒） | `{t['hex_normalized']}`（{t['seek_seconds']}秒） |")
report = f'''# packet_diag两音源数码管视频判读

记录时间：{NOW}（北京时间）。状态：两种音源的已录稳定显示窗口符合预期；基础图像/按键/听感正常来自此前用户反馈。旧版杂音具体根因仍未证实。

## 版本与视频

- 位流：`E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/manual/AC201_player_fat32_packet_diag.bit`；629624字节，SHA256 `{SHA}`。运行版本依前序下载上下文关联，未提供本次下载日志。原310文件candidate与211文件incomplete检查点冻结不改。
- 长按前：`627fe2d528011f1d7f1c5d0c96efe5d7.mp4`，26.733333秒、7177481字节，SHA256 `4A9755F1612F60A89672A815EFD502E8F63564969717914579B8994321047A3F`；[原字节归档](2026-10-08/packet_diag_default_wav.mp4)。
- 长按后：`4d68c80af78f897671bd73cf63c68257.mp4`，25.833622秒、7036402字节，SHA256 `380AEB0B16C21FEBF59D52C6C058E42DF470E46E79585CA7974D1AA23A96B10B`；[原字节归档](2026-10-08/packet_diag_internal_tone.mp4)。
- 两段1280×720横向，无旋转元数据，不需旋转；均有48kHz双声道AAC录音轨。录音轨为视频容器信息，不据此推断HDMI有效左右声道或客观音质。

## 读数（全部十六进制）

| 页/意义 | 默认WAV：读数/视频时间 | 内部音阶：读数/视频时间 |
| --- | --- | --- |
''' + '\n'.join(rows) + f'''

## 结论与边界

- 页3模式由3变B：tone_mode由0变1，观察窗无underflow标志，hdmi_locked/frame_seen为1。页6至C的F=E：已见数据岛、有效音频、合法ACR，未锁存格式错误。正常显示窗口支持观察器已识别当前核心并行输出。
- 输入有效样本、包内样本对、音频包计数都为`00BB80`=48000/名义秒。稳态样本对数与包数相等，符合每包一组采样对的发送方式；不能套用仅每包4组时的12000包预期。这是计数推断，未另存每包present序列。
- 观察到坏BCH、非法TERC/guard均0；内部模式幅值异常0。WAV模式A页0只表示检查未启用，不证明WAV样本逐点正确。CTS=`0061A8`=25000，N=`001800`=6144，符合现25MHz/48kHz配置的预期。
- 视觉判读先用2fps抽帧/1秒contact定位，再以表中准确`-ss`时刻抽帧复核。七段管B显示为小写b；与6仅顶部a段不同。子代理首读误为6，经原裁剪/源码段码及首位6对照纠正；归档仅采用复核读数。不是OCR/自动修图，不强行修正模糊扫描帧。
- 证据范围是两段短视频所显示的计数窗；没有完整PCM顺序、IEC parity/V/U/C、InfoFrame/AVMUTE、差分PHY/接收器波形或实测时钟频率。音质正常为用户听感反馈，未做校准音频测量。不能由新位流正常归因旧杂音为MSLICE移动/BCH/时序或特定RTL问题。
- 已保留原视频、逐页原始帧及[双模式读数截图](2026-10-08/packet_diag_selected_pages.jpg)。工程证据在`E:/VSCODE-project/FPGA-ANLU/development/player_fat32_packet_diag/build/board_videos_20261008/`，含metadata、2fps原帧/裁剪、contact、selected和observations.json；make_contacts.py可复现裁剪，数据人工读。原视频副本逐字节SHA核验一致。

## 下一步

无需再补录当前基线。保留此位流作为已获基础功能正常反馈且包显示符合预期的版本；之后用受支持的真实音乐TEST.WAV、换文件/碎片及长时运行推进播放器验证。当前仅完成视频核对/归档/元数据，未改HDL/约束/DB/位流、未构建、未操作板卡/TF/Flash；原故障根因保留未证实状态。
'''
report_path = TOPIC / 'packet_diag两音源视频判读_20261008.md'
assert not report_path.exists()
report_path.write_text(report, encoding='utf-8')
(BASE / 'observations.md').write_text(report, encoding='utf-8')
meta_path = ROOT / 'build/manual/AC201_player_fat32_packet_diag.info.json'
meta = json.loads(meta_path.read_text(encoding='utf-8-sig'))
assert meta['sha256'] == SHA
meta['status'] = 'basic playback and both audio sources passed by user feedback; recorded packet display windows match expected values; long-run/media-change checks pending; old noise root cause unresolved'
meta['hardware_result'] = 'User reports image/buttons/slideshow and both sources normal; two supplied videos verify modes 3/B, 48000 input/sample/packet counts, F=E, zero BCH/TERC/tone error, CTS=25000 and N=6144 in displayed windows'
meta['board_video_observation'] = {'recorded_beijing': NOW, 'evidence': str(BASE / 'observations.json'), 'report': str(report_path), 'packet_readings_captured': True, 'videos': [{k: v[k] for k in ('mode', 'sha256', 'duration_seconds', 'archive')} for v in videos]}
meta_path.write_text(json.dumps(meta, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
state_path = RECORDS / '当前状态.md'
state = state_path.read_text(encoding='utf-8-sig')
state = re.sub(r'^更新：.*?（北京时间）', '更新：' + NOW + '（北京时间）', state, count=1, flags=re.M)
start = state.index('**packet_diag本候选')
end = state.index('**', start + 2) + 2
state = state[:start] + f'**packet_diag本候选基础上板功能通过（用户反馈）：图像、KEY0手动、KEY1轮播及长按前后两音源均正常。两段26.73/25.83秒数码管视频已核对：模式3/B，输入/包内样本/包数均00BB80=48000/名义秒，F=E，已显示的BCH/TERC/内部tone异常0，CTS25000/N6144。无需继续补录基线，下一步实际音乐、换文件/碎片与长时运行。旧版沙沙声具体根因仍未证实；新观察器/布局改变，不能据此确定旧故障机制。候选SHA256 {SHA}，629624字节；310文件candidate/211文件incomplete保持冻结。47项包模型及原约束STA通过（SWNS0.102/HWNS0.027ns、TNS均0、coverage99.97%）；短视频/用户听感不等于长期或完整PCM/PHY波形验证。**' + state[end:]
state = state.replace('未录包数码管、运行时长未记录；310文件candidate保持冻结，live元数据另存反馈。', '两段短视频包显示窗口符合预期；长期稳定性未测，310文件candidate冻结，live元数据另存反馈/视频证据。')
start = state.index('3. packet_diag已获用户基础上板通过')
end = state.index('4. 基本播放与轮播', start)
state = state[:start] + '3. packet_diag基础上板反馈与两源包数码管判读已完成。模式3/B、输入/样本/包数48000、F=E、所见BCH/TERC及内部tone异常0、CTS25000/N6144；短视频支持本实现正常基线，不能归因旧噪声。无需再录基线，保持冻结成功版本进入实际音乐/换文件与稳定性验证。完整读数、原视频hash及证据边界见[两源视频判读](专题记录/FAT32文件播放/packet_diag两音源视频判读_20261008.md)。\n' + state[end:]
state_path.write_text(state, encoding='utf-8')
updates = f'''\n## {NOW}｜packet_diag两源视频判读与归档｜已完成（观察窗范围）

- 用户提供长按前627fe2...、长按后4d68c8...视频；26.733333/25.833622秒，原字节分别SHA256 4A9755F1612F60A89672A815EFD502E8F63564969717914579B8994321047A3F / 380AEB0B16C21FEBF59D52C6C058E42DF470E46E79585CA7974D1AA23A96B10B。原视频及双模式逐页截图已核验归档，完整表和来源见[两源视频判读](packet_diag两音源视频判读_20261008.md)。
- 判读：1DA80000；页3默认3300BB80/内部3B00BB80，6E00BB80/7E00BB80，8E000000/9E000000/AE000000，BE0061A8/CE001800。稳定计数窗输入/包内样本对/包数48000，F=E，所见错误0，内部幅值异常0，CTS25000/N6144。WAV A页不检查幅值；相等的样本/包数符合每包1组，不能用4组/包的12000预期判错。b与6段码已视觉复核。
- 两段短视频/已显示窗符合预期，先前声音干净/按键图片正常为用户反馈；没有完整PCM顺序、PHY/接收器波形、校准音质或实测时钟频率/长时证据。新观察器改变实现，旧杂音机制仍未证实。
- 已更新live.info.json、工程README、当前状态和专题入口；原用户反馈文件/310候选及211未完成检查点不改，源码/约束/DB/位流不改，无重新构建及代理板卡/TF/Flash操作。
- 下一步：无需再补录基线；保留成功位流，后续实际音乐TEST.WAV、换文件/碎片与长时验证。\n'''
for path in (TOPIC / 'keepaudio黑屏诊断_20261008.md', RECORDS / '工作日志/2026-10-08.md'):
    text = updates
    if path.parent.name == '工作日志':
        text = text.replace('(packet_diag两音源视频判读_20261008.md)', '(../专题记录/FAT32文件播放/packet_diag两音源视频判读_20261008.md)')
    with path.open('a', encoding='utf-8') as f:
        f.write(text)
index_path = TOPIC / 'README.md'
index = index_path.read_text(encoding='utf-8-sig')
index = re.sub(r'## 最新进展.*?\n\n(?=## 首版)', f'## 最新进展（{NOW}）\n\npacket_diag图像/按键/轮播及两音源正常为用户反馈；两段视频已核对模式3/B、输入/包内样本/包数48000、F=E、所见BCH/TERC/内部tone异常0、CTS25000/N6144。无需再补录基线，旧故障根因仍未证实，下一步实际音乐/换文件与长时运行。见[完整视频判读与原字节归档](packet_diag两音源视频判读_20261008.md)、[当前状态](../../当前状态.md)。\n\n', index, count=1, flags=re.S)
index_path.write_text(index, encoding='utf-8')
steps_path = TOPIC / 'packet_diag上板步骤_20261008.md'
steps = steps_path.read_text(encoding='utf-8-sig')
steps = steps.replace('包数码管未录、持续时长未记录。', '两段短视频数码管已读：模式3/B、48000输入/样本/包计数、错误0、CTS/N正确；长期运行未测。')
steps = steps.replace('## 当前补录（基础播放已通过）', '## 当前状态：补录与判读已完成\n\n两段视频已核对，当前无需再录；读数/原视频及边界见[两音源视频判读](packet_diag两音源视频判读_20261008.md)。保留以下步骤供未来复测使用。\n\n## 已完成的补录步骤（基础播放已通过）')
steps_path.write_text(steps, encoding='utf-8')
readme_path = ROOT / 'README.md'
readme = readme_path.read_text(encoding='utf-8-sig')
readme = readme.replace('数码管包数据未录，持续时长未记录，旧噪声根因未证实。见 `build/board_feedback_20261008.json`；原candidate检查点保持冻结。', '数码管两源短视频现已核对模式3/B、48000输入/样本/包计数、F=E、所见错误0及CTS/N正确；长期运行未验证，旧噪声根因未证实。先前用户反馈在 `build/board_feedback_20261008.json`，新增视频证据在 `build/board_videos_20261008/observations.json`；原candidate检查点保持冻结。')
readme_path.write_text(readme + updates.replace('(packet_diag两音源视频判读_20261008.md)', '(E:/QQ%20CACHE/Download/安路资料/开发记录/专题记录/FAT32文件播放/packet_diag两音源视频判读_20261008.md)'), encoding='utf-8')
assert digest(bit) == SHA
print(json.dumps({'saved_beijing': NOW, 'videos_archived': 2, 'pages_read': 18, 'record': str(report_path), 'candidate_sha256': SHA, 'source_or_bit_changes': False}, ensure_ascii=False))
