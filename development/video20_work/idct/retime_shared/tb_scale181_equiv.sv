`timescale 1ns/1ps
module tb_scale181;
reg signed [31:0] x;
wire signed [31:0] old_w = ($signed(x) <<< 7) + ($signed(x) <<< 5) + ($signed(x) <<< 4) + ($signed(x) <<< 2) + ($signed(x) <<< 0);
wire signed [31:0] new_w = $signed(x) * 32'sd181;
integer seed=32'h1811DC70; integer k=0, errors=0;
reg signed [31:0] directed[0:11];
initial begin
 directed[0]=32'h80000000; directed[1]=32'hffffffff; directed[2]=32'h00000000; directed[3]=32'h00000001;
 directed[4]=32'h7fffffff; directed[5]=32'h80000001; directed[6]=32'h7ffffffe; directed[7]=32'h00000100;
 directed[8]=32'hffffff00; directed[9]=32'h40000000; directed[10]=32'hc0000000; directed[11]=32'h01010101;
 for(k=0;k<12;k=k+1) begin x=directed[k]; #1; if(old_w!==new_w || old_w/256!==new_w/256) begin $display("DIRECT_FAIL k=%0d x=%h old=%h new=%h",k,x,old_w,new_w);errors=errors+1;end end
 for(k=0;k<100000;k=k+1) begin x=$random(seed); #1; if(old_w!==new_w || old_w/256!==new_w/256) begin if(errors<10)$display("RANDOM_FAIL k=%0d x=%h old=%h new=%h",k,x,old_w,new_w);errors=errors+1;end end
 $display("SCALE181_RESULT directed=12 random=100000 errors=%0d",errors);
 if(errors)$fatal(1,"scale181 mismatch"); $finish;
end
endmodule
