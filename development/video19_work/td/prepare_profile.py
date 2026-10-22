"""Measure specialization to the fixed 640x480 JPEG420 media contract."""
from pathlib import Path
import hashlib, json, re, shutil

HERE = Path(__file__).resolve().parent
destination = HERE / 'candidate_src/A09'
assert not destination.exists()
shutil.copytree(HERE / 'candidate_src/A08', destination)
p = destination / 'jpeg_core.v'
s = p.read_text()
for signal, value in [('width', "16'd640"), ('height', "16'd480"), ('mode', "2'd2")]:
    before = f'.img_{signal}_i(img_{signal}_w)'
    assert s.count(before) == 2
    s = s.replace(before, f'.img_{signal}_i({value})')
p.write_text(s)
unit = HERE / 'candidate_td/A09'
shutil.copytree(HERE / 'candidate_td/A06', unit,
    ignore=shutil.ignore_patterns('*.log', '*.db', '*.aig', '*.bid', '*.qor', '*Runs', 'result.json', 'manifest.json'))
for p in [unit / 'td_project/jpeg_core.al', unit / 'run_syn.tcl']:
    p.write_text(p.read_text().replace('/A06/', '/A09/'))
manifest = dict(variant='A09', parent='A08', description='Only fixed 640x480/420 child geometry; input parser and arithmetic unchanged',
    sources=[dict(name=p.name, sha256=hashlib.sha256(p.read_bytes()).hexdigest()) for p in sorted(destination.glob('*.v'))])
(unit / 'manifest.json').write_text(json.dumps(manifest, indent=2))
print(destination)
