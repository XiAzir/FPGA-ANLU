"""Freeze selected source, reports, and offline bit with their actual hashes."""
from pathlib import Path
from datetime import datetime
import hashlib
import json
import shutil

ROOT = Path(__file__).resolve().parents[2]
CANDIDATE = ROOT / 'development/player_spectrum_resource_fit'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    latest = {}
    for stage in ('synthesis', 'physical', 'bitstream'):
        evidence = CANDIDATE / 'build/manual/stage_evidence'
        pointer = json.loads((evidence / f'latest_{stage}.json').read_text(encoding='utf-8-sig'))
        assert pointer['status'] == 'success', pointer
        latest[stage] = json.loads((evidence / pointer['record']).read_text(encoding='utf-8-sig'))
    target = CANDIDATE / 'checkpoints/C11313_resource_fit_20261020_offline'
    target.mkdir(parents=True, exist_ok=False)
    # Source and build instructions; generated databases and compiler caches stay in build/.
    for folder in ('src', 'scripts', 'sim'):
        for file in (CANDIDATE / folder).rglob('*'):
            if not file.is_file() or file.suffix.lower() in ('.db', '.vvp', '.pyc', '.dmp'):
                continue
            if any(part in ('__pycache__', 'work', 'modelsim_work') for part in file.parts):
                continue
            destination = target / file.relative_to(CANDIDATE)
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(file, destination)
    selected = [
        'build/manual/AC201_player_spectrum_resource_fit.bit',
        'build/manual/AC201_tf_hdmi_gate.area', 'build/manual/AC201_tf_hdmi_phy.area',
        'build/manual/AC201_tf_hdmi_gate.v', 'build/audit/routed_implementation.v',
        'build/manual/AC201_tf_hdmi_phy.ts', 'build/manual/AC201_tf_hdmi_pr.timing',
        'build/manual/synthesis_console.log', 'build/manual/physical_console.log',
        'build/manual/bitstream_console.log', 'build/manual/build_source_scope.json',
        'build/ablation_summary.json', 'build/preservation.json', 'build/area_strategy.json',
        'build/audit/routed_clock_audit.json', 'build/audit/routed_rom_init.json',
        'build/audit/routed_rom_control_proof.json',
        'build/audit/audit_clock_route.py', 'build/audit/audit_rom_controls.py',
        'build/audit/export_routed_rom.tcl',
        'build/gate_verify/normalized_control_proof.json', 'build/gate_verify/run.log',
        'build/gate_verify/run_fft_gate_verify.ps1',
        'build/gate_verify/prove_current_gate_rom_polarity.ps1',
        'build/gate_verify/build_normalized_control_proof.py',
        'build/gate_verify/audit_current_gate_rom_init.py',
        'build/gate_verify/adapt_current_normalized_control_proof.py',
        'build/gate_verify/input_manifest.json', 'build/regression/gate_rom_controls.json',
        'build/regression/gate_rom_init.json',
    ]
    selected += [str(p.relative_to(CANDIDATE)) for p in
                 (CANDIDATE / 'build/manual/stage_evidence').glob('*.json')]
    for relative in selected:
        source = CANDIDATE / relative
        destination = target / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
    shutil.copy2(CANDIDATE / 'src/td_project/route.qor', target / 'route.qor')
    manifest = {
        'schema': 'C11313-resource-fit-offline-v1',
        'created_local': datetime.now().astimezone().isoformat(),
        'conclusion': 'AREA_REDUCED_FUNCTIONALLY_CHECKED',
        'hardware_status': 'BOARD_NOT_TESTED',
        'stage_records': latest,
        'files': [{'path': str(p.relative_to(target)), 'bytes': p.stat().st_size, 'sha256': sha(p)}
                  for p in sorted(target.rglob('*')) if p.is_file()],
    }
    (target / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(target)
    print('manifest_sha256='+sha(target / 'manifest.json'))


if __name__ == '__main__':
    main()
