`timescale 1ns/1ps
module tb_stride_identity;
reg [10:0] width_low;
wire [11:0] ref_stride=((({1'b0,width_low}*14'd3)+14'd3)>>2)<<2;
wire [9:0] stride_words={1'b0,width_low[10:2]}+{width_low[10:2],1'b0}+{8'd0,width_low[1:0]};
wire [11:0] cand_stride={stride_words,2'b00};
integer w;
initial begin
 for(w=0;w<2048;w=w+1) begin width_low=w[10:0]; #1; if(ref_stride!==cand_stride) $fatal(1,"stride mismatch width=%0d ref=%03x cand=%03x",w,ref_stride,cand_stride); end
 $display("BMP_STRIDE_IDENTITY PASS widths=2048 formula=ceil(3w/4)*4 modulo4096"); $finish;
end
endmodule
