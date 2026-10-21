from pathlib import Path
from mapper_aligned_proposal import apply as mapper_apply
from waveform_flags_proposal import build_flags_proposal

ROOT=Path(__file__).resolve().parents[2]
old=ROOT/'development/player_spectrum_trace/src/user_source/hdl_source'
hdl=ROOT/'development/player_spectrum_resource_fit/src/user_source/hdl_source'
p=hdl/'fat32_file_sector.v';p.write_bytes((old/p.name).read_bytes());mapper_apply(p)
p=hdl/'player_pcm_waveform.v'
wave=build_flags_proposal((old/p.name).read_text(encoding='utf-8')).replace('module player_pcm_waveform_flags_proposal #(', 'module player_pcm_waveform #(')
wave=wave.replace('    wire source_vsync_clear=vs_rise && source_waiting;\n','')
wave=wave.replace('    reg [4:0] column_index;\n','')
wave=wave.replace("        column_index=(x_pos>=128 && x_pos<512)?plot_x[8:4]:5'd0;\n",'')
p.write_text(wave,encoding='utf-8')
for name in ('top_tf_hdmi_audio.v','player_status_monitor.v'):
    p=hdl/name;s=p.read_text(encoding='utf-8-sig')
    assert s.count("24'hC11312")==1,(name,'build ID')
    p.write_text(s.replace("24'hC11312","24'hC11313"),encoding='utf-8')

# The existing diagnostic runner described its old unchanged-source baseline.
# Give new candidate evidence the correct scope description.
p=ROOT/'development/player_spectrum_resource_fit/sim/run_bmp_failure_detail.ps1'
s=p.read_text(encoding='utf-8-sig').replace('RTL unchanged; public pin-level','Selected candidate RTL; public pin-level')
p.write_text(s,encoding='utf-8')
print('C11313 final candidate prepared')
