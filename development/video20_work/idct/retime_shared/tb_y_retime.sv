`timescale 1ns/1ps
module tb_y_retime;
reg clk=0; always #10 clk=~clk;
reg rst=1,img_start=0,in_valid=0;
reg [31:0] d0=0,d1=0,d2=0,d3=0; reg [2:0] idx=0;
wire rv,dv,bv,cv; wire [31:0] rd,dd,bd,cd; wire [5:0] ri,di,bi,ci;
integer seed=32'h51D7C0DE, cyc=0, sent=0, rc=0,dc=0,bc=0,cc=0, errors=0;
integer total_r=0,total_d=0,total_b=0,total_c=0;
reg [31:0] rdata[0:8191],ddata[0:8191],bdata[0:8191],cdata[0:8191];
reg [5:0] ridx[0:8191],didx[0:8191],bidx[0:8191],cidx[0:8191];
integer rcyc[0:8191],dcyc[0:8191],bcyc[0:8191],ccyc[0:8191];
reg [20:0] a,b,c,d; integer k,seg;

jpeg_idct_y_reference #(.OUT_SHIFT(11)) u_ref(clk,rst|img_start,img_start,1'b0,in_valid,d0,d1,d2,d3,idx,rv,rd,ri);
jpeg_idct_y_retimed #(.OUT_SHIFT(11)) u_retime(clk,rst|img_start,img_start,1'b0,in_valid,d0,d1,d2,d3,idx,dv,dd,di);
jpeg_idct_y_dsp #(.OUT_SHIFT(11)) u_dsp(clk,rst|img_start,img_start,1'b0,in_valid,d0,d1,d2,d3,idx,bv,bd,bi);
jpeg_idct_y_retimed_dsp #(.OUT_SHIFT(11)) u_retime_dsp(clk,rst|img_start,img_start,1'b0,in_valid,d0,d1,d2,d3,idx,cv,cd,ci);

always @(posedge clk) begin
  cyc=cyc+1;
  if(rst || img_start) begin
    total_r=total_r+rc;total_d=total_d+dc;total_b=total_b+bc;total_c=total_c+cc;
    rc=0;dc=0;bc=0;cc=0;
  end else begin
    if(dv) begin ddata[dc]=dd; didx[dc]=di; dcyc[dc]=cyc; dc=dc+1; end
    if(bv) begin bdata[bc]=bd; bidx[bc]=bi; bcyc[bc]=cyc; bc=bc+1; end
    if(cv) begin cdata[cc]=cd; cidx[cc]=ci; ccyc[cc]=cyc; cc=cc+1; end
    if(rv) begin
      rdata[rc]=rd; ridx[rc]=ri; rcyc[rc]=cyc;
      if(dc<=rc || ddata[rc]!==rd || didx[rc]!==ri || rcyc[rc]-dcyc[rc]!=1) begin
        $display("RETIME_DIFF beat=%0d ref=%h/%0d@%0d got=%h/%0d@%0d",rc,rd,ri,cyc,ddata[rc],didx[rc],dcyc[rc]); errors=errors+1;
      end
      if(cc<=rc || cdata[rc]!==rd || cidx[rc]!==ri || rcyc[rc]-ccyc[rc]!=1) begin
        $display("COMBO_DIFF beat=%0d ref=%h/%0d@%0d got=%h/%0d@%0d",rc,rd,ri,cyc,cdata[rc],cidx[rc],ccyc[rc]); errors=errors+1;
      end
      if(bc<=rc || bdata[rc]!==rd || bidx[rc]!==ri || bcyc[rc]!=cyc) begin
        $display("DSP_DIFF beat=%0d ref=%h/%0d@%0d got=%h/%0d@%0d",rc,rd,ri,cyc,bdata[rc],bidx[rc],bcyc[rc]); errors=errors+1;
      end
      rc=rc+1;
    end
  end
end

initial begin
  repeat(5) @(negedge clk); rst=0;
  for(seg=0;seg<3;seg=seg+1) begin
    while(sent < (seg+1)*256) begin
      @(negedge clk);
      if(($random(seed)&7)!=0) begin
        in_valid=1; idx=sent%8;
        a=$random(seed);b=$random(seed);c=$random(seed);d=$random(seed);
        case(sent%32)
          0: begin a=21'h100000;b=21'h0fffff;c=0;d=21'h1fffff; end
          1: begin a=21'h0fffff;b=21'h100000;c=21'h1fffff;d=0; end
          2: begin a=0;b=21'h1fffff;c=21'h100000;d=21'h0fffff; end
          3: begin a=21'h1fffff;b=0;c=21'h0fffff;d=21'h100000; end
          4: begin a=21'h1fffff;b=21'h1fffff;c=21'h1fffff;d=21'h1fffff; end
          5: begin a=21'h100000;b=21'h100000;c=21'h100000;d=21'h100000; end
        endcase
        d0={{11{a[20]}},a}; d1={{11{b[20]}},b}; d2={{11{c[20]}},c}; d3={{11{d[20]}},d};
        sent=sent+1;
      end else in_valid=0;
    end
    @(negedge clk); in_valid=0;
    repeat(2200) @(negedge clk);
    if(seg<2) begin
      rst=1;img_start=1; repeat(3) @(negedge clk); rst=0;img_start=0;
      repeat(2) @(negedge clk);
    end
  end
  repeat(80) @(negedge clk);
  total_r=total_r+rc;total_d=total_d+dc;total_b=total_b+bc;total_c=total_c+cc;
  if(total_r!=total_d || total_r!=total_b || total_r!=total_c) begin
    $display("COUNT ref=%0d retime=%0d dsp=%0d combo=%0d",total_r,total_d,total_b,total_c); errors=errors+1;
  end
  $display("Y_RETIME_RESULT sent=%0d ref=%0d retime=%0d dsp=%0d combo=%0d errors=%0d",sent,total_r,total_d,total_b,total_c,errors);
  if(errors) $fatal(1,"Y retime mismatch");
  $finish;
end
endmodule
