from pathlib import Path
import json, datetime
root=Path(__file__).resolve().parents[4]
diag=Path(__file__).resolve().parent
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录')
now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat(timespec='seconds')
feedback={'user':'C11310无信号，回载稳定版正常；本条未说明回载具体版本。',
 'before':'58d4f989ff35cdcd4f887ba4f8727b85.mp4','after':'e07713286b0bd679ed9db01c8ed8a32c.mp4',
 'versionObserved':'DFC11310 in both videos',
 'beforePages':['3100BB80','6700F485','7700F485','8700F485','97000000','A7008000','B7000000','C7840000','DFC11310','E4000080','F0000000','F100475E','F2001800','F3000000','F4000000'],
 'afterPages':['3900BB80','6700F485','7700F485','8700F485','97000000','A7008000','B7000000','C7840000','DFC11310','E4000080','F0000000','F10076A8','F2001600','F3000000','F4000000'],
 'limits':'Visual frame reading. Page3 PCM48000/second, HDMI locked0, frame_seen1. F2 capture state, sample_count8..14 in sampled frames; F3/F4 zero. Asynchronous pages are not one atomic snapshot. Not unique physical root proof.'}
(diag/'feedback.json').write_text(json.dumps(feedback,ensure_ascii=False,indent=2)+chr(10),encoding='utf-8')
info=root/'download/spectrum_fft_recover.info.json'
data=json.loads(info.read_text(encoding='utf-8-sig'))
data.update(boardStatus='FAILED_BOARD_NO_HDMI_SIGNAL',boardFeedbackBeijing=now,boardFeedback=feedback)
info.write_text(json.dumps(data,ensure_ascii=False,indent=2)+chr(10),encoding='utf-8')
status=docs/'当前状态.md'
t=status.read_text(encoding='utf-8-sig')
entry='- **C11310实板失败（本轮用户反馈）**：两视频D页均DFC11310，KEY1前后无信号，回载稳定版正常（本条未指明回载版本）。PCM页3100BB80/3900BB80：48k有效输入、HDMI内核locked=0、frame_seen=1；B帧0/C7840000，F2采样计数8..14而F3/F4均0，继续追控制和遥测矛盾。独立两帧AXIS合同复现共享转换器行结束缺失：614400像素/2 SOF/0 TLAST，应960 TLAST；在隔离player_spectrum_contract_fix修正行首计数后960 TLAST/0错误。旧版也含此bug，不能单独定为本次黑屏根因。live标FAILED；bit/ZIP/266冻结不改。无新发布位流、未操作硬件。证据见工程build/board_feedback_no_signal_20261014。'
if entry not in t:t=t.replace('## 当前阶段','## 当前阶段'+chr(10)*2+entry,1)
status.write_text(t,encoding='utf-8')
log=docs/'工作日志/2026-10-14.md'
with log.open('a',encoding='utf-8') as f:
 f.write(chr(10)+'### '+now[11:16]+'｜C11310无信号与协议错误复现｜进行中'+chr(10)*2)
 f.write(entry+chr(10))
 f.write('- 阶段边界：两版时序均包含25→125MHz的31路径组；此前CC-From/To=no的疑问不代表未分析跨钟。独立网表审计继续追HDMI锁定条件及FFT实际使能；没有将TLAST缺陷或源码继承当作板端唯一因果。用户选择频谱柱保持。下一步须补成可复现控制/实现证据，尚未JTAG/TF写卡/Flash。'+chr(10))
print('Recorded failed C11310; preserved bit/ZIP/checkpoint; isolated RTL contract fix only.')
