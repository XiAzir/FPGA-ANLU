# BMP scaler validated-domain experiment ledger

This directory retains the first experiment based on the root `opt16_work/scaler/bmp_scale_engine.v` row-seed/shared-image-bytes snapshot. It is superseded for final C11315 comparison by [`c11315/README.md`](c11315/README.md), which is bound directly to the production scaler SHA `1916cf21f554e64d476d3697973cdba33f66c0acefbdbab5b48341cbeea29519`.

Root-share source binding: engine input SHA `f07163167ab03b7824c60b052ce3ac5f5aa434879fad6cce671a4d44732b6c13`, gated candidate engine SHA `892be432118754a9d5bc4c381e856cebfc19808cc7b78a283c7cf6cf0c44eddb`; test candidate loader SHA `b5e40551868f943e99e080990a6542009417525426a8b1f67936f927c169f71a`.

Icarus results from this intermediate source snapshot:

- Generic default-0 direct scaler: 7 valid + 6 error cases passed per-cycle comparison.
- Parameter-1 legal-domain direct scaler: 7 geometry cases passed per-cycle comparison.
- Existing 538 diagnostic fixture: all public-output cycle comparisons passed.
- A paired six-image testbench compiled, then its run was stopped when the root requested rebinding to C11315. An independent root-share full-image run passed 1,843,200 pixel gold checks; that result is root-provided evidence.
- No TD resource result was produced from this root-share version. Do not use its source for the final A1/A2 numbers.
