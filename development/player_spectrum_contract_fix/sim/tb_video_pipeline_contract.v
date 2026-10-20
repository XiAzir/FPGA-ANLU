`timescale 1ns/1ps
module tb_video_pipeline_contract;
  reg clk=0,rst=1;
  wire hs,vs,de,req,re,hs_d,vs_d,de_d,user,valid,last;
  wire [23:0] rgb,data;
  integer cycle=0,pl=-1,pf=-1,x=0,y=0,pixels=0,lines=0,frames=0,errors=0;
  video_timing_data timing(.video_clk(clk),.rst(rst),.read_req(req),.read_req_ack(1'b1),.hs(hs),.vs(vs),.de(de));
  video_delay delay(.video_clk(clk),.rst(rst),.read_en(re),.read_data(24'h123456),.hs(hs),.vs(vs),.de(de),.hs_r(hs_d),.vs_r(vs_d),.de_r(de_d),.vout_data(rgb));
  video_rgb_to_axis_640x480 axis(.I_clk(clk),.I_rst(rst),.I_vs(vs_d),.I_de(de_d),.I_rgb(rgb),.O_video_user(user),.O_video_valid(valid),.O_video_last(last),.O_video_data(data));
  always #20 clk=~clk;
  always @(posedge clk) begin
    #1;
    if(!rst) begin
      cycle=cycle+1;
      if(valid) begin
        pixels=pixels+1;
        if(user) begin
          if(pf>=0 && cycle-pf!=420000) begin $display("FAIL frame period %0d",cycle-pf);errors=errors+1;end
          if(x!=0 || y!=0) begin $display("FAIL SOF position");errors=errors+1;end
          pf=cycle;frames=frames+1;
        end
        if(x==0) begin
          if(y!=0 && pl>=0 && cycle-pl!=800) begin $display("FAIL line period %0d",cycle-pl);errors=errors+1;end
          pl=cycle;
        end
        if(last !== (x==639)) begin if(errors<5)$display("FAIL EOL x%0d y%0d",x,y);errors=errors+1;end
        if(x==639) begin x=0;lines=lines+1;if(y==479)y=0;else y=y+1;end else x=x+1;
        if(lines==1440) begin
          $display("RESULT pixels=%0d lines=%0d frames=%0d errors=%0d",pixels,lines,frames,errors);
          if(errors || pixels!=921600 || frames!=3)$fatal(1,"Video pipeline contract failed");
          $display("PASS video_pipeline_contract");$finish;
        end
      end else if(x!=0) $fatal(1,"Discontinuous active line");
    end
  end
  initial begin repeat(8)@(negedge clk);rst=0;repeat(1680000)@(negedge clk);$fatal(1,"Timeout");end
endmodule
