from pathlib import Path
import json
R=Path(__file__).resolve().parents[2];B=R/'development/player_spectrum_arch17/build/attempts'
for folder,decision in {
 'A00_buildid_only':'Same C11317 Build ID/source-location control; no algorithm change.',
 'A01_mapper_lifetime':'Unit benefit confirmed; full top LUT +94 and FF -188 versus same-ID control. Combined with FIFO reuse in A02.',
 'A02_lifetime_fifo_hold':'Synthesis 12654 LUT/7488 FF; physical completed and separately retained as A02_verified_offline.',
 'A02_lifetime_fifo_hold_physical':'Physical fallback 7383 slices, setup +0.614 ns / hold +0.004 ns. Nominal system and gate/routed audits subsequently passed.',
 'A02_verified_offline':'Verified fallback retained while evaluating shared core. Bit kept internal until final selection.',
 'A03_compile_order_rejected':'TD completed synthesis but input-context gate rejected compile-order metadata rewrite. Fixed metadata and rebuilt without changing guard.',
 'A03_B9_shared_fifo':'Certified synthesis and nominal full-system pass. Superseded by revision084: an aged-counter deposit at C_IDLE exposed a queued-peer scheduling priority case; default 50M reachability unproven. No PNR or publication for B9.'
}.items():
 p=B/folder/'result.json'
 if p.exists():
  x=json.loads(p.read_text(encoding='utf-8-sig'));x['selection_note']=decision
  p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Attempt decisions recorded')
