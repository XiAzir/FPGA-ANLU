`timescale 1ns/1ps
module tb_pll_startup;
reg refclk=0;
wire slock,vlock,s0,s1,s2,pclk,serclk;
sys_pll spll(.refclk(refclk),.reset(1'b0),.extlock(slock),.clk0_out(s0),.clk1_out(s1),.clk2_out(s2));
video_pll vpll(.refclk(refclk),.reset(1'b0),.extlock(vlock),.clk0_out(pclk),.clk1_out(serclk));
always #10 refclk=~refclk;
integer pc=0,sc=0;
always @(posedge pclk) pc=pc+1;
always @(posedge serclk) sc=sc+1;
always @(slock or vlock) $display("PLL_LOCK t=%0t sys=%b video=%b",$time,slock,vlock);
initial begin
 #100000;$display("PLL_100US sys=%b video=%b pc=%0d sc=%0d",slock,vlock,pc,sc);
 #1900000;$display("PLL_2MS sys=%b video=%b pc=%0d sc=%0d",slock,vlock,pc,sc);
 #23000000;$display("PLL_25MS sys=%b video=%b pc=%0d sc=%0d",slock,vlock,pc,sc);
 if(slock!==1 || vlock!==1)$display("FAIL original PLL model lock");else $display("PASS original PLL model lock");
 $finish;
end
endmodule
