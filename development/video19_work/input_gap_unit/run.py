from pathlib import Path
import hashlib, json, subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
BIN = ROOT / 'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
original = HERE.parent / 'vendor/core_jpeg/src_v/jpeg_input.v'
fixed = ROOT / 'development/player_video19/src/user_source/hdl_source/jpeg/jpeg_input.v'
results = []
for name, path in [('original', original), ('fixed', fixed)]:
    copied = HERE / (name + '.v')
    copied.write_bytes(path.read_bytes())
    exe = HERE / (name + '.vvp')
    compile = subprocess.run([str(BIN/'iverilog.exe'), '-g2012', '-s', 'tb_input_gap',
                              '-o', str(exe), str(HERE/'tb_input_gap.sv'), str(copied)], capture_output=True)
    assert compile.returncode == 0, compile.stderr
    run = subprocess.run([str(BIN/'vvp.exe'), str(exe)], capture_output=True)
    log = run.stdout.decode() + run.stderr.decode()
    (HERE / (name + '.log')).write_text(log)
    results.append(dict(name=name, source=str(path), sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                        exit_code=run.returncode, output=log))
assert results[0]['exit_code'] != 0 and 'false JPEG EOI' in results[0]['output']
assert results[1]['exit_code'] == 0 and 'JPEG_INPUT_GAP_PASS' in results[1]['output']
(HERE/'result.json').write_text(json.dumps(dict(status='PASS', cases=results), indent=2))
print('JPEG_INPUT_GAP_ABLATION_PASS original_false_EOI_reproduced=1 fixed_PASS=1')
