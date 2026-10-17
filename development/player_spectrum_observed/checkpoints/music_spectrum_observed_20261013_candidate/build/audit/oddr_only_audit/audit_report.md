# C11306 ODDR-only serializer audit

Date: 2026-10-13
Scope: isolated behavioral test only. No C11306/C11305 source, bitstream, or metadata was edited; no full-project build or hardware access was performed.

## Variant

Copied the known C11206 PHY source from development/player_bmp_scale/src/user_source/hdl_source/ into this directory and added model-only delay parameters. The single functional RTL change in lane_oddr_negedge.v is the capture edge for S_oddr_data: posedge I_serial_clk → 
egedge I_serial_clk. The pixel marker remains posedge I_pixel_clk; the wrapper retains the baseline direct TMDS input mapping and has no pixel-falling capture stage. The wrapper parameter additions and D0/D1/clock delay nets are inactive when all delays are zero and only support simulation.

Baseline lane source SHA256: 4E2297D22452B437EE60968DAAD5D6473E1541AB1614C507EFF7F298F112BC0E
Baseline wrapper source SHA256: 416B082B0987001BDBC0A7E20A557CB8FB1DCA34E25DC881E6D28A8CB3CF4300
The generated-source diff is preserved in lane_diff.txt.

## Results

matrix_summary.txt records 108 runs using the original serializer testbench and its EG ODDR functional model:

- Baseline lane, nominal: 27/27 pass.
- ODDR-negedge-only variant, nominal: 27/27 pass.
- Baseline lane, PAD-skew boundary: 0/27 pass; all fail to align a valid serialized word (lign_bit=-1).
- ODDR-negedge-only variant, same PAD-skew boundary: 27/27 pass.

Each group spans serial phase −1 ns, 0, +1 ns; pixel-marker toggle delay 0/1/2 ns; seeds 1, 37, 97. Boundary runs apply D0 path 50 ps, D1 path 1500 ps, and ODDR clock path 1000 ps. matrix_failures.txt and per-case baseline boundary logs retain the counterexamples. The runner requires all 54 ODDR-negedge variant cases to pass.

The copied testbench’s EG ODDR model samples both D0 and D1 at the serial rising edge, emits D0 on the rising half and D1 on the falling half. This matches the installed TD EG model in C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_logic_io.v (around lines 191–235).

## Conclusion and limits

This supports the narrow change: with baseline marker, baseline wrapper, baseline bit ordering, and baseline load/shift schedule unchanged, registering the ODDR data pair on 
egedge I_serial_clk preserves nominal output word/bit order and resolves this model’s specified D-input/PAD-clock skew counterexample. In the 125 MHz serializer model, the half-cycle provides 4 ns nominal setup before the next rising capture edge; the tested injected path leaves positive setup in the boundary case.

This is behavioral evidence, not routed timing or silicon evidence. The injected delays are stress parameters, not measured AC201 pad/board delays. It does not establish that the ODDR-only change fixes C11306’s reported white pixels/noise, nor validate image/audio packet timing end-to-end. Keep the change as an isolated candidate until TD routed timing and a same-condition board A/B confirm it.
