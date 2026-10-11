"""Verify FAT file-layer scope against the board-verified data_d1 snapshot."""
import hashlib
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
baseline = root.parent / 'player_480p/checkpoints/compact_data_d1_verified/src'
current = root / 'src'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
before = baseline / 'user_source'
after = current / 'user_source'
changed, missing = [], []
for path in before.rglob('*'):
    if path.is_file():
        rel = path.relative_to(before)
        if not (after / rel).exists():
            missing.append(rel.as_posix())
        elif sha(path) != sha(after / rel):
            changed.append(rel.as_posix())
added = [p.relative_to(after).as_posix() for p in after.rglob('*')
         if p.is_file() and not (before / p.relative_to(after)).exists()]
expected_changed = {'hdl_source/top_tf_hdmi_audio.v', 'hdl_source/sd_sector_arbiter.v'}
expected_added = {'hdl_source/' + n for n in (
    'fat32_catalog.v', 'fat32_file_sector.v',
    'tf_bmp_file_player.v', 'tf_wav_file_player.v')}
assert not missing, missing
assert set(changed) == expected_changed, changed
assert set(added) == expected_added, added
inputs = [p for p in after.rglob('*') if p.is_file()]
inputs += [current / 'td_project/AC201_tf_hdmi.al']
inputs += [p for p in (current / 'td_project/al_ip').rglob('*') if p.is_file()]
result = {
    'baseline': str(baseline), 'current': str(current),
    'changed_user_source': changed, 'added_user_source': added,
    'pixel_codec_framebuffer_sdram_pll_pins_sdc_unchanged': True,
    'source_sha256': {p.relative_to(current).as_posix(): sha(p) for p in inputs},
    'board_verification': 'pending for FAT candidate',
}
output = root / 'build/fat_source_audit.json'
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
print('PASS FAT_SCOPE: only top, arbiter and four new file-layer modules changed')
