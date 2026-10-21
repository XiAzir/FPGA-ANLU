from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[2];D=R/'development/player_spectrum_arch17/build/system_fast_20261021_124327'
p=D/'source_receipt.json';receipt=json.loads(p.read_text(encoding='utf-8-sig'))
before=p.read_bytes()
for e in receipt['candidate_overrides']:
 for k in ('compiled_copy_path','compiled_copy_sha256','copy_content_proof'):e.pop(k)
receipt.pop('compile_artifacts')
data=json.dumps(receipt,indent=2).replace('\n','\r\n').encode('utf-8')
fixture=json.loads((D/'fixture_receipt.json').read_text(encoding='utf-8-sig'))
entry=next(e for e in fixture if Path(e['path'])==p)
assert hashlib.sha256(data).hexdigest()==entry['sha256'].lower(),'reconstructed source receipt differs from original fixture binding'
T=R/'development/player_spectrum_arch17/build/audit/attempts/final_copy_binding_receipt'
T.mkdir(parents=True,exist_ok=False)
(T/'source_receipt_mutated.json').write_bytes(before)
(T/'repair.json').write_text(json.dumps({'status':'ORIGINAL_RESTORED_BY_EXACT_SHA','original_sha256':entry['sha256'].lower(),'cause':'Compiled copy fields were initially added to source_receipt, which fixture_receipt already hashes. Restored original metadata exactly; derived bindings now separate compiled_copy_binding.json.'},indent=2))
p.write_bytes(data);print('Original simulation receipt restored',entry['sha256'])
