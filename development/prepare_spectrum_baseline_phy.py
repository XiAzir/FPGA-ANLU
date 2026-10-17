from pathlib import Path
import shutil, json, hashlib
from datetime import datetime, timezone, timedelta

root = Path(__file__).resolve().parents[1]
old = root/'development/player_spectrum'
new = root/'development/player_spectrum_baseline_phy'
baseline = root/'development/player_bmp_scale'
assert not new.exists(), 'Preserve existing candidate'
for name in ('src','scripts','sim'):
    shutil.copytree(old/name,new/name,ignore=shutil.ignore_patterns('__pycache__','*.db','*.vvp','AC201_tf_hdmi_Runs'))
for f in (new/'scripts').iterdir():
    if f.suffix in ('.ps1','.tcl'):
        f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum','player_spectrum_baseline_phy').replace('player_spectrum_baseline_phy_','player_spectrum_'),encoding='utf-8')
al=new/'src/td_project/AC201_tf_hdmi.al'
al.write_text(al.read_text(encoding='utf-8-sig').replace('player_spectrum','player_spectrum_baseline_phy').replace('player_spectrum_baseline_phy_','player_spectrum_'),encoding='utf-8')
for name in ('hdmi_phy_warpper.v','lane_lvds_10_1.v'):
    shutil.copyfile(baseline/'src/user_source/hdl_source'/name,new/'src/user_source/hdl_source'/name)
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    f=new/'src/user_source/hdl_source'/name
    f.write_text(f.read_text(encoding='utf-8-sig').replace('C11304','C11305'),encoding='utf-8')
for f in (new/'sim').iterdir():
    if f.suffix in ('.py','.ps1'):
        f.write_text(f.read_text(encoding='utf-8-sig').replace('player_spectrum','player_spectrum_baseline_phy').replace('player_spectrum_baseline_phy_','player_spectrum_'),encoding='utf-8')
(new/'build/audit').mkdir(parents=True)
shutil.copyfile(old/'build/audit/audit_spectrum_rom_init.py',new/'build/audit/audit_spectrum_rom_init.py')
stamp=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
failure={'timeBeijing':stamp,'version':'C11304','status':'FAILED_BOARD_VALIDATION',
 'reportedBy':'user','symptom':'Black screen/no signal before and after KEY1',
 'videoBefore':r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\a4475e174eda909176027905ffa8d58d.mp4',
 'videoAfter':r'E:\QQ CACHE\LiaoTianJiLu\Tencent Files\1791081637\nt_qq\nt_data\Video\2026-10\Ori\3ba64e78d8703317e6bbdbe3fc3bae41.mp4',
 'observedAfterFrame':'DFC11304; A7008000; 6700F485; 7700F485; 97000000; C700002C',
 'limits':'Video shows diagnostic display, not HDMI monitor. No electrical TMDS measurement. Unique root cause unconfirmed.',
 'nextCandidate':'C11305 retains spectrum and ERAM init; restores exactly the two successful C11206 PHY files.'}
(old/'build/board_failure_20261013/feedback.json').write_text(json.dumps(failure,ensure_ascii=False,indent=2),encoding='utf-8')
for f in (root/'download/spectrum.info.json',old/'build/manual/AC201_player_spectrum.info.json'):
    info=json.loads(f.read_text(encoding='utf-8-sig'))
    info['boardStatus']='FAILED_BOARD_VALIDATION';info['boardFeedback']=failure
    f.write_text(json.dumps(info,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
status=docs/'当前状态.md';s=status.read_text(encoding='utf-8-sig')
s=s.replace('**C11304真实频谱柱候选已本地交付，实板待验证**','**C11304真实频谱柱实板失败，C11305隔离修复进行中**')
s=s.replace('音画/观感/长期未板测；未操作JTAG/TF/Flash。','用户反馈KEY1前后黑屏无信号；后视频DFC11304确认版本，输入检查F485/flag7仍有效。原模型/STA结论保留但不构成硬件通过。C11305恢复C11206两份PHY文件，频谱/ERAM初始化暂不变；唯一根因未确认。未操作JTAG/TF/Flash。',1)
s=s.replace('0. 优先按C11304操作卡同条件验证默认音乐/内部音阶/回切、频谱观感、HOLD/恢复和原集成功能；候选未获实板反馈前不升为成功基线。','0. C11304实板失败，停止作为测试推荐；本地制作C11305恢复成功C11206 PHY、保留频谱柱的隔离修复候选，完成时序/封存后交付板测。')
status.write_text(s,encoding='utf-8')
topic=docs/'专题记录/音频可视化/频谱柱_C11304_20261013/README.md'
topic.write_text(f'## {stamp} 实板失败修正\n\n用户反馈C11304在KEY1前后均黑屏无信号；两视频已抽帧，后视频可读DFC11304，音源A页变化、PCM源/输入CRC同F485（flag7），无格式错误。视频只拍数码管，黑屏来自用户描述。原本地PASS有效范围不变，候选状态改FAILED，旧bit/ZIP/325文件快照不改。C11305恢复C11206两份PHY文件、保留真实频谱，正在本地验证；尚未证明唯一原因。证据：工程build/board_failure_20261013。\n\n'+topic.read_text(encoding='utf-8-sig'),encoding='utf-8')
with (docs/'工作日志/2026-10-13.md').open('a',encoding='utf-8') as f:
    f.write(f'\n### {stamp[11:16]}｜C11304黑屏实板失败与C11305隔离修复｜进行中\n\n- 用户反馈KEY1前后黑屏无信号；两视频抽帧确认程序翻页，后视频DFC11304、A7008000、输入CRC F485/flag7，无格式错误；未直接测HDMI输出。\n- live元数据标FAILED，原bit/ZIP/checkpoint不改。新player_spectrum_baseline_phy C11305只恢复成功C11206的HDMI wrapper/lane并改build ID，保留频谱和ERAM init。\n- 未完成：编译/时序/候选封存与实板回归，唯一根因未确认。下一步完成本地验证后交付。\n')
print(new)
