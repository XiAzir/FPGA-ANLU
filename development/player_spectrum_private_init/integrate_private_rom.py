from pathlib import Path
import shutil, re

p=Path(__file__).resolve().parent
probe=p.parent/'player_spectrum_private_rom_probe'
hdl=p/'src/user_source/hdl_source'
for name in ('spectrum_coeff_rom.v','gen_private_spectrum_rom.py','spectrum_coeff_rom_manifest.json'):
    shutil.copyfile(probe/'src'/name,hdl/name)
shutil.copyfile(probe/'src/audit_probe_gate_init.py',p/'build/audit/audit_private_rom_init.py')
shutil.copytree(probe/'build',p/'build/audit/private_rom_probe')
shutil.copyfile(probe/'README.md',p/'build/audit/private_rom_probe_README.md')
shutil.copyfile(probe/'sim/tb_coeff_rom.v',p/'sim/tb_coeff_rom.v')
tb=p/'sim/tb_coeff_rom.v'
tb.write_text(tb.read_text().replace('twiddle_gold[511]','twiddle_gold[123]'),encoding='utf-8')
f=hdl/'player_spectrum_analyzer.v'
s=f.read_text(encoding='utf-8-sig')
s=s.replace('    (* rom_style = "bram" *) reg [15:0] hann_rom [0:1023];\n    reg [15:0] hann_q;\n    (* rom_style = "bram" *) reg [31:0] twiddle_rom [0:511];\n    reg [31:0] twiddle_q;', '    wire [15:0] hann_q;\n    wire [31:0] twiddle_q;')
s=s.replace('    initial begin\n        $readmemh(HANN_FILE, hann_rom);\n        $readmemh(TWIDDLE_FILE, twiddle_rom);\n    end', '''    // Explicit local BRAM INIT parameters retain FFT coefficients while the
    // successful player baseline keeps global gate eram_init disabled.
    spectrum_coeff_rom #(.HANN_FILE(HANN_FILE), .TWIDDLE_FILE(TWIDDLE_FILE))
    u_coefficients (
        .clk(clk), .hann_en(state == ST_WIN_REQ), .hann_addr(win_index), .hann_q(hann_q),
        .twiddle_en(state == ST_FFT_ISSUE), .twiddle_addr(twiddle_addr), .twiddle_q(twiddle_q)
    );''')
s=s.replace('            twiddle_q <= twiddle_rom[twiddle_addr];\n','').replace('            hann_q <= hann_rom[win_index];\n','')
assert 'hann_rom' not in s and 'twiddle_rom' not in s
f.write_text(s,encoding='utf-8')
al=p/'src/td_project/AC201_tf_hdmi.al'
s=al.read_text(encoding='utf-8-sig')
entry='''            <File Path="../user_source/hdl_source/spectrum_coeff_rom.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="101"/>
                </FileInfo>
            </File>
'''
s=s.replace('        </Verilog>',entry+'        </Verilog>')
al.write_text(s,encoding='utf-8')
for f in (p/'sim').glob('run_spectrum*.ps1'):
    s=f.read_text(encoding='utf-8-sig')
    s=s.replace('$iverilog -g2012','$iverilog -g2012 -DPRIVATE_ROM_BEHAVIORAL_SIM')
    # Every existing compile passes $rtl; append the independent local ROM.
    lines=s.splitlines()
    for i,line in enumerate(lines):
        if '& $iverilog ' in line:
            before,sep,after=line.partition(' 2>&1')
            lines[i]=before+' (Join-Path $hdl "spectrum_coeff_rom.v")'+sep+after
    f.write_text('\n'.join(lines)+'\n',encoding='utf-8')
f=p/'sim/collect_spectrum_model_result.py'
s=f.read_text(encoding='utf-8-sig')
s=s.replace("'analyzer_rtl':ana,", "'private_coefficient_rom_rtl':HDL/'spectrum_coeff_rom.v',\n      'private_rom_generator':HDL/'gen_private_spectrum_rom.py',\n      'private_rom_manifest':HDL/'spectrum_coeff_rom_manifest.json',\n      'analyzer_rtl':ana,")
s=s.replace('Local Icarus simulation and independent Python gold models; not hardware validation.', 'Local Icarus PRIVATE_ROM_BEHAVIORAL_SIM and independent Python gold models; coefficient primitive INIT audited separately, no official protected primitive simulation or board validation.')
s=s.replace('The simulation loads the checked ROM files; it does not prove TD/FPGA hardware ROM initialization.', 'The simulation defines PRIVATE_ROM_BEHAVIORAL_SIM and loads coefficient files, not the official protected BRAM model; independent gate INIT decoding is required to check hardware coefficient constants.')
f.write_text(s,encoding='utf-8')
print('C11306 private ROM integrated; hardware/behavioral simulation distinction explicit')
