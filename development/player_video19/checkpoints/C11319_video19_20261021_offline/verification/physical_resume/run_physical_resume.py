"""Replay the exact C03 frozen physical-controller system using the existing runner contract."""
from pathlib import Path
from datetime import datetime
import argparse, hashlib, json, shutil, struct, sys
HERE=Path(__file__).resolve().parent
WORK=HERE.parent
ROOT=HERE.parents[2]
PLAYER=ROOT/'development/player_video19'
BASE=ROOT/'development/system_verification_20261016'
OLD=PLAYER/'build/video_system_20261021_193504'
sys.path.insert(0,str(BASE/'integration'))
from common import BIN,EG4,HDMI,sha,compile_sources,execute
p=argparse.ArgumentParser()
p.add_argument('--card',type=Path,required=True)
p.add_argument('--frames',type=int,default=2)
p.add_argument('--physical-memory',action='store_true')
p.add_argument('--optimize',action='store_true')
a=p.parse_args()
out=HERE/'runs'/('video_system_'+datetime.now().strftime('%Y%m%d_%H%M%S'))
out.mkdir(parents=True)
print(out,flush=True)
shutil.copytree(OLD/'frozen',out/'frozen')
shutil.copy2(WORK/'tb_video_system.v',out/'tb_video_system.v')
shutil.copy2(OLD/'source_receipt.json',out/'prior_source_receipt.json')
# Rebase only paths from the exact preexisting C03 run into this isolated directory.
sources=[]
oldlist=[Path(x.strip().strip('"')) for x in (OLD/'sources.f').read_text().splitlines()]
for src in oldlist:
    try:
        rel=src.relative_to(OLD)
    except ValueError:
        raise RuntimeError(f'Unexpected source outside frozen run: {src}')
    if rel.as_posix()=='tb_video_system.v':
        continue
    dst=out/rel
    if not dst.exists(): shutil.copy2(src,dst)
    if sha(src)!=sha(dst): raise RuntimeError(f'Frozen source copy hash mismatch: {rel}')
    sources.append(dst)
# Bind the key model sources to the expected independent receipts.
gate_info=json.loads((BASE/'memory/controller_gate_latest.json').read_text())
gate=Path(gate_info['directory'])/'build/controller_gate.v'
assert sha(gate).upper()==gate_info['gate_sha256'].upper()
assert sha(out/'controller_gate.v').upper()==gate_info['gate_sha256'].upper()
prior=json.loads((out/'prior_source_receipt.json').read_text())
prior_by_copy={Path(x['copy']).name:x['sha256'].upper() for x in prior['inputs']}
for name in ['controller_gate.v','sdram_issi_reference_wrapper.v','IS42s32200.v','global_def.v','pll_clock_replay.v','sd_spi_card_model.v']:
    assert sha(out/name).upper()==prior_by_copy[name],name
(out/'modelsim.ini').write_text('[Library]\nwork = work\neg4 = '+EG4.as_posix()+'\nhdmi = '+HDMI.as_posix()+'\nothers = E:/ModelsimSE/modelsim.ini\n')
tb=out/'tb_video_system.v'
flags=['+incdir+'+'+'.join(x.as_posix() for x in [out,out/'frozen/src/user_source/hdl_source',out/'frozen/src/user_source/hdl_source/include',out/'frozen/src/user_source/hdl_source/SD',out/'frozen/src/td_project'])]
comp=compile_sources(out,sources,flags,tb)
card=a.card.resolve()
metadata=json.loads((card/'summary.json').read_text(encoding='utf-8-sig'))
for name in ['packed_mem.mem','lba_map.mem']: shutil.copy2(card/name,out/name)
media=WORK/'stream_frontend/output'
wav=(media/'TEST.WAV').read_bytes(); index=json.loads((media/'index.json').read_text())
(out/'jpeg_crc.mem').write_text('\n'.join(x['jpeg_crc32'] for x in index['frames'])+'\n')
pcm=wav[index['audio']['data_offset']:][:index['audio']['data_bytes']]
(out/'pcm.mem').write_text('\n'.join(f'{v[0]:04x}' for v in struct.iter_unpack('<H',pcm))+'\n')
(out/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
(out/'replay_binding.json').write_text(json.dumps({'old_run':str(OLD),'prior_status':'incomplete at 190ms after paused turn; original logs retained','frames':a.frames,'physical_memory':a.physical_memory,'gate_path':str(gate),'gate_sha256':sha(gate),'card_summary':str(card/'summary.json'),'packed_mem_sha256':sha(out/'packed_mem.mem'),'lba_map_sha256':sha(out/'lba_map.mem'),'frozen_sources':len(sources),'source_list':str(OLD/'sources.f')},indent=2))
cmd=[BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-lic_noqueue',*([] if a.optimize else ['-novopt']),'-suppress','3017,3722','-L','work','-L','eg4','-L','hdmi','-g/tb_video_system/MAPPED_SECTORS='+str(metadata['mapped_sectors']),'-g/tb_video_system/IMAGE_BYTES='+str(metadata['image_bytes']),'-g/tb_video_system/CHECK_FRAMES='+str(a.frames),'work.tb_video_system','work.glbl','-do','run.do','-l','run.log']
r=execute(cmd,out,'console.log',2400)
log=(out/'console.log').read_text(errors='replace')
startup=[];runtime=[]
import re
lines=log.splitlines()
for i,line in enumerate(lines):
    if not re.search(r'\*\* (?:Error|Fatal)|ERROR:',line): continue
    m=re.search(r'at time\s+([\d.]+) ns',line)
    if m: ns=float(m[1])
    else:
        m=re.search(r'Time:\s+([\d.]+)\s+(ps|ns)','\n'.join(lines[i:i+4]))
        ns=float(m[1])*(.001 if m[2]=='ps' else 1) if m else None
    (startup if a.physical_memory and ns is not None and ns<1000 else runtime).append({'time_ns':ns,'message':line})
passed=r['exit_code']==0 and 'VIDEO_SYSTEM_PASS' in log and not runtime
summary={'status':'PASS' if passed else 'FAILED','compile':comp,'simulation':r,'assumptions':['Qualified nominal PLL edge replay','SHA-bound SDRAM controller gate + APUG011 pin memory model; no SDF','Source-selection event injected before media starts'],'hardware':'Pending board test','card_metadata':metadata,'startup_model_errors_before_1us':startup,'runtime_model_errors':runtime}
if startup: summary['status']='PASS_AFTER_STARTUP_TRANSIENT' if passed else 'FAILED'; summary['assumptions'].append('Retained raw SDRAM startup diagnostics before 1us')
(out/'summary.json').write_text(json.dumps(summary,indent=2))
print(log[-5000:],flush=True)
raise SystemExit(0 if passed else 2)

