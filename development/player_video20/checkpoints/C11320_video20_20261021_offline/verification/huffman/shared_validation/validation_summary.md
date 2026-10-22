# Shared IDCT full JPEG validation

C04 current JPEG RTL is the baseline. The V1 candidate changes only `jpeg_idct.v`; V3 changes only `jpeg_idct.v` and `jpeg_idct_transpose.v`. Every listed full-frame comparison contains 307,200 coordinate/RGB records.

| Case | Mode | Baseline cycles | Candidate cycles | Backpressure stalls (base/candidate) | Exact records | Pin gold |
|---|---:|---:|---:|---:|---|---|
| v1_frame108 | 0 | 659356 | 1265572 | 0/0 | True | True |
| v1_frame000 | 0 | 659578 | 1265573 | 0/0 | True | — |
| v1_frame299 | 0 | 659564 | 1265573 | 0/0 | True | — |
| v3_frame108 | 0 | 659356 | 1041241 | 0/0 | True | True |
| v3_gap | 3 | 696576 | 1078689 | 76702/76569 | True | True |
| v3_abort | 2 | 696268 | 1078342 | 76465/76525 | True | True |

Frame108 V1, V3 mode0, V3 random input gaps plus random output backpressure, and V3 abort/reset recovery each match the C04 output stream exactly and match independent frame108 pin gold by coordinate and RGB. Frame0 and frame299 V1 single-frame runs also match exactly.

The serialized V1 0+299 launch stopped before simulation because the generated absolute concatenated input path exceeded the testbench's 128-character path register. No serialized result is claimed. No synthesis or P&R was run.

Machine-readable source hashes, fixture hashes, run log paths and per-case cycle counts are in [validation_summary.json](validation_summary.json).
