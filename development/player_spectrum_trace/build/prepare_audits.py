from pathlib import Path
import re,json,hashlib,shutil
project=Path(__file__).resolve().parents[1]
repo=project.parents[1]
old=repo/'development/player_spectrum_fft_recover'
audit=project/'build/audit';audit.mkdir(exist_ok=True)
for name in ('audit_clock_route.py','audit_private_rom_init.py','audit_rom_controls.py','export_routed_rom.tcl','prove_rom_polarity.ps1'):
    text=(old/'build/audit'/name).read_text(encoding='utf-8-sig')
    text=text.replace('player_spectrum_fft_recover','player_spectrum_trace').replace('C11310','C11312')
    (audit/name).write_text(text,encoding='utf-8')
def tokens(text):
    return re.findall(r'[^\s]+',re.sub(r'//[^\n]*|/\*.*?\*/','',text,flags=re.S))
result={}
for name in ('player_spectrum_analyzer.v','player_pcm_waveform.v'):
    a=(old/'src/user_source/hdl_source'/name).read_text()
    b=(project/'src/user_source/hdl_source'/name).read_text()
    if name=='player_spectrum_analyzer.v':
        b=b.replace(',\n    output wire [7:0] debug_control','')
        b=b.replace('    assign debug_control={fft_reset,source_change,timeout_pulse,sample_write_en,frame_done,band_valid,debug_coeff_nonzero};\n','')
        a=a.replace('    reg [8:0] twiddle_addr;\n','');b=b.replace('    reg [8:0] twiddle_addr;\n','')
    else:
        b=b.replace(',\n    output wire [7:0] spectrum_debug_control','')
        b=b.replace(',.debug_control(spectrum_debug_control)','')
    result[name]=tokens(a)==tokens(b)
assert all(result.values()),result
scope=[]
for f in (old/'src/user_source').rglob('*'):
    if f.is_file():
        relative=f.relative_to(old/'src/user_source');other=project/'src/user_source'/relative
        if other.exists():
            scope.append({'path':str(relative),'same_bytes':f.read_bytes()==other.read_bytes(),
                          'old_sha256':hashlib.sha256(f.read_bytes()).hexdigest(),'new_sha256':hashlib.sha256(other.read_bytes()).hexdigest()})
changed=[x['path'] for x in scope if not x['same_bytes']]
assert len(changed)==4,changed
evidence={'status':'PASS','functional_token_comparison_after_removing_passive_ports':result,'changed_existing_source_count':4,'added_hdl':'player_fault_snapshot.v','scope':scope}
(audit/'passive_source_scope.json').write_text(json.dumps(evidence,indent=2),encoding='utf-8')
print('PASS passive analyzer/waveform token comparison; exactly four existing source files changed.')
