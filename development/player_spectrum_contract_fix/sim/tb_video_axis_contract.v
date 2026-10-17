`timescale 1ns/1ps
module tb_video_axis_contract;
  reg clk=0,rst=1,vs=0,de=0;
  reg [23:0] rgb=0;
  wire valid,user,last; wire [23:0] data;
  integer frame_no,y,x,valids=0,sofs=0,eols=0,errors=0;
  integer observed_x=0,observed_y=0;
  video_rgb_to_axis_640x480 dut(.I_clk(clk),.I_rst(rst),.I_vs(vs),
    .I_de(de),.I_rgb(rgb),.O_video_user(user),.O_video_valid(valid),
    .O_video_last(last),.O_video_data(data));
  always #20 clk=~clk;
  always @(posedge clk) begin
    #1;
    if(!rst) begin
      if((user || last) && !valid) begin
        $display("FAIL marker outside VALID"); errors=errors+1;
      end
      if(valid) begin
        valids=valids+1;
        if(user) sofs=sofs+1;
        if(last) eols=eols+1;
        if(user !== (observed_x==0 && observed_y==0)) begin
          if(errors<5) $display("FAIL SOF x=%0d y=%0d user=%b",observed_x,observed_y,user);
          errors=errors+1;
        end
        if(last !== (observed_x==639)) begin
          if(errors<5) $display("FAIL EOL x=%0d y=%0d last=%b",observed_x,observed_y,last);
          errors=errors+1;
        end
        if(data !== {observed_y[7:0],observed_x[7:0],8'h5a}) begin
          if(errors<5) $display("FAIL pixel data x=%0d y=%0d data=%h",observed_x,observed_y,data);
          errors=errors+1;
        end
        if(observed_x==639) begin
          observed_x=0;
          if(observed_y==479) observed_y=0; else observed_y=observed_y+1;
        end else observed_x=observed_x+1;
      end
    end
  end
  initial begin
    repeat(8) @(negedge clk); rst=0;
    for(frame_no=0;frame_no<2;frame_no=frame_no+1) begin
      vs=1; repeat(800*2) @(negedge clk);
      vs=0; repeat(800*33) @(negedge clk);
      for(y=0;y<480;y=y+1) begin
        for(x=0;x<640;x=x+1) begin
          de=1; rgb={y[7:0],x[7:0],8'h5a}; @(negedge clk);
        end
        de=0; repeat(160) @(negedge clk);
      end
      repeat(800*10) @(negedge clk);
    end
    repeat(4) @(negedge clk);
    $display("RESULT frames=2 valids=%0d sofs=%0d eols=%0d errors=%0d",valids,sofs,eols,errors);
    if(valids!=614400 || sofs!=2 || eols!=960 || errors!=0) $fatal(1,"AXIS video contract violated");
    $display("PASS video_axis_contract"); $finish;
  end
endmodule
