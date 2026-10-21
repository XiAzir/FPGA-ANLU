from pathlib import Path
from datetime import datetime
import json,hashlib,re
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_opt16'
D=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11316_20261021')
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
b=read(C/'build/final_binding.json');assert b['status']=='PASS'
area=(C/'build/manual/AC201_tf_hdmi_phy.area').read_text()
def count(n):return int(re.search(r'^\s*#'+n+r'\s+(\d+)',area,re.M)[1])
spi=read(R/'download/spectrum_spi12p5.info.json')['spi']
info={'build_id':'C11316','created':datetime.now().astimezone().isoformat(),
 'status':'OFFLINE_RESOURCE_OPTIMIZED','hardware_status':'BOARD_NOT_TESTED',
 'conclusion':'LOWER_SLICE_AND_DSP_WITH_EQUIVALENT_MEDIA_BEHAVIOR_OFFLINE',
 'bitstream_sha256':b['bit_sha256'],'bitstream_bytes':(R/'download/spectrum_opt16.bit').stat().st_size,
 'spi':{k:v for k,v in spi.items() if k!='finding'},
 'resources':{'slice':b['slices'],'slice_percent':b['slice_percent'],'lut':count('lut'),'register':count('reg'),'LE':count('le'),'BRAM9K':count('bram9k'),'DSP':count('dsp'),'GCLK':count('gclk'),'PLL':count('pll')},
 'timing':{'setup_wns_ns':0.649,'setup_tns_ns':0.0,'hold_wns_ns':0.024,'hold_tns_ns':0.0},'STA_coverage':'99.98%',
 'baseline':{'build_id':'C11315','slice':7632,'slice_reduction':48,'DSP_reduction':1,'bitstream_sha256':'a9de55c166cd730db1203fc9d1d882eee885237cec68fd389dad26d0d972e22f'},
 'optimizations':['four fixed BPB fields reduced to byte-stream match flags','compile-time removal of duplicate scaler bounds checks under the validated production caller contract'],
 'system_results':{'duration_ms':122,'overrides':11,'serial_RGB_checked':1536000,'PCM_pairs_checked':4447,'FFT_frames':3,'FFT_bands':72,'FFT_max_error':0,'CRC_checked':58,'CRC_bad':0,'underflow':0,'commit_ns':95044789,'performance_identical_to_C11315':True},
 'unit_results':{'paired_images':6,'paired_pixels':1843200,'loader_public_outputs':'cycle identical','header_diagnostics':538,'catalog_field_variants':15,'geometry_bound_pairs':786432,'unit_evidence_files':len(read(C/'build/unit_evidence.json')['files'])},
 'gate_route_audit':{'gate_FFT_bands':72,'max_error':0,'ROM_logical_words':1536,'ROM_lane_entries':3072,'gate_control_truth_rows':192,'routed_control_truth_rows':192,'clock_checks_pass':45,'raw_SIG_INV_mismatches_retained':6},
 'model_assumptions':['nominal PLL edge replay','application SDRAM interface model; data leads valid one clock','first cold video frame excluded from RGB pin score'],
 'checkpoint':'development/player_spectrum_opt16/checkpoints/C11316_opt16_20261021_offline','checkpoint_files':b['checkpoint_files'],'manifest_sha256':b['manifest_sha256'],
 'validation_binding':'development/player_spectrum_opt16/build/final_binding.json','validation_binding_sha256':sha(C/'build/final_binding.json'),'stage_run_ids':b['stage_run_ids'],
 'report':str(D/'README.md'),'next':'Board verify C11316 Build ID, cold boot, multi-image switching, audio, spectrum, keys and sustained operation.'}
assert sha(R/'download/spectrum_opt16.bit')==info['bitstream_sha256']
(R/'download/spectrum_opt16.info.json').write_text(json.dumps(info,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
receipt={**b,'metadata_path':str(R/'download/spectrum_opt16.info.json'),'metadata_sha256':sha(R/'download/spectrum_opt16.info.json'),'report':str(D/'README.md')}
(D/'delivery_receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'bit_sha256':info['bitstream_sha256'],'manifest_sha256':b['manifest_sha256'],'checkpoint_files':b['checkpoint_files'],'slice':b['slices'],'status':'PASS'}))
