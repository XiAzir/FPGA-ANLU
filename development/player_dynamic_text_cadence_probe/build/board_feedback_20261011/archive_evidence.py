"""Archive source videos and visually read cadence pages without OCR correction."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import json, hashlib, shutil

root=Path('E:/VSCODE-project/FPGA-ANLU')
local=root/'development/player_dynamic_text_cadence_probe/build/board_feedback_20261011'
archive=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/OSD状态显示/节奏诊断实板失败_20261011')
source=Path('E:/QQ CACHE/LiaoTianJiLu/Tencent Files/1791081637/nt_qq/nt_data/Video/2026-10/Ori')
archive.mkdir(parents=True,exist_ok=True)
sha=lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
pages=['1','3','6','7','8','9','A','B','C']
values={
 'before':['1D400800','33020000','65FFF000','75000000','85BEBC20','950668A0','A5000000','B500001F','C5C10902'],
 'after':['1D400800','3B02BB80','6F208209','7F000326','8FBEBC20','9F0668A0','AF00BB80','BF00001F','CFC10902']}
selected={'before':[8,12,16,20,24,28,32,36,40],'after':[2,4,8,12,16,20,24,28,32]}
files={'before':'8239fea9aa8c4a7c5c092759c0da52d5.mp4','after':'6a481f77ad742393486554fe841615e2.mp4'}
feedback={
 'recorded_beijing':datetime.now(timezone(timedelta(hours=8))).isoformat(timespec='seconds'),
 'status':'BOARD_FAIL_NO_HDMI_SIGNAL',
 'user_report':{'display':'仍无信号','before_leds':'D3 D2 D1 D0全灭','cold_start':'用户明确确认已断电再上电下载'},
 'expected_bitstream':str(root/'download/cadence_probe.bit'),
 'local_bit_sha256':sha(root/'download/cadence_probe.bit'),
 'board_build_id_observed':'C10902',
 'build_id_is_not_configuration_readback':True,
 'videos':{},
 'interpretation':{
  'file_status':'1D400800: both PLL locks reported, rst_all low, SD init done; FS error and code08 timeout, not mounted',
  'default_audio':'Observer reports no valid audio; 6 FFF000 is uninitialized gap history, not measured 4095-cycle interval',
  'internal_tone':'520/521 cycles between events, zero bad gaps,806 samples/frame,420000 cycles/frame;12500000 half ticks and48000 samples/window',
  'clock_word':'01F and no observed locked clock-word errors, before serializer only',
  'legacy_page3':'Before 020000, after 02BB80 vs observer A 000000/00BB80; fixed extra bit17=0x020000. Anomaly is in reported data; stage not yet localized',
  'scope':'This build does not reproduce old axis_probe471xx; old bitstream cause remains unknown. Do not infer absolute25MHz or electrical HDMI output from counters.'},
 'actions':'Read-only source/netlist/video analysis; no card, JTAG or Flash operations; no new bitstream generated',
 'root_cause':'NOT_CONFIRMED',
}
for mode,name in files.items():
    dest=archive/mode
    dest.mkdir(exist_ok=True)
    shutil.copy2(source/name,dest/'board_video.mp4')
    assert sha(source/name)==sha(dest/'board_video.mp4')
    shutil.copy2(local/mode/'ffprobe.json',dest/'ffprobe.json')
    for p in (local/mode).glob('contact_*.png'):shutil.copy2(p,dest/p.name)
    records=[]
    for page,val,index in zip(pages,values[mode],selected[mode]):
        p=local/mode/'frames'/f'frame_{index:03d}.png'
        target=dest/f'page_{page}_frame_{index:03d}.png'
        shutil.copy2(p,target)
        records.append({'page':page,'hex':val,'frame_index_fps2':index,'nominal_seconds':(index-1)/2,'evidence':str(target)})
    probe=json.loads((local/mode/'ffprobe.json').read_text(encoding='utf-8-sig'))
    feedback['videos'][mode]={'source':str(source/name),'archived':str(dest/'board_video.mp4'),'sha256':sha(source/name),'bytes':(source/name).stat().st_size,'duration_seconds':float(probe['format']['duration']),'pages':records}
feedback['reading_method']='ffmpeg fps=2 extraction, manual segment reading. Hex B is lower-case b glyph (top a segment off); self-test numeral6 has top segment on. Original full frames retained. Time values are filter-grid labels, not exact source frame PTS.'
for dest in [local/'feedback.json',archive/'feedback.json']:
    dest.write_text(json.dumps(feedback,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [root/'download/cadence_probe.info.json',root/'development/player_dynamic_text_cadence_probe/build/manual/AC201_player_dynamic_text_cadence_probe.info.json']:
    info=json.loads(p.read_text(encoding='utf-8-sig'))
    info['status']='BOARD_FAIL_NO_SIGNAL_UNDER_INVESTIGATION'
    info['hardware_result']='USER_REPORTED_NO_SIGNAL_AFTER_COLD_START_BEFORE_AND_AFTER_TONE_SWITCH'
    info['root_cause']='NOT_CONFIRMED'
    info['board_feedback_record']=str(archive/'feedback.json')
    p.write_text(json.dumps(info,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'archive':str(archive),'pages':18,'old_frozen_checkpoint_and_zip':'unchanged'},ensure_ascii=False))
