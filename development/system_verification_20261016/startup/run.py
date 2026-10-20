"""Run archived startup-control logic at its original million-clock wait."""
from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json,os,subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
BIN=Path('E:/ModelsimSE/win64')
TZ=timezone(timedelta(hours=8))
RELEASES=[('C11206','player_bmp_scale','bmp_scale_20261012_verified'),
 ('C11309','player_spectrum_clock_route','music_spectrum_clock_route_20261014_candidate'),
 ('C11310','player_spectrum_fft_recover','music_spectrum_fft_recover_20261014_candidate')]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest().upper()
def run(cmd,cwd,log,timeout=120):
 with (cwd/log).open('w',encoding='utf-8') as handle:
  proc=subprocess.run([str(x) for x in cmd],cwd=cwd,stdout=handle,stderr=subprocess.STDOUT,timeout=timeout)
 return {'command':[str(x) for x in cmd],'exit_code':proc.returncode,'log':str(cwd/log)}

if not os.environ.get('MGLS_LICENSE_FILE'):raise SystemExit('Initialize existing user license environment first')
out=HERE/('run_'+datetime.now(TZ).strftime('%Y%m%d_%H%M%S'))
out.mkdir(exist_ok=False)
summary={'started_beijing':datetime.now(TZ).isoformat(),
 'scope':'Real archived reset controller only; original 1000000-clock wait. PLL lock inputs are explicit stimuli; no entire-top or electrical guarantee.',
 'tb_sha256':sha(HERE/'tb_startup_contract.v'),'results':[]}
for version,project,checkpoint in RELEASES:
 cp=ROOT/'development'/project/'checkpoints'/checkpoint
 rel='src/user_source/hdl_source/top_tf_hdmi_audio.v'
 path=cp/rel
 entries=json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))
 expected=next(x['sha256'].upper() for x in entries if x['path']==rel)
 if sha(path)!=expected:raise RuntimeError('Archived source SHA mismatch')
 source=path.read_text(encoding='utf-8-sig')
 a=source.index("reg [19:0] rst_cnt = 20'd0;")
 b=source.index('assign rst_all = rst_all_reg;',a)+len('assign rst_all = rst_all_reg;')
 block=source[a:b]
 if block.count('always @')!=1 or "20'd1_000_000" not in block:raise RuntimeError('Unexpected source contract')
 cwd=out/version;cwd.mkdir()
 header='module startup_contract(input clk,rst_n,sys_pll_lock,video_pll_lock,output rst_all,output [19:0] count);\n'
 (cwd/'startup_contract.v').write_text(header+block+'\nassign count=rst_cnt;\nendmodule\n',encoding='utf-8')
 result={'version':version,'archived_top':str(path),'archived_top_sha256':expected,'manifest_match':True,
  'exact_source_block_sha256_lf':hashlib.sha256(block.encode('utf-8')).hexdigest(),
  'derived_module_sha256':sha(cwd/'startup_contract.v'),'commands':[]}
 (cwd/'modelsim.ini').write_text('[Library]\nwork = work\nothers = E:/ModelsimSE/modelsim.ini\n')
 (cwd/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
 for command,log in [([BIN/'vlib.exe','work'],'vlib.log'),
  ([BIN/'vlog.exe','-modelsimini','modelsim.ini','startup_contract.v',HERE/'tb_startup_contract.v'],'compile.log'),
  ([BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-lic_noqueue','-novopt','work.tb_startup_contract','-do','run.do','-l','run.log'],'console.log')]:
  call=run(command,cwd,log);result['commands'].append(call)
  if call['exit_code']!=0:break
 console=(cwd/'console.log').read_text(errors='replace') if (cwd/'console.log').exists() else ''
 result['markers']=[l for l in console.splitlines() if any(x in l for x in ['BOUNDARY','RESET_RELEASE','CASE ','PASS startup_contract','Fatal','Error'])]
 result['status']='PASS' if len(result['commands'])==3 and all(x['exit_code']==0 for x in result['commands']) and 'PASS startup_contract scenarios=5 releases=3' in console and '** Error' not in console and '** Fatal' not in console else 'FAIL'
 result['console_sha256']=sha(cwd/'console.log') if (cwd/'console.log').exists() else None
 summary['results'].append(result)
 (cwd/'result.json').write_text(json.dumps(result,indent=2))
 (out/'summary.json').write_text(json.dumps(summary,indent=2))
 print(version,result['status'],flush=True)
summary['completed_beijing']=datetime.now(TZ).isoformat()
(out/'summary.json').write_text(json.dumps(summary,indent=2))
(HERE/'latest.json').write_text(json.dumps({'run':str(out),'summary':str(out/'summary.json')},indent=2))
if any(x['status']!='PASS' for x in summary['results']):raise SystemExit(2)
