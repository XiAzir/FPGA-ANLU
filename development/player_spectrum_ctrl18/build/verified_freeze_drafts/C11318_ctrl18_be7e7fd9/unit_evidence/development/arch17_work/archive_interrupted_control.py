from pathlib import Path
from datetime import datetime
import shutil,json
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17'
B=C/'build';D=B/'attempts/A00_interrupted_session'
D.mkdir(parents=True,exist_ok=False)
for p in (B/'manual').rglob('*'):
 if p.is_file() and p.suffix.lower() not in ('.db','.dmp'):
  q=D/p.relative_to(B/'manual');q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
receipt={'status':'INTERRUPTED_NO_SUCCESS_MARKER','observed_local':datetime.now().astimezone().isoformat(),'prior_run_id':'37045a07-dac7-4954-aede-33014cb122d3','facts':'exec session19586 unavailable; no TD process remained; log stopped at37%; no completion marker; latest_synthesis still running. Cause not established. Rebuild with a fresh guarded run.'}
(D/'interruption_receipt.json').write_text(json.dumps(receipt,indent=2));print(receipt['status'])
