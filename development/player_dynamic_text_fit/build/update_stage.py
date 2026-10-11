import json
from pathlib import Path
from datetime import datetime, timezone, timedelta

project = Path(__file__).resolve().parent.parent
path = project / 'build/preparation.json'
prep = json.loads(path.read_text(encoding='utf-8-sig'))
prep['user_source_differences'] = ['hdl_source/fat32_file_sector.v']
prep['mapperwidth_experiment'] = 'ADOPTED AFTER BOUNDED MODELS PASS; 6381198 cycles/12295 complete sectors, old/narrow bytegap tests'
markers = [('synthesis', 'SYNTHESIS_COMPLETE_WITH_GATE_DATABASE'), ('physical', 'PLACE_ROUTE_COMPLETE_WITH_REPORTS'),
           ('hold', 'POST_ROUTE_HOLD_FIX_COMPLETE'), ('bitstream', 'BITSTREAM_GENERATED')]
passed = []
for stage, marker in markers:
    log = project / 'build/manual' / (stage + '_console.log')
    if log.exists() and marker in log.read_text(encoding='utf-8-sig', errors='replace'):
        passed.append(stage)
prep['build_status'] = ('LOCAL_BUILD_PASS_HARDWARE_PENDING' if len(passed) == 4 else 'PASSED:' + ','.join(passed) + '; later stages pending')
prep['bitstream_status'] = 'GENERATED_NOT_BOARD_TESTED' if 'bitstream' in passed else 'NOT_GENERATED'
prep['updated_beijing'] = datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M:%S')
path.write_text(json.dumps(prep, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(prep['build_status'])
