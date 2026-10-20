`timescale 1ns/1ps
module tb_envelope_integration;
reg clk=0;always #20 clk=~clk;
reg rst=1,vs=0,de=0,tone=0;
reg [23:0] rgb=0,golden_rgb=0,ap=0;
reg av=0;reg [3:0] b=4;reg [2:0] c=2;reg [1:0] mode=0;
reg [15:0] pcm[0:1023];
integer sample_index=0,acc=0;
always @(negedge clk) begin
 if(rst)begin av=0;acc=0;sample_index=0;end
 else begin
  acc=acc+48000;
  if(acc>=25000000)begin
   acc=acc-25000000;av=1;ap={pcm[sample_index%1024],8'h00};sample_index=sample_index+1;
  end else av=0;
 end
end
wire [23:0] ar,o1,d1,a1,out,go1,gd1,ga1;
player_rgb_adjust adjust(rgb,b,c,ar);
wire [23:0] rgb_active=de?ar:rgb;
player_osd osd(clk,rst,vs,de,rgb_active,2'd0,3'd4,1'b0,1'b1,o1);
player_dynamic_text dynamic_text(clk,rst,vs,de,1'b0,o1,d1);
player_adjust_osd aosd(clk,rst,vs,de,d1,mode,b,c,a1);
player_pcm_waveform wave_display(clk,rst,vs,de,a1,av,ap,tone,1'b0,out);
player_osd gosd(clk,rst,vs,de,golden_rgb,2'd0,3'd4,1'b0,1'b1,go1);
player_dynamic_text gdynamic(clk,rst,vs,de,1'b0,go1,gd1);
player_adjust_osd gaosd(clk,rst,vs,de,gd1,mode,b,c,ga1);
integer hist[0:127],backgold[0:511],frontgold[0:511];
integer count=0,sum=0,env=0,tgt=0,delta=0,step=0,height=0;
integer vprev=0,front_valid=0,have_back=0,checks=0,graphchecks=0,titlewhite=0;
integer x,y,f,i,j,val,col,distance_px,alpha,red,green,blue;
reg [23:0] expected;
function integer golden_channel;
 input integer p,bi,ci;integer v,n;
 begin
 case(ci)0:n=2;1:n=3;2:n=4;3:n=5;4:n=6;default:n=4;endcase
 v=(p-128)*n;if(v<0)v=-((-v+3)/4);else v=v/4;
 v=v+128+(bi-4)*16;golden_channel=v<0?0:v>255?255:v;
 end
endfunction
function integer cubic;
 input integer column;integer s,k,p0,p1,p2,p3,n,q,lo,hi;
 begin
 s=column/4;k=column%4;
 p0=hist[s==0?0:s-1];p1=hist[s];p2=hist[s==127?127:s+1];p3=hist[s>=126?127:s+2];
 case(k)
 0:n=128*p1;1:n=-9*p0+111*p1+29*p2-3*p3;
 2:n=-8*p0+72*p1+72*p2-8*p3;default:n=-3*p0+29*p1+111*p2-9*p3;
 endcase
 q=n/128;if(n<0 && n%128!=0)q=q-1;
 lo=p1<p2?p1:p2;hi=p1>p2?p1:p2;
 cubic=q<lo?lo:q>hi?hi:q;
 end
endfunction
// Integer reference observes only PCM input/VALID and VS. No DUT state is
// used to construct the expected waveform, table, bank validity or colors.
always @(posedge clk)begin
 if(rst)begin
  count=0;sum=0;env=0;vprev=0;front_valid=0;have_back=0;
  for(j=0;j<128;j=j+1)hist[j]=0;
  for(j=0;j<512;j=j+1)begin backgold[j]=0;frontgold[j]=0;end
 end else begin
  if(vs && !vprev)begin
   front_valid=have_back;
   for(j=0;j<512;j=j+1)frontgold[j]=backgold[j];
   for(j=0;j<127;j=j+1)hist[j]=hist[j+1];
   height=env<=65536?env/128:512+(env-65536)/512;
   if(height>832)height=832;
   hist[127]=height;
   for(j=0;j<512;j=j+1)backgold[j]=cubic(j);
   have_back=1;
  end
  vprev=vs;
  if(av)begin
   val=$signed(ap[23:8]);if(val<0)val=-val;
   sum=sum+val;count=count+1;
   if(count==256)begin
    tgt=(sum/256)*16;delta=tgt-env;
    if(delta>0)env=env+(delta+15)/16;
    else if(delta<0)env=env-((-delta+63)/64);
    count=0;sum=0;
   end
  end
 end
end
task tick;input integer n;integer k;begin for(k=0;k<n;k=k+1)@(negedge clk);end endtask
initial begin
 $readmemh("music_pcm.hex",pcm);tick(4);rst=0;tick(4);
 for(f=0;f<3;f=f+1)begin
  b=f==1?7:4;c=f==1?4:2;mode=f==1?1:0;
  vs=1;tick(4);vs=0;tick(4);
  for(y=0;y<525;y=y+1)begin
   for(x=0;x<800;x=x+1)begin
    de=x<640 && y<480;
    rgb={8'((x+y)%256),8'((x*3+y)%256),8'((x+y*5)%256)};
    golden_rgb=de?{8'(golden_channel(rgb[23:16],b,c)),8'(golden_channel(rgb[15:8],b,c)),8'(golden_channel(rgb[7:0],b,c))}:rgb;
    #1;
    if(de && x>=16 && x<624 && y>=320 && y<424)begin
     if(x==16 || x==623 || y==320 || y==423)begin
      if(out!==24'h000000)$fatal(1,"panel edge mismatch f%0d x%0d y%0d",f,x,y);
     end else if(x>=24 && x<232 && y>=328 && y<344)begin
      if(out!==0 && out!==24'hffffff)$fatal(1,"title palette mismatch");
      if(out==24'hffffff)titlewhite=titlewhite+1;
     end else if(x>=64 && x<576 && y>=356 && y<=412)begin
      expected=y==408?24'h17212c:24'h070b12;
      if(front_valid)begin
       distance_px=(408-y)*16-frontgold[x-64];if(distance_px<0)distance_px=-distance_px;
       if(distance_px<16)begin
        alpha=16-distance_px;red=7+alpha*65/16;green=11+alpha*209/16;blue=18+alpha*192/16;
        expected=(red<<16)|(green<<8)|blue;
       end else if(distance_px<32)begin
        alpha=32-distance_px;red=7+alpha*4/16;green=11+alpha*13/16;blue=18+alpha*12/16;
        expected=(red<<16)|(green<<8)|blue;
       end
      end
      if(out!==expected)$fatal(1,"graph mismatch f%0d x%0d y%0d out%h exp%h Q4%0d",f,x,y,out,expected,frontgold[x-64]);
      graphchecks=graphchecks+1;
     end else if(out!==24'h070b12)$fatal(1,"panel background mismatch");
    end else if(out!==ga1)$fatal(1,"passthrough mismatch f%0d x%0d y%0d out%h exp%h",f,x,y,out,ga1);
    checks=checks+1;tick(1);
   end
  end
 end
 if(titlewhite==0)$fatal(1,"empty title");
 $display("INTEGRATION PASS raster_clocks=%0d graph_pixels=%0d title_white=%0d music_pcm_events=%0d frames=3",checks,graphchecks,titlewhite,sample_index);$finish;
end
initial begin #100000000;$fatal(1,"integration timeout");end
endmodule
