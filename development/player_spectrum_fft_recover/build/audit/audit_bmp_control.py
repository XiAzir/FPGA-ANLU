from pathlib import Path
import re,json,hashlib
p=Path(__file__).resolve().parents[2]
new=p/'src/user_source/hdl_source/tf_bmp_file_player.v'
baseline=p.parent/'player_bmp_scale/src/user_source/hdl_source/tf_bmp_file_player.v'
def main_process(f):
    s=f.read_text(encoding='utf-8-sig')
    s=re.sub(r'//[^\n]*','',s)
    s=re.sub(r'/\*.*?\*/','',s,flags=re.S)
    # Last process is the original player's state/request/pixel process.
    body=s.rsplit('always @(posedge clk or posedge rst)',1)[1]
    return re.sub(r'\s+','',body)
a=main_process(new);b=main_process(baseline)
result={'status':'PASS' if a==b else 'FAIL','scope':'Exact BMP main control-process token text comparison after whitespace/comments removal; passive observer processes/ports excluded, not whole gate equivalence.', 'newFile':str(new),'newSha256':hashlib.sha256(new.read_bytes()).hexdigest(),'baselineFile':str(baseline),'baselineSha256':hashlib.sha256(baseline.read_bytes()).hexdigest(),'processSha256':hashlib.sha256(a.encode()).hexdigest()}
(p/'build/audit/bmp_control_process_audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result,indent=2))
assert a==b,'Original BMP control was changed'

