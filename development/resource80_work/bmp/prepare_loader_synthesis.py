from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parent
active=Path(__file__).resolve().parents[3]/'development/player_spectrum_resource_80/src/user_source/hdl_source'
out=root/'synthesis_loader'
template=Path(__file__).resolve().parents[3]/'development/resource_opt_work/bmp_synthesis/runs/loader_reference/td_project/bmp_loader_reference.al'
tcl_template=Path(__file__).resolve().parents[3]/'development/resource_opt_work/bmp_synthesis/runs/loader_reference/run_syn.tcl'
if out.exists() and any(out.iterdir()): raise SystemExit(f'{out} already populated')
text=(active/'SD/sd_card_bmp.v').read_text(encoding='utf-8-sig')
match=re.search(r'(?ms)^module key_press_debounce\s*#\(.*?^endmodule',text)
if not match: raise SystemExit('debounce module not found')
variants={'base':(root/'tf_bmp_file_player.base.v',root/'bmp_scale_engine.base.v'),'header':(root/'tf_bmp_file_player.header.v',root/'bmp_scale_engine.base.v')}
manifest={}
for name,(loader,engine) in variants.items():
 folder=out/name; hdl=folder/'hdl_source'; td=folder/'td_project'; hdl.mkdir(parents=True);td.mkdir()
 (hdl/'tf_bmp_file_player.v').write_bytes(loader.read_bytes());(hdl/'bmp_scale_engine.v').write_bytes(engine.read_bytes());(hdl/'key_press_debounce.v').write_text(match.group(0)+'\n',encoding='utf-8')
 proj=f'bmp_loader_{name}.al'
 t=template.read_text(encoding='utf-8-sig').replace('resource_opt_work/bmp_synthesis/runs/loader_reference/td_project',f'resource80_work/bmp/synthesis_loader/{name}/td_project').replace('bmp_loader_reference',f'bmp_loader_{name}')
 (td/proj).write_text(t,encoding='utf-8',newline='\n')
 tt=tcl_template.read_text(encoding='utf-8-sig').replace('bmp_loader_reference.al',proj)
 (folder/'run_syn.tcl').write_text(tt,encoding='ascii',newline='\n')
 (folder/'standalone.sdc').write_text('create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n',encoding='ascii')
 manifest[name]={'loader_sha256':hashlib.sha256((hdl/'tf_bmp_file_player.v').read_bytes()).hexdigest(),'engine_sha256':hashlib.sha256((hdl/'bmp_scale_engine.v').read_bytes()).hexdigest(),'debounce_sha256':hashlib.sha256((hdl/'key_press_debounce.v').read_bytes()).hexdigest(),'project':str((td/proj).resolve())}
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(out)
for k,v in manifest.items(): print(k,v['loader_sha256'],v['engine_sha256'])
