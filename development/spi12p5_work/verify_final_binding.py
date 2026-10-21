"""Check selected source, simulation, implementation, bit and frozen manifest binding."""
from pathlib import Path
import argparse
import hashlib
import json
import re

ROOT=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
C = ROOT / 'development/player_spectrum_spi12p5'


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def read(p):
    return json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--system', type=Path, required=True)
    args = parser.parse_args()
    changes = read(args.system / 'source_receipt.json')['candidate_overrides']
    for entry in changes:
        assert sha(Path(entry['path'])) == entry['sha256'].lower(), entry['path']
    system_summary=read(args.system/'summary.json')
    assert system_summary['status'] == 'SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'
    assert system_summary['testbench_sha256'].lower()==sha(args.system/'tb_system.v')
    for entry in read(args.system/'fixture_receipt.json'):
        assert sha(Path(entry['path']))==entry['sha256'].lower(),entry['path']
    assert len(changes)==11
    performance=read(args.system/'spi_performance.json')
    assert performance['min_sclk_period_ns']==80
    assert performance['status']=='PASS' and performance['crc_bad']==0 and performance['underruns']==0
    ablation=read(C/'build/ablation_summary.json')
    assert ablation['variants']['fast_C11315']['performance_sha256']==sha(args.system/'spi_performance.json')
    assert 'MAPPER_CONTRACT_PASS' in (args.system/'console.log').read_text(errors='replace')
    manual = C / 'build/manual'
    pointers={stage:read(manual/'stage_evidence'/('latest_'+stage+'.json'))
              for stage in ('synthesis','physical','bitstream')}
    assert all(p['status']=='success' for p in pointers.values())
    records={stage:read(manual/'stage_evidence'/p['record']) for stage,p in pointers.items()}
    assert records['physical']['synthesisRunId']==pointers['synthesis']['runId']
    slices=int(re.search(r'#slices\s*\|\s*(\d+)',(C/'src/td_project/route.qor').read_text())[1])
    assert slices<=7839,slices
    timing=(manual/'AC201_tf_hdmi_phy.ts').read_text()
    margins=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',timing)
    assert margins and all(float(x)>=0 for x in margins.groups()),timing
    for entry in read(manual/'build_source_scope.json'):
        assert sha(C/'src'/entry['path']) == entry['sha256'].lower(), entry['path']
    normalized = read(C/'build/gate_verify/normalized_control_proof.json')
    assert normalized['status'] == 'PASS'
    assert normalized['synthesis_run_id']==pointers['synthesis']['runId']
    assert normalized['gate_netlist_sha256'] == sha(manual/'AC201_tf_hdmi_gate.v')
    dynamic=normalized['dynamic_gate_regression']
    assert dynamic['status']=='PASS'
    assert dynamic['manifest_sha256']==sha(C/'build/gate_verify/input_manifest.json')
    assert dynamic['log_sha256']==sha(Path(dynamic['log']))
    clock = read(C/'build/audit/routed_clock_audit.json')
    assert clock['status'] == 'PASS'
    assert clock['netlist_sha256'] == sha(C/'build/audit/routed_implementation.v')
    assert read(C/'build/audit/routed_rom_init.json')['all_match']
    routed_control=read(C/'build/audit/routed_rom_control_proof.json')
    assert routed_control['status']=='PASS'
    assert routed_control['netlists']['routed']['netlist_sha256']==sha(C/'build/audit/routed_implementation.v')
    assert routed_control['synthesis_run_id']==pointers['synthesis']['runId']
    assert routed_control['physical_run_id']==pointers['physical']['runId']
    assert read(C/'build/preservation.json')['status'] == 'PASS'
    bits = [manual/'AC201_player_spectrum_spi12p5.bit',ROOT/'download/spectrum_spi12p5.bit']
    checkpoint = C/'checkpoints/C11315_spi12p5_20261021_offline'
    bits.append(checkpoint/'build/manual/AC201_player_spectrum_spi12p5.bit')
    assert len({sha(p) for p in bits}) == 1
    manifest = read(checkpoint/'manifest.json')
    for entry in manifest['files']:
        file = checkpoint/entry['path']
        assert file.stat().st_size == entry['bytes'] and sha(file) == entry['sha256'], entry['path']
    result = {'status':'PASS', 'hardware_status':'BOARD_NOT_TESTED',
              'simulation':str(args.system), 'selected_overrides':len(changes),
              'scope_files':len(read(manual/'build_source_scope.json')),
              'checkpoint_files':len(manifest['files']), 'bit_sha256':sha(bits[0]),
              'manifest_sha256':sha(checkpoint/'manifest.json'),
              'slices':slices,'slice_percent':100*slices/9800,'timing':timing.strip(),
              'stage_run_ids':{k:v['runId'] for k,v in pointers.items()}}
    (C/'build/final_binding.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result,ensure_ascii=False))


if __name__ == '__main__':
    main()
