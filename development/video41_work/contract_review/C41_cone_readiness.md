# C41 SDRAM controller cone readiness

2026-10-27 19:28 更正：本目录cone仅为未完成实验。闭包补充后扩大到9539实例并留下127个未解析外部net，驱动方向表尚不完整；当前输出未用于C41仿真验收。下文730实例的逐字节匹配仅对应最初子树文本完整性。C41正式命令证据使用完整生产gate，root runner中的UseCone选项已删除。

Updated 2026-10-27 (China Standard Time). This is a static extraction package for the root agent's reduced gate-level investigation. No simulation, TD tool, device tool, or protected source body was accessed.

## Files

- `extract_c41_sdram_cone.py`: deterministic extractor for the complete flattened `u_frame_buffer/u_sdram/u2_ram` mapped instance subtree, plus the three `EG_PHY_PAD` consumers of RAS/CAS/WE.
- `c41_sdram_cone_cut.v`: 730 source-verbatim mapped instances and all 10,181 original `wire` declarations in an otherwise empty top shell (1,319,161 bytes).
- `c41_sdram_cone_manifest.json`: source/output SHA-256, each selected instance path and source line/byte offsets, per-instance SHA-256, parsed port expressions, observation roots, and TB force cut inputs.

## Static verification

- Source gate SHA-256: `3d5c2dfaaa2bb07d458ea689a61114f1727cd0c5d51f36069982facffe8c3c9e`, matching the root-provided C41 hash.
- The manifest's 730 selected instance hashes were independently checked against the original source byte ranges: 730 matched, 0 mismatched.
- The extracted Verilog ends in a module shell and retains the exact original primitive instance bodies. The output hash is recorded in the manifest.
- The shell intentionally omits unrelated drivers. Drive every manifest cut input needed by the bench; it is not a self-contained SDRAM model. The TB's physical command shell can observe the included RAS/CAS/WE PAD consumers.

## ACK edge-pulse fix review

Visible gate evidence supports the proposed event conversion at only `sdr_ref_ack_sft[0]`:

- `sdr_ref_ack_sft[0]` is a register sampling the public `u1_init_ref/Sdr_ref_ack` output; the chain shifts through bit 19 (gate lines 109093-109097, 109109 onward, 109214-109217).
- `sdr_ref_ack_sft[19]` feeds `ref_vld_reg_syn_6`; that term participates in the registered refresh-valid update (gate lines 108685-108702).
- A one-cycle rising-edge pulse at bit 0 therefore limits a multi-cycle ACK level to one event as it propagates through the existing delay chain. This is consistent with the observed repeated refresh command pattern being sensitive to sustained ACK levels.

The review assumes each independent raw ACK rising edge represents one accepted completion event. Keep the raw ACK path and outward ACK observation unchanged. Initialize/reset the previous-ACK state low and sample it on the same memory clock as the original shift register. Preserve distinct later raw ACK rising edges as distinct events; root's reported extra raw ACK rise should remain visible and should not be filtered by a one-shot latch. This static evidence does not prove the full request/refresh transaction contract; use the reduced gate trace to correlate `Sdr_ref_req`, both ACK sources, shift[0]/shift[19], `ref_vld`, and actual AREF command edges.

## Rebuild command

From the project root with the bundled Python runtime:

```powershell
$py = 'C:/Users/PENGYUHAO/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe'
& $py 'development/video41_work/contract_review/extract_c41_sdram_cone.py' `
  --gate 'development/player_video41_refresh/build/manual/AC201_tf_hdmi_gate.v' `
  --out-dir 'development/video41_work/contract_review'
```
