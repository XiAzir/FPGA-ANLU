"""Restore byte-exact large experiment inputs from Git-sized gzip chunks."""
import gzip
import hashlib
import io
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / 'development/video_codec_trial_20261021/media/git_archive'


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


class Parts(io.RawIOBase):
    def __init__(self, parts):
        super().__init__()
        self.parts = iter(parts)
        self.current = None

    def readable(self):
        return True

    def readinto(self, buffer):
        while True:
            if self.current is None:
                try:
                    self.current = next(self.parts).open('rb')
                except StopIteration:
                    return 0
            n = self.current.readinto(buffer)
            if n:
                return n
            self.current.close()
            self.current = None

    def close(self):
        if self.current:
            self.current.close()
        super().close()


def main():
    index = json.loads((ARCHIVE / 'index.json').read_text(encoding='utf-8'))
    for entry in index['files']:
        target = ROOT / entry['path']
        if target.exists():
            if target.stat().st_size != entry['bytes'] or digest(target) != entry['sha256']:
                raise RuntimeError(f'Existing input differs: {target}')
            print(f'Verified {entry["path"]}')
            continue
        parts = []
        for part in entry['parts']:
            path = ARCHIVE / part['name']
            if digest(path) != part['sha256']:
                raise RuntimeError(f'Archive chunk hash mismatch: {path}')
            parts.append(path)
        temporary = target.with_suffix(target.suffix + '.restoring')
        try:
            with Parts(parts) as raw, io.BufferedReader(raw) as stream, gzip.GzipFile(fileobj=stream) as source, temporary.open('xb') as output:
                for block in iter(lambda: source.read(1024 * 1024), b''):
                    output.write(block)
            if temporary.stat().st_size != entry['bytes'] or digest(temporary) != entry['sha256']:
                raise RuntimeError(f'Restored input hash mismatch: {target}')
            temporary.rename(target)
        except Exception:
            temporary.unlink(missing_ok=True)
            raise
        print(f'Restored {entry["path"]}')


if __name__ == '__main__':
    main()
