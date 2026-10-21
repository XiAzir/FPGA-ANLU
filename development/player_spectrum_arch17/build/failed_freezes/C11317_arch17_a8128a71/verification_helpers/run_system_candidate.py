"""Replay the established C11312 full-media fixture against selected candidate RTL."""
from pathlib import Path
import sys, json, inspect, re

ROOT=next(p for p in Path(__file__).resolve().parents if (p/'scripts/anlu_tools.ps1').is_file() and (p/'download').is_dir())
FIXTURE=ROOT/'development/system_verification_20261016/integration'
sys.path.insert(0,str(FIXTURE))
import common

candidate=ROOT/'development/player_spectrum_arch17'
baseline='--baseline' in sys.argv
slow_reference='--slow-reference' in sys.argv
if slow_reference:sys.argv.remove('--slow-reference')
assert not (baseline and slow_reference)
if baseline:
    sys.argv.remove('--baseline')
    candidate=ROOT/'development/player_spectrum_opt16'
output_root=ROOT/'development/player_spectrum_arch17/build'
hdl=candidate/'src/user_source/hdl_source'
shared_mapper=(hdl/'fat32_dual_file_sector.v').is_file()
changed=('fat32_catalog.v','fat32_file_sector.v','bmp_scale_engine.v',
         'tf_bmp_file_player.v','player_pcm_waveform.v','top_tf_hdmi_audio.v',
         'player_status_monitor.v','sd_card_bmp.v','player_audio_probe.v',
         'tf_wav_file_player.v','sd_card_sec_read_write.v','rgb888_word_codec.v')
# C11312 uses a manifest object with a files list; older fixture releases
# use a bare list. Keep the original per-file SHA verification in both cases.
loader_text=inspect.getsource(common.archived_sources)
loader_text=loader_text.replace(" manifest=json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))", " manifest=json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))\n if isinstance(manifest,dict):manifest=manifest['files']")
exec(compile(loader_text,str(FIXTURE/'common.py'),'exec'),common.__dict__)
original_loader=common.archived_sources

def candidate_sources(version,cwd,exclude=()):
    if shared_mapper:exclude=tuple(exclude)+('sd_sector_arbiter.v',)
    sources,flags,receipt=original_loader(version,cwd,exclude)
    overrides=[]
    for i,source in enumerate(sources):
        production_name=source.name.replace('_compat.v','.v')
        if production_name in changed:
            selected=hdl/('SD/'+production_name if production_name in ('sd_card_bmp.v','sd_card_sec_read_write.v') else production_name)
            if shared_mapper and production_name=='fat32_file_sector.v':selected=hdl/'fat32_dual_file_sector.v'
            copy=cwd/('candidate_'+production_name)
            selected_text=selected.read_text(encoding='utf-8-sig')
            transform=None
            if slow_reference and production_name=='top_tf_hdmi_audio.v':
                assert selected_text.count('.SPI_HIGH_SPEED_DIV(0)')==1
                selected_text=selected_text.replace('.SPI_HIGH_SPEED_DIV(0)','.SPI_HIGH_SPEED_DIV(2)')
                transform='Simulation reference only: SPI_HIGH_SPEED_DIV 0 -> 2 with corrected controller'
            if production_name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
                pattern=(r'^\s*wire\s+bmp_write_ready\s*;[^\n]*\n' if production_name=='top_tf_hdmi_audio.v' else r'^\s*reg\s+request_toggle,\s*ack_sync0,\s*ack_sync1\s*;[^\n]*\n')
                declaration=re.search(pattern,selected_text,re.M)
                if declaration:
                    moved=selected_text[:declaration.start()]+selected_text[declaration.end():]
                    anchor=moved.index(';',moved.index('module '))+1
                    selected_text=moved[:anchor]+'\n'+declaration.group().strip()+'\n'+moved[anchor:]
            copy.write_text(selected_text,encoding='utf-8')
            overrides.append(dict(path=str(selected),sha256=common.sha(selected),
                                  reference_path=str(source),reference_sha256=common.sha(source)))
            if transform:overrides[-1]['simulation_transform']=dict(description=transform,copy_sha256=common.sha(copy))
            sources[i]=copy
    assert len(overrides)==len(changed),overrides
    # Require every changed archived production RTL file to be selected explicitly.
    for entry in receipt['inputs']:
        archived=Path(entry['path'])
        if archived.suffix.lower()!='.v' or 'src' not in archived.parts:continue
        selected=candidate/Path(*archived.parts[archived.parts.index('src'):])
        if selected.is_file() and common.sha(selected)!=common.sha(archived):
            assert archived.name in changed, str(selected)
    receipt['candidate_overrides']=overrides
    receipt['shared_mapper']=shared_mapper
    (cwd/'source_receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
    return sources,flags,receipt

common.archived_sources=candidate_sources
text=(FIXTURE/'run_system.py').read_text(encoding='utf-8')
text=text.replace("  manifest=json.loads((Path(receipt['checkpoint'])/'manifest.json').read_text(encoding='utf-8-sig'))", "  manifest=json.loads((Path(receipt['checkpoint'])/'manifest.json').read_text(encoding='utf-8-sig'))\n  if isinstance(manifest,dict):manifest=manifest['files']")
text=text.replace("out=BASE/'integration'/('run_'+a.version+'_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()", "out=Path("+repr(str(output_root))+")/('system_"+('baseline_' if baseline else 'slow_reference_' if slow_reference else 'fast_')+"'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()")
monitor=(Path(__file__).with_name('mapper_caller_contract.vh')).read_text(encoding='utf-8')
performance=(Path(__file__).with_name('spi_performance_monitor.vh')).read_text(encoding='utf-8')
if shared_mapper:
    aliases='''// Physical issued-sector observations; the shared owner is retained through sd_end.
wire perf_bmp_phy_read=dut.arb_card_read && !dut.u_file_mapper.active_client;
wire perf_wav_phy_read=dut.arb_card_read && dut.u_file_mapper.active_client;
wire perf_bmp_phy_end=dut.arb_card_end && !dut.u_file_mapper.active_client;
wire perf_wav_phy_end=dut.arb_card_end && dut.u_file_mapper.active_client;
wire [31:0] perf_bmp_phy_addr=dut.arb_card_addr;
wire [31:0] perf_wav_phy_addr=dut.arb_card_addr;
'''
    for client in ('bmp','wav'):
        for signal in ('read','end','addr'):
            performance=performance.replace('dut.'+client+'_phy_'+signal,'perf_'+client+'_phy_'+signal)
    performance=aliases+performance
performance=performance.replace('EXPECTED_SCLK_NS',str(160 if slow_reference else 80))
monitor+='\n'+performance+'\n'+Path(__file__).with_name('bmp_header_contract.vh').read_text(encoding='utf-8')
if not baseline:
    monitor+='\n'+Path(__file__).with_name('fifo_hold_contract.vh').read_text(encoding='utf-8')
text=text.replace("fixture_paths=list(dict.fromkeys(", "tb.write_text(tb.read_text().replace('endmodule',"+repr(monitor+"\nendmodule")+"))\nfixture_paths=list(dict.fromkeys(")
checks=' check_mapper_contracts; check_spi_performance; check_bmp_header_contract;'
if not baseline: checks+=' check_fifo_hold_contract;'
text=text.replace("    check_pin_scoreboard;", "    check_pin_scoreboard;"+checks)
text=text.replace("fft_result=None", "if status=='SYSTEM_MEDIA_PASS_WITH_MODEL_ASSUMPTIONS':\n import json as _spi_json\n _spi_perf=_spi_json.loads((out/'spi_performance.json').read_text())\n _spi_perf['sclk_target_MHz']="+('6.25' if slow_reference else '12.5')+"\n _spi_perf['variant']='"+('baseline_C11316' if baseline else 'slow_reference_corrected_DIV2' if slow_reference else 'fast_C11317')+"'\n _spi_perf['service_observation']='"+('shared issued physical-sector time' if shared_mapper else 'original per-client physical demand time')+"'\n (out/'spi_performance.json').write_text(_spi_json.dumps(_spi_perf,indent=2))\nfft_result=None")
sys.argv=['run_system_candidate.py','--version','C11312','--clock-model','replay',
          '--max-ms','200','--serial-scoreboard']+sys.argv[1:]
exec(compile(text,str(FIXTURE/'run_system.py'),'exec'))
