# SDRAM jump-address probe

`run.py` creates a fresh subdirectory under `runs/`, copies the exact gate netlist and APUG011 IS42s32200 model inputs, and records their SHA-256 hashes. It drives JPEG 4:2:0 block-order addresses into the application write interface, then reads the tested region linearly and compares only addresses that were written.

```powershell
python development/video19_work/jpeg_unit/memory_jump/run.py --format rgb888
python development/video19_work/jpeg_unit/memory_jump/run.py --format rgb565
```

The `rgb888` probe uses the `jpeg420_word_address.v` mapping for four horizontal MCUs: 768 words with a six-word 8-pixel block row. The `rgb565` probe uses four words per 8-pixel block row: 512 words. Both currently send a continuous app write stream and linear reads; they do not pause at the production 128-word burst boundaries. Results are exploratory until those application-interface burst boundaries are modeled. The protected controller gate SHA is checked before and after each run. No TD, board, or production source is changed.
