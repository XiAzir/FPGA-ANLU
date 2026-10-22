"""Package the already measured Q90 encoding as an isolated bandwidth trial."""
from pathlib import Path
import contextlib
import hashlib
import json
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
FRONTEND = HERE.parent / 'stream_frontend'
sys.path.insert(0, str(FRONTEND))
import build_card_fixture as card
from pack_video_mjp import pack

video = ROOT / 'development/video_codec_trial_20261021/media/letterbox640_q90_420.mjpg'
audio = FRONTEND / 'output/TEST.WAV'
out = HERE / 'output'
out.mkdir(parents=True, exist_ok=True)
index = pack(video, audio, out / 'VIDEO.MJP', out / 'index.json', out / 'TEST.WAV')
card.HERE, card.MJP_PATH, card.WAV_PATH = HERE, out / 'VIDEO.MJP', out / 'TEST.WAV'
with (HERE / 'card_fixture.log').open('w', encoding='utf-8') as stream:
    with contextlib.redirect_stdout(stream):
        card.build()
peak = max(index['frames'], key=lambda f: f['jpeg_length_bytes'])
receipt = dict(profile='640x480 15fps JPEG420 Q90, 20 seconds, original PCM unchanged',
               source_sha256=hashlib.sha256(video.read_bytes()).hexdigest(),
               video_sha256=index['video_sha256'], audio_sha256=index['audio']['sha256'],
               peak_frame=peak['frame_index'], peak_jpeg_bytes=peak['jpeg_length_bytes'],
               status='ISOLATED_MEDIA_TRIAL', production_bitstream='C04 unchanged')
(HERE / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
print(json.dumps(receipt, indent=2))
