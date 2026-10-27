"""Sequential clock-model and refresh-period checks, with negative controls."""
import datetime
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]
WORK = Path(__file__).resolve().parent
OUT = WORK / ('units_' + datetime.datetime.now().strftime('%Y%m%d_%H%M%S'))
OUT.mkdir()
MS = Path('E:/ModelsimSE/win64')
IV = ROOT / 'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
VENDOR = Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4')
BASE = ROOT / 'development/player_video41_refresh/src/user_source/hdl_source'
CAND = ROOT / 'development/player_video42_sdram100/src/user_source/hdl_source'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
records = []
parser=argparse.ArgumentParser()
parser.add_argument('--phase-ns',type=int,default=9)
parser.add_argument('--pll-only',action='store_true')
opts=parser.parse_args()

def run(cmd, cwd, log, timeout=60, allow_failure=False):
    proc = subprocess.run([x.as_posix() if isinstance(x, Path) else str(x) for x in cmd],
                          cwd=cwd, capture_output=True, text=True, timeout=timeout)
    text = proc.stdout + proc.stderr
    log.write_text(text, encoding='utf-8')
    if not allow_failure:
        assert proc.returncode == 0, (cmd[0], proc.returncode, str(log))
    return proc, text

for name, source, period, phase, negative in [
    ('C41_PLL', BASE,20,8,False), ('C42_PLL',CAND,10,opts.phase_ns,False),
    ('negative_unchanged_PLL',BASE,10,opts.phase_ns,True)
]:
    case = OUT/name
    case.mkdir()
    ini = case/'modelsim.ini'
    ini.write_text('[Library]\nwork = '+(case/'work').as_posix()+'\nothers = E:/ModelsimSE/modelsim.ini\n',encoding='ascii')
    run([MS/'vlib.exe',case/'work'],case,case/'vlib.log')
    run([MS/'vlog.exe','-modelsimini',ini,'-work','work','-timescale','1ns/1ps',
         VENDOR/'eg_phy_pll.v',VENDOR/'eg_phy_glbl.v'],case,case/'model.log')
    run([MS/'vlog.exe','-modelsimini',ini,'-work','work','-timescale','1ps/1ps',
         VENDOR/'eg_logic_clk.v'],case,case/'clock_model.log')
    run([MS/'vlog.exe','-modelsimini',ini,'-work','work','-timescale','1ns/1ps',
         source/'IP/sys_pll.v'],case,case/'compile_pll.log')
    run([MS/'vlog.exe','-sv','-modelsimini',ini,'-work','work','-timescale','1ns/1ps',
         WORK/'tb_sys_pll.sv'],case,case/'compile.log')
    proc,text=run([MS/'vsim.exe','-c','-modelsimini',ini,'-novopt','work.tb_sys_pll','work.glbl',
                  f'-gMEM_PERIOD_NS={period}',f'-gMEM_SHIFT_NS={phase}',
                  '-do','onerror {quit -code 2 -f}; onbreak {quit -code 3 -f}; run -all; quit -code 0 -f'],
                 case,case/'run.log',allow_failure=negative)
    passed = ('PLL_CLOCK_PASS' in text and proc.returncode==0) if not negative else ('PLL high width' in text or 'PLL phase actual=' in text)
    assert passed, (name,str(case/'run.log'))
    records.append({'case':name,'status':'NEGATIVE_DETECTED' if negative else 'PASS',
                    'source_sha256':sha(source/'IP/sys_pll.v'),'log':str(case/'run.log')})

if opts.pll_only:
    summary={'status':'PASS','scope':'Official PLL functional model, 200ns test reset; no SDF/board measurement',
             'records':records,'runner_sha256':sha(Path(__file__)), 'pll_bench_sha256':sha(WORK/'tb_sys_pll.sv')}
    (OUT/'summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps(summary,ensure_ascii=False,indent=2))
    raise SystemExit(0)

bench=(ROOT/'development/video41_work/tb_refresh_period.v').read_text(encoding='utf-8-sig')
bench=bench.replace('parameter integer EXPECT_PERIOD = 781;',
                    'parameter integer EXPECT_PERIOD = 781;\n    parameter integer CLOCK_NS=20;')
bench=bench.replace('always #10 clk','always #(CLOCK_NS/2.0) clk')
bench=bench.replace('3500000','7000000').replace('(last_pulse-first_pulse)*20','(last_pulse-first_pulse)*CLOCK_NS')
for name, source, period, clock, negative in [
    ('C41_refresh',BASE,781,20,False), ('C42_refresh',CAND,1562,10,False),
    ('negative_old_period_macro',BASE,1562,10,True)
]:
    case=OUT/name
    case.mkdir()
    prefix=(source/'include/sdr_init_ref.enc.v').read_text(encoding='utf-8-sig').split('`pragma protect begin_protected')[0]
    prefix=prefix.replace('../user_source/hdl_source/include/global_def.v','global_def.v')+'\nendmodule\n'
    (case/'prefix.v').write_text(prefix,encoding='utf-8')
    (case/'global_def.v').write_bytes((source/'include/global_def.v').read_bytes())
    (case/'bench.v').write_text(bench,encoding='utf-8')
    run([IV/'iverilog.exe','-g2012','-s','tb_refresh_period',f'-Ptb_refresh_period.EXPECT_PERIOD={period}',
         f'-Ptb_refresh_period.CLOCK_NS={clock}','-Ptb_refresh_period.NATURAL_INIT=1',
         '-I',case,'-o',case/'test.vvp',case/'bench.v',case/'prefix.v'],case,case/'compile.log')
    proc,text=run([IV/'vvp.exe',case/'test.vvp'],case,case/'run.log',allow_failure=negative)
    passed=('REFRESH_SPEC_PASS' in text and proc.returncode==0) if not negative else ('request gap' in text and proc.returncode!=0)
    assert passed,(name,str(case/'run.log'))
    records.append({'case':name,'status':'NEGATIVE_DETECTED' if negative else 'PASS',
                    'macro_sha256':sha(source/'include/global_def.v'),'log':str(case/'run.log'), 'stdout':text})

summary={'status':'PASS','scope':'Official PLL functional model with 200ns test reset; public refresh prefix with natural startup; no SDF/board evidence',
         'records':records,'runner_sha256':sha(Path(__file__)), 'pll_bench_sha256':sha(WORK/'tb_sys_pll.sv')}
(OUT/'summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(summary,ensure_ascii=False,indent=2))
