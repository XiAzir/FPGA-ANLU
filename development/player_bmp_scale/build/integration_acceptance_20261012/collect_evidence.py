"""Index existing C11206 acceptance evidence; no build or hardware operations."""
from pathlib import Path
import datetime
import hashlib
import json
import re

ROOT = Path('E:/VSCODE-project/FPGA-ANLU')
DOCS = Path('E:/QQ CACHE/Download/安路资料/开发记录')
TOPIC = DOCS / '专题记录/整机集成/C11206五扩展验收_20261012'
CURRENT = ROOT / 'development/player_bmp_scale/checkpoints/bmp_scale_20261012_verified'
CANDIDATE = CURRENT.parent / 'bmp_scale_20261012_candidate'
NOW = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')


def load(file):
    return json.loads(Path(file).read_text(encoding='utf-8-sig'))


def sha(file):
    digest = hashlib.sha256()
    with Path(file).open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(block)
    return digest.hexdigest().upper()


def save(file, value):
    Path(file).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def snapshot(folder, count, expected):
    assert sha(folder / 'manifest.json') == expected
    items = load(folder / 'manifest.json')
    assert len(items) == count
    for item in items:
        file = folder / item['path']
        assert file.stat().st_size == item['bytes'] and sha(file) == item['sha256']
    return {'path': str(folder), 'files': count, 'manifestSha256': expected, 'allEntriesMatched': True}


acceptance = load(ROOT / 'development/player_bmp_scale/build/acceptance_verified.json')
delivery = load(ROOT / 'development/player_bmp_scale/build/delivery_verified.json')
bit_sha = acceptance['bitSha256']
verified_check = snapshot(CURRENT, 268, acceptance['manifestSha256'])
candidate_check = snapshot(CANDIDATE, 260, delivery['manifestSha256'])
assert sha(ROOT / 'download/bmp_scale.bit') == bit_sha
assert sha(CURRENT / 'build/manual/AC201_player_bmp_scale.bit') == bit_sha
assert sha(Path(delivery['zip'])) == delivery['zipSha256']

files = {}


def add(path, kind, version, use):
    file = Path(path)
    assert file.is_file(), f'Missing evidence: {file}'
    name = str(file)
    if name in files:
        if use not in files[name]['uses']:
            files[name]['uses'].append(use)
        return
    files[name] = {'path': name, 'kind': kind, 'version': version,
                   'bytes': file.stat().st_size, 'sha256': sha(file), 'uses': [use]}


src = CURRENT / 'src/user_source/hdl_source'
source_functions = {
    'top_tf_hdmi_audio.v': 'TC24/同位流集成与音频像素连线',
    'player_dynamic_text.v': 'E01/TC16', 'player_osd.v': 'E01/TC15',
    'player_adjust_control.v': 'E04/E05/统一按键', 'player_rgb_adjust.v': 'E04/TC17',
    'player_adjust_osd.v': 'E04/TC18', 'player_pcm_waveform.v': 'E05/TC19/HOLD',
    'player_wipe_address.v': 'E02/TC20', 'player_osd_state.v': 'E02/TC20',
    'bmp_scale_engine.v': 'E03/TC21', 'tf_bmp_file_player.v': 'E03/TC09/TC21',
    'tf_wav_file_player.v': '基础/WAV规格', 'fat32_catalog.v': '基础/FAT目录规格',
    'fat32_file_sector.v': '基础/FAT文件规格',
}
for name, use in source_functions.items():
    add(src / name, 'current_frozen_source', 'C11206', use)

for rel, kind, use in [
    ('manifest.json', 'current_manifest', '版本绑定'),
    ('build/manual/AC201_player_bmp_scale.info.json', 'current_frozen_build_info', '正式构建与验收'),
    ('build/model/scaler_validation_receipt.json', 'current_model_receipt', 'E03/TC09/TC21'),
    ('build/model/scaler_full_loader.log', 'current_model_log', 'E03/TC09/TC21'),
    ('build/model/write_backpressure.log', 'current_model_log', 'E03/写侧FIFO反压'),
    ('build/model/verification_scope.md', 'candidate_time_scope_document', '本版/祖先模型覆盖边界'),
    ('build/model/parent_source_audit.json', 'current_source_lineage_audit', '继承与变更范围'),
    ('build/audit/scaler_final_audit.md', 'current_static_audit', '资源/同步RAM/集成'),
    ('build/manual/AC201_tf_hdmi_pr.timing', 'current_formal_timing_report', '原约束setup/hold'),
    ('build/delivery/media_manifest.json', 'candidate_media_manifest', '四尺寸原BMP和预览范围'),
    ('build/board_feedback_20261012/functions_feedback.json', 'current_user_report', '五扩展总体反馈/四图外观'),
]:
    add(CURRENT / rel, kind, 'C11206', use)
for stage, run in [('synthesis', '03c1c1aa-4c00-4a51-8a44-44c994410696'),
                   ('physical', '4c02438d-3657-4bd4-a4ce-6bdad4aa7cef'),
                   ('bitstream', '363e2765-ce3c-4bbe-8aae-266761446b35')]:
    add(CURRENT / f'build/manual/stage_evidence/{stage}_{run}.json', 'current_build_stage_binding', 'C11206', '正式构建来源')

for asset in load(CURRENT / 'build/delivery/media_manifest.json')['files']:
    file = CURRENT / 'build/delivery/TF_ROOT' / asset['tfName']
    assert sha(file).lower() == asset['sha256'].lower()
    add(file, 'supplied_original_bmp_not_card_readback', 'C11206', 'E03/TC21')
feedback = load(CURRENT / 'build/board_feedback_20261012/functions_feedback.json')
for photo in feedback['photos']:
    project_copy, docs_copy = Path(photo['projectCopy']), Path(photo['docsCopy'])
    assert sha(project_copy) == sha(docs_copy) == photo['sha256']
    add(docs_copy, 'current_user_photo', 'C11206_context_association', 'E03布局/静态叠加外观；非动态或音频测量')

parent4 = ROOT / 'development/player_pcm_waveform_keyfreeze/checkpoints/waveform_keyfreeze_20261012_verified'
parent5 = ROOT / 'development/player_transition_wipe/checkpoints/transition_wipe_20261012_verified'
parent1 = ROOT / 'development/player_image_adjust/checkpoints/image_adjust_20261012_verified'
lineage = []
for ancestor, version, names in [
    (parent4, 'C11204', ['player_dynamic_text.v', 'player_osd.v', 'player_adjust_control.v', 'player_pcm_waveform.v']),
    (parent1, 'C11201', ['player_rgb_adjust.v', 'player_adjust_osd.v']),
    (parent5, 'C11205', ['player_wipe_address.v', 'player_osd_state.v']),
]:
    for name in names:
        old_file = ancestor / 'src/user_source/hdl_source' / name
        assert sha(src / name) == sha(old_file), f'Unexpected source change: {name}'
        add(old_file, 'ancestor_frozen_source', version, source_functions[name])
        lineage.append({'module': name, 'currentSource': str(src / name), 'ancestorSource': str(old_file),
                        'ancestorVersion': version, 'sha256': sha(old_file), 'identicalBytes': True,
                        'limit': 'Source identity only; does not establish netlist equivalence or current hardware behavior.'})

for folder, version, logs in [
    (parent1, 'C11201', ['tb_player_rgb_adjust.log', 'tb_player_adjust_control.log']),
    (parent4, 'C11204', ['player_pcm_waveform_model.log', 'keyfreeze_music.log', 'tb_waveform_chord_control.log', 'integration.log']),
    (parent5, 'C11205', ['wipe_address.log', 'wipe_rgb888.log', 'wipe_backend.log', 'verification_scope.md']),
]:
    for name in logs:
        add(folder / 'build/model' / name, 'ancestor_model_evidence_not_rerun_on_C11206', version, '功能/算法/控制历史模型')

for relative, version, use in [
    ('专题记录/图像实时调节/亮度对比度首版_20261012/board_feedback.json', 'C11201', 'E04/用户反馈'),
    ('专题记录/三扩展集成/C11204验收_20261012/feedback.json', 'C11204', 'E01/E04/E05组合用户反馈'),
    ('专题记录/音频可视化/真实PCM波形首版_20261012/keyfreeze_board_feedback.json', 'C11204', 'E05动态/HOLD对照与已知项'),
    ('专题记录/音频可视化/真实PCM波形首版_20261012/photo_findings.json', 'C11202', 'E05祖先重影照片分析'),
    ('专题记录/图片转场/上下擦除首版_20261012/board_feedback.json', 'C11205', 'E02转场及集成用户反馈'),
    ('专题记录/图片缩放/多尺寸最近邻首版_20261012/board_feedback.json', 'C11206', '当前总体功能反馈/四照片'),
    ('专题记录/图片缩放/多尺寸最近邻首版_20261012/verified_receipt.json', 'C11206', '封存凭据'),
]:
    add(DOCS / relative, 'archived_user_report_or_receipt', version, use)
add(ROOT / 'deliverables/real_music_20261008.package_audit.json', 'supplied_music_audit_not_card_readback', 'music_package_20261008', '60秒PCM16单声道TEST.WAV源包')
add(ROOT / 'planning/20261007/执行规划.md', 'internal_execution_plan', '20261007_with_later_notes', '范围与可选增强/稳定建议')
add(ROOT / 'planning/20261007/source/安路赛题一_开发到提交规划_20261007.md', 'original_internal_plan', '20261007', 'T32/T33/T36/TC详细用例')

index = {
    'recordedBeijing': NOW, 'baseline': 'C11206', 'bitSha256': bit_sha,
    'assemblyStatus': 'COMPLETE_EXISTING_EVIDENCE_INDEX',
    'G4Status': 'FUNCTIONS_REPORTED_PASS_WITH_KNOWN_ISSUES_DYNAMIC_DEMONSTRATION_EVIDENCE_PENDING',
    'T36Status': 'RETAINED_SCOPE_DRAFT_FINAL_FREEZE_NOT_EXECUTED',
    'sourceIdentityComparisons': lineage, 'files': list(files.values()),
    'userReportScope': feedback['reportedFunctions'],
    'limits': ['No new RTL/model/TD execution or board tests in this collection.',
               'Inherited model results retain their ancestor version.',
               'Current photos are static/context-associated; not a bit readback, audio measurement or animation recording.',
               'Known dynamic waveform double trace and low display resolution retained.',
               'No hardware/TF/Flash operation; no timed long-run or maximum-format hardware claim.'],
}
save(TOPIC / '证据索引.json', index)

broken = []
links = 0
for name in ['README.md', '后续验证清单.md']:
    file = TOPIC / name
    for target in re.findall(r'\[[^\]]+\]\(([^\n)]+)\)', file.read_text(encoding='utf-8')):
        target = target.strip('<>')
        if target == '整理凭据.json':
            continue  # Written immediately below.
        if target.startswith(('http://', 'https://', '#')):
            continue
        target = re.sub(r':\d+$', '', target)
        path = Path(target) if re.match(r'^[A-Za-z]:[/\\]', target) else file.parent / target
        links += 1
        if not path.exists():
            broken.append({'file': name, 'target': target})
assert not broken, json.dumps(broken, ensure_ascii=False)

result = {
    'recordedBeijing': NOW, 'task': 'T32/T33 evidence collection; no final G4 or T36 freeze claim',
    'baselineBitSha256': bit_sha, 'verifiedSnapshot': verified_check, 'candidateSnapshot': candidate_check,
    'originalZipSha256': delivery['zipSha256'], 'originalSourceBitSnapshotsAndZipUnchanged': True,
    'indexedFiles': len(files), 'sourceIdentityComparisons': len(lineage), 'existingLocalLinksChecked': links,
    'evidenceIndexSha256': sha(TOPIC / '证据索引.json'),
    'documents': [{'path': str(TOPIC / name), 'sha256': sha(TOPIC / name)} for name in ['README.md', '后续验证清单.md']],
    'remaining': 'Waveform clarity optimization, timed stability/error regression, final dynamic demonstrations, T36 final freeze and Flash/submission remain unexecuted.',
}
save(TOPIC / '整理凭据.json', result)
save(Path(__file__).parent / 'collection_receipt.json', result)
print(json.dumps({'status': 'PASS', 'indexedFiles': len(files), 'sourceComparisons': len(lineage),
                  'linksChecked': links, 'indexSha256': result['evidenceIndexSha256'], 'recordedBeijing': NOW}))
