import { createHash } from 'node:crypto';
import { readFile, writeFile } from 'node:fs/promises';
import { simulate } from '../td/candidate_tools/node_modules/@veriflow/iverilog-wasm/dist/index.js';

const root = new URL('.', import.meta.url);
const names = ['player_video_schedule.v', 'player_osd_state.v', 'schedule_osd_tb.v'];
const files = [];
const hashes = {};
for (const name of names) {
  const url = new URL(name === 'schedule_osd_tb.v' ? name : `rtl/${name}`, root);
  const data = await readFile(url, 'utf8');
  hashes[name] = createHash('sha256').update(data).digest('hex');
  files.push({ path: name, data });
}

const result = await simulate({
  files,
  sources: names,
  generation: '2005',
  timeoutMs: 600000,
});
await writeFile(new URL('simulation.log', root), result.combinedOutput);
const passed = result.success && result.combinedOutput.includes('SCHEDULE_OSD_PASS');
await writeFile(new URL('result.json', root), JSON.stringify({
  status: passed ? 'PASS' : 'FAIL',
  command: 'node development/video19_work/schedule_unit/run.mjs',
  simulator: '@veriflow/iverilog-wasm@0.1.4 (Icarus Verilog WASM)',
  generation: '2005',
  sources: hashes,
  compile_stage: result.stage ?? null,
  output: result.combinedOutput.trim(),
}, null, 2));
process.stdout.write(result.combinedOutput);
if (!passed) throw new Error(`schedule/OSD simulation failed at ${result.stage ?? 'unknown'}: ${result.stderr}`);
