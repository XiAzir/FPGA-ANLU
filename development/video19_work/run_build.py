"""Run one TD stage and retain its complete console output."""
from pathlib import Path
from datetime import datetime
import argparse, hashlib, json, shutil, subprocess

HERE = Path(__file__).resolve().parent
PLAYER = HERE.parent / 'player_video19'
parser = argparse.ArgumentParser()
parser.add_argument('stage', choices=['syn', 'phy', 'bit'])
args = parser.parse_args()
script = PLAYER / 'scripts' / dict(syn='build_manual_syn.tcl',
                                 phy='build_manual_phy.tcl', bit='generate_bit.tcl')[args.stage]
log = PLAYER / 'build' / (args.stage + '_' + datetime.now().strftime('%Y%m%d_%H%M%S') + '.log')
inputs = []
frozen = log.with_suffix('.frozen')
for path in sorted((PLAYER / 'src').rglob('*')):
    if path.is_file() and path.suffix.lower() in ['.v', '.vh', '.adc', '.sdc', '.al', '.mem', '.tcl']:
        inputs.append(dict(path=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
        if args.stage == 'syn':
            target = frozen / path.relative_to(PLAYER)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, target)
inputs.append(dict(path=str(script), sha256=hashlib.sha256(script.read_bytes()).hexdigest()))
log.with_suffix('.inputs.json').write_text(json.dumps(inputs, indent=2), encoding='utf-8')
exe = Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe')
with log.open('wb') as stream:
    proc = subprocess.Popen([str(exe), script.as_posix()], cwd=PLAYER / 'src/td_project',
                            stdout=stream, stderr=subprocess.STDOUT)
    print(f'TD_{args.stage.upper()} PID={proc.pid} LOG={log}', flush=True)
    code = proc.wait()
print(f'TD_EXIT={code} LOG={log}', flush=True)
raise SystemExit(code)
