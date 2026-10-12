`timescale 1ns/1ps
module tb_wipe_rgb888;
 reg clk=0;always #10 clk=~clk;
 reg rst=1,ack=0,active=1,clear=0,pixel_en=0;
 reg[8:0]rows=0;reg[1:0]oldbuf=0,newbuf=1;reg[20:0]linear=0;
 wire[20:0]mapped;wire pop,underflow;wire[23:0]rgb;
 reg[31:0]fifo_data=0;integer rd=0;wire empty=rd>=230400;
 integer s,r,x,y,idx,expected_source,checks=0,f;
 reg[23:0]expected;
 player_wipe_address route(clk,rst,ack,active,rows,oldbuf,newbuf,linear,mapped);
 rgb888_unpack32 unpack(clk,rst,clear,pixel_en,rgb,empty,pop,fifo_data,underflow);
 function [23:0]pixel;input integer bank,number;integer px,py;begin
 px=number%640;py=number/640;
 pixel={8'((bank*97+px+py)%256),8'((bank*73+3*px+py)%256),8'((bank*41+px+5*py)%256)};
 end endfunction
 // Independent byte-addressed host encoding of three-byte RGB pixels into
 // little-endian 32-bit words. Do not copy the HDL packer's phase equations.
 function[31:0]memory_word;input integer address;integer bank,off,j,pn,bytephase;reg[23:0]v;begin
 bank=address>=230400;off=address-bank*230400;memory_word=0;
 for(j=0;j<4;j=j+1)begin
 pn=(off*4+j)/3;bytephase=(off*4+j)%3;v=pixel(bank,pn);
 memory_word[j*8+:8]=(v>>(bytephase*8));end
 end endfunction
 always @*linear=oldbuf[0]*230400+rd;
 always @(posedge clk)begin
 if(rst||clear)begin rd<=0;fifo_data<=0;end
 else if(pop)begin fifo_data<=memory_word(mapped);rd<=rd+1;end
 end
 task tick;input integer n;integer j;begin for(j=0;j<n;j=j+1)@(negedge clk);end endtask
 initial begin
 tick(3);rst=0;tick(3);
 for(f=0;f<4;f=f+1)begin
 s=f/2;r=(f%2)==0?8:472;oldbuf=s;newbuf=1-s;rows=r;active=1;
 // The real backend holds FIFO clear throughout ACK. Metadata must latch
 // before prefetch begins, otherwise old context could seed the reservoir.
 clear=1;pixel_en=0;tick(5);ack=1;tick(2);ack=0;tick(2);clear=0;tick(5);
 for(y=0;y<480;y=y+1)begin
 for(x=0;x<800;x=x+1)begin
 pixel_en=x<640;
 @(posedge clk);#1;
 if(pixel_en)begin
 expected_source=y<r?1-s:s;expected=pixel(expected_source,y*640+x);
 if(rgb!==expected)$fatal(1,"f=%0d x=%0d y=%0d got=%h expected=%h rd=%0d",f,x,y,rgb,expected,rd);
 if(underflow)$fatal(1,"underflow");checks=checks+1;
 end else if(rgb!==0)$fatal(1,"blanking output");
 @(negedge clk);
 end end
 pixel_en=0;tick(3);
 if(rd!=230400)$fatal(1,"unexpected total words %0d",rd);
 end
 $display("WIPE_RGB888 PASS pixels=%0d frames=4 no_underflow exact_words_per_frame=230400",checks);$finish;
 end
 initial begin #100000000;$fatal(1,"timeout");end
endmodule
