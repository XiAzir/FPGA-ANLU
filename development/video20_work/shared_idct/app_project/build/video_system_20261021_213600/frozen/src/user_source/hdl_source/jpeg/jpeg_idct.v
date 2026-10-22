// Block-scheduled, exact X/Y IDCT sharing. Arithmetic remains in jpeg_idct_y.
// X and Y reserve an entire non-stallable 64-beat transfer before launching.
module jpeg_idct (
 input clk_i,rst_i,img_start_i,img_end_i,inport_valid_i,
 input [15:0] inport_data_i,
 input [5:0] inport_idx_i,
 input inport_eob_i,
 input [31:0] inport_id_i,
 input outport_accept_i,
 output inport_accept_o,outport_valid_o,
 output [31:0] outport_data_o,
 output [5:0] outport_idx_o,
 output [31:0] outport_id_o
);
 reg y_pass_q,x_reserved_q;
 wire x_valid,y_valid,core_valid;
 wire [15:0] x0,x1,x2,x3;
 wire [31:0] y0,y1,y2,y3;
 wire [2:0] x_idx,y_idx;
 wire [31:0] core_data;
 wire [5:0] core_idx;
 wire transpose_accept;
 wire x_launch = !y_pass_q && !x_reserved_q && outport_accept_i;
 wire y_launch = y_pass_q && outport_accept_i;
 always @(posedge clk_i) begin
  if(rst_i || img_start_i) begin
   y_pass_q<=0;x_reserved_q<=0;
  end else begin
   if(x_valid) x_reserved_q<=1;
   if(core_valid && core_idx==63) begin
    if(y_pass_q) begin y_pass_q<=0;x_reserved_q<=0;end
    else y_pass_q<=1;
   end
  end
 end
 jpeg_idct_ram u_input(
  .clk_i(clk_i),.rst_i(rst_i),.img_start_i(img_start_i),.img_end_i(img_end_i),
  .inport_valid_i(inport_valid_i),.inport_data_i(inport_data_i),.inport_idx_i(inport_idx_i),
  .inport_eob_i(inport_eob_i),.inport_accept_o(inport_accept_o),
  .outport_valid_o(x_valid),.outport_data0_o(x0),.outport_data1_o(x1),
  .outport_data2_o(x2),.outport_data3_o(x3),.outport_idx_o(x_idx),.outport_ready_i(x_launch));
 jpeg_idct_transpose u_transpose(
  .clk_i(clk_i),.rst_i(rst_i),.img_start_i(img_start_i),.img_end_i(img_end_i),
  .inport_valid_i(core_valid && !y_pass_q),.inport_data_i(core_data),
  .inport_idx_i({core_idx[2:0],core_idx[5:3]}),.inport_accept_o(transpose_accept),
  .outport_valid_o(y_valid),.outport_data0_o(y0),.outport_data1_o(y1),
  .outport_data2_o(y2),.outport_data3_o(y3),.outport_idx_o(y_idx),.outport_ready_i(y_launch));
 jpeg_idct_y #(.OUT_SHIFT(11)) u_shared(
  .clk_i(clk_i),.rst_i(rst_i || img_start_i),.img_start_i(img_start_i),.img_end_i(img_end_i),
  .inport_valid_i(y_pass_q ? y_valid : x_valid),
  .inport_data0_i(y_pass_q ? y0 : {{16{x0[15]}},x0}),
  .inport_data1_i(y_pass_q ? y1 : {{16{x1[15]}},x1}),
  .inport_data2_i(y_pass_q ? y2 : {{16{x2[15]}},x2}),
  .inport_data3_i(y_pass_q ? y3 : {{16{x3[15]}},x3}),
  .inport_idx_i(y_pass_q ? y_idx : x_idx),
  .outport_valid_o(core_valid),.outport_data_o(core_data),.outport_idx_o(core_idx));
 assign outport_valid_o=core_valid && y_pass_q;
 assign outport_data_o=$signed(core_data) >>> 4;
 assign outport_idx_o=core_idx;
 jpeg_idct_fifo #(.WIDTH(32),.DEPTH(8),.ADDR_W(3)) u_id_fifo(
  .clk_i(clk_i),.rst_i(rst_i),.flush_i(img_start_i),.push_i(inport_eob_i),
  .data_in_i(inport_id_i),.accept_o(),.valid_o(),.data_out_o(outport_id_o),
  .pop_i(outport_valid_o && outport_idx_o==63));
endmodule
