"""Freeze the selected C11319 offline delivery and its verification evidence."""
from pathlib import Path
from datetime import datetime
import argparse
import hashlib
import json
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[2]
PLAYER = ROOT / 'development/player_video19'
WORK = ROOT / 'development/video19_work'
PACKAGE = ROOT / 'deliverables/video19_c11319_20261021'
CHECKPOINT = PLAYER / 'checkpoints/C11319_video19_20261021_offline'
EXPECTED_BIT = '2cc753d6cc2d241cc06e8ecb1e7b5bc86bc08eb99a6f074cba5ca5bf0791e430'


def sha(path):
    h = hashlib.sha256()
    with path.open('rb') as f:
        for block in iter(lambda: f.read(1048576), b''):
            h.update(block)
    return h.hexdigest()


def save(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def copy(source, relative):
    target = CHECKPOINT / relative
    if source.is_file():
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
    else:
        shutil.copytree(source, target, ignore=shutil.ignore_patterns(
            'work', 'cone_work', '__pycache__', '*.wlf', '*.vstf', '*.pyc'))


parser = argparse.ArgumentParser()
parser.add_argument('--prepare', action='store_true')
parser.add_argument('--pin-run', type=Path)
parser.add_argument('--physical-result', type=Path)
args = parser.parse_args()

if args.prepare:
    CHECKPOINT.mkdir(parents=True, exist_ok=False)
    for name in ('src', 'scripts', 'sim'):
        copy(PLAYER / name, Path(name))
    for name in ('stage_evidence', 'AC201_player_video19.bit', 'AC201_tf_hdmi_gate.db',
                 'AC201_tf_hdmi_gate.v', 'AC201_tf_hdmi_pr.db', 'AC201_tf_hdmi_gate.area',
                 'AC201_tf_hdmi_phy.area', 'AC201_tf_hdmi_pr.timing',
                 'build_source_scope.json', 'synthesis_console.log', 'physical_console.log',
                 'hold_console.log', 'bitstream_console.log'):
        copy(PLAYER / 'build/manual' / name, Path('build/manual') / name)
    for name in ('run_video_system.py', 'tb_video_system.v', 'verify_video19_binding.py',
                 'seal_offline.py'):
        copy(WORK / name, Path('verification/helpers') / name)
    print(json.dumps({'status': 'SOURCE_AND_BUILD_FROZEN', 'path': str(CHECKPOINT)}))
else:
    assert args.pin_run and args.physical_result
    binding = json.loads((WORK / 'combined_area/C04/final_source_binding.json').read_text())
    assert binding['status'] == 'PASS'
    assert sha(PACKAGE / 'video19.bit') == EXPECTED_BIT
    assert sha(PACKAGE / 'VIDEO.MJP') == '239a413b3fc9462ab362918177f3e62e7069f10559281815e7c3198457525c31'
    assert sha(PACKAGE / 'TEST.WAV') == '30eaf10a6ff1800163cecb3225cce685873b38c9a8e42635f1e5c92b0e95b5de'
    selections = [
        (PLAYER / 'build/video_system_20261021_203750', 'verification/q90_short_window'),
        (PLAYER / 'build/video_system_20261021_203329', 'verification/q95_negative_phase'),
        (WORK / 'photo_regression/runs/photo_system_20261021_200426', 'verification/photo_audio_fft'),
        (PLAYER / 'build/gate_verify', 'verification/gate_fft'),
        (PLAYER / 'build/audit', 'verification/rom_init'),
        (WORK / 'final_route_audit', 'verification/final_route_audit'),
        (WORK / 'cadence_analysis', 'verification/cadence_analysis'),
        (WORK / 'color_pipeline', 'verification/color_pipeline'),
        (WORK / 'video_pin_scoreboard', 'verification/video_pin_scoreboard'),
        (WORK / 'physical_resume', 'verification/physical_resume'),
        (WORK / 'combined_area/C04/final_source_binding.json', 'verification/final_source_binding.json'),
        (WORK / 'media_q90_trial/prepare.py', 'verification/prepare_q90.py'),
        (WORK / 'media_q90_trial/output/index.json', 'verification/q90_index.json'),
    ]
    for source, target in selections:
        copy(source, Path(target))
    download = ROOT / 'download/video19.bit'
    shutil.copy2(PACKAGE / 'video19.bit', download)
    info = {
        'build_id': 'C11319', 'candidate': 'C04_exact_elastic_color',
        'status': 'OFFLINE_VERIFIED_BOARD_PENDING', 'created_local': datetime.now().isoformat(),
        'bit_sha256': EXPECTED_BIT, 'slice_used': 9554, 'slice_total': 9800,
        'setup_wns_ns': 0.289, 'hold_wns_ns': 0.024, 'setup_tns_ns': 0, 'hold_tns_ns': 0,
        'bram9k': 62, 'dsp': 27, 'spi_mhz': 12.5,
        'source_binding': str(WORK / 'combined_area/C04/final_source_binding.json'),
        'hdmi_pin_run': str(args.pin_run.resolve()), 'physical_result': str(args.physical_result.resolve()),
        'hardware': 'Pending user board/TF availability; no programming/card/Flash operation performed',
        'media': {'width': 640, 'height': 480, 'fps': 15, 'frames': 300, 'seconds': 20,
                  'jpeg_quality': 90, 'sampling': '420', 'framebuffer': 'RGB565',
                  'pcm_rate_hz': 48000, 'pcm_bits': 16, 'pcm_channels': 1,
                  'jpeg_average_mbps': 3.3165176, 'files_gross_mbps': 4.1767224},
        'validation_scope': {
            'whole_file_reader': '302 records: 300 original frames, wrap0, reset0; lengths/CRC/LBA exact',
            'application': 'Q90 peak108 second frame; AUDIO_PHASE800 50ms window; 205ms selected scenes',
            'hdmi': 'Independent C03 JPEG reference to C04 pixels/framebuffer; AXIS to TMDS pins; original PCM',
            'physical': 'C04 actual SDRAM gate and APUG011 device model; original Q95 prefix; nominal PLL replay',
            'timing': 'Final post-hold static timing; SDF and full20s whole-system/board playback pending'},
    }
    save(ROOT / 'download/video19.info.json', info)
    save(PACKAGE / 'video19.info.json', info)
    copy(PACKAGE, Path('delivery'))
    files = [{'path': str(p.relative_to(CHECKPOINT)).replace('\\', '/'),
              'bytes': p.stat().st_size, 'sha256': sha(p)}
             for p in sorted(CHECKPOINT.rglob('*')) if p.is_file()]
    save(CHECKPOINT / 'manifest.json', {'status': 'FROZEN', 'files': files})
    frozen_errors = [e['path'] for e in files
                     if sha(CHECKPOINT / e['path']) != e['sha256']]
    assert not frozen_errors
    package_files = [{'path': p.name, 'bytes': p.stat().st_size, 'sha256': sha(p)}
                     for p in sorted(PACKAGE.iterdir()) if p.is_file()]
    receipt = {'status': 'OFFLINE_VERIFIED_BOARD_PENDING',
               'created_local': datetime.now().isoformat(), 'files': package_files,
               'checkpoint': str(CHECKPOINT), 'checkpoint_files': len(files),
               'checkpoint_manifest_sha256': sha(CHECKPOINT / 'manifest.json'),
               'binding_checks': binding['checks_count'],
               'bit_copies_match': all(sha(p) == EXPECTED_BIT for p in
                    (download, PACKAGE / 'video19.bit', CHECKPOINT / 'build/manual/AC201_player_video19.bit'))}
    assert receipt['bit_copies_match']
    save(PACKAGE / 'delivery_receipt.json', receipt)
    archive = PACKAGE.with_suffix('.zip')
    with zipfile.ZipFile(archive, 'x', zipfile.ZIP_DEFLATED) as z:
        for p in sorted(PACKAGE.iterdir()):
            if p.is_file():
                z.write(p, f'{PACKAGE.name}/{p.name}')
    with zipfile.ZipFile(archive) as z:
        assert z.testzip() is None
        for entry in receipt['files']:
            data = z.read(f'{PACKAGE.name}/{entry["path"]}')
            assert hashlib.sha256(data).hexdigest() == entry['sha256']
    save(archive.with_suffix('.zip.receipt.json'), {
        'status': 'PASS', 'archive': str(archive), 'bytes': archive.stat().st_size,
        'sha256': sha(archive), 'zip_crc_and_payload_hashes': 'PASS',
        'delivery_receipt_sha256': sha(PACKAGE / 'delivery_receipt.json')})
    print(json.dumps(receipt, ensure_ascii=False, indent=2))
