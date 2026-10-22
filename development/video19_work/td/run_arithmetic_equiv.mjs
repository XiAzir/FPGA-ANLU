import { readFile, writeFile } from 'node:fs/promises';
import { createHash } from 'node:crypto';
import { simulate } from './candidate_tools/node_modules/@veriflow/iverilog-wasm/dist/index.js';

const tbPath = new URL('./arithmetic_equiv_tb.v', import.meta.url);
const data = await readFile(tbPath, 'utf8');
const result = await simulate({
  files: [{ path: 'arithmetic_equiv_tb.v', data }],
  sources: ['arithmetic_equiv_tb.v'],
  generation: '2005',
  timeoutMs: 120000,
});
process.stdout.write(result.combinedOutput);
if (!result.success || !result.combinedOutput.includes('ARITHMETIC_EQUIV_PASS')) {
  throw new Error(`Icarus equivalence failed at ${result.stage ?? 'unknown'}: ${result.stderr}`);
}
const digest = createHash('sha256').update(data).digest('hex');
await writeFile(new URL('./arithmetic_equiv.log', import.meta.url), result.combinedOutput);
await writeFile(new URL('./arithmetic_equiv_result.json', import.meta.url), JSON.stringify({
  status: 'PASS',
  command: 'node development/video19_work/td/run_arithmetic_equiv.mjs',
  simulator: '@veriflow/iverilog-wasm@0.1.4 (Icarus Verilog WASM)',
  generation: '2005',
  deterministic_vectors: 100009,
  coverage: ['signed 32-bit wraparound', 'negative values', 'overflow', 'boundary values', '181/256 signed division toward zero'],
  testbench_sha256: digest,
  output: result.combinedOutput.trim(),
}, null, 2));
