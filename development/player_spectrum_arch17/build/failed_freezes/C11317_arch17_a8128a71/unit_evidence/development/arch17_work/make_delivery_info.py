from pathlib import Path
from datetime import datetime
import json,hashlib,re,argparse
R=Path(__file__).resolve().parents[2];C=R/'development/player_spectrum_arch17';W=Path(__file__).parent
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
a=argparse.ArgumentParser();a.add_argument('--system',required=True,type=Path);args=a.parse_args()
b=read(C/'build/final_binding.json');assert b['status']=='PASS'
perf=read(args.system/'spi_performance.json');sys=read(args.system/'summary.json')
area=(C/'build/manual/AC201_tf_hdmi_phy.area').read_text()
resource={label:int(re.search(r'^#'+key+r'\s+(\d+)',area,re.M)[1]) for label,key in [('lut','lut'),('register','reg'),('LE','le'),('BRAM9K','bram9k'),('DSP','dsp'),('GCLK','gclk'),('PLL','pll')]}
resource.update(slice=b['slices'],slice_percent=b['slice_percent'])
timing_values=[float(x) for x in re.findall(r'(?:SWNS|STNS|HWNS|HTNS):\s*([-\d.]+)ns',b['timing'])]
assert len(timing_values)==4
sel=read(C/'build/selected_changes.json')
optimizations=['Reuse held normal-FIFO output as the RGB reservoir high suffix; retain 32 local reservoir bits']
shared=(C/'src/user_source/hdl_source/fat32_dual_file_sector.v').exists()
if shared:optimizations+=['One FAT execution engine and sector arbiter with two independent contexts; cache/walk lifetime sharing; retire two old source files']
else:optimizations+=['Merge live FAT walk and completed cache state per mapper']
if 'user_source/hdl_source/bmp_scale_engine.v' in sel:optimizations+=['Production validated scaler references parent-held header width, height and stride; generic path retains original latches']
manifest=C/'checkpoints/C11317_arch17_20261021_offline/manifest.json'
info={'build_id':'C11317','created':datetime.now().astimezone().isoformat(),'status':'OFFLINE_RESOURCE_OPTIMIZED','hardware_status':'BOARD_NOT_TESTED','bitstream_sha256':b['bit_sha256'],'bitstream_bytes':(R/'download/spectrum_arch17.bit').stat().st_size,'spi':{'mode':3,'system_nominal_MHz':50,'low_div':248,'low_nominal_kHz':100,'high_div':0,'data_nominal_MHz':12.5,'simulated_payload_sclk_period_ns':perf['min_sclk_period_ns']},'resources':resource,'timing':dict(zip(('setup_wns_ns','setup_tns_ns','hold_wns_ns','hold_tns_ns'),timing_values)),'baseline':{'build_id':'C11316','slice':7584,'slice_reduction':7584-b['slices'],'bitstream_sha256':'1de561dda1428c86c2f3127cf55b4b391cae8598c51111394ef9bde0ee971afa'},'optimizations':optimizations,'system_results':{'duration_ms':122,'overrides':b['selected_overrides'],'serial_RGB_checked':1536000,'PCM_pairs_checked':4447,'FFT_frames':sys['fft']['completed_frames'],'FFT_bands':sys['fft']['band_checks'],'FFT_max_error':sys['fft']['max_abs_error'],'CRC_checked':perf['crc_checked'],'CRC_bad':perf['crc_bad'],'underflow':perf['underruns'],'commit_ns':perf['commit_ns'],'fifo_min_after_prime':perf['fifo_min_after_prime']},'gate_route_audit':{'gate_FFT_bands':72,'max_error':0,'ROM_logical_words':1536,'ROM_lane_entries':3072,'gate_control_truth_rows':192,'routed_control_truth_rows':192,'clock_checks_pass':45,'raw_SIG_INV_mismatches_retained':6},'model_assumptions':sys['assumptions']+['First cold video frame excluded from serial RGB comparison'],'unverified':sys['unverified'],'checkpoint':str(manifest.parent.relative_to(R)),'checkpoint_files':b['checkpoint_files'],'manifest_sha256':sha(manifest),'validation_binding':str((C/'build/final_binding.json').relative_to(R)),'validation_binding_sha256':sha(C/'build/final_binding.json'),'stage_run_ids':b['stage_run_ids'],'report':'E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11317_20261021/README.md','next':'Board verify C11317 Build ID, cold boot, multi-image switching, audio, spectrum, keys and sustained operation.'}
(R/'download/spectrum_arch17.info.json').write_text(json.dumps(info,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
D=Path('E:/QQ CACHE/Download/安路资料/开发记录/专题记录/资源优化/C11317_20261021');D.mkdir(parents=True,exist_ok=True)
(D/'delivery_receipt.json').write_text(json.dumps(info,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Delivery info',resource['slice'],b['bit_sha256'])
