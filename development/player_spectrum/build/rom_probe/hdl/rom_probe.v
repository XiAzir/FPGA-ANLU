module rom_param #(parameter INIT_FILE="param.mem")(input wire clk,input wire [3:0] addr,output reg [7:0] dout);
(* rom_style="bram" *) reg [7:0] mem [0:15];
initial $readmemh(INIT_FILE,mem);
always @(posedge clk) dout <= mem[addr];
endmodule
module rom_literal(input wire clk,input wire [3:0] addr,output reg [7:0] dout);
(* rom_style="bram" *) reg [7:0] mem [0:15];
initial $readmemh("literal.mem",mem);
always @(posedge clk) dout <= mem[addr];
endmodule
module rom_explicit(input wire clk,input wire [3:0] addr,output reg [7:0] dout);
(* rom_style="bram" *) reg [7:0] mem [0:15];
initial begin
mem[0]=8'h81;
mem[1]=8'h82;
mem[2]=8'h83;
mem[3]=8'h84;
mem[4]=8'h85;
mem[5]=8'h86;
mem[6]=8'h87;
mem[7]=8'h88;
mem[8]=8'h89;
mem[9]=8'h8A;
mem[10]=8'h8B;
mem[11]=8'h8C;
mem[12]=8'h8D;
mem[13]=8'h8E;
mem[14]=8'h8F;
mem[15]=8'h80;
end
always @(posedge clk) dout <= mem[addr];
endmodule
module rom_case(input wire clk,input wire [3:0] addr,output reg [7:0] dout);
always @(posedge clk) case(addr)
4'd0: dout<=8'hC1;
4'd1: dout<=8'hC2;
4'd2: dout<=8'hC3;
4'd3: dout<=8'hC4;
4'd4: dout<=8'hC5;
4'd5: dout<=8'hC6;
4'd6: dout<=8'hC7;
4'd7: dout<=8'hC8;
4'd8: dout<=8'hC9;
4'd9: dout<=8'hCA;
4'd10: dout<=8'hCB;
4'd11: dout<=8'hCC;
4'd12: dout<=8'hCD;
4'd13: dout<=8'hCE;
4'd14: dout<=8'hCF;
4'd15: dout<=8'hC0;
endcase
endmodule
module top(input wire clk,input wire [3:0] addr,output wire [7:0] y_param,output wire [7:0] y_literal,output wire [7:0] y_explicit,output wire [7:0] y_case);
rom_param #(.INIT_FILE("param.mem")) a(clk,addr,y_param);
rom_literal b(clk,addr,y_literal);
rom_explicit c(clk,addr,y_explicit);
rom_case d(clk,addr,y_case);
endmodule
