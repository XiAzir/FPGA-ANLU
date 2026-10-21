#!/usr/bin/env python3
"""Read-only report parser for FPGA-ANLU historical/current TD area/timing.

No external packages; does NOT synthesize RTL, modify a repository or verify hardware.
Usage: python resource_compare.py --code-root E:/.../FPGA-ANLU
"""
from __future__ import annotations
import argparse
import csv
import json
from pathlib import Path
import re
import sys

RUNS = [
    ('C11206', 'player_bmp_scale'),
    ('C11309', 'player_spectrum_clock_route'),
    ('C11310', 'player_spectrum_fft_recover'),
    ('C11312', 'player_spectrum_trace'),
]
RESOURCE_RE = re.compile(r'^#(lut|reg|le|bram|dsp|pll|gclk)\s+(\d+)(?:\s+out of\s+(\d+)\s+([\d.]+)%)?', re.MULTILINE)
TIMING_RE = re.compile(r'(SWNS|STNS|HWNS|HTNS):\s*(-?[\d.]+)ns')
SLICE_RE = re.compile(r'^\|\s*#slices\s*\|\s*(\d+)\s*\|', re.MULTILINE)
SLICE_PCT_RE = re.compile(r'^\|\s*slices percentage\s*\|\s*([\d.]+)%', re.MULTILINE)


def read_text(path: Path) -> str:
    return path.read_text(encoding='utf-8-sig', errors='replace')


def parse_hierarchy(area: str):
    if 'Report Hierarchy Area:' not in area:
        return []
    part = area.split('Report Hierarchy Area:', 1)[1]
    rows = []
    # hierarchy rows use pipe-separated columns and exactly two spaces before top-level instances
    for line in part.splitlines():
        if not line.startswith('|'):
            continue
        bits = line.split('|')
        if len(bits) < 10:
            continue
        key = bits[1]
        if not re.match(r'^  u_\w+', key):
            continue
        if re.match(r'^ {4}', key):
            continue
        try:
            rows.append(dict(instance=key.strip(), module=bits[2].strip(),
                             le=int(bits[3]), lut_logic=int(bits[4]),
                             ripple=int(bits[5]), seq=int(bits[6]),
                             bram9k=int(bits[7]), dsp=int(bits[8])))
        except ValueError:
            pass
    return rows


def inspect_run(root: Path, build: str, folder: str):
    base = root / 'development' / folder
    area_path = base / 'build' / 'manual' / 'AC201_tf_hdmi_phy.area'
    timing_path = base / 'build' / 'manual' / 'AC201_tf_hdmi_phy.ts'
    route_path = base / 'src' / 'td_project' / 'route.qor'
    check_path = base / 'build' / 'manual' / 'AC201_tf_hdmi_chk.timing'
    missing = [str(p) for p in (area_path, timing_path, route_path) if not p.is_file()]
    if missing:
        return {'build_id': build, 'folder': folder, 'missing': missing}
    area, timing, route = map(read_text, (area_path, timing_path, route_path))
    stats = {key: {'used': int(value), 'capacity': int(total) if total else None,
                   'reported_pct': float(pct) if pct else None}
             for key, value, total, pct in RESOURCE_RE.findall(area)}
    tv = {k: float(v) for k, v in TIMING_RE.findall(timing)}
    sr, spr = SLICE_RE.search(route), SLICE_PCT_RE.search(route)
    if not sr or not spr or len(tv) != 4:
        return {'build_id': build, 'folder': folder, 'error': 'failed to parse slice or final timing',
                'paths': [str(area_path), str(timing_path), str(route_path)]}
    warnings = []
    if check_path.exists():
        ch = read_text(check_path)
        for word in ('no input delay', 'no output delay'):
            m = re.search(re.escape(word)+r'\((\d+)\)', ch)
            if m and int(m.group(1)):
                warnings.append(f'{word}: {m.group(1)}')
    return dict(build_id=build, folder=folder, slices=int(sr.group(1)),
                slice_percent=float(spr.group(1)), stats=stats, final_timing_ns=tv,
                hierarchy=parse_hierarchy(area), warnings=warnings, paths={
                    'area': str(area_path), 'timing': str(timing_path), 'route': str(route_path),
                    'check': str(check_path)
                })


def fmt(v):
    return '-' if v is None else str(v)


def print_markdown(rows, top_n):
    print('# 历史/当前本地TD报告资源对照（只读）\n')
    print('**警告**：Slice源自route.qor，最终Setup/Hold取post-route/post-hold的build/manual/phy.ts；两者不是同一指标阶段。')
    print('本脚本不判断工具版本、源SHA一致性、I/O是否充分约束，也不证明实板功能。\n')
    print('| 版本 | Slice | 占用率 | LUT | FF | LE | BRAM9K | DSP | 最终Setup WNS(ns) | 最终Hold WNS(ns) |')
    print('|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|')
    for r in rows:
        if 'missing' in r or 'error' in r:
            print(f"| {r['build_id']} | 数据缺失/不能解析：{r.get('missing',r.get('error'))} |")
            continue
        s = r['stats'];t=r['final_timing_ns'];
        print(f"| {r['build_id']} | {r['slices']} | {r['slice_percent']:.2f}% | {fmt(s.get('lut',{}).get('used'))} | "
              f"{fmt(s.get('reg',{}).get('used'))} | {fmt(s.get('le',{}).get('used'))} | "
              f"{fmt(s.get('bram',{}).get('used'))} | {fmt(s.get('dsp',{}).get('used'))} | {t.get('SWNS', float('nan')):+.3f} | {t.get('HWNS', float('nan')):+.3f} |")
    for r in rows:
        if r.get('warnings'):
            print(f"- {r['build_id']} 约束核查提示：{', '.join(r['warnings'])}")
    current = next((r for r in rows if r['build_id'] == 'C11312' and 'hierarchy' in r), None)
    if current:
        print('\n## C11312 顶层模块LE排行（不是Slice排行）\n')
        print('| 模块实例 | LE | LUT逻辑 | BRAM9K | DSP |')
        print('|---|---:|---:|---:|---:|')
        for m in sorted(current['hierarchy'], key=lambda x:x['le'], reverse=True)[:top_n]:
            print(f"| `{m['instance']}` | {m['le']} | {m['lut_logic']} | {m['bram9k']} | {m['dsp']} |")
        print('\n完整层级行数：', len(current['hierarchy']))


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--code-root', required=True, type=Path, help='Actual locally cloned FPGA-ANLU root')
    p.add_argument('--json-out', type=Path, help='Optional new output JSON, otherwise stdout only')
    p.add_argument('--top-n', type=int, default=15)
    args=p.parse_args()
    root=args.code_root.resolve()
    if not (root/'AGENTS.md').is_file() or not (root/'development').is_dir():
        sys.exit(f'ERROR: not a validated FPGA-ANLU root: {root}')
    rows=[inspect_run(root, build, folder) for build,folder in RUNS]
    print_markdown(rows,max(1,args.top_n))
    if args.json_out:
        target=args.json_out.resolve()
        if root == target or root in target.parents:
            sys.exit('ERROR: --json-out must be outside FPGA-ANLU source repository to avoid writing in repo')
        if target.exists():
            sys.exit(f'ERROR: refusing overwrite: {target}')
        target.parent.mkdir(parents=True,exist_ok=True)
        target.write_text(json.dumps(rows,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
        print(f'Wrote optional JSON outside repo: {target}')
    if all('missing' in x or 'error' in x for x in rows):
        return 2
    return 0

if __name__=='__main__':
    sys.exit(main())
