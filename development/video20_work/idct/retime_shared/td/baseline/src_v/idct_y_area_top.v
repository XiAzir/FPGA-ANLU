module idct_y_area_top(
 input clk_i,input rst_i,input img_start_i,input inport_valid_i,
 input [31:0] inport_data0_i,input [31:0] inport_data1_i,input [31:0] inport_data2_i,input [31:0] inport_data3_i,input [2:0] inport_idx_i,
 output outport_valid_o,output [31:0] outport_data_o,output [5:0] outport_idx_o
);
jpeg_idct_y #(.OUT_SHIFT(11)) u_y(
 .clk_i(clk_i),.rst_i(rst_i),.img_start_i(img_start_i),.img_end_i(1'b0),.inport_valid_i(inport_valid_i),
 .inport_data0_i(inport_data0_i),.inport_data1_i(inport_data1_i),.inport_data2_i(inport_data2_i),.inport_data3_i(inport_data3_i),.inport_idx_i(inport_idx_i),
 .outport_valid_o(outport_valid_o),.outport_data_o(outport_data_o),.outport_idx_o(outport_idx_o));
endmodule
