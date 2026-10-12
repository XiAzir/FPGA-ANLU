`timescale 1ns/1ps
module tb_wipe_address;
 reg clk=0;always #10 clk=~clk;
 reg rst=1,ack=0,active=0;reg[8:0] rows=0;
 reg[1:0] oldbuf=0,newbuf=1;reg[20:0] linear=0;wire[20:0] mapped;
 integer i,s,k,r,oldbase,newbase,gold,checks=0;
 player_wipe_address dut(clk,rst,ack,active,rows,oldbuf,newbuf,linear,mapped);
 task tick;input integer n;integer j;begin for(j=0;j<n;j=j+1)@(negedge clk);end endtask
 task capture;begin tick(5);ack=1;tick(2);ack=0;tick(2);end endtask
 task check;input integer expected;begin #1;if(mapped!==expected[20:0])$fatal(1,"map linear=%0d got=%0d expected=%0d",linear,mapped,expected);checks=checks+1;end endtask
 initial begin
 tick(3);rst=0;tick(4);
 // All 61 production progress boundaries, both swap directions. Probe
 // beginning/end/seam and seam-adjacent words with an independent formula.
 for(s=0;s<2;s=s+1)begin
 oldbuf=s;newbuf=1-s;oldbase=s*230400;newbase=(1-s)*230400;active=1;
 for(r=0;r<=480;r=r+8)begin
 rows=r;capture;
 for(k=0;k<6;k=k+1)begin
 case(k)0:i=0;1:i=230399;2:i=r*480-1;3:i=r*480;4:i=r*480+1;5:i=115200;endcase
 if(i>=0&&i<230400)begin linear=oldbase+i;tick(1);gold=(i<r*480?newbase:oldbase)+i;check(gold);end
 end
 end
 end
 // Four entire command streams including gaps and live metadata changes.
 // A changed source bundle cannot mutate a frame until memory ACK.
 for(s=0;s<2;s=s+1)begin
 for(k=0;k<2;k=k+1)begin
 oldbuf=s;newbuf=1-s;oldbase=s*230400;newbase=(1-s)*230400;
 r=k==0?8:472;active=1;rows=r;capture;
 for(i=0;i<230400;i=i+1)begin
 linear=oldbase+i;
 if(i==4000)begin active=0;rows=240;oldbuf=1-s;newbuf=s;end
 tick(1);gold=(i<r*480?newbase:oldbase)+i;check(gold);
 if(i%256==255)tick(3);
 end
 end end
 // Disabled route is exact passthrough including a selected new full frame.
 active=0;oldbuf=1;newbuf=0;rows=480;capture;
 for(i=0;i<32;i=i+1)begin linear=230400+i;tick(1);check(230400+i);end
 // While ACK stays asserted, changing held metadata must not re-latch.
 active=1;oldbuf=0;newbuf=1;rows=8;tick(5);ack=1;tick(2);
 rows=480;active=0;tick(5);linear=4000;tick(1);check(4000);
 linear=0;tick(1);check(230400);ack=0;tick(3);
 $display("WIPE_ADDRESS PASS checks=%0d full_frames=4 progress_boundaries=61 directions=2",checks);$finish;
 end
 initial begin #50000000;$fatal(1,"timeout");end
endmodule
