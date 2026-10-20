"""Prepare archived production RTL for offline integration without changing it."""
from pathlib import Path
import difflib,hashlib,json,re,subprocess,xml.etree.ElementTree as ET

BASE=Path(__file__).resolve().parents[1]
ROOT=BASE.parents[1]
BIN=Path('E:/ModelsimSE/win64')
EG4=ROOT/'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/modelsim/work'
HDMI=ROOT/'development/player_spectrum_fft_recover/build/board_feedback_no_signal_20261014/video_modelsim/work'
RELEASES={
 'C11206':('player_bmp_scale','bmp_scale_20261012_verified'),
 'C11309':('player_spectrum_clock_route','music_spectrum_clock_route_20261014_candidate'),
 'C11310':('player_spectrum_fft_recover','music_spectrum_fft_recover_20261014_candidate'),
 'C11312':('player_spectrum_trace','music_spectrum_trace_20261015_candidate'),
}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest().upper()
def execute(command,cwd,log,timeout=240):
 with (cwd/log).open('w',encoding='utf-8') as stream:
  process=subprocess.Popen([str(x) for x in command],cwd=cwd,stdout=stream,stderr=subprocess.STDOUT)
  timed_out=False
  try:code=process.wait(timeout=timeout)
  except subprocess.TimeoutExpired:
   # Kill only the simulator tree started by this call, never global vsim jobs.
   timed_out=True
   subprocess.run(['pwsh','-NoProfile','-Command',
    '[System.Diagnostics.Process]::GetProcessById('+str(process.pid)+').Kill($true)'],stdout=stream,stderr=subprocess.STDOUT)
   process.wait(timeout=20);code=124
 return dict(command=[str(x) for x in command],exit_code=code,timed_out=timed_out,log=str(cwd/log))
def archived_sources(version,cwd,exclude=()):
 project,checkpoint=RELEASES[version]
 cp=ROOT/'development'/project/'checkpoints'/checkpoint
 manifest=json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))
 entries={e['path'].lower():e['sha256'].upper() for e in manifest}
 checked=[]
 def verify(path):
  rel=path.relative_to(cp).as_posix().lower()
  if rel not in entries or sha(path)!=entries[rel]:raise ValueError('Archived input mismatch: '+str(path))
  checked.append(dict(path=str(path),sha256=entries[rel]))
 hdl=cp/'src/user_source/hdl_source';td=cp/'src/td_project'
 al=td/'AC201_tf_hdmi.al';verify(al)
 text=re.sub(r'&(?!amp;|lt;|gt;|quot;|apos;)','&amp;',al.read_text(encoding='utf-8-sig'))
 tree=ET.fromstring(text)
 sources=[]
 for file in tree.findall('Source_Files/Verilog/File'):
  attrs={a.get('Name'):a.get('Val') for a in file.findall('FileInfo/Attr')}
  if attrs.get('AutoExcluded')=='true':continue
  path=(td/file.get('Path')).resolve()
  if path.name in exclude:continue
  verify(path);sources.append(path)
 for name in ['sys_pll.v','video_pll.v','afifo_16_32_256.v','afifo_32_16_256.v']:
  path=hdl/'ip'/name;verify(path);sources.append(path)
 for file in hdl.glob('*.vh'):verify(file)
 compat=[]
 for i,path in enumerate(sources):
  if path.name=='frame_read_write.v':
   source=path.read_text(encoding='utf-8-sig');moved=source
   for instance,port,signal in [('frame_fifo_write_m0','rdusedw','rdusedw'),('frame_fifo_read_m0','wrusedw','wrusedw')]:
    start=moved.index(instance);end=moved.index(');',start)+2
    block=moved[start:end]
    pattern=r'(\.'+port+r'\s*\()\s*'+signal+r'\s*(\))'
    block,count=re.subn(pattern,lambda m:m[1]+"{1'b0,"+signal+'}'+m[2],block)
    if count!=1:raise ValueError('Unexpected FIFO count-port layout')
    moved=moved[:start]+block+moved[end:]
   copied=cwd/'frame_read_write_compat.v';copied.write_text(moved,encoding='utf-8')
   (cwd/'fifo_count_extension.diff').write_text(''.join(difflib.unified_diff(source.splitlines(True),moved.splitlines(True),fromfile=str(path),tofile=str(copied))),encoding='utf-8')
   sources[i]=copied
   compat.append(dict(source=str(path),copy=str(copied),source_sha256=sha(path),copy_sha256=sha(copied),change='Explicit unsigned zero-extension of 9-bit FIFO counts into 10-bit input ports; old ModelSim otherwise leaves high bit Z'))
  if path.name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
   source=path.read_text(encoding='utf-8-sig')
   pattern=(r'^\s*wire\s+bmp_write_ready\s*;[^\n]*\n' if path.name=='top_tf_hdmi_audio.v' else r'^\s*reg\s+request_toggle,\s*ack_sync0,\s*ack_sync1\s*;[^\n]*\n')
   match=re.search(pattern,source,re.M)
   if match:
    # Preserve the entire declaration and move it before any implicit use.
    declaration=match.group().strip()+'\n'
    moved=source[:match.start()]+source[match.end():]
    anchor=moved.index(';',moved.index('module '))+1
    moved=moved[:anchor]+'\n'+declaration+moved[anchor:]
    copied=cwd/(path.stem+'_compat.v');copied.write_text(moved,encoding='utf-8')
    (cwd/(path.stem+'_declaration.diff')).write_text(''.join(difflib.unified_diff(source.splitlines(True),moved.splitlines(True),fromfile=str(path),tofile=str(copied))),encoding='utf-8')
    sources[i]=copied
    compat.append(dict(source=str(path),copy=str(copied),source_sha256=sha(path),copy_sha256=sha(copied),change='Declaration location only'))
  if path.name=='player_spectrum_analyzer.v':
   source=path.read_text(encoding='utf-8-sig')
   pattern=re.compile(r'^\s*(?:wire|reg)\s+\[8:0\]\s+twiddle_addr\s*;[^\n]*\n',re.M)
   match=pattern.search(source)
   if match and match.start()>source.find('spectrum_coeff_rom'):
    # Old ModelSim rejects a declaration after an instance creates an implicit net.
    moved=source[:match.start()]+source[match.end():]
    anchor=moved.index('spectrum_coeff_rom')
    line=moved.rfind('\n',0,anchor)+1
    moved=moved[:line]+match.group().strip()+'\n'+moved[line:]
    copied=cwd/'player_spectrum_analyzer_compat.v'
    copied.write_text(moved,encoding='utf-8')
    diff=''.join(difflib.unified_diff(source.splitlines(True),moved.splitlines(True),fromfile=str(path),tofile=str(copied)))
    (cwd/'analyzer_declaration.diff').write_text(diff,encoding='utf-8')
    sources[i]=copied
    compat.append(dict(source=str(path),copy=str(copied),source_sha256=sha(path),copy_sha256=sha(copied),change='Declaration location only'))
 # The only vendor model adaptation is the documented simulation initial state.
 pll=BASE/'pll/eg_phy_pll_init_adapter.v'
 if not pll.exists():raise ValueError('Missing separately verified PLL simulation adapter')
 sources.insert(0,pll)
 receipt=dict(version=version,checkpoint=str(cp),manifest_sha256=sha(cp/'manifest.json'),inputs=checked,compatibility_copies=compat,
  model_assumptions=['PLL model fakelockcnt initialized to zero in simulation-only copy'],pll_adapter_sha256=sha(pll))
 (cwd/'source_receipt.json').write_text(json.dumps(receipt,indent=2))
 (cwd/'modelsim.ini').write_text('[Library]\nwork = work\neg4 = '+EG4.as_posix()+'\nhdmi = '+HDMI.as_posix()+'\nothers = E:/ModelsimSE/modelsim.ini\n')
 inc=[hdl,hdl/'include',hdl/'SD',td]
 flags=['+incdir+'+'+'.join(p.as_posix() for p in inc)]
 return sources,flags,receipt
def compile_sources(cwd,sources,flags,top_tb):
 vlib=execute([BIN/'vlib.exe','work'],cwd,'vlib.log')
 if vlib['exit_code']:raise RuntimeError('vlib failed')
 (cwd/'sources.f').write_text('\n'.join('"'+str(p).replace('\\','/')+'"' for p in sources+[top_tb])+'\n')
 # The old SDRAM encrypted IP uses an unsized concatenation accepted in SV mode.
 # PLL ports named 'do' require Verilog mode, so compile the IP separately.
 encrypted=[p for p in sources if p.name.startswith('sdr_') and p.name.endswith('.enc.v')]
 plain=[p for p in sources if p not in encrypted]+[top_tb]
 (cwd/'plain.f').write_text('\n'.join('"'+p.as_posix()+'"' for p in plain)+'\n')
 result=execute([BIN/'vlog.exe','-modelsimini','modelsim.ini','-work','work']+flags+['-f','plain.f'],cwd,'compile.log')
 if result['exit_code']:raise RuntimeError('vlog failed; '+str(cwd/'compile.log'))
 if encrypted:
  ip_result=execute([BIN/'vlog.exe','-modelsimini','modelsim.ini','-work','work','-sv']+flags+[str(p) for p in encrypted],cwd,'compile_sdram_sv.log')
  if ip_result['exit_code']:raise RuntimeError('SDRAM SV compile failed; '+str(cwd/'compile_sdram_sv.log'))
  result['sdram_sv_compile']=ip_result
 return result
