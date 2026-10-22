module rgb_test(input clk_i,input [23:0] rgb,input [3:0] b,input [2:0] c,output reg [23:0] q);
reg [23:0] rgb_q;reg [3:0] b_q;reg [2:0] c_q;wire [23:0] o;
always @(posedge clk_i) begin rgb_q<=rgb;b_q<=b;c_q<=c;q<=o;end
player_rgb_adjust u(rgb_q,b_q,c_q,o);endmodule
