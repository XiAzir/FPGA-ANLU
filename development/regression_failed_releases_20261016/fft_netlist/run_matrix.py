"""Re-run unchanged archived FFT gate/routed primitives against one common TB.

No synthesis, no bitstream generation, no writes into a release checkpoint.
ModelSim simulates corresponding archived netlists, not raw .bit bytes.
"""
from pathlib import Path
import hashlib
import json
import os
import subprocess
import shutil
import sys
import time
from datetime import datetime, timezone, timedelta
import argparse

BASE = Path(__file__).resolve().parent
OUT = BASE/'attempt_2_guarded'
ROOT = BASE.parents[2]
BIN = Path('E:/ModelsimSE/win64')
LIB = ROOT/'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work'
PROJECTS = [
    'player_spectrum', 'player_spectrum_baseline_phy',
    'player_spectrum_private_init', 'player_spectrum_observed',
    'player_spectrum_tf_margin', 'player_spectrum_clock_route',
    'player_spectrum_fft_recover',
]
TZ = timezone(timedelta(hours=8))

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()

def execute(command, cwd, log, timeout=240):
    before = time.monotonic()
    with (cwd/log).open('w', encoding='utf-8') as handle:
        try:
            result = subprocess.run([str(x) for x in command], cwd=cwd,
                stdout=handle, stderr=subprocess.STDOUT, timeout=timeout)
            return dict(command=[str(x) for x in command], returncode=result.returncode,
                        seconds=round(time.monotonic()-before, 3), log=str(cwd/log))
        except subprocess.TimeoutExpired:
            return dict(command=[str(x) for x in command], returncode=None,
                        seconds=round(time.monotonic()-before, 3), log=str(cwd/log), timeout=True)

def verify_file(cp, relative, entries):
    file = cp/relative
    actual = sha(file)
    expected = next(x['sha256'].upper() for x in entries if x['path']==relative)
    if actual != expected:
        raise RuntimeError('Archived manifest mismatch: '+str(file))
    return dict(path=str(file), sha256=actual, manifest_match=True)

if __name__ == '__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('--output-tag',default=None)
    parser.add_argument('--only',default='',help='Comma-separated C113xx:gate/routed cases')
    args=parser.parse_args()
    if args.output_tag is None:
        args.output_tag='run_'+datetime.now(TZ).strftime('%Y%m%d_%H%M%S')
    if not args.output_tag.replace('_','').isalnum(): raise SystemExit('Unsafe output tag')
    OUT=BASE/args.output_tag
    if (OUT/'summary.json').exists(): raise SystemExit('Refuse to overwrite existing regression evidence')
    only=set(args.only.split(',')) if args.only else set()
    if not os.environ.get('MGLS_LICENSE_FILE'):
        raise SystemExit('Initialize the existing user license environment before launch')
    OUT.mkdir(parents=True,exist_ok=True)
    summary = dict(started=datetime.now(TZ).isoformat(), scope='Functional FFT cones only; controlled 25MHz/global reset and accelerated PCM. No SDF, full startup, media controller or HDMI PHY.',
        tb=dict(path=str(BASE/'tb_fft_cone.v'),sha256=sha(BASE/'tb_fft_cone.v')),
        extractor_sha256=sha(BASE/'extract_fft.py'), original_extractor_sha256=sha(BASE/'extract_fft_original_1015.py'), results=[])
    for number, name in enumerate(PROJECTS,4):
        version = f'C113{number:02d}'
        cp = next((ROOT/'development'/name/'checkpoints').glob('*candidate'))
        entries = json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))
        bits = [e for e in entries if e['path'].endswith('.bit') and e['path'].startswith('build/manual/')]
        bit = verify_file(cp, bits[0]['path'], entries)
        for stage, relative in [('gate','build/manual/AC201_tf_hdmi_gate.v'),('routed','build/audit/routed_implementation.v')]:
            if only and version+':'+stage not in only: continue
            cwd = OUT/version/stage
            cwd.mkdir(parents=True, exist_ok=True)
            result = dict(version=version, stage=stage, checkpoint=str(cp), manifest_sha256=sha(cp/'manifest.json'), bit=bit, commands=[])
            summary['results'].append(result)
            if not (cp/relative).exists():
                result['status']='NOT_AVAILABLE_ARCHIVED_NETLIST'
                print(version,stage,result['status'],flush=True)
                continue
            print('START',version,stage,flush=True)
            try:
                result['netlist']=verify_file(cp,relative,entries)
                for fname in ['all_samples.mem','all_expected.mem']:
                    result[fname]=verify_file(cp,'sim/vectors/'+fname,entries)
                command=[sys.executable,BASE/'extract_fft.py','--source',cp/relative,'--out',cwd]
                if stage=='routed': command+=['--routed']
                call=execute(command,cwd,'extract.log',120)
                result['commands'].append(call)
                if call['returncode']!=0: raise RuntimeError('EXTRACTION_FAILED')
                cone=json.loads((cwd/'cone_manifest.json').read_text())
                if cone['unresolved']: raise RuntimeError('UNRESOLVED_DEPENDENCIES')
                result['cone']=dict(included=cone['included'],primitive_counts=cone['primitive_counts'],unresolved=cone['unresolved'],sha256=sha(cwd/'fft_cone.v'))
                (cwd/'modelsim.ini').write_text('[Library]\nwork = work\neg4 = '+LIB.as_posix()+'\nothers = E:/ModelsimSE/modelsim.ini\n')
                if not (cwd/'work').exists():
                    call=execute([BIN/'vlib.exe','work'],cwd,'vlib.log')
                    result['commands'].append(call)
                    if call['returncode']!=0: raise RuntimeError('VLIB_FAILED')
                call=execute([BIN/'vlog.exe','-modelsimini','modelsim.ini','-work','work','fft_cone.v',BASE/'tb_fft_cone.v'],cwd,'compile.log')
                result['commands'].append(call)
                if call['returncode']!=0: raise RuntimeError('COMPILE_FAILED')
                (cwd/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
                vec=cp/'sim/vectors'
                for filename in ['all_samples.mem','all_expected.mem']:
                    shutil.copyfile(vec/filename,cwd/filename)
                    if sha(vec/filename)!=sha(cwd/filename): raise RuntimeError('VECTOR_COPY_MISMATCH')
                command=[BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-lic_noqueue','-novopt','-suppress','3017,3722','-L','work','-L','eg4','work.tb_fft_cone','eg4.glbl',
                         '+VEC=all_samples.mem','+EXP=all_expected.mem','-do','run.do','-l','run.log']
                call=execute(command,cwd,'console.log',240)
                result['commands'].append(call)
                console=(cwd/'console.log').read_text(errors='replace')
                result['model_loads_checked']=all(x in console.lower() for x in ['loading work.tb_fft_cone','loading work.fft_cone','eg_phy_bram','eg4.glbl'])
                result['markers']=[line for line in console.splitlines() if any(x in line for x in ['BOUNDARY','CASE_RESULT','PASS fft_cone','FAIL'])]
                result['input_guard_passed']='INPUT_VALID samples=13312 expected=312 unknown_words=0' in console
                result['status']='PASS' if call['returncode']==0 and result['model_loads_checked'] and result['input_guard_passed'] and 'PASS fft_cone cases=3 bands=72' in console and '# FAIL' not in console and '** Error:' not in console else 'SIMULATION_FAILED_OR_INCONCLUSIVE'
                result['console_sha256']=sha(cwd/'console.log')
            except Exception as err:
                result['status']=str(err)
            (cwd/'result.json').write_text(json.dumps(result,indent=2))
            summary['updated']=datetime.now(TZ).isoformat()
            (OUT/'summary.json').write_text(json.dumps(summary,indent=2))
            print('RESULT',version,stage,result['status'],flush=True)
    summary['completed']=datetime.now(TZ).isoformat()
    (OUT/'summary.json').write_text(json.dumps(summary,indent=2))
    print('MATRIX_COMPLETE', len(summary['results']),flush=True)
