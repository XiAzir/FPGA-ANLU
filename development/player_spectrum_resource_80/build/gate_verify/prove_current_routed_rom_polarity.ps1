param([Parameter(Mandatory)][string]$RunId,[Parameter(Mandatory)][string]$PhysicalRunId)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$root = Join-Path $root 'development/player_spectrum_resource_80'
$outDir = Join-Path $root 'build/audit'
$stageEvidenceDir = Join-Path $root 'build/manual/stage_evidence'
$latestPath = Join-Path $stageEvidenceDir 'latest_synthesis.json'
$latest = Get-Content -LiteralPath $latestPath -Raw | ConvertFrom-Json
if ($latest.stage -ne 'synthesis' -or $latest.status -ne 'success' -or $latest.runId -ne $RunId) {
    throw "Requested success runId $RunId does not match latest synthesis pointer"
}
$recordPath = Join-Path $stageEvidenceDir $latest.record
$record = Get-Content -LiteralPath $recordPath -Raw | ConvertFrom-Json
if ($record.stage -ne 'synthesis' -or $record.status -ne 'success' -or $record.runId -ne $RunId) {
    throw "Synthesis record does not match requested runId $RunId"
}
$routedPath = Join-Path $root 'build/audit/routed_implementation.v'
$gateDbPath = Join-Path $root 'build/manual/AC201_tf_hdmi_gate.db'
if ((Get-FileHash -LiteralPath $gateDbPath -Algorithm SHA256).Hash.ToLower() -ne $record.gateDbHash) {
    throw 'Current gate database hash differs from successful synthesis record'
}
foreach ($artifact in @('routed_rom_control_proof.json','routed_rom_control_proof_verified.json','routed_rom_control_proof.md')) {
    Remove-Item -LiteralPath (Join-Path $outDir $artifact) -Force -ErrorAction SilentlyContinue
}

$bound = [ordered]@{
    routed_rom_control = 'build/audit/routed_rom_control.json'
    routed_netlist = 'build/audit/routed_implementation.v'
    analyzer_rtl = 'src/user_source/hdl_source/player_spectrum_analyzer.v'
    coeff_rom_rtl = 'src/user_source/hdl_source/spectrum_coeff_rom.v'
    manifest = 'src/user_source/hdl_source/spectrum_coeff_rom_manifest.json'
    proof_script = 'build/gate_verify/prove_current_routed_rom_polarity.ps1'
}
$proofCode = @'
import itertools, json, pathlib, re, sys, hashlib

root = pathlib.Path(sys.argv[1])
run_id = sys.argv[2]
physical_run_id = sys.argv[3]
audit = root / 'build' / 'audit'
synthesis_marker_path=root/'build/manual/stage_evidence/latest_synthesis.json'
synthesis_marker=json.loads(synthesis_marker_path.read_text(encoding='utf-8-sig'))
if synthesis_marker.get('stage')!='synthesis' or synthesis_marker.get('status')!='success' or synthesis_marker.get('runId')!=run_id:
    raise SystemExit('latest successful synthesis marker differs from requested runId')
synthesis_record_path=synthesis_marker_path.parent/synthesis_marker['record']
synthesis_record=json.loads(synthesis_record_path.read_text(encoding='utf-8-sig'))
if synthesis_record.get('stage')!='synthesis' or synthesis_record.get('status')!='success' or synthesis_record.get('runId')!=run_id:
    raise SystemExit('synthesis record differs from requested runId')
gate_db_path=root/'build/manual/AC201_tf_hdmi_gate.db'
if hashlib.sha256(gate_db_path.read_bytes()).hexdigest()!=synthesis_record.get('gateDbHash'):
    raise SystemExit('gate database SHA differs from synthesis record')
physical_marker_path=root/'build/manual/stage_evidence/latest_physical.json'
physical_marker=json.loads(physical_marker_path.read_text(encoding='utf-8-sig'))
if physical_marker.get('stage')!='physical' or physical_marker.get('status')!='success' or physical_marker.get('runId')!=physical_run_id:
    raise SystemExit('latest successful physical marker differs from requested runId')
physical_record_path=physical_marker_path.parent/physical_marker['record']
physical_record=json.loads(physical_record_path.read_text(encoding='utf-8-sig'))
if physical_record.get('stage')!='physical' or physical_record.get('status')!='success' or physical_record.get('runId')!=physical_run_id or physical_record.get('synthesisRunId')!=run_id:
    raise SystemExit('physical record is not linked to selected synthesis/physical IDs')
if physical_record.get('scopeHash')!=synthesis_record.get('scopeHash') or physical_record.get('gateDbHash')!=synthesis_record.get('gateDbHash'):
    raise SystemExit('physical record scope or gate DB hash differs from synthesis record')
route_db_path=root/'build/manual/AC201_tf_hdmi_pr.db'
if hashlib.sha256(route_db_path.read_bytes()).hexdigest()!=physical_record.get('artifacts',{}).get('AC201_tf_hdmi_pr.db'):
    raise SystemExit('current routed database SHA differs from selected physical record')
routed_path=audit/'routed_implementation.v'
from datetime import datetime
if routed_path.stat().st_mtime < datetime.fromisoformat(physical_record['completedUtc'].replace('Z','+00:00')).timestamp():
    raise SystemExit('exported routed netlist predates selected physical completion')

def split_top(text):
    text = text.strip()
    if text.startswith('{') and text.endswith('}'):
        text = text[1:-1]
    out, start, depth = [], 0, 0
    for i, ch in enumerate(text):
        if ch == '{': depth += 1
        elif ch == '}': depth -= 1
        elif ch == ',' and depth == 0:
            out.append(text[start:i].strip()); start = i + 1
    if text[start:].strip(): out.append(text[start:].strip())
    return out

def expand_atom(atom):
    atom = atom.strip()
    m = re.fullmatch(r"(\d+)'[bB]([01xXzZ]+)", atom)
    if m:
        width, digits = int(m.group(1)), m.group(2).lower()
        digits = digits.rjust(width, '0')[-width:]
        return ["1'b" + x for x in digits]
    m = re.fullmatch(r"(.*?)\s+\[(\d+):(\d+)\]", atom)
    if m:
        base, hi, lo = m.group(1).strip().lstrip('\\'), int(m.group(2)), int(m.group(3))
        step = -1 if hi >= lo else 1
        return [f'{base}[{n}]' for n in range(hi, lo + step, step)]
    m = re.fullmatch(r"(.*?)\s+\[(\d+)\]", atom)
    if m: return [f'{m.group(1).strip().lstrip(chr(92))}[{m.group(2)}]']
    return [atom.lstrip('\\').strip()]

def lanes(expr):
    atoms = split_top(expr)
    flat = []
    for atom in atoms: flat.extend(expand_atom(atom))
    # Verilog vector lane 0 is the rightmost/least-significant item.
    lsb_first = list(reversed(flat))
    if len(lsb_first) == 1: lsb_first.append("1'b0")
    return lsb_first[:2]

def parse_params(text):
    return {m.group(1): (m.group(2) or m.group(3)).strip()
            for m in re.finditer(r'\.([A-Za-z0-9_]+)\s*\(\s*(?:"([^"]*)"|([^)]*))\)', text)}

def parse_ports(text):
    return {m.group(1): m.group(2).strip()
            for m in re.finditer(r'\.([A-Za-z0-9_]+)\s*\(([^)]*)\)', text)}

cell_re = re.compile(r'(?ms)^\s*(?P<typ>(?:AL_MAP|EG_PHY)_[A-Z0-9_]+)\s*#\s*\((?P<params>.*?)\)\s*(?P<inst>\\[^\r\n]+?)\s*\((?P<ports>.*?)\)\s*;')

def int_literal(text):
    m = re.fullmatch(r"\s*\d+'([bBoOdDhH])([0-9a-fA-F_xXzZ]+)\s*", text)
    if not m: return None
    base = {'b':2,'o':8,'d':10,'h':16}[m.group(1).lower()]
    digits = m.group(2).replace('_','')
    if any(c in digits.lower() for c in 'xz'): return None
    return int(digits, base)

def expand_bus(expr):
    flat=[]
    for atom in split_top(expr): flat.extend(expand_atom(atom))
    return flat

class Netlist:
    def __init__(self, path):
        self.path = path
        self.text = path.read_text(encoding='utf-8', errors='replace')
        self.drivers = {}
        self.duplicates = set()
        self.cells = []
        self.q_outputs = []
        for match in cell_re.finditer(self.text):
            typ, params, inst, ports = match.group('typ'), parse_params(match.group('params')), match.group('inst').strip(), parse_ports(match.group('ports'))
            cell = {'typ':typ, 'params':params, 'inst':inst, 'ports':ports, 'inputs':{}}
            self.cells.append(cell)
            if 'q' in ports:
                self.q_outputs.extend((net, cell) for net in expand_bus(ports['q']))
            for pin in ('a','b','c','d','e'):
                if pin in ports: cell['inputs'][pin] = lanes(ports[pin])
            if typ.startswith('AL_MAP_LUT'):
                if 'o' in ports:
                    output = expand_atom(ports['o'])[0]
                    cell['lut'] = int_literal(params.get('INIT',''))
                    cell['lut_pins'] = [x for x in ('a','b','c','d','e') if x in ports]
                    self.add(output, cell)
            elif typ.startswith('EG_PHY_'):
                for output_pin, family in (('f','LUT'),('fx','LUTG')):
                    if output_pin not in ports: continue
                    outs = lanes(ports[output_pin])
                    for lane, output in enumerate(outs):
                        key = family + str(lane) if family == 'LUT' else 'INIT_LUTG' + str(lane)
                        if family == 'LUT':
                            lut_key = 'INIT_LUT' + str(lane)
                            if typ.endswith('LSLICE'): lut_key = 'INIT_LUTF' + str(lane)
                        else: lut_key = 'INIT_LUTG' + str(lane)
                        if output.startswith("1'b"): continue
                        mode_key = ('LSFMUX' if output_pin == 'f' else 'LSFGMUX') + str(lane)
                        mode = params.get(mode_key)
                        if typ.endswith('LSLICE') and mode not in (None, 'FUNC5'):
                            cell_copy = dict(cell); cell_copy['unsupported_mode'] = mode
                        else: cell_copy = dict(cell)
                        cell_copy['lane'] = lane
                        cell_copy['lut'] = int_literal(params.get(lut_key,''))
                        cell_copy['lut_g'] = int_literal(params.get('INIT_LUTG' + str(lane),'')) if typ.endswith('LSLICE') and output_pin == 'f' else None
                        cell_copy['lut_pins'] = ['a','b','c','d','e'] if typ.endswith('LSLICE') else ['a','b','c','d']
                        self.add(output, cell_copy)
        
    def add(self, output, cell):
        if output in self.drivers:
            self.duplicates.add(output)
        self.drivers[output] = cell

    def source(self, net, lane=0):
        if net in self.duplicates: raise ValueError(f'multiple drivers for {net}')
        cell = self.drivers.get(net)
        if cell is None: return None
        if cell.get('unsupported_mode'): raise ValueError(f"unsupported {cell['typ']} mode {cell['unsupported_mode']} driving {net}")
        if cell['lut'] is None: raise ValueError(f"no LUT INIT for {net} from {cell['inst']}")
        bits = []
        pins = ('a','b','c','d') if cell['typ'].endswith('LSLICE') else cell['lut_pins']
        for pin in pins:
            pin_lanes = cell['inputs'].get(pin, ["1'b0", "1'b0"])
            expr = pin_lanes[cell.get('lane',0)] if cell['typ'].startswith('EG_PHY_') else pin_lanes[0]
            bits.append(expr)
        if cell['typ'].endswith('LSLICE'):
            e_lanes=cell['inputs'].get('e',["1'b0","1'b0"])
            bits.append(e_lanes[cell.get('lane',0)])
        return cell, bits

    def leaves(self, net, visiting=None):
        if visiting is None: visiting=set()
        if net in visiting: raise ValueError('combinational loop at '+net)
        if re.fullmatch(r"(?:.*/)?debug_progress\[(1[9]|2[0-3])\]",net): return set()
        if net.startswith("1'b"): return set()
        if net.lower().startswith('open') or net.lower()=='open': return {net}
        src=self.source(net)
        if src is None: return {net}
        cell, exprs=src; result=set(); visiting=visiting|{net}
        for expr in exprs:
            result |= self.leaves(expand_atom(expr)[0], visiting)
        return result

    def evaluate(self, net, state, assigns, visiting=None):
        if visiting is None: visiting=set()
        if net in visiting: raise ValueError('combinational loop at '+net)
        m=re.fullmatch(r'(?:.*/)?debug_progress\[(\d+)\]',net)
        if m and 19 <= int(m.group(1)) <= 23: return (state >> (int(m.group(1))-19)) & 1
        m=re.fullmatch(r"1'b([01])",net)
        if m: return int(m.group(1))
        if net in assigns: return assigns[net]
        src=self.source(net)
        if src is None: raise ValueError('unresolved leaf '+net)
        cell, exprs=src
        if cell['typ'].endswith('LSLICE'):
            index=0
            for bit,expr in enumerate(exprs[:4]):
                index |= self.evaluate(expand_atom(expr)[0],state,assigns,visiting|{net}) << bit
            f=(cell['lut'] >> index) & 1
            g=(cell['lut_g'] >> index) & 1 if cell['lut_g'] is not None else f
            e=self.evaluate(expand_atom(exprs[4])[0],state,assigns,visiting|{net}) if len(exprs)>4 else 0
            return g if e else f
        index=0
        for bit, expr in enumerate(exprs):
            index |= self.evaluate(expand_atom(expr)[0], state, assigns, visiting|{net}) << bit
        return (cell['lut'] >> index) & 1

def truth(netlist, net, invert, expected_state):
    leaves=netlist.leaves(net)
    if len(leaves)>12: raise ValueError(f'{net} cone has {len(leaves)} independent leaves: {sorted(leaves)}')
    rows=[]; all_ok=True
    for state in range(32):
        values=set()
        for choices in itertools.product((0,1), repeat=len(leaves)):
            values.add(invert ^ netlist.evaluate(net,state,dict(zip(sorted(leaves),choices))))
        expected = state == expected_state
        value = next(iter(values)) if len(values)==1 else None
        if value is None or value != expected: all_ok=False
        rows.append({'state':state,'state_bits':'0b'+format(state,'05b'),'expected':expected,'effective':value,'independent_leaves':len(leaves),'leaves':sorted(leaves)})
    return rows, all_ok, sorted(leaves)

routed=Netlist(routed_path)
netlists={'routed':routed}
raw_reports={kind:json.loads((audit/f'{kind}_rom_control.json').read_text(encoding='utf-8-sig')) for kind in netlists}
problems=[]

def require(condition, message):
    if not condition: problems.append(message)

def norm_net(text):
    return expand_atom(text.strip())[0]

def find_rom(nl, bank):
    matches=[c for c in nl.cells if c['typ']=='EG_PHY_BRAM' and c['inst'].lstrip('\\').rstrip().endswith('/u_coefficients/u_'+bank)]
    if len(matches)!=1: raise ValueError(f'{nl.path}: expected one EG_PHY_BRAM for {bank}, found {len(matches)}')
    return matches[0]

def mux_inverts(mode):
    if mode=='INV': return True
    if mode in ('SIG','1','0'): return False
    raise ValueError('unsupported control mux mode '+str(mode))

def actual_port_control(cell, port, bit=None):
    if port not in cell['ports']: raise ValueError(f"{cell['inst']} lacks .{port}")
    signals=expand_bus(cell['ports'][port])
    if bit is None:
        if len(signals)!=1: raise ValueError(f"{cell['inst']}.{port} expected scalar, got {signals}")
        return signals[0]
    if len(signals)<=bit: raise ValueError(f"{cell['inst']}.{port} missing bit {bit}: {signals}")
    # expand_bus returns MSB-to-LSB order, so bit N indexes len-N-1.
    return signals[len(signals)-bit-1]

def validate_source():
    src=(root/'src/user_source/hdl_source/player_spectrum_analyzer.v').read_text(encoding='utf-8')
    checks={
      'ST_WIN_REQ':r'\bST_WIN_REQ\s*=\s*4\s*\x27\s*[dD]\s*1\b',
      'ST_FFT_ISSUE':r'\bST_FFT_ISSUE\s*=\s*4\s*\x27\s*[dD]\s*4\b',
      'hann enable':r'\.hann_en\s*\(\s*state\s*==\s*ST_WIN_REQ\s*\)',
      'twiddle enable':r'\.twiddle_en\s*\(\s*state\s*==\s*ST_FFT_ISSUE\s*\)',
      'debug state alias':r'assign\s+debug_progress\s*=\s*\{\s*state\s*,\s*sample_count\s*,\s*win_index\s*\[\s*8\s*:\s*0\s*\]\s*\}',
    }
    for name,pat in checks.items(): require(re.search(pat,src)!=None,'source condition not verified: '+name)
    return checks

source_checks=validate_source()
for kind,nl in netlists.items():
    raw=raw_reports[kind]
    digest=hashlib.sha256(nl.path.read_bytes()).hexdigest()
    require(raw.get('netlist_sha256')==digest,f'{kind}: raw audit netlist hash differs from bound netlist')
    require(raw.get('status') in ('PASS','FAIL'),f'{kind}: raw strict audit status is missing or invalid')
    calculated='FAIL' if any(v.get('mismatches',{}) for v in raw.get('banks',{}).values()) else 'PASS'
    require(raw.get('status')==calculated,f'{kind}: strict status does not match recorded parameter differences')
    qmap={}
    for net,cell in nl.q_outputs:
        m=re.fullmatch(r'u_pcm_waveform/u_spectrum/debug_progress\[(\d+)\]',net)
        if m and 19<=int(m.group(1))<=23: qmap.setdefault(int(m.group(1)),[]).append(cell)
    for bit in range(19,24):
        cells=qmap.get(bit,[])
        require(len(cells)==1,f'{kind}: debug_progress[{bit}] must be driven by exactly one FF Q, found {len(cells)}')
        if cells:
            c=cells[0]
            require(c['typ'] in ('AL_MAP_SEQ','EG_PHY_MSLICE','EG_PHY_LSLICE'),f'{kind}: unexpected state Q cell type {c["typ"]}')
            if c['typ'].startswith('EG_PHY_'): require(c['params'].get('DFFMODE')=='FF',f'{kind}: progress[{bit}] Q cell is not DFFMODE FF')

bank_results={}
expected_bank_names={'hann_low','hann_high','twiddle_low','twiddle_high'}
for kind,nl in netlists.items():
    raw=raw_reports[kind]
    require(set(raw.get('banks',{}))==expected_bank_names,f'{kind}: raw report bank set unexpected')
    for bank in sorted(expected_bank_names):
        is_hann=bank.startswith('hann')
        mismatch=raw['banks'][bank].get('mismatches',{})
        cell=find_rom(nl,bank)
        for param,value in raw['banks'][bank].get('actual',{}).items():
            require(cell['params'].get(param)==value,f'{kind}/{bank}: primitive {param}={cell["params"].get(param)!r}, raw audit says {value!r}')
        coeff='hann' if is_hann else 'twiddle'
        expected_state=1 if is_hann else 4
        port_specs=[('cea',None,'CEAMUX')] if is_hann else [('csa',2,'CSA2'),('csb',2,'CSB2')]
        port_results=[]
        for port,bit,mux_param in port_specs:
            signal=actual_port_control(cell,port,bit)
            mux=cell['params'].get(mux_param)
            require(mux in ('SIG','INV'),f'{kind}/{bank}: {mux_param} is {mux}, expected signal or inverted-signal mux')
            rows,ok,leaves=truth(nl,signal,mux_inverts(mux),expected_state)
            require(ok,f'{kind}/{bank}.{port}: per-state enable does not equal source state condition')
            port_results.append({'port':port if bit is None else f'{port}[{bit}]','net':signal,'mux_parameter':mux_param,'mux_value':mux,'inverted':mux_inverts(mux),'truth_table':rows,'enumerated_open_or_leaf_inputs':leaves,'passes':ok})
        bank_results[(kind,bank)]={'ports':port_results,'passes':all(r['passes'] for r in port_results),'primitive':cell['inst'].lstrip('\\').rstrip(),'primitive_params':{p:cell['params'].get(p) for _,_,p in port_specs}}

bound_rel={
 'routed_rom_control':'build/audit/routed_rom_control.json',
 'routed_netlist':'build/audit/routed_implementation.v',
 'analyzer_rtl':'src/user_source/hdl_source/player_spectrum_analyzer.v','coeff_rom_rtl':'src/user_source/hdl_source/spectrum_coeff_rom.v',
 'manifest':'src/user_source/hdl_source/spectrum_coeff_rom_manifest.json',
 'synthesis_marker':'build/manual/stage_evidence/latest_synthesis.json','synthesis_record':str(synthesis_record_path.relative_to(root)).replace('\\','/'),
 'physical_marker':'build/manual/stage_evidence/latest_physical.json','physical_record':str(physical_record_path.relative_to(root)).replace('\\','/'),
 'gate_database':'build/manual/AC201_tf_hdmi_gate.db','route_database':'build/manual/AC201_tf_hdmi_pr.db','proof_script':'build/gate_verify/prove_current_routed_rom_polarity.ps1'}
bound_files=[{'path':str((root/rel).resolve()),'sha256':hashlib.sha256((root/rel).read_bytes()).hexdigest()} for rel in bound_rel.values()]
proof_banks={kind:{} for kind in netlists}
for kind in netlists:
    for bank in sorted(expected_bank_names):
        r=bank_results[(kind,bank)]
        proof_banks[kind][bank]={
          'raw_mismatches':raw_reports[kind]['banks'][bank]['mismatches'],
          'primitive':r['primitive'],'primitive_parameters':r['primitive_params'],
          'port_proofs':r['ports'],'verdict':'PASS_POLARITY_EQUIVALENT' if r['passes'] else 'FAIL'}

status='PASS' if not problems else 'FAIL'
evidence={
 'schema':'rom-polarity-evidence-v2','status':status,
 'synthesis_run_id':run_id,'physical_run_id':physical_run_id,
 'synthesis_marker':str(synthesis_marker_path.resolve()),'synthesis_marker_sha256':hashlib.sha256(synthesis_marker_path.read_bytes()).hexdigest(),
 'synthesis_record':str(synthesis_record_path.resolve()),'synthesis_record_sha256':hashlib.sha256(synthesis_record_path.read_bytes()).hexdigest(),
 'gate_database_sha256':hashlib.sha256(gate_db_path.read_bytes()).hexdigest(),
 'physical_marker':str(physical_marker_path.resolve()),'physical_marker_sha256':hashlib.sha256(physical_marker_path.read_bytes()).hexdigest(),
 'physical_record':str(physical_record_path.resolve()),'physical_record_sha256':hashlib.sha256(physical_record_path.read_bytes()).hexdigest(),
 'route_database_sha256':hashlib.sha256(route_db_path.read_bytes()).hexdigest(),
 'conclusion':'All four coefficient BRAM instances in the current routed netlist have actual control-pin LUT and mux polarity whose effective values match the RTL request for every state and open input.' if status=='PASS' else 'One or more instance, source, raw-mismatch, state-FF, or truth-table assertions failed.',
 'bound_files':bound_files,
 'source_conditions':{'ST_WIN_REQ_value':1,'ST_FFT_ISSUE_value':4,'RTL_enable_connections_verified':True,'state_debug_alias':'debug_progress[23:19] = state[4:0]'},
 'state_ff_q_bindings':{kind:{str(bit):{'q_cell_type':qmap[bit][0]['typ'],'instance':qmap[bit][0]['inst'].lstrip('\\').rstrip(),'dffmode':qmap[bit][0]['params'].get('DFFMODE')} for bit in range(19,24) if len(qmap.get(bit,[]))==1} for kind,nl in netlists.items()},
 'netlists':{kind:{'netlist_sha256':hashlib.sha256(nl.path.read_bytes()).hexdigest(),'raw_audit_status':raw_reports[kind]['status'],'banks':proof_banks[kind]} for kind,nl in netlists.items()},
 'raw_mismatch_policy':{'strict_status':raw_reports['routed']['status'],'recorded_mismatches':{bank:raw_reports['routed']['banks'][bank].get('mismatches',{}) for bank in sorted(expected_bank_names)},'status_matches_reported_mismatches':raw_reports['routed']['status']==('FAIL' if any(raw_reports['routed']['banks'][bank].get('mismatches',{}) for bank in expected_bank_names) else 'PASS'),'no_mismatch_allowlist_used':True},
 'parser_method':'Resolves each EG_PHY_BRAM .cea/.csa[2]/.csb[2] actual connection; derives polarity from its mux parameter; recursively parses per-lane f/fx LUTs with concat rightmost lane0 and LUT index {d,c,b,a}; enumerates every open or unresolved leaf over 0/1; verifies each debug_progress[19:23] has exactly one FF Q driver.',
 'failures':problems
}
evidence_path=audit/'routed_rom_control_proof.json'
evidence_path.write_text(json.dumps(evidence,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
evidence_sha=hashlib.sha256(evidence_path.read_bytes()).hexdigest()
verified={'status':status,'evidence_sha256':evidence_sha,'bound_files':bound_files,'reason':'Every source, FF-Q, actual BRAM-port, mux-parameter, raw-mismatch, and 32-state assertion passed.' if status=='PASS' else 'At least one source, strict-report binding, actual pin, mux, or exhaustive truth-table assertion failed; inspect the evidence JSON failures array.'}
(audit/'routed_rom_control_proof_verified.json').write_text(json.dumps(verified,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
md='# C11314 routed ROM control proof\n\n'
md+=f'**Result: {status}.** '+('The actual routed pin mux and LUT cones produce the active-high RTL enable for all 32 states. The strict parameter report is retained verbatim; any SIG/INV differences are documented from the current routed netlist and are accepted only when the exhaustive effective-control proof passes.\n\n' if status=='PASS' else 'The proof did not satisfy every required assertion.\n\n')
md+='The script verifies the RTL state constants and enable expressions, confirms the state FF Qs drive `debug_progress[19:23]`, reads each coefficient BRAM instance\'s actual control port and mux parameter, records strict SIG/INV differences without a mismatch whitelist, then enumerates all 32 state values and every open/leaf input assignment.\n\n'
for (kind,bank),r in sorted(bank_results.items()):
    port_summaries=[f"{p['port']}={p['net']} with {p['mux_parameter']}={p['mux_value']} -> {'PASS' if p['passes'] else 'FAIL'}" for p in r['ports']]
    md+=f'- {kind}/{bank}: '+'; '.join(port_summaries)+'\n'
if problems: md+='\nFailures:\n'+'\n'.join(f'- {p}' for p in problems)+'\n'
md+='\nSHA-256 bindings are recorded in the JSON. Raw audit files and production RTL/netlists were not modified.\n'
(audit/'routed_rom_control_proof.md').write_text(md,encoding='utf-8')
print(json.dumps({'status':status,'failures':problems,'banks':{f'{kind}/{bank}':r['passes'] for (kind,bank),r in bank_results.items()}},ensure_ascii=False))
if status!='PASS': sys.exit(1)
'@
try {
$proofCode | & python -c "import sys; exec(sys.stdin.read())" $root $RunId $PhysicalRunId
    if ($LASTEXITCODE -ne 0) { throw 'ROM polarity proof failed.' }
}
catch {
    $failureMessage = $_.Exception.Message
    $evidencePath = Join-Path $outDir 'routed_rom_control_proof.json'
    $verifiedPath = Join-Path $outDir 'routed_rom_control_proof_verified.json'
    $existingFailure = $false
    if (Test-Path -LiteralPath $evidencePath) {
        try { $existingFailure = ((Get-Content -LiteralPath $evidencePath -Raw | ConvertFrom-Json).status -eq 'FAIL') } catch { $existingFailure = $false }
    }
    if (-not $existingFailure) {
        $boundFailure = @()
        foreach ($relative in @('build/audit/routed_rom_control.json','build/audit/routed_implementation.v','src/user_source/hdl_source/player_spectrum_analyzer.v','src/user_source/hdl_source/spectrum_coeff_rom.v','src/user_source/hdl_source/spectrum_coeff_rom_manifest.json','build/gate_verify/prove_current_routed_rom_polarity.ps1')) {
            $candidate = Join-Path $root $relative
            if (Test-Path -LiteralPath $candidate) { $boundFailure += [ordered]@{path=(Resolve-Path -LiteralPath $candidate).Path;sha256=(Get-FileHash -LiteralPath $candidate -Algorithm SHA256).Hash.ToLowerInvariant()} }
        }
        $failureEvidence = [ordered]@{schema='rom-polarity-evidence-v2';status='FAIL';conclusion='Proof execution failed before all assertions completed.';failures=@($failureMessage);bound_files=$boundFailure}
        Set-Content -LiteralPath $evidencePath -Value ($failureEvidence | ConvertTo-Json -Depth 8) -Encoding utf8
        Set-Content -LiteralPath (Join-Path $outDir 'routed_rom_control_proof.md') -Value ("# C11314 routed ROM control proof`n`n**Result: FAIL.** $failureMessage`n") -Encoding utf8
    }
    $evidenceSha = (Get-FileHash -LiteralPath $evidencePath -Algorithm SHA256).Hash.ToLowerInvariant()
    if (Test-Path -LiteralPath $verifiedPath) {
        try { $verifiedStatus=(Get-Content -LiteralPath $verifiedPath -Raw | ConvertFrom-Json).status } catch { $verifiedStatus='' }
    } else { $verifiedStatus='' }
    if ($verifiedStatus -ne 'FAIL') {
        if ($existingFailure) { $boundFailure=(Get-Content -LiteralPath $evidencePath -Raw | ConvertFrom-Json).bound_files }
        Set-Content -LiteralPath $verifiedPath -Value ([ordered]@{status='FAIL';evidence_sha256=$evidenceSha;bound_files=$boundFailure;reason=$failureMessage} | ConvertTo-Json -Depth 8) -Encoding utf8
    }
    throw 'ROM polarity proof failed; FAIL evidence was retained and the process exits nonzero.'
}




