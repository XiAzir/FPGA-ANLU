module idct_xy_area_top(
 input clk_i,input rst_i,input sx_start_i,input sy_start_i,input sx_valid_i,input sy_valid_i,
 input [15:0] x0_i,input [15:0] x1_i,input [15:0] x2_i,input [15:0] x3_i,input [2:0] xi_i,
 input [20:0] y0_i,input [20:0] y1_i,input [20:0] y2_i,input [20:0] y3_i,input [2:0] yi_i,
 output xv_o,output [31:0] xo_o,output [5:0] xidx_o,
 output yv_o,output [31:0] yo_o,output [5:0] yidx_o
);
wire signed [31:0] y0_s={{11{y0_i[20]}},y0_i};
wire signed [31:0] y1_s={{11{y1_i[20]}},y1_i};
wire signed [31:0] y2_s={{11{y2_i[20]}},y2_i};
wire signed [31:0] y3_s={{11{y3_i[20]}},y3_i};
jpeg_idct_x u_x(clk_i,rst_i,sx_start_i,1'b0,sx_valid_i,x0_i,x1_i,x2_i,x3_i,xi_i,xv_o,xo_o,xidx_o);
jpeg_idct_y u_y(clk_i,rst_i,sy_start_i,1'b0,sy_valid_i,y0_s,y1_s,y2_s,y3_s,yi_i,yv_o,yo_o,yidx_o);
endmodule
