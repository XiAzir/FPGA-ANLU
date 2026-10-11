from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[3] / 'scripts'))
from anlu_paths import REPOSITORY_ROOT, DOCS_ROOT, recorded_path, require_file
import hashlib, json, shutil, datetime

root = REPOSITORY_ROOT
candidate = root/'development/player_dynamic_text_axis_last_fix'
topic = (DOCS_ROOT / '开发记录/专题记录/OSD状态显示/动态字幕资源版竖线_20261009')
def sha(p): return hashlib.sha256(require_file(p).read_bytes()).hexdigest().upper()
guards = {}
for project, checkpoint, count in (
    ('player_osd_phy_fix','osd_phy_fix_20261009_candidate',174),
    ('player_dynamic_text','dynamic_text_20261009_candidate',136),
    ('player_dynamic_text_fit','dynamic_text_fit_20261009_candidate',148),
    ('player_dynamic_text_video_probe','dynamic_text_video_probe_20261009_candidate',140),
):
    folder = root/'development'/project/'checkpoints'/checkpoint
    manifest = json.loads((folder/'manifest.json').read_text(encoding='utf-8-sig'))
    assert len(manifest) == count, (project, len(manifest))
    for item in manifest:
        path = require_file(folder/item['path'])
        assert path.is_file() and path.stat().st_size == item['bytes'] and sha(path) == item['sha256'].upper(), str(path)
    guards[str(folder)] = {'count':count, 'result':'PASS', 'manifest_sha256':sha(folder/'manifest.json')}
for name, expected in (
    ('osd_phy_fix.bit','9E893B0B6C86BF6FBEE19E74B5FB58933C1BEA6AA07F203786CCE96F3B60AE6F'),
    ('dynamic_text_video_probe.bit','1EFEB04BD50035789E4EBD1430B3CB8736B0F48D93DAF24FD4013AB8130F30DF'),
    ('dynamic_text_fit.bit','028D9D9A742A2CD980ECBEA48FFBE824D89DA34CF6B2B3E66EA0AA42B6D6456D'),
    ('dynamic_text.bit','D0559A203C0A775B2C70F7A1EA3E7F90BB7743F7ED463AF11409855D54CBF28F'),
):
    assert sha(root/'download'/name) == expected, name
evidence = {}
for key, source in {
    'warm_summary.json':root/'build/board_video_20261009_nosignal/summary.json',
    'warm_12p20.png':root/'build/board_video_20261009_nosignal/source_12p20.png',
    'cold_summary.json':root/'development/player_dynamic_text_video_probe/build/board_video_20261009_cold_tone/summary.json',
    'cold_00p20.png':root/'development/player_dynamic_text_video_probe/build/board_video_20261009_cold_tone/source_00p20.png',
    'cold_02p70_crop.png':root/'development/player_dynamic_text_video_probe/build/board_video_20261009_cold_tone/crop_02p70.png',
    'cold_04p20.png':root/'development/player_dynamic_text_video_probe/build/board_video_20261009_cold_tone/source_04p20.png',
    'cold_10p20.png':root/'development/player_dynamic_text_video_probe/build/board_video_20261009_cold_tone/source_10p20.png',
}.items():
    assert source.is_file(), str(source)
    dest = topic/'nosignal_evidence'/key
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists(): assert sha(dest) == sha(source), str(dest)
    else: shutil.copyfile(source,dest)
    evidence[str(dest)] = {'source':str(source), 'bytes':dest.stat().st_size,'sha256':sha(dest)}
out = {'recorded_beijing': datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat(), 'frozen_guards':guards,'old_download_bits':'PASS','copied_evidence':evidence}
(candidate/'build/frozen_guard_and_evidence.json').write_text(json.dumps(out, ensure_ascii=False, indent=2)+'\n',encoding='utf-8')
print(json.dumps({'frozen_files':sum(i['count'] for i in guards.values()),'old_bits':'PASS','copied_evidence':len(evidence)},ensure_ascii=False))
