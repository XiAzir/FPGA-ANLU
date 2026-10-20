#!/usr/bin/env python3
"""Collect reproducible local simulation results with SHA-bound source files."""
from __future__ import annotations
import datetime, hashlib, json, re
from pathlib import Path

TASK=Path(__file__).resolve().parents[1]
PROJECT=TASK.parents[1]
SIM=TASK/'sim';HDL=TASK/'src'/'user_source'/'hdl_source';MODEL=TASK/'build'/'model';VEC=SIM/'vectors'
def sha(p:Path)->str:return hashlib.sha256(p.read_bytes()).hexdigest()
def rel(p:Path)->str:
    try:return p.relative_to(PROJECT).as_posix()
    except ValueError:return str(p)
def record(p:Path)->dict:return {'path':rel(p),'sha256':sha(p)}
def latest(pattern:str)->Path:
    found=sorted(MODEL.glob(pattern),key=lambda p:p.stat().st_mtime)
    assert found,f'no evidence matches {pattern}'
    return found[-1]

def main():
    ana=HDL/'player_spectrum_analyzer.v';overlay=HDL/'player_pcm_waveform.v'
    analyzer_evidence=latest('spectrum_evidence_*.txt')
    pixel_evidence=latest('render_pixel_evidence_*.txt')
    pixel_hash_file=latest('render_pixel_hashes_*.json')
    integration_evidence=MODEL/'spectrum_overlay_integration_evidence.txt'
    integration_hash_file=MODEL/'spectrum_overlay_integration_hashes.json'
    music_evidence=MODEL/'spectrum_real_music_evidence.txt'
    pixhash=json.loads(pixel_hash_file.read_text(encoding='utf-8-sig'))
    inthash=json.loads(integration_hash_file.read_text(encoding='utf-8-sig'))
    for evidence,label,path in [(analyzer_evidence,'SHA256 analyzer=',ana),(music_evidence,'Analyzer RTL SHA256=',ana)]:
        match=re.search(re.escape(label)+r'([0-9a-fA-F]{64})',evidence.read_text(encoding='utf-8'))
        assert match and match.group(1).lower()==sha(path),f'{evidence.name} is not bound to current analyzer source'
    assert pixhash['renderer']==sha(overlay) and pixhash['analyzer']==sha(ana),'pixel evidence source hash mismatch'
    assert inthash['renderer']==sha(overlay) and inthash['analyzer']==sha(ana),'integration evidence source hash mismatch'
    cases=json.loads((VEC/'oracle.json').read_text(encoding='utf-8'))
    max_dft=max(c['max_fixed_float_abs_error'] for c in cases)
    assert max_dft<=16
    obs=(MODEL/'spectrum_overlay_integration_observed.log').read_text(encoding='utf-8').splitlines()
    frame_bands={}
    for line in obs:
        q=line.split()
        if q and q[0]=='BAND':frame_bands.setdefault(int(q[1]),{})[int(q[2])]=int(q[3])
    expected={0:cases[0]['fixed_bands'],5:cases[5]['fixed_bands'],12:cases[12]['fixed_bands']}
    integrated_error=0
    for f,ref in expected.items():
        assert sorted(frame_bands[f])==list(range(24))
        integrated_error=max(integrated_error,max(abs(frame_bands[f][i]-ref[i]) for i in range(24)))
    assert integrated_error==0
    music=Path(__file__).resolve().parents[3] / 'deliverables' / 'real_music_20261008' / 'card' / 'TEST.WAV'
    music_meta=json.loads((VEC/'real_music_windows.json').read_text(encoding='utf-8'))
    music_log=(MODEL/'spectrum_real_music_run.log').read_text(encoding='utf-8').splitlines()
    music_bands={}
    for line in music_log:
        q=line.split()
        if q and q[0]=='MUSIC_BAND':music_bands.setdefault(int(q[1]),{})[int(q[2])]=int(q[3])
    expected_music={w['id']:w['fixed_bands'] for w in music_meta['windows']}
    music_error=0
    for f,ref in expected_music.items():
        assert sorted(music_bands[f])==list(range(24))
        music_error=max(music_error,max(abs(music_bands[f][i]-ref[i]) for i in range(24)))
    assert music_error==0
    state_result=json.loads((MODEL/'spectrum_overlay_integration_result.json').read_text(encoding='utf-8'))
    render_gold=json.loads((VEC/'render_gold.json').read_text(encoding='utf-8'))
    files={
      'private_coefficient_rom_rtl':HDL/'spectrum_coeff_rom.v',
      'private_rom_generator':HDL/'gen_private_spectrum_rom.py',
      'private_rom_manifest':HDL/'spectrum_coeff_rom_manifest.json',
      'analyzer_rtl':ana,'overlay_rtl':overlay,'top_level_rtl':HDL/'top_tf_hdmi_audio.v',
      'band_edges':HDL/'player_spectrum_bands.vh','hann_rom':HDL/'spectrum_hann.mem','twiddle_rom':HDL/'spectrum_twiddle.mem',
      'coefficient_generator':HDL/'gen_player_spectrum_coeffs.py',
      'analyzer_tb':SIM/'tb_player_spectrum_analyzer.v','pixel_tb':SIM/'tb_spectrum_overlay_pixels.v',
      'integrated_control_tb':SIM/'tb_spectrum_overlay_integration.v','real_music_tb':SIM/'tb_spectrum_real_music.v',
      'analyzer_oracle':SIM/'spectrum_oracle.py','pixel_gold':SIM/'spectrum_render_gold.py',
      'integrated_state_gold':SIM/'verify_spectrum_overlay_integration.py','real_music_vector_preparer':SIM/'prepare_real_music_vectors.py',
      'analyzer_runner':SIM/'run_spectrum_model.ps1','pixel_runner':SIM/'run_spectrum_render_pixels.ps1',
      'integrated_runner':SIM/'run_spectrum_overlay_integration.ps1','real_music_runner':SIM/'run_spectrum_real_music.ps1',
      'result_collector':Path(__file__),'fixedpoint_vectors':VEC/'all_expected.mem','pcm_vectors':VEC/'all_samples.mem',
      'pixel_vectors':VEC/'render_pixels.mem','real_music_pcm_vectors':VEC/'real_music_samples.mem',
      'real_music_expected_vectors':VEC/'real_music_expected.mem','fixedpoint_case_results':VEC/'oracle.json',
      'pixel_gold_results':VEC/'render_gold.json','real_music_windows':VEC/'real_music_windows.json',
      'real_music_source':music,
    }
    run_logs={
      'analyzer_compile':latest('spectrum_compile_*.log'),'analyzer_run':latest('spectrum_run_*.log'),
      'pixel_compile':latest('render_pixels_compile_*.log'),'pixel_run':latest('render_pixels_run_*.log'),
      'integrated_compile':MODEL/'spectrum_overlay_integration_compile.log','integrated_run':MODEL/'spectrum_overlay_integration_run.log',
      'real_music_compile':MODEL/'spectrum_real_music_compile.log','real_music_run':MODEL/'spectrum_real_music_run.log',
    }
    result={
      'schema':'fpga-anlu-spectrum-model-result/v2','status':'PASS',
      'generated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
      'verification_kind':'Local Icarus PRIVATE_ROM_BEHAVIORAL_SIM and independent Python gold models; coefficient primitive INIT audited separately, no official protected primitive simulation or board validation.',
      'bound_sources':{k:record(v) for k,v in files.items()},
      'results':{
        'analyzer':{
          'status':'PASS','production_fft_size':1024,'sample_rate_hz':48000,'frequency_bin_hz':46.875,
          'vectors':len(cases),'bands_compared':len(cases)*24,'fixed_model_max_abs_error':0,
          'direct_dft_max_abs_error':max_dft,'direct_dft_asserted_bound':16,
          'coefficient_rom_words_formula_checked':{'hann':1024,'twiddle':512},
          'cases':[c['name'] for c in cases],
          'checks':['tone peak band low/mid/high','two tone response','amplitude doubled response','silence zero','DC excluded with Hann leakage accounted','positive/negative fullscale DC','phase pi/4 fullscale sine','alternating Nyquist extremes','centered impulse','fixed seed wideband random','continuous recapture','source_change abort during capture and analysis','reset abort','one full-rate frame with 521 clock intervals'],
          'analysis_cycles_per_frame':55320,'evidence':{'text':rel(analyzer_evidence),'compile':rel(run_logs['analyzer_compile']),'run':rel(run_logs['analyzer_run'])}
        },
        'real_music':{
          'status':'PASS','source':record(music),'sample_rate_hz':music_meta['sample_rate_hz'],'channels':music_meta['channels'],
          'sample_width_bits':music_meta['sample_width_bits'],'selected_windows':music_meta['windows'],
          'band_values_compared':48,'fixed_model_max_abs_error':music_error,
          'direct_dft_max_abs_error':music_meta['max_direct_dft_quantization_error'],'direct_dft_asserted_bound':16,
          'evidence':{'text':rel(music_evidence),'compile':rel(run_logs['real_music_compile']),'run':rel(run_logs['real_music_run'])}
        },
        'pixel_renderer':{
          'status':'PASS','independent_rgb_samples':render_gold['pixel_samples'],
          'coverage':['panel bounds','24 column starts/ends/gaps','baseline and maximum bar','peak marker','gridlines','SPECTRUM WAV/TONE and HOLD WAV/TONE title glyphs at pitch 16','LOW/HIGH legends at pitch 8','DE-low and outside RGB passthrough'],
          'evidence':{'text':rel(pixel_evidence),'hashes':rel(pixel_hash_file),'compile':rel(run_logs['pixel_compile']),'run':rel(run_logs['pixel_run'])}
        },
        'integrated_overlay':{
          **state_result,'actual_analyzer_fixed_model_max_abs_error':integrated_error,
          'wideband_random_band23':frame_bands[12][23],
          'evidence':{'text':rel(integration_evidence),'hashes':rel(integration_hash_file),'compile':rel(run_logs['integrated_compile']),
                      'run':rel(run_logs['integrated_run']),'observations':rel(MODEL/'spectrum_overlay_integration_observed.log')}
        }
      },
      'structural_observation':'The overlay receives PCM/VALID as inputs and returns RGB only; the top-level audio PCM outputs remain separate from this analyzer branch.',
      'limits':['The separate analyzer 521-clock sample cadence frame exercises 48 kHz timing; integrated PCM capture is accelerated to one valid sample per main clock but uses the full 1024-point arithmetic pipeline.','The simulation defines PRIVATE_ROM_BEHAVIORAL_SIM and loads coefficient files, not the official protected BRAM model; independent gate INIT decoding is required to check hardware coefficient constants.','Renderer sequential snapshots inspect internal state arrays against an independent model.','No board playback, HDMI display, or acoustic hardware test is included.']
    }
    out=MODEL/'model_result.json';out.write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
    print(json.dumps({'status':'PASS','model_result':rel(out),'analyzer_sha256':sha(ana),'overlay_sha256':sha(overlay),
      'fixedpoint_error':0,'direct_dft_max_error':max_dft,'music_fixedpoint_error':music_error,
      'music_source_sha256':sha(music),'pixel_samples':render_gold['pixel_samples'],'integrated_band23':frame_bands[12][23]},indent=2,ensure_ascii=False))
if __name__=='__main__':main()
