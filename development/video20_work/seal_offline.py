"""Prepare and finalize the selected C11320 offline delivery."""
from pathlib import Path
from datetime import datetime
import argparse
import hashlib
import json
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[2]
PLAYER20 = ROOT / 'development/player_video20'
WORK20 = ROOT / 'development/video20_work'
LEGACY_PIN_NEGATIVE = ROOT / 'development/video19_work/video_pin_scoreboard/runs'
PACKAGE = ROOT / 'deliverables/video20_c11320_20261021'
CHECKPOINT = PLAYER20 / 'checkpoints/C11320_video20_20261021_offline'
EXPECTED_BIT = '2c97c1152d69a1a7a9b7681d543f3834c2a4fdd4a0f15ec0982bc90579310e6d'
EXPECTED_VIDEO = '239a413b3fc9462ab362918177f3e62e7069f10559281815e7c3198457525c31'
EXPECTED_WAV = '30eaf10a6ff1800163cecb3225cce685873b38c9a8e42635f1e5c92b0e95b5de'


def sha(path):
    h = hashlib.sha256()
    with path.open('rb') as f:
        for block in iter(lambda: f.read(1048576), b''):
            h.update(block)
    return h.hexdigest()


def save(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def ignored_names(_directory, names, omit_td_db=False):
    ignored_dirs = {
        '.git', '__pycache__', 'work', 'cone_work', 'simv.daidir',
        'modelsim_lib', 'questa_lib', 'xcelium.d', '.pytest_cache', '.mypy_cache',
    }
    ignored_suffixes = {'.wlf', '.vstf', '.pyc', '.qdb', '.qpg', '.vdb', '.o', '.obj'}
    result = set()
    for name in names:
        path = Path(name)
        if name in ignored_dirs or path.suffix.lower() in ignored_suffixes:
            result.add(name)
        elif name.lower() in {'transcript', 'simv'}:
            result.add(name)
        elif omit_td_db and name.lower() == 'td_project':
            result.add(name)
        elif omit_td_db and path.suffix.lower() in {'.db', '.aig'}:
            result.add(name)
    return result


def copy(source, relative, target_root=CHECKPOINT, *, required=True, omit_td_db=False):
    source = Path(source)
    target = target_root / relative
    if not source.exists():
        if required:
            raise FileNotFoundError(f'required evidence is missing: {source}')
        return False
    if source.is_file():
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
    elif source.is_dir():
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(
            source, target,
            ignore=lambda directory, names: ignored_names(directory, names, omit_td_db),
            dirs_exist_ok=False,
        )
    else:
        raise ValueError(f'unsupported evidence path: {source}')
    return True


def file_entries(directory, *, exclude=()):
    exclude = {Path(p).as_posix() for p in exclude}
    return [
        {'path': p.relative_to(directory).as_posix(), 'bytes': p.stat().st_size, 'sha256': sha(p)}
        for p in sorted(directory.rglob('*'))
        if p.is_file() and p.relative_to(directory).as_posix() not in exclude
    ]


def verify_entries(directory, entries):
    errors = []
    for entry in entries:
        path = directory / entry['path']
        if not path.is_file() or path.stat().st_size != entry['bytes'] or sha(path) != entry['sha256']:
            errors.append(entry['path'])
    return errors


def freeze_sources():
    if CHECKPOINT.exists():
        raise FileExistsError(f'checkpoint already exists; refusing to replace it: {CHECKPOINT}')
    CHECKPOINT.mkdir(parents=True, exist_ok=False)
    for name in ('src', 'scripts', 'sim'):
        copy(PLAYER20 / name, Path(name))

    manual = PLAYER20 / 'build/manual'
    for name in (
        'stage_evidence', 'build_source_scope.json',
        'AC201_player_video20.bit', 'AC201_tf_hdmi_gate.v',
        'AC201_tf_hdmi_gate.db', 'AC201_tf_hdmi_pr.db',
    ):
        copy(manual / name, Path('build/manual') / name)

    for pattern in ('*.area', '*.ts', '*timing*', '*console.log', 'strategy_actual.*'):
        for source in sorted(manual.glob(pattern)):
            if source.is_file():
                copy(source, Path('build/manual') / source.name)

    for name in ('run_video_system.py', 'tb_video_system.v', 'verify_video20_binding.py', 'seal_offline.py'):
        copy(WORK20 / name, Path('verification/helpers') / name, required=False)
    print(json.dumps({'status': 'SOURCE_AND_BUILD_FROZEN', 'path': str(CHECKPOINT)}, ensure_ascii=False))


def validate_final_inputs(binding_path, pin_run, physical_path):
    if not binding_path or not pin_run or not physical_path:
        raise ValueError('--finalize requires --binding, --pin-run, and --physical-result')
    binding = json.loads(binding_path.read_text(encoding='utf-8'))
    pin_summary = json.loads((pin_run / 'summary.json').read_text(encoding='utf-8'))
    physical = json.loads(physical_path.read_text(encoding='utf-8'))
    if binding.get('status') != 'PASS':
        raise AssertionError(f'binding status must be PASS; got {binding.get("status")!r}')
    if pin_summary.get('status') != 'PASS':
        raise AssertionError(f'pin-run status must be PASS; got {pin_summary.get("status")!r}')
    if physical.get('status') not in {'PASS', 'PASS_AFTER_STARTUP_TRANSIENT'}:
        raise AssertionError(f'physical status is not accepted: {physical.get("status")!r}')
    legacy_pin_controls = []
    for kind in ('rgb', 'pcm'):
        summary_path = LEGACY_PIN_NEGATIVE / f'C04_Q90_pin_20261021_203750_negative_{kind}' / 'summary.json'
        summary = json.loads(summary_path.read_text(encoding='utf-8'))
        if summary.get('status') != 'NEGATIVE_CONTROL_PASS':
            raise AssertionError(f'legacy C11319 pin negative control did not pass: {summary_path}')
        checker = 'system_pin_scoreboard_video.vh'
        assert sha(pin_run / checker) == sha(summary_path.parent / checker)
        legacy_pin_controls.append({'path': str(summary_path), 'status': summary['status'],
                                    'summary_sha256': sha(summary_path),
                                    'unchanged_checker_sha256': sha(pin_run / checker),
                                    'scope': 'Prior C11319 rejection controls; same checker, prior source'})

    required_package = ('video20.bit', 'VIDEO.MJP', 'TEST.WAV', 'video20.info.json')
    for name in required_package:
        if not (PACKAGE / name).is_file():
            raise FileNotFoundError(f'package is incomplete; missing {PACKAGE / name}')
    docs_dir = PACKAGE / 'docs'
    has_docs = (PACKAGE / 'README.md').is_file() or (
        docs_dir.is_dir() and any(p.is_file() for p in docs_dir.rglob('*'))
    )
    if not has_docs:
        raise FileNotFoundError('package requires README.md or at least one file under docs/')
    if sha(PACKAGE / 'video20.bit') != EXPECTED_BIT:
        raise AssertionError('package bit SHA-256 does not match the expected C11320 build')
    if sha(PACKAGE / 'VIDEO.MJP') != EXPECTED_VIDEO or sha(PACKAGE / 'TEST.WAV') != EXPECTED_WAV:
        raise AssertionError('package media SHA-256 does not match the frozen media inputs')

    # The source tree must still match the source snapshot made by --prepare.
    for name in ('src', 'scripts', 'sim'):
        current = PLAYER20 / name
        frozen = CHECKPOINT / name
        if not current.is_dir() or not frozen.is_dir():
            raise FileNotFoundError(f'missing current or frozen source tree: {name}')
        current_files = {p.relative_to(current).as_posix(): p for p in current.rglob('*') if p.is_file()}
        frozen_files = {p.relative_to(frozen).as_posix(): p for p in frozen.rglob('*') if p.is_file()}
        if current_files.keys() != frozen_files.keys():
            raise AssertionError(f'{name} file set changed after --prepare')
        changed = [rel for rel in current_files if sha(current_files[rel]) != sha(frozen_files[rel])]
        if changed:
            raise AssertionError(f'{name} changed after --prepare: {changed[:8]}')
    manual_bit = CHECKPOINT / 'build/manual/AC201_player_video20.bit'
    if not manual_bit.is_file() or sha(manual_bit) != EXPECTED_BIT:
        raise AssertionError('frozen manual bit is missing or its SHA-256 differs from EXPECTED_BIT')
    return binding, pin_summary, physical, legacy_pin_controls


def finalize(args):
    if not args.binding or not args.pin_run or not args.physical_result:
        raise ValueError('--finalize requires --binding, --pin-run, and --physical-result')
    binding_path = args.binding.resolve()
    pin_run = args.pin_run.resolve()
    physical_path = args.physical_result.resolve()
    delivery_status = 'OFFLINE_VERIFIED_BOARD_PENDING'
    binding, pin_summary, physical, legacy_pin_controls = validate_final_inputs(
        binding_path, pin_run, physical_path)
    info = json.loads((PACKAGE / 'video20.info.json').read_text(encoding='utf-8'))
    assert info['status'] == delivery_status
    counts = json.loads((WORK20 / 'final_route_audit/posthold_slice_count.json').read_text())
    assert counts['post_explicit_hold_routed_netlist_counts']['total_slice_primitives'] == 8637
    assert 8637 <= 8820
    archive = PACKAGE.with_suffix('.zip')
    if archive.exists():
        raise FileExistsError(f'refusing to overwrite existing package archive: {archive}')
    for existing in (PACKAGE / 'video20_manifest.json', PACKAGE / 'video20_receipt.json'):
        if existing.exists():
            raise FileExistsError(f'refusing to overwrite existing package record: {existing}')

    selections = [
        (PLAYER20 / 'build/video_system_20261021_215350', 'verification/app_short_window'),
        (Path(physical['run_directory']), 'verification/physical_run'),
        (PLAYER20 / 'build/video_system_20261021_215714', 'verification/physical_interrupted'),
        (WORK20 / 'photo_regression/runs/photo_system_20261021_220234', 'verification/photo_regression'),
        (PLAYER20 / 'build/gate_verify', 'verification/gate_verify'),
        (PLAYER20 / 'build/audit', 'verification/audit'),
        (WORK20 / 'final_route_audit', 'verification/final_route_audit'),
        (WORK20 / 'idct/retime_shared/review_final', 'verification/idct/review_final'),
        (WORK20 / 'idct/retime_shared/gate_verify', 'verification/idct/gate_verify'),
        (WORK20 / 'rgb/equiv', 'verification/rgb/equiv'),
        (WORK20 / 'huffman/shared_validation', 'verification/huffman/shared_validation'),
        (WORK20 / 'shared_idct/equiv_215144', 'verification/shared_unit'),
        (WORK20 / 'shared_idct/run_equiv.py', 'verification/shared_unit_runner.py'),
        (WORK20 / 'shared_idct/tb_shared.sv', 'verification/shared_unit_tb.sv'),
        (WORK20 / 'area/evidence/fixed_profile', 'verification/fixed_profile'),
        (WORK20 / 'area/evidence/summary.md', 'verification/area_ablation.md'),
        (WORK20 / 'D02_inputs.json', 'verification/D02_inputs.json'),
        (WORK20 / 'seal_offline.py', 'verification/helpers/seal_offline_final.py'),
        (WORK20 / 'prepare_delivery.py', 'verification/helpers/prepare_delivery.py'),
        (WORK20 / 'whole/D02/preservation_and_diff.json', 'verification/preservation_and_diff.json'),
        (pin_run, 'verification/video_pin_run'),
        (binding_path, 'verification/final_binding.json'),
        (physical_path, 'verification/physical_result.json'),
        (WORK20 / 'whole/D00_id_control', 'verification/system_ablation/D00_id_control'),
        (WORK20 / 'whole/D01_shared_serial_gate', 'verification/system_ablation/D01_shared_serial_gate'),
    ]
    for source, target in selections:
        if not source.exists():
            raise FileNotFoundError(f'required verification evidence is missing: {source}')
        if (CHECKPOINT / target).exists():
            raise FileExistsError(f'refusing to replace frozen verification evidence: {CHECKPOINT / target}')
    if (CHECKPOINT / 'delivery').exists() or (CHECKPOINT / 'manifest.json').exists():
        raise FileExistsError('checkpoint delivery or manifest already exists; refusing to overwrite it')
    for source, target in selections:
        copy(source, Path(target), omit_td_db=str(target).startswith('verification/system_ablation/'))

    extra_root = CHECKPOINT / 'verification/optional_results'
    for index, source in enumerate(args.extra_result or []):
        source = source.resolve()
        if source.suffix.lower() != '.json':
            raise ValueError(f'optional result must be a JSON file: {source}')
        json.loads(source.read_text(encoding='utf-8'))
        copy(source, Path(f'{index:02d}_{source.name}'), target_root=extra_root)

    download = ROOT / 'download'
    download.mkdir(parents=True, exist_ok=True)
    shutil.copy2(PACKAGE / 'video20.bit', download / 'video20.bit')
    shutil.copy2(PACKAGE / 'video20.info.json', download / 'video20.info.json')
    three_bit_copies = (
        PACKAGE / 'video20.bit',
        CHECKPOINT / 'build/manual/AC201_player_video20.bit',
        download / 'video20.bit',
    )
    if any(not p.is_file() or sha(p) != EXPECTED_BIT for p in three_bit_copies):
        raise AssertionError('package, frozen manual, and download bit copies must share EXPECTED_BIT')

    package_manifest_path = PACKAGE / 'video20_manifest.json'
    package_entries = file_entries(PACKAGE, exclude=('video20_manifest.json', 'video20_receipt.json'))
    save(package_manifest_path, {'status': 'PASS', 'files': package_entries})
    package_manifest_entry = {
        'path': package_manifest_path.name, 'bytes': package_manifest_path.stat().st_size,
        'sha256': sha(package_manifest_path),
    }
    receipt_entries = package_entries + [package_manifest_entry]
    if verify_entries(PACKAGE, receipt_entries):
        raise AssertionError('package files do not match their manifest hashes')
    save(PACKAGE / 'video20_receipt.json', {
        'status': delivery_status, 'created_local': datetime.now().isoformat(),
        'build_id': 'C11320', 'expected_bit_sha256': EXPECTED_BIT,
        'binding_status': binding['status'], 'pin_status': pin_summary['status'],
        'physical_status': physical['status'], 'files': receipt_entries,
        'legacy_pin_negative_controls': legacy_pin_controls,
        'three_bit_copies_match': all(sha(p) == EXPECTED_BIT for p in three_bit_copies),
    })

    # Copy the complete parent-authored package, including its media, info, docs and hashes.
    copy(PACKAGE, Path('delivery'))
    bit_copies = (
        PACKAGE / 'video20.bit',
        CHECKPOINT / 'build/manual/AC201_player_video20.bit',
        download / 'video20.bit',
        CHECKPOINT / 'delivery/video20.bit',
    )
    if any(not p.is_file() or sha(p) != EXPECTED_BIT for p in bit_copies):
        raise AssertionError('one or more package, frozen, checkpoint-delivery, or download bit copies differ')
    if sha(download / 'video20.info.json') != sha(PACKAGE / 'video20.info.json'):
        raise AssertionError('download info differs from the parent-authored package info')

    checkpoint_manifest = CHECKPOINT / 'manifest.json'
    checkpoint_entries = file_entries(CHECKPOINT, exclude=('manifest.json',))
    save(checkpoint_manifest, {'status': 'FROZEN', 'delivery_status': delivery_status,
                               'build_id': 'C11320', 'files': checkpoint_entries})
    frozen_errors = verify_entries(CHECKPOINT, checkpoint_entries)
    if frozen_errors:
        raise AssertionError(f'checkpoint manifest verification failed: {frozen_errors[:8]}')

    # ZIP every package payload recursively and compare each archived payload SHA-256.
    archive_payloads = {p.relative_to(PACKAGE).as_posix(): sha(p)
                        for p in PACKAGE.rglob('*') if p.is_file()}
    with zipfile.ZipFile(archive, 'x', zipfile.ZIP_DEFLATED) as z:
        for p in sorted(PACKAGE.rglob('*')):
            if p.is_file():
                z.write(p, f'{PACKAGE.name}/{p.relative_to(PACKAGE).as_posix()}')
    with zipfile.ZipFile(archive) as z:
        if z.testzip() is not None:
            raise AssertionError('ZIP CRC validation failed')
        for relative, expected_sha in archive_payloads.items():
            data = z.read(f'{PACKAGE.name}/{relative}')
            if hashlib.sha256(data).hexdigest() != expected_sha:
                raise AssertionError(f'ZIP payload SHA-256 mismatch: {relative}')
    save(archive.with_suffix('.zip.receipt.json'), {
        'status': 'PASS', 'archive': str(archive), 'bytes': archive.stat().st_size,
        'sha256': sha(archive), 'payload_count': len(archive_payloads),
        'zip_crc_and_payload_sha256': 'PASS',
        'checkpoint_manifest_sha256': sha(checkpoint_manifest),
        'package_manifest_sha256': sha(package_manifest_path),
    })
    print(json.dumps({
        'status': delivery_status, 'checkpoint': str(CHECKPOINT),
        'package': str(PACKAGE), 'archive': str(archive),
        'checkpoint_files': len(checkpoint_entries), 'zip_payloads': len(archive_payloads),
        'bit_sha256': EXPECTED_BIT,
    }, ensure_ascii=False, indent=2))


parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group(required=True)
mode.add_argument('--prepare', action='store_true')
mode.add_argument('--finalize', action='store_true')
parser.add_argument('--binding', type=Path)
parser.add_argument('--pin-run', type=Path)
parser.add_argument('--physical-result', type=Path)
parser.add_argument('--extra-result', type=Path, action='append',
                    help='optional JSON result to archive under verification/optional_results')
args = parser.parse_args()

if args.prepare:
    freeze_sources()
else:
    finalize(args)
