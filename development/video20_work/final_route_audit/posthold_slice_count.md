# C11320 post-explicit-hold Slice count

The final explicit-hold routed netlist contains **8637 Slice primitives**: 4334 `EG_PHY_MSLICE` + 4303 `EG_PHY_LSLICE`. This is an exact count from the exported routed primitive netlist; it matches the auto-hold physical console's final QoR count of 8637.

The physical console records 4332 MSLICE + 4303 LSLICE before its automatic hold stage (8635), then reports 8637 slices after hold repair. The explicit hold log reports 0/2 endpoints fixed by LUT bridge and 2/2 fixed by pin delay, with final hold WNS +0.024 ns.

**Known:** the explicit-hold final netlist has 8637 slice primitives; its routed DB SHA-256 and source run binding are the same as the final route audit receipt.

**Inference:** matching the auto-hold count plus pin-delay-only repair indicates the explicit hold pass added no further slice primitive. The prior auto-hold database snapshot is retained in `whole/D02/prehold`; this audit counts the final netlist and does not compare individual placement movement.

Input hashes are recorded in `posthold_slice_count.json`; the existing route netlist and build artifacts were read only.
