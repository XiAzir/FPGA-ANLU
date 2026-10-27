from pathlib import Path
import hashlib
import json
import shutil

root = Path(__file__).resolve().parents[2]
baseline = root / 'development/player_video32_read_return'
candidate = root / 'development/player_video34_1080p15'
candidate.mkdir()
shutil.copytree(baseline / 'src/user_source', candidate / 'src/user_source')
shutil.copytree(baseline / 'src/td_project/al_ip', candidate / 'src/td_project/al_ip')
shutil.copy2(baseline / 'src/td_project/AC201_tf_hdmi.al', candidate / 'src/td_project/AC201_tf_hdmi.al')
shutil.copytree(baseline / 'scripts', candidate / 'scripts')

project = candidate / 'src/td_project/AC201_tf_hdmi.al'
project.write_bytes(project.read_bytes().replace(
    str(baseline / 'src/td_project').replace('\\', '/').encode(),
    str(candidate / 'src/td_project').replace('\\', '/').encode()))
for path in (candidate / 'scripts').glob('*'):
    if path.suffix in ('.ps1', '.tcl'):
        path.write_bytes(path.read_bytes().replace(b'player_video32_read_return', b'player_video34_1080p15'))

manifest = []
for path in sorted((baseline / 'src/user_source').rglob('*')):
    if path.is_file():
        rel = path.relative_to(baseline)
        copied = candidate / rel
        old_hash = hashlib.sha256(path.read_bytes()).hexdigest()
        new_hash = hashlib.sha256(copied.read_bytes()).hexdigest()
        if old_hash != new_hash:
            raise RuntimeError(str(rel))
        manifest.append({'path': rel.as_posix(), 'sha256': old_hash})
receipt = {'baseline': str(baseline), 'candidate': str(candidate),
           'baseline_bit_sha256': hashlib.sha256((root/'download/video32_read_return.bit').read_bytes()).hexdigest(),
           'copied_source_files': manifest, 'state':'PREPARED_FROM_C32_NOT_BUILT'}
Path(__file__).with_name('baseline_binding.json').write_text(json.dumps(receipt, indent=2), encoding='utf-8')
print(json.dumps({'candidate':str(candidate),'source_files':len(manifest),'baseline_bit_sha256':receipt['baseline_bit_sha256']}))
