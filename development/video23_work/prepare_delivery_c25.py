from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[2]
p = ROOT / 'development/player_video25_sdhc_init'
base = ROOT / 'development/player_video23_mode_switch'
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
read = lambda path: json.loads(path.read_text(encoding='utf-8-sig'))


def save(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


binding = read(p / 'verification/final_stage_binding.json')
assert binding['status'] == 'PASS'
old = {q.relative_to(base / 'src/user_source').as_posix(): sha(q)
       for q in (base / 'src/user_source').rglob('*') if q.is_file()}
new = {q.relative_to(p / 'src/user_source').as_posix(): sha(q)
       for q in (p / 'src/user_source').rglob('*') if q.is_file()}
assert old.keys() == new.keys()
changed = sorted(k for k in old if old[k] != new[k])
assert changed == ['hdl_source/SD/sd_card_sec_read_write.v',
                   'hdl_source/player_compact_status_pages.v']
sd = p / 'src/user_source/hdl_source/SD/sd_card_sec_read_write.v'
assert sha(sd) == 'c564981202ac07c103d8efdcf9c024d2a2b71873a6742eeddc4866bcac375857'
assert 'S_CMD16' not in sd.read_text(encoding='utf-8-sig')
pages = p / 'src/user_source/hdl_source/player_compact_status_pages.v'
assert pages.read_text(encoding='utf-8-sig').replace('00C11325', '00C11323') == (
    base / 'src/user_source/hdl_source/player_compact_status_pages.v').read_text(encoding='utf-8-sig')
system = p / 'build/video_system_20261022_141439'
assert read(system / 'summary.json')['status'] == 'PASS'
system_log = (system / 'console.log').read_text(encoding='utf-8-sig')
assert 'VIDEO_SYSTEM_PASS decoded_pixels=1030912 commits=3 distinct_frames=2 PCM=6440 underflow=0 late=0' in system_log
receipt = read(system / 'source_receipt.json')
compat = {x['path']: x['copy_sha256'].lower() for x in receipt['compatibility']}
for row in receipt['inputs']:
    assert sha(Path(row['source'])) == row['sha256'].lower()
    assert sha(Path(row['copy'])) == compat.get(row['copy'], row['sha256'].lower())
sdlog = ROOT / 'development/video23_work/mode_analysis/sd_quiesce_c25_actual.log'
sdtext = sdlog.read_text(encoding='utf-8-sig')
for marker in ['BASE mounted commands=7 reads=3 crc=3/0 CMD0=1',
               'PASS six phase drain preserved catalog/card session',
               'PASS negative control: injected one payload bit; CRC bad incremented to 1']:
    assert marker in sdtext
timing = (p / 'build/manual/AC201_tf_hdmi_phy.ts').read_text()
m = re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.', timing)
assert m and all(float(x) >= 0 for x in m.groups())
net = (p / 'verification/final_routed.v').read_text(encoding='utf-8-sig')
counts = {x: len(re.findall(r'^\s*' + x + r'\s*#', net, re.M))
          for x in ['EG_PHY_MSLICE', 'EG_PHY_LSLICE']}
slices = sum(counts.values())
assert 0 < slices <= 9800
area = (p / 'build/manual/AC201_tf_hdmi_phy.area').read_text()
resources = {k: int(re.search(r'^#' + k + r'\s+(\d+)', area, re.M)[1])
             for k in ['lut', 'reg', 'bram', 'dsp', 'pll', 'gclk']}
bit = p / 'build/manual/AC201_player_video25_sdhc_init.bit'
assert sha(bit) == binding['bit_sha256'].lower()
package = ROOT / 'deliverables/video25_sdhc_init_c11325_20261022'
package.mkdir(exist_ok=True)
validation = {
    'status': 'OFFLINE_PASS_BOARD_PENDING', 'build_id': '00C11325',
    'purpose': 'SDHC initialization CMD16 removal; C23 session-preserving mode handoff retained',
    'bit_sha256': sha(bit), 'changed_from_c23': changed,
    'other_user_source_identical': len(old) - len(changed),
    'clock': 'SD SPI12.5MHz, initialization100kHz; pixel/system/PLL unchanged',
    'timing_ns': dict(zip(['setup_wns', 'setup_tns', 'hold_wns', 'hold_tns'], map(float, m.groups()))),
    'slice_used': slices, 'slice_percent': slices / 98, 'routed_slices': counts,
    'physical': resources,
    'video_system': {'status': 'PASS', 'duration_ms': 210, 'decoded_pixels': 1030912,
                     'commits': 3, 'distinct_frames': 2, 'pcm_samples': 6440,
                     'underflow': 0, 'late': 0, 'log_sha256': sha(system / 'console.log'),
                     'source_receipt_sha256': sha(system / 'source_receipt.json'),
                     'assumptions': read(system / 'summary.json')['assumptions']},
    'sd_phase_crc': {'status': 'PASS', 'phases': 6, 'cmd0_count': 1,
                     'negative_payload_bit_crc_bad': 1, 'log_sha256': sha(sdlog)},
    'board_result': 'Pending; C22 remains user-confirmed playable baseline',
    'audio_noise': 'Audio path unchanged; metadata prototype remains separate',
    'causality': 'CMD16 rejection injection reproduced a timeout path; physical card response not captured',
    'final_stage_binding_sha256': sha(p / 'verification/final_stage_binding.json'),
    'created_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
}
save(p / 'verification/final_binding.json', validation)
save(package / 'validation.json', validation)
for target in [ROOT / 'download/video25_sdhc_init.bit', package / 'video25_sdhc_init.bit']:
    shutil.copy2(bit, target)
for name in ['canonical_crc_period_1875.csv', 'crc_period_metadata.json']:
    shutil.copy2(ROOT / 'deliverables/video22_audio_diag_c11322_20261022' / name, package / name)
manual = '''C11325 SDHC初始化精简对照版

位流 video25_sdhc_init.bit；版本页 00C11325。
TF卡文件沿用当前版本，图片/VIDEO.MJP/TEST.WAV保持原位。
工作态SPI12.5MHz，初始化100kHz。相对C23仅删除SDHC冗余CMD16和改变版本号。
保留C23扇区边界模式交接与C22音频观测。

已完成：210ms冷启视频模型、六相SD扇区排空/CRC翻位负控、综合/布局布线/保持时间修正。
待实板验证：冷启动图片/原声；图片和视频往返，包含视频播放1~2秒即返回图片。
先记录版本页、2开头状态页及其下一页CRC。启动失败时再记录4/5及最后两页文件头。
音频杂音问题继续独立调查，本版音频源码沿用。
CMD16拒绝注入可复现旧初始化超时，现场故障与该命令的因果仍待验证。
C22 video22_audio_diag.bit继续保留为实板可播放对照。
'''
(package / '操作说明.txt').write_text(manual, encoding='utf-8')
info = {'build_id': '00C11325', 'sha256': sha(bit), 'status': validation['status'],
        'purpose': validation['purpose'], 'validation': str(package / 'validation.json')}
save(package / 'video25_sdhc_init.info.json', info)
save(ROOT / 'download/video25_sdhc_init.info.json', info)
files = [{'name': q.name, 'bytes': q.stat().st_size, 'sha256': sha(q)}
         for q in sorted(package.iterdir()) if q.is_file() and q.name != 'receipt.json']
save(package / 'receipt.json', {'build_id': '00C11325', 'files': files})
zpath = package.with_suffix('.zip')
with zipfile.ZipFile(zpath, 'w', zipfile.ZIP_DEFLATED) as z:
    for q in sorted(package.iterdir()):
        if q.is_file():
            z.write(q, q.name)
with zipfile.ZipFile(zpath) as z:
    assert z.testzip() is None
    for row in files:
        assert hashlib.sha256(z.read(row['name'])).hexdigest() == row['sha256']
assert len({sha(bit), sha(ROOT / 'download/video25_sdhc_init.bit'), sha(package / 'video25_sdhc_init.bit')}) == 1
record = {'status': 'PASS_DELIVERY_BOARD_PENDING', 'bit_sha256': sha(bit),
          'zip_sha256': sha(zpath), 'zip_bytes': zpath.stat().st_size,
          'payloads': len(files) + 1, 'slice': slices, 'slice_percent': slices / 98,
          'timing_ns': validation['timing_ns']}
save(p / 'verification/delivery_receipt.json', record)
print(json.dumps(record, ensure_ascii=False, indent=2))
