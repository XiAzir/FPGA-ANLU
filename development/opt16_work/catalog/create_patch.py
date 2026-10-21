from pathlib import Path
import difflib,hashlib
root=Path(__file__).resolve().parent
base=(root/'fat32_catalog_baseline.v').read_text(encoding='utf-8').splitlines(True)
cand=(root/'fat32_catalog_candidate_fixed_flags.v').read_text(encoding='utf-8').splitlines(True)
diff=''.join(difflib.unified_diff(base,cand,fromfile='fat32_catalog_baseline.v',tofile='fat32_catalog_candidate_fixed_flags.v'))
(root/'fixed_flags.diff').write_text(diff,encoding='utf-8',newline='\n')
for n in ('fat32_catalog_baseline.v','fat32_catalog_candidate_fixed_flags.v','fixed_flags.diff'):
 p=root/n; print(n,hashlib.sha256(p.read_bytes()).hexdigest(),p.stat().st_size)
