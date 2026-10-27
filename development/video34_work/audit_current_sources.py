from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
initial=json.loads((HERE/'baseline_binding.json').read_text())
baseline=Path(initial['baseline'])
candidate=Path(initial['candidate'])
changed=[]
for item in initial['copied_source_files']:
    parent=baseline/item['path']
    assert sha(parent)==item['sha256'],str(parent)
    target=candidate/item['path']
    if sha(target)!=item['sha256']:
        changed.append({'path':item['path'],'baseline_sha256':item['sha256'],'current_sha256':sha(target)})
assert sha(ROOT/'download/video32_read_return.bit')==initial['baseline_bit_sha256']
source=ROOT/'development/video33_work/idct/jpeg_idct_dc_fast.v'
integrated=candidate/'src/user_source/hdl_source/jpeg/jpeg_idct.v'
expected=source.read_bytes().replace(b'module jpeg_idct_dc_fast',b'module jpeg_idct',1)
equal=expected.rstrip(b'\r\n')==integrated.read_bytes().rstrip(b'\r\n')
receipt={'baseline_unchanged':True,'C32_bit_sha256':initial['baseline_bit_sha256'],
         'changed_original_source_files':changed,
         'idct_source_sha256':sha(source),'idct_integrated_sha256':sha(integrated),
         'idct_only_module_rename_and_trailing_newlines':equal,
         'new_sources':[str(p.relative_to(candidate)) for p in (candidate/'src/user_source').rglob('*') if p.is_file() and str(p.relative_to(candidate)).replace('\\','/') not in {i['path'] for i in initial['copied_source_files']}]}
(HERE/'current_source_audit.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
assert equal,'Integrated IDCT differs beyond module rename and trailing newlines'
(HERE/'idct_integration_after_eob.json').write_text(json.dumps({
    'source':str(source),'source_sha256':sha(source),'destination':str(integrated),
    'destination_sha256':sha(integrated),'binding':'module rename and trailing newline difference only',
    'verification':'82-block exact tests plus full JPEG gradient/solid/blocks native integration; see per-fixture source bindings',
    'previous_receipt':'idct_integration.json records first import before EOB-contract repair'},indent=2),encoding='utf-8')
print(json.dumps({'baseline_unchanged':True,'changed_files':len(changed),'new_sources':len(receipt['new_sources']),'idct_integrated_sha256':receipt['idct_integrated_sha256']}))
