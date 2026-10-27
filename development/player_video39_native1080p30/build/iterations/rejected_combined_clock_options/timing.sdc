# AC601 50MHz reference; actual PLL M=104, N=7, C0=10, C1=2.
create_clock -name clk -period 20.000 -waveform {0.000 10.000} [get_ports {clk}]
create_generated_clock -name pixel_clk -source [get_ports {clk}] -master_clock {clk} -multiply_by 104 -divide_by 70 [get_pins {u_video_pll/pll_inst.clkc[0]}]
create_generated_clock -name hdmi_5x_clk -source [get_ports {clk}] -master_clock {clk} -multiply_by 104 -divide_by 14 [get_pins {u_video_pll/pll_inst.clkc[1]}]
# Related 5:1 clocks, with 50% duty cycle and zero phase from the PLL configuration.
# Receiver and board-level external delays remain uncharacterized.
