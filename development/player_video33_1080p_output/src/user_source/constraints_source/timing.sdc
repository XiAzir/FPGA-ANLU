# AC601 50 MHz reference and EG4 PLL-derived 33/165 MHz clocks.
create_clock -name clk -period 20.000 -waveform {0.000 10.000} [get_ports {clk}]
derive_clocks
rename_clock -name {pixel_clk} -source [get_ports {clk}] -master_clock {clk} [get_pins {u_video_pll/pll_inst.clkc[0]}]
rename_clock -name {hdmi_5x_clk} -source [get_ports {clk}] -master_clock {clk} [get_pins {u_video_pll/pll_inst.clkc[1]}]
# Pixel and serializer domains are derived from one PLL and remain synchronous.
# HDMI receiver setup/hold and board-level cable delays remain uncharacterized.
