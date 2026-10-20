from pathlib import Path

p=Path(__file__).resolve().parent
s=(p.parent/'player_spectrum/package_candidate.py').read_text(encoding='utf-8-sig')
s=s.replace("parent=root/'development/player_music_envelope_phy'","parent=root/'development/player_spectrum_baseline_phy'\nbaseline=root/'development/player_bmp_scale'")
s=s.replace('AC201_player_spectrum.bit','AC201_player_spectrum_private_init.bit')
s=s.replace('AC201_player_spectrum.info.json','AC201_player_spectrum_private_init.info.json')
s=s.replace("'spectrum.bit'","'spectrum_private_init.bit'").replace("'spectrum.info.json'","'spectrum_private_init.info.json'")
s=s.replace('download/spectrum.info.json','download/spectrum_private_init.info.json')
s=s.replace('music_spectrum_20261013','music_spectrum_private_init_20261013')
s=s.replace("rom_audit=readj(p/'build/audit/spectrum_rom_init_audit.json')\nassert rom_audit['all_match'] and all(r['mismatches']==0 for r in rom_audit['coefficient_roms'])\nassert sha(manual/'AC201_tf_hdmi_gate.v')==rom_audit['gate_verilog_sha256'].upper()", "rom_audit=readj(p/'build/audit/private_rom_init_audit.json')\nassert rom_audit['all_match'] and rom_audit['eram_init_off']\nassert all(r['mismatches']==0 for r in rom_audit['combined_roms'].values())\nassert sha(manual/'AC201_tf_hdmi_gate.v')==rom_audit['gate_sha256'].upper()\nassert sha(manual/'synthesis_console.log')==rom_audit['synthesis_log_sha256'].upper()")
s=s.replace("stages={}","routed_rom=readj(p/'build/audit/routed_rom_init_audit.json')\nassert routed_rom['all_match'] and routed_rom['eram_init_off']\nassert sha(p/'build/audit/routed_implementation.v')==routed_rom['gate_sha256'].upper()\nassert 'ROUTE_ROM_EXPORT_COMPLETE_READ_ONLY' in (p/'build/audit/routed_export_console.log').read_text(encoding='utf-8')\nstages={}")
s=s.replace("r'HDL-5105|SYN-6562'","r'HDL-5105'")
s=s.replace("{'user_source/hdl_source/player_pcm_waveform.v','user_source/hdl_source/top_tf_hdmi_audio.v','user_source/hdl_source/player_status_monitor.v'}","{'user_source/hdl_source/player_spectrum_analyzer.v','user_source/hdl_source/top_tf_hdmi_audio.v','user_source/hdl_source/player_status_monitor.v'}")
s=s.replace("==sha(parent/'src/user_source/hdl_source'/name)","==sha(baseline/'src/user_source/hdl_source'/name)")
s=s.replace("'version':'C11304'","'version':'C11306'")
s=s.replace("'parent':'C11303 PHY candidate; not certified as full board baseline'","'parent':'C11305 failed board candidate; global ERAM init restored off, coefficients use four explicit local EG_PHY_BRAM INIT banks'")
s=s.replace("'parent':'C11303'","'parent':'C11305'")
s=s.replace("'gateInitialization':'eram_init on; all Hann and twiddle gate INIT words verified'","'gateInitialization':'eram_init off globally; explicit local coefficient INIT/INITP verified, behavioral simulation does not use protected vendor primitives'")
s=s.replace("'gateRomAudit':rom_audit,","'gateRomAudit':rom_audit,'routedRomAudit':routed_rom,")
s=s.replace("# C11304 真实音乐频谱柱候选（实板待验证）","# C11306 频谱柱：局部系数初始化（实板待验证）")
s=s.replace("从实际播放PCM计算1024点Hann窗FFT，显示24频段幅值柱。","C11305默认只有UI、BMP/WAV读取超时，长KEY1切tone后接收器无信号。此版恢复成功C11206的global eram_init off，改用仅频谱的四块显式BRAM INIT/INITP，1536系数逐字验证；PHY、PLL、复位、TF/音频和频谱UI保持。初始化设置是隔离变量，尚未证实为唯一实物原因。\n\n从实际播放PCM计算1024点Hann窗FFT，显示24频段幅值柱。")
s=s.replace('Add spectrum.bit','Add spectrum_private_init.bit').replace('DFC11304','DFC11306')
s=s.replace('本地独立算法/像素/控制模型和最终原约束时序通过；','本地独立算法/像素/控制模型（PRIVATE_ROM_BEHAVIORAL_SIM）和最终原约束时序通过；官方受保护BRAM原语不能由Icarus仿真，初始化另外以正式gate INIT解码核对；')
s=s.replace("for folder in ('download','deliverables'):",'''assert sha(root/'download/spectrum_baseline_phy.bit')=='768B510C951E5A12EE6F062CDFE053885D1DB6A4B9DDBFFE63944E96A082DE1F'
assert sha(root/'deliverables/music_spectrum_baseline_phy_20261013.zip')=='DFA9B4306712D261CD8D2BD9FEF41063E98629D10EA0E6D648DAEFBBDA5428D0'
assert sha(p/'src/user_source/hdl_source/player_pcm_waveform.v')==sha(parent/'src/user_source/hdl_source/player_pcm_waveform.v')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    assert (p/'src/user_source/hdl_source'/name).read_text(encoding='utf-8-sig').replace('C11306','C11305')==(parent/'src/user_source/hdl_source'/name).read_text(encoding='utf-8-sig')
assert {d['path'] for d in added}=={'user_source/hdl_source/spectrum_coeff_rom.v','user_source/hdl_source/gen_private_spectrum_rom.py','user_source/hdl_source/spectrum_coeff_rom_manifest.json'}
assert '<eram_init>on</eram_init>' not in (p/'src/td_project/AC201_tf_hdmi.al').read_text(encoding='utf-8-sig')
assert 'PASS: 1024 Hann + 512 twiddle synchronous reads and disabled hold' in (p/'build/model/coeff_rom_run.log').read_text(encoding='utf-8')
for folder in ('download','deliverables'):''')
(p/'package_candidate.py').write_text(s,encoding='utf-8')
print('C11306 package gates prepared, no publication yet')
