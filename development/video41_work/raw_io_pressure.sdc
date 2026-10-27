# Analysis-only external delay values to expose routed SPI pad paths.
set_input_delay -clock sd_card_clk -max 20.0 [get_ports {sd_miso}]
set_input_delay -clock sd_card_clk -min 0.0 [get_ports {sd_miso}]
set_output_delay -clock sd_card_clk -max 20.0 [get_ports {sd_dclk sd_mosi}]
set_output_delay -clock sd_card_clk -min 0.0 [get_ports {sd_dclk sd_mosi}]
