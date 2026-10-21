from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[4]
NETLIST = ROOT / 'development/player_spectrum_arch17/build/audit/routed_implementation.v'
CANONICAL = r'\u_pcm_waveform/u_spectrum/state_reg[0]_syn_4'
DUPLICATE = r'\u_pcm_waveform/u_spectrum/state_reg[0]_syn_5'
EXPECTED_Q0 = r'\u_pcm_waveform/u_spectrum/debug_progress [19]'
EXPECTED_Q1 = r'\u_pcm_waveform/u_spectrum/debug_progress[19]_dup_103'


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def extract_cell(text: str, instance: str) -> dict:
    needle = instance
    pos = text.find(needle)
    if pos < 0:
        raise ValueError(f'missing cell instance {instance}')
    start = text.rfind('EG_PHY_LSLICE #(', 0, pos)
    if start < 0:
        raise ValueError(f'missing EG_PHY_LSLICE declaration for {instance}')
    end = text.find(');', pos)
    if end < 0:
        raise ValueError(f'unterminated cell instance {instance}')
    end += 2
    block = text[start:end]
    instance_pos = block.find(needle)
    param_open = block.find('#(', start - start)
    # The first parameter close immediately followed by the escaped instance
    # identifies the parameter region even when comments contain parentheses.
    match = re.search(r'#\((.*?)\)\s*' + re.escape(needle) + r'\s*\(', block, re.S)
    if not match:
        raise ValueError(f'cannot parse parameter block for {instance}')
    params_text = match.group(1)
    port_text = block[match.end():-2]
    params = {}
    for name, value in re.findall(r'^\s*\.(\w+)\(([^)]*)\)\s*,?\s*$', params_text, re.M):
        params[name] = value.strip()
    ports = {}
    for name, value in re.findall(r'\.(\w+)\((.*?)\)\s*(?:,|$)', port_text, re.S):
        ports[name] = value.strip()
    return {'name': instance, 'block_start': start, 'block_end': end,
            'block': block, 'params': params, 'ports': ports}


def lane_list(value: str) -> list[str]:
    value = value.strip()
    if not (value.startswith('{') and value.endswith('}')):
        raise ValueError(f'expected two-lane concat, got {value!r}')
    lanes = [x.strip() for x in value[1:-1].split(',')]
    if len(lanes) != 2:
        raise ValueError(f'expected two lanes, got {lanes!r}')
    return lanes


def equivalent(text: str) -> tuple[bool, str]:
    a = extract_cell(text, CANONICAL)
    b = extract_cell(text, DUPLICATE)
    if text[a['block_start']:a['block_end']].split('#(', 1)[0].strip() != text[b['block_start']:b['block_end']].split('#(', 1)[0].strip():
        return False, 'primitive type differs'
    if a['params'] != b['params']:
        return False, 'primitive parameters differ'
    for port in ('a', 'b', 'c', 'd', 'e'):
        if a['ports'].get(port) != b['ports'].get(port):
            return False, f'data-function input {port} differs'
    for port in ('clk', 'sr'):
        if a['ports'].get(port) != b['ports'].get(port):
            return False, f'{port} differs'
    if 'ce' in a['ports'] or 'ce' in b['ports']:
        if a['ports'].get('ce') != b['ports'].get('ce'):
            return False, 'clock enable differs'
    for port in set(a['ports']) | set(b['ports']):
        if port in ('q', 'mi'):
            continue
        if a['ports'].get(port) != b['ports'].get(port):
            return False, f'other input {port} differs'
    mi_a, mi_b = lane_list(a['ports']['mi']), lane_list(b['ports']['mi'])
    if mi_a[1] != mi_b[1]:
        return False, 'active MI lane differs'
    if not mi_a[0].startswith('open_') or not mi_b[0].startswith('open_'):
        return False, 'unused MI lanes are not both open'
    q_a, q_b = lane_list(a['ports']['q']), lane_list(b['ports']['q'])
    if not q_a[0].startswith('open_') or not q_b[0].startswith('open_'):
        return False, 'unused Q lanes are not both open'
    if q_a[1] != EXPECTED_Q0 or q_b[1] != EXPECTED_Q1:
        return False, f'active Q aliases differ: {q_a[1]!r}, {q_b[1]!r}'
    return True, 'same EG_PHY_LSLICE, parameters, duplicated a-e function inputs, active MI, clock, async reset and reset state; only open upper lane names and active Q alias differ'


def mutate_duplicate_port(text: str, port: str, old: str, new: str) -> str:
    cell = extract_cell(text, DUPLICATE)
    block = cell['block']
    pattern = r'(\.' + re.escape(port) + r'\s*\()(.*?)(\))'
    changed, count = re.subn(pattern, lambda m: m.group(1) + m.group(2).replace(old, new, 1) + m.group(3), block, count=1, flags=re.S)
    if count != 1 or changed == block:
        raise ValueError(f'failed to mutate {port}: {old}')
    return text[:cell['block_start']] + changed + text[cell['block_end']:]


def mutate_duplicate_param(text: str, param: str, old: str, new: str) -> str:
    cell = extract_cell(text, DUPLICATE)
    block = cell['block']
    pattern = r'(\.' + re.escape(param) + r'\s*\()' + re.escape(old) + r'(\))'
    changed, count = re.subn(pattern, lambda m: m.group(1) + new + m.group(2), block, count=1)
    if count != 1:
        raise ValueError(f'failed to mutate parameter {param}')
    return text[:cell['block_start']] + changed + text[cell['block_end']:]


def main() -> None:
    raw = NETLIST.read_bytes()
    text = raw.decode('utf-8', errors='replace')
    ok, reason = equivalent(text)
    if not ok:
        raise SystemExit('equivalence failed: ' + reason)
    a = extract_cell(text, CANONICAL)
    b = extract_cell(text, DUPLICATE)
    tests = {
        'data_input_d': mutate_duplicate_port(text, 'd', r'\u_pcm_waveform/u_spectrum/mux6_syn_111', r'\u_pcm_waveform/u_spectrum/mux6_syn_112'),
        'clock': mutate_duplicate_port(text, 'clk', r'\u_status_monitor/sys_clk ', r'\u_status_monitor/other_clk'),
        'async_reset': mutate_duplicate_port(text, 'sr', r'\u_pcm_waveform/u_spectrum/reset_pipe [1]', r'\u_pcm_waveform/u_spectrum/reset_pipe [0]'),
        'active_mi_input': mutate_duplicate_port(text, 'mi', r'\u_pcm_waveform/u_spectrum/add10_syn_50 ', r'\u_pcm_waveform/u_spectrum/add10_syn_51'),
        'selected_dff_data': mutate_duplicate_param(text, 'REG0_SD', '"FX"', '"F"'),
        'reset_mode': mutate_duplicate_param(text, 'SRMODE', '"ASYNC"', '"SYNC"'),
    }
    negatives = {}
    for name, mutated in tests.items():
        accepted, why = equivalent(mutated)
        negatives[name] = {'rejected': not accepted, 'reason': why}
        if accepted:
            raise SystemExit(f'negative control accepted: {name}')
    result = {
        'status': 'PASS',
        'netlist': str(NETLIST),
        'netlist_sha256': sha(raw),
        'canonical': {'instance': CANONICAL, 'line': text.count('\n', 0, a['block_start']) + 1,
                      'active_q': lane_list(a['ports']['q'])[1]},
        'duplicate': {'instance': DUPLICATE, 'line': text.count('\n', 0, b['block_start']) + 1,
                      'active_q': lane_list(b['ports']['q'])[1]},
        'primitive': 'EG_PHY_LSLICE',
        'compared_parameters': a['params'],
        'compared_active_inputs': {key: a['ports'][key] for key in ('a','b','c','d','e','mi','clk','sr')},
        'equivalence_basis': reason,
        'negative_controls': negatives,
    }
    out = Path(__file__).with_name('result.json')
    out.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()


