`timescale 1ns/1ps
module tb_adjust_overlay;
 reg clk=0;always #5 clk=~clk;
 reg rst=1,vs=0,de=0;reg [23:0] rgb=0,golden_rgb=0;
 reg [3:0] b=4;reg [2:0] c=2;reg [1:0] mode=0;
 wire [23:0] adjusted,a1,a2,out,g1,g2;
 player_rgb_adjust math(rgb,b,c,adjusted);
 wire [23:0] adj_active=de?adjusted:rgb;
 player_osd o1(clk,rst,vs,de,adj_active,2'd0,3'd4,1'b0,1'b1,a1);
 player_dynamic_text #(.CLK_FREQ_HZ(800)) d1(clk,rst,vs,de,1'b0,a1,a2);
 player_adjust_osd o2(clk,rst,vs,de,a2,mode,b,c,out);
 player_osd go1(clk,rst,vs,de,golden_rgb,2'd0,3'd4,1'b0,1'b1,g1);
 player_dynamic_text #(.CLK_FREQ_HZ(800)) gd1(clk,rst,vs,de,1'b0,g1,g2);
 integer x,y,f,k,checks=0,boxchecks=0; reg [23:0] expected;
 function integer gold;
 input integer p,bi,ci;
 integer v,n;
 begin
 // Reference uses rational numerator/4; Verilog division truncates toward zero, explicitly floor negatives.
 case(ci) 0:n=2;1:n=3;2:n=4;3:n=5;4:n=6;default:n=4;endcase
 v=(p-128)*n;
 if(v<0)v=-((-v+3)/4);else v=v/4;
 v=v+128+(bi-4)*16;
 gold=v<0?0:v>255?255:v;
 end endfunction
 function [4:0] font;
 input [7:0] ch;input integer r;
 reg [34:0] rows;
 begin
 case(ch)
 "P":rows=35'b11110_10001_10001_11110_10000_10000_10000;
 "L":rows=35'b10000_10000_10000_10000_10000_10000_11111;
 "A":rows=35'b01110_10001_10001_11111_10001_10001_10001;
 "Y":rows=35'b10001_10001_01010_00100_00100_00100_00100;
 "B":rows=35'b11110_10001_10001_11110_10001_10001_11110;
 "R":rows=35'b11110_10001_10001_11110_10100_10010_10001;
 "I":rows=35'b11111_00100_00100_00100_00100_00100_11111;
 "C":rows=35'b01110_10001_10000_10000_10000_10001_01110;
 "O":rows=35'b01110_10001_10001_10001_10001_10001_01110;
 "N":rows=35'b10001_11001_10101_10011_10001_10001_10001;
 "+":rows=35'b00000_00100_00100_11111_00100_00100_00000;
 "-":rows=35'b00000_00000_00000_11111_00000_00000_00000;
 ".":rows=35'b00000_00000_00000_00000_00000_00100_00100;
 "0":rows=35'b01110_10001_10011_10101_11001_10001_01110;
 "1":rows=35'b00100_01100_00100_00100_00100_00100_01110;
 "5":rows=35'b11111_10000_10000_11110_00001_00001_11110;
 "6":rows=35'b01111_10000_10000_11110_10001_10001_01110;
 "4":rows=35'b10010_10010_10010_11111_00010_00010_00010;
 default:rows=0;
 endcase
 font=r<7 ? (rows >> ((6-r)*5)) : 0;
 end endfunction
 function [23:0] overlay;
 input integer px,py,fr;
 reg [8*15-1:0] text_line; reg [7:0] ch; reg [4:0] rowbits;
 integer tx,ty,col;
 begin
 case(fr) 0:text_line="PLAY B+00 C1.00";1:text_line="BRI  B+64 C1.50";default:text_line="CON  B-64 C0.50";endcase
 tx=px-24;ty=py-64;overlay=0;
 if(tx>=0 && tx<240 && ty>=0 && ty<16) begin
 ch=text_line>>((14-tx/16)*8);rowbits=font(ch,ty/2);col=(tx%16)/2;
 if(col<5 && rowbits[4-col])overlay=(fr!=0 && tx<64)?24'hffff00:24'hffffff;
 end
 end endfunction
 initial begin
 repeat(4)@(negedge clk);rst=0;
 for(f=0;f<3;f=f+1)begin
 b=f==0?4:f==1?8:0;c=f==0?2:f==1?4:0;mode=f;
 vs=1;repeat(4)@(negedge clk);vs=0;repeat(4)@(negedge clk);
 for(y=0;y<480;y=y+1)begin
 for(x=0;x<800;x=x+1)begin
 de=x<640;rgb={8'((x+y)%256),8'((x*3+y)%256),8'((x+y*5)%256)};
 // variable-width concatenation replaced below with byte slices
 golden_rgb=de?{8'(gold(rgb[23:16],b,c)),8'(gold(rgb[15:8],b,c)),8'(gold(rgb[7:0],b,c))}:rgb;
 #1;
 expected=(de && x>=16 && x<272 && y>=56 && y<88)?overlay(x,y,f):g2;
 if(out!==expected)begin $display("FAIL frame=%d x=%d y=%d out=%h exp=%h ch=%s",f,x,y,out,expected,o2.ch);$fatal;end
 checks=checks+1;if(de && x>=16 && x<272 && y>=56 && y<88)boxchecks=boxchecks+1;
 @(negedge clk);
 end end
 end
 $display("PASS overlay frames=3 checks=%0d parameter-box=%0d; default identity, extreme clip, blanking, existing OSD/RUN/scroll preserved",checks,boxchecks);$finish;
 end
 initial begin #20000000;$fatal(1,"timeout");end
endmodule

