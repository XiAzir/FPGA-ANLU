`timescale 1ns/1ps
module tb_original_eof;
 reg clk=0; always #5 clk=~clk;
 reg rst=1,img_start=0,img_end=1,blk_space=1;
 wire [5:0] pop,idx; wire req,valid,eob; wire [1:0] table_id;
 wire [15:0] lookup_input,data; wire [4:0] width; wire [7:0] value; wire [31:0] id;
 integer samples=0,eobs=0;
 jpeg_mcu_proc dut(.clk_i(clk),.rst_i(rst),.img_start_i(img_start),.img_end_i(img_end),
  .img_width_i(16'd16),.img_height_i(16'd16),.img_mode_i(2'd2),.inport_valid_i(1'b0),
  .inport_data_i(32'b0),.inport_last_i(1'b0),.lookup_valid_i(1'b0),.lookup_width_i(5'b0),
  .lookup_value_i(8'b0),.outport_blk_space_i(blk_space),.inport_pop_o(pop),.lookup_req_o(req),
  .lookup_table_o(table_id),.lookup_input_o(lookup_input),.outport_valid_o(valid),
  .outport_data_o(data),.outport_idx_o(idx),.outport_id_o(id),.outport_eob_o(eob));
 always @(posedge clk) if(!rst) begin if(valid) samples<=samples+1; if(eob) eobs<=eobs+1; end
 initial begin
  repeat(3) @(negedge clk);rst=0;force dut.end_of_image_w=1'b1;
  repeat(30) @(negedge clk);
  if(samples<2 || eobs<2) $fatal(1,"baseline did not reproduce EOF repetition samples=%0d eobs=%0d",samples,eobs);
  $display("BASELINE_EOF_REPEATS samples=%0d eobs=%0d over 30 cycles",samples,eobs);
  $finish;
 end
 initial begin #100000;$fatal(1,"baseline EOF test timeout");end
endmodule
