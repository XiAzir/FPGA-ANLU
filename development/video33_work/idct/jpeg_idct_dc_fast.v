// Experimental DC-only block bypass. DC blocks use a descriptor FIFO and
// emit 64 samples directly; AC blocks retain the original RAM and shared core.
module jpeg_idct_dc_fast (
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
 localparam DESC_DEPTH=8;
 reg [2:0] desc_wr_q,desc_rd_q;
 reg [3:0] desc_count_q;
 reg desc_dc_q [0:DESC_DEPTH-1];
 reg signed [15:0] desc_value_q [0:DESC_DEPTH-1];
 reg active_q,active_dc_q;
 reg signed [31:0] active_dc_out_q;
 reg [5:0] dc_seq_q;
 reg block_has_ac_q;
 reg signed [15:0] block_dc_q;

 reg y_pass_q,input_y_q,x_reserved_q;
 reg [5:0] input_beat_q;
 wire x_valid,y_valid,core_valid;
 wire [15:0] x0,x1,x2,x3;
 wire [31:0] y0,y1,y2,y3;
 wire [2:0] x_idx,y_idx;
 wire [31:0] core_data;
 wire [5:0] core_idx;
 wire transpose_accept,input_ram_accept,id_fifo_accept;
 wire dc_out_valid_w = active_q && active_dc_q && x_valid;
 wire normal_out_last_w = active_q && !active_dc_q && core_valid && y_pass_q && core_idx==63;
 wire dc_out_last_w = dc_out_valid_w && dc_seq_q==63;
 wire desc_pop_w = normal_out_last_w || dc_out_last_w;
 wire desc_space_w = (desc_count_q < DESC_DEPTH) || desc_pop_w;

 function signed [31:0] dc_transform;
  input signed [15:0] dc;
  reg signed [31:0] p0,a,p1,b;
  begin
   p0 = $signed({{16{dc[15]}},dc}) * 32'sd2896;
   a = p0 >>> 11;
   p1 = a * 32'sd2896;
   b = p1 >>> 11;
   dc_transform = b >>> 4;
  end
 endfunction
 function [5:0] dc_index;
  input [5:0] seq;
  begin dc_index={seq[2:0],seq[5:3]}; end
 endfunction

 assign inport_accept_o = desc_space_w && input_ram_accept &&
   (!inport_eob_i || id_fifo_accept);
 wire accept_block_w = inport_valid_i && inport_accept_o;
 wire normal_input_w = accept_block_w;
 wire accept_eob_w = inport_eob_i && inport_accept_o;
 wire accepted_ac_nonzero_w = accept_block_w && (inport_idx_i!=0) && (inport_data_i!=0);
 wire dc_only_block_w = !(block_has_ac_q || accepted_ac_nonzero_w);
 wire signed [15:0] dc_value_for_desc_w =
   (accept_block_w && (inport_idx_i==0)) ? $signed(inport_data_i) : block_dc_q;
 wire x_launch = active_q && !input_y_q && !x_reserved_q && !y_pass_q &&
   (!active_dc_q || outport_accept_i);
 wire y_launch = active_q && !active_dc_q && input_y_q && outport_accept_i;
 wire input_valid_w = active_q && !active_dc_q && (input_y_q ? y_valid : x_valid);

 always @(posedge clk_i) begin
  if(rst_i || img_start_i) begin
   desc_wr_q<=0;desc_rd_q<=0;desc_count_q<=0;
   active_q<=0;active_dc_q<=0;active_dc_out_q<=0;dc_seq_q<=0;
   block_has_ac_q<=0;block_dc_q<=0;
   y_pass_q<=0;input_y_q<=0;x_reserved_q<=0;input_beat_q<=0;
  end else begin
   if(accept_block_w && (inport_idx_i==0))
    block_dc_q<=inport_data_i;
   if(accepted_ac_nonzero_w)
    block_has_ac_q<=1'b1;
   if(accept_eob_w) begin
    desc_dc_q[desc_wr_q]<=dc_only_block_w;
    desc_value_q[desc_wr_q]<=dc_value_for_desc_w;
    desc_wr_q<=desc_wr_q+1'b1;
    block_has_ac_q<=1'b0;
   end
   if(desc_pop_w) desc_rd_q<=desc_rd_q+1'b1;
   case ({accept_eob_w,desc_pop_w})
    2'b10: desc_count_q<=desc_count_q+1'b1;
    2'b01: desc_count_q<=desc_count_q-1'b1;
    default: ;
   endcase
   if(!active_q && (desc_count_q!=0)) begin
    active_q<=1;
    active_dc_q<=desc_dc_q[desc_rd_q];
    active_dc_out_q<=dc_transform(desc_value_q[desc_rd_q]);
    dc_seq_q<=0;
    y_pass_q<=0;input_y_q<=0;x_reserved_q<=0;input_beat_q<=0;
   end
   if(dc_out_valid_w) begin
    if(dc_seq_q==63) begin
     active_q<=0;active_dc_q<=0;dc_seq_q<=0;
    end else dc_seq_q<=dc_seq_q+1'b1;
   end
   if(active_q && !active_dc_q) begin
    if(x_valid && !input_y_q) x_reserved_q<=1;
    if(input_valid_w) begin
     input_beat_q<=input_beat_q+1'b1;
     if(input_beat_q==63) begin
      input_y_q<=~input_y_q;
      if(input_y_q) x_reserved_q<=0;
     end
    end
    if(core_valid && core_idx==63) begin
     y_pass_q<=~y_pass_q;
     if(y_pass_q) begin active_q<=0;active_dc_q<=0;end
    end
   end
  end
 end

 jpeg_idct_ram u_input(
  .clk_i(clk_i),.rst_i(rst_i),.img_start_i(img_start_i),.img_end_i(img_end_i),
  .inport_valid_i(normal_input_w),.inport_data_i(inport_data_i),.inport_idx_i(inport_idx_i),
  .inport_eob_i(accept_eob_w),.inport_accept_o(input_ram_accept),
  .outport_valid_o(x_valid),.outport_data0_o(x0),.outport_data1_o(x1),
  .outport_data2_o(x2),.outport_data3_o(x3),.outport_idx_o(x_idx),.outport_ready_i(x_launch));
 jpeg_idct_transpose #(.EARLY_READ(1)) u_transpose(
  .clk_i(clk_i),.rst_i(rst_i),.img_start_i(img_start_i),.img_end_i(img_end_i),
  .inport_valid_i(core_valid && !y_pass_q),.inport_data_i(core_data),
  .inport_idx_i({core_idx[2:0],core_idx[5:3]}),.inport_accept_o(transpose_accept),
  .outport_valid_o(y_valid),.outport_data0_o(y0),.outport_data1_o(y1),
  .outport_data2_o(y2),.outport_data3_o(y3),.outport_idx_o(y_idx),.outport_ready_i(y_launch));
 jpeg_idct_y #(.OUT_SHIFT(11)) u_shared(
  .clk_i(clk_i),.rst_i(rst_i || img_start_i),.img_start_i(img_start_i),.img_end_i(img_end_i),
  .inport_valid_i(input_valid_w),
  .inport_data0_i(input_y_q ? y0 : {{16{x0[15]}},x0}),
  .inport_data1_i(input_y_q ? y1 : {{16{x1[15]}},x1}),
  .inport_data2_i(input_y_q ? y2 : {{16{x2[15]}},x2}),
  .inport_data3_i(input_y_q ? y3 : {{16{x3[15]}},x3}),
  .inport_idx_i(input_y_q ? y_idx : x_idx),
  .outport_valid_o(core_valid),.outport_data_o(core_data),.outport_idx_o(core_idx));

 assign outport_valid_o = (active_q && !active_dc_q && core_valid && y_pass_q) || dc_out_valid_w;
 assign outport_data_o = dc_out_valid_w ? active_dc_out_q : ($signed(core_data) >>> 4);
 assign outport_idx_o = dc_out_valid_w ? dc_index(dc_seq_q) : core_idx;
 jpeg_idct_fifo #(.WIDTH(32),.DEPTH(8),.ADDR_W(3)) u_id_fifo(
  .clk_i(clk_i),.rst_i(rst_i),.flush_i(img_start_i),
  .push_i(accept_eob_w),.data_in_i(inport_id_i),
  .accept_o(id_fifo_accept),.valid_o(),.data_out_o(outport_id_o),
  .pop_i(outport_valid_o && outport_idx_o==63));
endmodule

