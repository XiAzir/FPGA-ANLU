from pathlib import Path
import hashlib,json
root=Path(__file__).resolve().parent
active=Path(__file__).resolve().parents[2]/'development/player_spectrum_resource_80/src/user_source/hdl_source'
runroot=root/'synthesis'
if runroot.exists() and any(runroot.iterdir()): raise SystemExit(f'{runroot} already nonempty')

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def project(al,name,top,files):
    lines=[]
    for i,f in enumerate(files,1):
        lines.append(f'''            <File Path="../hdl_source/{f}"><FileInfo><Attr Name="UsedInSyn" Val="true"/><Attr Name="UsedInP&amp;R" Val="true"/><Attr Name="BelongTo" Val="design_1"/><Attr Name="CompileOrder" Val="{i}"/></FileInfo></File>''')
    return f'''<?xml version="1.0" encoding="UTF-8"?>\n<Project Version="3" Minor="2" Path="{al.parent.resolve().as_posix()}"><TD_Version>6.2.178840</TD_Version><Name>{name}</Name><HardWare><Family>EG4</Family><Device>EG4S20BG256</Device></HardWare><Source_Files><Verilog>{''.join(lines)}</Verilog></Source_Files><FileSets><FileSet Name="design_1" Type="DesignFiles"/><FileSet Name="constraint_1" Type="ConstrainFiles"/></FileSets><TOP_MODULE><LABEL>{top}</LABEL><MODULE>{top}</MODULE><CREATEINDEX>user</CREATEINDEX></TOP_MODULE><Runs><Run Name="syn_1" Type="Synthesis" ConstraintSet="constraint_1" Active="true"><Strategy Name="Default_Synthesis_Strategy"/></Run></Runs></Project>\n'''
def tcl(top):
 return f'''set variant_root [file normalize [file join [file dirname [info script]] .]]\nset project_dir [file join $variant_root td_project]\nset report_dir [file join $variant_root reports]\nfile mkdir $report_dir\ncd $project_dir\nif {{[catch {{\n import_device eagle_s20.db -package EG4S20BG256\n open_project [file join $project_dir bmp.al] -single_run\n load_run_param -run syn_1\n elaborate -top {top}\n read_sdc ../standalone.sdc\n commit_param -step rtl\n optimize_rtl\n commit_param -step gate\n optimize_gate -packarea [file join $report_dir gate.area]\n}} message]}} {{puts "BUILD_ERROR: $message"; exit 1}}\nputs SYNTHESIS_COMPLETE\nclose_project\nexit\n'''
variants=[('engine_base','bmp_scale_engine','bmp_scale_engine.v',root/'bmp_scale_engine.base.v'),('engine_rowstep','bmp_scale_engine','bmp_scale_engine.v',root/'bmp_scale_engine.rowstep.v')]
manifest={'device':'EG4S20BG256','period_ns':20,'variants':{}}
for n,top,source,engine in variants:
 folder=runroot/n; hd=folder/'hdl_source'; td=folder/'td_project';hd.mkdir(parents=True);td.mkdir()
 (hd/source).write_bytes(engine.read_bytes())
 al=td/'bmp.al'; al.write_text(project(al,'bmp_'+n,top,[source]),encoding='utf-8')
 (folder/'standalone.sdc').write_text('create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]\n')
 (folder/'run_syn.tcl').write_text(tcl(top),encoding='ascii')
 manifest['variants'][n]={'source_sha256':sha(hd/source),'tcl':str((folder/'run_syn.tcl').resolve()),'area':str((folder/'reports/gate.area').resolve())}
(runroot/'input_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(runroot)
for n,v in manifest['variants'].items(): print(n,v['source_sha256'])
