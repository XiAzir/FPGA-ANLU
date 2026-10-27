# AC601 reference crystal: 50 MHz. Check PLL clocks in routed reports.
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
derive_clocks
rename_clock -name {sd_card_clk} -source [get_ports {clk}] -master_clock {clk} [get_pins {sys_pll_m0/pll_inst.clkc[0]}]
rename_clock -name {ext_mem_clk} -source [get_ports {clk}] -master_clock {clk} [get_pins {sys_pll_m0/pll_inst.clkc[1]}]
rename_clock -name {ext_mem_clk_sft} -source [get_ports {clk}] -master_clock {clk} [get_pins {sys_pll_m0/pll_inst.clkc[2]}]
rename_clock -name {video_clk} -source [get_ports {clk}] -master_clock {clk} [get_pins {video_pll_m0/pll_inst.clkc[0]}]
rename_clock -name {hdmi_5x_clk} -source [get_ports {clk}] -master_clock {clk} [get_pins {video_pll_m0/pll_inst.clkc[1]}]
# Pixel and serializer clocks run simultaneously with a fixed PLL relationship.
# Do not mark them exclusive or suppress all crossings to obtain Timing Clean.
# Board-level SPI I/O delays remain uncharacterized at this stage.

# C42 read interface: SDRAM launch n@8ns is captured at mem edge20ns.
# Data changes each 10ns; retain the setup-derived hold check (source8/capture10,
# equivalent to next word source18/capture20). No hold relaxation is applied.
# This source clock drives only the SDRAM forwarding clock. Its return paths
# must be verified against the actual device model and DATA_DELAY=0 capture.
set_multicycle_path 2 -setup -from [get_clocks ext_mem_clk_sft] -to [get_clocks ext_mem_clk]
