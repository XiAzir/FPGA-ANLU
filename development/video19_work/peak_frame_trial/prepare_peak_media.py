"""Put the largest JPEG second, while original-audio playback is active."""
from pathlib import Path
import argparse
import contextlib
import hashlib
import json
import sys

HERE = Path(__file__).resolve().parent
FRONTEND = HERE.parent / 'stream_frontend'
parser = argparse.ArgumentParser()
parser.add_argument('--start-frame', type=int)
parser.add_argument('--output-root', type=Path, default=HERE)
parser.add_argument('--source-media', type=Path, default=FRONTEND / 'output')
args = parser.parse_args()
output_root = args.output_root.resolve()
sys.path.insert(0, str(FRONTEND))
import build_card_fixture as card
from pack_video_mjp import pack, split_mjpeg

source_index = json.loads((args.source_media / 'index.json').read_text())
source_video = Path(source_index['source_mjpg'])
frames = split_mjpeg(source_video.read_bytes())
peak = max(range(len(frames)), key=lambda i: len(frames[i]))
start = (peak - 1) % len(frames) if args.start_frame is None else args.start_frame
order = list(range(start, len(frames))) + list(range(start))
media = output_root / 'output'
media.mkdir(parents=True, exist_ok=True)
rotated = media / 'peak_at_one.mjpg'
rotated.write_bytes(b''.join(frames[i] for i in order))
index = pack(rotated, args.source_media / 'TEST.WAV', media / 'VIDEO.MJP',
             media / 'index.json', media / 'TEST.WAV')
card.HERE = output_root
card.MJP_PATH = media / 'VIDEO.MJP'
card.WAV_PATH = media / 'TEST.WAV'
with (output_root / 'card_fixture.log').open('w', encoding='utf-8') as log:
    with contextlib.redirect_stdout(log):
        card.build()
receipt = dict(
    purpose='Simulation-only reordered JPEG sequence for load/deadline phase tests',
    original_first_frame=start, original_second_frame=order[1],
    original_peak_frame=peak, peak_test_position=order.index(peak),
    jpeg_bytes=len(frames[peak]),
    original_frame_order=order, frames=len(frames),
    source_mjpeg_sha256=hashlib.sha256(source_video.read_bytes()).hexdigest(),
    video_sha256=index['video_sha256'], audio_sha256=index['audio']['sha256'],
    note='JPEG bytes unchanged; reordered picture sequence and original WAV test timing separately. Delivery media unchanged.')
(output_root / 'fixture_receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
print(json.dumps({k: v for k, v in receipt.items() if k != 'original_frame_order'}, indent=2))
