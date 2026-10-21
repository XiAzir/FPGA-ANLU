from pathlib import Path
import subprocess,json
R=Path(__file__).resolve().parents[2];D=Path(__file__).parent/'mapper_lifetime'
iv=R/'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe';vp=iv.with_name('vvp.exe')
summary=[]
for short,modes in [('edges',range(8)),('long',(0,5,7))]:
 for mode in modes:
  tag=f'{short}_{mode:03b}';top=f'tb_mapper_{short}_specialized'
  args=[str(iv),'-g2012','-s',top,'-P'+top+'.CATALOG_GEOMETRY='+str((mode>>2)&1),'-P'+top+'.STATIC_FILE='+str((mode>>1)&1),'-P'+top+'.REQUEST_STABLE='+str(mode&1),'-o',str(D/(tag+'.vvp')),str(D/'reference.v'),str(D/'fat32_file_sector.v'),str(D/f'tb_{short}.v')]
  p=subprocess.run(args,capture_output=True,text=True);(D/(tag+'_compile.log')).write_text(p.stdout+p.stderr);assert p.returncode==0,p.stderr
  p=subprocess.run([str(vp),str(D/(tag+'.vvp'))],capture_output=True,text=True);(D/(tag+'_run.log')).write_text(p.stdout+p.stderr);print(tag,p.returncode,p.stdout[-500:],flush=True);assert p.returncode==0,p.stdout
  summary.append({'case':tag,'status':'PASS','log':str(D/(tag+'_run.log'))})
(D/'summary.json').write_text(json.dumps(summary,indent=2))
