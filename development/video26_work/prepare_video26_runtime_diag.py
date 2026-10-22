from pathlib import Path
import shutil

base22 = Path('development/player_video22_audio_diag')
base25 = Path('development/player_video25_sdhc_init')
new = Path('development/player_video26_runtime_diag')
assert base22.exists() and base25.exists()
assert not new.exists(), f'target already exists: {new}'
(new / 'src/td_project').mkdir(parents=True)
shutil.copytree(base22 / 'src/user_source', new / 'src/user_source')
shutil.copytree(base22 / 'src/td_project/al_ip', new / 'src/td_project/al_ip')
shutil.copy2(base22 / 'src/td_project/AC201_tf_hdmi.al', new / 'src/td_project/AC201_tf_hdmi.al')
shutil.copytree(base25 / 'scripts', new / 'scripts')
(new / 'verification').mkdir()
for name in ('check_final_stages.ps1', 'dump_final_routed.tcl'):
    shutil.copy2(base25 / 'verification' / name, new / 'verification' / name)
replacements = (
    ('player_video25_sdhc_init', 'player_video26_runtime_diag'),
    ('AC201_player_video25_sdhc_init.bit', 'AC201_player_video26_runtime_diag.bit'),
    ('00C11325', '00C11326'),
)
for p in list((new / 'scripts').rglob('*')) + [new / 'src/td_project/AC201_tf_hdmi.al', *(new/'verification').iterdir()]:
    if p.is_file() and p.suffix.lower() in ('.ps1', '.tcl', '.al'):
        text = p.read_text(encoding='utf-8-sig')
        for old, replacement in replacements:
            text = text.replace(old, replacement)
        p.write_text(text, encoding='utf-8')
print(f'Copied C22 source to {new}; C25 scripts/checkers retargeted to C26.')
