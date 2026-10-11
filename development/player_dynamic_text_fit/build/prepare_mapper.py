import hashlib
import json
import shutil
from pathlib import Path

project = Path(__file__).resolve().parent.parent
root = project.parent.parent
original = root / 'development/player_dynamic_text'
experiment = root / 'development/player_dynamic_text_compact/build/mapper_width_experiment'
dest = project / 'sim/mapper_width_experiment'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest().upper()
assert not dest.exists()
for log in ['tb_fat32_file_sector_existing_run.log', 'tb_fat32_file_sector_narrow_existing_run.log', 'tb_mapper_width_equiv_run.log']:
    text = (experiment / log).read_text()
    assert 'PASS' in text and 'FAIL' not in text and 'FATAL' not in text
assert 'cycles=6381198 sectors=12295' in (experiment / 'tb_mapper_width_equiv_run.log').read_text()
old_test = (experiment / 'fat32_file_sector_original.v').read_text()
assert old_test.replace('module fat32_file_sector_original', 'module fat32_file_sector', 1) == (original / 'src/user_source/hdl_source/fat32_file_sector.v').read_text()
assert sha(experiment / 'fat32_file_sector_narrow.v') == '69C462C22D55870281FC2D45BBCB279BBB4FDB0A056F309513E076EBE09F316E'
dest.mkdir()
for file in experiment.iterdir():
    if file.is_file() and file.suffix in ('.v', '.ps1', '.log', '.md'):
        shutil.copy2(file, dest / file.name)
mapper = (experiment / 'fat32_file_sector_narrow.v').read_text().replace('module fat32_file_sector_narrow', 'module fat32_file_sector', 1)
(project / 'src/user_source/hdl_source/fat32_file_sector.v').write_text(mapper, encoding='utf-8')
source = project / 'src/user_source'
changes = []
manifest = []
for file in sorted(p for p in source.rglob('*') if p.is_file()):
    relative = file.relative_to(source)
    old = original / 'src/user_source' / relative
    if sha(old) != sha(file):
        changes.append(relative.as_posix())
    manifest.append({'path': relative.as_posix(), 'source_sha256': sha(old), 'candidate_sha256': sha(file)})
assert len(manifest) == 75 and changes == ['hdl_source/fat32_file_sector.v']
prep_path = project / 'build/preparation.json'
prep = json.loads(prep_path.read_text(encoding='utf-8-sig'))
prep.update(source_manifest=manifest, intentional_user_source_differences=changes, user_source_hash_match_count=74,
            mapper_width_status='MODELS_PASS: 6381198 cycles/12295 sectors, old and narrow bytegap tests',
            intentional_source_delta='Only mapper power/cache_power=14 bits and length/cache_length=13 bits; anchors stay32. Existing4096 limit retained. Original dynamic renderer and other74 sources byte-identical.',
            build_status='NOT_BUILT', board_test_status='NOT_TESTED', bitstream_status='NOT_GENERATED')
prep_path.write_text(json.dumps(prep, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
reused = project / 'build/reused_models'
reused.mkdir()
for name, relative in [('pixels', 'dynamic_sim/pixels_run.log'), ('timer', 'dynamic_sim/timer_run.log'),
                       ('osd', 'osd_sim/run.log'), ('state', 'state_sim/run.log')]:
    shutil.copy2(original / 'build' / relative, reused / (name + '_run.log'))
print('Mapper test bindings verified; 75 sources, only fat32_file_sector.v changed; model evidence copied.')
