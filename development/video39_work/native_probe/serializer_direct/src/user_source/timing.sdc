create_clock -name refclk -period 20 -waveform {0 10} [get_ports {refclk}]
derive_clocks
