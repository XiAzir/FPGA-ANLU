"""Create C41 from the user-confirmed C40 without copying build databases."""
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT / 'development/player_video40_spi25'
CAND = ROOT / 'development/player_video41_refresh'
assert not CAND.exists(), 'Preserve an existing C41 candidate'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
shutil.copytree(BASE / 'src/user_source', CAND / 'src/user_source')
shutil.copytree(BASE / 'src/td_project/al_ip', CAND / 'src/td_project/al_ip')
project = (BASE / 'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8-sig')
project = re.sub(r'(<Project\b[^>]*\bPath=")[^"]*(")',
                 lambda m: m[1] + (CAND / 'src/td_project').as_posix() + m[2], project, count=1)
(CAND / 'src/td_project/AC201_tf_hdmi.al').write_text(project, encoding='utf-8')
shutil.copytree(BASE / 'scripts', CAND / 'scripts')
for path in (CAND / 'scripts').iterdir():
    if path.is_file():
        path.write_text(path.read_text(encoding='utf-8-sig').replace(
            'AC201_player_video40_spi25.bit', 'AC201_player_video41_refresh.bit'), encoding='utf-8')
top_path = CAND / 'src/user_source/hdl_source/top_tf_hdmi_audio.v'
top = top_path.read_text(encoding='utf-8-sig')
assert top.count("32'h00C11340") == 1
top_path.write_text(top.replace("32'h00C11340", "32'h00C11341"), encoding='utf-8')
(CAND / 'verification').mkdir()
check = (BASE / 'verification/check_final_stages.ps1').read_text(encoding='utf-8-sig')
check = check.replace('AC201_player_video40_spi25.bit', 'AC201_player_video41_refresh.bit').replace('C40_FINAL', 'C41_FINAL')
(CAND / 'verification/check_final_stages.ps1').write_text(check, encoding='utf-8')
manifest = {p.relative_to(BASE / 'src/user_source').as_posix(): sha(p)
            for p in sorted((BASE / 'src/user_source').rglob('*')) if p.is_file()}
record = {'status': 'SCAFFOLD_CREATED_REFRESH_SPEC_PENDING',
          'baseline_board_feedback': 'download/video40_spi25.board_feedback.json',
          'baseline_bit_sha256': sha(ROOT / 'download/video40_spi25.bit'),
          'baseline_user_sources': manifest,
          'scope': 'Keep TF25, SDRAM50, original HDMI and media; separate periodic-refresh correction.'}
(CAND / 'verification/preparation.json').write_text(
    json.dumps(record, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps({k: v for k, v in record.items() if k != 'baseline_user_sources'}, ensure_ascii=False))
