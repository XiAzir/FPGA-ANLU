from pathlib import Path
import re,json,hashlib,subprocess
R=Path(__file__).resolve().parents[2];D=Path(__file__).parent/'mapper_lifetime';D.mkdir(exist_ok=True)
P=R/'development/player_spectrum_opt16/src/user_source/hdl_source/fat32_file_sector.v'
s=P.read_text(encoding='utf-8-sig');t=s
changes={
 'reg [27:0] cache_cluster, cache_start;':'wire [27:0] cache_cluster=current_cluster;\n    reg [27:0] cache_start;',
 'reg [11:0] cache_index;':'wire [11:0] cache_index=walk_index;',
 'reg [27:0] brent_anchor, cache_brent_anchor;':'reg [27:0] brent_anchor;\n    wire [27:0] cache_brent_anchor=brent_anchor;',
 'reg [12:0] brent_power, cache_brent_power;':'reg [12:0] brent_power;\n    wire [12:0] cache_brent_power=brent_power;',
 'reg [12:0] brent_length, cache_brent_length;':'reg [12:0] brent_length;\n    wire [12:0] cache_brent_length=brent_length;'}
for a,b in changes.items():assert t.count(a)==1;a_count=t.count(a);t=t.replace(a,b)
for name in ('cache_cluster','cache_index','cache_brent_anchor','cache_brent_power','cache_brent_length'):
 t,n=re.subn(r'^\s*'+name+r'\s*<=\s*[^;]+;\s*$', '',t,flags=re.M);assert n==2,(name,n)
t=t.replace('// Brent cycle tracking', '// Working walk and completed-sector cache share their storage. Cache\n// contents are consulted only at request setup, before overwriting a walk.\n// An unsuccessful walk is sticky-failed until reset, so its old cache has\n// no later consumer. Successful data completion retains the live walk state.\n// Brent cycle tracking',1)
(D/'fat32_file_sector.v').write_text(t,encoding='utf-8')
(D/'reference.v').write_text(s.replace('module fat32_file_sector #','module fat32_file_sector_reference #'),encoding='utf-8')
F=R/'development/opt16_work/mapper'
for short in ('edges','long'):
 tb=(F/f'tb_mapper_{short}.v').read_text()
 if short=='long':
  tb=tb.replace('reference_mapper.cache_brent_anchor !== optimized_mapper.cache_brent_anchor ||',
   '(reference_mapper.state==0 && reference_mapper.cache_valid && reference_mapper.cache_brent_anchor !== optimized_mapper.cache_brent_anchor) ||')
  tb=tb.replace('reference_mapper.cache_brent_power !== optimized_mapper.cache_brent_power ||',
   '(reference_mapper.state==0 && reference_mapper.cache_valid && reference_mapper.cache_brent_power !== optimized_mapper.cache_brent_power) ||')
  tb=tb.replace('reference_mapper.cache_brent_length !== optimized_mapper.cache_brent_length)',
   '(reference_mapper.state==0 && reference_mapper.cache_valid && reference_mapper.cache_brent_length !== optimized_mapper.cache_brent_length))')
 (D/f'tb_{short}.v').write_text(tb,encoding='utf-8')
receipt={'baseline':str(P),'baseline_sha256':hashlib.sha256(P.read_bytes()).hexdigest(),'candidate_sha256':hashlib.sha256((D/'fat32_file_sector.v').read_bytes()).hexdigest(),'removed_bits_per_mapper':94,'proof':'Cache context read only at S_CHECK when no logical request is in flight. At idle after success live walk equals completed cache. Busy overwrites have no later cache consumer until success; any failure is sticky and disable invalidates cache. Cache identity/valid kept independently.'}
(D/'source_receipt.json').write_text(json.dumps(receipt,indent=2));print(json.dumps(receipt))
