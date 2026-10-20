"""Retain selected original cell timing and connections, map external boundaries.

No library delay numbers are altered. External upstream logic is not modeled.
"""
from pathlib import Path
import json,re,hashlib
p=Path(__file__).resolve().parent/'display_cone'
s=(p/'full_routed.sdf').read_text()
m=json.loads((p/'cone_manifest.json').read_text())
pins=json.loads((p/'pin_nets.json').read_text())
selected=set(m['instances']);bounds=m['boundaries']
def unescape(x):return re.sub(r'\\(.)',r'\1',x)
def endpoint(x):
    z=re.split(r'(?<!\\)/',x)
    return unescape('/'.join(z[:-1])),unescape(z[-1])
matches=list(re.finditer(r'^  \(CELL\n',s,re.M))
parts=[s[:matches[0].start()].replace('(DESIGN "top")','(DESIGN "display_cone")')]
stats={'cells':0,'retained_interconnect':0,'boundary_interconnect':0,'omitted_external_interconnect':0}
for i,match in enumerate(matches):
    end=matches[i+1].start() if i+1<len(matches) else s.rfind('\n)')
    block=s[match.start():end]
    typ=re.search(r'\(CELLTYPE "([^"]+)"\)',block).group(1)
    inst=unescape(re.search(r'\(INSTANCE (.*?)\)',block).group(1))
    if typ=='top':
        lines=[]
        for line in block.splitlines():
            hit=re.search(r'\(INTERCONNECT (\S+) (\S+) (.*)',line)
            if not hit:lines.append(line.replace('(CELLTYPE "top")','(CELLTYPE "display_cone")'));continue
            a,b=hit.groups()[:2];ai,ap=endpoint(a);bi,bp=endpoint(b)
            if bi in selected:
                net=pins[bi].get(bp)
                if net in bounds:
                    replacement=bounds[net]
                    line=line.replace('(INTERCONNECT '+a+' ', '(INTERCONNECT '+replacement+' ',1)
                    stats['boundary_interconnect']+=1
                    lines.append(line)
                elif ai in selected:
                    stats['retained_interconnect']+=1;lines.append(line)
                else:stats['omitted_external_interconnect']+=1
            elif ai in selected and b in ('seg7_dio','seg7_sclk','seg7_rclk'):
                lines.append(line);stats['retained_interconnect']+=1
            else:stats['omitted_external_interconnect']+=1
        parts.append('\n'.join(lines)+'\n')
    elif inst in selected:
        parts.append(block);stats['cells']+=1
parts.append(s[s.rfind('\n)'):])
t=''.join(parts)
(p/'display.sdf').write_text(t)
stats.update(source_sha256=hashlib.sha256(s.encode()).hexdigest(),result_sha256=hashlib.sha256(t.encode()).hexdigest(),
             limit='Extracted observed cone only, ideal clock/reset/data boundaries replace original upstream drivers. Original retained delay values; no external 595 electrical behavior.')
(p/'sdf_scope.json').write_text(json.dumps(stats,indent=2))
print(json.dumps(stats,indent=2))
