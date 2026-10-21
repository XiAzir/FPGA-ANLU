from pathlib import Path
import json,hashlib,re,argparse
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
a=argparse.ArgumentParser();a.add_argument('--system',required=True,type=Path);args=a.parse_args();D=args.system.resolve()
receipt=json.loads((D/'source_receipt.json').read_text(encoding='utf-8-sig'))
binding={'source_receipt_sha256':sha(D/'source_receipt.json'),'candidate_overrides':[dict(e) for e in receipt['candidate_overrides']]}
compile_list=(D/'plain.f').read_text(encoding='utf-8-sig')
for e in binding['candidate_overrides']:
 p=Path(e['path']);assert sha(p)==e['sha256'].lower(),p
 name=Path(e['reference_path']).name.replace('_compat.v','.v')
 q=D/('candidate_'+name);text=p.read_text(encoding='utf-8-sig')
 if name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
  pattern=(r'^\s*wire\s+bmp_write_ready\s*;[^\n]*\n' if name=='top_tf_hdmi_audio.v' else r'^\s*reg\s+request_toggle,\s*ack_sync0,\s*ack_sync1\s*;[^\n]*\n')
  declaration=re.search(pattern,text,re.M)
  if declaration:
   moved=text[:declaration.start()]+text[declaration.end():]
   anchor=moved.index(';',moved.index('module '))+1
   text=moved[:anchor]+'\n'+declaration.group().strip()+'\n'+moved[anchor:]
 assert q.read_text(encoding='utf-8-sig')==text,q
 assert '"'+q.as_posix()+'"' in compile_list,q
 e['compiled_copy_path']=str(q);e['compiled_copy_sha256']=sha(q)
 e['copy_content_proof']='Exact normalized selected source, with established declaration-position-only adaptation for top/status.'
binding['compile_artifacts']=[{'path':str(D/name),'sha256':sha(D/name)} for name in ('plain.f','sources.f','compile.log','compile_sdram_sv.log') if (D/name).is_file()]
(D/'compiled_copy_binding.json').write_text(json.dumps(binding,indent=2)+'\n',encoding='utf-8')
print('Compiled copies bound',len(binding['candidate_overrides']))
