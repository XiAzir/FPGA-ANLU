"""Describe the verified C11314 bit; hardware status stays pending."""
from pathlib import Path
from datetime import datetime
import hashlib,json,re
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
C=R/'development/player_spectrum_resource_80'
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
binding=read(C/'build/final_binding.json')
assert binding['status']=='PASS'
bit=R/'download/spectrum_resource_80.bit'
assert hashlib.sha256(bit.read_bytes()).hexdigest()==binding['bit_sha256']
area=(C/'build/manual/AC201_tf_hdmi_phy.area').read_text()
def count(name):return int(re.search(r'^[ \t]*#'+name+r'\s+(\d+)',area,re.M)[1])
result={
 'build_id':'C11314','status':'OFFLINE_RESOURCE_CANDIDATE',
 'conclusion':'SLICE_BELOW_80_TIMING_PASS_OFFLINE_VERIFIED',
 'hardware_status':'BOARD_NOT_TESTED','created':datetime.now().astimezone().isoformat(),
 'bitstream_sha256':binding['bit_sha256'],'bitstream_bytes':bit.stat().st_size,
 'selected_variant':'B04 mapper specialization + WAV v2 + catalog latch + BMP header/stride; AreaHigh + AdderThreshold18',
 'resources':{'slice':binding['slices'],'slice_percent':round(binding['slice_percent'],4),
              'lut':count('lut'),'register':count('reg'),'LE':count('le'),'BRAM9K':count('bram9k'),
              'DSP':count('dsp'),'GCLK':count('gclk'),'PLL':count('pll')},
 'timing':{'setup_wns_ns':.633,'hold_wns_ns':.011,'setup_tns_ns':0,'hold_tns_ns':0,'coverage':'99.98%'},
 'baseline':{'build_id':'C11313','slice':8243,'slice_percent':84.11224489795919,
             'slice_reduction':8243-binding['slices'],
             'hardware_status':'USER_REPORTED_FUNCTION_AND_SPECTRUM_PASS',
             'bitstream_sha256':'3d85e5cdda40f1a91697ddf3c0275c52cf7bcee76d31af20503293b5a7428ca1'},
 'checkpoint':'development/player_spectrum_resource_80/checkpoints/C11314_resource80_20261021_offline',
 'manifest_sha256':binding['manifest_sha256'],'checkpoint_files':binding['checkpoint_files'],
 'stage_pointers':{s:read(C/'build/manual/stage_evidence'/f'latest_{s}.json') for s in ('synthesis','physical','bitstream')},
 'validation_binding':'development/player_spectrum_resource_80/build/final_binding.json',
 'system_verification':'development/player_spectrum_resource_80/build/system_20261020_222306',
 'system_results':{'override_sources':10,'serial_rgb_checked':1536000,'PCM_pairs_checked':4446,
                   'FFT_frames':3,'FFT_bands':72,'FFT_max_abs_error':0,'spectrum_visible_bar_pixels':2844,
                   'mapper_contract_requests':{'BMP':3,'WAV':27}},
 'model_assumptions':['nominal PLL edge replay','application SDRAM interface model; data leads valid one clock','first cold video frame excluded from pin RGB scoring'],
 'gate_and_route_audit':{'gate_fft_bands':72,'gate_fft_max_error':0,'ROM_logical_words':1536,
                        'ROM_lane_entries':3072,'gate_control_truth_rows':192,'routed_control_truth_rows':192,
                        'strict_parameter_mismatches_retained':6,'routed_clock_checks_pass':45},
 'report':'E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11314_20261020/README.md',
 'board_next':'Load this C11314 bit and check images/audio/spectrum/keys and sustained operation; stable C11313 bit is retained.'}
out=R/'download/spectrum_resource_80.info.json'
out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11314_20261020')
(docs/'delivery_receipt.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'build_id':result['build_id'],'bit_sha256':result['bitstream_sha256'],
                  'resources':result['resources'],'hardware_status':result['hardware_status']}))
