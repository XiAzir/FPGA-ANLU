from pathlib import Path
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent
def adapt(s):return s.replace('player_spectrum_arch17','player_spectrum_ctrl18').replace('spectrum_arch17.bit','spectrum_ctrl18.bit').replace('C11317_arch17_20261021_offline','C11318_ctrl18_20261021_offline').replace('C11317','C11318').replace('arch17_work','ctrl18_work')
p=W/'verify_final_binding.py';s=adapt((R/'development/arch17_work/verify_final_binding.py').read_text(encoding='utf-8-sig'))
s=s.replace('assert len(changes)==12','assert len(changes)==14').replace('assert slices<7584,slices','assert slices<7050,slices')
p.write_text(s,encoding='utf-8')
p=W/'freeze_resource_candidate.py';s=p.read_text(encoding='utf-8-sig').replace('baseline/C11316_source_sha256.json','baseline/C11317_source_sha256.json').replace('system_baseline_C11316','system_baseline_C11317');p.write_text(s,encoding='utf-8')
p=W/'collect_ablation.py';s=adapt((R/'development/arch17_work/collect_ablation.py').read_text(encoding='utf-8-sig'))
s=s.replace("P=R/'development/player_spectrum_opt16'","P=R/'development/player_spectrum_arch17'").replace('baseline_C11316','baseline_C11317').replace('7584','7231')
s=s.replace("('mapper_lifetime','codec','codec_hold','catalog_storage','scaler_lifetime','shared_mapper','mapper_tests')","('key_events','status_domain','integration_audit')")
s=s.replace("'slice_saved':7231-slices","'slice_saved':7231-slices,'slice_saved_vs_same_id_control':7050-slices")
p.write_text(s,encoding='utf-8')
print('Final helpers prepared')
