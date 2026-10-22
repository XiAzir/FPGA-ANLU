onerror {quit -code 2 -f}
onbreak {quit -code 3 -f}
set fifo_aw [examine -radix decimal /tb_system/dut.u_hdmi_1_4b_transmitter_core_wrapper.u_hdmi_tx_controller_wrapper.u_hdmi_island_data_gen.U_audio_sample_packet_2_channel.u_w96_d1024_fifo.u5.ADDR_WIDTH]
puts "HDMI_FIFO_ADDR_WIDTH=$fifo_aw"
quit -code 0 -f
