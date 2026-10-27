# Analysis only: retain clocks already stored in the routed DB.
set_input_delay -clock sd_card_clk -max 0.0 [get_ports {sd_miso}]
set_input_delay -clock sd_card_clk -min 0.0 [get_ports {sd_miso}]
set_output_delay -clock sd_card_clk -max 0.0 [get_ports {sd_dclk sd_mosi}]
set_output_delay -clock sd_card_clk -min 0.0 [get_ports {sd_dclk sd_mosi}]
