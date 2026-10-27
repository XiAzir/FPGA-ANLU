"""Normalize a refresh acknowledgement level at the public shift-register input."""
import hashlib
import json
from pathlib import Path
import shutil

ROOT=Path(__file__).resolve().parents[2]
PROJECT=ROOT/'development/player_video41_refresh'
WORK=Path(__file__).resolve().parent
sha=lambda b:hashlib.sha256(b).hexdigest()
archive=WORK/'macro_only_implementation'
archive.mkdir(exist_ok=False)
shutil.copytree(PROJECT/'build/manual',archive/'manual')
shutil.copytree(PROJECT/'verification',archive/'verification')
path=PROJECT/'src/user_source/hdl_source/include/sdr_init_ref.enc.v'
original=path.read_bytes()
marker=b'`pragma protect begin_protected'
pos=original.index(marker)
prefix=original[:pos]
suffix=original[pos:]
assert prefix.count(b'reg\t\t[19:0]\tsdr_ref_ack_sft;')==1
prefix=prefix.replace(b'reg\t\t[19:0]\tsdr_ref_ack_sft;',
    b'reg\t\t[19:0]\tsdr_ref_ack_sft;\r\nreg                 sdr_ref_ack_1d;')
old=b"\tif (Rst)\r\n\t\tsdr_ref_ack_sft <= 'd0;"
new=b"\tif (Rst) begin\r\n\t\tsdr_ref_ack_sft <= 'd0;\r\n        sdr_ref_ack_1d <= 1'b0;\r\n    end"
assert prefix.count(old)==1
prefix=prefix.replace(old,new)
old=b'\t\t\tsdr_ref_ack_sft[0]\t<= Sdr_ref_ack;'
new=(b'        sdr_ref_ack_1d <= Sdr_ref_ack;\r\n'
     b'        // One AREF trigger for each contiguous acknowledgement level.\r\n'
     b'        sdr_ref_ack_sft[0] <= Sdr_ref_ack & ~sdr_ref_ack_1d;')
assert prefix.count(old)==1
prefix=prefix.replace(old,new)
updated=prefix+suffix
path.write_bytes(updated)
assert path.read_bytes().split(marker,1)[1]==original.split(marker,1)[1]
(WORK/'sdr_init_ref_public_prefix_final.v').write_bytes(prefix)
record={'status':'PASS','only_public_prefix_modified':True,
        'original_full_sha256':sha(original),'updated_full_sha256':sha(updated),
        'protected_suffix_sha256_before':sha(suffix),'protected_suffix_sha256_after':sha(updated[len(prefix):]),
        'original_prefix_sha256':sha(original[:pos]),'updated_prefix_sha256':sha(prefix),
        'purpose':'Raw scheduler direct/completion ACK paths can form a two-cycle high level; accept its leading edge once.'}
(PROJECT/'verification/ack_edge_change.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
print(json.dumps(record,indent=2))
