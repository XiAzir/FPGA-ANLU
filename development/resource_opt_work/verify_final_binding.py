"""Check selected source, simulation, implementation, bit and frozen manifest binding."""
from pathlib import Path
import argparse
import hashlib
import json

ROOT = Path(__file__).resolve().parents[2]
C = ROOT / 'development/player_spectrum_resource_fit'


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
    assert read(args.system/'summary.json')['status'] == 'SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS'
    manual = C / 'build/manual'
    for entry in read(manual/'build_source_scope.json'):
        assert sha(C/'src'/entry['path']) == entry['sha256'].lower(), entry['path']
    normalized = read(C/'build/gate_verify/normalized_control_proof.json')
    assert normalized['status'] == 'PASS'
    assert normalized['gate_netlist_sha256'] == sha(manual/'AC201_tf_hdmi_gate.v')
    clock = read(C/'build/audit/routed_clock_audit.json')
    assert clock['status'] == 'PASS'
    assert clock['netlist_sha256'] == sha(C/'build/audit/routed_implementation.v')
    assert read(C/'build/audit/routed_rom_init.json')['all_match']
    assert read(C/'build/preservation.json')['status'] == 'PASS'
    bits = [manual/'AC201_player_spectrum_resource_fit.bit',ROOT/'download/spectrum_resource_fit.bit']
    checkpoint = C/'checkpoints/C11313_resource_fit_20261020_offline'
    bits.append(checkpoint/'build/manual/AC201_player_spectrum_resource_fit.bit')
    assert len({sha(p) for p in bits}) == 1
    manifest = read(checkpoint/'manifest.json')
    for entry in manifest['files']:
        file = checkpoint/entry['path']
        assert file.stat().st_size == entry['bytes'] and sha(file) == entry['sha256'], entry['path']
    result = {'status':'PASS', 'hardware_status':'BOARD_NOT_TESTED',
              'simulation':str(args.system), 'selected_overrides':len(changes),
              'scope_files':len(read(manual/'build_source_scope.json')),
              'checkpoint_files':len(manifest['files']), 'bit_sha256':sha(bits[0]),
              'manifest_sha256':sha(checkpoint/'manifest.json')}
    (C/'build/final_binding.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result,ensure_ascii=False))


if __name__ == '__main__':
    main()
