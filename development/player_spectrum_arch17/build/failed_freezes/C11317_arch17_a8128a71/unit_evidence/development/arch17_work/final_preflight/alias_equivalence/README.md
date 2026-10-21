# A04 routed state alias equivalence check

This independent structural check validates the routed `state_reg[0]` duplicate used by the Hann control proof. It reads the routed netlist only and never invokes TD or edits the netlist / proof scripts.

Run with:

```powershell
python .\development\arch17_work\final_preflight\alias_equivalence\verify_state_alias.py
```

## Evidence

- Routed source: `development/player_spectrum_arch17/build/audit/routed_implementation.v`
- SHA-256: `5ad73bac35a528f6f67d55bffddd7c24d300238dcb1ea1ee9686d8ce78de0a6f`
- Canonical cell begins at line 141517; duplicate begins at line 141547.
- Both are `EG_PHY_LSLICE`, with identical full parameter maps, `a..e` two-lane inputs, clock, and async reset. Their selected lower-lane `mi` input also matches (`add10_syn_50`). The upper `mi` and `q` lanes are open in both cells. The connected lower-lane Q names are the expected canonical and duplicate debug nets.
- Result: `result.json` reports PASS.

Six negative controls each reject the synthetic mismatch: data input `d`, clock, reset signal, selected `mi`, `REG0_SD`, and `SRMODE`.

## Vendor model check

The local `C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/arch/eagle_macro.v` declares EG_PHY_LSLICE ports and parameter choices, then ends the module without behavioral logic. It cannot establish whether the `FX` selection is independent of `mi`. For this proof, comparing the selected active `mi` lane is the conservative structural rule; it passes for this exact pair. The macro has `LSFXMUX0="FUNC6"`, so there is no evidence here to justify dropping that comparison.
