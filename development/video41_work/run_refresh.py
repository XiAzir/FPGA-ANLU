"""Refresh-request ablation using the original public RTL prefix only."""
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]
WORK = Path(__file__).resolve().parent
BASE = ROOT / 'development/player_video40_spi25'
CAND = ROOT / 'development/player_video41_refresh'
BIN = ROOT / 'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
OUT = WORK / 'refresh_model_ackfinal'
OUT.mkdir(exist_ok=True)
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
prefix_path = WORK / 'sdr_init_ref_public_prefix_final.v'
prefix = prefix_path.read_text(encoding='utf-8-sig')
assert 'begin_protected' not in prefix
prefix = prefix.replace('../user_source/hdl_source/include/global_def.v','global_def.v')+'\nendmodule\n'
current = (CAND / 'src/user_source/hdl_source/include/global_def.v').read_text(encoding='utf-8-sig')
raw = (BASE / 'src/user_source/hdl_source/include/global_def.v').read_text(encoding='utf-8-sig')
half_rate = raw.replace('64000000/`SDR_CLK_PERIOD/2**(`ROW_WIDTH)',
                       '(64000000/(`SDR_CLK_PERIOD)/2**(`ROW_WIDTH))')
off_one = current.replace('/4096-1)', '/4096)')
cases = [('C40_reproduce',raw,0,0,False),
         ('C41_period',current,1,0,False),
         ('C41_natural_startup',current,1,1,False),
         ('negative_no_refresh',raw,1,0,True),
         ('negative_row_count',half_rate,1,0,True),
         ('negative_off_by_one',off_one,1,0,True)]
records = []
for tag, macros, expected, natural, negative in cases:
    case_dir = OUT / tag
    case_dir.mkdir(exist_ok=True)
    (case_dir/'global_def.v').write_text(macros,encoding='utf-8')
    (case_dir/'sdr_init_ref_public.v').write_text(prefix,encoding='utf-8')
    exe = case_dir/'test.vvp'
    compile_cmd = [str(BIN/'iverilog.exe'),'-g2012','-s','tb_refresh_period',
                   f'-Ptb_refresh_period.EXPECT_REQUESTS={expected}',
                   f'-Ptb_refresh_period.NATURAL_INIT={natural}',
                   '-o',str(exe),'-I',str(case_dir),str(WORK/'tb_refresh_period.v'),
                   str(case_dir/'sdr_init_ref_public.v')]
    comp = subprocess.run(compile_cmd,cwd=case_dir,capture_output=True,text=True)
    (case_dir/'compile.log').write_text(comp.stdout+comp.stderr,encoding='utf-8')
    assert comp.returncode == 0,tag
    run = subprocess.run([str(BIN/'vvp.exe'),str(exe)],cwd=case_dir,capture_output=True,text=True,timeout=60)
    stdout = run.stdout+run.stderr
    (case_dir/'run.log').write_text(stdout,encoding='utf-8')
    passed = (run.returncode != 0 and 'FATAL:' in stdout) if negative else (
        run.returncode == 0 and ('REFRESH_SPEC_PASS' in stdout or 'BASELINE_ZERO_REQUEST_REPRODUCED' in stdout))
    assert passed,(tag,stdout)
    records.append({'case':tag,'status':'EXPECTED_FAILURE_DETECTED' if negative else 'PASS',
                    'returncode':run.returncode,'stdout':stdout})
record = {'status':'PASS','scope':'C41 candidate public prefix; forced-init unit and natural startup; delayed ACK. Protected command encoder, device and SDF are outside this fixture.',
          'required_refresh_commands_per_64ms':4096,'period_mem_clocks':781,'terminal':780,
          'interval_ns':15620,'window_4096_intervals_ns':63979520,
          'inputs':{str(p.relative_to(ROOT)):sha(p) for p in [prefix_path,WORK/'tb_refresh_period.v',
              CAND/'src/user_source/hdl_source/include/global_def.v']},'cases':records}
(OUT/'summary.json').write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(record,ensure_ascii=False,indent=2))
