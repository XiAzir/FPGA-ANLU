# JPEG core simulation

This folder contains an isolated Icarus testbench for the frozen JPEG core and a runner for swapping in complete candidate source directories. It writes one binary output record per accepted pixel: little-endian `x`, little-endian `y`, then `R,G,B`. Each run saves the compiled image, console output, pixel records, Pillow analysis, and a manifest with SHA-256 hashes for every input RTL file, fixture, and testbench.

Run a fixture with the installed Icarus/Pillow environment:

```powershell
python run.py E:/VSCODE-project/FPGA-ANLU/development/video_codec_trial_20261021/decoder_fixture/frame_000.jpg --name frame_000
python run.py E:/VSCODE-project/FPGA-ANLU/development/video_codec_trial_20261021/decoder_fixture/frame_299.jpg --mode 3 --gap 5 --seed 20261021 --name frame_299_stress
python run.py E:/VSCODE-project/FPGA-ANLU/development/video_codec_trial_20261021/decoder_fixture/frame_000.jpg --core-dir E:/VSCODE-project/FPGA-ANLU/development/video19_work/td/candidate_src/A08 --name A08_frame_000
python compare_runs.py runs/frame_000/pixels_xy_rgb.bin runs/A08_frame_000/pixels_xy_rgb.bin
```

`--mode 1` adds input-valid gaps, `--mode 2` adds random output backpressure, and `--mode 3` combines them. Input-gap runs are exploratory until the JPEG parser's marker detection is qualified with the stream reader. For a reduced image, pass matching `--width` and `--height`; the checked dimensions must be multiples of 16.

Input bytes follow `jpeg_input.v`: bytes occupy lanes `[7:0]`, `[15:8]`, `[23:16]`, `[31:24]`. Keep valid/data/strb/last stable until `valid && inport_accept`. The core asserts input acceptance early whenever `last` is high, so the fixture tail is zero-padded to a full word using `strb`, then followed by an accepted empty `last` beat. The included 43,231-byte and 35,721-byte fixtures exercise three- and one-byte tails.

The core emits 4:2:0 output in MCU order. The first eight 8x8 block starts are `(0,0), (8,0), (0,8), (8,8), (16,0), (24,0), (16,8), (24,8)`: TL, TR, BL, BR within each 16x16 MCU, then the next MCU horizontally. Analysis checks all block starts and full coordinate coverage.

Run evidence and limitations are in [receipt.md](receipt.md). The SDRAM gate probe is isolated under [memory_jump](memory_jump/README.md).
