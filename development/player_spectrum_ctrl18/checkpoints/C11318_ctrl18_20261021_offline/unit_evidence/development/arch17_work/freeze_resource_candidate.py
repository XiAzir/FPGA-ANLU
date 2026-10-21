"""Freeze selected source, reports, and offline bit with their actual hashes."""
from pathlib import Path
from datetime import datetime
import hashlib
import json
import shutil
import argparse

ROOT=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
CANDIDATE = ROOT / 'development/player_spectrum_arch17'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--system',type=Path,required=True)
    parser.add_argument('--baseline',type=Path,required=True)
    args=parser.parse_args()
    assert json.loads((args.system/'summary.json').read_text())['status']=='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'
    latest = {}
    for stage in ('synthesis', 'physical', 'bitstream'):
        evidence = CANDIDATE / 'build/manual/stage_evidence'
        pointer = json.loads((evidence / f'latest_{stage}.json').read_text(encoding='utf-8-sig'))
        assert pointer['status'] == 'success', pointer
        latest[stage] = json.loads((evidence / pointer['record']).read_text(encoding='utf-8-sig'))
    assert latest['physical']['synthesisRunId']==latest['synthesis']['runId']==latest['bitstream']['synthesisRunId']
    assert len({r['scopeHash'] for r in latest.values()})==1 and len({r['scriptHash'] for r in latest.values()})==1
    assert latest['synthesis']['gateDbHash']==latest['physical']['gateDbHash']==latest['bitstream']['gateDbHash']==sha(CANDIDATE/'build/manual/AC201_tf_hdmi_gate.db')
    route_stage=latest['bitstream']['routeStage'];assert route_stage in ('physical','hold')
    route_pointer=json.loads((evidence/('latest_'+route_stage+'.json')).read_text(encoding='utf-8-sig'))
    route_record=json.loads((evidence/route_pointer['record']).read_text(encoding='utf-8-sig'))
    assert route_pointer['status']=='success' and route_record['synthesisRunId']==latest['synthesis']['runId']
    for name,digest in route_record['artifacts'].items():assert sha(CANDIDATE/'build/manual'/name)==digest,name
    assert latest['bitstream']['bitHash']==sha(CANDIDATE/'build/manual/AC201_player_spectrum_arch17.bit')
    target = CANDIDATE / 'checkpoints/C11317_arch17_20261021_offline'
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
        'build/manual/AC201_player_spectrum_arch17.bit',
        'build/manual/AC201_tf_hdmi_gate.area', 'build/manual/AC201_tf_hdmi_phy.area',
        'build/manual/AC201_tf_hdmi_gate.v', 'build/audit/routed_implementation.v',
        'build/manual/AC201_tf_hdmi_phy.ts', 'build/manual/AC201_tf_hdmi_pr.timing',
        'build/manual/synthesis_console.log', 'build/manual/physical_console.log',
        'build/manual/bitstream_console.log', 'build/manual/build_source_scope.json',
        'build/ablation_summary.json', 'build/preservation.json', 'build/strategy.json',
        'build/selected_changes.json','build/source_delta.patch',
        'build/unit_evidence.json',
        'build/baseline/receipt.json','build/baseline/C11316_source_sha256.json',
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
        'build/gate_verify/input_manifest.json', 'build/audit/gate_rom_control.json',
        'build/audit/gate_rom_init.json',
        'build/manual/strategy_actual.rtl.log','build/manual/strategy_actual.gate.log',
    ]
    selected += [str(p.relative_to(CANDIDATE)) for p in
                 (CANDIDATE / 'build/manual/stage_evidence').glob('*.json')]
    for folder in ('build/audit','build/gate_verify'):
        selected += [str(p.relative_to(CANDIDATE)) for p in (CANDIDATE/folder).iterdir()
                     if p.is_file() and p.suffix.lower() in ('.py','.ps1','.tcl','.json','.md','.v','.log','.do','.ini')]
    selected=list(dict.fromkeys(selected))
    for relative in selected:
        source = CANDIDATE / relative
        destination = target / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
    unit_manifest=json.loads((CANDIDATE/'build/unit_evidence.json').read_text(encoding='utf-8-sig'))
    assert unit_manifest['status']=='PASS'
    for entry in unit_manifest['files']:
        source=Path(entry['path']);assert sha(source)==entry['sha256'],source
        destination=target/'unit_evidence'/entry['relative_to_repository']
        destination.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,destination)
    for case,folder in ((args.system,'system_selected'),(args.baseline,'system_baseline_C11316')):
        assert json.loads((case/'summary.json').read_text(encoding='utf-8-sig'))['status']=='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'
        system_target=target/'build'/folder
        system_target.mkdir()
        for source in sorted(case.iterdir()):
            if source.is_file() and (source.suffix in ('.json','.log','.v','.vh','.do','.f','.ini','.csv') or source.name=='spectrum_oracle.py'):
                shutil.copy2(source,system_target/source.name)
    # Preserve reproduction/binding entry points alongside the chosen implementation.
    helpers=target/'verification_helpers'
    helpers.mkdir()
    for source in Path(__file__).parent.iterdir():
        if source.is_file() and source.suffix in ('.py','.vh','.md'):
            shutil.copy2(source,helpers/source.name)
    shutil.copy2(CANDIDATE / 'src/td_project/route.qor', target / 'route.qor')
    manifest = {
        'schema': 'C11317-resource-optimization-offline-v1',
        'created_local': datetime.now().astimezone().isoformat(),
        'conclusion': 'RESOURCE_OPTIMIZED_OFFLINE',
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
