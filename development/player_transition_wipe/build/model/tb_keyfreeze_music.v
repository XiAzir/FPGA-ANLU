`timescale 1ns/1ps
module tb_keyfreeze_music;
 reg clk=0;always #20 clk=~clk;
 reg rst=1,vs=0,de=0;reg [23:0] rgb=0,golden_rgb=0;
 reg freeze_toggle=0;reg av=0;reg [23:0] ap=0;reg tone=0;
 reg [3:0] b=4;reg [2:0] c=2;reg [1:0] mode=0;
 reg [15:0] pcm[0:1023];reg [13:0] gold_bins[0:127];
 wire [23:0] ar,o1,d1,a1,out,go1,gd1,ga1;
 player_rgb_adjust adjust(rgb,b,c,ar);
 wire [23:0] rgb_active=de?ar:rgb;
 player_osd osd(clk,rst,vs,de,rgb_active,2'd0,3'd4,1'b0,1'b1,o1);
 player_dynamic_text dynamic_text(clk,rst,vs,de,1'b0,o1,d1);
 player_adjust_osd aosd(clk,rst,vs,de,d1,mode,b,c,a1);
 player_pcm_waveform wave_display(clk,rst,vs,de,a1,av,ap,tone,freeze_toggle,out);
 player_osd gosd(clk,rst,vs,de,golden_rgb,2'd0,3'd4,1'b0,1'b1,go1);
 player_dynamic_text gdynamic(clk,rst,vs,de,1'b0,go1,gd1);
 player_adjust_osd gaosd(clk,rst,vs,de,gd1,mode,b,c,ga1);
 integer x,y,f,i,j,checks=0,graphchecks=0,titlewhite=0;
 integer code_lo,code_hi,bin,acc=0,waitcycles;reg [23:0] expected;
 function integer golden_channel;
 input integer p,bi,ci;integer v,n;
 begin
 case(ci)0:n=2;1:n=3;2:n=4;3:n=5;4:n=6;default:n=4;endcase
 v=(p-128)*n;if(v<0)v=-((-v+3)/4);else v=v/4;
 v=v+128+(bi-4)*16;golden_channel=v<0?0:v>255?255:v;
 end endfunction
 task tick;input integer n;integer j;begin for(j=0;j<n;j=j+1)@(negedge clk);end endtask
 initial begin
 $readmemh("music_pcm.hex",pcm);$readmemh("music_bins.hex",gold_bins);
 tick(4);rst=0;tick(4);
 // 1024 true PCM16 events at the 520/521-cycle fractional 48kHz spacing.
 for(i=0;i<1024;i=i+1)begin
 acc=acc+400;waitcycles=520;
 if(acc>=480)begin acc=acc-480;waitcycles=521;end
 av=1;ap={pcm[i],8'h00};tick(1);av=0;tick(waitcycles-1);
 end
 tick(4);
 // First display the complete real-music window, then freeze that visible
 // front at a separate VS. The acoustic input keeps changing while held.
 vs=1;tick(4);vs=0;tick(4);
 freeze_toggle=1;tick(1);freeze_toggle=0;tick(2);
 vs=1;tick(4);vs=0;tick(4);
 if(!wave_display.frozen_front || wave_display.capture_active)$fatal(1,"manual freeze did not commit");
 av=1;ap=24'h7fff00;
 for(f=0;f<2;f=f+1)begin
 b=f==0?4:7;c=f==0?2:4;mode=f==0?0:1;
 vs=1;tick(4);vs=0;tick(4);
 for(y=0;y<480;y=y+1)begin
 for(x=0;x<800;x=x+1)begin
 de=x<640;rgb={8'((x+y)%256),8'((x*3+y)%256),8'((x+y*5)%256)};
 golden_rgb=de?{8'(golden_channel(rgb[23:16],b,c)),8'(golden_channel(rgb[15:8],b,c)),8'(golden_channel(rgb[7:0],b,c))}:rgb;
 #1;
 if(de && x>=16 && x<624 && y>=320 && y<424) begin
 if(x>=64 && x<576 && y>=356 && y<=412) begin
 bin=(x-64)/4;code_lo=gold_bins[bin][13:7];code_hi=gold_bins[bin][6:0];
 expected=(y>=412-code_hi && y<=412-code_lo)?24'h00ffff:(y==384?24'h404040:24'h000000);
 if(out!==expected)begin $display("FAIL graph f=%d x=%d y=%d bin=%d lo=%d hi=%d out=%h exp=%h",f,x,y,bin,code_lo,code_hi,out,expected);$fatal;end
 graphchecks=graphchecks+1;
 end else if(y>=328 && y<344 && x>=24 && x<264)begin
 // Title glyph coverage checked in module TB; integration checks its palette and visibility.
 if(out!==24'h000000 && out!==24'hffffff)$fatal(1,"invalid title color x=%0d y=%0d rgb=%h",x,y,out);
 if(out==24'hffffff)titlewhite=titlewhite+1;
 end else if(out!==0)$fatal(1,"unexpected panel pixel x=%0d y=%0d rgb=%h",x,y,out);
 end else if(out!==ga1)begin $display("FAIL passthrough f=%d x=%d y=%d out=%h exp=%h",f,x,y,out,ga1);$fatal;end
 checks=checks+1;tick(1);
 end end
 end
 if(titlewhite==0)$fatal(1,"empty title");
 $display("PASS MANUAL FREEZE real music integration: actual local music 1024 samples@520/521 cycles, 128 min/max gold_bins, two frames=%0d cycles graph=%0d titlewhite=%0d; all512 graph columns hold PCM gold despite dense new extreme samples; brightness/OSD/RUN/scroll/blanking unaffected outside panel",checks,graphchecks,titlewhite);$finish;
 end
 initial begin #100000000;$fatal(1,"timeout");end
endmodule

