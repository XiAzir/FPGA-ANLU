# Analysis only: deliberately tighten external budgets to expose the pin paths.
# This file is never used to build a delivery bitstream.
set_input_delay -clock sd_card_clk -max 20.0 [get_ports {sd_miso}]
set_input_delay -clock sd_card_clk -min 0.0 [get_ports {sd_miso}]
set_output_delay -clock sd_card_clk -max 20.0 [get_ports {sd_dclk}]
set_output_delay -clock sd_card_clk -min 0.0 [get_ports {sd_dclk}]
set_output_delay -clock sd_card_clk -max 20.0 [get_ports {sd_mosi}]
set_output_delay -clock sd_card_clk -min 0.0 [get_ports {sd_mosi}]
