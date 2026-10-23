"""Bind manually reviewed C29 normal-board snapshots to source recordings."""
from pathlib import Path
import hashlib
import importlib.util
import json
import sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
sys.path.insert(0,str(ROOT/'development/video29_work'))
from decode_pages import decode

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))

# These are transcriptions of the original crops, rather than expected values.
selected={
 'photo':[
  ('3','30180000','frame_017.jpg'),('5','5E070800','frame_021.jpg'),
  ('6','6B0023C7','frame_023.jpg'),('E','EEBB8000','frame_007.jpg'),
  ('F','F061A800','frame_009.jpg')],
 'tone':[
  ('3','30180000','digit_crops_6fps/digit_048.jpg'),
  ('5','5E070800','digit_crops_6fps/digit_060.jpg'),
  ('6','6B0022C7','digit_crops_6fps/digit_066.jpg'),
  ('E','EEBB8000','digit_crops_6fps/digit_115.jpg'),
  ('F','F061A800','digit_crops_6fps/digit_120.jpg')],
 'video':[
  ('3','30180000','display_native/display_001.jpg'),
  ('5','5F84B000','display_native/display_004.jpg'),
  ('6','680222C7','display_native/display_006.jpg'),
  ('E','EEBB8000','display_native/display_022.jpg'),
  ('F','F061A800','display_native/display_024.jpg')]
}
modes={}
for mode,items in selected.items():
    folder=HERE/mode
    source=read(folder/'source.json')
    modes[mode]={
      'source':source,'version':'00C11329',
      'observation_file':f'{mode}/observations.json',
      'observation_sha256':sha(folder/'observations.json'),
      'key_pages':[{**decode(word),'frame':f'{mode}/{frame}',
                    'frame_sha256':sha(folder/frame)} for _,word,frame in items]
    }

spec=importlib.util.spec_from_file_location('gold',ROOT/'development/video22_work/audio_crc/gen_crc_golden.py')
gold=importlib.util.module_from_spec(spec);spec.loader.exec_module(gold)
pcm,_,_=gold.parse_wav(gold.SOURCE)
checks=[]
for mode,index,observed in [('first',0,'9DC4'),('photo',267,'26A2'),('video',80,'7F2F')]:
    expected=f'{gold.block_crc(pcm,index*4096,4096):04X}'
    checks.append({'mode':mode,'block':index,'sample_start':index*4096,
                   'observed':observed,'expected':expected,'match':expected==observed})
assert all(c['match'] for c in checks)
bit=ROOT/'download/video29_media_flow.bit'
package=ROOT/'deliverables/video29_media_flow_c11329_20261023.zip'
assert sha(bit)=='0f87f90f55eec622fcfe2373fbcb7c7a97a349bda79babcbafbe483e4a6e3c56'
assert sha(package)=='583134df6387f162b13b9a21128c8a94285fe9be3419156e84d0e49bdd4f8432'
result={
 'status':'NORMAL_BOARD_DIAGNOSTIC_SNAPSHOTS_RECORDED',
 'build_id':'00C11329','user_report':'Current version everything normal; supplied three mode-labelled recordings',
 'modes':modes,'pcm_golden':{'source_sha256':sha(gold.SOURCE),'checks':checks},
 'findings':[
  'All three captured pageE windows report48000 valid stereo sample pairs, BCH0/TERC0, flagsE.',
  'Observed ACR N6144 and CTS25000; nominal pixel frequency25MHz corresponds to48kHz.',
  'Labelled internal-tone capture has tone_bad_previous_sec0.',
  'Completed read session photo/tone230400 words, video153600 words; nonzero reads and count_match observed.',
  'All three pixel flagsC7 include osd/source valid, raw/gated nonzero history and pixel-underflow history.',
  'Audio underflow pageA observed0 in each recording.',
  'First PCM9DC4, photo block267 CRC26A2 and video block80 CRC7F2F independently match canonical WAV.'
 ],
 'limits':[
  'Sampled recordings show board/digits throughout; monitor picture and listening quality retain the user report.',
  'Pixel-underflow flag is sticky since media reset; its occurrence time/count is unavailable.',
  'Normal snapshot evidence is separate from five mode round trips, three restarts, cold starts and sustained playback.',
  'C28/C29 media control source preserved; current recovery cause remains undetermined.'
 ],
 'glyph_review':'Lowercase b/d and unlit top segments were rechecked at full resolution; initial contact-sheet estimates superseded in per-mode correction notes.',
 'frozen_artifacts':{'bit_sha256':sha(bit),'package_sha256':sha(package)},
 'actions':'Read-only recording analysis and documentation only; production source/bit/package unchanged; no TD/whole-system simulation/hardware operation'
}
(HERE/'summary.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'status':result['status'],'pcm':checks,'artifacts_preserved':True},indent=2))
