from pathlib import Path
import argparse,re,json,hashlib
p=Path(__file__).resolve().parents[2]
ap=argparse.ArgumentParser()
ap.add_argument('--netlist',type=Path,required=True)
ap.add_argument('--output',type=Path,required=True)
args=ap.parse_args()
manifest=json.loads((p/'src/user_source/hdl_source/spectrum_coeff_rom_manifest.json').read_text(encoding='utf-8'))
mapping=manifest['inferred_read_control_mapping']
text=args.netlist.read_text(encoding='utf-8',errors='replace')
common={'READBACK':'OFF','REGMODE_A':'NOREG','REGMODE_B':'NOREG','WRITEMODE_A':'NORMAL','WRITEMODE_B':'NORMAL','GSR':'ENABLE','RESETMODE':'ASYNC','ASYNC_RESET_RELEASE':'SYNC'}
found={}
for m in re.finditer(r'EG_PHY_BRAM\s*#\((.*?)\)\s+\\(\S+)\s*\(',text,re.S):
    name=re.search(r'(?:^|/)u_(hann_low|hann_high|twiddle_low|twiddle_high)$',m.group(2))
    if not name:continue
    key=name.group(1);kind='hann' if key.startswith('hann') else 'twiddle'
    actual=dict(re.findall(r'\.([A-Z0-9_]+)\s*\(\s*"([^"]+)"\s*\)',m.group(1)))
    expected={**common,**mapping[kind]['control_parameters'],'MODE':mapping[kind]['mode'],
              'DATA_WIDTH_A':str(mapping[kind]['data_width_a_b']),'DATA_WIDTH_B':str(mapping[kind]['data_width_a_b'])}
    mismatch={k:{'expected':v,'actual':actual.get(k)} for k,v in expected.items() if actual.get(k)!=v}
    found[key]={'compared_parameters':len(expected),'mismatches':mismatch,'actual':{k:actual.get(k) for k in expected}}
assert set(found)=={'hann_low','hann_high','twiddle_low','twiddle_high'}
result={'status':'PASS' if all(not x['mismatches'] for x in found.values()) else 'FAIL',
 'netlist':str(args.netlist.resolve()),'netlist_sha256':hashlib.sha256(args.netlist.read_bytes()).hexdigest(),
 'banks':found,'scope':'Parameterized read control compared with TD inferred mapping. Dynamic addresses/enables connected by production generator; does not prove silicon read timing.'}
args.output.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'status':result['status'],'banks':{k:{'parameters':v['compared_parameters'],'mismatches':v['mismatches']} for k,v in found.items()}},indent=2))
raise SystemExit(0 if result['status']=='PASS' else 1)
