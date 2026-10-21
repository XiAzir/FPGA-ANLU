#!/usr/bin/env python3
"""Verify the SHA256SUMS.txt of this extracted handoff folder; safe read-only."""
from __future__ import annotations
import hashlib
from pathlib import Path
import sys
root=Path(__file__).resolve().parent.parent
manifest=root/'SHA256SUMS.txt'
if not manifest.is_file():
    sys.exit('ERROR: Missing SHA256SUMS.txt')
failed=[];count=0
for line in manifest.read_text(encoding='utf-8').splitlines():
    if not line.strip() or line.startswith('#'):
        continue
    try:
        digest,relpath=line.split('  ',1)
    except ValueError:
        failed.append('invalid manifest row: '+line);continue
    p=root/relpath
    if not p.is_file():
        failed.append('missing '+relpath);continue
    if hashlib.sha256(p.read_bytes()).hexdigest()!=digest:
        failed.append('mismatch '+relpath)
    else:
        count+=1
print(f'SHA256 verified files: {count}')
if failed:
    print('\n'.join(failed));sys.exit(1)
print('OK (manifest excludes itself)')
