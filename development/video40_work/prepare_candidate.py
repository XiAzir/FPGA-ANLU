"""Create the independent C40 TF25 candidate from the board-passed C32 sources."""
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT / 'development/player_video32_read_return'
CAND = ROOT / 'development/player_video40_spi25'
WORK = Path(__file__).resolve().parent

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

if CAND.exists():
    raise RuntimeError('Candidate already exists; preserve it and inspect the current preparation state')
shutil.copytree(BASE / 'src/user_source', CAND / 'src/user_source')
(CAND / 'src/td_project').mkdir()
project = (BASE / 'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8-sig')
project = re.sub(r'(<Project\b[^>]*\bPath=")[^"]*(")', lambda m: m[1] + (CAND / 'src/td_project').as_posix() + m[2], project, count=1)
(CAND / 'src/td_project/AC201_tf_hdmi.al').write_text(project, encoding='utf-8')
shutil.copytree(BASE / 'scripts', CAND / 'scripts')
for script in (CAND / 'scripts').glob('*'):
    if script.is_file():
        content = script.read_text(encoding='utf-8-sig')
        content = content.replace('AC201_player_video32_read_return.bit', 'AC201_player_video40_spi25.bit')
        script.write_text(content, encoding='utf-8')

top_path = CAND / 'src/user_source/hdl_source/top_tf_hdmi_audio.v'
top = top_path.read_text(encoding='utf-8-sig')
assert top.count("32'h00C11332") == 1
assert top.count('sd_card_top #(.SPI_HIGH_SPEED_DIV(0))') == 1
top = top.replace("32'h00C11332", "32'h00C11340")
top = top.replace('sd_card_top #(.SPI_HIGH_SPEED_DIV(0))', 'sd_card_top #(.SPI_HIGH_SPEED_DIV(0), .SPI_FAST_DIV0(1))')
top_path.write_text(top, encoding='utf-8')

card_path = CAND / 'src/user_source/hdl_source/SD/sd_card_top.v'
card = card_path.read_text(encoding='utf-8-sig')
original = '\tparameter  SPI_HIGH_SPEED_DIV = 0'
assert card.count(original) == 1
card = card.replace(original, '\tparameter  SPI_FAST_DIV0 = 0,\n' + original)
assert card.count('spi_master spi_master_m0(') == 1
card = card.replace('spi_master spi_master_m0(', 'spi_master #(.FAST_DIV0(SPI_FAST_DIV0)) spi_master_m0(')
card_path.write_text(card, encoding='utf-8')

inputs = {p.relative_to(BASE / 'src/user_source').as_posix(): digest(p)
          for p in sorted((BASE / 'src/user_source').rglob('*')) if p.is_file()}
changed = [name for name, value in inputs.items() if digest(CAND / 'src/user_source' / name) != value]
preparation = {
    'state': 'SCAFFOLD_CREATED_SPI_RTL_PENDING',
    'base': BASE.as_posix(), 'candidate': CAND.as_posix(), 'version': '00C11340',
    'baseline_bit_sha256': digest(ROOT / 'download/video32_read_return.bit'),
    'baseline_user_sources': inputs, 'changed_before_spi_integration': changed,
    'scope': 'TF SPI fast transfer only; base C32 user-source clocks/SDRAM/HDMI retained; low-speed initialization divider retained.',
}
(CAND / 'verification').mkdir()
(CAND / 'verification/preparation.json').write_text(json.dumps(preparation, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps({k: v for k, v in preparation.items() if k != 'baseline_user_sources'}, ensure_ascii=False, indent=2))
