from pathlib import Path
from datetime import datetime
import hashlib,json,re
R=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
C=R/'development/player_spectrum_spi12p5'
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
b=read(C/'build/final_binding.json');assert b['status']=='PASS'
bit=R/'download/spectrum_spi12p5.bit';assert sha(bit)==b['bit_sha256']
area=(C/'build/manual/AC201_tf_hdmi_phy.area').read_text(encoding='utf-8')
count=lambda key:int(re.search(r'^[ \t]*#'+key+r'\s+(\d+)',area,re.M)[1])
timing=(C/'build/manual/AC201_tf_hdmi_phy.ts').read_text(encoding='utf-8')
margins=re.search(r'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.',timing)
a=read(C/'build/ablation_summary.json')
result={'build_id':'C11315','created':datetime.now().astimezone().isoformat(),
 'status':'OFFLINE_SPI_CONFIGURATION_CANDIDATE','hardware_status':'BOARD_NOT_TESTED',
 'conclusion':'SPI_HIGH_SPEED_PARAMETER_RESPECTED_12P5_VERIFIED_OFFLINE',
 'bitstream_sha256':sha(bit),'bitstream_bytes':bit.stat().st_size,
 'spi':{'mode':3,'system_nominal_MHz':50,'low_div':248,'low_nominal_kHz':100,
         'high_div':0,'data_nominal_MHz':12.5,'simulated_payload_sclk_period_ns':80,
         'finding':'Original C11314 steady-state code forced divider zero; its data phase already uses nominal12.5MHz. C11315 fixes parameter override and selects zero explicitly.'},
 'resources':{'slice':b['slices'],'slice_percent':round(b['slice_percent'],4),
              'lut':count('lut'),'register':count('reg'),'LE':count('le'),'BRAM9K':count('bram9k'),
              'DSP':count('dsp'),'GCLK':count('gclk'),'PLL':count('pll')},
 'timing':dict(zip(('setup_wns_ns','setup_tns_ns','hold_wns_ns','hold_tns_ns'),map(float,margins.groups()))),
 'STA_coverage':'99.98%',
 'baseline':{'build_id':'C11314','slice':7748,'slice_reduction':7748-b['slices'],
             'data_nominal_MHz':12.5,'bitstream_sha256':'60ed79eecfcbd271bbc2b9a9333d5da03668e00b580a6be751ebcd61f0fa4d28'},
 'reference_ablation':{'comparison':'Corrected DIV2 simulation reference versus production DIV0',
                       'throughput_ratio':a['service_throughput_ratio_fast_to_reference'],
                       'variants':a['variants']},
 'system_results':{'duration_ms':122,'overrides':11,'serial_RGB_checked':1536000,'PCM_pairs_checked':4447,
                   'FFT_frames':3,'FFT_bands':72,'FFT_max_error':0,'CRC_checked':58,'CRC_bad':0,'underflow':0},
 'gate_route_audit':{'gate_FFT_bands':72,'max_error':0,'ROM_logical_words':1536,'ROM_lane_entries':3072,
                     'gate_control_truth_rows':192,'routed_control_truth_rows':192,'clock_checks_pass':45,
                     'raw_SIG_INV_mismatches_retained':6},
 'model_assumptions':['nominal PLL edge replay','application SDRAM interface model; data leads valid one clock','short BMP/WAV fixtures; first cold video frame excluded from RGB pin score'],
 'SPI_board_IO_delay':'Awaiting board characterization; nominal half-cycle40ns',
 'checkpoint':'development/player_spectrum_spi12p5/checkpoints/C11315_spi12p5_20261021_offline',
 'checkpoint_files':b['checkpoint_files'],'manifest_sha256':b['manifest_sha256'],
 'validation_binding':'development/player_spectrum_spi12p5/build/final_binding.json',
 'stage_run_ids':b['stage_run_ids'],
 'report':'E:/QQ CACHE/Download/安路资料/开发记录/专题记录/SPI提速_20261021/C11315_实施记录.md',
 'next':'Board verify Build ID, cold boot, multi-image switching, audio, spectrum, keys, CRC/underflow and sustained operation.'}
(R/'download/spectrum_spi12p5.info.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
docs=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/SPI提速_20261021')
(docs/'C11315_delivery_receipt.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:result[k] for k in ('build_id','bitstream_sha256','resources','timing','manifest_sha256')},ensure_ascii=False))
