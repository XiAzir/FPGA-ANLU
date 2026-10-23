import json
from pathlib import Path

p=Path(__file__).resolve().parents[1]/'video28_work/board_20261023_feedback'
def read(name):return json.loads((p/name).read_text(encoding='utf-8-sig'))
data={
 'build_id':'00C11328',
 'evidence_kind':'user board feedback and manual full-resolution digit reading',
 'power':'external 5V USB adapter, USB-A to USB-C',
 'symptoms':{'photo':'UI and live FFT visible; content black; audio severe noise',
             'video':'content absent; audio severe noise'},
 'recordings':{k:read(k+'/source.json') for k in ('photo','video')},
 'pages':{
  'photo':{'version':['00C11328'],'status':['2B910000'],'4':['40000729','40000829'],
           '5':['5077E7F2'],'6':['68003000'],'7':['79DC4000'],'8':['84490000'],
           '9':['90282000'],'A':['A0000000'],'B':['B6000047'],
           'C':['C8840863','C8840873'],'D':['D4400000'],
           'E':['EDDC781D','ED76781D','ED94781D'],'F':['F07D0000']},
  'video':{'version':['00C11328'],'status':['2BD44000'],'4':['40000728'],
           '5':['50000003'],'6':['68023000'],'7':['79DC4000'],'8':['80779000'],
           '9':['9004F000'],'A':['A0000000'],'B':['BE000067'],
           'C':['C8840873'],'D':['D4400000'],'E':['ED78781D','ED96781D'],'F':['F07D0000']}},
 'pcm_golden':read('pcm_reference_check.json'),
 'findings':[
  'Photo scaler state0, y479/x639 and display_valid1 show complete output and commit.',
  'Video mode1, controller4 and display_valid1 observed.',
  'HDMI locked/seen/ready1, lost0, 480 active lines; clock word01f, 256 input edges/128 pixels.',
  'Read FIFO empty sampled in both modes; continuous read-stream activity remains unobserved.',
  'First PCM and the two later indexed blocks match the delivered WAV; captured underflow0.'
 ],
 'pending':['osd pixel gate and memory FIFO input/return flow',
            'HDMI post-core packet BCH/TERC, N/CTS and tone payload',
            'physical HDMI receiver PCM and failure causality'],
 'corrections':['Page9 original contact-sheet estimates674/70 superseded by full-size crops642/79.'],
 'next':'C29 passive memory/pixel and HDMI packet observer; board validation pending'
}
(p/'observations.json').write_text(json.dumps(data,ensure_ascii=False,indent=2),encoding='utf-8')
print('C28 observations saved')
