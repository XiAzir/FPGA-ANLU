"""Retain original SDF; create bounded logic-only check excluding unsupported macros."""
from pathlib import Path
import re,json,hashlib
p=Path(__file__).resolve().parent
s=(p/'routed.sdf').read_text()
exclude={'EG_PHY_SDRAM_2M_32','EG_PHY_PLL','EG_PHY_PAD'}
matches=list(re.finditer(r'^  \(CELL\n',s,re.M))
parts=[s[:matches[0].start()]]; omitted=[]; kept=0
for i,m in enumerate(matches):
 end=matches[i+1].start() if i+1<len(matches) else s.rfind('\n)')
 block=s[m.start():end]
 typ=re.search(r'\(CELLTYPE "([^"]+)"\)',block).group(1)
 inst=re.search(r'\(INSTANCE (.*?)\)',block).group(1)
 if typ in exclude: omitted.append({'type':typ,'instance':inst})
 else: parts.append(block);kept+=1
parts.append(s[s.rfind('\n)'):])
t=''.join(parts)
(p/'routed_logic_only.sdf').write_text(t)
result={'scope':'Logic fabric/BRAM/DSP and interconnect timing only; no PLL, PAD or hard SDRAM macro timing. This is not full board timing verification.',
        'source_sha256':hashlib.sha256(s.encode()).hexdigest(),'result_sha256':hashlib.sha256(t.encode()).hexdigest(),'kept_cells':kept,'omitted':omitted}
(p/'sdf_scope.json').write_text(json.dumps(result,indent=2))
print(json.dumps({'kept_cells':kept,'omitted_count':len(omitted),'omitted_types':sorted(exclude)}))
