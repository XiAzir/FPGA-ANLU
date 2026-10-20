from pathlib import Path
from datetime import datetime
import os,sys,json,shutil,argparse,re
from common import BASE,BIN,archived_sources,compile_sources,execute,sha
from prepare_golden import prepare
from verify_fft_trace import verify as verify_fft

p=argparse.ArgumentParser();p.add_argument('--version',choices=['C11206','C11309','C11310','C11312'],default='C11206');p.add_argument('--optimize',action='store_true');p.add_argument('--clock-model',choices=['vendor','replay'],default='vendor');p.add_argument('--max-ms',type=int,default=200);p.add_argument('--serial-scoreboard',action='store_true');a=p.parse_args()
if not os.environ.get('MGLS_LICENSE_FILE'):raise SystemExit('Initialize existing license environment')
out=BASE/'integration'/('run_'+a.version+'_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
prepare(BASE/'card',out)
sources,flags,receipt=archived_sources(a.version,out,exclude=('sdram.v','sdr_as_ram.enc.v','sdr_init_ref.enc.v','sdr_wrrd.enc.v'))
if a.version!='C11206':
 flags+=['+define+HAS_FFT']
 shutil.copy2(BASE.parents[1]/'development/player_spectrum_fft_recover/sim/spectrum_oracle.py',out/'spectrum_oracle.py')
if a.clock_model=='replay':
 replay_dir=BASE/'memory/vendor_qualification/clock_replay'
 qualification=replay_dir/'summary.json'
 if not qualification.exists():raise SystemExit('Clock replay qualification missing; refusing to use it')
 proof=json.loads(qualification.read_text(encoding='utf-8-sig'))
 if proof.get('status')!='PASS_SCOPE':raise SystemExit('Clock replay is not qualified')
 # The qualification file names and hash scheme must be checked explicitly.
 expected=proof.get('replay_sha256','').lower()
 if sha(replay_dir/'pll_clock_replay.v').lower()!=expected:raise SystemExit('Clock replay source SHA mismatch')
 bindings={'adapter':BASE/'pll/eg_phy_pll_init_adapter.v',
  'sys_wrapper':next(p for p in sources if p.name=='sys_pll.v'),
  'video_wrapper':next(p for p in sources if p.name=='video_pll.v')}
 for name,digest in proof.get('source_sha256',{}).items():
  path=bindings.get(name,replay_dir/name)
  if not path.exists() or sha(path).lower()!=digest.lower():raise SystemExit('Clock qualification input mismatch: '+str(path))
 if not all(k in proof.get('source_sha256',{}) for k in bindings):raise SystemExit('Incomplete clock qualification source binding')
 evidence_dir=out/'clock_evidence';evidence_dir.mkdir()
 for name in proof['source_sha256']:
  path=bindings.get(name,replay_dir/name)
  destination=evidence_dir/(name+'.v' if name in bindings else name)
  shutil.copy2(path,destination)
 sources=[p for p in sources if p.name not in ('sys_pll.v','video_pll.v','eg_phy_pll_init_adapter.v')]
 sources += [replay_dir/'pll_clock_replay.v',BASE/'integration/pll_replay_wrappers.v']
 shutil.copy2(qualification,out/'clock_qualification.json')
sources += [BASE/'memory/sdram_app_model.v',BASE/'card/sd_spi_card_model.v']
if a.serial_scoreboard:
 sources += [BASE/'hdmi'/name for name in ['hdmi_serial_receiver.v','hdmi_serial_packet_monitor.v','hdmi_video_period_receiver.v']]
 if not any(p.name=='hdmi_packet_monitor.v' for p in sources):
  monitor=Path(receipt['checkpoint'])/'src/user_source/hdl_source/hdmi_packet_monitor.v'
  manifest=json.loads((Path(receipt['checkpoint'])/'manifest.json').read_text(encoding='utf-8-sig'))
  digest=next(e['sha256'] for e in manifest if e['path'].lower()==monitor.relative_to(Path(receipt['checkpoint'])).as_posix().lower())
  if sha(monitor).lower()!=digest.lower():raise SystemExit('Monitor SHA mismatch')
  sources.append(monitor)
glbl=Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v');sources.insert(0,glbl)
for file in ['card.mem','wave_samples.mem','packed_mem.mem','lba_map.mem']:
 if not (BASE/'card'/file).exists():continue
 shutil.copy2(BASE/'card'/file,out/file)
# Isolate mutable fixture/model files too: ModelSim may auto-refresh from sources.
for i,path in enumerate(sources):
 if BASE in path.parents and path.parent!=out:
  target=out/path.name;shutil.copy2(path,target);sources[i]=target
tb=out/'tb_system.v';shutil.copy2(BASE/'integration/tb_system.v',tb)
if a.serial_scoreboard:
 observer=BASE/'integration/system_pin_scoreboard.vh';shutil.copy2(observer,out/observer.name)
 text=tb.read_text();text=text.replace(' integer elapsed_ms=0;',observer.read_text()+'\n integer elapsed_ms=0;')
 text=text.replace('    $display("SYSTEM_MEDIA_PASS', '    check_pin_scoreboard;\n    $display("SYSTEM_MEDIA_PASS')
 text=text.replace('BOUNDARY serial HDMI content still requires separate scoreboard','BOUNDARY serial HDMI scoreboard included; physical IO and full SDF remain unverified')
 tb.write_text(text)
fixture_paths=list(dict.fromkeys([p for p in sources if p.parent==out]+[tb]+list(out.glob('*.mem'))+list(out.glob('*receipt.json'))+list(out.glob('*qualification.json'))+([out/'spectrum_oracle.py'] if a.version!='C11206' else [])))
(out/'fixture_receipt.json').write_text(json.dumps([dict(path=str(p),sha256=sha(p)) for p in fixture_paths],indent=2))
compile_result=compile_sources(out,sources,flags,tb)
(out/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
print(out,flush=True)
mode=[] if a.optimize else ['-novopt']
call=execute([BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-lic_noqueue']+mode+['-suppress','3017,3722','-L','work','-L','eg4','-L','hdmi','work.tb_system','work.glbl','+max_ms='+str(a.max_ms),'-do','run.do','-l','run.log'],out,'console.log',1800)
log=(out/'console.log').read_text(errors='replace')
failed=re.search(r'(?im)^.*(?:\bFATAL\b|\*\*\s+Error\b|\bFAIL(?:ED)?\b)',log)
status='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS' if call['exit_code']==0 and 'SYSTEM_MEDIA_PASS' in log and not failed else 'NOT_PASSED'
fft_result=None
if status=='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS' and a.version!='C11206':
 try:fft_result=verify_fft(out)
 except Exception as error:status='FFT_SCOREBOARD_FAILED';fft_result=dict(error=str(error))
(out/'summary.json').write_text(json.dumps(dict(status=status,version=a.version,clock_model=a.clock_model,serial_scoreboard=a.serial_scoreboard,compile=compile_result,simulation=call,fft=fft_result,assumptions=['PLL initialization adapter' if a.clock_model=='vendor' else 'Qualified nominal PLL edge replay, fixed 50MHz reference/reset0 only','application-interface memory model; data leads valid by one clock','short generated BMP/WAV fixture'],unverified=['physical SDRAM']+([] if a.serial_scoreboard else ['HDMI serial content'])+['key source switching','SDF','hardware fault reproduction'],testbench_sha256=sha(tb)),indent=2))
print(status,flush=True);print(log[-5000:])
raise SystemExit(0 if status=='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS' else 2)
